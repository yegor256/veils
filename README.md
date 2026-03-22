# Ruby Decorator for "Veil" Objects

[![EO principles respected here](https://www.elegantobjects.org/badge.svg)](https://www.elegantobjects.org)
[![DevOps By Rultor.com](https://www.rultor.com/b/yegor256/veils)](https://www.rultor.com/p/yegor256/veils)
[![We recommend RubyMine](https://www.elegantobjects.org/rubymine.svg)](https://www.jetbrains.com/ruby/)

[![rake](https://github.com/yegor256/veils/actions/workflows/rake.yml/badge.svg)](https://github.com/yegor256/veils/actions/workflows/rake.yml)
[![Gem Version](https://badge.fury.io/rb/veils.svg)](https://badge.fury.io/rb/veils)
[![Maintainability](https://api.codeclimate.com/v1/badges/51b007d0eb24ceeeca94/maintainability)](https://codeclimate.com/github/yegor256/veils/maintainability)
[![Yard Docs](https://img.shields.io/badge/yard-docs-blue.svg)](https://rubydoc.info/github/yegor256/veils/master/frames)
[![Hits-of-Code](https://hitsofcode.com/github/yegor256/veils)](https://hitsofcode.com/view/github/yegor256/veils)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/yegor256/veils/blob/master/LICENSE.txt)

Read this blog post first: [Veil Objects to Replace DTOs][blog].

First, install it:

```bash
gem install veils
```

Then, use it like this:

```ruby
require 'veil'
obj = Veil.new(obj, to_s: 'Hello, world!')
```

The method `to_s` will return `Hello, world!` until some other
method is called and the veil is "pierced."

You can also use the `Unpiercable` decorator, which will never be pierced:
a very good instrument for data memoization.

You can also try `AlterOut`, which lets you modify the output
of object methods on the fly:

```ruby
require 'alterout'
obj = AlterOut.new(obj, to_s: proc { |s| s + 'extra tail' })
```

There is also the `AlterIn` decorator, to modify incoming method arguments
(the result of the `proc` will replace the list of input arguments):

```ruby
require 'alterin'
obj = AlterIn.new(obj, print: proc { |i| [i + 1] })
```

Keep in mind that all classes are thread-safe.

## How to contribute

Read these [guidelines].
Make sure your build is green before you contribute your pull request.
You will need to have [Ruby] 2.3+ and [Bundler] installed.
Then:

```bash
bundle update
bundle exec rake
```

If it's clean and you don't see any error messages, submit your pull request.

[blog]: https://www.yegor256.com/2020/05/19/veil-objects.html
[guidelines]: https://www.yegor256.com/2014/04/15/github-guidelines.html
[Ruby]: https://www.ruby-lang.org/en/
[Bundler]: https://bundler.io/
