# vLLM 部署教程

远程集群 / 多 Agent 场景：推荐使用 `SGLang`  
单卡本地部署：强烈推荐 `vLLM`


## Windows
### 安装 WSL2
在 PowerShell（管理员）执行：
```
wsl --install
```
安装完成后重启电脑，然后安装Ubuntu
```
wsl --install -d Ubuntu
```
检查版本：
```
wsl --version
```

### WSL 安装 CUDA 驱动支持
先确认 Windows 已安装 NVIDIA 驱动
```
nvidia-smi
```
然后在 WSL Ubuntu 里运行：
```
nvidia-smi
```
如果出现显卡信息说明 GPU直通成功。例如
```
RTX 4090 # 根据你自己的显卡而定
```
<img width="1109" height="598" alt="vLLM1" src="https://github.com/user-attachments/assets/1022e74b-fecc-4763-b8ed-00e8bc3695d5" />


## Ubuntu
确认你的 Ubuntu 系统和显卡信息：  
查看 Ubuntu 版本
```
lsb_release -a
```
查看显卡硬件信息
```
lspci | grep -i nvidia
```
查看当前内核版本
```
uname -r
```
安装 NVIDIA 驱动  
方法一：使用 Ubuntu 官方源（推荐，较稳定）  
 添加 NVIDIA 驱动 PPA
```
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
```
自动推荐并安装合适的驱动
```
sudo ubuntu-drivers autoinstall
```
或者手动安装特定版本（例如 550）
```
sudo apt install nvidia-driver-550
```
方法二：从 NVIDIA 官方下载（获取最新版本）
访问 https://www.nvidia.com/Download/index.aspx  选择对应驱动，或使用以下命令：  
添加 NVIDIA 官方仓库
```
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt update
```
安装驱动
```
sudo apt install cuda-drivers
```
重启并验证驱动
```
reboot
```
重启后，检查 NVIDIA 驱动是否成功加载
```
nvidia-smi
```


### 安装 Python 环境
更新系统：
```
sudo apt update
sudo apt upgrade -y
```
安装 Python：
```
sudo apt install python3-pip python3-venv -y
```
创建虚拟环境：
```
cd ~
python3 -m venv vllm-env
```
进入环境：
```
source vllm-env/bin/activate
```


### 安装 vLLM
安装命令
```
pip install --upgrade pip
pip install vllm
```
安装完成后测试：
```
python -c "import vllm; print('vLLM installed')"
```


### 下载模型
推荐模型：
```
Qwen2.5-14B-Instruct-AWQ
```
模型优点：
- 中文强  
- Agent能力好  
- 支持更全面的工具调用能力

演示使用的是 24GB 显存显卡。如果你的显存更小，建议选择参数规模更小的模型，否则在加载模型时可能会出现：显存不足（Out of Memory）的问题  

如果显存不够大，那么可以选择：Qwen2.5-7B-Instruct-AWQ 或  Qwen2.5-4B 等更小的模型  


### 启动 vLLM 服务
运行命令：
```
python -m vllm.entrypoints.openai.api_server \
  --model Qwen/Qwen2.5-14B-Instruct-AWQ \
  --quantization awq_marlin \
  --gpu-memory-utilization 0.9 \
  --max-model-len 32768 \
  --enable-auto-tool-choice \
  --tool-call-parser hermes
```
成功后会看到：  
<img width="1129" height="615" alt="vLLM2" src="https://github.com/user-attachments/assets/1b05091e-d4e3-4420-9c1f-4b8e81ee0e22" />

说明 API 已启动成功


### 测试模型
在 Windows PowerShell 测试
```
curl http://127.0.0.1:8000/v1/models
```
返回模型信息：  
Qwen/Qwen2.5-14B-Instruct-AWQ  
说明连接正常


### 安装 OpenClaw
在 WSL 子系统里执行安装命令：  
先安装Nodejs  
```
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -<br />sudo apt install -y nodejs
```
再执行安装Openclaw
```
sudo npm install -g openclaw@latest
```

### OpenClaw 配置本地模型
进入配置：
```
openclaw onboard
```
添加模型：  
模型提供商必须选择自定义的：  

<img width="1363" height="747" alt="vLLM3" src="https://github.com/user-attachments/assets/fd88bf96-12e7-4b19-9bf2-642eb308dbe3" />

Base URL：http://127.0.0.1:8000/v1

API key：123456 (随便填写)

模型名称：Qwen2.5-14B-Instruct-AWQ

<img width="1376" height="759" alt="vLLM4" src="https://github.com/user-attachments/assets/080745a1-e92b-41a2-821d-da719a7ceeee" />

最后保存即可！



### OpenClaw 推荐参数（优化）

为了避免卡顿：

Context length：6000–8000

Temperature：0.7

Max tokens：2048


### 优化推理速度（强烈推荐）
vLLM启动参数建议：  
注意：这是RTX4090显卡的配置，请根据你自己的显卡显存来适当修改max-model-len  后面的参数
```
python -m vllm.entrypoints.openai.api_server \
  --model Qwen/Qwen2.5-14B-Instruct-AWQ \
  --quantization awq_marlin \
  --gpu-memory-utilization 0.9 \
  --max-model-len 32768 \
  --enable-auto-tool-choice \
  --tool-call-parser hermes
```
效果：  
prefix cache 加速 prompt  
GPU利用率更高


### 解决长对话卡顿
在 OpenClaw System Prompt 加：

When the conversation becomes long,  
summarize previous messages into a short memory.  
Keep the memory under 200 tokens.

这样：  
8000 token  
↓  
200 token memory  

速度不会下降。
  
