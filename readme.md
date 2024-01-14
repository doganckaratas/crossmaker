# crossmaker

## What is it?

`crossmaker` is a Docker based simple cross compiler builder utility that not mess up your distro while building packages.

## How to use it?

All commands can be triggered with `./manage.sh` script. Before using it, please `source` it with the following command:

```sh
$ source manage.sh
```

With this way, you can use `tab` key for autocomplete target arguments.

If you do not have Docker installed on your system, please use `./manage.sh` script for auto installing Docker with below command:

```sh
$ ./manage.sh setup
```

Script will ask your sudo password when necessary for completing operations.

After this step is finished, please log-off and log-on your session for applying changes system-wide.

You can use available session, but if you close terminal you might want to execute `newgrp docker` command before using the script.

Building container is easy as the following command:

```sh
$ ./manage.sh build
```

After building, you can use it immediately with this command:

```sh
$ ./manage.sh run
```

That's it, you can close session with `exit` or `CTRL-D` keys.

If you no longer need container, you can send it to hell with the following command:

```sh
$ ./manage.sh destroy
```

I've added simple help text but if you ask me, I think it is not helpful at all, although you can acces it with wrong arguments supplied or the following command:

```sh
$ ./manage.sh help
```

## Generating the toolchain

After `running` the container with `./manage.sh run`, you can use `./build-toolchain.sh` command for the automated build of the toolchain.

You can alter my default settings in `./build-toolchain.sh` for your needs, e.g. I've picked job count to `7` and you can change it to `3` for example.

```sh
# ./build-toolchain.sh
```

## System requirements

I think all Docker supported linux distros are suitable, but scripts are based on `bash` / `dash` shell, so if you are using other shells something might be screwed.
