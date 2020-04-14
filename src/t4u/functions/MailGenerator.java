package t4u.functions;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import t4u.common.ApplicationListener;


/**
 * 
 * @changed by Guru
 * Support class for sending email using smtp
 * Classes:SMTPAuthenticator
 */
public class MailGenerator {

  private static final Logger logger = LoggerFactory.getLogger(MailGenerator.class);

  public static final String GET_MAIL_PROP_FOR_SYSTEMID = "select SERVICE_PROVIDER,USER_ID,PASSWORD,FROM_ADDRESS,PORT from Mail_Properties where SYSTEM_ID=?";

  public static final String GET_MAIL_PROP_COMMON = "select SERVICE_PROVIDER,USER_ID,PASSWORD,FROM_ADDRESS,PORT from Mail_Properties where NAME='t4userver'";

  public static final String GET_MAIL_PROP_FOR_PASSWORD_RECOVERY = " select SERVICE_PROVIDER,USER_ID,PASSWORD,FROM_ADDRESS,PORT from Mail_Properties where NAME='t4upasswordrecovery' ";

  /**
   * Sends email
   * @param con
   * @param systemid
   * @param to
   * @param subject
   * @param body
   * @param filePath
   * @param rootPath
   * @param dateemail
   * @param attachment
   * @param BCCRCC
   * @return
   * @throws SQLException
   * @throws AddressException
   * @throws MessagingException
   */
  public String send(Connection con, int systemid, ArrayList<String> to, String subject, String body, String filePath, String rootPath,
      String dateemail, boolean attachment, String BCCRCC) throws SQLException, AddressException, MessagingException {

    String host = "";
    String from = "";
    String pwd = "";
    String from_address = "";
    String message = "";
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String port = "25";
    /*
     * a new column 'FROM_ADDRESS' was added to the Mail_Properties table.
     * before the from address was hard coded , now it is being fetched from
     * database. if there is any specific service provider for a particular
     * LTSP then the below query will fetch the required info. else we are
     * fetching the info regarding to NAME = 'Common' which is commonly used
     * for the rest.
     */

    try {

      if (subject != null && (subject.toLowerCase().contains("password") || "Profile Updated Successfully".equalsIgnoreCase(subject.trim())
          || "Password Reset Link".equalsIgnoreCase(subject.trim()) || "Application Login Link".equalsIgnoreCase(subject.trim()))) {
        //System.out.println(" password contains !!!!!!!!!!!!! ");
        pstmt = con.prepareStatement(GET_MAIL_PROP_FOR_PASSWORD_RECOVERY);
        rs = pstmt.executeQuery();
        if (rs.next()) {
          host = rs.getString("SERVICE_PROVIDER");
          from = rs.getString("USER_ID");
          pwd = rs.getString("PASSWORD");
          from_address = rs.getString("FROM_ADDRESS");
          port = rs.getString("PORT");
        }
        BCCRCC = "";
      } else {
        pstmt = con.prepareStatement(GET_MAIL_PROP_FOR_SYSTEMID);
        pstmt.setInt(1, systemid);
        rs = pstmt.executeQuery();

        if (rs.next()) {
          host = rs.getString("SERVICE_PROVIDER");
          from = rs.getString("USER_ID");
          pwd = rs.getString("PASSWORD");
          from_address = rs.getString("FROM_ADDRESS");
          port = rs.getString("PORT");
        } else {

          pstmt = con.prepareStatement(GET_MAIL_PROP_COMMON);
          rs = pstmt.executeQuery();
          if (rs.next()) {
            host = rs.getString("SERVICE_PROVIDER");
            from = rs.getString("USER_ID");
            pwd = rs.getString("PASSWORD");
            from_address = rs.getString("FROM_ADDRESS");
            port = rs.getString("PORT");
          }
        }
      }
    } catch (Exception e) {
      logger.error(e.getMessage(), e);
    } finally {
      if (rs != null) {
        rs.close();
      }
      if (pstmt != null) {
        pstmt.close();
      }
    }

    try {
      Properties props = new Properties();

      String protocol = "smtp";
      String smtpauth = "true";
      String debug = "false";
      String startTls = "";

      if (subject != null && (subject.toLowerCase().contains("password") || "Profile Updated Successfully".equalsIgnoreCase(subject.trim())
          || "Password Reset Link".equalsIgnoreCase(subject.trim()) || "Application Login Link".equalsIgnoreCase(subject.trim()))) {
        startTls = "true";
      } else {
        startTls = "false";
      }
      String fallback = "false";

      props.put("mail.transport.protocol", protocol);
      props.put("mail.smtp.port", port);
      props.put("mail.smtp.socketFactory.port", port);
      props.put("mail.smtp.starttls.enable", startTls);
      props.put("mail.smtp.socketFactory.fallback", fallback);
      props.put("mail.smtp.host", host);
      props.put("mail.smtp.auth", smtpauth);
      props.put("mail.debug", debug);
      if (systemid == 247) {
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory"); //SSL Factory Class
      }
      Authenticator auth = new SMTPAuthenticator(from, pwd);

      Session session = Session.getInstance(props, auth);
      MimeMessage simpleMessage = new MimeMessage(session);

      simpleMessage.setFrom(new InternetAddress(from_address));

      InternetAddress[] mainAddress = new InternetAddress[to.size()];

      for (int i = 0; i < to.size(); i++) {
        mainAddress[i] = new InternetAddress(to.get(i));
      }

      String to1 = to.get(0);

      simpleMessage.setRecipients(Message.RecipientType.TO, to1);
      if ("BCC".equalsIgnoreCase(BCCRCC)) {
        simpleMessage.setRecipients(Message.RecipientType.BCC, mainAddress);
      } else if ("CC".equalsIgnoreCase(BCCRCC)) {
        simpleMessage.setRecipients(Message.RecipientType.CC, mainAddress);
      }
      simpleMessage.setSubject(subject);
      simpleMessage.setSentDate(new java.util.Date());

      MimeBodyPart messageBodyPart = new MimeBodyPart();
      messageBodyPart.setContent(body, "text/html");

      Multipart multipart = new MimeMultipart();
      multipart.addBodyPart(messageBodyPart);

      if (attachment) {

        messageBodyPart = new MimeBodyPart();
        String fileAttachment = filePath;
        DataSource source = new FileDataSource(fileAttachment);
        messageBodyPart.setDataHandler(new DataHandler(source));
        messageBodyPart.setFileName(fileAttachment);
        multipart.addBodyPart(messageBodyPart);

      }

      simpleMessage.setContent(multipart);

      Transport.send(simpleMessage);

      message = "Sent";

      if (attachment) {
        File f = new File(filePath);
        if (f.exists()) {
          f.delete();
        }
        f = new File(rootPath);
        if (f.exists()) {
          f.delete();
        }
      }
    } catch (Exception e) {

      logger.error(e.getMessage(), e);
    }

    return message;

  }
  
  public String send(int systemid, ArrayList<String> to, String subject, String body, String filePath, String rootPath,
	      String dateemail, boolean attachment, String BCCRCC) throws SQLException, AddressException, MessagingException {

	    String host = ApplicationListener.prop.getProperty("SERVICE_PROVIDER");
	    String from = ApplicationListener.prop.getProperty("USER_ID");
	    String pwd = ApplicationListener.prop.getProperty("PASSWORD");
	    String from_address = ApplicationListener.prop.getProperty("FROM_ADDRESS");
	    String message = ApplicationListener.prop.getProperty("SERVICE_PROVIDER");
	    String port = ApplicationListener.prop.getProperty("PORT");;
	    /*
	     * a new column 'FROM_ADDRESS' was added to the Mail_Properties table.
	     * before the from address was hard coded , now it is being fetched from
	     * database. if there is any specific service provider for a particular
	     * LTSP then the below query will fetch the required info. else we are
	     * fetching the info regarding to NAME = 'Common' which is commonly used
	     * for the rest.
	     */
	    try {
	      Properties props = new Properties();

	      String protocol = "smtp";
	      String smtpauth = "true";
	      String debug = "false";
	      String startTls = "";

	      if (subject != null && (subject.toLowerCase().contains("password") || "Profile Updated Successfully".equalsIgnoreCase(subject.trim())
	          || "Password Reset Link".equalsIgnoreCase(subject.trim()) || "Application Login Link".equalsIgnoreCase(subject.trim()))) {
	        startTls = "true";
	      } else {
	        startTls = "false";
	      }
	      String fallback = "false";

	      props.put("mail.transport.protocol", protocol);
	      props.put("mail.smtp.port", port);
	      props.put("mail.smtp.socketFactory.port", port);
	      props.put("mail.smtp.starttls.enable", startTls);
	      props.put("mail.smtp.socketFactory.fallback", fallback);
	      props.put("mail.smtp.host", host);
	      props.put("mail.smtp.auth", smtpauth);
	      props.put("mail.debug", debug);
	      if (systemid == 247) {
	        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory"); //SSL Factory Class
	      }
	      Authenticator auth = new SMTPAuthenticator(from, pwd);

	      Session session = Session.getInstance(props, auth);
	      MimeMessage simpleMessage = new MimeMessage(session);

	      simpleMessage.setFrom(new InternetAddress(from_address));

	      InternetAddress[] mainAddress = new InternetAddress[to.size()];

	      for (int i = 0; i < to.size(); i++) {
	        mainAddress[i] = new InternetAddress(to.get(i));
	      }

	      String to1 = to.get(0);

	      simpleMessage.setRecipients(Message.RecipientType.TO, to1);
	      if ("BCC".equalsIgnoreCase(BCCRCC)) {
	        simpleMessage.setRecipients(Message.RecipientType.BCC, mainAddress);
	      } else if ("CC".equalsIgnoreCase(BCCRCC)) {
	        simpleMessage.setRecipients(Message.RecipientType.CC, mainAddress);
	      }
	      simpleMessage.setSubject(subject);
	      simpleMessage.setSentDate(new java.util.Date());

	      MimeBodyPart messageBodyPart = new MimeBodyPart();
	      messageBodyPart.setContent(body, "text/html");

	      Multipart multipart = new MimeMultipart();
	      multipart.addBodyPart(messageBodyPart);

	      if (attachment) {

	        messageBodyPart = new MimeBodyPart();
	        String fileAttachment = filePath;
	        DataSource source = new FileDataSource(fileAttachment);
	        messageBodyPart.setDataHandler(new DataHandler(source));
	        messageBodyPart.setFileName(fileAttachment);
	        multipart.addBodyPart(messageBodyPart);

	      }

	      simpleMessage.setContent(multipart);

	      Transport.send(simpleMessage);

	      message = "Sent";

	      if (attachment) {
	        File f = new File(filePath);
	        if (f.exists()) {
	          f.delete();
	        }
	        f = new File(rootPath);
	        if (f.exists()) {
	          f.delete();
	        }
	      }
	    } catch (Exception e) {

	      logger.error(e.getMessage(), e);
	    }

	    return message;

	  }
}
