import socket

# 定义允许的IP地址和端口
ALLOWED_IPS = ['192.168.1.1', '192.168.1.2']
ALLOWED_PORTS = [80, 443]

# 模拟接收的数据包
class Packet:
    def __init__(self, src_ip, dest_ip, src_port, dest_port, protocol):
        self.src_ip = src_ip
        self.dest_ip = dest_ip
        self.src_port = src_port
        self.dest_port = dest_port
        self.protocol = protocol

# 防火墙检查函数
def firewall_check(packet):
    if packet.dest_ip in ALLOWED_IPS and packet.dest_port in ALLOWED_PORTS:
        return True
    else:
        return False

# 测试数据包
def test_firewall():
    # 模拟几个数据包
    packets = [
        Packet('192.168.1.1', '192.168.1.1', 12345, 80, 'TCP'),
        Packet('192.168.1.2', '192.168.1.2', 12346, 443, 'TCP'),
        Packet('192.168.1.3', '192.168.1.3', 12347, 8080, 'TCP'),
    ]

    for packet in packets:
        # 防火墙检察
        if firewall_check(packet):
            print(f"Packet from {packet.src_ip} to {packet.dest_ip}:{packet.dest_port} allowed.")
        else:
            print(f"Packet from {packet.src_ip} to {packet.dest_ip}:{packet.dest_port} blocked.")

if __name__ == "__main__":
    test_firewall()