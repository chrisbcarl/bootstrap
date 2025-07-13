# https://stackoverflow.com/a/31566403

from flask import Flask

app = Flask(__name__)
# unhandled teardown won't happen while in debug mode
# app.debug = True
# set this if you need the full traceback, not just the exception
app.config['PROPAGATE_EXCEPTIONS'] = True


@app.route('/')
def index():
    raise ValueError('yup')


@app.teardown_request
def log_unhandled(e):
    if e is not None:
        # print(repr(e))
        app.logger.exception(e)  # only works with PROPAGATE_EXCEPTIONS


app.run('localhost')
