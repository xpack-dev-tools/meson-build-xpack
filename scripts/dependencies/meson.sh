# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------

# https://mesonbuild.com
# https://github.com/mesonbuild/meson/archive/0.55.1.tar.gz
# https://github.com/mesonbuild/meson/releases
# https://github.com/mesonbuild/meson/releases/download/0.55.1/meson-0.55.1.tar.gz

# https://archlinuxarm.org/packages/aarch64/meson/files/PKGBUILD

# Sep 11 2020, "0.55.3"

# -----------------------------------------------------------------------------

function meson_build()
{
  echo_develop
  echo_develop "[${FUNCNAME[0]} $@]"

  local meson_version="$1"
  shift

  local python_packaging_version=""
  local python_setuptools_version=""

  while [ $# -gt 0 ]
  do
    case "$1" in
      --packaging-version=* )
        python_packaging_version=$(xbb_parse_option "$1")
        shift
        ;;

      --setuptools-version=* )
        python_setuptools_version=$(xbb_parse_option "$1")
        shift
        ;;

      * )
        echo "Unsupported argument $1 in ${FUNCNAME[0]}()"
        exit 1
        ;;
    esac
  done

  local meson_src_folder_name="meson-${meson_version}"

  # GitHub release archive.
  local meson_archive_file_name="${meson_src_folder_name}.tar.gz"
  # local meson_url="https://github.com/mesonbuild/meson/archive/${meson_version}.tar.gz"
  local meson_url="https://github.com/mesonbuild/meson/releases/download/${meson_version}/${meson_archive_file_name}"

  local meson_folder_name="${meson_src_folder_name}"

  local python_with_version="python${XBB_PYTHON3_VERSION_MAJOR}.${XBB_PYTHON3_VERSION_MINOR}"

  mkdir -pv "${XBB_LOGS_FOLDER_PATH}/${meson_folder_name}"

  local meson_stamp_file_path="${XBB_STAMPS_FOLDER_PATH}/stamp-${meson_folder_name}-installed"
  if [ ! -f "${meson_stamp_file_path}" ]
  then
    (
      mkdir -pv "${XBB_SOURCES_FOLDER_PATH}"
      cd "${XBB_SOURCES_FOLDER_PATH}"

      # When extracting on macOS, tar reports an error related to the symlink,
      # but the extracted content seems fine.
      # tar: meson-0.55.1/test cases/common/227 fs module/a_symlink: Cannot utime: No such file or directory

      download_and_extract "${meson_url}" "${meson_archive_file_name}" \
        "${meson_src_folder_name}"

      if false
      then
        run_verbose sed -i.bak \
          -e "s|if getattr(sys, 'frozen', False) and hasattr(sys, '_MEIPASS'):|if getattr(sys, 'frozen', False):|" \
          "${meson_src_folder_name}/mesonbuild/utils/universal.py"
      fi

      mkdir -p "${XBB_BUILD_FOLDER_PATH}/${meson_folder_name}"
      cd "${XBB_BUILD_FOLDER_PATH}/${meson_folder_name}"

      xbb_activate_dependencies_dev

      # gcc-xbb -pthread
      # -L/Host/Users/ilg/Work/meson-build-0.55.1-1/linux-x64/install/libs/lib64
      # -L/Host/Users/ilg/Work/meson-build-0.55.1-1/linux-x64/install/libs/lib
      # -O2 -Wl,--gc-sections -fno-semantic-interposition -v
      # -Xlinker -export-dynamic -o python.exe Programs/python.o libpython3.8.a
      # -lcrypt -lpthread -ldl  -lutil -lrt -lm   -lm

      if [ "${XBB_HOST_PLATFORM}" == "win32" ]
      then
        CPPFLAGS="${XBB_CPPFLAGS} -I${XBB_BUILD_FOLDER_PATH}/${meson_folder_name} -I${XBB_SOURCES_FOLDER_PATH}/Python-${XBB_PYTHON3_VERSION}/Include -DPy_BUILD_CORE_BUILTIN=1"
      else
        CPPFLAGS="${XBB_CPPFLAGS} -I${XBB_LIBRARIES_INSTALL_FOLDER_PATH}/include/python${XBB_PYTHON3_VERSION_MAJOR}.${XBB_PYTHON3_VERSION_MINOR} -DPy_BUILD_CORE_BUILTIN=1"
      fi
      CFLAGS="${XBB_CFLAGS_NO_W}"
      CXXFLAGS="${XBB_CXXFLAGS_NO_W}"

      LDFLAGS="${XBB_LDFLAGS_APP}"

      if [ "${XBB_HOST_PLATFORM}" == "win32" ]
      then
        LDFLAGS+=" -L${XBB_SOURCES_FOLDER_PATH}/${XBB_PYTHON3_WIN_SRC_FOLDER_NAME}"
      elif [ "${XBB_HOST_PLATFORM}" == "darwin" ]
      then
        LDFLAGS+=" -L${XBB_LIBRARIES_INSTALL_FOLDER_PATH}/lib"
        if [[ "$(basename ${CC})" =~ .*gcc.* ]]
        then
          LDFLAGS+=" -fno-semantic-interposition"
        fi
      elif [ "${XBB_HOST_PLATFORM}" == "linux" ]
      then
        # ${XBB_LIBRARIES_INSTALL_FOLDER_PATH}/lib/libpython3.8.a
        LDFLAGS+=" -L${XBB_LIBRARIES_INSTALL_FOLDER_PATH}/lib "
        LDFLAGS+=" -fno-semantic-interposition"
        LDFLAGS+=" -Xlinker -export-dynamic"
      fi

      # Python3 uses these two libraries.
      if [ "${XBB_HOST_PLATFORM}" == "win32" ]
      then
        LIBS="-lpython${XBB_PYTHON3_VERSION_MAJOR} -lpython${XBB_PYTHON3_VERSION_MAJOR_MINOR}"
      elif [ "${XBB_HOST_PLATFORM}" == "darwin" ]
      then
        LIBS="-lpython${XBB_PYTHON3_VERSION_MAJOR}.${XBB_PYTHON3_VERSION_MINOR} -lcrypt -lpthread -ldl  -lutil -lm"
      elif [ "${XBB_HOST_PLATFORM}" == "linux" ]
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

      xbb_adjust_ldflags_rpath

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

      if [ "${XBB_HOST_PLATFORM}" == "win32" ]
      then
        cp -v "${helper_folder_path}/extras/python/pyconfig-win-${XBB_PYTHON3_VERSION}.h" \
          "pyconfig.h"
      fi

      run_verbose make meson${XBB_HOST_DOT_EXE} V=1

      run_verbose install -d -m 755 "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/bin"

      # Install the meson standalone binary.
      run_verbose install -v -c -m 755 meson${XBB_HOST_DOT_EXE} "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/bin"

      show_host_libs "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/bin/meson"

      if false
      then
        # Install the meson Python interpreter.
        # run_verbose install -v -c -m 755 \
        "${XBB_DEPENDENCIES_INSTALL_FOLDER_PATH}/bin/${python_with_version}${XBB_HOST_DOT_EXE}" \
        "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/bin/meson-python${XBB_PYTHON3_VERSION_MAJOR}"
      fi

      if true # [ ! -d "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/" ]
      then
        (
          mkdir -pv "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/"

          echo
          echo "Copying .py files from the standard Python library..."

          # Use the installed location, not the source, since there are extra
          # cases like _sysconfigdata__darwin_darwin.py
          cp -r "${XBB_DEPENDENCIES_INSTALL_FOLDER_PATH}/lib/${python_with_version}" \
            "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/lib"


          echo "pip install mesonbuild..."
          run_verbose "${XBB_DEPENDENCIES_INSTALL_FOLDER_PATH}/bin/${python_with_version}${XBB_HOST_DOT_EXE}" \
            -m pip install --target "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/site-packages" "${XBB_SOURCES_FOLDER_PATH}/${meson_folder_name}"

          if [ ! -z "${python_packaging_version}" ]
          then
            echo "pip install packaging ${python_packaging_version}..."
            run_verbose "${XBB_DEPENDENCIES_INSTALL_FOLDER_PATH}/bin/${python_with_version}${XBB_HOST_DOT_EXE}" \
              -m pip install --target "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/site-packages" packaging==${python_packaging_version}
          fi

          if [ ! -z "${python_setuptools_version}" ]
          then
            echo "pip install setuptools ${python_setuptools_version}..."
            run_verbose "${XBB_DEPENDENCIES_INSTALL_FOLDER_PATH}/bin/${python_with_version}${XBB_HOST_DOT_EXE}" \
              -m pip install --target "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/site-packages" setuptools==${python_setuptools_version}
          fi

          echo "cleanups..."
          run_verbose rm -rfv \
            "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/site-packages/bin" \
            "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/site-packages/share" \
            "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/site-packages"/pip*

          (
            echo "Compiling all python & meson sources..."
            # Compiling tests fails, ignore the errors.

            run_verbose "${XBB_NATIVE_DEPENDENCIES_INSTALL_FOLDER_PATH}/bin/${python_with_version}" \
              -m compileall \
              -j "${XBB_JOBS}" \
              -f "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/" \
              || true

            # For just in case.
            find "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/" \
              \( -name '*.opt-1.pyc' -o -name '*.opt-2.pyc' \) \
              -exec rm -v {} \;
          )

          if true
          then
            echo "Replacing .py files with .pyc files..."
            python3_move_pyc "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/lib/${python_with_version}"
          fi

          # Restore files that known to be used as scripts,
          # like `mesonbuild/scripts/python_info.py`.
          echo "Restoring .py scripts..."
          run_verbose cp -Rf \
            "${XBB_SOURCES_FOLDER_PATH}/${meson_folder_name}/mesonbuild/scripts"/* \
            "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/site-packages/mesonbuild/scripts"

          echo
          echo "Copying Python shared libraries..."

          mkdir -pv "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/lib-dynload/"

          if [ "${XBB_HOST_PLATFORM}" == "win32" ]
          then
            # Copy the Windows specific DLLs (.pyd) to the separate folder;
            # they are dynamically loaded by Python.
            cp -v "${XBB_SOURCES_FOLDER_PATH}/${XBB_PYTHON3_WIN_SRC_FOLDER_NAME}"/*.pyd \
              "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/lib-dynload/"
            # Copy the usual DLLs too; the python*.dll are used, do not remove them.
            cp -v "${XBB_SOURCES_FOLDER_PATH}/${XBB_PYTHON3_WIN_SRC_FOLDER_NAME}"/*.dll \
              "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/lib-dynload/"
          else
            # Copy dynamically loaded modules and rename folder.
            cp -r "${XBB_LIBRARIES_INSTALL_FOLDER_PATH}/lib/python${XBB_PYTHON3_VERSION_MAJOR}.${XBB_PYTHON3_VERSION_MINOR}"/lib-dynload/* \
              "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/lib/${python_with_version}/lib-dynload/"
          fi
        ) 2>&1 | tee "${XBB_LOGS_FOLDER_PATH}/${meson_folder_name}/build-output-$(ndate).txt"
      fi

      copy_license \
        "${XBB_SOURCES_FOLDER_PATH}/${meson_src_folder_name}" \
        "${meson_folder_name}"

    )

    mkdir -pv "${XBB_STAMPS_FOLDER_PATH}"
    touch "${meson_stamp_file_path}"

  else
    echo "Component meson already installed"
  fi

  tests_add "meson_test" "${XBB_EXECUTABLES_INSTALL_FOLDER_PATH}/bin"
}

# -----------------------------------------------------------------------------

function meson_test()
{
  local test_bin_path="$1"

  echo
  echo "Running the binaries..."

  run_host_app_verbose "${test_bin_path}/meson" --version

  run_host_app_verbose "${test_bin_path}/meson" --help

  # TODO: Add a minimal functional test.
}

# -----------------------------------------------------------------------------
