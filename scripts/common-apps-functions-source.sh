# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software 
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# Helper script used in the second edition of the xPack build 
# scripts. As the name implies, it should contain only functions and 
# should be included with 'source' by the container build scripts.

# -----------------------------------------------------------------------------

# https://github.com/meson-build/meson/wiki
# https://sourceforge.net/projects/msys2/files/REPOS/MSYS2/Sources/meson-1.10.0-1.src.tar.gz/download

function build_meson()
{
  local meson_version="$1"

  # https://mesonbuild.com
  # https://github.com/mesonbuild/meson/archive/0.55.1.tar.gz
  # https://github.com/mesonbuild/meson/releases/download/0.55.1/meson-0.55.1.tar.gz

  # https://archlinuxarm.org/packages/aarch64/meson/files/PKGBUILD

  local meson_src_folder_name="meson-${meson_version}"
  local meson_folder_name="${meson_src_folder_name}"

  # GitHub release archive.
  local meson_archive_file_name="${meson_src_folder_name}.tar.gz"
  # local meson_url="https://github.com/mesonbuild/meson/archive/${meson_version}.tar.gz"
  local meson_url="https://github.com/mesonbuild/meson/releases/download/${meson_archive_file_name}"

  cd "${SOURCES_FOLDER_PATH}"

  (
    set +e
    # When extracting on macOS, tar reports an error related to the symlink,
    # but the extracted content seems fine.
    # tar: meson-0.55.1/test cases/common/227 fs module/a_symlink: Cannot utime: No such file or directory
  
    download_and_extract "${meson_url}" "${meson_archive_file_name}" \
      "${meson_src_folder_name}"
  )

  (
    mkdir -p "${BUILD_FOLDER_PATH}/${meson_folder_name}"
    cd "${BUILD_FOLDER_PATH}/${meson_folder_name}"

    mkdir -pv "${LOGS_FOLDER_PATH}/${meson_folder_name}"

    xbb_activate
    # xbb_activate_installed_dev

    local build_win32
    if [ "${TARGET_PLATFORM}" == "win32" ]
    then
      prepare_gcc_env "${CROSS_COMPILE_PREFIX}-"
    fi

    CPPFLAGS="${XBB_CPPFLAGS} -I${SOURCES_FOLDER_PATH}/Python-${PYTHON_VERSION}/Include"
    CFLAGS="${XBB_CFLAGS_NO_W}"
    CXXFLAGS="${XBB_CXXFLAGS_NO_W}"
    LDFLAGS="${XBB_LDFLAGS_APP_STATIC_GCC} -L${INSTALL_FOLDER_PATH}/libs/lib"

    # Python3 uses these two libraries.
    LIBS="-lpython${PYTHON_VERSION_MAJOR} -lpython${PYTHON_VERSION_MAJOR_MINOR}"

    export CPPFLAGS
    export CFLAGS
    export CXXFLAGS
    export LDFLAGS
    export LIBS

    env | sort

    cp -v "${BUILD_GIT_PATH}/src"/* .

    if [ "${TARGET_PLATFORM}" == "win32" ]
    then
      run_verbose make meson.exe V=1

      mkdir -pv "${APP_PREFIX}/bin"    
      install -v -m755 -c meson.exe "${APP_PREFIX}/bin"
    else
      run_verbose make meson V=1

      mkdir -pv "${APP_PREFIX}/bin"    
      install -v -m755 -c meson "${APP_PREFIX}/bin"
    fi

    prepare_app_libraries "${APP_PREFIX}/bin/meson"

    copy_license \
      "${SOURCES_FOLDER_PATH}/${meson_src_folder_name}" \
      "${meson_folder_name}"

  )

  tests_add "test_meson"
}

# -----------------------------------------------------------------------------

function test_meson()
{
  if [ "${TARGET_PLATFORM}" == "win32" -a "${TARGET_BITS}" == "32" ]
  then
    : # skip, Wine fails.
  else
    run_app "${APP_PREFIX}/bin/meson" --version
  fi
}

# -----------------------------------------------------------------------------
