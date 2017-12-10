package geneticAlgorithm;
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;

public class SendEmail {

    private static String USER_NAME = "warehouse.ge";  // GMail user name (just the part before "@gmail.com")
    private static String PASSWORD = "supermemesfer69"; // GMail password
    
    private static String[] RECIPIENT;
    
    public static void sendFromGmail(String subject, String body) 
    {
        Properties props = System.getProperties();
        String host = "smtp.gmail.com";
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.user", USER_NAME);
        props.put("mail.smtp.password", PASSWORD);
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");

        Session session = Session.getDefaultInstance(props);
        MimeMessage message = new MimeMessage(session);

        try {
            message.setFrom(new InternetAddress(USER_NAME));
            InternetAddress[] toAddress = new InternetAddress[RECIPIENT.length];

            // To get the array of addresses
            for( int i = 0; i < RECIPIENT.length; i++ ) {
                toAddress[i] = new InternetAddress(RECIPIENT[i]);
            }

            for( int i = 0; i < toAddress.length; i++) {
                message.addRecipient(Message.RecipientType.TO, toAddress[i]);
            }

            message.setSubject(subject);
            message.setText(body);
            Transport transport = session.getTransport("smtp");
            transport.connect(host, USER_NAME, PASSWORD);
            transport.sendMessage(message, message.getAllRecipients());
            transport.close();
        }
        catch (AddressException ae) {
            ae.printStackTrace();
        }
        catch (MessagingException me) {
            me.printStackTrace();
        }
    }
    
    public static void setRecipients(String[] recipients)
    {
        RECIPIENT = recipients;
    }
}
