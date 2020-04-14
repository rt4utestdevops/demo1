package t4u.common;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Properties;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.PropertyConfigurator;

import t4u.beans.LanguageWordsBean;
import t4u.functions.CommonFunctions;

/**
 * 
 * Initialization 
 * This class will be called by the servlet container.. In our case, it's Tomcat.
 */

public class ApplicationListener implements ServletContextListener {
	public static Properties prop = null;

	public static HashMap<String, LanguageWordsBean> langConverted;

	public void contextInitialized(ServletContextEvent sce) {
		System.out.println("The application context is being initialized...");
		try {
			prop = DBConnection.getProperties(sce);
		} catch (IOException e) {
			System.out.println("Error in loading properties... Context isn't initialized properly :: " + e.toString());
			e.printStackTrace();
		}
		try {
			CommonFunctions cf = new CommonFunctions();
			LocationLocalization locationLocalization = new LocationLocalization();
			langConverted = cf.LanguageConverter();
			locationLocalization.setLocationLocalization();
			/*String homeDir = sce.getServletContext().getRealPath("/");
			File propertiesFile = new File(homeDir, "WEB-INF/log4j.properties");
			PropertyConfigurator.configure(propertiesFile.toString()); */
			System.out.println("property file loaded....");
			
		} catch (Exception e) {
			System.out.println("Error in loading Language Converted Words :: " + e.toString());
			e.printStackTrace();
		}
	}

	public void contextDestroyed(ServletContextEvent sce) {
		System.out.println("The application context is destroyed...");
	}
}
