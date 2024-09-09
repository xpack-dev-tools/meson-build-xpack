# Change & release log

Entries in this file are in reverse chronological order.

## 2024-09-09

* v1.4.2-1 prepared
* 8cc14d3 build-assets/package.json updates
* 799c954 re-generate workflows
* 2264130 meson.sh: explain _MEIPASS patch

## 2024-08-17

* ad76681 website remove preliminary
* b942da6 build-assets/package.json: updates
* ea5b2a2 templates/body-blog update
* 0c31c5f templates/body-github: update
* 7d694b3 re-generate workflows

## 2024-08-16

* 1276ba3 templates/body-github: update

## 2024-08-14

* b9eaafa build-assets/package.json: updates

## 2024-08-09

* 4618c13 READMEs update
* 31ea9fc package.json: git+https
* 3df8514 build-assets/package.json: updates
* b8d0764 templates/body-blog update

## 2024-08-07

* c6a5f6a build-assets/package.json: updates
* a0cdb12 build-assets/package.json: updates
* 24d7fef website: preliminary content
* a029f03 re-generate workflows
* 17f7540 move to build-assets

## 2024-08-06

* be696b3 package.json: bump deps

## 2024-08-04

* d4f683a package.json: bump deps
* c0f0db6 package.json: update generate-workflows
* 96408bd templates/jekyll update
* 3f8eb48 meson.sh: XBB_BUILD_ROOT_PATH
* 55bccfa READMEs update
* 89567e6 package.json: add actions, bump deps

## 2024-07-27

* f88b544 package.json: add actions, bump deps
* 58c1c64 templates/jekyll update

## 2024-07-23

* e4f0afa READMEs update
* e0a76d1 .npmignore update
* e6fcbcb re-generate scripts
* c9e1259 body-jekyll update
* c473373 re-generate workflows
* 81e4159 package.json: rework generate workflows
* 712ad40 package.json: loglevel info
* aa85a2b package.json: bump deps

## 2024-06-18

* 796aa31 READMEs update

## 2024-06-17

* 5af6bcb package.json: rework generate workflows
* eca4625 package.json: bump deps
* dfa2032 application.sh: update

## 2024-05-23

* b515b39 package.json: clang 16.0.6-1.1

## 2024-05-18

* 2907bcd READMEs update
* 13bd4fa package.json: XBB_ENVIRONMENT_SKIP_CHECKS

## 2024-05-16

* 6ec42dc READMEs update
* e47fa79 versioning.sh: no need for --disable-lib-suffixes

## 2024-05-14

* 53c7f75 versioning.sh: ncurses with --disable-lib-suffixes

## 2024-05-07

* 7e0c8bc versioning.sh: remove DISABLE_WIDEC

## 2024-05-03

* 0db01da package.json: add bison to deps

## 2024-05-02

* 7193eab package.json: add m4 to deps
* 3ae91a7 package.json: clang 17.0.6-1.1
* 928e4e4 README update

## 2024-04-22

* 20f8e0e versioning.sh: avoid xz 5.6

## 2024-04-03

* 1aff05e meson.sh: cosmetics
* 6b0ad93 rework meson.sh with actual python; no setuptools
* 2a145c7 meson.sh: re-enable cleanups (config, opt)
* 032a647 versioning.sh: cosmetics
* 6e1514d meson.sh: separate windows code
* 2ef1029 meson.c: consistent sys.path with default python

## 2024-04-02

* 24388fc add --with-meson-python
* 32e13da prepare 1.3.2-2
* b497277 package.json bump deps

## 2024-04-01

* 81d01ab 1.3.2-1.1
* 36aeba3 package.json: .pre
* 5c788fa CHANGELOG: publish npm v1.3.2-1.1
* a5006a3 package.json: update urls for 1.3.2-1.1 release
* c3b7227 README update
* ca1c4ae body-jekyll update
* 8dae360 CHANGELOG update
* 7fa05d7 README update
* dc35379 README update
* 798fb52 CHANGELOG.md update
* b2d7e49 workflow updates
* 68d64d2 README update
* d1d0401 package.json: bump deps
* e1c6401 prepare v1.3.2-1
* 17a5bcf meson.sh: cp -R

## 2024-03-31

* b67afdc meson.sh: fix recursive copy
* 235281d meson.sh: test runpython
* 907a7da meson.sh: update windows code
* 11941e4 meson.sh: re-enable universal.py patch
* 422e3b9 versioning.sh: use XBB_PYTHON3_*_VERSION
* c719da7 meson.c: escape backslash

## 2024-03-29

* cc20cff meson.sh: cosmetics
* 0628c04 meson.sh: restore scripts/*.py
* 0a51634 versioning.sh: use python3 3.11 in 1.4.*
* 0c95edb versioning.sh: no setuptools & customisations
* f702ade versioning.sh: configure 1.3.2-* separately
* 593a21b meson.c: use HAS_MEIPASS
* 835a518 meson.c: add sys.is_xpack = True
* d58c76f meson.sh: cleanups and selected .py
* 7e4d48f versioning.sh: parametrise builds
* fc7b8f1 meson.sh: rework with pip install
* b6f6de2 versioning.sh: meson with --*-version
* 80ce29b versioning.sh: python --with-ensurepip
* 85deecd meson.c: add sys._MEIPASS = '%s'
* 9832231 meson.c: add sys.frozen = True
* 6b4c67a meson.c: add pythonX.YY to path
* 1a14c7a meson.c: use fprintf(stderr, ...)

## 2024-03-27

* 5c9b519 versioning.sh: wide ncurses for python
* 84d0c3e versioning.sh: zlib 1.3.1
* 3e7ac6d python 3.12.2 functional

## 2024-03-23

* a34547d VERSION revert to 1.3.2-1
* 9b8188a VERSION: try 1.4.0
* fd7beb2 versioning.sh: add preliminary 1.4.*
* db05993 README update
* c1fbb7d README update
* ac48dad README update
* 835363b README update
* 691b04e README update
* 0a97579 package-lock.json update
* a07e78f prepare v1.3.2-1

## 2024-03-22

* 3f46881 package.json: xpm-version 0.18.0

## 2024-03-08

* d0acb58 package.json: xpm-version 0.18.0

## 2024-03-07

* c660ecb package.json: xpm-version 0.18.0
* d5e9626 package.json: bump deps

## 2024-03-06

* 4bec3db body-jekyll update
* 43b3cf8 package.json: bump deps

## 2024-02-07

* 952a7dd READMEs update
* bcf5301 package.json: bump deps

## 2023-12-03

* ec9211d package.json: bump deps
* 0cc56bf re-generate workflows

## 2023-11-26

* 55e6ca4 1.3.0-1.1
* 4773d18 CHANGELOG: publish npm v1.3.0-1.1
* 71c83ea package.json: update urls for 1.3.0-1.1 release
* 7fd772a body-jekyll update
* eff33d7 CHANGELOG update
* ce1b762 prepare v1.3.0-1
* 0395c91 1.2.3-1.1
* 312e19e CHANGELOG: publish npm v1.2.3-1.1
* ce6dc33 package.json: update urls for 1.2.3-1.1 release
* 1c51948 body-jekyll update
* b6b3d99 CHANGELOG update

## 2023-11-25

* 4cdd161 prepare v1.2.3-1
* 8e05c13 1.1.1-1.1
* 2529156 package.json .pre
* bf13d2e .npmignore src
* 04689fe CHANGELOG: publish npm v1.1.1-1.1
* 29d14af package.json: update urls for 1.1.1-1.1 release
* 154879b README update
* 7d14289 body-jekyll update
* 5c12648 CHANGELOG update
* bc28e05 README update
* 103cccf package-lock.json update
* 83873b0 README update
* b9b6f4b prepare v1.1.1-1

## 2023-11-12

* 9db7097 package.json: bump deps

## 2023-09-25

* be86556 body-jekyll update

## 2023-09-20

* a5693e5 package.json: bump deps

## 2023-09-16

* b90e7f6 package.json: add linux32
* 9645191 body-jekyll update

## 2023-09-11

* faaac0b package.json: bump deps

## 2023-09-08

* 2c7993c package.json: bump deps

## 2023-09-06

* a629a76 package.json: bump deps
* 4336557 READMEs update
* 9b2aef4 body-jekyll update

## 2023-09-05

* 7622bb2 dot.*ignore update
* 845a463 re-generate workflows
* 0cd3c3d READMEs update
* 0b09120 package.json: bump deps

## 2023-09-03

* 36a5b05 package.json: bump deps

## 2023-08-28

* bcae6cf READMEs update

## 2023-08-25

* d393a81 package.json: rm xpack-dev-tools-build/*
* 1d2233f package.json: bump deps

## 2023-08-21

* 2909606 READMEs update
* 75e6a08 package.json: bump deps

## 2023-08-19

* 0f5eaf2 READMEs update
* cab4a9d package.json: bump deps

## 2023-08-15

* 0b2f57c re-generate workflows
* 23f82eb README-MAINTAINER rename xbbla
* 2e04f77 package.json: rename xbbla
* 8c32aef package.json: bump deps
* ce315ac READMEs update
* 8f079ce package.json: bump deps

## 2023-08-05

* 7dab3c2 READMEs update

## 2023-08-04

* c8b3cd8 READMEs update
* 8a70b10 READMEs update
* 1a87286 package.json: add build-develop-debug
* 9dc5674 READMEs update

## 2023-08-03

* f7422ea package.json: reorder build actions
* 6173e43 READMEs update
* 01dfc81 package.json: bump deps

## 2023-07-28

* 01b6e49 READMEs update* a7cb8bb CHANGELOG update
* beb5899 1.0.2-1.1
* cf424e8 CHANGELOG: publish npm v1.0.2-1.1
* v1.0.2-1.1 published on npmjs.com
* c93f11e package.json: update urls for 1.0.2-1.1 release
* b68dde0 README update
* 5ce29ba templates/jekyll update
* 4d25ae9 CHANGELOG update
* d02ce77 prepare v1.0.2-1
* 16f7ad4 READMEs update
* 7bee0b6 0.64.1-1.1
* 9ad8e31 CHANGELOG: publish npm v0.64.1-1.1
* v0.64.1-1.1 published on npmjs.com
* 8c737ec package.json: update urls for 0.64.1-1.1 release
* fbd0dfb re-generate workflows
* 8f81ea3 package.json: bump deps
* 06c1b2d package.json: liquidjs --context --template
* add4975 templates/jekyll update
* 2be0fda CHANGELOG update
* 82cbcfd README update
* 2146deb READMEs update
* fd1ff90 scripts cosmetics
* 53d44a6 .npmignore remove src
* e047719 README update
* b667e87 package-lock.json update
* 2f6e973 package.json: @xpack-dev-tools/xbb-helper
* 5e9592c package.json: bump helper 1.4.14
* d0bb6f5 package.json: minXpm 0.16.3
* accd2fa re-generate workflows
* a608327 package.json: minXpm 0.16.3
* ee24990 VERSION 0.64.1
* 6e12585 package.json: bump helper 1.4.14
* 8215921 README update
* 9178ec0 versioning.sh: update deps for 1.0.*
* 05b5141 prepare v0.64.1-1
* 1fe702f package.json: bump helper 1.4.12
* 1fe702f package.json: bump helper 1.4.12

## 2023-07-26

* 7f45b4b package.json: move scripts to actions
* a5081fa package.json: update xpack-dev-tools path
* e0b32dd READMEs update xpack-dev-tools path
* 99f5c53 body-jekyll update
* 31faa88 READMEs update

## 2023-07-17

* 182055a package.json: bump deps

## 2023-03-25

* 6b85909 READMEs update
* f6d4cb8 READMEs update prerequisites
* c503138 package.json: mkdir -pv cache

## 2023-02-22

* 9146699 READMEs update

## 2023-02-14

* a9e6952 body-jekyll update

## 2023-02-10

* c8402db package.json: update Work/xpacks
* b554fdc READMEs update

## 2023-02-07

* 0d6ee51 READMEs update
* dc6ff8b versioning.sh: update for https
* c304ea6 body-jekyll update

## 2023-01-28

* v0.63.3-1.1 published on npmjs.com
* v0.63.3-1 released
* 346b744 templates updates
* v0.63.3-1 prepared
* v0.62.2-1.1 published on npmjs.com
* 60024e7 package.json: update urls for 0.62.2-1.1 release
* c1176b2 README update
* 5ca770e README update
* 84c3137 body-jekyll update
* 892165b CHANGELOG update
* v0.62.2-1 released
* bd2c931 README update
* 84a9b43 versioning.sh: fix extras path
* b2f53dd versioning.sh: fix extras path
* 3faf93f versioning.sh: fix extras path
* 3c0bcf0 README-MAINTAINER remove caffeinate xpm
* b7bebea CHANGELOG updates
* 723246d remove extras (use helper ones)
* 72c8fe8 versioning.sh: use versioning functions
* b16b91b package.json: bump deps

## 2023-01-27

* accd9b7 package.json: reorder scripts

## 2023-01-24

* 9cdd5fe versioning.sh: revert 0.6* deps versions
* a7aa022 re-generate workflows
* ee56282 prepare v0.62.2-1
* d131540 .vscode/settings.json: ignoreWords
* 4c025ac package.json: bump deps
* 97d0ce2 README updates

## 2023-01-22

* e1ca1e0 README update

## 2023-01-11

* 09d27f0 cosmetize xbb_adjust_ldflags_rpath

## 2023-01-09

* 1ac7bf3 meson.sh: fix regexp
* 808a0f0 meson.sh: cleanups
* df8fa78 package.json: bump deps
* fb88907 package.json: loglevel info
* b27fb15 versioning.sh: add comment before *_installed_bin

## 2023-01-02

* 711f417 package.json: reformat

## 2023-01-01

* 7de9c8b package.json: pass xpm version & loglevel
* c6750eb README update

## 2022-12-30

* 216b602 README-MAINTAINER: xpm run install
* 540e209 package.json: bump deps
* 7030574 versioning.sh: regexp

## 2022-12-27

* bf7ab3b README update
* ee94a1a meson.sh: use python3_* functions
* c594791 echo FUNCNAME[0]
* 2ef9845 cosmetics: move versions to the top

## 2022-12-26

* 9ffee9e versioning.sh: fix windows build
* 401d643 re-generate from templates
* 6cad4e4 README updates

## 2022-12-25

* 1b7eddb README update
* 2ce9210 versioning.sh: remove explicit xbb_set_executables_install_path

## 2022-12-24

* update for XBB v5.0.0
* 90f592c CHANGELOG update
* a55547c meson.sh: fix parameter passing
* 93649a6 READMEs updates
* 17654f0 .vscode/settings.json: ignoreWords
* 5d6c56d package.json: update
* e8d734c package.json: bump deps
* 6c30755 versioning.sh: update
* 7b48bff meson.sh: update
* 0ee4bcd re-generate templates
* d692db9 CHANGELOG.md: use bullet lists
* 2699654 rename functions

## 2022-12-12

* fffdfa6 package.json: add caffeinate builds for macOS

## 2022-11-18

* b54bdc7 .vscode/settings.json: watcherExclude

## 2022-10-26

* 7335a59 meson.sh: fix test_meson
* 3b4071b package.json: bump deps
* d392812 package.json: bump deps
* aa8f45b Merge remote-tracking branch 'origin/xpack-develop' into xpack-develop
* 3ece39b package.json: bump deps
* 92aa1c2 versioning.sh: enable build_sqlite on linux too
* c150c36 re-generate workflows
* ab398ac versioning.sh: re-enable build_sqlite for macOS
* 15f9e71 re-generate workflows
* 4e120a8 versioning.sh: rework with build_set_target "cross"
* fb40099 versioning.sh: rename build_application_versioned_components
* f007bf7 meson.sh: create XBB_STAMPS_FOLDER_PATH
* 83bbe6d meson.sh: use install for meson executable
* adec1d7 meson.sh: fix path to native python3
* 808f743 application.sh: XBB_APPLICATION_INITIAL_TARGET="native"
* 8621e1d package.json: add gcc to win32 deps

## 2022-10-25

* e0e8fc4 meson.sh: no longer use linux binaries
* ba36ccb versioning: always build python
* c8484fa .vscode/settings.json: ignoreWords
* b03cd86 package.json: deps
* 47e5c77 package.json: bump deps
* bc943a4 versioning.sh: comment out build_sqlite
* 3466921 package.json: deps cleanups
* e8820ed re-generate workflows
* ded7324 package.json: bump deps
* 0cb8c27 README update

## 2022-10-23

* 10b3979 package.json: bump deps
* 2edc85a package.json: bump deps
* 71b0631 READMEs update
* 875cee7 package.json: add devDep realpath
* ce2561f versioning.sh: remove build_coreutils
* d7c938d build.sh: cosmetics
* 94c312a test.sh: update
* b35ccdd build.sh: update
* 4a9238e rename application.sh
* 29363fc package.json: reorder actions

## 2022-10-19

* c037ee7 versioning.sh: libffi 3.4.3
* 5c39be8 READMEs update
* 0c31b9f versioning.sh: XBB_COREUTILS_INSTALL_REALPATH_ONLY
* 2fcb177 .gitignore updates
* a82f7e6 meson.sh: cosmetics
* c1e00b1 temporarily use coreutils
* 6f2a2bf package.json: remove xbb-bootstrap
* 8021bae remove update.sh

## 2022-10-18

* fdb86ea READMEs updates
* 8e997ed body-jekyll: update
* b09846d meson.sh: ue XBB_LDFLAGS_APP

## 2022-10-17

* 68b560a update for xbb v4.0
* c6875c4 remove submodule

## 2022-10-04

* fdf0d2b README-RELEASE update for bullet lists in CHANGELOG

## 2022-09-25

* 2d345d5 README-RELEASE update

## 2022-09-17

* 87c2519 package.json: remove -ia32
* 0dd7ee9 README-BUILD update

## 2022-09-03

* 341be6b READMEs updates

## 2022-09-01

* v0.61.5-1.1 published on npmjs.com
* v0.61.5-1 released

## 2022-03-24

* v0.60.3-1.1 published on npmjs.com
* v0.60.3-1 released

## 2021-12-06

* v0.59.4-1.1 published on npmjs.com
* v0.59.4-1 released
* v0.59.4-1 prepared

## 2021-11-20

* v0.58.2-2 prepared
* add Apple Silicon support

## 2021-10-19

* v0.58.2-1.1 published on npmjs.com
* v0.58.2-1 released
* v0.58.2-1 prepared

## 2021-05-26

* v0.57.2-1.1 published on npmjs.com
* v0.57.2-1 released

## 2021-04-27

* v0.56.2-2.1 published on npmjs.com
* v0.56.2-2 released

## 2021-02-02

* v0.56.2-1.1 published on npmjs.com
* v0.56.2-1 released

## 2020-10-16

* v0.55.3-2.1 published on npmjs.com
* v0.55.3-2 released

## 2020-09-30

* v0.55.3-1.1 published on npmjs.com
* v0.55.3-1 released

## 2020-09-25

* v0.55.3-1 created

## 2020-08-23

* v0.55.1-1 created
