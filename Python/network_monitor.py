#!/usr/bin/env python
# -*- coding: utf-8 -*-
# 这个脚本具有以下功能：
# 实时监控：每秒更新一次网卡流量数据,
# 这个脚本特别适合监控网络活动、识别带宽占用较大的网卡，或实时跟踪特定网卡的流量变化。
# 兼容python2和3
# 流量可视化：
#  - 显示接收和发送的总字节数
#  - 计算并显示接收和发送速率（字节 / 秒）
#  - 显示总流量速率
# 交互式排序：
#  - 按总流量排序（默认）
#  - 按接收流量排序
#  - 按发送流量排序
# 彩色显示：活跃网卡以粗体显示
# 响应式界面：自动适应终端窗口大小
#
# 使用方法
# 将脚本保存为 network_monitor.py
# 使用 root 权限运行：sudo python2 network_monitor.py
# 交互式控制：
# - 按 q 退出
# - 按 s 按总流量排序
# - 按 r 按接收流量排序
# - 按 t 按发送流量排序
# - 按 R 切换排序方向

import os
import time
import sys
import curses

def get_network_stats():
    """读取 /proc/net/dev 并解析网络接口统计信息"""
    stats = {}
    try:
        with open('/proc/net/dev', 'r') as f:
            lines = f.readlines()
    except Exception as e:
        print("Error reading /proc/net/dev:", e)
        return stats

    # 跳过标题行
    for line in lines[2:]:
        line = line.strip()
        if not line:
            continue
        
        # 分割行数据
        parts = line.split()
        if len(parts) < 17:
            continue
        
        # 获取接口名称和统计数据
        interface = parts[0].rstrip(':')
        rx_bytes = int(parts[1])
        rx_packets = int(parts[2])
        tx_bytes = int(parts[9])
        tx_packets = int(parts[10])
        
        stats[interface] = {
            'rx_bytes': rx_bytes,
            'rx_packets': rx_packets,
            'tx_bytes': tx_bytes,
            'tx_packets': tx_packets
        }
    
    return stats

def format_size(bytes):
    """将字节数格式化为更易读的单位"""
    units = ['B', 'KB', 'MB', 'GB', 'TB']
    unit_index = 0
    while bytes >= 1024 and unit_index < len(units) - 1:
        bytes /= 1024.0
        unit_index += 1
    return "{0:.2f} {1}".format(bytes, units[unit_index])

def format_rate(bytes_per_sec):
    """将字节速率格式化为更易读的单位"""
    return format_size(bytes_per_sec) + '/s'

def main(stdscr):
    """主函数，使用 curses 库创建交互式界面"""
    # 初始化 curses
    curses.curs_set(0)  # 隐藏光标
    stdscr.nodelay(1)   # 非阻塞输入
    stdscr.clear()
    
    # 显示使用说明
    help_text = "Press 'q' to quit, 's' to sort by total traffic, 'r' to sort by receive, 't' to sort by transmit"
    stdscr.addstr(0, 0, help_text, curses.A_REVERSE)
    
    # 初始采样
    prev_stats = get_network_stats()
    time.sleep(1)
    
    # 排序选项
    sort_key = 'total'
    sort_reverse = True
    
    last_time = time.time()  # 初始化上次时间
    
    while True:
        # 清除屏幕
        stdscr.clear()
        stdscr.addstr(0, 0, help_text, curses.A_REVERSE)
        
        # 当前采样
        current_stats = get_network_stats()
        
        # 计算时间差
        now = time.time()
        time_diff = now - last_time
        last_time = now
        
        # 确保时间差有效，避免除以零
        if time_diff <= 0:
            time_diff = 1.0  # 默认使用 1 秒作为时间差
        
        # 计算速率并准备显示数据
        interfaces = []
        for interface, stats in current_stats.items():
            if interface in prev_stats:
                prev = prev_stats[interface]
                
                # 计算速率，确保不会出现负值（可能由于计数器重置）
                rx_delta = max(0, stats['rx_bytes'] - prev['rx_bytes'])
                tx_delta = max(0, stats['tx_bytes'] - prev['tx_bytes'])
                
                rx_rate = rx_delta / time_diff
                tx_rate = tx_delta / time_diff
                total_rate = rx_rate + tx_rate
                
                interfaces.append({
                    'name': interface,
                    'rx_bytes': stats['rx_bytes'],
                    'tx_bytes': stats['tx_bytes'],
                    'rx_rate': rx_rate,
                    'tx_rate': tx_rate,
                    'total_rate': total_rate
                })
        
        # 排序
        if sort_key == 'total':
            interfaces.sort(key=lambda x: x['total_rate'], reverse=sort_reverse)
        elif sort_key == 'rx':
            interfaces.sort(key=lambda x: x['rx_rate'], reverse=sort_reverse)
        elif sort_key == 'tx':
            interfaces.sort(key=lambda x: x['tx_rate'], reverse=sort_reverse)
        
        # 显示表头
        headers = ["Interface", "RX Bytes", "TX Bytes", "RX Rate", "TX Rate", "Total Rate"]
        stdscr.addstr(2, 0, headers[0].ljust(16), curses.A_BOLD)
        stdscr.addstr(2, 16, headers[1].ljust(14), curses.A_BOLD)
        stdscr.addstr(2, 30, headers[2].ljust(14), curses.A_BOLD)
        stdscr.addstr(2, 44, headers[3].ljust(14), curses.A_BOLD)
        stdscr.addstr(2, 58, headers[4].ljust(14), curses.A_BOLD)
        stdscr.addstr(2, 72, headers[5].ljust(14), curses.A_BOLD)
        
        # 显示分割线
        stdscr.addstr(3, 0, "-" * 86, curses.A_DIM)
        
        # 显示每个网卡的信息
        for i, iface in enumerate(interfaces):
            y = i + 4
            if y >= curses.LINES - 1:  # 避免超出屏幕
                break
                
            # 高亮显示活跃的网卡
            attr = curses.A_NORMAL
            if iface['total_rate'] > 1024:  # 大于 1 KB/s
                attr = curses.A_BOLD
                
            stdscr.addstr(y, 0, iface['name'].ljust(16), attr)
            stdscr.addstr(y, 16, format_size(iface['rx_bytes']).ljust(14), attr)
            stdscr.addstr(y, 30, format_size(iface['tx_bytes']).ljust(14), attr)
            stdscr.addstr(y, 44, format_rate(iface['rx_rate']).ljust(14), attr)
            stdscr.addstr(y, 58, format_rate(iface['tx_rate']).ljust(14), attr)
            stdscr.addstr(y, 72, format_rate(iface['total_rate']).ljust(14), attr)
        
        # 显示排序状态
        sort_text = "Sorting by: "
        if sort_key == 'total':
            sort_text += "Total Traffic"
        elif sort_key == 'rx':
            sort_text += "Receive"
        elif sort_key == 'tx':
            sort_text += "Transmit"
        stdscr.addstr(curses.LINES - 1, 0, sort_text.ljust(40), curses.A_DIM)
        
        # 刷新屏幕
        stdscr.refresh()
        
        # 处理用户输入
        c = stdscr.getch()
        if c == ord('q'):
            break
        elif c == ord('s'):
            sort_key = 'total'
        elif c == ord('r'):
            sort_key = 'rx'
        elif c == ord('t'):
            sort_key = 'tx'
        elif c == ord('R'):
            sort_reverse = not sort_reverse
        
        # 更新前一次统计数据
        prev_stats = current_stats
        
        # 等待下一次采样
        time.sleep(1)

if __name__ == "__main__":
    # 检查是否有足够的权限
    if not os.access('/proc/net/dev', os.R_OK):
        print("Error: Cannot read /proc/net/dev. Run as root or use sudo.")
        sys.exit(1)
    
    # 运行 curses 界面
    try:
        curses.wrapper(main)
    except KeyboardInterrupt:
        print("\nExiting...")
