# https://stackoverflow.com/a/67290440
# https://stackoverflow.com/a/54857411

import os
import traceback
# third party
import werkzeug
import flask
from flask import Flask, request, jsonify

SCRIPT_DIRPATH = os.path.abspath(os.path.dirname(__file__))

app = Flask('whatever')


@app.get('/')
def home():
    return 'hello'


@app.post('/upload')
def upload():
    try:
        # body = request.form
        # print(body)  # <- immutable dict
        file = request.files['file']
        content = file.read()
        return content
    except Exception:
        app.logger.exception('predict-batch')
        return jsonify({'traceback': traceback.format_exc()}), 500


@app.route("/upstream", methods=['POST'])
def upstream():

    def custom_stream_factory(total_content_length, filename, content_type, content_length=None):
        import tempfile
        tmpfile = tempfile.NamedTemporaryFile('wb+', prefix='flaskapp', suffix='.nc')
        app.logger.info("start receiving file ... filename => " + str(tmpfile.name))
        return tmpfile

    stream, form, files = werkzeug.formparser.parse_form_data(flask.request.environ, stream_factory=custom_stream_factory)
    for fil in files.values():
        app.logger.info(" ".join(["saved form name", fil.name, "submitted as", fil.filename, "to temporary file", fil.stream.name]))
        # Do whatever with stored file at `fil.stream.name`
    return 'OK', 200


if __name__ == '__main__':
    app.run(debug=True)
