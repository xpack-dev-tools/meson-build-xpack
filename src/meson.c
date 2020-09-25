#define PY_SSIZE_T_CLEAN
#include <Python.h>
// Note Since Python may define some pre-processor definitions which
// affect the standard headers on some systems, you must include 
// Python.h before any standard headers are included.

#ifdef __MINGW32__
#include <windows.h>
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

#if 0
  char python_folder_name[] = "pythonXX.YY";
  snprintf(python_folder_name, sizeof(python_folder_name) - 1, "python%d.%d", 
    PYTHON3_VERSION_MAJOR, PYTHON3_VERSION_MINOR);
#endif

  char self_exe_path[PATH_MAX];
  char self_folder_path[PATH_MAX];
  char root_folder_path[PATH_MAX];
  int len;
#ifdef __MINGW32__
#define FILE_SEPARATOR '\\'
#define FILE_SEPARATOR_STR "\\"
#define PATH_SEPARATOR_STR ";"
  len = GetModuleFileName(NULL, self_exe_path, sizeof(self_exe_path) - 1);
#else
#define FILE_SEPARATOR '/'
#define FILE_SEPARATOR_STR "/"
#define PATH_SEPARATOR_STR ":"
  len = readlink("/proc/self/exe", self_exe_path, sizeof(self_exe_path) - 1);
#endif
  if (len <= 0) {
    fprintf(stderr, "Fatal error: cannot get self path\n");
    exit(1);
  }

  self_exe_path[len] = 0;
#if defined(DEBUG)
  printf("self_exe_path: %s\n", self_exe_path);
#endif

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

  strcpy(root_folder_path, self_folder_path);
  last_slash = strrchr(root_folder_path, FILE_SEPARATOR);
  if (last_slash == NULL) {
    fprintf(stderr, "Fatal error: cannot get folder path from %s\n", self_folder_path);
    exit(1);
  }
  // Remove the slash and the name.
  *(last_slash) = '\0';
#if defined(DEBUG)
  printf("root_folder_path: %s\n", root_folder_path);
#endif

  char* argv0 = argv[0];
  wchar_t* wargv0 = Py_DecodeLocale(argv0, NULL);
  argv[0] = "";

  wchar_t* wargv[argc];
  for (int i=0; i < argc; ++i) {
    wargv[i] = Py_DecodeLocale(argv[i], NULL);
  }

  wchar_t* wpath = Py_GetPath();
#if defined(DEBUG)
  printf("initial path: %ls\n", wpath);
#endif

  char new_path[PATH_MAX * 3];
  new_path[0] = '\0';
  strcat(new_path, root_folder_path);
  strcat(new_path, FILE_SEPARATOR_STR);
  strcat(new_path, "lib");
  strcat(new_path, FILE_SEPARATOR_STR);
  strcat(new_path, "python");
  strcat(new_path, PATH_SEPARATOR_STR);
  strcat(new_path, root_folder_path);
  strcat(new_path, FILE_SEPARATOR_STR);
  strcat(new_path, "lib");
  strcat(new_path, FILE_SEPARATOR_STR);
  strcat(new_path, "python.zip");
  strcat(new_path, PATH_SEPARATOR_STR);
  strcat(new_path, root_folder_path);
  strcat(new_path, FILE_SEPARATOR_STR);
  strcat(new_path, "lib");
  strcat(new_path, FILE_SEPARATOR_STR);
  strcat(new_path, "python-dynload");

  wchar_t* new_wpath = Py_DecodeLocale(new_path, NULL);
  Py_SetPath(new_wpath);
#if defined(DEBUG)
  printf("new path: %ls\n", new_wpath);
#endif

#if defined(_DEBUG)
  wchar_t *full_path = Py_GetProgramFullPath();
  wchar_t *prefix = Py_GetPrefix();
  wchar_t *exec_prefix = Py_GetExecPrefix();
  wchar_t *home = Py_GetPythonHome();

  printf("full_path %ls\n", full_path);
  printf("path %ls\n", full_path);
  printf("prefix %ls\n", prefix);
  printf("exec_prefix %ls\n", exec_prefix);
  printf("home %ls\n", home);
#endif

  if (wargv0 == NULL) {
    fprintf(stderr, "Fatal error: cannot decode argv[0]\n");
    exit(1);
  }
  // The argument should point to a zero-terminated wide character string
  // in static storage 
  Py_SetProgramName(wargv0);  /* optional but recommended */

  Py_Initialize();
  if (! Py_IsInitialized()) {
    fprintf(stderr, "Fatal error: cannot initialise Python environment.\n");
    exit(1);
  }
  
#if defined(DEBUG)
  printf("initialised\n");
#endif

  // It is recommended that applications embedding the Python interpreter
  // for purposes other than executing a single script pass 0 as updatepath,
  // and update sys.path themselves if desired.
  PySys_SetArgvEx(argc, wargv, 0);

  PyRun_SimpleString("import sys\n");
  
#if defined(_DEBUG)
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
  PyMem_RawFree(new_wpath);
  PyMem_RawFree(wpath);
  for (int i=0; i < argc; ++i) {
    PyMem_RawFree(wargv[i]);
  }
  PyMem_RawFree(wargv0);

  return 0;
}