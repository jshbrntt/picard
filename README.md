# picard

Portable CI/CD pipelines with Make :heart: Docker.

![Make it so.](https://i.imgur.com/86dBGg3.gif)

## Why does this project exist?

Well... with more and more projects are making use of DevOps tooling these days to automate their CI/CD process, they often settle on a particular product/service/tool, which also comes with its own flavour of configuration language/schema/APIs.

This is a slippery slope to an inevitable ***'vendor lock-in'***, in most cases.

Also, frequently these solutions are ***not portable***, and do not provide a easy way to ***debug and reproduce pipeline failures locally***, meaning you typically waste a lot of time thrashing around and pushing configuration changes in an attempt to diagnose issues.

## Enter Make :heart: Docker

You can get pretty far by wrapping Docker commands with a Make targets, allowing you to build a simplified CLI for your project, which can also be made use of in your CI/CD pipeline of choice, with only these two dependencies and trivial to install locally.

**This project is to serve as an example of how you can define your project's dev/build environment in Docker and your CI/CD pipeline stages in Make.**