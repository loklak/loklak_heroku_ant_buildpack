#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testRelease()
{
  expected_release_output=`cat <<EOF
---
config_vars:
  PATH: /usr/local/bin:/usr/bin:/bin
  JAVA_OPTS: -Xmx384m -Xss512k -XX:+UseCompressedOops
  MAVEN_OPTS: -Xmx384m -Xss512k -XX:+UseCompressedOops 
addons:
  shared-database:5mb


EOF`

  capture ${BUILDPACK_HOME}/bin/release ${BUILD_DIR}
  assertEquals 0 ${rtrn}
  assertEquals "${expected_release_output}" "$(cat ${STD_OUT})"
  assertEquals "" "$(cat ${STD_ERR})"
}
