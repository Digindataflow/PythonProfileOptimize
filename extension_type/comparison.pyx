from cpython.object cimport Py_LT, Py_LE, Py_EQ, Py_GE, Py_GT, Py_NE
cdef class R:
    """Extension type that supports rich comparisons."""
    cdef double data
    def __init__(self, d):
        self.data = d
    def __richcmp__(x, y, int op):
        cdef:
            R r
            double data
        # Make r always refer to the R instance.
        r, y = (x, y) if isinstance(x, R) else (y, x)
        data = r.data
        if op == Py_LT:
            return data < y
        elif op == Py_LE:
            return data <= y
        elif op == Py_EQ:
            return data == y
        elif op == Py_NE:
            return data != y
        elif op == Py_GT:
            return data > y
        elif op == Py_GE:
            return data >= y
        else:
            assert False
