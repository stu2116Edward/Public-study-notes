local function exec_cmd(cmd)
    local ok = os.execute(cmd .. " >/dev/null 2>&1")
    if not ok then
        ngx.log(ngx.ERR, "Exec failed: ", cmd)
    end
end

-- 使用共享内存来存储被封禁的IP
local banned_ips = ngx.shared.banned_ips or ngx.shared.traffic_stats

local function firewall_init()
    ngx.log(ngx.INFO, "Firewall initialization skipped in container environment")
end

-- 在脚本运行时初始化
firewall_init()

local function set_key(dict, key, value)
    local ok, err = dict:set(key, value)
    if not ok then
        ngx.log(ngx.ERR, "Set key", key, "err", err)
        ngx.exit(444)
    end
end

local function str_concat(...)
    local str = {...}
    return table.concat(str, ':')
end

-- 使用共享内存来封禁IP（替代ipset）
local function ban_ip(ip)
    -- 将IP加入共享内存的黑名单，有效期24小时
    local ok, err = banned_ips:set("banned:" .. ip, true, 86400)
    if not ok then
        ngx.log(ngx.ERR, "Failed to ban IP in shared memory: ", ip, " err: ", err)
    else
        ngx.log(ngx.ERR, "IP banned in shared memory: ", ip)
    end
end

-- 检查IP是否被封禁
local function is_ip_banned(ip)
    return banned_ips:get("banned:" .. ip) == true
end

local function protect(during, ttl, count_limit, bytes_limit, costs_limit)
    local dict = ngx.shared.traffic_stats
    local timestamp = ngx.now()
    local ip = ngx.var.limit_key
    
    -- 首先检查IP是否已经被封禁
    if is_ip_banned(ip) then
        ngx.exit(444)
    end

    local count_key = str_concat("count", during, ip)
    local bytes_key = str_concat("bytes", during, ip)
    local costs_key = str_concat("costs", during, ip)
    local last_time_key = str_concat("last", during, ip)
    local forbidden_key = str_concat("forbidden", during, ip)

    local last_time = dict:get(last_time_key)
    if last_time == nil or last_time + ttl < timestamp then
        set_key(dict, last_time_key, timestamp)
        set_key(dict, count_key, 0)
        set_key(dict, bytes_key, 0)
        set_key(dict, costs_key, 0)
        set_key(dict, forbidden_key, false)
    end

    local count = dict:get(count_key)
    if count ~= nil and count > tonumber(count_limit) then
        set_key(dict, forbidden_key, true)
        ban_ip(ip)
        ngx.exit(444)
    end

    local bytes = dict:get(bytes_key)
    if bytes ~= nil and bytes > tonumber(bytes_limit) then
        set_key(dict, forbidden_key, true)
        ban_ip(ip)
        ngx.exit(444)
    end

    local cost = dict:get(costs_key)
    if cost ~= nil and cost > tonumber(costs_limit) then
        set_key(dict, forbidden_key, true)
        ban_ip(ip)
        ngx.exit(444)
    end
end

protect("hour", 3600, ngx.var.limit_count_per_hour, ngx.var.limit_bytes_per_hour, ngx.var.limit_costs_per_hour)
protect("day", 3600 * 24, ngx.var.limit_count_per_day, ngx.var.limit_bytes_per_day, ngx.var.limit_costs_per_day)
