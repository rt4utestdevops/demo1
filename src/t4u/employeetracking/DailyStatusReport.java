package t4u.employeetracking;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.functions.CommonFunctions;
import t4u.functions.EmployeetrackingFunctions;

@SuppressWarnings("serial")
public class DailyStatusReport extends HttpServlet {
	@SuppressWarnings("unchecked")
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    HttpSession session = request.getSession();
	    EmployeetrackingFunctions etf=new EmployeetrackingFunctions();
	    LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId=loginInfo.getSystemId();
		int offset = loginInfo.getOffsetMinutes();
		CommonFunctions cf = null;
		try {
			cf = new CommonFunctions();
			String clientId = request.getParameter("clientId");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			System.out.println("startDate:"+startDate);
			System.out.println("endDate:"+endDate);
			String clientName = cf.getCustomerName(clientId, systemId);
            ArrayList<ArrayList> finalDataList = null;
			ServletOutputStream servletOutputStream = response.getOutputStream();
			Properties properties = ApplicationListener.prop;
			String Reportgeneralpath=  properties.getProperty("reportpath");
			String formno="StatusReport";
			String bookingRepo = Reportgeneralpath+ formno + ".xls";
			File fileforExcel;
			fileforExcel=new File(bookingRepo);
		    fileforExcel.createNewFile();
		    HashMap dataMap = new HashMap();
		    finalDataList=etf.getStatusDetails(clientId,systemId,startDate,endDate,offset);
		    ArrayList sheetName = new ArrayList();
		    sheetName.add("StatusReport");
		    if (finalDataList.size()>0) {
				dataMap.put("StatusReport", getFormatedData(finalDataList.get(0), String.valueOf(systemId), clientId, "", clientName, finalDataList.get(1)));
				GenerateExcel excel=new GenerateExcel(dataMap,sheetName,0,fileforExcel);
				excel.createExcel(response);
				printBill(response, servletOutputStream);
		    }
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	@SuppressWarnings("unchecked")
	public static ArrayList<Object> getFormatedData(ArrayList<Object> maindata,String systemId,String clientId,String systemName,String clientName, ArrayList dateList)
	{
		ArrayList<Object> data = new ArrayList<Object>();
		ArrayList<Object> mylist = new ArrayList<Object>();
		
		ArrayList<String> note = new ArrayList<String>();
		note.add("");

		int noOfLinePerSheet=maindata.size();
		
		ArrayList<String> startTitleList = new ArrayList<String>();
		startTitleList.add("Status Report For - "+clientName);
		
		ArrayList<String> endTitleList = new ArrayList<String>();
		endTitleList.add(""+systemName);
		
		data.add(startTitleList);
		data.add(getCurrentDate("",""));
		data.add(getHeaderListFirst(dateList));
		data.add(getHeaderList(dateList));
		data.add(getcolunList(dateList));
		data.add(getdataTypeList(dateList));
		data.add(maindata);
		data.add(note);
		data.add(endTitleList);
		data.add(noOfLinePerSheet);
		mylist.add(data);
		return mylist;
	}
	
	public static ArrayList<String> getCurrentDate(String fromDate,String endDate)
	{
		ArrayList<String> headers = null;
			try {
				headers = new ArrayList<String>();
				String header3 = "" +fromDate ; 
				String header5 = ""  +endDate; 
				headers.add(header3);
				headers.add(header5);
			} catch (Exception e) {
				e.printStackTrace();
			}
			return headers;
	}

	@SuppressWarnings("unchecked")
	public static ArrayList<String> getHeaderList(ArrayList arrayList)
	{
		ArrayList<String> headerList = null;
		try {
			Date d = new Date();;
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat sdfFormatDate = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
			headerList = new ArrayList<String>();
			headerList=new ArrayList();
			headerList.add("Vehicle No");
			headerList.add("Vehicle ID");
			headerList.add("Transporter");
			headerList.add("IMEI No");
			headerList.add("Device Type");
			headerList.add("ETMS Kit Type");
			for (int i=0; i<arrayList.size(); i++) {
				d = sdf.parse((String) arrayList.get(i));
				headerList.add(sdfFormatDate.format(d));
				headerList.add(sdfFormatDate.format(d));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return headerList;
	}
	
	@SuppressWarnings("unchecked")
	public static ArrayList<String> getHeaderListFirst(ArrayList arrayList)
	{
		ArrayList<String> headerList = new ArrayList<String>();
		headerList=new ArrayList();
		headerList.add("");
		headerList.add("");
		headerList.add("");
		headerList.add("");
		headerList.add("");
		headerList.add("");
		for (int i=0; i<arrayList.size(); i++) {
			headerList.add("System Status");
			headerList.add("Task List");
		}
		return headerList;
	}
	/**
	 * column span for excel.
	 * @param dateList 
	 * @param driverOrVehicle
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static ArrayList<Integer> getcolunList(ArrayList dateList)
	{
		ArrayList<Integer> colSpanList = new ArrayList<Integer>();
		for (int i = 0; i < dateList.size()+dateList.size()+6; i ++)
		{
			colSpanList.add(1);
		}
		return colSpanList;
	}
	/**
	 * This is for specifying data type of each column 
	 * @param dateList 
	 * @param driverOrVehicle
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static ArrayList<String> getdataTypeList(ArrayList dateList)
	{
		ArrayList<String> dataTypeList = new ArrayList<String>();
		for(int i = 0; i < dateList.size()+dateList.size()+6; i ++)
		{
			dataTypeList.add("string");
		}
		return dataTypeList;
	}
	
	private void printBill(HttpServletResponse response, ServletOutputStream servletOutputStream)
	{
		try
		{
			/** opening Excel file **/
			response.setContentType("application/vnd.ms-excel");
			response.setHeader("Content-disposition","attachment; filename=StatusReport.xls");
			response.setHeader("Cache-Control", "no-cache");
			Properties p=ApplicationListener.prop;
			String reportPath=p.getProperty("historicalTripReport");
			FileInputStream fis = new FileInputStream(reportPath+"StatusReport.xls");
			DataOutputStream outputStream = new	DataOutputStream(servletOutputStream);
			byte [] buffer = new byte [1024];
			int len = 0;
			while ( (len = fis.read(buffer)) >= 0 ) 
			{
				outputStream.write(buffer, 0, len);
			}
			servletOutputStream.flush();
			servletOutputStream.close();
		}
		catch (Exception e) 
		{
			System.out.println("Error in printing Builty details  : " + e);
			e.printStackTrace();
		}
	}
}
