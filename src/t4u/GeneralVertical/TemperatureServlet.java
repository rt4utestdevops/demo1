package t4u.GeneralVertical;

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;
import org.json.XML;

import t4u.common.ApplicationListener;
import t4u.common.DBConnection;

import com.lowagie.text.Document;

@SuppressWarnings("serial")
public class TemperatureServlet extends HttpServlet {

	private static String GET_TRIP_DETAILS = " select dateadd(mi,$,td.INSERTED_TIME) as INSERTED_TIME,td.ORDER_ID as ORDER_ID,td.TRIP_ID as TRIP_ID,td.ASSET_NUMBER as ASSET_NUMBER,case when td.INSERTED_TIME>d0.PLANNED_ARR_DATETIME then dateadd(mi,$,d0.PLANNED_ARR_DATETIME) else dateadd(mi,$,td.INSERTED_TIME) end as TRIP_START_DATE  "
		+ " from AMS.dbo.TRACK_TRIP_DETAILS td left outer join AMS.dbo.DES_TRIP_DETAILS d0 on d0.TRIP_ID= td.TRIP_ID and d0.SEQUENCE=0 ## ";
	
	
	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy_MM_dd");
	
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		Document document = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String param="";
		try {
			String tripId = request.getParameter("tripId");
			String type = request.getParameter("type");
			String tripComboDownload = request.getParameter("tripComboDownload");
			Properties properties = ApplicationListener.prop;
			String TemperatureReportPath = properties.getProperty("TemperatureReportPath");
			String array1 = "";
			String newtripList = "";
			if(tripComboDownload !=null) {
				 array1 = (tripComboDownload.substring(0, tripComboDownload.length() - 1));
				 newtripList ="'"+array1.toString().replace(",","','")+"'";	
			}
			
			String formno = "";
			String bill = "";
			String orderId= "";
			String date = "";
			
			List<String> files = new ArrayList<String>();
			List<String> fileNames = new ArrayList<String>();
			
			con = DBConnection.getConnectionToDB("AMS");
			if("3".equals(type)) {
				pstmt = con.prepareStatement(GET_TRIP_DETAILS.replace("$", "330").replace("##", " where td.TRIP_ID in ("+newtripList +")"));
			} else  {
				pstmt = con.prepareStatement(GET_TRIP_DETAILS.replace("$", "330").replace("##", " where td.TRIP_ID=? "));
				pstmt.setString(1, tripId);
			}
			rs = pstmt.executeQuery();
			while(rs.next()) {
				orderId=rs.getString("ORDER_ID");
				date = sdfDB.format(rs.getTimestamp("INSERTED_TIME"));
				
				if("1".equals(type)) {
					ServletOutputStream servletOutputStream = response.getOutputStream();
					formno = "Temperature_Report_"+orderId+"_"+date;
					bill = TemperatureReportPath + tripId +"_"+"Temperature_Report" + ".xls";
					printExcel(servletOutputStream, response, bill, formno);
				} else if ("2".equals(type)) {
					ServletOutputStream servletOutputStream = response.getOutputStream();
					formno = "Temperature_Graph_"+orderId+"_"+date;
					bill = TemperatureReportPath + tripId +"_"+"Temperature_Chart.pdf" ;
					printPdf(servletOutputStream, response, bill, formno);
				}else if ("4".equals(type)) {
					String startDate  = rs.getString("TRIP_START_DATE").split(" ")[0];
					String assetno= rs.getString("ASSET_NUMBER");
					String slug=tripId+"_"+assetno+"_"+startDate+"_"+orderId;
					String t4uspringappURL = properties.getProperty("t4uspringappURL");
					String GET_URL = t4uspringappURL+"temperatureReport/"+slug;
					URL obj = new URL(GET_URL);
					HttpURLConnection conn = (HttpURLConnection) obj.openConnection();
					conn.setRequestMethod("GET");
					int responseCode = conn.getResponseCode();
					System.out.println("GET Response Code :: " + responseCode);
					if (responseCode == HttpURLConnection.HTTP_OK) { // success
						BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
						String inputLine;
						StringBuffer res = new StringBuffer();
						while ((inputLine = in.readLine()) != null) {
							res.append(inputLine);
						}
						JSONObject jsonObj = XML.toJSONObject(res.toString());
						in.close();
						response.getWriter().print(jsonObj.getJSONObject("ResponseModel").getString("message"));	
						System.out.println(response.toString());
					} else {
						//logWriter.log("Error conecting to SAP URL::"+file, LogWriter.ERROR);
						System.out.println("GET request not worked");
					}
				} else if ("3".equals(type)) {
					try {
						files.add(TemperatureReportPath + rs.getInt("TRIP_ID") + "_" + "Temperature_Report" + ".xls");
						files.add(TemperatureReportPath + rs.getInt("TRIP_ID") + "_" + "Temperature_Chart" + ".pdf");
						
						fileNames.add("Temperature_Report_"+orderId+"_"+date+".xls");
						fileNames.add("Temperature_Report_"+orderId+"_"+date+".pdf");
						
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
			if ("3".equals(type)) {
				zipFiles(files,response,fileNames);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			if(document!=null) {
				document.close();
			}
		}
	}
	private void printExcel(ServletOutputStream servletOutputStream, HttpServletResponse response, String bill, String PDForm) {
		try {
			String formno = PDForm;
			response.setContentType("application/xls");
			response.setHeader("Content-disposition", "attachment;filename="+ formno + ".xls");
			FileInputStream fis = new FileInputStream(bill);
			DataOutputStream outputStream = new DataOutputStream(servletOutputStream);
			byte[] buffer = new byte[1024];
			int len = 0;
			while ((len = fis.read(buffer)) >= 0) {
				outputStream.write(buffer, 0, len);
			}
			servletOutputStream.flush();
			servletOutputStream.close();
		} catch (Exception e) {
			System.out.println("Error downloading excel file for :: "+PDForm);
		}
	}
	
	private void printPdf(ServletOutputStream servletOutputStream, HttpServletResponse response, String bill, String PDForm) {
		try {
			String formno = PDForm;
			response.setContentType("application/pdf");
			response.setHeader("Content-disposition", "attachment;filename="+ formno + ".pdf");
			FileInputStream fis = new FileInputStream(bill);
			DataOutputStream outputStream = new DataOutputStream(servletOutputStream);
			byte[] buffer = new byte[1024];
			int len = 0;
			while ((len = fis.read(buffer)) >= 0) {
				outputStream.write(buffer, 0, len);
			}
			servletOutputStream.flush();
			servletOutputStream.close();
		} catch (Exception e) {
			System.out.println("Error downloading pdf file for :: "+PDForm);
		}
	}
	
	public void zipFiles(List<String> files,HttpServletResponse response,List<String> fileNames) {

		ZipOutputStream zipOut = null;
		FileInputStream fis = null;
		try {
			DataOutputStream outputStream = new DataOutputStream(response.getOutputStream());
			zipOut = new ZipOutputStream(new BufferedOutputStream(outputStream));
			response.setContentType("application/zip");
			response.setHeader("Content-disposition", "attachment;filename="+ "Temperature_Reports" + ".zip");
			for (int i=0;i<files.size();i++) {
				try {
					File input = new File(files.get(i));
					fis = new FileInputStream(input);
					ZipEntry ze = new ZipEntry(fileNames.get(i));
					zipOut.putNextEntry(ze);
					byte[] tmp = new byte[4 * 1024];
					int size = 0;
					while ((size = fis.read(tmp)) != -1) {
						zipOut.write(tmp, 0, size);
					}
					zipOut.flush();
					fis.close();
				} catch (Exception e) {
					System.out.println("Error creating zip file for :: "+fileNames.get(i));
				}
			}
			zipOut.close();
			outputStream.close();
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println("Error downloading zip file...");
		} finally {
		}
	}
}
