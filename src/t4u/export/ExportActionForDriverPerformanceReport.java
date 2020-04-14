package t4u.export;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.itextpdf.text.Chunk;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Image;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;


import t4u.beans.LoginInfoBean;

import t4u.beans.ExportForm;
import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.functions.CommonFunctions;

import javax.servlet.ServletOutputStream;

@SuppressWarnings( { "unchecked" })
public class ExportActionForDriverPerformanceReport extends Action {
	CommonFunctions cf = new CommonFunctions();

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		ExportForm exForm = (ExportForm) form;
		LoginInfoBean loginInfoBean = (LoginInfoBean) request.getSession().getAttribute("loginInfoDetails");
		String serviceProvider = "";

		Properties properties = null;
		try {
			properties = ApplicationListener.prop;
		} catch (Exception e) {
			e.printStackTrace();
		}

		if (loginInfoBean != null) {
			if (loginInfoBean.getCategory().equalsIgnoreCase("Enterprise")) {
				String platformName = properties.getProperty("Platform_Name");
				serviceProvider = platformName;
			} else {
				serviceProvider = loginInfoBean.getSystemName();
			}

		}

		String language = loginInfoBean.getLanguage();

		try {

			ArrayList<String> dataTypeList = null;
			ArrayList<Integer> colSpanList = null;
			int leftAlign = 0;

			HttpSession session = request.getSession();

			response.setCharacterEncoding("UTF-8");
			ServletOutputStream servletOutputStream = response.getOutputStream();

			String reportpath = properties.getProperty("ExcelReportPath");
			String reportpathpdf = properties.getProperty("PDFReportPath");

			refreshdir(reportpath);
			refreshdir(reportpathpdf);
			ArrayList headers = null;
			ArrayList footers = null;

			String type = exForm.getReporttype();
			String filename = exForm.getFilename();
			String report = exForm.getReport();
			String filteredRecords = exForm.getFilteredRecords();
			String hiddencolumns = exForm.getHiddencolumns();
			String exportdataType = exForm.getExportDataType();
			String subTotal=exForm.getSubtotal();
			String clientId = String.valueOf(loginInfoBean.getCustomerId());
			String systemid = String.valueOf(loginInfoBean.getSystemId());
			String userId = String.valueOf(loginInfoBean.getUserId());

			String urlxls = reportpath + filename + "_" + systemid + "_" + userId + ".xls";
			String urlpdf = reportpathpdf + filename + "_" + systemid + "_" + userId + ".pdf";
			String serviceReceiver = "";
			if (loginInfoBean.getCustomerName() != null && !loginInfoBean.getCustomerName().equals("")) {
				serviceReceiver = loginInfoBean.getCustomerName();				
			} else {
				serviceReceiver = loginInfoBean.getSystemName();				
			}
			// *******for any file export set here**/
			if(filename.equals("DriverPerformanceReport")){
				//session.getAttribute("custId").toString();
				headers = getHeadersForDriverPerformanceReport(serviceReceiver,language,session.getAttribute("Group").toString(),session.getAttribute("Type").toString(),session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString(),session.getAttribute("Customer").toString());	
			}
			if(filename.equals("StoppageRepotEcom")){
				//session.getAttribute("custId").toString();
				headers = getHeadersForStoppageReport(serviceReceiver,language,session.getAttribute("VehicleNo").toString());	
			}
			
			else if(filename.equals("CT_Dashboard_Details")){
				headers = getHeadersFOrCT_Dashboard_DetailsReport(serviceReceiver);
			}
			// *************************************************************************************************************************//
			ArrayList tempFooters = null;
			tempFooters = getFooter(serviceProvider, language);

			ReportHelper Report = new ReportHelper();
			Report = (ReportHelper) session.getAttribute(report);

			ArrayList headerList = new ArrayList();
			ArrayList tempHeaderList = (ArrayList) Report.getHeadersList();
			ArrayList dataList = (ArrayList) Report.getReportsList();

			ReportHelper reportData = new ReportHelper();
			ArrayList data = new ArrayList();
			ArrayList reportdataList = new ArrayList();
			ArrayList hiddenList = new ArrayList();
			ArrayList hiddenHeaderList = new ArrayList();

			dataTypeList = getDataTypeList(tempHeaderList, exportdataType);
			colSpanList = getColSpanList(tempHeaderList);

			ArrayList<String> delListData = new ArrayList<String>();
			ArrayList<Integer> delListCol = new ArrayList<Integer>();

			delListData.add(null);
			delListCol.add(null);

			if (hiddencolumns != null) {
				
				StringTokenizer st = new StringTokenizer(hiddencolumns, ",");
				String indexStr = "";
				while (st.hasMoreTokens()) {
					indexStr = (String) st.nextToken();
					hiddenList.add(Integer.parseInt(indexStr));
					hiddenHeaderList.add(tempHeaderList.get(Integer.parseInt(indexStr)));

					dataTypeList.set(Integer.parseInt(indexStr), null);
					colSpanList.set(Integer.parseInt(indexStr), null);
				}

			}
			for (int j = 0; j < tempHeaderList.size(); j++) {
				headerList.add(tempHeaderList.get(j));
			}

			headerList.removeAll(hiddenHeaderList);
			dataTypeList.removeAll(delListData);
			colSpanList.removeAll(delListCol);

			dataTypeList.add(0, "int");
			colSpanList.add(0, 1);

			headerList.add(0, cf.getLabelFromDB("SLNO", language));
			reportdataList.add(headerList);

			footers = new ArrayList();
			footers = tempFooters;

			if (filteredRecords != null) { 
				ArrayList filterList = new ArrayList();
				String s = filteredRecords;
				StringTokenizer st = new StringTokenizer(s, ",");

				while (st.hasMoreTokens()) {
					filterList.add(st.nextToken());
					reportdataList.add(new ArrayList());
				}
				int counter = 1;
				for (int i = 0; i < dataList.size(); i++) {
					reportData = (ReportHelper) dataList.get(i);
					data = (ArrayList) reportData.getInformationList();

					ArrayList tempData = new ArrayList();
					for (int j = 0; j < data.size(); j++) {
						tempData.add(data.get(j));
					}

					if (filterList.contains(String.valueOf(data.get(0)))) {

						int index = filterList.indexOf(String.valueOf(data
								.get(0)));
						Collections.sort(hiddenList);
						for (int k = hiddenList.size() - 1; k >= 0; k--) {
							int in = (Integer) hiddenList.get(k);
							tempData.remove(in);

						}
						tempData.add(0, index + 1);
						counter++;
						reportdataList.set(index + 1, tempData);
					}

				}

			} else {

				for (int i = 0; i < dataList.size(); i++) {

					reportData = (ReportHelper) dataList.get(i);
					data = (ArrayList) reportData.getInformationList();
					ArrayList tempData = new ArrayList();
					ArrayList dataHiddenList = new ArrayList();
					for (int j = 0; j < data.size(); j++) {
						tempData.add(data.get(j));
					}
					for (int k = 0; k < hiddenList.size(); k++) {
						dataHiddenList.add(data
								.get((Integer) hiddenList.get(k)));
					}
					tempData.removeAll(dataHiddenList);
					reportdataList.add(tempData);
				}
			}

			if (type.equals("xls")) {

				try {

					ArrayList<String> startTitleList = new ArrayList<String>();
					startTitleList.add(headers.get(0).toString());
					ArrayList<String> endTitleList = getEndTitleList(footers);
					ArrayList<String> summaryFooterList = FooterList(footers);
					String noOfLPerSheet = properties.getProperty("NoOfLinePerSheet");
					int noOfLinePerSheet=0;
					if(properties.getProperty("NoOfLinePerSheet")!=null){
						noOfLinePerSheet=Integer.parseInt(noOfLPerSheet);
					}

					File f = new File(urlxls);

					ArrayList summaryHeaders = headers;
					summaryHeaders.remove(0);
					reportdataList.remove(0);
					noOfLinePerSheet = reportdataList.size();

					ExportExcelCreatorForDriverPerformancereport ee = null;
					ee = new ExportExcelCreatorForDriverPerformancereport(startTitleList, summaryHeaders,
							headerList, colSpanList, dataTypeList,
							reportdataList, summaryFooterList, endTitleList,
							leftAlign, noOfLinePerSheet, f);
					if(filename.equals("StoppageRepotEcom")){
						ee.createExcelForStoppage();
					}
					if(filename.equals("CT_Dashboard_Details")){
						ee.createExcelForCT_Dashboard();
					}
					else{
					ee.createExcel();
					}
				} catch (Exception e) {
					System.out.println("Exception creating excel : " + e);
					e.printStackTrace();
				}
				try {
					response.setContentType("application/xls");
					response.setHeader("Content-disposition",
							"attachment;filename=" + filename + ".xls");
					FileInputStream fis = new FileInputStream(urlxls);
					DataOutputStream outputStream = new DataOutputStream(
							servletOutputStream);
					byte[] buffer = new byte[1024];
					int len = 0;
					while ((len = fis.read(buffer)) >= 0) {
						outputStream.write(buffer, 0, len);
					}
				} catch (Exception e) {
					System.out.println("Exception opening excel : " + e);
				}

				//
			} else if (type.equals("pdf")) {
				try {
					ArrayList<String> startTitleList = new ArrayList<String>();
					startTitleList.add(headers.get(0).toString());
					ArrayList<String> endTitleList = getEndTitleList(footers);
					ArrayList<String> summaryFooterList = FooterList(footers);
					File f = new File(urlpdf);
					ArrayList summaryHeaders = headers;
					summaryHeaders.remove(0);
					reportdataList.remove(0);
					ExportPDFCreatorForDriverPerformanceReport epc = null;
					PdfPTable pt = createimageHeader(summaryHeaders, systemid,
							clientId, request);
					epc = new ExportPDFCreatorForDriverPerformanceReport(startTitleList, summaryHeaders,
							headerList, colSpanList, dataTypeList,
							reportdataList, summaryFooterList, endTitleList,
							leftAlign,f, language, pt);
					epc.createPDF();

				} catch (Exception e) {
					System.out.println("Exception creating pdf : " + e);
					e.printStackTrace();
				}
				try {
					/** opening PDF file **/

					response.setContentType("application/pdf");
					response.setCharacterEncoding("UTF-8");
					response.setHeader("Content-disposition",
							"attachment;filename=" + filename + ".pdf");
					FileInputStream fis = new FileInputStream(urlpdf);
					DataOutputStream outputStream = new DataOutputStream(
							servletOutputStream);
					byte[] buffer = new byte[1024];
					int len = 0;
					while ((len = fis.read(buffer)) >= 0) {
						outputStream.write(buffer, 0, len);
					}
				} catch (Exception e) {
					System.out.println("Exception opening pdf : " + e);
				}

			}

			servletOutputStream.flush();
			servletOutputStream.close();
		} catch (Exception e) {
			System.out.println("Exception in Report Servlet Ordinary : " + e);
			e.printStackTrace();
		}

		return null;
	}

	
	private ArrayList getHeadersForDriverPerformanceReport(String serviceReceiver,
			String language,String group,String type, String startDate,String endDate, String custId) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Driver Performance Report "+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : "+custId);
		headers.add("Type" +" : "+type);
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		headers.add("Group" +" : "+group);
		return headers;
	}
	
	private ArrayList getHeadersForStoppageReport(String serviceReceiver,
			String language,String VehicleNo) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("APMT Stoppage Details "+" - "+serviceReceiver);
		headers.add("VehicleNo" +" : "+VehicleNo);
		return headers;
	}
	
	private ArrayList getHeadersFOrCT_Dashboard_DetailsReport(String serviceReceiver) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Dashbord Details : "+serviceReceiver);
		
		return headers;
	}
	/** 
	 * headers alignment
	 * @return
	 */
	public ArrayList getHeaderAlignment()
	{
		ArrayList headerAlign = new ArrayList();
		headerAlign.add(0);
		return headerAlign;
	}

	/**
	 * Footers alignment
	 * @return
	 */
	public ArrayList getFooterAlignment(){
		ArrayList footerAlign = new ArrayList();
		footerAlign.add(1);
		return footerAlign;
	}

	/**
	 * creating the directory if not present
	 * @param reportpath
	 */
	private void refreshdir(String reportpath)
	{
		File f = new File(reportpath);
		if(!f.exists())
		{
			f.mkdir();
		}
	}

	/**
	 * Default footer defnition
	 * @param serviceProvider
	 * @param language
	 * @return
	 */
	public ArrayList getFooter(String serviceProvider,String language)
	{
		ArrayList<String> tobeConverted=new ArrayList<String>();
		tobeConverted.add("Service_Delivered_By");
		ArrayList<String> convertedWords=new ArrayList<String>();
		convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
		ArrayList footers = new ArrayList();
		footers.add(convertedWords.get(0)+" - "+serviceProvider);
		return footers;
	}

	/**
	 * Generating data type
	 * @param headers
	 * @param exportdataType
	 * @return
	 */
	public ArrayList<String> getDataTypeList(ArrayList headers,String exportdataType)
	{
		ArrayList<String> dataTypeList = new ArrayList<String>();

		String dataType[] = exportdataType.split(",");
		if(dataType.length > 0)
		{
			for(int i = 0; i < dataType.length; i ++)
			{
				dataTypeList.add(dataType[i]);
			}
		}
		else
		{
			for(int i = 0; i < headers.size(); i ++)
			{
				dataTypeList.add("string");
			}
		}

		return dataTypeList;
	}

	/**
	 * Generating column span
	 * @param headers
	 * @return
	 */
	public ArrayList<Integer> getColSpanList(ArrayList headers)
	{
		ArrayList<Integer> colSpanList = new ArrayList<Integer>();

		for(int i = 0; i < headers.size(); i ++)
		{
			colSpanList.add(1);
		}

		return colSpanList;
	}

	/**
	 * Generating excel footer
	 * @param footers
	 * @return
	 */
	public ArrayList FooterList(ArrayList footers)
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

	/**
	 * Adding end title 
	 * @param footers
	 * @return
	 */
	public ArrayList getEndTitleList(ArrayList footers)
	{
		ArrayList<String> endTitleList = new ArrayList<String>();
		if(footers != null && footers.size() > 1)
		{
			String endTitleStr = (String)footers.get(1);
			endTitleList.add(endTitleStr);
		}
		return endTitleList;
	}

	/**
	 * Adjusting the widths for excel cell
	 * @param headerList
	 * @return
	 */
	public float[] getLocationAdjustedCellWidths(ArrayList headerList)
	{
		float total = 100;
		int headerSize = headerList.size();
		float widths[] = new float[headerSize];
		float normalWidth = total / headerSize;

		for(int i = 0; i < headerSize; i ++)
		{
			widths[i] = normalWidth;
		}

		return widths;
	}



	public PdfPTable getPdfTable1(ArrayList headers, String systemid, String
			clientId, HttpServletRequest request) { PdfPTable t = new PdfPTable(1);
			float[] widths = { 100 }; PdfPCell c1;



			try { t.setWidthPercentage(100); t.setWidths(widths);
			t.getDefaultCell().setBorder(0); t.setHorizontalAlignment(1);


			Properties properties = null;
			try 
			{
				properties = ApplicationListener.prop;
			} 
			catch (Exception e) 
			{
				e.printStackTrace();
			}
			String fontpath=properties.getProperty("FontPath");
			String encoding = "Identity-H";
			Font fontNormal = FontFactory.getFont(fontpath+"ARIALUNI.TTF", encoding, BaseFont.EMBEDDED, 8, Font.NORMAL);

			Chunk chunkA = new Chunk("" + "\n",fontNormal);
			Phrase myPhrase=new Phrase(chunkA);

			c1= new PdfPCell(myPhrase); c1.setBorder(0);
			c1.setHorizontalAlignment(1); t.addCell(c1);


			} catch (Exception e) {
				System.out.println("Exception creating pdf header : " + e);
				e.printStackTrace(); } return t; }


	/***************************** Setting client logo and T4U logos for PDF file ************************************/

	private PdfPTable createimageHeader(ArrayList headers, String systemid,
			String clientId, HttpServletRequest request) {

		float[] widths = { 2, 10, 70, 10, 2 };
		PdfPTable t = new PdfPTable(5);
		DBConnection admincon = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {

			t.setWidthPercentage(100);
			t.setWidths(widths);
			Phrase blankphrase = new Phrase(" ");

			PdfPCell blankcell = new PdfPCell(blankphrase);
			blankcell.setBorder(0);
			blankcell.setHorizontalAlignment(0);
			t.addCell(blankcell);

			String imgName = "";
			boolean exists = false;

			Properties properties = null;
			try {
				properties = ApplicationListener.prop;
			} catch (Exception e) {
				e.printStackTrace();
			}

			String imagepath = properties.getProperty("ImagePath");

			if (Integer.parseInt(clientId) != 0) {

				imgName = imagepath + "custlogo_" + systemid + "_" + clientId
				+ ".gif";

				System.out.println("imgName..WHEN SYSTEMID!=0..." + imgName);
				System.out.println("Image path" + imagepath);

				File f = new File(imagepath + "custlogo_" + systemid + "_"
						+ clientId + ".gif");

				if (f.exists()) {
					exists = true;
				}

			}
			if (Integer.parseInt(clientId) == 0 || !exists) {
				imgName = imagepath + "custlogo_" + systemid + ".gif";

				System.out.println("imgName.. WHEN CLIENT ID==0--" + imgName);
			}
			Image img1 = Image.getInstance(imgName);

			PdfPCell cell = new PdfPCell();
			cell.setHorizontalAlignment(0);

			cell.addElement(img1);
			t.addCell(cell);


			PdfPTable pt = getPdfTable1(headers, systemid, clientId,
					request); PdfPCell c = new PdfPCell(pt);
					c.setBorder(Rectangle.NO_BORDER); c.setHorizontalAlignment(1);
					t.addCell(c);

					String path1 = "";
					Image img2 = null;
					String logonew = "";
					// =====================================================================================
					try {

						admincon = new DBConnection();
						con = admincon.getConnectionToDB("AMS");
						pstmt = con
						.prepareStatement(" select Show_t4u_logo from AMS.dbo.System_Master where System_id=? ");
						pstmt.setString(1, systemid);
						rs = pstmt.executeQuery();
						if (rs.next()) {
							logonew = rs.getString("Show_t4u_logo");
						}

					} catch (Exception e) {
						System.out.println("Error in getting showlogo.." + e);
					}

					// =====================================================================================
					if (logonew.equalsIgnoreCase("Yes")) {
						path1 = imagepath + "t4u_White_logo1.gif";

						System.out.println("imgName...NEW LOGO.." + path1);
						img2 = Image.getInstance(path1);
					}
					PdfPCell cell1 = new PdfPCell();
					cell1.setHorizontalAlignment(0);
					// cell1.setBorderColor(Color.white);
					cell1.addElement(img2);
					t.addCell(cell1);

					PdfPCell blankcell1 = new PdfPCell(blankphrase);
					blankcell1.setBorder(0);
					blankcell1.setHorizontalAlignment(0);
					t.addCell(blankcell1);
		} catch (Exception e) {
			System.out.println("Error creating Builty details : " + e);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return t;
	}

}
