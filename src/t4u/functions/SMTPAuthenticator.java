package t4u.functions;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 
 * To authenticate the from address and password
 *
 */
public class SMTPAuthenticator extends Authenticator {
  private static final Logger logger = LoggerFactory.getLogger(SMTPAuthenticator.class);
  String fromAddress = null;
  String pwd = null;

  public SMTPAuthenticator(String from, String passd) {
    fromAddress = from;
    pwd = passd;
  }

  public PasswordAuthentication getPasswordAuthentication() {
    String fromAdd = null;
    String passwd = null;
    try {
      fromAdd = fromAddress;
      passwd = pwd;
    }

    catch (Exception e) {
      logger.error(e.getMessage(), e);

    }
    return new PasswordAuthentication(fromAdd, passwd);
  }
}