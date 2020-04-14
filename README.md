bubonem
=======

About
-----

bubonem is built with ruby and javascript. Good stuff... It used to be on jquery for a while but now it is running on vanilla. Great....


Install locally
---------------

The ruby things are set up in the Gemfile. Use whatever ruby version that is in `.ruby-version` with rbenv or something. Install bundler:

    gem install bundler

and then install all the gems

    bundle install

The javascript things are alls native to the browser so no need to install anything. Some fonts and likewise are drawn from the internets.


Run locally
-----------

The app is served by sinatra and the easiest way to run it locally is by using rackup:

    bundle exec rackup config.ru

Open a browser at http://localhost:9292 to behold the started things


Run server side
---------------

On the server unicorn is used to run things. It can connect with nginx over native sockets which is nice for performance. (Not important but nice.....)

The configuration for unicon lives in `unibubonem.rb`. To run it on a server:

    bundle exec unicorn -c unibubonem.rb -E production -D

This tells unicorn to run as a daemon in production mode. Sweet.
