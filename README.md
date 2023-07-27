[![GitHub package.json version](https://img.shields.io/github/package-json/v/xpack-dev-tools/meson-build-xpack)](https://github.com/xpack-dev-tools/meson-build-xpack/blob/xpack/package.json)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/xpack-dev-tools/meson-build-xpack)](https://github.com/xpack-dev-tools/meson-build-xpack/releases/)
[![npm (scoped)](https://img.shields.io/npm/v/@xpack-dev-tools/meson-build.svg?color=blue)](https://www.npmjs.com/package/@xpack-dev-tools/meson-build/)
[![license](https://img.shields.io/github/license/xpack-dev-tools/meson-build-xpack)](https://github.com/xpack-dev-tools/meson-build-xpack/blob/xpack/LICENSE)

# The xPack Meson Build

A standalone cross-platform (Windows/macOS/Linux) **Meson Build**
binary distribution, intended for reproducible builds.

To simplify dependency management, the `meson` executable is a
standard ELF/EXE which includes the Python run-time; all Python
files are compiled and are available only as `.pyc`.

In addition to the the binary archives and the package meta data,
this project also includes the build scripts.

## Overview

This open source project is hosted on GitHub as
[`xpack-dev-tools/meson-build-xpack`](https://github.com/xpack-dev-tools/meson-build-xpack)
and provides the platform specific binaries for the
[xPack Meson Build](https://xpack.github.io/meson-build/).

This distribution follows the official [Meson](https://mesonbuild.com) build system.

The binaries can be installed automatically as **binary xPacks** or manually as
**portable archives**.

## Release schedule

This distribution is generally one minor release behind the upstream releases.
In practical terms, when the minor release number changes, it awaits a few
more weeks to get the latest patch release.

## User info

This section is intended as a shortcut for those who plan
to use the Meson Build binaries. For full details please read the
[xPack Meson Build](https://xpack.github.io/meson-build/) pages.

### Easy install

The easiest way to install Meson Build is using the **binary xPack**, available as
[`@xpack-dev-tools/meson-build`](https://www.npmjs.com/package/@xpack-dev-tools/meson-build)
from the [`npmjs.com`](https://www.npmjs.com) registry.

#### Prerequisites

A recent [xpm](https://xpack.github.io/xpm/),
which is a portable [Node.js](https://nodejs.org/) command line application
that complements [npm](https://docs.npmjs.com)
with several extra features specific to
**C/C++ projects**.

It is recommended to install/update to the latest version with:

```sh
npm install --location=global xpm@latest
```

For details please follow the instructions in the
[xPack install](https://xpack.github.io/install/) page.

#### Install

With the `xpm` tool available, installing
the latest version of the package and adding it as
a development dependency for a project is quite easy:

```sh
cd my-project
xpm init # Add a package.json if not already present

xpm install @xpack-dev-tools/meson-build@latest --verbose

ls -l xpacks/.bin
```

This command will:

- install the latest available version,
into the central xPacks store, if not already there
- add symbolic links (`.cmd` forwarders on Windows) into
the local `xpacks/.bin` folder to the central store

The central xPacks store is a platform dependent
location in the home folder;
check the output of the `xpm` command for the actual
folder used on your platform.
This location is configurable via the environment variable
`XPACKS_STORE_FOLDER`; for more details please check the
[xpm folders](https://xpack.github.io/xpm/folders/) page.

It is also possible to install Meson Build globally, in the user home folder:

```sh
xpm install --global @xpack-dev-tools/meson-build@latest --verbose
```

After install, the package should create a structure like this (macOS files;
only the first two depth levels are shown):

```console
$ tree -L 2 /Users/ilg/Library/xPacks/\@xpack-dev-tools/meson-build/0.64.1-1.1/.content/
/Users/ilg/Library/xPacks/\@xpack-dev-tools/meson-build/0.64.1-1.1/.content/
├── README.md
├── bin
│   └── meson
├── distro-info
│   ├── CHANGELOG.md
│   ├── licenses
│   ├── patches
│   └── scripts
├── lib
│   └── python3.10
└── libexec
    ├── libbz2.1.0.8.dylib
    ├── libcrypt.2.dylib
    ├── libcrypto.1.1.dylib
    ├── libexpat.1.8.10.dylib
    ├── libexpat.1.dylib -> libexpat.1.8.10.dylib
    ├── libffi.8.dylib
    ├── liblzma.5.dylib
    ├── libncurses.6.dylib
    ├── libpanel.6.dylib
    ├── libpython3.10.dylib
    ├── libreadline.8.2.dylib
    ├── libreadline.8.dylib -> libreadline.8.2.dylib
    ├── libsqlite3.0.dylib
    ├── libssl.1.1.dylib
    ├── libz.1.2.13.dylib
    └── libz.1.dylib -> libz.1.2.12.dylib

8 directories, 19 files
```

No other files are installed in any system folders or other locations.

#### Uninstall

To remove the links created by xpm in the current project:

```sh
cd my-project

xpm uninstall @xpack-dev-tools/meson-build
```

To completely remove the package from the central xPack store:

```sh
xpm uninstall --global @xpack-dev-tools/meson-build
```

After install, the package should create a structure like this (macOS files;
only the first two depth levels are shown):

### Manual install

For all platforms, the **xPack Meson Build**
binaries are released as portable
archives that can be installed in any location.

The archives can be downloaded from the
GitHub [Releases](https://github.com/xpack-dev-tools/meson-build-xpack/releases/)
page.

For more details please read the
[Install](https://xpack.github.io/meson-build/install/) page.

### Version information

The version strings used by the Meson project are three number strings
like `0.64.1`; to this string the xPack distribution adds a four number,
but since semver allows only three numbers, all additional ones can
be added only as pre-release strings, separated by a dash,
like `0.64.1-1`. When published as a npm package, the version gets
a fifth number, like `0.64.1-1.1`.

Since adherence of third party packages to semver is not guaranteed,
it is recommended to use semver expressions like `^0.64.1` and `~0.64.1`
with caution, and prefer exact matches, like `0.64.1-1.1`.

## Maintainer info

For maintainer info, please see the
[README-MAINTAINER](https://github.com/xpack-dev-tools/meson-build-xpack/blob/xpack/README-MAINTAINER.md).

## Support

The quick advice for getting support is to use the GitHub
[Discussions](https://github.com/xpack-dev-tools/meson-build-xpack/discussions/).

For more details please read the
[Support](https://xpack.github.io/meson-build/support/) page.

## License

Unless otherwise stated, the content is released under the terms of the
[MIT License](https://opensource.org/licenses/mit/),
with all rights reserved to
[Liviu Ionescu](https://github.com/ilg-ul).

The binary distributions include several open-source components; the
corresponding licenses are available in the installed
`distro-info/licenses` folder.

## Download analytics

- GitHub [`xpack-dev-tools/meson-build-xpack`](https://github.com/xpack-dev-tools/meson-build-xpack/) repo
  - latest xPack release
[![Github All Releases](https://img.shields.io/github/downloads/xpack-dev-tools/meson-build-xpack/latest/total.svg)](https://github.com/xpack-dev-tools/meson-build-xpack/releases/)
  - all xPack releases [![Github All Releases](https://img.shields.io/github/downloads/xpack-dev-tools/meson-build-xpack/total.svg)](https://github.com/xpack-dev-tools/meson-build-xpack/releases/)
  - [individual file counters](https://somsubhra.github.io/github-release-stats/?username=xpack-dev-tools&repository=meson-build-xpack) (grouped per release)
- npmjs.com [`@xpack-dev-tools/meson-build`](https://www.npmjs.com/package/@xpack-dev-tools/meson-build/) xPack
  - latest release, per month
[![npm (scoped)](https://img.shields.io/npm/v/@xpack-dev-tools/meson-build.svg)](https://www.npmjs.com/package/@xpack-dev-tools/meson-build/)
[![npm](https://img.shields.io/npm/dm/@xpack-dev-tools/meson-build.svg)](https://www.npmjs.com/package/@xpack-dev-tools/meson-build/)
  - all releases [![npm](https://img.shields.io/npm/dt/@xpack-dev-tools/meson-build.svg)](https://www.npmjs.com/package/@xpack-dev-tools/meson-build/)

Credit to [Shields IO](https://shields.io) for the badges and to
[Somsubhra/github-release-stats](https://github.com/Somsubhra/github-release-stats)
for the individual file counters.
