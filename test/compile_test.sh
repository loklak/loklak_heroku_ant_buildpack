#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

createPom()
{
  cat > ${BUILD_DIR}/pom.xml <<EOF
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.mycompany.app</groupId>
  <artifactId>my-app</artifactId>
  <version>1.0-SNAPSHOT</version>
  <properties> 
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding> 
  </properties>
  <dependencies>
$1
  </dependencies>
</project>
EOF
}

withDependency()
{
  cat <<EOF
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.0</version>
      <type>jar</type>
      <scope>test</scope>
    </dependency>
EOF
}


testCompile()
{
  createPom "$(withDependency)" # including dependency to force use of s3pository.heroku.com

  compile
  
  assertCapturedSuccess

  assertCaptured "Installing Maven 3.0.3"
  assertFileMD5 "605f8b746e16576064258afaf630a2cc"  ${CACHE_DIR}/.maven/bin/mvn
  assertTrue "mvn should be executable" "[ -x ${CACHE_DIR}/.maven/bin/mvn ]"
  
  assertCaptured "Installing settings.xml" 
  assertFileMD5 "a5fa7b9982fc64939c0e215f935a850a" ${CACHE_DIR}/.m2/settings.xml
  
  assertCaptured "executing $CACHE_DIR/.maven/bin/mvn -B -Duser.home=$BUILD_DIR -Dmaven.repo.local=$CACHE_DIR/.m2/repository -s $CACHE_DIR/.m2/settings.xml -DskipTests=true clean install"
  assertCaptured "s3pository.heroku.com" 
  assertCaptured "BUILD SUCCESS" 
}

testCompilationFailure()
{
  # Don't create POM to fail build
  
  compile

  assertCapturedError "Failed to build app with Maven"
}

testDownloadCaching()
{
  createPom

  # simulate a primed cache
  mkdir -p ${CACHE_DIR}/.maven
  mkdir -p ${CACHE_DIR}/.m2
  echo "OLD SETTINGS" > ${CACHE_DIR}/.m2/settings.xml

  compile

  assertNotCaptured "Maven should not be installed again when already cached" "Installing Maven"
  assertCaptured "settings.xml should always be installed" "Installing settings.xml" 
  assertFileNotContains "existing settings.xml file should have been replaced" "OLD SETTINGS" "${CACHE_DIR}/.m2/settings.xml"
}

testNewAppsRemoveM2Cache()
{
  createPom
  rm -r ${CACHE_DIR} # simulate a brand new app without a cache dir
  
  assertFalse "Precondition: New apps should not have a CACHE_DIR prior to running" "[ -d ${CACHE_DIR} ]" 
  assertFalse "Precondition: New apps should not have a removeM2Cache file prior to running" "[ -f ${CACHE_DIR}/removeM2Cache ]" 

  compile

  assertCapturedSuccess
  assertTrue "removeM2Cache file should now exist in cache" "[ -f ${CACHE_DIR}/removeM2Cache ]"  
  assertFalse ".m2 should not be copied to build dir" "[ -d ${BUILD_DIR}/.m2 ]"
  assertFalse ".maven should not be copied to build dir" "[ -d ${BUILD_DIR}/.maven ]"
}

testNonLegacyExistingAppsRemoveCache()
{
  createPom
  touch ${CACHE_DIR}/removeM2Cache # simulate a previous run with no cache dir
  
  assertTrue "Precondition: Existing apps should have a CACHE_DIR from previous run" "[ -d ${CACHE_DIR} ]" 
  assertTrue "Precondition: Existing apps should have a removeM2Cache file from previous run" "[ -f ${CACHE_DIR}/removeM2Cache ]" 

  compile
  
  assertCapturedSuccess
  assertTrue "removeM2Cache file should still exist in cache" "[ -f ${CACHE_DIR}/removeM2Cache ]"  
  assertFalse ".m2 should not be copied to build dir" "[ -d ${BUILD_DIR}/.m2 ]"
  assertFalse ".maven should not be copied to build dir" "[ -d ${BUILD_DIR}/.maven ]"
}

testLegacyAppsKeepM2Cache()
{
  createPom

  assertTrue  "Precondition: Legacy apps should have a CACHE_DIR from a previous run" "[ -d ${CACHE_DIR} ]" 
  assertFalse "Precondition: Legacy apps should not have a removeM2Cache file" "[ -f ${CACHE_DIR}/removeM2Cache ]"

  compile
  
  assertCapturedSuccess
  assertFalse "removeM2Cache file should not exist in cache" "[ -f ${CACHE_DIR}/removeM2Cache ]"  
  assertEquals ".m2 should be copied to build dir" "" "$(diff -r ${CACHE_DIR}/.m2 ${BUILD_DIR}/.m2)"
  assertEquals ".maven should be copied to build dir" "" "$(diff -r ${CACHE_DIR}/.maven ${BUILD_DIR}/.maven)"
}
