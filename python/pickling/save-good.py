import os
import pickle
from lib import Whatever

DIRPATH = os.path.abspath(os.path.dirname(__file__))
FILEPATH = os.path.join(DIRPATH, 'good.pkl')

w = Whatever()

with open(FILEPATH, 'wb') as wb:
    pickle.dump(w, wb)

w.action()
