ngx.header.content_type = "text/html; charset=utf-8"

-- 获取当前访客IP（支持反代）
local function get_client_ip()
    local ip = ngx.var.http_x_forwarded_for
    if ip then
        local real_ip = ip:match("([^,]+)")
        if real_ip then return real_ip end
    end
    return ngx.var.remote_addr or ""
end

-- 字节转换
local function human_bytes(n)
    if not n then return "0 B" end
    if n < 1024 then return string.format("%d B", n) end
    if n < 1024 * 1024 then return string.format("%.2f KB", n / 1024) end
    if n < 1024 * 1024 * 1024 then return string.format("%.2f MB", n / (1024 * 1024)) end
    return string.format("%.2f GB", n / (1024 * 1024 * 1024))
end

-- 耗时转换
local function human_duration(us)
    if not us then return "0 μs" end
    return string.format("%d μs", us)
end

-- 获取限制阈值
local function get_limits(during)
    if during == "hour" then
        return {
            count = ngx.var.limit_count_per_hour,
            bytes = ngx.var.limit_bytes_per_hour,
            costs_us = tonumber(ngx.var.limit_costs_per_hour) * 1000
        }
    else
        return {
            count = ngx.var.limit_count_per_day,
            bytes = ngx.var.limit_bytes_per_day,
            costs_us = tonumber(ngx.var.limit_costs_per_day) * 1000
        }
    end
end

-- 生成表格数据行
local function generate_table_rows(client_ip)
    local rows = ""
    local timestamp = ngx.now()
    local dict = ngx.shared.traffic_stats

    local function stats(during)
        local limits = get_limits(during)
        local bytes_limit_human = human_bytes(tonumber(limits.bytes))
        local costs_limit_human = human_duration(limits.costs_us)

        for _, val in pairs(dict:get_keys(0)) do
            local match = "last:"..during
            if val:sub(1, #match) == match then
                local ip = val:sub(#match + 2)

                -- 首次访问时写入入站时间
                if during == "hour" and not dict:get("first:hour:"..ip) then
                    dict:set("first:hour:"..ip, os.time())
                end
                if during == "day" and not dict:get("first:day:"..ip) then
                    dict:set("first:day:"..ip, os.time())
                end

                local last_time = dict:get(val) or timestamp
                local age = math.floor(timestamp - last_time)
                local count = dict:get("count:"..during..":"..ip) or 0
                local bytes = dict:get("bytes:"..during..":"..ip) or 0
                local bytes_human = human_bytes(bytes)
                local costs_us = dict:get("costs:"..during..":"..ip) or 0
                local costs_human = human_duration(costs_us)
                local forbidden = tostring(dict:get("forbidden:"..during..":"..ip) or false)
                -- 入站时间
                local first_time = dict:get("first:"..during..":"..ip)
                local first_time_str = first_time and os.date("%Y-%m-%d %H:%M:%S", first_time) or "-"

                -- 高亮行
                local highlight = ""
                if forbidden == "true" and ip == client_ip then
                    highlight = ' class="highlight-red"'
                elseif forbidden == "true" then
                    highlight = ' class="highlight-red"'
                elseif ip == client_ip then
                    highlight = ' class="highlight"'
                end

                rows = rows .. string.format([[
                    <tr%s>
                        <td class="ip-cell">%s</td>
                        <td class="location-cell" data-ip="%s"></td>
                        <td>%s</td>
                        <td>%d</td>
                        <td>%s</td>
                        <td>%d/%s</td>
                        <td>%s/%s</td>
                        <td>%s/%s</td>
                        <td>%s</td>
                    </tr>
                ]],
                highlight,
                ip, ip, during, age, first_time_str,
                count, limits.count,
                bytes_human, bytes_limit_human,
                costs_human, costs_limit_human,
                forbidden
                )
            end
        end
    end

    stats("hour")
    stats("day")
    return rows
end

-- 以下为流量统计清空逻辑

-- 每日跨天清空流量统计
local function clear_traffic_stats_daily()
    local dict = ngx.shared.traffic_stats
    local now = os.time()
    local last_clear = dict:get("last_clear_daily") or 0
    -- 获取今天零点时间戳
    local today = os.date("*t", now)
    today.hour, today.min, today.sec = 0, 0, 0
    local today_zero = os.time(today)
    -- 如果上次清空早于今天零点，则清空
    if last_clear < today_zero then
        dict:flush_all()
        dict:flush_expired()
        dict:set("last_clear_daily", now)
    end
end

-- 每周一清空（默认关闭）
local function clear_traffic_stats_weekly()
    local dict = ngx.shared.traffic_stats
    local now = os.time()
    local last_clear = dict:get("last_clear_weekly") or 0
    local t = os.date("*t", now)
    -- 计算本周一零点
    local days_since_monday = (t.wday + 5) % 7
    local monday = os.time{year=t.year, month=t.month, day=t.day - days_since_monday, hour=0, min=0, sec=0}
    if last_clear < monday then
        dict:flush_all()
        dict:flush_expired()
        dict:set("last_clear_weekly", now)
    end
end

-- 每月一号清空（默认关闭）
local function clear_traffic_stats_monthly()
    local dict = ngx.shared.traffic_stats
    local now = os.time()
    local last_clear = dict:get("last_clear_monthly") or 0
    local t = os.date("*t", now)
    local first_day = os.time{year=t.year, month=t.month, day=1, hour=0, min=0, sec=0}
    if last_clear < first_day then
        dict:flush_all()
        dict:flush_expired()
        dict:set("last_clear_monthly", now)
    end
end

-- 调用清空函数
clear_traffic_stats_daily()      -- 每日清空
-- clear_traffic_stats_weekly()  -- 每周清空
-- clear_traffic_stats_monthly() -- 每月清空

local request_type = ngx.var.arg_type or "page"
local client_ip = get_client_ip()

if request_type == "data" then
    ngx.say(generate_table_rows(client_ip))
else
    ngx.say([[
        <html>
        <head>
        <title>IP 限制与使用统计（统一显示微秒）</title>
        <style>
            table { 
                border-collapse: collapse; 
                font-family: monospace;
                font-size: 14px;
                margin: 20px auto;
                width: 90%;
                max-width: 1500px;
            }
            th, td { 
                border: 1px solid #ccc; 
                padding: 8px 12px; 
                text-align: center;
                user-select: text; /* 允许所有单元格选中复制 */
            }
            th { 
                background: #f5f5f5; 
                font-weight: bold;
            }
            .update-time {
                text-align: center;
                margin-top: 10px;
                color: #666;
                font-size: 12px;
            }
            .current-ip {
                text-align: center;
                margin: 20px auto 10px auto;
                font-size: 16px;
                color: #333;
                font-weight: bold;
            }
            .current-ip span {
                color: blue;
            }
            .highlight {
                background: #e6ffe6 !important;
            }
            .highlight-red {
                background: #ffe6e6 !important;
            }
            .ip-cell {
                user-select: text;
                -webkit-user-select: text;
                cursor: pointer;
            }
            .location-cell {
                min-width: 180px;
                color: #337ab7;
            }
        </style>
        <script>
            // 在脚本顶部创建一个全局缓存对象
            const ipLocationCache = {};

            // 更新IP归属地的函数，增加缓存逻辑
            function updateIPLocations() {
                // 使用 Set 来自动处理重复的IP地址
                const ipsToFetch = new Set(); 

                // 第一次遍历：用缓存填充，并收集所有需要新查询的IP
                document.querySelectorAll('.location-cell').forEach(cell => {
                    const ip = cell.dataset.ip;
                    if (!ip) return;

                    if (ipLocationCache[ip]) {
                        cell.textContent = ipLocationCache[ip];
                    } else {
                        cell.textContent = '查询中...';
                        // 无论IP出现多少次，Set只会保留一个
                        ipsToFetch.add(ip);
                    }
                });

                // 第二次遍历：仅为需要新查询的IP发起API请求
                ipsToFetch.forEach(ip => {
                    fetch(`https://api.vore.top/api/IPdata?ip=${ip}`)
                        .then(response => response.json())
                        .then(data => {
                            let location = '查询失败';
                            if (data && data.ipdata && data.ipdata.info1) {
                                location = `${data.ipdata.info1} ${data.ipdata.info2 || ''} ${data.ipdata.info3 || ''}`.trim();
                            }
                            
                            ipLocationCache[ip] = location;

                            document.querySelectorAll(`.location-cell[data-ip='${ip}']`).forEach(c => {
                                c.textContent = location;
                            });
                        })
                        .catch(error => {
                            console.error('Error fetching IP location for', ip, error);
                            const errorMessage = '查询出错';
                            ipLocationCache[ip] = errorMessage;
                            document.querySelectorAll(`.location-cell[data-ip='${ip}']`).forEach(c => {
                                c.textContent = errorMessage;
                            });
                        });
                });
            }

            // 判断页面是否有选中内容
            function hasSelection() {
                var sel = window.getSelection();
                return sel && sel.toString().length > 0;
            }
            
            function fetchData() {
                if (!hasSelection()) {
                    fetch('/dk8s.stats?type=data&t=' + Date.now())
                        .then(r => r.text())
                        .then(data => {
                            document.getElementById('stats-body').innerHTML = data;
                            document.getElementById('last-update').textContent = new Date().toLocaleString();
                            updateIPLocations();
                        });
                }
            }
            
            // 页面加载完成后立即执行一次
            document.addEventListener('DOMContentLoaded', function() {
                fetchData();
                updateIPLocations();
            });
            
            setInterval(fetchData, 500);
        </script>
        </head>
        <body>
            <div class="current-ip">Your Current IP: <span>]] .. client_ip .. [[</span></div>
            <table>
                <thead>
                    <tr>
                        <th>IP</th>
                        <th>归属地</th>
                        <th>周期</th>
                        <th>活跃时间(秒)</th>
                        <th>入站时间（秒级）</th>
                        <th>请求数(当前/限制)</th>
                        <th>流量(当前/限制)</th>
                        <th>耗时(当前/限制)</th>
                        <th>是否封禁</th>
                    </tr>
                </thead>
                <tbody id="stats-body">
                    ]] .. generate_table_rows(client_ip) .. [[
                </tbody>
            </table>
            <div class="update-time">
                最后更新: <span id="last-update">]] .. os.date("%Y-%m-%d %H:%M:%S") .. [[</span>
            </div>
        </body>
        </html>
    ]])
end
