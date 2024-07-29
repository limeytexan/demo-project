#include <Python.h>
#include "flox_hello_world.h"

static PyObject* py_flox_hello_world(PyObject* self, PyObject* args) {
    flox_hello_world();
    Py_RETURN_NONE;
}

static PyMethodDef FloxMethods[] = {
    {"flox_hello_world", py_flox_hello_world, METH_VARARGS, "Print 'Hello, Flox World!'"},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef floxmodule = {
    PyModuleDef_HEAD_INIT,
    "flox_hello_world_py",
    NULL,
    -1,
    FloxMethods
};

PyMODINIT_FUNC PyInit_flox_hello_world_py(void) {
    return PyModule_Create(&floxmodule);
}
