About
============
UmnShibAuth is an authentication gem for Rails designed to replace the existing UmnAuth x500 plugin for use with Shibboleth.  This plugin should work for all versions of rails--it's been used in Rails 2 and 3.

Installation
============
Add a reference to umn_shib_auth in your Gemfile:

    gem 'umn_shib_auth', git: 'git@github.umn.edu:asrweb/umn_shib_auth'

Usage
=====
In application_controller.rb:

    include UmnShibAuth::ControllerMethods

In your views:

    <%= link_to "Sign out", shib_logout_url %>
    <%= link_to "Sign in", shib_logout_in %>

In your controller:

    before_filter :shib_umn_auth_required

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
