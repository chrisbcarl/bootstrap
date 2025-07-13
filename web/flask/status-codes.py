from flask import jsonify


@app.route('/login', methods=['POST'])
def login():
    data = {'name': 'nabin khadka'}
    return jsonify(data), 200


app.run('localhost')
