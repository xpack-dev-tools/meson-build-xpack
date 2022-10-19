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

function build_meson()
{
  local meson_version="$1"

  # https://mesonbuild.com
  # https://github.com/mesonbuild/meson/archive/0.55.1.tar.gz
  # https://github.com/mesonbuild/meson/releases
  # https://github.com/mesonbuild/meson/releases/download/0.55.1/meson-0.55.1.tar.gz

  # https://archlinuxarm.org/packages/aarch64/meson/files/PKGBUILD

  # Sep 11 2020, "0.55.3"

  local meson_src_folder_name="meson-${meson_version}"

  # GitHub release archive.
  local meson_archive_file_name="${meson_src_folder_name}.tar.gz"
  # local meson_url="https://github.com/mesonbuild/meson/archive/${meson_version}.tar.gz"
  local meson_url="https://github.com/mesonbuild/meson/releases/download/${meson_version}/${meson_archive_file_name}"

  local meson_folder_name="${meson_src_folder_name}"

  mkdir -pv "${XBB_LOGS_FOLDER_PATH}/${meson_folder_name}"

  cd "${XBB_SOURCES_FOLDER_PATH}"

  (
    set +e
    # When extracting on macOS, tar reports an error related to the symlink,
    # but the extracted content seems fine.
    # tar: meson-0.55.1/test cases/common/227 fs module/a_symlink: Cannot utime: No such file or directory

    download_and_extract "${meson_url}" "${meson_archive_file_name}" \
      "${meson_src_folder_name}"
  )

  local meson_stamp_file_path="${XBB_STAMPS_FOLDER_PATH}/stamp-${meson_folder_name}-installed"
  if [ ! -f "${meson_stamp_file_path}" ]
  then
    (
      mkdir -p "${XBB_BUILD_FOLDER_PATH}/${meson_folder_name}"
      cd "${XBB_BUILD_FOLDER_PATH}/${meson_folder_name}"

      xbb_activate_installed_dev

      # gcc-xbb -pthread
      # -L/Host/Users/ilg/Work/meson-build-0.55.1-1/linux-x64/install/libs/lib64
      # -L/Host/Users/ilg/Work/meson-build-0.55.1-1/linux-x64/install/libs/lib
      # -O2 -Wl,--gc-sections -fno-semantic-interposition -v
      # -Xlinker -export-dynamic -o python.exe Programs/python.o libpython3.8.a
      # -lcrypt -lpthread -ldl  -lutil -lrt -lm   -lm

      if [ "${XBB_TARGET_PLATFORM}" == "win32" ]
      then
        CPPFLAGS="${XBB_CPPFLAGS} -I${XBB_BUILD_FOLDER_PATH}/${meson_folder_name} -I${XBB_SOURCES_FOLDER_PATH}/Python-${XBB_PYTHON3_VERSION}/Include -DPy_BUILD_CORE_BUILTIN=1"
      else
        CPPFLAGS="${XBB_CPPFLAGS} -I${XBB_LIBRARIES_INSTALL_FOLDER_PATH}/include/python${XBB_PYTHON3_VERSION_MAJOR}.${XBB_PYTHON3_VERSION_MINOR} -DPy_BUILD_CORE_BUILTIN=1"
      fi
      CFLAGS="${XBB_CFLAGS_NO_W}"
      CXXFLAGS="${XBB_CXXFLAGS_NO_W}"
      # LDFLAGS="${XBB_LDFLAGS_APP_STATIC_GCC}"
      LDFLAGS="${XBB_LDFLAGS_APP}"
      if [ "${XBB_TARGET_PLATFORM}" == "win32" ]
      then
        LDFLAGS+=" -L${XBB_SOURCES_FOLDER_PATH}/${XBB_PYTHON3_WIN_SRC_FOLDER_NAME}"
      elif [ "${XBB_TARGET_PLATFORM}" == "darwin" ]
      then
        LDFLAGS+=" -L${XBB_LIBRARIES_INSTALL_FOLDER_PATH}/lib"
        if [[ "${CC}" =~ gcc* ]]
        then
          LDFLAGS+=" -fno-semantic-interposition"
        fi
      elif [ "${XBB_TARGET_PLATFORM}" == "linux" ]
      then
        # ${XBB_LIBRARIES_INSTALL_FOLDER_PATH}/lib/libpython3.8.a
        LDFLAGS+=" -L${XBB_LIBRARIES_INSTALL_FOLDER_PATH}/lib "
        LDFLAGS+=" -fno-semantic-interposition"
        LDFLAGS+=" -Xlinker -export-dynamic"
        LDFLAGS+=" -Wl,-rpath,${LD_LIBRARY_PATH}"
      fi

      # Python3 uses these two libraries.
      if [ "${XBB_TARGET_PLATFORM}" == "win32" ]
      then
        LIBS="-lpython${XBB_PYTHON3_VERSION_MAJOR} -lpython${XBB_PYTHON3_VERSION_MAJOR_MINOR}"
      elif [ "${XBB_TARGET_PLATFORM}" == "darwin" ]
      then
        LIBS="-lpython${XBB_PYTHON3_VERSION_MAJOR}.${XBB_PYTHON3_VERSION_MINOR} -lcrypt -lpthread -ldl  -lutil -lm"
      elif [ "${XBB_TARGET_PLATFORM}" == "linux" ]
      then
        # LIBS="${XBB_LIBRARIES_INSTALL_FOLDER_PATH}/lib/libpython${XBB_PYTHON3_VERSION_MAJOR}.${XBB_PYTHON3_VERSION_MINOR}.a ${XBB_LIBRARIES_INSTALL_FOLDER_PATH}/lib/libcrypt.a -lpthread -ldl  -lutil -lrt -lm"
        LIBS="-lpython${XBB_PYTHON3_VERSION_MAJOR}.${XBB_PYTHON3_VERSION_MINOR} -lcrypt -lpthread -ldl  -lutil -lrt -lm"
      fi

      CPPFLAGS+=" -DPYTHON_VERSION_MAJOR=${XBB_PYTHON3_VERSION_MAJOR}"
      CPPFLAGS+=" -DPYTHON_VERSION_MINOR=${XBB_PYTHON3_VERSION_MINOR}"

      if [ "${XBB_IS_DEBUG}" == "y" ]
      then
        CPPFLAGS+=" -DDEBUG"
      fi

      export CPPFLAGS
      export CFLAGS
      export CXXFLAGS
      export LDFLAGS
      export LIBS

      if [ "${XBB_IS_DEVELOP}" == "y" ]
      then
        env | sort
      fi

      # Bring the meson source files into the build folder.
      cp -v "${XBB_BUILD_GIT_PATH}"/src/* .

      if [ "${XBB_TARGET_PLATFORM}" == "win32" ]
      then
        cp -v "${XBB_BUILD_GIT_PATH}/extras/includes/pyconfig-win-${XBB_PYTHON3_VERSION}.h" \
          "pyconfig.h"
      fi

      run_verbose make meson${XBB_DOT_EXE} V=1

      mkdir -pv "${XBB_BINARIES_INSTALL_FOLDER_PATH}/bin"
      install -v -m755 -c meson${XBB_DOT_EXE} "${XBB_BINARIES_INSTALL_FOLDER_PATH}/bin"

      show_libs "${XBB_BINARIES_INSTALL_FOLDER_PATH}/bin/meson"

      local python_with_version="python${XBB_PYTHON3_VERSION_MAJOR}.${XBB_PYTHON3_VERSION_MINOR}"
      if [ ! -d "${XBB_BINARIES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/" ]
      then
        (
          mkdir -pv "${XBB_BINARIES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/"

          echo
          echo "Copying .py files from the standard Python library..."

          # Copy all .py from the original source package.
          cp -r "${XBB_SOURCES_FOLDER_PATH}/${XBB_PYTHON3_SRC_FOLDER_NAME}"/Lib/* \
            "${XBB_BINARIES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/"

          echo "Copying mesonbuild .py code..."
          mkdir -pv "${XBB_BINARIES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/mesonbuild/"
          cp -r "${XBB_SOURCES_FOLDER_PATH}/${meson_src_folder_name}"/mesonbuild/* \
            "${XBB_BINARIES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/mesonbuild/"

          (
            echo "Compiling all python & meson sources..."
            # Compiling tests fails, ignore the errors.
            if [ "${XBB_TARGET_PLATFORM}" == "win32" ]
            then
              run_verbose "${WORK_FOLDER_PATH}/${LINUX_INSTALL_RELATIVE_PATH}/libs/bin/python3" \
                -m compileall \
                -j "${XBB_JOBS}" \
                -f "${XBB_BINARIES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/" \
                || true
            else
              run_verbose "${XBB_LIBRARIES_INSTALL_FOLDER_PATH}/bin/python3.${XBB_PYTHON3_VERSION_MINOR}" \
                -m compileall \
                -j "${XBB_JOBS}" \
                -f "${XBB_BINARIES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/" \
                || true

            fi

            # For just in case.
            find "${XBB_BINARIES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/" \
              \( -name '*.opt-1.pyc' -o -name '*.opt-2.pyc' \) \
              -exec rm -v {} \;
          )

          echo "Replacing .py files with .pyc files..."
          move_pyc "${XBB_BINARIES_INSTALL_FOLDER_PATH}/lib/${python_with_version}"

          mkdir -pv "${XBB_BINARIES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/lib-dynload/"

          echo
          echo "Copying Python shared libraries..."

          if [ "${XBB_TARGET_PLATFORM}" == "win32" ]
          then
            # Copy the Windows specific DLLs (.pyd) to the separate folder;
            # they are dynamically loaded by Python.
            cp -v "${XBB_SOURCES_FOLDER_PATH}/${XBB_PYTHON3_WIN_SRC_FOLDER_NAME}"/*.pyd \
              "${XBB_BINARIES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/lib-dynload/"
            # Copy the usual DLLs too; the python*.dll are used, do not remove them.
            cp -v "${XBB_SOURCES_FOLDER_PATH}/${XBB_PYTHON3_WIN_SRC_FOLDER_NAME}"/*.dll \
              "${XBB_BINARIES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/lib-dynload/"
          else
            # Copy dynamically loaded modules and rename folder.
            cp -r "${XBB_LIBRARIES_INSTALL_FOLDER_PATH}/lib/python${XBB_PYTHON3_VERSION_MAJOR}.${XBB_PYTHON3_VERSION_MINOR}"/lib-dynload/* \
              "${XBB_BINARIES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/lib-dynload/"
          fi
        ) 2>&1 | tee "${XBB_LOGS_FOLDER_PATH}/${meson_folder_name}/build-output-$(ndate).txt"
      fi

      copy_license \
        "${XBB_SOURCES_FOLDER_PATH}/${meson_src_folder_name}" \
        "${meson_folder_name}"

    )

    touch "${meson_stamp_file_path}"

  else
    echo "Component meson already installed."
  fi

  tests_add "test_meson"
}

function process_pyc()
{
  local file_path="$1"

  # echo bbb "${file_path}"

  local file_full_name="$(basename "${file_path}")"
  local file_name="$(echo "${file_full_name}" | sed -e 's|\.cpython-[0-9]*\.pyc||')"
  local folder_path="$(dirname $(dirname "${file_path}"))"

  # echo "${folder_path}" "${file_name}"

  if [ -f "${folder_path}/${file_name}.py" ]
  then
    mv "${file_path}" "${folder_path}/${file_name}.pyc"
    rm "${folder_path}/${file_name}.py"
  fi
}

export -f process_pyc

function process_pycache()
{
  local folder_path="$1"

  find ${folder_path} -name '*.pyc' -type f -print0 | xargs -0 -L 1 -I {} bash -c 'process_pyc "{}"'

  if [ $(ls -1 "${folder_path}" | wc -l) -eq 0 ]
  then
    rm -rf "${folder_path}"
  fi
}

export -f process_pycache

function move_pyc()
{
  local folder_path="$1"

  find ${folder_path} -name '__pycache__' -type d -print0 | xargs -0 -L 1 -I {} bash -c 'process_pycache "{}"'
}


# -----------------------------------------------------------------------------

function test_meson()
{
  echo
  echo "Running the binaries..."

  if [ -d "xpacks/.bin" ]
  then
    TEST_BIN_PATH="$(pwd)/xpacks/.bin"
  elif [ -d "${XBB_BINARIES_INSTALL_FOLDER_PATH}/bin" ]
  then
    TEST_BIN_PATH="${XBB_BINARIES_INSTALL_FOLDER_PATH}/bin"
  else
    echo "Wrong folder."
    exit 1
  fi
  time run_app "${TEST_BIN_PATH}/meson" --version

  run_app "${TEST_BIN_PATH}/meson" --help
  # TODO: Add a minimal test.
}

# -----------------------------------------------------------------------------