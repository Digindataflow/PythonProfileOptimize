import pandas as pd
from collections import defaultdict
import time

class CharFieldParser:

    def __init__(self):
        self.error = defaultdict()

    def parse_empty(self, column, **kwargs):
        default = kwargs.get('default')
        if default:
            column[column==''] = default
        else:
            wrong_idx = column.index[column=='']
            column[wrong_idx] = False
            self.error['empty_error'] = wrong_idx
        return column

    def validate_length(self, column, **kwargs):
        min_length = kwargs.get('min_length')
        max_length = kwargs.get('max_length')
        if min_length:
            sub_column = column[column!=False]
            length = sub_column.str.len()
            wrong_idx = sub_column.index[length<min_length]
            column[wrong_idx] = False
            self.error['length_short'] = wrong_idx

        if max_length:
            sub_column = column[column!=False]
            length = sub_column.str.len()
            wrong_idx = sub_column.index[length>max_length]
            column[wrong_idx] = False
            self.error['length_long'] = wrong_idx
        return column

    def parse(self, column, **kwargs):
        column = self.parse_empty(column, **kwargs)
        column = self.validate_length(column, **kwargs)
        return column

df = pd.Series(['', 'aaa', 'a', 'aaaaaaaaaa']*1000, name='code')

if __name__ == '__main__':
    parser=CharFieldParser()
    start = time.time()
    parser.parse(df, min_length=2, max_length=5)
    duration = time.time() - start
    print(f'Duration {duration}.')
    print(f'Errors: {parser.error}')