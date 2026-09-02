@echo off
:: 网络重置与DNS修复脚本
:: 功能：释放IP、刷新DNS、重置Winsock与TCP/IP协议栈
:: 使用前请以管理员身份运行！
:: 设置窗口标题与颜色，提升可读性
title 网络重置与DNS修复工具
color 0a
cls
echo.
echo  ===================================================
echo       欢迎使用网络重置与DNS修复工具
echo       请务必以管理员身份运行此脚本！
echo       执行过程中网络将暂时断开，请勿中断操作。
echo  ===================================================
echo.

:: ---------- 管理员权限检查与提升 ----------
net session >nul 2>&1
if %errorlevel% neq 0 (
    :: 如果系统有 PowerShell，则尝试以管理员权限重新运行脚本（UAC 提升）
    where powershell >nul 2>&1
    if %errorlevel%==0 (
        echo 检测到未以管理员运行，正在尝试以管理员权限重新启动脚本...
        powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
        exit /b
    ) else (
        echo 错误：此脚本必须以管理员权限运行，但未检测到 PowerShell 可用于提升。
        echo 请右键本脚本并选择“以管理员身份运行”。
        pause
        exit /b 1
    )
)

echo  正在执行网络重置操作，请稍候...
echo.

:: 显示重置前的完整网络配置信息
echo 正在显示重置前的网络配置信息...
ipconfig /all
echo.

:: 1. 释放当前IP地址
echo [1/5] 正在释放IP地址...
ipconfig /release
echo.

:: 2. 重新获取IP地址
echo [2/5] 正在重新获取IP地址...
ipconfig /renew
echo.

:: 3. 清除DNS缓存
echo [3/5] 正在清除DNS缓存...
ipconfig /flushdns
echo.

:: 4. 重置Winsock目录
echo [4/5] 正在重置 Winsock...
netsh winsock reset
echo.

:: 5. 重置 TCP/IP 协议栈（会生成重置日志文件）
echo [5/5] 正在重置 TCP/IP 协议栈...
netsh int ip reset
echo.

:: 显示重置后的完整网络配置信息
echo 正在显示重置后的网络配置信息...
ipconfig /all
echo.

echo.
echo  网络重置与 DNS 修复步骤已完成。
echo  建议：为确保所有更改生效，请考虑重启系统（此脚本不会自动重启）。
echo.

:: 显示日志/提示：若想查看命令输出/错误，请将各命令的重定向（>nul 2>&1）移除以观察详细信息。
echo 按任意键退出...
pause >nul
exit /b 0