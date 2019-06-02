import numpy as np
import parsers
a = np.array(['a','aaaaa','','aaa'], dtype='U')
parsers.parse(a, 'empty', 0, 0)