import typing
import json


def print_typing(t, depth=0):
    print(depth, '-', t._name, t.__origin__, t.__args__ if hasattr(t, '__args__') else 'no args', t.__parameters__ if hasattr(t, '__parameters__') else 'no params')


def print_typing_recurse(t, depth=0):
    print_typing(t)
    if hasattr(t, '__args__'):
        for arg in t.__args__:
            print_typing_recurse(arg, depth=depth + 1)


def json_stuff(t):
    return {
        'r': repr(t),
        '_name': getattr(t, '_name', None),
        '__origin__': getattr(t, '__origin__', None),
        '__args__': getattr(t, '__args__', None),
        '__parameters__': getattr(t, '__parameters__', None),
        'ga': isinstance(t, typing._GenericAlias),
    }


u = typing.Union[int, float]
t = typing.Tuple[list, dict, set]
s = typing.Set[int]
l = typing.List[s]
d = typing.Dict[str, typing.List[u]]
a = typing.Any
n = None
c = typing.Callable[[int, typing.List[float]], typing.Tuple[int, float]]
g = typing.Generator[typing.Tuple[int, typing.List[float]], None, None]
lit = typing.Literal[True]
T = typing.TypeVar('T')  # Can be anything
S = typing.TypeVar('S', bound=str)  # Can be any subtype of str
A = typing.TypeVar('A', str, bytes)  # Must be exactly str or bytes

for e in [u, t, s, l, d, a, n, c, g, lit, T, S, A]:
    print(json_stuff(e))

results = '''
u = typing.Union[int, float]                                             | {'r': 'typing.Union[int, float]',                                                    '_name': None,          '__origin__': typing.Union,                         '__args__': (<class 'int'>, <class 'float'>), '__parameters__': ()}
t = typing.Tuple[list, dict, set]                                        | {'r': 'typing.Tuple[list, dict, set]',                                               '_name': 'Tuple',       '__origin__': <class 'tuple'>,                      '__args__': (<class 'list'>, <class 'dict'>, <class 'set'>), '__parameters__': ()}
l = typing.List[typing.Set[int]]                                         | {'r': 'typing.List[typing.Set[int]]',                                                '_name': 'List',        '__origin__': <class 'list'>,                       '__args__': (typing.Set[int],), '__parameters__': ()}
d = typing.Dict[str, typing.List[u]]                                     | {'r': 'typing.Dict[str, typing.List[typing.Union[int, float]]]',                     '_name': 'Dict',        '__origin__': <class 'dict'>,                       '__args__': (<class 'str'>, typing.List[typing.Union[int, float]]), '__parameters__': ()}
a = typing.Any                                                           | {'r': 'typing.Any',                                                                  '_name': None,          '__origin__': None,                                 '__args__': None, '__parameters__': None}
n = None                                                                 | {'r': 'None',                                                                        '_name': None,          '__origin__': None,                                 '__args__': None, '__parameters__': None}
c = typing.Callable[[int, typing.List[float]], typing.Tuple[int, float]] | {'r': 'typing.Callable[[int, typing.List[float]], typing.Tuple[int, float]]',        '_name': 'Callable',    '__origin__': <class 'collections.abc.Callable'>,   '__args__': (<class 'int'>, typing.List[float], typing.Tuple[int, float]), '__parameters__': ()}
g = typing.Generator[typing.Tuple[int, typing.List[float]], None, None]  | {'r': 'typing.Generator[typing.Tuple[int, typing.List[float]], NoneType, NoneType]', '_name': 'Generator',   '__origin__': <class 'collections.abc.Generator'>,  '__args__': (typing.Tuple[int, typing.List[float]], <class 'NoneType'>, <class 'NoneType'>), '__parameters__': ()}
lit = typing.Literal[True]                                               | {'r': 'typing.Literal[True]',                                                        '_name': None,          '__origin__': typing.Literal,                       '__args__': (True,),  '__parameters__': ()}
T = typing.TypeVar('T')  # Can be anything                               | {'r': '~T',                                                                          '_name': None,          '__origin__': None,                                 '__args__': None, '__parameters__': None}
S = typing.TypeVar('S', bound=str)  # Can be any subtype of str          | {'r': '~S',                                                                          '_name': None,          '__origin__': None,                                 '__args__': None, '__parameters__': None}
A = typing.TypeVar('A', str, bytes)  # Must be exactly str or bytes      | {'r': '~A',                                                                          '_name': None,          '__origin__': None,                                 '__args__': None, '__parameters__': None}
'''


shit_type = typing.List[typing.Dict[str, typing.Union[int, typing.Tuple[list, dict, set]]]]



typing._SpecialForm

typing._AnyMeta
    typing.Any


typing._GenericAlias
    typing.Union
    typing.List
    typing.Generator

typing._SpecialGenericAlias