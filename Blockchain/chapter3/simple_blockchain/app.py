import models
from flask import Flask, request, jsonify

app = Flask(__name__)
app.config['KSPM_AS_ASCII']=False
blockchain = models.Blockchain()

@app.route('/add', methods=['POST'])
def add():
    body = request.json
    index = blockchain.add_new_block(body['data'])
    return jsonify({
        'code': 200,
        'data': index
    })


@app.route('/query', methods=['GET'])
def query():
    index = int(request.args['index'])
    return jsonify({
        'code': 200,
        'data': blockchain.query_block_info(index)
    })


if __name__ == '__main__':
    app.run()
