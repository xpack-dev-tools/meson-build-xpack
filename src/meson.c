#define PY_SSIZE_T_CLEAN
#include <Python.h>
// Note Since Python may define some pre-processor definitions which
// affect the standard headers on some systems, you must include 
// Python.h before any standard headers are included.

#ifdef __MINGW32__
#include <windows.h>
#endif

# if defined(__APPLE__)
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

int
main(int argc, char* argv[])
{
#if defined(DEBUG)
  printf("argc %d\n", argc);
  for (int i = 0; i < argc; ++i) {
    printf("argv[%d]='%s'\n", i, argv[i]);
  }
#endif

  char self_exe_path[PATH_MAX];

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
  char self_nsgetexe_path[PATH_MAX];
  len = sizeof(self_nsgetexe_path) - 1;
  // In general it may be a symbolic link, and readlink() must be used,
  // but in this specific case it is not.
  _NSGetExecutablePath(self_nsgetexe_path, &len);
  self_nsgetexe_path[len] = 0;
#if defined(DEBUG)
  printf("self_nsgetexe_path: %s\n", self_nsgetexe_path);
#endif
  struct stat self_nsgetexe_stat;
  if (lstat(self_nsgetexe_path, &self_nsgetexe_stat) < 0) {
    fprintf(stderr, "Fatal error: cannot lstat (%s)\n", strerror(errno));
    exit(1);
  }
  if (S_ISLNK(self_nsgetexe_stat.st_mode)) {
    len = readlink(self_nsgetexe_path, self_exe_path, sizeof(self_exe_path) - 1);
  } else {
    strcpy(self_exe_path, self_nsgetexe_path);
    len = strlen(self_exe_path);
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
  printf("self_exe_path: %s\n", self_exe_path);
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
  printf("self_folder_path: %s\n", self_folder_path);
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
  printf("home_folder_path: %s\n", home_folder_path);
#endif

  wchar_t* whome;
#if defined(DEBUG)
  whome = Py_GetPythonHome();
  printf("initial home %ls\n", whome);
#endif

  wchar_t* new_whome = Py_DecodeLocale(home_folder_path, NULL);
  Py_SetPythonHome(new_whome);
#if defined(DEBUG)
  printf("new home: %ls\n", new_whome);
#endif

  wchar_t* wpath = Py_GetPath();
#if defined(DEBUG)
  printf("initial path: %ls\n", wpath);
#endif

  char python_folder_name[] = "pythonXX.YY";
  snprintf(python_folder_name, sizeof(python_folder_name) - 1, "python%d.%d", 
    PYTHON_VERSION_MAJOR, PYTHON_VERSION_MINOR);

  char new_path[PATH_MAX * 2];
  new_path[0] = '\0';

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

  wchar_t* new_wpath = Py_DecodeLocale(new_path, NULL);
  Py_SetPath(new_wpath);
#if defined(DEBUG)
  printf("new path: %ls\n", new_wpath);
#endif

#if defined(DEBUG)
  wchar_t *full_path = Py_GetProgramFullPath();
  wchar_t *prefix = Py_GetPrefix();
  wchar_t *exec_prefix = Py_GetExecPrefix();

  printf("full_path %ls\n", full_path);
  printf("prefix %ls\n", prefix);
  printf("exec_prefix %ls\n", exec_prefix);
#endif

  Py_Initialize();
  if (! Py_IsInitialized()) {
    fprintf(stderr, "Fatal error: cannot initialise Python environment.\n");
    exit(1);
  }
  
#if defined(DEBUG)
  printf("initialised\n");
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
  
#if defined(DEBUG)
  // PyRun_SimpleString("print(sys.builtin_module_names)\n");
  // PyRun_SimpleString("print(sys.modules.keys())\n");

  PyRun_SimpleString("print(sys.executable)\n");
  PyRun_SimpleString("print(sys.path)\n");
  
  PyRun_SimpleString("print(sys.argv)\n");
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
  printf("exiting...\n");
#endif

  // Cleanups. 
  // Normally all allocated wide strings must be freed,
  // but before exit it makes not much sense.
  PyMem_RawFree(new_wpath);
  PyMem_RawFree(wpath);
  for (int i=0; i < argc; ++i) {
    PyMem_RawFree(wargv[i]);
  }
  PyMem_RawFree(wargv0);
  PyMem_RawFree(wself_exe_path);

  return 0;
}