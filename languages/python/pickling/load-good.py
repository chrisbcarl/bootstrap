# https://stackoverflow.com/questions/49621169/joblib-load-main-attributeerror
# joblib.load('file.joblib')
# AttributeError: module '__main__' has no attribute 'NeuralNetwork'

import os
import pickle

DIRPATH = os.path.abspath(os.path.dirname(__file__))
FILEPATH = os.path.join(DIRPATH, 'good.pkl')

with open(FILEPATH, 'rb') as rb:
    w = pickle.load(rb)

w.action()
