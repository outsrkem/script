#!/usr/bin/env python3
# -*- coding:utf-8 -*-
# 随机生成人员信息
#
#
#
import sys, time
import random


'''
PyMySQL==0.9.3
'''


class PersonalInformation():
    # 生成姓名
    def Names_of_generated(self):
        list_Xing = [
            '赵', '钱', '孙', '李', '周', '吴', '郑', '王', '冯', '陈', '褚', '卫', '蒋', '沈', '韩', '杨', '朱', '秦',
            '尤', '许', '何', '吕', '施', '张', '孔', '曹', '墨', '哈', '谯', '笪', '年', '爱', '阳', '佟', '言', '福',
            '严', '华', '金', '魏', '陶', '姜', '戚', '谢', '邹', '喻', '柏', '水', '窦', '章', '云', '苏', '牟', '佘',
            '潘', '葛', '奚', '范', '彭', '郎', '鲁', '韦', '昌', '马', '苗', '凤', '花', '方', '俞', '任', '袁', '柳',
            '酆', '鲍', '史', '唐', '费', '廉', '岑', '薛', '雷', '贺', '倪', '汤', '滕', '殷', '罗', '毕', '郝', '邬',
            '安', '常', '乐', '于', '时', '傅', '皮', '卞', '齐', '康', '伍', '余', '元', '卜', '顾', '孟', '平', '黄',
            '和', '穆', '萧', '尹', '姚', '邵', '湛', '汪', '祁', '毛', '禹', '狄', '米', '贝', '明', '臧', '计', '伏',
            '成', '戴', '谈', '宋', '茅', '庞', '熊', '纪', '舒', '屈', '项', '祝', '董', '粱', '杜', '阮', '蓝', '闵',
            '席', '季', '麻', '强', '贾', '路', '娄', '危', '江', '童', '颜', '郭', '梅', '盛', '林', '刁', '钟', '徐',
            '邱', '骆', '高', '夏', '蔡', '田', '樊', '胡', '凌', '霍', '虞', '万', '支', '柯', '昝', '管', '卢', '莫',
            '经', '房', '裘', '缪', '干', '解', '应', '宗', '丁', '宣', '贲', '邓', '郁', '单', '杭', '洪', '包', '诸',
            '左', '石', '崔', '吉', '钮', '龚', '程', '嵇', '邢', '滑', '裴', '陆', '荣', '翁', '荀', '羊', '於', '惠',
            '甄', '麴', '家', '封', '芮', '羿', '储', '靳', '汲', '邴', '糜', '松', '井', '段', '富', '巫', '乌', '焦',
            '巴', '弓', '牧', '隗', '山', '谷', '车', '侯', '宓', '蓬', '全', '郗', '班', '仰', '秋', '仲', '伊', '宫',
            '宁', '仇', '栾', '暴', '甘', '钭', '厉', '戎', '祖', '武', '符', '刘', '景', '詹', '束', '龙', '叶', '幸',
            '司', '韶', '郜', '黎', '蓟', '薄', '印', '宿', '白', '怀', '蒲', '邰', '从', '鄂', '索', '咸', '籍', '赖',
            '卓', '蔺', '屠', '蒙', '池', '乔', '阴', '欎', '胥', '能', '苍', '双', '闻', '莘', '党', '翟', '谭', '贡',
            '劳', '逄', '姬', '申', '扶', '堵', '冉', '宰', '郦', '雍', '舄', '璩', '桑', '桂', '濮', '牛', '寿', '通',
            '边', '扈', '燕', '冀', '郏', '浦', '尚', '农', '温', '别', '庄', '晏', '柴', '瞿', '阎', '充', '慕', '连',
            '茹', '习', '宦', '艾', '鱼', '容', '向', '古', '易', '慎', '戈', '廖', '庾', '终', '暨', '居', '衡', '步',
            '都', '耿', '满', '弘', '匡', '国', '文', '寇', '广', '禄', '阙', '东', '殴', '殳', '沃', '利', '蔚', '越',
            '夔', '隆', '师', '巩', '厍', '聂', '晁', '勾', '敖', '融', '冷', '訾', '辛', '阚', '那', '简', '饶', '空',
            '曾', '毋', '沙', '乜', '养', '鞠', '须', '丰', '巢', '关', '蒯', '相', '查', '後', '荆', '红', '游', '竺',
            '权', '逯', '盖', '益', '桓', '商', '佴', '伯', '赏', '闫', '法', '汝', '鄢', '涂', '钦', '帅', '缑', '亢',
            '况', '后', '有', '琴', '仉', '督', '归', '海', '岳', '公', '晋', '娜', '静', '楚', '惠', '倩', '婷', '宁',
            '万俟', '司马', '上官', '欧阳', '夏侯', '诸葛', '闻人', '乐正', '壤驷', '公良', '拓跋', '漆雕', '夹谷', '宰父',
            '东方', '赫连', '皇甫', '尉迟', '公羊', '澹台', '公冶', '宗政', '濮阳', '淳于', '单于', '太叔', '申屠', '公孙',
            '仲孙', '南宫', '南门', '呼延', '羊舌', '微生', '梁丘', '左丘', '东门', '西门', '东郭', '巫马', '公西', '谷梁',
            '轩辕', '令狐', '钟离', '宇文', '长孙', '慕容', '鲜于', '闾丘', '司徒', '司空', '亓官', '司寇', '颛孙', '端木',
            '子车', '百里', '段干'
        ]
        list_Ming = [
            '伟', '刚', '勇', '毅', '俊', '峰', '强', '军', '平', '保', '东', '文', '辉', '力', '明', '永', '健', '世',
            '广', '志', '义', '兴', '轮', '翰', '朗', '惠', '珠', '翠', '莉', '桂', '娣', '筠', '柔', '竹', '婕', '馨',
            '飞', '彬', '富', '顺', '信', '子', '杰', '涛', '昌', '成', '康', '星', '光', '天', '达', '安', '岩', '中',
            '茂', '进', '林', '有', '伯', '雅', '叶', '霭', '苑', '瑗', '绍', '功', '松', '徐', '孺', '饯', '子', '徐',
            '厚', '庆', '磊', '民', '友', '裕', '河', '哲', '江', '超', '浩', '亮', '政', '谦', '亨', '奇', '固', '之',
            '致', '树', '炎', '德', '行', '时', '泰', '盛', '秀', '娟', '英', '华', '慧', '巧', '美', '娜', '静', '淑',
            '雪', '荣', '爱', '妹', '霞', '香', '月', '莺', '媛', '艳', '瑞', '凡', '佳', '嘉', '琼', '勤', '珍', '贞',
            '怡', '婵', '雁', '蓓', '纨', '仪', '荷', '丹', '蓉', '眉', '君', '琴', '蕊', '薇', '菁', '梦', '岚', '苑',
            '飘', '育', '馥', '琦', '晶', '妍', '茜', '秋', '珊', '莎', '锦', '黛', '青', '倩', '婷', '宁', '蓓', '纨',
            '良', '海', '山', '仁', '波', '宁', '贵', '福', '生', '龙', '元', '全', '国', '胜', '学', '祥', '才', '发',
            '武', '新', '利', '清', '善', '希', '地', '灵', '枝', '思', '丽', '瑾', '颖', '露', '云', '莲', '真', '环',
            '坚', '和', '彪', '博', '诚', '先', '敬', '震', '振', '壮', '会', '思', '群', '豪', '心', '邦', '承', '乐',
            '宏', '言', '若', '鸣', '朋', '斌', '梁', '栋', '维', '启', '克', '伦', '翔', '旭', '鹏', '泽', '晨', '辰',
            '芝', '玉', '萍', '红', '娥', '玲', '芬', '芳', '燕', '彩', '春', '菊', '兰', '凤', '洁', '梅', '琳', '素',
            '璧', '璐', '娅', '琦', '晶', '妍', '茜', '秋', '珊', '莎', '锦', '黛', '青', '倩', '婷', '姣', '婉', '娴',
            '凝', '晓', '欢', '霄', '枫', '芸', '菲', '寒', '欣', '滢', '伊', '亚', '宜', '可', '姬', '舒', '影', '荔',
            '琰', '韵', '融', '园', '艺', '咏', '卿', '聪', '澜', '纯', '毓', '悦', '昭', '冰', '爽', '琬', '茗', '羽',
            '引', '瓯', '越', '物', '华', '天', '宝', '龙', '光', '射', '牛', '斗', '之', '墟', '人', '杰', '地', '灵',
            '士', '以', '建', '家', '瑶', '秀'
        ]
        return random.choice(list_Xing) + random.choice(list_Ming) + random.choice(list_Ming)

    # 生成有效手机号码
    def phoneNORandomGenerator(self):
        prelist = ["130", "131", "132", "133", "134", "135", "136", "137", "138", "139", "147", "150", "151", "152",
                   "153", "155", "156", "157", "158", "159", "186", "187", "188"]
        return random.choice(prelist) + "".join(random.choice("0123456789") for i in range(8))

    # 邮箱
    def emaliInfo(self, phone):
        eList = ['@163.com', '@126.com', '@qq.com',
                 '@sina.com', '@soho.com', '@yeah.com', '@139.com']
        return phone + random.choice(eList)


    # 年龄
    def ageInfo(self):
        return random.randint(12, 60)

    # 性别
    def sexInfo(self):
        sex = random.choice(['男', '女'])
        return sex

    # 生日
    def getBirthday(self):
        # 随机生成年月日
        year = random.randint(1960, 2000)
        month = random.randint(1, 12)
        # 判断每个月有多少天随机生成日
        if year % 4 == 0:
            if month in (1, 3, 5, 7, 8, 10, 12):
                day = random.randint(1, 31)
            elif month in (4, 6, 9, 11):
                day = random.randint(1, 30)
            else:
                day = random.randint(1, 29)
        else:
            if month in (1, 3, 5, 7, 8, 10, 12):
                day = random.randint(1, 31)
            elif month in (4, 6, 9, 11):
                day = random.randint(1, 30)
            else:
                day = random.randint(1, 28)
        # 小于10的月份前面加0
        if month < 10:
            month = '0' + str(month)
        if day < 10:
            day = '0' + str(day)
        birthday = str(year) + str(month) + str(day)
        return birthday

    # 身份证号
    def idnum(self, Birthday, sex):
        province_id = [11, 12, 13, 14, 15, 21, 22, 23, 31, 32, 33, 34, 35, 36, 37, 41, 42, 43, 44, 45, 46, 50, 51, 52,
                       53, 54, 61, 62, 63, 65, 65, 81, 82, 83]
        id_num = ''
        # 随机选择地址码
        id_num += str(random.choice(province_id))
        # 随机生成4-6位地址码
        for i in range(4):
            ran_num = str(random.randint(0, 9))
            id_num += ran_num
        b = Birthday
        id_num += b
        # 生成15、16位顺序号
        num = ''
        for i in range(2):
            num += str(random.randint(0, 9))
        id_num += num
        # 通过性别判断生成第十七位数字 男单 女双
        s = sex
        if s == '男':
            # 生成奇数
            seventeen_num = random.randrange(1, 9, 2)
        else:
            seventeen_num = random.randrange(2, 9, 2)

        id_num += str(seventeen_num)
        eighteen_num = str(random.randint(1, 10))
        if eighteen_num == '10':
            eighteen_num = 'X'
        id_num += eighteen_num
        return id_num


def PersonalInfo():
    PersonalInfo = PersonalInformation()
    info = {}
    info['name'] = PersonalInfo.Names_of_generated()
    info['age'] = PersonalInfo.ageInfo()
    info['sex'] = PersonalInfo.sexInfo()
    info['birthday'] = PersonalInfo.getBirthday()
    info['idnum'] = PersonalInfo.idnum(info['birthday'], info['sex'])
    info['phone'] = PersonalInfo.phoneNORandomGenerator()
    info['emali'] = PersonalInfo.emaliInfo(info['phone'])

    return info


import json

PersolInfoDict = PersolInfo = PersonalInfo()
# sort_keys是告诉编码器按照字典key排序(a到z)输出。
# indent参数根据数据格式缩进显示，读起来更加清晰, indent的值，代表缩进空格式
# separators参数的作用是去掉‘，’ ‘：’后面的空格，在传输数据的过程中，越精简越好，冗余的东西全部去掉。
PersolInfoJson = json.dumps(PersolInfo, ensure_ascii=False,sort_keys=True,indent=4,separators=(',',':'))


print(type(PersolInfoDict))
print(PersolInfoDict)

print(type(PersolInfoJson))
print(PersolInfoJson)


'''
import pymysql
import threading

dblink = pymysql.connect(
    host="10.10.10.1",
    user="jianyong",
    password="jianyong",
    database="test",
    charset="utf8")


# 创建一个锁就是通过threading.Lock()来实现
# 当多个线程同时执行lock.acquire()时，只有一个线程能成功地获取锁，然后继续执行代码，其他线程就继续等待直到获得锁为止。
# 获得锁的线程用完后一定要释放锁，否则那些苦苦等待锁的线程将永远等待下去，成为死线程。
# 所以我们用try...finally来确保锁一定会被释放。

# 插入数据
def install(db):
    cursor = db.cursor()
    sql = "insert `test`.`userinfo` (name,email,age,sex,birthday,idnumber,phone) values( %s,%s,%s,%s,%s,%s,%s )"
    lock.acquire()  # 获取锁
    try:
        PerInfo = PersonalInfo()
        data = (PerInfo['name'], PerInfo['emali'], PerInfo['age'], PerInfo['sex'], PerInfo['birthday'],
                PerInfo['idnum'], PerInfo['phone'])
        print(data)
        cursor.execute(sql, data)
        db.commit()
    finally:  # 确保锁一定会被释放。当在try块中抛出一个异常，立即执行finally块代码。
        lock.release()  # 释放锁


lock = threading.RLock()  # 创建锁
threads = []
if __name__ == '__main__':
    # target=执行的函数，args=传给函数的值，range代表打开几个线程执行，变量i传给函数执行的函数的形参
    for i in range(500):
        t = threading.Thread(target=install, args=(dblink,))
        threads.append(t)

    # 打开线程活动
    for thr in threads:
        thr.start()

    # 等待至线程中止
    for thr in threads:
        thr.join()
'''
