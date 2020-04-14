package t4u.ironMining;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.functions.AdminFunctions;
import t4u.functions.CommonFunctions;
import t4u.functions.IronMiningFunction;

import com.itextpdf.text.Element;
import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.Barcode128;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

@SuppressWarnings("serial")
public class PdfForTripSheet extends HttpServlet{
	static BaseFont baseFont = null;
	CommonFunctions cf= new CommonFunctions();
	IronMiningFunction ironfuc=new IronMiningFunction();
	
	/*pdf gereration code written by santhosh*/
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)throws ServletException, IOException {
    	HttpSession session = req.getSession();
        String param = "";
        String zone = "";
        int systemid = 0;
        int userId = 0;
        int offset = 0;
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        AdminFunctions adfunc = new AdminFunctions();
        systemid = loginInfo.getSystemId();
        zone = loginInfo.getZone();
        userId = loginInfo.getUserId();
        offset = loginInfo.getOffsetMinutes();
        String lang = loginInfo.getLanguage();
        String ltspName = loginInfo.getSystemName();
        String userName = loginInfo.getUserName();
        String category = loginInfo.getCategory();
        String categoryType = loginInfo.getCategoryType();

		ArrayList<ArrayList<String>> printDetails = null;
		ArrayList<String> assetEnrollmentDetails = null;
		String TripSheetNumber ="";
		String vehicleNumber ="";
		String validityDate = "";
		String leaseNo ="";
		String quantity ="";
		String grade ="";
		String route ="";
		String minerals="";
		String distance ="";
		String source="";
		String destination="";
		String sourceHub="";
		String destHub="";
		String tareWeight="";
		String totalQty="";
		String issueDate="";
		String dsSource = ""; 
		String dsDestination = ""; 
		String transactionId="";
		String weighbrideId="";
		String gstNo="";
		try {
			
			int systemId = Integer.parseInt(req.getParameter("systemId"));
			int clientId =  Integer.parseInt(req.getParameter("clientId"));
			String vehicleNo=req.getParameter("vehicleNo");
			String CustomerName=req.getParameter("clientName");
			String buttonValue=req.getParameter("buttonValue");
			String uniqueId=req.getParameter("uniqueId");
			
			ServletOutputStream servletOutputStream = resp.getOutputStream();
			Properties properties = ApplicationListener.prop;
			String billpath=  properties.getProperty("Builtypath");
			refreshdir(billpath);
			String pdfFileName="TripSheet_"+uniqueId;
			String fontPath = properties.getProperty("FontPathForMaplePDF");
			baseFont = BaseFont.createFont(fontPath, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
			String bill = billpath+ pdfFileName + ".pdf";

			FileOutputStream fileOut = new FileOutputStream(bill);
			Document document = new Document(PageSize.A4.rotate(), 20, 20, 20, 20);
			PdfWriter writer = PdfWriter.getInstance(document,fileOut);
			writer.setEncryption(null,null,PdfWriter.AllowPrinting,PdfWriter.ENCRYPTION_AES_128);//This line is for avoid editting the PDF 
			document.open();
			PdfContentByte canvas = writer.getDirectContent();
		
			
			printDetails=ironfuc.getPrintTripSheet(systemId,clientId,vehicleNo,CustomerName,buttonValue,uniqueId,zone);
			
			assetEnrollmentDetails=printDetails.get(0);
			if(!assetEnrollmentDetails.isEmpty())
			{
				TripSheetNumber =assetEnrollmentDetails.get(0);
				validityDate = assetEnrollmentDetails.get(1);
				vehicleNumber =assetEnrollmentDetails.get(2);
				leaseNo=assetEnrollmentDetails.get(3);
				quantity =assetEnrollmentDetails.get(4);
				grade =assetEnrollmentDetails.get(5);
				route =assetEnrollmentDetails.get(6);
			//	minerals =assetEnrollmentDetails.get(7);
				distance=assetEnrollmentDetails.get(7);
				source=assetEnrollmentDetails.get(8);
				destination=assetEnrollmentDetails.get(9);
				sourceHub=assetEnrollmentDetails.get(10);
				destHub=assetEnrollmentDetails.get(11);
				tareWeight=assetEnrollmentDetails.get(12);
				totalQty=assetEnrollmentDetails.get(13);
				issueDate=assetEnrollmentDetails.get(14);
				dsSource=assetEnrollmentDetails.get(15);
				dsDestination=assetEnrollmentDetails.get(16);
				transactionId=assetEnrollmentDetails.get(17);
				weighbrideId=assetEnrollmentDetails.get(18);
				gstNo=assetEnrollmentDetails.get(19);
			}
			String data = TripSheetNumber + Barcode128.FNC1;
			//----------bar code------------------//
			  /*Create a Barcode image pass below parameter with matched data types
			  Implements the code 128 and UCC/EAN-128. Other symbologies are allowed in raw mode.
			  The code types allowed are:
			  CODE128 - plain barcode 128.
			  CODE128_UCC - support for UCC/EAN-128 with a full list of AI.
			  CODE128_RAW - raw mode. The code attribute has the actual codes from 0 to 105 followed by '\uffff' and the human readable text.
			  
			  The default parameters are:
			   1.X(0.75f);
			   2.N(1.5f);
			   3.ChecksumText(true);
			   4.GenerateChecksum(true);
			   5.Size(5f);
			   6.setBaseline(10f);
			   7.setCode(Passed your data String here);
			   8.BarHeight(20f);*/
			   
			   Image code128Image=cf.getBarCode(0.75f,1.5f,true,true ,5f, 10f, data,20f,canvas); 
			//-----------------------------------------------//	
			//-------------------date format for QRCode------------//
			   
			SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
			SimpleDateFormat ss = new SimpleDateFormat("dd-MM-yyyy");
			String hours="";
			Date ValidFieldDates=null;
			String ValidFieldDate="";
			if(validityDate!=""){
				Date vdate=dateFormat.parse(validityDate);
				String validDate=dateFormat.format(vdate);
				
				String[] values = validDate.split(" ");
		        String date = values[0];
		        hours = values[1];
		        ValidFieldDates=ss.parse(date);
		        ValidFieldDate =new SimpleDateFormat("dd-MMM-yy").format(ValidFieldDates);
			}
			
			//---------------QR Code-----------------//
			String EnrollNocode ="TRIPSHEETNO:"+TripSheetNumber+"|";
			String ownerNamecode="OWNER:"+leaseNo+"|";
			String regNocode ="REGNO:"+vehicleNumber+"|";
			String QTY="QTY:"+ String.valueOf(totalQty).split("\\.")[0]+"kgs"+"|";
			String routes="ROUTE:"+route+"|";
			String distances="DISTANCE:"+distance+"kms"+"|";
		    String Materials ="MATERIALS: Fe"+grade+"|";
			String validUpto= "VALIDUPTO:"+hours+"Hoursof:"+ValidFieldDate+"|";
			String routeSource="SOURCE:"+source+"|";
			String routeDestination="DESTINATION:"+destination+"|";
        	String Note="For more information please visit"+"\n"+"http://goadmg.gov.in";
        	String QRdata = String.format("%s%n%s%n%s%n%s%n%s%n%s%n%s%n%s%n%s%n%s%n%s%n", EnrollNocode,ownerNamecode,regNocode,QTY,routes,distances,Materials,routeSource,validUpto,routeDestination,Note);
        	Image finalQRImage=cf.getQrCode(QRdata, 50, 50);
			
			generateTripSheet(document,bill,systemId,clientId,TripSheetNumber,validityDate,vehicleNumber,leaseNo,
					quantity,grade,route,distance,source,destination,ValidFieldDate,hours,code128Image,finalQRImage,sourceHub,destHub,tareWeight,totalQty,issueDate,dsSource,dsDestination,transactionId,weighbrideId,gstNo);
			document.close();
			printBill(servletOutputStream, resp, bill, pdfFileName);
		} catch (DocumentException e) {
			e.printStackTrace();
		} catch (IOException e) {
            e.printStackTrace();
        } catch (ParseException e) {
			e.printStackTrace();
		}
	}
	private void generateTripSheet(Document document, String bill, int systemId,
			int clientId, String TripSheetNumber, String validityDate,
			String vehicleNumber,String leaseNo, String quantity, String grade,
			String route,String distance,String source,String destination,String ValidFieldDate,String hours,Image barImage,Image finalQRImage,String sourceHub,String destHub,
			String tareWeight,String totalQty,String issueDate,String dsSource,String dsDestination,String transactionId,String weighbrideId,String gstNo) {
			try {
				
				PdfPTable tab= new PdfPTable(2);
				float[] tabCount = {7.2f,2.8f};
				tab.setWidthPercentage(100.0f);
				tab.setWidths(tabCount);
				
				PdfPTable tab1= new PdfPTable(1);
				float[] tab1Count = {1};
				tab1.setWidthPercentage(100.0f);
				tab1.setWidths(tab1Count);
		
				PdfPCell c1=new PdfPCell(createLogoHeader(vehicleNumber,leaseNo));
				c1.setBorder(Rectangle.NO_BORDER);
				tab1.addCell(c1);
				
				PdfPCell c2=new PdfPCell(createHeader(barImage,TripSheetNumber));
				c2.setBorder(Rectangle.NO_BORDER);
				tab1.addCell(c2);
				
				PdfPCell c3=new PdfPCell(createTripNoTable(TripSheetNumber,quantity,tareWeight,totalQty,transactionId,weighbrideId,gstNo));
				c3.setBorder(Rectangle.NO_BORDER);
				tab1.addCell(c3);
				
				PdfPCell c4=new PdfPCell(createRouteDetailsTable(route,distance,grade));
				c4.setBorder(Rectangle.NO_BORDER);
				tab1.addCell(c4);
				
				PdfPCell c5=new PdfPCell(createValidUptoDetailsTable(ValidFieldDate,hours));
				c5.setBorder(Rectangle.NO_BORDER);
				tab1.addCell(c5);
				
				PdfPCell c6=new PdfPCell(createBoldDetailsTable(source,destination));
				c6.setBorder(Rectangle.NO_BORDER);
				tab1.addCell(c6);
				
				PdfPCell c7=new PdfPCell(createBoldDetailsTable1(dsSource,dsDestination));
				c7.setBorder(Rectangle.NO_BORDER);
				tab1.addCell(c7);
				
				PdfPCell c8=new PdfPCell(createSignDetailsTable(issueDate,finalQRImage));
				c8.setBorder(Rectangle.NO_BORDER);
				tab1.addCell(c8);
				
				PdfPCell tab1Cell=new PdfPCell(tab1);
				tab1Cell.setBorder(Rectangle.NO_BORDER);
				tab1Cell.setPaddingRight(20f);
				
				PdfPCell tab2Cell=new PdfPCell(createTearBillTable(vehicleNumber,TripSheetNumber,tareWeight,quantity,totalQty,grade,issueDate,finalQRImage));
				tab2Cell.setBorder(Rectangle.BOX);
				
				PdfPCell tab3Cell=new PdfPCell();
				tab3Cell.setBorder(Rectangle.BOX);
				tab3Cell.enableBorderSide(Rectangle.RIGHT);
				
				tab.addCell(tab1Cell);
				tab.addCell(tab2Cell);
				document.add(tab);
				
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("Inside generatetripsheet function.."+e.toString());
			}	
	}
	
	private PdfPTable createLogoHeader(String regno,String ownerName) {
		float[] widthsLogo = {2,60,60,60,2};
		PdfPTable logoTable = new PdfPTable(5);
		try {
			String path = getServletContext().getRealPath("/")+"Main/modules/ironMining/images/dmgLogo.png";
			Image headimg2 = Image.getInstance(path);
			headimg2.scaleToFit(1800, 52);
			headimg2.setRotationDegrees(0);
			
			logoTable.setWidthPercentage(100.0f);
			logoTable.setWidths(widthsLogo);

			Phrase logomyPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			PdfPCell logoCel = new PdfPCell(logomyPhrase);
			logoCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			logoCel.enableBorderSide(Rectangle.TOP);
			logoCel.enableBorderSide(Rectangle.LEFT);
			logoCel.enableBorderSide(Rectangle.BOTTOM);
			logoCel.disableBorderSide(Rectangle.RIGHT);
			logoTable.addCell(logoCel);

			logomyPhrase=new Phrase(ownerName,new Font(baseFont, 15, Font.NORMAL));
			logoCel = new PdfPCell(logomyPhrase);
			logoCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			logoCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			logoCel.disableBorderSide(Rectangle.LEFT);
			logoTable.addCell(logoCel);

			logomyPhrase=new Phrase("",new Font(baseFont, 10, Font.NORMAL));
			logomyPhrase.add(new Chunk(headimg2, 0, 0));
			logoCel = new PdfPCell(logomyPhrase);
			logoCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			logoCel.setBorder(Rectangle.NO_BORDER);
			logoCel.enableBorderSide(Rectangle.TOP);
			logoCel.disableBorderSide(Rectangle.BOTTOM);
			logoTable.addCell(logoCel);

			logomyPhrase=new Phrase(regno,new Font(baseFont, 15, Font.BOLD));
			logoCel = new PdfPCell(logomyPhrase);
			logoCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			logoCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			logoCel.enableBorderSide(Rectangle.LEFT);
			logoCel.disableBorderSide(Rectangle.RIGHT);
			logoTable.addCell(logoCel);
			
			logomyPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			logoCel = new PdfPCell(logomyPhrase);
			logoCel.disableBorderSide(Rectangle.LEFT);
			logoCel.enableBorderSide(Rectangle.TOP);
			logoCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			logoCel.enableBorderSide(Rectangle.RIGHT);
			logoTable.addCell(logoCel);
			
			} catch (Exception e) {
			e.printStackTrace();
		}
		return logoTable;
	}
			
	private PdfPTable createHeader(Image baCodeImage,String tripsheetNo) {
		float[] widths = {2,60,60,60,2};
		PdfPTable t1 = new PdfPTable(5);
		String headerTrip="TRIP SHEET";
		if(tripsheetNo.contains("E-AUCTION")){
			headerTrip="E-AUCTION TRIP SHEET";
		}
		try {
			
			t1.setWidthPercentage(100.0f);
			t1.setWidths(widths);
//--------------------------------------------------------------------------//
			Phrase myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase);
			c1.enableBorderSide(Rectangle.LEFT);
			c1.disableBorderSide(Rectangle.TOP);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.disableBorderSide(Rectangle.RIGHT);
			c1.disableBorderSide(Rectangle.BOTTOM);
			t1.addCell(c1);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.disableBorderSide(Rectangle.LEFT);
			t1.addCell(c1);

			myPhrase=new Phrase("Government of Goa",new Font(baseFont, 10, Font.NORMAL));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			t1.addCell(c1);

			myPhrase=new Phrase("",new Font(baseFont, 8, Font.BOLD));
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
			c1.enableBorderSide(Rectangle.RIGHT);
			t1.addCell(c1);

//--------------------------------------------------------------------//
			myPhrase=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.disableBorderSide(Rectangle.TOP);
			c1.enableBorderSide(Rectangle.LEFT);
			c1.disableBorderSide(Rectangle.BOTTOM);
			c1.disableBorderSide(Rectangle.RIGHT);
			t1.addCell(c1);
			
			myPhrase=new Phrase("",new Font(baseFont, 9, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.disableBorderSide(Rectangle.RIGHT);
			t1.addCell(c1);
			
			myPhrase=new Phrase("Directorate of Mines & Geology",new Font(baseFont, 10, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.disableBorderSide(Rectangle.LEFT);
			c1.disableBorderSide(Rectangle.BOTTOM);
			t1.addCell(c1);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.disableBorderSide(Rectangle.BOTTOM);
			t1.addCell(c1);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.disableBorderSide(Rectangle.BOTTOM);
			c1.enableBorderSide(Rectangle.RIGHT);
			t1.addCell(c1);
			
			//--------------------------------------------------------------------//
			myPhrase=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.disableBorderSide(Rectangle.TOP);
			c1.enableBorderSide(Rectangle.LEFT);
			c1.disableBorderSide(Rectangle.BOTTOM);
			c1.disableBorderSide(Rectangle.RIGHT);
			t1.addCell(c1);
			
			myPhrase=new Phrase("",new Font(baseFont, 9, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Element.ALIGN_LEFT);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.addElement(baCodeImage);
			c1.disableBorderSide(Rectangle.RIGHT);
			t1.addCell(c1);
			
			myPhrase=new Phrase(headerTrip,new Font(baseFont, 15, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setVerticalAlignment(Element.ALIGN_MIDDLE);
			c1.setHorizontalAlignment(Element.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.disableBorderSide(Rectangle.LEFT);
			c1.disableBorderSide(Rectangle.BOTTOM);
			t1.addCell(c1);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.disableBorderSide(Rectangle.BOTTOM);
			t1.addCell(c1);

			myPhrase=new Phrase("",new Font(baseFont, 6, Font.BOLD));
			c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.enableBorderSide(Rectangle.RIGHT);
			c1.disableBorderSide(Rectangle.BOTTOM);
			t1.addCell(c1);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return t1;
	}
	private PdfPTable createTripNoTable(String enrollNo,String qty,String tareWeight,String totalQty,String transactionId,String weighbrideId,String gstNo) {
        float[] widthtripNo = {20,60,18,19,16,50};
		PdfPTable tripNoTable=new PdfPTable(6);
		if(transactionId.equals("NA")){
			transactionId="";
		}
		try {
			tripNoTable.setWidthPercentage(100.0f);
			tripNoTable.setWidths(widthtripNo);
			
			Phrase tripNoMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
		    PdfPCell tripNoCel = new PdfPCell(tripNoMyPhras);
		    tripNoCel.enableBorderSide(Rectangle.TOP);
			tripNoCel.enableBorderSide(Rectangle.LEFT);
			tripNoCel.disableBorderSide(Rectangle.BOTTOM);
			tripNoCel.disableBorderSide(Rectangle.RIGHT);
			tripNoTable.addCell(tripNoCel);

			tripNoMyPhras=new Phrase("     "+gstNo,new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.disableBorderSide(Rectangle.LEFT);
			tripNoCel.disableBorderSide(Rectangle.BOTTOM);
			tripNoCel.disableBorderSide(Rectangle.RIGHT);
			tripNoTable.addCell(tripNoCel);

			tripNoMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.disableBorderSide(Rectangle.LEFT);
			tripNoCel.disableBorderSide(Rectangle.BOTTOM);
			tripNoCel.disableBorderSide(Rectangle.RIGHT);
			tripNoTable.addCell(tripNoCel);
			
			tripNoMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.disableBorderSide(Rectangle.LEFT);
			tripNoCel.disableBorderSide(Rectangle.BOTTOM);
			tripNoTable.addCell(tripNoCel);
			
			tripNoMyPhras=new Phrase("Gross weight",new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.enableBorderSide(Rectangle.LEFT);
			tripNoCel.enableBorderSide(Rectangle.BOTTOM);
			tripNoCel.enableBorderSide(Rectangle.TOP);
			tripNoCel.enableBorderSide(Rectangle.RIGHT);
			tripNoCel.enableBorderSide(Rectangle.BOTTOM);
			tripNoCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			tripNoTable.addCell(tripNoCel);

			tripNoMyPhras=new Phrase(qty+" Kgs",new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.enableBorderSide(Rectangle.LEFT);
			tripNoCel.enableBorderSide(Rectangle.BOTTOM);
			tripNoCel.enableBorderSide(Rectangle.TOP);
			tripNoCel.enableBorderSide(Rectangle.RIGHT);
			tripNoCel.enableBorderSide(Rectangle.BOTTOM);
			tripNoCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			tripNoTable.addCell(tripNoCel);
	//-----------------------------------------------------------------------------------//
			tripNoMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.enableBorderSide(Rectangle.LEFT);
			tripNoCel.disableBorderSide(Rectangle.BOTTOM);
			//tripNoCel.disableBorderSide(Rectangle.TOP);
			tripNoCel.disableBorderSide(Rectangle.RIGHT);
			tripNoTable.addCell(tripNoCel);

			tripNoMyPhras=new Phrase(enrollNo,new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.disableBorderSide(Rectangle.LEFT);
			tripNoCel.disableBorderSide(Rectangle.BOTTOM);
			//tripNoCel.setBorder(Rectangle.NO_BORDER);
			tripNoCel.disableBorderSide(Rectangle.RIGHT);
			tripNoCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			tripNoTable.addCell(tripNoCel);

			tripNoMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			//tripNoCel.disableBorderSide(Rectangle.TOP);
			tripNoCel.disableBorderSide(Rectangle.LEFT);
			tripNoCel.disableBorderSide(Rectangle.BOTTOM);
			tripNoCel.disableBorderSide(Rectangle.RIGHT);
			tripNoTable.addCell(tripNoCel);
			
			tripNoMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			//tripNoCel.disableBorderSide(Rectangle.TOP);
			tripNoCel.disableBorderSide(Rectangle.LEFT);
			tripNoCel.disableBorderSide(Rectangle.BOTTOM);
			tripNoTable.addCell(tripNoCel);
			
		    tripNoMyPhras=new Phrase("Tare weight",new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.enableBorderSide(Rectangle.LEFT);
			tripNoCel.enableBorderSide(Rectangle.BOTTOM);
			tripNoCel.enableBorderSide(Rectangle.TOP);
			tripNoCel.enableBorderSide(Rectangle.RIGHT);
			tripNoCel.enableBorderSide(Rectangle.BOTTOM);
			tripNoCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			tripNoTable.addCell(tripNoCel);

			tripNoMyPhras=new Phrase(tareWeight+" Kgs",new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.enableBorderSide(Rectangle.LEFT);
			tripNoCel.enableBorderSide(Rectangle.BOTTOM);
			tripNoCel.enableBorderSide(Rectangle.TOP);
			tripNoCel.enableBorderSide(Rectangle.RIGHT);
			tripNoCel.enableBorderSide(Rectangle.BOTTOM);
			tripNoCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			tripNoTable.addCell(tripNoCel);
			//-----------------------------empty---------------------------//
			tripNoMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.enableBorderSide(Rectangle.LEFT);
			tripNoCel.disableBorderSide(Rectangle.BOTTOM);
			tripNoCel.enableBorderSide(Rectangle.TOP);
			tripNoCel.disableBorderSide(Rectangle.RIGHT);
			tripNoCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			tripNoCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			tripNoTable.addCell(tripNoCel);

			tripNoMyPhras=new Phrase(weighbrideId,new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.disableBorderSide(Rectangle.LEFT);
			tripNoCel.disableBorderSide(Rectangle.BOTTOM);
			tripNoCel.enableBorderSide(Rectangle.TOP);
			tripNoCel.disableBorderSide(Rectangle.RIGHT);
			tripNoCel.setVerticalAlignment(Element.ALIGN_BOTTOM);
			tripNoCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			tripNoTable.addCell(tripNoCel);

			tripNoMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.enableBorderSide(Rectangle.TOP);
			tripNoCel.disableBorderSide(Rectangle.LEFT);
			tripNoCel.disableBorderSide(Rectangle.BOTTOM);
			tripNoCel.disableBorderSide(Rectangle.RIGHT);
			tripNoCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			tripNoCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			tripNoTable.addCell(tripNoCel);
			
			tripNoMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.enableBorderSide(Rectangle.TOP);
			tripNoCel.disableBorderSide(Rectangle.LEFT);
			tripNoCel.disableBorderSide(Rectangle.BOTTOM);
			tripNoCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			tripNoCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			tripNoTable.addCell(tripNoCel);
			
		    tripNoMyPhras=new Phrase("QTY :",new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.disableBorderSide(Rectangle.TOP);
			tripNoCel.disableBorderSide(Rectangle.BOTTOM);
			tripNoCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			tripNoCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			tripNoCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			tripNoTable.addCell(tripNoCel);

			tripNoMyPhras=new Phrase(totalQty+" Kgs",new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.disableBorderSide(Rectangle.TOP);
			tripNoCel.disableBorderSide(Rectangle.BOTTOM);
			tripNoCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			tripNoCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			tripNoTable.addCell(tripNoCel);
	//----------------------------------------------------------------------------------------//	
			tripNoMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
		    tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.enableBorderSide(Rectangle.LEFT);
			tripNoCel.disableBorderSide(Rectangle.TOP);
			tripNoCel.enableBorderSide(Rectangle.BOTTOM);
			tripNoCel.disableBorderSide(Rectangle.RIGHT);
			tripNoTable.addCell(tripNoCel);

			tripNoMyPhras=new Phrase(" ",new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.disableBorderSide(Rectangle.LEFT);
			tripNoCel.disableBorderSide(Rectangle.TOP);
			tripNoCel.enableBorderSide(Rectangle.BOTTOM);
			tripNoCel.disableBorderSide(Rectangle.RIGHT);
			tripNoTable.addCell(tripNoCel);

			tripNoMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.disableBorderSide(Rectangle.TOP);
			tripNoCel.disableBorderSide(Rectangle.LEFT);
			tripNoCel.disableBorderSide(Rectangle.RIGHT);
			tripNoTable.addCell(tripNoCel);
			
			tripNoMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.disableBorderSide(Rectangle.TOP);
			tripNoCel.disableBorderSide(Rectangle.LEFT);
			tripNoTable.addCell(tripNoCel);
			
			tripNoMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.disableBorderSide(Rectangle.TOP);
			tripNoCel.enableBorderSide(Rectangle.BOTTOM);
			tripNoTable.addCell(tripNoCel);

			tripNoMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.disableBorderSide(Rectangle.TOP);
			tripNoCel.enableBorderSide(Rectangle.BOTTOM);
			tripNoTable.addCell(tripNoCel);
		} catch (Exception e) {
			e.printStackTrace();
	  }
		return tripNoTable;
	}
	
	private PdfPTable createRouteDetailsTable(String route,String distance,String grade) {
        float[] widthRouteDetails = {15,60,18,19,16,50};
		PdfPTable routeDetailsTable=new PdfPTable(6);
		String GRADE="";
		if(grade.equalsIgnoreCase("NA")){
			GRADE=grade;
		}else{
			GRADE="Fe:"+grade;
		}
		try {
			routeDetailsTable.setWidthPercentage(100.0f);
			routeDetailsTable.setWidths(widthRouteDetails);
			
			Phrase routeDetailsMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
		    PdfPCell routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
		    routeDetailsCel.enableBorderSide(Rectangle.TOP);
			routeDetailsCel.enableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.disableBorderSide(Rectangle.RIGHT);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.enableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.disableBorderSide(Rectangle.RIGHT);
			routeDetailsTable.addCell(routeDetailsCel);
			
			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.enableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsTable.addCell(routeDetailsCel);
			
			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsTable.addCell(routeDetailsCel);
	//----------------------------------------------------------------------//
			/*//--------------------empty row-------------------//
			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.enableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			//routeDetailsCel.disableBorderSide(Rectangle.RIGHT);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase(" ",new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.setBorder(Rectangle.NO_BORDER);
			routeDetailsCel.disableBorderSide(Rectangle.RIGHT);
			routeDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			routeDetailsCel.enableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.disableBorderSide(Rectangle.RIGHT);
			//routeDetailsCel.setBorder(Rectangle.NO_BORDER);
			routeDetailsTable.addCell(routeDetailsCel);
			
			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			routeDetailsCel.enableBorderSide(Rectangle.LEFT);
			routeDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			//routeDetailsCel.setBorder(Rectangle.NO_BORDER);
			routeDetailsTable.addCell(routeDetailsCel);
			
		    routeDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			routeDetailsTable.addCell(routeDetailsCel);*/
			//------------------------end-------------------------------------//
			routeDetailsMyPhras=new Phrase("Route :",new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.enableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			routeDetailsCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			//routeDetailsCel.disableBorderSide(Rectangle.RIGHT);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase(route,new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.setBorder(Rectangle.NO_BORDER);
			routeDetailsCel.disableBorderSide(Rectangle.RIGHT);
			routeDetailsCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			routeDetailsCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase("Distance:",new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			routeDetailsCel.enableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.disableBorderSide(Rectangle.RIGHT);
			routeDetailsCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			routeDetailsCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			//routeDetailsCel.setBorder(Rectangle.NO_BORDER);
			routeDetailsTable.addCell(routeDetailsCel);
			
			routeDetailsMyPhras=new Phrase(distance+" Kms",new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			routeDetailsCel.enableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			routeDetailsCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			//routeDetailsCel.setBorder(Rectangle.NO_BORDER);
			routeDetailsTable.addCell(routeDetailsCel);
			
		    routeDetailsMyPhras=new Phrase("MATL:",new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			routeDetailsCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase(GRADE,new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			routeDetailsCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			routeDetailsTable.addCell(routeDetailsCel);
			//--------------------empty row-------------------//
			/*routeDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.enableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			//routeDetailsCel.disableBorderSide(Rectangle.RIGHT);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase(" ",new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.setBorder(Rectangle.NO_BORDER);
			routeDetailsCel.disableBorderSide(Rectangle.RIGHT);
			routeDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			routeDetailsCel.enableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.disableBorderSide(Rectangle.RIGHT);
			//routeDetailsCel.setBorder(Rectangle.NO_BORDER);
			routeDetailsTable.addCell(routeDetailsCel);
			
			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			routeDetailsCel.enableBorderSide(Rectangle.LEFT);
			routeDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			//routeDetailsCel.setBorder(Rectangle.NO_BORDER);
			routeDetailsTable.addCell(routeDetailsCel);
			
		    routeDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			routeDetailsTable.addCell(routeDetailsCel);*/
			//------------------------end-------------------------------------//
		//---------------------------------------------------------------------------------//	
//			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
//		    routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
//			routeDetailsCel.enableBorderSide(Rectangle.LEFT);
//			routeDetailsCel.disableBorderSide(Rectangle.TOP);
//			routeDetailsCel.enableBorderSide(Rectangle.BOTTOM);
//			//routeDetailsCel.disableBorderSide(Rectangle.RIGHT);
//			routeDetailsTable.addCell(routeDetailsCel);
//
//			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
//			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
//			routeDetailsCel.disableBorderSide(Rectangle.LEFT);
//			routeDetailsCel.disableBorderSide(Rectangle.TOP);
//			routeDetailsCel.enableBorderSide(Rectangle.BOTTOM);
//			routeDetailsCel.disableBorderSide(Rectangle.RIGHT);
//			routeDetailsTable.addCell(routeDetailsCel);
//
//			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
//			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
//			routeDetailsCel.disableBorderSide(Rectangle.TOP);
//			routeDetailsCel.enableBorderSide(Rectangle.LEFT);
//			routeDetailsCel.disableBorderSide(Rectangle.RIGHT);
//			routeDetailsTable.addCell(routeDetailsCel);
//			
//			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
//			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
//			routeDetailsCel.disableBorderSide(Rectangle.TOP);
//			routeDetailsCel.enableBorderSide(Rectangle.LEFT);
//			routeDetailsTable.addCell(routeDetailsCel);
//			
//			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
//			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
//			routeDetailsCel.disableBorderSide(Rectangle.TOP);
//			routeDetailsCel.enableBorderSide(Rectangle.BOTTOM);
//			routeDetailsTable.addCell(routeDetailsCel);
//
//			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
//			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
//			routeDetailsCel.disableBorderSide(Rectangle.TOP);
//			routeDetailsCel.enableBorderSide(Rectangle.BOTTOM);
//			routeDetailsTable.addCell(routeDetailsCel);
		} catch (Exception e) {
			e.printStackTrace();
	  }
		return routeDetailsTable;
	}
	
    private PdfPTable createValidUptoDetailsTable(String EnrollDate,String hours) {
        float[] widthValidUptoDetails = {25,25,10,25,25};
		PdfPTable ValidUptoDetailsTable=new PdfPTable(5);
		try {
			ValidUptoDetailsTable.setWidthPercentage(100.0f);
			ValidUptoDetailsTable.setWidths(widthValidUptoDetails);
			
			Phrase ValidUptoDetailsMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
		    PdfPCell ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
		    ValidUptoDetailsCel.enableBorderSide(Rectangle.TOP);
			ValidUptoDetailsCel.enableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);

			ValidUptoDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);
			
			ValidUptoDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);
			
			ValidUptoDetailsMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);

			ValidUptoDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);
	//----------------------------------------------------------------------//
			
			ValidUptoDetailsMyPhras=new Phrase("Valid Upto :",new Font(baseFont, 13, Font.NORMAL));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.enableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.TOP);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);

			ValidUptoDetailsMyPhras=new Phrase(hours,new Font(baseFont, 12, Font.BOLD));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsCel.setBorder(Rectangle.NO_BORDER);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);
			
			ValidUptoDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.TOP);
			ValidUptoDetailsCel.enableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsCel.setBorder(Rectangle.NO_BORDER);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);
			
		    ValidUptoDetailsMyPhras=new Phrase("Hours of:",new Font(baseFont, 13, Font.NORMAL));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.TOP);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);

			ValidUptoDetailsMyPhras=new Phrase(EnrollDate,new Font(baseFont, 12, Font.BOLD));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.TOP);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);
		//---------------------------------------------------------------------------------//	
			ValidUptoDetailsMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
		    ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.enableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.TOP);
			ValidUptoDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);

			ValidUptoDetailsMyPhras=new Phrase(" ",new Font(baseFont, 5, Font.BOLD));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.TOP);
			ValidUptoDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);
			
			ValidUptoDetailsMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.TOP);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);
			
			ValidUptoDetailsMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.TOP);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);

			ValidUptoDetailsMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.TOP);
			ValidUptoDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);
		} catch (Exception e) {
			e.printStackTrace();
	  }
		return ValidUptoDetailsTable;
	}
    
    private PdfPTable createBoldDetailsTable(String source,String destination) {
        float[] widthBoldDetails = {40,15,40};
		PdfPTable BoldDetailsTable=new PdfPTable(3);
		try {
			BoldDetailsTable.setWidthPercentage(100.0f);
			BoldDetailsTable.setWidths(widthBoldDetails);
			
			Phrase BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
		    PdfPCell BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
		    BoldDetailsCel.enableBorderSide(Rectangle.TOP);
			BoldDetailsCel.enableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
			BoldDetailsTable.addCell(BoldDetailsCel);

			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsTable.addCell(BoldDetailsCel);

			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsTable.addCell(BoldDetailsCel);
	//----------------------------------------------------------------------//
			
			BoldDetailsTableMyPhras=new Phrase(source,new Font(baseFont, 13, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.enableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
			BoldDetailsTable.addCell(BoldDetailsCel);

			BoldDetailsTableMyPhras=new Phrase("|",new Font(baseFont, 13, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.setBorder(Rectangle.NO_BORDER);
			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
			BoldDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			BoldDetailsTable.addCell(BoldDetailsCel);

			BoldDetailsTableMyPhras=new Phrase(destination,new Font(baseFont, 13, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			BoldDetailsTable.addCell(BoldDetailsCel);
		//---------------------------------------------------------------------------------//	
			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
		    BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.enableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
			BoldDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
			BoldDetailsTable.addCell(BoldDetailsCel);

			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
			BoldDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
			BoldDetailsTable.addCell(BoldDetailsCel);

			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
			BoldDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			BoldDetailsTable.addCell(BoldDetailsCel);
		} catch (Exception e) {
			e.printStackTrace();
	  }
		return BoldDetailsTable;
	}
    
    private PdfPTable createBoldDetailsTable1(String dssource,String dsdestination) {
        float[] widthBoldDetails = {40,15,40};
		PdfPTable BoldDetailsTable=new PdfPTable(3);
		try {
			BoldDetailsTable.setWidthPercentage(100.0f);
			BoldDetailsTable.setWidths(widthBoldDetails);
			if(dssource.equals("NA")){
				dssource="";
			}
			if(dsdestination.equals("NA")){
				dsdestination="";
			}
			
			Phrase BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
		    PdfPCell BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
		    BoldDetailsCel.enableBorderSide(Rectangle.TOP);
			BoldDetailsCel.enableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
			BoldDetailsTable.addCell(BoldDetailsCel);

			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsTable.addCell(BoldDetailsCel);

			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsTable.addCell(BoldDetailsCel);
	//----------------------------------------------------------------------//
			
			BoldDetailsTableMyPhras=new Phrase(dssource,new Font(baseFont, 13, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.enableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
			BoldDetailsTable.addCell(BoldDetailsCel);

			BoldDetailsTableMyPhras=new Phrase("|",new Font(baseFont, 13, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.setBorder(Rectangle.NO_BORDER);
			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
			BoldDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			BoldDetailsTable.addCell(BoldDetailsCel);

			BoldDetailsTableMyPhras=new Phrase(dsdestination,new Font(baseFont, 13, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			BoldDetailsTable.addCell(BoldDetailsCel);
		//---------------------------------------------------------------------------------//	
			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
		    BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.enableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
			BoldDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
			BoldDetailsTable.addCell(BoldDetailsCel);

			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
			BoldDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
			BoldDetailsTable.addCell(BoldDetailsCel);

			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
			BoldDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			BoldDetailsTable.addCell(BoldDetailsCel);
		} catch (Exception e) {
			e.printStackTrace();
	  }
		return BoldDetailsTable;
	}

    
    private PdfPTable createSignDetailsTable(String EnrollDate,Image finalQRImage) {
        float[] widthSignDetails = {25,10,10,25,25};
		PdfPTable SignDetailsTable=new PdfPTable(5);
		try {
			SignDetailsTable.setWidthPercentage(100.0f);
			SignDetailsTable.setWidths(widthSignDetails);
			
			String path = getServletContext().getRealPath("/")+"Main/modules/ironMining/images/authorizedsign.jpg";
			Image imgsign = Image.getInstance(path);
			finalQRImage.scaleToFit(5000, 135);
			
			String pathStap = getServletContext().getRealPath("/")+"Main/modules/ironMining/images/DMG_SEAL.jpg";
			Image imgStamp = Image.getInstance(pathStap);
			imgStamp.scaleToFit(3500, 120);
			
		    Phrase SignDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
		    SignDetailsMyPhras.add(new Chunk(imgStamp, 0, 0));
		    SignDetailsMyPhras.add(EnrollDate);
		    PdfPCell SignDetailsCel = new PdfPCell(SignDetailsMyPhras);
			SignDetailsCel.setVerticalAlignment(Element.ALIGN_BOTTOM);
			SignDetailsCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			SignDetailsCel.enableBorderSide(Rectangle.LEFT);
			SignDetailsCel.enableBorderSide(Rectangle.TOP);
			SignDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			SignDetailsCel.disableBorderSide(Rectangle.RIGHT);
			SignDetailsTable.addCell(SignDetailsCel);

			SignDetailsMyPhras=new Phrase(" ",new Font(baseFont, 10, Font.BOLD));
			SignDetailsCel = new PdfPCell(SignDetailsMyPhras);
			SignDetailsCel.disableBorderSide(Rectangle.LEFT);
			SignDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			SignDetailsCel.disableBorderSide(Rectangle.RIGHT);
			SignDetailsTable.addCell(SignDetailsCel);
			
			SignDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			SignDetailsCel = new PdfPCell(SignDetailsMyPhras);
			SignDetailsCel.disableBorderSide(Rectangle.RIGHT);
			SignDetailsCel.disableBorderSide(Rectangle.LEFT);
			SignDetailsTable.addCell(SignDetailsCel);
			
		    SignDetailsMyPhras=new Phrase("",new Font(baseFont, 18, Font.NORMAL));
			SignDetailsCel = new PdfPCell(SignDetailsMyPhras);
			SignDetailsCel.addElement(imgsign);
			SignDetailsCel.disableBorderSide(Rectangle.LEFT);
			SignDetailsCel.disableBorderSide(Rectangle.RIGHT);
			SignDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			SignDetailsCel.setVerticalAlignment(Element.ALIGN_BOTTOM);
			SignDetailsCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			SignDetailsTable.addCell(SignDetailsCel);

			SignDetailsMyPhras=new Phrase("",new Font(baseFont, 15, Font.BOLD));
			SignDetailsMyPhras.add(new Chunk(finalQRImage, 0, 0));
			//SignDetailsCel.addElement(finalQRImage);
			SignDetailsCel = new PdfPCell(SignDetailsMyPhras);
			SignDetailsCel.enableBorderSide(Rectangle.LEFT);
			SignDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			SignDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			SignDetailsTable.addCell(SignDetailsCel);
		
		} catch (Exception e) {
			e.printStackTrace();
	  }
		return SignDetailsTable;
	}
    private PdfPTable createTearBillTable(String vehicleNumber,String TripSheetNumber,String tareWeight,String quantity,String totalQty,String grade,String EnrollDate,Image finalQRImage) {
        float[] widthSignDetails = {1};
		PdfPTable tearBillTab=new PdfPTable(1);
		try {
			tearBillTab.setWidthPercentage(100.0f);
			tearBillTab.setWidths(widthSignDetails);
			
			String pathStap = getServletContext().getRealPath("/")+"Main/modules/ironMining/images/DMG_SEAL.jpg";
			Image imgStamp = Image.getInstance(pathStap);
			imgStamp.scaleToFit(2000, 120);
			
			Phrase  phras=new Phrase(vehicleNumber,new Font(baseFont, 12, Font.BOLD));
			PdfPCell  cel = new PdfPCell(phras);
			cel.setHorizontalAlignment(Element.ALIGN_CENTER);
			cel.setBorder(Rectangle.NO_BORDER);
			cel.setPaddingTop(30f);
			tearBillTab.addCell(cel);
			
			phras=new Phrase(TripSheetNumber,new Font(baseFont, 12, Font.BOLD));
			cel = new PdfPCell(phras);
			cel.setHorizontalAlignment(Element.ALIGN_CENTER);
			cel.setBorder(Rectangle.NO_BORDER);
			cel.setPaddingTop(25f);
			cel.setPaddingBottom(25f);
			tearBillTab.addCell(cel);
			//--------Table--------//
			PdfPTable tab =new PdfPTable(2);
			float[] tabWidths = {1.3f,3.0f};
			tab.setWidthPercentage(100.0f);
			tab.setWidths(tabWidths);
			String GRADE="";
			if(grade.equalsIgnoreCase("NA")){
				GRADE=grade;
			}else{
				GRADE="Fe:"+grade;
			}
			
			Phrase tabPhras=new Phrase("Gross Weight",new Font(baseFont, 10, Font.BOLD));
			PdfPCell tabCel = new PdfPCell(tabPhras);
			tab.addCell(tabCel);
			
			tabPhras=new Phrase(quantity+" Kgs",new Font(baseFont, 10, Font.BOLD));
			tabCel = new PdfPCell(tabPhras);
			tabCel.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			tabCel.setPaddingRight(50f);
			tab.addCell(tabCel);

			tabPhras=new Phrase("Tare   Weight",new Font(baseFont, 10, Font.BOLD));
			tabCel = new PdfPCell(tabPhras);
			tab.addCell(tabCel);

			tabPhras=new Phrase(tareWeight+" Kgs",new Font(baseFont, 10, Font.BOLD));
			tabCel = new PdfPCell(tabPhras);
			tabCel.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			tabCel.setPaddingRight(50f);
			tab.addCell(tabCel);

			tabPhras=new Phrase("QTY",new Font(baseFont, 11, Font.BOLD));
			tabCel = new PdfPCell(tabPhras);
			
			tab.addCell(tabCel);

			tabPhras=new Phrase(totalQty+" Kgs",new Font(baseFont, 10, Font.BOLD));
			tabCel = new PdfPCell(tabPhras);
			tabCel.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			tabCel.setPaddingRight(50f);
			tab.addCell(tabCel);

			tabPhras=new Phrase("MATL",new Font(baseFont, 10, Font.BOLD));
			tabCel = new PdfPCell(tabPhras);
			tab.addCell(tabCel);
			
			tabPhras=new Phrase(GRADE,new Font(baseFont, 10, Font.BOLD));
			tabCel = new PdfPCell(tabPhras);
			tabCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			tab.addCell(tabCel);
			
			PdfPCell tabCell=new PdfPCell(tab);
			tabCell.setBorder(Rectangle.NO_BORDER);
			tearBillTab.addCell(tabCell);
			//--------Table--------//
			
		    Phrase SignDetailsMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
		    SignDetailsMyPhras.add(new Chunk(imgStamp, 0, 0));
		    SignDetailsMyPhras.add("                 "+EnrollDate);
		    PdfPCell SignDetailsCel = new PdfPCell(SignDetailsMyPhras);
			SignDetailsCel.setVerticalAlignment(Element.ALIGN_BOTTOM);
			SignDetailsCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			SignDetailsCel.setBorder(Rectangle.NO_BORDER);
			tearBillTab.addCell(SignDetailsCel);

		
		} catch (Exception e) {
			e.printStackTrace();
	  }
		return tearBillTab;
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
