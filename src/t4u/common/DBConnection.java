package t4u.common;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Properties;
import javax.servlet.ServletContextEvent;

import org.apache.commons.lang.SystemUtils;

import com.mongodb.MongoClient;

public class DBConnection {
	
	/**
	 * To get connection to database
	 * @param dbname
	 * @return
	 */
	public static Connection getConnectionToDB(String dbname) {
		Connection connection = null;
		try {
			Properties properties = null;
			properties = ApplicationListener.prop;
			String path = properties.getProperty("class.path");
			String urlAMS = properties.getProperty(dbname);
			String user = properties.getProperty("uname");
			String pass = properties.getProperty("pwd");
			Class.forName(path);

			connection = DriverManager.getConnection(urlAMS, user, pass);
			
			connection.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);
		
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Error in getting connection func "+e); 
		}
		return connection;
	}
	
	public static MongoClient getMongoConnection() throws FileNotFoundException, IOException
	{
		  Properties dbProperties = null;
		  dbProperties=ApplicationListener.prop;
		  String url=dbProperties.getProperty("MongoURL");
		  String uname=dbProperties.getProperty("mongouname");
		  String passwrd=dbProperties.getProperty("mongopwd");
		 
		  final MongoClient mongo=new MongoClient(url,27017);
		    mongo.getDB("LOCATION").authenticate(uname, passwrd.toCharArray());
		  
			return mongo;
		  
	}
	
	/**
	 * To release connection to database
	 * @param con
	 * @param pstmt
	 * @param rs
	 */
	public static void releaseConnectionToDB(Connection con,PreparedStatement pstmt,ResultSet rs){
		try {
			
			if(con!=null){
				con.close();
			}
			if(pstmt!=null){
				pstmt.close();
			}
			if(rs!=null){
				rs.close();
			}
			
		} catch (Exception e) {
			System.out.println("Error in release connection func "+e); 
		}
	}
	/**
	 * This will load the application properties when tomcat is turned on
	 * @param sce
	 * @return
	 * @throws FileNotFoundException
	 * @throws IOException
	 * @return application properties
	 */
	public static Properties getProperties(ServletContextEvent sce) throws FileNotFoundException,IOException 
    {  
		 Properties appProperties;
    	 FileInputStream fs=null;
    	 if(SystemUtils.IS_OS_LINUX || SystemUtils.IS_OS_UNIX){
    		 fs=new FileInputStream("/opt/cluster/platform/application.properties");
    	 }else{
    		 fs=new FileInputStream("C:\\cluster\\shareddir\\application.properties");
    	 } 
    	 appProperties = new Properties();
    	 appProperties.load(fs); 
   	 if (appProperties == null) 
   	 {
   		 throw new IOException ("Properties not loaded");
     }
		 return appProperties;
    }
	
	
	public static Connection getDashboardConnection(String dbname) {
		Connection connection = null;
		try {
			Properties properties = null;
			properties = ApplicationListener.prop;
			String path = properties.getProperty("class.path");
			String urlAMS = properties.getProperty(dbname);
			String user = properties.getProperty("uname");
			String pass = properties.getProperty("pwd");
			Class.forName(path);
			connection = DriverManager.getConnection(urlAMS, user, pass);	
			
			connection.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Error in getting connection func "+e); 
		}
		return connection;
	}
	
	/*public static com.mysql.jdbc.Connection getConnectionMysql(){
		com.mysql.jdbc.Connection mysqlCon = null;
		try{
			Properties dbProperties = null;
			dbProperties=ApplicationListener.prop;
			String url = dbProperties.getProperty("mysqlserver");
			String user = dbProperties.getProperty("Mysqluname");
			String pass = dbProperties.getProperty("Mysqlpwd");
			String classPath=dbProperties.getProperty("mySqlClassPath");
			Class.forName(classPath);
			mysqlCon = (com.mysql.jdbc.Connection) DriverManager.getConnection(url,user,pass);
			
			Properties properties = null;
			properties = MyContextListeners.prop;
			String path = properties.getProperty("class.Mysqlpath");
			String urlAMS = properties.getProperty(dbname);
			String user = properties.getProperty("Mysqluname");
			String pass = properties.getProperty("Mysqlpwd");
			Class.forName(path);
			connection = DriverManager.getConnection(urlAMS, user, pass);

			

		}
		catch(Exception e){
			e.printStackTrace();
			System.out.println("Mysql Connection Exception..");
		} 
		return mysqlCon;
	}
	
	public static void releaseConnectionToMysqlDB(com.mysql.jdbc.Connection con,PreparedStatement pstmt,ResultSet rs){
		try {
			
			if(con!=null){
				con.close();
			}
			if(pstmt!=null){
				pstmt.close();
			}
			if(rs!=null){
				rs.close();
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			 
		}
	} */
	public  static Connection getConnectionMysToMysqlDB(String dbname) {
		Connection connection = null;
		try {
			
			Properties properties = null;
			properties = ApplicationListener.prop;
			String path = properties.getProperty("class.Mysqlpath");
			String urlAMS = properties.getProperty(dbname);
			String user = properties.getProperty("Mysqluname");
			String pass = properties.getProperty("Mysqlpwd");
			Class.forName(path);
			connection = DriverManager.getConnection(urlAMS, user, pass);
			
			connection.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);
		
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Error in getting connection func "+e); 
		}
		return connection;
	}
	
	public  static Connection getConnectionMysToMysqlDBJSMDC(String dbname) {
		Connection connection = null;
		try {
			
			Properties properties = null;
			properties = ApplicationListener.prop;
			String path = properties.getProperty("class.JSMDCMysqlpath");
			String urlAMS = properties.getProperty(dbname);
			String user = properties.getProperty("JSMDCMysqluname");
			String pass = properties.getProperty("JSMDCMysqlpwd");
			Class.forName(path);
			connection = DriverManager.getConnection(urlAMS, user, pass);
			connection.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Error in getting connection func "+e); 
		}
		return connection;
	}

	public static void releaseConnectionToMysqlDB(Connection con,PreparedStatement pstmt,ResultSet rs){
		try {
			
			if(con!=null){
				con.close();
			}
			if(pstmt!=null){
				pstmt.close();
			}
			if(rs!=null){
				rs.close();
			}
			
		} catch (Exception e) {
			System.out.println("Error in release connection func "+e); 
		}
	}
}
