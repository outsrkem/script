import rsa
from binascii import b2a_hex, a2b_hex

# 生成公钥和密钥文件保存到文件
pubkey, privkey = rsa.newkeys(256)
pub = pubkey.save_pkcs1()
pubfile = open('public.pem','wb')
pubfile.write(pub)
pubfile.close()
pri = privkey.save_pkcs1()
prifile = open('private.pem','wb')
prifile.write(pri)
prifile.close()

# 读取公钥和密钥文件，密码长度与证书长度位数有关系。
# 加密的 plaintext 最大长度是 证书key位数/8 - 11, 
# 例如1024 bit的证书，被加密的串最长 1024/8 - 11=117,
# 那么对于 2048bit的证书，被加密的长度最长2048/8 - 11 =245,解决办法是分块加密，然后分块解密就行了，
# 因为 证书key固定的情况下，加密出来的串长度是固定的。
# 也就是说，如果使用2048bit的证书，并且被加密的字符段是小于245个，那么被加密出来的字符长度是344个，
# 以此类推，被加密的字符串可以是688个，1032个等
with open('public.pem') as publickfile:
  p = publickfile.read()
  pubkey = rsa.PublicKey.load_pkcs1(p)
with open('private.pem') as privatefile:
  p = privatefile.read()
  prikey = rsa.PrivateKey.load_pkcs1(p)


# 待加密密码
passwd = 'bjy981700.'
print(passwd.encode())

# 加密
# 因为rsa加密时候得到的字符串不一定是ascii字符集的，输出到终端或者保存时候可能存在问题
# 所以这里统一把加密后的字符串转化为16进制字符串
ciphertext = rsa.encrypt(passwd.encode(), pubkey)
print(b2a_hex(ciphertext))

# 解密
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
        # 因为rsa加密时候得到的字符串不一定是ascii字符集的，输出到终端或者保存时候可能存在问题
        # 所以这里统一把加密后的字符串转化为16进制字符串
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
