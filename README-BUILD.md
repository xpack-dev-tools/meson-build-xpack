# How to build the xPack Meson Build

## Introduction

This project also includes the scripts and additional files required to
build and publish the
[xPack Meson Build](https://github.com/xpack-dev-tools/meson-build-xpack) binaries.

The build scripts use the
[xPack Build Box (XBB)](https://github.com/xpack/xpack-build-box),
a set of elaborate build environments based on recent GCC versions
(Docker containers
for GNU/Linux and Windows or a custom folder for MacOS).

There are two types of builds:

- local/native builds, which use the tools available on the
  host machine; generally the binaries do not run on a different system
  distribution/version; intended mostly for development purposes.
- distribution builds, which create the archives distributed as
  binaries; expected to run on most modern systems.

## Repositories

- `https://github.com/xpack-dev-tools/meson-build-xpack.git` - the URL of the
  [xPack Meson Build fork](https://github.com/xpack-dev-tools/meson-build-xpack) project
- `https://github.com/xpack-dev-tools/build-helper` - the URL of the
  xPack build helper, used as the `scripts/helper` submodule
- `https://github.com/mesonbuild/meson` - the URL of the original Meson repo

### Branches

- `xpack` - the updated content, used during builds
- `xpack-develop` - the updated content, used during development
- `master` - empty, not used.

## Prerequisites

The prerequisites are common to all binary builds. Please follow the
instructions in the separate
[Prerequisites for building binaries](https://xpack.github.io/xbb/prerequisites/)
page and return when ready.

## Download the build scripts

The build scripts are available in the `scripts` folder of the
[`xpack-dev-tools/meson-build-xpack`](https://github.com/xpack-dev-tools/meson-build-xpack)
Git repo.

To download them, the following shortcut is available:

```console
$ curl -L https://github.com/xpack-dev-tools/meson-build-xpack/raw/xpack/scripts/git-clone.sh | bash
```

This small script issues the following two commands:

```console
$ rm -rf ~/Downloads/meson-build-xpack.git; \
  git clone --recurse-submodules \
  https://github.com/xpack-dev-tools/meson-build-xpack.git \
  ~/Downloads/meson-build-xpack.git
```

> Note: the repository uses submodules; for a successful build it is
> mandatory to recurse the submodules.

For development purposes, there is a shortcut to clone the `xpack-develop`
branch:

```console
$ curl -L https://github.com/xpack-dev-tools/meson-build-xpack/raw/xpack/scripts/git-clone-develop.sh | bash
```

which is a shortcut for:

```console
$ rm -rf ~/Downloads/meson-build-xpack.git; \
  git clone --recurse-submodules --branch xpack-develop \
  https://github.com/xpack-dev-tools/meson-build-xpack.git \
  ~/Downloads/meson-build-xpack.git
```

## The `Work` folder

The scripts create a temporary build `Work/meson-build-${version}` folder in
the user home. Although not recommended, if for any reasons you need to
change the location of the `Work` folder,
you can redefine `WORK_FOLDER_PATH` variable before invoking the script.

## Spaces in folder names

Due to the limitations of `make`, builds started in folders with
spaces in names are known to fail.

If on your system the work folder is in such a location, redefine it in a
folder without spaces and set the `WORK_FOLDER_PATH` variable before invoking
the script.

## Customizations

There are many other settings that can be redefined via
environment variables. If necessary,
place them in a file and pass it via `--env-file`. This file is
either passed to Docker or sourced to shell. The Docker syntax
**is not** identical to shell, so some files may
not be accepted by bash.

## Versioning

The version string is an extension to semver, the format looks like `0.55.3-2`.
It includes the three digits with the original Meson version (0.55.3), a fourth
digit with the xPack release number.

When publishing on the **npmjs.com** server, a fifth digit is appended.

## Changes

Compared to the original Meson Build distribution, there should be no
functional changes.

The actual changes for each version are documented in the corresponding
release pages:

- https://xpack.github.io/meson-build/releases/

## How to build local/native binaries

### README-DEVELOP.md

The details on how to prepare the development environment for Meson Build are in the
[`README-DEVELOP.md`](https://github.com/xpack-dev-tools/meson-build-xpack/blob/xpack/README-DEVELOP.md) file.

## How to build distributions

### Build

Although it is perfectly possible to build all binaries in a single step
on a macOS system, due to Docker specifics, it is faster to build the
GNU/Linux and Windows binaries on a GNU/Linux system and the macOS binary
separately on a macOS system.

#### Build the Intel GNU/Linux and Windows binaries

The current platform for GNU/Linux and Windows production builds is a
Debian 10, running on an Intel NUC8i7BEH mini PC with 32 GB of RAM
and 512 GB of fast M.2 SSD.

```console
$ ssh xbbi
```

Before starting a build, check if Docker is started:

```console
$ docker info
```

Before running a build for the first time, it is recommended to preload the
docker images.

```console
$ bash ~/Downloads/meson-build-xpack.git/scripts/build.sh preload-images
```

The result should look similar to:

```console
$ docker images
REPOSITORY          TAG                              IMAGE ID            CREATED             SIZE
ilegeul/ubuntu      i386-12.04-xbb-v3.2              fadc6405b606        2 days ago          4.55GB
ilegeul/ubuntu      amd64-12.04-xbb-v3.2             3aba264620ea        2 days ago          4.98GB
hello-world         latest                           bf756fb1ae65        5 months ago        13.3kB
```

It is also recommended to Remove unused Docker space. This is mostly useful
after failed builds, during development, when dangling images may be left
by Docker.

To check the content of a Docker image:

```console
$ docker run --interactive --tty ilegeul/ubuntu:amd64-12.04-xbb-v3.2
```

To remove unused files:

```console
$ docker system prune --force
```

Since the build takes a while, use `screen` to isolate the build session
from unexpected events, like a broken
network connection or a computer entering sleep.

```console
$ screen -S meson

$ sudo rm -rf ~/Work/meson-build-*
$ bash ~/Downloads/meson-build-xpack.git/scripts/build.sh --all
```

or, for development builds:

```console
$ rm -rf ~/Work/meson-build-*
$ caffeinate bash ~/Downloads/meson-build-xpack.git/scripts/build.sh --develop --without-pdf --disable-tests --linux64 --linux32 --win64 --win32
```

To detach from the session, use `Ctrl-a` `Ctrl-d`; to reattach use
`screen -r meson-build`; to kill the session use `Ctrl-a` `Ctrl-k` and confirm.

About 16 minutes later, the output of the build script is a set of 4
archives and their SHA signatures, created in the `deploy` folder:

```console
$ cd ~/Work/meson-build-*/deploy
total 80596
-rw-rw-r-- 1 ilg ilg 19876980 Sep 30 11:32 xpack-meson-build-0.55.3-2-linux-x32.tar.gz
-rw-rw-r-- 1 ilg ilg      110 Sep 30 11:32 xpack-meson-build-0.55.3-2-linux-x32.tar.gz.sha
-rw-rw-r-- 1 ilg ilg 19697828 Sep 30 11:23 xpack-meson-build-0.55.3-2-linux-x64.tar.gz
-rw-rw-r-- 1 ilg ilg      110 Sep 30 11:23 xpack-meson-build-0.55.3-2-linux-x64.tar.gz.sha
-rw-rw-r-- 1 ilg ilg 20965024 Sep 30 11:33 xpack-meson-build-0.55.3-2-win32-x32.zip
-rw-rw-r-- 1 ilg ilg      107 Sep 30 11:33 xpack-meson-build-0.55.3-2-win32-x32.zip.sha
-rw-rw-r-- 1 ilg ilg 21964105 Sep 30 11:23 xpack-meson-build-0.55.3-2-win32-x64.zip
-rw-rw-r-- 1 ilg ilg      107 Sep 30 11:23 xpack-meson-build-0.55.3-2-win32-x64.zip.sha
```

To copy the files from the build machine to the current development
machine, either use NFS to mount the entire folder, or open the `deploy`
folder in a terminal and use `scp`:

```console
$ (cd ~/Work/meson-build-*/deploy; scp * ilg@wks:Downloads/xpack-binaries/meson)
```

#### Build the Arm GNU/Linux binaries

The current platform for Arm GNU/Linux production builds is a
Debian 9, running on an ROCK Pi 4 SBC with 4 GB of RAM
and 256 GB of fast M.2 SSD.

```console
$ ssh xbba
```

Before starting a build, check if Docker is started:

```console
$ docker info
```

Before running a build for the first time, it is recommended to preload the
docker images.

```console
$ bash ~/Downloads/meson-build-xpack.git/scripts/build.sh preload-images
```

The result should look similar to:

```console
$ docker images
REPOSITORY          TAG                                IMAGE ID            CREATED             SIZE
ilegeul/ubuntu      arm32v7-16.04-xbb-v3.2             b501ae18580a        27 hours ago        3.23GB
ilegeul/ubuntu      arm64v8-16.04-xbb-v3.2             db95609ffb69        37 hours ago        3.45GB
hello-world         latest                             a29f45ccde2a        5 months ago        9.14kB
```

Since the build takes a while, use `screen` to isolate the build session
from unexpected events, like a broken
network connection or a computer entering sleep.

```console
$ screen -S meson

$ sudo rm -rf ~/Work/meson-build-*
$ bash ~/Downloads/meson-build-xpack.git/scripts/build.sh --all
```

or, for development builds:

```console
$ rm -rf ~/Work/meson-build-*
$ caffeinate bash ~/Downloads/meson-build-xpack.git/scripts/build.sh --develop --without-pdf --disable-tests --arm32 --arm64
```

To detach from the session, use `Ctrl-a` `Ctrl-d`; to reattach use
`screen -r meson`; to kill the session use `Ctrl-a` `Ctrl-k` and confirm.

About 85 minutes later, the output of the build script is a set of 2
archives and their SHA signatures, created in the `deploy` folder:

```console
$ cd ~/Work/meson-build-*/deploy
total 37960
-rw-rw-r-- 1 ilg ilg 19644860 Sep 30 08:48 xpack-meson-build-0.55.3-2-linux-arm64.tar.gz
-rw-rw-r-- 1 ilg ilg      112 Sep 30 08:48 xpack-meson-build-0.55.3-2-linux-arm64.tar.gz.sha
-rw-rw-r-- 1 ilg ilg 19212119 Sep 30 09:40 xpack-meson-build-0.55.3-2-linux-arm.tar.gz
-rw-rw-r-- 1 ilg ilg      110 Sep 30 09:40 xpack-meson-build-0.55.3-2-linux-arm.tar.gz.sha
```

To copy the files from the build machine to the current development
machine, either use NFS to mount the entire folder, or open the `deploy`
folder in a terminal and use `scp`:

```console
$ (cd ~/Work/meson-build-*/deploy; scp * ilg@wks:Downloads/xpack-binaries/meson)
```

#### Build the macOS binary

The current platform for macOS production builds is a macOS 10.10.5
running on a MacBook Pro with 32 GB of RAM and a fast SSD.

```console
$ ssh xbbm
```

To build the latest macOS version:

```console
$ screen -S meson

$ rm -rf ~/Work/meson-build-*
$ caffeinate bash ~/Downloads/meson-build-xpack.git/scripts/build.sh --osx
```

or, for development builds:

```console
$ rm -rf ~/Work/meson-build-*
$ caffeinate bash ~/Downloads/meson-build-xpack.git/scripts/build.sh --develop --without-pdf --disable-tests --osx
```

To detach from the session, use `Ctrl-a` `Ctrl-d`; to reattach use
`screen -r meson`; to kill the session use `Ctrl-a` `Ctrl-\` or
`Ctrl-a` `Ctrl-k` and confirm.

About 15 minutes later, the output of the build script is a compressed
archive and its SHA signature, created in the `deploy` folder:

```console
$ cd ~/Work/meson-build-*/deploy
total 37416
-rw-r--r--  1 ilg  staff  19150231 Sep 30 11:30 xpack-meson-build-0.55.3-2-darwin-x64.tar.gz
-rw-r--r--  1 ilg  staff       111 Sep 30 11:30 xpack-meson-build-0.55.3-2-darwin-x64.tar.gz.sha
```

To copy the files from the build machine to the current development
machine, either use NFS to mount the entire folder, or open the `deploy`
folder in a terminal and use `scp`:

```console
$ (cd ~/Work/meson-build-*/deploy; scp * ilg@wks:Downloads/xpack-binaries/meson)
```

### Subsequent runs

#### Separate platform specific builds

Instead of `--all`, you can use any combination of:

```
--linux32 --linux64
--arm32 --arm64
--win32 --win64 
```

#### `clean`

To remove most build temporary files, use:

```console
$ bash ~/Downloads/meson-build-xpack.git/scripts/build.sh --all clean
```

To also remove the library build temporary files, use:

```console
$ bash ~/Downloads/meson-build-xpack.git/scripts/build.sh --all cleanlibs
```

To remove all temporary files, use:

```console
$ bash ~/Downloads/meson-build-xpack.git/scripts/build.sh --all cleanall
```

Instead of `--all`, any combination of `--win32 --win64 --linux32 --linux64`
will remove the more specific folders.

For production builds it is recommended to completely remove the build folder.

#### `--develop`

For performance reasons, the actual build folders are internal to each
Docker run, and are not persistent. This gives the best speed, but has
the disadvantage that interrupted builds cannot be resumed.

For development builds, it is possible to define the build folders in
the host file system, and resume an interrupted build.

#### `--debug`

For development builds, it is also possible to create everything with
`-g -O0` and be able to run debug sessions.

### --jobs

By default, the build steps use all available cores. If, for any reason,
parallel builds fail, it is possible to reduce the load.

#### Interrupted builds

The Docker scripts run with root privileges. This is generally not a
problem, since at the end of the script the output files are reassigned
to the actual user.

However, for an interrupted build, this step is skipped, and files in
the install folder will remain owned by root. Thus, before removing
the build folder, it might be necessary to run a recursive `chown`.

## Test

A simple test is performed by the script at the end, by launching the
executable to check if all shared/dynamic libraries are correctly used.

For a true test you need to unpack the archive in a temporary location
(like `~/Downloads`) and then run the
program from there. For example on macOS the output should
look like:

```console
$ /Users/ilg/Downloads/xPacks/meson-build/0.55.3-2/bin/meson --version
0.55.3
```

## Travis tests

A multi-platform validation test for all binary archives can be performed
using Travis CI.

For details please see `tests/scripts/README.md`.

## Installed folders

After install, the package should create a structure like this (macOS files;
only the first two depth levels are shown):

```console
$ tree -L 2 /Users/ilg/Library/xPacks/\@xpack-dev-tools/meson-build/0.55.3-2.1/.content/
/Users/ilg/Library/xPacks/@xpack-dev-tools/meson-build/0.55.3-2.1/.content/
├── README.md
├── bin
│   ├── libcrypt.2.dylib
│   ├── libgcc_s.1.dylib
│   ├── libpython3.8.dylib
│   └── meson
├── distro-info
│   ├── CHANGELOG.md
│   ├── licenses
│   ├── patches
│   └── scripts
└── lib
    └── python3.8

7 directories, 6 files
```

No other files are installed in any system folders or other locations.

## Uninstall

The binaries are distributed as portable archives; thus they do not need
to run a setup and do not require an uninstall; simply removing the
folder is enough.

## Files cache

The XBB build scripts use a local cache such that files are downloaded only
during the first run, later runs being able to use the cached files.

However, occasionally some servers may not be available, and the builds
may fail.

The workaround is to manually download the files from an alternate
location (like
https://github.com/xpack-dev-tools/files-cache/tree/master/libs),
place them in the XBB cache (`Work/cache`) and restart the build.

## More build details

The build process is split into several scripts. The build starts on
the host, with `build.sh`, which runs `container-build.sh` several
times, once for each target, in one of the two docker containers.
Both scripts include several other helper scripts. The entire process
is quite complex, and an attempt to explain its functionality in a few
words would not be realistic. Thus, the authoritative source of details
remains the source code.
