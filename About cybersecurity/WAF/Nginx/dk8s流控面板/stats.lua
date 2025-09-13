ngx.header.content_type = "text/html; charset=utf-8"

-- 获取当前访问者真实IP（支持X-Forwarded-For）
local xff = ngx.var.http_x_forwarded_for
local current_visitor_ip
if xff and xff ~= "" then
    local ips = {}
    for ip in string.gmatch(xff, "([^, ]+)") do
        table.insert(ips, ip)
    end
    if #ips > 0 then
        current_visitor_ip = ips[#ips]
    else
        current_visitor_ip = ngx.var.remote_addr
    end
else
    current_visitor_ip = ngx.var.remote_addr
end

local dict = ngx.shared.traffic_stats

-- 记录当前IP入站时间戳，只要访问到服务器就记录
do
    local first_key = "first:hour:" .. current_visitor_ip
    local first_time = dict:get(first_key)
    if not first_time or first_time == 0 then
        dict:set(first_key, os.time(), 86400)
    end
end

-- 日志记录函数（与record.lua一致，直接嵌入保证页面访问也写日志）
local function ensure_log_directory()
    local log_dir = "log"
    local test_path = log_dir .. "/.dir_test__"
    local f = io.open(test_path, "w")
    if f then
        f:close()
        os.remove(test_path)
        return
    end
    local dir_sep = package.config:sub(1,1)
    if dir_sep == "\\" then
        os.execute("mkdir \"" .. log_dir .. "\" >nul 2>nul")
    else
        os.execute("mkdir -p '" .. log_dir .. "' >/dev/null 2>&1")
    end
end

local function get_today_log_filename()
    local now = os.time()
    local today = os.date("*t", now)
    return string.format("%04d%02d%02d.csv", today.year, today.month, today.day)
end

local function format_ts(ts)
    if not ts or ts == 0 then return "-" end
    local t = os.date("*t", ts)
    return string.format("%d-%d-%d %02d:%02d:%02d", t.year, t.month, t.day, t.hour, t.min, t.sec)
end

local function is_ip_banned(ip)
    local banned = dict:get("forbidden:hour:" .. ip) or dict:get("forbidden:day:" .. ip)
    return banned == true
end

local function record_ip_log(ip)
    ensure_log_directory()
    local log_filename = "log/" .. get_today_log_filename()
    local first_key = "first:hour:" .. ip
    local first_visit = dict:get(first_key)
    if not first_visit then
        first_visit = os.time()
        dict:set(first_key, first_visit, 86400)
    end
    local banned_status = is_ip_banned(ip) and "true" or "false"
    local function csv_escape(v)
        v = tostring(v or "")
        v = v:gsub('"', '""')
        return '"' .. v .. '"'
    end
    local log_entry = table.concat({
        csv_escape(ip),
        csv_escape(format_ts(first_visit)),
        csv_escape(banned_status)
    }, ",") .. "\n"

    local offset_key = "log_offset:" .. ip
    local last_status_key = "last_ban_status:" .. ip
    local file_offset = dict:get(offset_key)
    local last_status = dict:get(last_status_key)
    if file_offset and last_status ~= nil then
        if last_status ~= banned_status then
            local file = io.open(log_filename, "r+")
            if file then
                file:seek("set", file_offset)
                local line = file:read("*l")
                if line and line ~= "" then
                    local last_comma = line:match(".*(),")
                    if last_comma then
                        local new_line = line:sub(1, last_comma) .. banned_status
                        if #new_line < #line then
                            new_line = new_line .. string.rep(" ", #line - #new_line)
                        end
                        file:seek("set", file_offset)
                        file:write(new_line .. "\n")
                    end
                end
                file:close()
                dict:set(last_status_key, banned_status, 86400)
            end
        end
        return
    end

    local file = io.open(log_filename, "a+")
    if file then
        local file_size = file:seek("end")
        if file_size == 0 then
            file:write("\239\187\191")
            file:write("IP,入站时间戳,是否被封禁\n")
        end
        local offset = file:seek("end")
        file:write(log_entry)
        file:close()
        dict:set(offset_key, offset, 86400)
        dict:set(last_status_key, banned_status, 86400)
    end
end

-- 确保页面访问也会记录到日志文件
record_ip_log(current_visitor_ip)

local function human_bytes(n)
    if not n then return "0 B" end
    if n < 1024 then return string.format("%d B", n) end
    if n < 1024 * 1024 then return string.format("%.2f KB", n / 1024) end
    if n < 1024 * 1024 * 1024 then return string.format("%.2f MB", n / (1024 * 1024)) end
    return string.format("%.2f GB", n / (1024 * 1024 * 1024))
end
local function human_duration(us)
    if not us then return "0 μs" end
    return string.format("%d μs", us)
end

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

local function get_ip_first_time(ip)
    local first_time = dict:get("first:hour:"..ip)
    if not first_time or first_time == 0 then
        first_time = dict:get("first:day:"..ip)
    end
    if not first_time or first_time == 0 then
        return "-"
    end
    return format_ts(first_time)
end

local function generate_table_rows(visitor_ip)
    local rows = ""
    local timestamp = ngx.now()
    local function stats(during)
        local limits = get_limits(during)
        local bytes_limit_human = human_bytes(tonumber(limits.bytes))
        local costs_limit_human = human_duration(limits.costs_us)
        local keys = dict:get_keys(0)
        for _, val in pairs(keys) do
            local match = "last:"..during
            if val:sub(1, #match) == match then
                local ip = val:sub(#match + 2)
                local first_time_str = get_ip_first_time(ip)
                local last_time = dict:get(val)
                local count = dict:get("count:"..during..":"..ip)
                local bytes = dict:get("bytes:"..during..":"..ip)
                local costs_us = dict:get("costs:"..during..":"..ip)
                local forbidden = dict:get("forbidden:"..during..":"..ip)
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

local request_type = ngx.var.arg_type or "page"

if request_type == "export" then
    -- 直接读取当天日志文件内容返回
    local filename = get_today_log_filename()
    local log_filename = "log/" .. filename
    local file = io.open(log_filename, "rb")
    if file then
        local content = file:read("*a")
        file:close()
        ngx.header.content_type = "text/csv; charset=utf-8"
        ngx.header.content_disposition = string.format('attachment; filename="%s"', filename)
        ngx.say(content)
    else
        ngx.header.content_type = "text/csv; charset=utf-8"
        ngx.header.content_disposition = string.format('attachment; filename="%s"', filename)
        ngx.say("\239\187\191IP,入站时间戳,是否被封禁\n")
    end
    return
elseif request_type == "data" then
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
        document.addEventListener('DOMContentLoaded', () => { fetchAndUpdate(); updateViewMode(); });
        setInterval(fetchAndUpdate, 500);
    </script>
    </head>
    <body>
        <div class="header-info">
            <h3>Your Current IP: <span id="current-ip" style="color: #007bff;"></span></h3>
            <button id="export-btn" class="export-btn" onclick="manualExport()">导出当日IP统计CSV</button>
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
            </tbody>
        </table>
        <div class="update-time">
            最后更新: <span id="last-update">]] .. os.date("%Y-%m-%d %H:%M:%S") .. [[</span>
        </div>
    </body>
    </html>
    ]])
end
