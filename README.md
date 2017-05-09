# Wasp

![Status](https://img.shields.io/badge/status-development-yellow.svg) [![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/icyleaf/wasp/blob/master/LICENSE) [![Dependency Status](https://shards.rocks/badge/github/icyleaf/wasp/status.svg)](https://shards.rocks/github/icyleaf/wasp) [![devDependency Status](https://shards.rocks/badge/github/icyleaf/wasp/dev_status.svg)](https://shards.rocks/github/icyleaf/wasp) [![Build Status](https://travis-ci.org/icyleaf/wasp.svg)](https://travis-ci.org/icyleaf/wasp)

A Static Site Generator written in [Crystal](http://crystal-lang.org/).

## Documents

Install crystal-lang and clone the project, then to run:

```
$ crystal src/wasp.cr "server -s docs"

...

Web Server is running at http://127.0.0.1:8624 (Press Ctrl+C to stop)
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

1. Fork it ( https://github.com/icyleaf/wasp/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [icyleaf](https://github.com/icyleaf) - creator, maintainer
