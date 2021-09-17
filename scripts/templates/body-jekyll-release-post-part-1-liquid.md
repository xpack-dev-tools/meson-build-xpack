---
title:  xPack Meson Build {{ RELEASE_VERSION }} released

TODO: select one summary

summary: "Version {{ RELEASE_VERSION }} is a maintenance release; it fixes <...>."

summary: "Version {{ RELEASE_VERSION }} is a new release; it follows the upstream release."

version: {{ RELEASE_VERSION }}
npm_subversion: 1
download_url: https://github.com/xpack-dev-tools/meson-build-xpack/releases/tag/v{{ RELEASE_VERSION }}/

date:   {{ RELEASE_DATE }}

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

[The xPack Meson Build](https://xpack.github.io/meson-build/)
is a standalone cross-platform binary distribution of
[Meson Build](http://meson-build.org).

There are separate binaries for **Windows** (Intel 32/64-bit),
**macOS** (Intel 64-bit) and **GNU/Linux** (Intel 32/64-bit, Arm 32/64-bit).

{% raw %}{% include note.html content="The main targets for the Arm binaries
are the **Raspberry Pi** class devices." %}{% endraw %}

## Download

The binary files are available from GitHub [releases]({% raw %}{{ page.download_url }}{% endraw %}).

## Install

The full details of installing the **xPack Meson Build** on various platforms
are presented in the separate
[Install]({% raw %}{{ site.baseurl }}{% endraw %}/meson-build/install/) page.

### Easy install

The easiest way to install Meson Build is with
[`xpm`]({% raw %}{{ site.baseurl }}{% endraw %}/xpm/)
by using the **binary xPack**, available as
[`@xpack-dev-tools/meson-build`](https://www.npmjs.com/package/@xpack-dev-tools/meson-build)
from the [`npmjs.com`](https://www.npmjs.com) registry.

With the `xpm` tool available, installing
the latest version of the package and adding it as
a dependency for a project is quite easy:

```sh
cd my-project
xpm init # Only at first use.

xpm install @xpack-dev-tools/meson-build@latest

ls -l xpacks/.bin
```

To install this specific version, use:

```sh
xpm install @xpack-dev-tools/meson-build@{% raw %}{{ page.version }}.{{ page.npm_subversion }}{% endraw %}
```

It is also possible to install Meson Build globally, in the user home folder,
but this requires xPack aware tools to automatically identify them and
manage paths.

```sh
xpm install --global @xpack-dev-tools/meson-build@latest
```

### Uninstall

To remove the links from the current project:

```sh
cd my-project

xpm uninstall @xpack-dev-tools/meson-build
```

To completely remove the package from the global store:

```sh
xpm uninstall --global @xpack-dev-tools/meson-build
```

## Compliance

The xPack Meson Build generally follows the official
[Meson Build](http://meson-build.org) releases.

The current version is based on:

TODO: update commit id and date.

- Meson Build release 0.11.0
[<xxxxxxx>](https://github.com/mesonbuild/meson/releases/tag/<xxxxxxxxxxxxx>)
from <ddddddddd>.

## Changes

Compared to the upstream version, there are no functional changes.

## Bug fixes

- none

## Enhancements

- none

## Known problems

- none

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

## Shared libraries

On all platforms the packages are standalone, and expect only the standard
runtime to be present on the host.

All dependencies that are build as shared libraries are copied locally
in the `libexec` folder (or in the same folder as the executable for Windows).

### `DT_RPATH` and `LD_LIBRARY_PATH`

On GNU/Linux the binaries are adjusted to use a relative path:

```console
$ readelf -d library.so | grep runpath
 0x000000000000001d (RPATH)            Library rpath: [$ORIGIN]
```

In the GNU ld.so search strategy, the `DT_RPATH` has
the highest priority, higher than `LD_LIBRARY_PATH`, so if this later one
is set in the environment, it should not interfere with the xPack binaries.

Please note that previous versions, up to mid-2020, used `DT_RUNPATH`, which
has a priority lower than `LD_LIBRARY_PATH`, and does not tolerate setting
it in the environment.

### `@executable_path`

Similarly, on macOS, the dynamic libraries are adjusted with `otool` to use a
relative path.

## Documentation

The original documentation is available from:

- [https://mesonbuild.com/Manual.html](https://mesonbuild.com/Manual.html)

## Supported platforms

Binaries for **Windows**, **macOS** and **Intel/Arm GNU/Linux** are provided.

The binaries were built using the
[xPack Build Box (XBB)](https://github.com/xpack/xpack-build-box), a set
of build environments based on slightly older distributions, that should be
compatible with most recent systems.

- Intel GNU/Linux: all binaries were built with GCC 9.4, running in an
  Ubuntu 12 Docker container
- Arm GNU/Linux: all binaries were built with GCC 9.4, running in an
  Ubuntu 16 Docker container (added in mid-2020)
- Windows: all binaries were built with mingw-w64 GCC 9.4, running in an
  Ubuntu 12 Docker container
- macOS: all binaries were built with GCC 11.1, running in a separate
  folder on macOS 10.13.6, but were tested and also run on 10.10.

## Build

The scripts used to build this distribution are in:

- `distro-info/scripts`

For the prerequisites and more details on the build procedure, please see the
[How to build](https://github.com/xpack-dev-tools/meson-build-xpack/blob/xpack/README-BUILD.md) page.

## CI tests

Before publishing, a set of simple tests were performed on an exhaustive
set of platforms. The results are available from:

- [GitHub Actions](https://github.com/xpack-dev-tools/meson-build-xpack/actions/)
- [travis-ci.com](https://app.travis-ci.com/github/xpack-dev-tools/meson-build-xpack/builds/)

## Checksums

The SHA-256 hashes for the files are:
