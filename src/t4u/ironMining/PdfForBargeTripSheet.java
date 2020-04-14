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
public class PdfForBargeTripSheet extends HttpServlet{
	static BaseFont baseFont = null;
	CommonFunctions cf= new CommonFunctions();
	IronMiningFunction ironfuc=new IronMiningFunction();
	
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)throws ServletException, IOException {
    	HttpSession session = req.getSession();
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        String zone = loginInfo.getZone();
		ArrayList<ArrayList<String>> printDetails = null;
		ArrayList<String> bargeTripsheetDetails = null;
		String vesselDetails = "";
		String gradeDetails = "";
		ArrayList<Object> permitDetails = null;
		String TripSheetNumber ="";
		String vehicleNumber ="";
		String validityDate = "";
		String leaseNo ="";
		String bargeQuantity ="";
		String route ="";
		String source="";
		String destination="";
		String issueDate="";
		String bargeCapacity="";
		String distance="";
		String minerals="";
		String grade="";
		String assetId="";
		String vesselName="";
		String divertedQty="0";
		
		try {
			int uniqueId=Integer.parseInt(req.getParameter("uniqueId"));
			
			ServletOutputStream servletOutputStream = resp.getOutputStream();
			Properties properties = ApplicationListener.prop;
			String billpath=  properties.getProperty("Builtypath");
			refreshdir(billpath);
			String pdfFileName="Barge TripSheet_"+uniqueId;
			String fontPath = properties.getProperty("FontPathForMaplePDF");
			baseFont = BaseFont.createFont(fontPath, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
			String bill = billpath+ pdfFileName + ".pdf";

			FileOutputStream fileOut = new FileOutputStream(bill);
			Document document = new Document(PageSize.A4.rotate(), 40, 40, 40, 30);
			PdfWriter writer = PdfWriter.getInstance(document,fileOut);
			document.open();
			PdfContentByte canvas = writer.getDirectContent();
		
			int systemId = 0;
			int clientId =  0;
			
			
			printDetails=ironfuc.getBargePrintTripSheet(uniqueId,zone);
			permitDetails=ironfuc.getPermit(uniqueId);
			vesselDetails=ironfuc.getVesselName(uniqueId);
			bargeTripsheetDetails=printDetails.get(0);
			if(!bargeTripsheetDetails.isEmpty())
			{
				TripSheetNumber =bargeTripsheetDetails.get(0);
				validityDate = bargeTripsheetDetails.get(1);
				vehicleNumber =bargeTripsheetDetails.get(2);
				leaseNo=bargeTripsheetDetails.get(3);
				bargeQuantity =bargeTripsheetDetails.get(4);
				bargeCapacity=bargeTripsheetDetails.get(5);
				issueDate=bargeTripsheetDetails.get(6);
				route =bargeTripsheetDetails.get(7);
				source=bargeTripsheetDetails.get(8);
				destination=bargeTripsheetDetails.get(9);
				assetId=bargeTripsheetDetails.get(10);
				vesselName=bargeTripsheetDetails.get(11);
				divertedQty=bargeTripsheetDetails.get(12);
				vesselName=vesselName.trim().length()>0 &&!vesselName.equals("NA")?vesselName:"NA";// vesselName+" ("+divertedQty+")"
			}
			String data = TripSheetNumber + Barcode128.FNC1;
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
			String QTY="QTY:"+ String.valueOf(bargeQuantity).split("\\.")[0]+"kgs"+"|";
			String routes="ROUTE:"+route+"|";
			String distances="DISTANCE:"+distance+"kms"+"|";
		    String Materials ="MATERIALS: Fe"+minerals+grade+"|";
			String validUpto= "VALIDUPTO:"+hours+"Hoursof:"+ValidFieldDate+"|";
			String routeSource="SOURCE:"+source+"|";
			String routeDestination="DESTINATION:"+destination+"|";
        	String Note="For more information please visit"+"\n"+"http://goadmg.gov.in";
        	String QRdata = String.format("%s%n%s%n%s%n%s%n%s%n%s%n%s%n%s%n%s%n%s%n%s%n", EnrollNocode,ownerNamecode,regNocode,QTY,routes,distances,Materials,routeSource,validUpto,routeDestination,Note);
        	Image finalQRImage=cf.getQrCode(QRdata, 50, 50);
			
			generateTripSheet(document,bill,systemId,clientId,TripSheetNumber,validityDate,vehicleNumber,leaseNo,
					bargeQuantity,route,source,destination,ValidFieldDate,hours,code128Image,finalQRImage,issueDate,permitDetails,bargeCapacity,vesselName,assetId);
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
	@SuppressWarnings("unchecked")
	private void generateTripSheet(Document document, String bill, int systemId,
			int clientId, String TripSheetNumber, String validityDate,
			String vehicleNumber,String leaseNo, String quantity,
			String route, String source,String destination,String ValidFieldDate,String hours,Image barImage,Image finalQRImage,
			String issueDate,ArrayList<Object> permitDetails,String bargeCapacity,String vesselName,String assetId) {
			try {
						        
				PdfPTable LogoheaderTable=createLogoHeader(vehicleNumber,leaseNo,assetId);
				document.add(LogoheaderTable);
				
				PdfPTable headerTable= createHeader(barImage);
				document.add(headerTable);
				
				PdfPTable tripAndQtyTable=createTripNoTable(TripSheetNumber,quantity,bargeCapacity,route);
				document.add(tripAndQtyTable);
				
				PdfPTable validUpToDetailsTable=createValidUptoDetailsTable(ValidFieldDate,hours,vesselName);
				document.add(validUpToDetailsTable);
				
				PdfPTable boldDetailsTable=createBoldDetailsTable(source,destination);
				document.add(boldDetailsTable);
				
				for(int i=0;i<permitDetails.size();i++){
					ArrayList<Object> permit=new ArrayList<Object>();
					permit=(ArrayList<Object>) permitDetails.get(i);
					PdfPTable boldDetailsTable1=createBoldDetailsTable1((String)permit.get(0),(String)permit.get(1),i,(String)permit.get(2),(String)permit.get(3));
					document.add(boldDetailsTable1);
				}
				PdfPTable signDetailsTable=createSignDetailsTable(issueDate,finalQRImage);
				document.add(signDetailsTable);
				
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("Inside generatetripsheet function.."+e.toString());
			}	
	}
	
	private PdfPTable createLogoHeader(String regno,String ownerName,String assetId) {
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

			logomyPhrase=new Phrase("",new Font(baseFont, 13, Font.NORMAL));
			logomyPhrase.add(new Chunk(headimg2, 0, 0));
			logoCel = new PdfPCell(logomyPhrase);
			logoCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			logoCel.setBorder(Rectangle.NO_BORDER);
			logoCel.enableBorderSide(Rectangle.TOP);
			logoTable.addCell(logoCel);

			logomyPhrase=new Phrase(regno+"\n\n"+assetId,new Font(baseFont, 15, Font.BOLD));
			logoCel = new PdfPCell(logomyPhrase);
			logoCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			logoCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			logoCel.enableBorderSide(Rectangle.LEFT);
			logoCel.disableBorderSide(Rectangle.RIGHT);
			logoTable.addCell(logoCel);
			
			logomyPhrase=new Phrase("",new Font(baseFont, 12, Font.BOLD));
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
			
	private PdfPTable createHeader(Image baCodeImage) {
		float[] widths = {2,60,60,60,2};
		PdfPTable t1 = new PdfPTable(5);
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

			myPhrase=new Phrase("Government of Goa",new Font(baseFont, 13, Font.NORMAL));
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
			myPhrase=new Phrase("",new Font(baseFont, 13, Font.BOLD));
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
			
			myPhrase=new Phrase("Directorate of Mines & Geology",new Font(baseFont, 13, Font.BOLD));
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
			myPhrase=new Phrase("",new Font(baseFont, 13, Font.BOLD));
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
			
			myPhrase=new Phrase("BARGE TRIP SHEET",new Font(baseFont, 15, Font.BOLD));
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
	private PdfPTable createTripNoTable(String enrollNo,String qty,String bargeCapacity,String route) {
        float[] widthtripNo = {15,60,18,20,15,50};
		PdfPTable tripNoTable=new PdfPTable(6);
		try {
			tripNoTable.setWidthPercentage(100.0f);
			tripNoTable.setWidths(widthtripNo);
			
			Phrase tripNoMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
		    PdfPCell tripNoCel = new PdfPCell(tripNoMyPhras);
		    tripNoCel.enableBorderSide(Rectangle.TOP);
			tripNoCel.enableBorderSide(Rectangle.LEFT);
			tripNoCel.disableBorderSide(Rectangle.BOTTOM);
			tripNoCel.disableBorderSide(Rectangle.RIGHT);
			tripNoTable.addCell(tripNoCel);

			tripNoMyPhras=new Phrase(enrollNo,new Font(baseFont, 13, Font.BOLD));
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
			
			tripNoMyPhras=new Phrase("Barge Capacity",new Font(baseFont, 13, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.enableBorderSide(Rectangle.LEFT);
			tripNoCel.enableBorderSide(Rectangle.BOTTOM);
			tripNoCel.enableBorderSide(Rectangle.TOP);
			tripNoCel.enableBorderSide(Rectangle.RIGHT);
			tripNoCel.enableBorderSide(Rectangle.BOTTOM);
			tripNoCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			tripNoTable.addCell(tripNoCel);

			tripNoMyPhras=new Phrase(bargeCapacity+" tons",new Font(baseFont, 13, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.enableBorderSide(Rectangle.LEFT);
			tripNoCel.enableBorderSide(Rectangle.BOTTOM);
			tripNoCel.enableBorderSide(Rectangle.TOP);
			tripNoCel.enableBorderSide(Rectangle.RIGHT);
			tripNoCel.enableBorderSide(Rectangle.BOTTOM);
			tripNoCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			tripNoTable.addCell(tripNoCel);
	//-----------------------------------------------------------------------------------//
			tripNoMyPhras=new Phrase("Route : ",new Font(baseFont, 13, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.enableBorderSide(Rectangle.LEFT);
			tripNoCel.disableBorderSide(Rectangle.BOTTOM);
			tripNoCel.enableBorderSide(Rectangle.TOP);
			tripNoCel.enableBorderSide(Rectangle.RIGHT);
			tripNoTable.addCell(tripNoCel);

			tripNoMyPhras=new Phrase(route,new Font(baseFont, 13, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.enableBorderSide(Rectangle.LEFT);
			tripNoCel.disableBorderSide(Rectangle.BOTTOM);
			tripNoCel.disableBorderSide(Rectangle.RIGHT);
			tripNoCel.enableBorderSide(Rectangle.TOP);
			tripNoCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			tripNoTable.addCell(tripNoCel);

			tripNoMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.enableBorderSide(Rectangle.TOP);
			tripNoCel.disableBorderSide(Rectangle.LEFT);
			tripNoCel.enableBorderSide(Rectangle.BOTTOM);
			tripNoCel.disableBorderSide(Rectangle.RIGHT);
			tripNoTable.addCell(tripNoCel);
			
			tripNoMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.enableBorderSide(Rectangle.TOP);
			tripNoCel.disableBorderSide(Rectangle.LEFT);
			tripNoCel.enableBorderSide(Rectangle.BOTTOM);
			tripNoTable.addCell(tripNoCel);
			
		    tripNoMyPhras=new Phrase("Quantity",new Font(baseFont, 13, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.enableBorderSide(Rectangle.LEFT);
			tripNoCel.enableBorderSide(Rectangle.BOTTOM);
			tripNoCel.enableBorderSide(Rectangle.TOP);
			tripNoCel.enableBorderSide(Rectangle.RIGHT);
			tripNoCel.enableBorderSide(Rectangle.BOTTOM);
			tripNoCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			tripNoTable.addCell(tripNoCel);

			tripNoMyPhras=new Phrase(qty+" tons",new Font(baseFont, 13, Font.BOLD));
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
			tripNoCel.disableBorderSide(Rectangle.TOP);
			tripNoCel.disableBorderSide(Rectangle.RIGHT);
			tripNoCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			tripNoCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			tripNoTable.addCell(tripNoCel);

			tripNoMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.disableBorderSide(Rectangle.LEFT);
			tripNoCel.disableBorderSide(Rectangle.BOTTOM);
			tripNoCel.setBorder(Rectangle.NO_BORDER);
			tripNoCel.disableBorderSide(Rectangle.RIGHT);
			tripNoCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			tripNoCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			tripNoTable.addCell(tripNoCel);

			tripNoMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.disableBorderSide(Rectangle.TOP);
			tripNoCel.disableBorderSide(Rectangle.LEFT);
			tripNoCel.disableBorderSide(Rectangle.BOTTOM);
			tripNoCel.disableBorderSide(Rectangle.RIGHT);
			tripNoCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			tripNoCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			tripNoTable.addCell(tripNoCel);
			
			tripNoMyPhras=new Phrase("",new Font(baseFont, 10, Font.BOLD));
			tripNoCel = new PdfPCell(tripNoMyPhras);
			tripNoCel.disableBorderSide(Rectangle.TOP);
			tripNoCel.disableBorderSide(Rectangle.LEFT);
			tripNoCel.disableBorderSide(Rectangle.BOTTOM);
			tripNoCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			tripNoCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			tripNoTable.addCell(tripNoCel);
			
		  
		} catch (Exception e) {
			e.printStackTrace();
	  }
		return tripNoTable;
	}
	
	@SuppressWarnings("unused")
	private PdfPTable createRouteDetailsTable(String route,String distance,String minerals,String grade) {
        float[] widthRouteDetails = {15,60,18,20,15,50};
		PdfPTable routeDetailsTable=new PdfPTable(6);
		try {
			routeDetailsTable.setWidthPercentage(100.0f);
			routeDetailsTable.setWidths(widthRouteDetails);
			
			Phrase routeDetailsMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
		    PdfPCell routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
		    routeDetailsCel.enableBorderSide(Rectangle.TOP);
			routeDetailsCel.enableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
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

			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsTable.addCell(routeDetailsCel);
	//----------------------------------------------------------------------//
			/*//--------------------empty row-------------------//
			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.enableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			//routeDetailsCel.disableBorderSide(Rectangle.RIGHT);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase(" ",new Font(baseFont, 13, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.setBorder(Rectangle.NO_BORDER);
			routeDetailsCel.disableBorderSide(Rectangle.RIGHT);
			routeDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
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
			
		    routeDetailsMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			routeDetailsTable.addCell(routeDetailsCel);*/
			//------------------------end-------------------------------------//
			routeDetailsMyPhras=new Phrase("Route :",new Font(baseFont, 13, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.enableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			routeDetailsCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			//routeDetailsCel.disableBorderSide(Rectangle.RIGHT);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase(route,new Font(baseFont, 13, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.setBorder(Rectangle.NO_BORDER);
			routeDetailsCel.disableBorderSide(Rectangle.RIGHT);
			routeDetailsCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			routeDetailsCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase(" ",new Font(baseFont, 13, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			routeDetailsCel.enableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.disableBorderSide(Rectangle.RIGHT);
			routeDetailsCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			routeDetailsCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			//routeDetailsCel.setBorder(Rectangle.NO_BORDER);
			routeDetailsTable.addCell(routeDetailsCel);
			
			routeDetailsMyPhras=new Phrase(" ",new Font(baseFont, 13, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			routeDetailsCel.enableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			routeDetailsCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			//routeDetailsCel.setBorder(Rectangle.NO_BORDER);
			routeDetailsTable.addCell(routeDetailsCel);
			
		    routeDetailsMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			routeDetailsCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.setVerticalAlignment(Element.ALIGN_MIDDLE);
			routeDetailsCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			routeDetailsTable.addCell(routeDetailsCel);
			//--------------------empty row-------------------//
			/*routeDetailsMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.enableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			//routeDetailsCel.disableBorderSide(Rectangle.RIGHT);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase(" ",new Font(baseFont, 13, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.LEFT);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.setBorder(Rectangle.NO_BORDER);
			routeDetailsCel.disableBorderSide(Rectangle.RIGHT);
			routeDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
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
			
		    routeDetailsMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
			routeDetailsCel.disableBorderSide(Rectangle.TOP);
			routeDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			routeDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			routeDetailsTable.addCell(routeDetailsCel);

			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
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
//			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
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
//			routeDetailsMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
//			routeDetailsCel = new PdfPCell(routeDetailsMyPhras);
//			routeDetailsCel.disableBorderSide(Rectangle.TOP);
//			routeDetailsCel.enableBorderSide(Rectangle.BOTTOM);
//			routeDetailsTable.addCell(routeDetailsCel);
		} catch (Exception e) {
			e.printStackTrace();
	  }
		return routeDetailsTable;
	}
	
    private PdfPTable createValidUptoDetailsTable(String EnrollDate,String hours,String vesselName) {
        float[] widthValidUptoDetails = {20,20,2,20,20,5,25,25};
		PdfPTable ValidUptoDetailsTable=new PdfPTable(8);
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

			ValidUptoDetailsMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
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
			
			ValidUptoDetailsMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);

			ValidUptoDetailsMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);
			
//			ValidUptoDetailsMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
//			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
//			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
//			ValidUptoDetailsCel.disableBorderSide(Rectangle.LEFT);
//			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
//			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);


			ValidUptoDetailsMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.setColspan(2);
			ValidUptoDetailsCel.enableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);
	//----------------------------------------------------------------------//
			
			ValidUptoDetailsMyPhras=new Phrase("Valid Upto :",new Font(baseFont, 15, Font.NORMAL));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.enableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.TOP);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);

			ValidUptoDetailsMyPhras=new Phrase(hours.trim(),new Font(baseFont, 15, Font.BOLD));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsCel.setBorder(Rectangle.NO_BORDER);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);
			
			ValidUptoDetailsMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.TOP);
			ValidUptoDetailsCel.enableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsCel.setBorder(Rectangle.NO_BORDER);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);
			
		    ValidUptoDetailsMyPhras=new Phrase("Hours of:",new Font(baseFont, 15, Font.NORMAL));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.TOP);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);

			ValidUptoDetailsMyPhras=new Phrase(EnrollDate,new Font(baseFont, 15, Font.BOLD));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.TOP);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);
			
			ValidUptoDetailsMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.TOP);
			ValidUptoDetailsCel.enableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsCel.setBorder(Rectangle.NO_BORDER);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);
			
			ValidUptoDetailsMyPhras=new Phrase(vesselName,new Font(baseFont, 15, Font.BOLD));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.setColspan(2);
			ValidUptoDetailsCel.enableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.TOP);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsCel.enableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);

//			ValidUptoDetailsMyPhras=new Phrase("",new Font(baseFont, 15, Font.BOLD));
//			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
//			ValidUptoDetailsCel.disableBorderSide(Rectangle.LEFT);
//			ValidUptoDetailsCel.disableBorderSide(Rectangle.TOP);
//			ValidUptoDetailsCel.disableBorderSide(Rectangle.BOTTOM);
//			ValidUptoDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
//			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);
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
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);
			
			ValidUptoDetailsMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.LEFT);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.TOP);
			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
			ValidUptoDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);
			

//			ValidUptoDetailsMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
//			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
//			ValidUptoDetailsCel.disableBorderSide(Rectangle.LEFT);
//			ValidUptoDetailsCel.disableBorderSide(Rectangle.TOP);
//			ValidUptoDetailsCel.disableBorderSide(Rectangle.RIGHT);
//			ValidUptoDetailsCel.enableBorderSide(Rectangle.BOTTOM);
//			ValidUptoDetailsTable.addCell(ValidUptoDetailsCel);
			
			ValidUptoDetailsMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			ValidUptoDetailsCel = new PdfPCell(ValidUptoDetailsMyPhras);
			ValidUptoDetailsCel.setColspan(2);
			ValidUptoDetailsCel.enableBorderSide(Rectangle.LEFT);
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

			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsTable.addCell(BoldDetailsCel);
	//----------------------------------------------------------------------//
			
			BoldDetailsTableMyPhras=new Phrase(source,new Font(baseFont, 15, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.enableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
			BoldDetailsTable.addCell(BoldDetailsCel);

			BoldDetailsTableMyPhras=new Phrase("|",new Font(baseFont, 15, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.setBorder(Rectangle.NO_BORDER);
			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
			BoldDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			BoldDetailsTable.addCell(BoldDetailsCel);

			BoldDetailsTableMyPhras=new Phrase(destination,new Font(baseFont, 15, Font.BOLD));
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

			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
			BoldDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
			BoldDetailsTable.addCell(BoldDetailsCel);

			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
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
    
    private PdfPTable createBoldDetailsTable1(String permitNo,String permitQuantity,int i,String grade,String shipName) {
        float[] widthBoldDetails = {50,20,30,40};
		PdfPTable BoldDetailsTable=new PdfPTable(4);
		try {
			BoldDetailsTable.setWidthPercentage(100.0f);
			BoldDetailsTable.setWidths(widthBoldDetails);
			
			Phrase BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
		    PdfPCell BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
		    BoldDetailsCel.enableBorderSide(Rectangle.TOP);
			BoldDetailsCel.enableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.enableBorderSide(Rectangle.RIGHT);
			BoldDetailsTable.addCell(BoldDetailsCel);

//			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
//			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
//			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
//			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
//			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
//			BoldDetailsTable.addCell(BoldDetailsCel);

			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.enableBorderSide(Rectangle.RIGHT);
			BoldDetailsTable.addCell(BoldDetailsCel);
			
//			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
//			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
//			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
//			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
//			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
//			BoldDetailsTable.addCell(BoldDetailsCel);
			
			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.enableBorderSide(Rectangle.RIGHT);
			BoldDetailsTable.addCell(BoldDetailsCel);
			
//			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 5, Font.BOLD));
//			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
//			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
//			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
//			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
//			BoldDetailsTable.addCell(BoldDetailsCel);
			
			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 0, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.enableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.enableBorderSide(Rectangle.RIGHT);
			BoldDetailsTable.addCell(BoldDetailsCel);
	//----------------------------------------------------------------------//
			BoldDetailsTableMyPhras=new Phrase(permitNo,new Font(baseFont, 15, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.enableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
			BoldDetailsCel.enableBorderSide(Rectangle.RIGHT);
			BoldDetailsTable.addCell(BoldDetailsCel);
				
//			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 15, Font.BOLD));
//			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
//			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
//			BoldDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
//			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
//			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
//			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
//			BoldDetailsTable.addCell(BoldDetailsCel);
			
			BoldDetailsTableMyPhras=new Phrase(permitQuantity+" tons",new Font(baseFont, 15, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.setBorder(Rectangle.NO_BORDER);
			BoldDetailsCel.enableBorderSide(Rectangle.RIGHT);
			BoldDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			BoldDetailsTable.addCell(BoldDetailsCel);

//			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 15, Font.BOLD));
//			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
//			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
//			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
//			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
//			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
//			BoldDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
//			BoldDetailsTable.addCell(BoldDetailsCel);
			
			BoldDetailsTableMyPhras=new Phrase(grade,new Font(baseFont, 15, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.setBorder(Rectangle.NO_BORDER);
			BoldDetailsCel.enableBorderSide(Rectangle.RIGHT);
			BoldDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			BoldDetailsTable.addCell(BoldDetailsCel);
			
//			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 15, Font.BOLD));
//			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
//			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
//			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
//			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
//			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
//			BoldDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
//			BoldDetailsTable.addCell(BoldDetailsCel);

			BoldDetailsTableMyPhras=new Phrase(shipName,new Font(baseFont, 15, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
			BoldDetailsCel.disableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			BoldDetailsTable.addCell(BoldDetailsCel);
		//---------------------------------------------------------------------------------//	
			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
		    BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.enableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
			BoldDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.enableBorderSide(Rectangle.RIGHT);
			BoldDetailsTable.addCell(BoldDetailsCel);

//			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
//			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
//			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
//			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
//			BoldDetailsCel.enableBorderSide(Rectangle.BOTTOM);
//			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
//			BoldDetailsTable.addCell(BoldDetailsCel);

			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
			BoldDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.enableBorderSide(Rectangle.RIGHT);
			BoldDetailsTable.addCell(BoldDetailsCel);
			
//			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
//			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
//			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
//			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
//			BoldDetailsCel.enableBorderSide(Rectangle.BOTTOM);
//			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
//			BoldDetailsTable.addCell(BoldDetailsCel);
			
			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
			BoldDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.enableBorderSide(Rectangle.RIGHT);
			BoldDetailsTable.addCell(BoldDetailsCel); 
			
//			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
//			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
//			BoldDetailsCel.disableBorderSide(Rectangle.LEFT);
//			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
//			BoldDetailsCel.enableBorderSide(Rectangle.BOTTOM);
//			BoldDetailsCel.disableBorderSide(Rectangle.RIGHT);
//			BoldDetailsTable.addCell(BoldDetailsCel);
			
			BoldDetailsTableMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
			BoldDetailsCel = new PdfPCell(BoldDetailsTableMyPhras);
			BoldDetailsCel.enableBorderSide(Rectangle.LEFT);
			BoldDetailsCel.disableBorderSide(Rectangle.TOP);
			BoldDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			BoldDetailsCel.enableBorderSide(Rectangle.RIGHT);
			BoldDetailsTable.addCell(BoldDetailsCel);
			
		} catch (Exception e) {
			e.printStackTrace();
	  }
		return BoldDetailsTable;
	}

    
    private PdfPTable createSignDetailsTable(String EnrollDate,Image finalQRImage) {
        float[] widthSignDetails = {20,10,25,2,25,25};
		PdfPTable SignDetailsTable=new PdfPTable(6);
		try {
			SignDetailsTable.setWidthPercentage(100.0f);
			SignDetailsTable.setWidths(widthSignDetails);
			
			String path = getServletContext().getRealPath("/")+"Main/modules/ironMining/images/authorizedsign.jpg";
			Image imgsign = Image.getInstance(path);
			finalQRImage.scaleToFit(5000, 135);
			
			String pathStap = getServletContext().getRealPath("/")+"Main/modules/ironMining/images/DMG_SEAL.jpg";
			Image imgStamp = Image.getInstance(pathStap);
			imgStamp.scaleToFit(3500, 120);
			
		    Phrase SignDetailsMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
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

			SignDetailsMyPhras=new Phrase(" ",new Font(baseFont, 20, Font.BOLD));
			SignDetailsCel = new PdfPCell(SignDetailsMyPhras);
			SignDetailsCel.disableBorderSide(Rectangle.LEFT);
			SignDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			SignDetailsCel.disableBorderSide(Rectangle.RIGHT);
			SignDetailsTable.addCell(SignDetailsCel);

			
		    SignDetailsMyPhras=new Phrase("Sign & Seal Of Barge Master/Representative",new Font(baseFont, 15, Font.NORMAL));
			SignDetailsCel = new PdfPCell(SignDetailsMyPhras);
			SignDetailsCel.disableBorderSide(Rectangle.LEFT);
			SignDetailsCel.disableBorderSide(Rectangle.RIGHT);
			SignDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			SignDetailsCel.setVerticalAlignment(Element.ALIGN_BOTTOM);
			SignDetailsCel.setHorizontalAlignment(Element.ALIGN_CENTER);
			SignDetailsTable.addCell(SignDetailsCel);
			
			SignDetailsMyPhras=new Phrase("",new Font(baseFont, 13, Font.BOLD));
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

			SignDetailsMyPhras=new Phrase("",new Font(baseFont, 20, Font.BOLD));
			SignDetailsMyPhras.add(new Chunk(finalQRImage, 0, 0));
			//SignDetailsCel.addElement(finalQRImage);
			SignDetailsCel = new PdfPCell(SignDetailsMyPhras);
			SignDetailsCel.enableBorderSide(Rectangle.LEFT);
			SignDetailsCel.enableBorderSide(Rectangle.BOTTOM);
			SignDetailsCel.enableBorderSide(Rectangle.RIGHT);
			SignDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			SignDetailsTable.addCell(SignDetailsCel);
		
		} catch (Exception e) {
			e.printStackTrace();
	  }
		return SignDetailsTable;
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
