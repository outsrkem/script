import rsa
from binascii import b2a_hex, a2b_hex

# ���ɹ�Կ����Կ�ļ����浽�ļ�
pubkey, privkey = rsa.newkeys(256)
pub = pubkey.save_pkcs1()
pubfile = open('public.pem','wb')
pubfile.write(pub)
pubfile.close()
pri = privkey.save_pkcs1()
prifile = open('private.pem','wb')
prifile.write(pri)
prifile.close()

# ��ȡ��Կ����Կ�ļ������볤����֤�鳤��λ���й�ϵ��
# ���ܵ� plaintext ��󳤶��� ֤��keyλ��/8 - 11, 
# ����1024 bit��֤�飬�����ܵĴ�� 1024/8 - 11=117,
# ��ô���� 2048bit��֤�飬�����ܵĳ����2048/8 - 11 =245,����취�Ƿֿ���ܣ�Ȼ��ֿ���ܾ����ˣ�
# ��Ϊ ֤��key�̶�������£����ܳ����Ĵ������ǹ̶��ġ�
# Ҳ����˵�����ʹ��2048bit��֤�飬���ұ����ܵ��ַ�����С��245������ô�����ܳ������ַ�������344����
# �Դ����ƣ������ܵ��ַ���������688����1032����
with open('public.pem') as publickfile:
  p = publickfile.read()
  pubkey = rsa.PublicKey.load_pkcs1(p)
with open('private.pem') as privatefile:
  p = privatefile.read()
  prikey = rsa.PrivateKey.load_pkcs1(p)


# ����������
passwd = '123456'
print(passwd.encode())

# ����
# ��Ϊrsa����ʱ��õ����ַ�����һ����ascii�ַ����ģ�������ն˻��߱���ʱ����ܴ�������
# ��������ͳһ�Ѽ��ܺ���ַ���ת��Ϊ16�����ַ���
ciphertext = rsa.encrypt(passwd.encode(), pubkey)
print(b2a_hex(ciphertext))

# ����
text = b2a_hex(ciphertext)
# text = "592c328ead4255c64d5e4c6ce2e5cf53944972ec79e0c0748a260f39936aa00b"
decrypt_text = rsa.decrypt(a2b_hex(text), prikey)
print(decrypt_text)


###########################################################
import rsa
from binascii import b2a_hex, a2b_hex



class rsacrypt():
    def __init__(self, pubkey, prikey):
        self.pubkey = pubkey
        self.prikey = prikey

    def encrypt(self, text):
        self.ciphertext = rsa.encrypt(text.encode(), self.pubkey)
        # ��Ϊrsa����ʱ��õ����ַ�����һ����ascii�ַ����ģ�������ն˻��߱���ʱ����ܴ�������
        # ��������ͳһ�Ѽ��ܺ���ַ���ת��Ϊ16�����ַ���
        return b2a_hex(self.ciphertext)

    def decrypt(self, text):
        decrypt_text = rsa.decrypt(a2b_hex(text), prikey)
        return decrypt_text


if __name__ == '__main__':
    pubkey, prikey = rsa.newkeys(256)
    print(pubkey)
    print(prikey)

    rs_obj = rsacrypt(pubkey,prikey)
    text='asdsadsasd'
    ency_text = rs_obj.encrypt(text)
    print(ency_text)
    print(rs_obj.decrypt(ency_text))

"""
b'7cb319c67853067abcd16aad25b3a8658e521f83b1e6a6cf0c4c2e9303ad3e14'
b'hello'
"""
