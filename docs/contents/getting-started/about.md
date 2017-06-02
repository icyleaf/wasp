---
title: "About"
slug: "about"
date: "2017-06-02T15:00:31+08:00"
---

# What is Wasp?

![Status](https://img.shields.io/badge/status-WIP-blue.svg)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/icyleaf/wasp/blob/master/LICENSE)
[![Dependency Status](https://shards.rocks/badge/github/icyleaf/wasp/status.svg)](https://shards.rocks/github/icyleaf/wasp)
[![Build Status](https://img.shields.io/circleci/project/github/icyleaf/wasp/master.svg?style=flat)](https://circleci.com/gh/icyleaf/wasp)

A Static Site Generator written in [Crystal](http://crystal-lang.org/).

## Documents

Read it [Online](https://icyleaf.github.io/wasp/) or [install](https://crystal-lang.org/docs/installation/) crystal-lang and clone the project, then to run:

```
$ make
$ ./bin/wasp server -s docs --verbose
Using config file: /Users/icyleaf/Development/crystal/wasp/docs
Generating static files to /Users/icyleaf/Development/crystal/wasp/docs/public
Write to /Users/icyleaf/Development/crystal/wasp/docs/public/guide/getting-started/index.html
Write to /Users/icyleaf/Development/crystal/wasp/docs/public/guide/install/index.html
Write to /Users/icyleaf/Development/crystal/wasp/docs/public/guide/intro/index.html
Total in 55.375 ms
Watch changes in '/Users/icyleaf/Development/crystal/wasp/docs/{config.yml,contents/**/*.md,layouts/**/*.html,static/**/*}'
Web Server is running at http://localhost:8624/ (bind address 127.0.0.1)
Press Ctrl+C to stop
```

## Todo

This project is under development, DO NOT use it in production.

- [x] site structures
- [x] site configurate (default)
- [x] parse markdown to html
- [x] live preview with web server
- [x] livereload after save content(settings/post/page)
- [ ] theme template
- [ ] admin panel
- [ ] command line tool
  - [x] `config`: print site configuration
  - [ ] `init`: initialize a new site
  - [ ] `new`: create a new post
  - [ ] `search`: search post
  - [x] `build`: generate to static pages
  - [x] `server`: run a web server

## Inspires

- [hugo](https://github.com/spf13/hugo)
- [journey](https://github.com/kabukky/journey)
- [dingo](https://github.com/dingoblog/dingo)

## Contributing

1. [Fork me](https://github.com/icyleaf/wasp/fork)
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [icyleaf](https://github.com/icyleaf) - creator, maintainer
