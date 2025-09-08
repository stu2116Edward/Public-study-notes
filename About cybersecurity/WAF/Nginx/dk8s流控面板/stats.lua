ngx.header.content_type = "text/html; charset=utf-8"

-- 获取当前访问者的真实 IP 地址
local xff = ngx.var.http_x_forwarded_for
local current_visitor_ip
if xff and xff ~= "" then
    -- 遍历 X-Forwarded-For 列表，获取最后一个非空的IP地址
    local ips = {}
    for ip in string.gmatch(xff, "([^, ]+)") do
        table.insert(ips, ip)
    end
    if #ips > 0 then
        current_visitor_ip = ips[#ips]
    else
        current_visitor_ip = ngx.var.remote_addr -- 如果 XFF 格式异常，则降级
    end
else
    current_visitor_ip = ngx.var.remote_addr
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
    else -- day
        return {
            count = ngx.var.limit_count_per_day,
            bytes = ngx.var.limit_bytes_per_day,
            costs_us = tonumber(ngx.var.limit_costs_per_day) * 1000
        }
    end
end

-- 确保log目录存在（根据系统区分命令）
local function ensure_log_directory()
    local log_dir = "log"
    -- 使用io.open检查一个文件是否可写以判断目录存在性（在目录内尝试写一个临时文件）
    local test_path = log_dir .. "/.dir_test__"
    local f = io.open(test_path, "w")
    if f then
        f:close()
        os.remove(test_path)
        return
    end
    -- 创建目录
    local dir_sep = package.config:sub(1,1)
    if dir_sep == "\\" then
        -- Windows
        os.execute("mkdir \"" .. log_dir .. "\" >nul 2>nul")
    else
        -- Unix/Linux
        os.execute("mkdir -p '" .. log_dir .. "' >/dev/null 2>&1")
    end
end

-- 生成日志数据（使用 hour 周期的数据）
local function generate_log_data()
    local dict = ngx.shared.traffic_stats
    local log_entries = {}
    local processed_ips = {} -- 用于跟踪已经处理过的IP

    local keys = dict:get_keys(0)
    for _, key in pairs(keys) do
        -- 检查是否是 last:hour 键
        if key:sub(1, 9) == "last:hour" then
            local ip = key:sub(11) -- 提取IP地址
            
            -- 跳过已经处理过的IP
            if processed_ips[ip] then
                goto continue
            end
            processed_ips[ip] = true
            
            -- 获取必要数据
            local last_time = dict:get(key)
            local count = dict:get("count:hour:"..ip)
            local bytes = dict:get("bytes:hour:"..ip)
            local costs_us = dict:get("costs:hour:"..ip)
            local forbidden = dict:get("forbidden:hour:"..ip)
            local first_time = dict:get("first:hour:"..ip)
            
            if last_time and count and bytes and costs_us then
                table.insert(log_entries, {
                    ip = ip,
                    first_time = first_time or 0,
                    forbidden = forbidden or false
                })
            end
        end
        ::continue::
    end
    return log_entries
end

-- 导出日志到文件（CSV转义）
local function export_log_to_file(filename)
    ensure_log_directory()
    local log_entries = generate_log_data()

    local function csv_escape(v)
        v = tostring(v or "")
        v = v:gsub('"', '""')
        return '"' .. v .. '"'
    end

    local function format_ts(ts)
        if not ts or ts == 0 then return "-" end
        local t = os.date("*t", ts)
        return string.format("%d-%d-%d %02d:%02d:%02d", t.year, t.month, t.day, t.hour, t.min, t.sec)
    end

    local file = io.open("log/" .. filename, "w")
    if file then
        -- 写入UTF-8 BOM确保编码
        file:write("\239\187\191")
        -- 写入表头（三列）
        file:write("IP,入站时间戳,是否被封禁\n")
        for _, entry in ipairs(log_entries) do
            local line = table.concat({
                csv_escape(entry.ip),
                csv_escape(format_ts(entry.first_time)),
                csv_escape(tostring(entry.forbidden))
            }, ",") .. "\n"
            file:write(line)
        end
        file:close()
        return true, #log_entries
    else
        return false, "无法创建日志文件"
    end
end

-- 生成表格行
local function generate_table_rows(visitor_ip)
    local rows = ""
    local timestamp = ngx.now()
    local dict = ngx.shared.traffic_stats
    
    local function stats(during)
        local limits = get_limits(during)
        local bytes_limit_human = human_bytes(tonumber(limits.bytes))
        local costs_limit_human = human_duration(limits.costs_us)
        
        local keys = dict:get_keys(0)
        for _, val in pairs(keys) do
            local match = "last:"..during
            if val:sub(1, #match) == match then
                local ip = val:sub(#match + 2)
                
                -- 首次访问时写入入站时间
                if during == "hour" and not dict:get("first:hour:"..ip) then
                    dict:add("first:hour:"..ip, os.time())
                end
                if during == "day" and not dict:get("first:day:"..ip) then
                    dict:add("first:day:"..ip, os.time())
                end

                -- 批量获取数据，减少竞态条件窗口
                local last_time = dict:get(val)
                local count = dict:get("count:"..during..":"..ip)
                local bytes = dict:get("bytes:"..during..":"..ip)
                local costs_us = dict:get("costs:"..during..":"..ip)
                local forbidden = dict:get("forbidden:"..during..":"..ip)
                -- 入站时间
                local first_time = dict:get("first:"..during..":"..ip)
                local first_time_str = first_time and os.date("%Y-%m-%d %H:%M:%S", first_time) or "-"

                -- 增加nil检查，如果数据在中途被删除，则跳过此条记录
                if last_time and count and bytes and costs_us then
                    local age = math.floor(timestamp - (tonumber(last_time) or timestamp))
                    local bytes_human = human_bytes(tonumber(bytes))
                    local costs_human = human_duration(tonumber(costs_us))
                    local forbidden_str = tostring(forbidden or false)

                    local row_style = ""
                    if forbidden == true and ip == visitor_ip then
                        row_style = "style='background-color: #ffe6e6; font-weight: bold;'"
                    elseif forbidden == true then
                        row_style = "style='background-color: #ffe6e6;'"
                    elseif ip == visitor_ip then
                        row_style = "style='background-color: #d4edda; font-weight: bold;'"
                    end
                    
                    rows = rows .. string.format([[
                        <tr %s>
                            <td class="ip-cell">%s</td>
                            <td>%s</td>
                            <td>%d</td>
                            <td>%s</td>
                            <td>%d/%s</td>
                            <td>%s/%s</td>
                            <td>%s/%s</td>
                            <td>%s</td>
                        </tr>
                    ]], 
                    row_style,
                    ip,
                    during, age, first_time_str,
                    tonumber(count), limits.count, 
                    bytes_human, bytes_limit_human, 
                    costs_human, costs_limit_human, 
                    forbidden_str
                    )
                end
            end
        end
    end
    
    stats("hour")
    stats("day")
    return rows
end

-- 获取当前日期的日志文件名
local function get_current_log_filename()
    local now = os.time()
    local today = os.date("*t", now)
    return string.format("%04d%02d%02d.csv", today.year, today.month, today.day)
end

-- 启动时立即生成当天日志文件并记录数据
local function init_daily_log()
    local log_filename = get_current_log_filename()
    export_log_to_file(log_filename)
end

-- 每日跨天清空流量统计
local function clear_traffic_stats_daily()
    local dict = ngx.shared.traffic_stats
    local now = os.time()
    local last_clear = dict:get("last_clear_daily") or 0
    
    -- 获取今天零点时间戳
    local today = os.date("*t", now)
    today.hour, today.min, today.sec = 0, 0, 0
    local today_zero = os.time(today)
    
    -- 首次启动时，创建当天日志文件并设置标记
    if last_clear == 0 then
        dict:set("last_clear_daily", now)
        init_daily_log() -- 创建当天日志文件
        return
    end
    
    -- 如果上次清空早于今天零点，则清空并归档
    if last_clear < today_zero then
        -- 在清空之前先导出昨天的日志（文件名为昨天日期）
        local yesterday_ts = today_zero - 86400
        local y = os.date("*t", yesterday_ts)
        local log_filename = string.format("%04d%02d%02d.csv", y.year, y.month, y.day)
        export_log_to_file(log_filename)
        
        -- 清空统计数据
        dict:flush_all()
        dict:flush_expired()
        dict:set("last_clear_daily", now)
        
        -- 创建新的当天日志文件
        init_daily_log()
    end
end

-- 初始化：创建当天日志文件
init_daily_log()

-- 调用清空函数（检查是否需要归档）
clear_traffic_stats_daily()

local request_type = ngx.var.arg_type or "page"

if request_type == "export" then
    -- 手动导出当前面板数据，直接返回CSV供浏览器下载
    local log_entries = generate_log_data()
    local filename = string.format("%04d%02d%02d_%02d%02d%02d.csv", os.date("%Y"), os.date("%m"), os.date("%d"), os.date("%H"), os.date("%M"), os.date("%S"))
    
    local function csv_escape(v)
        v = tostring(v or "")
        v = v:gsub('"', '""')
        return '"' .. v .. '"'
    end
    local function format_ts(ts)
        if not ts or ts == 0 then return "-" end
        local t = os.date("*t", ts)
        return string.format("%d-%d-%d %02d:%02d:%02d", t.year, t.month, t.day, t.hour, t.min, t.sec)
    end
    
    -- 生成CSV内容（添加UTF-8 BOM）
    local csv_content = "\239\187\191" .. "IP,入站时间戳,是否被封禁\n"
    for _, entry in ipairs(log_entries) do
        local line = table.concat({
            csv_escape(entry.ip),
            csv_escape(format_ts(entry.first_time)),
            csv_escape(tostring(entry.forbidden))
        }, ",") .. "\n"
        csv_content = csv_content .. line
    end
    
    -- 设置下载响应头
    ngx.header.content_type = "text/csv; charset=utf-8"
    ngx.header.content_disposition = string.format('attachment; filename="%s"', filename)
    ngx.say(csv_content)
    return
elseif request_type == "data" then
    -- 返回JSON格式的数据，包含当前IP和表格数据
    ngx.header.content_type = "application/json"
    ngx.say(string.format([[{"current_ip":"%s","table_html":"%s"}]], 
        current_visitor_ip,
        ngx.escape_uri(generate_table_rows(current_visitor_ip))))
else
    ngx.say([[
    <html>
    <head>
    <title>IP 限制与使用统计</title>
    <style>
        body { font-family: sans-serif; }
        table { border-collapse: collapse; font-family: monospace; font-size: 14px; margin: 20px auto; width: 90%; max-width: 1600px; }
        th, td { border: 1px solid #ccc; padding: 8px 12px; text-align: center; }
        th { background: #f5f5f5; font-weight: bold; }
        .header-info { text-align: center; margin: 10px auto; }
        .update-time { text-align: center; margin-top: 10px; color: #666; font-size: 12px; }
        .export-btn { display:inline-block; margin-top:8px; padding:6px 12px; background:#007bff; color:#fff; border-radius:4px; cursor:pointer; font-size:13px; }
        .export-btn:disabled { background:#999; cursor:not-allowed; }
        .view-mode-select { display:inline-block; margin-left:15px; padding:6px 10px; font-size:13px; border:1px solid #ccc; border-radius:4px; background:#fff; }
    </style>
    <script>
        // 封装数据获取和更新的逻辑
        function fetchAndUpdate() {
            fetch('/dk8s.stats?type=data&t=' + Date.now())
                .then(r => r.json())
                .then(data => {
                    document.getElementById('current-ip').textContent = data.current_ip;
                    document.getElementById('stats-body').innerHTML = decodeURIComponent(data.table_html);
                    document.getElementById('last-update').textContent = new Date().toLocaleString();
                    updateViewMode();
                });
        }

        // 手动导出按钮逻辑
        function manualExport() {
            const url = '/dk8s.stats?type=export&t=' + Date.now();
            const btn = document.getElementById('export-btn');
            if (btn) {
                btn.disabled = true;
                const oldText = btn.textContent;
                btn.textContent = '准备下载...';
                setTimeout(() => {
                    btn.disabled = false;
                    btn.textContent = oldText;
                }, 1500);
            }
            const a = document.createElement('a');
            a.href = url;
            a.style.display = 'none';
            document.body.appendChild(a);
            a.click();
            setTimeout(() => document.body.removeChild(a), 2000);
        }

        function updateViewMode() {
            const sel = document.getElementById('view-mode');
            const mode = sel ? sel.value : 'hour';
            const rows = document.querySelectorAll('#stats-body tr');
            rows.forEach(row => {
                const periodCell = row.querySelector('td:nth-child(2)');
                const period = periodCell ? periodCell.textContent.trim() : '';
                if (mode === 'hour') {
                    row.style.display = (period === 'hour') ? '' : 'none';
                } else if (mode === 'day') {
                    row.style.display = (period === 'day') ? '' : 'none';
                } else {
                    row.style.display = '';
                }
            });
        }

        // 页面加载完成后，立即执行一次
        document.addEventListener('DOMContentLoaded', () => { fetchAndUpdate(); updateViewMode(); });

        // 每隔 5 秒刷新一次数据
        setInterval(fetchAndUpdate, 500);

    </script>
    </head>
    <body>
        <div class="header-info">
            <h3>Your Current IP: <span id="current-ip" style="color: #007bff;">]] .. current_visitor_ip .. [[</span></h3>
            <button id="export-btn" class="export-btn" onclick="manualExport()">手动导出当前面板信息</button>
            <select id="view-mode" class="view-mode-select" onchange="updateViewMode()">
                <option value="hour" selected>仅显示 hour</option>
                <option value="day">仅显示 day</option>
                <option value="all">显示所有</option>
            </select>
        </div>
        <table>
            <thead>
                <tr>
                    <th>IP</th>
                    <th>周期</th>
                    <th>活跃时间(秒)</th>
                    <th>入站时间</th>
                    <th>请求数(当前/限制)</th>
                    <th>流量(当前/限制)</th>
                    <th>耗时(当前/限制)</th>
                    <th>是否封禁</th>
                </tr>
            </thead>
            <tbody id="stats-body">
                ]] .. generate_table_rows(current_visitor_ip) .. [[
            </tbody>
        </table>
        <div class="update-time">
            最后更新: <span id="last-update">]] .. os.date("%Y-%m-%d %H:%M:%S") .. [[</span>
        </div>
    </body>
    </html>
    ]])
end
