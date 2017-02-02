About
============
UmnShibAuth is an authentication gem for Rails designed to replace the existing UmnAuth x500 plugin for use with Shibboleth.  This plugin should work for all versions of rails--it's been used in Rails 2 and 3.

Installation
============
Add a reference to umn_shib_auth in your Gemfile:

    gem 'umn_shib_auth', git: 'git@github.umn.edu:asrweb/umn_shib_auth'

Usage
=====
In your routes, define a [root route](http://guides.rubyonrails.org/routing.html#using-root)

In application_controller.rb:

    include UmnShibAuth::ControllerMethods

In your views:

    <%= link_to "Sign out", shib_logout_url %>
    <%= link_to "Sign in", shib_logout_in %>

In your controller:

    before_filter :shib_umn_auth_required

Behavior
=====

If an un-authenticated user makes a request, they will be redirected (status code 302) to 

    https://yourapp.umn.edu/Shibboleth.sso/Login?target=https://yourapp.umn.edu/whatever_url_they_requested

If the request is an Ajax/XHR request (as defined by Rails' [`xml_http_request?`](http://api.rubyonrails.org/classes/ActionDispatch/Request.html#method-i-xml_http_request-3F) method), then the behavior is slightly different. Instead of a 302 Redirect, the user will receive some javascript that changes their browser location to

    https://yourapp.umn.edu/Shibboleth.sso/Login?target=https://yourapp.umn.edu/your_root_route

The behavior of the gem differs because the behavior of these two requests is not the same. 

In the case of a non-XHR request, shib will redirect the user to their originally-requested URL. This is fine, as that request was already a normal HTTP request and should work as expected.

But in the case of an XHR request we can not redirect the user to the same URL again. It will not behave the same because the redirect will be missing the "XMLHttpRequest" header that Rails relies on.

Proxied HTTP headers
--------------------

You can tell umn_shib_auth which variable has the EPPN value if it's not
the default, `request.env('eppn')`. This is useful when using Torquebox or
anytime `ShibUseHeaders On` is enabled in your apache config.

Simply create an intializer and set `UmnShibAuth.eppn_variable` to
whatever your setup requires. If you're using Torquebox, you'll probably
want to use something like this:

    # config/initializers/umn_shib_auth.rb
    # Use the shibboleth eppn forwarded by apache
    UmnShibAuth.eppn_variable = 'HTTP_EPPN'

Migrating
=========
If you were using some flavor of the old UmnAuth filter
linked from https://wiki.umn.edu/CAH/WebHome
labeled "umn_auth for Rails 2.x (Joe Goggins).

You can do a one line migration, by removing the old code and adding the
new code like follows

    # include UmnAuth::ControllerMethods
    include UmnShibAuth::ReplacementForUmnAuthControllerMethods

Development
======

- Fork the repo
- `./script/setup`

Scripts
======
- `./script/setup` installs dependencies
- `./script/test` runs the tests
- `./script/update` updates dependencies

Copyright (c) 2011 Regents of the University of Minnesota
