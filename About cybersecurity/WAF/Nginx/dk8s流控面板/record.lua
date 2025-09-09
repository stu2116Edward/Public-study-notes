function str_concat(...)
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

-- 获取当前日期的日志文件名
local function get_current_log_filename()
    local now = os.time()
    local today = os.date("*t", now)
    return string.format("%04d%02d%02d.csv", today.year, today.month, today.day)
end

-- 检查IP是否被封禁
local function is_ip_banned(ip, during)
    local dict = ngx.shared.traffic_stats
    local forbidden_key = str_concat("forbidden", during, ip)
    local banned = dict:get(forbidden_key)
    return banned == true
end

-- 更新日志中IP的封禁状态
local function update_ip_ban_status_in_log(ip, banned_status)
    ensure_log_directory()
    local log_filename = "log/" .. get_current_log_filename()
    
    local dict = ngx.shared.traffic_stats
    local offset_key = "log_offset:" .. ip
    local last_status_key = "last_ban_status:" .. ip
    
    -- 获取上次记录的封禁状态和文件偏移量
    local last_status = dict:get(last_status_key)
    local file_offset = dict:get(offset_key)
    
    -- 如果状态无变化或偏移量不存在，则跳过
    if last_status == banned_status or not file_offset then
        return
    end
    
    -- 格式化新状态行
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
    
    local timestamp = os.time()
    local new_entry = table.concat({
        csv_escape(ip),
        csv_escape(format_ts(timestamp)),
        csv_escape(banned_status and "true" or "false")
    }, ",") .. "\n"
    
    -- 覆盖写入更新状态
    local file = io.open(log_filename, "r+")
    if file then
        file:seek("set", file_offset)
        file:write(new_entry)
        file:close()
        
        -- 更新最后状态记录
        dict:set(last_status_key, banned_status, 86400)
    end
end

-- 记录IP到CSV文件（首次记录）
local function log_ip_to_csv(ip)
    ensure_log_directory()
    local log_filename = "log/" .. get_current_log_filename()
    local dict = ngx.shared.traffic_stats
    local recorded_key = "recorded:" .. ip
    
    if not dict:get(recorded_key) then
        local timestamp = os.time()
        local banned = is_ip_banned(ip, "hour") or is_ip_banned(ip, "day")
        local banned_status = banned and "true" or "false"
        
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
        
        local log_entry = table.concat({
            csv_escape(ip),
            csv_escape(format_ts(timestamp)),
            csv_escape(banned_status)
        }, ",") .. "\n"
        
        local file = io.open(log_filename, "a")
        if file then
            local file_size = file:seek("end")
            if file_size == 0 then
                file:write("\239\187\191")  -- UTF-8 BOM
                file:write("IP,入站时间戳,是否被封禁\n")
            end
            
            -- 记录当前写入位置的偏移量
            local offset = file:seek("end")
            file:write(log_entry)
            file:close()
            
            -- 保存偏移量和状态到共享字典
            dict:set(recorded_key, true, 86400)
            dict:set("log_offset:" .. ip, offset, 86400)
            dict:set("last_ban_status:" .. ip, banned, 86400)
            
            if not dict:get("first:hour:"..ip) then
                dict:add("first:hour:"..ip, timestamp, 86400)
            end
        end
    else
        -- 非首次记录，检查状态变化并更新
        local banned = is_ip_banned(ip, "hour") or is_ip_banned(ip, "day")
        update_ip_ban_status_in_log(ip, banned)
    end
end

function stats(during)
    local request_length = ngx.var.request_length
    local bytes_sent = ngx.var.bytes_sent
    local ip = ngx.var.limit_key
    local dict = ngx.shared.traffic_stats
    local count_key = str_concat("count", during, ip)
    local bytes_key = str_concat("bytes", during, ip)
    local costs_key = str_concat("costs", during, ip)

    local start_clock = ngx.ctx.start_clock or os.clock()
    local request_time = os.clock() - start_clock
    local request_time_us = request_time * 1000000

    local ok, err = dict:incr(count_key, 1)
    if not ok then
        ngx.log(ngx.ERR, "Failed to incr count for key ", count_key, ": ", err)
    end

    ok, err = dict:incr(bytes_key, request_length + bytes_sent)
    if not ok then
        ngx.log(ngx.ERR, "Failed to incr bytes for key ", bytes_key, ": ", err)
    end

    ok, err = dict:incr(costs_key, request_time_us)
    if not ok then
        ngx.log(ngx.ERR, "Failed to incr costs for key ", costs_key, ": ", err)
    end
    
    if during == "hour" then
        log_ip_to_csv(ip)
    end
end

stats("hour")
stats("day")
