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
  XBB_MESON_VERSION="$(xbb_strip_version_pre_release "${XBB_RELEASE_VERSION}")"

  # Keep them in sync with the combo archive content.
  if [[ "${XBB_RELEASE_VERSION}" =~ 1[.][4][.].*-.* ]]
  then

    # -------------------------------------------------------------------------

    # https://www.python.org/ftp/python/
    # Be sure that ${helper_folder_path}/extras/python/pyconfig-win-3.X.Y.h
    # is available.

    # For the latest stable see:
    # https://www.python.org/downloads/
    XBB_PYTHON3_VERSION="3.12.2"

    XBB_PYTHON3_VERSION_MAJOR=$(xbb_get_version_major "${XBB_PYTHON3_VERSION}")
    XBB_PYTHON3_VERSION_MINOR=$(echo ${XBB_PYTHON3_VERSION} | sed -e 's|\([0-9]\)[.]\([0-9][0-9]*\)[.].*|\2|')
    XBB_PYTHON3_VERSION_MAJOR_MINOR=${XBB_PYTHON3_VERSION_MAJOR}${XBB_PYTHON3_VERSION_MINOR}
    XBB_PYTHON3_SRC_FOLDER_NAME="Python-${XBB_PYTHON3_VERSION}"

    if [ "${XBB_REQUESTED_TARGET_PLATFORM}" == "win32" ]
    then
      if [ ! -f "${helper_folder_path}/extras/python/pyconfig-win-${XBB_PYTHON3_VERSION}.h" ]
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
    # Before set target (to possibly update CC & co variables).
    # xbb_activate_installed_bin

    xbb_set_target "requested"

    if [ "${XBB_REQUESTED_TARGET_PLATFORM}" != "win32" ]
    then
      # https://zlib.net/fossils/
      zlib_build  "1.2.13"

      # https://sourceware.org/pub/bzip2/
      bzip2_build "1.0.8"

      # https://sourceforge.net/projects/lzmautils/files/
      xz_build "5.4.6" # "5.4.3"

      # https://www.bytereef.org/mpdecimal/download.html
      mpdecimal_build "4.0.0"

      # https://github.com/libexpat/libexpat/releases
      expat_build "2.6.2" # "2.5.0"

      # https://github.com/libffi/libffi/releases
      libffi_build "3.4.6" # "3.4.4"

      # https://github.com/besser82/libxcrypt/releases
      libxcrypt_build "4.4.36"

      # https://github.com/openssl/openssl/tags
      openssl_build "3.2.1" # "1.1.1u"

      export XBB_NCURSES_DISABLE_WIDEC="y"
      # https://ftp.gnu.org/gnu/ncurses/
      ncurses_build "6.4"

      # https://ftp.gnu.org/gnu/readline/
      readline_build "8.2"

      # Without it, on macOS, the Python binaries will have a reference
      # to the system libsqlite.
      # https://www.sqlite.org/download.html
      sqlite_build "3450200" "2024" # "3420000"

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
  elif [[ "${XBB_RELEASE_VERSION}" =~ 1[.][0123][.].*-.* ]]
  then

    # -------------------------------------------------------------------------

    # https://www.python.org/ftp/python/
    # Be sure that ${helper_folder_path}/extras/python/pyconfig-win-3.X.Y.h
    # is available.

    # For the latest stable see:
    # https://www.python.org/downloads/
    XBB_PYTHON3_VERSION="3.11.4"

    XBB_PYTHON3_VERSION_MAJOR=$(xbb_get_version_major "${XBB_PYTHON3_VERSION}")
    XBB_PYTHON3_VERSION_MINOR=$(echo ${XBB_PYTHON3_VERSION} | sed -e 's|\([0-9]\)[.]\([0-9][0-9]*\)[.].*|\2|')
    XBB_PYTHON3_VERSION_MAJOR_MINOR=${XBB_PYTHON3_VERSION_MAJOR}${XBB_PYTHON3_VERSION_MINOR}
    XBB_PYTHON3_SRC_FOLDER_NAME="Python-${XBB_PYTHON3_VERSION}"

    if [ "${XBB_REQUESTED_TARGET_PLATFORM}" == "win32" ]
    then
      if [ ! -f "${helper_folder_path}/extras/python/pyconfig-win-${XBB_PYTHON3_VERSION}.h" ]
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
    # Before set target (to possibly update CC & co variables).
    # xbb_activate_installed_bin

    xbb_set_target "requested"

    if [ "${XBB_REQUESTED_TARGET_PLATFORM}" != "win32" ]
    then
      # https://zlib.net/fossils/
      zlib_build  "1.2.13" # "1.2.12"

      # https://sourceware.org/pub/bzip2/
      bzip2_build "1.0.8"

      # https://sourceforge.net/projects/lzmautils/files/
      xz_build "5.4.3" # "5.2.6"

      # https://www.bytereef.org/mpdecimal/download.html
      mpdecimal_build "2.5.1"

      # https://github.com/libexpat/libexpat/releases
      expat_build "2.5.0" # "2.4.8"

      # https://github.com/libffi/libffi/releases
      libffi_build "3.4.4" # "3.4.3"

      # https://github.com/besser82/libxcrypt/releases
      libxcrypt_build "4.4.36" # "4.4.28"

      # https://github.com/openssl/openssl/tags
      openssl_build "1.1.1u" # "1.1.1q"

      export XBB_NCURSES_DISABLE_WIDEC="y"
      # https://ftp.gnu.org/gnu/ncurses/
      ncurses_build "6.4" # "6.3"

      # https://ftp.gnu.org/gnu/readline/
      readline_build "8.2" # "8.1.2"

      # Without it, on macOS, the Python binaries will have a reference
      # to the system libsqlite.
      # https://www.sqlite.org/download.html
      sqlite_build "3420000" # "3390200"

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
  elif [[ "${XBB_RELEASE_VERSION}" =~ 0[.]6[1234][.].*-.* ]]
  then

    # -------------------------------------------------------------------------

    # https://www.python.org/ftp/python/
    # Be sure that ${helper_folder_path}/extras/python/pyconfig-win-3.X.Y.h
    # is available.

    # For the latest stable see:
    # https://www.python.org/downloads/
    XBB_PYTHON3_VERSION="3.10.6"

    XBB_PYTHON3_VERSION_MAJOR=$(xbb_get_version_major "${XBB_PYTHON3_VERSION}")
    XBB_PYTHON3_VERSION_MINOR=$(echo ${XBB_PYTHON3_VERSION} | sed -e 's|\([0-9]\)[.]\([0-9][0-9]*\)[.].*|\2|')
    XBB_PYTHON3_VERSION_MAJOR_MINOR=${XBB_PYTHON3_VERSION_MAJOR}${XBB_PYTHON3_VERSION_MINOR}
    XBB_PYTHON3_SRC_FOLDER_NAME="Python-${XBB_PYTHON3_VERSION}"

    if [ "${XBB_REQUESTED_TARGET_PLATFORM}" == "win32" ]
    then
      if [ ! -f "${helper_folder_path}/extras/python/pyconfig-win-${XBB_PYTHON3_VERSION}.h" ]
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
    # Before set target (to possibly update CC & co variables).
    # xbb_activate_installed_bin

    xbb_set_target "requested"

    if [ "${XBB_REQUESTED_TARGET_PLATFORM}" != "win32" ]
    then
      # https://zlib.net/fossils/
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
