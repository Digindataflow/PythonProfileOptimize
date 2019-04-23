""""
place the declarations of C-level constructs that we wish to share.

• C type declarations—ctypedef, struct, union, or enum
• Declarations for external C or C++ libraries (i.e., cdef extern blocks)
• Declarations for cdef and cpdef module-level functions
• Declarations for cdef class extension types
• The cdef attributes of extension types
• Declarations for cdef and cpdef methods
• The implementation of C-level inline functions and methods
""""

cdef extern from "mt19937ar.h":
    # initializes mt[N] with a seed
    void init_genrand(unsigned long s)

ctypedef double real_t

cdef class State:
    cdef:
        unsigned int n_particles
        real_t *x
        real_t *vx
    cpdef real_t momentum(self)

cpdef run(State st)
cpdef int step(State st, real_t timestep)