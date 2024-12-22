from flask import Flask, request, jsonify
import flask_socketio
import services
import entity
from flask_apscheduler import APScheduler

network = entity.network  # 获取区块链网络内容，根据实际节点情况切换
c_peer = entity.peer0  # 取出当前进程的节点内容，根据实际情况切换
http_port = 5000  # 定义HTTP使用端口

app = Flask(__name__)

# 创建socket客户端
scheduler = APScheduler()
class Config(object):
    SCHEDULER_API_ENABLED = True
app.config.from_object(Config())
scheduler.init_app(app)

@scheduler.task('interval', id='send_message', seconds=20, misfire_grace_time=900)
def send_message():
    services.send_version(c_peer, network)

# 创建socket服务端处理内容
peer_socketio = flask_socketio.SocketIO(app, cors_allowed_origins='*')
@peer_socketio.on('peer-version')
def peer_version(rec_msg):
    services.peer_version_services(rec_msg, c_peer, c_peer.sio)

@peer_socketio.on('peer-message')
def peer_message(msg_dict):
    services.peer_message_service(msg_dict, c_peer)

# 创建HTTP接口处理函数
@app.route('/new_msg', methods=['POST'])
def new_msg():
    body = request.json
    return services.new_msg_service(body, c_peer)


@app.route('/get_pool', methods=['GET'])
def get_pool():
    return jsonify({
        'code': 200,
        'data': c_peer.pool
    })

if __name__ == '__main__':
    print(f"{'*'*20}Starting peer0!{'*'*20}")
    scheduler.start()
    peer_socketio.run(app, host='0.0.0.0', port=http_port, debug=False)