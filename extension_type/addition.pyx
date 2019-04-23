cdef class E:
    """Extension type that supports addition.

     __add__ will be called when the expression e + f is evaluated and e
    is an E instance, in that order
    __add__ method will also be called when the expression f + e is evaluated and f’s
    __add__ method returns NotImplemented, in that order
    """
    cdef int data
    def __init__(self, d):
        self.data = d
    def __add__(x, y):
        # Regular __add__ behavior
        if isinstance(x, E):
            if isinstance(y, int):
                return (<E>x).data + y
        # __radd__ behavior
        elif isinstance(y, E):
            if isinstance(x, int):
                return (<E>y).data + x
        else:
            return NotImplemented