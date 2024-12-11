from flask import Flask
from flask import request
import services

app = Flask(__name__)

@app.route('/encrypt', methods=['GET'])

def encrypt():
    data = request.args.get("data")
    res = services.hash_encrypt(data)
    return {
        'res':res
    }

if __name__ == '__main__':
    app.run()