#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testDetect()
{
  touch ${BUILD_DIR}/pom.xml

  detect

  assertAppDetected "Java"
}

testNoDetectMissingPomFile()
{
  detect

  assertNoAppDetected
}

testNoDetectPomFileAsDir()
{
  mkdir -p ${BUILD_DIR}/pom.xml

  detect

  assertNoAppDetected
}
