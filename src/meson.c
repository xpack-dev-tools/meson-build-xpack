#include <stdio.h>
#define PY_SSIZE_T_CLEAN
#include <Python.h>

int
main(int argc, char* argv[])
{
  for (int i = 1; i < argc; ++i) {
    printf("argv[%d]='%s'\n", i, argv[i]);
  }

  wchar_t *argv0 = Py_DecodeLocale(argv[0], NULL);
  if (argv0 == NULL) {
      fprintf(stderr, "Fatal error: cannot decode argv[0]\n");
      exit(1);
  }
  printf("%ls\n", argv0);
  Py_SetProgramName(argv0);  /* optional but recommended */

  wchar_t *full_path = Py_GetProgramFullPath();
  wchar_t *path = Py_GetPath();
  wchar_t *prefix = Py_GetPrefix();
  wchar_t *exec_prefix = Py_GetExecPrefix();

  printf("full_path %ls\n", full_path);
  printf("path %ls\n", full_path);
  printf("prefix %ls\n", prefix);
  printf("exec_prefix %ls\n", exec_prefix);

  Py_Initialize();

  printf("initialised\n");
  
  PyRun_SimpleString("from time import time,ctime\n"
                      "print('Today is', ctime(time()))\n");
  if (Py_FinalizeEx() < 0) {
      exit(120);
  }
  PyMem_RawFree(argv0);
  return 0;
}