# About this Repo

This is the Git repo of the Docker image for [janus-gateway]. It uses
Debian buster as its base and tries to check the integrity for all of the
dependencies used.

[janus-gateway]: https://hub.docker.com/r/29ki/janus-gateway/

## Service Configuration

There are multiple ways to set Janus server configuration.

* Use a custom config file in `/usr/local/etc/janus`. The entry point will
  automatically expand any environmental variables found in configuration
  files this directory.

* Set options directly on the run line. The entry point will pass all arguments
  you pass to it to the janus executable.

# Resources

There are alternative Docker Image packaging of Janus out there.

* [krull](https://github.com/krull/docker-janus) -- flexible and based on Debian jessie
