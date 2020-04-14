package t4u.ironMining;

import java.awt.Color;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.functions.IronMiningFunction;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
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
public class PdfForAssetEnrollment extends HttpServlet{
	static BaseFont baseFont = null;
	IronMiningFunction ironfuc=new IronMiningFunction();
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)throws ServletException, IOException {
		LoginInfoBean loginInfo =new LoginInfoBean();
		ArrayList<ArrayList<String>> printDetails = null;
		ArrayList<String> assetEnrollmentDetails = null;
		try {
			ServletOutputStream servletOutputStream = resp.getOutputStream();
			Properties properties = ApplicationListener.prop;
			String billpath=  properties.getProperty("Builtypath");
			refreshdir(billpath);
			String pdfFileName="AssetEnrollment";
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
	        
	        Rectangle rect1 = new Rectangle(36, 36, 559, 806);
	        rect1.setBorder(Rectangle.BOX);
	        rect1.setBorderWidth(2);
	        canvas.rectangle(rect1);
			
			int systemId = Integer.parseInt(req.getParameter("systemId"));
			int clientId =  Integer.parseInt(req.getParameter("clientId"));
			String vehicleNo=req.getParameter("vehicleNo");
			String CustomerName=req.getParameter("clientName");
			printDetails=ironfuc.getPrintList(systemId,clientId,vehicleNo,CustomerName);
			String enrollmentNumber ="";
			String enrollmentDate = "";
			String vehicleNumber ="";
			String vehicleRegistrationDate ="";
			String carriageCapacity ="";
			String chassisNo ="";
			String InsurancePolicyNo="";
			String InsuranceExpiryDate="";
			String PucNumber ="";
			String PucExpiryDate="";
	        String ownerName ="";
			String houseNo ="";
			String assemblyConstituency="";
			String locality ="";
			String city ="";
			String taluk ="";
			String district ="";
			String state ="";
			String mobileNumber ="";
			String epicNumber ="-";
			String panNumber = "-";
			String aadharNo="-";
			String vehicleType="-";
			assetEnrollmentDetails=printDetails.get(0);
			if(!assetEnrollmentDetails.isEmpty())
			{
				enrollmentNumber =assetEnrollmentDetails.get(0);
				enrollmentDate = assetEnrollmentDetails.get(1);
				vehicleNumber =assetEnrollmentDetails.get(2);
				vehicleRegistrationDate =assetEnrollmentDetails.get(3);
				carriageCapacity =assetEnrollmentDetails.get(4);
				chassisNo =assetEnrollmentDetails.get(5);
				InsurancePolicyNo =assetEnrollmentDetails.get(6);
		        InsuranceExpiryDate =assetEnrollmentDetails.get(7);
				PucNumber =assetEnrollmentDetails.get(8);
				PucExpiryDate =assetEnrollmentDetails.get(9);
                ownerName =assetEnrollmentDetails.get(10);
				houseNo =assetEnrollmentDetails.get(11);
				assemblyConstituency=assetEnrollmentDetails.get(12);
				locality = assetEnrollmentDetails.get(13);
				city =assetEnrollmentDetails.get(14);
				taluk =assetEnrollmentDetails.get(15);
				district =assetEnrollmentDetails.get(16);
				state =assetEnrollmentDetails.get(17);
				epicNumber =assetEnrollmentDetails.get(18);
				panNumber = assetEnrollmentDetails.get(19);
				mobileNumber =assetEnrollmentDetails.get(20);
				aadharNo=assetEnrollmentDetails.get(21);
				vehicleType=assetEnrollmentDetails.get(22);
			}

			generateBill(document,bill,systemId,clientId,enrollmentNumber,enrollmentDate,vehicleNumber,vehicleRegistrationDate,carriageCapacity,
					chassisNo,InsurancePolicyNo,InsuranceExpiryDate,PucNumber,PucExpiryDate,ownerName,houseNo,assemblyConstituency,locality,city,taluk,district,state,mobileNumber,epicNumber,panNumber,aadharNo,vehicleType);
			document.close();
			printBill(servletOutputStream, resp, bill, pdfFileName);
		} catch (DocumentException e) {
			e.printStackTrace();
		}
	}
	private void generateBill(Document document,String bill, int systemId,int clientId,String enrollmentNumber,String enrollmentDate,String vehicleNumber,String vehicleRegistrationDate,String carriageCapacity,
			String chassisNo, String InsurancePolicyNo,String InsuranceExpiryDate,String PucNumber,String PucExpiryDate, String ownerName,String houseNo,String assemblyConstituency,String locality,String city,String taluk,String district,String state,String mobileNumber,String epicNumber,String panNumber,String aadharNo,String vehicleType) {
		try {
			PdfPTable headerTable= createHeader();
			document.add(headerTable);

			PdfPTable headerTable2= createsecondHeader(vehicleType);
			document.add(headerTable2);

			PdfPTable tableEnroll= createEnrollNumberAndEnrollDate(enrollmentNumber,enrollmentDate);
			document.add(tableEnroll);

			PdfPTable empty3ColumnTable=createEmptyTable();
			document.add(empty3ColumnTable);

			PdfPTable secHeaderTable=create2Header();
			document.add(secHeaderTable);

			PdfPTable empty2ColumnTable=createEmptyTable();
			document.add(empty2ColumnTable);

			PdfPTable empty1ColumnTable=createEmptyTable();
			document.add(empty1ColumnTable);

			PdfPTable empty4ColumnTable=createEmptyTable();
			document.add(empty4ColumnTable);

			PdfPTable vehilceNoTable=creatVehiclnoTable(vehicleNumber);
			document.add(vehilceNoTable);

			PdfPTable ownerNameAndAddressDetails=creatOwnerDetailsAndAddressTable(ownerName,houseNo,locality,city,taluk,district,state);
			document.add(ownerNameAndAddressDetails);

			PdfPTable assemblyConsTable=creatassemblyConsTableTable(assemblyConstituency);
			document.add(assemblyConsTable);

			PdfPTable empty5ColumnTable=createEmptyTable();
			document.add(empty5ColumnTable);

			PdfPTable empty6ColumnTable=createEmptyTable();
			document.add(empty6ColumnTable);

			PdfPTable vehicleOtherdetailsTable=createVehicleOtherDetails(vehicleRegistrationDate,mobileNumber);
			document.add(vehicleOtherdetailsTable);
			
			PdfPTable empty7ColumnTable=createEmptyTable();
			document.add(empty7ColumnTable);

			PdfPTable empty8ColumnTable=createEmptyTable();
			document.add(empty8ColumnTable);

			PdfPTable vehicleCarriageAndEpicdetailsTable=createVehicleCarriageAndEpicDetails(carriageCapacity,epicNumber);
			document.add(vehicleCarriageAndEpicdetailsTable);
			
			PdfPTable empty9ColumnTable=createEmptyTable();
			document.add(empty9ColumnTable);

			PdfPTable empty10ColumnTable=createEmptyTable();
			document.add(empty10ColumnTable);

			PdfPTable vehicleChassisAndPandetailsTable=createvehicleChassisAndPanDetails(chassisNo,panNumber);
			document.add(vehicleChassisAndPandetailsTable);
			
			PdfPTable empty11ColumnTable=createEmptyTable();
			document.add(empty11ColumnTable);

			PdfPTable empty12ColumnTable=createEmptyTable();
			document.add(empty12ColumnTable);

			PdfPTable vehicleAddhardetailsTable=createVehicleAddharDetails(aadharNo);
			document.add(vehicleAddhardetailsTable);
			
			PdfPTable empty13ColumnTable=createEmptyTable();
			document.add(empty13ColumnTable);

			PdfPTable empty14ColumnTable=createEmptyTable();
			document.add(empty14ColumnTable);
			
			PdfPTable vehicleInsurancedetailsTable=createvehicleInsurancedetails(InsurancePolicyNo,InsuranceExpiryDate);
			document.add(vehicleInsurancedetailsTable);
			
			PdfPTable empty15ColumnTable=createEmptyTable();
			document.add(empty13ColumnTable);

			PdfPTable empty16ColumnTable=createEmptyTable();
			document.add(empty14ColumnTable);
			
			PdfPTable vehiclePucdetailsTable=createvehiclePucdetails(PucNumber,PucExpiryDate);
			document.add(vehiclePucdetailsTable);
			
			PdfPTable empty17ColumnTable=createEmptyTable();
			document.add(empty13ColumnTable);

			PdfPTable empty18ColumnTable=createEmptyTable();
			document.add(empty14ColumnTable);
			
		    PdfPTable signaturecHeaderTable=createSignatureHeader();
			document.add(signaturecHeaderTable);


		} catch (Exception e) {
			System.out.println("Error generating report : " + e);
			e.printStackTrace();
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
	private PdfPTable createsecondHeader(String vehicleType) {	
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

			Phrase myc=new Phrase(vehicleType+" REGISTRATION CERTIFICATE",new Font(baseFont, 15, Font.BOLD));
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

	private PdfPTable create2Header() {
		PdfPTable mainTable3=new PdfPTable(3);
		try {
			mainTable3.setWidthPercentage(100.0f);
			mainTable3.getDefaultCell().setBorderWidthBottom(1f);
			Phrase myPhrases=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			PdfPCell cells0 = new PdfPCell(myPhrases);
			cells0.disableBorderSide(Rectangle.LEFT);
			cells0.setBorder(Rectangle.NO_BORDER);
			mainTable3.addCell(cells0);

			myPhrases=new Phrase("VEHICLE AND OWNER DETAILS",new Font(baseFont, 11, Font.BOLD));
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

	private PdfPTable creatOwnerDetailsAndAddressTable(String ownerName,
			String houseNo, String locality, String city, String taluk,
			String district, String state) {
		PdfPTable OwnerNameAndAddressTable=new PdfPTable(3);
		try {
			OwnerNameAndAddressTable.setWidthPercentage(100.0f);
			OwnerNameAndAddressTable.getDefaultCell().setBorderWidthBottom(1f);

			Phrase OwnerNameAndAddPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			PdfPCell OwnerNameAndAddcel = new PdfPCell(OwnerNameAndAddPhras);
			OwnerNameAndAddcel.enableBorderSide(Rectangle.LEFT);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.BOTTOM);
			OwnerNameAndAddressTable.addCell(OwnerNameAndAddcel);

			OwnerNameAndAddPhras=new Phrase(ownerName,new Font(baseFont, 9, Font.BOLD));
			OwnerNameAndAddcel = new PdfPCell(OwnerNameAndAddPhras);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.RIGHT);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.BOTTOM);
			OwnerNameAndAddressTable.addCell(OwnerNameAndAddcel);

			OwnerNameAndAddPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			OwnerNameAndAddcel = new PdfPCell(OwnerNameAndAddPhras);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.LEFT);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.BOTTOM);
			OwnerNameAndAddressTable.addCell(OwnerNameAndAddcel); 
			//---------------houseNo-----------------------------//	
			OwnerNameAndAddPhras=new Phrase("Owner Name & Address",new Font(baseFont, 9, Font.NORMAL));
			OwnerNameAndAddcel = new PdfPCell(OwnerNameAndAddPhras);
			OwnerNameAndAddcel.enableBorderSide(Rectangle.LEFT);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.TOP);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.BOTTOM);
			OwnerNameAndAddressTable.addCell(OwnerNameAndAddcel);

			OwnerNameAndAddPhras=new Phrase(houseNo +" "+locality,new Font(baseFont, 9, Font.NORMAL));
			OwnerNameAndAddcel = new PdfPCell(OwnerNameAndAddPhras);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.RIGHT);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.TOP);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.BOTTOM);
			OwnerNameAndAddressTable.addCell(OwnerNameAndAddcel);

			OwnerNameAndAddPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			OwnerNameAndAddcel = new PdfPCell(OwnerNameAndAddPhras);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.LEFT);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.TOP);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.BOTTOM);
			OwnerNameAndAddressTable.addCell(OwnerNameAndAddcel);

			//---------------locality-----------------------------//	
			/*OwnerNameAndAddPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			OwnerNameAndAddcel = new PdfPCell(OwnerNameAndAddPhras);
			OwnerNameAndAddcel.enableBorderSide(Rectangle.LEFT);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.TOP);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.BOTTOM);
			OwnerNameAndAddressTable.addCell(OwnerNameAndAddcel);

			OwnerNameAndAddPhras=new Phrase(locality,new Font(baseFont, 9, Font.NORMAL));
			OwnerNameAndAddcel = new PdfPCell(OwnerNameAndAddPhras);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.RIGHT);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.TOP);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.BOTTOM);
			OwnerNameAndAddressTable.addCell(OwnerNameAndAddcel);

			OwnerNameAndAddPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			OwnerNameAndAddcel = new PdfPCell(OwnerNameAndAddPhras);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.LEFT);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.TOP);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.BOTTOM);
			OwnerNameAndAddressTable.addCell(OwnerNameAndAddcel);*/
			//---------------city-----------------------------//	
			OwnerNameAndAddPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			OwnerNameAndAddcel = new PdfPCell(OwnerNameAndAddPhras);
			OwnerNameAndAddcel.enableBorderSide(Rectangle.LEFT);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.TOP);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.BOTTOM);
			OwnerNameAndAddressTable.addCell(OwnerNameAndAddcel);

			OwnerNameAndAddPhras=new Phrase(city,new Font(baseFont, 9, Font.NORMAL));
			OwnerNameAndAddcel = new PdfPCell(OwnerNameAndAddPhras);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.RIGHT);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.TOP);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.BOTTOM);
			OwnerNameAndAddressTable.addCell(OwnerNameAndAddcel);

			OwnerNameAndAddPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			OwnerNameAndAddcel = new PdfPCell(OwnerNameAndAddPhras);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.LEFT);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.TOP);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.BOTTOM);
			OwnerNameAndAddressTable.addCell(OwnerNameAndAddcel);
			//---------------taluk-----------------------------//	
			OwnerNameAndAddPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			OwnerNameAndAddcel = new PdfPCell(OwnerNameAndAddPhras);
			OwnerNameAndAddcel.enableBorderSide(Rectangle.LEFT);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.TOP);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.BOTTOM);
			OwnerNameAndAddressTable.addCell(OwnerNameAndAddcel);

			OwnerNameAndAddPhras=new Phrase(taluk,new Font(baseFont, 9, Font.NORMAL));
			OwnerNameAndAddcel = new PdfPCell(OwnerNameAndAddPhras);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.RIGHT);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.TOP);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.BOTTOM);
			OwnerNameAndAddressTable.addCell(OwnerNameAndAddcel);

			OwnerNameAndAddPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			OwnerNameAndAddcel = new PdfPCell(OwnerNameAndAddPhras);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.LEFT);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.TOP);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.BOTTOM);
			OwnerNameAndAddressTable.addCell(OwnerNameAndAddcel);
			//---------------district-----------------------------//	
			OwnerNameAndAddPhras=new Phrase("",new Font(baseFont, 9, Font.NORMAL));
			OwnerNameAndAddcel = new PdfPCell(OwnerNameAndAddPhras);
			OwnerNameAndAddcel.enableBorderSide(Rectangle.LEFT);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.TOP);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.BOTTOM);
			OwnerNameAndAddressTable.addCell(OwnerNameAndAddcel);

			OwnerNameAndAddPhras=new Phrase(district,new Font(baseFont, 9, Font.NORMAL));
			OwnerNameAndAddcel = new PdfPCell(OwnerNameAndAddPhras);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.RIGHT);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.TOP);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.BOTTOM);
			OwnerNameAndAddressTable.addCell(OwnerNameAndAddcel);

			OwnerNameAndAddPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			OwnerNameAndAddcel = new PdfPCell(OwnerNameAndAddPhras);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.LEFT);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.TOP);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.BOTTOM);
			OwnerNameAndAddressTable.addCell(OwnerNameAndAddcel);
			//---------------state-----------------------------//						
			OwnerNameAndAddPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			OwnerNameAndAddcel = new PdfPCell(OwnerNameAndAddPhras);
			OwnerNameAndAddcel.enableBorderSide(Rectangle.LEFT);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.TOP);
			OwnerNameAndAddcel.enableBorderSide(Rectangle.BOTTOM);
			OwnerNameAndAddressTable.addCell(OwnerNameAndAddcel);

			OwnerNameAndAddPhras=new Phrase(state,new Font(baseFont, 9, Font.NORMAL));
			OwnerNameAndAddcel = new PdfPCell(OwnerNameAndAddPhras);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.TOP);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.RIGHT);
			OwnerNameAndAddcel.enableBorderSide(Rectangle.BOTTOM);
			OwnerNameAndAddressTable.addCell(OwnerNameAndAddcel);

			OwnerNameAndAddPhras=new Phrase("",new Font(baseFont, 9, Font.BOLD));
			OwnerNameAndAddcel = new PdfPCell(OwnerNameAndAddPhras);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.TOP);
			OwnerNameAndAddcel.disableBorderSide(Rectangle.LEFT);
			OwnerNameAndAddcel.enableBorderSide(Rectangle.BOTTOM);
			OwnerNameAndAddressTable.addCell(OwnerNameAndAddcel);	

		} catch (Exception e) {
			e.printStackTrace();
		}
		return OwnerNameAndAddressTable;
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
	private PdfPTable createVehicleOtherDetails(String vehicleRegistrationDate,String mobileNumber) {
		PdfPTable mainTable2=new PdfPTable(5);
		float[] regDatewidths = {60,30,40,40,40};
		try {
			mainTable2.setWidthPercentage(100.0f);
			//mainTable2.getDefaultCell().setBorderWidthBottom(1f);
			mainTable2.setWidths(regDatewidths);

			Phrase vehicleOtherPhras=new Phrase("Vehicle Registration Date :",new Font(baseFont, 9, Font.NORMAL));
			PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(vehicleRegistrationDate,new Font(baseFont, 9, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase("",new Font(baseFont, 10, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel); 

			vehicleOtherPhras=new Phrase("Mobile Number :",new Font(baseFont, 9, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(mobileNumber,new Font(baseFont, 9, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable2;
	}
	private PdfPTable createVehicleAddharDetails(String aadharNo) {
		//------------------------aadhar------------------------------------//
		PdfPTable aadharNoTable=new PdfPTable(5);
		float[] aadrwidths = {60,30,40,40,40};
		try {
			aadharNoTable.setWidthPercentage(100.0f);
			//aadharNoTable.getDefaultCell().setBorderWidthBottom(1f);
			aadharNoTable.setWidths(aadrwidths);

			Phrase aadharNoPhras=new Phrase("",new Font(baseFont, 5, Font.NORMAL));
			PdfPCell aadharNocel = new PdfPCell(aadharNoPhras);
			aadharNocel.setBorder(Rectangle.NO_BORDER);
			aadharNoTable.addCell(aadharNocel);

			aadharNoPhras=new Phrase("",new Font(baseFont, 10, Font.NORMAL));
			aadharNocel = new PdfPCell(aadharNoPhras);
			aadharNocel.setBorder(Rectangle.NO_BORDER);
			aadharNoTable.addCell(aadharNocel); 

			aadharNoPhras=new Phrase("",new Font(baseFont, 10, Font.NORMAL));
			aadharNocel = new PdfPCell(aadharNoPhras);
			aadharNocel.setBorder(Rectangle.NO_BORDER);
			aadharNoTable.addCell(aadharNocel); 

			aadharNoPhras=new Phrase("Aadhar Number:",new Font(baseFont, 9, Font.NORMAL));
			aadharNocel = new PdfPCell(aadharNoPhras);
			aadharNocel.setBorder(Rectangle.NO_BORDER);
			aadharNoTable.addCell(aadharNocel); 

			aadharNoPhras=new Phrase(aadharNo,new Font(baseFont, 9, Font.NORMAL));
			aadharNocel = new PdfPCell(aadharNoPhras);
			aadharNocel.setBorder(Rectangle.NO_BORDER);
			aadharNoTable.addCell(aadharNocel); 
		} catch (Exception e) {
			e.printStackTrace();
		}
		return aadharNoTable;
	}
	private PdfPTable createvehiclePucdetails(String PucNumber ,
			String PucExpiryDate) {
		//--------------------------InsurancePolicyNo and InsuranceExpiryDate---------------------------------------//
		float[] Pucwidths = {60,30,40,40,40};
		PdfPTable PucNumberAndPucExpiryDate=new PdfPTable(5);
		try {
			PucNumberAndPucExpiryDate.setWidthPercentage(100.0f);
			//chassisNoAndPanTable.getDefaultCell().setBorderWidthBottom(1f);
			PucNumberAndPucExpiryDate.setWidths(Pucwidths);
			
			Phrase PucNumberAndPucExpiryDatePhras=new Phrase("Puc Number :",new Font(baseFont, 9, Font.NORMAL));
			PdfPCell PucNumberAndPucExpiryDatecel = new PdfPCell(PucNumberAndPucExpiryDatePhras);
			PucNumberAndPucExpiryDatecel.setBorder(Rectangle.NO_BORDER);
			PucNumberAndPucExpiryDate.addCell(PucNumberAndPucExpiryDatecel);

			PucNumberAndPucExpiryDatePhras=new Phrase(PucNumber,new Font(baseFont, 9, Font.NORMAL));
			PucNumberAndPucExpiryDatecel = new PdfPCell(PucNumberAndPucExpiryDatePhras);
			PucNumberAndPucExpiryDatecel.setBorder(Rectangle.NO_BORDER);
			PucNumberAndPucExpiryDate.addCell(PucNumberAndPucExpiryDatecel); 

			PucNumberAndPucExpiryDatePhras=new Phrase("",new Font(baseFont, 10, Font.NORMAL));
			PucNumberAndPucExpiryDatecel = new PdfPCell(PucNumberAndPucExpiryDatePhras);
			PucNumberAndPucExpiryDatecel.setBorder(Rectangle.NO_BORDER);
			PucNumberAndPucExpiryDate.addCell(PucNumberAndPucExpiryDatecel); 

			PucNumberAndPucExpiryDatePhras=new Phrase("Puc ExpiryDate :",new Font(baseFont, 9, Font.NORMAL));
			PucNumberAndPucExpiryDatecel = new PdfPCell(PucNumberAndPucExpiryDatePhras);
			PucNumberAndPucExpiryDatecel.setBorder(Rectangle.NO_BORDER);
			PucNumberAndPucExpiryDate.addCell(PucNumberAndPucExpiryDatecel); 

			PucNumberAndPucExpiryDatePhras=new Phrase(PucExpiryDate,new Font(baseFont, 9, Font.NORMAL));
			PucNumberAndPucExpiryDatecel = new PdfPCell(PucNumberAndPucExpiryDatePhras);
			PucNumberAndPucExpiryDatecel.setBorder(Rectangle.NO_BORDER);
			PucNumberAndPucExpiryDate.addCell(PucNumberAndPucExpiryDatecel); 
		} catch (Exception e) {
			e.printStackTrace();
		}
		return PucNumberAndPucExpiryDate;
	}
	
	private PdfPTable createvehicleInsurancedetails(String InsurancePolicyNo,
			String InsuranceExpiryDate) {
		//--------------------------InsurancePolicyNo and InsuranceExpiryDate---------------------------------------//
		float[] Insuwidths = {60,30,40,40,40};
		PdfPTable InsurancePolicyNoAndInsuranceExpiryDate=new PdfPTable(5);
		try {
			InsurancePolicyNoAndInsuranceExpiryDate.setWidthPercentage(100.0f);
			//chassisNoAndPanTable.getDefaultCell().setBorderWidthBottom(1f);
			InsurancePolicyNoAndInsuranceExpiryDate.setWidths(Insuwidths);
			
			Phrase InsurancePolicyNoAndInsuranceExpiryDatePhras=new Phrase("Insurance PolicyNo :",new Font(baseFont, 9, Font.NORMAL));
			PdfPCell InsurancePolicyNoAndInsuranceExpiryDatecel = new PdfPCell(InsurancePolicyNoAndInsuranceExpiryDatePhras);
			InsurancePolicyNoAndInsuranceExpiryDatecel.setBorder(Rectangle.NO_BORDER);
			InsurancePolicyNoAndInsuranceExpiryDate.addCell(InsurancePolicyNoAndInsuranceExpiryDatecel);

			InsurancePolicyNoAndInsuranceExpiryDatePhras=new Phrase(InsurancePolicyNo,new Font(baseFont, 9, Font.NORMAL));
			InsurancePolicyNoAndInsuranceExpiryDatecel = new PdfPCell(InsurancePolicyNoAndInsuranceExpiryDatePhras);
			InsurancePolicyNoAndInsuranceExpiryDatecel.setBorder(Rectangle.NO_BORDER);
			InsurancePolicyNoAndInsuranceExpiryDate.addCell(InsurancePolicyNoAndInsuranceExpiryDatecel); 

			InsurancePolicyNoAndInsuranceExpiryDatePhras=new Phrase("",new Font(baseFont, 10, Font.NORMAL));
			InsurancePolicyNoAndInsuranceExpiryDatecel = new PdfPCell(InsurancePolicyNoAndInsuranceExpiryDatePhras);
			InsurancePolicyNoAndInsuranceExpiryDatecel.setBorder(Rectangle.NO_BORDER);
			InsurancePolicyNoAndInsuranceExpiryDate.addCell(InsurancePolicyNoAndInsuranceExpiryDatecel); 

			InsurancePolicyNoAndInsuranceExpiryDatePhras=new Phrase("Insurance ExpiryDate :",new Font(baseFont, 9, Font.NORMAL));
			InsurancePolicyNoAndInsuranceExpiryDatecel = new PdfPCell(InsurancePolicyNoAndInsuranceExpiryDatePhras);
			InsurancePolicyNoAndInsuranceExpiryDatecel.setBorder(Rectangle.NO_BORDER);
			InsurancePolicyNoAndInsuranceExpiryDate.addCell(InsurancePolicyNoAndInsuranceExpiryDatecel); 

			InsurancePolicyNoAndInsuranceExpiryDatePhras=new Phrase(InsuranceExpiryDate,new Font(baseFont, 9, Font.NORMAL));
			InsurancePolicyNoAndInsuranceExpiryDatecel = new PdfPCell(InsurancePolicyNoAndInsuranceExpiryDatePhras);
			InsurancePolicyNoAndInsuranceExpiryDatecel.setBorder(Rectangle.NO_BORDER);
			InsurancePolicyNoAndInsuranceExpiryDate.addCell(InsurancePolicyNoAndInsuranceExpiryDatecel); 
		} catch (Exception e) {
			e.printStackTrace();
		}
		return InsurancePolicyNoAndInsuranceExpiryDate;
	}
	private PdfPTable createVehicleCarriageAndEpicDetails(
			String carriageCapacity, String epicNumber) {
		float[] carwidths = {60,30,40,40,40};
		PdfPTable carriageAndEpicTable=new PdfPTable(5);
		try {
			carriageAndEpicTable.setWidthPercentage(100.0f);
			//carriageAndEpicTable.getDefaultCell().setBorderWidthBottom(1f);
			carriageAndEpicTable.setWidths(carwidths);
			
			Phrase carriageAndEpicPhras=new Phrase("Carriage Capacity (in Kgs):",new Font(baseFont, 9, Font.NORMAL));
			PdfPCell carriageAndEpiccel = new PdfPCell(carriageAndEpicPhras);
			carriageAndEpiccel.setBorder(Rectangle.NO_BORDER);
			carriageAndEpicTable.addCell(carriageAndEpiccel);

			carriageAndEpicPhras=new Phrase(carriageCapacity,new Font(baseFont, 9, Font.NORMAL));
			carriageAndEpiccel = new PdfPCell(carriageAndEpicPhras);
			carriageAndEpiccel.setBorder(Rectangle.NO_BORDER);
			carriageAndEpicTable.addCell(carriageAndEpiccel); 

			carriageAndEpicPhras=new Phrase("",new Font(baseFont, 10, Font.NORMAL));
			carriageAndEpiccel = new PdfPCell(carriageAndEpicPhras);
			carriageAndEpiccel.setBorder(Rectangle.NO_BORDER);
			carriageAndEpicTable.addCell(carriageAndEpiccel); 

			carriageAndEpicPhras=new Phrase("EPIC Number :",new Font(baseFont, 9, Font.NORMAL));
			carriageAndEpiccel = new PdfPCell(carriageAndEpicPhras);
			carriageAndEpiccel.setBorder(Rectangle.NO_BORDER);
			carriageAndEpicTable.addCell(carriageAndEpiccel); 

			carriageAndEpicPhras=new Phrase(epicNumber,new Font(baseFont, 9, Font.NORMAL));
			carriageAndEpiccel = new PdfPCell(carriageAndEpicPhras);
			carriageAndEpiccel.setBorder(Rectangle.NO_BORDER);
			carriageAndEpicTable.addCell(carriageAndEpiccel); 
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Inside carriage capacity and Epic Number");
		}
		return carriageAndEpicTable;
	}
	
	private PdfPTable createvehicleChassisAndPanDetails(String chassisNo,
			String panNumber) {
		//--------------------------chasis and pan---------------------------------------//
		float[] chaswidths = {60,30,40,40,40};
		PdfPTable chassisNoAndPanTable=new PdfPTable(5);
		try {
			chassisNoAndPanTable.setWidthPercentage(100.0f);
			//chassisNoAndPanTable.getDefaultCell().setBorderWidthBottom(1f);
			chassisNoAndPanTable.setWidths(chaswidths);
			
			Phrase chassisNoAndPanPhras=new Phrase("Chassis Number :",new Font(baseFont, 9, Font.NORMAL));
			PdfPCell chassisNoAndPancel = new PdfPCell(chassisNoAndPanPhras);
			chassisNoAndPancel.setBorder(Rectangle.NO_BORDER);
			chassisNoAndPanTable.addCell(chassisNoAndPancel);

			chassisNoAndPanPhras=new Phrase(chassisNo,new Font(baseFont, 9, Font.NORMAL));
			chassisNoAndPancel = new PdfPCell(chassisNoAndPanPhras);
			chassisNoAndPancel.setBorder(Rectangle.NO_BORDER);
			chassisNoAndPanTable.addCell(chassisNoAndPancel); 

			chassisNoAndPanPhras=new Phrase("",new Font(baseFont, 10, Font.NORMAL));
			chassisNoAndPancel = new PdfPCell(chassisNoAndPanPhras);
			chassisNoAndPancel.setBorder(Rectangle.NO_BORDER);
			chassisNoAndPanTable.addCell(chassisNoAndPancel); 

			chassisNoAndPanPhras=new Phrase("PAN number :",new Font(baseFont, 9, Font.NORMAL));
			chassisNoAndPancel = new PdfPCell(chassisNoAndPanPhras);
			chassisNoAndPancel.setBorder(Rectangle.NO_BORDER);
			chassisNoAndPanTable.addCell(chassisNoAndPancel); 

			chassisNoAndPanPhras=new Phrase(panNumber,new Font(baseFont, 9, Font.NORMAL));
			chassisNoAndPancel = new PdfPCell(chassisNoAndPanPhras);
			chassisNoAndPancel.setBorder(Rectangle.NO_BORDER);
			chassisNoAndPanTable.addCell(chassisNoAndPancel); 
		} catch (Exception e) {
			e.printStackTrace();
		}
		return chassisNoAndPanTable;
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
	private void printBill(ServletOutputStream servletOutputStream,
			HttpServletResponse resp, String bill, String pdfFileName) {
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
