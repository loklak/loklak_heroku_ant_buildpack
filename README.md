Heroku buildpack: Java (with Apache Ant)
=========================

This is a [Heroku buildpack](http://devcenter.heroku.com/articles/buildpack) for Java apps.
It uses Apache Ant 1.8.3 to build your application and OpenJDK 1.6.0_20 to run it.

Usage
-----

Example usage:

    $ ls
    Procfile  pom.xml  src

    $ heroku create --stack cedar --buildpack http://github.com/dennisg/heroku-buildpack-ant.git

    $ git push heroku master
    ...
    -----> Heroku receiving push
    -----> Fetching custom language pack... done
    -----> Java app detected
    -----> Installing Maven 3.0.3..... done
    -----> Installing settings.xml..... done
    -----> executing /app/tmp/repo.git/.cache/.maven/bin/mvn -B -Duser.home=/tmp/build_19z6l4hp57wqm -Dmaven.repo.local=/app/tmp/repo.git/.cache/.m2/repository -s /app/tmp/repo.git/.cache/.m2/settings.xml -DskipTests=true clean install
           [INFO] Scanning for projects...
           [INFO]                                                                         
           [INFO] ------------------------------------------------------------------------
           [INFO] Building readmeTest 1.0-SNAPSHOT
           [INFO] ------------------------------------------------------------------------
    ...

The buildpack will detect your app as Java if it has the file `pom.xml` in the root.  It will use Maven to execute the build defined by your pom.xml and download your dependencies. The .m2 folder (local maven repository) will be cached between builds for faster dependency resolution. However neither the mvn executable or the .m2 folder will be available in your slug at runtime.

Hacking
-------

To use this buildpack, fork it on Github.  Push up changes to your fork, then create a test app with `--buildpack <your-github-url>` and push to it.

For example if you want to have maven available to use at runtime in your application you simply have to copy it from the cache directory to the build directory by adding the following lines to the compile script:

    for DIR in ".m2" ".maven" ; do
      cp -r $CACHE_DIR/$DIR $BUILD_DIR/$DIR
    done

This will copy the local maven repo and maven binaries into your slug.

Commit and push the changes to your buildpack to your Github fork, then push your sample app to Heroku to test. Once the push succeeds you should be able to run:

    $ heroku run bash

and then:

    $ ls -al

and you'll see the .m2 and .maven directories are now present in your slug.
