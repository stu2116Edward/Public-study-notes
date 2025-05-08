const http = require('http')

const server = http.createServer((req, res) => {
    console.log(req.method)
    console.log(req.url)

    // 处理 GET 请求
    // GET 请求的特点：用于获取数据，从服务器获取资源，不修改服务器数据
    if (req.method === 'GET') {
        if (req.url === '/a') {
            res.statusCode = 200;   // 设置状态码为200
            res.end('url a\n');     // 以GET方法访问链接/a
            return;
        } else if (req.url === '/b') {
            res.statusCode = 200;   // 设置状态码为200
            res.end('url b\n');     // 以GET方法访问链接/b
            return;
        }
    }

    // 处理 POST 请求
    // POST 请求的特点：用于提交数据，向服务器发送数据，通常会修改服务器状态
    if (req.method === 'POST') {
        let postData = '';  // 准备一个变量来存储接收到的数据

        // 数据可能会分多次传输，所以这个事件可能会触发多次
        req.on('data', chunk => {
            postData += chunk.toString();   // chunk是二进制数据块，我们把它转为字符串并拼接到postData中
            console.log('接收到数据块:', chunk.toString());
        });
        
        // 监听'end'事件 - 当所有数据接收完成时触发
        req.on('end', () => {
            console.log('接收完毕，完整数据:', postData);
            res.setHeader('Content-Type', 'text/plain;charset=utf-8');  // 设置响应头
            res.statusCode = 200;   // 设置状态码为200
            res.end(`你发送的POST数据是: ${postData}\n`);   // 返回响应
        });
        return;
    }
    // 调用方式：
    // # 基本POST请求
    // curl -X POST -d "你好，这是测试数据" http://localhost:3000

    // # 发送JSON数据
    // curl -X POST -H "Content-Type: application/json" -d '{"name":"张三","age":25}' http://localhost:3000

    // # 发送表单数据
    // curl -X POST -d "username=admin&password=123456" http://localhost:3000

    // 对于未指定的链接返回404
    res.statusCode = 404 
    res.end('404 not found\n')
})

server.listen(3000, '127.0.0.1', () => {
    console.log(`Server running at http://127.0.0.1:3000/`)
})