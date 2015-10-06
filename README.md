Bookmark Manager Challenge		[![Build Status](https://travis-ci.org/UsmanJ/bookmark_manager.svg?branch=master)](https://travis-ci.org/UsmanJ/bookmark_manager)
======================

Synopsis
-----

The requirement was to build a bookmark manager which stores data using an SQL database. The manager can be used by those who sign up only. Passwords are encrypted using BCrypt. Users can sign in and sign out as well as sign up.


Approach towards solving the challenge
--------------------------------------

This was the first time I was using SQL databases and many of the gems included in this build. I test-drove the entire project to avoid any bugs. I first developed the ability to view and create links and adding a database which recorded the specifics.

Once I had done this, it made it easier to understand databases and allowed me to configure them as the project's requirements changed. I then implement the use of tags so that users can add tags to their bookmarks.

The ability to sign up, sign in and sign out was added near the end. The password had to be confirmed in order to create an account.

I used a rake file to migrate changes to my databases and used DataMapper to interact with the databases.

Improvements
-----------

I would like to improve the UI of the application and also add the ability to reset passwords. Last but not least, I'd also like to implement the ability to filter links using tags.
