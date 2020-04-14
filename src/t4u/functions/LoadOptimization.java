package t4u.functions;

import java.io.File;
import java.io.FileInputStream;

import org.apache.commons.lang.SystemUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.codehaus.plexus.util.cli.CommandLineException;
import org.codehaus.plexus.util.cli.CommandLineUtils;
import org.codehaus.plexus.util.cli.Commandline;
import org.codehaus.plexus.util.cli.WriterStreamConsumer;


import java.io.BufferedReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;


import org.jdom.Document;
import org.jdom.Element;
import org.jdom.output.XMLOutputter;
import org.json.JSONException;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.t4u.osm.DistanceBean;
import com.t4u.osm.DistanceJar;

import t4u.beans.MapAPIConfigBean;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.statements.LoadAndTripPlannerStatements;
import t4u.statements.OrderStatements;
import t4u.util.LatLng;
import t4u.util.MapAPIUtil;
import t4u.util.TimeAndDistanceCalculator;
import tool.LoadAndRoutePlanner;

public class LoadOptimization  {

	 ArrayList<Double> lat1=null;
	 ArrayList<Double> lng1=null;
	 ArrayList<Integer> priority = null;
	 ArrayList<String> deliveryTime=null;
	 ArrayList<String> destination=null;
	 String key="";
	 String vehicleSpeed="";
	 MapAPIUtil mapAPIUtil = new MapAPIUtil();
	 TimeAndDistanceCalculator tdc  = new TimeAndDistanceCalculator();

	public  boolean xmlsCreate(String uniqueId,int systemId,int customerId,String folderName)
	{	
		System.out.println("XML CREATION Starts......");
		boolean xmlgenearted=false;
		Properties properties = ApplicationListener.prop;
		FileInputStream in;
		Connection con=null;
		try {
			 priority = new ArrayList<Integer>();
			deliveryTime=new ArrayList<String>();
		    destination=new ArrayList<String>();
			lat1=new ArrayList<Double>();
		    lng1=new ArrayList<Double>();
			con = DBConnection.getConnectionToDB("AMS");
			key = properties.getProperty("googleTripKey").trim();
			System.out.println(key);
			String sourceLatLng=properties.getProperty("sourceLatLng");
			String StartTime=properties.getProperty("stratTime");
			String loadingEfficiency=properties.getProperty("loading_efficiency");
			String durationLimit=properties.getProperty("duration_limit");
			String unloadingDuration=properties.getProperty("unloading_duration");
			vehicleSpeed=properties.getProperty("vehicleSpeed");
			destination.add("s1");
			deliveryTime.add("00:00");
			priority.add(0);
			
			if(!(sourceLatLng.equalsIgnoreCase(null) && sourceLatLng.equalsIgnoreCase("") )){
				String[] source=sourceLatLng.split(",", 0);
				double lat=Double.parseDouble(source[0]);
				double lng=Double.parseDouble(source[1]);
				lat1.add(lat);
				lng1.add(lng);
			}else{
				lat1.add(23.671589);
				lng1.add(57.930499);
			}

			routeReader(con,uniqueId,systemId,customerId,folderName);
			xmlgenearted=createRouteXML(folderName,systemId);
			createStockAndOrderXML(con,uniqueId,systemId,customerId,folderName);
			createVehicleXML(con,systemId,customerId,folderName,StartTime);
			createInitXml(loadingEfficiency,durationLimit,unloadingDuration,folderName);
			
		} catch (Exception e) {
			e.printStackTrace();
			xmlgenearted=false;
		} finally{
			DBConnection.releaseConnectionToDB(con, null, null);
			System.out.println("XML CREATION ENDS......");
		}
		return xmlgenearted;
	}

	public    boolean routeReader(Connection conn,String uniqueId,int systemId,int customerId,String folderName){
		PreparedStatement statement=null;
		ResultSet rs=null;
		boolean status=false;
		try {
			File directory = new File(folderName);
			if (! directory.exists()){
				directory.mkdirs();
			}
			
			String previousDest="";
			statement = conn.prepareStatement(OrderStatements.GET_ROUTE_DETAILS);
			statement.setInt(1, systemId);
			statement.setInt(2, customerId);
			statement.setString(3, uniqueId);
			rs = statement.executeQuery();
			if (rs != null) {
				 status=true;
				while (rs.next()) {
					String currentDest=rs.getString("DESTINATION_NUMBER");
					if(!(previousDest.equalsIgnoreCase(currentDest))){
						String[] dt=rs.getString("DELIVERY_TIME").split("-");
						lat1.add(rs.getDouble("LATITUDE"));
						lng1.add(rs.getDouble("LONGITUDE"));
						priority.add(rs.getInt("PRIORITY"));
						destination.add(currentDest);
						deliveryTime.add((dt.length>1? new SimpleDateFormat("HH:mm").format(new SimpleDateFormat("hh.mm aa").parse(dt[1])):"18:00"));
					}

					previousDest=currentDest;
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
			 status=false;
		}finally {
			DBConnection.releaseConnectionToDB(null, statement, rs);
		}
		return status;
	}

	public   boolean createRouteXML(String folderName,Integer  systemId)
	{
		boolean status=false;
		MapAPIConfigBean mapAPIConfigBean = null;
		try
		{	
			mapAPIConfigBean = mapAPIUtil.getConfiguration(systemId);

			int size=lng1.size();
			ArrayList<Double> dis;
			double [][] duration=new double[size][size];
			double [][] distance=new double[size][size];
			int [][] degreeArray=new int[size][size];
			String [][] deliveryTimeArray=new String[size][size];
			int [][] priorityArray=new int[size][size];


			for(int row=0;row<distance.length;row++){
				for(int col=0;col<distance[row].length;col++){
					if(row==col){
						distance[row][col]=0.0;
						duration[row][col]=0.0;
					}else{
						/*dis=getDestinationFromOsm(lat1.get(row),lng1.get(row),lat1.get(col),lng1.get(col));
						DecimalFormat df = new DecimalFormat("#.0");
						double googleDistance= (double) dis.get(0);
						double calulatedDuration=(googleDistance/Double.parseDouble(vehicleSpeed));
						calulatedDuration=calulatedDuration*60;
						calulatedDuration=calulatedDuration>1?calulatedDuration:1.0;
					//	double googleDuration= (double) dis.get(1);
						distance[row][col]=Double.parseDouble(df.format(googleDistance));
						duration[row][col]=Double.parseDouble(df.format(calulatedDuration));*/
						
						dis=getDestinationFromOsm(lat1.get(row),lng1.get(row),lat1.get(col),lng1.get(col));
						if(dis.size()==0){
							dis= new ArrayList<Double>();
							dis=getDestination(lat1.get(row),lng1.get(row),lat1.get(col),lng1.get(col),key,mapAPIConfigBean);
							DecimalFormat df = new DecimalFormat("#.0");
							double googleDistance= (double) dis.get(0);
							double calulatedDuration=(googleDistance/Double.parseDouble(vehicleSpeed));
							calulatedDuration=calulatedDuration*60;
							calulatedDuration=calulatedDuration>1?calulatedDuration:1.0;
							System.out.println("google computed" );
						//	double googleDuration= (double) dis.get(1);
							distance[row][col]=Double.parseDouble(df.format(googleDistance));
							duration[row][col]=Double.parseDouble(df.format(calulatedDuration));
						}else{
							DecimalFormat df = new DecimalFormat("#.0");
							double osmDistance = dis.get(0);
							double osmEat=dis.get(1);   
							double configuredETA=(osmDistance/Double.parseDouble(vehicleSpeed));
							configuredETA=configuredETA*60;
							configuredETA=configuredETA>1?configuredETA:1;
							distance[row][col]=osmDistance;
							duration[row][col]=Double.parseDouble(df.format(configuredETA));
						}
						
					}

					if(row==0){
						int degree=(int) bearingBetweenLocations(lat1.get(row),lng1.get(row),lat1.get(col),lng1.get(col));
						degreeArray[row][col]=(degree==0) ? 1 : degree;
						deliveryTimeArray[row][col]=deliveryTime.get(col);
						priorityArray[row][col]=priority.get(col);

					}

				}
				l=0;
			}

			Element company = new Element("LoadAndRoutePlanner_route");
			Document doc = new Document(company);
			doc.setRootElement(company);
			for(int row=0;row<duration.length;row++){
				StringBuffer dur=new StringBuffer();
				StringBuffer dist=new StringBuffer();
				StringBuffer degree=new StringBuffer();
				StringBuffer dtime=new StringBuffer();
				StringBuffer prty=new StringBuffer();
				doc.getRootElement().addContent("\n\n\t");
				Element route = new Element("route");
				route.addContent("\n\t\t");
				route.addContent(new Element("start").setText(destination.get(row)));

				for(int col=0;col<duration[row].length;col++){
					double d1=  (double) distance[row][col];
					double t1=  (double) duration[row][col];
					int deg= degreeArray[row][col];
					String dt=  (String) deliveryTimeArray[row][col];
					int p1=  (int) priorityArray[row][col];

					dist.append(String.valueOf(d1));
					dist.append("\t");

					dur.append(String.valueOf(t1));
					dur.append("\t");
					if(row==0){
						degree.append(String.valueOf(deg));
						degree.append("\t");	
						dtime.append(dt);
						dtime.append("\t");
						if(dt.equalsIgnoreCase("18:00")){
							prty.append("2");
							prty.append("\t");
						}else{
							prty.append("1");
							prty.append("\t");
						}
						
						
					}


				}
				route.addContent("\n\t\t");
				route.addContent(new Element("distance").setText(dist.toString().trim()));
				route.addContent("\n\t\t");
				route.addContent(new Element("duration").setText(dur.toString().trim()));
			//	route.addContent("\n\t\t");
				if(row==0){
					route.addContent("\n\t\t");
					route.addContent(new Element("zone").setText(degree.toString().trim()));
					route.addContent("\n\t\t");
					route.addContent(new Element("eta").setText(dtime.toString().trim()));
					route.addContent("\n\t\t");
					route.addContent(new Element("priority").setText(prty.toString().trim()));
					//	route.addContent("\n\t\t");

				}
				route.addContent("\n\t");
				doc.getRootElement().addContent(route);

			}
			doc.getRootElement().addContent("\n\n");

			XMLOutputter xmlOutput = new XMLOutputter();

			// display nice nice
			//xmlOutput.setFormat(Format.getPrettyFormat().setIndent("\t"));

			File file = new File(folderName+"/route.xml");
			if (file.exists() && file.isFile())
			{
						System.out.println("file exists, and it is a file");
			}else{
				file.createNewFile();
			}
			xmlOutput.output(doc, new FileWriter(folderName+"/route.xml"));
			System.out.println("Route XML Saved!");
			 status=true;
		}
		catch(Exception e)
		{
			e.printStackTrace();
			 status=false;
		}
		return status;

	}

	/*
	 * 
	 * method to get distance from google API
	 */
	public  ArrayList<Double> getDestination(double srclat,double srclng,double deslat,double deslng,String key,MapAPIConfigBean mapAPIConfigBean) throws Exception
	{
		ArrayList<Double> disDur= new ArrayList<Double>();
//		Long dd1= 0l;
//		Long dd2=0l;
		List<LatLng> latlongs = new ArrayList<LatLng>();
		double distance1 = 0;
		double  duration1 = 0;
		latlongs.add(new LatLng(srclat, srclng));
		latlongs.add(new LatLng(deslat, deslng));
		
		org.json.JSONObject json = tdc.calculateTimeAndDistance(latlongs, mapAPIConfigBean);
		
		if (json.length() > 0){
			  try {
				 // converting to miles    
				distance1=(json.getDouble("distanceInKms"))/ 1.609344;  
				duration1=json.getDouble("durationInMins");
			} catch (JSONException e) {
				e.printStackTrace();
			}
			  
		}

//			URL url = new URL("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins="+srclat+","+srclng+"&destinations="+deslat+","+deslng+"&mode=driving&key="+key);
//			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
//			conn.setRequestMethod("GET");
//			conn.setRequestProperty("Accept", "application/json");
//
//			if (conn.getResponseCode() != 200) {
//				throw new RuntimeException("Failed : HTTP error code : "
//						+ conn.getResponseCode());
//			}
//
//			BufferedReader br = new BufferedReader(new InputStreamReader(
//					(conn.getInputStream())));
//
//			String output;
//
//			StringBuffer outputRest=new StringBuffer();
//			while ((output = br.readLine()) != null) {
//				outputRest.append(output);
//			}
//			String st=new String(outputRest);
//			Object obj=JSONValue.parse(st.trim());
//			JSONObject jsonObject = (JSONObject) obj;
//			JSONArray slideContent = (JSONArray) jsonObject.get("rows");
//
//			Iterator i = slideContent.iterator();
//
//			JSONObject jobj=(JSONObject)i.next();
//			JSONArray title = (JSONArray) jobj.get("elements");
//			JSONObject dur= (JSONObject)title.get(0);
//			JSONObject value=(JSONObject)dur.get("distance");
//			JSONObject value01=(JSONObject)dur.get("duration");
//
//			if(value==null){
//
//			}else{
//				dd1=(Long)value.get("value");
//				dd2=(Long)value01.get("value");
//			}
//			double distance1=(double) dd1/1000;
//			double duration1=(double) dd2/60;
		
		
		disDur.add(distance1>1?distance1:1);
		disDur.add(duration1>1?duration1:1);
//			conn.disconnect();
		return disDur;
	}
	/*
	 * 
	 * method to get distance from google API
	 */
	public   ArrayList<Double> getDestinationFromOsm(double srclat,double srclng,double deslat,double deslng)
	{
		//System.out.println(srclat+","+srclng+","+deslat+","+deslng);
		ArrayList<Double> disDur= null;
		try {
			disDur=new ArrayList<Double>();
			DistanceJar distanceJar = new DistanceJar();
			DistanceBean db = distanceJar.getDistance(srclat, srclng, deslat, deslng);
			if(db!=null){
				double  eta=(double) db.getTimeinMins();
				disDur.add(db.getDistanceinKms()>1?db.getDistanceinKms():1.0);
				disDur.add(eta>1?eta:1);
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return disDur;
	}

	public   void createStockAndOrderXML(Connection conn,String uniqueId,int systemId,int customerId,String folderName)
	{
		PreparedStatement statement=null;
		ResultSet rs=null;
		try {

			Element company = new Element("LoadAndRoutePlanner_order");
			Document doc = new Document(company);
			doc.setRootElement(company);


			Element stockXml = new Element("LoadAndRoutePlanner_stock");
			Document doc1 = new Document(stockXml);
			doc1.setRootElement(stockXml);
			StringBuffer s1=new StringBuffer();
			statement = conn.prepareStatement(OrderStatements.GET_STOCK_AND_ORDER);
			statement.setInt(1, systemId);
			statement.setInt(2, customerId);
			statement.setString(3, uniqueId);
			rs = statement.executeQuery();
			if (rs != null) {
				while (rs.next()) {
					Element order=null;
					doc.getRootElement().addContent("\n");
					order = new Element("order");
					doc.getRootElement().addContent("\n\t");
					order.addContent("\n\t\t");
					order.addContent(new Element("destination").setText(rs.getString("DESTINATION_NUMBER")));
					order.addContent("\n\t\t");
					order.addContent(new Element("source").setText("s1"));
					order.addContent("\n\t\t");
					order.addContent(new Element("customer").setText(rs.getString("CUSTOMER_NAME")));
					order.addContent("\n\t\t");
					order.addContent(new Element("id").setText(rs.getString("ORDER_NO")));
					order.addContent("\n\t\t");
					if(rs.getString("WEIGHT_UNIT").equalsIgnoreCase("KG"))
					{
						order.addContent(new Element("weight").setText(rs.getString("TOTAL_WEIGHT")));
					}
					else{
						order.addContent(new Element("weight").setText(String.valueOf(rs.getFloat("TOTAL_WEIGHT")/1000)));
					}
					s1.append(String.valueOf(rs.getString("ORDER_NO"))+"\t");
					order.addContent("\n\t");
					doc.getRootElement().addContent(order);
				//	doc.getRootElement().addContent("\n");
				}
				doc.getRootElement().addContent("\n\n");
			}

			doc1.getRootElement().addContent("\n");
			Element stock = new Element("stock");
			doc1.getRootElement().addContent("\n\t");
			stock.addContent("\n\t\t");
			stock.addContent(new Element("source").setText("s1"));
			stock.addContent("\n\t\t");
			stock.addContent(new Element("order").setText(s1.toString().trim()));
			stock.addContent("\n\t\t");
			StringBuffer destn = new StringBuffer();
			for (int i = 1; i < destination.size(); i++) {
				destn.append(destination.get(i));
				destn.append("\t");
			}
			stock.addContent(new Element("destinations").setText(destn.toString().trim()));
			stock.addContent("\t\n\t");
			doc1.getRootElement().addContent(stock);
			doc1.getRootElement().addContent("\n\n");

			XMLOutputter xmlOutput = new XMLOutputter();
			// display nice nice
			//	xmlOutput.setFormat(Format.getPrettyFormat().setIndent("\t"));
			File orderfile = new File(folderName+"/order.xml");

			if (orderfile.exists() && orderfile.isFile())
			{
				//System.out.println("file exists, and it is a orderfile");
			}else{
				orderfile.createNewFile();
			}

			File file = new File(folderName+"/stock.xml");

			if (file.exists() && file.isFile())
			{
				//System.out.println("file exists, and it is a file");
			}else{
				file.createNewFile();
			}
			xmlOutput.output(doc, new FileWriter(folderName+"/order.xml"));
			xmlOutput.output(doc1, new FileWriter(folderName+"/stock.xml"));

			System.out.println("Order and Stock XML Saved!");


		} catch (Exception io) {
			io.printStackTrace();
			System.out.println(">>>>>>>>>>>>>>"+io.getLocalizedMessage());
		}finally {
			DBConnection.releaseConnectionToDB(null, statement, rs);
		}

	}


	public   void createVehicleXML(Connection conn,int systemId,int customerId,String folderName,String StartTime)
	{
		PreparedStatement statement=null;
		ResultSet rs=null;
		try {

			Element vehRoot = new Element("LoadAndRoutePlanner_vehicle");
			Document doc = new Document(vehRoot);
			doc.setRootElement(vehRoot);
			statement = conn.prepareStatement(OrderStatements.GET_FREE_VEHICLES);
			statement.setInt(1, systemId);
			statement.setInt(2, customerId);
			rs = statement.executeQuery();
			
				while (rs.next()) {
					doc.getRootElement().addContent("\n\n\t");
					Element vehicle= new Element("vehicle");
					vehicle.addContent("\n\t\t");
					vehicle.addContent(new Element("reg_num").setText(rs.getString("VehicleNo")));
					vehicle.addContent("\n\t\t");
					vehicle.addContent(new Element("location").setText("s1"));
					vehicle.addContent("\n\t\t");
					vehicle.addContent(new Element("capacity").setText(rs.getString("LoadingCapacity")));
					vehicle.addContent("\n\t\t");
					vehicle.addContent(new Element("start_time").setText(StartTime));  // configured in propertyFile
					vehicle.addContent("\t\n\t");
					doc.getRootElement().addContent(vehicle);
				}
				doc.getRootElement().addContent("\n\n");
		


			XMLOutputter xmlOutput = new XMLOutputter();
			//	xmlOutput.setFormat(Format.getPrettyFormat().setIndent("\t"));
			File vehiclefile = new File(folderName+"/vehicle.xml");

			if (vehiclefile.exists() && vehiclefile.isFile())
			{
				//System.out.println("file exists, and it is a orderfile");
			}else{
				vehiclefile.createNewFile();
			}

			xmlOutput.output(doc, new FileWriter(folderName+"/vehicle.xml"));

			System.out.println("vehicle XML Saved!");


		} catch (Exception io) {
			io.printStackTrace();
			System.out.println(">>>>>>>>>>>>>>"+io.getLocalizedMessage());
		}finally{
			DBConnection.releaseConnectionToDB(null, statement, rs);
		}

	}
	
	public   void createInitXml(String loadingEfficiency,String durationLimit,String unloadingDuration,String folderName)
	{
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
		    Calendar calendar = Calendar.getInstance();
		    // add one day to the date/calendar
		    calendar.add(Calendar.DAY_OF_YEAR, 1);
		    Date tomorrow = calendar.getTime();
           
			Element LoadAndRoutePlanner_init = new Element("LoadAndRoutePlanner_init");
			Document doc = new Document(LoadAndRoutePlanner_init);
			doc.setRootElement(LoadAndRoutePlanner_init);
			doc.getRootElement().addContent("\n\n\t");
			Element init= new Element("init");
			init.addContent("\n\t\t");
			init.addContent(new Element("plan_date").setText(sdf.format(tomorrow)));
			init.addContent("\n\t\t");
			init.addContent(new Element("loading_efficiency").setText(loadingEfficiency));
			init.addContent("\n\t\t");
			init.addContent(new Element("duration_limit").setText(durationLimit));
			init.addContent("\n\t\t");
			init.addContent(new Element("unloading_duration").setText(unloadingDuration));  
			init.addContent("\t\n\t");
			doc.getRootElement().addContent(init);
			doc.getRootElement().addContent("\n\n");


			XMLOutputter xmlOutput = new XMLOutputter();
			//	xmlOutput.setFormat(Format.getPrettyFormat().setIndent("\t"));
			File vehiclefile = new File(folderName+"/init.xml");

			if (vehiclefile.exists() && vehiclefile.isFile())
			{
				//System.out.println("file exists, and it is a orderfile");
			}else{
				vehiclefile.createNewFile();
			}

			xmlOutput.output(doc, new FileWriter(folderName+"/init.xml"));

			System.out.println("init XML Saved!");


		} catch (Exception io) {
			io.printStackTrace();
			System.out.println(">>>>>>>>>>>>>>"+io.getLocalizedMessage());
		}

	}

	static int l=0;

	private    double bearingBetweenLocations(double slat ,double slng,double dlat, double dlng) {

		double PI = 3.14159;
		double lat1 = slat * PI / 180;
		double long1 = slng * PI / 180;
		double lat2 = dlat * PI / 180;
		double long2 = dlng * PI / 180;

		double dLon = (long2 - long1);

		double y = Math.sin(dLon) * Math.cos(lat2);
		double x = Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1)
		* Math.cos(lat2) * Math.cos(dLon);

		double brng = Math.atan2(y, x);

		brng = Math.toDegrees(brng);
		//  System.out.print(l++ +"----"+brng+"----------");
		brng = (brng + 360) % 360;
		brng = (360-brng)+90;
		//   System.out.println("--------------------------"+brng);

		int zone=0;
		if(brng>90 && brng<270){
			//	System.out.println(brng+"----if-----1 ");
			zone=1;
		}else if(brng==450){
			zone=1;
		}else {
			//System.out.println(brng+"----else-----2 ");
			zone=2;
		}

		return zone;
	}	
	
	
	public String ImportExcelDatatoDb(int systemId,int customerId, int userId){
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean importEcxel=false;
		String uniqueCode="";
		try {
			System.out.println("*************** Excel Reading  Starts   ***************");
			con=DBConnection.getConnectionToDB("AMS"); 
			
			Properties properties = ApplicationListener.prop;
			String readPath=properties.getProperty("fileUploadPath");
			
			String previd = "";
			String excelFilePath ="";// readPath+"\\LoadPlanner.xlsx";//"C://LoadPlanner/excel1.xlsx";
			if(SystemUtils.IS_OS_LINUX || SystemUtils.IS_OS_UNIX){
				excelFilePath=readPath+"/LoadPlanner.xlsx";
	    	 }else{
	    		 excelFilePath=readPath+"\\LoadPlanner.xlsx";
	    	 } 
			FileInputStream inputStream = new FileInputStream(new File(excelFilePath));
			Workbook workbook = new XSSFWorkbook(inputStream);
			Sheet firstSheet = workbook.getSheetAt(0);
			Iterator<Row> iterator = firstSheet.iterator();
		
			int destinatiopnOrder=0;
			SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMddHHmmss");
			SimpleDateFormat sdfDB=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat sdf2=new SimpleDateFormat("dd.MM.yyyy");
			int orderCount=0;
			Date date=new Date();
			
			 uniqueCode="Plan"+sdf.format(date);
			int count=0;
			boolean rowExists=false;
			
			while (iterator.hasNext()) {
				Row nextRow = iterator.next();
				Iterator<Cell> cellIterator = nextRow.cellIterator();
				
				
				int priority=0;
				String customerNo="";
				String customerName="";
				double lattitude=0.0;
				double longitude=0.0;
				String orderNumber="";
				String orderDate="";
				double orderValue=0.0;
				String delivery="";
				String deliveryDate="";
				String deliveryTime="";
				double totalWeight=0.0;
				String weihgtUnit="";
				double totalVolume=0.0;
				String volumeUnit="";
				
				while (cellIterator.hasNext()) {
					Cell cell = cellIterator.next();
					if(cell.getRowIndex()>1){
						int columnNo=cell.getColumnIndex();
						switch (columnNo) {
						case 1: priority=(int)cell.getNumericCellValue();
						count++;
						rowExists=true;
							break;
						case 2: long custId=(long)cell.getNumericCellValue();
							customerNo= String.valueOf(custId);
						if(customerNo.equals(previd)){
							//destinatiopnOrder;
						}else{
							++destinatiopnOrder;
						}
						previd=customerNo;
							break;
						case 3: customerName= cell.toString();
							break;
						case 4: lattitude = cell.getNumericCellValue();
							break;
						case 5: longitude= cell.getNumericCellValue();
							break;
						case 6:  long orderId=(long)cell.getNumericCellValue();
						orderNumber= String.valueOf(orderId);
							break;
						case 7: orderDate = cell.toString();
							break;
						case 8: orderValue= cell.getNumericCellValue();
							break;
						case 9: delivery = cell.toString();
						break;
						case 10: deliveryDate= cell.toString();
							break;
						case 11: deliveryTime= cell.toString();
							break;
						case 12: totalWeight= cell.getNumericCellValue();
							break;
						case 13: weihgtUnit= cell.toString();
								if(weihgtUnit.equalsIgnoreCase("KG")){
								   	 
							     }else{
							     totalWeight=totalWeight/1000;
							   	 weihgtUnit="KG";
							     }
						break;
						case 14: totalVolume= cell.getNumericCellValue();
						break;
						case 15: volumeUnit= cell.toString();
						break;
						default:
							break;
						}
					}	

				}
				
				
				//&& destinatiopnOrder<21
				if(rowExists)
				{
				pstmt = con.prepareStatement(LoadAndTripPlannerStatements.INSERT_EXCEL_DATA);
				pstmt.setInt(1,priority);
				pstmt.setString(2, customerNo);
				pstmt.setString(3, customerName);
				pstmt.setDouble(4, lattitude);
				pstmt.setDouble(5, longitude);
				pstmt.setInt(6, ++orderCount);
				pstmt.setString(7, sdfDB.format(sdf2.parse(orderDate)));
				pstmt.setDouble(8, orderValue);
				pstmt.setString(9, delivery);
				pstmt.setString(10,sdfDB.format(sdf2.parse(deliveryDate)));
				pstmt.setString(11, deliveryTime);
				pstmt.setDouble(12, totalWeight);
				pstmt.setString(13, weihgtUnit);
				pstmt.setDouble(14, totalVolume);
				pstmt.setString(15, volumeUnit);
				pstmt.setString(16, uniqueCode);
				pstmt.setString(17, "d"+destinatiopnOrder);
				pstmt.setInt(18, systemId);
				pstmt.setInt(19, customerId);
				pstmt.setInt(20, userId);
				
				int x=pstmt.executeUpdate();
				if(x>0){
					importEcxel=true;
				}
				
				}
			}
			if(!importEcxel){
				uniqueCode="failure";
			}
			
			System.out.println(count+" "+uniqueCode);
			//workbook.close();
			inputStream.close();

		} catch (Exception e) {
			e.printStackTrace();
			importEcxel=false;
			uniqueCode="failure";
		}finally {
			try {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
				System.out.println("*************** Excel Reading  ends    ***************");
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
	return uniqueCode;
}

	/*public static  boolean optimizedRouteandLoad(String uniqueId,int userId,int systemId,int customerId)
	{
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		Properties properties = ApplicationListener.prop;
		FileInputStream in=null;
		Connection con=null;
		boolean optimized=false;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String createXmlPath=properties.getProperty("createXmlPath").trim();
			
			String args[]=null;		
			LoadAndRoutePlanner loadOptimize = new LoadAndRoutePlanner();
			System.out.println(loadOptimize);
			args=new String[1];
			args[0]=createXmlPath;
			//loadOptimize.main(args);
			
			   DocumentBuilderFactory docBuild = DocumentBuilderFactory.newInstance();
	            DocumentBuilder docBuilder = docBuild.newDocumentBuilder();
	            
	            FileInputStream fis = new FileInputStream(createXmlPath+"\\logs\\visits.xml");
	            InputSource is = new InputSource(fis);
	            org.w3c.dom.Document doc = docBuilder.parse(is);

	            // get the first element
	            org.w3c.dom.Element element = doc.getDocumentElement();

	            String textVal=null;
	            // get all child nodes
	            NodeList nodes = element.getElementsByTagName("visit");
	            
	           // NodeList nodes2=element.getElementsByTagName("visit");
	           
	            // print the text content of each child
	            for (int i = 0; i < nodes.getLength(); i++) {
	            	String value[]= nodes.item(i).getTextContent().split("\n");
	            	//System.out.println(value);
	            	  String reg_num=value[1];
		              String vehicle_Route=value[2].substring(2).replaceAll("\\s", "->");
	                  //  System.out.println(value[1]+" "+vehicle_Route+" "+vehicle_Route.contains("d"));
	               
	                    
	                   // System.out.println(reg_num+"------"+reg_num.replaceAll("\\s", ""));
	               if(vehicle_Route.contains("d")){
	            	   pstmt= con.prepareStatement("insert into AMS.dbo.OPTIMISED_VEHICLE_ROUTE_DETAILS(VEHICLE_NO,CAPACITY,UNIQUE_ID,INSERTED_BY,ORDER_OF_CHECKPOINTS,INSERTED_GMT) values (?,?,?,?,?,getutcdate())");
		               pstmt.setString(1,reg_num.replaceAll("\\s", "").trim());
		               pstmt.setString(2,"0");
		               pstmt.setString(3,uniqueId);
		               pstmt.setInt(4,userId);
		               pstmt.setString(5,vehicle_Route);
		               
		               int x=pstmt.executeUpdate();
		               
		               if(x>0)
		               {
		            	   System.out.println("Success");
		            	   optimized=true;
		               }
	               }
	               
	            }
	            
		} catch (Exception e) {
			e.printStackTrace();
			optimized=false;
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return optimized;
	}*/
	
	
public void runProcess(String batfile, String directory) throws CommandLineException {
		
		Commandline commandLine = new Commandline();
		
		File executable = new File(directory + "/" +batfile);
		commandLine.setExecutable(executable.getAbsolutePath());
		
		WriterStreamConsumer systemOut = new WriterStreamConsumer(
	            new OutputStreamWriter(System.out));
		
		WriterStreamConsumer systemErr = new WriterStreamConsumer(
	            new OutputStreamWriter(System.out));

		int returnCode = CommandLineUtils.executeCommandLine(commandLine, systemOut, systemErr);
		if (returnCode != 0) {
		    System.out.println("Something Bad Happened!");
		} else {
		    System.out.println("Taaa!! ddaaaaa!!");
		};
	
}



}