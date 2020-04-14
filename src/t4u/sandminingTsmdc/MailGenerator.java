package t4u.sandminingTsmdc;

import java.io.StringWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Properties;

import javax.mail.Address;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import t4u.common.DBConnection;

public class MailGenerator {

	  public static String send(Connection con, ArrayList<String> to, String body, String BCCRCC, boolean attachment, String subject, int systemId) throws SQLException, AddressException, MessagingException {
		    String host = "";
		    String from = "";
		    String pwd = "";
		    String from_address = "";
		    String message = "";
		    String port = "25";
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    String to1 = "";
		    try {
		     
		      pstmt = con.prepareStatement("select SERVICE_PROVIDER,USER_ID,PASSWORD,FROM_ADDRESS,PORT from Mail_Properties where NAME='t4userver' ");
		      rs = pstmt.executeQuery();
		      if (rs.next()) {
		        host = rs.getString("SERVICE_PROVIDER");
		        from = rs.getString("USER_ID");
		        pwd = rs.getString("PASSWORD");
		        from_address = rs.getString("FROM_ADDRESS");
		        port = rs.getString("PORT");
		      }
		    } catch (Exception e) {
		   //   logger.error(e.getMessage(), e);
		    }
		    try {
	    	  final String finalFrom =from;
              final String finalPwd = pwd;
		      Properties props = new Properties();
		      props.put("mail.smtp.host", host);
		      props.put("mail.smtp.port", port);
		      props.put("mail.smtp.debug", "false");
		      props.put("mail.smtp.auth", "true");
		      props.put("mail.smtp.socketFactory.port", host);
		      props.put("mail.smtp.socketFactory.fallback", "false");
		      props.put("mail.smtp.starttls.enable", "false");
		      //SMTPAuthenticator auth = new SMTPAuthenticator(from, pwd);
		     // Session session = Session.getInstance(props, auth);
		      
		      Session session = Session.getDefaultInstance(props,
                      new javax.mail.Authenticator() {
                          protected PasswordAuthentication getPasswordAuthentication() {
                              return new PasswordAuthentication(finalFrom, finalPwd);
                          }
                      });
		      MimeMessage simpleMessage = new MimeMessage(session);
		      simpleMessage.setFrom((Address) new InternetAddress(from_address));
		      InternetAddress[] mainAddress = new InternetAddress[to.size()];
		      int i = 0;
		      while (i < to.size()) {
		        mainAddress[i] = new InternetAddress(to.get(i));
		        ++i;
		      }
		      to1 = to.get(0);
		      simpleMessage.setRecipients(Message.RecipientType.TO, to1);
		      if ("BCC".equalsIgnoreCase(BCCRCC)) {
		        simpleMessage.setRecipients(Message.RecipientType.BCC, (Address[]) mainAddress);
		      } else if ("CC".equalsIgnoreCase(BCCRCC)) {
		        simpleMessage.setRecipients(Message.RecipientType.CC, (Address[]) mainAddress);
		      }
		      simpleMessage.setSubject(subject);
		      simpleMessage.setSentDate(new Date());
		      MimeBodyPart messageBodyPart = new MimeBodyPart();
		      messageBodyPart.setContent( body, "text/html");
		      MimeMultipart multipart = new MimeMultipart();
		      multipart.addBodyPart(messageBodyPart);

		      simpleMessage.setContent(multipart);
		      Transport.send(simpleMessage);
		      message = "Sent";
		      System.out.println(message);
		      logDetails(con,subject,body,to1,systemId);
		    } catch (Exception e) {
		      StringWriter errors = new StringWriter();
		      logFailDetails(con,subject,body,to1,systemId);
		      message = "Invalid Mail Address";
		    } finally {
		      DBConnection.releaseConnectionToDB(null, pstmt, rs);
		    }
		    return message;
		  }
	  
	  public static void logDetails(Connection con,String subject,String emailTemplate,String usermailId,int systemId){
			PreparedStatement pstmt=null,pstmt2=null;
			SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
			ResultSet rs=null;
			long serialNo=0;
			try
			{
				pstmt=con.prepareStatement("select max(Slno) as MaxSerial from AMS.dbo.EmailQueueHistory ");
				
				rs=pstmt.executeQuery();
				if(rs.next())
				{
					serialNo=rs.getLong("MaxSerial");
				}
				serialNo++;
				
				pstmt2=con.prepareStatement("insert into AMS.dbo.EmailQueueHistory(Slno,Subject,Body,EmailList,SentDate,DateTime,SystemId) values(?,?,?,?,?,getdate(),?) ");
				pstmt2.setLong(1, serialNo);
				pstmt2.setString(2, subject);
				pstmt2.setString(3, emailTemplate);
				pstmt2.setString(4, usermailId);
				pstmt2.setString(5, sdf.format(new Date()));
				pstmt2.setInt(6,systemId);
				int x=pstmt2.executeUpdate();
				if(x>0)
				{
					//logger.info("Email Queue History Inserted "+serialNo);
				}
			}
			catch(Exception e)
			{
				e.printStackTrace();
				//logger.info(e.getMessage(), e);
			}
			finally
			{
				try{
					pstmt.close();
					pstmt2.close();
					rs.close();
				}
				catch(Exception e){
					e.printStackTrace();
					//logger.info(e.getMessage(),e);
				}
			}
		  }

		public static void logFailDetails(Connection con,String subject,String emailTemplate,String usermailId,int systemId){
			PreparedStatement pstmt=null,pstmt2=null;
			SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
			ResultSet rs=null;
			long serialNo=0;
			try
			{
				pstmt=con.prepareStatement("select max(Slno) as MaxSerial from AMS.dbo.EmailFailureHistory ");
				
				rs=pstmt.executeQuery();
				if(rs.next())
				{
					serialNo=rs.getLong("MaxSerial");
				}
				serialNo++;
				
				pstmt2=con.prepareStatement("insert into AMS.dbo.EmailFailureHistory(Slno,Subject,Body,EmailList,SentDate,DateTime,SystemId) values(?,?,?,?,?,getdate(),?) ");
				pstmt2.setLong(1, serialNo);
				pstmt2.setString(2, subject);
				pstmt2.setString(3, emailTemplate);
				pstmt2.setString(4, usermailId);
				pstmt2.setString(5, sdf.format(new Date()));
				pstmt2.setInt(6,systemId);
				int x=pstmt2.executeUpdate();
				if(x>0)
				{
					//logger.info("Email Failure History Inserted "+serialNo);
				}
			}
			catch(Exception e)
			{
				e.printStackTrace();
				//logger.info(e.getMessage(), e);
			}
			finally
			{
				try{
					pstmt.close();
					pstmt2.close();
					rs.close();
				}
				catch(Exception e){
					e.printStackTrace();
					//logger.info(e.getMessage(),e);
				}
			}
		  }
	
}
