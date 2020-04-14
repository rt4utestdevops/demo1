package t4u.util;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import t4u.functions.LogWriter;

public class SMSUtil {
	private static final Logger logger = LoggerFactory.getLogger(SMSUtil.class);

	public SMSUtil() {

	}	
	
	public static void sendSMSTest2(String mobilenumber, String message) {
		//Properties property = globalProperties.fetchProperties();
		String smsSender = "611332";//property.getProperty("smsSender");// t4uConsumerApplicationProperties.smssender;
		String authKey = "252572Aag2smhn5c1a15a0";//property.getProperty("smsAuthKey");// t4uConsumerApplicationProperties.smsAuthKey;
		Integer responseCode = 0;
		try {
			String encodedMessage = URLEncoder.encode(message, "UTF-8");
			String url = "http://api.msg91.com/api/sendhttp.php?sender=" + smsSender + "&route=4&mobiles=" + mobilenumber
					+ "&authkey=" + authKey + "&country=0&message=" + encodedMessage;
			//responseCode= Unirest.get(url).asString().getStatus();

		} catch (final Exception e) {
			System.out.println(e.getMessage());
			e.printStackTrace();
			 //logger.error(e.getMessage(), e);
		}
		//return responseCode;
	}
	
	public static void sendSMSTest(String mobilenumber, String message) {
		String postData="";
		String retval = "";

		//give all Parameters In String 
		String User ="611332";
		String passwd = "252572Aag2smhn5c1a15a0";
		String sid = "JOTUN";
		String mtype = "N";
		String DR = "Y";		
		
		try {
			postData += "User=" + URLEncoder.encode(User, "UTF-8") + "&passwd=" + passwd + "&mobilenumber="
					+ mobilenumber + "&message=" + URLEncoder.encode(message, "UTF-8") + "&sid=" + sid + "&mtype="
					+ mtype + "&DR=" + DR;
			URL url = new URL("http://api.msg91.com/api/sendhttp.php?sender=" + User + "&route=4&mobiles=" + mobilenumber
					+ "&authkey=" + passwd + "&country=0&message=" + message);
			HttpURLConnection urlconnection = (HttpURLConnection) url.openConnection();
			urlconnection.setRequestMethod("POST");
			urlconnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			urlconnection.setDoOutput(true);
			OutputStreamWriter out = new OutputStreamWriter(urlconnection.getOutputStream());
			out.write(postData);
			out.close();
			BufferedReader in = new BufferedReader(new InputStreamReader(urlconnection.getInputStream()));
			String decodedString;
			while ((decodedString = in.readLine()) != null) {
				retval += decodedString;
			}
			in.close();
		} catch (Exception e) {
			logger.error("Error while sending SMS to mobile number"+mobilenumber);
		}
		logger.info(""); 
	}
	
	
	public static void sendSMS(String mobilenumber, String message,String smsUrl, String userName, String password,LogWriter logWriter) {
		String postData="";
		String retval = "";

		String mtype = "N";
		String DR = "Y";		
		
		try {
			logWriter.log("sending SMS to Mobile Number ::"+mobilenumber +"Response:"+retval ,LogWriter.INFO);
			postData += "User=" + URLEncoder.encode(userName, "UTF-8") + "&passwd=" + password + "&mobilenumber="
					+ mobilenumber + "&message=" + URLEncoder.encode(message, "UTF-8") + "&sid=" + userName + "&mtype="
					+ mtype + "&DR=" + DR;
			URL url = new URL(smsUrl);
			HttpURLConnection urlconnection = (HttpURLConnection) url.openConnection();
			urlconnection.setRequestMethod("POST");
			urlconnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			urlconnection.setDoOutput(true);
			OutputStreamWriter out = new OutputStreamWriter(urlconnection.getOutputStream());
			out.write(postData);
			out.close();
			BufferedReader in = new BufferedReader(new InputStreamReader(urlconnection.getInputStream()));
			String decodedString;
			while ((decodedString = in.readLine()) != null) {
				retval += decodedString;
			}
			logWriter.log("Sent SMS to Mobile Number ::"+mobilenumber +"Response:"+retval ,LogWriter.INFO); 
			in.close();
		} catch (Exception e) {
			logWriter.log("Error while sending SMS to mobile number"+mobilenumber, LogWriter.ERROR);
		}
		
	}
	
//	public static void main( String[] args) throws Exception{
//		//sendSMS(mobilenumber, "Test t4u");
//	}
}

