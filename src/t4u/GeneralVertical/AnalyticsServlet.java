package t4u.GeneralVertical;

import java.io.DataOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import t4u.common.ApplicationListener;
import t4u.common.DBConnection;

import com.lowagie.text.Document;

@SuppressWarnings("serial")
public class AnalyticsServlet extends HttpServlet {

	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy_MM_dd");
	
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		Document document = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			Properties properties = ApplicationListener.prop;
			String DelayAnalysisReport = properties.getProperty("analyticspath"); //DelayAnalysisReport
			ServletOutputStream servletOutputStream = response.getOutputStream();
			String type = request.getParameter("type");
			String bill = "";
			bill = DelayAnalysisReport +type + ".xlsx";
			printExcel(servletOutputStream, response, bill, type);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			if(document!=null) {
				document.close();
			}
		}
	}
	private void printExcel(ServletOutputStream servletOutputStream, HttpServletResponse response, String bill, String formName) {
		try {
			response.setContentType("application/xls");
			response.setHeader("Content-disposition", "attachment;filename=" + formName + ".xlsx");
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
			e.printStackTrace();
			System.out.println("Error downloading excel file for :: ");
		}
	}
	
}
