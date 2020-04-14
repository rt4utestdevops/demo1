package t4u.GeneralVertical;

import java.awt.Color;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Properties;
import java.util.Scanner;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.functions.CommonFunctions;
import t4u.functions.HistoryAnalysisFunction;

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

@SuppressWarnings("serial")
public class TripSummaryPDF extends HttpServlet
{
	static int font=10;
	private static final String GET_ALERT_COUNT = "select count(ALERT_TYPE) as COUNT,ALERT_TYPE from AMS.dbo.TRIP_EVENT_DETAILS where TRIP_ID=? group by ALERT_TYPE";
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat ddmmyyyyhhmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	BaseFont baseFont = null;
	HistoryAnalysisFunction historyTrackingFunctions= new HistoryAnalysisFunction();
	
	public String GET_SUMMARY_DETAILS= "select isnull(PLANNED_DISTANCE,0) as PLANNED_DISTANCE,isnull(ROUTE_NAME,'') as ROUTE_NAME,isnull(CALIBERATION_STATUS,'') as CALIBERATION_STATUS,isnull(td.ORDER_ID,'') as TRIP_NAME,isnull(ds1.NAME,'') as ORIGIN, isnull(ds.NAME,'') as DESTINATION," +
	" isnull((case when dateadd(mi,?,td.ACTUAL_TRIP_START_TIME) is null then dateadd(mi,?,td.TRIP_START_TIME) else dateadd(mi,?,td.ACTUAL_TRIP_START_TIME) end),'') as START_DATE,"+
	" isnull((case when td.ACTUAL_TRIP_END_TIME is null then 0 else datediff(mi,td.ACTUAL_TRIP_START_TIME,td.ACTUAL_TRIP_END_TIME) end ),'') as TRIP_DURATION,"+ 
	" isnull((case when td.ACTUAL_TRIP_END_TIME is null then 0 else isnull(ACTUAL_DURATION,0) end ),0) as TRAVEL_TIME,isnull((case when isnull(START_ODOMETER,0)=0 THEN GPS_START_ODOMETER ELSE START_ODOMETER end),0) as START_ODOMETER,"+  
	" isnull((case when isnull(END_ODOMETER,0)=0 THEN GPS_END_ODOMETER ELSE END_ODOMETER end),0) as END_ODOMETER ,isnull(td.ACTUAL_DISTANCE,0) as DISTANCE_TRAVELLED, " +
	" (case when td.ACTUAL_TRIP_END_TIME is null then '' else dateadd(mi,?,td.ACTUAL_TRIP_END_TIME) end) as END_DATE " +
	" from AMS.dbo.TRACK_TRIP_DETAILS td"+    
	" left outer join AMS.dbo.DES_TRIP_DETAILS ds on ds.TRIP_ID=td.TRIP_ID and ds.SEQUENCE=100 "+ 	  
	" left outer join AMS.dbo.DES_TRIP_DETAILS ds1 on ds1.TRIP_ID=td.TRIP_ID and ds1.SEQUENCE=0 "+ 
	" where td.TRIP_ID=? ";
	
	public String GET_LEG_DETAILS = " select isnull(d1.Fullname,'') as DRIVER2,isnull(d.Fullname,'') as DRIVER1,isnull(dateadd(mi,?,ACTUAL_ARRIVAL),'') as ATA,isnull(dateadd(mi,?,ACTUAL_DEPARTURE),'') as ATD,LEG_NAME,lz.NAME as SOURCE,lz1.NAME as DESTIANTION,isnull(dateadd(mi,?,STD),'') as STD,isnull(dateadd(mi,?,STA),'') as STA,isnull(TOTAL_DISTANCE,0) as TOTAL_DISTANCE, " +
	" isnull(tl.AVG_SPEED,0) as AVG_SPEED,isnull(FUEL_CONSUMED,0) as FUEL_CONSUMED,isnull(MILEAGE,0) as MILEAGE,isnull(OBD_MILEAGE,0) as OBD_MILEAGE, " +
	" case when ACTUAL_ARRIVAL is null then " +
	" isnull(DATEDIFF(mi,ACTUAL_DEPARTURE,ISNULL(ACTUAL_ARRIVAL,getutcdate())),0) else isnull(DATEDIFF(mi,ACTUAL_DEPARTURE,ACTUAL_ARRIVAL),0)  end as TRAVEL_DURATION " +
	" from TRIP_LEG_DETAILS tl " +
	" left outer join AMS.dbo.LEG_MASTER lm on lm.ID=tl.LEG_ID " +
	" left outer join AMS.dbo.LOCATION_ZONE_A lz on lz.HUBID=lm.SOURCE " +
	" left outer join AMS.dbo.LOCATION_ZONE_A lz1 on lz1.HUBID=lm.DESTINATION " +
	" left outer join AMS.dbo.Driver_Master d on d.Driver_id=tl.DRIVER_1 " +
	" left outer join AMS.dbo.Driver_Master d1 on d1.Driver_id=tl.DRIVER_2 " +
	" where LEG_ID in (select LEG_ID from TRIP_ROUTE_DETAILS where ROUTE_ID =?) and TRIP_ID=? " ; 
	
	public static final String GET_TRIP_EVENT_DETAILS = "select isnull(VEHICLE_NO,'') as vehicleNo,isnull(dateadd(mi,?,GMT),'') as dateTime,isnull(LOCATION,'') as location," +
	" isnull(ALERT_NAME,'') as alertName ,isnull(SPEED,0) as speed,isnull(STOP_HOURS,0) as stoppagetime ,isnull(ALERT_TYPE,0) as alertId  from AMS.dbo.TRIP_EVENT_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and TRIP_ID=?  order by GMT desc";//and ALERT_TYPE not in (105,58)

	@SuppressWarnings("unchecked")
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		try
		{
			HttpSession session = request.getSession();	
			String VehicleNo = request.getParameter("vehicleNo");
			String StartDate = request.getParameter("startDate");
			String EndDate = request.getParameter("endDate");
			String pdfZoom = request.getParameter("pdfzoom");
			String tripId = request.getParameter("tripId");
			String routeId = request.getParameter("routeId");
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			
			int systemId = 0;
			int clientId = 0;
			int offset = 0;
			int userId = 0;
			if(loginInfo != null){
				systemId = loginInfo.getSystemId();
				clientId = loginInfo.getCustomerId();
				offset = loginInfo.getOffsetMinutes();
				userId = loginInfo.getUserId();
			}

			ServletOutputStream servletOutputStream = response.getOutputStream();
		    Properties properties = ApplicationListener.prop;
		    String excelpath =  properties.getProperty("Builtypath");
		    String tripSummaryImagePath = properties.getProperty("tripSummaryImagePath");
		    String googleKey = properties.getProperty("GoogleMapApiKey");
			refreshdir(excelpath);

			String formno = "TripDetails";
			String fontPath = properties.getProperty("FontPathForMaplePDF");
			baseFont = BaseFont.createFont(fontPath, BaseFont.CP1252, BaseFont.NOT_EMBEDDED); 
			String bill = excelpath+ formno + ".pdf";
			FileOutputStream fileOut = new FileOutputStream(bill);
			Document document = new Document(PageSize.A4, 50, 50, 50, 50);
			PdfWriter writer = PdfWriter.getInstance(document,fileOut);
			
			getImageForMap(VehicleNo,StartDate,EndDate,systemId,clientId,offset,userId,pdfZoom,tripSummaryImagePath, googleKey);
			
			ArrayList<Object> mainData = new ArrayList<Object>();
			mainData=getDetailsForGrid(Integer.parseInt(tripId),offset);
			
			ArrayList<Object> alertDetails = new ArrayList<Object>();
			alertDetails=getAlertCount(Integer.parseInt(tripId));
			
			ArrayList<Object> gridDetails = new ArrayList<Object>();
			gridDetails=getDetailsToGrid(Integer.parseInt(tripId),systemId,clientId,offset);
			
			ArrayList<ArrayList<String>> legData = new ArrayList<ArrayList<String>>();
			legData=getLegDeatils(Integer.parseInt(tripId),offset,Integer.parseInt(routeId));
			
			String TripDuration="";
			String TripTravelTime="";
			String StartLocation="";
			String EndLocation="";
			String StartOdomerter="";
			String EndOdometer="";
			String DistanceTraveled="";
			String OSCount="";
			String PanicCount="";
			String HAHBCount ="";
			String StoppageCount="";
			String RouteDeviation="";
				
			TripDuration= (String) mainData.get(0).toString();
			TripTravelTime= (String) mainData.get(1).toString();
			StartLocation= (String) mainData.get(2).toString();
			EndLocation=(String) mainData.get(3).toString();
			StartOdomerter=(String) mainData.get(4).toString();
			EndOdometer=(String) mainData.get(5).toString();
			DistanceTraveled= (String)mainData.get(6).toString();
			String StartDateT = (String)mainData.get(7).toString();
			String EndDateT = (String)mainData.get(8).toString();
			String tripNumber=(String)mainData.get(9).toString();
			String calStatus=(String)mainData.get(10).toString();
			String routeName=(String)mainData.get(11).toString();
			String annexure=(String)mainData.get(12).toString();
			
			OSCount=(String) alertDetails.get(0).toString();
			PanicCount=(String) alertDetails.get(1).toString();
			HAHBCount=(String) alertDetails.get(2).toString();
			StoppageCount=(String) alertDetails.get(3).toString();
			RouteDeviation=(String) alertDetails.get(4).toString();
			String mainPower=(String) alertDetails.get(5).toString();
			
			document.open();
			generateBill(document,VehicleNo,StartDateT,EndDateT,TripDuration,TripTravelTime,StartLocation,EndLocation,StartOdomerter,EndOdometer,DistanceTraveled,OSCount,PanicCount,
					HAHBCount,StoppageCount,RouteDeviation,gridDetails,systemId,tripNumber,mainPower,calStatus,legData,annexure,routeName,tripSummaryImagePath);
			document.close();
			printBill(servletOutputStream,response,bill,formno);
				
		}
		catch (Exception e) 
		{
			System.out.println("Error in generating TripDetails Print : " + e);
			e.printStackTrace();
		}
	}


	@SuppressWarnings("unchecked")
	private void generateBill(Document document,String VehicleNo,String StartDate,String EndDate,String tripDuration,String tripTravelTime, String startLocation, String endLocation,String startOdomerter, String endOdometer, String distanceTraveled,
			String oSCount, String panicCount, String hAHBCount,String stoppageCount, String routeDeviation,ArrayList gridDetails,int systemId,
			String tripNumber,String mainPower,String calStatus,ArrayList<ArrayList<String>> legData,String annexure,String routeName, String tripSummaryImagePath) {
		try {
			
			CommonFunctions cf = new CommonFunctions();
			String UOM = cf.getUnitOfMeasure(systemId);
			PdfPTable headerTable2= createsecondHeader();
			document.add(headerTable2);
			
			PdfPTable image = createImage(tripSummaryImagePath);
			document.add(image);
			
			PdfPTable vehicleOtherdetailsTableA=createVehicleOtherDetailsA();
			document.add(vehicleOtherdetailsTableA);
			
			PdfPTable vehicleOtherdetailsTable=createVehicleOtherDetails(VehicleNo,tripNumber);
			document.add(vehicleOtherdetailsTable);
			
			PdfPTable vehicleOtherdetailsTableR=createVehicleOtherDetailsR(routeName);
			document.add(vehicleOtherdetailsTableR);
			
			PdfPTable vehicleOtherdetailsTableN=createVehicleOtherDetailsN(StartDate,EndDate);
			document.add(vehicleOtherdetailsTableN);
			PdfPTable vehicleOtherdetailsTable1=createVehicleOtherDetails1(tripDuration,tripTravelTime);
			document.add(vehicleOtherdetailsTable1);
			PdfPTable vehicleOtherdetailsTable2=createVehicleOtherDetails2(startLocation,endLocation);
			document.add(vehicleOtherdetailsTable2);
			PdfPTable vehicleOtherdetailsTable3=createVehicleOtherDetails3(startOdomerter, endOdometer,UOM);
			document.add(vehicleOtherdetailsTable3);
			PdfPTable vehicleOtherdetailsTable4=createVehicleOtherDetails4(distanceTraveled,"",UOM,annexure);
			document.add(vehicleOtherdetailsTable4);
			
			PdfPTable vehicleOtherdetailsTableB=createVehicleOtherDetailsB();
			document.add(vehicleOtherdetailsTableB);
			
			PdfPTable vehicleOtherdetailsTable5=createVehicleOtherDetails5(oSCount,panicCount);
			document.add(vehicleOtherdetailsTable5);
			PdfPTable vehicleOtherdetailsTable6=createVehicleOtherDetails6(hAHBCount, stoppageCount,calStatus);
			document.add(vehicleOtherdetailsTable6);
			PdfPTable vehicleOtherdetailsTable7=createVehicleOtherDetails7(routeDeviation,mainPower);
			document.add(vehicleOtherdetailsTable7);
			
			for(int i=0;i<=legData.size()-1;i++){
				PdfPTable LegDetailsHeading=createHeadingorLegDetails(i+1);
				document.add(LegDetailsHeading);
				
				PdfPTable LegDetails1=createLegDetails1(legData.get(i).get(0));
				document.add(LegDetails1);
				
				PdfPTable LegDetails2=createLegDetails2(legData.get(i).get(1),legData.get(i).get(2));
				document.add(LegDetails2);
				
				PdfPTable LegDetails8=createLegDetails8(legData.get(i).get(13),legData.get(i).get(14));
				document.add(LegDetails8);
				
				PdfPTable LegDetails3=createLegDetails3(legData.get(i).get(3),legData.get(i).get(4));
				document.add(LegDetails3);
				
				PdfPTable LegDetails4=createLegDetails4(legData.get(i).get(5),legData.get(i).get(6));
				document.add(LegDetails4);
				
				PdfPTable LegDetails5=createLegDetails5(legData.get(i).get(7),legData.get(i).get(8));
				document.add(LegDetails5);
				
				PdfPTable LegDetails6=createLegDetails6(legData.get(i).get(9),legData.get(i).get(10));
				document.add(LegDetails6);
				
				//PdfPTable LegDetails7=createLegDetails7(legData.get(i).get(11),legData.get(i).get(12));
				//document.add(LegDetails7);
			}
			PdfPTable vehicleOtherdetailsTableC=createVehicleOtherDetailsC();
			document.add(vehicleOtherdetailsTableC);
			
			PdfPTable data=createTableForGrid(gridDetails);
			document.add(data);
			
			} catch (Exception e) {
				System.out.println("Error generating report : " + e);
				e.printStackTrace();
			}
	}
	

	private PdfPTable createImage(String tripSummaryImagePath) {

		float[] width = { 16 };
		PdfPTable maintable = new PdfPTable(1);

		try {
			Image img2 = Image.getInstance(tripSummaryImagePath);

			maintable.setWidthPercentage(100);
			maintable.setWidths(width);

			Phrase myPhrase = new Phrase("", new Font(baseFont, 1, Font.NORMAL));
			PdfPCell ci2 = new PdfPCell(myPhrase);
			ci2.setBackgroundColor(Color.WHITE);
			ci2.setBorder(Rectangle.NO_BORDER);
			maintable.addCell(ci2);

			myPhrase = new Phrase("", new Font(baseFont, 1, Font.NORMAL));
			PdfPCell ci = new PdfPCell(myPhrase);
			ci.setBackgroundColor(Color.WHITE);
			ci.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			ci.addElement(img2);
			ci.setBorder(Rectangle.NO_BORDER);
			ci.disableBorderSide(Rectangle.TOP);
			maintable.addCell(ci);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return maintable;
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

			Phrase myc=new Phrase("Trip Summary Report",new Font(baseFont, 15, Font.BOLD));
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
	@SuppressWarnings("unused")
	private PdfPTable createVehicleDetails(String Vehicle) {
		
		PdfPTable mainTable2=new PdfPTable(2);
		float[] regDatewidths = {20,80};
		
		try {
			mainTable2.setWidthPercentage(100.0f);
			mainTable2.setWidths(regDatewidths);

			Phrase vehicleOtherPhras=new Phrase("Vehicle Number :",new Font(baseFont, font, Font.BOLD));
			PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);
			

			vehicleOtherPhras=new Phrase(Vehicle,new Font(baseFont, font, Font.BOLD));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);


		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable2;
	}
	
	
	private PdfPTable createVehicleOtherDetails(String vehicleNo,String tripNo) {
		
			PdfPTable mainTable2=new PdfPTable(5);
			float[] regDatewidths = {43,50,10,40,50};
			try {
				mainTable2.setWidthPercentage(100.0f);
				mainTable2.setWidths(regDatewidths);

				Phrase vehicleOtherPhras=new Phrase("Vehicle Number :",new Font(baseFont, font, Font.NORMAL));
				PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
				vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
				vehicleOthercel.disableBorderSide(Rectangle.RIGHT);	
				mainTable2.addCell(vehicleOthercel);
				

				vehicleOtherPhras=new Phrase(vehicleNo,new Font(baseFont, font, Font.NORMAL));
				vehicleOthercel = new PdfPCell(vehicleOtherPhras);
				vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
				vehicleOthercel.disableBorderSide(Rectangle.RIGHT);	
				vehicleOthercel.disableBorderSide(Rectangle.LEFT);	
				mainTable2.addCell(vehicleOthercel);

				vehicleOtherPhras=new Phrase("",new Font(baseFont, font, Font.NORMAL));
				vehicleOthercel = new PdfPCell(vehicleOtherPhras);
				vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
				vehicleOthercel.disableBorderSide(Rectangle.RIGHT);	
				vehicleOthercel.disableBorderSide(Rectangle.LEFT);	
				mainTable2.addCell(vehicleOthercel); 

				vehicleOtherPhras=new Phrase("Trip Number :",new Font(baseFont, font, Font.NORMAL));
				vehicleOthercel = new PdfPCell(vehicleOtherPhras);
				vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
				vehicleOthercel.disableBorderSide(Rectangle.RIGHT);	
				vehicleOthercel.disableBorderSide(Rectangle.LEFT);	
				mainTable2.addCell(vehicleOthercel);

				vehicleOtherPhras=new Phrase(tripNo,new Font(baseFont, font, Font.NORMAL));
				vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				vehicleOthercel = new PdfPCell(vehicleOtherPhras);
				vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
				vehicleOthercel.disableBorderSide(Rectangle.LEFT);	
				mainTable2.addCell(vehicleOthercel);

			} catch (Exception e) {
				e.printStackTrace();
			}
			return mainTable2;
		}
	private PdfPTable createVehicleOtherDetailsN(String startDate,String endDate) {
		
		PdfPTable mainTable2=new PdfPTable(5);
		float[] regDatewidths = {43,50,10,40,50};
		try {
			mainTable2.setWidthPercentage(100.0f);
			mainTable2.setWidths(regDatewidths);

			Phrase vehicleOtherPhras=new Phrase("Start Date :",new Font(baseFont, font, Font.NORMAL));
			PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
			vehicleOthercel.disableBorderSide(Rectangle.RIGHT);	
			vehicleOthercel.disableBorderSide(Rectangle.TOP);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(startDate,new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel); 

			vehicleOtherPhras=new Phrase("End Date :",new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(endDate,new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
			vehicleOthercel.disableBorderSide(Rectangle.LEFT);	
			vehicleOthercel.disableBorderSide(Rectangle.TOP);
			mainTable2.addCell(vehicleOthercel);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable2;
	}
private PdfPTable createVehicleOtherDetailsR(String routeName) {
		
		PdfPTable mainTable2=new PdfPTable(2);
		float[] regDatewidths = {20,70};
		try {
			mainTable2.setWidthPercentage(100.0f);
			mainTable2.setWidths(regDatewidths);

			Phrase vehicleOtherPhras=new Phrase("Route :",new Font(baseFont, font, Font.NORMAL));
			PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
			vehicleOthercel.disableBorderSide(Rectangle.RIGHT);	
			vehicleOthercel.disableBorderSide(Rectangle.TOP);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(routeName,new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
			vehicleOthercel.disableBorderSide(Rectangle.LEFT);	
			vehicleOthercel.disableBorderSide(Rectangle.TOP);
			mainTable2.addCell(vehicleOthercel);


		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable2;
	}
	private PdfPTable createVehicleOtherDetails1( String tripDuration, String tripTravelTime) {
		
		PdfPTable mainTable2=new PdfPTable(5);
		float[] regDatewidths = {43,50,10,40,50};
		CommonFunctions cf =new CommonFunctions();
		try {
			mainTable2.setWidthPercentage(100.0f);
			mainTable2.setWidths(regDatewidths);

			Phrase vehicleOtherPhras=new Phrase("Duration :",new Font(baseFont, font, Font.NORMAL));
			PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
			vehicleOthercel.disableBorderSide(Rectangle.RIGHT);	
			vehicleOthercel.disableBorderSide(Rectangle.TOP);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(tripDuration+" (HH.mm)",new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel); 

			vehicleOtherPhras=new Phrase("Travel Time :",new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(cf.convertMinutesToHHMMFormat1(Integer.parseInt(tripTravelTime))+" (HH.mm)",new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
			vehicleOthercel.disableBorderSide(Rectangle.LEFT);	
			vehicleOthercel.disableBorderSide(Rectangle.TOP);
			mainTable2.addCell(vehicleOthercel);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable2;
	}
	private PdfPTable createVehicleOtherDetails2(String startLocation, String endLocation) {
		
		PdfPTable mainTable2=new PdfPTable(5);
		float[] regDatewidths ={43,50,10,40,50};
		try {
			mainTable2.setWidthPercentage(100.0f);
			mainTable2.setWidths(regDatewidths);

			Phrase vehicleOtherPhras=new Phrase("Start Location :",new Font(baseFont, font, Font.NORMAL));
			PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
			vehicleOthercel.disableBorderSide(Rectangle.RIGHT);	
			vehicleOthercel.disableBorderSide(Rectangle.TOP);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(startLocation,new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel); 

			vehicleOtherPhras=new Phrase("End Location :",new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(endLocation,new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
			vehicleOthercel.disableBorderSide(Rectangle.LEFT);	
			vehicleOthercel.disableBorderSide(Rectangle.TOP);
			mainTable2.addCell(vehicleOthercel);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable2;
	}
	private PdfPTable createVehicleOtherDetails3(String startOdomerter,String endOdometer,String UOM) {
		
		PdfPTable mainTable2=new PdfPTable(5);
		float[] regDatewidths ={43,50,10,40,50};
		DecimalFormat df = new DecimalFormat("00.00");
		String startOdomerterS=df.format(Double.parseDouble(startOdomerter));
		String endOdometerS=df.format(Double.parseDouble(endOdometer));
		try {
			mainTable2.setWidthPercentage(100.0f);
			mainTable2.setWidths(regDatewidths);

			Phrase vehicleOtherPhras=new Phrase("Start Odometer :",new Font(baseFont, font, Font.NORMAL));
			PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
			vehicleOthercel.disableBorderSide(Rectangle.RIGHT);	
			vehicleOthercel.disableBorderSide(Rectangle.TOP);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(startOdomerterS+" "+"("+UOM.toLowerCase()+")",new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel); 

			vehicleOtherPhras=new Phrase("End Odometer :",new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			vehicleOthercel.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(endOdometerS+" "+"("+UOM.toLowerCase()+")",new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
			vehicleOthercel.disableBorderSide(Rectangle.LEFT);	
			vehicleOthercel.disableBorderSide(Rectangle.TOP);
			mainTable2.addCell(vehicleOthercel);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable2;
	}
	private PdfPTable createVehicleOtherDetails4(String distanceTraveled,String newone,String UOM,String annexure) {
		
		PdfPTable mainTable2=new PdfPTable(5);
		float[] regDatewidths = {43,50,10,40,50};
		String distanceTraveledD="0";
		DecimalFormat df = new DecimalFormat("00.00");
		if(UOM.equals("Miles")){
			distanceTraveledD = df.format(Double.parseDouble(distanceTraveled) * 0.621371); 
		}else{
			distanceTraveledD = df.format(Double.parseDouble(distanceTraveled)); 
		}
		try {
			mainTable2.setWidthPercentage(100.0f);
			mainTable2.setWidths(regDatewidths);

			Phrase vehicleOtherPhras=new Phrase("Distance Travelled :",new Font(baseFont, font, Font.NORMAL));
			PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.disableBorderSide(Rectangle.TOP);
			vehicleOthercel.disableBorderSide(Rectangle.RIGHT);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(distanceTraveledD+" "+"("+UOM.toLowerCase()+")",new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			vehicleOthercel.disableBorderSide(Rectangle.LEFT);
			vehicleOthercel.disableBorderSide(Rectangle.RIGHT);	
			vehicleOthercel.disableBorderSide(Rectangle.TOP);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.disableBorderSide(Rectangle.LEFT);
			vehicleOthercel.disableBorderSide(Rectangle.RIGHT);	
			vehicleOthercel.disableBorderSide(Rectangle.TOP);
			mainTable2.addCell(vehicleOthercel); 

			vehicleOtherPhras=new Phrase("Annexure :",new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.disableBorderSide(Rectangle.LEFT);
			vehicleOthercel.disableBorderSide(Rectangle.RIGHT);	
			vehicleOthercel.disableBorderSide(Rectangle.TOP);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(annexure+" "+"("+UOM.toLowerCase()+")",new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.disableBorderSide(Rectangle.LEFT);
			vehicleOthercel.disableBorderSide(Rectangle.TOP);
			mainTable2.addCell(vehicleOthercel);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable2;
	}
	

	
private PdfPTable createLegDetails1(String legName) {
	
	PdfPTable mainTable2=new PdfPTable(5);
	float[] regDatewidths = {40,50,20,40,50};
	try {
		mainTable2.setWidthPercentage(100.0f);
		mainTable2.setWidths(regDatewidths);

		Phrase vehicleOtherPhras=new Phrase("Leg Name  :",new Font(baseFont, font, Font.NORMAL));
		PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase( legName,new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase("",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		mainTable2.addCell(vehicleOthercel); 

		vehicleOtherPhras=new Phrase("",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase("",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
		mainTable2.addCell(vehicleOthercel);

	} catch (Exception e) {
		e.printStackTrace();
	}
	return mainTable2;
}
private PdfPTable createLegDetails2(String source,String destination) {
	
	PdfPTable mainTable2=new PdfPTable(5);
	float[] regDatewidths = {40,50,20,40,50};
	try {
		mainTable2.setWidthPercentage(100.0f);
		mainTable2.setWidths(regDatewidths);

		Phrase vehicleOtherPhras=new Phrase("Source  :",new Font(baseFont, font, Font.NORMAL));
		PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase( source,new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase("",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel); 

		vehicleOtherPhras=new Phrase("Destination :",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase(destination,new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
		mainTable2.addCell(vehicleOthercel);

	} catch (Exception e) {
		e.printStackTrace();
	}
	return mainTable2;
}
private PdfPTable createLegDetails3(String travelTime,String travelDistance) {
	
	PdfPTable mainTable2=new PdfPTable(5);
	float[] regDatewidths = {40,50,20,40,50};
	try {
		mainTable2.setWidthPercentage(100.0f);
		mainTable2.setWidths(regDatewidths);

		Phrase vehicleOtherPhras=new Phrase("Travel Time :",new Font(baseFont, font, Font.NORMAL));
		PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase( convertMinutesToHHMMFormat(Integer.parseInt(travelTime))+" (HH.mm)",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase("",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel); 

		vehicleOtherPhras=new Phrase("Travel Distance :",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase(travelDistance+" Kms",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
		mainTable2.addCell(vehicleOthercel);

	} catch (Exception e) {
		e.printStackTrace();
	}
	return mainTable2;
}
private PdfPTable createLegDetails4(String std,String sta) {
	
	PdfPTable mainTable2=new PdfPTable(5);
	float[] regDatewidths = {40,50,20,40,50};
	try {
		mainTable2.setWidthPercentage(100.0f);
		mainTable2.setWidths(regDatewidths);

		Phrase vehicleOtherPhras=new Phrase("STD  :",new Font(baseFont, font, Font.NORMAL));
		PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase( std,new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase("",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel); 

		vehicleOtherPhras=new Phrase("STA :",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase(sta,new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
		mainTable2.addCell(vehicleOthercel);

	} catch (Exception e) {
		e.printStackTrace();
	}
	return mainTable2;
}
private PdfPTable createLegDetails5(String ata,String atd) {
	
	PdfPTable mainTable2=new PdfPTable(5);
	float[] regDatewidths = {40,50,20,40,50};
	try {
		mainTable2.setWidthPercentage(100.0f);
		mainTable2.setWidths(regDatewidths);

		Phrase vehicleOtherPhras=new Phrase("ATD  :",new Font(baseFont, font, Font.NORMAL));
		PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase( atd,new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase("",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel); 

		vehicleOtherPhras=new Phrase("ATA :",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase(ata,new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
		mainTable2.addCell(vehicleOthercel);

	} catch (Exception e) {
		e.printStackTrace();
	}
	return mainTable2;
}
private PdfPTable createLegDetails6(String avgSpeed,String fuelConsumed) {
	
	PdfPTable mainTable2=new PdfPTable(5);
	float[] regDatewidths = {40,50,20,40,50};
	try {
		mainTable2.setWidthPercentage(100.0f);
		mainTable2.setWidths(regDatewidths);

		Phrase vehicleOtherPhras=new Phrase("Average Speed  :",new Font(baseFont, font, Font.NORMAL));
		PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase( avgSpeed+" Km/h",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase(" ",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		mainTable2.addCell(vehicleOthercel); 

		vehicleOtherPhras=new Phrase("",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase("",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		mainTable2.addCell(vehicleOthercel);

	} catch (Exception e) {
		e.printStackTrace();
	}
	return mainTable2;
}
@SuppressWarnings("unused")
private PdfPTable createLegDetails7(String mileage,String OBDMileage) {
	
	PdfPTable mainTable2=new PdfPTable(5);
	float[] regDatewidths = {40,50,20,40,50};
	try {
		mainTable2.setWidthPercentage(100.0f);
		mainTable2.setWidths(regDatewidths);

		Phrase vehicleOtherPhras=new Phrase("Mileage  :",new Font(baseFont, font, Font.NORMAL));
		PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase( mileage,new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase("",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);
		mainTable2.addCell(vehicleOthercel); 

		vehicleOtherPhras=new Phrase("OBD Mileage",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase(OBDMileage,new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		mainTable2.addCell(vehicleOthercel);

	} catch (Exception e) {
		e.printStackTrace();
	}
	return mainTable2;
}
private PdfPTable createLegDetails8(String driver1,String driver2) {
	
	PdfPTable mainTable2=new PdfPTable(5);
	float[] regDatewidths = {40,50,20,40,50};
	try {
		mainTable2.setWidthPercentage(100.0f);
		mainTable2.setWidths(regDatewidths);

		Phrase vehicleOtherPhras=new Phrase("Driver 1 :",new Font(baseFont, font, Font.NORMAL));
		PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase( driver1,new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase("",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel); 

		vehicleOtherPhras=new Phrase("Driver 2 :",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase(driver2,new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
		mainTable2.addCell(vehicleOthercel);

	} catch (Exception e) {
		e.printStackTrace();
	}
	return mainTable2;
}
private PdfPTable createVehicleOtherDetails6(String HAHB,String Stoppage,String calStatus) {
	
	PdfPTable mainTable2=new PdfPTable(5);
	float[] regDatewidths ={40,50,20,40,50};
	try {
		mainTable2.setWidthPercentage(100.0f);
		mainTable2.setWidths(regDatewidths);

		Phrase vehicleOtherPhras=new Phrase("Harsh Alerts : ",new Font(baseFont, font, Font.NORMAL));
		PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);	
		mainTable2.addCell(vehicleOthercel);
		
		vehicleOtherPhras=new Phrase(HAHB +" Counts "+calStatus,new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase("",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase("Stoppage :",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase(Stoppage+" Counts",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		mainTable2.addCell(vehicleOthercel);

	} catch (Exception e) {
		e.printStackTrace();
	}
	return mainTable2;
}
private PdfPTable createVehicleOtherDetails7(String Route,String mainPower) {
	
	PdfPTable mainTable2=new PdfPTable(5);
	float[] regDatewidths ={40,50,20,40,50};
	try {
		mainTable2.setWidthPercentage(100.0f);
		mainTable2.setWidths(regDatewidths);

		Phrase vehicleOtherPhras=new Phrase("Route Deviation :",new Font(baseFont, font, Font.NORMAL));
		PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase( Route+" Counts",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);	
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase("",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);	
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		mainTable2.addCell(vehicleOthercel); 

		vehicleOtherPhras=new Phrase("Main Power ON/OFF :",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.RIGHT);	
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		mainTable2.addCell(vehicleOthercel);

		vehicleOtherPhras=new Phrase(mainPower+" Counts",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.LEFT);
		vehicleOthercel.disableBorderSide(Rectangle.TOP);
		mainTable2.addCell(vehicleOthercel);

	} catch (Exception e) {
		e.printStackTrace();
	}
	return mainTable2;
}
private PdfPTable createVehicleOtherDetailsA() {
	
	PdfPTable mainTable2=new PdfPTable(1);
	float[] regDatewidths = {100};
	try {
		mainTable2.setWidthPercentage(100.0f);
		mainTable2.setWidths(regDatewidths);

		Phrase vehicleOtherPhras=new Phrase("Trip Summary",new Font(baseFont, 12, Font.BOLD));
		PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel);
		
		vehicleOtherPhras=new Phrase(" ",new Font(baseFont, font, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel);


	} catch (Exception e) {
		e.printStackTrace();
	}
	return mainTable2;
}

private PdfPTable createVehicleOtherDetailsB() {
	
	PdfPTable mainTable2=new PdfPTable(1);
	float[] regDatewidths = {100};
	try {
		mainTable2.setWidthPercentage(100.0f);
		mainTable2.setWidths(regDatewidths);

		Phrase vehicleOtherPhras=new Phrase(" ",new Font(baseFont, 10, Font.BOLD));
		PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel); 
		
		vehicleOtherPhras=new Phrase("Vehicle Safety Details",new Font(baseFont, 12, Font.BOLD));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel);
		
		vehicleOtherPhras=new Phrase(" ",new Font(baseFont, 12, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel); 

	} catch (Exception e) {
		e.printStackTrace();
	}
	return mainTable2;
}
private PdfPTable createHeadingorLegDetails(int i) {
	
	PdfPTable mainTable2=new PdfPTable(1);
	float[] regDatewidths = {100};
	try {
		mainTable2.setWidthPercentage(100.0f);
		mainTable2.setWidths(regDatewidths);

		Phrase vehicleOtherPhras=new Phrase(" ",new Font(baseFont, 10, Font.BOLD));
		PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel); 
		
		vehicleOtherPhras=new Phrase("Leg-"+i+" Details",new Font(baseFont, 12, Font.BOLD));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel);
		
		vehicleOtherPhras=new Phrase(" ",new Font(baseFont, 12, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel); 

	} catch (Exception e) {
		e.printStackTrace();
	}
	return mainTable2;
}
private PdfPTable createVehicleOtherDetailsC() {
	
	PdfPTable mainTable2=new PdfPTable(1);
	float[] regDatewidths = {100};
	try {
		mainTable2.setWidthPercentage(100.0f);
		mainTable2.setWidths(regDatewidths);

		Phrase vehicleOtherPhras=new Phrase(" ",new Font(baseFont, 10, Font.BOLD));
		PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel); 
		
		vehicleOtherPhras=new Phrase("Alert Details",new Font(baseFont, 12, Font.BOLD));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel);
		
		vehicleOtherPhras=new Phrase(" ",new Font(baseFont, 12, Font.NORMAL));
		vehicleOthercel = new PdfPCell(vehicleOtherPhras);
		vehicleOthercel.setBorder(Rectangle.NO_BORDER);
		mainTable2.addCell(vehicleOthercel); 

	} catch (Exception e) {
		e.printStackTrace();
	}
	return mainTable2;
}

private PdfPTable createTableForGrid(ArrayList<Object> gridData)
{
	float[] widths = {15,50,30,30};
	PdfPTable t = new PdfPTable(4);
	
	try
	{
		t.setWidthPercentage(100);
		t.setWidths(widths);
		
		Phrase myPhrase=new Phrase("Sl No",new Font(baseFont,10, Font.BOLD));
		PdfPCell c2 = new PdfPCell(myPhrase);
		c2.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
		c2.setBackgroundColor(Color.LIGHT_GRAY);
		t.addCell(c2);
		
		 myPhrase=new Phrase("Location",new Font(baseFont,10, Font.BOLD));
		 c2 = new PdfPCell(myPhrase);
		 c2.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
		 c2.setBackgroundColor(Color.LIGHT_GRAY);
		 t.addCell(c2);
		
		myPhrase=new Phrase("Date Time",new Font(baseFont, 10, Font.BOLD));
		PdfPCell c3 = new PdfPCell(myPhrase);
		c3.setBackgroundColor(Color.LIGHT_GRAY);
		c3.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
		t.addCell(c3);
		
		myPhrase=new Phrase("Alert",new Font(baseFont,10, Font.BOLD));
		PdfPCell c4 = new PdfPCell(myPhrase);
		c4.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
		c4.setBackgroundColor(Color.LIGHT_GRAY);
		t.addCell(c4);
		
		if(gridData.size()>0){
			for(int i=0;i<gridData.size();i++){
				myPhrase=new Phrase((String) gridData.get(i),new Font(baseFont,9, Font.NORMAL));
				PdfPCell c9 = new PdfPCell(myPhrase);
				c9.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				c9.setBackgroundColor(Color.WHITE);
				t.addCell(c9);
			}
		}
	}
	catch (Exception e) 
	{
		System.out.println("Error creating PDF form for Mining  : " + e);
		e.printStackTrace();
	}
	return t;	
}
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
			System.out.println("Error creating folder for GST Report: " + e);
			e.printStackTrace();
		}
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
			fis.close();
		}
		catch (Exception e) 
		{
			System.out.println("Error in printing PO for GST details  : " + e);
			e.printStackTrace();
		}
	}
private PdfPTable createVehicleOtherDetails5(String OS,String Panic) {
		
		PdfPTable mainTable2=new PdfPTable(5);
		float[] regDatewidths = {40,50,20,40,50};
		try {
			mainTable2.setWidthPercentage(100.0f);
			mainTable2.setWidths(regDatewidths);

			Phrase vehicleOtherPhras=new Phrase("Over Speed  :",new Font(baseFont, font, Font.NORMAL));
			PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			
			vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
			vehicleOthercel.disableBorderSide(Rectangle.RIGHT);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase( OS +" Counts",new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			vehicleOthercel.disableBorderSide(Rectangle.LEFT);
			vehicleOthercel.disableBorderSide(Rectangle.RIGHT);	
			vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.disableBorderSide(Rectangle.LEFT);
			vehicleOthercel.disableBorderSide(Rectangle.RIGHT);	
			vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
			mainTable2.addCell(vehicleOthercel); 

			vehicleOtherPhras=new Phrase("Panic :",new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.disableBorderSide(Rectangle.LEFT);
			vehicleOthercel.disableBorderSide(Rectangle.RIGHT);	
			vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
			mainTable2.addCell(vehicleOthercel);

			vehicleOtherPhras=new Phrase(Panic+" Counts",new Font(baseFont, font, Font.NORMAL));
			vehicleOthercel = new PdfPCell(vehicleOtherPhras);
			vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			vehicleOthercel.disableBorderSide(Rectangle.LEFT);
			vehicleOthercel.disableBorderSide(Rectangle.BOTTOM);
			mainTable2.addCell(vehicleOthercel);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable2;
	}
	private void getImageForMap(String VehicleNo,String StartDate,String EndDate,int systemId,int clientId,int offset,int userId,String pdfZoom, String tripSummaryImagePath, String googleKey) throws JSONException {
        try {
        	int pdfZoomInt=9;
        	if(pdfZoom!=null){
        		pdfZoomInt=Integer.parseInt(pdfZoom)-1;
        	}
        	String latlonString="";
            String marker = "";
            JSONArray jArr= new JSONArray();
            jArr = historyTrackingFunctions.getVehicleTrackingHistory(VehicleNo,StartDate,EndDate, offset, systemId, clientId, 0,"0","0",userId);
            JSONObject obj=new JSONObject();
            obj=(JSONObject) jArr.get(0);
            JSONArray jarray=new JSONArray();
            jarray= (JSONArray) obj.get("datalist");
            System.out.println(jarray.length());
            int k=3;
            if(jarray.length()>200){
            	k=6;
            }
            if(jarray.length()>500){
            	k=9;
            }
            if(jarray.length()>1000){
            	k=18;
            }
            if(jarray.length()>4000){
            	k=30;
            }
            if(jarray.length()>5000){
            	k=45;
            }
            if(jarray.length()>10000){
            	k=60;
            }
            if(jarray.length()>12000){
            	k = 75;
            }
            if(jarray.length()>15000){
            	k=105;
            }
            if(jarray.length()>20000){
            	k=156;
            }
            if(jarray.length()>25000){
            	k=210;
            }
            if(jarray.length()>30000){
            	k=270;
            }
            if(jarray.length()>40000){
            	k = 450;
            }
            if(jarray.length() > 50000){
            	k = 600;
            }
            System.out.println(k);
            String lastPoint="";
            String firstlatlon="";
            for(int i=0;i<jarray.length();){
            	String latlon=(Double) jarray.get(i)+","+(Double) jarray.get(i+1);
                firstlatlon=(Double) jarray.get(0)+","+(Double) jarray.get(1);
            	latlonString=latlonString+latlon+"|";
            	i=i+k;
            	lastPoint=(Double) jarray.get(jarray.length()-3)+","+(Double) jarray.get(jarray.length()-2)+"|";
            }
            latlonString=latlonString+lastPoint;
            String location = firstlatlon;
            
            Scanner sc = new Scanner(location);
            Scanner sc2 = new Scanner(location);
            String imageUrl = "https://maps.googleapis.com/maps/api/staticmap?";
            while (sc.hasNext()) {
                imageUrl = imageUrl + sc.next();
            }
            marker = "&markers="+"icon:http://telematics4u.in/ApplicationImages/VehicleImages/redcirclemarker.png"+"|"+firstlatlon+
            "&markers="+"|"+lastPoint+"|" ;
            
            marker = marker.substring(0, marker.length() - 1);
            if(latlonString.length()>0){
            	 latlonString = latlonString.substring(0, latlonString.length() - 1);
            }
            String googleKeyStr = "&key="+googleKey;
            String path = googleKeyStr+"&path=color:darkgreen|weight:5|"+latlonString;
            imageUrl = imageUrl + "&size=620x300&scale=2&maptype=terrain&zoom="+pdfZoomInt+marker+path;
            System.out.println(imageUrl.length());

            URL url = new URL(imageUrl);
            InputStream is = url.openStream();
            OutputStream os = new FileOutputStream(tripSummaryImagePath);

            byte[] b = new byte[2048];
            int length;

            while ((length = is.read(b)) != -1) {
                os.write(b, 0, length);
            }
            is.close();
            os.close();
            sc.close();
            sc2.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
	}
	public ArrayList<Object> getDetailsForGrid(int  id,int offset) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> informationList = new ArrayList<Object>();
		try {
			int count=0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_SUMMARY_DETAILS);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				informationList.add(convertMinutesToHHMMFormat(rs.getInt("TRIP_DURATION")));
				informationList.add( rs.getInt("TRAVEL_TIME"));
				informationList.add( rs.getString("ORIGIN"));
				informationList.add( rs.getString("DESTINATION"));
				informationList.add( rs.getString("START_ODOMETER"));
				informationList.add( rs.getString("END_ODOMETER"));
				informationList.add( rs.getString("DISTANCE_TRAVELLED"));
				
				if(rs.getString("START_DATE").contains("1900")){
					informationList.add("");
				}else{
					informationList.add( ddmmyyyyhhmmss.format(rs.getTimestamp("START_DATE")));
				}
				if(rs.getString("END_DATE").contains("1900")){
					informationList.add("");
				}else{
					informationList.add( ddmmyyyyhhmmss.format(rs.getTimestamp("END_DATE")));
				}
				informationList.add( rs.getString("TRIP_NAME"));
				informationList.add( rs.getString("CALIBERATION_STATUS"));
				informationList.add( rs.getString("ROUTE_NAME"));
				informationList.add( rs.getString("PLANNED_DISTANCE"));
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return informationList;
	}
	
	public ArrayList<Object> getAlertCount(int  id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> informationList = new ArrayList<Object>();
		String overSpeed="0";
		String panic="0";
		String stoppage="0";
		String deviation="0";
		String mainPower="0";
		try {
			int count=0;
			int HCount=0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_ALERT_COUNT);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				if(rs.getInt("ALERT_TYPE")==2){
					overSpeed = rs.getString("COUNT");
				}
				if(rs.getInt("ALERT_TYPE")==3){
					panic = rs.getString("COUNT");
				}
				if(rs.getInt("ALERT_TYPE")==58 ||rs.getInt("ALERT_TYPE")==105 || rs.getInt("ALERT_TYPE")==106){
					HCount=HCount+ rs.getInt("COUNT");
				}
				
				if(rs.getInt("ALERT_TYPE")==1){
					stoppage = rs.getString("COUNT");
				}
				
				if(rs.getInt("ALERT_TYPE")==5){
					deviation = rs.getString("COUNT");
				}
				if(rs.getInt("ALERT_TYPE")==7){
					mainPower = rs.getString("COUNT");
				}
			}
			informationList.add(overSpeed);
			informationList.add(panic);
			informationList.add(HCount);
			informationList.add(stoppage);
			informationList.add(deviation);
			informationList.add(mainPower);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return informationList;
	}
	
	@SuppressWarnings("unchecked")
	public ArrayList getDetailsToGrid(int  id,int systemId,int clientId,int offset) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count=0;
		String location = "";
		double overspeed = 0;
		CommonFunctions cf = new CommonFunctions();
		DecimalFormat df = new DecimalFormat("00.00");
		ArrayList<Object> informationList = new ArrayList<Object>();
		try {
			String unit = cf.getUnitOfMeasure(systemId);
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_TRIP_EVENT_DETAILS);
			pstmt.setInt(1,offset);
			pstmt.setInt(2,systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				informationList.add( String.valueOf(count));
				if(unit.equals("Miles")){
					overspeed = rs.getDouble("speed") * 0.621371; 
				}else{
					overspeed = rs.getDouble("speed");
				}
				if(rs.getInt("alertId") == 2){
					location = df.format(overspeed)+" "+unit+"/Hr overspeed "+rs.getString("location");
				}else if(rs.getInt("alertId") == 1){	
					String stpphrs=rs.getString("stoppagetime");
					if(stpphrs.contains(".")){
						stpphrs=df.format(rs.getDouble("stoppagetime"));
					}					
					location = stpphrs.replace('.', ':')+"(HH:mm) stoppage, "+rs.getString("location");
				}else{
					location = rs.getString("location");
				}
				informationList.add(location);
				informationList.add( ddmmyyyyhhmmss.format(rs.getTimestamp("datetime")));
				informationList.add( rs.getString("alertName"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return informationList;
	}
	public ArrayList<ArrayList<String>> getLegDeatils(int  id,int offset,int routeId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> informationList = new ArrayList<String>();
		ArrayList<ArrayList<String>> list = new ArrayList<ArrayList<String>>();
		try {
			int count=0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_LEG_DETAILS);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, routeId);
			pstmt.setInt(6, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				informationList = new ArrayList<String>();
				count++;
				informationList.add( rs.getString("LEG_NAME"));
				informationList.add( rs.getString("SOURCE"));
				informationList.add( rs.getString("DESTIANTION"));
				informationList.add( rs.getString("TRAVEL_DURATION"));
				informationList.add( rs.getString("TOTAL_DISTANCE"));
				if(rs.getString("STD").contains("1900")){
					informationList.add("");
				}else{
					informationList.add( ddmmyyyyhhmmss.format(rs.getTimestamp("STD")));
				}
				if(rs.getString("STA").contains("1900")){
					informationList.add("");
				}else{
					informationList.add( ddmmyyyyhhmmss.format(rs.getTimestamp("STA")));
				}
				if(rs.getString("ATA").contains("1900")){
					informationList.add("");
				}else{
					informationList.add( ddmmyyyyhhmmss.format(rs.getTimestamp("ATA")));
				}
				if(rs.getString("ATD").contains("1900")){
					informationList.add("");
				}else{
					informationList.add( ddmmyyyyhhmmss.format(rs.getTimestamp("ATD")));
				}
				informationList.add( rs.getString("AVG_SPEED"));
				informationList.add( rs.getString("FUEL_CONSUMED"));
				informationList.add( rs.getString("MILEAGE"));
				informationList.add( rs.getString("OBD_MILEAGE"));
				informationList.add( rs.getString("DRIVER1"));
				informationList.add( rs.getString("DRIVER2"));
				list.add(informationList);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return list;
	}
	public String convertMinutesToHHMMFormat(int minutes) 
	{
		String duration="";
		
		long durationHrslong = minutes / 60;
		String durationHrs = String.valueOf(durationHrslong);
		if(durationHrs.length()==1)
		{
			durationHrs = "0"+ durationHrs;
		}
		
		long durationMinsLong = minutes % 60;
		String durationMins = String.valueOf(durationMinsLong);
		if(durationMins.length()==1)
		{
			durationMins = "0"+ durationMins;
		}
		
		duration = durationHrs + "." + durationMins;
		
		return duration;
	}
}

