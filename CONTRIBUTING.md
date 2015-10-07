Pull requests are awesome!  Pull requests with tests are even more awesome!

## WARNING WARNING WARNING

You'll need to grab a copy of your Zerocater menu HTML and develop against it locally.  For the moment, I've set it up so the tests depend on a environment variable that points to the menu HTML, though this is rather fragile.

## Quick steps

1. Fork the repo.
2. Run the tests: `bundle && rake`
3. Add a test for your change. Only refactoring and documentation changes require no new tests. If you are adding functionality or fixing a bug, it needs a test!
4. Make the test pass.
5. Push to your fork and submit a pull request.
