#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

. ${BUILDPACK_HOME}/bin/common

testDetect()
{
  touch ${BUILD_DIR}/build.xml

  detect

  assertAppDetected "Java (using Apache Ant $ANT_VER)"
}

testNoDetectMissingBuildFile()
{
  detect

  assertNoAppDetected
}

testNoDetectBuildFileAsDir()
{
  mkdir -p ${BUILD_DIR}/build.xml

  detect

  assertNoAppDetected
}
