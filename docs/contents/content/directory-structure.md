---
title: "Directory structure"
slug: "directory-structure.md"
date: "2018-09-21T12:01:31+08:00"
---

The default Wasp installation consists of a directory structure which looks like this:

```
├── config.yml
├── contents
├── layouts
│   ├── 404.html
│   ├── _default
│   │   └── single.html
│   ├── index.html
│   └── partial
│       ├── footer.html
│       ├── header.html
│       └── menu.html
└── static
    ├── css
    ├── fonts
    └── js
```

Here's a high level overview of each of these folders and `config.yml`.

### config.yml

A mandatory configuration file of Gutenberg in YAML format. It is explained in details in the [Configuration page](/configuration).

### contents

Where all your markup content lies: this will be mostly comprised of .md files.
Each folder in the content directory represents a section that contains pages : your .md files.

### layouts

Contains all the Crinja templates that will be used to render this site.
Have a look at the Templates to learn more about default templates and available variables.

### static

Contains any kind of files. All the files/folders in the static folder will be copied as-is in the output directory.
