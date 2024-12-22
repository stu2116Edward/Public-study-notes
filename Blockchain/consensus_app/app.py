from flask import Flask, request
from flask_apscheduler import APScheduler
import services
from datetime import datetime
import entity
app = Flask(__name__)
network = services.generate_network('test', entity.peer_list)

scheduler = APScheduler()
class Config(object):
    SCHEDULER_API_ENABLED = True
app.config.from_object(Config())
scheduler.init_app(app)

interval_seconds = 20


@scheduler.task('interval', id='peer0-calc', seconds=interval_seconds, misfire_grace_time=900)
def peer0_exe_pow():
    data = f"{entity.peer0.name}-{datetime.now().strftime('%Y/%m/%d %H:%M:%S')}"
    services.exe_pow(data=data, peer_name=entity.peer0.name)

@scheduler.task('interval', id='peer1-calc', seconds=interval_seconds, misfire_grace_time=900)
def peer1_exe_pow():
    data = f"{entity.peer1.name}-{datetime.now().strftime('%Y/%m/%d %H:%M:%S')}"
    services.exe_pow(data=data, peer_name=entity.peer1.name)

@scheduler.task('interval', id='peer2-calc', seconds=interval_seconds, misfire_grace_time=900)
def peer2_exe_pow():
    data = f"{entity.peer2.name}-{datetime.now().strftime('%Y/%m/%d %H:%M:%S')}"
    services.exe_pow(data=data, peer_name=entity.peer2.name)

@scheduler.task('interval', id='peer3-calc', seconds=interval_seconds, misfire_grace_time=900)
def peer3_exe_pow():
    data = f"{entity.peer3.name}-{datetime.now().strftime('%Y/%m/%d %H:%M:%S')}"
    services.exe_pow(data=data, peer_name=entity.peer3.name)

@scheduler.task('interval', id='peer4-calc', seconds=interval_seconds, misfire_grace_time=900)
def peer4_exe_pow():
    data = f"{entity.peer4.name}-{datetime.now().strftime('%Y/%m/%d %H:%M:%S')}"
    services.exe_pow(data=data, peer_name=entity.peer4.name)

@app.route('/peer_block_query', methods=['GET'])
def peer_block_query():
    return entity.blockchain.peer_block

@app.route('/block_query', methods=['GET'])
def block_query():
    index = request.args['id']
    return entity.blockchain.query_block_info(int(index))

if __name__ == '__main__':
    scheduler.start()
    app.run()