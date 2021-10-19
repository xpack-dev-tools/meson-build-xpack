# -----------------------------------------------------------------------------
# This file is part of the xPacks distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software 
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# Helper script used in the second edition of the GNU MCU Eclipse build 
# scripts. As the name implies, it should contain only functions and 
# should be included with 'source' by the container build scripts.

# -----------------------------------------------------------------------------

function build_versions()
{
  MESON_VERSION="$(echo "${RELEASE_VERSION}" | sed -e 's|-.*||')"

  if [ "${TARGET_PLATFORM}" == "win32" ]
  then
    prepare_gcc_env "${CROSS_COMPILE_PREFIX}-"
  fi

  # Keep them in sync with combo archive content.
  if [[ "${RELEASE_VERSION}" =~ 0\.58\.2-* ]]
  then

    # -------------------------------------------------------------------------
    (
      xbb_activate

      # https://www.python.org/ftp/python/
      # Be sure the extras/includes/pyconfig-win-3.X.Y.h is available.

      PYTHON3_VERSION="3.9.7" # "3.8.12"
    
      if [ "${TARGET_PLATFORM}" == "win32" ]
      then
        # Shortcut, use the existing pyton.exe instead of building
        # if from sources. It also downloads the sources.
        download_python3_win "${PYTHON3_VERSION}"
      else
        # On macOS, to prevent Python picking system libraries,
        # provide controlled versions of them.
        build_zlib "1.2.11" # "1.2.8"
        build_bzip2 "1.0.8"
        build_xz "5.2.5"

        build_libmpdec "2.5.1" # "2.5.0"
        build_expat "2.4.1" # "2.2.9"
        build_libffi "3.4.2" # "3.3"

        build_libxcrypt "4.4.26" # "4.4.17"
        build_openssl "1.1.1l" # "1.1.1h"

        build_ncurses "6.2"
        build_readline "8.1" # "8.0" # ncurses

        build_sqlite "3360000" # "3.32.3"

        build_python3 "${PYTHON3_VERSION}"
      fi

      build_meson "${MESON_VERSION}"
    )

    # -------------------------------------------------------------------------
  elif [[ "${RELEASE_VERSION}" =~ 0\.57\.2-* ]]
  then

    # -------------------------------------------------------------------------
    (
      xbb_activate

      # https://www.python.org/ftp/python/
      # Be sure the extras/includes/pyconfig-win-3.X.Y.h is available.

      PYTHON3_VERSION="3.8.6"
    
      if [ "${TARGET_PLATFORM}" == "win32" ]
      then
        # Shortcut, use the existing pyton.exe instead of building
        # if from sources. It also downloads the sources.
        download_python3_win "${PYTHON3_VERSION}"
      else
        # On macOS, to prevent Python picking system libraries,
        # provide controlled versions of them.
        build_zlib "1.2.8"
        build_bzip2 "1.0.8"
        build_xz "5.2.5"

        build_libmpdec "2.5.0"
        build_expat "2.2.9"
        build_libffi "3.3"

        build_libxcrypt "4.4.17"
        build_openssl "1.1.1h"

        build_ncurses "6.2"
        build_readline "8.0" # ncurses

        build_sqlite "3.32.3"

        build_python3 "${PYTHON3_VERSION}"
      fi

      build_meson "${MESON_VERSION}"
    )

    # -------------------------------------------------------------------------
  elif [[ "${RELEASE_VERSION}" =~ 0\.56\.2-* ]]
  then

    # -------------------------------------------------------------------------

    (
      xbb_activate

      # https://www.python.org/ftp/python/
      # Be sure the extras/includes/pyconfig-win-3.X.Y.h is available.

      PYTHON3_VERSION="3.8.6"
    
      if [ "${TARGET_PLATFORM}" == "win32" ]
      then
        # Shortcut, use the existing pyton.exe instead of building
        # if from sources. It also downloads the sources.
        download_python3_win "${PYTHON3_VERSION}"
      else
        # On macOS, to prevent Python picking system libraries,
        # provide controlled versions of them.
        build_zlib "1.2.8"
        build_bzip2 "1.0.8"
        build_xz "5.2.5"

        build_libmpdec "2.5.0"
        build_expat "2.2.9"
        build_libffi "3.3"

        build_libxcrypt "4.4.17"
        build_openssl "1.1.1h"

        build_ncurses "6.2"
        build_readline "8.0" # ncurses

        build_sqlite "3.32.3"

        build_python3 "${PYTHON3_VERSION}"
      fi

      build_meson "${MESON_VERSION}"
    )

    # -------------------------------------------------------------------------
  elif [[ "${RELEASE_VERSION}" =~ 0\.55\.3-* ]]
  then

    # -------------------------------------------------------------------------

    (
      xbb_activate

      # https://www.python.org/ftp/python/
      # Be sure the extras/includes/pyconfig-win-3.X.Y.h is available.

      if [ "${RELEASE_VERSION}" == "0.53.3-1" ]
      then
        README_OUT_FILE_NAME=${README_OUT_FILE_NAME:-"README-${RELEASE_VERSION}.md"}
        PYTHON3_VERSION="3.8.5"
      else
        PYTHON3_VERSION="3.8.6"
      fi
    
      if [ "${TARGET_PLATFORM}" == "win32" ]
      then
        # Shortcut, use the existing pyton.exe instead of building
        # if from sources. It also downloads the sources.
        download_python3_win "${PYTHON3_VERSION}"
      else
        # On macOS, to prevent Python picking system libraries,
        # provide controlled versions of them.
        build_zlib "1.2.8"
        build_bzip2 "1.0.8"
        build_xz "5.2.5"

        build_libmpdec "2.5.0"
        build_expat "2.2.9"
        build_libffi "3.3"

        build_libxcrypt "4.4.17"
        build_openssl "1.1.1h"

        build_ncurses "6.2"
        build_readline "8.0" # ncurses

        build_sqlite "3.32.3"

        build_python3 "${PYTHON3_VERSION}"
      fi

      build_meson "${MESON_VERSION}"
    )

    # -------------------------------------------------------------------------
  else
    echo "Unsupported version ${RELEASE_VERSION}."
    exit 1
  fi
}

# -----------------------------------------------------------------------------
