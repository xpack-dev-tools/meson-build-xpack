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
  if [[ "${RELEASE_VERSION}" =~ 0\.55\.1-* ]]
  then

    # -------------------------------------------------------------------------

    PYTHON_VERSION="3.8.5"
  
    if [ "${TARGET_PLATFORM}" != "win32" ]
    then

      build_zlib "1.2.8"

      build_libmpdec "2.5.0"

      build_expat "2.2.9"

      build_libffi "3.3"

      build_libxcrypt "4.4.17"
      
      build_python3 "${PYTHON_VERSION}"
    fi

    if [ "${TARGET_PLATFORM}" == "win32" ]
    then
      download_python3_win "${PYTHON_VERSION}"

      # Copy the .zip with the entire Python run-time (.pyc files).
      mkdir -pv "${APP_PREFIX}/bin"
      cp -v "${SOURCES_FOLDER_PATH}/${PYTHON3_WIN_EMBED_FOLDER_NAME}/python${PYTHON3_VERSION_MAJOR_MINOR}.zip" \
        "${APP_PREFIX}/bin"
      cp -v "${SOURCES_FOLDER_PATH}/${PYTHON3_WIN_EMBED_FOLDER_NAME}/python.exe" \
        "${APP_PREFIX}/bin/python-meson.exe"

      mkdir -pv "${APP_PREFIX}/bin/DLLs"
      # Copy the Windows specific DLLs (.pyd) to the separate folder;
      # they are dynamically loaded by Python.
      cp -v "${SOURCES_FOLDER_PATH}/${PYTHON3_WIN_EMBED_FOLDER_NAME}"/*.pyd "${APP_PREFIX}/bin/DLLs"
      # Copy the usual DLLs too.
      cp -v "${SOURCES_FOLDER_PATH}/${PYTHON3_WIN_EMBED_FOLDER_NAME}"/*.dll "${APP_PREFIX}/bin/DLLs"

      # From bin are copied dependencies.
      cp -v "${SOURCES_FOLDER_PATH}/${PYTHON3_WIN_EMBED_FOLDER_NAME}"/*.dll "${LIBS_INSTALL_FOLDER_PATH}/bin"

      cp -v "${BUILD_GIT_PATH}/extras/includes/pyconfig-${PYTHON_VERSION}.h" \
        "${SOURCES_FOLDER_PATH}/${PYTHON3_SRC_FOLDER_NAME}/Include/pyconfig.h"

    fi

    build_meson "0.55.1"

    # -------------------------------------------------------------------------
  else
    echo "Unsupported version ${RELEASE_VERSION}."
    exit 1
  fi
}

# -----------------------------------------------------------------------------
