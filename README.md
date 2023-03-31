# picard

Portable CI/CD pipelines with Make :heart: Docker.

![Make it so.](https://i.imgur.com/86dBGg3.gif)

## Getting started

1. Install [GNU Make](https://www.gnu.org/software/make/) (you probably already have it)

2. Install Docker [Engine](https://docs.docker.com/engine/install/)/[Desktop](https://www.docker.com/products/docker-desktop/)

3. Clone this repository

4. Run the following commands

```
$ make
# starts a shell in the development environment by default
/usr/src/example $ yarn test
# ...test output...
/usr/src/example $ yarn start
# ...main output...

# you can run the same commands with these make targets outside of the 
$ make test   # will run 'yarn --silent test' see 'Makefile'
$ make start  # will run 'yarn --silent start' see 'Makefile'
```

## Why does this project exist?

Well... with more and more projects are making use of DevOps tooling these days to automate their CI/CD process, they often settle on a particular product/service/tool, which also comes with its own flavour of configuration language/schema/APIs.

This is a slippery slope to an inevitable ***'vendor lock-in'***, in most cases.

Also, frequently these solutions are ***not portable***, and do not provide a easy way to ***debug and reproduce pipeline failures locally***, meaning you typically waste a lot of time thrashing around and pushing configuration changes in an attempt to diagnose issues.

## Enter Make :heart: Docker

You can get pretty far by wrapping Docker commands with a Make targets, allowing you to build a simplified CLI for your project, which can also be made use of in your CI/CD pipeline of choice, with only these two dependencies and trivial to install locally.

**This project is to serve as an example of how you can define your project's dev/build environment in Docker and your CI/CD pipeline stages in Make.**