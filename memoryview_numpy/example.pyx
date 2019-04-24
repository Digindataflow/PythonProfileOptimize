"""
- declare mv
cdef int[:, :, :] mv
mv = np.empty((10, 20, 30), dtype=np.int32)

- it can acquire a buffer from a fully strided ndarray:
mv = arr[4:10:2, ::3, 5::-2]

- C-contiguous typed memoryview
cdef float[:, ::1] c_contig_mv
c_contig_mv = np.ones((3, 4), dtype=np.float32, order='F')
#=> ValueError: ndarray is not C-contiguous
arr = np.ones((3, 4), dtype=np.float32)
c_contig_mv = arr[:, ::2]
#=> ValueError: ndarray is not C-contiguous

- modify entirely with scalar
mv[...] = math.pi

- modify with a second mv with same shape
cdef double[:, :] mv1 = np.zeros((10, 20))
cdef double[:, ::1] mv2 = np.ones((20, 40))
mv1[::2, ::2] = mv2[1:11:2, 10:40:3]

- new dimension
 mv[None, :]

- dynamic c array
def dynamic(size_t N, size_t M):
    cdef long *arr = <long*>malloc(N * M * sizeof(long))
    cdef long[:, ::1] mv = <long[:N, :M]>arr
"""

from cython cimport boundscheck, wraparound

def summer(double[:] mv):
    """Sums its argument's contents."""
    cdef:
        double ss = 0.0
        int i, N
    N = mv.shape[0]
    with boundscheck(False), wraparound(False)：
        for i in range(N):
            ss += mv[i]
    return ss