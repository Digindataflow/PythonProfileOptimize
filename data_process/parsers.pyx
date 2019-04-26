from libc.string cimport strcmp, strlen
from libc.stdlib cimport malloc, free
import cython
import numpy as np
cimport numpy as np
cdef extern from 'Python.h':
    char* PyUnicode_AsUTF8(object unicode)
    PyUnicode_FromString(const char *u)

cdef char* parse_empty(char *value, char *default):
    if (strcmp(value, "")==0):
        return default
    else:
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

cdef char ** to_cstring_array(np.ndarray list_str, Py_ssize_t length):
    cdef:
        char **ret = <char **>malloc(length * sizeof(char *))
        Py_ssize_t i
    for i in range(length):
        ret[i] = PyUnicode_AsUTF8(list_str[i])
    return ret

@cython.wraparound(False)
@cython.boundscheck(False)
cpdef parse(np.ndarray column, str default, int min_length, int max_length):
    cdef:
        Py_ssize_t i, n
        np.ndarray result
    n = column.size
    carr = to_cstring_array(column, n)
    result = np.empty(n, dtype=str)
    for i in range(n):
        result[i] = parse_empty(carr[i], PyUnicode_AsUTF8(default))
        result[i] = validate_length(result[i], min_length, max_length)

    return result

# def compute_numba(column, **kwargs):
#     default = kwargs.get('default')
#     min_length = kwargs.get('min_length')
#     max_length = kwargs.get('max_length')
#     result, errors = parse(column.values, min_length, max_length)
#     return pd.Series(result, index=column.index, name=column.name), errors