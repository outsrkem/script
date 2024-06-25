# -*- coding=utf-8 -*-
from smtplib import SMTP_SSL
from email.mime.text import MIMEText
from email.header import Header


class SendMail:
    def __init__(self, server, port, user, pwd) -> None:
        self.MAIL_SMTP_SERVER = server
        self.MAIL_SMTP_PORT = port
        self.MAIL_SMTP_USER = user
        self.MAIL_SMTP_PWD = pwd

    def send_email(self, receiver: list, subject: str, content: str) -> bool:
        """发送邮件
        :param list receiver: 接收邮件的邮箱
        :param str subject: 邮件主题
        :param str content: 邮件正文
        :return: bool
        """
        MAIL_SMTP_USER = self.MAIL_SMTP_USER
        MAIL_SMTP_SERVER = self.MAIL_SMTP_SERVER
        MAIL_SMTP_PORT = self.MAIL_SMTP_PORT
        MAIL_SMTP_PWD = self.MAIL_SMTP_PWD
        sender = f'{MAIL_SMTP_USER}'  # 发送地址
        from_addr = f'UIAS <{MAIL_SMTP_USER}>'  # 发件人

        """三个参数：第一个为文本内容，第二个 plain 设置文本格式，第三个 utf-8 设置编码"""
        message = MIMEText(content, 'html', 'utf-8')
        message['Subject'] = Header(subject, 'utf-8')
        message['From'] = from_addr  # 发送者
        message['To'] = Header(",".join(receiver))  # 收件人
        message['Cc'] = Header("")  # 抄送人
        try:
            smtp_obj = SMTP_SSL(MAIL_SMTP_SERVER, MAIL_SMTP_PORT)
            smtp_obj.login(user=MAIL_SMTP_USER, password=MAIL_SMTP_PWD)
            smtp_obj.sendmail(sender, receiver, message.as_string())
            smtp_obj.quit()
            print(message)
            print(Header(",".join(receiver)))
            print("be sent successfully.")
        except Exception as e:
            print("fail to send. ↓↓↓↓↓")
            print("[%s] [%s] [%s]" %
                  (MAIL_SMTP_SERVER, MAIL_SMTP_USER, MAIL_SMTP_PWD))


email = SendMail(server="smtp.126.com", port="465",
                 user="xxx@126.com", pwd="OxxxxV")

content = """
<div>
    <h1>Hello</h1>
</div>
"""

email.send_email(["xxx@qq.com", "xxx@qq.com"], "测试", content)
