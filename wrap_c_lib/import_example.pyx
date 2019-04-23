cdef extern from "header.h":
    double M_PI
    float MAX(float a, float b)
    double hypot(double x, double y)
    ctypedef int integral
    ctypedef double real
    #  adding variable names for the function arguments is recommended
    void func(integral a, integral b, real c)
    real *func_arrays(integral[] i, integral[][10] j, real **k)

    # union, struct, enum
    # It is only necessary to declare the fields that are actually used
    # or just use pass
    ctypedef struct struct_alias:
        struct_members
    ctypedef union union_alias:
        union_members
    ctypedef enum enum_alias:
        enum_members
