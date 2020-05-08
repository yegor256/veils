<img src="/logo.svg" width="64px" height="64px"/>

[![EO principles respected here](https://www.elegantobjects.org/badge.svg)](https://www.elegantobjects.org)
[![DevOps By Rultor.com](http://www.rultor.com/b/yegor256/veils)](http://www.rultor.com/p/yegor256/veils)
[![We recommend RubyMine](https://www.elegantobjects.org/rubymine.svg)](https://www.jetbrains.com/ruby/)

[![Build Status](https://travis-ci.org/yegor256/veils.svg)](https://travis-ci.org/yegor256/veils)
[![Build status](https://ci.appveyor.com/api/projects/status/e61qudqccs0fu8xt?svg=true)](https://ci.appveyor.com/project/yegor256/veils)
[![Gem Version](https://badge.fury.io/rb/veils.svg)](http://badge.fury.io/rb/veils)
[![Maintainability](https://api.codeclimate.com/v1/badges/224939b58aa606fdd56c/maintainability)](https://codeclimate.com/github/yegor256/veils/maintainability)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/github/yegor256/veils/master/frames)

[![Hits-of-Code](https://hitsofcode.com/github/yegor256/veils)](https://hitsofcode.com/view/github/yegor256/veils)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/yegor256/veils/blob/master/LICENSE.txt)

First, install it:

```bash
$ gem install veils
```

Then, use it like this:

```ruby
require 'veils'
obj = Veil.new(obj, to_s: 'Hello, world!')
```

The method `to_s` will return `Hello, world!` until some other
method is called and the veil is "pierced."

Keep in mind that `Veil` is thread-safe.

## How to contribute

Read [these guidelines](https://www.yegor256.com/2014/04/15/github-guidelines.html).
Make sure you build is green before you contribute
your pull request. You will need to have [Ruby](https://www.ruby-lang.org/en/) 2.3+ and
[Bundler](https://bundler.io/) installed. Then:

```
$ bundle update
$ bundle exec rake
```

If it's clean and you don't see any error messages, submit your pull request.
