#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

. ${BUILDPACK_HOME}/bin/common

testRelease()
{
  expected_release_output=`cat <<EOF
---
config_vars:
  ANT_HOME: $ANT_HOME
  PATH: /usr/local/bin:/usr/bin:/bin
  JAVA_OPTS: -Xmx384m -Xss512k -XX:+UseCompressedOops
  ANT_OPTS: -Xmx384m -Xss512k -XX:+UseCompressedOops 
addons:
  shared-database:5mb
default_process_types:
  web: ant run

EOF`

  release

  assertCapturedSuccess
  assertCaptured "${expected_release_output}"
}
