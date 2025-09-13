local function str_concat(...)
    local str = {...}
    return table.concat(str, ':')
end

-- IP 获取方式：优先 X-Forwarded-For 的第一个
local function get_real_ip()
    local xff = ngx.var.http_x_forwarded_for
    if xff and xff ~= "" then
        local ip = xff:match("([^,%s]+)")
        return ip or ngx.var.remote_addr or "-"
    else
        return ngx.var.remote_addr or "-"
    end
end

-- 确保日志目录存在
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
    if not ts or ts == 0 or ts == "" then return "-" end
    local t = os.date("*t", ts)
    return string.format("%d-%d-%d %02d:%02d:%02d", t.year, t.month, t.day, t.hour, t.min, t.sec)
end

local function is_ip_banned(ip, during)
    local dict = ngx.shared.traffic_stats
    local forbidden_key = str_concat("forbidden", during, ip)
    local banned = dict:get(forbidden_key)
    return banned == true
end

-- 字段写入时始终加双引号，不允许空字符串
local function csv_escape(v)
    if v == nil or v == "" then v = "-" end
    v = tostring(v)
    v = v:gsub('"', '""')
    return '"' .. v .. '"'
end

local function record_ip_log(ip)
    ensure_log_directory()
    local dict = ngx.shared.traffic_stats
    local log_filename = "log/" .. get_today_log_filename()
    local first_key = "first:hour:" .. ip
    local first_visit = dict:get(first_key)
    if not first_visit or first_visit == "" or first_visit == 0 then
        first_visit = os.time()
        dict:set(first_key, first_visit, 86400)
    end
    local banned = is_ip_banned(ip, "hour") or is_ip_banned(ip, "day")
    local banned_status = csv_escape(banned and "true" or "false")
    local log_entry = table.concat({
        csv_escape(ip),
        csv_escape(format_ts(first_visit)),
        banned_status
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

function stats(during)
    local request_length = tonumber(ngx.var.request_length) or 0
    local bytes_sent = tonumber(ngx.var.bytes_sent) or 0
    local ip = get_real_ip()
    local dict = ngx.shared.traffic_stats
    local count_key = str_concat("count", during, ip)
    local bytes_key = str_concat("bytes", during, ip)
    local costs_key = str_concat("costs", during, ip)
    local start_clock = ngx.ctx.start_clock or os.clock()
    local request_time = os.clock() - start_clock
    local request_time_us = request_time * 1e6

    local ok, err = dict:incr(count_key, 1)
    if not ok then dict:set(count_key, 1, 86400) end
    ok, err = dict:incr(bytes_key, request_length + bytes_sent)
    if not ok then dict:set(bytes_key, request_length + bytes_sent, 86400) end
    ok, err = dict:incr(costs_key, request_time_us)
    if not ok then dict:set(costs_key, request_time_us, 86400) end

    if during == "hour" then
        record_ip_log(ip)
    end
end

-- 页面访问也需要记录当前IP到日志
local function record_current_ip()
    local ip = get_real_ip()
    record_ip_log(ip)
end

record_current_ip()

stats("hour")
stats("day")
