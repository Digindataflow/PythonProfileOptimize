# cython: profile=True
from libc.math cimport sqrt, sin

cpdef double integrate(int a, int b, f, int N=2000):
    cdef:
        int i
        double dx = (b-a)/N
        double s = 0.0
    for i in range(N):
        s += f(a+i*dx)
    return s * dx

cdef double c_integrate(int a, int b, double (*f)(double), int N=2000):
    cdef:
        int i
        double dx = (b-a)/N
        double s = 0.0
    for i in range(N):
        s += f(a+i*dx)
    return s * dx

cpdef double sin2(double x):
    return sqrt(sin(x))