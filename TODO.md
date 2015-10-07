# TODO

Things that could be improved upon:

* It might be worth getting fancier and parsing out the vendor name too?
* `lunch` shows _all_ items for that day, and not just lunch items - it'd be awesome if we could look at the time and make a best-effort to pick the right one.
* `zerocater <date> <location>` would be a nice expansion of the syntax, so that one can look at only their own office's menu.
* "Today" is also relative to each location, and not whatever timezone the bot is in.  Oh, joy, timezone math.
* The Zerocater menu HTML has a lot of ... interesting ... data, and I'm hesitant to commit it on an open repo - it'd be great to have a highly sanitized test file that would let everyone run their tests.
