#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

createBuildFile()
{
  cat > ${BUILD_DIR}/build.xml <<EOF
<project name="ant-test">
    <target name="clean">
      <echo>cleaning...</echo>
    	<delete dir="target"/>
    </target>
    <target name="init">
      	<mkdir dir="target/classes"/>
    </target>
    <target name="install">
      <echo>installing...</echo>
    </target>
</project>
EOF
}

testCompile()
{
  createBuildFile "$(withDependency)"

  compile
  
  assertCapturedSuccess

  assertCaptured "Installing Apache Ant 1.8.3"
  assertTrue "ant should be executable" "[ -x ${BUILD_DIR}/.buildpack/apache-ant-1.8.3/bin/ant ]"
  
  assertCaptured "executing ${BUILD_DIR}/.buildpack/apache-ant-1.8.3/bin/ant clean install"
  assertCaptured "BUILD SUCCESS" 
}

testCompilationFailure()
{
  # Don't create build.xml to fail build
  
  compile

  assertCapturedError "Failed to build app with Apache Ant"
}