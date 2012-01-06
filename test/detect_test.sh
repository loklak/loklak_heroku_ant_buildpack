#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testDetect()
{
  touch ${BUILD_DIR}/pom.xml
  
  capture ${BUILDPACK_HOME}/bin/detect ${BUILD_DIR}
  
  assertEquals 0 ${rtrn}
  assertEquals "Java" "$(cat ${STD_OUT})"
  assertNull "$(cat ${STD_ERR})"
}

testNoDetectMissingPomFile()
{
  touch ${BUILD_DIR}/build.xml

  capture ${BUILDPACK_HOME}/bin/detect ${BUILD_DIR}
 
  assertEquals 1 ${rtrn}
  assertEquals "no" "$(cat ${STD_OUT})"
  assertNull "$(cat ${STD_ERR})"
}
