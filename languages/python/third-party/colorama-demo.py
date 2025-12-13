# https://stackoverflow.com/a/61687509

from colorama import Fore, Back
from colorama import init as colorama_init

colorama_init(autoreset=True)

foreground = {attr: getattr(Fore, attr) for attr in dir(Fore) if not attr.startswith('__') and isinstance(getattr(Fore, attr), str)}
background = {attr: getattr(Fore, attr) for attr in dir(Fore) if not attr.startswith('__') and isinstance(getattr(Fore, attr), str)}

for color in foreground:
    print(f'{getattr(Fore, color)} {getattr(Fore, color)!r} gets you {color}')

print("last color sticky? Nope! colorama_init(autoreset=True)")
