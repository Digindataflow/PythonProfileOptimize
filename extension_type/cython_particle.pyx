""""
1. A cdef method has C calling semantics, and cannot be called from Python.
2. def always have to accept and return Python objects of one type or another.
3. A cpdef method is callable both from external Python code and from other
Cython code. But the argument and return types have
to be automatically convertible from and to Python objects

--------------
Cast p to static type Particle to bypass python dict lookup of methods
cdef Particle static_p = p
print static_p.get_momentum()
Or use cast operator
print (<Particle>p).get_momentum() # sure p is Particle
print (<Particle?>p).get_momentum() # not sure
""""

cdef class Particle(object):
    """A C struct behind every extension type instance."""
    cdef readonly double velocity # velocity is readable
    cdef public double mass # mass is both readable and writable
    cdef double position  # position is private attribute
    def __init__(self, m, p, v):
        self.mass = m
        self.position = p
        self.velocity = v
    cpdef double get_momentum(self):
        return self.mass * self.velocity
    property momentum:
        """The momentum Particle property."""
        def __get__(self):
            """momentum's getter"""
            return self.mass * self.velocity
        def __set__(self, m):
            """momentum's setter"""
            self.velocity = m / self.mass

""""Subclass""""
cdef class CParticle(Particle):
    cdef double momentum
    def __init__(self, m, p, v):
        super(CParticle, self).__init__(m, p, v)
        self.momentum = self.mass * self.velocity
    cpdef double get_momentum(self):
        return self.momentum


def add_momentums(list particles):
    """Returns the sum of the particle momentums.

    no Python objects are involved
    """
    cdef:
        double total_mom = 0.0
        Particle particle

    for particle in particles:
        total_mom += particle.get_momentum()
    return total_mom

def dispatch(Particle p not None):
    """Make sure p is not None is necessary when we access
    c level method(cdef and cpdef) and attributes.
    While for python methods(def) and public attributes(readonly, public) it's
    not needed since Python/C API will handle the exception.
    """
    print p.get_momentum()
    print p.velocity

cdef class Matrix:
    """" __cinit__ whose responsibility is to perform C level
    allocation and initialization.
    __dealloc__ is the opposite method.
    cython ensures __cinit__ and __dealloc__ only will be called
    once.
    """"
    cdef:
        unsigned int nrows, ncols
        double *_matrix
    def __cinit__(self, nr, nc):
        self.nrows = nr
        self.ncols = nc
        self._matrix = <double*>malloc(nr * nc * sizeof(double))
        if self._matrix == NULL:
            raise MemoryError()
    def __dealloc__(self):
        if self._matrix != NULL:
            free(self._matrix)


