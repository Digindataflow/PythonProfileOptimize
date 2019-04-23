cdef class I:
    cdef:
        list data
        int i
    def __init__(self):
        self.data = range(100)
        self.i = 0
    def __iter__(self):
        return self
    def __next__(self):
        if self.i >= len(self.data):
            raise StopIteration()
        ret = self.data[self.i]
        self.i += 1
        return ret