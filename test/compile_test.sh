#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testCompile()
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

  capture ${BUILDPACK_HOME}/bin/compile ${BUILD_DIR} ${CACHE_DIR}
  assertEquals 0 "${rtrn}"
  assertContains "Installing Maven 3.0.3" "`cat ${STD_OUT}`"
  assertContains "BUILD SUCCESS" "`cat ${STD_OUT}`"
  assertEquals "" "`cat ${STD_ERR}`"

  assertTrue "settings.xml should be downloaded" "[ -f ${CACHE_DIR}/.m2/settings.xml ]"

  # cache dir is created
  # maven is downloaded
  # ./maven/bin/mvn is executable
  # settings.xml is downloaded
  # mvn opts
  # build cmd
}

_testCompileFailed()
{
 fail
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
