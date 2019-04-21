import numba
import pandas

@numba.jit
def convert_to_int(df):
    df.