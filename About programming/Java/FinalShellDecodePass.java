import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.Random;
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
 
/**
 * FinalShell密码解密工具类
 * 用于解密FinalShell存储的加密密码
 */
public class FinalShellDecodePass {
    
    /**
     * 主方法，用于测试密码解密
     * @param args 命令行参数
     * @throws Exception 可能抛出的异常
     */
    public static void main(String[] args) throws Exception {
        // 测试解密一个加密后的密码
        System.out.println(decodePass("替换为自己的密钥"));
    }
 
    /**
     * DES解密方法
     * @param data 待解密的数据
     * @param head 密钥数据
     * @return 解密后的字节数组
     * @throws Exception 解密过程中可能抛出的异常
     */
    public static byte[] desDecode(byte[] data, byte[] head) throws Exception {
        // 创建安全随机数生成器
        SecureRandom sr = new SecureRandom();
        // 创建DES密钥规范
        DESKeySpec dks = new DESKeySpec(head);
        // 获取DES密钥工厂实例
        SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
        // 生成密钥
        SecretKey securekey = keyFactory.generateSecret(dks);
        // 获取DES加密器实例
        Cipher cipher = Cipher.getInstance("DES");
        // 初始化加密器为解密模式（模式2）
        cipher.init(2, securekey, sr);
        // 执行解密操作
        return cipher.doFinal(data);
    }
 
    /**
     * 解密密码的主要方法
     * @param data Base64编码的加密数据
     * @return 解密后的明文密码
     * @throws Exception 解密过程中可能抛出的异常
     */
    public static String decodePass(String data) throws Exception {
        if (data == null) {
            return null;
        } else {
            String rs = "";
            // 将Base64编码的数据解码为字节数组
            byte[] buf = Base64.getDecoder().decode(data);
            // 提取前8字节作为头部数据
            byte[] head = new byte[8];
            System.arraycopy(buf, 0, head, 0, head.length);
            // 提取剩余部分作为加密数据
            byte[] d = new byte[buf.length - head.length];
            System.arraycopy(buf, head.length, d, 0, d.length);
            // 使用头部数据生成密钥并解密
            byte[] bt = desDecode(d, ranDomKey(head));
            // 将解密后的字节数组转换为字符串
            rs = new String(bt);
            return rs;
        }
    }
 
    /**
     * 根据头部数据生成随机密钥
     * @param head 头部数据（8字节）
     * @return 生成的MD5密钥
     */
    static byte[] ranDomKey(byte[] head) {
        // 使用特定算法生成随机数种子
        long ks = 3680984568597093857L / (long)(new Random((long)head[5])).nextInt(127);
        Random random = new Random(ks);
        int t = head[0];
        // 进行t次随机数生成
        for(int i = 0; i < t; ++i) {
            random.nextLong();
        }
        long n = random.nextLong();
        Random r2 = new Random(n);
        // 构造包含头部数据和随机数的长整型数组
        long[] ld = new long[]{(long)head[4], r2.nextLong(), (long)head[7], (long)head[3], 
                              r2.nextLong(), (long)head[1], random.nextLong(), (long)head[2]};
        
        // 将长整型数组写入字节流
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        DataOutputStream dos = new DataOutputStream(bos);
        long[] var15 = ld;
        int var14 = ld.length;
        for(int var13 = 0; var13 < var14; ++var13) {
            long l = var15[var13];
            try {
                dos.writeLong(l);
            } catch (IOException var18) {
                var18.printStackTrace();
            }
        }
        try {
            dos.close();
        } catch (IOException var17) {
            var17.printStackTrace();
        }
        // 获取字节数组并计算其MD5值作为最终密钥
        byte[] keyData = bos.toByteArray();
        keyData = md5(keyData);
        return keyData;
    }
 
    /**
     * 计算MD5值的方法
     * @param data 输入数据
     * @return MD5哈希值的字节数组
     */
    public static byte[] md5(byte[] data) {
        String ret = null;
        byte[] res = null;
        try {
            // 获取MD5算法实例
            MessageDigest m;
            m = MessageDigest.getInstance("MD5");
            // 更新数据
            m.update(data, 0, data.length);
            // 计算MD5值
            res = m.digest();
            // 将结果转换为16进制字符串（未使用）
            ret = new BigInteger(1, res).toString(16);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return res;
    }
}