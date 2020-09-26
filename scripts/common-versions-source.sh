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
  # The \x2C is a comma in hex; without this trick the regular expression
  # that processes this string in the Makefile, silently fails and the 
  # bfdver.h file remains empty.
  BRANDING="${BRANDING}\x2C ${TARGET_MACHINE}"

  # NINJA_BUILD_GIT_BRANCH=${NINJA_BUILD_GIT_BRANCH:-"master"}
  # NINJA_BUILD_GIT_COMMIT=${NINJA_BUILD_GIT_COMMIT:-"HEAD"}
  README_OUT_FILE_NAME=${README_OUT_FILE_NAME:-"README-${RELEASE_VERSION}.md"}

  # Keep them in sync with combo archive content.
  if [[ "${RELEASE_VERSION}" =~ 0\.55\.3-* ]]
  then

    # -------------------------------------------------------------------------

    PYTHON_VERSION="3.8.5"
  
    if [ "${TARGET_PLATFORM}" == "win32" ]
    then
      download_python3_win "${PYTHON_VERSION}"
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

      build_python3 "${PYTHON_VERSION}"
    fi

    build_meson "0.55.3"

    # -------------------------------------------------------------------------
  else
    echo "Unsupported version ${RELEASE_VERSION}."
    exit 1
  fi
}

# -----------------------------------------------------------------------------
