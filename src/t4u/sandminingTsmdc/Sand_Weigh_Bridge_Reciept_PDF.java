package t4u.sandminingTsmdc;

import java.awt.Color;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import t4u.common.ApplicationListener;

import com.lowagie.text.Document;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

public class Sand_Weigh_Bridge_Reciept_PDF extends HttpServlet{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	static BaseFont baseFont = null;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		try{
			String systemid = request.getParameter("systemId");
			String custId = request.getParameter("custId");
			String transitPermit = request.getParameter("transitPermit");
			String vehicleNo = request.getParameter("vehicleNo");
			String tareWeight = request.getParameter("tareWeight");
			String grossWeight = request.getParameter("grossWeight");
			String netWeight = request.getParameter("netWeight");
			String orderId = request.getParameter("orderId");
			String serialNo = request.getParameter("serialNo");
			String weightDate = request.getParameter("weightDate");
			
			String timeStamp = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").format(Calendar.getInstance().getTime());
			
			ServletOutputStream servletOutputStream = response.getOutputStream();
			Properties properties = ApplicationListener.prop;
			String billpath=  properties.getProperty("Builtypath");
			refreshdir(billpath);
			String formno="Sand_Weigh_Bridge_Receipt_"+systemid+"_"+transitPermit;
			String fontPath = properties.getProperty("FontPathForMaplePDF");
			baseFont = BaseFont.createFont(fontPath, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
			String bill = billpath+ formno + ".pdf";
			
			SandTSMDCFunction tsmdcFunc = new SandTSMDCFunction();
			String weightCharges = tsmdcFunc.getWeightCharges(Integer.parseInt(systemid),Integer.parseInt(custId));
	
			generateBill(systemid,bill,request,serialNo,orderId,transitPermit,vehicleNo,tareWeight,grossWeight,netWeight,weightDate,weightCharges);
			printBill(servletOutputStream,response,bill,formno);
		}
		catch (Exception e) 
		{
			System.out.println("Error generating sms bill : " + e);
			e.printStackTrace();
		}
	}
	private void generateBill(String systemId,String bill,HttpServletRequest request,String serialNo,String orderId,String transitPermit, String vehicleNo, String tareWeight, String grossWeight, String netWeight,String weightDate,String weightCharges) {
		try {
			FileOutputStream fileOut = new FileOutputStream(bill);
			Document document = new Document(PageSize.A4, 50, 50, 80, 50);
			PdfWriter writer = PdfWriter.getInstance(document,fileOut);
			
			document.open();
			PdfContentByte canvas = writer.getDirectContent();
	        Rectangle rect = document.getPageSize();
	        
	        rect.setBorder(Rectangle.NO_BORDER); // left, right, top, bottom border
	        rect.setBorderWidth(0); // a width of 5 user units
	        rect.setUseVariableBorders(true); // the full width will be visible
	        canvas.rectangle(rect);
	       
	        Rectangle rect1 = new Rectangle(10, 36, 580, 806);
	        rect1.setBorder(Rectangle.BOX);
	        rect1.setBorderWidth(0);
	        canvas.rectangle(rect1);
	        
	      
	        PdfPTable headerTable2= emptySpace();
		//	document.add(headerTable2);
		//	document.add(headerTable2);
	        
	        PdfPTable headerTable1= createSerialNoVehicleNo(serialNo,vehicleNo);
			document.add(headerTable1);
	        
			document.add(headerTable2);
			
			PdfPTable headerTable3= createGrossWeightDateTime(grossWeight,weightDate);
			document.add(headerTable3);
			
			document.add(headerTable2);
			
			PdfPTable headerTable4= createTareWeight(tareWeight);
			document.add(headerTable4);
			
			document.add(headerTable2);
			
			PdfPTable headerTable5= createNetWeight(netWeight,orderId,transitPermit);
			document.add(headerTable5);
			
			PdfPTable headerTable7= emptySpace2();
			document.add(headerTable7);
			
			
			PdfPTable headerTable6= createWeigmentCharge(weightCharges);
			document.add(headerTable6);
	        
	        document.close();
		} catch (Exception e) {
			System.out.println("Error generating report : " + e);
			e.printStackTrace();
		}
	}
	
	private PdfPTable emptySpace() {

		float[] widths = {60,60,60};
		PdfPTable t = new PdfPTable(3);

		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase1=new Phrase("                                          ",new Font(baseFont, 10, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
		
			myPhrase1=new Phrase("                                 ",new Font(baseFont,10, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			//c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);
			
			
			
			myPhrase1=new Phrase("                ");
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating empty sapace : " + e);
			e.printStackTrace();
		}
		return t;	
		
	}
	
	private PdfPTable emptySpace2() {

		float[] widths = {100};
		PdfPTable t = new PdfPTable(1);

		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase1=new Phrase("   ",new Font(baseFont, 10, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
		
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating empty sapace : " + e);
			e.printStackTrace();
		}
		return t;	
		
	}
	
	private PdfPTable createSerialNoVehicleNo(String serialNo,String vehicleNo) {
		PdfPTable mainTable5=new PdfPTable(5);
		float[] regDatewidths = {10,20,20,20,30};
		try {
			mainTable5.setWidthPercentage(100);
			mainTable5.setWidths(regDatewidths);
			
			Phrase myPhrase1=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c1);
			
			Phrase myPhrase2=new Phrase(serialNo,new Font(baseFont, 10, Font.NORMAL));
			PdfPCell c2 = new PdfPCell(myPhrase2);
			c2.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c2);
			
			Phrase myPhrase3=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			PdfPCell c3 = new PdfPCell(myPhrase3);
			c3.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c3);
			

			Phrase myPhrase4=new Phrase(vehicleNo,new Font(baseFont, 10, Font.NORMAL));
			PdfPCell c4 = new PdfPCell(myPhrase4);
			c4.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c4);
			
			Phrase myPhrase5=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			PdfPCell c5 = new PdfPCell(myPhrase5);
			c5.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c5);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable5;
	}
	
	private PdfPTable createGrossWeightDateTime(String grossWeight,String weightDate) {
		PdfPTable mainTable5=new PdfPTable(6);
		float[] regDatewidths = {10,30,30,10,10,5};
		try {
			mainTable5.setWidthPercentage(100);
			mainTable5.setWidths(regDatewidths);
			
			Phrase myPhrase1=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c1);
			
			Phrase myPhrase2=new Phrase(grossWeight,new Font(baseFont, 10, Font.NORMAL));
			PdfPCell c2 = new PdfPCell(myPhrase2);
			c2.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c2);
			
			Phrase myPhrase3=new Phrase(weightDate,new Font(baseFont, 9, Font.NORMAL));
			PdfPCell c3 = new PdfPCell(myPhrase3);
			c3.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c3);
			

			Phrase myPhrase4=new Phrase("",new Font(baseFont, 10, Font.NORMAL));
			PdfPCell c4 = new PdfPCell(myPhrase4);
			c4.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c4);
			
			Phrase myPhrase5=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			PdfPCell c5 = new PdfPCell(myPhrase5);
			c5.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c5);
			
			Phrase myPhrase6=new Phrase("",new Font(baseFont, 10, Font.NORMAL));
			PdfPCell c6 = new PdfPCell(myPhrase6);
			c6.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c6);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable5;
	}
	
	private PdfPTable createTareWeight(String tareWeight ) {
		PdfPTable mainTable5=new PdfPTable(5);
		float[] regDatewidths = {10,20,20,20,20};
		try {
			mainTable5.setWidthPercentage(100);
			mainTable5.setWidths(regDatewidths);
			
			Phrase myPhrase1=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c1);
			
			Phrase myPhrase2=new Phrase(tareWeight,new Font(baseFont, 10, Font.NORMAL));
			PdfPCell c2 = new PdfPCell(myPhrase2);
			c2.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c2);
			
			Phrase myPhrase3=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			PdfPCell c3 = new PdfPCell(myPhrase3);
			c3.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c3);
			

			Phrase myPhrase4=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			PdfPCell c4 = new PdfPCell(myPhrase4);
			c4.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c4);
			
			Phrase myPhrase5=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			PdfPCell c5 = new PdfPCell(myPhrase5);
			c5.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c5);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable5;
	}
	
	private PdfPTable createNetWeight(String netWeight,String orderId,String transitPermit) {
		PdfPTable mainTable5=new PdfPTable(6);
		float[] regDatewidths = {10,20,15,17,20,10};
		try {
			mainTable5.setWidthPercentage(100);
			mainTable5.setWidths(regDatewidths);
			
			Phrase myPhrase1=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c1);
			
			Phrase myPhrase2=new Phrase(netWeight,new Font(baseFont, 10, Font.NORMAL));
			PdfPCell c2 = new PdfPCell(myPhrase2);
			c2.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c2);
			
			Phrase myPhrase3=new Phrase("",new Font(baseFont, 10, Font.NORMAL));
			PdfPCell c3 = new PdfPCell(myPhrase3);
			c3.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c3);
			

			Phrase myPhrase4=new Phrase("Transit Pass:",new Font(baseFont, 10, Font.NORMAL));
			PdfPCell c4 = new PdfPCell(myPhrase4);
			c4.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c4);
			
			Phrase myPhrase5=new Phrase(transitPermit,new Font(baseFont, 10, Font.NORMAL));
			PdfPCell c5 = new PdfPCell(myPhrase5);
			c5.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c5);
			
			Phrase myPhrase6=new Phrase("",new Font(baseFont, 10, Font.NORMAL));
			PdfPCell c6 = new PdfPCell(myPhrase6);
			c6.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c6);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable5;
	}
	
	private PdfPTable createWeigmentCharge(String weightCharges) {
		PdfPTable mainTable5=new PdfPTable(5);
		float[] regDatewidths = {10,20,25,20,20};
		try {
			mainTable5.setWidthPercentage(100);
			mainTable5.setWidths(regDatewidths);
			
			Phrase myPhrase1=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c1);
			
			Phrase myPhrase2=new Phrase("",new Font(baseFont, 10, Font.NORMAL));
			PdfPCell c2 = new PdfPCell(myPhrase2);
			c2.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c2);
			
			Phrase myPhrase3=new Phrase("",new Font(baseFont, 10, Font.NORMAL));
			PdfPCell c3 = new PdfPCell(myPhrase3);
			c3.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c3);
			

			Phrase myPhrase4=new Phrase(weightCharges+"/-",new Font(baseFont, 10, Font.NORMAL));
			PdfPCell c4 = new PdfPCell(myPhrase4);
			c4.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c4);
			
			Phrase myPhrase5=new Phrase("",new Font(baseFont, 10, Font.NORMAL));
			PdfPCell c5 = new PdfPCell(myPhrase5);
			c5.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(c5);
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable5;
	}
	
	private void printBill(ServletOutputStream servletOutputStream,HttpServletResponse response,String bill,String PDForm) {
		// TODO Auto-generated method stub

		try
		{
			String formno=PDForm;
			response.setContentType("application/pdf");
			response.setHeader("Content-disposition","inline;filename="+formno+".pdf");
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
			System.out.println("Error printing SMS Bills : " + e);
			e.printStackTrace();
		}
	
		
	}
	
	//Refresh Directory
	private void refreshdir(String reportpath)
	{
		try
		{
			File f = new File(reportpath);
			if(!f.exists())
			{
				f.mkdirs();
			}
		}
		catch (Exception e) 
		{
			System.out.println("Error creating folder for Builty Report: " + e);
			e.printStackTrace();
		}
	}
}
