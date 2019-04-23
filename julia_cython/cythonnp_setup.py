from distutils.core import setup, Extension
from Cython.Distutils import build_ext
from Cython.Build import cythonize
import numpy

extensions = Extension(
    "calculate", ["cython_np.pyx"],
    extra_compile_args=['/openmp'],
    extra_link_args=['/openmp']
)

setup(
    cmdclass={'build_ext': build_ext},
    ext_modules=cythonize(extensions, compiler_directives={'language_level' : "3"}),
    include_dirs=[numpy.get_include()],
)