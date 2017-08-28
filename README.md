# abaez/openresty
## A modulized container for Openresty by [Alejandro Baez](https://twitter.com/a_baez)


### DESCRIPTION
A simple base container for Openresty. Needed something that I could control
the build release. Due note, that you need to extend the `Dockerfile` for it to
actually work.

### USAGE
A lightweight base container for openresty. The container allows you to run two
different versions of lua for openresty. You can choose which by choosing from
the branch or tag in your `Dockerfile`. The default version of lua is
**luajit** on the **latest** tag. If you want to choose a different version,
simply define it in your `Dockerfile` like so:

```
FROM abaez/openresty:lua5.1
```

You can pick the version of lua you want by using one of the following:

* base branches:
    * latest: the most current version of luajit provided by openresty.
    * lua5.1: the most current version of lua-5.1.
* version of openresty by tags:
    * 1.11.2.2
    * 1.9.7.2
    * 1.9.3.1

