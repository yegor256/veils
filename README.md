<img src="/logo.svg" width="64px" height="64px"/>

[![EO principles respected here](https://www.elegantobjects.org/badge.svg)](https://www.elegantobjects.org)
[![DevOps By Rultor.com](http://www.rultor.com/b/yegor256/veils)](http://www.rultor.com/p/yegor256/veils)
[![We recommend RubyMine](https://www.elegantobjects.org/rubymine.svg)](https://www.jetbrains.com/ruby/)

[![rake](https://github.com/yegor256/veils/actions/workflows/rake.yml/badge.svg)](https://github.com/yegor256/veils/actions/workflows/rake.yml)
[![Gem Version](https://badge.fury.io/rb/veils.svg)](http://badge.fury.io/rb/veils)
[![Maintainability](https://api.codeclimate.com/v1/badges/51b007d0eb24ceeeca94/maintainability)](https://codeclimate.com/github/yegor256/veils/maintainability)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/github/yegor256/veils/master/frames)
[![Hits-of-Code](https://hitsofcode.com/github/yegor256/veils)](https://hitsofcode.com/view/github/yegor256/veils)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/yegor256/veils/blob/master/LICENSE.txt)

Read this blog post first:
[Veil Objects to Replace DTOs](https://www.yegor256.com/2020/05/19/veil-objects.html)

First, install it:

```bash
$ gem install veils
```

Then, use it like this:

```ruby
require 'veil'
obj = Veil.new(obj, to_s: 'Hello, world!')
```

The method `to_s` will return `Hello, world!` until some other
method is called and the veil is "pierced."

You can also use `Unpiercable` decorator, which will never be pierced:
a very good instrument for data memoization.

You can also try `AlterOut`, which lets you modify the output
of object methods on fly:

```ruby
require 'alterout'
obj = AlterOut.new(obj, to_s: proc { |s| s + 'extra tail' })
```

There is also `AlterIn` decorator, to modify incoming method arguments
(the result of the `proc` will replace the list of input arguments):

```ruby
require 'alterin'
obj = AlterIn.new(obj, print: proc { |i| [i + 1] })
```

Keep in mind that all classes are thread-safe.

## How to contribute

Read [these guidelines](https://www.yegor256.com/2014/04/15/github-guidelines.html).
Make sure your build is green before you contribute
your pull request. You will need to have [Ruby](https://www.ruby-lang.org/en/) 2.3+ and
[Bundler](https://bundler.io/) installed. Then:

```
$ bundle update
$ bundle exec rake
```

If it's clean and you don't see any error messages, submit your pull request.
