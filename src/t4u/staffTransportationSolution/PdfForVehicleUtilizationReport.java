package t4u.staffTransportationSolution;

import java.awt.Color;
import java.io.DataOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Properties;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.functions.StaffTransportationSolutionFunctions;

public class PdfForVehicleUtilizationReport extends HttpServlet{
	
	private static final long serialVersionUID = 1L;
	static BaseFont baseFont = null;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

		try {
			HttpSession session = request.getSession();
			
						
			LoginInfoBean loginInfo = (LoginInfoBean)session.getAttribute("loginInfoDetails");
			String custId = request.getParameter("custId");
			String vehGroupId = request.getParameter("vehGroupId");
			String vehGroupName = request.getParameter("vehGroupName");
			String endDate = request.getParameter("endDate");
			String startDate = request.getParameter("startDate");
			String systemId = request.getParameter("systemId");
			String shiftId = request.getParameter("ShiftId");
			String shiftName = request.getParameter("ShiftName");			
			String reportTypeId = request.getParameter("ReportTypeId");
			int userId = loginInfo.getUserId();
			int offset = loginInfo.getOffsetMinutes();
			String language = loginInfo.getLanguage();
			String userName = loginInfo.getUserName();
			
			
			ServletOutputStream servletOutputStream = response.getOutputStream();
			Properties properties = ApplicationListener.prop;
			String imagepath = properties.getProperty("ImagePath");
			String imgName = imagepath + "custlogo_" + systemId  + "_"+ custId + ".gif";
			String billpath=  properties.getProperty("Builtypath");//path where file will get save
			String pdfFileName = "VehicleUtilizationReport";//name of the pdf file
			String fontPath = properties.getProperty("FontPathForMaplePDF");
			baseFont = BaseFont.createFont(fontPath, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
			String bill = billpath + pdfFileName + ".pdf";
			FileOutputStream fileOut = new FileOutputStream(bill);
			Document document = new Document(PageSize.A4, 50, 50, 50, 50);
			PdfWriter writer = PdfWriter.getInstance(document,fileOut);
			document.open();
			PdfContentByte pdfContentByte = writer.getDirectContent();
			
			JSONArray jsonArray = null;
			StaffTransportationSolutionFunctions stsFunc = new StaffTransportationSolutionFunctions();
			if( Integer.parseInt(reportTypeId) == 1 ){
			jsonArray = stsFunc.getVehicleUtilizationReportForShiftWise(Integer.parseInt(systemId), custId, vehGroupId, offset, startDate, endDate, language, userId,Integer.parseInt(shiftId));	
			}else{
			jsonArray = stsFunc.getVehicleUtilizationReport(Integer.parseInt(systemId), custId, vehGroupId, offset, startDate, endDate, language, userId);
			}
			generateReport(document, jsonArray, pdfContentByte, startDate, endDate, vehGroupName, userName, systemId, imgName,shiftName,Integer.parseInt(reportTypeId),Integer.parseInt(custId),Integer.parseInt(vehGroupId),offset);
			
			document.close();
			printBill(servletOutputStream, response, bill, pdfFileName);
		} catch (NumberFormatException e) {
			e.printStackTrace();
		} catch (DocumentException e) {
			e.printStackTrace();
		}

	}

	public void generateReport(Document document, JSONArray jsonArray, PdfContentByte contentByte, String startDate, String endDate, String vehGroupName, String userName, String systemId, String imagepath,String shiftName,int reportType,int custId,int groupId,int offset) {
		
		String startDatetoShow = startDate;
		String endDateToShow = endDate;
		try {
			if(shiftName.equalsIgnoreCase("ALL")){
				startDate = startDate.substring(0,startDate.lastIndexOf(" "));
			    endDate = endDate.substring(0,endDate.lastIndexOf(" "));
			    DateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			    DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
				try {
					startDate = sdf.format(df.parse(startDate));
					endDate  = sdf.format(df.parse(endDate));
				} catch (ParseException e) {					
					e.printStackTrace();
				}
			StaffTransportationSolutionFunctions stsFunc = new StaffTransportationSolutionFunctions();
			String[] timeString  = stsFunc.getStartAndEndTimeForAll(startDate,endDate,Integer.parseInt(systemId),custId,groupId,offset);
			if(timeString !=null){
				startDatetoShow = timeString[0];
				endDateToShow = timeString[1];
			}
			}
			PdfPTable header = createHeader(startDatetoShow, endDateToShow, vehGroupName, userName, systemId, imagepath,shiftName,reportType);
			document.add(header);
			
			float[] widths = {20,30,50};
			PdfPTable mainTable=new PdfPTable(3);
			
			try {
				mainTable.setWidthPercentage(100.0f);
				mainTable.setWidths(widths);
				
				PdfPCell cella = new PdfPCell(new Paragraph("Vehicle No"));
				cella.setBackgroundColor(Color.ORANGE);
				cella.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				mainTable.addCell(cella);

				cella = new PdfPCell(new Paragraph("Trip Duration (hh:mm:ss)"));
				cella.setBackgroundColor(Color.ORANGE);
				cella.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				mainTable.addCell(cella);

				cella = new PdfPCell(new Paragraph("Graphic"));
				cella.setBackgroundColor(Color.ORANGE);
				cella.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				mainTable.addCell(cella);
				
				
				for(int i = 0; i < jsonArray.length(); i++){
					JSONObject obj = (JSONObject) jsonArray.get(i);
					
					cella = new PdfPCell(new Phrase(obj.getString("vehicleNoDataIndex"), new Font(baseFont, 8,Font.NORMAL)));
					cella.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					cella.setPadding(5f);
					mainTable.addCell(cella);

					String tripDur = obj.getString("TotalTripDurationDataIndex");
					tripDur = tripDur.replace("days ", ":");
					tripDur = tripDur.replace("hrs ", ":");
					tripDur = tripDur.replace("mins ", "");
					
					cella = new PdfPCell(new Phrase(tripDur, new Font(baseFont, 8,Font.NORMAL)));
					cella.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					cella.setPadding(5f);
					mainTable.addCell(cella);

					float d1 = Float.parseFloat(obj.getString("GraphDataIndex"));
					float d2 = 100-d1;
					
					float[] widths1 = {d1,d2};
					PdfPTable mainTable1 = new PdfPTable(widths1.length);
					
					mainTable1.setWidthPercentage(100);
					mainTable1.setWidths(widths1);
					
					cella = new PdfPCell();
					cella.setBorder(Rectangle.NO_BORDER);
					cella.setBackgroundColor(Color.LIGHT_GRAY);
					cella.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
					mainTable1.addCell(cella);
					
					cella = new PdfPCell();
					cella.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					cella.setBorder(Rectangle.NO_BORDER);
					mainTable1.addCell(cella);
					
					cella = new PdfPCell(mainTable1);
					cella.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					cella.setPadding(5f);
					mainTable.addCell(cella);
					
//System.out.println( obj.getString("TotalTripDurationDataIndex")+"\t"+ obj.getString("vehicleNoDataIndex") +"\t"+  obj.getString("vehicleNoDataIndex"));
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
			  
			
			
			document.add(mainTable);
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		
	}
	private PdfPTable createHeader(String startDate, String endDate, String vehGroupName, String userName, String systemId, String imagepath,String shiftName,int reportType) {
		float[] widths = {10,30,30};
		PdfPTable t = new PdfPTable(3);
		try {
			t.setWidthPercentage(100);
			t.setWidths(widths);
			t.setSpacingAfter(10f);
			try {
				Image img1 = Image.getInstance(imagepath);
				PdfPCell c = new PdfPCell();
				c.setBorderColor(Color.white);
				c.addElement(img1);
				c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				t.addCell(c);
			} catch (Exception e) {
				System.out.println(e.toString());
				PdfPCell c = new PdfPCell();
				c.setBorderColor(Color.white);
				t.addCell(c);
			}
			
			PdfPCell c = new PdfPCell(new Phrase("Vehicle Utilization (Simplified)", new Font(baseFont, 10,Font.BOLD)));
			c.setBorderColor(Color.white);
			c.setColspan(2);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);
			
			//date and vehicle group
			
			c = new PdfPCell(new Phrase("    ", new Font(baseFont, 10,Font.BOLD)));
			c.setBorderColor(Color.white);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setColspan(2);
			t.addCell(c);
			
			c = new PdfPCell(new Phrase("     ", new Font(baseFont, 10,Font.BOLD)));
			c.setBorderColor(Color.white);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			t.addCell(c);
			
			c = new PdfPCell(new Phrase("Vehicle Group : "+vehGroupName, new Font(baseFont, 10,Font.BOLD)));
			c.setBorderColor(Color.white);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setColspan(2);
			t.addCell(c);
			
			if(reportType == 1 ){
			c = new PdfPCell(new Phrase("Shift Name : "+shiftName, new Font(baseFont, 10,Font.BOLD)));
			c.setBorderColor(Color.white);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			t.addCell(c);
			}
			else{
				c = new PdfPCell(new Phrase("   ", new Font(baseFont, 10,Font.BOLD)));
				c.setBorderColor(Color.white);
				c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				t.addCell(c);	
			}
			c = new PdfPCell(new Phrase("Start Date : "+startDate, new Font(baseFont, 10,Font.BOLD)));
			c.setBorderColor(Color.white);
			c.setColspan(2);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			t.addCell(c);
			
			c = new PdfPCell(new Phrase("End Date : "+endDate, new Font(baseFont, 10,Font.BOLD)));
			c.setBorderColor(Color.white);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			t.addCell(c);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return t;
	}

	private void printBill(ServletOutputStream servletOutputStream,HttpServletResponse resp, String bill, String pdfFileName) {
		try
		{
			resp.setContentType("application/pdf");
			resp.setHeader("Content-disposition","attachment;filename="+pdfFileName+".pdf");
			FileInputStream fis = new FileInputStream(bill);
			DataOutputStream outputStream = new	DataOutputStream(servletOutputStream);
			byte [] buffer = new byte [1024];
			int len = 0;
			while ((len = fis.read(buffer)) >= 0 ) 
			{
				outputStream.write(buffer, 0, len);
			}

			servletOutputStream.flush();
			servletOutputStream.close();
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
	}
	

}
