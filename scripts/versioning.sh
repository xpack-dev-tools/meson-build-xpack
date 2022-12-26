# -----------------------------------------------------------------------------
# This file is part of the xPacks distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------

function application_build_versioned_components()
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
    
    XBB_PYTHON3_VERSION_MAJOR=$(echo ${XBB_PYTHON3_VERSION} | sed -e 's|\([0-9]\)\..*|\1|')
    XBB_PYTHON3_VERSION_MINOR=$(echo ${XBB_PYTHON3_VERSION} | sed -e 's|\([0-9]\)\.\([0-9][0-9]*\)\..*|\2|')
    XBB_PYTHON3_VERSION_MAJOR_MINOR=${XBB_PYTHON3_VERSION_MAJOR}${XBB_PYTHON3_VERSION_MINOR}
    XBB_PYTHON3_SRC_FOLDER_NAME="Python-${XBB_PYTHON3_VERSION}"

    if [ "${XBB_REQUESTED_TARGET_PLATFORM}" == "win32" ]
    then
      if [ ! -f "${XBB_BUILD_GIT_PATH}/extras/includes/pyconfig-win-${XBB_PYTHON3_VERSION}.h" ]
      then
        echo
        echo "Missing extras/includes/pyconfig-win-${XBB_PYTHON3_VERSION}.h"
        exit 1
      fi
    fi

    # -------------------------------------------------------------------------
    # Build the native dependencies.

    # None

    # -------------------------------------------------------------------------
    # Build the target dependencies.

    xbb_reset_env
    xbb_set_target "requested"

    if [ "${XBB_REQUESTED_TARGET_PLATFORM}" != "win32" ]
    then
      # http://zlib.net/fossils/
      zlib_build  "1.2.12"

      # https://sourceware.org/pub/bzip2/
      bzip2_build "1.0.8"

      # https://sourceforge.net/projects/lzmautils/files/
      xz_build "5.2.6"

      # https://www.bytereef.org/mpdecimal/download.html
      mpdecimal_build "2.5.1"

      # https://github.com/libexpat/libexpat/releases
      expat_build "2.4.8"

      # https://github.com/libffi/libffi/releases
      libffi_build "3.4.3" # !

      # https://github.com/besser82/libxcrypt
      libxcrypt_build "4.4.28"

      # https://www.openssl.org/source/
      openssl_build "1.1.1q"

      export XBB_NCURSES_DISABLE_WIDEC="y"
      # https://ftp.gnu.org/gnu/ncurses/
      ncurses_build "6.3"

      # https://ftp.gnu.org/gnu/readline/
      readline_build "8.1.2"

      # Without it, on macOS, the Python binaries will have a reference
      # to the system libsqlite.
      # https://www.sqlite.org/download.html
      sqlite_build "3390200"

      python3_build "${XBB_PYTHON3_VERSION}"
    fi

    # -------------------------------------------------------------------------
    # Build the application binaries.

    xbb_set_executables_install_path "${XBB_APPLICATION_INSTALL_FOLDER_PATH}"
    xbb_set_libraries_install_path "${XBB_DEPENDENCIES_INSTALL_FOLDER_PATH}"

    if [ "${XBB_REQUESTED_TARGET_PLATFORM}" == "win32" ]
    then
      # Shortcut, use the existing pyton3X.dll instead of building
      # if from sources. It also downloads the sources.
      python3_download_win "${XBB_PYTHON3_VERSION}"
    fi

    meson_build "${XBB_MESON_VERSION}"

    # -------------------------------------------------------------------------
  else
    echo "Unsupported ${XBB_APPLICATION_LOWER_CASE_NAME} version ${XBB_RELEASE_VERSION}"
    exit 1
  fi
}

# -----------------------------------------------------------------------------
