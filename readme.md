# crossmaker

## What is it?

`crossmaker` is a Docker based simple cross compiler builder utility that not mess up your distro while building packages.

## How to use it?

All commands can be triggered with `./manage.sh` script. Before using it, please `source` it with the following command:

```sh
$ source manage.sh
```

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

## System requirements

I think all Docker supported linux distros are suitable, but scripts are based on `bash` / `dash` shell, so if you are using other shells something might be screwed.
