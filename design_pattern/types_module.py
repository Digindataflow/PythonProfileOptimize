import types
a_dict = {'a':1, 'b':3}
proxy_dict = types.MappingProxyType(a_dict) # a view on the dict.

class OneClass:
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def default(self):
        pass

def OneFunction(param1):
    print('In the function one. '+param1.__class__.__name__)

OneClassInst = OneClass()
OneClassInst.default = types.MethodType(OneFunction, OneClassInst)
OneClassInst.default()

expected_ns = {}
class AMeta(type):
    def __new__(*args, **kwargs):
        return type.__new__(*args, **kwargs)

    def __prepare__(*args):
        return expected_ns

TwoClass = types.new_class('TwoClass', (OneClass,), {'metaclass':AMeta})

class SharedClassState:
    _share_state={}

    def __init__(self):
        pass

    @classmethod
    def update(cls, name, value):
        cls._share_state.update({name:value})

    def getall(self):
        print(self._share_state)

