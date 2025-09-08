function str_concat(...)
    local str = {...}
    return table.concat(str, ':')
end

-- 确保日志目录存在
local function ensure_log_directory()
    local log_dir = "log"
    -- 使用io.open检查一个文件是否可写以判断目录存在性
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

-- 获取当前日期的日志文件名（与stats.lua一致）
local function get_current_log_filename()
    local now = os.time()
    local today = os.date("*t", now)
    return string.format("%04d%02d%02d.csv", today.year, today.month, today.day)
end

-- 记录IP日志到CSV文件（与stats.lua格式同步）
local function log_ip_to_csv(ip, banned)
    ensure_log_directory()
    
    -- 获取日志文件名（与stats.lua一致）
    local log_filename = "log/" .. get_current_log_filename()
    
    -- 检查IP是否已记录（避免重复）
    local recorded_ips = {}
    local file = io.open(log_filename, "r")
    if file then
        -- 读取CSV文件头
        local header = file:read("*l")
        
        -- 读取已记录的IP
        for line in file:lines() do
            local recorded_ip = line:match("^\"?([^\",]+)\"?,")
            if recorded_ip then
                recorded_ips[recorded_ip] = true
            end
        end
        file:close()
    end
    
    -- 如果IP未记录，则添加到CSV
    if not recorded_ips[ip] then
        local timestamp = os.time()  -- 使用Unix时间戳
        local banned_status = banned and "true" or "false"
        
        -- CSV转义函数（与stats.lua一致）
        local function csv_escape(v)
            v = tostring(v or "")
            v = v:gsub('"', '""')
            return '"' .. v .. '"'
        end
        
        -- 格式化时间戳（与stats.lua一致）
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
            -- 如果是新文件，写入CSV表头
            if not recorded_ips[ip] and not file:seek("end") then
                file:write("\239\187\191")  -- UTF-8 BOM
                file:write("IP,入站时间戳,是否被封禁\n")
            end
            
            file:write(log_entry)
            file:close()
            
            -- 更新共享字典中的首次访问时间（与stats.lua同步）
            local dict = ngx.shared.traffic_stats
            if during == "hour" and not dict:get("first:hour:"..ip) then
                dict:add("first:hour:"..ip, timestamp)
            end
        end
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

    -- 使用os.clock()计算实际耗时（秒，高精度）
    local start_clock = ngx.ctx.start_clock or os.clock()
    local request_time = os.clock() - start_clock  -- 耗时（秒）
    local request_time_us = request_time * 1000000  -- 转换为微秒

    -- 检查是否能成功写入共享内存，如果失败则记录错误并退出
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
    
    -- 检查是否被封禁
    local forbidden_key = str_concat("forbidden", during, ip)
    local is_banned = dict:get(forbidden_key) or false
    
    -- 记录IP到CSV文件（仅记录一次，与stats.lua同步）
    if during == "hour" then
        log_ip_to_csv(ip, is_banned)
    end
end

stats("hour")
stats("day")