About
============
UmnShibAuth is an authentication gem for Rails designed to replace the existing UmnAuth x500 plugin for use with Shibboleth.  This plugin should work for all versions of rails--it's been used in Rails 2 and 3.

Installation
============
Snag the code and drop it into `lib/umn_shib_auth`, then add a reference
to it in your Gemfile:

    gem 'umn_shib_auth', :path => 'lib/umn_shib_auth'

Usage
=====
In application_controller.rb:

    include UmnShibAuth::ControllerMethods

In your views:

    <%= link_to "Sign out", shib_logout_url %>
    <%= link_to "Sign in", shib_logout_in %>

In your controller:

    before_filter :umn_auth_required

Migrating
=========
If you were using some flavor of the old UmnAuth filter
linked from https://wiki.umn.edu/CAH/WebHome
labeled "umn_auth for Rails 2.x (Joe Goggins).

You can do a one line migration, by removing the old code and adding the
new code like follows

    # include UmnAuth::ControllerMethods
    include UmnShibAuth::ReplacementForUmnAuthControllerMethods


Copyright (c) 2011 Regents of the University of Minnesota
