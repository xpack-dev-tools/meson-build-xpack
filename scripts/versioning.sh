# -----------------------------------------------------------------------------
# This file is part of the xPacks distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# Helper script used in the xPack build scripts. As the name implies,
# it should contain only functions and should be included with 'source'
# by the build scripts (both native and container).

# -----------------------------------------------------------------------------

function build_application_versioned_components()
{
  XBB_MESON_VERSION="$(echo "${XBB_RELEASE_VERSION}" | sed -e 's|-.*||')"

  # Keep them in sync with combo archive content.
  if [[ "${XBB_RELEASE_VERSION}" =~ 0\.61\.5-* ]]
  then

    # -------------------------------------------------------------------------

    # https://www.python.org/ftp/python/
    # Be sure the extras/includes/pyconfig-win-3.X.Y.h is available.

    # For the latest stable see:
    # https://www.python.org/downloads/
    XBB_PYTHON3_VERSION="3.10.6"

    if [ "${XBB_REQUESTED_TARGET_PLATFORM}" == "win32" ]
    then
      if [ ! -f "${XBB_BUILD_GIT_PATH}/extras/includes/pyconfig-win-${XBB_PYTHON3_VERSION}.h" ]
      then
        echo
        echo "Missing extras/includes/pyconfig-win-${XBB_PYTHON3_VERSION}.h"
        exit 1
      fi
    fi

    # This application starts with native target.

    xbb_set_binaries_install "${XBB_DEPENDENCIES_INSTALL_FOLDER_PATH}"
    xbb_set_libraries_install "${XBB_DEPENDENCIES_INSTALL_FOLDER_PATH}"

    # http://zlib.net/fossils/
    build_zlib  "1.2.12"

    # https://sourceware.org/pub/bzip2/
    build_bzip2 "1.0.8"

    # https://sourceforge.net/projects/lzmautils/files/
    build_xz "5.2.6"

    # https://www.bytereef.org/mpdecimal/download.html
    build_mpdecimal "2.5.1"

    # https://github.com/libexpat/libexpat/releases
    build_expat "2.4.8"

    # https://github.com/libffi/libffi/releases
    build_libffi "3.4.3" # !

    # https://github.com/besser82/libxcrypt
    build_libxcrypt "4.4.28"

    # https://www.openssl.org/source/
    build_openssl "1.1.1q"

    export XBB_NCURSES_DISABLE_WIDEC="y"
    # https://ftp.gnu.org/gnu/ncurses/
    build_ncurses "6.3"

    # https://ftp.gnu.org/gnu/readline/
    build_readline "8.1.2"

    # https://www.sqlite.org/download.html
    # build_sqlite "3390200"

    XBB_PYTHON3_VERSION_MAJOR=$(echo ${XBB_PYTHON3_VERSION} | sed -e 's|\([0-9]\)\..*|\1|')
    XBB_PYTHON3_VERSION_MINOR=$(echo ${XBB_PYTHON3_VERSION} | sed -e 's|\([0-9]\)\.\([0-9][0-9]*\)\..*|\2|')
    XBB_PYTHON3_VERSION_MAJOR_MINOR=${XBB_PYTHON3_VERSION_MAJOR}${XBB_PYTHON3_VERSION_MINOR}

    XBB_PYTHON3_SRC_FOLDER_NAME="Python-${XBB_PYTHON3_VERSION}"

    build_python3 "${XBB_PYTHON3_VERSION}"

    # -------------------------------------------------------------------------
    # With all dependencies solved, build the application.

    if [ "${XBB_REQUESTED_TARGET_PLATFORM}" == "win32" ]
    then
      # Restore the cross target.
      build_set_target "cross"
    fi

    xbb_set_libraries_install "${XBB_DEPENDENCIES_INSTALL_FOLDER_PATH}"
    xbb_set_binaries_install "${XBB_APPLICATION_INSTALL_FOLDER_PATH}"

    if [ "${XBB_REQUESTED_TARGET_PLATFORM}" == "win32" ]
    then
      # Shortcut, use the existing pyton3X.dll instead of building
      # if from sources. It also downloads the sources.
      download_python3_win "${XBB_PYTHON3_VERSION}"
    fi

    build_meson "${XBB_MESON_VERSION}"

    # -------------------------------------------------------------------------
  else
    echo "Unsupported version ${XBB_RELEASE_VERSION}."
    exit 1
  fi
}

# -----------------------------------------------------------------------------
