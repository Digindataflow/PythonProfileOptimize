import numpy as np
# responsible for cleaning up the memory used by numpy
cimport numpy as cnp

cdef extern from "matrix.h":
    float *make_matrix_c(int nrows, int ncols)

def make_matrix(int nrows, int ncols):
    cdef float *mat = make_matrix_c(nrows, ncols)
    # cast poiter to mv
    cdef float[:, ::1] mv = <float[:nrows, :ncols]>mat
    # return numpy array, a view on the underlying C array
    cdef cnp.ndarray arr = np.asarray(mv)
    set_base(arr, mat)
    return arr

# to free memory
cdef class _finalizer:
    cdef void *_data
    def __dealloc__(self):
        print "_finalizer.__dealloc__"
        if self._data is not NULL:
            free(self._data)

cdef void set_base(cnp.ndarray arr, void *carr):
    cdef _finalizer f = _finalizer()
    # initializes its _data
    f._data = <void*>carr
    cnp.set_array_base(arr, f)