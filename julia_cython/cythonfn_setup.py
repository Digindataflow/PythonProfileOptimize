
from distutils.core import setup, Extension
from Cython.Distutils import build_ext
from Cython.Build import cythonize

extensions = Extension("calculate", ["cythonfn.pyx"])

setup(
    cmdclass={'build_ext': build_ext},
    ext_modules=cythonize(extensions, compiler_directives={'language_level' : "3"}),
)