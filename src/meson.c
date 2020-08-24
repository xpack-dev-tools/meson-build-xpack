#define PY_SSIZE_T_CLEAN
#include <Python.h>
// Note Since Python may define some pre-processor definitions which
// affect the standard headers on some systems, you must include 
// Python.h before any standard headers are included.

#include <stdio.h>
#include <wchar.h>

// https://docs.python.org/3/extending/embedding.html
// https://docs.python.org/3/c-api/index.html
// https://docs.python.org/3/c-api/init.html

int
main(int argc, char* argv[])
{
#if defined(DEBUG)
  printf("argc %d\n");
  for (int i = 0; i < argc; ++i) {
    printf("argv[%d]='%s'\n", i, argv[i]);
  }
#endif

  char* argv0 = argv[0];
  wchar_t* wargv0 = Py_DecodeLocale(argv0, NULL);
  argv[0] = "";

  wchar_t* wargv[argc];
  for (int i=0; i < argc; ++i) {
    wargv[i] = Py_DecodeLocale(argv[i], NULL);
  }

  wchar_t* path = Py_GetPath();

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
  for (int i=0; i < argc; ++i) {
    PyMem_RawFree(wargv[i]);
  }
  PyMem_RawFree(wargv0);

  return 0;
}