local function str_concat(...)
    local str = {...}
    return table.concat(str, ':')
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

-- 获取当天日志文件名 YYYYMMDD.csv
local function get_today_log_filename()
    local now = os.time()
    local today = os.date("*t", now)
    return string.format("%04d%02d%02d.csv", today.year, today.month, today.day)
end

-- 格式化时间戳为 "YYYY-MM-DD HH:MM:SS"
local function format_ts(ts)
    if not ts or ts == 0 then return "-" end
    local t = os.date("*t", ts)
    return string.format("%d-%d-%d %02d:%02d:%02d", t.year, t.month, t.day, t.hour, t.min, t.sec)
end

-- 检查IP是否被封禁
local function is_ip_banned(ip, during)
    local dict = ngx.shared.traffic_stats
    local forbidden_key = str_concat("forbidden", during, ip)
    local banned = dict:get(forbidden_key)
    return banned == true
end

-- 字段写入时始终加双引号
local function csv_escape(v)
    v = tostring(v or "")
    v = v:gsub('"', '""')
    return '"' .. v .. '"'
end

-- 记录或更新一行日志（实时）
local function record_ip_log(ip)
    ensure_log_directory()
    local dict = ngx.shared.traffic_stats
    local log_filename = "log/" .. get_today_log_filename()
    -- 获取当天入站时间戳（首次访问时间）
    local first_key = "first:hour:" .. ip
    local first_visit = dict:get(first_key)
    if not first_visit then
        -- 首次访问，写入入站时间戳
        first_visit = os.time()
        dict:set(first_key, first_visit, 86400)
    end
    -- 当前封禁状态
    local banned = is_ip_banned(ip, "hour") or is_ip_banned(ip, "day")
    local banned_status = csv_escape(banned and "true" or "false")
    local log_entry = table.concat({
        csv_escape(ip),
        csv_escape(format_ts(first_visit)),
        banned_status
    }, ",") .. "\n"

    -- 用 IP 做唯一标识，维护偏移量，支持更新状态
    local offset_key = "log_offset:" .. ip
    local last_status_key = "last_ban_status:" .. ip
    local file_offset = dict:get(offset_key)
    local last_status = dict:get(last_status_key)

    -- 如果有旧行且只封禁状态变化，则覆盖最后一列
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
        return -- 如果不是首次且封禁没变则无需写新行
    end

    -- 首次写入或无偏移量时追加新行
    local file = io.open(log_filename, "a+")
    if file then
        local file_size = file:seek("end")
        if file_size == 0 then
            -- 文件为空，写入BOM和表头
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

-- 主统计函数，后台流量统计时调用
function stats(during)
    local request_length = tonumber(ngx.var.request_length) or 0
    local bytes_sent = tonumber(ngx.var.bytes_sent) or 0
    local ip = ngx.var.limit_key
    local dict = ngx.shared.traffic_stats
    local count_key = str_concat("count", during, ip)
    local bytes_key = str_concat("bytes", during, ip)
    local costs_key = str_concat("costs", during, ip)
    local start_clock = ngx.ctx.start_clock or os.clock()
    local request_time = os.clock() - start_clock
    local request_time_us = request_time * 1e6

    -- 统计流量数据
    local ok, err = dict:incr(count_key, 1)
    if not ok then dict:set(count_key, 1, 86400) end
    ok, err = dict:incr(bytes_key, request_length + bytes_sent)
    if not ok then dict:set(bytes_key, request_length + bytes_sent, 86400) end
    ok, err = dict:incr(costs_key, request_time_us)
    if not ok then dict:set(costs_key, request_time_us, 86400) end

    -- hour周期时，实时记录日志
    if during == "hour" then
        record_ip_log(ip)
    end
end

-- 后台实时调用（只要限流/统计事件发生即调用，页面无需调用）
stats("hour")
stats("day")
