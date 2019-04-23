# cython_np.pyx
from cython.parallel import prange # using OpenMP
import cython
import numpy as np
cimport numpy as np

@cython.boundscheck(False)
def calculate_z(int maxiter, double complex[:] zs, double complex[:] cs):
    """Calculate output list using Julia update rule"""
    cdef unsigned int i, length
    cdef double complex z, c
    length = len(zs)
    cdef int[:] output = np.empty(length, dtype=np.int32)
    with nogil:
        for i in prange(length, schedule="guided"):
            z = zs[i]
            c = cs[i]
            output[i] = 0
            while output[i] < maxiter and (z.real * z.real + z.imag * z.imag) < 4:
                z = z * z + c
                output[i] += 1
    return output