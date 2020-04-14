package t4u.functions;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.statements.DocumentManagementStatements;

public class DocumentManagementFunctions {
	public int insertFileDetails(String destinationPath, String fileName,
			String category, String value,int clientIdInt, int systemId, int userId, String dateTime, String fileExtension) {
		Connection conAms = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int id = 0;
		
		try {
			conAms = DBConnection.getConnectionToDB("AMS");
			pstmt = conAms.prepareStatement(DocumentManagementStatements.INSERT_FILE_UPLOAD_DETAILS,Statement.RETURN_GENERATED_KEYS);
			pstmt.setString(1,fileName);
			pstmt.setString(2,category);
			pstmt.setString(3,value);
			pstmt.setInt(4, clientIdInt);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, userId);
			pstmt.setString(7, dateTime);
			pstmt.setString(8, fileExtension);
			pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();
			if (rs.next()) {
				id = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		return id;
	}
	
	public JSONArray getDocuments(HttpServletRequest request, int clientId, String value, int systemId) {
		JSONObject jsonObject = new JSONObject();
		JSONArray jsonArray = new JSONArray();
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		int id = 0;
		String fileName = null;
		String destinationPath = new File(System.getProperty("catalina.base"))+ "/webapps/ApplicationImages/TempImageFile/";
		String localUrl = null;
		String dateTime = null;
		try {
			Properties properties = ApplicationListener.prop;
			String path = properties.getProperty("DocumentUploadPath").trim();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			
			String fileExtension = null;
			conAdmin = DBConnection.getConnectionToDB("AMS");
			pstmt = conAdmin.prepareStatement(DocumentManagementStatements.GET_UPLOADED_FILE);
			pstmt.setString(1, value);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			rs = pstmt.executeQuery();
			Calendar cal = null;
			int day = 0;
			int month = 0;
			int year = 0;
			while(rs.next()){
				try {
					id = rs.getInt("ID");
					fileName = rs.getString("FILE_NAME");
					fileExtension = rs.getString("FILE_EXTENTION");
					dateTime = rs.getString("INSERTED_TIME");
					if (dateTime!=null) {
						Date d = sdf.parse(dateTime);
						cal = Calendar.getInstance();
						cal.setTime(d);
						day = cal.get(Calendar.DAY_OF_MONTH);
						month = cal.get(Calendar.MONTH);
						year = cal.get(Calendar.YEAR);
						month+=1;
						File trgDir = new File(destinationPath+"/"+id+fileExtension);
						File srcDir = new File(path+"/"+id+fileExtension);
					//	File srcDir = new File(path+"\\"+year+"\\"+month+"\\"+day+"\\"+id+fileExtension);
						FileUtils.copyFile(srcDir, trgDir);
						
						localUrl = "/ApplicationImages/TempImageFile/"+id+fileExtension;
						
						jsonObject = new JSONObject();
						jsonObject.put("id", id);
						jsonObject.put("name", fileName);
						jsonObject.put("url", localUrl);
						jsonObject.put("size", id);
						jsonObject.put("lastmod","");
						jsonArray.put(jsonObject);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}

	public int getClientId(String regNo, int systemId) {
		Connection conAms = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int clientId = 0;
		try {
			conAms = DBConnection.getConnectionToDB("AMS");
			pstmt = conAms.prepareStatement(DocumentManagementStatements.GET_CLIENT_ID);
			pstmt.setString(1,regNo);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				clientId = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		return clientId;
	}
}
