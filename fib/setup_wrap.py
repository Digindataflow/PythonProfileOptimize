from distutils.core import setup, Extension
from Cython.Build import cythonize

ext = Extension(name="wrap_fib", sources=["wrap_fib.pyx"])

setup(
    ext_modules=cythonize(ext, compiler_directives={'language_level' : "3"})
)