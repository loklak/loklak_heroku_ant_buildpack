Heroku buildpack: Java (with Apache Ant)
=========================

This is a [Heroku buildpack](http://devcenter.heroku.com/articles/buildpack) for Java apps.
It uses Apache Ant 1.9.2 to build your application and OpenJDK 1.6.0_20 to run it.

Usage
-----

Example usage:

    $ ls
    Procfile	build.xml	libs		src

    $ heroku create --stack cedar --buildpack http://github.com/dennisg/heroku-buildpack-ant.git
    
    $ git push heroku master
    ...
	-----> Heroku receiving push
	-----> Fetching custom buildpack... done
	-----> Java (using Apache Ant 1.9.2) app detected
	-----> Installing Apache Ant 1.9.2.....done!
	-----> executing /tmp/build_1i100c5e7xm9u/.buildpack/apache-ant-1.8.4/bin/ant -Duser.home=/tmp/build_1i100c5e7xm9u clean install
       Buildfile: /tmp/build_1i100c5e7xm9u/build.xml
       
       clean:
            [echo] cleaning...
       
       init:
           [mkdir] Created dir: /tmp/build_1i100c5e7xm9u/target/classes
       
       compile:
           [javac] Compiling 1 source file to /tmp/build_1i100c5e7xm9u/target/classes
       
       jar:
             [jar] Building jar: /tmp/build_1i100c5e7xm9u/target/application.jar
       
       install:
            [echo] installing...
       
       BUILD SUCCESSFUL
       Total time: 0 seconds
	-----> Discovering process types
    Procfile declares types -> web
	-----> Compiled slug size is 5.6MB
	-----> Launching... done, v5
    http://<your-app-name>.herokuapp.com deployed to Heroku

The buildpack will detect your app as Java (using Apache Ant) if it has the file 'build.xml' in the root. It will use Apache Ant to execute the targets 'clean install' defined by your build.xml.

The Ant executable is unpacked inside your slug directory in '.buildpack' and is therefore also available for running the actual Java application too (I added its bin folder to the PATH).

Example Procfile:

	web: ant run

Config Update
-------
If you have been using this buildpack before, the upgrade from 1.9.x to 1.9.2 now requires a heroku config update.

Please issue:

	heroku config:set ANT_HOME=.buildpack/apache-ant-1.9.2
	heroku config:set PATH=/usr/local/bin:/usr/bin:/bin:.buildpack/apache-ant-1.9.2/bin

to make it work again...

Hacking
-------

To use a modification of this buildpack, fork it on Github. Push up changes to your fork, then create a test app with `--buildpack <your-github-url>` and push to it too.
