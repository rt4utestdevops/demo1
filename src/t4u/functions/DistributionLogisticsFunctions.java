package t4u.functions;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.Vector;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.distributionlogistics.IndentMasterData;
import t4u.distributionlogistics.IndentVehicleDetailsData;
import t4u.distributionlogistics.IndentVehiclesCount;
import t4u.statements.AdminStatements;
import t4u.statements.AutomotiveLogisticsStatements;
import t4u.statements.CreateTripStatement;
import t4u.statements.DistributionStatments;
import t4u.statements.GeneralVerticalStatements;

import com.t4u.activity.VehicleActivity;
import com.t4u.activity.VehicleActivity.DataListBean;

public class DistributionLogisticsFunctions {
	
	CommonFunctions cf= new CommonFunctions();
	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat sdf2 = new SimpleDateFormat("dd/MM/yyyy HH:mm");
	SimpleDateFormat sdf3 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	DecimalFormat df = new DecimalFormat("00.00");
	public static final String VEHICLE_TYPE_AD_HOC = "Ad-hoc";
	public static final String VEHICLE_TYPE_DEDICATED = "Dedicated";
	public static final String REMARKS_DELIMITER = "+";
	public static final String ALL_VALUE = "-- ALL --";
	
	public Vector getStopReport(Date startDateTime,Date endDateTime,String regno,
			String clientName, String systemId, int offset,HttpSession session) {
		String lang="en";
	    if(session.getAttribute("lan")!= null){
		lang = session.getAttribute("lan").toString();
		}
		Locale locale = (Locale)session.getAttribute(org.apache.struts.Globals.LOCALE_KEY);
		
		JSONArray list2 = new JSONArray(); 
		 DBConnection jc=null;
	  	  Connection con=null;
	  	  PreparedStatement pstmt=null;
	  	  ResultSet rs=null;
	    	ReportHelper finalReportHelper  = new ReportHelper();
			ArrayList reportsList = new ArrayList();
			Vector vector = new Vector();
			ArrayList headersList = new ArrayList();
			long timeBandInt=0;
			
			String localdate1 = "";
			String localdate2 = "";
			String loc="";
			String TotalHrs1="";
		
			SimpleDateFormat sdfDD = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
			SimpleDateFormat sdfDDmmyyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
			SimpleDateFormat sdfDateTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
			SimpleDateFormat sdfmy = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
			DecimalFormat df = new DecimalFormat("0.##");
			 
			 LinkedList<DataListBean> activityReportList=new LinkedList<DataListBean>();
			 
	  	  try
	  	  {
	  		 
	  		jc = new DBConnection();
			con = jc.getConnectionToDB("AMS");
	  		  
				
				VehicleActivity vi=new VehicleActivity(con, regno, startDateTime, endDateTime, offset, Integer.parseInt(systemId), Integer.parseInt(clientName),0);
	            activityReportList = vi.getFinalList();
				int k=0;
				

				ArrayList informationList=new ArrayList();
				   		for(int i=0;i<activityReportList.size();i++)
						{
				   			
				   			DataListBean dlbcur = activityReportList.get(i);
			                DataListBean dlbnext=null;
			                if(i+1<activityReportList.size()){
			                	dlbnext = activityReportList.get(i+1);
			                }
			                
			                
			                String cat=dlbcur.getCategory();
							if(cat.equals("STOPPAGE")){
								if(i==activityReportList.size()-1){
									 DataListBean dlbprev=activityReportList.get(i-1);
									 String cat1=dlbprev.getCategory();
									 if(cat1.equals("STOPPAGE")){
										 break;
									 }
								}

						
				   			k++;
							informationList=new ArrayList();
							JSONObject obj1 = new JSONObject();
							obj1.put("slno",k);
							informationList.add(String.valueOf(k));
						//	StopReportBean sr=(StopReportBean)dataList.get(i);
	// ===================================================================================================
							
							Date dd=dlbcur.getGmtDateTime();
							localdate1=sdfDDmmyyyy.format(getLocalDateTime(dd,offset));
							localdate1=localdate1.substring(0,19);
							
							loc=dlbcur.getLocation();
							long ms=dlbcur.getStopTime();

							 TotalHrs1 = formattedDaysHoursMinutes(ms);
							 String TotalHrs1NEW = formattedDaysHoursMinutesNEW(ms);
							 
													
							if(dlbnext == null )
							{
								localdate2 = "";
							}
							else
							{
								Date dd1=dlbnext.getGmtDateTime();
								localdate2=sdfDDmmyyyy.format(getLocalDateTime(dd1,offset));
								localdate2=localdate2.substring(0,19);
							}
							
								
	// ===================================================================================================		
							obj1.put("durationNEW", TotalHrs1NEW);
							informationList.add(TotalHrs1NEW);
							
							obj1.put("duration", TotalHrs1);
							informationList.add(TotalHrs1);	
								
							
							obj1.put("location", loc);
							informationList.add(loc);
							
							 obj1.put("startdate", localdate1);
								informationList.add(localdate1);
								
								obj1.put("enddate", localdate2);
								informationList.add(localdate2);
								
								int noofDays= Integer.parseInt(TotalHrs1.substring(0, 1));
							if(loc.toUpperCase().startsWith("INSIDE")){
								k--;
								continue;
							}
							if((Integer.parseInt(TotalHrs1.substring(TotalHrs1.indexOf(":")+1, TotalHrs1.indexOf(":")+2))<1) || (noofDays>0)){
								k--;
								continue;
							}
							int value= Integer.parseInt(TotalHrs1.substring(TotalHrs1.indexOf(":")+1, TotalHrs1.indexOf(":")+2));
							obj1.put("value", value);
							informationList.add(value);
							
							list2.put(obj1);
				    		ReportHelper reporthelper=new ReportHelper();
				    		reporthelper.setInformationList(informationList);
				    		reportsList.add(reporthelper); 
				    		 if(k >= 5000)
				    		 {
				    			 break;
				    		 }
				    		 
				   		}  // end of if
	  	  
	  	  }  // end of for
	  	  } // end of try
	  	catch(Exception e)
	  	  {
	  		e.printStackTrace();
	  		  System.out.println("Error .."+e);
	  	  }
	  	finally
		{
	  		
	  		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	  		finalReportHelper.setReportsList(reportsList);
			
			headersList.add("SLNo");
			headersList.add("Duration (DD:HH:MM:SS)");
			headersList.add("Duration (D:H:M)");
			headersList.add("LOCATION");
			headersList.add("Start Date");
			headersList.add("End Date");
			headersList.add("VALUE");
			
			finalReportHelper.setHeadersList(headersList);
			vector.add(list2);
			vector.add(finalReportHelper);
			 
		
		}
	 // 	System.out.println("vector..."+vector);
		return vector;  
		
		
	}

	
	private String formattedDaysHoursMinutesNEW(long ms) {
		String formateddaysHoursMinutes = "";
		try{
		long d = ms;

		long dSeconds = d / 1000;
		long min=0;
		long hrs=0;
		long days=0;
		if (dSeconds>=60) {
			min=dSeconds/60;
			dSeconds=dSeconds%60;
		}
		if (min>=60) {
			hrs=min/60;
			min=min%60;
		}
		if (hrs>=24) {
			days=hrs/24;
			hrs=hrs%24;
		}
		formateddaysHoursMinutes=days+":"+hrs+":"+min+":"+dSeconds;
		}
		catch(Exception e){
		e.printStackTrace();
		}
		return formateddaysHoursMinutes;
		}
	
	private String formattedDaysHoursMinutes(long fromDateMillisec){
		String formateddaysHoursMinutes = "";
		try{
		long d = fromDateMillisec;

		long dSeconds = d / 1000;


		long dM = d / (60 * 1000);

		long dH = d / (60 * 60 * 1000);

		long dD = d / (24 * 60 * 60 * 1000);

		long hours =(d % (24 * 60 * 60 * 1000))/(60 * 60 * 1000);

		long minutes = ((d % (24 * 60 * 60 * 1000))%(60 * 60 * 1000))/(60 * 1000);

		// System.out.println("In milliseconds: " + d + " milliseconds.");
		// System.out.println("In seconds: " + dSeconds + " seconds.");
		// System.out.println("In minutes: " + dM + " minutes.");
		// System.out.println("In hours: " + dH + " hours.");
		// System.out.println("In days: " + dD + " days.");
		// System.out.println("In hours: " + hours + " hours.");
		// System.out.println("In minutes: " + minutes + " minutes.");
		formateddaysHoursMinutes = dD +":"+hours+":"+minutes;
		//System.out.println(" formateddaysHoursMinutes :"+formateddaysHoursMinutes);

		}
		catch(Exception e){
		e.printStackTrace();
		}
		return formateddaysHoursMinutes;
		}
	
	public Date getLocalDateTime(Date dateTimeGMT,int offset){
		Calendar cal=Calendar.getInstance();
		cal.setTime(dateTimeGMT);
		cal.add(Calendar.MINUTE,offset);
		return cal.getTime();
	}
	
	public ArrayList<Object> getAPMTTripDetails(int systemid,String customerid,String startDate,String endDate,int offSet) {
		JSONArray ServiceTypeJsonArray = new JSONArray();
		JSONObject ServiceTypeJsonObject = new JSONObject();
		Connection conAdmin = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count=0;
		int Count=0;
		String tripDate="";
		String tripDate1="";
		String timediff="";
		String PortToCfsDetention="";
		String CfsToPostDetention="";
		String timediff1= "";
		String Exporttransitime= "";	
		String transitimeToport= "";
    	  
		String milestone1_in= "";
		String milestone3_in = "";
		String milestone2_in = "";
		String  milestone1_out = "";
		String  milestone3_out = "";
		String  milestone2_out = "";
		String  milestone4_in= "";
		String  milestone5_in = "";
		String  milestone6_in = "";
		String  milestone4_out = "";
		String  milestone5_out = "";
		String  milestone6_out = "";
		String  port_return = "";
		String  exportCfsIn ="";
		String  exportCfsOut = "";
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat sdf1=new SimpleDateFormat("dd/MM/yyyy");
		
		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList < Object > aslist = new ArrayList < Object > ();
		
		
		try {
			ServiceTypeJsonArray = new JSONArray();
			ServiceTypeJsonObject = new JSONObject();
			conAdmin = DBConnection.getConnectionToDB("AMS");
			
			headersList.add("SL No");
            headersList.add("Trip Date");
            headersList.add("Vehicle No");
            headersList.add("Start Location");
            headersList.add("End Location");
            headersList.add("InTime StartLocation");
            headersList.add("OutTime StartLocation");
            headersList.add("Port Detention at StartLocation");
            headersList.add("Name of Milestone 1");
            headersList.add("Milestone 1: In-time");
            headersList.add("Milestone 1: Out-time");
            headersList.add("Detention at Milestone 1");
            headersList.add("Name of Milestone 2");
            headersList.add("Milestone 2:In-time");
            headersList.add("Milestone 2 :Out-time");
            headersList.add("Detention at Milestone 2");   
            headersList.add("Name of Milestone 3");	
            headersList.add("Milestone 3: In-time");
            headersList.add("Milestone 3: Out-time");
            headersList.add("Detention at Milestone 3");
            headersList.add("Enroute Stoppage from PORT to Last Milestone");
            headersList.add("Total Detention at Milestones(PORT to CFS)");
            headersList.add("In-Time End Location");
            headersList.add("Out-Time End Location");
            headersList.add("Detention End Location");
            headersList.add("Transit time from Port to Import CFS/Yard");
            headersList.add("Export Location");
            headersList.add("Export In Time");
            headersList.add("Export Out Time");
            headersList.add("Export Detention");
            headersList.add("Transit time from Import CFS/Yard to Export CFS/Yard");
            headersList.add("Name of Milestone 4");
            headersList.add("Milestone 4: In-time");
	        headersList.add("Milestone 4 Out-time");
	        headersList.add("Detention at Milestone 4");
	        headersList.add("Name of Milestone 5");
	        headersList.add("Milestone 5: In-time");
	        headersList.add("Milestone 5: Out-time");
	        headersList.add("Detention at Milestone 5");   
	        headersList.add("Name of Milestone 6");	
	        headersList.add("Milestone 6: In-time");
	        headersList.add("Milestone 6:Out-time");
	        headersList.add("Detention at Milestone 6");  
	        headersList.add("Enroute Stoppage from First Milestone to PORT");
	        headersList.add("Transit time from CFS to PORT");
	        headersList.add("Total Detention at Milestones(CFS to PORT)"); 
            headersList.add("Transit time from Export yard to Port");
            headersList.add("Total Enroute Stoppage from Import CFS/Yard to Export CFS/Yard");
	        headersList.add("Return to Port(Port Name)");   
	        headersList.add("Return to Port (Intime)");
	        headersList.add("Stoppage Count");
	        headersList.add("Total Enroute Stoppage from PORT to CFS");
	        headersList.add("Total Enroute Stoppage from Import CFS/Yard to Port");
	        headersList.add("Total Round Trip time");
	        ServiceTypeJsonObject = new JSONObject();
	        pstmt = conAdmin.prepareStatement(DistributionStatments.GET_APMT_TRIP_DETAILS);
		    
		    pstmt.setString(1,startDate);
		    pstmt.setString(2,endDate);
		    pstmt.setInt(3,systemid);
		    pstmt.setInt(4,Integer.parseInt(customerid));
		     rs = pstmt.executeQuery();
		    
		    while (rs.next()) {	
		    	
		    	
		              ArrayList < Object >  informationList = new ArrayList < Object > ();
		        	  ReportHelper reporthelper = new ReportHelper();
		        	  JSONObject jsonObject = new JSONObject();
		        	   timediff= getTimeDiffrence( rs.getString("SOURCE_OUT"), rs.getString("DEST_IN"));
		        	   PortToCfsDetention=getAddDetentions(rs.getString("DETENTION_1"),rs.getString("DETENTION_2"),rs.getString("DETENTION_3"));
		        	   CfsToPostDetention=getAddDetentions(rs.getString("DETENTION_4"),rs.getString("DETENTION_5"),rs.getString("DETENTION_6"));
		        	   timediff1= getTimeDiffrence( rs.getString("DEST_OUT"), rs.getString("TRIP_END_TIME"));
		        	  	if(!rs.getString("EXPORT_DEST_IN").equals("1900-01-01 00:00:00")){
		        	     Exporttransitime= getTimeDiffrence( rs.getString("DEST_OUT"), rs.getString("EXPORT_DEST_IN"));
		        	  	}
		        	  	else {
		        	  		
		        	  		Exporttransitime ="00:00";
		        	  	}
		        	  	if(!rs.getString("EXPORT_DEST_OUT").equals("1900-01-01 00:00:00")){
		        	   transitimeToport= getTimeDiffrence( rs.getString("EXPORT_DEST_OUT"), rs.getString("TRIP_END_TIME"));	
		          	    }
			    	  	else {
			    	  		transitimeToport ="00:00";
			    	  	}
		        	  milestone1_in= rs.getString("MILESTONE_1_IN");
		        	  milestone3_in = rs.getString("MILESTONE_3_IN");
		        	  milestone2_in =rs.getString("MILESTONE_2_IN");
		        	  milestone1_out =rs.getString("MILESTONE_1_OUT");
		        	  milestone3_out =rs.getString("MILESTONE_3_OUT");
		        	  milestone2_out = rs.getString("MILESTONE_2_OUT");
		        	  milestone4_in= rs.getString("MILESTONE_4_IN");
		        	  milestone5_in = rs.getString("MILESTONE_5_IN");
		        	  milestone6_in =rs.getString("MILESTONE_6_IN");
		        	  milestone4_out =rs.getString("MILESTONE_4_OUT");
		        	  milestone5_out =rs.getString("MILESTONE_5_OUT");
		        	  milestone6_out = rs.getString("MILESTONE_6_OUT");
		        	  exportCfsIn =rs.getString("EXPORT_DEST_IN");
		        	  exportCfsOut = rs.getString("EXPORT_DEST_OUT");
		        	  port_return = rs.getString("TRIP_END_TIME");
		        	 
		        	 
		        	 if(port_return.equals("1900-01-01 00:00:00")){
		        		 port_return = "";
					}
		        	 
		        	 if(milestone1_in.equals("1900-01-01 00:00:00")){
		        		 milestone1_in = "";
					}
					if(milestone2_in.equals("1900-01-01 00:00:00")){
						milestone2_in	="";        		 
					}
					if(milestone3_in.equals("1900-01-01 00:00:00")){
						milestone3_in ="" ;
					}
					if(milestone1_out.equals("1900-01-01 00:00:00")){
						milestone1_out= "";
					}
					if(milestone2_out.equals("1900-01-01 00:00:00")){
						milestone2_out= "";
					}
					if(milestone3_out.equals("1900-01-01 00:00:00")){
						milestone3_out ="";
                    }
					if(milestone4_in.equals("1900-01-01 00:00:00")){
		        		 milestone4_in = "";
					}
					if(milestone5_in.equals("1900-01-01 00:00:00")){
						milestone5_in	="";        		 
					}
					if(milestone6_in.equals("1900-01-01 00:00:00")){
						milestone6_in ="" ;
					}
					if(milestone4_out.equals("1900-01-01 00:00:00")){
						milestone4_out= "";
					}
					if(milestone5_out.equals("1900-01-01 00:00:00")){
						milestone5_out= "";
					}
					if(milestone6_out.equals("1900-01-01 00:00:00")){
						milestone6_out ="";
                   }
					if(exportCfsIn.equals("1900-01-01 00:00:00")){
						exportCfsIn= "";
					}
					if(exportCfsOut.equals("1900-01-01 00:00:00")){
						exportCfsOut ="";
                   }
		        	
					tripDate = rs.getString("SOURCE_OUT");
					
					if(rs.getInt("DATEHR")<9){
					
					Calendar c = Calendar.getInstance();
					c.setTime(sdf.parse(tripDate));
					c.add(Calendar.DATE, -1);  // number of days to add
					tripDate = sdf.format(c.getTime()); 
					
					}
					if(!tripDate.equals("")){
						
						tripDate1 = sdf1.format(sdf.parse(tripDate));
					}
					
		        	  Count=++count;
		        	  jsonObject.put("slnoIndex",Count);
				        informationList.add(Count);
			jsonObject.put("TripDateDataIndex",tripDate);
	        informationList.add(tripDate1);
	        jsonObject.put("VehiclenoDataIndex",rs.getString("REGISTRATION_NO"));
	        informationList.add(rs.getString("REGISTRATION_NO"));
	        jsonObject.put("StartLocationDataIndex",rs.getString("SOURCE_NAME"));
	        informationList.add(rs.getString("SOURCE_NAME"));
	        jsonObject.put("EndLocationDataIndex",rs.getString("DEST_NAME"));
	        informationList.add(rs.getString("DEST_NAME"));
	        jsonObject.put("InTimestartLocationDataIndex",rs.getString("SOURCE_IN"));
	        informationList.add(rs.getString("SOURCE_IN"));
	        jsonObject.put("OutTimestartLocationDataIndex",rs.getString("SOURCE_OUT"));
	        informationList.add(rs.getString("SOURCE_OUT"));
	        jsonObject.put("PortDetentionstartLocationDataIndex",rs.getString("PORT_DETENTION"));
	        informationList.add(rs.getString("PORT_DETENTION"));
	        jsonObject.put("NameofMilestone1DataIndex",rs.getString("MILESTONE_1"));
	        informationList.add(rs.getString("MILESTONE_1"));
	        jsonObject.put("Milestone1InTimeDataIndex",milestone1_in);
	        informationList.add(milestone1_in);
	        jsonObject.put("Milestone1OutTimeDataIndex",milestone1_out);
	        informationList.add(milestone1_out);
	        jsonObject.put("DetentionatMilestone1DataIndex",rs.getString("DETENTION_1"));
	        informationList.add(rs.getString("DETENTION_1"));
	        jsonObject.put("NameofMilestone2DataIndex",rs.getString("MILESTONE_2"));
	        informationList.add(rs.getString("MILESTONE_2"));
	        jsonObject.put("Milestone2InTimeDataIndex",milestone2_in);
	        informationList.add(milestone2_in);
			jsonObject.put("Milestone2OutTimeDataIndex",milestone2_out);
			 informationList.add(milestone2_out);
	        jsonObject.put("DetentionatMilestone2DataIndex",rs.getString("DETENTION_2"));  
	        informationList.add(rs.getString("DETENTION_2"));
			jsonObject.put("NameofMilestone3DataIndex",rs.getString("MILESTONE_3"));	
			 informationList.add(rs.getString("MILESTONE_3"));
		    jsonObject.put("Milestone3InTimeDataIndex",milestone3_in);
		    informationList.add(milestone3_in);
			jsonObject.put("Milestone3OutTimeDataIndex",milestone3_out);
			 informationList.add(milestone3_out);
			jsonObject.put("DetentionatMilestone3DataIndex",rs.getString("DETENTION_3"));
			 informationList.add(rs.getString("DETENTION_3"));
			 jsonObject.put("Src_Milestone_Stoppage",rs.getString("SRC_MILESTONE_STOPPAGE"));
			 informationList.add(rs.getString("SRC_MILESTONE_STOPPAGE"));
			jsonObject.put("atMilestonesPorttoCFSDataIndex",PortToCfsDetention);
			 informationList.add(PortToCfsDetention);
			jsonObject.put("InTimeEndLocationDataIndex",rs.getString("DEST_IN"));
			 informationList.add(rs.getString("DEST_IN"));
			jsonObject.put("OutTimeEndLocationDataIndex",rs.getString("DEST_OUT"));
			 informationList.add(rs.getString("DEST_OUT"));
			 jsonObject.put("DetentionEndLocationDataIndex",rs.getString("CFS_DETENTION"));
			 informationList.add(rs.getString("CFS_DETENTION"));
			 jsonObject.put("DetentionPortandCFSDataIndex",timediff);
		        informationList.add(timediff);
		        jsonObject.put("exportLocationIndex",rs.getString("EXPORT_DEST_NAME"));
			    informationList.add(rs.getString("EXPORT_DEST_NAME"));
			    jsonObject.put("exportInTimeIndex",exportCfsIn);
			    informationList.add(exportCfsIn);
			    jsonObject.put("exportOutTimeIndex",exportCfsOut);
			    informationList.add(exportCfsOut);
			    jsonObject.put("exportDetentionIndex",rs.getString("EXPORT_CFS_DETENTION"));
			    informationList.add(rs.getString("EXPORT_CFS_DETENTION"));
			    jsonObject.put("transitTimeImportToExportCFSYardIndex",Exporttransitime);
			    informationList.add(Exporttransitime);
		        jsonObject.put("NameofMilestone4DataIndex",rs.getString("MILESTONE_4"));
		        informationList.add(rs.getString("MILESTONE_4"));
		        jsonObject.put("Milestone4InTimeDataIndex",milestone4_in);
		        informationList.add(milestone4_in);
		        jsonObject.put("Milestone4OutTimeDataIndex",milestone4_out);
		        informationList.add(milestone4_out);
		        jsonObject.put("DetentionatMilestone4DataIndex",rs.getString("DETENTION_4"));
		        informationList.add(rs.getString("DETENTION_4"));
		        jsonObject.put("NameofMilestone5DataIndex",rs.getString("MILESTONE_5"));
		        informationList.add(rs.getString("MILESTONE_5"));
		        jsonObject.put("Milestone5InTimeDataIndex",milestone5_in);
		        informationList.add(milestone5_in);
				jsonObject.put("Milestone5OutTimeDataIndex",milestone5_out);
				 informationList.add(milestone5_out);
		        jsonObject.put("DetentionatMilestone5DataIndex",rs.getString("DETENTION_5")); 
		        informationList.add(rs.getString("DETENTION_5"));
				jsonObject.put("NameofMilestone6DataIndex",rs.getString("MILESTONE_6"));
				 informationList.add(rs.getString("MILESTONE_6"));
			    jsonObject.put("Milestone6InTimeDataIndex",milestone6_in);
			    informationList.add(milestone6_in);
			    jsonObject.put("Milestone6OutTimeDataIndex",milestone6_out);
				 informationList.add(milestone6_out);
	            jsonObject.put("DetentionatMilestone6DataIndex",rs.getString("DETENTION_6"));  
					 informationList.add(rs.getString("DETENTION_6"));
				jsonObject.put("Dest_Milestone_Stoppage",rs.getString("DEST_MILESTONE_STOPPAGE"));
					 informationList.add(rs.getString("DEST_MILESTONE_STOPPAGE"));
				jsonObject.put("DetentionatCfsAndPortDataIndex",timediff1);  
				 informationList.add(timediff1);
		        jsonObject.put("atMilestonesCFStoPortDataIndex",CfsToPostDetention); 
		        informationList.add(CfsToPostDetention);
			    jsonObject.put("transitTimeExportYardToPortIndex",transitimeToport);
			    informationList.add(transitimeToport);
			    jsonObject.put("totalStoppageExportToImportCFSYardIndex",rs.getString("STOPPAGE_BTE_CFS"));
			    informationList.add(rs.getString("STOPPAGE_BTE_CFS"));
		        jsonObject.put("PortNameDataIndex",rs.getString("RETURN_PORT"));  
		        informationList.add(rs.getString("RETURN_PORT"));
		        jsonObject.put("ReturntoPortInTimeDataIndex",port_return);
		        informationList.add(port_return);
		        jsonObject.put("StoppagecountDataIndex",rs.getString("STOPPAGE_COUNT"));
		        informationList.add(rs.getString("STOPPAGE_COUNT"));
		        jsonObject.put("Enrotestoppagemilestone3DataIndex",rs.getString("ENROUTE_STOPPAGE_1"));
		        informationList.add(rs.getString("ENROUTE_STOPPAGE_1"));
		        jsonObject.put("Enrotestoppagemilestone1DataIndex",rs.getString("ENROUTE_STOPPAGE_2"));
		        informationList.add(rs.getString("ENROUTE_STOPPAGE_2"));
				jsonObject.put("TotalRoundTriptimeDataIndex",rs.getString("RETURN_PORT_IN"));
				 informationList.add(rs.getString("RETURN_PORT_IN"));
			
			ServiceTypeJsonArray.put(jsonObject);
			
			
			reporthelper.setInformationList(informationList);
			reportsList.add(reporthelper);
	        }
	        
	        aslist.add(ServiceTypeJsonArray);
	        finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			aslist.add(finalreporthelper);
		
		}
	        catch (Exception e) {
				e.printStackTrace();
			}
			finally {
	 			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
				//System.out.println("Trip Details");
	 		}  
			          
	

	return aslist;
}



	public  String getTimeDiffrence(String stopIn,String stopOut)
	{
		long diffhrs=0;
		long mins=0;
		Date stopIndate=null;
		Date stopOutDate=null;
		String diffhrsString ="";
		String minsString ="";
		try{
		SimpleDateFormat dateformat2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		stopIndate=dateformat2.parse(stopIn);
		stopOutDate =dateformat2.parse(stopOut);
		}
		catch(Exception e){
			
			e.printStackTrace();
		}
		
		long difference = stopOutDate.getTime() - stopIndate.getTime();
		diffhrs = (difference/(1000*60*60));
		mins=(difference/(1000*60))%60;
		
		if(diffhrs<10){
			diffhrsString = "0"+diffhrs;
		}
		else{
			diffhrsString = ""+diffhrs;
		}
		if(mins<10){
			minsString = "0"+mins;
		}
		else{
			minsString = ""+mins;
		}
		
		return diffhrsString +":"+minsString;
	}
	
	
	public String getAddDetentions(String DETENTION1,String DETENTION2,String DETENTION3)
	{
	
		String add1="";
		String hours1;	
		int add = 0;
		int minuss = 0;
		String hours;	
		String hours2;
		String minutes;
		String minutes1; 
		String minutes2;
		String hrs="";
		String minitues="";
		try {

			String time1=DETENTION1;
			String splitTime[]=time1.split(":");
			hours=splitTime[0];
			minutes=splitTime[1];
			int hour =Integer.parseInt(hours);
			int minute =Integer.parseInt(minutes);

			String time2=DETENTION2;
			String splitTime1[]=time2.split(":");
			hours1=splitTime1[0];
			minutes1=splitTime1[1];
			int hour1 =Integer.parseInt(hours1);
			int minute1 =Integer.parseInt(minutes1);

			String time3=DETENTION3;
			String splitTime2[]=time3.split(":");
			hours2=splitTime2[0];
			minutes2=splitTime2[1];
			int hour2 =Integer.parseInt(hours2);
			int minute2 =Integer.parseInt(minutes2);

			int sumhours=hour+hour1+hour2;
			int summinutes= minute+minute1+minute2;
			if(summinutes>59)
			{
				int mins=summinutes/60;
				minuss=summinutes%60;
				add=sumhours+mins;
				hrs= ""+add;
				if(add<10){
					hrs	="0"+hrs;
				}
				
				minitues= ""+minuss;
				if(minuss<10){
					minitues ="0"+minuss;
				}
				
				add1=hrs+":"+minitues;
			}
			else{
				add=sumhours;
				hrs= ""+add;
				
				if(add<10){
					hrs	="0"+hrs;
				}
				
				minitues= ""+summinutes;
				if(summinutes<10){
					minitues ="0"+minitues;
				}
				add1=hrs+":"+minitues;
			}

		} catch (Exception e) {
			e.printStackTrace();
		                      }
		return add1;
		}
	public JSONArray getVehicleNo(int systemId, int customerId, int userId, String groupid) {
	    Connection conAdmin = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = new JSONObject();
	    try {
	        conAdmin = DBConnection.getConnectionToDB("AMS");
	        pstmt = conAdmin.prepareStatement(DistributionStatments.GET_VEHICLE_WHICH_IS_BELONG_GROUP_AND_VID);
	        pstmt.setInt(1, customerId);
	        pstmt.setInt(2, systemId);
	        pstmt.setInt(3, userId);
	        pstmt.setString(4, groupid);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            jsonObject = new JSONObject();
	            jsonObject.put("vehicleNoName", rs.getString("REGISTRATION_NUMBER"));
	            jsonArray.put(jsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
	    }
	    return jsonArray;
	}
	public JSONArray getVehicleNumbersByCustomerId(int systemId, int customerId, int userId, String dateId) {
	    Connection conAdmin = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = new JSONObject();
	    try {
	        conAdmin = DBConnection.getConnectionToDB("AMS");
	        pstmt = conAdmin.prepareStatement(DistributionStatments.GET_VEHICLE_BY_CUSTOMERID_SYSTEMID);
	        pstmt.setInt(1, customerId);
	        pstmt.setInt(2, systemId);
	        pstmt.setInt(3, userId);
	        //pstmt.setString(4, dateId);
	        
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            jsonObject = new JSONObject();
	            jsonObject.put("vehicleNoName", rs.getString("REGISTRATION_NUMBER"));
	            jsonObject.put("groupName", rs.getString("GROUP_NAME"));
	            jsonObject.put("vehicleType", rs.getString("VehicleType"));
	            jsonArray.put(jsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
	    }
	    return jsonArray;
	}
	public String addVehicleReportingDetails(String groupId,String groupName,String VehicleNo,String currentDateId,int systemId,int custId,String dateId){
	    Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		String message="";
		
		try
		{
			 con = DBConnection.getConnectionToDB("AMS");
			 pstmt = con.prepareStatement(DistributionStatments.CHECK_VEHICLE_ALREADY_EXIST);
			 pstmt.setString(1, VehicleNo);	
			 pstmt.setString(2, groupId);
			 pstmt.setInt(3, systemId);		
			 pstmt.setInt(4, custId);

			 rs = pstmt.executeQuery();
			 if(rs.next())
			 {
				 message="Vehicle Already Exist";
				 return message;
			 }
			 else {
			 pstmt = con.prepareStatement(DistributionStatments.ADD_NEW_VEHICLE_REPORTING_DETAILS);
			 pstmt.setString(1,groupId);
			 pstmt.setString(2,groupName);
			 pstmt.setString(3,VehicleNo);
			 pstmt.setString(4,dateId);
			 pstmt.setString(5, currentDateId);			 	
			 pstmt.setInt(6, systemId);
			 pstmt.setInt(7, custId);			 
			 int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
               message = "Saved Successfully";
          }
		}
		} 
		 catch (Exception e)
		 {
				System.out.println("error in:-save VehicleReporting details "+e.toString());
				e.printStackTrace();
		 }      
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    } 
		return message;
				
	 
 }
 
 public String modifyVehicleReportingDetails(String groupId,String VehicleNo,String currentDateId,int systemId,int custId,int userId,String dateId,String id){
	
	 	Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		String message="";
		
		try
		{
			 con = DBConnection.getConnectionToDB("AMS");
			
			 pstmt = con.prepareStatement(DistributionStatments.UPDATE_VEHICLE_REPORTING_DETAILS);
			
			 pstmt.setString(1,currentDateId);
			 pstmt.setInt(2, userId);
			 pstmt.setString(3,groupId);
			 pstmt.setString(4,VehicleNo);
			 pstmt.setInt(5, systemId);
			 pstmt.setInt(6, custId);
			 pstmt.setString(7, id);
			 
			 int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
            message = "Saved Successfully";
       }
		}
		 catch (Exception e)
		 {
				System.out.println("error in:-save VehicleReporting details "+e.toString());
				e.printStackTrace();
		 }      
		finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    } 
		return message;
	
 }
 public ArrayList < Object > getVehicleReportingDetails(int systemId, int customerId, String groupId, String dateId) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		ReportHelper finalreporthelper = new ReportHelper();
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	    SimpleDateFormat sdfDateTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    try {
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        
	        headersList.add("SL No");
	        headersList.add("ID");
	        headersList.add("Vehicle No");
	        headersList.add("Current Reporting Time");
	        headersList.add("Actual Reporting Time");
	        headersList.add("Updated Date Time");
	        headersList.add("Updated By");
	        
	        pstmt = con.prepareStatement(DistributionStatments.GET_VEHICLE_REPORTING_DETAILS);
	        pstmt.setString(1, groupId);
	        pstmt.setInt(2, systemId);
	        pstmt.setInt(3, customerId);
	        pstmt.setString(4, dateId);
	        
	        
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	        	ArrayList < Object >  informationList = new ArrayList < Object > ();
	        	ReportHelper reporthelper = new ReportHelper();
	            JsonObject = new JSONObject();
	            count++;
	           
	            informationList.add(Integer.toString(count));
	            JsonObject.put("slnoIndex", count);
	            
	            informationList.add(rs.getString("ID"));
	            JsonObject.put("idIndex",rs.getString("ID"));
	            
	            informationList.add(rs.getString("ASSET_NO"));
	            JsonObject.put("vehicleNoIndex", rs.getString("ASSET_NO"));	
	            
	            informationList.add(rs.getString("REPORT_TIME"));
	            JsonObject.put("currentDateIndex",rs.getString("REPORT_TIME"));
	            
				if(rs.getString("ACTUAL_REPORT_DATETIME").equals("") || rs.getString("ACTUAL_REPORT_DATETIME").contains("1900")){
					informationList.add("");
					JsonObject.put("actualDateIndex", "");
				    }else{
				    informationList.add(ddmmyyyy.format(sdfDateTime.parseObject(rs.getString("ACTUAL_REPORT_DATETIME"))));
		            JsonObject.put("actualDateIndex",ddmmyyyy.format(sdfDateTime.parse(rs.getString("ACTUAL_REPORT_DATETIME"))));	
		            } 
				
				if(rs.getString("UPDATED_DATETIME").equals("") || rs.getString("UPDATED_DATETIME").contains("1900")){
					informationList.add("");
					JsonObject.put("updatedDateIndex", "");
				    }else{
				    informationList.add(ddmmyyyy.format(sdfDateTime.parseObject(rs.getString("UPDATED_DATETIME"))));
		            JsonObject.put("updatedDateIndex",ddmmyyyy.format(sdfDateTime.parse(rs.getString("UPDATED_DATETIME"))));	
		            } 
				
				informationList.add(rs.getString("UPDATED_BY"));
	            JsonObject.put("updatedByIndex",rs.getString("UPDATED_BY"));
	            
	            JsonArray.put(JsonObject);
	            reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
	        }
	        finlist.add(JsonArray);
	        finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    } 
	    return finlist;
	}
 public JSONArray getLocation(int systemId, int custId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = null;
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DistributionStatments.GET_LOCATION_ZONE);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, userId);
			
			rs = pstmt.executeQuery();
			//jsObj = new JSONObject(); 
			
			while(rs.next()) {
				jsObj = new JSONObject();
				jsObj.put("HubName", rs.getString("NAME"));
				jsObj.put("Longitude", rs.getString("LONGITUDE"));
				jsObj.put("Latitude", rs.getString("LATITUDE"));
				jsObj.put("HubId", rs.getString("HUBID"));
				
				jsArr.put(jsObj);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
         DBConnection.releaseConnectionToDB(con, pstmt, rs);
     }
		return jsArr;
	}
	public JSONArray getVehicles(int systemId, int custId,int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();
		JSONObject jsObj = null;
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DistributionStatments.GET_VEHICLES);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			pstmt.setInt(3, userId);
			
			rs = pstmt.executeQuery();
			jsObj = new JSONObject(); 
			while(rs.next()) {
				jsObj = new JSONObject();
				jsObj.put("vehicleNoName", rs.getString("REGISTRATION_NUMBER"));
				jsObj.put("groupId", rs.getString("GROUP_ID"));
				jsObj.put("driverName", rs.getString("DRIVER_NAME"));
				jsObj.put("mobileNo", rs.getString("DRIVER_MOBILE"));
				
				jsArr.put(jsObj);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
         DBConnection.releaseConnectionToDB(con, pstmt, rs);
     }
		return jsArr;
	}


	public String addTripGenerationDetails(String amazonTripId,String vehicleNo, String sourceLocation,String destinationLocation, String destinationTime,String destinationDistance, String[] touchPointCombo, String[] touchPointTime, String[] touchPointDistance, int systemId,int custId,String driverName,String mobileNo,int userId,String tripstarttime,String routeName,String totalTime,String totalDistance) {Connection con = null;
	PreparedStatement pstmt= null;
	PreparedStatement pstmt1= null;
	ResultSet rs = null;
	ResultSet rs1 = null;
	String message="";
	int id=0;
	int instertedtransit =0;
	double totaldistance = 0 ;
	double totalTransitTime = 0 ;
	LogWriter logWriter = null;
	Properties properties = ApplicationListener.prop;
	String logFile=  properties.getProperty("TripGeneration");
	String logFileName = logFile.substring(0,logFile.lastIndexOf("."));
	String logFileExt = logFile.substring(logFile.lastIndexOf(".")+1,logFile.length());
	logFile = logFileName + "-" + sdf.format(new Date()) + "." + logFileExt;
	 
	PrintWriter pw;
	
	if (logFile != null)
	{
		try
		{
			pw = new PrintWriter(new FileWriter(logFile, true), true);
	        logWriter=new LogWriter("addTripGenerationDetails",LogWriter.INFO,pw);;
	        logWriter.setPrintWriter(pw);
		}
		catch (IOException e)
		{
			logWriter.log("Can't open the log file: " + logFile + ". Using System.err instead", LogWriter.ERROR);
		}
	}
	logWriter.log(" Begining of the method ",LogWriter.INFO);
	
	
	try
	{
		 con = DBConnection.getConnectionToDB("AMS");
		 pstmt = con.prepareStatement(DistributionStatments.CHECK_TRIP_EXIST);
		 pstmt.setString(1, vehicleNo);	
		 pstmt.setString(2, amazonTripId);
		 pstmt.setInt(3, systemId);		
		 pstmt.setInt(4, custId);

		 rs = pstmt.executeQuery();
		 if(rs.next())
		 {
			 if(rs.getString("SHIPMENNT_ID").equals(amazonTripId)){
				 message="Shipment Id is already exist";
				 logWriter.log("Shipment Id is already exist",LogWriter.INFO);
				 logWriter.log("Vehicle no : "+ vehicleNo +" Shipment Id : "+ amazonTripId ,LogWriter.INFO);
				 logWriter.log(" ",LogWriter.INFO);
				 logWriter.log("*****************************************************************************************",LogWriter.INFO);
				 return message;
			 }
			 else if(rs.getString("STATUS").equals("Open")) {
				 message="Trip already exist please close the current trip and create again";
				 logWriter.log("Trip already exist please close the current trip and create again",LogWriter.INFO);
				 logWriter.log("Vehicle no : "+ vehicleNo +" Shipment Id : "+ amazonTripId ,LogWriter.INFO);
				 logWriter.log(" ",LogWriter.INFO);
				 logWriter.log("*****************************************************************************************",LogWriter.INFO);
				 return message;
				 
			 }				
		 }
		 else {
			 logWriter.log("New Shipment ",LogWriter.INFO);
			 totaldistance=  Double.parseDouble(totalDistance.replace("km",""));
			 totalTransitTime = Double.parseDouble(totalTime.replace(":", "."));
		 pstmt = con.prepareStatement(DistributionStatments.INSERT_TRIP_GENERATION_DETAILS,Statement.RETURN_GENERATED_KEYS);
		 pstmt.setString(1,vehicleNo);
		 pstmt.setString(2,amazonTripId);
		 pstmt.setString(3,tripstarttime);
		 pstmt.setInt(4,systemId);
		 pstmt.setInt(5,custId);
		 pstmt.setString(6, driverName);			 	
		 pstmt.setString(7, mobileNo);
		 pstmt.setInt(8,userId);
		 pstmt.setDouble(9, totaldistance);
		 pstmt.setDouble(10, totalTransitTime);
		 pstmt.setString(11, routeName);
		 int inserted = pstmt.executeUpdate();
		 if(inserted>0){
			 logWriter.log("Shipment Inserted for Vehicle no : "+ vehicleNo +", Shipment Id : "+ amazonTripId +", routeName : "+ routeName ,LogWriter.INFO);
		 }
		 else {
			 logWriter.log("failed to insert shipment for Vehicle no : "+ vehicleNo +", Shipment Id : "+ amazonTripId +", routeName : "+ routeName ,LogWriter.INFO);						 
			 }
			rs1=pstmt.getGeneratedKeys();
			if(rs1.next())
			{
			id=rs1.getInt(1);
			String touchpoint="";
			String touchpointEta ="";
			int touchpointhrs =0;
			String touchpointTime="";
			String distance="";
			String min =null;
			String hr =null;
			int totmins = 0;
			
			for(int i=0 ;i<touchPointCombo.length-1; i++){
				instertedtransit = 0;
				touchpoint = touchPointCombo[i];
				distance= touchPointDistance[i];
				if((i>0) && !(touchpoint.equals(""))){
				touchpointEta = touchPointTime[i];
				 hr=touchpointEta.substring(0, touchpointEta.indexOf("."));
				  min=touchpointEta.substring(touchpointEta.indexOf(".")+1);
				  totmins = totmins+(Integer.parseInt(hr)*60)+Integer.parseInt(min);
					touchpointhrs =Integer.parseInt(hr)+Integer.parseInt(min)/60;
					if(Integer.parseInt(min)>60){
					touchpointTime = touchpointhrs + "." +Integer.parseInt(min)%60;
					}
					else {
				    touchpointTime = touchpointhrs + "." +Integer.parseInt(min);
					}
				}
				else if(i!=0){
					distance= destinationDistance;
					touchpointEta = destinationTime;
					 hr=touchpointEta.substring(0, touchpointEta.indexOf("."));
					  min=touchpointEta.substring(touchpointEta.indexOf(".")+1);
					  totmins = totmins+(Integer.parseInt(hr)*60)+Integer.parseInt(min);
						touchpointhrs =Integer.parseInt(hr)+Integer.parseInt(min)/60;
						if(Integer.parseInt(min)>60){
						touchpointTime = touchpointhrs + "." +Integer.parseInt(min)%60;
						}
						else {
					    touchpointTime = touchpointhrs + "." +Integer.parseInt(min);
						}
				}
			  distance = distance.replace("km","");
				pstmt = con.prepareStatement(DistributionStatments.INSERT_TOUCHPOINTS_DETAILS);
				if(i==0){
					 pstmt.setInt(1,id);
					 pstmt.setString(2,sourceLocation);
					 pstmt.setString(3,"0");
					 pstmt.setInt(4,0);
					 pstmt.setString(5,tripstarttime);
					 pstmt.setInt(6,0);
					 pstmt.setString(7,tripstarttime);
					 pstmt.setInt(8,i);
					 pstmt.setDouble(9,0);
					 instertedtransit =pstmt.executeUpdate();
					 if(instertedtransit>0){
					 logWriter.log("Source inserted",LogWriter.INFO);
					 logWriter.log("Source Hub : "+ sourceLocation +", tripstarttime : " + tripstarttime + ", Sequence : " + 0,LogWriter.INFO);
					 }
					 else {
					 logWriter.log("failed to insert Source for Vehicle no : "+ vehicleNo +", Shipment Id : "+ amazonTripId +", routeName : "+ routeName ,LogWriter.INFO);						 
					 logWriter.log("Source Hub : "+ sourceLocation +", tripstarttime : " +tripstarttime+ ", Sequence " + 0,LogWriter.INFO);
					 }
					 }
				else if(touchpoint.equals("")){
					 pstmt.setInt(1,id);
					 pstmt.setString(2,destinationLocation);
					 pstmt.setString(3,touchpointTime);
					 pstmt.setInt(4,totmins);
					 pstmt.setString(5,tripstarttime);
					 pstmt.setInt(6,totmins);
					 pstmt.setString(7,tripstarttime);
					 pstmt.setInt(8,100);
					  pstmt.setDouble(9,Double.parseDouble(distance));
					 instertedtransit = pstmt.executeUpdate();
					 if(instertedtransit>0){
						 logWriter.log("Destination inserted",LogWriter.INFO);
						 logWriter.log("Destination Hub : "+ destinationLocation + ", touchpointTime : " +touchpointTime +", totmins : "+totmins+", Sequence " + 100,LogWriter.INFO);
						 }
					 else {
						 logWriter.log("Failed to Insert Destination point",LogWriter.INFO);
						 logWriter.log("Destination Hub : "+ destinationLocation + ", touchpointTime : " +touchpointTime +", totmins : "+totmins+", Sequence " + 100,LogWriter.INFO);
					 }
					break;
				}
				else {
				 pstmt.setInt(1,id);
				 pstmt.setString(2,touchpoint);
				 pstmt.setString(3,touchpointTime);
				 pstmt.setInt(4,totmins);
				 pstmt.setString(5,tripstarttime);
				 pstmt.setInt(6,totmins);
				 pstmt.setString(7,tripstarttime);
				 pstmt.setInt(8,i);
				pstmt.setDouble(9,Double.parseDouble(distance));
				 instertedtransit = pstmt.executeUpdate();
				 if(instertedtransit>0){
					 logWriter.log("Touch Point Inserted",LogWriter.INFO);
					 logWriter.log("Touch Point Hub : "+ touchpoint + ", touchpointTime : " +touchpointTime +", totmins : "+totmins+", Sequence " + i,LogWriter.INFO);
					 }
				 else {
					 logWriter.log("Failed to Insert touch point",LogWriter.INFO);
					 logWriter.log("Touch Point Hub : "+ touchpoint + ", touchpointTime : " +touchpointTime +", totmins : "+totmins+", Sequence " + i,LogWriter.INFO);
				 }
				}
			}
			
			}
		if ( instertedtransit > 0) {
        message = "Saved Successfully";
        logWriter.log("Trip Insertion Completed",LogWriter.INFO);
   }
		logWriter.log(" ",LogWriter.INFO);
		logWriter.log("*****************************************************************************************",LogWriter.INFO);
	}
	} 
	 catch (Exception e)
	 {
			System.out.println("error in:-save TripGeneration details "+e.toString());
			e.printStackTrace();
			
			StringWriter errors = new StringWriter();
			e.printStackTrace(new PrintWriter(errors));
			logWriter.log(errors.toString(),LogWriter.ERROR);
			e.printStackTrace();
			logWriter.log("Before inserting",LogWriter.INFO);
			if(con!=null){
				try {
					pstmt=con.prepareStatement("insert into AMS.dbo.EmailQueue(Subject,Body,EmailList,SystemId) values (?,?,?,?)");
					pstmt.setString(1, "error in addTripGenerationDetails for SystemId "+systemId);
					pstmt.setString(2, errors.toString());
					pstmt.setString(3, "narendra.k@telematics4u.com,namrata.d@telematics4u.com");
					pstmt.setInt(4, systemId);
					pstmt.executeUpdate();
					logWriter.log("Record inserted in EmailQueue",LogWriter.INFO);
				} catch (SQLException e1) {
					errors = new StringWriter();
					e1.printStackTrace(new PrintWriter(errors));
					logWriter.log(errors.toString(),LogWriter.ERROR);
					e1.printStackTrace();
				}
			}
	 }     
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }  
	return message;
	}
	public ArrayList < Object > getTripGenerationDetails(int systemId, int customerId) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		ReportHelper finalreporthelper = new ReportHelper();
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	    SimpleDateFormat sdfDateTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    try {
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        
	        headersList.add("SL No");
	        headersList.add("Vehicle No");
	        headersList.add("Shipment Id");
	        headersList.add("Trip Start Date Time");
	        headersList.add("Total Planned Distance (Kms)");
	        headersList.add("Total Planned Duration (HH:MM)");
	        headersList.add("Route Name");
	        headersList.add("Inserted By");
	        headersList.add("Inserted Date Time");
	        
	        pstmt = con.prepareStatement(DistributionStatments.GET_TRIP_GENERATION_DETAILS);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	        	ArrayList < Object >  informationList = new ArrayList < Object > ();
	        	ReportHelper reporthelper = new ReportHelper();
	            JsonObject = new JSONObject();
	            count++;
	           
	            informationList.add(Integer.toString(count));
	            JsonObject.put("slnoIndex", count);
	            
	            informationList.add(rs.getString("ASSET_NUMBER"));
	            JsonObject.put("vehicleNoIndex", rs.getString("ASSET_NUMBER"));	 
	            
	            informationList.add(rs.getString("SHIPMENNT_ID"));
	            JsonObject.put("amazonTripIndex",rs.getString("SHIPMENNT_ID"));
	            
	            if(rs.getString("TRIP_START_TIME").equals("") || rs.getString("TRIP_START_TIME").contains("1900")){
	            	informationList.add("");
	            	JsonObject.put("TripStartDateIndex", "");
				    }else{
				    informationList.add(ddmmyyyy.format(sdfDateTime.parseObject(rs.getString("TRIP_START_TIME"))));
		            JsonObject.put("TripStartDateIndex",ddmmyyyy.format(sdfDateTime.parse(rs.getString("TRIP_START_TIME"))));	
		            } 
	            
	            informationList.add(rs.getString("PLANNED_DISTANCE"));
				JsonObject.put("totalPlannedDistanceIndex",rs.getString("PLANNED_DISTANCE"));
				
				informationList.add(rs.getString("PLANNED_DURATION").replace(".", ":"));
				JsonObject.put("totalplannedDateIndex",rs.getString("PLANNED_DURATION").replace(".", ":"));
				
				informationList.add(rs.getString("ROUTE_NAME"));
				JsonObject.put("routeNameIndex",rs.getString("ROUTE_NAME"));
				
	            informationList.add(rs.getString("INSERTED_BY"));
	            JsonObject.put("addedByIndex",rs.getString("INSERTED_BY"));
	            
				if(rs.getString("INSERTED_TIME").equals("") || rs.getString("INSERTED_TIME").contains("1900")){
					informationList.add("");
					JsonObject.put("addedDateIndex", "");
				    }else{
				    informationList.add(ddmmyyyy.format(sdfDateTime.parseObject(rs.getString("INSERTED_TIME"))));	
		            JsonObject.put("addedDateIndex",ddmmyyyy.format(sdfDateTime.parse(rs.getString("INSERTED_TIME"))));	
		            } 
				
	            JsonArray.put(JsonObject);
	            reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
	        }
	        finlist.add(JsonArray);
	        finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    } 
	    return finlist;
	}

/*-----------------------------NEW MLL DASHBORD------------------------------------------- */
	public JSONArray distributionLogisticsDashboardNewCountsDetails(int systemId,int custId,int userId) {
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		PreparedStatement pstmt1=null;
		ResultSet rs1=null;
		Connection connection=null;
		JSONArray jsonArray=new JSONArray();
		JSONArray jsonArrayAll=new JSONArray();
		JSONObject jsonObject=new JSONObject();
		JSONObject jsonObjectAll=new JSONObject();
		JSONObject jsonObject1 = null;	
		JSONObject jsonObject2 = null;	
		JSONArray touchpoin = null;
		double distanceTravelled = 0;
		boolean currenpt=false;
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat sdfDateTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		boolean custExist=false; 
		 try{
			 connection = DBConnection.getConnectionToDB("AMS");
			 
			 String cust[]=null;

			 Properties properties = ApplicationListener.prop;
	 		 String MllCustomers = properties.getProperty("MllCustomers").trim();
	 	    	  if(MllCustomers !=null && MllCustomers!=""){
	 	    		  cust=MllCustomers.split(",");
	 	    	  }
	 	    	 for(int i=0;i<cust.length;i++){
	 				int CustId=Integer.parseInt(cust[i]);
	 				if(custId==CustId){
	 					custExist=true;
	 					break;
	 				}
	 				}
			// if((systemId == 214 && custId==5015) || (systemId == 291 && custId==5492)){
			if(custExist){
			 pstmt=connection.prepareStatement(AutomotiveLogisticsStatements.GET_DETAILS_FOR_NEW_DASHBOARD.replaceAll("STATUS='Open'", "STATUS='Open' and a.INSERTED_BY > 0"));
			 }
			 else {
			 pstmt=connection.prepareStatement(AutomotiveLogisticsStatements.GET_DETAILS_FOR_NEW_DASHBOARD);
			 }
		
		 pstmt.setInt(1,systemId);
		 pstmt.setInt(2,custId);
		 pstmt.setInt(3,userId);
		 rs = pstmt.executeQuery();
		 
		 String source="SOURCE";
		 String destination="DESTINATION";
 
		 while(rs.next()){
			  source="";
			  destination="";
			 distanceTravelled = 0;
			 jsonObject1=new JSONObject();
			 
			 jsonObject1.put("clientName", rs.getString("CustomerName"));
			 jsonObject1.put("vehicleNo", rs.getString("ASSET_NUMBER"));
			 jsonObject1.put("tripNo", rs.getString("SHIPMENNT_ID"));
			 jsonObject1.put("totalDistance", rs.getDouble("PLANNED_DISTANCE"));
			 jsonObject1.put("location", rs.getString("LOCATION"));
			 
			 if(rs.getString("TRIP_STATUS").equals("DELAYED ADDRESSED"))
				 jsonObject1.put("tripStatus", "ADDRESSED");
			 
			 else
				 jsonObject1.put("tripStatus", rs.getString("TRIP_STATUS"));

			 jsonObject1.put("driverNumber", rs.getString("DRIVER_NUMBER"));
			 jsonObject1.put("tripId", rs.getString("TRIP_NAME"));
			 
			// For Non MIddle Mile Customers
			 if(systemId == 214 && custId !=5015){
			 pstmt1=connection.prepareStatement(AutomotiveLogisticsStatements.GET_TOUCH_POINT_INFO_NON_MM);  
			 }
			 else {
				 pstmt1=connection.prepareStatement(AutomotiveLogisticsStatements.GET_TOUCH_POINT_INFO);	 
			 }
			 pstmt1.setInt(1,rs.getInt("TRIP_ID"));
			 pstmt1.setInt(2,rs.getInt("TRIP_ID"));
			 rs1 = pstmt1.executeQuery();
			 
			 touchpoin=new JSONArray();
			 
			 while(rs1.next()){
				 currenpt = false;
				 if(rs1.getInt("CURR_POINT")>=rs1.getInt("SEQUENCE")){	 
				// distanceTravelled=distanceTravelled+rs1.getDouble("DISTANCE");
				 currenpt= true;
				 }
				 jsonObject2=new JSONObject();
				 if(rs1.getInt("SEQUENCE") == 0){
					 if(rs1.getString("NAME").length()>=12){
						 source = rs1.getString("NAME").substring(0, 11);
					 }else{
						 
					 source = rs1.getString("NAME");
					 }
				 }
				 if(rs1.getInt("SEQUENCE") == 100){
					 if(rs1.getString("NAME").length()>=12){
						 destination = rs1.getString("NAME").substring(0, 11);
					 }else{
						 
					 destination = rs1.getString("NAME");
					 }
				 }
				 jsonObject2.put("pointName",rs1.getString("NAME"));
				 jsonObject2.put("statusOfCurretTrip",rs1.getString("STATUS"));
				 jsonObject2.put("eta",ddmmyyyy.format(sdfDateTime.parse(rs1.getString("EXP_ARRIVAL"))));
				 jsonObject2.put("delayTime",rs1.getString("DELAY"));
				 jsonObject2.put("currentPoint",currenpt);
				 jsonObject2.put("touchPointDistance",rs1.getDouble("DISTANCE"));
				 touchpoin.put(jsonObject2);	
			 }
			 jsonObject1.put("touchPoints",touchpoin);	
			 jsonObject1.put("distanceTravelled",rs.getString("ACTUAL_DISTANCE"));
			 jsonObject1.put("source", source);
			 jsonObject1.put("destination", destination);
			 jsonArray.put(jsonObject1);
		 }
		 
		 pstmt.close();
		 rs.close();
		 jsonObjectAll.put("grid",jsonArray);
		 jsonArrayAll.put(jsonObjectAll);
		 
		}
		catch (Exception e) {
			e.printStackTrace();// TODO: handle exception
		}
		finally
		{
			 DBConnection.releaseConnectionToDB(connection, pstmt, rs);
			 DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
	return jsonArrayAll;
}

	public JSONArray distributionLogisticsDashboardNewCounts(int systemId,int custId,int userId) {
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		Connection connection=null;
		JSONArray jsonArrayAll=new JSONArray();
		JSONObject jsonObject=new JSONObject();
		JSONObject jsonObjectAll=new JSONObject();
		boolean custExist=false;
		try
		{
		 connection = DBConnection.getConnectionToDB("AMS");
		 String cust[]=null;

	     	Properties properties = ApplicationListener.prop;
			String MllCustomers = properties.getProperty("MllCustomers").trim();
	    	  if(MllCustomers !=null && MllCustomers!=""){
	    		  cust=MllCustomers.split(",");
	    	  }
	    	  for(int i=0;i<cust.length;i++){
	  			int CustId=Integer.parseInt(cust[i]);
	  			if(custId==CustId){
	  				custExist=true;
	  				break;
	  			}
	  			}
		 //if((systemId == 214 && custId==5015) || (systemId == 291 && custId==5492)){
	       if(custExist){  
			 pstmt=connection.prepareStatement(AutomotiveLogisticsStatements.GET_OVERSPEED_COUNT_FOR_NEW_DASHBOARD.replaceAll("and STATUS='Open'", "and STATUS='Open' and a.INSERTED_BY > 0"));
			 }
			 else {
		     pstmt=connection.prepareStatement(AutomotiveLogisticsStatements.GET_OVERSPEED_COUNT_FOR_NEW_DASHBOARD);
			 }
		 pstmt.setInt(1,systemId);
		 pstmt.setInt(2,custId);
		 pstmt.setInt(3,userId);
		 pstmt.setInt(4,systemId);
		 pstmt.setInt(5,custId);
		 pstmt.setInt(6,userId);
		 rs = pstmt.executeQuery();
		 
		 while(rs.next()){
			 switch(rs.getInt("flag")){
			 	case 1: jsonObject.put("overSpeed", rs.getInt("COUNT"));
			 	break;
			 	case 2: jsonObject.put("vehicleStoppage", rs.getInt("COUNT"));
			 	break;
			 }
		 }
		 pstmt.close();
		 rs.close();
		 
		 //if((systemId == 214 && custId==5015) || (systemId == 291 && custId==5492)){
		 if(custExist){
		 pstmt=connection.prepareStatement(AutomotiveLogisticsStatements.GET_ALL_COUNTS_FOR_NEW_DASHBOARD.replace("and STATUS='Open'", "and STATUS='Open' and a.INSERTED_BY > 0"));
		 }
		 else {
		 pstmt=connection.prepareStatement(AutomotiveLogisticsStatements.GET_ALL_COUNTS_FOR_NEW_DASHBOARD);
		 }
		 pstmt.setInt(1,systemId);
		 pstmt.setInt(2,custId);
		 pstmt.setInt(3,userId);
		 rs = pstmt.executeQuery();
 
		 while(rs.next()){
			 	if(rs.getString("TRIP_STATUS").equals("ON TIME"))
			 		jsonObject.put("onTime", rs.getInt("COUNTS"));
			 	
			 	if(rs.getString("TRIP_STATUS").equals("DELAYED"))
			 		jsonObject.put("delayed", rs.getInt("COUNTS"));
			 	
			  	if(rs.getString("TRIP_STATUS").equals("BEFORE TIME"))
			 		jsonObject.put("beforeTime", rs.getInt("COUNTS"));
			 	
			 	if(rs.getString("TRIP_STATUS").equals("DELAYED ADDRESSED"))
			 		jsonObject.put("delayedAddress", rs.getInt("COUNTS"));
		 }
		 pstmt.close();
		 rs.close();
		 jsonObjectAll.put("count",jsonObject);
		 jsonArrayAll.put(jsonObjectAll);
		 }
		catch (Exception e) {
			e.printStackTrace();// TODO: handle exception
		}
		finally
		{
			 DBConnection.releaseConnectionToDB(connection, pstmt, rs);
		}
	return jsonArrayAll;
}	
	public enum colun {
		Vehicle_No,
		Source,
		Destination,
		Touch_Point_in_Sequence,
		Trip_Start_Time_Planned,
		Trip_Start_Time_Actual,
		Planned_Destination_ETA,
		Revised_Destination_ETA,
		Total_Trip_Distance,
		Touch_Points_Covered,
		Next_Touch_Point,
		Current_Location,
		Km_Coverd,
		Km_to_be_Covered,
		Trip_Status,
		Trip_Completion,
		Stoppage,
		Unauthorised_Stoppage,
		Shipment_Id
	}

	public ArrayList < Object > getDashBoardDetails1(int systemId, int customerId,String type) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null; 
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    double cmp_per = 0;
	    ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		ReportHelper finalreporthelper = new ReportHelper();
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	    String All_Touch_points = "";
	    List<String > Header= new ArrayList<String>();
	    
	    
	    int slno = 0;
	    String shipment_Id = "";
	    String vehicle_no = "";
	    String current_location = "";
	    String kmsCovered = "";
	    String kmsToBeCovered = "";
	    String trip_status = "";
	    String route_name = "";
	    double trip_completion = 0;
	    String planned_Distance = "";
	    String trip_start_time_planned = "";
	    String trip_start_time_actual = "";
	    String planned_destination_eta = "";
	    String revised_destination_eta = "";
	    String start_point = "";
	    String destination = "";
	    String touch_point_sequence = "";
	    String total_trip_distance = "";
	    String covered_points = "";
	    String next_touch_points = "";
	    double newduration = 0 ;
	    boolean flag = false;
	    DecimalFormat df = new DecimalFormat("#.##"); 
	    boolean custExist=false;
	    try {
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	       
	        
	        ArrayList < Object >  informationList =  null;
	     	ReportHelper reporthelper = null;
	     	
	     	headersList.add("SL No");
	     	String cust[]=null;

	     	Properties properties = ApplicationListener.prop;
			String MllCustomers = properties.getProperty("MllCustomers").trim();
	    	  if(MllCustomers !=null && MllCustomers!=""){
	    		  cust=MllCustomers.split(",");
	    	  }
	    	  for(int i=0;i<cust.length;i++){
	  			int custId=Integer.parseInt(cust[i]);
	  			if(customerId==custId){
	  				custExist=true;
	  				break;
	  			}
	  			}
			//if(customerId==5015 || customerId==5019 || ((systemId == 291) && (customerId==5492))){
	    	  if(custExist){
		        	if(type.equalsIgnoreCase("delay")){
		        		 pstmt = con.prepareStatement(DistributionStatments.GET_DASHBOARD_DETAILS.replace("#"," and TRIP_STATUS='DELAYED' "));
		        	}else if(type.equalsIgnoreCase("ontime")){
		        		pstmt = con.prepareStatement(DistributionStatments.GET_DASHBOARD_DETAILS.replace("#"," and TRIP_STATUS='ON TIME' "));
		        	}else if (type.equalsIgnoreCase("address")){
		        		pstmt = con.prepareStatement(DistributionStatments.GET_DASHBOARD_DETAILS.replace("#"," and TRIP_STATUS='DELAYED ADDRESSED' "));
		        	}else if (type.equalsIgnoreCase("beforetime")){
		        		pstmt = con.prepareStatement(DistributionStatments.GET_DASHBOARD_DETAILS.replace("#"," and TRIP_STATUS='BEFORE TIME' "));
		        	}
		        	else{
		        		pstmt = con.prepareStatement(DistributionStatments.GET_DASHBOARD_DETAILS.replace("#",  "and TRIP_STATUS <> 'NEW' "));
		        	}
		        }else{
		        	if(type.equalsIgnoreCase("delay")){
		        		 pstmt = con.prepareStatement(DistributionStatments.GET_DETAILS.replace("#"," and TRIP_STATUS='DELAYED' "));
		        	}else if(type.equalsIgnoreCase("ontime")){
		        		pstmt = con.prepareStatement(DistributionStatments.GET_DETAILS.replace("#"," and TRIP_STATUS='ON TIME' "));
		        	}else if (type.equalsIgnoreCase("address")){
		        		pstmt = con.prepareStatement(DistributionStatments.GET_DETAILS.replace("#"," and TRIP_STATUS='DELAYED ADDRESSED' "));
		        	}else if (type.equalsIgnoreCase("beforetime")){
		        		pstmt = con.prepareStatement(DistributionStatments.GET_DETAILS.replace("#"," and TRIP_STATUS='BEFORE TIME' "));
		        	}
		        	else{
		        		pstmt = con.prepareStatement(DistributionStatments.GET_DETAILS.replace("#", "and TRIP_STATUS <> 'NEW' "));
		        	}
		        }
		        pstmt.setInt(1, systemId);
		        pstmt.setInt(2, customerId);
		        
		        rs = pstmt.executeQuery();
	        while (rs.next()) {
	        	if(shipment_Id.equals("") || !shipment_Id.equals(rs.getString("SHIPMENNT_ID"))){
	        		count++;
	        		informationList = new ArrayList < Object > ();
		        	reporthelper = new ReportHelper();
		            JsonObject = new JSONObject();
		            
		            newduration=(rs.getDouble("DURATION"))*60.0;
		            
		            informationList.add(count);
		            JsonObject.put("slnoIndex", count);			        	
		            
		            shipment_Id = rs.getString("SHIPMENNT_ID");
		            JsonObject.put("shipmentIdIndex", rs.getString("SHIPMENNT_ID"));	 
		            
		            vehicle_no =  rs.getString("ASSET_NUMBER");
		            JsonObject.put("vehicleNoDataIndex", rs.getString("ASSET_NUMBER"));	
		            
		            current_location = rs.getString("LOCATION");
		            JsonObject.put("locationDataIndex",
		            		 " <div class='location-icon'><img src='/ApplicationImages/DashBoard/location-pin.png' alt='location-pin' value ="+rs.getString("LATITUDE")+";"+rs.getString("LONGITUDE")+";"+rs.getString("CATEGORY").toUpperCase() + " name ="+rs.getString("LOCATION").replace(" ", "*")+" onClick='showMapView(this)';></div> " +
		            		rs.getString("LOCATION"));
		            
		            kmsCovered = rs.getString("ACTUAL_DISTANCE");
		            JsonObject.put("kmsDataIndex", rs.getString("ACTUAL_DISTANCE"));	 
		            
		            if(rs.getFloat("DIST_TO_DEST")<0){
		            	kmsToBeCovered = "0";
			            JsonObject.put("kmtoDestDataIndex", 0);	 
		            }else{
		            	kmsToBeCovered = rs.getString("DIST_TO_DEST");
			            JsonObject.put("kmtoDestDataIndex", rs.getString("DIST_TO_DEST"));	 
		            }
		            
		            if(rs.getDouble("PLANNED_DISTANCE")>0){

		            	cmp_per = (rs.getDouble("ACTUAL_DISTANCE")/rs.getDouble("PLANNED_DISTANCE"))*100;
		            	cmp_per = Double.valueOf(df.format(cmp_per));
		            }
		           
		            trip_status = rs.getString("TRIP_STATUS");
		            JsonObject.put("statusDataIndex", rs.getString("TRIP_STATUS"));	 
		            
		            if(cmp_per<100){
		            	trip_completion = cmp_per;
		  	            JsonObject.put("completionDataIndex", cmp_per);	
		            	
		            }
		            else {
		            	trip_completion = 0;
		  	            JsonObject.put("completionDataIndex", "NA");	
		            }
		            
		            route_name = rs.getString("ROUTE_NAME");
		            JsonObject.put("routeNameIndex", rs.getString("ROUTE_NAME"));
		            
		            if(rs.getString("PLANNED_TRIP_TIME").contains("1900"))
					{
		            	trip_start_time_planned = "";
						JsonObject.put("plannedStartTimeDataIndex","");
					}else{
						trip_start_time_planned = diffddMMyyyyHHmmss.format(rs.getTimestamp("PLANNED_TRIP_TIME"));
						JsonObject.put("plannedStartTimeDataIndex", diffddMMyyyyHHmmss.format(rs.getTimestamp("PLANNED_TRIP_TIME")));
					}
		            
		            if(rs.getString("ACTUAL_START_TIME").contains("1900"))
					{
		            	trip_start_time_actual = "";
						JsonObject.put("actualStartTimeDataIndex","");
					}else{
						trip_start_time_actual = diffddMMyyyyHHmmss.format(rs.getTimestamp("ACTUAL_START_TIME"));
						JsonObject.put("actualStartTimeDataIndex", diffddMMyyyyHHmmss.format(rs.getTimestamp("ACTUAL_START_TIME")));
					}
		            planned_Distance = rs.getString("PLANNED_DISTANCE");
		            JsonObject.put("tripDistanceDataIndex", rs.getString("PLANNED_DISTANCE"));	 
		            
		            JsonObject.put("nextTouchptDataIndex", rs.getString("NEXT_POINT"));	 
		            next_touch_points = rs.getString("NEXT_POINT");
	        	}
	        	
	        	if(!flag){
		            if("STOPPAGE".equals(rs.getString("CATEGORY").toUpperCase()) && newduration>10)
		            {
		            flag = true;
		            //if (rs.getString("HUB_STATUS").toUpperCase().contains("INSIDE") && (customerId==5015 || ((systemId == 291) && (customerId==5492)))) 
		            if (rs.getString("HUB_STATUS").toUpperCase().contains("INSIDE") && custExist)
		            {
		            //take hub id and if hub is not source,destination or transit points then make flag as true or else false
		            if (rs.getDouble("STOP_HUB")!=rs.getDouble("HUB_ID")) {
		            flag = true;
		            }else{
		            flag = false;
		            }
		            }else{
		            flag = true;
		            }
		            }
	        	}
	        	if(rs.getString("TOUCH_POINT").contains(",")){
	        	 All_Touch_points = All_Touch_points + rs.getString("TOUCH_POINT").substring(0, rs.getString("TOUCH_POINT").indexOf(","))+ "  -  " ;
	        	}
	        	else {
	        	All_Touch_points = All_Touch_points + rs.getString("TOUCH_POINT")+ "  -  " ;
	        	}
	        	
	            if(rs.getInt("SEQUENCE")==0){
	            start_point = rs.getString("TOUCH_POINT");
	            JsonObject.put("sourceDataIndex", rs.getString("TOUCH_POINT"));	 
	            
	            }
	            
	            if(rs.getString("TOUCH_POINT_ACT")!=null){
	            	
	            	if(rs.getString("TOUCH_POINT").contains(",")){
	            	covered_points = covered_points +rs.getString("TOUCH_POINT").substring(0, rs.getString("TOUCH_POINT").indexOf(",")) + "  -  " ;
	            	}
	            	else {
	            		covered_points = covered_points +rs.getString("TOUCH_POINT")+ "  -  " ;
	            	}
	            	
	            }
	            
	            
	            if(rs.getInt("SEQUENCE")==100){
	            	All_Touch_points =  All_Touch_points.substring(0,  All_Touch_points.lastIndexOf("-"));
	            	if(covered_points.length()>0){
	            	covered_points =  covered_points.substring(0,  covered_points.lastIndexOf("-"));
	            	}
	            	destination = rs.getString("TOUCH_POINT");
		            JsonObject.put("destataIndex", rs.getString("TOUCH_POINT"));	 
		            
		            touch_point_sequence = All_Touch_points;
		            JsonObject.put("pointInSequenceDataIndex", All_Touch_points);
		            
		            if(rs.getString("ETA_DATETIME").contains("1900"))
					{
		            	planned_destination_eta = "";
						JsonObject.put("etaDataIndex","");
					}else{
						planned_destination_eta = diffddMMyyyyHHmmss.format(rs.getTimestamp("ETA_DATETIME"));
						JsonObject.put("etaDataIndex", diffddMMyyyyHHmmss.format(rs.getTimestamp("ETA_DATETIME")));
					}
		            
		            if(rs.getString("EXP_ETA_DATETIME").contains("1900"))
					{
		            revised_destination_eta = "";
		            JsonObject.put("revisedetaDataIndex","");	
					}
		            else{
		            	revised_destination_eta = diffddMMyyyyHHmmss.format(rs.getTimestamp("EXP_ETA_DATETIME"));
						JsonObject.put("revisedetaDataIndex", diffddMMyyyyHHmmss.format(rs.getTimestamp("EXP_ETA_DATETIME")));
					}
		            
		            JsonObject.put("touchPtCoveredDataIndex", covered_points);
		            if(flag){
		            JsonObject.put("categoryIndex", rs.getString("CATEGORY").toUpperCase());
		            }else{
		            JsonObject.put("categoryIndex", "");
		            }
		            JsonObject.put("stoppageOutsideIndex",flag);
		         
		            
		            informationList.add(shipment_Id);
		            informationList.add(vehicle_no);
		            informationList.add(start_point);
		            informationList.add(destination);
		            informationList.add(touch_point_sequence);
		            informationList.add(trip_start_time_planned);
		            informationList.add(trip_start_time_actual);
		            informationList.add(planned_destination_eta);
		            informationList.add(revised_destination_eta);
		            informationList.add(planned_Distance);
		            informationList.add(covered_points);
		            informationList.add(next_touch_points);
		            informationList.add(current_location);
		            informationList.add(kmsCovered);
		            informationList.add(kmsToBeCovered);
		            informationList.add(trip_status);
		            informationList.add(trip_completion);
		            informationList.add(flag);
		            
		            informationList.add(rs.getString("CATEGORY").toUpperCase()+";"+flag);
		            
		            JsonArray.put(JsonObject);
		            reporthelper.setInformationList(informationList);
		            reportsList.add(reporthelper);
					
					All_Touch_points = "";
	        	    covered_points = "";
	        	    shipment_Id="";
	        	    newduration = 0 ;
	        	    flag = false;
		            }
	            
	            shipment_Id = rs.getString("SHIPMENNT_ID");
	          
	        }
	        finlist.add(JsonArray);
	        
	        finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);
			System.out.println(finlist);
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    } 
	    return finlist;
	}
	public JSONArray getColumnHeaders(int systemId, int customerId,int userId) {

		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DistributionStatments.GET_COLUMN_HEADERS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				count++;
				JsonObject = new JSONObject();
				JsonObject.put("slnoIndex", count);
				JsonObject.put("columnId", rs.getString("ID"));
				JsonObject.put("columnsIndex", rs.getString("COLUMN_NAME"));
				JsonObject.put("checkedStatus", rs.getString("CHECKED_STATUS"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return JsonArray;
}
	
	
	public enum columnHeaders {
		Vehicle_No,
		Source,
		Destination,
		Touch_Point_in_Sequence,
		Trip_Start_Time_Planned,
		Trip_Start_Time_Actual,
		Planned_Destination_ETA,
		Revised_Destination_ETA,
		Total_Trip_Distance,
		Touch_Points_Covered,
		Next_Touch_Point,
		Current_Location,
		Km_Coverd,
		Km_to_be_Covered,
		Trip_Status,
		Trip_Completion,
		Stoppage,
		Unauthorised_Stoppage,
		Shipment_Id
	}
	
	
	@SuppressWarnings("unused")
	public ArrayList < Object > getDashBoardDetails(int systemId, int customerId,String type,int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null; 
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		double cmp_per = 0;
		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList < Object > finlist = new ArrayList < Object > ();
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		String All_Touch_points = "";
		List<String > Header= new ArrayList<String>();

		String shipment_Id = "";
		String vehicle_no = "";
		String current_location = "";
		String kmsCovered = "";
		String kmsToBeCovered = "0";
		String trip_status = "";
		double trip_completion = 0;
		String planned_Distance = "";
		String trip_start_time_planned = "";
		String trip_start_time_actual = "";
		String planned_destination_eta = "";
		String revised_destination_eta = "";
		String start_point = "";
		String destination = "";
		String touch_point_sequence = "";
		String covered_points = "";
		String next_touch_points = "";
		double newduration = 0 ;
		boolean flag = false;
		DecimalFormat df = new DecimalFormat("#.##"); 
		String category="";
		boolean stoppage=false;
		int custId=0;
		boolean custExist=false;
		try {
			int count = 0;
			con = DBConnection.getConnectionToDB("AMS");
			ArrayList < Object >  informationList =  null;
			ReportHelper reporthelper = null;
			String cust[]=null;
			
			Properties properties = ApplicationListener.prop;
			String MllCustomers = properties.getProperty("MllCustomers").trim();
			 if(MllCustomers !=null && MllCustomers!=""){
	    		  cust=MllCustomers.split(",");
	    	  }
			headersList.add("SL No");			
			pstmt=con.prepareStatement(DistributionStatments.GET_COLUMN_HEADERS_FOR_USER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs=pstmt.executeQuery();			
			while(rs.next()){
				Header.add(rs.getString("LABEL"));
				headersList.add(rs.getString("VALUE"));
			}
			headersList.add("Stoppage");
			headersList.add("Unauthorised Stoppage");
			
			for(int i=0;i<cust.length;i++){
			custId=Integer.parseInt(cust[i]);
			if(customerId==custId){
				custExist=true;
				break;
			}
			} 
			//if(customerId==5015 || customerId==5019 || ((systemId == 291) && (customerId==5492))){
			//if(MllCustomers.contains(String.valueOf(customerId))){
				if(custExist){
				if(type.equalsIgnoreCase("delay")){
					pstmt = con.prepareStatement(DistributionStatments.GET_DASHBOARD_DETAILS.replace("#"," and TRIP_STATUS='DELAYED' "));
				}else if(type.equalsIgnoreCase("ontime")){
					pstmt = con.prepareStatement(DistributionStatments.GET_DASHBOARD_DETAILS.replace("#"," and TRIP_STATUS='ON TIME' "));
				}else if (type.equalsIgnoreCase("address")){
					pstmt = con.prepareStatement(DistributionStatments.GET_DASHBOARD_DETAILS.replace("#"," and TRIP_STATUS='DELAYED ADDRESSED' "));
				}else if (type.equalsIgnoreCase("beforetime")){
					pstmt = con.prepareStatement(DistributionStatments.GET_DASHBOARD_DETAILS.replace("#"," and TRIP_STATUS='BEFORE TIME' "));
				}
				else{
					pstmt = con.prepareStatement(DistributionStatments.GET_DASHBOARD_DETAILS.replace("#",  "and TRIP_STATUS <> 'NEW' "));
				}
			}else{
				if(type.equalsIgnoreCase("delay")){
					pstmt = con.prepareStatement(DistributionStatments.GET_DETAILS.replace("#"," and TRIP_STATUS='DELAYED' "));
				}else if(type.equalsIgnoreCase("ontime")){
					pstmt = con.prepareStatement(DistributionStatments.GET_DETAILS.replace("#"," and TRIP_STATUS='ON TIME' "));
				}else if (type.equalsIgnoreCase("address")){
					pstmt = con.prepareStatement(DistributionStatments.GET_DETAILS.replace("#"," and TRIP_STATUS='DELAYED ADDRESSED' "));
				}else if (type.equalsIgnoreCase("beforetime")){
					pstmt = con.prepareStatement(DistributionStatments.GET_DETAILS.replace("#"," and TRIP_STATUS='BEFORE TIME' "));
				}
				else{
					pstmt = con.prepareStatement(DistributionStatments.GET_DETAILS.replace("#", "and TRIP_STATUS <> 'NEW' "));
				}
			}
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				if(rs.getString("TOUCH_POINT").contains(",")){
					All_Touch_points = All_Touch_points + rs.getString("TOUCH_POINT").substring(0, rs.getString("TOUCH_POINT").indexOf(","))+ "  -  " ;
				}else{
					All_Touch_points = All_Touch_points + rs.getString("TOUCH_POINT")+ "  -  " ;
				}
				if(rs.getString("TOUCH_POINT_ACT")!=null){
					if(rs.getString("TOUCH_POINT").contains(",")){
						covered_points = covered_points +rs.getString("TOUCH_POINT").substring(0, rs.getString("TOUCH_POINT").indexOf(",")) + "  -  " ;
					}else{
						covered_points = covered_points +rs.getString("TOUCH_POINT")+ "  -  " ;
					}
				}
				if(shipment_Id.equals("") || !shipment_Id.equals(rs.getString("SHIPMENNT_ID"))){
					if(rs.getInt("SEQUENCE")==0){
						newduration=(rs.getDouble("DURATION"))*60.0;
						if(rs.getDouble("PLANNED_DISTANCE")>0){
							cmp_per = (rs.getDouble("ACTUAL_DISTANCE")/rs.getDouble("PLANNED_DISTANCE"))*100;
							cmp_per = Double.valueOf(df.format(cmp_per));
						}
						if(rs.getFloat("DIST_TO_DEST")<0){kmsToBeCovered = "0";}else{kmsToBeCovered=rs.getString("DIST_TO_DEST");}
						shipment_Id = rs.getString("SHIPMENNT_ID");
						vehicle_no =  rs.getString("ASSET_NUMBER");
						current_location = rs.getString("LOCATION");
						kmsCovered = rs.getString("ACTUAL_DISTANCE");
						if(cmp_per<100){trip_completion = cmp_per;}else{trip_completion=0;}
						trip_status = rs.getString("TRIP_STATUS");
						if(!rs.getString("ACTUAL_START_TIME").contains("1900")){
							trip_start_time_actual = diffddMMyyyyHHmmss.format(rs.getTimestamp("ACTUAL_START_TIME"));
					    }
						if(!rs.getString("PLANNED_TRIP_TIME").contains("1900")){
							trip_start_time_planned = diffddMMyyyyHHmmss.format(rs.getTimestamp("PLANNED_TRIP_TIME"));
						}
						planned_Distance = rs.getString("PLANNED_DISTANCE");
						next_touch_points = rs.getString("NEXT_POINT");
						start_point = rs.getString("TOUCH_POINT");
					}
				 }	
					 if (!flag) {
						if ("STOPPAGE".equals(rs.getString("CATEGORY").toUpperCase())&& newduration > 10) {
							flag = true;
							//if (rs.getString("HUB_STATUS").toUpperCase().contains("INSIDE")&& (customerId == 5015 || ((systemId == 291) && (customerId == 5492)))) {
							if (rs.getString("HUB_STATUS").toUpperCase().contains("INSIDE")&& custExist) {	
							if (rs.getDouble("STOP_HUB") != rs.getDouble("HUB_ID")) {
									flag = true;
								} else {
									flag = false;
								}
							} else {
								flag = true;
							}
						}
					 }
				  if(rs.getInt("SEQUENCE")==100){
						All_Touch_points =  All_Touch_points.substring(0,  All_Touch_points.lastIndexOf("-"));
						destination = rs.getString("TOUCH_POINT");
						if(covered_points.length()>0){
							covered_points =  covered_points.substring(0,  covered_points.lastIndexOf("-"));
						}
						touch_point_sequence = All_Touch_points;
						if(!rs.getString("ETA_DATETIME").contains("1900")){
							planned_destination_eta = diffddMMyyyyHHmmss.format(rs.getTimestamp("ETA_DATETIME"));
						}
						if(!rs.getString("EXP_ETA_DATETIME").contains("1900")){
							revised_destination_eta = diffddMMyyyyHHmmss.format(rs.getTimestamp("EXP_ETA_DATETIME"));
						}
						if(flag){
							category=rs.getString("CATEGORY").toUpperCase();
						}else{
							category="";
						}
						stoppage=flag;
						count++;
						informationList = new ArrayList < Object > ();
						reporthelper = new ReportHelper();
						JsonObject = new JSONObject();

						informationList.add(count);
						JsonObject.put("slnoIndex", count);			      

						JsonObject.put("routeNameIndex", rs.getString("ROUTE_NAME"));
						for(String header:Header){
							switch (columnHeaders.valueOf(header)) {
							case Shipment_Id :
								informationList.add(shipment_Id);
								JsonObject.put("shipmentIdIndex", shipment_Id);
								break;
							case Vehicle_No :
								informationList.add(vehicle_no);
								JsonObject.put("vehicleNoDataIndex", vehicle_no);
								break;
							case Source:
								informationList.add(start_point);
								JsonObject.put("sourceDataIndex", start_point);	 
								break; 
							case Destination:
								informationList.add(destination);
								JsonObject.put("destataIndex", destination);	 
								break;  
							case Touch_Point_in_Sequence:
								informationList.add(All_Touch_points);
								JsonObject.put("pointInSequenceDataIndex", All_Touch_points); 
								break;  
							case Trip_Start_Time_Planned:
								informationList.add(trip_start_time_planned);
								JsonObject.put("plannedStartTimeDataIndex", trip_start_time_planned);
								break;
							case Trip_Start_Time_Actual:
								informationList.add(trip_start_time_actual);
								JsonObject.put("actualStartTimeDataIndex", trip_start_time_actual);
								break;
							case Planned_Destination_ETA:
								informationList.add(planned_destination_eta);
								JsonObject.put("etaDataIndex", planned_destination_eta); 
								break;  
							case Revised_Destination_ETA:
								informationList.add(revised_destination_eta);
								JsonObject.put("revisedetaDataIndex", revised_destination_eta); 
								break;  
							case Total_Trip_Distance:
								informationList.add(planned_Distance);
								JsonObject.put("tripDistanceDataIndex", planned_Distance);	 
								break;  
							case Touch_Points_Covered:
								informationList.add(covered_points);
								JsonObject.put("touchPtCoveredDataIndex", covered_points); 
								break; 
							case Next_Touch_Point:
								informationList.add(next_touch_points);
								JsonObject.put("nextTouchptDataIndex", next_touch_points);	 
								break;  
							case Current_Location :
								informationList.add(current_location);
								JsonObject.put("locationDataIndex", " <div class='location-icon'><img src='/ApplicationImages/DashBoard/location-pin.png' alt='location-pin' value ="+rs.getString("LATITUDE")+";"+rs.getString("LONGITUDE")+";"+rs.getString("CATEGORY").toUpperCase() + " name ="+rs.getString("LOCATION").replace(" ", "*")+" onClick='showMapView(this)';></div> " +rs.getString("LOCATION"));
								break;
							case Km_Coverd :
								informationList.add(kmsCovered);
								JsonObject.put("kmsDataIndex", kmsCovered);
								break;
							case Km_to_be_Covered:
								informationList.add(kmsToBeCovered);
								JsonObject.put("kmtoDestDataIndex", kmsToBeCovered);
								break;
							case Trip_Status:
								informationList.add(trip_status);
								JsonObject.put("statusDataIndex", trip_status);
								break;
							case Trip_Completion:
								informationList.add(trip_completion);
								JsonObject.put("completionDataIndex", "NA");
								break;
							}
						}
						informationList.add(category+";"+flag);
						JsonObject.put("stoppageOutsideIndex", flag); 
						
						informationList.add(rs.getString("CATEGORY").toUpperCase()+";"+flag);
						JsonObject.put("categoryIndex", category); 
						
						JsonArray.put(JsonObject);
			            reporthelper.setInformationList(informationList);
			            reportsList.add(reporthelper);
			            
						All_Touch_points = "";
						covered_points = "";
						shipment_Id="";
						newduration = 0 ;
						flag = false;
					}
					shipment_Id = rs.getString("SHIPMENNT_ID");
			}
			finlist.add(JsonArray);
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		} 
		return finlist;
	}
	public String associateHeader(int customerId, int systemId, JSONArray js,int userId) {
	    Connection con = null;
	    PreparedStatement pstmt2 = null;
	    PreparedStatement pstmt3 = null;
	    ResultSet rs1 = null;
	    String message = "";
	    ArrayList < String > columnList = new ArrayList < String > ();
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt3 = con.prepareStatement(DistributionStatments.DELETE_PREV_RECORDS);
            pstmt3.setInt(1, userId);
            pstmt3.setInt(2, customerId);
            pstmt3.setInt(3, systemId);
            int deleted=pstmt3.executeUpdate();
	        for (int i = 0; i < js.length(); i++) {
	        	columnList.clear();
	            JSONObject obj = js.getJSONObject(i);
	            String columnId = obj.getString("columnId");
            	pstmt3 = con.prepareStatement(DistributionStatments.INSERT_INTO_COLUMN_SETTINGS);
                pstmt3.setString(1, columnId);
	            pstmt3.setInt(2, userId);
	            pstmt3.setInt(3, customerId);
	            pstmt3.setInt(4, systemId);
	            pstmt3.setInt(5, userId);
                pstmt3.executeUpdate();
	         }
	        message = "Columns Associated Successfully.";
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt2, rs1);
	        DBConnection.releaseConnectionToDB(null, pstmt3, null);
	    }
	    return message;
	}
	public String insertIndentMasterDetails(int systemId,int custId,int offset,int userId,String region,int dedicatedCount,int adhocCount,String supervisorName,
			String supervisorContact,int  hubId,String custName) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs=null;
		String message="";
		int totalCount=dedicatedCount+adhocCount;
		try {
			con = DBConnection.getConnectionToDB("AMS");
	    	pstmt = con.prepareStatement(DistributionStatments.INSERT_INDENT_DETAILS);
	     	pstmt.setInt(1, hubId);
	     	pstmt.setString(2, region);
	     	pstmt.setInt(3, dedicatedCount);
	     	pstmt.setInt(4, adhocCount);
	     	pstmt.setInt(5, totalCount);
	     	pstmt.setString(6, supervisorName);
	     	pstmt.setString(7, supervisorContact);
	     	pstmt.setInt(8, systemId);
			pstmt.setInt(9, custId);
			pstmt.setInt(10, userId);
			pstmt.setString(11, custName);
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "success";
			}else{
				message="error";
			}
		   
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return message;
	}
	public String updateIndentMasterDetails(int indentId, String region,int dedicatedCount,int adhocCount,String supervisorName,String supervisorContact) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs=null;
		String message="";
		try {
			con = DBConnection.getConnectionToDB("AMS");
	    	pstmt = con.prepareStatement(DistributionStatments.UPDATE_INDENT_MASTER_DETAILS);
	     	pstmt.setString(1, region);
	     	pstmt.setInt(2, dedicatedCount);
	     	pstmt.setInt(3, adhocCount);
	     	pstmt.setInt(4, dedicatedCount+adhocCount);
	     	pstmt.setString(5, supervisorName);
	     	pstmt.setString(6, supervisorContact);
	     	pstmt.setInt(7, indentId);
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "success";
			}else{
				message="error";
			}
		   
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return message;
	}
	public JSONArray getIndentMasterDetails(int systemId,String custId,int offset,int userId,String mllCust,String userAuthority) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DistributionStatments.GET_INDENT_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, custId);
			pstmt.setString(3, mllCust);
			pstmt.setInt(4, userId);
			pstmt.setInt(5, systemId);
			rs = pstmt.executeQuery();
			boolean isAdmin = ("Admin".equals(userAuthority)) ?true : false; 
			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slno", count);
				jsonobject.put("nodeIndex", rs.getString("NODE"));
				jsonobject.put("regionIndex", rs.getString("REGION"));
				jsonobject.put("dedicatedIndex", rs.getString("DEDICATED_COUNT"));
				jsonobject.put("adhocIndex", rs.getString("ADHOC_COUNT"));
				jsonobject.put("totalIndex", rs.getString("TOTAL_COUNT"));
				jsonobject.put("assignedDedicatedIndex", rs.getString("ASSIGNED_DEDICATED_COUNT"));
				jsonobject.put("assignedAdhocIndex", rs.getString("ASSIGNED_ADHOC_COUNT"));
				jsonobject.put("supervisorName", rs.getString("SUPERVISOR_NAME"));
				jsonobject.put("supervisorContact", rs.getString("SUPERVISOR_CONTACT"));
				if(rs.getInt("COUNT")>0){
					jsonobject.put("button", "<button onclick=openModal("+rs.getString("ID")+","+rs.getString("ADHOC_COUNT")+","+rs.getString("DEDICATED_COUNT")
																		 +','+rs.getString("ASSIGNED_ADHOC_COUNT")+","+rs.getString("ASSIGNED_DEDICATED_COUNT")+','+0+"); class='btn btn-info btn-sm text-center' >View Details</button>" );
				}else{
					jsonobject.put("button", "<button onclick=openModal("+rs.getString("ID")+","+rs.getString("ADHOC_COUNT")+","+rs.getString("DEDICATED_COUNT")
																		 +','+rs.getString("ASSIGNED_ADHOC_COUNT")+","+rs.getString("ASSIGNED_DEDICATED_COUNT")+','+1+"); class='btn btn-info btn-sm text-center' >Add Details</button>" );
				}
				
				if(isAdmin){
					jsonobject.put("modifyButton", "<button onclick=addOrUpdateIndent("+"'"+rs.getString("ID")+"'"+","
																					   +rs.getString("ASSIGNED_ADHOC_COUNT")+","+rs.getString("ASSIGNED_DEDICATED_COUNT")+','+1+"); class='btn btn-info btn-sm text-center'>Modify</button>");
				}else{
					jsonobject.put("modifyButton", "<div></div>");
				}
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	public JSONArray getAssetTypeDetails(int systemId, int userId) {
	    JSONArray JsonArray = null;
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    int count = 0;
	    try {
	        JsonArray = new JSONArray();
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(AdminStatements.GET_ASSET_TYPE_FOR_MANAGE_ASSET);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            count++;
	            JsonObject = new JSONObject();
	            JsonObject.put("AssetType", rs.getString("Category_name"));
	            JsonArray.put(JsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}
	public JSONArray getMakes(int systemId, int clientId) {
	    JSONArray JsonArray = null;
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    int count = 0;
	    try {
	        JsonArray = new JSONArray();
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(DistributionStatments.GET_ASSET_MODEL_NAMES);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, clientId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            count++;
	            JsonObject = new JSONObject();
	            JsonObject.put("make", rs.getString("ModelName"));
	            JsonArray.put(JsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}
	public JSONArray getIndentVehicleDetails(int systemId,String uniqueId,int offset,int userId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(DistributionStatments.GET_INDENT_VEHICLE_DETAILS);
			pstmt.setString(1, uniqueId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slno", count);
				jsonobject.put("node", rs.getString("NODE"));
				jsonobject.put("vehcileType", rs.getString("VEHICLE_TYPE"));
				jsonobject.put("make", rs.getString("MAKE"));
				jsonobject.put("noOfVehcicles", rs.getString("VEHICLE_COUNT"));
				jsonobject.put("dedicated", rs.getString("TYPE"));
				jsonobject.put("placementTime", rs.getString("PLACEMENT_TIME"));
				int id=rs.getInt("ID");
				int indentId=rs.getInt("INDENT_ID");
				int vcount=rs.getInt("VEHICLE_COUNT");
				String type="'"+rs.getString("TYPE")+"'";
				String vehicleType="'"+rs.getString("VEHICLE_TYPE").replaceAll("\\s","*")+"'";
				String make="'"+rs.getString("MAKE").replaceAll("\\s","*")+"'";
				String placementTime="'"+rs.getString("PLACEMENT_TIME")+"'";
				jsonobject.put("action", "<a href='#'><span id='editId' class='glyphicon glyphicon-pencil' onClick=updateRecord("+id+","+type+","+vcount+","+indentId+","+vehicleType+","+make+","+placementTime
						+");></a>");
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	public JSONArray insertIndentVehicleDetails(int systemId,int id,int ffset,int userId,String vehicleType,int noOfVehicles,String type,
			String placementTime,String make) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs=null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObj= new JSONObject();
		try {
			con = DBConnection.getConnectionToDB("AMS");
	    	pstmt = con.prepareStatement(DistributionStatments.INSERT_INDENT_VEHICLE_DETAILS);
	     	pstmt.setInt(1, id);
	     	pstmt.setString(2, vehicleType);
	     	pstmt.setString(3, make);
	     	pstmt.setInt(4, noOfVehicles);
	     	pstmt.setString(5, type);
	     	pstmt.setString(6, placementTime);
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				jsonObj.put("message","success");
			}else{
				jsonObj.put("message","error");
			}
			jsonArray.put(jsonObj);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return jsonArray;
	}
	public JSONArray getTotalCount(int id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs=null;
		String count="0";
		int AdhocCount=0;
		int dedicated=0;
		int a=0;
		int d=0;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
	    	pstmt = con.prepareStatement(DistributionStatments.GET_TOTAL_VEHICLE_COUNT);
	     	pstmt.setInt(1, id);
			rs=pstmt.executeQuery();
			while(rs.next()){
				if(rs.getString("TYPE").equals(VEHICLE_TYPE_AD_HOC)){
					AdhocCount=rs.getInt("VEHICLE_COUNT");
				}if(rs.getString("TYPE").equals(VEHICLE_TYPE_DEDICATED)){
				   dedicated=rs.getInt("VEHICLE_COUNT");
				}
				a=rs.getInt("ADHOC_COUNT");
				d=rs.getInt("DEDICATED_COUNT");
			}
			 jsonobject .put("adhoc", AdhocCount);
			 jsonobject .put("dedicatedC", dedicated);
			 
			 jsonobject .put("totaladhoc", a);
			 jsonobject .put("totaldedicatedC", d);
			 jsonArray.put(jsonobject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return jsonArray;
	}
	public JSONArray updateIndentVehicleDetails(int systemId,String id,int indentMasterId,int count,String type,String vehicleType,String placementTime,String make){
		Connection con=null;
		PreparedStatement pstmt=null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		try {
		con = DBConnection.getConnectionToDB("AMS");
		String stmt=DistributionStatments.UPDATE_INDENT_VEHICLE_DETAILS;
		if(vehicleType.equals("")){
			stmt = stmt.replace("#", "");
		}else{
			stmt=stmt.replace("#", ",VEHICLE_TYPE='"+vehicleType+"'");
		}
		if(make.equals("")){
			stmt = stmt.replace("$", "");
		}else{
			stmt=stmt.replace("$",",MAKE='"+make+"'");
		}
		pstmt=con.prepareStatement(stmt);
		pstmt.setInt(1, count);
		pstmt.setString(2, type);
		pstmt.setString(3, placementTime);
		pstmt.setString(4, id);
		int updated=pstmt.executeUpdate();
		
		if (updated > 0) {
	        pstmt=con.prepareStatement(DistributionStatments.GET_TOTAL_ASSIGNED_COUNT);
	        pstmt.setInt(1, indentMasterId);
	        ResultSet rs=pstmt.executeQuery();
	        jsonObject.put("message", "success");
			while(rs.next()){
				if(rs.getString("TYPE").equals(VEHICLE_TYPE_AD_HOC)){
					jsonObject.put("assignedAdhocCount",rs.getInt("VEHICLE_COUNT"));
				}if(rs.getString("TYPE").equals(VEHICLE_TYPE_DEDICATED)){
					jsonObject.put("assignedDedicatedCount",rs.getInt("VEHICLE_COUNT"));
				}
			}

	    }else{
	    	 jsonObject.put("message", "error");
	    }
		jsonArray.put(jsonObject);
		 }catch (Exception e) {
			 e.printStackTrace();
		 } finally {
			 DBConnection.releaseConnectionToDB(con, pstmt, null);
		 }
		return jsonArray;
	}
   	
	 public ArrayList<Object> getVehicleAllocations(int systemId, int customerId, Integer hubId, String startDate , String endDate, Integer offset,String zone,int userid) {
		    JSONArray JsonArray = new JSONArray();
		    JSONObject JsonObject = null;
		    Connection con = null;
		    PreparedStatement pstmt = null;
		    PreparedStatement pstmtForCount = null;
		    ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
			ArrayList < String > headersList = new ArrayList < String > ();
			ReportHelper finalreporthelper = new ReportHelper();
		    ArrayList < Object > finlist = new ArrayList < Object > ();
		    ResultSet rs = null;
		    ResultSet rsForCount = null;
		    String condition="";
		    try {
		        con = DBConnection.getConnectionToDB("AMS");
		        headersList.add("SL No");
		        headersList.add("Hub Name");
		        headersList.add("ID");
		        headersList.add("Vehicle Type");
		        headersList.add("Make");
		        headersList.add("Dedicated/Ad-hoc");
		        headersList.add("Select Vehicle");
		        headersList.add("Vehicle-BA");
		       // headersList.add("Actual Vehicle Type");		        
		        headersList.add("Current Reporting Time");
		        headersList.add("Actual Reporting Time");
		        headersList.add("Vehicle Allocated DateTime");		       
		        headersList.add("VEHICLE_INDENT_ID");
		        headersList.add("EDIT_ROW");
		        headersList.add("Create Trip");
		        ArrayList<String> allHubIds = new ArrayList<String>();
		        
		        if(hubId!=0){
		        	condition="HUB_ID="+hubId+" and ";
		        }else{
		        	//Get all the Hub Ids associated to the user
		        	pstmt = con.prepareStatement(DistributionStatments.GET_HUB_DETAILS.replace("LOCATION","LOCATION_ZONE_"+zone));
					pstmt.setInt(1,systemId);
					pstmt.setInt(2,customerId);
					pstmt.setInt(3, userid);
					pstmt.setInt(4,systemId);
					rs=pstmt.executeQuery();
					while(rs.next()){
						allHubIds.add(rs.getString("HUBID"));
					}
		        	condition="HUB_ID in ("+convertListToSqlINParam(allHubIds)+") and ";
		        }
		        pstmtForCount = con.prepareStatement(DistributionStatments.GET_ASSETS_REGISTERD_TO_HUB_ID.replace("#", condition));
	        	pstmtForCount.setString(1, startDate);
	        	pstmtForCount.setInt(2, systemId);
	        	pstmtForCount.setInt(3, customerId);
	            rsForCount = pstmtForCount.executeQuery();
	            
	            List<String> reportedIndentHubIds = new ArrayList<String>();
	            while(rsForCount.next()){
	            	reportedIndentHubIds.add(rsForCount.getString("HUB_ID"));
	            }
	            //Filter non reported indent hub ids
	            List<String> nonReportedIndentHubIds = new ArrayList<String>();
	            for(String allHubId : allHubIds){
	            	if(reportedIndentHubIds.contains(allHubId)){
	            		continue;
	            	}
	            	nonReportedIndentHubIds.add(allHubId);
	            }
	            if(reportedIndentHubIds.size()>0){
	            	getReportedIndents(systemId, customerId, hubId, startDate, endDate, offset, zone, userid,
	            						reportedIndentHubIds, con, JsonArray, reportsList);
	            }else{
	            	if(hubId !=0){
	            		List<String> hubIds = new ArrayList<String>();
	            		hubIds.add(hubId.toString());
	            		getNonReportedIndents(systemId, customerId, hubId, startDate, endDate, offset, zone, userid,
	            							  hubIds, con, JsonArray, reportsList);
	            	}
	            }
	            if(nonReportedIndentHubIds.size() >0){
	            	getNonReportedIndents(systemId, customerId, hubId, startDate, endDate, offset, zone, userid,
	            						  nonReportedIndentHubIds, con, JsonArray, reportsList);
	            }
	            finlist.add(JsonArray);
		        finalreporthelper.setReportsList(reportsList);
				finalreporthelper.setHeadersList(headersList);
				finlist.add(finalreporthelper);
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        DBConnection.releaseConnectionToDB(con, pstmt, rs);
		    } 
		    return finlist;
		}

	public String saveVehicleNumberAndTime(int systemId, int custId,
			JSONArray js, String hubId, String dateId,LogWriter logWriter,String sessionId) {
		logWriter.log("Start of DistributionLogisticsFunction.saveVehicleNumberAndTime method :"+sessionId +"::Trip Id:"+"::hubId:"+hubId+"::date:"+dateId,LogWriter.INFO);
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = "";
		JSONObject jsonobject = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
				jsonobject = js.getJSONObject(0);
				if(Integer.parseInt(jsonobject.getString("uniqueIdIndex")) <= 0){
					pstmt = con.prepareStatement(DistributionStatments.GET_ASSET_REPORTING_BY_DATE);
					pstmt.setString(1, dateId);
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, custId);
					pstmt.setString(4, jsonobject.getString("idIndex"));
					rs = pstmt.executeQuery();
					if(rs.next()){
						return "Already placed!!";
					}
				}
				for (int i = 0; i < js.length(); i++) {
					jsonobject = js.getJSONObject(i);
					if(Integer.parseInt(jsonobject.getString("uniqueIdIndex"))>0){

							pstmt = con.prepareStatement(DistributionStatments.UPDATE_INDENT_DETAILS);

						pstmt.setString(1, jsonobject.getString("selectVehicleIndex"));
						pstmt.setString(2, jsonobject.getString("uniqueIdIndex"));
						pstmt.setString(3, jsonobject.getString("selectVehicleIndex"));
						pstmt.executeUpdate();
					}else{
						pstmt = con.prepareStatement(DistributionStatments.INSERT_INDENT_VEHICLE_DETAILS1);
						pstmt.setString(1, jsonobject.getString("selectVehicleIndex"));
						pstmt.setString(2, dateId);
						pstmt.setString(3, jsonobject.getString("actualReportingTimeIndex"));
						pstmt.setString(4, hubId);
						pstmt.setInt(5, systemId);
						pstmt.setInt(6, custId);
						pstmt.setString(7, jsonobject.getString("idIndex"));
						pstmt.setString(8, jsonobject.getString("vehicleIndentIdIndex"));
						pstmt.executeUpdate();
					}
				}
				message = "Success";
				logWriter.log("End of DistributionLogisticsFunction.saveVehicleNumberAndTime :"+sessionId+message, LogWriter.INFO);
		} catch (Exception e) {
			logWriter.log("Error in DistributionLogisticsFunction.saveVehicleNumberAndTime :"+sessionId+e.getMessage(), LogWriter.ERROR);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}
	 
	public JSONArray getHubDetails(int cutomerId, int systemId,String zone,int UserId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		PreparedStatement pstmt1=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();			
			pstmt = con.prepareStatement(DistributionStatments.GET_HUB_DETAILS.replace("LOCATION","LOCATION_ZONE_"+zone));
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,cutomerId);
			pstmt.setInt(3, UserId);
			pstmt.setInt(4,systemId);
			rs=pstmt.executeQuery();
			jsonObject = new JSONObject();
			jsonObject.put("hubId", "0");
			jsonObject.put("hubName", "-- ALL --");
			jsonArray.put(jsonObject);
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("hubId", rs.getString("HUBID"));
				jsonObject.put("hubName", rs.getString("HUBNAME"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			System.out.println("Error in getHubDetails "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	
	}
		
	public JSONArray getAlertDetails(int cutomerId, int systemId,int userId,int offset,int HubId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		ResultSet rs1=null;
		int unplanned=0;
		int rtDeviation=0;
		int completed=0;
		int enroute=0;
		int tat=0;
		String cond="";
		if(HubId!=0)
		{
			cond="and HUB_ID="+HubId;
		}
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(DistributionStatments.GET_ALERT_DETAILS.replace("#", cond));
			
			pstmt.setInt(1,userId);
			pstmt.setInt(2,systemId);
			pstmt.setInt(3,systemId);
			pstmt.setInt(4,cutomerId);
			pstmt.setInt(5,userId);
			pstmt.setInt(6,systemId);
			pstmt.setInt(7,systemId);
			pstmt.setInt(8,cutomerId);
			pstmt.setInt(9,userId);
			pstmt.setInt(10,systemId);
			pstmt.setInt(11,systemId);
			pstmt.setInt(12,cutomerId);
			pstmt.setInt(13,userId);
			pstmt.setInt(14,systemId);
			pstmt.setInt(15,systemId);
			pstmt.setInt(16,cutomerId);
			pstmt.setInt(17,userId);
			pstmt.setInt(18,systemId);
			pstmt.setInt(19,systemId);
			pstmt.setInt(20,cutomerId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				if(rs.getString("STATUS").equals("UNPLANNED_STOPPAGE")){
					unplanned = rs.getInt("COUNT");
					}if(rs.getString("STATUS").equals("ROUTE_DEVIATION")){
						rtDeviation=rs.getInt("COUNT");
					}if(rs.getString("STATUS").equals("COMPLETED_TRIPS")){
						completed=rs.getInt("COUNT");
					}if(rs.getString("STATUS").equals("ENROUTE_TRIPS")){
						enroute= rs.getInt("COUNT");			
					}if(rs.getString("STATUS").equals("TAT")){
						tat= rs.getInt("COUNT");			
					}
				
			}
			jsonObject = new JSONObject();
			jsonObject.put("unplanedStoppage", unplanned);
			jsonObject.put("routeDeviation", rtDeviation);
			jsonObject.put("completedTrips", completed);
			jsonObject.put("enrouteTrips", enroute);
			jsonObject.put("tatTrips", tat);
			jsonArray.put(jsonObject);
		
		
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error in getalertdetails "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	
	}
	public JSONArray getTripSummaryDetailsForMLLReport(int systemId, int clientId, int offset,String unit,int userId,String startDate,String endDateJsp,String tripCustomerName) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String condition = "";
		double distance = 0;
		double expecteddistance = 0;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
		    condition = " and td.TRIP_START_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?)";
		    if(tripCustomerName.equals("All"))
		    {
		    pstmt=con.prepareStatement(DistributionStatments.GET_MLL_TABLE_DATA.replace("&", condition).replace("#", "").replace("$", ""));
		    }
		    else
		    {
			pstmt=con.prepareStatement(DistributionStatments.GET_MLL_TABLE_DATA.replace("&", "and CUSTOMER_NAME='"+tripCustomerName+"'").replace("#", condition).replace("$", ""));
		    }			    
		    pstmt.setInt(1,offset);
			pstmt.setInt(2,offset);
			pstmt.setInt(3,offset);
			pstmt.setInt(4,offset);
			pstmt.setInt(5,offset);
			pstmt.setInt(6,offset);
			pstmt.setInt(7,offset);
			pstmt.setInt(8,offset);
			pstmt.setInt(9,offset);
			pstmt.setInt(10,offset);
			pstmt.setInt(11,offset);
			pstmt.setInt(12,offset);
			pstmt.setInt(13,offset);
			pstmt.setInt(14,offset);
			pstmt.setInt(15,offset);
			pstmt.setInt(16,offset);
			pstmt.setInt(17,offset);
			pstmt.setInt(18,systemId);
			pstmt.setInt(19,clientId);
			pstmt.setInt(20,offset);
			pstmt.setString(21,startDate);
			pstmt.setInt(22,offset);
			pstmt.setString(23,endDateJsp);
			
			rs = pstmt.executeQuery();
			while (rs.next()) {
				
				count++;
				String ATD="";
				if(!rs.getString("ActualTimeOfDeparture").contains("1900")){
					ATD = sdf.format(sdfDB.parse(rs.getString("ActualTimeOfDeparture")));
				}
				String ETA="";
				if(!rs.getString("ETA").contains("1900")){
					ETA = sdf.format(sdfDB.parse(rs.getString("ETA")));
				}
				String ATA="";
				if(!rs.getString("ATA").contains("1900")){
					ATA = sdf.format(sdfDB.parse(rs.getString("ATA")));
				}
				
				jsonobject = new JSONObject();
				jsonobject.put("slNo", count);
				jsonobject.put("VEHNo", rs.getString("VEHICLE_NO"));
				jsonobject.put("Vehicletype", rs.getString("VehicleType"));
				jsonobject.put("triptype", rs.getString("TRIP_TYPE"));
				jsonobject.put("vrid", rs.getString("VR_NO"));
				jsonobject.put("shipmentid", rs.getString("ORDER_ID"));
				jsonobject.put("sealno", rs.getString("SEAL_NO"));
				jsonobject.put("noofbags", rs.getString("NO_OF_BAGS"));
				jsonobject.put("nooffluidboxes", rs.getString("NO_OF_FLUID_BAGS"));
				jsonobject.put("gpsno", rs.getString("GPSNO"));
				jsonobject.put("route", rs.getString("ROUTE_NAME"));
				if(rs.getString("OriginHubCode").equals("")){
					jsonobject.put("routetype", "NA");
				}
				else if(rs.getString("OriginHubCode").equals(rs.getString("DestinationHubCode")))
				{
					jsonobject.put("routetype", "Round Trip");
				}
				else
				{
					jsonobject.put("routetype", "One Way");
				}
				
				jsonobject.put("originhubcode", rs.getString("OriginHubCode"));	
				String schplacement="";
				if(!rs.getString("ScheduledTimeOfPlacement").contains("1900"))
				{
					schplacement=sdf.format(sdfDB.parse(rs.getString("ScheduledTimeOfPlacement")));
				}
				jsonobject.put("scheduledplacementdatetime", schplacement);
				String actualpalcement="";
				if(!rs.getString("ActualTimeOfPlacement").contains("1900"))
				{
					actualpalcement=sdf.format(sdfDB.parse(rs.getString("ActualTimeOfPlacement")));
				}
				jsonobject.put("actualplacementdatetime",actualpalcement);
				String actualreporting="";
				if(!rs.getString("actualreporting").contains("1900"))
				{
					actualreporting=sdf.format(sdfDB.parse(rs.getString("actualreporting")));
				}
				jsonobject.put("SourceOriginArrivalDateTime",actualreporting);
				String triptime="";
				if(!rs.getString("TRIPDATETIME").contains("1900"))
				{
					triptime=sdf.format(sdfDB.parse(rs.getString("TRIPDATETIME")));
				}
				jsonobject.put("TripDateTime", triptime);
				String tripendtime="";
				if(!rs.getString("TRIP_END_TIME").contains("1900"))
				{
					tripendtime=sdf.format(sdfDB.parse(rs.getString("TRIP_END_TIME")));
				}
				jsonobject.put("TripEndDateTime", tripendtime);
				jsonobject.put("OriginDispatchDepartureDateTime", ATD);
				jsonobject.put("OriginDetention", cf.convertMinutesToHHMMFormat(Math.max(0,rs.getInt("OriginDetention"))));
				jsonobject.put("openingkms", rs.getString("OPENING_KMS"));
				jsonobject.put("dp1code", rs.getString("DP1NAME"));
				String dp1arrival="";
				if(!rs.getString("DP1AAT").contains("1900"))
				{
					dp1arrival=sdf.format(sdfDB.parse(rs.getString("DP1AAT")));
				}
				jsonobject.put("dp1arrivaldatetime", dp1arrival);
				String dp1dep="";
				if(!rs.getString("DP1ADT").contains("1900"))
				{
					dp1dep=sdf.format(sdfDB.parse(rs.getString("DP1ADT")));
				}
				jsonobject.put("dp1depdatetime", dp1dep);
				jsonobject.put("dp1detention", cf.convertMinutesToHHMMFormat(Math.max(0,rs.getInt("Dp1Detention"))));					
				jsonobject.put("dp2code", rs.getString("DP2NAME"));
				String dp2arrival="";
				if(!rs.getString("DP2AAT").contains("1900"))
				{
					dp2arrival=sdf.format(sdfDB.parse(rs.getString("DP2AAT")));
				}
				jsonobject.put("DP2ArrivalDateTime", dp2arrival);
				String dp2dept="";
				if(!rs.getString("DP2ADT").contains("1900"))
				{
					dp2dept=sdf.format(sdfDB.parse(rs.getString("DP2ADT")));
				}
				jsonobject.put("DP2DepartureDateTime", dp2dept);
				jsonobject.put("dp2detention", cf.convertMinutesToHHMMFormat(Math.max(0,rs.getInt("Dp2Detention"))));
				jsonobject.put("dp3code", rs.getString("DP3NAME"));
				String dp3arrival="";
				if(!rs.getString("DP3AAT").contains("1900"))
				{
					dp3arrival=sdf.format(sdfDB.parse(rs.getString("DP3AAT")));
				}
				jsonobject.put("DP3ArrivalDateTime", dp3arrival);
				String dp3dept="";
				if(!rs.getString("DP3ADT").contains("1900"))
				{
					dp3dept=sdf.format(sdfDB.parse(rs.getString("DP3ADT")));
				}
				jsonobject.put("DP3DepartureDateTime",dp3dept);
				jsonobject.put("dp3detention", cf.convertMinutesToHHMMFormat(Math.max(0,rs.getInt("Dp3Detention"))));
				jsonobject.put("dp4code", rs.getString("DP4NAME"));
				String dp4arrival="";
				if(!rs.getString("DP4AAT").contains("1900"))
				{
					dp4arrival=sdf.format(sdfDB.parse(rs.getString("DP4AAT")));
				}
				jsonobject.put("DP4ArrivalDateTime",dp4arrival);
				String dp4dept="";
				if(!rs.getString("DP4ADT").contains("1900"))
				{
					dp4dept=sdf.format(sdfDB.parse(rs.getString("DP4ADT")));
				}
				jsonobject.put("DP4DepartureDateTime",dp4dept);
				jsonobject.put("dp4detention", cf.convertMinutesToHHMMFormat(Math.max(0,rs.getInt("Dp4Detention"))));
				jsonobject.put("destinationhubcode", rs.getString("DestinationHubCode"));
				String destarrival="";
				if(!rs.getString("DestinationArrivalTime").contains("1900"))
				{
					destarrival=sdf.format(sdfDB.parse(rs.getString("DestinationArrivalTime")));
				}
				jsonobject.put("DestinationArrivalDateTime", destarrival);
				String unloadingstart="";
				if(!rs.getString("GPS_START").contains("1900"))
				{
					unloadingstart=sdf.format(sdfDB.parse(rs.getString("GPS_START")));
				}
				jsonobject.put("unloadingstart", unloadingstart);
				String unloadingend="";
				if(!rs.getString("GPS_END").contains("1900"))
				{
					unloadingend=sdf.format(sdfDB.parse(rs.getString("GPS_END")));
				}
				jsonobject.put("unloadingend",unloadingend);
				String destdept="";
				if(!rs.getString("DestinationDeptTime").contains("1900"))
				{
					destdept=sdf.format(sdfDB.parse(rs.getString("DestinationDeptTime")));
				}
				jsonobject.put("DestinationDepartureDateTime",destdept);
				jsonobject.put("Destinationdetention", cf.convertMinutesToHHMMFormat(Math.max(0,rs.getInt("DestinationDetention"))));
				jsonobject.put("closingkms", "");
				jsonobject.put("status", rs.getString("STATUS"));
				jsonobject.put("swappedvehicleno", rs.getString("SWAPPED_VEHICLE"));
				jsonobject.put("remarks", rs.getString("REMARKS"));
				if(rs.getString("INTRANSIT_REMARKS") != null){
					jsonobject.put("intransitremarks", rs.getString("INTRANSIT_REMARKS"));
				 }
				else{
					jsonobject.put("intransitremarks", "");
				}
				int gpsTimeMin =rs.getInt("GPSTIME") ;
				String gpsstaus="";
				if(gpsTimeMin<=15)
				{
					gpsstaus="Communicating";
				}
				else
				{
					gpsstaus="Non-Communicating";
				}
				jsonobject.put("gpsstatus",gpsstaus);
				//calculation of distance 
				if(gpsstaus.equals("Communicating"))
				{
				distance = rs.getDouble("TOTAL_DISTANCE");
				if(unit.equals("kms"))
				{
					distance = rs.getDouble("TOTAL_DISTANCE");
					jsonobject.put("totdistcovered", df.format(distance));
				}
				}
				else
				{
					jsonobject.put("totdistcovered", "");
				}
				
				expecteddistance = rs.getDouble("TOTAL_EXPECTED_DISTANCE");
				if(unit.equals("kms"))
				{
					expecteddistance = rs.getDouble("TOTAL_EXPECTED_DISTANCE"); 
				}
				jsonobject.put("expecteddist", df.format(expecteddistance));
				
				
				Integer totalTripTimeATAATD = 0;
				Integer expectedtotalTripTimeATAATD=0;
				
//				if((!ATA.equals("")) &&( !ATD.equals(""))){
					 totalTripTimeATAATD = rs.getInt("TOTAL_TRIP_TIME");
//					 totalTripTimeATAATD  = totalTripTimeATAATD < 0 ? 0: totalTripTimeATAATD;
//				}
				if((!ETA.equals("")))
				{
					expectedtotalTripTimeATAATD = rs.getInt("EXPECTED_TOTAL_TRIP_TIME");
					expectedtotalTripTimeATAATD  = expectedtotalTripTimeATAATD < 0 ? 0: expectedtotalTripTimeATAATD;
				}
				
				jsonobject.put("actualtriptime", cf.convertMinutesToHHMMFormat(totalTripTimeATAATD));
				jsonobject.put("expectedtriptime", cf.convertMinutesToHHMMFormat(expectedtotalTripTimeATAATD));
				
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	
		
	public ArrayList < Object > getDashBoardGridDetails(int systemId, int customerId, int offset, String startDate,String endDate,String units,String tripStatus,int hubId,int UserId) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
		SimpleDateFormat diffddMMyyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    double totalDistance=0;
	    double remainingDistance=0;
	    double travelledDistance=0;
	    String latLng="";
	    String condition="";
	    String cond="";
	    try {
	    	int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        if(hubId!=0){
	        	condition=" and ds1.HUB_ID="+hubId;
	        }
	        if(tripStatus.equals("TAT"))
	        {
	        	tripStatus="OPEN";
	        	cond=" and dateadd(mi,isnull(PLANNED_DURATION,'0'),isnull(ACTUAL_TRIP_START_TIME,TRIP_START_TIME))<getUTCDate() ";
	        }else if(tripStatus.equals("OPEN"))
	        {
	        	tripStatus="OPEN";
	        	cond=" and dateadd(mi,isnull(PLANNED_DURATION,'0'),isnull(ACTUAL_TRIP_START_TIME,TRIP_START_TIME))>=getUTCDate() ";
	        }
	        else if(tripStatus.equals("CLOSED"))
	        {
	        	cond=" and DATEADD(DAY, DATEDIFF(DAY, 0, td.ACTUAL_TRIP_START_TIME), 0)>= DATEADD(DAY, DATEDIFF(DAY, 0,CURRENT_TIMESTAMP), 0) ";
	        }
	        pstmt = con.prepareStatement(DistributionStatments.GET_DASHBOARD_TABLE_DATA.replace("#", cond).replace("$", condition));
	        pstmt.setInt(1, offset);
	        pstmt.setInt(2, offset);
	        pstmt.setInt(3, offset);
	        pstmt.setInt(4, offset);
	        pstmt.setInt(5, offset);
	        pstmt.setInt(6, offset);
	        pstmt.setInt(7, offset);
	        pstmt.setInt(8, offset);
	        pstmt.setInt(9, offset);
	        pstmt.setInt(10, offset);
	        pstmt.setInt(11, systemId);
	        pstmt.setInt(12, customerId);
	        pstmt.setString(13, tripStatus);
	        pstmt.setInt(14, UserId);
	        pstmt.setInt(15, systemId);
	   
	        rs = pstmt.executeQuery();
			
	        while (rs.next()) {
	    
	            JsonObject = new JSONObject();
	            count++;
	            
				String tripStart="";
				if(!rs.getString("TRIP_START").contains("1900")){
					tripStart = sdf.format(rs.getTimestamp("TRIP_START"));
				}
				
				String eta="";
				if(!rs.getString("ETA").contains("1900")){
					eta = sdf.format(rs.getTimestamp("ETA"));
				}
				
				String std="";
				if(!rs.getString("STD").contains("1900")){
					std = sdf.format(rs.getTimestamp("STD"));
				}
				
				String nextTouchPtETA="";
				if(!rs.getString("ETA_TO_NEXT_TOUCH_POINT").contains("1900")){
					nextTouchPtETA = sdf.format(rs.getTimestamp("ETA_TO_NEXT_TOUCH_POINT"));
				}
				if(!rs.getString("endDate").contains("1900")){
					endDate = sdf.format(rs.getTimestamp("endDate"));
				}
				JsonObject.put("endDateHidden", endDate);
	           
	            JsonObject.put("slnoIndex", count);
	            
	            JsonObject.put("tripIdIndex",rs.getInt("TRIP_ID"));
	            
	            JsonObject.put("tripNumberIndex",rs.getString("TRIP_NO"));//shipment id
	            
	            JsonObject.put("vrNumberIndex",rs.getString("VR_NO"));
	            
	            JsonObject.put("vehicleNoIndex",rs.getString("VEHICLE_NO"));
	            		            
	            JsonObject.put("startPointIndex",rs.getString("START_POINT"));
	            
	            JsonObject.put("endPointIndex",rs.getString("END_POINT"));
	            
	            JsonObject.put("nextTouchPointIndex",rs.getString("NEXT_TOUCH_POINT"));
	            
	            JsonObject.put("etaTouchPointIndex",nextTouchPtETA); 
	            
	            JsonObject.put("currentLocationIndex",rs.getString("CURRENT_LOCATION")); 
	            
	            JsonObject.put("tripStartIndex",tripStart);
	            
	            JsonObject.put("etaIndex",eta);
	            
	            JsonObject.put("onTimeDelayedStatusIndex", rs.getString("ONTIME_DELAYED_STATUS"));
	            
	            if(units.equals("Miles")){
					totalDistance = rs.getDouble("TOTAL_DISTANCE") * 0.621371; 
					JsonObject.put("totalDistanceIndex",df.format(totalDistance));
				}else{
					totalDistance=rs.getDouble("TOTAL_DISTANCE");
					JsonObject.put("totalDistanceIndex",totalDistance);
				}
	            travelledDistance=rs.getDouble("TRAVELLED_DISTANCE");
	            
	            remainingDistance=totalDistance-travelledDistance;
	            
	            if(remainingDistance<0){
	            	remainingDistance=0;
	            }
	            if(units.equals("Miles")){
					remainingDistance = remainingDistance * 0.621371; 
					JsonObject.put("remainingDistanceIndex",df.format(remainingDistance));
				}else{
					JsonObject.put("remainingDistanceIndex",df.format(remainingDistance));
				}

	            double statusPercent=0;
	            statusPercent=((travelledDistance/totalDistance))*100;
	            if(statusPercent>100){
	            	statusPercent=100;
	            }
	            JsonObject.put("stdIndex",std);
	            
	            JsonObject.put("routeIdIndex",rs.getString("ROUTE_ID"));
	            
	            JsonObject.put("tripStatusIndex",rs.getString("STATUS"));
	            
	            JsonObject.put("statusIndex","<div class='progress'><div class='progress-bar progress-bar-success' role='progressbar' aria-valuemin='0' aria-valuemax='100' style='width:"+statusPercent+"%'></div></div>");
	            String lat=rs.getString("LAT");
	            String lng=rs.getString("LNG");
	            latLng=lat+","+lng;
	            String imageSrc="";
				imageSrc = " <div class='location-icon'><a href='#'><img src='/ApplicationImages/VehicleImagesNew/globe.jpg'/></a></div> ";
				//imageSrc = " <div class='location-icon'><a href=\'#\'><img src='/ApplicationImages/VehicleImagesNew/globe.jpg'/></a></div> ";
				//<a href=\"#\"
				JsonObject.put("viewMapIndex", imageSrc);
				
				JsonObject.put("endDateIndex", endDate);
				
				JsonObject.put("latLngIndex",latLng);
				if("CLOSED".equals(rs.getString("STATUS"))){
					JsonObject.put("tripRemarksIndex","<button id='remarksBtnId' class='btn btn-info btn-sm text-center'>View Remarks</button>");
				}else{
					JsonObject.put("tripRemarksIndex", "<button id='remarksBtnId' class='btn btn-info btn-sm text-center'>Add Remarks</button>");
				}
				String s=rs.getString("ACTUALARRIVALTIME_DEST");
				if(!rs.getString("ACTUALARRIVALTIME_DEST").contains("1900") && rs.getString("ACTUALARRIVALTIME_DEST")!="" )
				{
				JsonObject.put("actualarrdestindex", rs.getString("ACTUALARRIVALTIME_DEST"));
				}
				else
				{
					JsonObject.put("actualarrdestindex", "");	
				}
				if(!rs.getString("ACTUALARRIVALTIME_DEST").contains("1900") && rs.getString("ACTUALARRIVALTIME_DEST")!="" && rs.getString("STATUS").equalsIgnoreCase("OPEN"))
				{
					
					if(rs.getString("GPS_START").contains("1900"))
					{
					JsonObject.put("unloadingIndex","<button id='unloadingBtnId' data-target='#unloadingbutton' class='btn btn-info btn-sm text-center style='background-color:#158e1a; border-color:#158e1a; width:30px'>Unloading Start</button>");
					JsonObject.put("alertnameIndex","Unload_Start");
					}
					else if(!rs.getString("GPS_START").contains("1900") && rs.getString("GPS_END").contains("1900"))
					{					
					JsonObject.put("unloadingIndex","<button id='unloadingBtnId' data-target='#unloadingbutton' class='btn btn-info btn-sm text-center style='background-color: #f44336; border-color:#158e1a;'>Unloading End</button>");
					JsonObject.put("alertnameIndex","Unload_End");
					}
					else
					{
						JsonObject.put("unloadingIndex","<button id='unloadingBtnId' data-target='#unloadingbutton' class='btn btn-warning'disabled style='background-color:#da2618; border-color:#da2618;'>Completed</button>");
						JsonObject.put("alertnameIndex","completed");		
					}
				}				
				else
				{
			    JsonObject.put("unloadingIndex","");
			    JsonObject.put("alertnameIndex","completed");			  
//				JsonObject.put("unloadingIndex","<button id='unloadingBtnId' data-target='#unloadingbutton' class='btn btn-info disabled btn-sm text-center style='background-color: #f44336; border-color:#158e1a;'>Unloading End</button>");	

				}
				JsonArray.put(JsonObject);
	        }
	        
	        finlist.add(JsonArray);
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return finlist;
	}
		
public JSONArray getVehiclePlacementChartData(int systemId,int CustomerId,int offset,String startDate,String endDate, int hubId,int UserId) {
			
			PreparedStatement pstmt=null;
			ResultSet rs=null;
			Connection con=null;
			JSONArray jsonArray=new JSONArray();
			JSONObject jsonObject=new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");
			int placedCount=0;
			int notPlacedCount=0;
			int totalCount=0;
			String cond1="";
			String cond2="";
			try {
				if(hubId!=0){
					cond1="and NODE_ID="+hubId;
					cond2="and HUB_ID="+hubId;
				}
				pstmt=con.prepareStatement(DistributionStatments.GET_VEHICLE_PLACEMENT_DETAILS.replace("#",cond1).replace("$", cond2));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, CustomerId);
				pstmt.setInt(3, UserId);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, CustomerId);
				pstmt.setInt(7, UserId);
				pstmt.setInt(8, systemId);
				pstmt.setString(9, startDate);
				
				rs = pstmt.executeQuery();
				while(rs.next())
				 {
					if(rs.getString("STATUS").equals("TOTAL")){
						totalCount = rs.getInt("COUNT");
					}
					if(rs.getString("STATUS").equals("PLACED")){
						placedCount=rs.getInt("COUNT");
					}
				 }
					notPlacedCount=totalCount-placedCount;
					jsonObject=new JSONObject();
					jsonObject.put("placed", placedCount);
					jsonObject.put("yetToBePlaced", notPlacedCount);
					jsonArray.put(jsonObject);
			} 
			catch (Exception e) {
				e.printStackTrace();
			}finally{
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			return jsonArray;
		}
	

public JSONArray getOnTimePlacement(int systemId, int CustomerId,
		int hubId, String startDate, String endDate, int offset,int UserId) {

	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs1 = null;
	Connection con = null;
	JSONArray JsonArray = new JSONArray();
	JSONObject JsonObject = new JSONObject();
	con = DBConnection.getConnectionToDB("AMS");
	SimpleDateFormat timef = new SimpleDateFormat("HH:mm");
	CommonFunctions cf = new CommonFunctions();
	int onTime = 0;
	int delayed = 0;
	int yetToReach=0;
	String condition = "";
	String reportingtime = "";
	String actualReportingtime = "";
	if (hubId != 0) {
		condition = "and HUB_ID=" + hubId;
	}
	try {
		pstmt = con.prepareStatement(DistributionStatments.GET_ON_TIME_PLACEMENT_COUNTS.replace("#", condition));
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, CustomerId);
		pstmt.setInt(3, UserId);
		pstmt.setInt(4, systemId);
		pstmt.setString(5, startDate);		
		pstmt.setInt(6, systemId);
		pstmt.setInt(7, CustomerId);
		pstmt.setInt(8, UserId);
		pstmt.setInt(9, systemId);
		pstmt.setString(10, startDate);
		pstmt.setInt(11, systemId);
		pstmt.setInt(12, CustomerId);
		pstmt.setInt(13, UserId);
		pstmt.setInt(14, systemId);
		pstmt.setString(15, startDate);
		rs = pstmt.executeQuery();
		while (rs.next()) {
			JsonObject = new JSONObject();
			if(rs.getString("STATUS").equalsIgnoreCase("YET_TO_REACH")){
				yetToReach=rs.getInt("count");
			}
			else if(rs.getString("STATUS").equalsIgnoreCase("DELAYED")){
				delayed=rs.getInt("count");
			}
			else if(rs.getString("STATUS").equalsIgnoreCase("ONTIME")){
				onTime=rs.getInt("count");
			}
		}
		JsonObject.put("onTime", onTime);
		JsonObject.put("delayed", delayed);
		JsonObject.put("yetToReach", yetToReach);
		JsonArray.put(JsonObject);

	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return JsonArray;
}	
		public ArrayList < Object > getAlertTableDetails(int systemId, int customerId, int offset, int alertId,int userId,int HubId){
			PreparedStatement pstmt=null;
			ResultSet rs=null;
			Connection con=null;
			JSONArray JsonArray=new JSONArray();
			JSONObject JsonObject=new JSONObject();
			DecimalFormat df = new DecimalFormat("##0.00");
			con = DBConnection.getConnectionToDB("AMS");
			SimpleDateFormat timef = new SimpleDateFormat("HH:mm");
			SimpleDateFormat diffddMMyyyy = new SimpleDateFormat("dd-MM-yyyy");
		    ArrayList < Object > finlist = new ArrayList < Object > ();
		    int count=0;
		    String condition="";
		    if (HubId != 0) {
				condition = "and HUB_ID=" + HubId;
			}
			try {
				pstmt = con.prepareStatement(DistributionStatments.GET_ALERT_TABLE_DETAILS.replace("#",condition));
				pstmt.setInt(1,offset);
				pstmt.setInt(2,userId);
				pstmt.setInt(3,systemId);
				pstmt.setInt(4,systemId);
				pstmt.setInt(5,customerId);
				pstmt.setInt(6,alertId);				
				rs = pstmt.executeQuery();
				while (rs.next()) {
					count++;
				 JsonObject = new JSONObject();
				 JsonObject.put("slnoIndex",count);
				 JsonObject.put("idIndex",rs.getString("ID"));				 
				 JsonObject.put("vehicleNoIndex",rs.getString("VEHICLE_NO"));
				 JsonObject.put("locationIndex",rs.getString("LOCATION"));
				 JsonObject.put("dateTimeIndex",sdf.format(rs.getTimestamp("GMT")));
				 JsonObject.put("remarksIndex",rs.getString("REMARKS"));
				 JsonArray.put(JsonObject);
	        }
	        finlist.add(JsonArray);
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return finlist;
		}
		
		public ArrayList < Object > getVehiclePlacementTableDetails(int systemId, int customerId, int offset, String selectionType,int userId,int HubId,String date){
			PreparedStatement pstmt=null;
			PreparedStatement pstmt1=null;
			ResultSet rs=null;
			ResultSet rs1=null;
			Connection con=null;
			JSONArray JsonArray=new JSONArray();
			JSONObject JsonObject=new JSONObject();
			DecimalFormat df = new DecimalFormat("##0.00");
			con = DBConnection.getConnectionToDB("AMS");
			SimpleDateFormat timef = new SimpleDateFormat("HH:mm");
			SimpleDateFormat diffddMMyyyy = new SimpleDateFormat("dd-MM-yyyy");
		    ArrayList < Object > finlist = new ArrayList < Object > ();
		    int count=0;
		    String condition="";
		    String condition1="";
		    String condition2="";
		    if (HubId != 0) {
				condition = "and HUB_ID=" + HubId;
				condition1 = "and b.HUB_ID=" + HubId;
				condition2 = "NODE_ID="+ HubId+"and";
			}
			try {
				if(selectionType.equalsIgnoreCase("Yet to be Placed"))
				{
					pstmt1 = con.prepareStatement(DistributionStatments.GET_VEHICLE_PLACEMENT_TABLE_DETAILS_YET_TO_PLACE.replace("#",condition1).replace("$", condition2));
					pstmt1.setInt(1,userId);
					pstmt1.setInt(2,systemId);
					pstmt1.setInt(3,systemId);
					pstmt1.setInt(4,customerId);
					pstmt1.setString(5,date);
					pstmt1.setString(6,date);
					pstmt1.setInt(7,systemId);
					pstmt1.setInt(8,userId);
					pstmt1.setInt(9,systemId);
					pstmt1.setInt(10,systemId);
					pstmt1.setInt(11,customerId);
					pstmt1.setString(12,date);
					pstmt1.setString(13,date);
					rs1 = pstmt1.executeQuery();
					while (rs1.next()) {
		 		           int noOfVehicles = Integer.parseInt(rs1.getString("COUNT"));
		 		            for (int i=0; i<noOfVehicles;i++){
		 		            	count++;
		 						 JsonObject = new JSONObject();		 						 
		 						 String curr="";
		 							if(!rs1.getString("currentreporttime").contains("1900")){
		 								curr = sdf.format(rs1.getTimestamp("currentreporttime"));
		 							}
		 						 JsonObject.put("slnoIndex",count);
		 						 JsonObject.put("hubNameIndex",rs1.getString("NAME"));
		 						 JsonObject.put("vehicleTypeIndex","");
		 						 JsonObject.put("vehicleMakeIndex","");	
		 						 JsonObject.put("vehicleNumberIndex",rs1.getString("ASSET_NO"));
		 						 JsonObject.put("currentReportingTimeIndex",curr);
		 						 JsonObject.put("actualReportingIndex","");
		 						 JsonObject.put("vehicleAssignedTimeIndex","");
		 						 JsonArray.put(JsonObject);	
		 						 }
					}
								}
				else
				{
				pstmt = con.prepareStatement(DistributionStatments.GET_VEHICLE_PLACEMENT_TABLE_DETAILS.replace("#",condition));
				pstmt.setInt(1,systemId);
				pstmt.setInt(2,customerId);
				pstmt.setInt(3,userId);
				pstmt.setInt(4,systemId);
				pstmt.setString(5,date);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					count++;
				 JsonObject = new JSONObject();
				 
				 String curr="";
					if(!rs.getString("currentreporttime").contains("1900")){
						curr = sdf.format(rs.getTimestamp("currentreporttime"));
					}
					String actual="";
					if(!rs.getString("ACTUAL_REP_TIME").contains("1900")){
						actual = sdf.format(rs.getTimestamp("ACTUAL_REP_TIME"));
					}
					String vehAssigned="";
					if(!rs.getString("vehicleassigned").contains("1900")){
						vehAssigned = sdf.format(rs.getTimestamp("vehicleassigned"));
					}
				 JsonObject.put("slnoIndex",count);
				 JsonObject.put("hubNameIndex",rs.getString("NAME"));
				 JsonObject.put("vehicleTypeIndex",rs.getString("VEHICLE_TYPE"));
				 JsonObject.put("vehicleMakeIndex",rs.getString("VEHICLE_MAKE"));
				 JsonObject.put("vehicleNumberIndex",rs.getString("ASSET_NO"));
				 JsonObject.put("currentReportingTimeIndex",curr);
				 JsonObject.put("actualReportingIndex",actual);
				 JsonObject.put("vehicleAssignedTimeIndex",vehAssigned);
				 JsonArray.put(JsonObject);
				}
	        }
	        finlist.add(JsonArray);
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return finlist;
		}
		
		public ArrayList < Object > getOnTimePlacementTableDetails(int systemId, int customerId, int offset, String selectionType,int userId,int HubId,String date){
			PreparedStatement pstmt=null;
			ResultSet rs=null;
			Connection con=null;
			JSONArray JsonArray=new JSONArray();
			JSONObject JsonObject=new JSONObject();
			DecimalFormat df = new DecimalFormat("##0.00");
			con = DBConnection.getConnectionToDB("AMS");
			SimpleDateFormat timef = new SimpleDateFormat("HH:mm");
			SimpleDateFormat diffddMMyyyy = new SimpleDateFormat("dd-MM-yyyy");
		    ArrayList < Object > finlist = new ArrayList < Object > ();
		    int count=0;
		    String condition="";
		    if (HubId != 0) {
				condition = "and a.HUB_ID=" + HubId;
			}
			try {
				if(selectionType.equalsIgnoreCase("ON-TIME")){
					pstmt = con.prepareStatement(DistributionStatments.GET_ONTIME_PLACEMENT_TABLE_DETAILS_ON_TIME.replace("#",condition));
					pstmt.setInt(1,systemId);
					pstmt.setInt(2,customerId);
					pstmt.setInt(3,userId);
					pstmt.setInt(4,systemId);
					pstmt.setString(5,date);
					rs = pstmt.executeQuery();
				}else if (selectionType.equalsIgnoreCase("DELAYED")){
					pstmt = con.prepareStatement(DistributionStatments.GET_ONTIME_PLACEMENT_TABLE_DETAILS_DELAYED.replace("#",condition));
					pstmt.setInt(1,systemId);
					pstmt.setInt(2,customerId);
					pstmt.setInt(3,userId);
					pstmt.setInt(4,systemId);
					pstmt.setString(5,date);
					rs = pstmt.executeQuery();
				}else if (selectionType.equalsIgnoreCase("NOT REACHED")){
					pstmt = con.prepareStatement(DistributionStatments.GET_ONTIME_PLACEMENT_TABLE_DETAILS_NOT_REACHED.replace("#",condition));
					pstmt.setInt(1,systemId);
					pstmt.setInt(2,customerId);
					pstmt.setInt(3,userId);
					pstmt.setInt(4,systemId);
					pstmt.setString(5,date);
					rs = pstmt.executeQuery();
				}
				while (rs.next()) {
					count++;
				 JsonObject = new JSONObject();
				 
				 String curr="";
					if(!rs.getString("currentreporttime").contains("1900")){
						curr = sdf.format(rs.getTimestamp("currentreporttime"));
					}
					String actual="";
					if(!rs.getString("ACTUAL_REP_TIME").contains("1900")){
						actual = sdf.format(rs.getTimestamp("ACTUAL_REP_TIME"));
					}
					String vehAssigned="";
					if(!rs.getString("vehicleassigned").contains("1900")){
						vehAssigned = sdf.format(rs.getTimestamp("vehicleassigned"));
					}
				 JsonObject.put("slnoIndex",count);
				 JsonObject.put("hubNameIndex",rs.getString("NAME"));
				 JsonObject.put("vehicleTypeIndex",rs.getString("VEHICLE_TYPE"));
				 JsonObject.put("vehicleMakeIndex",rs.getString("VEHICLE_MAKE"));
				 JsonObject.put("vehicleNumberIndex",rs.getString("ASSET_NO"));
				 JsonObject.put("currentReportingTimeIndex",curr);
				 JsonObject.put("actualReportingIndex",actual);
				 JsonObject.put("vehicleAssignedTimeIndex",vehAssigned);
				 JsonArray.put(JsonObject);
	        }
	        finlist.add(JsonArray);
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return finlist;
		}
		
		public JSONArray getIndentByHubId(int systemId,String custId,String mllCust,String hubId){
		    Connection conAdmin = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    JSONArray jsonArray = new JSONArray();
		    JSONObject jsonObject = new JSONObject();
		    try {
		        conAdmin = DBConnection.getConnectionToDB("AMS");
		        pstmt = conAdmin.prepareStatement(DistributionStatments.GET_INDENT_FOR_HUB);
		        pstmt.setInt(1, systemId);
		        pstmt.setInt(2, Integer.parseInt(custId));
		        pstmt.setInt(3, Integer.parseInt(mllCust));
		        pstmt.setInt(4, Integer.parseInt(hubId));
		        
		        rs = pstmt.executeQuery();
		        while (rs.next()) {
		            jsonObject = new JSONObject();
		            jsonObject.put("id", rs.getString("ID"));
		            jsonArray.put(jsonObject);
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		    }
		    return jsonArray;
			
		}
		public JSONArray getIndentById(int indentId){
		    Connection conAdmin = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    JSONArray jsonArray = new JSONArray();
		    JSONObject jsonObject = new JSONObject();
		    try {
		        conAdmin = DBConnection.getConnectionToDB("AMS");
		        pstmt = conAdmin.prepareStatement(DistributionStatments.GET_INDENT_BY_ID);
		        pstmt.setInt(1, indentId);
		        
		        rs = pstmt.executeQuery();
		        while (rs.next()) {
		            jsonObject = new JSONObject();
		            jsonObject.put("id", rs.getString("ID"));
		            jsonObject.put("nodeIdIndex", rs.getString("HUBID"));
		            jsonObject.put("nodeIndex", rs.getString("NODE"));
		            jsonObject.put("regionIndex", rs.getString("REGION"));
		            jsonObject.put("dedicatedIndex", rs.getString("DEDICATED_COUNT"));
		            jsonObject.put("adhocIndex", rs.getString("ADHOC_COUNT"));
		            jsonObject.put("supervisorName", rs.getString("SUPERVISOR_NAME"));
		            jsonObject.put("supervisorContact", rs.getString("SUPERVISOR_CONTACT"));
		            jsonArray.put(jsonObject);
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		    }
		    return jsonArray;
			
		}
		
		public String insertunloadingdetails(int systemId,int userID,int TripId,int offset,int clientId,String date,String vehicleNo,int alertType,String alertName,String location,String destination){
			Connection con=null;
			PreparedStatement pstmt=null;
			PreparedStatement pstmt1=null;
			PreparedStatement pstmt2=null;
			ResultSet rs = null;
			String message="";
			int updated=0;
			int updated1=0;
			Date d1 = null;
			try {
				d1=sdf3.parse(destination);
			} catch (Exception e1) {
				
				e1.printStackTrace();
			}
			String d2=sdf3.format(d1);
			try {
			con = DBConnection.getConnectionToDB("AMS");			
			if(alertName.equalsIgnoreCase("Unload_Start"))
			{
				if(sdf3.parse(date).before(sdf3.parse(d2)))
				{
					message = "Please Enter Correct Date";		
				}
				else
				{
				pstmt2 = con.prepareStatement(DistributionStatments.INSERT_UNLOADINGSTART_DETAILS);
				pstmt2.setInt(1,offset);
				pstmt2.setString(2,date);
				pstmt2.setInt(3, TripId);
				pstmt2.setString(4, vehicleNo);
				pstmt2.setInt(5, alertType);
		        pstmt2.setString(6, location);
		        pstmt2.setString(7, alertName);
		        pstmt2.setInt(8, userID);
				pstmt2.setInt(9, systemId);
				pstmt2.setInt(10, clientId);
				pstmt2.setString(11, date);
				updated = pstmt2.executeUpdate();
				if (updated > 0) {
			        message = "Unloading-start date saved successfully";
			    }
			}
			}
			else if(alertName.equalsIgnoreCase("Unload_End"))
			{
				pstmt1 = con.prepareStatement("select isnull(GPS_DATETIME,'')as start,case when isnull(GPS_DATETIME,'')>? THEN 'INCORRECT_TIME' else 'CORRECT_TIME' END AS TIME_VALIDATION from TRIP_EVENT_DETAILS where TRIP_ID=? and ALERT_TYPE=? and ALERT_NAME='Unload_Start'");
				pstmt1.setString(1,date);
				pstmt1.setInt(2, TripId);
				pstmt1.setInt(3, alertType);
				rs = pstmt1.executeQuery();
				if(rs.next())
				{
				if(rs.getString("TIME_VALIDATION").equals("INCORRECT_TIME"))
				{
					message = "Please Enter Correct Date";	
				}
				else
				{
				pstmt2 = con.prepareStatement(DistributionStatments.INSERT_UNLOADINGEND_DETAILS);
				pstmt2.setInt(1,offset);
				pstmt2.setString(2,date);
				pstmt2.setInt(3, TripId);
				pstmt2.setString(4, vehicleNo);
				pstmt2.setInt(5, alertType);
		        pstmt2.setString(6, location);
		        pstmt2.setString(7, alertName);
		        pstmt2.setInt(8, userID);
				pstmt2.setInt(9, systemId);
				pstmt2.setInt(10, clientId);
				pstmt2.setString(11, date);
				updated1 = pstmt2.executeUpdate();
				if (updated1 > 0) {
			        message = "Unloading-end date saved successfully";
			    }
				}
				}				
			}
			else{
		    	 message = "Error While Unloading";
			}
			 }catch (Exception e) {
				 e.printStackTrace();
			 } finally {
				 DBConnection.releaseConnectionToDB(null, pstmt1, null);
				 DBConnection.releaseConnectionToDB(null, pstmt2, null);
			 }
			return message;
		}
		
		public String insertTripRemarks(int tripId, String vehicleNo,int alertType,String location,String alertName, String remarks, int hubId, int systemId,int customerId){
			Connection conAdmin = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    String message="";
		    try {
		        conAdmin = DBConnection.getConnectionToDB("AMS");
		        pstmt = conAdmin.prepareStatement(DistributionStatments.INSERT_TRIP_REMARKS);
		        pstmt.setInt(1, tripId);
		        pstmt.setString(2, vehicleNo);
		        pstmt.setInt(3, alertType);
		        pstmt.setString(4, location);
		        pstmt.setString(5, alertName);
		        pstmt.setString(6, remarks);
		        pstmt.setInt(7, hubId);
		        pstmt.setInt(8, systemId);
		        pstmt.setInt(9, customerId);
		        
		        int inserted = pstmt.executeUpdate();
				if (inserted > 0) {
	               message = "Remarks saved successfully";
	          }
		    } catch (Exception e) {
		    	message = "Error saving"+e.toString();
		        e.printStackTrace();
		    } finally {
		        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		    }
		    return message;
		}
		
		public String getTripRemarksByTripId(int tripId){
			Connection conAdmin = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    StringBuffer sb =new StringBuffer();
		    try {
		        conAdmin = DBConnection.getConnectionToDB("AMS");
		        pstmt = conAdmin.prepareStatement(DistributionStatments.GET_TRIP_REMARKS_BY_TRIP_ID);
		        pstmt.setInt(1, tripId);
		        rs = pstmt.executeQuery();
		        int slNo =1;
				while(rs.next()){
					if(!rs.getString("DESCRIPTION").equals("")){
						sb.append(slNo + ". " +rs.getString("DESCRIPTION"));
						sb.append("<br>");
					}
					slNo++;
	            }
				
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		    }
		    return sb.toString();
		}
		
	public Map<String, IndentVehiclesCount> getIndentVehiclesCount(Set<String> nodes, int systemId,int clientId,String customerName){
			
			Connection conAdmin = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    IndentVehiclesCount vehicleCount = null;
		    Map<String, IndentVehiclesCount> nodeToVehicleCount = new HashMap<String, IndentVehiclesCount>();
		    if(nodes.isEmpty()){
				return nodeToVehicleCount;
			}
		    try {
		        conAdmin = DBConnection.getConnectionToDB("AMS");
		        pstmt = conAdmin.prepareStatement(DistributionStatments.GET_INDENT_VEHICLE_COUNT_BY_HUBNAMES.replace("#", sqlParams(nodes.size())));
		        pstmt.setInt(1, systemId);
		        pstmt.setInt(2, clientId);
		        pstmt.setString(3, customerName);
		        int paramIndex =4;
		        for(String node : nodes){
		        	pstmt.setString(paramIndex, node);
		        	paramIndex++;
		        }
		        rs = pstmt.executeQuery();
				while(rs.next()){
					vehicleCount = new IndentVehiclesCount();
					vehicleCount.setIndentId(Integer.parseInt(rs.getString("INDENT_ID")));
					vehicleCount.setNode(rs.getString("NODE"));
					vehicleCount.setTotalDedicated(Integer.parseInt(rs.getString("DEDICATED_COUNT")));
					vehicleCount.setTotalAdhoc(Integer.parseInt(rs.getString("ADHOC_COUNT")));
					vehicleCount.setTotalAssignedDedicated(Integer.parseInt(rs.getString("ASSIGNED_DEDICATED")));
					vehicleCount.setTotalAssignedAdhoc(Integer.parseInt(rs.getString("ASSIGNED_ADHOC")));
					nodeToVehicleCount.put(rs.getString("NODE"), vehicleCount);
	            }
				
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		    }
		    return nodeToVehicleCount;
		}
		
	public Map<String,Integer> getIndentListByHubNames(List<String> nodes, int systemId,int clientId,String customerName){
			Connection conAdmin = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    HashMap<String,Integer> hubToIndentIdMap = new HashMap<String, Integer>();
		    try {
		        conAdmin = DBConnection.getConnectionToDB("AMS");
		        pstmt = conAdmin.prepareStatement(DistributionStatments.GET_INDENTS_BY_HUBNAMES.replace("#", sqlParams(nodes.size())));
		        pstmt.setInt(1, systemId);
		        pstmt.setInt(2, clientId);
		        pstmt.setString(3, customerName);
		        
		        int paramIndex =4;
		        for(String node : nodes){
		        	pstmt.setString(paramIndex, node);
		        	paramIndex++;
		        }
		        
		        rs = pstmt.executeQuery();
				while(rs.next()){
					hubToIndentIdMap.put(rs.getString("NODE"), rs.getInt("INDENT_ID"));
					
	            }
				
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		    }
		    return hubToIndentIdMap;
		}
		
	public int importIndentMasterMasterDetails(List<IndentMasterData> indentList,int systemId,int custId, String custName,int userId){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs=null;
		int successRecords=0;
		try {
				con = DBConnection.getConnectionToDB("AMS");
				for(IndentMasterData indentData : indentList){
				if(indentData.isValid()){
					int totalCount=Integer.parseInt(indentData.getDedicated())+Integer.parseInt(indentData.getAdhoc());
					
				    	pstmt = con.prepareStatement(DistributionStatments.INSERT_INDENT_DETAILS);
				     	pstmt.setInt(1, indentData.getNodeId());
				     	pstmt.setString(2, indentData.getRegion());
				     	pstmt.setInt(3, Integer.parseInt(indentData.getDedicated()));
				     	pstmt.setInt(4, Integer.parseInt(indentData.getAdhoc()));
				     	pstmt.setInt(5, totalCount);
				     	pstmt.setString(6, indentData.getSupervisorName());
				     	pstmt.setString(7, indentData.getSupervisorContact());
				     	pstmt.setInt(8, systemId);
						pstmt.setInt(9, custId);
						pstmt.setInt(10, userId);
						pstmt.setString(11, custName);
						int inserted = pstmt.executeUpdate();
						if (inserted > 0) {
							successRecords++;
							//System.out.println("Saved Imported Node "+indentData.getNode());
						}else{
							System.out.println("Failed to save the Indent for node"+indentData.getNode());
						}
				}
			   }
		}catch (Exception e) {
				e.printStackTrace();
		} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return successRecords;
	}
	
	public int importIndentVehicleDetails(List<IndentVehicleDetailsData> indentList,int systemId,int custId, String custName,int userId){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs=null;
		int successRecords=0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			for(IndentVehicleDetailsData indentData : indentList){
			if(indentData.isValid()){
			    	pstmt = con.prepareStatement(DistributionStatments.INSERT_INDENT_VEHICLE_DETAILS);
			     	pstmt.setInt(1, indentData.getIndentId());
			     	pstmt.setString(2, indentData.getVehicleType());
			     	pstmt.setString(3, indentData.getMake());
			     	pstmt.setInt(4, Integer.parseInt(indentData.getNoOfVehicles()));
			     	pstmt.setString(5, indentData.getDedicatedOrAdhoc());
			     	pstmt.setString(6, indentData.getPlacementTime());
					int inserted = pstmt.executeUpdate();
					if (inserted > 0) {
						successRecords++;
						//System.out.println("Success fully added Vehicle data for Node--"+indentData.getNode()+"No of vehicles::"+indentData.getNoOfVehicles()+" ::"+indentData.getDedicatedOrAdhoc());
					}else{
						System.out.println("Failed to save the Indent for node"+indentData.getIndentId());
					}
				} 
			}
		}catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return successRecords;
	}
	
	private String sqlParams(int numParams) {
	    StringBuilder sb = new StringBuilder();
	    if(numParams <= 0) return sb.toString();
	    for(int ctr = 0; ctr < numParams - 1; ++ctr) {
	        sb.append("?,");
	    }
	    sb.append("?");
	    return sb.toString();
	}
	
	private String convertListToSqlINParam(List<String> list){
		StringBuffer sb = new StringBuffer();
		String str= new String();
		for(String id : list){
			sb.append(id);
			sb.append(",");
		}
		if(sb.lastIndexOf(",") >0){
			str = sb.substring(0, sb.lastIndexOf(","));
		}
		return str;
	}
	
	
	private void getReportedIndents(int systemId, int customerId, Integer hubId, 
									 String startDate , String endDate, Integer offset,String zone,int userid,
									 List<String> reportedIndentHubIds,Connection con,JSONArray jsonArray,ArrayList < ReportHelper > reporstList) throws SQLException, JSONException{
		SimpleDateFormat sdfDDmmyyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        String condition="b.HUB_ID in ("+convertListToSqlINParam(reportedIndentHubIds)+") and ";
    	PreparedStatement pstmt = con.prepareStatement(DistributionStatments.GET_REPORTED_VEHICLES.replace("#", condition).replace("LOCATION","LOCATION_ZONE_"+zone));
    	pstmt.setInt(1, offset);
    	pstmt.setInt(2, offset);
    	pstmt.setInt(3, systemId);
	        pstmt.setInt(4, customerId);
    	    pstmt.setInt(5, systemId);
	        pstmt.setInt(6, customerId);
	        pstmt.setString(7, startDate);
	       ResultSet rs = pstmt.executeQuery();
	       JSONObject JsonObject;
	       int count = jsonArray.length();
	       while(rs.next()){
	        ArrayList<Object> informationList = new ArrayList<Object> ();
	        ReportHelper reporthelper = new ReportHelper();
	          	count++;
	          	
        	JsonObject = new JSONObject();
            JsonObject.put("slnoIndex", count);
            informationList.add(count);
            JsonObject.put("hubnameIndex",rs.getString("NAME"));
            informationList.add(rs.getString("NAME"));
            JsonObject.put("uniqueIdIndex", rs.getString("UNIQUE_ID"));			           
            JsonObject.put("idIndex",rs.getString("ID"));
            informationList.add(rs.getString("ID"));
            JsonObject.put("vehicleTypeIndex", rs.getString("VEHICLE_TYPE"));
            informationList.add(rs.getString("VEHICLE_TYPE"));
            JsonObject.put("makeIndex",rs.getString("MAKE"));
            informationList.add(rs.getString("MAKE"));
            JsonObject.put("dedicatedAdhocIndex",rs.getString("TYPE"));
            informationList.add(rs.getString("TYPE"));
            JsonObject.put("selectVehicleIndex",rs.getString("VEHICLE_NO"));
            informationList.add(rs.getString("VEHICLE_NO"));
            JsonObject.put("vehiclegroup",rs.getString("GROUP_NAME"));
            informationList.add(rs.getString("GROUP_NAME"));
            //JsonObject.put("vehicleType",rs.getString("VehicleType"));
            //informationList.add(rs.getString("VehicleType"));			            
            JsonObject.put("actualReportingTimeIndex",rs.getString("ACTUAL_DETENTION"));
            informationList.add(rs.getString("ACTUAL_DETENTION"));
            if(rs.getString("ACTUAL_REPORT_DATETIME").contains("1900")){
	            	JsonObject.put("actualReportingDateTimeIndex","");
	            	informationList.add("");
	            }else{
	            	JsonObject.put("actualReportingDateTimeIndex",sdfDDmmyyyy.format(rs.getTimestamp("ACTUAL_REPORT_DATETIME")));
	            	String s=sdfDDmmyyyy.format(rs.getTimestamp("ACTUAL_REPORT_DATETIME"));
	            	informationList.add(s);
	            }
            
            String inserteddate="";			      
            if(!rs.getString("Actualvehicleallocated").contains("1900")&& !rs.getString("VEHICLE_NO").equals("")){
            	inserteddate=sdfDDmmyyyy.format(rs.getTimestamp("Actualvehicleallocated"));
	            }else{
	            	inserteddate="";	
	            }
            JsonObject.put("insertedDateTimeIndex",inserteddate);
            informationList.add(inserteddate);
            JsonObject.put("vehicleIndentIdIndex",rs.getString("vehicleIndentId"));	
            informationList.add(rs.getString("vehicleIndentId"));
            if(rs.getString("VEHICLE_NO").equals("")){
            	
            	JsonObject.put("editRowIndex",true);
            	informationList.add("true");
            	JsonObject.put("createTripIndex","");//<a href='#div1' id='createTriphlinkId' style='display:none;' onclick='tripCreation()'>Create Trip</a>");			            	
            	informationList.add("");
            }else if(rs.getString("STATUS") != null && rs.getString("STATUS").equals("OPEN")){			            	
            	JsonObject.put("createTripIndex","");
            	informationList.add("");
            }
            else{			            	
            	JsonObject.put("editRowIndex",false);
            	informationList.add("false");
            	JsonObject.put("createTripIndex","<a href='#div1' id='createTriphlinkId' onclick='tripCreation()'>Create Trip</a>");
            	informationList.add("Create Trip");
            }
            
            JsonObject.put("countIndex",rs.getInt("Counttt"));
            JsonObject.put("dateindex",rs.getString("RequiredDate"));			            
            JsonObject.put("currentdateindex",rs.getString("currentdate"));				            
	        ///informationList.add(rs.getString("currentdate"));
            jsonArray.put(JsonObject);
           reporthelper.setInformationList(informationList);
           reporstList.add(reporthelper);
	       }
    
	}
	
	private void getNonReportedIndents(int systemId, int customerId, Integer hubId, 
			 							String startDate , String endDate, Integer offset,String zone,int userid,
			 							List<String> nonReportedIndentHubIds,Connection con,JSONArray jsonArray,ArrayList<ReportHelper > reportsList) throws SQLException, JSONException{

       	String condition="b.NODE_ID in ("+convertListToSqlINParam(nonReportedIndentHubIds)+") and ";
    	PreparedStatement pstmt = con.prepareStatement(DistributionStatments.GET_VEHICLE_ALLOCATION.replace("#", condition).replace("LOCATION","LOCATION_ZONE_"+zone));
    	pstmt.setString(1, startDate);
	        pstmt.setInt(2, systemId);
	        pstmt.setInt(3, customerId);	 		        
	        ResultSet rs = pstmt.executeQuery();
	        int count = jsonArray.length();
	        JSONObject JsonObject;
	        while (rs.next()) {	 		        	
	           int noOfVehicles = Integer.parseInt(rs.getString("VEHICLE_COUNT"));
	            for (int i=0; i<noOfVehicles;i++){
	            	count++;
	            	JsonObject = new JSONObject();
	            	ArrayList < Object >  informationList = new ArrayList < Object > ();
		        	ReportHelper reporthelper = new ReportHelper();
		            JsonObject.put("slnoIndex", count);
		            informationList.add(count);
		            JsonObject.put("hubnameIndex",rs.getString("NAME"));
	                informationList.add(rs.getString("NAME"));
	            	JsonObject.put("uniqueIdIndex", 0);
		            JsonObject.put("idIndex",rs.getString("ID"));
		            informationList.add(rs.getString("ID"));
		            JsonObject.put("vehicleTypeIndex", rs.getString("VEHICLE_TYPE"));
		            informationList.add(rs.getString("VEHICLE_TYPE"));
		            JsonObject.put("makeIndex",rs.getString("MAKE"));
		            informationList.add(rs.getString("MAKE"));
		            JsonObject.put("dedicatedAdhocIndex",rs.getString("TYPE"));
		            informationList.add(rs.getString("TYPE"));
		            JsonObject.put("selectVehicleIndex",rs.getString("VEHICLE_NO"));
		            informationList.add(rs.getString("VEHICLE_NO"));
		            JsonObject.put("vehiclegroup","");
		            informationList.add("");
	                //JsonObject.put("vehicleType","");
	                //informationList.add("");
		            JsonObject.put("actualReportingTimeIndex",rs.getString("ACTUAL_DETENTION"));
		            informationList.add(rs.getString("ACTUAL_DETENTION"));
		            if(rs.getString("ACTUAL_REPORT_DATETIME").contains("1900")){
		            	JsonObject.put("actualReportingDateTimeIndex","");
		            	informationList.add("");
		            }else{
		            	JsonObject.put("actualReportingDateTimeIndex",rs.getString("ACTUAL_REPORT_DATETIME"));
		            	informationList.add(rs.getString("ACTUAL_REPORT_DATETIME"));
		            }
		           JsonObject.put("insertedDateTimeIndex","");
	               informationList.add("");	 			           
		           JsonObject.put("vehicleIndentIdIndex",rs.getString("vehicleIndentId"));	 	
	               informationList.add(rs.getString("vehicleIndentId"));
	               JsonObject.put("editRowIndex",true);
	               informationList.add("true");
	               JsonObject.put("createTripIndex","");
            	   informationList.add("");
            	
            	   if(rs.getString("VEHICLE_NO").equals(""))
			       {
			            JsonObject.put("countIndex",0);
			       }		 			           
	                JsonObject.put("dateindex",rs.getString("RequiredDate"));				            
	                JsonObject.put("currentdateindex",rs.getString("currentdate"));				            
		            jsonArray.put(JsonObject);
		            reporthelper.setInformationList(informationList);
					reportsList.add(reporthelper);
	            }
	        }
    
	}
	public JSONArray getAllHubs(int cutomerId, int systemId,String zone,int UserId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		PreparedStatement pstmt1=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();			
			pstmt = con.prepareStatement(DistributionStatments.GET_USER_ASSOCIATED_HUB.replace("LOCATION","LOCATION_ZONE_"+zone));
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,cutomerId);
			pstmt.setInt(3, UserId);
			pstmt.setInt(4,systemId);
			rs=pstmt.executeQuery();
			jsonObject = new JSONObject();
			jsonObject.put("hubId", "0");
			jsonObject.put("hubName", "-- ALL --");
			jsonArray.put(jsonObject);
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("hubId", rs.getString("HUBID"));
				jsonObject.put("hubName", rs.getString("HUBNAME"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			System.out.println("Error in getHubDetails "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	
	}
	
	public JSONArray getVehicleSummaryReport(int systemId, int clientId, int offset,String unit,int userId,String startDate,String endDateJsp) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String condition = "";
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
		    condition = " and td.TRIP_START_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?)";
		    pstmt=con.prepareStatement(DistributionStatments.VEHICLE_SUMMARY_REPORT.replace("&", condition));
		    pstmt.setString(1,startDate);
			pstmt.setString(2,endDateJsp);
			pstmt.setInt(3,systemId);
			pstmt.setInt(4,clientId);
			pstmt.setInt(5,offset);
			pstmt.setString(6,startDate);
			pstmt.setInt(7,offset);
			pstmt.setString(8,endDateJsp);
			
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slNo", count);
				jsonobject.put("VEHNo", rs.getString("ASSET_NUMBER"));
				jsonobject.put("Vehicletype", rs.getString("VehicleType"));
				jsonobject.put("TotalNoOfTrips", rs.getString("TOTAL_NO_OF_TRIPS"));
				jsonobject.put("NoOfAllocatedDays", rs.getString("NO_OF_ALLOCATED_DAYS"));
				jsonobject.put("TotalDistanceCovered", df.format(rs.getDouble("TOTAL_DISTANCE_COVERED")));
				jsonobject.put("TotalDistanceExpected", df.format(rs.getDouble("TOTAL_DISTANACE_EXPECTED")));
				jsonobject.put("TotalNoOfHours", cf.convertMinutesToHHMMFormat(rs.getInt("TOTAL_DURATION")));
				
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getVehicleTripReport(int systemId, int clientId, int offset,String unit,int userId,String startDate
											,String endDateJsp,String hubId,String vehicleNumber) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonobject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String condition = "";
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
		    if(Integer.parseInt(hubId) !=0){
	        	condition=condition + " and b.HUB_ID="+hubId ;
	        }
		    if(!vehicleNumber.equals(ALL_VALUE)){
	        	condition=condition + " and td.ASSET_NUMBER='"+vehicleNumber+"'";
	        }
	    	pstmt=con.prepareStatement(DistributionStatments.VEHICLE_TRIP_REPORT.replace("&", condition));
		    pstmt.setInt(1,offset);
			pstmt.setInt(2,offset);
			pstmt.setInt(3,offset);
			pstmt.setInt(4,offset);
			pstmt.setInt(5,offset);
			pstmt.setInt(6,systemId);
			pstmt.setInt(7,clientId);
			pstmt.setInt(8,offset);
		    pstmt.setString(9,startDate);
		    pstmt.setInt(10,offset);
			pstmt.setString(11,endDateJsp);
			
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				jsonobject = new JSONObject();
				jsonobject.put("slNo", count);
				jsonobject.put("Date", rs.getString("DATE"));
				jsonobject.put("RouteName", rs.getString("ROUTE_NAME"));
				jsonobject.put("VehicleNumber", rs.getString("VEHICLE_NO"));
				if(rs.getString("ACTUAL_REPORT_DATETIME") != null){
					jsonobject.put("SourceOriginArrivalDateTime", sdf.format(sdfDB.parse(rs.getString("ACTUAL_REPORT_DATETIME"))));
				}else{
					jsonobject.put("SourceOriginArrivalDateTime", "");
				}
				String tripendtime="";
				if(!rs.getString("ACTUAL_TRIP_END_TIME").contains("1900"))
				{
					tripendtime=sdf.format(sdfDB.parse(rs.getString("ACTUAL_TRIP_END_TIME")));
				}
				jsonobject.put("TripEndDateTime", tripendtime);
				int gpsTimeMin =rs.getInt("GPSTIME") ;
				String gpsstaus="";
				if(gpsTimeMin<=15){
					gpsstaus="Communicating";
				}
				else{
					gpsstaus="Non-Communicating";
				}
				
				String ATD="";
				if(!rs.getString("ActualTimeOfDeparture").contains("1900")){
					ATD = sdf.format(sdfDB.parse(rs.getString("ActualTimeOfDeparture")));
				}
				String ATA="";
				if(!rs.getString("ATA").contains("1900")){
					ATA = sdf.format(sdfDB.parse(rs.getString("ATA")));
				}
				int totalTripTimeATAATD =0;
//				if((!ATA.equals("")) &&( !ATD.equals(""))){
					 totalTripTimeATAATD = rs.getInt("TOTAL_TRIP_TIME");
//					 totalTripTimeATAATD  = totalTripTimeATAATD < 0 ? 0: totalTripTimeATAATD;
//				}
				jsonobject.put("actualtriptime", cf.convertMinutesToHHMMFormat(totalTripTimeATAATD));
				double distance = 0;
				//calculation of distance 
				if(gpsstaus.equals("Communicating")){
					distance = rs.getDouble("TOTAL_DISTANCE");
					if(unit.equals("kms")){
						distance = rs.getDouble("TOTAL_DISTANCE");
						jsonobject.put("totdistcovered", df.format(distance));
					}
				}
				else{
					jsonobject.put("totdistcovered", "");
				}
				Double expecteddistance = rs.getDouble("TOTAL_EXPECTED_DISTANCE");
				if(unit.equals("kms")){
					expecteddistance = rs.getDouble("TOTAL_EXPECTED_DISTANCE"); 
				}
				jsonobject.put("expecteddistance", df.format(expecteddistance));
				jsonArray.put(jsonobject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}


	public JSONArray getVehiclesFromAssetReporting(int systemId, int clientId,
			int userId, String startDate, String endDate) {
			JSONArray jsonArray = new JSONArray();
			JSONObject jsonObject = new JSONObject();
			Connection con=null;
			PreparedStatement pstmt=null;
			ResultSet rs=null;
	
			try {
				con = DBConnection.getConnectionToDB("AMS");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				pstmt = con.prepareStatement(DistributionStatments.GET_VEHICLES_FROM_VEHICLE_REPORTING_DATE_RANGE);
				pstmt.setString(1, startDate);
				pstmt.setString(2, endDate );
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, clientId);
		        rs = pstmt.executeQuery();
		        jsonObject = new JSONObject();
				jsonObject.put("vehicleName", ALL_VALUE);
				jsonArray.put(jsonObject);	
				while (rs.next()) {
					jsonObject = new JSONObject();
					jsonObject.put("vehicleName", rs.getString("REGISTRATION_NUMBER"));
					jsonArray.put(jsonObject);	
				}
			} // end of try
			catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);			
			}
	
			return jsonArray;

	}
	

}


