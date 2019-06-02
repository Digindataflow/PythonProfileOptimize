from libc.string cimport strcmp, strlen
from libc.stdlib cimport malloc, free
from libc.stdio cimport printf
import cython
import numpy as np
cimport numpy as np
cdef extern from 'Python.h':
    char* PyUnicode_AsUTF8(object unicode)
    PyUnicode_FromString(const char *u)

cdef char* parse_empty(char *value, char *default):
    if (strcmp(value, "")==0):
        return default
    printf(value)
    return value

cpdef parse_empty_wrap(str value, str default=''):
    result = parse_empty(PyUnicode_AsUTF8(value), PyUnicode_AsUTF8(default))
    return PyUnicode_FromString(result)

cdef char* validate_length(char *value, int min_length, int max_length):
    length = strlen(value)
    if min_length != 0:
        if length < min_length:
            return ''
    if max_length != 0:
        if length > max_length:
            return ''
    return value

cdef char ** to_cstring_array(list_str, Py_ssize_t length):
    cdef:
        char **ret = <char **>malloc(length * sizeof(char *))
        Py_ssize_t i
    for i in range(length):
        ret[i] = PyUnicode_AsUTF8(list_str[i])
        printf(ret[i])
        printf('\n')
    return ret

@cython.wraparound(False)
@cython.boundscheck(False)
cpdef parse(column, str default, int min_length, int max_length):
    cdef:
        Py_ssize_t i, n
        char *intermediate
        char *c_default
    n = column.size
    c_default = PyUnicode_AsUTF8(default)
    # cdef char **result = <char **>malloc(n * sizeof(char *))
    # carr = to_cstring_array(column, n)
    result = np.empty(n, dtype="U")
    for i in range(n):
        printf(PyUnicode_AsUTF8(column[i]))
        printf(PyUnicode_AsUTF8(default))
        intermediate = parse_empty(PyUnicode_AsUTF8(column[i]), c_default)
        printf(intermediate)
        intermediate = validate_length(intermediate, min_length, max_length)
        print(PyUnicode_FromString(intermediate))
        result[i] = PyUnicode_FromString(intermediate)
        printf('\n')
    # free(carr)
    return result

# def compute_numba(column, **kwargs):
#     default = kwargs.get('default')
#     min_length = kwargs.get('min_length')
#     max_length = kwargs.get('max_length')
#     result, errors = parse(column.values, min_length, max_length)
#     return pd.Series(result, index=column.index, name=column.name), errors