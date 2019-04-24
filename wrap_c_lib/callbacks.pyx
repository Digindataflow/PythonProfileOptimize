cdef extern from "stdlib.h":
    void qsort(void *array, size_t count, size_t size,
        int (*compare)(const void *, const void *) except *)
    void *malloc(size_t size)
    void free(void *ptr)

# callback function, to compare
cdef int int_compare(const void *a, const void *b) except *:
    cdef int ia, ib
    # convert the void pointer arguments into C integers
    #  dereference a pointer in Cython we index into it with index 0
    ia = (<int*>a)[0]
    ib = (<int*>b)[0]
    return ia - ib

""""Allow reverse sort """"
cdef int reverse_int_compare(const void *a, const void *b) except *:
    return -int_compare(a, b)

"""Allow pass user defined python callback to qsort"""
# python callback
cdef object py_cmp = None
cdef int py_cmp_wrapper(const void *a, const void *b) except *:
    cdef int ia, ib
    ia = (<int*>a)[0]
    ib = (<int*>b)[0]
    return py_cmp(ia, ib)
cdef int reverse_py_cmp_wrapper(const void *a, const void *b) except *:
    return -py_cmp_wrapper(a, b)

# main function
ctypedef int (*qsort_cmp)(const void *, const void *) except *
def pyqsort(list x, cmp=None, reverse=False):
    global py_cmp
    cdef:
        int *array
        int i, N
        qsort_cmp cmp_callback
    # Allocate the C array.
    N = len(x)
    array = <int*>malloc(sizeof(int) * N)
    if array == NULL:
        raise MemoryError("Unable to allocate array.")
    # Fill the C array with the Python integers.
    for i in range(N):
        array[i] = x[i]

    # Select the appropriate callback.
    if cmp and reverse:
        py_cmp = cmp
        cmp_callback = reverse_py_cmp_wrapper
    elif cmp and not reverse:
        py_cmp = cmp
        cmp_callback = py_cmp_wrapper
    elif reverse:
        cmp_callback = reverse_int_compare
    else:
        cmp_callback = int_compare
    # qsort the array...
    qsort(<void*>array, <size_t>N, sizeof(int), cmp_callback)
    # Convert back to Python and free the C array.
    for i in range(N):
        x[i] = array[i]
    free(array)
