-- local random = math.random

-- function request()
--     local ip = string.format("%d.%d.%d.%d", random(0, 255), random(0, 255), random(0, 255), random(0, 255))
--     wrk.headers["X-Forwarded-For"] = ip
--     wrk.headers["Host"] = "blog.kejilion.pro"
--     return wrk.format("GET", path)
-- end

local random = math.random

-- 随机字符串生成器
function random_string(length)
    local chars = "abcdefghijklmnopqrstuvwxyz0123456789"
    local str = ""
    for i = 1, length do
        local idx = random(1, #chars)
        str = str .. chars:sub(idx, idx)
    end
    return str
end

-- 生成伪造 IP 地址
function gen_ip()
    return string.format("%d.%d.%d.%d", random(1, 255), random(0, 255), random(0, 255), random(1, 254))
end

function request()
    local ip = gen_ip()
    local ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"

    -- 生成路径，形式如 /abc123/page/42?ref=xyz
    local path = string.format("/%s/page/%d?ref=%s",
        random_string(6),
        random(1, 100),
        random_string(4)
    )

    wrk.headers["Host"] = "blog.kejilion.pro"
    wrk.headers["User-Agent"] = ua
    wrk.headers["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"
    wrk.headers["Accept-Encoding"] = "gzip, deflate"
    wrk.headers["Accept-Language"] = "zh-CN,zh;q=0.9"
    wrk.headers["Cache-Control"] = "no-cache"
    wrk.headers["Connection"] = "keep-alive"
    wrk.headers["Referer"] = "https://blog.kejilion.pro/"
    wrk.headers["Upgrade-Insecure-Requests"] = "1"

    -- 常见伪造 IP 头部
    wrk.headers["X-Forwarded-For"] = ip
    wrk.headers["X-Real-IP"] = ip
    wrk.headers["X-Client-IP"] = ip
    wrk.headers["X-Remote-IP"] = ip
    wrk.headers["X-Remote-Addr"] = ip
    wrk.headers["True-Client-IP"] = ip
    wrk.headers["CF-Connecting-IP"] = ip
    wrk.headers["Fastly-Client-IP"] = ip
    wrk.headers["X-Cluster-Client-IP"] = ip
    wrk.headers["Forwarded"] = "for=" .. ip

    return wrk.format("GET", path)
end



-- wrk -s ./wrk.lua -c 500 -t 8 -d 600s -c 10 http://[target]
-- wrk -s ./wrk.lua -c 500 -t 8 -d 600s -c 150 http://[target]
-- wrk -s ./wrk.lua -c 500 -t 8 -d 600s -c 100000 http://[target]
