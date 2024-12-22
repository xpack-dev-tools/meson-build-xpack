---

title: The xPack Meson Build
permalink: /dev-tools/meson-build/

summary: "A binary distribution of Meson Build."

keywords: meson-build

comments: true

date: 2020-09-27 10:58:00 +0300

redirect_to: https://xpack-dev-tools.github.io/meson-build-xpack/

---

## Quicklinks

If you already know the general facts about the xPack Meson Build, you can
directly skip to the desired pages.

User pages:

- [install]({{ site.baseurl }}/meson-build/install/)
- [support]({{ site.baseurl }}/meson-build/support/)
- [releases]({{ site.baseurl }}/meson-build/releases/)

Developer & maintainer pages:

- [GitHub](https://github.com/xpack-dev-tools/meson-build-xpack/)
- [README-MAINTAINER](https://github.com/xpack-dev-tools/meson-build-xpack/blob/xpack/README-MAINTAINER.md)

## Overview

The **xPack Meson Build** is a cross-platform binary distribution of
[Meson](https://mesonbuild.com), **The Meson Build system**,
an open source project hosted on
[GitHub](https://github.com/mesonbuild/meson/).

The Meson project is written in Python. To simplify dependencies management,
the xPack Meson Build embeds a Python3 instance.

## Benefits

The main advantages of using the **xPack Meson Build** are:

- a convenient, uniform and portable install/uninstall/upgrade procedure,
  the same procedure is used for all major
  platforms (Intel Windows 64-bit, Intel GNU/Linux 64-bit, Arm GNU/Linux
  64/32-bit, Intel macOS 64-bit, Apple Silicon macOS 64-bit)
- a better integration with development environments
- a more convenient integration with CI environment

All binaries are self-contained, they include all required libraries,
and can be installed in any location.

## Compatibility

The **xPack Meson Build** is fully compatible with the original **Meson**
distribution.

## Install

The details of installing the **xPack Meson Build** on various platforms are
presented in the separate
[install]({{ site.baseurl }}/meson-build/install/) page.

## Documentation

The original Meson documentation is available online:

- [https://mesonbuild.com/Manual.html](https://mesonbuild.com/Manual.html)

## Support

For the various support options, please read the separate
[support]({{ site.baseurl }}/meson-build/support/) page.

## Change log

The release and change log is available in the repository
[`CHANGELOG.md`](https://github.com/xpack-dev-tools/meson-build-xpack/blob/xpack/CHANGELOG.md) file.

## Build details

For those interested in building the binaries, please read the
[README-MAINTAINER](https://github.com/xpack-dev-tools/meson-build-xpack/blob/xpack/README-MAINTAINER.md)
page.
However, the ultimate source for details are the build scripts themselves,
all available from the
[`meson-build-xpack.git/scripts`](https://github.com/xpack-dev-tools/meson-build-xpack/tree/xpack/scripts/)
folder.

## Releases

See the [releases]({{ site.baseurl }}/meson-build/releases/) pages.
