Heroku buildpack: Java (with Apache Ant)
=========================

This is a [Heroku buildpack](http://devcenter.heroku.com/articles/buildpack) for Java apps.
It uses Apache Ant 1.8.3 to build your application and OpenJDK 1.6.0_20 to run it.

Usage
-----

Example usage:

    $ ls
    Application	Procfile	build.xml	libs		src

    $ heroku create --stack cedar --buildpack http://github.com/dennisg/heroku-buildpack-ant.git

    $ git push heroku master
    ...
	-----> Heroku receiving push
	-----> Fetching custom buildpack... done
	-----> Java (using Ant) app detected
	-----> Installing Apache Ant 1.8.3..... done
	-----> executing /app/tmp/repo.git/.cache/apache-ant-1.8.3/bin/ant -Duser.home=/tmp/build_20ryb3jtgpkek clean install
	       Buildfile: /tmp/build_20ryb3jtgpkek/build.xml
	       
	       clean:
	            [echo] cleaning...
	          [delete] Deleting directory /tmp/build_20ryb3jtgpkek/target
	       
	       init:
	           [mkdir] Created dir: /tmp/build_20ryb3jtgpkek/target/classes
	       
	       compile:
	           [javac] Compiling 1 source file to /tmp/build_20ryb3jtgpkek/target/classes
	       
	       jar:
	             [jar] Building jar: /tmp/build_20ryb3jtgpkek/target/application.jar
	       
	       install:
	            [echo] installing...
	       
	       BUILD SUCCESSFUL
	       Total time: 3 seconds
	-----> Discovering process types
	       Procfile declares types -> web
	-----> Compiled slug size is 4K
	-----> Launching... done, v7
	       http://<your-app-name>.herokuapp.com deployed to Heroku

The buildpack will detect your app as Java if it has the file `build.xml` in the root.  It will use Apache Ant to execute the targets 'clean install' defined by your build.xml.
It's from there up to you how you want to start your application. The Procfile should one way or the other execute some piece of code that starts your Java application.

Example Procile:

	web: sh Application
	
where on Heroku (on the cedar stack) the Java executable can be found at:
       
	JAVACMD="$JAVA_HOME/bin/java"


This means that your version of 'Application' should be in the lines of:

	#!/bin/sh
	# If a specific java binary isn't specified search for the standard 'java' binary
	if [ -z "$JAVACMD" ] ; then
	  if [ -n "$JAVA_HOME"  ] ; then
	    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
	      # IBM's JDK on AIX uses strange locations for the executables
	      JAVACMD="$JAVA_HOME/jre/sh/java"
	    else
	      JAVACMD="$JAVA_HOME/bin/java"
	    fi
	  else
	    JAVACMD=`which java`
	  fi
	fi
	
	if [ ! -x "$JAVACMD" ] ; then
	  echo "Error: JAVA_HOME is not defined correctly."
	  echo "  We cannot execute $JAVACMD"
	  exit 1
	fi
	
	exec "$JAVACMD" $JAVA_OPTS \
  		$EXTRA_JVM_ARGUMENTS \
  		-Dapp.name="Heroku Application" \
  		-Dapp.pid="$$" \
  		-Dbasedir="$BASEDIR" \
  		-jar $BASEDIR/target/application.jar \
  		"$@"
	

Hacking
-------

To use a modification of this buildpack, fork it on Github.  Push up changes to your fork, then create a test app with `--buildpack <your-github-url>` and push to it.
