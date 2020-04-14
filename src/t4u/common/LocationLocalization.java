package t4u.common;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.ResourceBundle;

public class LocationLocalization {

	public static HashMap<String, String> locationLocalization = new HashMap<String, String>();
	public static ResourceBundle obj = null;

	public void setLocationLocalization() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;			
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement("select LOCATION, ARABIC_LOCATION from LOCATION_LOCALIZATION where ARABIC_LOCATION is not null");
			rs = pstmt.executeQuery();
			while (rs.next()) {
				locationLocalization.put(rs.getString("LOCATION"), rs.getString("ARABIC_LOCATION"));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			try {
				if (rs!=null){
					rs.close();			
				}	
				if(pstmt != null){
					pstmt.close();
				}					
				if(con != null){
					con.close();
				}				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	public static String getAppendLocationLocalization(String locationName, String language) {
		String translatedLocationName = "";
		try {
			if (language != null && language.equalsIgnoreCase("AR")) {
				String splitLocationName = splitLocationName(locationName);
				String location[] = splitLocationName.split("#");
				if (location.length > 1) {
					splitLocationName = location[1];
				}
				translatedLocationName = locationLocalization.get(splitLocationName);
				if(translatedLocationName == null){
					translatedLocationName = locationName;
				} else if (location.length > 1) {
					translatedLocationName = location[0] + " " + translatedLocationName;
				}
			} else {
				translatedLocationName = locationName;
			}
			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return translatedLocationName;
	}
	
	public static String getLocationLocalization(String locationName, String language) {
		String translatedLocationName = "";
		try {
			if (language != null && language.equalsIgnoreCase("AR")) {
				translatedLocationName = locationLocalization.get(locationName);
				if(translatedLocationName == null){
					translatedLocationName = locationName;
				}
			} else {
				translatedLocationName = locationName;
			}			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return translatedLocationName;
	}
	
	public static String splitLocationName(String s) {
		String n = s;
		if (n != null) {
			try {
				if (s.indexOf("On ") < 2 && s.indexOf("On ") > -1) {
					String s1[] = s.split("On ");
					n = getApplicationResourcesValuesForArabic("On");
					n = n + " #" + s1[1];
				} else if (s.indexOf("At ") < 2 && s.indexOf("At ") > -1) {
					String s1[] = s.split("At ");
					n = getApplicationResourcesValuesForArabic("At");
					n = n + " #" + s1[1];
				} else if (s.indexOf("Near to ") > -1 && s.indexOf("Near to ") < 2) {
					String s1[] = s.split("Near to ");
					n = getApplicationResourcesValuesForArabic("Near_To");
					n = n + " #" + s1[1];
				} else if (s.contains("kms from ")) {
					String s1[] = s.split("kms from ");
					n = getApplicationResourcesValuesForArabic("Kms_From");
					s1[0] = getApplicationResourcesValuesForArabic(s1[0].trim());
					n = s1[0] + " " + n + " #" + s1[1];
				} else if (s.contains("Inside ")) {
					String s1[] = s.split("Inside ");
					n = getApplicationResourcesValuesForArabic("Inside");
					n = n + " #" + s1[1];
				}
			} catch (Exception e) {
				n = s;
			}
		}
		return n;
	}
	
	public static String getApplicationResourcesValuesForArabic(String words) {
		String Query = null;
		if (obj == null) {
			obj = ResourceBundle.getBundle("ApplicationResources_AR");
		}
		if (obj != null && obj.containsKey(words)) {
			Query = obj.getString(words);
		} else {
			Query = words;
		}
		return Query;
	}
	
	public static String getApplicationResourcesValuesForArabicNew(String words) {
		String Query = null;
		String word=words.replaceAll(" ", "_");
		if (obj == null) {
			obj = ResourceBundle.getBundle("ApplicationResources_AR");
		}
		if (obj != null && obj.containsKey(word)) {
			Query = obj.getString(word);
		} else {
			Query = words;
		}
		return Query;
	}
}
