package t4u.automotivelogistics;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Properties;
import java.util.StringTokenizer;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.vividsolutions.jts.noding.NodableSegmentString;

import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.functions.AutomotiveLogisticsFunction;
import t4u.functions.CommonFunctions;

@SuppressWarnings("serial")
public class HistoricalTripReportAction extends HttpServlet{

	int systemId=0;
	String clientId="";
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
	String message="";
	@SuppressWarnings("unchecked")
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    HttpSession session = request.getSession();
	    AutomotiveLogisticsFunction alf=new AutomotiveLogisticsFunction();
	    LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		systemId=loginInfo.getSystemId();
		int offset = loginInfo.getOffsetMinutes();
		CommonFunctions cf = new CommonFunctions();
		String language = loginInfo.getLanguage();
		try {
			int leftAlign = 0;
			clientId = request.getParameter("clientId");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String clientName = cf.getCustomerName(clientId, systemId);
            ArrayList<ArrayList> reportdataList = null;
			ServletOutputStream servletOutputStream = response.getOutputStream();
			Properties properties = ApplicationListener.prop;
			String Reportgeneralpath=  properties.getProperty("reportpath");
			String formno="ActionLogReport";
			String urlxls = Reportgeneralpath + formno + "_" + systemId + "_" + clientId + ".xls";
			File f = new File(urlxls);
		    reportdataList=alf.getHistoricalTripReport(clientId,systemId,startDate,endDate,offset);
		    ArrayList<String> startTitleList = new ArrayList<String>();
			startTitleList.add("Action Log Report For - "+clientName);
			int noOfLinePerSheet = reportdataList.size()-1;
			ArrayList footers = new ArrayList();
			footers.add("service provided by "+" - "+"T4U");
			//ArrayList<String> headerList = getHeaderList(language,Integer.parseInt(reportdataList.get(0).get(reportdataList.get(0).size()-1).toString()));
			int maxcount=Integer.parseInt(reportdataList.get(reportdataList.size()-1).get(0).toString());
			reportdataList.remove(reportdataList.size()-1);
			ArrayList<String> headerList = getHeaderList(language,maxcount);
			ArrayList<String> currentDate = getCurrentDate(startDate,endDate);
			ArrayList<Integer> colSpanList = getcolSpanList(headerList.size());
			ArrayList<String> dataTypeList = getdataTypeList(headerList.size());
			ArrayList<String> summaryFooterList =getFooterList(footers);
			GenerateLogisticsExcel excel=new GenerateLogisticsExcel(startTitleList,currentDate,headerList, colSpanList, dataTypeList,reportdataList, summaryFooterList,leftAlign, noOfLinePerSheet, f);
			excel.createExcel();
			printBill(response, servletOutputStream); 
	} catch(Exception e) {
			e.printStackTrace();
		}
		
	}
	
	private void printBill(HttpServletResponse response,
			ServletOutputStream servletOutputStream) {
		try
		{
			/** opening Excel file **/
			response.setContentType("application/vnd.ms-excel");
			response.setHeader("Content-disposition","attachment; filename=ActionLogReport.xls");
			response.setHeader("Cache-Control", "no-cache");
			Properties p=ApplicationListener.prop;
			String historicalTripReport=p.getProperty("historicalTripReport");
			FileInputStream fis = new FileInputStream(historicalTripReport+"ActionLogReport_"+systemId+"_"+clientId+".xls");
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

	ArrayList<String> getCurrentDate(String fromDate,String endDate)
	{
		ArrayList<String> headers = null;
			try {
				headers = new ArrayList<String>();
				String header3 = ddmmyyyy.format(sdf.parse(fromDate)) ; 
				String header5 = ddmmyyyy.format(sdf.parse(endDate)); 
				headers.add(header3);
				headers.add(header5);
			} catch (Exception e) {
				e.printStackTrace();
			}
			return headers;
	}

	private ArrayList<Integer> getcolSpanList(int size) {
		ArrayList<Integer> colSpanList = new ArrayList<Integer>();
		for (int i = 0; i < size; i++)
		{
			colSpanList.add(1);
		}
		return colSpanList;
		
	}

	private ArrayList<String> getdataTypeList(int size) {
		ArrayList<String> dataTypeList = new ArrayList<String>();
		for(int i = 0; i < size ; i++)
		{
			dataTypeList.add("string");
		}
		return dataTypeList;
		
	}

	@SuppressWarnings("unchecked")
private ArrayList<String> getHeaderList(String lang, int maxPoints) {
		ArrayList<String> headerList = null;
		CommonFunctions cf = new CommonFunctions();
		try {
			@SuppressWarnings("unused")
			Date d = new Date();;
			@SuppressWarnings("unused")
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			@SuppressWarnings("unused")
			SimpleDateFormat sdfFormatDate = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
			headerList = new ArrayList<String>();
			headerList=new ArrayList();
			headerList.add(cf.getLabelFromDB("SLNO",lang));
			headerList.add(cf.getLabelFromDB("Shipment_ID",lang));
			headerList.add(cf.getLabelFromDB("Route_Name",lang));
			headerList.add(cf.getLabelFromDB("Asset_Number",lang));
			headerList.add(cf.getLabelFromDB("Asset_Type",lang));
			headerList.add(cf.getLabelFromDB("BA_Name",lang));
			headerList.add(cf.getLabelFromDB("Route_Origin",lang));
			headerList.add(cf.getLabelFromDB("Planned_Arrival_Time",lang));
			headerList.add(cf.getLabelFromDB("Actual_Arrival_Time",lang));
			headerList.add(cf.getLabelFromDB("Notification",lang));
			headerList.add(cf.getLabelFromDB("Planned_Departure_Time",lang));
			headerList.add(cf.getLabelFromDB("Actual_Departure_Time",lang));
			headerList.add(cf.getLabelFromDB("Issue",lang));
			headerList.add(cf.getLabelFromDB("Remarks",lang));
			headerList.add(cf.getLabelFromDB("Action_Status",lang));
			headerList.add("No Of Touch Points");
			
			for(int i=1;i<=maxPoints;i++){
				headerList.add(cf.getLabelFromDB("Check_Point",lang)+" "+i);
				headerList.add(cf.getLabelFromDB("Planned_Arrival_Time",lang));
				headerList.add(cf.getLabelFromDB("Actual_Arrival_Time",lang));
				headerList.add(cf.getLabelFromDB("Notification",lang));
				//headerList.add(cf.getLabelFromDB("Planned_Departure_Time",lang));
				headerList.add(cf.getLabelFromDB("Actual_Departure_Time",lang));
				headerList.add(cf.getLabelFromDB("Issue",lang));
				headerList.add(cf.getLabelFromDB("Remarks",lang));
				headerList.add(cf.getLabelFromDB("Action_Status",lang));
			}
			headerList.add(cf.getLabelFromDB("Route_Destination",lang));
			headerList.add(cf.getLabelFromDB("Planned_Arrival_Time",lang));
			headerList.add(cf.getLabelFromDB("Actual_Arrival_Time",lang));
			headerList.add(cf.getLabelFromDB("Notification",lang));
			//headerList.add(cf.getLabelFromDB("Planned_Departure_Time",lang));
			headerList.add(cf.getLabelFromDB("Actual_Departure_Time",lang));
			headerList.add(cf.getLabelFromDB("Issue",lang));
			headerList.add(cf.getLabelFromDB("Remarks",lang));
			headerList.add(cf.getLabelFromDB("Action_Status",lang));
			/*headerList.add(cf.getLabelFromDB("Gate_In_Time_At_Source",lang));
			headerList.add(cf.getLabelFromDB("Gate_Out_Time_At_Source",lang));
			headerList.add(cf.getLabelFromDB("Schedule_Arrival_Time",lang));
			headerList.add(cf.getLabelFromDB("Actual_Arrival_Time_Destination",lang));
			headerList.add(cf.getLabelFromDB("In_Plant_TAT",lang)+"(HH.MM)");*/
			headerList.add(cf.getLabelFromDB("Halt_Duration",lang)+"(HH.MM)");
			headerList.add(cf.getLabelFromDB("Trip_Start_Date_Time",lang));
			headerList.add(cf.getLabelFromDB("Trip_End_Date_Time",lang));
			headerList.add(cf.getLabelFromDB("Scheduled_TAT",lang)+"(HH.MM)");
			headerList.add(cf.getLabelFromDB("Actual_TAT",lang)+"(HH.MM)");
			headerList.add(cf.getLabelFromDB("Delivery_Status_As_Per_TAT",lang));
			headerList.add(cf.getLabelFromDB("Total_Delay",lang)+"(HH.MM)");
			headerList.add(cf.getLabelFromDB("Comments",lang));
			headerList.add("Planned Distance");
			headerList.add("Actual Distance");
			headerList.add("Auto Close");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return headerList;
	
	}
	@SuppressWarnings("unchecked")
	public ArrayList getFooterList(ArrayList footers)
	{
		ArrayList<String> excelFooterSummary = new ArrayList<String>();
		if(footers != null && footers.size() > 0)
		{
			String footerStr = (String)footers.get(0);
			StringTokenizer st = new StringTokenizer(footerStr,"\n");
			while(st.hasMoreTokens())
			{
				String footer = (String)st.nextToken();
				excelFooterSummary.add(footer);
			}
		}
		return excelFooterSummary;
	}

}
