<img src="/logo.svg" width="64px" height="64px"/>

[![EO principles respected here](https://www.elegantobjects.org/badge.svg)](https://www.elegantobjects.org)
[![DevOps By Rultor.com](http://www.rultor.com/b/yegor256/syncem)](http://www.rultor.com/p/yegor256/syncem)
[![We recommend RubyMine](https://www.elegantobjects.org/rubymine.svg)](https://www.jetbrains.com/ruby/)

[![rake](https://github.com/yegor256/syncem/actions/workflows/rake.yml/badge.svg)](https://github.com/yegor256/syncem/actions/workflows/rake.yml)
[![Gem Version](https://badge.fury.io/rb/syncem.svg)](http://badge.fury.io/rb/syncem)
[![Maintainability](https://api.codeclimate.com/v1/badges/5528e182bb5e4a2ecc1f/maintainability)](https://codeclimate.com/github/yegor256/syncem/maintainability)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/github/yegor256/syncem/master/frames)
[![Hits-of-Code](https://hitsofcode.com/github/yegor256/syncem)](https://hitsofcode.com/view/github/yegor256/syncem)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/yegor256/syncem/blob/master/LICENSE.txt)

Read this blog post:
[_SyncEm: Thread-Safe Decorators in Ruby_](https://www.yegor256.com/2019/06/26/syncem.html).

Sometimes you have an object that is not thread-safe,
but you need to make sure each of its methods is thread-safe, because they
deal with some resources, like files or databases and you want them to
manage those resources sequentially. This small gem will help you achieve
exactly that without any re-design of the objects you already have. Just
decorate them with `SyncEm` [thread-safe decorator](https://www.yegor256.com/2017/01/17/synchronized-decorators.html)
and that is it.

First, install it:

```bash
$ gem install syncem
```

Then, use it like this:

```ruby
require 'syncem'
obj = SyncEm.new(obj)
```

That's it.

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
