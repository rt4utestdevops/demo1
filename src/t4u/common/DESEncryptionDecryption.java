package t4u.common;

import javax.crypto.Cipher;
import javax.crypto.spec.DESedeKeySpec;
import javax.crypto.spec.SecretKeySpec;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.security.Key;
import java.util.Properties;

/**
 * Class is uded to Eccrypt and Decrypt the user password
 * 
 * @author ashutoshk
 * 
 */
public class DESEncryptionDecryption {
	private static String algorithm = "DESede";
	private static Key key = null;
	private static Cipher cipher = null;

	public DESEncryptionDecryption() {

		Properties properties = null;
		try {
			properties = ApplicationListener.prop;
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {

			String ketStr = properties.getProperty("DESKey");
			// String ketStr = "com.sun.crypto.provider.DESedeKey@b069ba38";
			// key = KeyGenerator.getInstance(algorithm).generateKey();
			key = new SecretKeySpec(new DESedeKeySpec(ketStr.getBytes()).getKey(), algorithm);
			cipher = Cipher.getInstance(algorithm);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// function for encrypting the password
	public String encrypt(String input) {
		String encryptedText = "";
		try {
			cipher.init(Cipher.ENCRYPT_MODE, key);
			byte[] encryptedBytes = input.getBytes();
			encryptedText = new sun.misc.BASE64Encoder().encode(cipher.doFinal(encryptedBytes));
			encryptedText = URLEncoder.encode(encryptedText, "UTF-8");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return encryptedText;
	}

	// function for decrypting the password data
	public String decrypt(String encryptedText) {
		String decryptedText = "";
		try {
			encryptedText = URLDecoder.decode(encryptedText, "UTF-8");
			cipher.init(Cipher.DECRYPT_MODE, key);
			byte[] decryptedBytes = new sun.misc.BASE64Decoder().decodeBuffer(encryptedText);
			decryptedText = new String(cipher.doFinal(decryptedBytes));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return decryptedText;
	}
}
