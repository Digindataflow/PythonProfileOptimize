""""
C-level constructs can be imported via cimport.
It is at the C level and occurs at compile time.
- there are also predefined pxd files in cython, CPython, numpy

The import statement works at the Python level and the import occurs at runtime
""""
from simulator cimport State, step, real_t
# or use include('simulator.pxi') for old projects
# there are also predefined pxd files in cython, CPython, numpy
from libc.math cimport sin
from simulator import setup as sim_setup

cdef class NewState(State):
    cdef:
        # ...extra attributes...
    def __cinit__(self, ...):
        # ...
    def __dealloc__(self):
        # ...
def setup(fname):
    # ...call sim_setup and tweak things slightly...
cpdef run(State st):
    # ...improved run that uses simulator.step...