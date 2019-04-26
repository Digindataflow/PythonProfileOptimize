from distutils.core import setup, Extension
from Cython.Build import cythonize
import numpy

ext = Extension(name="parsers", sources=["parsers.pyx"])

setup(
    ext_modules=cythonize(ext, compiler_directives={'language_level' : "3"}),
    include_dirs=[numpy.get_include()],
)