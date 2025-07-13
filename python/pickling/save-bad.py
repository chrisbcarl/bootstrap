import os
import pickle

DIRPATH = os.path.abspath(os.path.dirname(__file__))
FILEPATH = os.path.join(DIRPATH, 'bad.pkl')


class Hidden(object):
    pass


class Whatever(object):

    def __init__(self):
        self.h = None

    def action(self):
        print('action start')
        self.h = Hidden()
        print('action end')


w = Whatever()

with open(FILEPATH, 'wb') as wb:
    pickle.dump(w, wb)

w.action()
