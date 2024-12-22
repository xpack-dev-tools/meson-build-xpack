---

title:  xPack Meson Build v0.56.2-2 released
sidebar: meson-build

summary: "Version **0.56.2-2** is a maintenance release of the **xPack Meson Build** package, intended to fix the macOS starting bug."

version: 0.56.2-2
npm_subversion: 1

download_url: https://github.com/xpack-dev-tools/meson-build-xpack/releases/tag/v0.56.2-2/

date: 2021-04-27 14:57:00 +0300

redirect_to: https://xpack-dev-tools.github.io/meson-build-xpack/blog/2021/04/27/meson-build-v0-56-2-2-released/

comments: true

categories:
  - releases
  - meson-build

tags:
  - releases
  - meson-build
  - meson
  - build
  - python
  - ninja

---

The [xPack Meson Build](https://xpack.github.io/dev-tools/meson-build/)
is the **xPack** distribution of the
[Meson](https://mesonbuild.com) build system.

There are separate binaries for **Windows** (x64 and x86),
**macOS** (x64) and **GNU/Linux** (x64 and x86, arm64 and arm).

{% include note.html content="The main targets for the GNU/Linux Arm
binaries are the **Raspberry Pi** class devices (armv7l and aarch64;
armv6 is not supported)." %}

## Download

The binary files are available from [GitHub Releases]({{ page.download_url }}).

## Install

The full details of installing the **xPack Meson Build** on various platforms
are presented in the separate [Install]({{ site.baseurl }}/dev-tools/meson-build/install/) page.

### Easy install

The easiest way to install Meson Build is with
[`xpm`]({{ site.baseurl }}/xpm/)
by using the **binary xPack**, available as
[`@xpack-dev-tools/meson-build`](https://www.npmjs.com/package/@xpack-dev-tools/meson-build)
from the [`npmjs.com`](https://www.npmjs.com) registry.

To install the latest version available, use:

```sh
xpm install --global @xpack-dev-tools/meson-build@latest --verbose
```

To install this specific version, use:

```sh
xpm install --global @xpack-dev-tools/meson-build@{{ page.version }}.{{ page.npm_subversion }}
```

## Compliance

The **xPack Meson Build** is based on the official
[Meson](https://mesonbuild.com) build system,
without any changes.

The current version is based on:

- Meson release
[0.56.2](https://github.com/mesonbuild/meson/releases/tag/0.56.2)
from Jan 10th, 2021.

## Bug fixes

- [#3] on macOS, the binary did not identify the executable
  absolute path correctly and failed to start; the logic was
  changed to use `proc_pidpath()` and the bug was fixed.

## Enhancements

- none

## Changes

Compared to the upstream version, there are no functional changes.

## Embedded Python

To simplify dependency management, this release embeds a Python
3.8.6 instance.

The `meson` executable is a standard ELF/EXE which includes the Python
run-time; the `main()` function prepares the Python environment and then
invokes the Meson main:

```python
  PyRun_SimpleString("from mesonbuild import mesonmain\n");
  PyRun_SimpleString("sys.exit(mesonmain.main())\n");
```

The Python library is located in the standard location:

- `lib/python3.8`
- `lib/python3.8/lib-dynload` (the platform dependent files)

The Meson files are located in:

- `lib/python3.8/mesonbuild`

To speed up execution, all Python files are compiled and are
available only as `.pyc`.

## Known problems

- none

## Shared libraries

On all platforms the packages are standalone, and expect only the standard
runtime to be present on the host.

All dependencies that are build as shared libraries are copied locally in the
same folder as the executable.

### `DT_RPATH` and `LD_LIBRARY_PATH`

On GNU/Linux the binaries are adjusted to use a relative path:

```console
$ readelf -d library.so | grep runpath
 0x000000000000001d (RPATH)            Library rpath: [$ORIGIN]
```

In the GNU ld.so search strategy, the `DT_RPATH` has
the highest priority, higher than `LD_LIBRARY_PATH`, so if this later one
is set in the environment, it should not interfere with the xPack binaries.

### `@executable_path`

Similarly, on macOS, the binaries are adjusted with `otool` to use a
relative path.

## Documentation

The original documentation is available from:

- [https://mesonbuild.com/Manual.html](https://mesonbuild.com/Manual.html)

## Supported platforms

Binaries for **Windows**, **macOS** and **GNU/Linux** are provided.

The binaries were built using the
[xPack Build Box (XBB)](https://github.com/xpack/xpack-build-box), a set
of build environments based on slightly older distributions, that should be
compatible with most recent systems.

- x86/x64 GNU/Linux: all binaries were built with GCC 9.3, running in an
  Ubuntu 12 Docker container
- arm64/arm GNU/Linux: all binaries were built with GCC 9.3, running in an
  Ubuntu 16 Docker container (added in mid-2020)
- x86/x64 Windows: all binaries were built with mingw-w64 GCC 9.3, running in an
  Ubuntu 12 Docker container
- x64 macOS: all binaries were built with GCC 9.3, running in a separate
  folder on macOS 10.10.5.

## Build

The scripts used to build this distribution are in:

- `distro-info/scripts`

For the prerequisites and more details on the build procedure, please see the
[README-MAINTAINER](https://github.com/xpack-dev-tools/meson-build-xpack/blob/xpack/README-MAINTAINER.md) page.

## Travis tests

The first set of tests were performed on Travis, by running
a simple script to check if the binaries start on a wide range of
platforms and distributions:

- [test xPack Meson Build on stable platforms](https://travis-ci.com/github/xpack-dev-tools/meson-build-xpack/builds/224217626)
- [test xPack Meson Build on latest platforms](https://travis-ci.com/github/xpack-dev-tools/meson-build-xpack/builds/224217632)

## Tests

TBD

## Checksums

The SHA-256 hashes for the files are:

```txt
61739c5dc93d61205cc40a49d604caebad71c9889ea356fa15d022831385c155
xpack-meson-build-0.56.2-2-darwin-x64.tar.gz

157a890caa5badf8a40d530f50571822a0b45227d115f53a1ddc8dc8ce64068b
xpack-meson-build-0.56.2-2-linux-arm64.tar.gz

90307812e56ccfa8a3ed63e99be157af8f757c1a3f3018218d032e48a7709762
xpack-meson-build-0.56.2-2-linux-arm.tar.gz

1840280797bc046a49cb6c7e9379be8404d00aa000b00ae73a1bfd8f9bea4200
xpack-meson-build-0.56.2-2-linux-ia32.tar.gz

4f81cb5c18b41e5d8b78f78c5570f908d2030e7a2cbcdeb0b72c9e744449164b
xpack-meson-build-0.56.2-2-linux-x64.tar.gz

f7b78b7f286db6e4bf700b88b9f4d2756507bee0c7fd26e9b4d9a552f3b4b3af
xpack-meson-build-0.56.2-2-win32-ia32.zip

bf0fec9f84997910994e391a6695967fec1a6781f7055206d3e557e47b0fb5d2
xpack-meson-build-0.56.2-2-win32-x64.zip
```

## Download analytics

- GitHub [xpack-dev-tools/meson-build-xpack](https://github.com/xpack-dev-tools/meson-build-xpack/)
  - this release [![Github All Releases](https://img.shields.io/github/downloads/xpack-dev-tools/meson-build-xpack/v{{ page.version }}/total.svg)](https://github.com/xpack-dev-tools/meson-build-xpack/releases/v{{ page.version }}/)
  - all xPack releases [![Github All Releases](https://img.shields.io/github/downloads/xpack-dev-tools/meson-build-xpack/total.svg)](https://github.com/xpack-dev-tools/meson-build-xpack/releases/)
  - [individual file counters](https://somsubhra.github.io/github-release-stats/?username=xpack-dev-tools&repository=meson-build-xpack) (grouped per release)
- npmjs.com [@xpack-dev-tools/meson-build](https://www.npmjs.com/package/@xpack-dev-tools/meson-build)
  - latest releases [![npm](https://img.shields.io/npm/dw/@xpack-dev-tools/meson-build.svg)](https://www.npmjs.com/package/@xpack-dev-tools/meson-build/)
  - all @xpack-dev-tools releases [![npm](https://img.shields.io/npm/dt/@xpack-dev-tools/meson-build.svg)](https://www.npmjs.com/package/@xpack-dev-tools/meson-build/)

Credit to [Shields IO](https://shields.io) for the badges and to
[Somsubhra/github-release-stats](https://github.com/Somsubhra/github-release-stats)
for the individual file counters.
