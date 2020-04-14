package t4u.functions;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedList;
import java.util.TimeZone;

import com.t4u.activity.VehicleActivity;
import com.t4u.activity.VehicleSummaryBean;
import com.t4u.activity.VehicleActivity.DataListBean;
import t4u.common.DBConnection;

public class SaveDriverPerformanceDetails {

	private static final String GET_OPEN_LEG_DETAILS = "select isnull(td.ACTUAL_DEPARTURE,'') as startDate,isnull(td.ACTUAL_ARRIVAL,getutcdate()) as endDate,isnull(DRIVER_1,0) as driver1,"+
	" isnull(DRIVER_2,0) as driver2,isnull(tr.ASSET_NUMBER,'') as vehicleNo,isnull(vm.Model,0) as modelId,isnull(td.LEG_ID,0) as legId ,isnull(tr.ROUTE_NAME,'') as routeName,isnull(tr.SHIPMENT_ID,'') as shipmentId " +
	" from TRIP_LEG_DETAILS td"+
	" left outer join TRACK_TRIP_DETAILS tr on tr.TRIP_ID=td.TRIP_ID"+
	" left outer join AMS.dbo.tblVehicleMaster vm on vm.VehicleNo=tr.ASSET_NUMBER"+
	" where td.TRIP_ID=? and td.ACTUAL_DEPARTURE is not null and td.ACTUAL_ARRIVAL is null";
	
	private static final String INSERT_DRIVER_DETAILS = "insert into AMS.dbo.TRIP_DRIVER_DETAILS(REGISTRATION_NO,TRIP_ID,LEG_ID,DRIVER_ID,TOTAL_DISTANCE," +
	" MAX_SPEED,AVG_SPEED_EXCL_STOPPAGE,AVG_SPEED_INCL_STOPPAGE,NO_OF_STOPS,NO_OF_IDLES,NO_OF_OVERSPEED,TOTAL_DURATION,TOTAL_IDLE_DURATION,TOTAL_STOP_DURATION," +
	" TOTAL_ALERTS,SYSTEM_ID,CUSTOMER_ID,INSERTED_TIME,HB_SCORE,HA_SCORE,HC_SCORE,OVER_SPEED_SCORE,IDLE_SCORE,GREEN_BAND_SPEED_SCORE,GREEN_BAND_RPM_SCORE," +
	" LOW_RPM_SCORE,HIGH_RPM_SCORE,OVER_REVV_SCORE,UNSCHDL_STOPPAGE_SCORE,FREE_WHEEL_SCORE,FINAL_SCORE,MILEAGE,FUEL_CONSUMED,START_DATE,END_DATE,HA_COUNT,HB_COUNT," +
	" HC_COUNT,OVERSPEED_COUNT,OVER_REVV_COUNT,UNSCHLD_STOP_DUR,EXCESS_IDLE_DUR,GREEN_BAND_SPEED_DUR,GREEN_BAND_RPM_DUR,LOW_RPM_DUR,HIGH_RPM_DUR,FREE_WHEEL_DUR," +
	" GREEN_BAND_SPEED_PERC,GREEN_RPM_PERC,OBD_MILEAGE,OTP_STATUS) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,getutcdate(),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

	private static final String GET_ALERT_DETAILS = "select ALERT_TYPE,count(ALERT_TYPE) as alertCount from AMS.dbo.TRIP_EVENT_DETAILS where TRIP_ID=? and GMT between ? and ? group by ALERT_TYPE";

	private static final String GET_SPEED_DETAILS = "select t.GMT,t.SPEED from (select SPEED,GMT from HISTORY_DATA where REGISTRATION_NO=? and " +
	" GMT between ? and ?"+
	" union all"+
	" select SPEED,GMT from AMS_Archieve.dbo.GE_DATA where REGISTRATION_NO=? and GMT between ? and ?) t order by t.GMT";

	private static final String GET_CANIQ_RPM_DETAILS = "select t.GMT,t.SPEED,t.ENGINE_SPEED from (select SPEED,GMT,ENGINE_SPEED from  AMS.dbo.CANIQ_HISTORY where" +
	" REGISTRATION_NO=? and GMT between ? and ?"+
	" union all"+
	" select SPEED,GMT,ENGINE_SPEED from  AMS_Archieve.dbo.GE_CANIQ where REGISTRATION_NO=? and GMT between ? and ?)t order by t.GMT";

	private static final String GET_FREE_WHEEL_SECONDS = "select isnull(sum(DURATION),0) as dur from Alert.dbo.GENERIC_ALERT_TRANSACTION where SYSTEM_ID=? and REGISTRATION_NO=?"+
	" and (START_GMT between ? and ? or END_GMT between ? and ?) and START_GMT is not null and END_GMT is not null and TYPE_OF_ALERT=93";

	private static final String GET_TRIP_STOPPAGE_ALERT = "select a.TRIP_ID from TRIP_EVENT_DETAILS a " +
	" inner join Alert b on b.TYPE_OF_ALERT=1 and a.GMT=b.GMT and b.REGISTRATION_NO=a.VEHICLE_NO"+
	" where a.TRIP_ID=? and a.ALERT_TYPE=1 and b.START_DATETIME=dateadd(mi,?,?)";

	private static final String GET_SPPED_BAND = "select isnull(MIN,0) as min,isnull(MAX,0) as max from AMS.dbo.DRIVER_SCORE_PARAMETER_SETTING" +
	" where SYSTEM_ID=? and CUSTOMER_ID=? and MODEL_ID=? and PARAMETER=?";

	private static final String UPDATE_TRIP_LEG_DETAILS_WHILE_CLOSING = "update TRIP_LEG_DETAILS set TOTAL_DISTANCE=?,AVG_SPEED=?,TOTAL_STOPPAGE_DUR=?,FUEL_CONSUMED=?," +
	" 	MILEAGE=?,OBD_MILEAGE=?,LEG_SCORE=?,STATUS=? , # where TRIP_ID=? and LEG_ID=?";

	private static final String UPDATE_MAIN_TRIP = "update TRACK_TRIP_DETAILS set STATUS=?,AUTO_CLOSE=?," +
	" CANCELLED_BY=?,REMARKS=?,CANCELLED_DATE=getutcdate(),TRIP_STATUS = 'FORCEFULLY',END_LOCATION=?,# where TRIP_ID=?";
	
	public static final String UPDATE_DES_ATA = "UPDATE dbo.DES_TRIP_DETAILS SET # WHERE TRIP_ID=? AND SEQUENCE=100";

	public static String GET_FUEL_QTY_STARTTIME = "select top 1 FUEL_QTY,GMT from " +
	" (select top 1 FUEL_QTY,GMT from AMS.dbo.FUEL_LLS_DIGITAL where GMT>=? and REGISTRATION_NO=? " +
	" AND FUEL_QTY IS NOT NULL ORDER by GMT ASC UNION select top 1 FUEL_QTY,GMT from AMS_Archieve.dbo.FUEL_LLS_DIGITAL_ARCHIEVE " +
	" where GMT>=? and REGISTRATION_NO=? AND FUEL_QTY IS NOT NULL ORDER by GMT ASC)R ORDER by GMT ASC";

	public static String GET_FUEL_QTY_ENDTIME = "select top 1 FUEL_QTY,GMT from " +
	" (select top 1 FUEL_QTY,GMT from AMS.dbo.FUEL_LLS_DIGITAL where GMT<=? and REGISTRATION_NO=? " +
	" AND FUEL_QTY IS NOT NULL ORDER by GMT DESC UNION select top 1 FUEL_QTY,GMT from AMS_Archieve.dbo.FUEL_LLS_DIGITAL_ARCHIEVE " +
	" where GMT<=? and REGISTRATION_NO=? AND FUEL_QTY IS NOT NULL ORDER by GMT DESC )R ORDER by GMT DESC";

	public static String LAST_REFUELLEVEL = "select FUEL_LEVEL,GMT from AMS.dbo.REFUEL_INFO WHERE GMT BETWEEN ? and ? and REGISTRATION_NO=? and REFUEL_IN_LIT > 0";

	public static String PREVIOUS_REFUEL_VALUE = "select top 2 FUEL_QTY,GMT from (select top 2 FUEL_QTY,GMT " +
	" from AMS.dbo.FUEL_LLS_DIGITAL where GMT < ? and REGISTRATION_NO=? AND FUEL_QTY IS NOT NULL ORDER by GMT DESC  UNION " +
	" select top 2 FUEL_QTY,GMT from AMS_Archieve.dbo.FUEL_LLS_DIGITAL_ARCHIEVE where GMT < ? and REGISTRATION_NO=?" +
	" AND FUEL_QTY IS NOT NULL ORDER by GMT DESC)R ORDER by GMT DESC";
	
	public static String GET_OBD_MILEAGE = " select isnull(AVG(DD),0) as OBD_MILEAGE from (select AVG(ENG_FUEL_ECO) as DD from CANIQ_HISTORY_# where GMT between ? and ? and REGISTRATION_NO=? "+
	" union all "+ 
	" select AVG(ENG_FUEL_ECO) as DD from [AMS_Archieve].dbo.GE_CANIQ_# where GMT between ? and ? and REGISTRATION_NO=? )r ";
	
	private static final String UPDATE_MAIN_TRIP_FOR_MLL = "update TRACK_TRIP_DETAILS set STATUS=?,ACTUAL_TRIP_END_TIME=getutcdate(),AUTO_CLOSE=?," +
	" CANCELLED_BY=?,REMARKS=?,CANCELLED_DATE=getutcdate(),ACTUAL_DISTANCE=PLANNED_DISTANCE,ACTUAL_DURATION=PLANNED_DURATION,TRIP_STATUS = 'FORCEFULLY' where TRIP_ID=?";
	
	public static String GET_LEG_OTP_STATUS ="select datediff(mi,ACTUAL_DEPARTURE,ACTUAL_ARRIVAL),datediff(mi,STD,STA) from TRIP_LEG_DETAILS where datediff(mi,ACTUAL_DEPARTURE,ACTUAL_ARRIVAL)>datediff(mi,STD,STA) and ACTUAL_DEPARTURE is not null and ACTUAL_ARRIVAL is not null and TRIP_ID=? and LEG_ID=?" ;
	
	public String  saveDriverPerformance(Connection con,int tripId, int systemId, int clientId, int offset, int userId, String sessionId, String serverName, String remarksData,String ata,boolean destinationArrived) {
		String message = "";
		PreparedStatement pstmt = null, pstmt1 = null;
		ResultSet rs = null, rs1 = null;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		ArrayList<String> tableName = new ArrayList<String>();
		String remarks = "";
		CommonFunctions cf = new CommonFunctions();
		String routeName=null;
		String shipmentId=null;
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("dd/MM/yyyy HH:mm");
		String vehicleNo ="";
		try{
			if(ata != null && !ata.equals("")){
				ata = sdf.format(sdfFormatDate.parse(ata));
			}
			ArrayList<Integer> drivers = new ArrayList<Integer>();
			pstmt = con.prepareStatement(GET_OPEN_LEG_DETAILS);
			pstmt.setInt(1, tripId);
			rs = pstmt.executeQuery();
			if(rs.next()){
				tableName.add("Select"+"##"+"TRIP_LEG_DETAILS");
				
				String startDate = rs.getString("startDate");
				String endDate = rs.getString("endDate");
			    vehicleNo =rs.getString("vehicleNo");
				String modelId = rs.getString("modelId");
				int legId = rs.getInt("legId");
				routeName = rs.getString("routeName");
				shipmentId = rs.getString("shipmentId");

				drivers.add(rs.getInt("driver1"));
				drivers.add(rs.getInt("driver2"));
				double totalDistance = 0;
				double maxSpeed = 0;
				double avgSpeedExclStop = 0;
				double avgSpeedInclStop = 0;
				int noOfStops = 0;
				int noOdIdle = 0;
				int noOfOverspeed = 0;
				int totalAlerts = 0;
				long totalStopDur = 0;
				double overSpeedScore = 10;
				double hcScore = 10;
				double hbScore = 10;
				double haScore = 10;
				double excessIdleScore = 0;
				double unschdldSopScore = 0;
				double greenBandScore = 0;
				double greenBandRPMScore = 0;
				double lowRPMScore = 0;
				double highRPMScore = 0;
				double overRevvingScore = 0;
				long idleDur = 0;
				double freeWheelingScore = 0;
				double latitude=0;
				double longitude=0;
				String location = "";
				float duration = 0;
				String dur = "0.0";
				String stopDurFormatted = "";
				
				dur = printDifference(sdf.parse(startDate), sdf.parse(endDate));
				if(!dur.equals("0.0")){
					duration = Float.parseFloat(dur);
				}
				if(duration > 0){
					tableName.add("Select"+"##"+"HISTORY_DATA_"+systemId);
		    	tableName.add("Select"+"##"+"GE_DATA_"+systemId);
				double totalDurMins = convertHHMMToMinutes(dur);
				LinkedList < DataListBean > activityReportList = new LinkedList < DataListBean > ();
				if(!startDate.equals("") && !startDate.contains("1900")){
				    VehicleActivity vi = new VehicleActivity(con,vehicleNo, sdf.parse(startDate), sdf.parse(endDate), 0, systemId, clientId, 0);
				    activityReportList = vi.getFinalList();
				    if (activityReportList.size() > 0) {
				    	VehicleSummaryBean vehicleSummaryBean = vi.getVehicleSummaryBean();
				    	totalDistance =  vehicleSummaryBean.getTotalDistanceTravelled();
				    	maxSpeed = vehicleSummaryBean.getMaxSpeedInKMPH();
				    	if(!String.valueOf(vehicleSummaryBean.getAverageSpeedExcludingStoppageInKMPH()).equals("NaN")){
				    		avgSpeedExclStop = vehicleSummaryBean.getAverageSpeedExcludingStoppageInKMPH();
				    	}
				    	if(!String.valueOf(vehicleSummaryBean.getAverageSpeedIncludingStoppageInKMPH()).equals("NaN")){
				    		avgSpeedInclStop = vehicleSummaryBean.getAverageSpeedIncludingStoppageInKMPH();
				    	}
				    	noOfStops = vehicleSummaryBean.getTotalNumberOfStops();
				    	noOdIdle = vehicleSummaryBean.getTotalNumberOfIdles();
				    	noOfOverspeed = vehicleSummaryBean.getTotalNumberOfOverSpeeds();
				    	stopDurFormatted = vehicleSummaryBean.getTotalStopDurationFormated();
				    	idleDur = vehicleSummaryBean.getTotalIldeDuration() / 1000;
				    	latitude = vehicleSummaryBean.getEndLatitude();
				    	longitude = vehicleSummaryBean.getEndLongitude();
				    	location = vehicleSummaryBean.getEndLocation();
				    }
				}
				int daysMinPart = 0;
				int hoursMinPart = 0;
				int minsMinPart = 0;
				String[] splitStr = stopDurFormatted.split("\\s+");
			    if(splitStr.length==3){
			    	daysMinPart = Integer.parseInt(splitStr[0].split("days")[0]);
		    		hoursMinPart = Integer.parseInt(splitStr[1].split("hrs")[0]);
		    		minsMinPart = Integer.parseInt(splitStr[2].split("mins")[0]);
		    		totalStopDur = daysMinPart*1440 + hoursMinPart*60 + minsMinPart*1;
			    }
			    //*****************************
			    long stopMilli = 0;
			    long stopDur = 0;
			    double unschdldSopScoreDurIns = 0;
			    for(int i = 0 ; i < activityReportList.size(); i++){
			    	tableName.add("Select"+"##"+"TRIP_EVENT_DETAILS");
			    	DataListBean dlbcur = activityReportList.get(i);
			    	String cat = dlbcur.getCategory();
			    	if(cat.equals("STOPPAGE")){
			    		pstmt = con.prepareStatement(GET_TRIP_STOPPAGE_ALERT);
			    		pstmt.setInt(1, tripId);
			    		pstmt.setInt(2, offset);
			    		pstmt.setString(3, sdf.format(dlbcur.getGpsDateTime()));
			    		rs1 = pstmt.executeQuery();
			    		if(rs1.next()){
			    			stopMilli += dlbcur.getStopTime();
			    		}
			    	}
			    }
				stopDur = stopMilli / 1000;
				unschdldSopScoreDurIns = stopDur / totalDurMins;
				unschdldSopScore = 10 * (1 - unschdldSopScoreDurIns);
			    
			    //Excessive idling time
				SimpleDateFormat df = new SimpleDateFormat("HH.mm"); // HH for 0-23
				double excessIdleScoreDurIns = 0;
				excessIdleScoreDurIns = idleDur / totalDurMins;
				excessIdleScore = 10 * (1 - excessIdleScoreDurIns);
				// *********************************
				
				// Free wheel score
				double freeWheelScoreDurIns = 0;
				tableName.add("Select"+"##"+"Alert.dbo.GENERIC_ALERT_TRANSACTION");
				float freeWheeldur = getFreeWheelDuration(con,systemId,vehicleNo,startDate,endDate);
				freeWheelScoreDurIns = convertHHMMToMinutes(String.valueOf(freeWheeldur)) / totalDurMins;
				freeWheelingScore = 10 * (1 - freeWheelScoreDurIns);
				
				double overSpeedScoreDurIns = 0;
				double hbScoreDurIns = 0;
				double haScoreDurIns = 0;
				double hcScoreDurIns = 0;
				
				pstmt1 = con.prepareStatement(GET_ALERT_DETAILS);
				pstmt1.setInt(1, tripId);
				pstmt1.setString(2, startDate);
				pstmt1.setString(3, endDate);
				rs1 = pstmt1.executeQuery();
				while(rs1.next()){
					totalAlerts += rs1.getInt("alertCount");
					switch(rs1.getInt("ALERT_TYPE")){
					case 2 : 
						try{
							overSpeedScoreDurIns = (rs1.getInt("alertCount") / totalDurMins ) * 60;
							overSpeedScore = 10 - (overSpeedScoreDurIns);
						}catch(Exception e){
							e.printStackTrace();
						}
						break;
					case 58 :
						try{
							hbScoreDurIns = (rs1.getInt("alertCount") / totalDurMins) * 60;
							hbScore = 10 - (hbScoreDurIns);
						}catch(Exception e){
							e.printStackTrace();
						}
						break;
					case 105 :
						try{
							haScoreDurIns = (rs1.getInt("alertCount") / totalDurMins) * 60;
							haScore = 10 - (haScoreDurIns);
						}catch(Exception e){
							e.printStackTrace();
						}
						break;
					case 106 :
						try{
							hcScoreDurIns = (rs1.getInt("alertCount") / totalDurMins) * 60;
							hcScore = 10 - (hcScoreDurIns);
						}catch(Exception e){
							e.printStackTrace();
						}
						break;
					}
				}
				// ******************************
				
				// Green band Score
				tableName.add("Select"+"##"+"AMS.dbo.DRIVER_SCORE_PARAMETER_SETTING");
				double greenBandScoreDurIns = 0;
				double  greenBandDur = 0;
				String greenBand = "0.0";
				if(!startDate.equals("") && !startDate.contains("1900")){
					greenBand = getgreenBandScoreDetails(con,systemId,clientId,startDate,endDate,vehicleNo,modelId);
				}
				if(Float.parseFloat(greenBand) > 0){
					greenBandDur = convertHHMMToMinutes(greenBand);
				}
				greenBandScoreDurIns = greenBandDur / totalDurMins;
				greenBandScore = 10 * (greenBandScoreDurIns);
				// *************************************
				
				// Get RPM Scores
				tableName.add("Select"+"##"+"AMS.dbo.CANIQ_HISTORY");
				tableName.add("Select"+"##"+"AMS_Archieve.dbo.GE_CANIQ");
				int overRevvCount = 0;
				double greenBandRpm = 0;
				double lowRpm = 0;
				double highRp = 0;
				double overRevvingScoreDurIns = 0; 
				double greenBandRPMScoreDurIns = 0;
				double lowRPMScoreDurIns = 0;
				double highRPMScoreDurIns = 0;
				ArrayList<String> rpmScores = new ArrayList<String>();
				if(!startDate.equals("") && !startDate.contains("1900")){
					rpmScores = getRPMScoresDetails(con,systemId,clientId,startDate,endDate,vehicleNo,modelId);
				}	
				if(rpmScores.size() > 0){
					overRevvCount = Integer.parseInt(rpmScores.get(0));
					if(Float.parseFloat(rpmScores.get(1)) > 0){
						greenBandRpm = convertHHMMToMinutes(rpmScores.get(1));
					}
					if(Float.parseFloat(rpmScores.get(2)) > 0){
						lowRpm = convertHHMMToMinutes(rpmScores.get(2));
					}
					if(Float.parseFloat(rpmScores.get(3)) > 0){
						highRp = convertHHMMToMinutes(rpmScores.get(3));
					}
				}
				/* @Vinay : Instances are created as below logic
				 *  If Divided is count / number, convert divisor to minutes and multiple by 60 to get per hour instances
				 *  If divided is a time, convert both divided and divisor to minutes i.e instances per hour 
				 */
				overRevvingScoreDurIns = (overRevvCount / totalDurMins) * 60;
				greenBandRPMScoreDurIns = (greenBandRpm / totalDurMins);
				lowRPMScoreDurIns = (lowRpm / totalDurMins);
				highRPMScoreDurIns = (highRp / totalDurMins);
				
				overRevvingScore = 10 - (overRevvingScoreDurIns);
				greenBandRPMScore = 10 * (greenBandRPMScoreDurIns);
				lowRPMScore = 10 * (1 - lowRPMScoreDurIns);
				highRPMScore = 10 * (1 - highRPMScoreDurIns);
				
				if(lowRpm>greenBandRpm){
					int HUB_ID=0;
					insertRPMAlert(con,systemId,clientId,vehicleNo,192,endDate,location,routeName,latitude,longitude,shipmentId,HUB_ID,convertHHMMToMinutes(String.valueOf(lowRpm)));
				}
				
				if(highRp>greenBandRpm){
					int HUB_ID=1;
					insertRPMAlert(con,systemId,clientId,vehicleNo,192,endDate,location,routeName,latitude,longitude,shipmentId,HUB_ID,convertHHMMToMinutes(String.valueOf(highRp)));
				}
				
				if(hbScore < 0){
					hbScore = 0;
				}
				if(haScore < 0){
					haScore = 0;
				}
				if(hcScore < 0){
					hcScore = 0;
				}
				if(overSpeedScore < 0){
					overSpeedScore = 0;
				}
				if(excessIdleScore < 0){
					excessIdleScore = 0;
				}
				if(greenBandScore < 0){
					greenBandScore = 0;
				}
				if(greenBandRPMScore < 0){
					greenBandRPMScore = 0;
				}
				if(lowRPMScore < 0){
					lowRPMScore = 0;
				}
				if(highRPMScore < 0){
					highRPMScore = 0;
				}
				if(freeWheelingScore < 0){
					freeWheelingScore = 0;
				}
				if(unschdldSopScore < 0){
					unschdldSopScore = 0;
				}
				if(overRevvingScore < 0){
					overRevvingScore = 0;
				}
				// ***********************************
				double legTraveltime = totalDurMins - totalStopDur;
                double legGreenbandSpeedPercentage = legTraveltime > 0.0 ?(( convertHHMMToMinutes(greenBand) / legTraveltime ) * 100.00):0.0;
                double legGreenbandRPMPercentage = 0;
				double totalScore = 0;
				if(greenBandRpm <= 0 && lowRpm <= 0 && highRp <= 0){
					totalScore = (hbScore + haScore + hcScore + overSpeedScore + excessIdleScore + greenBandScore + unschdldSopScore+ overRevvingScore) / 8; // 12 parameters
					lowRPMScore = 0;
					highRPMScore=0;
					freeWheelingScore = 0;
					greenBandRPMScore = 0;
				}else{
					totalScore = (hbScore + haScore + hcScore + overSpeedScore + excessIdleScore + greenBandScore + greenBandRPMScore + lowRPMScore + highRPMScore +
							freeWheelingScore + unschdldSopScore+ overRevvingScore) / 12; // 12 parameters
					
					legGreenbandRPMPercentage = legTraveltime > 0.0 ?((greenBandRpm /legTraveltime ) * 100.00) :0.0;
				}
				
				double fuelConsumed = 0;
				double mileage = 0;
				fuelConsumed = getFuelConsumed(con,vehicleNo,startDate,endDate);
				if(fuelConsumed > 0){
					mileage = totalDistance / fuelConsumed;
					ArrayList<String> params=getParameterSetting(con,systemId,clientId,vehicleNo,modelId,"OEM MILEAGE");
					if(mileage<Float.parseFloat(params.get(0))){
						insertMileageAlert(con,systemId,clientId,vehicleNo,195,endDate,location,routeName,latitude,longitude,shipmentId,0,(float)mileage);
					}
				}
				double obdmileage = 0;
				if(!startDate.equals("") && !startDate.contains("1900")){
					obdmileage = getOBDMileage(con, vehicleNo,startDate,endDate,systemId);
				}	
				String onTimeStatus=getOntimePerformancePerLeg(con,tripId,systemId,legId);
				for(int i = 0; i < drivers.size(); i++){
					tableName.add("Insert"+"##"+"AMS.dbo.TRIP_DRIVER_DETAILS");
					pstmt = con.prepareStatement(INSERT_DRIVER_DETAILS);
			    	pstmt.setString(1, vehicleNo);
			    	pstmt.setInt(2, tripId);
			    	pstmt.setInt(3, legId);
			    	pstmt.setInt(4, drivers.get(i));
			    	pstmt.setDouble(5, totalDistance);
			    	pstmt.setDouble(6, maxSpeed);
			    	pstmt.setDouble(7, avgSpeedExclStop);
			    	pstmt.setDouble(8, avgSpeedInclStop);
			    	pstmt.setInt(9, noOfStops);
			    	pstmt.setInt(10, noOdIdle);
			    	pstmt.setInt(11, noOfOverspeed);
			    	pstmt.setDouble(12, totalDurMins);
			    	pstmt.setDouble(13, idleDur);
			    	pstmt.setLong(14, totalStopDur);
			    	pstmt.setInt(15, totalAlerts);
			    	pstmt.setInt(16, systemId);
			    	pstmt.setInt(17, clientId);
			    	pstmt.setDouble(18, hbScore);
			    	pstmt.setDouble(19, haScore);
			    	pstmt.setDouble(20, hcScore);
			    	pstmt.setDouble(21, overSpeedScore);
			    	pstmt.setDouble(22, excessIdleScore);
			    	pstmt.setDouble(23, greenBandScore);
			    	pstmt.setDouble(24, greenBandRPMScore);
			    	pstmt.setDouble(25, lowRPMScore);
			    	pstmt.setDouble(26, highRPMScore);
			    	pstmt.setDouble(27, overRevvingScore);
			    	pstmt.setDouble(28, unschdldSopScore);
			    	pstmt.setDouble(29, freeWheelingScore);
			    	pstmt.setDouble(30, totalScore);
			    	pstmt.setDouble(31, mileage);
			    	pstmt.setDouble(32, fuelConsumed);
			    	pstmt.setString(33, startDate);
			    	pstmt.setString(34, endDate);
			    	pstmt.setDouble(35, haScoreDurIns);
			    	pstmt.setDouble(36, hbScoreDurIns);
			    	pstmt.setDouble(37, hcScoreDurIns);
			    	pstmt.setDouble(38, overSpeedScoreDurIns);
			    	pstmt.setDouble(39, overRevvingScoreDurIns);
			    	pstmt.setDouble(40, unschdldSopScoreDurIns);
			    	pstmt.setDouble(41, excessIdleScoreDurIns);
			    	pstmt.setDouble(42, greenBandScoreDurIns);
			    	pstmt.setDouble(43, greenBandRPMScoreDurIns);
			    	pstmt.setDouble(44, lowRPMScoreDurIns);
			    	pstmt.setDouble(45, highRPMScoreDurIns);
			    	pstmt.setDouble(46, freeWheelScoreDurIns);
			    	pstmt.setDouble(47, legGreenbandSpeedPercentage);
			    	pstmt.setDouble(48, legGreenbandRPMPercentage);
			    	pstmt.setDouble(49, obdmileage);
			    	pstmt.setString(50, onTimeStatus);
			    	pstmt.executeUpdate();
				}
				tableName.add("Update"+"##"+"TRIP_LEG_DETAILS");
				updateTipLegDetailsWhileClosing(con,totalDistance,avgSpeedExclStop,totalStopDur,fuelConsumed,mileage,obdmileage,totalScore,tripId,legId,ata,offset);
			}
			}
			tableName.add("Update"+"##"+"TRACK_TRIP_DETAILS");
			message = updateMainTrip(con, tripId, userId, remarksData,systemId,ata,offset,destinationArrived,vehicleNo,clientId);
			remarks = "Closing trip and updating driver performance."+tripId;
			try{
				cf.insertDataIntoAuditLogReport(sessionId, tableName, "Trip Solution", "Closing Trip", userId, serverName, systemId, clientId, remarks);
			}catch(Exception e){
				e.printStackTrace();
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return message;
	}
	private String updateMainTrip(Connection con, int tripId, int userId, String remarksData,int systemId,String ata,int offset,boolean destinationArrived, String vehicleNo,int clientId) {
		String message = "Error while closing";
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		int update = 0;
		try{
			CreateTripFunction cf= new CreateTripFunction();
			String endLocation = cf.getEndLocation(vehicleNo, systemId, clientId, tripId, con);
			if (systemId == 214 ) {
				pstmt = con.prepareStatement(UPDATE_MAIN_TRIP_FOR_MLL);
				pstmt.setString(1, "CLOSED");
		    	pstmt.setString(2, "N");
		    	pstmt.setInt(3, userId);
		    	pstmt.setString(4, remarksData);
		    	pstmt.setInt(5, tripId);
			}else{
				if(ata != null && !ata.equals("")){
					pstmt = con.prepareStatement(UPDATE_MAIN_TRIP.replace("#", "ACTUAL_TRIP_END_TIME=dateadd(mi,-"+offset+","+ata+")"));
				}else{
					pstmt = con.prepareStatement(UPDATE_MAIN_TRIP.replace("#", "ACTUAL_TRIP_END_TIME=getutcdate()"));	
				}
					pstmt.setString(1, "CLOSED");
			    	pstmt.setString(2, "N");
			    	pstmt.setInt(3, userId);
			    	pstmt.setString(4, remarksData);
			    	pstmt.setString(5, endLocation);
			    	pstmt.setInt(6, tripId);
				
				if(!destinationArrived){//If destination arrival happened don't override 
			    	if(ata != null && !ata.equals("")){
						pstmt1 = con.prepareStatement(UPDATE_DES_ATA.replace("#", "ACT_ARR_DATETIME=dateadd(mi,-?,?)"));
						pstmt1.setInt(1, offset);
				    	pstmt1.setString(2, ata);
				    	pstmt1.setInt(3, tripId);
				    	update = pstmt1.executeUpdate();
					}
				}
			}
	    	update = pstmt.executeUpdate();
	    	if(update> 0){
	    		message = "Trip closed successfully";
	    	}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return message;
	}
	private void updateTipLegDetailsWhileClosing(Connection con, double totalDistance, double avgSpeedExclStop, long totalStopDur, double fuelConsumed,	double mileage,
			double obdmileage, double totalScore, int tripId, int legId,String ata,int offset) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			if(ata != null && !ata.equals("")){
				pstmt = con.prepareStatement(UPDATE_TRIP_LEG_DETAILS_WHILE_CLOSING.replace("#", "ACTUAL_ARRIVAL=dateadd(mi,-"+offset+",'"+ata+"')"));
			}else{
				pstmt = con.prepareStatement(UPDATE_TRIP_LEG_DETAILS_WHILE_CLOSING.replace("#", "ACTUAL_ARRIVAL=getutcdate()"));
			}
			pstmt.setDouble(1, totalDistance);
	    	pstmt.setDouble(2, avgSpeedExclStop);
	    	pstmt.setDouble(3, totalStopDur);
	    	pstmt.setDouble(4, fuelConsumed);
	    	pstmt.setDouble(5, mileage);
	    	pstmt.setDouble(6, obdmileage);
	    	pstmt.setDouble(7, totalScore);
	    	pstmt.setString(8, "CLOSED");
	    	pstmt.setInt(9, tripId);
	    	pstmt.setInt(10, legId);
	    	pstmt.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		
	}
	private static float getFreeWheelDuration(Connection con, int systemId,	String vehicleNo, String startDate, String endDate) {
		String freeWheelDur = "0";
		long dur = 0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			pstmt = con.prepareStatement(GET_FREE_WHEEL_SECONDS);
			pstmt.setInt(1, systemId);
			pstmt.setString(2, vehicleNo);
			pstmt.setString(3, startDate);
			pstmt.setString(4, endDate);
			pstmt.setString(5, startDate);
			pstmt.setString(6, endDate);
			rs = pstmt.executeQuery();
			if(rs.next()){
				dur = rs.getLong("dur");
			}
			Date d = new Date(dur * 1000L);
			SimpleDateFormat df = new SimpleDateFormat("HH.mm"); // HH for 0-23
			df.setTimeZone(TimeZone.getTimeZone("GMT"));
			freeWheelDur = df.format(d);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return Float.parseFloat(freeWheelDur);
	}
	private static ArrayList<String> getRPMScoresDetails(Connection con,int systemId, int clientId, String startDate, String endDate, String vehicleNo,
			String modelId) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> details = new ArrayList<String>();
		boolean flag = false , flag1 = false, flag2 = false;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String sDate = "", eDate = "", sDate1 = "", eDate1 = "", sDate2 = "", eDate2 = "";;
		long greenDur = 0;
		long lowDur = 0;
		long highDur = 0;
		float min = 1100;
		float max = 1400;
		String greenDuration = "0.0";
		String lowDuration = "0.0";
		String highDuration = "0.0";
		int overRevvCount = 0;
		String gmt = "";
		try{
			pstmt = con.prepareStatement(GET_SPPED_BAND);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, modelId);
			pstmt.setString(4, "ENGINE RPM");
			rs = pstmt.executeQuery();
			if(rs.next()){
				min = rs.getFloat("min");
				max = rs.getFloat("max");
			}
			
			pstmt = con.prepareStatement(GET_CANIQ_RPM_DETAILS.replace("AMS.dbo.CANIQ_HISTORY", "AMS.dbo.CANIQ_HISTORY_"+systemId).replace("AMS_Archieve.dbo.GE_CANIQ","AMS_Archieve.dbo.GE_CANIQ_"+systemId));
			pstmt.setString(1, vehicleNo);
			pstmt.setString(2, startDate);
			pstmt.setString(3, endDate);
			pstmt.setString(4, vehicleNo);
			pstmt.setString(5, startDate);
			pstmt.setString(6, endDate);
			rs = pstmt.executeQuery();
			while(rs.next()){
				if(rs.getDouble("SPEED") == 0 && rs.getDouble("ENGINE_SPEED") > 1500){
					overRevvCount++;
				}
				// for between range 
				if(flag == false){
					if(rs.getDouble("ENGINE_SPEED") >= min && rs.getDouble("ENGINE_SPEED") <= max){
						sDate = rs.getString("GMT");
						flag = true;
					}	
				}else{
					if(!(rs.getDouble("ENGINE_SPEED") >= min && rs.getDouble("ENGINE_SPEED") <= max)){
						if(flag){
							eDate = rs.getString("GMT");
							greenDur += getTimeDiffrence(sdf.parse(sDate), sdf.parse(eDate));
							flag = false;
						}
					}
				}
				// for less than range 
				if(flag1 == false){
					if(rs.getDouble("ENGINE_SPEED") < min){
						sDate1 = rs.getString("GMT");
						flag1 = true;
					}
				}else{
					if(rs.getDouble("ENGINE_SPEED") >= min){
						if(flag1){
							eDate1 = rs.getString("GMT");
							lowDur += getTimeDiffrenceLowRPM(sdf.parse(sDate1), sdf.parse(eDate1));
							flag1 = false;
						}
					}
				}
				
				if(flag2 == false){
					if(rs.getDouble("ENGINE_SPEED") > max){
						sDate2 = rs.getString("GMT");
						flag2 = true;
					}
				}else{
					if(rs.getDouble("ENGINE_SPEED") <= max){
						if(flag2){
							eDate2 = rs.getString("GMT");
							highDur += getTimeDiffrenceHighRPM(sdf.parse(sDate2), sdf.parse(eDate2));
							flag2 = false;
						}
					}
				}
				gmt = rs.getString("GMT");
			}
			if(flag2){
				highDur += getTimeDiffrenceHighRPM(sdf.parse(sDate2), sdf.parse(gmt));
			}
			if(flag1){
				lowDur += getTimeDiffrenceLowRPM(sdf.parse(sDate1), sdf.parse(gmt));
			}
			if(flag){
				greenDur += getTimeDiffrence(sdf.parse(sDate), sdf.parse(gmt));
			}
			SimpleDateFormat df = new SimpleDateFormat("HH.mm"); // HH for 0-23
			
			Date d = new Date(greenDur * 1000L);
			df.setTimeZone(TimeZone.getTimeZone("GMT"));
			greenDuration = df.format(d);
			
			Date d1 = new Date(highDur * 1000L);
			df.setTimeZone(TimeZone.getTimeZone("GMT"));
			highDuration = df.format(d1);
			
			Date d2 = new Date(lowDur * 1000L);
			df.setTimeZone(TimeZone.getTimeZone("GMT"));
			lowDuration = df.format(d2);
			
			details.add(String.valueOf(overRevvCount));
			details.add(greenDuration);
			details.add(lowDuration);
			details.add(highDuration);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return details;
	}
	private static String getgreenBandScoreDetails(Connection con, int systemId, int clientId, String startDate, String endDate, String vehicleNo,
			String modelId) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String score = "0.0";
		boolean flag = false;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String sDate = "";
		String eDate = "";
		long dur=0;
		float min = 55;
		float max = 60;
		String date = "";
		try{
			pstmt = con.prepareStatement(GET_SPPED_BAND);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, modelId);
			pstmt.setString(4, "SPEED");
			rs = pstmt.executeQuery();
			if(rs.next()){
				min = rs.getFloat("min");
				max = rs.getFloat("max");
			}
			pstmt = con.prepareStatement(GET_SPEED_DETAILS.replace("HISTORY_DATA", "HISTORY_DATA_"+systemId).replace("AMS_Archieve.dbo.GE_DATA","AMS_Archieve.dbo.GE_DATA_"+systemId));
			pstmt.setString(1, vehicleNo);
			pstmt.setString(2, startDate);
			pstmt.setString(3, endDate);
			pstmt.setString(4, vehicleNo);
			pstmt.setString(5, startDate);
			pstmt.setString(6, endDate);
			rs = pstmt.executeQuery();
			while(rs.next()){
					if(flag == false){
						if(rs.getDouble("SPEED") >= min && rs.getDouble("SPEED") <= max){
							sDate = rs.getString("GMT");
							flag = true;
						}	
					}else{
						if(!(rs.getDouble("SPEED") >= min && rs.getDouble("SPEED") <= max)){
							if(flag){
								eDate = rs.getString("GMT");
								dur += getTimeDiffrence(sdf.parse(sDate), sdf.parse(eDate));
								flag = false;
							}
						}
					}
					date = rs.getString("GMT");
			}
			if(flag){
				dur += getTimeDiffrence(sdf.parse(sDate), sdf.parse(date));
			}
			Date d = new Date(dur * 1000L);
			SimpleDateFormat df = new SimpleDateFormat("HH.mm"); // HH for 0-23
			df.setTimeZone(TimeZone.getTimeZone("GMT"));
			score = df.format(d);
		}catch(Exception e){
			e.printStackTrace();
		}
		return score;
	}
	
	public static String printDifference(Date startDate, Date endDate){
		String duration = "0.0";
		try{
		    long different = endDate.getTime() - startDate.getTime();
		    long secondsInMilli = 1000;
		    long minutesInMilli = secondsInMilli * 60;
		    long hoursInMilli = minutesInMilli * 60;
		    //long daysInMilli = hoursInMilli * 24;
	
		    long elapsedHours = different / hoursInMilli;
		    different = different % hoursInMilli;
	
		    long elapsedMinutes = different / minutesInMilli;
		    different = different % minutesInMilli;
		    //long elapsedSeconds = different / secondsInMilli;
		    
		    duration = elapsedHours+"."+elapsedMinutes;
		}catch(Exception e){
			e.printStackTrace();
		}
		return duration;
	}
	
	public static int getTimeDiffrence(Date startdate,Date enddate){
		int diffMinutes=0;
		SimpleDateFormat sdfformat = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		Date d1 = null;
		Date d2 = null;
	
		try {
			d1=(Date)sdfformat.parse(sdfformat.format(startdate));
			d2=(Date)sdfformat.parse(sdfformat.format(enddate));
			long diff = d2.getTime() - d1.getTime();
		    diffMinutes = (int) (diff / (1000));
	
	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return diffMinutes;
	}
	
	public static int getTimeDiffrenceLowRPM(Date startdate,Date enddate){
		int diffMinutes=0;
		SimpleDateFormat sdfformat = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		Date d1 = null;
		Date d2 = null;
	
		try {
			d1=(Date)sdfformat.parse(sdfformat.format(startdate));
			d2=(Date)sdfformat.parse(sdfformat.format(enddate));
			long diff = d2.getTime() - d1.getTime();
		    diffMinutes = (int) (diff / (1000));
	
	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return diffMinutes;
	}
	
	public static int getTimeDiffrenceHighRPM(Date startdate,Date enddate){
		int diffMinutes=0;
		SimpleDateFormat sdfformat = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		Date d1 = null;
		Date d2 = null;
	
		try {
			d1=(Date)sdfformat.parse(sdfformat.format(startdate));
			d2=(Date)sdfformat.parse(sdfformat.format(enddate));
			long diff = d2.getTime() - d1.getTime();
		    diffMinutes = (int) (diff / (1000));
	
	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return diffMinutes;
	}
	public static float getFuelConsumed(Connection con,String vehNo,String trip_starttime,String trip_endtime){
		PreparedStatement psmt = null;
		ResultSet rs = null;
		PreparedStatement psmt1 = null;
		ResultSet rs1 = null;
		float fuel_qty_startime = 0,fuel_qty_endtime = 0,total_final_fuel_consumed=0;
		
		try{
			psmt = con.prepareStatement(GET_FUEL_QTY_STARTTIME);
			psmt.setString(1,trip_starttime);
			psmt.setString(2,vehNo);
			psmt.setString(3,trip_starttime);
			psmt.setString(4,vehNo);
			rs = psmt.executeQuery();
			while(rs.next())
			{
				fuel_qty_startime = rs.getFloat("FUEL_QTY");
			}
			rs.close();
			psmt.close();
			
			psmt = con.prepareStatement(GET_FUEL_QTY_ENDTIME);
			psmt.setString(1,trip_endtime);
			psmt.setString(2,vehNo);
			psmt.setString(3,trip_endtime);
			psmt.setString(4,vehNo);
			rs = psmt.executeQuery();
			while(rs.next())
			{
				fuel_qty_endtime = rs.getFloat("FUEL_QTY");
			}
			rs.close();
			psmt.close();
			
			psmt = con.prepareStatement(LAST_REFUELLEVEL);
			psmt.setString(1,trip_starttime);
			psmt.setString(2,trip_endtime);
			psmt.setString(3,vehNo);
			rs = psmt.executeQuery();
			float current_fuel_value = 0;
			float previous_fuel_value = 0;
			float delta_fuel_value = 0;
			while(rs.next())
			{
				int count=0;
				previous_fuel_value=0;
				current_fuel_value = rs.getFloat("FUEL_LEVEL");
				String last_refuel_datetime = rs.getString("GMT");
				psmt1 = con.prepareStatement(PREVIOUS_REFUEL_VALUE);
				psmt1.setString(1, last_refuel_datetime);
				psmt1.setString(2, vehNo);
				psmt1.setString(3, last_refuel_datetime);
				psmt1.setString(4, vehNo);
				rs1 = psmt1.executeQuery();
				while(rs1.next())
				{
					previous_fuel_value += rs1.getFloat("FUEL_QTY");
					count++;
				}
				previous_fuel_value=previous_fuel_value/count;
				delta_fuel_value = delta_fuel_value +(current_fuel_value - previous_fuel_value);
				
			}
			total_final_fuel_consumed = fuel_qty_startime+delta_fuel_value-fuel_qty_endtime;
			
		
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null,psmt, rs);
			DBConnection.releaseConnectionToDB(null,psmt1, rs1);
		}
		return total_final_fuel_consumed;
	}
	
	public static double convertHHMMToMinutes(String hourminutes) {
        double duration=0.00;
        String hours=hourminutes.substring(0, hourminutes.indexOf("."));
        String minutes=hourminutes.substring(hourminutes.indexOf(".")+1);
        double hoursdouble = 0.00;
        if (!hours.equals("")) {
            hoursdouble=Double.parseDouble(hours)*60;
        }
        duration = hoursdouble+Double.parseDouble(minutes);
        return duration;
    }
	
	public float getOBDMileage(Connection con,String vehNo,String trip_starttime,String trip_endtime,int systemid){
		PreparedStatement psmt = null;
		ResultSet rs = null;
		
		float obdmileage = 0;
		
		try{
			psmt = con.prepareStatement(GET_OBD_MILEAGE.replace("_#", "_"+systemid));
			psmt.setString(1,trip_starttime);
			psmt.setString(2,trip_endtime);
			psmt.setString(3,vehNo);
			psmt.setString(4,trip_starttime);
			psmt.setString(5,trip_endtime);
			psmt.setString(6,vehNo);
			rs = psmt.executeQuery();
			while(rs.next()){
				obdmileage = rs.getFloat("OBD_MILEAGE");
			}
			rs.close();
			psmt.close();
		
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null,psmt, rs);
		}
		return obdmileage;
	}
	
	
	public static void  insertRPMAlert(Connection con,int systemId,int customerid,String vehicleno,int type,String tripdatetime,String triplocation,String routeName,
			double latitude,double longitude,String shipmentId, int hub_id){
		PreparedStatement pstmt = null,statement=null;
		ResultSet rs = null;
		try {
			statement = con.prepareStatement("insert into Alert (REGISTRATION_NO,LONGITUDE ,LATITUDE,TYPE_OF_ALERT,SYSTEM_ID ,CLIENTID ,GMT,SMS_STATUS,EMAIL_STATUS," +
					"ROUTE_NAME,TRIP_NAME,HUB_ID) values(?,?,?,?,?,?,?,'N','N',?,?,?)");
			statement.setString(1, vehicleno);
			statement.setDouble(2, longitude);
			statement.setDouble(3, latitude);
			statement.setInt(4, type);
			statement.setInt(5, systemId);
			statement.setInt(6, customerid);
			statement.setString(7, tripdatetime);
			statement.setString(8, routeName);
			statement.setString(9, shipmentId);
			statement.setInt(10, hub_id);
			statement.execute();
			statement.close();
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
	}
	
	private static ArrayList<String> getParameterSetting(Connection con,int systemId, int clientId, String vehicleNo,String modelId,String parameter) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> details = new ArrayList<String>();
		float min = 40;
		float max = 400;
		try{
			pstmt = con.prepareStatement(GET_SPPED_BAND);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, modelId);
			pstmt.setString(4, parameter);
			rs = pstmt.executeQuery();
			if(rs.next()){
				min = rs.getFloat("min");
				max = rs.getFloat("max");
			}
			details.add(String.valueOf(min));
			details.add(String.valueOf(max));
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return details;
	}
	
	public static void  insertRPMAlert(Connection con,int systemId,int customerid,String vehicleno,int type,String tripdatetime,String triplocation,String routeName,
			double latitude,double longitude,String shipmentId, int hub_id, double rpmDurationInMin){
		PreparedStatement pstmt = null,statement=null;
		ResultSet rs = null;
		try {
			statement = con.prepareStatement("insert into Alert (REGISTRATION_NO,LONGITUDE ,LATITUDE,TYPE_OF_ALERT,SYSTEM_ID ,CLIENTID ,GMT,SMS_STATUS,EMAIL_STATUS," +
					"ROUTE_NAME,TRIP_NAME,HUB_ID, STOP_HOURS) values(?,?,?,?,?,?,?,'N','N',?,?,?,?)");
			statement.setString(1, vehicleno);
			statement.setDouble(2, longitude);
			statement.setDouble(3, latitude);
			statement.setInt(4, type);
			statement.setInt(5, systemId);
			statement.setInt(6, customerid);
			statement.setString(7, tripdatetime);
			statement.setString(8, routeName);
			statement.setString(9, shipmentId);
			statement.setInt(10, hub_id);
			statement.setString(11, String.valueOf(rpmDurationInMin));
			statement.execute();
			statement.close();
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
	}
	
	public static void  insertMileageAlert(Connection con,int systemId,int customerid,String vehicleno,int type,String tripdatetime,String triplocation,String routeName,
			double latitude,double longitude,String shipmentId, int hub_id, float mileage){
		PreparedStatement pstmt = null,statement=null;
		ResultSet rs = null;
		try {
			statement = con.prepareStatement("insert into Alert (REGISTRATION_NO,LONGITUDE ,LATITUDE,TYPE_OF_ALERT,SYSTEM_ID ,CLIENTID ,GMT,SMS_STATUS,EMAIL_STATUS," +
					"ROUTE_NAME,TRIP_NAME,HUB_ID, REMARKS) values(?,?,?,?,?,?,?,'N','N',?,?,?,?)");
			statement.setString(1, vehicleno);
			statement.setDouble(2, longitude);
			statement.setDouble(3, latitude);
			statement.setInt(4, type);
			statement.setInt(5, systemId);
			statement.setInt(6, customerid);
			statement.setString(7, tripdatetime);
			statement.setString(8, routeName);
			statement.setString(9, shipmentId);
			statement.setInt(10, hub_id);
			statement.setFloat(11, mileage);
			statement.execute();
			statement.close();
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
	}
	
	private static String getOntimePerformancePerLeg(Connection con, int tripId,int systemId,int legId) {
		// TODO Auto-generated method stub
		PreparedStatement psmt = null;
		ResultSet rs = null;
		
		String onTimeStatus="ontime";
		
		try{
			psmt = con.prepareStatement(GET_LEG_OTP_STATUS);
			psmt.setInt(1,tripId);
			psmt.setInt(2,legId);
			rs = psmt.executeQuery();
			if(rs.next()){
				onTimeStatus ="delayed";
			}
		
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null,psmt, rs);
		}
		return onTimeStatus;
	
	}
}
