# https://stackoverflow.com/questions/49621169/joblib-load-main-attributeerror
# https://stackoverflow.com/q/49621169
# joblib.load('file.joblib'), pickle.load(wb), etc.
# AttributeError: module '__main__' has no attribute 'NeuralNetwork'

import os
import pickle

DIRPATH = os.path.abspath(os.path.dirname(__file__))
FILEPATH = os.path.join(DIRPATH, 'bad.pkl')

with open(FILEPATH, 'rb') as rb:
    w = pickle.load(rb)

w.action()
