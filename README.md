# Wasp

[![Language](https://img.shields.io/badge/language-crystal-776791.svg)](https://github.com/crystal-lang/crystal)
![Status](https://img.shields.io/badge/status-WIP-blue.svg)
[![Build Status](https://img.shields.io/circleci/project/github/icyleaf/wasp/master.svg?style=flat)](https://circleci.com/gh/icyleaf/wasp)

A Static Site Generator written in [Crystal](http://crystal-lang.org/) v0.26.0+.

## Document

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

## Donate

Halite is a open source, collaboratively funded project. If you run a business and are using Halite in a revenue-generating product,
it would make business sense to sponsor Halite development. Individual users are also welcome to make a one time donation
if Halite has helped you in your work or personal projects.

You can donate via [Paypal](https://www.paypal.me/icyleaf/5).

## How to Contribute

Your contributions are always welcome! Please submit a pull request or create an issue to add a new question, bug or feature to the list.

Here is a throughput graph of the repository for the last few weeks:

All [Contributors](https://github.com/icyleaf/wasp/graphs/contributors) are on the wall.

## You may also like

- [halite](https://github.com/icyleaf/halite) - HTTP Requests Client with a chainable REST API, built-in sessions and middlewares.
- [totem](https://github.com/icyleaf/totem) - Load and parse a configuration file or string in JSON, YAML, dotenv formats.
- [markd](https://github.com/icyleaf/markd) - Yet another markdown parser built for speed, Compliant to CommonMark specification.
- [poncho](https://github.com/icyleaf/poncho) - A .env parser/loader improved for performance.
- [popcorn](https://github.com/icyleaf/popcorn) - Easy and Safe casting from one type to another.
- [fast-crystal](https://github.com/icyleaf/fast-crystal) - 💨 Writing Fast Crystal 😍 -- Collect Common Crystal idioms.

## License

[MIT License](https://github.com/icyleaf/halite/blob/master/LICENSE) © icyleaf
