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
import t4u.functions.SandMiningPermitFunctions;

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

public class Sand_Consumer_Reciept_PDF extends HttpServlet{
	static BaseFont baseFont = null;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		try{
			String systemid = request.getParameter("systemId");
			String appNo = request.getParameter("appNo");
			String consumerName = request.getParameter("consumerName");
			String reqQty = request.getParameter("reqQty");
			String fromStock = request.getParameter("fromStock");
			String consumerType = request.getParameter("consumerType");
			String mobileNo = request.getParameter("mobileNo");
			String workLocation = request.getParameter("workLocation");
			String approvedQty = request.getParameter("approvedQty");
			String idProofType = request.getParameter("idProofType");
			String idProofNo = request.getParameter("idProof");
			
			String timeStamp = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").format(Calendar.getInstance().getTime());
			
			ServletOutputStream servletOutputStream = response.getOutputStream();
			Properties properties = ApplicationListener.prop;
			String billpath=  properties.getProperty("Builtypath");
			refreshdir(billpath);
			String formno="Sand_Enrollment_Receipt_"+systemid+"_"+appNo;
			String fontPath = properties.getProperty("FontPathForMaplePDF");
			baseFont = BaseFont.createFont(fontPath, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
			String bill = billpath+ formno + ".pdf";
			
			SandMiningPermitFunctions smpf = new SandMiningPermitFunctions();
			String PdfNote = smpf.CONSUMER_ENROLMENT_PDF_NOTE(Integer.parseInt(systemid));
	
			generateBill(systemid,bill,request,appNo,consumerName,reqQty,fromStock,consumerType,timeStamp,mobileNo,workLocation,approvedQty,idProofType,idProofNo,PdfNote);
			printBill(servletOutputStream,response,bill,formno);
		}
		catch (Exception e) 
		{
			System.out.println("Error generating sms bill : " + e);
			e.printStackTrace();
		}
	}
	
	

	private void generateBill(String systemId,String bill,HttpServletRequest request,String AppNum, String consumerName, String reqQty, String fromStock, String consumerType, String timeStamp,String mobileNo,String workLocation,String approvedQty,String idProofType,String idProofNo,String PdfNote) {
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
	        
	        PdfPTable officeHeader= createOfficeHeader();
			document.add(officeHeader);
	        
			PdfPTable headerTable1= createMainHeader();
			document.add(headerTable1);
			
			PdfPTable secHeaderTable=createSubHeader();
			document.add(secHeaderTable);

			PdfPTable vehicleOtherdetailsTable=createRecieptDetails(AppNum,consumerName,reqQty,fromStock,consumerType,timeStamp,mobileNo,workLocation,approvedQty,idProofType,idProofNo);
			document.add(vehicleOtherdetailsTable);
			
			PdfPTable signature = signature();
			document.add(signature);
			
			PdfPTable noteFooter=noteFooter(PdfNote);
			document.add(noteFooter);
			
			PdfPTable lineSeparator=createLineSeparator();
			document.add(lineSeparator);
			
			PdfPTable customerHeader= createCustomerHeader();
			document.add(customerHeader);
			
			PdfPTable headerTable2= createMainHeader();
			document.add(headerTable2);
			
		    PdfPTable secHeaderTable2=createSubHeader();
			document.add(secHeaderTable2);

			PdfPTable vehicleOtherdetailsTable2=createRecieptDetails(AppNum,consumerName,reqQty,fromStock,consumerType,timeStamp,mobileNo,workLocation,approvedQty,idProofType,idProofNo);
			document.add(vehicleOtherdetailsTable2);
			
			PdfPTable signature2 = signature();
			document.add(signature2);
			
			PdfPTable noteFooter2=noteFooter(PdfNote);
			document.add(noteFooter2);
			
			
			
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



	private PdfPTable noteFooter(String PdfNote) {
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

			myPhrases=new Phrase("Disclaimer :"+PdfNote,new Font(baseFont, 6, Font.NORMAL));
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

	private PdfPTable signature() {
		PdfPTable mainTable4=new PdfPTable(4);
		float[] regDatewidths = {25,25,25,25};
		try {
			mainTable4.setWidthPercentage(100.0f);
			mainTable4.getDefaultCell().setBorderWidthBottom(1f);
			mainTable4.setWidths(regDatewidths);
			
			Phrase myPhrases=new Phrase("",new Font(baseFont, 5, Font.NORMAL));
			PdfPCell cells0 = new PdfPCell(myPhrases);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable4.addCell(cells0);
			
			myPhrases=new Phrase("",new Font(baseFont, 10, Font.NORMAL));
			cells0 = new PdfPCell(myPhrases);
			cells0.disableBorderSide(Rectangle.TOP);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable4.addCell(cells0);
			
			myPhrases=new Phrase("",new Font(baseFont, 10, Font.NORMAL));
			cells0 = new PdfPCell(myPhrases);
			cells0.disableBorderSide(Rectangle.TOP);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable4.addCell(cells0);

			myPhrases=new Phrase("",new Font(baseFont, 8, Font.NORMAL));
			cells0 = new PdfPCell(myPhrases);
			cells0.setHorizontalAlignment(Rectangle.ALIGN_JUSTIFIED);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setColspan(2);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable4.addCell(cells0);

			myPhrases=new Phrase("Customer Signature:",new Font(baseFont, 10, Font.NORMAL));
			cells0 = new PdfPCell(myPhrases);
			cells0.disableBorderSide(Rectangle.TOP);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable4.addCell(cells0);
			
			myPhrases=new Phrase("__________",new Font(baseFont, 10, Font.NORMAL));
			cells0 = new PdfPCell(myPhrases);
			cells0.disableBorderSide(Rectangle.TOP);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable4.addCell(cells0);
			
			myPhrases=new Phrase("Department Signature:",new Font(baseFont, 10, Font.NORMAL));
			cells0 = new PdfPCell(myPhrases);
			cells0.disableBorderSide(Rectangle.TOP);
			cells0.disableBorderSide(Rectangle.RIGHT);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable4.addCell(cells0);
			
			myPhrases=new Phrase("__________",new Font(baseFont, 10, Font.NORMAL));
			cells0 = new PdfPCell(myPhrases);
			cells0.disableBorderSide(Rectangle.TOP);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable4.addCell(cells0);
			
			myPhrases=new Phrase("",new Font(baseFont, 10, Font.NORMAL));
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

			myPhrases=new Phrase("RECEIPT FOR SAND ENROLLMENT",new Font(baseFont, 11, Font.BOLD));
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
	
	private PdfPTable createRecieptDetails(String AppNum, String consumerName, String reqQty, String fromStock, String consumerType, String timeStamp,String mobileNo,String workLocation,String approvedQty,String idProofType,String idProofNo) {
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
			
			 vehicleOtherPhras=new Phrase("Application No: ",new Font(baseFont, 10, Font.NORMAL));
			 vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(AppNum,new Font(baseFont, 9, Font.NORMAL));
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
			
			vehicleOtherPhras=new Phrase("Consumer Type: ",new Font(baseFont, 10, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);
			
			vehicleOtherPhras=new Phrase(consumerType,new Font(baseFont, 9, Font.NORMAL));
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
			
			vehicleOtherPhras=new Phrase("Work Location: ",new Font(baseFont, 10, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(workLocation,new Font(baseFont, 9, Font.NORMAL));
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
			
			vehicleOtherPhras=new Phrase("Identity Proof: ",new Font(baseFont, 10, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(idProofType +"-"+ idProofNo,new Font(baseFont, 9, Font.NORMAL));
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
			
			vehicleOtherPhras=new Phrase("Mobile No: ",new Font(baseFont, 10, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(mobileNo,new Font(baseFont, 9, Font.NORMAL));
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
			
			vehicleOtherPhras=new Phrase("Requested Quantity: ",new Font(baseFont, 10, Font.NORMAL));
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
			
			vehicleOtherPhras=new Phrase("Approved Quantity: ",new Font(baseFont, 10, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(approvedQty,new Font(baseFont, 9, Font.NORMAL));
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
			
			vehicleOtherPhras=new Phrase("From: ",new Font(baseFont, 10, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(fromStock,new Font(baseFont, 9, Font.NORMAL));
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
