# How to make a new release (maintainer info)

## Prepare the build

Before starting the build, perform some checks and tweaks.

### Check Git

- switch to the `xpack-develop` branch
- if needed, merge the `xpack` branch

### Increase the version

To prepare a new release, first determine the Meson Build version
(like `0.55.3`) and update the `scripts/VERSION` file. The format is
`0.55.3-1`. The fourth number is the xPack release number
of this version. A fifth number will be added when publishing
the package on the `npm` server.

### Fix possible open issues

Check GitHub issues and pull requests:

- https://github.com/xpack-dev-tools/meson-build-xpack/issues

and fix them; assign them to a milestone (like `v0.55.3-2`).

### Check `README.md`

Normally `README.md` should not need changes, but better check.
Information related to the new version should not be included here,
but in the version specific file (below).

### Update the `CHANGELOG.md` file

- open the `CHANGELOG.md` file
- check if all previous fixed issues are in
- add a new entry like _v0.55.3-2 prepared_
- commit commit with a message like _CHANGELOG: prepare v0.55.3-2_
- `npm version v0.55.3-2.1`; the first 4 nu

Note: if you missed to update the `CHANGELOG.md` before starting the build,
edit the file and rerun the build, it should take only a few minutes to
recreate the archives with the correct file.

### Update the version specific code

- open the `common-versions-source.sh` file
- add a new `if` with the new version before the existing code
- check the Python version, and possibly bump to newer one

## Build

### Clean the destination folder

On the development machine clear the folder where binaries from all
build machines will be collected.

```console
$ rm -f ~/Downloads/xpack-binaries/meson/*
```

### Pre-run the build scripts

Before the real build, run a test build on the development machine:

```console
$ sudo rm -rf ~/Work/meson-build-*
$ caffeinate bash ~/Downloads/meson-build-xpack.git/scripts/build.sh --develop --without-pdf --disable-tests --linux64 --win64 --linux32 --win32
```

Work on the scripts until all 4 platforms pass the build.

## Push the build script

In this Git repo:

- push the `xpack-develop` branch to GitHub
- possibly push the helper project too

From here it'll be cloned on the production machines.

### Run the build scripts

Move to the three production machines.

On the macOS build machine, create three new terminals.

Connect to the Intel Linux:

```console
$ caffeinate ssh xbbi
```

Connect to the Arm Linux:

```console
$ caffeinate ssh xbba
```

On all machines, clone the `xpack-develop` branch:

```console
$ rm -rf ~/Downloads/meson-build-xpack.git; \
  git clone --recurse-submodules --branch xpack-develop \
  https://github.com/xpack-dev-tools/meson-build-xpack.git \
  ~/Downloads/meson-build-xpack.git
```

Remove any previous build:

```console
$ sudo rm -rf ~/Work/meson-build-*
```

On the macOS machine:

```console
$ caffeinate bash ~/Downloads/meson-build-xpack.git/scripts/build.sh --osx
```

On the Linux machines:

```console
$ bash ~/Downloads/meson-build-xpack.git/scripts/build.sh --all
```

Copy the binaries to the development machine.

On all three machines:

```console
$ (cd ~/Work/meson-build-*/deploy; scp * ilg@wks:Downloads/xpack-binaries/qemu)
```

## Test

TBD

## Create a new GitHub pre-release

- commit and push the `xpack-develop` branch
- go to the [GitHub Releases](https://github.com/xpack-dev-tools/meson-build-xpack/releases) page
- click the **Draft a new release** button
- name the tag like **v0.55.3-2** (mind the dash in the middle!)
- select the `xpack-develop` branch
- name the release like **xPack Meson Build v0.55.3-2** (mind the dash)
- as description
  - add a downloads badge like `![Github Releases (by Release)](https://img.shields.io/github/downloads/xpack-dev-tools/meson-build-xpack/v0.55.3-2/total.svg)`
  - draft a short paragraph explaining what are the main changes
  - add _At this moment these binaries are for tests only!_
- **attach binaries** and SHA (drag and drop from the
`~/Downloads/xpack-binaries/meson/` folder)
- **enable** the **pre-release** button
- click the **Publish Release** button

Note: at this moment the system should send a notification to all clients watching this project.

## Run the Travis tests

Using the scripts in `tests/scripts/`, start:

- trigger-travis-quick.mac.command (optional)
- trigger-travis-stable.mac.command
- trigger-travis-latest.mac.command

The test results are available from:

- https://travis-ci.org/github/xpack-dev-tools/meson-build-xpack

For more details, see `tests/scripts/README.md`.

## Prepare a new blog post

In the `xpack.github.io` web Git:

- select the `xpack-develop` branch
- add a new file to `_posts/meson-build/releases`
- name the file like `2020-10-16-meson-build-v0-55-3-2-released.md`
- name the post like: **xPack Meson Build v0.55.3-2 released**.
- as `download_url` use the tagged URL like `https://github.com/xpack-dev-tools/meson-build-xpack/releases/tag/v0.55.3-2/`
- update the `date:` field with the current date
- update the Travis URLs using the actual test pages

If any, refer to closed
[issues](https://github.com/xpack-dev-tools/meson-build-xpack/issues)
as:

- **[Issue:\[#1\]\(...\)]**.

## Update the SHA sums

Copy/paste the build report at the end of the post as:

```console

## Checksums
The SHA-256 hashes for the files are:

06d2251a893f932b38f41c418cdc14e51893f68553ba5a183f02001bd92d9454  
xpack-meson-build-v0.55.3-2-darwin-x64.tar.gz

a1c7e77001cb549bd6b6dc00bb0193283179667e56f652182204229b55f58bc8  
xpack-meson-build-v0.55.3-2-linux-arm64.tar.gz

c812f12b7159b7f149c211fb521c0e405de64bb087f138cda8ea5ac04be87e15  
xpack-meson-build-v0.55.3-2-linux-arm.tar.gz

ebb4b08e8b94bd04b5493549b0ba2c02f1be5cc5f42c754e09a0c279ae8cc854  
xpack-meson-build-v0.55.3-2-linux-x32.tar.gz

687ac941c995eab069955fd673b6cd78a6b95048cac4a92728b09be444d0118e  
xpack-meson-build-v0.55.3-2-linux-x64.tar.gz

a0bde52aa8846a2a5b982031ad0bdebea55b9b3953133b363f54862473d71686  
xpack-meson-build-v0.55.3-2-win32-x32.zip

b25987e4153e42384ff6273ba228c3eaa7a61a2a6cc8f7a3fbf800099c3f6a49  
xpack-meson-build-v0.55.3-2-win32-x64.zip
```

If you missed this, `cat` the content of the `.sha` files:

```console
$ ~Downloads/xpack-binaries/meson
$ cat *.sha
```

## Update the preview Web

- commit the `develop` branch of `xpack.github.io` project; use a message
  like **xPack Meson Build v0.55.3-2 released**
- wait for the GitHub Pages build to complete
- the preview web is https://xpack.github.io/web-preview/

## Publish on the npmjs server

- select the `xpack-develop` branch
- open the `package.json` file
- open [GitHub Releases](https://github.com/xpack-dev-tools/meson-build-xpack/releases)
  and select the latest release
- check the download counter, it should match the number of tests
- update the `baseUrl:` with the file URLs (including the tag/version);
no terminating `/` is required
- from the web release, copy the SHA & file names
- commit all changes, use a message like
  `package.json: update urls for v0.55.3-2 release` (without `v`)
- check the latest commits `npm run git-log`
- update `CHANGELOG.md`; commit with a message like
  _CHANGELOG: prepare npm v0.55.3-2.1_
- `npm version v0.55.3-2.1`; the first 4 numbers are the same as the
  GitHub release; the fifth number is the npm specific version
- `npm pack` and check the content of the archive, which should list
  only the `package.json`, the `README.md`, `LICENSE` and `CHANGELOG.md`
- push all changes to GitHub
- `npm publish --tag next` (use `--access public` when publishing for
  the first time)

## Test if the npm binaries can be installed with xpm

Run the `tests/scripts/trigger-travis-xpm-install.sh` file, this
will install the package on Intel Linux 64-bit, macOS and Windows 64-bit.

The test results are available from:

- https://travis-ci.org/github/xpack-dev-tools/meson-build-xpack

For 32-bit Windows, 32-bit Intel GNU/Linux and 32-bit Arm, install manually.

```console
$ xpm install --global @xpack-dev-tools/meson-build@next
```

## Test the npm binaries

Install the binaries on all platforms.

```console
$ xpm install --global @xpack-dev-tools/meson-build@next
```

On GNU/Linux systems, including Raspberry Pi, use the following commands:

```
~/opt/xPacks/@xpack-dev-tools/meson-build/0.55.3-2.1/.content/bin/qemu-system-gnuarmeclipse --version

TODO
```

On macOS, use:

```
~/Library/xPacks/@xpack-dev-tools/meson-build/0.55.3-2.1/.content/bin/qemu-system-gnuarmeclipse --version

TODO
```

On Windows use:

```
%HOMEPATH%\AppData\Roaming\xPacks\@xpack-dev-tools\meson-build\0.55.3-2.1\.content\bin\qemu-system-gnuarmeclipse --version

TODO
```

## Update the repo

- merge `xpack-develop` into `xpack`
- push

## Tag the npm package as `latest`

When the release is considered stable, promote it as `latest`:

- `npm dist-tag ls @xpack-dev-tools/meson-build`
- `npm dist-tag add @xpack-dev-tools/meson-build@0.55.3-2.1 latest`
- `npm dist-tag ls @xpack-dev-tools/meson-build`

## Update the Web

- in the `master` branch, merge the `develop` branch
- wait for the GitHub Pages build to complete
- the result is in https://xpack.github.io/news/
- remember the post URL, since it must be updated in the release page

## Create the final GitHub release

- go to the [GitHub Releases](https://github.com/xpack-dev-tools/meson-build-xpack/releases) page
- check the download counter, it should match the number of tests
- add a link to the Web page `[Continue reading »]()`; use an same blog URL
- **disable** the **pre-release** button
- click the **Update Release** button

## Share on Twitter

- in a separate browser windows, open [TweetDeck](https://tweetdeck.twitter.com/)
- using the `@xpack_project` account
- paste the release name like **xPack Meson Build v0.55.3-2 released**
- paste the link to the blog release URL
- click the **Tweet** button
