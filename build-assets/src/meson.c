#define PY_SSIZE_T_CLEAN
#include <Python.h>
// Note Since Python may define some pre-processor definitions which
// affect the standard headers on some systems, you must include
// Python.h before any standard headers are included.

#ifdef __MINGW32__
#include <windows.h>
#endif

# if defined(__APPLE__)
#include <libproc.h>
#include <mach-o/dyld.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#endif

#include <stdio.h>
#include <wchar.h>

// https://docs.python.org/3/extending/embedding.html
// https://docs.python.org/3/c-api/index.html
// https://docs.python.org/3/c-api/init.html

#define HAS_MEIPASS

int
main(int argc, char* argv[])
{
#if defined(DEBUG)
  fprintf(stderr, "argc: %d\n", argc);
  for (int i = 0; i < argc; ++i) {
    fprintf(stderr, "argv[%d]: '%s'\n", i, argv[i]);
  }
#endif

#if defined(__APPLE__)
  char self_exe_path[PROC_PIDPATHINFO_SIZE+1];
  char pyinstaller_meipass[PROC_PIDPATHINFO_SIZE+1];
#else
  char self_exe_path[PATH_MAX];
  char pyinstaller_meipass[PATH_MAX];
#endif

  int len = 0;

#if defined(__MINGW32__)

#define FILE_SEPARATOR '\\'
#define FILE_SEPARATOR_STR "\\"
#define PATH_SEPARATOR_STR ";"
  len = GetModuleFileName(NULL, self_exe_path, sizeof(self_exe_path) - 1);

#elif defined(__APPLE__)

#define FILE_SEPARATOR '/'
#define FILE_SEPARATOR_STR "/"
#define PATH_SEPARATOR_STR ":"
  // The size must be at least PROC_PIDPATHINFO_SIZE, otherwise the call
  // fails with ENOMEM (12).
  // https://opensource.apple.com/source/Libc/Libc-498/darwin/libproc.c
  len = proc_pidpath(getpid(), self_exe_path, sizeof(self_exe_path) - 1);
  if ( len <= 0 ) {
    fprintf(stderr, "Fatal error: cannot proc_pidpath (%s)\n", strerror(errno));
    exit(1);
  }

#elif defined(__linux__)

#define FILE_SEPARATOR '/'
#define FILE_SEPARATOR_STR "/"
#define PATH_SEPARATOR_STR ":"
  len = readlink("/proc/self/exe", self_exe_path, sizeof(self_exe_path) - 1);

#endif

  if (len <= 0) {
    fprintf(stderr, "Fatal error: cannot get self path (%s)\n", strerror(errno));
    exit(1);
  }

  self_exe_path[len] = 0;
#if defined(DEBUG)
  fprintf(stderr, "self_exe_path: %s\n", self_exe_path);
#endif

  // Set the program name to the full executable path.
  // Prefer self_exe_path, argv0 usually is not absolute.
  wchar_t* wself_exe_path = Py_DecodeLocale(self_exe_path, NULL);
  Py_SetProgramName(wself_exe_path);

  // The executable folder path, like .../bin.
  char self_folder_path[PATH_MAX];
  char* last_slash;

  strcpy(self_folder_path, self_exe_path);
  last_slash = strrchr(self_folder_path, FILE_SEPARATOR);
  if (last_slash == NULL) {
    fprintf(stderr, "Fatal error: cannot get folder path from %s\n", self_exe_path);
    exit(1);
  }
  // Remove the slash and the name.
  *(last_slash) = '\0';
#if defined(DEBUG)
  fprintf(stderr, "self_folder_path: %s\n", self_folder_path);
#endif

  // The home folder path, like the first part of PYTHONHOME.
  char home_folder_path[PATH_MAX];

  strcpy(home_folder_path, self_folder_path);
  last_slash = strrchr(home_folder_path, FILE_SEPARATOR);
  if (last_slash == NULL) {
    fprintf(stderr, "Fatal error: cannot get folder path from %s\n", self_folder_path);
    exit(1);
  }
  // Remove the slash and the name.
  *(last_slash) = '\0';
#if defined(DEBUG)
  fprintf(stderr, "home_folder_path: %s\n", home_folder_path);
#endif

  wchar_t* whome;
#if defined(DEBUG)
  whome = Py_GetPythonHome();
  fprintf(stderr, "initial Py_GetPythonHome(): %ls\n", whome);
#endif

  wchar_t* new_whome = Py_DecodeLocale(home_folder_path, NULL);
  Py_SetPythonHome(new_whome);
#if defined(DEBUG)
  fprintf(stderr, "Py_SetPythonHome('%ls')\n", new_whome);
#endif

  wchar_t* wpath = Py_GetPath();
#if defined(DEBUG)
  fprintf(stderr, "initial Py_GetPath(): %ls\n", wpath);
#endif

  char python_folder_name[] = "pythonXX.YY";
  snprintf(python_folder_name, sizeof(python_folder_name) - 1, "python%d.%d",
    PYTHON_VERSION_MAJOR, PYTHON_VERSION_MINOR);

  char new_path[PATH_MAX * 3];
  new_path[0] = '\0';

#if defined(__MINGW32__)

  // The default is:
  // sys.path:  ['', 'Z:\\home\\ilg\\Work\\xpack-dev-tools\\meson-build-xpack.git\\build\\win32-x64\\application\\bin\\python311.zip', 'Z:\\home\\ilg\\Work\\xpack-dev-tools\\meson-build-xpack.git\\build\\win32-x64\\application\\DLLs', 'Z:\\home\\ilg\\Work\\xpack-dev-tools\\meson-build-xpack.git\\build\\win32-x64\\application\\Lib', 'Z:\\home\\ilg\\Work\\xpack-dev-tools\\meson-build-xpack.git\\build\\win32-x64\\application\\bin', 'Z:\\home\\ilg\\Work\\xpack-dev-tools\\meson-build-xpack.git\\build\\win32-x64\\application', 'Z:\\home\\ilg\\Work\\xpack-dev-tools\\meson-build-xpack.git\\build\\win32-x64\\application\\Lib\\site-packages']

  // Do not Py_SetPath(), for consistency with the embedded
  // python.exe, stick to the defaults.

#else

  // The default is:
  // sys.path:  ['', '/home/ilg/Work/xpack-dev-tools/meson-build-xpack.git/build/linux-x64/application/lib/python311.zip', '/home/ilg/Work/xpack-dev-tools/meson-build-xpack.git/build/linux-x64/application/lib/python3.11', '/home/ilg/Work/xpack-dev-tools/meson-build-xpack.git/build/linux-x64/application/lib/python3.11/lib-dynload', '/home/ilg/Work/xpack-dev-tools/meson-build-xpack.git/build/linux-x64/application/lib/python3.11/site-packages']

#if 0
  strcat(new_path, home_folder_path);
  strcat(new_path, FILE_SEPARATOR_STR);
  strcat(new_path, "lib");
  strcat(new_path, FILE_SEPARATOR_STR);
  strcat(new_path, python_folder_name);

  strcat(new_path, PATH_SEPARATOR_STR);

  strcat(new_path, home_folder_path);
  strcat(new_path, FILE_SEPARATOR_STR);
  strcat(new_path, "lib");
  strcat(new_path, FILE_SEPARATOR_STR);
  strcat(new_path, python_folder_name);
  strcat(new_path, FILE_SEPARATOR_STR);
  strcat(new_path, "lib-dynload");

  strcat(new_path, PATH_SEPARATOR_STR);

  strcat(new_path, home_folder_path);
  strcat(new_path, FILE_SEPARATOR_STR);
  strcat(new_path, "lib");
  strcat(new_path, FILE_SEPARATOR_STR);
  strcat(new_path, python_folder_name);
  strcat(new_path, FILE_SEPARATOR_STR);
  strcat(new_path, "site-packages");

  wchar_t* new_wpath = Py_DecodeLocale(new_path, NULL);
  Py_SetPath(new_wpath);
#if defined(DEBUG)
  fprintf(stderr, "Py_SetPath('%ls')\n", new_wpath);
#endif
#endif

#endif

#if defined(DEBUG)
  wchar_t *full_path = Py_GetProgramFullPath();
  wchar_t *prefix = Py_GetPrefix();
  wchar_t *exec_prefix = Py_GetExecPrefix();

  fprintf(stderr, "Py_GetProgramFullPath(): %ls\n", full_path);
  fprintf(stderr, "Py_GetPrefix(): %ls\n", prefix);
  fprintf(stderr, "Py_GetExecPrefix(): %ls\n", exec_prefix);
#endif

  Py_Initialize();
  if (! Py_IsInitialized()) {
    fprintf(stderr, "Fatal error: cannot initialise the Python environment.\n");
    exit(1);
  }

#if defined(DEBUG)
  fprintf(stderr, "Py_IsInitialized()\n");
#endif

  // Override argv[0] with the actual path, for consistency with Windows,
  // which uses sys.executable:
  //
  //  if 'meson.exe' in sys.executable:
  //      assert(os.path.isabs(sys.executable))
  //      launcher = sys.executable
  //  else:
  //      launcher = os.path.realpath(sys.argv[0])
  argv[0] = self_exe_path;

  wchar_t* wargv[argc];
  for (int i=0; i < argc; ++i) {
    wargv[i] = Py_DecodeLocale(argv[i], NULL);
  }

  // It is recommended that applications embedding the Python interpreter
  // for purposes other than executing a single script to pass 0 as updatepath,
  // and update sys.path themselves if desired.
  PySys_SetArgvEx(argc, wargv, 0);

  PyRun_SimpleString("import sys\n");

  PyRun_SimpleString("sys.frozen = True\n");
  PyRun_SimpleString("sys.is_xpack = True\n");

#if defined(HAS_MEIPASS)
  // Normally sys._MEIPASS is the PyInstaller bundle path,
  // i.e. the `.../_internal` folder.
  // In our case, it is the `.../lib/pythonX.YY` folder,
  // or .../bin/Lib on Windows (a bit weird).

  pyinstaller_meipass[0] = '\0';

#if defined(__MINGW32__)

  strcat(pyinstaller_meipass, home_folder_path);
  strcat(pyinstaller_meipass, FILE_SEPARATOR_STR);
  strcat(pyinstaller_meipass, "Lib");

#else

  strcat(pyinstaller_meipass, home_folder_path);
  strcat(pyinstaller_meipass, FILE_SEPARATOR_STR);
  strcat(pyinstaller_meipass, "lib");
  strcat(pyinstaller_meipass, FILE_SEPARATOR_STR);
  strcat(pyinstaller_meipass, python_folder_name);

#endif

#if defined(DEBUG)
  fprintf(stderr, "pyinstaller_meipass: %s\n", pyinstaller_meipass);
#endif

  char sys_meipass[sizeof(pyinstaller_meipass) + sizeof("sys._MEIPASS = '...'\n")];
#if defined(__MINGW32__)
  char pyinstaller_meipass_escaped[PATH_MAX];

  char* p = pyinstaller_meipass;
  char* q = pyinstaller_meipass_escaped;
  while (*p) {
    if ( *p == '\\') {
      *q++ = '\\';
    }
    *q++ = *p++;
  }
  *q++ = '\0';

  snprintf(sys_meipass, sizeof(sys_meipass), "sys._MEIPASS = '%s'\n", pyinstaller_meipass_escaped);
#else
  snprintf(sys_meipass, sizeof(sys_meipass), "sys._MEIPASS = '%s'\n", pyinstaller_meipass);
#endif

#if defined(DEBUG)
  fprintf(stderr, "sys_meipass: %s\n", sys_meipass);
#endif

  PyRun_SimpleString(sys_meipass);
#endif

#if defined(DEBUG)
  // PyRun_SimpleString("print(sys.builtin_module_names)\n");
  // PyRun_SimpleString("print(sys.modules.keys())\n");

  PyRun_SimpleString("print('sys.executable: ', sys.executable, file=sys.stderr)\n");
  PyRun_SimpleString("print('sys.path: ', sys.path, file=sys.stderr)\n");
  PyRun_SimpleString("print('sys.frozen: ', sys.frozen, file=sys.stderr)\n");
#if defined(HAS_MEIPASS)
  PyRun_SimpleString("print(sys._MEIPASS, file=sys.stderr)\n");
#endif

  PyRun_SimpleString("print('sys.argv: ', sys.argv, file=sys.stderr)\n");
#endif

  // PyRun_SimpleString("sys.exit(2)\n");
  PyRun_SimpleString("from mesonbuild import mesonmain\n");
  // For now do not pass exit code.
  PyRun_SimpleString("sys.exit(mesonmain.main())\n");

  // For now sys.exit throws an exception and execution does not get here.

  // We're done. Turn off the light.
  if (Py_FinalizeEx() < 0) {
      exit(120);
  }

#if defined(DEBUG)
  fprintf(stderr, "exiting...\n");
#endif

  // Cleanups.
  // Normally all allocated wide strings must be freed,
  // but before exit it makes not much sense.

  return 0;
}
