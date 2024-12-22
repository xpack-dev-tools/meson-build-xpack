---

title: How to install the xPack Meson Build binaries
permalink: /dev-tools/meson-build/install/

summary: "The recommended method is via xpm."

version: "0.60.3"
xpack-subversion: "1"

comments: true
toc: false

date: 2020-09-27 11:09:00 +0300

redirect_to: https://xpack-dev-tools.github.io/meson-build-xpack/docs/install/

---

## Overview

The **xPack Meson Build** can be installed automatically, via `xpm` (the
recommended method), or manually, by downloading and unpacking one of the
portable archives.

{% capture easy_install %}

## Easy install

The easiest way to install Meson is by using the **binary xPack**, available as
[`@xpack-dev-tools/meson-build`](https://www.npmjs.com/package/@xpack-dev-tools/meson-build)
from the [`npmjs.com`](https://www.npmjs.com) registry.

### Prerequisites

The only requirement is a recent
xpm, which is a portable
[Node.js](https://nodejs.org) command line application. To install it,
follow the instructions from the
[xpm install]({{ site.baseurl }}/xpm/install/) page.

### Install

With xpm available, installing
the latest version of the package is quite easy:

```sh
cd my-project
xpm init # Only at first use.

xpm install @xpack-dev-tools/meson-build@latest --verbose
```

This command will always install the latest available version,
in the global xPacks store, which is a platform dependent folder
(check the output of the `xpm` command for the actual folder used on
your platform).

{% capture include_1 %}
The install location can be configured using the
`XPACKS_STORE_FOLDER` environment variable; for more details please check the
[xpm folders]({{ site.baseurl }}/xpm/folders/) page.
{% endcapture %}

{% include tip.html content=include_1 %}

{% include tip.html content="The archive content is unpacked into a folder
named `.content`. On some platforms
this might be hidden for normal browsing, and require
separate options (like `ls -A`) or, in file browsers, to enable
settings like **Show Hidden Files**." %}

### Uninstall

To remove the links from the current project:

```sh
cd my-project

xpm uninstall @xpack-dev-tools/meson-build
```

To completely remove the package from the central xPacks store:

```sh
xpm uninstall --global @xpack-dev-tools/meson-build --verbose
```

{% endcapture %}

{% capture manual_install %}

## Manual install

For all platforms, the **xPack Meson Build** binaries are released as portable
archives that can be installed in any location.

The archives can be downloaded from the
GitHub [releases](https://github.com/xpack-dev-tools/meson-build-xpack/releases/)
page.

{% endcapture %}

{% capture windows %}

{{ easy_install }}

### Test

To check if the xpm installed Meson starts, use something like:

```doscon
C:\>%USERPROFILE%\AppData\Roaming\xPacks\@xpack-dev-tools\{{ page.version }}-{{ page.xpack-subversion }}.1\.content\bin\meson.exe --version
{{ page.version }}
```

{{ manual_install }}

### Download

The Windows versions of **xPack Meson Build**
are packed as ZIP files.
Download the latest version named like:

- `xpack-meson-build-{{ page.version }}-{{ page.xpack-subversion }}-win32-x64.zip`

{% include note.html content="In case you wonder where the suffix comes
from, it is exactly the Node.js `process.platform` and `process.arch`.
The `win32` part is confusing, but we have to live with it." %}

### Unpack

To manually install the xPack Meson Build,
unpack the archive and copy it into the
`%USERPROFILE%\AppData\Roaming\xPacks\meson-build`
(for example `C:\Users\ilg\AppData\Roaming\xPacks\meson-build`) folder;
according to Microsoft, `AppData\Roaming` is the recommended location for
installing user specific packages.

{% include note.html content="For manual installs, the recommended
install location is slightly different from the xpm install folders,
which use the scope (like `@xpack-dev-tools`) to group different tools,
and `.content` to store the unpacked archive." %}

### Test

To check if the manually installed Meson starts, use something like:

```doscon
C:\>%USERPROFILE%\AppData\Roaming\xPacks\meson-build\xpack-meson-{{ page.version }}-{{ page.xpack-subversion }}\bin\meson.exe --version
{{ page.version }}
```

{% endcapture %}

{% capture macos %}

{{ easy_install }}

### Test

To check if the xpm installed Meson starts, use something like:

```console
$ ~/.local/xPacks/@xpack-dev-tools/meson-build/{{ page.version }}-{{ page.xpack-subversion }}.1/.content/bin/meson --version
{{ page.version }}
```

{{ manual_install }}

### Download

The macOS versions of **xPack Meson Build**
are packed as `.tar.gz` archives.
Download the latest version named like:

- `xpack-meson-build-{{ page.version }}-{{ page.xpack-subversion }}-darwin-x64.tar.gz`
- `xpack-meson-build-{{ page.version }}-{{ page.xpack-subversion }}-darwin-arm64.tar.gz`

### Unpack

To manually install the xPack Meson Build,
unpack the archive and copy it to
`~/.local/xPacks/meson-build/xpack-meson-build-{{ page.version }}-{{ page.xpack-subversion }}`:

```sh
mkdir -p ~/.local/xPacks/meson-build
cd ~/.local/xPacks/meson-build

tar xvf ~/Downloads/xpack-meson-build-{{ page.version }}-{{ page.xpack-subversion }}-darwin-x64.tar.gz
chmod -R -w xpack-meson-build-{{ page.version }}-{{ page.xpack-subversion }}
```

{% include note.html content="For manual installs, the recommended
install location is different from the xpm install folders." %}

The result is a structure like:

```console
$ tree -L 2 /Users/ilg/.local/xPacks/meson-build/xpack-meson-build-{{ page.version }}-{{ page.xpack-subversion }}
/Users/ilg/.local/xPacks/meson-build/xpack-meson-build-{{ page.version }}-{{ page.xpack-subversion }}/
├── README.md
├── bin
│   └── meson
├── distro-info
│   ├── CHANGELOG.md
│   ├── licenses
│   ├── patches
│   └── scripts
├── lib
│   └── python3.10
└── libexec
    ├── libcrypt.2.dylib
    ├── libcrypto.1.1.dylib
    ├── libffi.8.dylib
    ├── libgcc_s.1.dylib
    ├── liblzma.5.dylib
    ├── libncurses.6.dylib
    ├── libpanel.6.dylib
    ├── libpython3.10.dylib
    ├── libreadline.8.1.dylib
    ├── libreadline.8.dylib -> libreadline.8.1.dylib
    ├── libsqlite3.0.dylib
    ├── libssl.1.1.dylib
    ├── libz.1.2.11.dylib
    └── libz.1.dylib -> libz.1.2.11.dylib

8 directories, 17 files
```

### Test

To check if the manually installed Meson starts, use something like:

```console
$ ~/.local/xPacks/meson-build/xpack-meson-build-{{ page.version }}-{{ page.xpack-subversion }}/bin/meson --version
{{ page.version }}
```

{% endcapture %}

{% capture linux %}

{{ easy_install }}

### Test

To check if the xpm installed Meson starts, use something like:

```console
$ ~/.local/xPacks/@xpack-dev-tools/meson-build/{{ page.version }}-{{ page.xpack-subversion }}.1/.content/bin/meson --version
{{ page.version }}
```

{{ manual_install }}

### Download

The GNU/Linux versions of **xPack Meson Build**
are packed as `.tar.gz` archives.
Download the latest version named like:

- `xpack-meson-build-{{ page.version }}-{{ page.xpack-subversion }}-linux-x64.tar.gz`
- `xpack-meson-build-{{ page.version }}-{{ page.xpack-subversion }}-linux-arm.tar.gz`
- `xpack-meson-build-{{ page.version }}-{{ page.xpack-subversion }}-linux-arm64.tar.gz`

As the name implies, these are GNU/Linux `tar.gz` archives; they were build on
Ubuntu, but can be executed on most recent GNU/Linux distributions.

### Unpack

To manually install the xPack Meson Build,
unpack the archive and move it to
`~/.local/xPacks/meson-build/xpack-meson-build-{{ page.version }}-{{ page.xpack-subversion }}`:

```sh
mkdir -p ~/.local/xPacks/meson-build
cd ~/.local/xPacks/meson-build

tar xvf ~/Downloads/xpack-meson-build-{{ page.version }}-{{ page.xpack-subversion }}-linux-x64.tar.gz
chmod -R -w xpack-meson-build-{{ page.version }}-{{ page.xpack-subversion }}
```

{% include note.html content="For manual installs, the recommended
install location is slightly different from the xpm install folders,
which use the scope (like `@xpack-dev-tools`) to group different tools,
and `.content` to store the unpacked archive." %}

```console
$ tree -L 2 '/home/ilg/.local/xPacks/meson-build/xpack-meson-build-{{ page.version }}-{{ page.xpack-subversion }}'
/home/ilg/.local/xPacks/meson-build/xpack-meson-build-{{ page.version }}-{{ page.xpack-subversion }}/
├── bin
│   └── meson
├── distro-info
│   ├── CHANGELOG.md
│   ├── licenses
│   ├── patches
│   └── scripts
├── lib
│   └── python3.10
├── libexec
│   ├── libcrypto.so.1.1
│   ├── libcrypt.so.1 -> libcrypt.so.1.1.0
│   ├── libcrypt.so.1.1.0
│   ├── libffi.so.8 -> libffi.so.8.1.0
│   ├── libffi.so.8.1.0
│   ├── liblzma.so.5 -> liblzma.so.5.2.5
│   ├── liblzma.so.5.2.5
│   ├── libncurses.so.6 -> libncurses.so.6.3
│   ├── libncurses.so.6.3
│   ├── libpanel.so.6 -> libpanel.so.6.3
│   ├── libpanel.so.6.3
│   ├── libpython3.10.so.1.0
│   ├── libreadline.so.8 -> libreadline.so.8.1
│   ├── libreadline.so.8.1
│   ├── libsqlite3.so.0 -> libsqlite3.so.0.8.6
│   ├── libsqlite3.so.0.8.6
│   ├── libssl.so.1.1
│   ├── libz.so.1 -> libz.so.1.2.11
│   └── libz.so.1.2.11
└── README.md

8 directories, 22 files
```

### Test

To check if the manually installed Meson starts, use something like:

```console
$ ~/.local/xPacks/meson-build/xpack-meson-build-{{ page.version }}-{{ page.xpack-subversion }}/bin/meson --version
{{ page.version }}
```

{% endcapture %}

{% include platform-tabs.html %}

## Testing

TODO
