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


Configuration
-------------

For the APIs with Storstockholms Lokaltrafik you will need API tokens. To avoid putting them in code the library [`dotenv`](https://github.com/bkeepers/dotenv) is used. You need to create a file called `.env` in the root folder and put tokens in it like so:

    SL_API_KEY_SEARCH=<your-search-token>
    SL_API_KEY_DEPARTURES=<your-departures-token>

The [search API](https://www.trafiklab.se/api/trafiklab-apis/sl/stop-lookup/) is only used when setting up a dashboard on the front page. If you know the stop ids from somewhere else you can use them directly instead. The [departures API](https://www.trafiklab.se/api/trafiklab-apis/sl/departures-4/) is used once a minute for each station on the dashboard which means that the lowest level is not enough. If you are running out of quota you will get a message about that involving the error code 429 instead of departure times. To get API keys you need to register with [trafiklab](https://www.trafiklab.se). 

Bubonem used to go against the undocumented APIs behind the SL site but there has been harder security put in place so the official APIs are the way to go now.


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

