cdef extern from "mt19937ar-struct.h":
    ctypedef struct mt_state
    mt_state *make_mt(unsigned long s)
    void free_mt(mt_state *state)
    double genrand_real1(mt_state *state)

# add "mt19937ar-struct.c" as source file
cdef class MT:
    cdef mt_state *_thisptr
    def __cinit__(self, unsigned long s):
    """"mt_state must be initialized before MT __init__"""
        self._thisptr = make_mt(s)
        if self._thisptr == NULL:
            msg = "Insufficient memory."
            raise MemoryError(msg)

    def __dealloc__(self):
        if self._thisptr != NULL:
            free_mt(self._thisptr)

    cpdef double rand(self):
        return genrand_real1(self._thisptr)

