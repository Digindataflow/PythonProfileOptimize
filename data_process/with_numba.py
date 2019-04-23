import numba
import pandas as pd
from collections import defaultdict
import time
import numpy as np
from numba import types
from numba.typed import Dict
from numba import njit
@numba.jit
def parse_empty(value, default=None):
    if value=='':
        if default:
            return default, False
        return '', True
    else:
        return value, False

@numba.jit
def validate_length(value, min_length=None, max_length=None):
    length = len(value)
    if min_length and length<min_length:
        return '', True
    if max_length and length>max_length:
        return '', True
    return value, False

@numba.njit
def parse(column, default=None, min_length=None, max_length=None):
    n = len(column)
    result = np.empty(n, dtype=str)
    errors = Dict.empty(
        key_type=types.unicode_type,
        value_type=types.int32[:],
    )
    for i in range(n):
        result[i], is_error = parse_empty(column[i], default)
        if is_error:
            errors["empty"].append(i)
        else:
            result[i], is_error = validate_length(result[i], min_length, max_length)
            if is_error:
                errors["length"].append(i)

    return result, errors

def compute_numba(column, **kwargs):
    default = kwargs.get('default')
    min_length = kwargs.get('min_length')
    max_length = kwargs.get('max_length')
    result, errors = parse(column.values, min_length, max_length)
    return pd.Series(result, index=column.index, name=column.name), errors

df = pd.Series(['', 'aaa', 'a', 'aaaaaaaaaa']*1000, name='code')

if __name__ == '__main__':
    start = time.time()
    compute_numba(df, min_length=2, max_length=5)
    duration = time.time() - start
    print(f'Duration {duration}.')