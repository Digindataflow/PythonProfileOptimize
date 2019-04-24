# during compile, add "mt19937ar.c" as source file
cdef extern from "mt19937ar.h":
    void init_genrand(unsigned long s)
    double genrand_real1()

# function still need to be wrapped in def, cpdef or cdef class
def init_state(unsigned long s):
    init_genrand(s)
def rand():
    return genrand_real1()