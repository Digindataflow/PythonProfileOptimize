if sys.version_info[0] > 2:                                      # Python 3
    createBoundMethod = types.MethodType
else:                                           # Python 2
    def createBoundMethod(func, obj):
        return types.MethodType(func, obj, obj.__class__)
 
class ClassOne:
    def __init__(self, replacementMethod = None):
        if replacementMethod:
            self.methodOne = createBoundMethod(replacementMethod, self)
 
    def methodOne(self):
        print("This is the Default Method in {}.".format(self.__class__.__name__))
 
obectOneOfClassOne = ClassOne()
obectOneOfClassOne.methodOne()                                             ### OUTPUT: This is the Default Method in ClassOne. ###
 
def substituteFunction(objectReference):
    print("This is the Substitute Function in {}.".format(objectReference.__class__.__name__))
 
objectTwoOfClassOne = ClassOne(substituteFunction)
objectTwoOfClassOne.methodOne()                                            ### OUTPUT: This is the Substitute Function in ClassOne. ###