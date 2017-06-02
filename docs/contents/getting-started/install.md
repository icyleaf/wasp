---
title: "Installing Wasp"
slug: "install"
date: "2017-06-01T15:00:31+08:00"
---

We can't provide pre-built binaries currently, Wasp is written in Crystal with support for multiple platforms except Windows.

## Installing from source

> Preqeuisite tools for downloading and building source code

- [Git](http://git-scm.com/)
- [Crystal](https://crystal-lang.org/) 0.22.0+

```
$ git clone https://github.com/icyleaf/wasp.git && cd wasp
$ make build
$ sudo cp bin/wasp /usr/local/bin/wasp
```