#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testDetect()
{
  touch ${BUILD_DIR}/build.xml

  detect

  assertAppDetected "Java (using Apache Ant 1.8.3)"
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
