cdef extern from '_fib.h':
    double cfib(int n)

def fib(n):
    return cfib(n)