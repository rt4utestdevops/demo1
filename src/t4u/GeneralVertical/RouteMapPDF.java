package t4u.GeneralVertical;

import java.awt.Color;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.FactoryConfigurationError;
import javax.xml.parsers.ParserConfigurationException;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.xml.sax.SAXException;

import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.functions.GeneralVerticalFunctions;
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
public class RouteMapPDF extends HttpServlet
{
	static int font=10;
	private static final String GET_LEG_NAMES = " select td.LEG_ID,lm.LEG_NAME from AMS.dbo.TRIP_ROUTE_DETAILS td " +
    " left outer join AMS.dbo.LEG_MASTER lm on lm.ID=td.LEG_ID where ROUTE_ID=? ";
	
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat ddmmyyyyhhmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	BaseFont baseFont = null;
	HistoryAnalysisFunction historyTrackingFunctions= new HistoryAnalysisFunction();
	
	@SuppressWarnings("unchecked")
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		try
		{
			HttpSession session = request.getSession();	
			String routeId = request.getParameter("routeId");
			String routeName = request.getParameter("routeName");
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			
			int systemId = 0;
			@SuppressWarnings("unused")
			int clientId = 0;
			@SuppressWarnings("unused")
			int offset = 0;
			@SuppressWarnings("unused")
			int userId = 0;
			@SuppressWarnings("unused")
			int isLtsp = 0;
			@SuppressWarnings("unused")
			int nonCommHrs = 0;
			@SuppressWarnings("unused")
			String lang = "";
			String zone = "";
			if(loginInfo != null){
				systemId = loginInfo.getSystemId();
				clientId = loginInfo.getCustomerId();
				offset = loginInfo.getOffsetMinutes();
				userId = loginInfo.getUserId();
				isLtsp = loginInfo.getIsLtsp();
				nonCommHrs = loginInfo.getNonCommHrs();
				lang = loginInfo.getLanguage();
				zone = loginInfo.getZone();
			}

			ServletOutputStream servletOutputStream = response.getOutputStream();
		    Properties properties = ApplicationListener.prop;
		    String excelpath =  properties.getProperty("Builtypath");
			refreshdir(excelpath);

			String formno = "TripDetails";
			String fontPath = properties.getProperty("FontPathForMaplePDF");
			baseFont = BaseFont.createFont(fontPath, BaseFont.CP1252, BaseFont.NOT_EMBEDDED); 
			String bill = excelpath+ formno + ".pdf";
			FileOutputStream fileOut = new FileOutputStream(bill);
			Document document = new Document(PageSize.A4, 50, 50, 50, 50);
			PdfWriter writer = PdfWriter.getInstance(document,fileOut);
			
			getImageForMap(routeId,systemId,zone);
			
			ArrayList<ArrayList<String>> arr = getLegNames(routeId);
			document.open();
			generateBill(document,routeId,routeName,arr);
			document.close();
			printBill(servletOutputStream,response,bill,formno);
				
		}
		catch (Exception e) 
		{
			System.out.println("Error in generating TripDetails Print : " + e);
			e.printStackTrace();
		}
	}


	private void generateBill(Document document,String routeId,String routeName,ArrayList<ArrayList<String>> arr) {
		try {
			
			PdfPTable headerTable2= createsecondHeader();
			document.add(headerTable2);
			
			PdfPTable heading = createTableForHeadings(routeName);
			document.add(heading);
			
			PdfPTable image = createImage(routeId);
			document.add(image);
			
			PdfPTable vehicleOtherdetailsTableC=createVehicleOtherDetails(arr);
			document.add(vehicleOtherdetailsTableC);
			
			} catch (Exception e) {
				System.out.println("Error generating report : " + e);
				e.printStackTrace();
			}
	}
	private PdfPTable createTableForHeadings(String routeName) {
		float[] widths = { 70, 20, 50 };
		PdfPTable t = new PdfPTable(3);

		try {
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1 = new Phrase("        ROUTE NAME : " + routeName,new Font(baseFont, 10, Font.NORMAL));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			Phrase myPhrase = new Phrase("", new Font(baseFont, 10,Font.NORMAL));
			PdfPCell c1 = new PdfPCell(myPhrase);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.setBackgroundColor(Color.WHITE);
			t.addCell(c1);

			myPhrase = new Phrase(" ", new Font(baseFont, 9, Font.NORMAL));
			PdfPCell cs = new PdfPCell(myPhrase);
			cs.disableBorderSide(Rectangle.LEFT);
			cs.disableBorderSide(Rectangle.RIGHT);
			cs.disableBorderSide(Rectangle.TOP);
			cs.setBackgroundColor(Color.WHITE);
			t.addCell(cs);

			myPhrase = new Phrase(" ", new Font(baseFont, 9, Font.NORMAL));
			PdfPCell cs1 = new PdfPCell(myPhrase);
			cs1.disableBorderSide(Rectangle.LEFT);
			cs1.disableBorderSide(Rectangle.RIGHT);
			cs1.disableBorderSide(Rectangle.TOP);
			cs1.setBackgroundColor(Color.WHITE);
			t.addCell(cs1);

		} catch (Exception e) {
			System.out.println("Error creating PDF form for Mining :  " + e);
			e.printStackTrace();
		}
		return t;
	}
	private PdfPTable createVehicleOtherDetails(ArrayList<ArrayList<String>> arr) {
		
		PdfPTable mainTable2=new PdfPTable(2);
		float[] regDatewidths = {20,50};
		try {
			mainTable2.setWidthPercentage(100.0f);
			mainTable2.setWidths(regDatewidths);
			
			Phrase vehicle=new Phrase("LEG DEATILS",new Font(baseFont, font, Font.NORMAL));
			PdfPCell vehicleOthercel1 = new PdfPCell(vehicle);
			vehicleOthercel1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			vehicleOthercel1.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel1);
			
			vehicle=new Phrase(" ",new Font(baseFont, 12, Font.NORMAL));
			vehicleOthercel1 = new PdfPCell(vehicle);
			vehicleOthercel1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			vehicleOthercel1.setBorder(Rectangle.NO_BORDER);
			mainTable2.addCell(vehicleOthercel1);
			
			for(int i=0;i<arr.size();i++){
				String legName = arr.get(i).get(0);
				Phrase vehicleOtherPhras=new Phrase("Leg Name "+(i+1)+" :",new Font(baseFont, font, Font.NORMAL));
				PdfPCell vehicleOthercel = new PdfPCell(vehicleOtherPhras);
				vehicleOthercel.setBorder(Rectangle.NO_BORDER);
				mainTable2.addCell(vehicleOthercel);
				
				vehicleOtherPhras=new Phrase(legName,new Font(baseFont, font, Font.NORMAL));
				vehicleOthercel = new PdfPCell(vehicleOtherPhras);
				vehicleOthercel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				vehicleOthercel.setBorder(Rectangle.NO_BORDER);
				mainTable2.addCell(vehicleOthercel);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mainTable2;
	}

	private PdfPTable createImage(String routeId) {

		float[] width = { 16 };
		PdfPTable maintable = new PdfPTable(1);

		try {
			Properties p=ApplicationListener.prop;
			String importedFile=p.getProperty("ImportedFilePath");
			String path = importedFile+"RouteMap_"+routeId+".jpg";
			Image img2 = Image.getInstance(path);

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

			Phrase myc=new Phrase("Route Details",new Font(baseFont, 15, Font.BOLD));
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
		}
		catch (Exception e) 
		{
			System.out.println("Error in printing PO for GST details  : " + e);
			e.printStackTrace();
		}
	}
	@SuppressWarnings("unchecked")
	private void getImageForMap(String routeId,int systemId,String zone) throws JSONException, ParserConfigurationException, FactoryConfigurationError, SAXException {
        try {
        	JSONArray jArr = new JSONArray();
        	JSONArray jArrLeg = new JSONArray();
        	Properties properties = ApplicationListener.prop;
			String key = properties.getProperty("routeGoogleKey");
        	String source = "";
    		String destination = "";
        	String legIds = "";
        	String latlonString="";
        	GeneralVerticalFunctions gf= new GeneralVerticalFunctions();
        	jArrLeg = gf.getLegList(Integer.parseInt(routeId), systemId);
        	
        	JSONObject obj1 = new JSONObject();
			for(int i=0;i<jArrLeg.length();i++){
				obj1 = jArrLeg.getJSONObject(i);
				legIds=legIds +obj1.get("legId")+",";
			}
			legIds=legIds.substring(0,legIds.length()-1);
        	jArr = gf.getLatLongsForCompleteRoute(legIds,systemId,routeId,zone);
        	JSONObject obj = new JSONObject();
        	ArrayList a= new ArrayList();
			for(int i=0;i<jArr.length();i++){
				obj = jArr.getJSONObject(i);
				if(obj.get("type").equals("SOURCE")){
					source = obj.get("lat")+","+obj.get("lon");
				}else if (obj.get("type").equals("DESTINATION")){
					destination = obj.get("lat")+","+obj.get("lon");
				}else{
					latlonString=latlonString+obj.get("lat")+","+obj.get("lon")+"|";
					a.add(obj.get("lat")+","+obj.get("lon"));
				}
			}
			latlonString=latlonString.substring(0,latlonString.length()-1);
    		URL url = new URL("https://maps.googleapis.com/maps/api/directions/json?origin="+source+"&destination="+destination+"&waypoints="+latlonString+"&key="+key);
    		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    		conn.setRequestMethod("GET");
    		String line, outputString = "";
    		BufferedReader reader = new BufferedReader(
    		new InputStreamReader(conn.getInputStream()));
    		while ((line = reader.readLine()) != null) {
    		     outputString += line;
    		}
    		JSONObject json =new JSONObject(outputString);
    		JSONArray elements =new JSONArray(json.getString("routes").toString());
    		JSONObject distancejson =new JSONObject(elements.getString(0));
    		JSONObject metersjson = new JSONObject(distancejson.getString("overview_polyline"));
    		String path= metersjson.getString("points");
        	
    		String markers="&markers=color:green|label:S|" + source+"&markers=color:red|label:D|"+destination;
    		String checkmarkers = "";
    		for(int k=0;k<a.size();k++){
    			checkmarkers=checkmarkers+"&markers=color:blue|label:"+(k+1)+"|" + a.get(k);
    		}
            String imageUrl = "https://maps.googleapis.com/maps/api/staticmap?";
            imageUrl = imageUrl + "&size=1000x500&maptype=roadmap"+markers+checkmarkers+"&path=weight:3|enc:"+path;
			Properties p=ApplicationListener.prop;
			String importedFile=p.getProperty("importedFile");
            String destinationFile = importedFile+"RouteMap_"+routeId+".jpg"; 

            URL URL = new URL(imageUrl);
            InputStream is = URL.openStream();
            OutputStream os = new FileOutputStream(destinationFile);

            byte[] b = new byte[2048];
            int length;

            while ((length = is.read(b)) != -1) {
                os.write(b, 0, length);
            }
            is.close();
            os.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
	}
	@SuppressWarnings("unchecked")
	public ArrayList getLegNames(String routeId) {

		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		ArrayList<ArrayList<String>> finalList = new ArrayList<ArrayList<String>>();
		ArrayList<String> list = new ArrayList<String>();
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_LEG_NAMES);
			pstmt.setString(1,routeId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				list = new ArrayList();
				list.add(rs.getString("LEG_NAME"));
				finalList.add(list);		
			}
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return finalList;
	
	}
}

