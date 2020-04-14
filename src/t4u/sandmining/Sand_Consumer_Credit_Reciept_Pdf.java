package t4u.sandmining;

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

import com.itextpdf.text.pdf.draw.DottedLineSeparator;
import com.lowagie.text.Document;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

public class Sand_Consumer_Credit_Reciept_Pdf extends HttpServlet{
	static BaseFont baseFont = null;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		try{
			String systemid = request.getParameter("systemId");
			String appNo = request.getParameter("appNo");
			String consumerName = request.getParameter("consumerName");
			String reqQty = request.getParameter("reqQty");
			String amount = request.getParameter("amount");
			String tpNo = request.getParameter("tpNo");
			String tpMobile = request.getParameter("tpMobile");
			
			
			String timeStamp = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").format(Calendar.getInstance().getTime());
			
			ServletOutputStream servletOutputStream = response.getOutputStream();
			Properties properties = ApplicationListener.prop;
			String billpath=  properties.getProperty("Builtypath");
			refreshdir(billpath);
			String formno="Sand_Credit_Reciept_"+systemid+"_"+appNo;
			String fontPath = properties.getProperty("FontPathForMaplePDF");
			baseFont = BaseFont.createFont(fontPath, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
			String bill = billpath+ formno + ".pdf";
	
			generateBill(systemid,bill,request,appNo,consumerName,reqQty,amount,tpNo,tpMobile,timeStamp);
			printBill(servletOutputStream,response,bill,formno);
		}
		catch (Exception e) 
		{
			System.out.println("Error generating sms bill : " + e);
			e.printStackTrace();
		}
	}
	
	

	private void generateBill(String systemId,String bill,HttpServletRequest request,String AppNum, String consumerName, String reqQty, String amount, String tpNo,String tpMobile, String timeStamp) {
		try {
			FileOutputStream fileOut = new FileOutputStream(bill);
			Document document = new Document(PageSize.A4, 50, 50, 80, 50);
			PdfWriter writer = PdfWriter.getInstance(document,fileOut);
			
			document.open();
			PdfContentByte canvas = writer.getDirectContent();
	        Rectangle rect = document.getPageSize();
	        
	        rect.setBorder(Rectangle.BOX); // left, right, top, bottom border
	        rect.setBorderWidth(5); // a width of 5 user units
	        rect.setUseVariableBorders(true); // the full width will be visible
	        canvas.rectangle(rect);
	        
	        Rectangle rect1 = new Rectangle(36, 36, 559, 806);
	        rect1.setBorder(Rectangle.BOX);
	        rect1.setBorderWidth(2);
	        canvas.rectangle(rect1);
	        
			PdfPTable headerTable1= createMainHeader();
			document.add(headerTable1);
			
			PdfPTable officeHeader= createOfficeHeader();
			document.add(officeHeader);

			PdfPTable secHeaderTable=createSubHeader();
			document.add(secHeaderTable);

			PdfPTable vehicleOtherdetailsTable=createRecieptDetails(AppNum,consumerName,reqQty,amount,tpNo,tpMobile,timeStamp);
			document.add(vehicleOtherdetailsTable);
			
//			PdfPTable noteFooter=noteFooter();
//			document.add(noteFooter);
			
			PdfPTable lineSeparator=createLineSeparator();
			document.add(lineSeparator);
			
			PdfPTable headerTable2= createMainHeader();
			document.add(headerTable2);
			
			PdfPTable customerHeader= createCustomerHeader();
			document.add(customerHeader);
			
		    PdfPTable secHeaderTable2=createSubHeader();
			document.add(secHeaderTable2);

			PdfPTable vehicleOtherdetailsTable2=createRecieptDetails(AppNum,consumerName,reqQty,amount,tpNo,tpMobile,timeStamp);
			document.add(vehicleOtherdetailsTable2);
			
//			PdfPTable noteFooter2=noteFooter();
//			document.add(noteFooter2);
			
//			PdfPTable vehicleCarriageAndEpicdetailsTable=createVehicleCarriageAndEpicDetails();
//			document.add(vehicleCarriageAndEpicdetailsTable);
//
//			PdfPTable vehicleChassisAndPandetailsTable=createvehicleChassisAndPanDetails(chassisNo,panNumber);
//			document.add(vehicleChassisAndPandetailsTable);
//			
//			PdfPTable vehicleInsurancedetailsTable=createvehicleInsurancedetails(InsurancePolicyNo,InsuranceExpiryDate);
//			document.add(vehicleInsurancedetailsTable);
			
			document.close();
		} catch (Exception e) {
			System.out.println("Error generating report : " + e);
			e.printStackTrace();
		}
	}
	
	private PdfPTable createCustomerHeader() {
		PdfPTable mainTable5=new PdfPTable(1);
		try {
			mainTable5.setWidthPercentage(100.0f);
			
			Phrase myPhrases=new Phrase("Customer Copy",new Font(baseFont, 10, Font.BOLD));
			PdfPCell cells0 = new PdfPCell(myPhrases);
			cells0.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			cells0.disableBorderSide(Rectangle.TOP);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(cells0);
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable5;
	}



	private PdfPTable createOfficeHeader() {
		PdfPTable mainTable5=new PdfPTable(1);
		try {
			mainTable5.setWidthPercentage(100.0f);
			
			Phrase myPhrases=new Phrase("Office Copy",new Font(baseFont, 10, Font.BOLD));
			PdfPCell cells0 = new PdfPCell(myPhrases);
			cells0.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			cells0.disableBorderSide(Rectangle.TOP);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable5.addCell(cells0);
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable5;
	}



	private PdfPTable createLineSeparator() {
		PdfPTable mainTable5=new PdfPTable(1);
		try {
			mainTable5.setWidthPercentage(100.0f);
			
			Phrase myPhrases=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			PdfPCell cells0 = new PdfPCell(myPhrases);
			cells0.disableBorderSide(Rectangle.TOP);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setBorder(Rectangle.BOTTOM);
			mainTable5.addCell(cells0);
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable5;
	}



	private PdfPTable noteFooter() {
		PdfPTable mainTable4=new PdfPTable(1);
		try {
			mainTable4.setWidthPercentage(100.0f);
			mainTable4.getDefaultCell().setBorderWidthBottom(1f);
			Phrase myPhrases=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			PdfPCell cells0 = new PdfPCell(myPhrases);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable4.addCell(cells0);
			
			myPhrases=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			cells0 = new PdfPCell(myPhrases);
			cells0.disableBorderSide(Rectangle.TOP);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable4.addCell(cells0);
			
			myPhrases=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			cells0 = new PdfPCell(myPhrases);
			cells0.disableBorderSide(Rectangle.TOP);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable4.addCell(cells0);

			myPhrases=new Phrase("Note: Your Application for SAND will be approved based on Document verification.",new Font(baseFont, 8, Font.BOLD));
			cells0 = new PdfPCell(myPhrases);
			cells0.setHorizontalAlignment(Rectangle.ALIGN_JUSTIFIED);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setColspan(2);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable4.addCell(cells0);

			myPhrases=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			cells0 = new PdfPCell(myPhrases);
			cells0.disableBorderSide(Rectangle.TOP);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable4.addCell(cells0);
			
			myPhrases=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			cells0 = new PdfPCell(myPhrases);
			cells0.disableBorderSide(Rectangle.TOP);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable4.addCell(cells0);
			
			myPhrases=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			cells0 = new PdfPCell(myPhrases);
			cells0.disableBorderSide(Rectangle.TOP);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable4.addCell(cells0);
			
			myPhrases=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			cells0 = new PdfPCell(myPhrases);
			cells0.disableBorderSide(Rectangle.TOP);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable4.addCell(cells0);
			
			myPhrases=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			cells0 = new PdfPCell(myPhrases);
			cells0.disableBorderSide(Rectangle.TOP);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable4.addCell(cells0);
		

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable4;
	}



	private PdfPTable createMainHeader() {	
		PdfPTable t3=new PdfPTable(2);
		try {
			t3.setWidthPercentage(100.0f);
			t3.getDefaultCell().setBorderWidthBottom(1f);
			Phrase mya=new Phrase(" ",new Font(baseFont, 5, Font.BOLD));
			PdfPCell cella = new PdfPCell(mya);
			cella.disableBorderSide(Rectangle.LEFT);
			cella.setBorder(Rectangle.NO_BORDER);
			t3.addCell(cella);

			Phrase myb=new Phrase(" ",new Font(baseFont, 5, Font.BOLD));
			PdfPCell cellb = new PdfPCell(myb);
			cellb.disableBorderSide(Rectangle.RIGHT);
			cellb.setBorder(Rectangle.NO_BORDER);
			t3.addCell(cellb);

			Phrase myc=new Phrase("SAND MONITORING COMMITTEE",new Font(baseFont, 15, Font.BOLD));
			PdfPCell cellc = new PdfPCell(myc);
			cellc.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			cellc.setColspan(2);
			cellc.disableBorderSide(Rectangle.TOP);
			cellc.disableBorderSide(Rectangle.LEFT);
			cellc.setBorder(Rectangle.NO_BORDER);
			t3.addCell(cellc);

			Phrase myd=new Phrase(" ",new Font(baseFont, 5, Font.BOLD));
			PdfPCell celld = new PdfPCell(myd);
			celld.disableBorderSide(Rectangle.TOP);
			celld.disableBorderSide(Rectangle.RIGHT);
			celld.setBorder(Rectangle.NO_BORDER);
			t3.addCell(celld);

			Phrase sam04=new Phrase(" ",new Font(baseFont, 5, Font.BOLD));
			PdfPCell sam004 = new PdfPCell(sam04);
			sam004.disableBorderSide(Rectangle.TOP);
			sam004.disableBorderSide(Rectangle.LEFT);
			sam004.setBorder(Rectangle.NO_BORDER);
			t3.addCell(sam004);

			Phrase sam05=new Phrase(" ",new Font(baseFont, 5, Font.BOLD));
			PdfPCell sam005 = new PdfPCell(sam05);
			sam005.disableBorderSide(Rectangle.TOP);
			sam005.disableBorderSide(Rectangle.RIGHT);
			sam005.setBorder(Rectangle.NO_BORDER);
			t3.addCell(sam005);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return t3;
	}

	private PdfPTable createSubHeader() {
		PdfPTable mainTable3=new PdfPTable(3);
		try {
			mainTable3.setWidthPercentage(100.0f);
			mainTable3.getDefaultCell().setBorderWidthBottom(1f);
			Phrase myPhrases=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			PdfPCell cells0 = new PdfPCell(myPhrases);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable3.addCell(cells0);

			myPhrases=new Phrase("RECIEPT FOR SAND CREDIT",new Font(baseFont, 11, Font.BOLD));
			myPhrases.getFont().setStyle(Font.UNDERLINE);
			cells0 = new PdfPCell(myPhrases);
			cells0.setHorizontalAlignment(Rectangle.ALIGN_JUSTIFIED);
			cells0.disableBorderSide(Rectangle.RIGHT);
			cells0.setColspan(2);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable3.addCell(cells0);

			myPhrases=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			cells0 = new PdfPCell(myPhrases);
			cells0.disableBorderSide(Rectangle.TOP);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable3.addCell(cells0);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable3;
	}
	
	private PdfPTable createRecieptDetails(String AppNum, String consumerName, String reqQty, String amount, String tpNo,String tpMobile, String timeStamp) {
		PdfPTable mainTable2=new PdfPTable(2);
		float[] regDatewidths = {40,60};
		try {
			mainTable2.setWidthPercentage(100.0f);
			//mainTable2.getDefaultCell().setBorderWidthBottom(1f);
			mainTable2.setWidths(regDatewidths);

			Phrase vehicleOtherPhras=new Phrase(" ",new Font(baseFont, 9, Font.NORMAL));
			PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER); 
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(" ",new Font(baseFont, 9, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);
			
			vehicleOtherPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			 vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);
			
			 vehicleOtherPhras=new Phrase("Application No: ",new Font(baseFont, 10, Font.BOLD));
			 vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(AppNum,new Font(baseFont, 9, Font.BOLD));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);
			
			vehicleOtherPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			 vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			
			vehicleOtherPhras=new Phrase("Application Date: ",new Font(baseFont, 10, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(timeStamp,new Font(baseFont, 9, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);
			
			vehicleOtherPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			 vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);
			
			vehicleOtherPhras=new Phrase("Consumer Name: ",new Font(baseFont, 10, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);
			
			vehicleOtherPhras=new Phrase(consumerName,new Font(baseFont, 9, Font.NORMAL));
			 vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);
			
			vehicleOtherPhras=new Phrase("Approved Sand Quantity: ",new Font(baseFont, 10, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);
			
			vehicleOtherPhras=new Phrase(reqQty,new Font(baseFont, 9, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);
			
			vehicleOtherPhras=new Phrase("Amount Paid: ",new Font(baseFont, 10, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(amount,new Font(baseFont, 9, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);
			
			vehicleOtherPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			 vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);
			
			vehicleOtherPhras=new Phrase("Tp Owner Name: ",new Font(baseFont, 10, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(tpNo,new Font(baseFont, 9, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);
			
			vehicleOtherPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			 vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);
			
			vehicleOtherPhras=new Phrase("Tp Owner Mobile No: ",new Font(baseFont, 10, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(tpMobile,new Font(baseFont, 9, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);
			
			vehicleOtherPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			 vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);
			
			vehicleOtherPhras=new Phrase("Payment Receiver’s Signature: ",new Font(baseFont, 10, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase("________________________________________________",new Font(baseFont, 9, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);
			
			vehicleOtherPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			 vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable2;
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
