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
</project>
EOF
}

testCompile()
{
  createPom

  # Create an old settings to make sure it gets replaced with correct one
  mkdir -p ${CACHE_DIR}/.m2
  echo "OLD SETTINGS" > ${CACHE_DIR}/.m2/settings.xml

  capture ${BUILDPACK_HOME}/bin/compile ${BUILD_DIR} ${CACHE_DIR}
  assertEquals 0 "${rtrn}"
  assertEquals "" "`cat ${STD_ERR}`"

  assertContains "Installing Maven 3.0.3" "`cat ${STD_OUT}`"
  assertTrue "mvn should be executable" "[ -x ${CACHE_DIR}/.maven/bin/mvn ]"
  
  assertContains "Installing settings.xml" "`cat ${STD_OUT}`"
  assertTrue "settings.xml should exist and have content" "[ -s ${CACHE_DIR}/.m2/settings.xml ]"
  assertNotContains "OLD SETTINGS" "`cat ${CACHE_DIR}/.m2/settings.xml`" # old settings was deleted

  assertContains "executing $CACHE_DIR/.maven/bin/mvn -B -Duser.home=$BUILD_DIR -Dmaven.repo.local=$CACHE_DIR/.m2/repository -s $CACHE_DIR/.m2/settings.xml -DskipTests=true clean install" "`cat ${STD_OUT}`"  
  assertContains "BUILD SUCCESS" "`cat ${STD_OUT}`"
}

testCompileFailed()
{
  # Don't create POM to fail build
  
  capture ${BUILDPACK_HOME}/bin/compile ${BUILD_DIR} ${CACHE_DIR}
  assertEquals 1 "${rtrn}"
  assertContains "Failed to build app with Maven" "`cat ${STD_OUT}`" # Should this be going to STD_ERR??
  assertEquals "" "`cat ${STD_ERR}`"
}

_testCompileKeepM2Cache()
{
  fail
  # logs contain retain_m2_repo
}

_testCompileRemoveM2CacheExplictly()
{
  fail
  # removeM2Cache file is created
  # cache is otherwise empty
}

_testCompileRemoveM2CacheImplictly()
{
  fail
}

_testExistingSettingsXmlFile()
{
  fail
}
