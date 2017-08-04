About
============
UmnShibAuth is an authentication gem for Rails designed to replace the existing UmnAuth x500 plugin for use with Shibboleth.  This plugin should work for all versions of rails--it's been used in Rails 2 and 3.

Installation
============
Add a reference to umn_shib_auth in your Gemfile:

    gem 'umn_shib_auth', git: 'git@github.umn.edu:asrweb/umn_shib_auth'

If you want access to `display_name` or `emplid` from shibboleth, you will need to:
1) be using the `apache_mod_shib` role in ansible, and
2) update your ansible configuration's group_vars to include:
```
apache_mod_shib_display_name: true
apache_mod_shib_employee_number: true
```

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

To access the shibboleth provided metadata, use one of `shib_umn_session.internet_id`, `shib_umn_session.emplid`, or `shib_umn_session.display_name`.  Ex:
```
<p>My name is <%= shib_umn_session.display_name %></p>
```

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

You can tell umn_shib_auth which variable has the EPPN value (or other shibboleth provided values) if they are not
the defaults (ex: `request.env('eppn')`). This is useful when using Torquebox or
anytime `ShibUseHeaders On` is enabled in your apache config.

Simply create an intializer and set `UmnShibAuth.eppn_variable` to
whatever your setup requires. If you're using Torquebox, you'll probably
want to use something like this:

    # config/initializers/umn_shib_auth.rb
    # Use the shibboleth eppn forwarded by apache
    UmnShibAuth.eppn_variable = 'HTTP_EPPN'
    UmnShibAuth.emplid_variable = 'HTTP_EMPLID'
    UmnShibAuth.display_name_variable = 'HTTP_NAME'

Migrating
=========
If you were using some flavor of the old UmnAuth filter
linked from https://wiki.umn.edu/CAH/WebHome
labeled "umn_auth for Rails 2.x (Joe Goggins).

You can do a one line migration, by removing the old code and adding the
new code like follows

    # include UmnAuth::ControllerMethods
    include UmnShibAuth::ReplacementForUmnAuthControllerMethods

Stubbing the current user in development
======

During development, it's nice to be able to stub which user is currently logged
in (short circuit the typical trip to the service provider). To do this, two
mechanisms are required:

1. Create a file, `~/.umn_shib_auth_enable_stub` with the content `I Want To Stub`.
2. Start your rails server with the environment variable `STUB_INTERNET_ID` set to the username you want to impersonate.  If you are getting emplid or display_name from shibboleth, you can also set the environment variables `STUB_EMPLID` and `STUB_DISPLAY_NAME`.

Both of these mechanisms are meant to be safeguards to ensure this behavior is not
enabled in production environments.

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
