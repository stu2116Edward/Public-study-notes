-- 增强版随机用户代理生成器
function get_random_ua()
    -- 定义主要浏览器类型及其特征
    local browsers = {
        {
            name = "Chrome",
            base = "Mozilla/5.0 (%s) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%d.%d.%d.%d Safari/537.36",
            os = {
                "(Windows NT 10.0; Win64; x64)",
                "(Macintosh; Intel Mac OS X 10_15_7)",
                "(X11; Linux x86_64)",
                "(Windows NT 10.0; Win64; x64; rv:89.0)"
            },
            major_version_range = {100, 115},
            minor_version_range = {0, 50},
            build_version_range = {0, 9999},
            patch_version_range = {1, 200}
        },
        {
            name = "Safari",
            base = "Mozilla/5.0 (%s) AppleWebKit/%d.%d.%d (KHTML, like Gecko) Version/%d.%d.%d Safari/%d.%d.%d",
            os = {
                "(Macintosh; Intel Mac OS X 10_15_7)",
                "(iPhone; CPU iPhone OS 14_6 like Mac OS X)",
                "(iPad; CPU OS 14_6 like Mac OS X)"
            },
            webkit_major = {605, 615},
            webkit_minor = {0, 50},
            webkit_patch = {0, 20},
            version_major = {14, 16},
            version_minor = {0, 5},
            version_patch = {0, 3},
            safari_major = {605, 615},
            safari_minor = {0, 50},
            safari_patch = {0, 20}
        },
        {
            name = "Firefox",
            base = "Mozilla/5.0 (%s; rv:%d.%d) Gecko/20100101 Firefox/%d.%d",
            os = {
                "(Windows NT 10.0; Win64; x64)",
                "(Macintosh; Intel Mac OS X 10.15; rv:91.0)",
                "(X11; Linux i686; rv:91.0)",
                "(Windows NT 6.1; Win64; x64; rv:91.0)"
            },
            rv_major = {90, 110},
            rv_minor = {0, 10},
            firefox_major = {90, 110},
            firefox_minor = {0, 10}
        },
        {
            name = "Edge",
            base = "Mozilla/5.0 (%s) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%d.%d.%d.%d Safari/537.36 Edg/%d.%d.%d.%d",
            os = {
                "(Windows NT 10.0; Win64; x64)",
                "(Windows NT 10.0; Win64; x64; rv:89.0)"
            },
            chrome_major = {100, 115},
            chrome_minor = {0, 50},
            chrome_build = {0, 9999},
            chrome_patch = {1, 200},
            edge_major = {100, 115},
            edge_minor = {0, 50},
            edge_build = {0, 9999},
            edge_patch = {1, 200}
        }
    }
    
    -- 随机选择浏览器类型
    local browser = browsers[math.random(1, #browsers)]
    
    if browser.name == "Chrome" then
        return string.format(
            browser.base,
            browser.os[math.random(1, #browser.os)],
            math.random(browser.major_version_range[1], browser.major_version_range[2]),
            math.random(browser.minor_version_range[1], browser.minor_version_range[2]),
            math.random(browser.build_version_range[1], browser.build_version_range[2]),
            math.random(browser.patch_version_range[1], browser.patch_version_range[2])
        )
    elseif browser.name == "Safari" then
        return string.format(
            browser.base,
            browser.os[math.random(1, #browser.os)],
            math.random(browser.webkit_major[1], browser.webkit_major[2]),
            math.random(browser.webkit_minor[1], browser.webkit_minor[2]),
            math.random(browser.webkit_patch[1], browser.webkit_patch[2]),
            math.random(browser.version_major[1], browser.version_major[2]),
            math.random(browser.version_minor[1], browser.version_minor[2]),
            math.random(browser.version_patch[1], browser.version_patch[2]),
            math.random(browser.safari_major[1], browser.safari_major[2]),
            math.random(browser.safari_minor[1], browser.safari_minor[2]),
            math.random(browser.safari_patch[1], browser.safari_patch[2])
        )
    elseif browser.name == "Firefox" then
        return string.format(
            browser.base,
            browser.os[math.random(1, #browser.os)],
            math.random(browser.rv_major[1], browser.rv_major[2]),
            math.random(browser.rv_minor[1], browser.rv_minor[2]),
            math.random(browser.firefox_major[1], browser.firefox_major[2]),
            math.random(browser.firefox_minor[1], browser.firefox_minor[2])
        )
    elseif browser.name == "Edge" then
        return string.format(
            browser.base,
            browser.os[math.random(1, #browser.os)],
            math.random(browser.chrome_major[1], browser.chrome_major[2]),
            math.random(browser.chrome_minor[1], browser.chrome_minor[2]),
            math.random(browser.chrome_build[1], browser.chrome_build[2]),
            math.random(browser.chrome_patch[1], browser.chrome_patch[2]),
            math.random(browser.edge_major[1], browser.edge_major[2]),
            math.random(browser.edge_minor[1], browser.edge_minor[2]),
            math.random(browser.edge_build[1], browser.edge_build[2]),
            math.random(browser.edge_patch[1], browser.edge_patch[2])
        )
    end
    
    -- 默认返回原始列表中的随机UA
    return user_agents[math.random(1, #user_agents)]
end