[![GitHub release (latest by date)](https://img.shields.io/github/v/release/xpack-dev-tools/meson-build-xpack)](https://github.com/xpack-dev-tools/meson-build-xpack/releases)
[![npm (scoped)](https://img.shields.io/npm/v/@xpack-dev-tools/meson-build.svg)](https://www.npmjs.com/package/@xpack-dev-tools/meson-build/)

# The xPack Meson Build

This open source project is hosted on GitHub as
[`xpack-dev-tools/meson-build-xpack`](https://github.com/xpack-dev-tools/meson-build-xpack)
and provides the platform specific binaries for the
[xPack Meson Build](https://xpack.github.io/meson-build/).

This distribution follows the official [Meson](https://mesonbuild.com) build system.

The binaries can be installed automatically as **binary xPacks** or manually as
**portable archives**.

In addition to the package meta data, this project also includes
the build scripts.

## User info

This section is intended as a shortcut for those who plan
to use the Meson Build binaries. For full details please read the
[xPack Meson Build](https://xpack.github.io/meson-build/) pages.

### Easy install

The easiest way to install Meson Build is using the **binary xPack**, available as
[`@xpack-dev-tools/meson-build`](https://www.npmjs.com/package/@xpack-dev-tools/meson-build)
from the [`npmjs.com`](https://www.npmjs.com) registry.

#### Prerequisites

The only requirement is a recent
`xpm`, which is a portable
[Node.js](https://nodejs.org) command line application. To install it,
follow the instructions from the
[xpm](https://xpack.github.io/xpm/install/) page.

#### Install

With the `xpm` tool available, installing
the latest version of the package is quite easy:

```sh
cd my-project
xpm init # Only at first use.

xpm install @xpack-dev-tools/meson-build@latest

ls -l xpacks/.bin
```

This command will:

- install the latest available version,
into the central xPacks store, if not already there
- add symbolic links (`.cmd` forwarders on Windows) into
the local `xpacks/.bin` folder to the central store

The central xPacks store is a platform dependent
folder; check the output of the `xpm` command for the actual
folder used on your platform).
This location is configurable via the environment variable
`XPACKS_REPO_FOLDER`; for more details please check the
[xpm folders](https://xpack.github.io/xpm/folders/) page.

It is also possible to install Meson Build globally, in the user home folder:

```sh
xpm install --global @xpack-dev-tools/meson-build@latest
```

#### Uninstall

To remove the links from the current project:

```sh
cd my-project

xpm uninstall @xpack-dev-tools/meson-build
```

To completely remove the package from the global store: 

```sh
xpm uninstall --global @xpack-dev-tools/meson-build
```

### Manual install

For all platforms, the **xPack Meson Build** binaries are released as portable
archives that can be installed in any location.

The archives can be downloaded from the
GitHub [releases](https://github.com/xpack-dev-tools/meson-build-xpack/releases/)
page.

For more details please read the
[Install](https://xpack.github.io/meson-build/install/) page.

### Version information

The version strings used by the Meson project are three number string
like `0.55.3`; to this string the xPack distribution adds a four number,
but since semver allows only three numbers, all additional ones can
be added only as pre-release strings, separated by a dash,
like `0.55.3-1`. When published as a npm package, the version gets
a fifth number, like `0.55.3-1.1`.

Since adherance of third party packages to semver is not guaranteed,
it is recommended to use semver expressions like `^0.55.3` and `~0.55.3`
with caution, and prefer exact matches, like `0.55.3-1.1`.

## Maintainer info

- [How to build](https://github.com/xpack-dev-tools/meson-build-xpack/blob/xpack/README-BUILD.md)
- [How to make new releases](https://github.com/xpack-dev-tools/meson-build-xpack/blob/xpack/README-RELEASE.md)

## Support

The quick answer is to use the
[xPack forums](https://www.tapatalk.com/groups/xpack/);
please select the correct forum.

For more details please read the
[Support](https://xpack.github.io/meson-build/support/) page.

## License

The original content is released under the
[MIT License](https://opensource.org/licenses/MIT), with all rights
reserved to [Liviu Ionescu](https://github.com/ilg-ul).

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
