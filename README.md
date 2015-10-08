# lita-zerocater

[![Build Status](https://img.shields.io/travis/esigler/lita-zerocater/master.svg)](https://travis-ci.org/esigler/lita-zerocater)
[![MIT License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://tldrlegal.com/license/mit-license)
[![RubyGems](http://img.shields.io/gem/v/lita-zerocater.svg)](https://rubygems.org/gems/lita-zerocater)
[![Coveralls Coverage](https://img.shields.io/coveralls/esigler/lita-zerocater/master.svg)](https://coveralls.io/r/esigler/lita-zerocater)
[![Code Climate](https://img.shields.io/codeclimate/github/esigler/lita-zerocater.svg)](https://codeclimate.com/github/esigler/lita-zerocater)
[![Gemnasium](https://img.shields.io/gemnasium/esigler/lita-zerocater.svg)](https://gemnasium.com/esigler/lita-zerocater)

A ZeroCater menu lookup plugin for Lita

## Installation

Add lita-zerocater to your Lita instance's Gemfile:

``` ruby
gem "lita-zerocater"
```

## Configuration

Configuring at least one location is required:

``` ruby
config.handlers.zerocater.locations = {
  'San Francisco' => 'ABCD'
}
```

Where `ABCD` is the slug found at the end of the Zerocater menu URL

## Usage

Examples:

```
lunch               - Show today's Zerocater menu for all locations
zerocater today     - Show today's Zerocater menu for all locations
zerocater tomorrow  - Show tomorrow's Zerocater menu for all locations
zerocater yesterday - Show yesterday's Zerocater menu for all locations
```
