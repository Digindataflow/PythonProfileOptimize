from distutils.core import setup
from Cython.Build import cythonize
setup(name="nbody",
    ext_modules=cythonize("nbody.pyx", compiler_directives={'language_level' : "3"}))
