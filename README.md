# Love as a Service
## About
Last year I wrote a webpage [love.hackerzhou.me](http://love.hackerzhou.me) and received 20,000+ PV in 2 weeks. It was amazing and some programmers forked my github project [Love](https://github.com/hackerzhou/Love) to do secondary development. So this year I decide to wrap it with Sinatra framework and put it on VMware's Cloud Foundry PaaS. Now users can create their own pages by several clicks. Please write romantic code for your loves using this application.

## Website
<http://iloveu.cloudfoundry.com>

## How to deploy on Cloud Foundry
1. Clone/Download the project.
2. Modify `db/migrate/0_initialize.rb` file, replace `#ADMIN_USERNAME#` and `#ADMIN_PASSWORD#` with whatever you like. _(Note that the password is encrypted by SHA1)_
3. Install ruby and vmc if you don't have them.
4. Execute following command to push this application to Cloud Foundry:
>vmc target api.cloudfoundry.com  
>vmc login  
>vmc push  
>_(Note that you need to create a mysql database)_

## Used Javascript libraries
1. [jQuery 1.8.0](http://jquery.com)
2. [jQuery UI 1.8.24](http://jqueryui.com)
3. [jQuery Time Picker 1.0.5](http://trentrichardson.com/examples/timepicker/)
4. [FlowerPower](http://www.openrise.com/lab/FlowerPower/)
5. [ColorBox 1.3.20.1](http://www.jacklmoore.com/colorbox)

## Used Ruby Gems
1. sinatra
2. activerecord
3. activerecord-postgresql-adapter
4. standalone_migrations
5. rack
6. json
7. cf-runtime

## TODO
1. Expose delete page feature to front end.
2. Management app based on REST service.
3. Session based counter.
4. Add CAPTCHA support.