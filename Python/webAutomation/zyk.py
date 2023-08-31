# -*- coding=utf-8 -*-
import time

import pyautogui
import random

screenWidth, screenHeight = pyautogui.size()
pyautogui.FAILSAFE
print(screenWidth)
print(screenHeight)

# 设置随机的点击间隔时间，以模拟人工点击
interval = random.uniform(0.5, 1.5)


def play():
    pyautogui.moveTo(start, duration=1)
    pyautogui.click(clicks=1, interval=interval)


def to_click(_x, _y, _duration):
    # 先定位链接的位置
    # link_position = (_x, _y)
    # 然后模拟鼠标移动到链接位置
    pyautogui.moveTo((_x, _y), duration=1)

    # 模拟单次点击
    pyautogui.click(clicks=1, interval=interval)
    # 鼠标滚轮向上滚动10个单位
    # pyautogui.scroll(10)
    # 播放视频
    if _duration != 0:
        time.sleep(4)
        play()
        # pass
        print("播放时间：%s 分钟" % _duration)
    time.sleep(_duration * 60)


x = 1000
y = 400
start = (450, 327)

v_list = {
    1: (1000, 171, 10),
    2: (1000, 199, 9),
    3: (1000, 221, 8),
    4: (1000, 248, 6),
    5: (1000, 272, 7),
    6: (1000, 272, 9),
    7: (1000, 199, 14),
    8: (1000, 221, 11),
    9: (1000, 248, 10),
    10: (1000, 272, 8),
    11: (1000, 272, 10),
    12: (1000, 199, 10),
    13: (1000, 221, 12),
    14: (1000, 248, 9),
    15: (1000, 272, 21),
    16: (1000, 199, 22),
    17: (1000, 221, 24),
    18: (1000, 248, 12),
    19: (1000, 272, 9),
    20: (1000, 272, 9),
    21: (1000, 199, 8),
    22: (1000, 221, 10),
    23: (1000, 248, 11),  # 艺术高超
    24: (1000, 272, 14),
    25: (1000, 272, 9),
    26: (1000, 272, 7),
    27: (1000, 272, 6),
    28: (1000, 272, 8),
    29: (1000, 272, 9),

}
t = 0
yy = 171
if __name__ == '__main__':
    for k, v in v_list.items():

        x = v[0]
        y = yy + t
        tduration = v[2]
        if 7 <= k <= 17 and k != 15:
            print(time.strftime("%Y-%m-%d %H:%M:%S"), end="")
            print(" 播放序号：", k)

            to_click(x, y, tduration)
        t += 25
    print("done-------------")
