package t4u.ironMining;

import java.awt.Color;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import t4u.common.ApplicationListener;
import t4u.functions.IronMiningFunction;

import com.lowagie.text.Document;
import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

@SuppressWarnings("serial")
public class PdfForAssetAcknowledgement extends HttpServlet{
	static BaseFont baseFont = null;
	IronMiningFunction ironfuc=new IronMiningFunction();
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)throws ServletException, IOException {
		ArrayList<ArrayList<String>> printAcknowledgeDetails = null;
		ArrayList<String> assetAcknowledgementDetails = null;
		try {
			ServletOutputStream servletOutputStream = resp.getOutputStream();
			Properties properties = ApplicationListener.prop;
			String billpath=  properties.getProperty("Builtypath");
			refreshdir(billpath);
			String pdfFileName="AssetAcknowledgement";
			String fontPath = properties.getProperty("FontPathForMaplePDF");
			baseFont = BaseFont.createFont(fontPath, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
			String bill = billpath+ pdfFileName + ".pdf";

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
	        
			int systemId = Integer.parseInt(req.getParameter("systemId"));
			int clientId =  Integer.parseInt(req.getParameter("clientId"));
			String vehicleNo=req.getParameter("vehicleNo");
			printAcknowledgeDetails=ironfuc.getAcknowledgePrintList(systemId,clientId,vehicleNo);
			String enrollmentNumber ="";
			String enrollmentDate = "";
			String vehicleNumber ="";
			String ownerName ="";
			String assemblyConstituency="";
			String challenNo ="";
			String challenDate ="";
			String bankTransactionNo ="";
			String amountPaid ="";
			String validityDate ="";
			assetAcknowledgementDetails=printAcknowledgeDetails.get(0);
			if(!assetAcknowledgementDetails.isEmpty())
			{
				enrollmentNumber =assetAcknowledgementDetails.get(0);
				enrollmentDate = assetAcknowledgementDetails.get(1);
				vehicleNumber =assetAcknowledgementDetails.get(2);
				ownerName =assetAcknowledgementDetails.get(3);
				assemblyConstituency=assetAcknowledgementDetails.get(4);
				challenNo=assetAcknowledgementDetails.get(5);
				challenDate=assetAcknowledgementDetails.get(6);
				bankTransactionNo=assetAcknowledgementDetails.get(7);
				amountPaid=assetAcknowledgementDetails.get(8);
				validityDate=assetAcknowledgementDetails.get(9);
			}
			double amount=Double.parseDouble(amountPaid);
			DecimalFormat df = new DecimalFormat("#0.00");
			String formattedAmount = df.format(amount); 
			generateBill(document,bill,systemId,clientId,enrollmentNumber,enrollmentDate,vehicleNumber,ownerName,assemblyConstituency,challenNo,challenDate,bankTransactionNo,formattedAmount,validityDate);
			document.close();
			printBill(servletOutputStream, resp, bill, pdfFileName);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Inside PdfForAssetAcknowledgement method..");
		}

	}
	private void generateBill(Document document, String bill, int systemId,
			int clientId, String enrollmentNumber, String enrollmentDate,
			String vehicleNumber, String ownerName,
			String assemblyConstituency, String challenNo, String challenDate,
			String bankTransactionNo, String amountPaid, String validityDate) {
		try {
			PdfPTable headerTable= createHeader();
			document.add(headerTable);

			PdfPTable headerTable2= createsecondHeader();
			document.add(headerTable2);
			
			PdfPTable empty1ColumnTable=createEmptyTable();
			document.add(empty1ColumnTable);

			PdfPTable empty2ColumnTable=createEmptyTable();
			document.add(empty2ColumnTable);

			PdfPTable empty3ColumnTable=createEmptyTable();
			document.add(empty3ColumnTable);

			PdfPTable tableEnroll= createEnrollNumberAndEnrollDate(enrollmentNumber,enrollmentDate);
			document.add(tableEnroll);

			PdfPTable empty4ColumnTable=createEmptyTable();
			document.add(empty4ColumnTable);

			PdfPTable empty5ColumnTable=createEmptyTable();
			document.add(empty5ColumnTable);

			PdfPTable empty6ColumnTable=createEmptyTable();
			document.add(empty6ColumnTable);

			PdfPTable empty7ColumnTable=createEmptyTable();
			document.add(empty7ColumnTable);
			
			PdfPTable empty8ColumnTable=createEmptyTable();
			document.add(empty8ColumnTable);

			PdfPTable vehilceNoTable=creatVehiclnoTable(vehicleNumber);
			document.add(vehilceNoTable);

			PdfPTable ownerNameTable=creatOwnerNameTable(ownerName);
			document.add(ownerNameTable);

			PdfPTable assemblyConsTable=creatassemblyConsTableTable(assemblyConstituency);
			document.add(assemblyConsTable);

			PdfPTable challenNoTable=creatchallenNoTable(challenNo);
			document.add(challenNoTable);

			PdfPTable challenDateTable=creatChallenDateTable(challenDate);
			document.add(challenDateTable);

			PdfPTable bankDetailsTable=createBankDetailsTable(bankTransactionNo);
			document.add(bankDetailsTable);

			PdfPTable amountPaidTable=createAmountPaidTable(amountPaid);
			document.add(amountPaidTable);

			PdfPTable validityDateTable=createValidityDateTable(validityDate);
			document.add(validityDateTable);
			
			PdfPTable signaturecHeaderTable=createSignatureHeader();
			document.add(signaturecHeaderTable);

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e.toString()+"Inside genrateBillMethod in DMG");
		}
	}


	private PdfPTable createHeader() {
		float[] widths = {20,20,20,20,20};
		PdfPTable t1 = new PdfPTable(5);
		try {
			String path = getServletContext().getRealPath("/")+"Main/modules/ironMining/images/dmgLogo.png";
			Image img2 = Image.getInstance(path);

			t1.setWidthPercentage(100.0f);
			t1.setWidths(widths);
			Phrase myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase);
			c1.setBackgroundColor(Color.WHITE);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.disableBorderSide(Rectangle.TOP);
			c1.disableBorderSide(Rectangle.LEFT);
			t1.addCell(c1);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setBackgroundColor(Color.WHITE);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.disableBorderSide(Rectangle.TOP);
			t1.addCell(c1);

			myPhrase=new Phrase("",new Font(baseFont, 3, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setBackgroundColor(Color.WHITE);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.addElement(img2);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.disableBorderSide(Rectangle.TOP);
			t1.addCell(c1);


			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setBackgroundColor(Color.WHITE);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.disableBorderSide(Rectangle.TOP);
			t1.addCell(c1);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setBackgroundColor(Color.WHITE);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.disableBorderSide(Rectangle.TOP);
			c1.disableBorderSide(Rectangle.RIGHT);
			t1.addCell(c1);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.disableBorderSide(Rectangle.LEFT);
			t1.addCell(c1);

			myPhrase=new Phrase("Government of Goa",new Font(baseFont, 8, Font.NORMAL));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setColspan(3);
			c1.setBorder(Rectangle.NO_BORDER);
			t1.addCell(c1);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.disableBorderSide(Rectangle.RIGHT);
			t1.addCell(c1);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.disableBorderSide(Rectangle.LEFT);
			t1.addCell(c1);

			myPhrase=new Phrase("Directorate of Mines & Geology",new Font(baseFont, 10, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setColspan(3);
			c1.setBorder(Rectangle.NO_BORDER);
			t1.addCell(c1);

			myPhrase=new Phrase("",new Font(baseFont, 8, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.disableBorderSide(Rectangle.RIGHT);
			t1.addCell(c1);
			//--------------------------------------------------------------//	
			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.disableBorderSide(Rectangle.LEFT);
			t1.addCell(c1);

			myPhrase=new Phrase("Ground Floor, Institute of Menezes Braganza, Panaji, Goa",new Font(baseFont, 8, Font.NORMAL));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setColspan(3);
			c1.setBorder(Rectangle.NO_BORDER);
			t1.addCell(c1);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			t1.addCell(c1);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			t1.addCell(c1);

			myPhrase=new Phrase("",new Font(baseFont, 9, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.disableBorderSide(Rectangle.RIGHT);
			t1.addCell(c1);
			//--------------------------------------------------------------//
			myPhrase=new Phrase(" ",new Font(baseFont, 6, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.disableBorderSide(Rectangle.LEFT);
			c1.disableBorderSide(Rectangle.BOTTOM);
			t1.addCell(c1);

			myPhrase=new Phrase(" ",new Font(baseFont, 6, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.disableBorderSide(Rectangle.BOTTOM);
			t1.addCell(c1);

			myPhrase=new Phrase(" ",new Font(baseFont, 6, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.disableBorderSide(Rectangle.BOTTOM);
			t1.addCell(c1);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			//c1.setColspan(3);
			c1.disableBorderSide(Rectangle.RIGHT);
			c1.disableBorderSide(Rectangle.BOTTOM);
			t1.addCell(c1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return t1;
	}

	private PdfPTable createsecondHeader() {	
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

			Phrase myc=new Phrase("REGISTRATION VALIDITY",new Font(baseFont, 15, Font.BOLD));
			myc.getFont().setStyle(Font.UNDERLINE);
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

	private PdfPTable createEnrollNumberAndEnrollDate(String enrollmentNumber,
			String enrollmentDate) {
		float[] enrolwidths = {50,60,40,40,40};
		PdfPTable mainTable=new PdfPTable(5);
		try {
			mainTable.setWidthPercentage(100.0f);
			mainTable.setWidths(enrolwidths);
			Phrase myb=new Phrase(" ",new Font(baseFont, 5, Font.BOLD));
			PdfPCell cella = new PdfPCell(myb);
			cella.disableBorderSide(Rectangle.LEFT);
			cella.setBorder(Rectangle.NO_BORDER);
			mainTable.addCell(cella);

			myb=new Phrase(" ",new Font(baseFont, 5, Font.BOLD));
			cella = new PdfPCell(myb);
			cella.disableBorderSide(Rectangle.RIGHT);
			cella.setBorder(Rectangle.NO_BORDER);
			mainTable.addCell(cella);

			myb=new Phrase(" ",new Font(baseFont, 5, Font.BOLD));
			cella = new PdfPCell(myb);
			cella.disableBorderSide(Rectangle.RIGHT);
			cella.setBorder(Rectangle.NO_BORDER);
			mainTable.addCell(cella);

			myb=new Phrase(" ",new Font(baseFont, 5, Font.BOLD));
			cella = new PdfPCell(myb);
			cella.disableBorderSide(Rectangle.RIGHT);
			cella.setBorder(Rectangle.NO_BORDER);
			mainTable.addCell(cella);

			myb=new Phrase(" ",new Font(baseFont, 5, Font.BOLD));
			cella = new PdfPCell(myb);
			cella.disableBorderSide(Rectangle.RIGHT);
			cella.setBorder(Rectangle.NO_BORDER);
			mainTable.addCell(cella);


			myb=new Phrase("Enrollment Number:",new Font(baseFont, 9, Font.NORMAL));
			cella = new PdfPCell(myb);
			cella.disableBorderSide(Rectangle.TOP);
			cella.disableBorderSide(Rectangle.BOTTOM);
			cella.setBorder(Rectangle.NO_BORDER);
			mainTable.addCell(cella);

			myb=new Phrase(enrollmentNumber,new Font(baseFont, 9, Font.BOLD));
			cella = new PdfPCell(myb);
			cella.disableBorderSide(Rectangle.BOTTOM);
			cella.setBorder(Rectangle.NO_BORDER);
			mainTable.addCell(cella);

			myb=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			cella = new PdfPCell(myb);
			cella.disableBorderSide(Rectangle.RIGHT);
			cella.disableBorderSide(Rectangle.BOTTOM);
			cella.setBorder(Rectangle.NO_BORDER);
			mainTable.addCell(cella);

			myb=new Phrase("Enrollment Date:",new Font(baseFont, 9, Font.NORMAL));
			cella = new PdfPCell(myb);
			cella.disableBorderSide(Rectangle.TOP);
			cella.setBorder(Rectangle.NO_BORDER);
			cella.disableBorderSide(Rectangle.BOTTOM);
			mainTable.addCell(cella);

			myb=new Phrase(enrollmentDate,new Font(baseFont, 9, Font.BOLD));
			cella = new PdfPCell(myb);
			cella.disableBorderSide(Rectangle.TOP);
			cella.setBorder(Rectangle.NO_BORDER);
			cella.disableBorderSide(Rectangle.BOTTOM);
			mainTable.addCell(cella);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable;
	}

	private PdfPTable creatVehiclnoTable(String vehicleNumber) {
		PdfPTable VehicleNoTable=new PdfPTable(3);
		try {
			VehicleNoTable.setWidthPercentage(100.0f);
			VehicleNoTable.getDefaultCell().setBorderWidthBottom(1f);
			Phrase vehicleNoPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			PdfPCell vechileNocel = new PdfPCell(vehicleNoPhras);
			vechileNocel.enableBorderSide(Rectangle.LEFT);
			vechileNocel.disableBorderSide(Rectangle.BOTTOM);
			VehicleNoTable.addCell(vechileNocel);

			vehicleNoPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			vechileNocel = new PdfPCell(vehicleNoPhras);
			vechileNocel.disableBorderSide(Rectangle.RIGHT);
			vechileNocel.disableBorderSide(Rectangle.BOTTOM);
			VehicleNoTable.addCell(vechileNocel);

			vehicleNoPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			vechileNocel = new PdfPCell(vehicleNoPhras);
			vechileNocel.disableBorderSide(Rectangle.LEFT);
			vechileNocel.disableBorderSide(Rectangle.BOTTOM);
			VehicleNoTable.addCell(vechileNocel); 

			vehicleNoPhras=new Phrase("Vehicle Number",new Font(baseFont, 9, Font.NORMAL));
			vechileNocel = new PdfPCell(vehicleNoPhras);
			vechileNocel.enableBorderSide(Rectangle.LEFT);
			vechileNocel.disableBorderSide(Rectangle.TOP);
			vechileNocel.disableBorderSide(Rectangle.BOTTOM);
			VehicleNoTable.addCell(vechileNocel);

			vehicleNoPhras=new Phrase(vehicleNumber,new Font(baseFont, 9, Font.BOLD));
			vechileNocel = new PdfPCell(vehicleNoPhras);
			vechileNocel.disableBorderSide(Rectangle.RIGHT);
			vechileNocel.disableBorderSide(Rectangle.TOP);
			vechileNocel.disableBorderSide(Rectangle.BOTTOM);
			VehicleNoTable.addCell(vechileNocel);

			vehicleNoPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			vechileNocel = new PdfPCell(vehicleNoPhras);
			vechileNocel.disableBorderSide(Rectangle.LEFT);
			vechileNocel.disableBorderSide(Rectangle.TOP);
			vechileNocel.disableBorderSide(Rectangle.BOTTOM);
			VehicleNoTable.addCell(vechileNocel);

			vehicleNoPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			vechileNocel = new PdfPCell(vehicleNoPhras);
			vechileNocel.enableBorderSide(Rectangle.LEFT);
			vechileNocel.disableBorderSide(Rectangle.TOP);
			vechileNocel.enableBorderSide(Rectangle.BOTTOM);
			VehicleNoTable.addCell(vechileNocel);

			vehicleNoPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			vechileNocel = new PdfPCell(vehicleNoPhras);
			vechileNocel.disableBorderSide(Rectangle.TOP);
			vechileNocel.disableBorderSide(Rectangle.RIGHT);
			vechileNocel.enableBorderSide(Rectangle.BOTTOM);
			VehicleNoTable.addCell(vechileNocel);

			vehicleNoPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			vechileNocel = new PdfPCell(vehicleNoPhras);
			vechileNocel.disableBorderSide(Rectangle.TOP);
			vechileNocel.disableBorderSide(Rectangle.LEFT);
			vechileNocel.enableBorderSide(Rectangle.BOTTOM);
			VehicleNoTable.addCell(vechileNocel);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return VehicleNoTable;
	}

	private PdfPTable creatOwnerNameTable(String ownerName) {
		PdfPTable ownerNameTable=new PdfPTable(3);
		try {
			ownerNameTable.setWidthPercentage(100.0f);
			ownerNameTable.getDefaultCell().setBorderWidthBottom(1f);
			Phrase ownerNamePhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			PdfPCell ownerNamecel = new PdfPCell(ownerNamePhras);
			ownerNamecel.enableBorderSide(Rectangle.LEFT);
			ownerNamecel.disableBorderSide(Rectangle.BOTTOM);
			ownerNameTable.addCell(ownerNamecel);

			ownerNamePhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			ownerNamecel = new PdfPCell(ownerNamePhras);
			ownerNamecel.disableBorderSide(Rectangle.RIGHT);
			ownerNamecel.disableBorderSide(Rectangle.BOTTOM);
			ownerNameTable.addCell(ownerNamecel);

			ownerNamePhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			ownerNamecel = new PdfPCell(ownerNamePhras);
			ownerNamecel.disableBorderSide(Rectangle.LEFT);
			ownerNamecel.disableBorderSide(Rectangle.BOTTOM);
			ownerNameTable.addCell(ownerNamecel); 

			ownerNamePhras=new Phrase("Owner Name",new Font(baseFont, 9, Font.NORMAL));
			ownerNamecel = new PdfPCell(ownerNamePhras);
			ownerNamecel.enableBorderSide(Rectangle.LEFT);
			ownerNamecel.disableBorderSide(Rectangle.TOP);
			ownerNamecel.disableBorderSide(Rectangle.BOTTOM);
			ownerNameTable.addCell(ownerNamecel);

			ownerNamePhras=new Phrase(ownerName,new Font(baseFont, 9, Font.BOLD));
			ownerNamecel = new PdfPCell(ownerNamePhras);
			ownerNamecel.disableBorderSide(Rectangle.RIGHT);
			ownerNamecel.disableBorderSide(Rectangle.TOP);
			ownerNamecel.disableBorderSide(Rectangle.BOTTOM);
			ownerNameTable.addCell(ownerNamecel);

			ownerNamePhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			ownerNamecel = new PdfPCell(ownerNamePhras);
			ownerNamecel.disableBorderSide(Rectangle.LEFT);
			ownerNamecel.disableBorderSide(Rectangle.TOP);
			ownerNamecel.disableBorderSide(Rectangle.BOTTOM);
			ownerNameTable.addCell(ownerNamecel);

			ownerNamePhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			ownerNamecel = new PdfPCell(ownerNamePhras);
			ownerNamecel.enableBorderSide(Rectangle.LEFT);
			ownerNamecel.disableBorderSide(Rectangle.TOP);
			ownerNamecel.enableBorderSide(Rectangle.BOTTOM);
			ownerNameTable.addCell(ownerNamecel);

			ownerNamePhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			ownerNamecel = new PdfPCell(ownerNamePhras);
			ownerNamecel.disableBorderSide(Rectangle.TOP);
			ownerNamecel.disableBorderSide(Rectangle.RIGHT);
			ownerNamecel.enableBorderSide(Rectangle.BOTTOM);
			ownerNameTable.addCell(ownerNamecel);

			ownerNamePhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			ownerNamecel = new PdfPCell(ownerNamePhras);
			ownerNamecel.disableBorderSide(Rectangle.TOP);
			ownerNamecel.disableBorderSide(Rectangle.LEFT);
			ownerNamecel.enableBorderSide(Rectangle.BOTTOM);
			ownerNameTable.addCell(ownerNamecel);

		} catch (Exception e) {
			System.out.println("Inside Owner Name method"+e.toString());
		}
		return ownerNameTable;
	}

	private PdfPTable creatassemblyConsTableTable(String assemblyConstituency) {
		PdfPTable assemblyConsTable=new PdfPTable(3);
		try {
			assemblyConsTable.setWidthPercentage(100.0f);
			assemblyConsTable.getDefaultCell().setBorderWidthBottom(1f);
			Phrase assemblyConsPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			PdfPCell assemblyConscel = new PdfPCell(assemblyConsPhras);
			assemblyConscel.enableBorderSide(Rectangle.LEFT);
			assemblyConscel.disableBorderSide(Rectangle.BOTTOM);
			assemblyConsTable.addCell(assemblyConscel);

			assemblyConsPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			assemblyConscel = new PdfPCell(assemblyConsPhras);
			assemblyConscel.disableBorderSide(Rectangle.RIGHT);
			assemblyConscel.disableBorderSide(Rectangle.BOTTOM);
			assemblyConsTable.addCell(assemblyConscel);

			assemblyConsPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			assemblyConscel = new PdfPCell(assemblyConsPhras);
			assemblyConscel.disableBorderSide(Rectangle.LEFT);
			assemblyConscel.disableBorderSide(Rectangle.BOTTOM);
			assemblyConsTable.addCell(assemblyConscel); 

			assemblyConsPhras=new Phrase("Assembly Constituency",new Font(baseFont, 9, Font.NORMAL));
			assemblyConscel = new PdfPCell(assemblyConsPhras);
			assemblyConscel.enableBorderSide(Rectangle.LEFT);
			assemblyConscel.disableBorderSide(Rectangle.TOP);
			assemblyConscel.disableBorderSide(Rectangle.BOTTOM);
			assemblyConsTable.addCell(assemblyConscel);

			assemblyConsPhras=new Phrase(assemblyConstituency,new Font(baseFont, 9, Font.BOLD));
			assemblyConscel = new PdfPCell(assemblyConsPhras);
			assemblyConscel.disableBorderSide(Rectangle.RIGHT);
			assemblyConscel.disableBorderSide(Rectangle.TOP);
			assemblyConscel.disableBorderSide(Rectangle.BOTTOM);
			assemblyConsTable.addCell(assemblyConscel);

			assemblyConsPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			assemblyConscel = new PdfPCell(assemblyConsPhras);
			assemblyConscel.disableBorderSide(Rectangle.LEFT);
			assemblyConscel.disableBorderSide(Rectangle.TOP);
			assemblyConscel.disableBorderSide(Rectangle.BOTTOM);
			assemblyConsTable.addCell(assemblyConscel);

			assemblyConsPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			assemblyConscel = new PdfPCell(assemblyConsPhras);
			assemblyConscel.enableBorderSide(Rectangle.LEFT);
			assemblyConscel.disableBorderSide(Rectangle.TOP);
			assemblyConscel.enableBorderSide(Rectangle.BOTTOM);
			assemblyConsTable.addCell(assemblyConscel);

			assemblyConsPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			assemblyConscel = new PdfPCell(assemblyConsPhras);
			assemblyConscel.disableBorderSide(Rectangle.TOP);
			assemblyConscel.disableBorderSide(Rectangle.RIGHT);
			assemblyConscel.enableBorderSide(Rectangle.BOTTOM);
			assemblyConsTable.addCell(assemblyConscel);

			assemblyConsPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			assemblyConscel = new PdfPCell(assemblyConsPhras);
			assemblyConscel.disableBorderSide(Rectangle.TOP);
			assemblyConscel.disableBorderSide(Rectangle.LEFT);
			assemblyConscel.enableBorderSide(Rectangle.BOTTOM);
			assemblyConsTable.addCell(assemblyConscel);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return assemblyConsTable;
	}
	private PdfPTable createValidityDateTable(String validityDate) {
		PdfPTable validityDateTable=new PdfPTable(3);
		try {
			validityDateTable.setWidthPercentage(100.0f);
			validityDateTable.getDefaultCell().setBorderWidthBottom(1f);

			Phrase validityDatePhars=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			PdfPCell validityDateCel = new PdfPCell(validityDatePhars);
			validityDateCel.enableBorderSide(Rectangle.LEFT);
			validityDateCel.disableBorderSide(Rectangle.BOTTOM);
			validityDateTable.addCell(validityDateCel);

			validityDatePhars=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			validityDateCel = new PdfPCell(validityDatePhars);
			validityDateCel.disableBorderSide(Rectangle.RIGHT);
			validityDateCel.disableBorderSide(Rectangle.BOTTOM);
			validityDateTable.addCell(validityDateCel);

			validityDatePhars=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			validityDateCel = new PdfPCell(validityDatePhars);
			validityDateCel.disableBorderSide(Rectangle.LEFT);
			validityDateCel.disableBorderSide(Rectangle.BOTTOM);
			validityDateTable.addCell(validityDateCel); 

			validityDatePhars=new Phrase("Validity Date",new Font(baseFont, 9, Font.NORMAL));
			validityDateCel = new PdfPCell(validityDatePhars);
			validityDateCel.enableBorderSide(Rectangle.LEFT);
			validityDateCel.disableBorderSide(Rectangle.TOP);
			validityDateCel.disableBorderSide(Rectangle.BOTTOM);
			validityDateTable.addCell(validityDateCel);

			validityDatePhars=new Phrase(validityDate,new Font(baseFont, 9, Font.BOLD));
			validityDateCel = new PdfPCell(validityDatePhars);
			validityDateCel.disableBorderSide(Rectangle.RIGHT);
			validityDateCel.disableBorderSide(Rectangle.TOP);
			validityDateCel.disableBorderSide(Rectangle.BOTTOM);
			validityDateTable.addCell(validityDateCel);

			validityDatePhars=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			validityDateCel = new PdfPCell(validityDatePhars);
			validityDateCel.disableBorderSide(Rectangle.LEFT);
			validityDateCel.disableBorderSide(Rectangle.TOP);
			validityDateCel.disableBorderSide(Rectangle.BOTTOM);
			validityDateTable.addCell(validityDateCel);

			validityDatePhars=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			validityDateCel = new PdfPCell(validityDatePhars);
			validityDateCel.enableBorderSide(Rectangle.LEFT);
			validityDateCel.disableBorderSide(Rectangle.TOP);
			validityDateCel.enableBorderSide(Rectangle.BOTTOM);
			validityDateTable.addCell(validityDateCel);

			validityDatePhars=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			validityDateCel = new PdfPCell(validityDatePhars);
			validityDateCel.disableBorderSide(Rectangle.TOP);
			validityDateCel.disableBorderSide(Rectangle.RIGHT);
			validityDateCel.enableBorderSide(Rectangle.BOTTOM);
			validityDateTable.addCell(validityDateCel);

			validityDatePhars=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			validityDateCel = new PdfPCell(validityDatePhars);
			validityDateCel.disableBorderSide(Rectangle.TOP);
			validityDateCel.disableBorderSide(Rectangle.LEFT);
			validityDateCel.enableBorderSide(Rectangle.BOTTOM);
			validityDateTable.addCell(validityDateCel);

		}catch (Exception e) {
			System.out.println("inside Validity Date table"+e.toString());
			e.printStackTrace();
		}
		return validityDateTable;
	}
	private PdfPTable createAmountPaidTable(String amountPaid) {
		PdfPTable amountPaidTable=new PdfPTable(3);
		try {
			amountPaidTable.setWidthPercentage(100.0f);
			amountPaidTable.getDefaultCell().setBorderWidthBottom(1f);

			Phrase amountPaidPhars=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			PdfPCell amountPaidCel = new PdfPCell(amountPaidPhars);
			amountPaidCel.enableBorderSide(Rectangle.LEFT);
			amountPaidCel.disableBorderSide(Rectangle.BOTTOM);
			amountPaidTable.addCell(amountPaidCel);

			amountPaidPhars=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			amountPaidCel = new PdfPCell(amountPaidPhars);
			amountPaidCel.disableBorderSide(Rectangle.RIGHT);
			amountPaidCel.disableBorderSide(Rectangle.BOTTOM);
			amountPaidTable.addCell(amountPaidCel);

			amountPaidPhars=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			amountPaidCel = new PdfPCell(amountPaidPhars);
			amountPaidCel.disableBorderSide(Rectangle.LEFT);
			amountPaidCel.disableBorderSide(Rectangle.BOTTOM);
			amountPaidTable.addCell(amountPaidCel); 

			amountPaidPhars=new Phrase("Amount Paid "+"(Rs)",new Font(baseFont, 9, Font.NORMAL));
			amountPaidCel = new PdfPCell(amountPaidPhars);
			amountPaidCel.enableBorderSide(Rectangle.LEFT);
			amountPaidCel.disableBorderSide(Rectangle.TOP);
			amountPaidCel.disableBorderSide(Rectangle.BOTTOM);
			amountPaidTable.addCell(amountPaidCel);

			amountPaidPhars=new Phrase(amountPaid,new Font(baseFont, 9, Font.BOLD));
			amountPaidCel = new PdfPCell(amountPaidPhars);
			amountPaidCel.disableBorderSide(Rectangle.RIGHT);
			amountPaidCel.disableBorderSide(Rectangle.TOP);
			amountPaidCel.disableBorderSide(Rectangle.BOTTOM);
			amountPaidTable.addCell(amountPaidCel);

			amountPaidPhars=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			amountPaidCel = new PdfPCell(amountPaidPhars);
			amountPaidCel.disableBorderSide(Rectangle.LEFT);
			amountPaidCel.disableBorderSide(Rectangle.TOP);
			amountPaidCel.disableBorderSide(Rectangle.BOTTOM);
			amountPaidTable.addCell(amountPaidCel);

			amountPaidPhars=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			amountPaidCel = new PdfPCell(amountPaidPhars);
			amountPaidCel.enableBorderSide(Rectangle.LEFT);
			amountPaidCel.disableBorderSide(Rectangle.TOP);
			amountPaidCel.enableBorderSide(Rectangle.BOTTOM);
			amountPaidTable.addCell(amountPaidCel);

			amountPaidPhars=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			amountPaidCel = new PdfPCell(amountPaidPhars);
			amountPaidCel.disableBorderSide(Rectangle.TOP);
			amountPaidCel.disableBorderSide(Rectangle.RIGHT);
			amountPaidCel.enableBorderSide(Rectangle.BOTTOM);
			amountPaidTable.addCell(amountPaidCel);

			amountPaidPhars=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			amountPaidCel = new PdfPCell(amountPaidPhars);
			amountPaidCel.disableBorderSide(Rectangle.TOP);
			amountPaidCel.disableBorderSide(Rectangle.LEFT);
			amountPaidCel.enableBorderSide(Rectangle.BOTTOM);
			amountPaidTable.addCell(amountPaidCel);
		} catch (Exception e) {
			System.out.println("inside Amount Paid table"+e.toString());
			e.printStackTrace();
		}
		return amountPaidTable;
	}
	private PdfPTable createBankDetailsTable(String bankTransactionNo) {
		PdfPTable bankTransactionNoTable=new PdfPTable(3);
		try {
			bankTransactionNoTable.setWidthPercentage(100.0f);
			bankTransactionNoTable.getDefaultCell().setBorderWidthBottom(1f);

			Phrase bankTransactionphras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			PdfPCell bankTransactionCel = new PdfPCell(bankTransactionphras);
			bankTransactionCel.enableBorderSide(Rectangle.LEFT);
			bankTransactionCel.disableBorderSide(Rectangle.BOTTOM);
			bankTransactionNoTable.addCell(bankTransactionCel);

			bankTransactionphras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			bankTransactionCel = new PdfPCell(bankTransactionphras);
			bankTransactionCel.disableBorderSide(Rectangle.RIGHT);
			bankTransactionCel.disableBorderSide(Rectangle.BOTTOM);
			bankTransactionNoTable.addCell(bankTransactionCel);

			bankTransactionphras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			bankTransactionCel = new PdfPCell(bankTransactionphras);
			bankTransactionCel.disableBorderSide(Rectangle.LEFT);
			bankTransactionCel.disableBorderSide(Rectangle.BOTTOM);
			bankTransactionNoTable.addCell(bankTransactionCel); 

			bankTransactionphras=new Phrase("Bank Transaction Number",new Font(baseFont, 9, Font.NORMAL));
			bankTransactionCel = new PdfPCell(bankTransactionphras);
			bankTransactionCel.enableBorderSide(Rectangle.LEFT);
			bankTransactionCel.disableBorderSide(Rectangle.TOP);
			bankTransactionCel.disableBorderSide(Rectangle.BOTTOM);
			bankTransactionNoTable.addCell(bankTransactionCel);

			bankTransactionphras=new Phrase(bankTransactionNo,new Font(baseFont, 9, Font.BOLD));
			bankTransactionCel = new PdfPCell(bankTransactionphras);
			bankTransactionCel.disableBorderSide(Rectangle.RIGHT);
			bankTransactionCel.disableBorderSide(Rectangle.TOP);
			bankTransactionCel.disableBorderSide(Rectangle.BOTTOM);
			bankTransactionNoTable.addCell(bankTransactionCel);

			bankTransactionphras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			bankTransactionCel = new PdfPCell(bankTransactionphras);
			bankTransactionCel.disableBorderSide(Rectangle.LEFT);
			bankTransactionCel.disableBorderSide(Rectangle.TOP);
			bankTransactionCel.disableBorderSide(Rectangle.BOTTOM);
			bankTransactionNoTable.addCell(bankTransactionCel);

			bankTransactionphras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			bankTransactionCel = new PdfPCell(bankTransactionphras);
			bankTransactionCel.enableBorderSide(Rectangle.LEFT);
			bankTransactionCel.disableBorderSide(Rectangle.TOP);
			bankTransactionCel.enableBorderSide(Rectangle.BOTTOM);
			bankTransactionNoTable.addCell(bankTransactionCel);

			bankTransactionphras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			bankTransactionCel = new PdfPCell(bankTransactionphras);
			bankTransactionCel.disableBorderSide(Rectangle.TOP);
			bankTransactionCel.disableBorderSide(Rectangle.RIGHT);
			bankTransactionCel.enableBorderSide(Rectangle.BOTTOM);
			bankTransactionNoTable.addCell(bankTransactionCel);

			bankTransactionphras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			bankTransactionCel = new PdfPCell(bankTransactionphras);
			bankTransactionCel.disableBorderSide(Rectangle.TOP);
			bankTransactionCel.disableBorderSide(Rectangle.LEFT);
			bankTransactionCel.enableBorderSide(Rectangle.BOTTOM);
			bankTransactionNoTable.addCell(bankTransactionCel);
		} catch (Exception e) {
			System.out.println("inside bank Transaction No table"+e.toString());
			e.printStackTrace();
		}
		return bankTransactionNoTable;
	}
	private PdfPTable creatChallenDateTable(String challenDate) {
		PdfPTable challenDateTable=new PdfPTable(3);
		try {
			challenDateTable.setWidthPercentage(100.0f);
			challenDateTable.getDefaultCell().setBorderWidthBottom(1f);

			Phrase challenDatePhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			PdfPCell challenDateCel = new PdfPCell(challenDatePhras);
			challenDateCel.enableBorderSide(Rectangle.LEFT);
			challenDateCel.disableBorderSide(Rectangle.BOTTOM);
			challenDateTable.addCell(challenDateCel);

			challenDatePhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			challenDateCel = new PdfPCell(challenDatePhras);
			challenDateCel.disableBorderSide(Rectangle.RIGHT);
			challenDateCel.disableBorderSide(Rectangle.BOTTOM);
			challenDateTable.addCell(challenDateCel);

			challenDatePhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			challenDateCel = new PdfPCell(challenDatePhras);
			challenDateCel.disableBorderSide(Rectangle.LEFT);
			challenDateCel.disableBorderSide(Rectangle.BOTTOM);
			challenDateTable.addCell(challenDateCel); 

			challenDatePhras=new Phrase("Challan Date",new Font(baseFont, 9, Font.NORMAL));
			challenDateCel = new PdfPCell(challenDatePhras);
			challenDateCel.enableBorderSide(Rectangle.LEFT);
			challenDateCel.disableBorderSide(Rectangle.TOP);
			challenDateCel.disableBorderSide(Rectangle.BOTTOM);
			challenDateTable.addCell(challenDateCel);

			challenDatePhras=new Phrase(challenDate,new Font(baseFont, 9, Font.BOLD));
			challenDateCel = new PdfPCell(challenDatePhras);
			challenDateCel.disableBorderSide(Rectangle.RIGHT);
			challenDateCel.disableBorderSide(Rectangle.TOP);
			challenDateCel.disableBorderSide(Rectangle.BOTTOM);
			challenDateTable.addCell(challenDateCel);

			challenDatePhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			challenDateCel = new PdfPCell(challenDatePhras);
			challenDateCel.disableBorderSide(Rectangle.LEFT);
			challenDateCel.disableBorderSide(Rectangle.TOP);
			challenDateCel.disableBorderSide(Rectangle.BOTTOM);
			challenDateTable.addCell(challenDateCel);

			challenDatePhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			challenDateCel = new PdfPCell(challenDatePhras);
			challenDateCel.enableBorderSide(Rectangle.LEFT);
			challenDateCel.disableBorderSide(Rectangle.TOP);
			challenDateCel.enableBorderSide(Rectangle.BOTTOM);
			challenDateTable.addCell(challenDateCel);

			challenDatePhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			challenDateCel = new PdfPCell(challenDatePhras);
			challenDateCel.disableBorderSide(Rectangle.TOP);
			challenDateCel.disableBorderSide(Rectangle.RIGHT);
			challenDateCel.enableBorderSide(Rectangle.BOTTOM);
			challenDateTable.addCell(challenDateCel);

			challenDatePhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			challenDateCel = new PdfPCell(challenDatePhras);
			challenDateCel.disableBorderSide(Rectangle.TOP);
			challenDateCel.disableBorderSide(Rectangle.LEFT);
			challenDateCel.enableBorderSide(Rectangle.BOTTOM);
			challenDateTable.addCell(challenDateCel);

		} catch (Exception e) {
			System.out.println("inside Challen Date table"+e.toString());
			e.printStackTrace();
		}
		return challenDateTable;
	}
	private PdfPTable creatchallenNoTable(String challenNo) {
		PdfPTable challenNoTable=new PdfPTable(3);
		try {
			challenNoTable.setWidthPercentage(100.0f);
			challenNoTable.getDefaultCell().setBorderWidthBottom(1f);

			Phrase challenNoPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			PdfPCell challenNoCel = new PdfPCell(challenNoPhras);
			challenNoCel.enableBorderSide(Rectangle.LEFT);
			challenNoCel.disableBorderSide(Rectangle.BOTTOM);
			challenNoTable.addCell(challenNoCel);

			challenNoPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			challenNoCel = new PdfPCell(challenNoPhras);
			challenNoCel.disableBorderSide(Rectangle.RIGHT);
			challenNoCel.disableBorderSide(Rectangle.BOTTOM);
			challenNoTable.addCell(challenNoCel);

			challenNoPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			challenNoCel = new PdfPCell(challenNoPhras);
			challenNoCel.disableBorderSide(Rectangle.LEFT);
			challenNoCel.disableBorderSide(Rectangle.BOTTOM);
			challenNoTable.addCell(challenNoCel); 

			challenNoPhras=new Phrase("Challan Number",new Font(baseFont, 9, Font.NORMAL));
			challenNoCel = new PdfPCell(challenNoPhras);
			challenNoCel.enableBorderSide(Rectangle.LEFT);
			challenNoCel.disableBorderSide(Rectangle.TOP);
			challenNoCel.disableBorderSide(Rectangle.BOTTOM);
			challenNoTable.addCell(challenNoCel);

			challenNoPhras=new Phrase(challenNo,new Font(baseFont, 9, Font.BOLD));
			challenNoCel = new PdfPCell(challenNoPhras);
			challenNoCel.disableBorderSide(Rectangle.RIGHT);
			challenNoCel.disableBorderSide(Rectangle.TOP);
			challenNoCel.disableBorderSide(Rectangle.BOTTOM);
			challenNoTable.addCell(challenNoCel);

			challenNoPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			challenNoCel = new PdfPCell(challenNoPhras);
			challenNoCel.disableBorderSide(Rectangle.LEFT);
			challenNoCel.disableBorderSide(Rectangle.TOP);
			challenNoCel.disableBorderSide(Rectangle.BOTTOM);
			challenNoTable.addCell(challenNoCel);

			challenNoPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			challenNoCel = new PdfPCell(challenNoPhras);
			challenNoCel.enableBorderSide(Rectangle.LEFT);
			challenNoCel.disableBorderSide(Rectangle.TOP);
			challenNoCel.enableBorderSide(Rectangle.BOTTOM);
			challenNoTable.addCell(challenNoCel);

			challenNoPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			challenNoCel = new PdfPCell(challenNoPhras);
			challenNoCel.disableBorderSide(Rectangle.TOP);
			challenNoCel.disableBorderSide(Rectangle.RIGHT);
			challenNoCel.enableBorderSide(Rectangle.BOTTOM);
			challenNoTable.addCell(challenNoCel);

			challenNoPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			challenNoCel = new PdfPCell(challenNoPhras);
			challenNoCel.disableBorderSide(Rectangle.TOP);
			challenNoCel.disableBorderSide(Rectangle.LEFT);
			challenNoCel.enableBorderSide(Rectangle.BOTTOM);
			challenNoTable.addCell(challenNoCel);

		} catch (Exception e) {
			System.out.println("inside Challen No table"+e.toString());
			e.printStackTrace();
		}
		return challenNoTable;
	}
	
	private PdfPTable createSignatureHeader() {
		float[] widths = {25,25,25,25,25};
		PdfPTable t = new PdfPTable(5);
		try {
			String path = getServletContext().getRealPath("/")+"Main/modules/ironMining/images/authorizedsign.jpg";
			Image img2 = Image.getInstance(path);

			t.setWidthPercentage(100.0f);
			t.setWidths(widths);
			Phrase myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase);
			c.setBackgroundColor(Color.WHITE);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			c.enableBorderSide(Rectangle.TOP);
			c.disableBorderSide(Rectangle.LEFT);
			t.addCell(c);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBackgroundColor(Color.WHITE);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			c.enableBorderSide(Rectangle.TOP);
			t.addCell(c);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBackgroundColor(Color.WHITE);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			c.enableBorderSide(Rectangle.TOP);
			t.addCell(c);


			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBackgroundColor(Color.WHITE);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			c.enableBorderSide(Rectangle.TOP);
			t.addCell(c);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBackgroundColor(Color.WHITE);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			c.enableBorderSide(Rectangle.TOP);
			c.disableBorderSide(Rectangle.RIGHT);
			t.addCell(c);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			c.disableBorderSide(Rectangle.LEFT);
			t.addCell(c);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			c.setColspan(3);
			c.disableBorderSide(Rectangle.RIGHT);
			t.addCell(c);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			c.disableBorderSide(Rectangle.LEFT);
			t.addCell(c);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			c.setColspan(3);
			c.disableBorderSide(Rectangle.RIGHT);
			t.addCell(c);
			//--------------------------------------------------------------//	
			myPhrase=new Phrase(" ",new Font(baseFont, 6, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			c.disableBorderSide(Rectangle.LEFT);
			t.addCell(c);

			myPhrase=new Phrase(" ",new Font(baseFont, 6, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase=new Phrase(" ",new Font(baseFont, 6, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase=new Phrase(" ",new Font(baseFont, 6, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase=new Phrase("",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			c.disableBorderSide(Rectangle.RIGHT);
			t.addCell(c);
			//--------------------------------------------------------------//
			myPhrase=new Phrase(" ",new Font(baseFont, 6, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			c.disableBorderSide(Rectangle.LEFT);
			c.disableBorderSide(Rectangle.BOTTOM);
			t.addCell(c);

			myPhrase=new Phrase(" ",new Font(baseFont, 6, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			c.disableBorderSide(Rectangle.BOTTOM);
			t.addCell(c);

			myPhrase=new Phrase(" ",new Font(baseFont, 6, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			c.disableBorderSide(Rectangle.BOTTOM);
			t.addCell(c);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.addElement(img2);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			c.setColspan(3);
			c.disableBorderSide(Rectangle.RIGHT);
			c.disableBorderSide(Rectangle.BOTTOM);
			t.addCell(c);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return t;
	}
	
	private PdfPTable createEmptyTable() {
		PdfPTable emptyTable=new PdfPTable(3);
		try {
			emptyTable.setWidthPercentage(100.0f);
			emptyTable.getDefaultCell().setBorderWidthBottom(1f);
			Phrase emptymyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			PdfPCell emptycel = new PdfPCell(emptymyPhras);
			emptycel.disableBorderSide(Rectangle.LEFT);
			emptycel.setBorder(Rectangle.NO_BORDER);
			emptyTable.addCell(emptycel);

			emptymyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			emptycel = new PdfPCell(emptymyPhras);
			emptycel.disableBorderSide(Rectangle.RIGHT);
			emptycel.setBorder(Rectangle.NO_BORDER);
			emptyTable.addCell(emptycel);

			emptymyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			emptycel = new PdfPCell(emptymyPhras);
			emptycel.disableBorderSide(Rectangle.TOP);
			emptycel.disableBorderSide(Rectangle.LEFT);
			emptycel.setBorder(Rectangle.NO_BORDER);
			emptyTable.addCell(emptycel);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return emptyTable;
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

	/** if directory not exixts then create it */
	private void refreshdir(String reportpath)
	{
		try
		{
			File f = new File(reportpath);
			if(!f.exists())
			{
				f.mkdir();
			}
		}
		catch (Exception e) 
		{
			System.out.println("Error creating folder for Builty Report: " + e);
			e.printStackTrace();
		}
	}	
}
