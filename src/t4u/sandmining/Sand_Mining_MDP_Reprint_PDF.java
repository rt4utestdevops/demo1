package t4u.sandmining;

import java.awt.Color;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.MessageFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import t4u.common.ApplicationListener;
import t4u.functions.SandMiningPermitFunctions;

import t4u.beans.LoginInfoBean;
import com.lowagie.text.Document;
import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

public class Sand_Mining_MDP_Reprint_PDF extends HttpServlet {


	static BaseFont baseFont = null;
	SandMiningPermitFunctions sqlfun=new SandMiningPermitFunctions();
	
	String finlist = "";
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {	
		try
		{
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
			SimpleDateFormat sdfFormatDatedd = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
			 
			
			int offset=330;
			HttpSession session = request.getSession();
				if (session.getAttribute("loginInfoDetails")!=null) {
					LoginInfoBean loginInfoBean = (LoginInfoBean) session.getAttribute("loginInfoDetails");
					offset=loginInfoBean.getOffsetMinutes();
				}
			String systemid = request.getParameter("systemId");
			String clientId = request.getParameter("clientId");
			String jsonList = request.getParameter("Json");
			finlist=sqlfun.getDistrict(Integer.parseInt(systemid));
			String vehicleNumber="";
			String tempPermitNumber = "";
			String leaseNumber = "";
			String leaseName = "";
			String permitId = "";
			String permitNumber = "";
			String tripCode = "";
			String barCode = "";
			String tripType = "";
			String typeOfLand = "";
			String validfrom = "";
			String validTo = "";
			String buyer = "";
			String taluk = "";
			String quantity = "";
			String royalty = "";
			String processingFees = "";
			String sandPort = "";
			String destination = "";
			String route = "";
			String distance="";
			
			if (jsonList != null) {
				String st = "[" + jsonList + "]";
				JSONArray js = null;
				try {
					js = new JSONArray(st.toString());
					for (int i = 0; i < js.length(); i++) {

						JSONObject obj = js.getJSONObject(i);
						
						vehicleNumber= obj.getString("vehicleNumber");
						leaseNumber = obj.getString("leaseNumber");
						tempPermitNumber = obj.getString("tempPermitNumber");
						leaseName = obj.getString("leaseName");
						//  permitId = obj.getString("permitId");
						permitNumber = obj.getString("permitNumber");
						tripCode = obj.getString("tripSheetCodeNumber");
						barCode = obj.getString("barCodeNumber");
						//  tripType = obj.getString("tripsheetType");
						typeOfLand = obj.getString("typeOfLand");
						validfrom = obj.getString("validFrom");
						validTo = obj.getString("validTo");
						buyer = obj.getString("buyer");
						taluk = obj.getString("talukDistrict");
						quantity = obj.getString("quantity");
						royalty = obj.getString("royalty");
						processingFees = obj.getString("processingFees");
						sandPort = obj.getString("sourcePlace");
						destination = obj.getString("destinationPlace");
						route = obj.getString("route");
						distance=obj.getString("distanceindex");
						
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}
			}
			if (validfrom.contains("T")) {
				validfrom = validfrom.substring(0, validfrom.indexOf("T"))+ " "+ validfrom.substring(validfrom.indexOf("T") + 1,validfrom.length());
			}
			
			if (validTo.contains("T")) {
				validTo = validTo.substring(0, validTo.indexOf("T"))+ " "+ validTo.substring(validTo.indexOf("T") + 1,validTo.length());
			}
			
			//Date validFromDate = sdfFormatDatedd.parse(validfrom);
			//validfrom = sdfFormatDatedd.format(validFromDate);
			
			//Date validToDate = sdfFormatDatedd.parse(validTo);
			//validTo = sdfFormatDatedd.format(validToDate);
			
			ArrayList printList1=new ArrayList();//sqlfun.getPrintList(uids,offset);
			printList1.add(permitNumber);
			printList1.add(leaseNumber);
			printList1.add(tempPermitNumber);
			printList1.add(tripCode);
			printList1.add(vehicleNumber);
			printList1.add(barCode);
			printList1.add(tripType);
			printList1.add(typeOfLand);
			printList1.add(validfrom);
			printList1.add(validTo);
			printList1.add(leaseName);
			printList1.add(taluk);
			printList1.add("Ordinary Sand");
			printList1.add(royalty);
			printList1.add(quantity);
			printList1.add(sandPort);
			printList1.add(buyer);
			printList1.add(route);
			printList1.add(destination);
			printList1.add(processingFees);
			printList1.add(distance);
			
			String note="1. The Trip Sheet is valid, only if the Mineral is Transported in a vehicle which has required Carriying Capacity as per M V. Act 1988 \n " +
					"2. KMMCR-42 From the date and time of issue,two hours of additional time for loading and unloading allowed. ";
			
			SimpleDateFormat simpleDateFormatddMMYY = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
			Calendar calendar = Calendar.getInstance();		
			Date TodayDate = calendar.getTime();
			String date=simpleDateFormatddMMYY.format(TodayDate);
			String todaydate=simpleDateFormatddMMYY.format(TodayDate);
			date= date.replaceAll("/", "");
			date=date.replaceAll(":", "");
			date=date.replaceAll(" ", "_");
			
			Date date1=simpleDateFormatddMMYY.parse(validfrom);
			Date date2=simpleDateFormatddMMYY.parse(validTo);
			long duration  = date2.getTime() - date1.getTime();

			int s = (int)((duration/=1000) % 60);
    		int m = (int)((duration/=60) % 60);
    		 int h = (int)(duration/=60);
    		 
    		String hour=String.valueOf(h>9?String.valueOf(h):"0"+String.valueOf(h));
 			String minute=String.valueOf(m>9?String.valueOf(m):"0"+String.valueOf(m));
 			String second=String.valueOf(s>9?String.valueOf(s):"0"+String.valueOf(s));
 			
    		//System.out.format("%02d:%02d:%02d%n", h, m, s);
    		String TotalTIme=hour+":"+""+ minute+":"+ second;
    		System.out.println("TotalTIme== "+TotalTIme);
    		printList1.add(TotalTIme);
			ServletOutputStream servletOutputStream = response.getOutputStream();
			Properties properties = ApplicationListener.prop;
			//Properties properties = BuildProperties.getDBProperties();
			String billpath=  properties.getProperty("Builtypath");
			refreshdir(billpath);
			String formno="MINERAL_DISPATCH_PERMIT"+systemid+"_"+date;
			String fontPath = properties.getProperty("FontPathForMaplePDF");
			baseFont = BaseFont.createFont(fontPath, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
			String bill = billpath+ formno + ".pdf";
			
			generateBill(bill,systemid,request,printList1, clientId, todaydate, note,finlist);
			
			printBill(servletOutputStream,response,bill,formno);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error generating sms bill : " + e);
			e.printStackTrace();
		}
	}

	

	private void generateBill(String bill,  String systemid, HttpServletRequest request, ArrayList printList, String clientId, String todaydate,String note,String finlist) 
	{		
		try
		{			
			FileOutputStream fileOut = new FileOutputStream(bill);
			Document document = new Document(PageSize.A4.rotate(), 40, 40, 30, 20);
			PdfWriter writer = PdfWriter.getInstance(document,fileOut);
			document.open();
			SandMiningPermitFunctions sqlfun=new SandMiningPermitFunctions();
			String currency="Rs.";
			String pERMITNO="";
			String Leaseno="";
			String note1="";	
				ArrayList list=(ArrayList) printList;
				pERMITNO=list.get(0).toString();
				Leaseno=list.get(1).toString();
				String tempPermitNo=list.get(2).toString();
				String tripsheetno=list.get(3).toString();
				String vehicleno=list.get(4).toString();
				String barcode=list.get(5).toString();
				String tripsheettype=list.get(6).toString();
				String landtype=list.get(7).toString();
				String validityfrom=list.get(8).toString();
				String validityto=list.get(9).toString();
				String lesseename=list.get(10).toString();
				String talukdist=list.get(11).toString();
				String mineralgrade=list.get(12).toString();
				String royality=list.get(13).toString();
				String qty=list.get(14).toString();
				String loadingplace=list.get(15).toString();
				String buyer=list.get(16).toString();
				String route=list.get(17).toString();
				String destination=list.get(18).toString();
				String processingfee=list.get(19).toString();
				String distance=list.get(20).toString();
				String validityTime=list.get(21).toString();
				
				

			String headingString1 = "        GOVERNMENT OF KARNATAKA       ";
			String headingString2 = "DEPARTMENT OF MINES AND GEOLOGY - "+finlist;
			String headingString3="MINERAL DISPATCH PERMIT - "+todaydate;
			
			/*PdfPTable headerTable0 = createBillhead0("",request); 
			document.add(headerTable0);*/
			
			PdfPTable headerTable45 =createBilldata24();
			document.add(headerTable45);
			
			document.add(headerTable45);
			document.add(headerTable45);
			
				// For heading
				PdfPTable headerTable = createBillhead("",headingString1);
				document.add(headerTable);
				PdfPTable headerTable1 = createBillhead1("",headingString2);
				document.add(headerTable1);
				PdfPTable headerTable2 = createBillhead2("",headingString3);
				document.add(headerTable2);
				
				PdfPTable headerTableTop = createBilldata();
				document.add(headerTableTop);
				
				document.add(headerTable45);
				
				PdfPTable headerTable31 = createVehicleNo(vehicleno);
				document.add(headerTable31);
				
				PdfPTable headerTable3 = createPermitNo(pERMITNO);
				document.add(headerTable3);
				
				PdfPTable headerTable33 = createtempPermitNumber(tempPermitNo);
				document.add(headerTable33);
				
				PdfPTable headerTable311 = createLesseeNo(Leaseno);
				document.add(headerTable311);
				
				PdfPTable headerTable4 = createTripsheetNo(tripsheetno);
				document.add(headerTable4);
				
				PdfPTable headerTable5 = createBarcode(barcode);
				document.add(headerTable5);
				
				//PdfPTable headerTable6 = createTripsheetType(tripsheettype);
				//document.add(headerTable6);
				
				PdfPTable headerTable61 = createLandType(landtype);
				document.add(headerTable61);
				
				PdfPTable headerTable7 = createValidity(validityfrom,validityto,validityTime);
				document.add(headerTable7);
				
				PdfPTable headerTable8 = createLeaseName(lesseename);
				document.add(headerTable8);
				
				PdfPTable headerTable9 = createTalukDistrict(talukdist);
				document.add(headerTable9);
				
				PdfPTable headerTable10 = createMineralGrade(mineralgrade);
				document.add(headerTable10);
				
				PdfPTable headerTable11 = createRoyality(royality,currency);
				document.add(headerTable11);
				
				//PdfPTable headerTable17 = createProcessingfee(processingfee, currency);
				//document.add(headerTable17);
				
				PdfPTable headerTable111 = createQty(qty);
				document.add(headerTable111);
				
				PdfPTable headerTable12 = createLoadingPlace(loadingplace);
				document.add(headerTable12);
				
				PdfPTable headerTable13 = createBuyer(buyer);
				document.add(headerTable13);
				
				PdfPTable headerTable14 = createRoute(route,distance);
				document.add(headerTable14);
				
				PdfPTable headerTable15 = createDestination(destination);
				document.add(headerTable15);
				
				
				
				document.add(headerTable45);
				document.add(headerTable45);
				document.add(headerTable45);
				document.add(headerTable45);
//				document.add(headerTable45);
				
				PdfPTable headerTable16 = createNote(note);
				document.add(headerTable16);
				if(systemid=="192"){
				note1="This MDP is Valid for Karnataka State Only";
				}else{
				note1="This MDP is Valid for "+finlist+" Only";
				}
				PdfPTable headerTablenote = createNote1(note1);
				document.add(headerTablenote);
				
			document.close();
		}
		catch (Exception e) 
		{
			System.out.println("Error generating report : " + e);
			e.printStackTrace();
		}
	}

	private PdfPTable createBillhead2(String string, String headingString) {
		float[] widths = {12,70,35,70,10};//,60,15};
		PdfPTable t = new PdfPTable(5);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			Phrase myPhrase=new Phrase(headingString,new Font(baseFont,7, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);
			
			 myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBackgroundColor(Color.WHITE);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);
			
			 myPhrase=new Phrase(headingString,new Font(baseFont,7, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);
			
			 myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	
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
	
	private PdfPTable createBilldata() {
		float[] widths = {50,50,60,40,50,50};//,50,40};
		PdfPTable t = new PdfPTable(6);
		String Top1="PERMIT HOLDER COPY";
		String	Top2="DESTINATION COPY";
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase1=new Phrase(" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase1=new Phrase(" "+Top1+"  ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);
			
			myPhrase1=new Phrase("            ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);
			
			myPhrase1=new Phrase("                       ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);
			
			myPhrase1=new Phrase(" "+Top2+"  ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);
			
			myPhrase1=new Phrase("                ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	
		
	}

	
	private PdfPTable createBillhead(String PDForm,String headingString)
	{
		float[] widths = {20,60,45,60,15};//,60,15};
		PdfPTable t = new PdfPTable(5);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			Phrase myPhrase=new Phrase(headingString,new Font(baseFont, 7, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);
			
			 myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBackgroundColor(Color.WHITE);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);
			
			 myPhrase=new Phrase(headingString,new Font(baseFont, 7, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);
			
			 myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	
	}	
	private PdfPTable createBillhead1(String PDForm,String headingString)
	{
		float[] widths = {12,68,37,68,15};//,60,10};
		PdfPTable t = new PdfPTable(5);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			Phrase myPhrase=new Phrase(headingString,new Font(baseFont, 7, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);
			
			 myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBackgroundColor(Color.WHITE);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);
			
			 myPhrase=new Phrase(headingString,new Font(baseFont, 7, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);
			
			 myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

	}	
		
	private PdfPTable  createPermitNo(String mdpno) {	
		float[] widths = {10,30,75,20,30,75};
		PdfPTable t = new PdfPTable(6);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase6=new Phrase(" ");
			PdfPCell c24 = new PdfPCell(myPhrase6);
			c24.setBorder(Rectangle.NO_BORDER);
			t.addCell(c24);
			
			Phrase myPhrase31=new Phrase("MDP No :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c18 = new PdfPCell(myPhrase31);
			c18.setBorder(Rectangle.NO_BORDER);
			t.addCell(c18);
			
			
			Phrase myPhrase32=new Phrase(mdpno,new Font(baseFont,8, Font.BOLD));
			PdfPCell c19 = new PdfPCell(myPhrase32);
			c19.setBorder(Rectangle.NO_BORDER);
			t.addCell(c19);
			
			myPhrase6=new Phrase(" ");
			PdfPCell c25 = new PdfPCell(myPhrase6);
			c25.setBorder(Rectangle.NO_BORDER);
			t.addCell(c25);
			
			Phrase myPhrase33=new Phrase("MDP No :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c20 = new PdfPCell(myPhrase33);
			c20.setBorder(Rectangle.NO_BORDER);
			t.addCell(c20);
			
			
			Phrase myPhrase34=new Phrase(mdpno,new Font(baseFont,8, Font.BOLD));
			PdfPCell c21 = new PdfPCell(myPhrase34);
			c21.setBorder(Rectangle.NO_BORDER);
			t.addCell(c21);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
		
	}
	
	private PdfPTable  createLesseeNo(String lesseeno) {	
		float[] widths = {10,30,75,20,30,75};
		PdfPTable t = new PdfPTable(6);
		
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase6=new Phrase(" ");
			PdfPCell c24 = new PdfPCell(myPhrase6);
			c24.setBorder(Rectangle.NO_BORDER);
			t.addCell(c24);
			
			Phrase myPhrase31=new Phrase("Sand Bar No :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c18 = new PdfPCell(myPhrase31);
			c18.setBorder(Rectangle.NO_BORDER);
			t.addCell(c18);
			
			
			Phrase myPhrase32=new Phrase(lesseeno,new Font(baseFont,8, Font.BOLD));
			PdfPCell c19 = new PdfPCell(myPhrase32);
			c19.setBorder(Rectangle.NO_BORDER);
			t.addCell(c19);
			
			myPhrase6=new Phrase(" ");
			PdfPCell c25 = new PdfPCell(myPhrase6);
			c25.setBorder(Rectangle.NO_BORDER);
			t.addCell(c25);
			
			Phrase myPhrase33=new Phrase("Sand Bar No :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c20 = new PdfPCell(myPhrase33);
			c20.setBorder(Rectangle.NO_BORDER);
			t.addCell(c20);
			
			
			Phrase myPhrase34=new Phrase(lesseeno,new Font(baseFont,8, Font.BOLD));
			PdfPCell c21 = new PdfPCell(myPhrase34);
			c21.setBorder(Rectangle.NO_BORDER);
			t.addCell(c21);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
		
	}
	
	private PdfPTable  createVehicleNo(String vehicleno) {	
		float[] widths = {10,30,75,20,30,75};
		PdfPTable t = new PdfPTable(6);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase6=new Phrase(" ");
			PdfPCell c24 = new PdfPCell(myPhrase6);
			c24.setBorder(Rectangle.NO_BORDER);
			t.addCell(c24);
			
			Phrase myPhrase31=new Phrase("Vehicle No :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c18 = new PdfPCell(myPhrase31);
			c18.setBorder(Rectangle.NO_BORDER);
			t.addCell(c18);
			
			
			Phrase myPhrase32=new Phrase(vehicleno,new Font(baseFont,8, Font.BOLD));
			PdfPCell c19 = new PdfPCell(myPhrase32);
			c19.setBorder(Rectangle.NO_BORDER);
			t.addCell(c19);
			
			myPhrase6=new Phrase(" ");
			PdfPCell c25 = new PdfPCell(myPhrase6);
			c25.setBorder(Rectangle.NO_BORDER);
			t.addCell(c25);
			
			Phrase myPhrase33=new Phrase("Vehicle No :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c20 = new PdfPCell(myPhrase33);
			c20.setBorder(Rectangle.NO_BORDER);
			t.addCell(c20);
			
			
			Phrase myPhrase34=new Phrase(vehicleno,new Font(baseFont,8, Font.BOLD));
			PdfPCell c21 = new PdfPCell(myPhrase34);
			c21.setBorder(Rectangle.NO_BORDER);
			t.addCell(c21);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
		
	}
	
	private PdfPTable  createTripsheetNo(String tripsheetno) {	
		float[] widths = {10,30,75,20,30,75};
		PdfPTable t = new PdfPTable(6);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase6=new Phrase(" ");
			PdfPCell c24 = new PdfPCell(myPhrase6);
			c24.setBorder(Rectangle.NO_BORDER);
			t.addCell(c24);
			
			Phrase myPhrase31=new Phrase("Tripsheet No :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c18 = new PdfPCell(myPhrase31);
			c18.setBorder(Rectangle.NO_BORDER);
			t.addCell(c18);
			
			
			Phrase myPhrase32=new Phrase(tripsheetno,new Font(baseFont,8, Font.BOLD));
			PdfPCell c19 = new PdfPCell(myPhrase32);
			c19.setBorder(Rectangle.NO_BORDER);
			t.addCell(c19);
			
			myPhrase6=new Phrase(" ");
			PdfPCell c25 = new PdfPCell(myPhrase6);
			c25.setBorder(Rectangle.NO_BORDER);
			t.addCell(c25);
			
			Phrase myPhrase33=new Phrase("Tripsheet No :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c20 = new PdfPCell(myPhrase33);
			c20.setBorder(Rectangle.NO_BORDER);
			t.addCell(c20);
			
			
			Phrase myPhrase34=new Phrase(tripsheetno,new Font(baseFont,8, Font.BOLD));
			PdfPCell c21 = new PdfPCell(myPhrase34);
			c21.setBorder(Rectangle.NO_BORDER);
			t.addCell(c21);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
		
	}
	
	private PdfPTable  createBarcode(String barcode) {	
		float[] widths = {10,30,75,20,30,75};
		PdfPTable t = new PdfPTable(6);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase6=new Phrase(" ");
			PdfPCell c24 = new PdfPCell(myPhrase6);
			c24.setBorder(Rectangle.NO_BORDER);
			t.addCell(c24);
			
			Phrase myPhrase31=new Phrase("Barcode :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c18 = new PdfPCell(myPhrase31);
			c18.setBorder(Rectangle.NO_BORDER);
			t.addCell(c18);
			
			
			Phrase myPhrase32=new Phrase(barcode,new Font(baseFont,8, Font.BOLD));
			PdfPCell c19 = new PdfPCell(myPhrase32);
			c19.setBorder(Rectangle.NO_BORDER);
			t.addCell(c19);
			
			myPhrase6=new Phrase(" ");
			PdfPCell c25 = new PdfPCell(myPhrase6);
			c25.setBorder(Rectangle.NO_BORDER);
			t.addCell(c25);
			
			Phrase myPhrase33=new Phrase("Barcode :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c20 = new PdfPCell(myPhrase33);
			c20.setBorder(Rectangle.NO_BORDER);
			t.addCell(c20);
			
			
			Phrase myPhrase34=new Phrase(barcode,new Font(baseFont,8, Font.BOLD));
			PdfPCell c21 = new PdfPCell(myPhrase34);
			c21.setBorder(Rectangle.NO_BORDER);
			t.addCell(c21);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
		
	}
	
	private PdfPTable  createLoadingPlace(String loadingplace) {	
		float[] widths = {10,30,75,20,30,75};
		PdfPTable t = new PdfPTable(6);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase6=new Phrase(" ");
			PdfPCell c24 = new PdfPCell(myPhrase6);
			c24.setBorder(Rectangle.NO_BORDER);
			t.addCell(c24);
			
			Phrase myPhrase31=new Phrase("Loading Place :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c18 = new PdfPCell(myPhrase31);
			c18.setBorder(Rectangle.NO_BORDER);
			t.addCell(c18);
			
			
			Phrase myPhrase32=new Phrase(loadingplace,new Font(baseFont,8, Font.BOLD));
			PdfPCell c19 = new PdfPCell(myPhrase32);
			c19.setBorder(Rectangle.NO_BORDER);
			t.addCell(c19);
			
			myPhrase6=new Phrase(" ");
			PdfPCell c25 = new PdfPCell(myPhrase6);
			c25.setBorder(Rectangle.NO_BORDER);
			t.addCell(c25);
			
			Phrase myPhrase33=new Phrase("Loading Place :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c20 = new PdfPCell(myPhrase33);
			c20.setBorder(Rectangle.NO_BORDER);
			t.addCell(c20);
			
			
			Phrase myPhrase34=new Phrase(loadingplace,new Font(baseFont,8, Font.BOLD));
			PdfPCell c21 = new PdfPCell(myPhrase34);
			c21.setBorder(Rectangle.NO_BORDER);
			t.addCell(c21);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
		
	}
	
	private PdfPTable  createBuyer(String buyer) {	
		float[] widths = {10,30,75,20,30,75};
		PdfPTable t = new PdfPTable(6);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase6=new Phrase(" ");
			PdfPCell c24 = new PdfPCell(myPhrase6);
			c24.setBorder(Rectangle.NO_BORDER);
			t.addCell(c24);
			
			Phrase myPhrase31=new Phrase("Buyer :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c18 = new PdfPCell(myPhrase31);
			c18.setBorder(Rectangle.NO_BORDER);
			t.addCell(c18);
			
			
			Phrase myPhrase32=new Phrase(buyer,new Font(baseFont,8, Font.BOLD));
			PdfPCell c19 = new PdfPCell(myPhrase32);
			c19.setBorder(Rectangle.NO_BORDER);
			t.addCell(c19);
			
			myPhrase6=new Phrase(" ");
			PdfPCell c25 = new PdfPCell(myPhrase6);
			c25.setBorder(Rectangle.NO_BORDER);
			t.addCell(c25);
			
			Phrase myPhrase33=new Phrase("Buyer :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c20 = new PdfPCell(myPhrase33);
			c20.setBorder(Rectangle.NO_BORDER);
			t.addCell(c20);
			
			
			Phrase myPhrase34=new Phrase(buyer,new Font(baseFont,8, Font.BOLD));
			PdfPCell c21 = new PdfPCell(myPhrase34);
			c21.setBorder(Rectangle.NO_BORDER);
			t.addCell(c21);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
		
	}
	
	private PdfPTable  createRoute(String route,String distance) {	
		float[] widths = {10,30,75,20,30,75};
		PdfPTable t = new PdfPTable(6);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase6=new Phrase(" ");
			PdfPCell c24 = new PdfPCell(myPhrase6);
			c24.setBorder(Rectangle.NO_BORDER);
			t.addCell(c24);
			
			Phrase myPhrase31=new Phrase("Route :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c18 = new PdfPCell(myPhrase31);
			c18.setBorder(Rectangle.NO_BORDER);
			t.addCell(c18);
			
			
			Phrase myPhrase32=new Phrase(route + "( "+distance+" Km)",new Font(baseFont,8, Font.BOLD));
			PdfPCell c19 = new PdfPCell(myPhrase32);
			c19.setBorder(Rectangle.NO_BORDER);
			t.addCell(c19);
			
			myPhrase6=new Phrase(" ");
			PdfPCell c25 = new PdfPCell(myPhrase6);
			c25.setBorder(Rectangle.NO_BORDER);
			t.addCell(c25);
			
			Phrase myPhrase33=new Phrase("Route :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c20 = new PdfPCell(myPhrase33);
			c20.setBorder(Rectangle.NO_BORDER);
			t.addCell(c20);
			
			
			Phrase myPhrase34=new Phrase(route+ " ("+distance+" Km)",new Font(baseFont,8, Font.BOLD));
			PdfPCell c21 = new PdfPCell(myPhrase34);
			c21.setBorder(Rectangle.NO_BORDER);
			t.addCell(c21);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
		
	}
	
	private PdfPTable  createDestination(String destination) {	
		float[] widths = {10,30,75,20,30,75};
		PdfPTable t = new PdfPTable(6);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase6=new Phrase(" ");
			PdfPCell c24 = new PdfPCell(myPhrase6);
			c24.setBorder(Rectangle.NO_BORDER);
			t.addCell(c24);
			
			Phrase myPhrase31=new Phrase("Destination :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c18 = new PdfPCell(myPhrase31);
			c18.setBorder(Rectangle.NO_BORDER);
			t.addCell(c18);
			
			
			Phrase myPhrase32=new Phrase(destination,new Font(baseFont,8, Font.BOLD));
			PdfPCell c19 = new PdfPCell(myPhrase32);
			c19.setBorder(Rectangle.NO_BORDER);
			t.addCell(c19);
			
			myPhrase6=new Phrase(" ");
			PdfPCell c25 = new PdfPCell(myPhrase6);
			c25.setBorder(Rectangle.NO_BORDER);
			t.addCell(c25);
			
			Phrase myPhrase33=new Phrase("Destination :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c20 = new PdfPCell(myPhrase33);
			c20.setBorder(Rectangle.NO_BORDER);
			t.addCell(c20);
			
			
			Phrase myPhrase34=new Phrase(destination,new Font(baseFont,8, Font.BOLD));
			PdfPCell c21 = new PdfPCell(myPhrase34);
			c21.setBorder(Rectangle.NO_BORDER);
			t.addCell(c21);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
		
	}
	
	private PdfPTable  createNote(String note) {	
		float[] widths = {10,15,95,20,15,95};
		PdfPTable t = new PdfPTable(6);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase6=new Phrase(" ");
			PdfPCell c24 = new PdfPCell(myPhrase6);
			c24.setBorder(Rectangle.NO_BORDER);
			t.addCell(c24);
			
			Phrase myPhrase31=new Phrase("NOTE :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c18 = new PdfPCell(myPhrase31);
			c18.setBorder(Rectangle.NO_BORDER);
			t.addCell(c18);
			
			
			Phrase myPhrase32=new Phrase(note,new Font(baseFont,8, Font.BOLD));
			PdfPCell c19 = new PdfPCell(myPhrase32);
			c19.setBorder(Rectangle.NO_BORDER);
			t.addCell(c19);
			
			myPhrase6=new Phrase(" ");
			PdfPCell c25 = new PdfPCell(myPhrase6);
			c25.setBorder(Rectangle.NO_BORDER);
			t.addCell(c25);
			
			Phrase myPhrase33=new Phrase("NOTE :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c20 = new PdfPCell(myPhrase33);
			c20.setBorder(Rectangle.NO_BORDER);
			t.addCell(c20);
			
			
			Phrase myPhrase34=new Phrase(note,new Font(baseFont,8, Font.BOLD));
			PdfPCell c21 = new PdfPCell(myPhrase34);
			c21.setBorder(Rectangle.NO_BORDER);
			t.addCell(c21);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
		
	}
	
	private PdfPTable  createNote1(String note1) {	
		float[] widths = {10,15,95,20,15,95};
		PdfPTable t = new PdfPTable(6);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase6=new Phrase(" ");
			PdfPCell c24 = new PdfPCell(myPhrase6);
			c24.setBorder(Rectangle.NO_BORDER);
			t.addCell(c24);
			
			Phrase myPhrase31=new Phrase(" "+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c18 = new PdfPCell(myPhrase31);
			c18.setBorder(Rectangle.NO_BORDER);
			t.addCell(c18);
			
			
			Phrase myPhrase38=new Phrase("\n"+note1,new Font(baseFont,10, Font.BOLD));
			PdfPCell c20 = new PdfPCell(myPhrase38);
			c20.setBorder(Rectangle.NO_BORDER);
			t.addCell(c20);
			
			myPhrase6=new Phrase(" ");
			PdfPCell c26 = new PdfPCell(myPhrase6);
			c26.setBorder(Rectangle.NO_BORDER);
			t.addCell(c26);
			
			Phrase myPhrase33=new Phrase(" "+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c19 = new PdfPCell(myPhrase33);
			c19.setBorder(Rectangle.NO_BORDER);
			t.addCell(c19);
			
			
			Phrase myPhrase34=new Phrase("\n"+note1,new Font(baseFont,10, Font.BOLD));
			PdfPCell c21 = new PdfPCell(myPhrase34);
			c21.setBorder(Rectangle.NO_BORDER);
			t.addCell(c21);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
		
	}
	
/*	private PdfPTable  createTripsheetType(String triptype) {	
		float[] widths = {10,30,75,20,30,75};
		PdfPTable t = new PdfPTable(6);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase6=new Phrase(" ");
			PdfPCell c24 = new PdfPCell(myPhrase6);
			c24.setBorder(Rectangle.NO_BORDER);
			t.addCell(c24);
			
			Phrase myPhrase31=new Phrase("Loading Type :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c18 = new PdfPCell(myPhrase31);
			c18.setBorder(Rectangle.NO_BORDER);
			t.addCell(c18);
			
			
			Phrase myPhrase32=new Phrase(triptype,new Font(baseFont,8, Font.BOLD));
			PdfPCell c19 = new PdfPCell(myPhrase32);
			c19.setBorder(Rectangle.NO_BORDER);
			t.addCell(c19);
			
			myPhrase6=new Phrase(" ");
			PdfPCell c25 = new PdfPCell(myPhrase6);
			c25.setBorder(Rectangle.NO_BORDER);
			t.addCell(c25);
			
			Phrase myPhrase33=new Phrase("Loading Type :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c20 = new PdfPCell(myPhrase33);
			c20.setBorder(Rectangle.NO_BORDER);
			t.addCell(c20);
			
			
			Phrase myPhrase34=new Phrase(triptype,new Font(baseFont,8, Font.BOLD));
			PdfPCell c21 = new PdfPCell(myPhrase34);
			c21.setBorder(Rectangle.NO_BORDER);
			t.addCell(c21);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
		
	} */
	
	private PdfPTable  createLandType(String landtype) {	
		float[] widths = {10,30,75,20,30,75};
		PdfPTable t = new PdfPTable(6);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase6=new Phrase(" ");
			PdfPCell c24 = new PdfPCell(myPhrase6);
			c24.setBorder(Rectangle.NO_BORDER);
			t.addCell(c24);
			
			Phrase myPhrase31=new Phrase("River Name:"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c18 = new PdfPCell(myPhrase31);
			c18.setBorder(Rectangle.NO_BORDER);
			t.addCell(c18);
			
			
			Phrase myPhrase32=new Phrase(landtype,new Font(baseFont,8, Font.BOLD));
			PdfPCell c19 = new PdfPCell(myPhrase32);
			c19.setBorder(Rectangle.NO_BORDER);
			t.addCell(c19);
			
			myPhrase6=new Phrase(" ");
			PdfPCell c25 = new PdfPCell(myPhrase6);
			c25.setBorder(Rectangle.NO_BORDER);
			t.addCell(c25);
			
			Phrase myPhrase33=new Phrase("River Name:"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c20 = new PdfPCell(myPhrase33);
			c20.setBorder(Rectangle.NO_BORDER);
			t.addCell(c20);
			
			
			Phrase myPhrase34=new Phrase(landtype,new Font(baseFont,8, Font.BOLD));
			PdfPCell c21 = new PdfPCell(myPhrase34);
			c21.setBorder(Rectangle.NO_BORDER);
			t.addCell(c21);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
		
	}
	
	private PdfPTable  createLeaseName(String leasename) {	
		float[] widths = {10,30,75,20,30,75};
		PdfPTable t = new PdfPTable(6);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase6=new Phrase(" ");
			PdfPCell c24 = new PdfPCell(myPhrase6);
			c24.setBorder(Rectangle.NO_BORDER);
			t.addCell(c24);
			
			Phrase myPhrase31=new Phrase("Permit Holder Name :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c18 = new PdfPCell(myPhrase31);
			c18.setBorder(Rectangle.NO_BORDER);
			t.addCell(c18);
			
			
			Phrase myPhrase32=new Phrase(leasename,new Font(baseFont,8, Font.BOLD));
			PdfPCell c19 = new PdfPCell(myPhrase32);
			c19.setBorder(Rectangle.NO_BORDER);
			t.addCell(c19);
			
			myPhrase6=new Phrase(" ");
			PdfPCell c25 = new PdfPCell(myPhrase6);
			c25.setBorder(Rectangle.NO_BORDER);
			t.addCell(c25);
			
			Phrase myPhrase33=new Phrase("Permit Holder Name :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c20 = new PdfPCell(myPhrase33);
			c20.setBorder(Rectangle.NO_BORDER);
			t.addCell(c20);
			
			
			Phrase myPhrase34=new Phrase(leasename,new Font(baseFont,8, Font.BOLD));
			PdfPCell c21 = new PdfPCell(myPhrase34);
			c21.setBorder(Rectangle.NO_BORDER);
			t.addCell(c21);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
		
	}
	
	private PdfPTable   createtempPermitNumber(String tempPermitNumber){	
		float[] widths = {10,30,75,20,30,75};
		PdfPTable t = new PdfPTable(6);
			try{
				t.setWidthPercentage(100);
				t.setWidths(widths);
				
				Phrase myPhrase6=new Phrase(" ");
				PdfPCell c24 = new PdfPCell(myPhrase6);
				c24.setBorder(Rectangle.NO_BORDER);
				t.addCell(c24);
				
				Phrase myPhrase31=new Phrase("Temporary Permit No:"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c18 = new PdfPCell(myPhrase31);
				c18.setBorder(Rectangle.NO_BORDER);
				t.addCell(c18);
				
				
				Phrase myPhrase32=new Phrase(tempPermitNumber,new Font(baseFont,8, Font.BOLD));
				PdfPCell c19 = new PdfPCell(myPhrase32);
				c19.setBorder(Rectangle.NO_BORDER);
				t.addCell(c19);
				
				myPhrase6=new Phrase(" ");
				PdfPCell c25 = new PdfPCell(myPhrase6);
				c25.setBorder(Rectangle.NO_BORDER);
				t.addCell(c25);
				
				Phrase myPhrase33=new Phrase("Temporary Permit No:"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c20 = new PdfPCell(myPhrase33);
				c20.setBorder(Rectangle.NO_BORDER);
				t.addCell(c20);
				
				
				Phrase myPhrase34=new Phrase(tempPermitNumber,new Font(baseFont,8, Font.BOLD));
				PdfPCell c21 = new PdfPCell(myPhrase34);
				c21.setBorder(Rectangle.NO_BORDER);
				t.addCell(c21);
					
				
				
			}
			catch(Exception e )
			{
				e.printStackTrace();
			}
		return t;
	}
	
	
	private PdfPTable  createTalukDistrict(String talukdist) {	
		float[] widths = {10,30,75,20,30,75};
		PdfPTable t = new PdfPTable(6);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase6=new Phrase(" ");
			PdfPCell c24 = new PdfPCell(myPhrase6);
			c24.setBorder(Rectangle.NO_BORDER);
			t.addCell(c24);
			
			Phrase myPhrase31=new Phrase("Taluk :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c18 = new PdfPCell(myPhrase31);
			c18.setBorder(Rectangle.NO_BORDER);
			t.addCell(c18);
			
			
			Phrase myPhrase32=new Phrase(talukdist,new Font(baseFont,8, Font.BOLD));
			PdfPCell c19 = new PdfPCell(myPhrase32);
			c19.setBorder(Rectangle.NO_BORDER);
			t.addCell(c19);
			
			myPhrase6=new Phrase(" ");
			PdfPCell c25 = new PdfPCell(myPhrase6);
			c25.setBorder(Rectangle.NO_BORDER);
			t.addCell(c25);
			
			Phrase myPhrase33=new Phrase("Taluk :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c20 = new PdfPCell(myPhrase33);
			c20.setBorder(Rectangle.NO_BORDER);
			t.addCell(c20);
			
			
			Phrase myPhrase34=new Phrase(talukdist,new Font(baseFont,8, Font.BOLD));
			PdfPCell c21 = new PdfPCell(myPhrase34);
			c21.setBorder(Rectangle.NO_BORDER);
			t.addCell(c21);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
		
	}
	
	private PdfPTable  createMineralGrade(String mingrade) {	
		float[] widths = {10,30,75,20,30,75};
		PdfPTable t = new PdfPTable(6);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase6=new Phrase(" ");
			PdfPCell c24 = new PdfPCell(myPhrase6);
			c24.setBorder(Rectangle.NO_BORDER);
			t.addCell(c24);
			
			Phrase myPhrase31=new Phrase("Mineral/Grade :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c18 = new PdfPCell(myPhrase31);
			c18.setBorder(Rectangle.NO_BORDER);
			t.addCell(c18);
			
			
			Phrase myPhrase32=new Phrase(mingrade,new Font(baseFont,8, Font.BOLD));
			PdfPCell c19 = new PdfPCell(myPhrase32);
			c19.setBorder(Rectangle.NO_BORDER);
			t.addCell(c19);
			
			myPhrase6=new Phrase(" ");
			PdfPCell c25 = new PdfPCell(myPhrase6);
			c25.setBorder(Rectangle.NO_BORDER);
			t.addCell(c25);
			
			Phrase myPhrase33=new Phrase("Mineral/Grade :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c20 = new PdfPCell(myPhrase33);
			c20.setBorder(Rectangle.NO_BORDER);
			t.addCell(c20);
			
			
			Phrase myPhrase34=new Phrase(mingrade,new Font(baseFont,8, Font.BOLD));
			PdfPCell c21 = new PdfPCell(myPhrase34);
			c21.setBorder(Rectangle.NO_BORDER);
			t.addCell(c21);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
		
	}
	
	private PdfPTable  createValidity(String validfrom,String validto,String validityTime) {	
		float[] widths = {10,30,75,20,30,75};
		PdfPTable t = new PdfPTable(6);
		String validatedate=validfrom+" To "+validto;
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase6=new Phrase(" ");
			PdfPCell c24 = new PdfPCell(myPhrase6);
			c24.setBorder(Rectangle.NO_BORDER);
			t.addCell(c24);
			
			Phrase myPhrase31=new Phrase("Validity :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c18 = new PdfPCell(myPhrase31);
			c18.setBorder(Rectangle.NO_BORDER);
			t.addCell(c18);
			
			
			Phrase myPhrase32=new Phrase(validatedate+" ("+validityTime+")",new Font(baseFont,8, Font.BOLD));
			PdfPCell c19 = new PdfPCell(myPhrase32);
			c19.setBorder(Rectangle.NO_BORDER);
			t.addCell(c19);
			
			myPhrase6=new Phrase(" ");
			PdfPCell c25 = new PdfPCell(myPhrase6);
			c25.setBorder(Rectangle.NO_BORDER);
			t.addCell(c25);
			
			Phrase myPhrase33=new Phrase("Validity :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c20 = new PdfPCell(myPhrase33);
			c20.setBorder(Rectangle.NO_BORDER);
			t.addCell(c20);
			
			
			Phrase myPhrase34=new Phrase(validatedate+" ("+validityTime+")",new Font(baseFont,8, Font.BOLD));
			PdfPCell c21 = new PdfPCell(myPhrase34);
			c21.setBorder(Rectangle.NO_BORDER);
			t.addCell(c21);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
		
	}
	
	private PdfPTable  createRoyality(String royality,String currency) {	
		float[] widths = {10,30,75,20,30,75};
		PdfPTable t = new PdfPTable(6);
		//MessageFormat royalityf = new MessageFormat("{0,number,###,###.00}");
		//String royalty = royalityf.format(new Object[]{Integer.valueOf(royality)});
		String royalty=royality;
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase6=new Phrase(" ");
			PdfPCell c24 = new PdfPCell(myPhrase6);
			c24.setBorder(Rectangle.NO_BORDER);
			t.addCell(c24);
			
			Phrase myPhrase31=new Phrase("Royality("+currency+") :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c18 = new PdfPCell(myPhrase31);
			c18.setBorder(Rectangle.NO_BORDER);
			t.addCell(c18);
			
			
			Phrase myPhrase32=new Phrase(royalty,new Font(baseFont,8, Font.BOLD));
			PdfPCell c19 = new PdfPCell(myPhrase32);
			c19.setBorder(Rectangle.NO_BORDER);
			t.addCell(c19);
			
			myPhrase6=new Phrase(" ");
			PdfPCell c25 = new PdfPCell(myPhrase6);
			c25.setBorder(Rectangle.NO_BORDER);
			t.addCell(c25);
			
			Phrase myPhrase33=new Phrase("Royality("+currency+") :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c20 = new PdfPCell(myPhrase33);
			c20.setBorder(Rectangle.NO_BORDER);
			t.addCell(c20);
			
			
			Phrase myPhrase34=new Phrase(royalty,new Font(baseFont,8, Font.BOLD));
			PdfPCell c21 = new PdfPCell(myPhrase34);
			c21.setBorder(Rectangle.NO_BORDER);
			t.addCell(c21);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
		
	}
	
	private PdfPTable  createProcessingfee(String processingfee,String currency) {	
		float[] widths = {10,30,75,20,30,75};
		PdfPTable t = new PdfPTable(6);
		MessageFormat processingfeef = new MessageFormat("{0,number,###,###.00}");
		String processingfeem = processingfeef.format(new Object[]{Integer.valueOf(processingfee)});
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase6=new Phrase(" ");
			PdfPCell c24 = new PdfPCell(myPhrase6);
			c24.setBorder(Rectangle.NO_BORDER);
			t.addCell(c24);
			
			Phrase myPhrase31=new Phrase("Processing Fees("+currency+"):"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c18 = new PdfPCell(myPhrase31);
			c18.setBorder(Rectangle.NO_BORDER);
			t.addCell(c18);
			
			
			Phrase myPhrase32=new Phrase(processingfeem,new Font(baseFont,8, Font.BOLD));
			PdfPCell c19 = new PdfPCell(myPhrase32);
			c19.setBorder(Rectangle.NO_BORDER);
			t.addCell(c19);
			
			myPhrase6=new Phrase(" ");
			PdfPCell c25 = new PdfPCell(myPhrase6);
			c25.setBorder(Rectangle.NO_BORDER);
			t.addCell(c25);
			
			Phrase myPhrase33=new Phrase("Processing Fees("+currency+") :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c20 = new PdfPCell(myPhrase33);
			c20.setBorder(Rectangle.NO_BORDER);
			t.addCell(c20);
			
			
			Phrase myPhrase34=new Phrase(processingfeem,new Font(baseFont,8, Font.BOLD));
			PdfPCell c21 = new PdfPCell(myPhrase34);
			c21.setBorder(Rectangle.NO_BORDER);
			t.addCell(c21);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
		
	}
	
	private PdfPTable  createQty(String qty) {	
		float[] widths = {10,30,75,20,30,75};
		PdfPTable t = new PdfPTable(6);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase6=new Phrase(" ");
			PdfPCell c24 = new PdfPCell(myPhrase6);
			c24.setBorder(Rectangle.NO_BORDER);
			t.addCell(c24);
			
			Phrase myPhrase31=new Phrase("Quantity :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c18 = new PdfPCell(myPhrase31);
			c18.setBorder(Rectangle.NO_BORDER);
			t.addCell(c18);
			
			
			Phrase myPhrase32=new Phrase(qty+" Metric Ton(MT)",new Font(baseFont,8, Font.BOLD));
			PdfPCell c19 = new PdfPCell(myPhrase32);
			c19.setBorder(Rectangle.NO_BORDER);
			t.addCell(c19);
			
			myPhrase6=new Phrase(" ");
			PdfPCell c25 = new PdfPCell(myPhrase6);
			c25.setBorder(Rectangle.NO_BORDER);
			t.addCell(c25);
			
			Phrase myPhrase33=new Phrase("Quantity :"+" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c20 = new PdfPCell(myPhrase33);
			c20.setBorder(Rectangle.NO_BORDER);
			t.addCell(c20);
			
			
			Phrase myPhrase34=new Phrase(qty+" Metric Ton(MT)",new Font(baseFont,8, Font.BOLD));
			PdfPCell c21 = new PdfPCell(myPhrase34);
			c21.setBorder(Rectangle.NO_BORDER);
			t.addCell(c21);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
		
	}

private PdfPTable createBilldata24() {

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
		System.out.println("Error creating bill2 details for SMS Bills : " + e);
		e.printStackTrace();
	}
	return t;	
	
}
	
	private void printBill(ServletOutputStream servletOutputStream,HttpServletResponse response,String bill,String PDForm)
	{
		try
		{
			String formno=PDForm;
			response.setContentType("application/pdf");
			response.setHeader("Content-disposition","attachment;filename="+formno+".pdf");
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

private PdfPTable createBillhead0(String PDForm, HttpServletRequest request)
{
	float[] widths = {60,20,80,20,70};
	PdfPTable t = new PdfPTable(5);
	try
	{
		t.setWidthPercentage(120);
		t.setWidths(widths);

		String path = getServletContext().getRealPath("/")
					+ "jsps/images/govt-kar.gif";
		Image img1 = Image.getInstance(path);

		Phrase myPhrase6 = new Phrase(" ");
		PdfPCell c1 = new PdfPCell(myPhrase6);
		c1.setBackgroundColor(Color.WHITE);
		c1.setBorder(Rectangle.NO_BORDER);
		t.addCell(c1);

		PdfPCell cell = new PdfPCell();
		cell.setHorizontalAlignment(0);
		cell.setBorderColor(Color.white);
		cell.addElement(img1);
		t.addCell(cell);

		myPhrase6 = new Phrase(" ");
		PdfPCell c2 = new PdfPCell(myPhrase6);
		c2.setBackgroundColor(Color.WHITE);
		c2.setBorder(Rectangle.NO_BORDER);
		t.addCell(c2);

		PdfPCell cell1 = new PdfPCell();
		cell1.setHorizontalAlignment(0);
		cell1.setBorderColor(Color.white);
		cell1.addElement(img1);
		t.addCell(cell1);

		myPhrase6 = new Phrase(" ");
		PdfPCell c3 = new PdfPCell(myPhrase6);
		c3.setBackgroundColor(Color.WHITE);
		c3.setBorder(Rectangle.NO_BORDER);
		t.addCell(c3);

		}
	catch (Exception e) 
	{
		System.out.println("Error creating in header : " + e);
		e.printStackTrace();
	}
	return t;

}



}
