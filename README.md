Heroku buildpack for Loklak: Java (with Apache Ant)
===================================================

This is a [Heroku buildpack](http://devcenter.heroku.com/articles/buildpack) made specifically for the [Loklak server](https://github.com/loklak/loklak_server). Forked from https://github.com/dennisg/heroku-buildpack-ant (Thanks!)
It uses Apache Ant 1.9.7 to build your application and OpenJDK 1.8 (currently) to run it.

Usage
-----
This buildpack is meant to be used in conjuction with Loklak server only. If you want to run any other application with Ant on Heroku, check out https://github.com/dennisg/heroku-buildpack-ant

In your project directory:

1. Clone the Loklak server (if not already) : `git clone https://github.com/loklak/loklak_server.git`
2. Create a heroku app: `heroku create`
3. Set the buildpack: `heroku buildpacks:set https://github.com/loklak/heroku_buildpack_ant_loklak.git`
4. Push your app to heroku: `git push heroku master`
5. Confirm the loklak server is running: `heroku logs --tail`
6. Open the URL of your server in your browser: `heroku open`.
