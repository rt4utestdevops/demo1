package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.json.JSONException;
import org.json.JSONObject;

import t4u.common.DBConnection;

public class SLAReportLegwiseThread implements Runnable{
	private Connection con;
	private JSONObject jsonTrip;
	private int rowNumber;
	private Row row;
	private Sheet sheet;
	private CellStyle integerStyle;
	private ArrayList<String> arrayList;
	private ArrayList<String> formatList;
	private CellStyle blankOrNAStyle;
	private CellStyle defaultStyle;
	private CellStyle dateCellStyle;
	private CellStyle decimalStyle;
	private CellStyle summaryStyle;
	private String[] summationArray;
	private int[] indexArray;
	
	public SLAReportLegwiseThread(Connection con, JSONObject jsonTrip,int rowNumber, Row rowLegwise, Sheet sheet, 
			CellStyle integerStyle, ArrayList<String> arrayListLegwise,	ArrayList<String> formatListLeg, 
			CellStyle blankOrNAStyle, CellStyle defaultStyle, CellStyle dateCellStyle, CellStyle decimalStyle, 
			CellStyle summaryStyle, String[] summationArray, int[] indexArray) {
		this.con = con;
		this.jsonTrip = jsonTrip;
		this.rowNumber = rowNumber;
		this.row = rowLegwise;
		this.sheet = sheet;
		this.integerStyle = integerStyle;
		this.arrayList = arrayListLegwise;
		this.formatList = formatListLeg;
		this.blankOrNAStyle = blankOrNAStyle;
		this.defaultStyle = defaultStyle;
		this.dateCellStyle = dateCellStyle;
		this.decimalStyle = decimalStyle;
		this.summaryStyle = summaryStyle;
		this.summationArray = summationArray;
		this.indexArray = indexArray;
	}
	int offset = 330;
	SimpleDateFormat mmddyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	DecimalFormat df1 = new DecimalFormat("00");
    DecimalFormat df2 = new DecimalFormat("00.00");
    
	public static final String GET_TRIP_SUMMARY_REPORT_LEG_DETAILS = "select tl.LEG_ID,LEG_NAME,isnull(lz.NAME,'') as SOURCE,lz1.NAME as DESTIANTION,isnull(dateadd(mi,?,STD),'') as STD," +
	" isnull(dateadd(mi,?,STA),'') as STA, isnull(dateadd(mi,?,ACTUAL_ARRIVAL),'') as ATA,isnull(dateadd(mi,?,ACTUAL_DEPARTURE),'') as ATD,isnull(tl.TOTAL_DISTANCE,0) as TOTAL_DISTANCE," +
	" isnull(tl.AVG_SPEED,0) as AVG_SPEED,isnull(case when tl.FUEL_CONSUMED > 0 then tl.FUEL_CONSUMED else 0 end,0) as FUEL_CONSUMED,isnull(case when (tl.MILEAGE > 0 and tl.MILEAGE < 10) then tl.MILEAGE else 0 end,0) as MILEAGE," +
	" isnull(case when (tl.OBD_MILEAGE > 0 and tl.OBD_MILEAGE < 10) then tl.OBD_MILEAGE else 0 end,0) as OBD_MILEAGE," +
	" case when ACTUAL_ARRIVAL is null then isnull(DATEDIFF(mi,ACTUAL_DEPARTURE,ISNULL(ACTUAL_ARRIVAL,getutcdate())),0) else isnull(DATEDIFF(mi,ACTUAL_DEPARTURE,ACTUAL_ARRIVAL),0)  end as TRAVEL_DURATION," +
	" isnull(d.Fullname,'') as DRIVER1,isnull(d1.Fullname,'') as DRIVER2,isnull(dateadd(mi,?,ETA),'') as ETA,isnull(sum(GREEN_BAND_SPEED_DUR),0) as SUM_GBSD ," +
	" isnull(sum(GREEN_BAND_RPM_DUR),0) as SUM_GBRD,isnull(sum(TOTAL_DURATION),0) as TOTAL_DURATION,isnull(sum(TOTAL_STOP_DURATION),0)as TOTAL_STOP_DURATION," +
	" isnull(sum(tdd.LOW_RPM_DUR),0) as LOW_RPM_DUR,isnull(sum(tdd.HIGH_RPM_DUR),0) as HIGH_RPM_DUR , isnull(sum(FREE_WHEEL_DUR),0) as SUM_FWD," +
	" isnull(tdd.GREEN_BAND_SPEED_PERC,0) as greenBandSpeedPerc,isnull(tdd.GREEN_RPM_PERC,0) as greenRPMPerc,isnull(d.Mobile,'') as DRIVER1_CONTACT,isnull(d1.Mobile,'') as DRIVER2_CONTACT,  " +
	" isnull(DATEDIFF(mi,STD, ACTUAL_DEPARTURE),0) as delayedDepartureATD_STD, "+
	" isnull(lm.TAT,0) as plannedTransitTime, "+
	" isnull(DATEDIFF(mi,ACTUAL_DEPARTURE, ACTUAL_ARRIVAL),0) as actualTransitTime , lm.DISTANCE , "+
	" isnull(lz.Standard_Duration,'') as Standard_DurationS,isnull(lz1.Standard_Duration,'') as Standard_DurationD , "+
	" DATEADD(mi,lm.TAT,isnull(STA,'')) as STA_wrt_STD,DATEADD(mi,lm.TAT,isnull(ACTUAL_DEPARTURE,''))  as STA_wrt_ATD , "+
	" isnull(tl.ATA_TEMP1,0) as ATA_TEMPA , isnull(tl.ATA_TEMP2,0) as ATA_TEMPB , isnull(tl.ATA_TEMP3,0) as ATA_TEMPC , "+
	" isnull(GREEN_DUR_T1,0) as GR,isnull(GREEN_DUR_T2,0) as GM,isnull(GREEN_DUR_T3,0) as GD, "+
	" isnull(YELLOW_DUR_T1,0) as YR,isnull(YELLOW_DUR_T2,0) as YM,isnull(YELLOW_DUR_T3,0) as YD , "+
	" isnull(RED_DUR_T1,0) as RR,isnull(RED_DUR_T2,0) as RM,isnull(RED_DUR_T3,0) as RD , " +
	" isnull(TOTAL_DURATION,0) as TDUR,isnull(TOTAL_STOP_DURATION,0) as TSTOPDUR "+
	" from TRIP_LEG_DETAILS (nolock) tl " +
	" left outer join AMS.dbo.LEG_MASTER lm on lm.ID=tl.LEG_ID " +
	" left outer join AMS.dbo.LOCATION_ZONE_A lz on lz.HUBID=lm.SOURCE " +
	" left outer join AMS.dbo.LOCATION_ZONE_A lz1 on lz1.HUBID=lm.DESTINATION " +
	" left outer join AMS.dbo.Driver_Master d on d.Driver_id=tl.DRIVER_1 and d.Client_id = lm.CUSTOMER_ID " +
	" left outer join AMS.dbo.Driver_Master d1 on d1.Driver_id=tl.DRIVER_2 and d1.Client_id = lm.CUSTOMER_ID " +
	" left outer join TRIP_DRIVER_DETAILS tdd on tl.TRIP_ID=tdd.TRIP_ID and tl.LEG_ID=tdd.LEG_ID " +
	" where  tl.TRIP_ID=? "+
	" group by tl.LEG_ID , LEG_NAME, lz.NAME,lz1.NAME ,STD ,STA ,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,tl.TOTAL_DISTANCE ,tl.AVG_SPEED,tl.FUEL_CONSUMED,tl.MILEAGE, "+
	" tl.OBD_MILEAGE,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,d.Fullname,d1.Fullname,ETA,tdd.GREEN_BAND_SPEED_PERC,tdd.GREEN_RPM_PERC,d.Mobile,d1.Mobile,tl.ID,lm.TAT , "+
	" lm.DISTANCE,lz.Standard_Duration,lz1.Standard_Duration , tl.ATA_TEMP1,tl.ATA_TEMP2,tl.ATA_TEMP3,GREEN_DUR_T1,GREEN_DUR_T2,GREEN_DUR_T3, "+
	" YELLOW_DUR_T1,YELLOW_DUR_T2,YELLOW_DUR_T3,RED_DUR_T1,RED_DUR_T2,RED_DUR_T3 , TOTAL_DURATION,TOTAL_STOP_DURATION order by tl.ID ";
	
	public void run() {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			if(con == null){
				con = DBConnection.getConnectionToDB("AMS");
			}
			System.out.println("processing .........."+jsonTrip.getInt("tripId"));
			JSONObject json = new JSONObject();
			int legNo=0;
			pstmt = con.prepareStatement(GET_TRIP_SUMMARY_REPORT_LEG_DETAILS);
			pstmt.setInt(1,offset);
			pstmt.setInt(2,offset);
			pstmt.setInt(3,offset);
			pstmt.setInt(4,offset);
			pstmt.setInt(5,offset);
			pstmt.setInt(6,jsonTrip.getInt("tripId"));
			rs = pstmt.executeQuery();
			
			long sumPlannedTransitTime=0;
			long sumActualTransitTime=0;
			long sumTransitDelay=0;
			long sumUnplannedStoppage=0;
			long sumTruckinngRunningTime=0;
			double sumDistance=0;
			
			while(rs.next()){
				++legNo;
				++rowNumber;
				row = sheet.createRow(rowNumber);
				long plannedTransitTime=rs.getInt("plannedTransitTime");
				long actualTransitTime=rs.getInt("actualTransitTime");
				long total_stop_duration=rs.getLong("TSTOPDUR");
				double distance=rs.getDouble("DISTANCE");
				long orginDetn=rs.getLong("Standard_DurationS");
				long destnDetn=rs.getLong("Standard_DurationD");
				
				long totalDuration=rs.getInt("TDUR");
				long truckinngRunningTime=(totalDuration>0)?(totalDuration-total_stop_duration):0;
				
				long transitDelay=(actualTransitTime!=0)?(actualTransitTime-plannedTransitTime):0;
				
				long GR=rs.getLong("GR");
				long GM=rs.getLong("GM");
				long GD=rs.getLong("GD");

				long YR=rs.getLong("YR");
				long YM=rs.getLong("YM");
				long YD=rs.getLong("YD");

				long RR=rs.getLong("RR");
				long RM=rs.getLong("RM");
				long RD=rs.getLong("RD");

				 if(jsonTrip.has("Temperature required")){
					 json.put("Temperature required",jsonTrip.get("Temperature required"));
				 }else{
					 json.put("Temperature required","");
				 }

				json.put("Sl. No.",rowNumber);
				Cell cell1 = row.createCell(0);
				cell1.setCellValue("");
				cell1.setCellStyle(integerStyle);

				json.put("Trip Id",jsonTrip.getString("Trip ID"));
				json.put("Trip No.",jsonTrip.getString("Trip No."));
				json.put("Trip Type",jsonTrip.getString("Trip Type"));
				json.put("Trip Category",jsonTrip.getString("Trip Category"));

				json.put("Route Id",jsonTrip.getString("Route ID"));
				json.put("Vehicle Number",jsonTrip.getString("Vehicle Number"));
				json.put("Make Of Vehicle",jsonTrip.getString("Make of Vehicle"));
				json.put("Type of Vehicle",jsonTrip.getString("Type of Vehicle"));
				json.put("Customer Reference ID",jsonTrip.getString("Customer Reference ID"));
				json.put("Customer Name",jsonTrip.getString("Customer Name"));

				json.put("Leg ID",rs.getString("LEG_NAME"));  
				json.put("Driver 1 Name",rs.getString("DRIVER1"));
				json.put("Driver 1 Contact",rs.getString("DRIVER1_CONTACT"));
				json.put("Driver 2 Name",rs.getString("DRIVER2"));
				json.put("Driver 2 Contact",rs.getString("DRIVER2_CONTACT"));
				json.put("Origin",rs.getString("SOURCE"));
				json.put("Destination",rs.getString("DESTIANTION"));
				json.put("STD",rs.getString("STD").contains("1900")?"":mmddyyy.format(sdfDB.parse(rs.getString("STD"))));
				json.put("ATD",rs.getString("ATD").contains("1900")?"":mmddyyy.format(sdfDB.parse(rs.getString("ATD"))));
				json.put("Departure Delay wrt STD (HH:mm:ss)",(rs.getInt("delayedDepartureATD_STD")!=0)?formattedHoursMinutesSeconds(rs.getInt("delayedDepartureATD_STD")):"");
				//sum of planned Transit time
				sumPlannedTransitTime+=plannedTransitTime;
				json.put("Planned Transit Time (incl. planned stoppages)(HH:mm:ss)",(plannedTransitTime!=0)?formattedHoursMinutesSeconds(plannedTransitTime):"");
				json.put("STA wrt STD",mmddyyy.format(sdfDB.parse(rs.getString("STA"))));
				json.put("STA wrt ATD",getDate(rs.getString("ATD"), plannedTransitTime));
				json.put("ETA",rs.getString("ETA").contains("1900")?"":mmddyyy.format(sdfDB.parse(rs.getString("ETA"))));
				json.put("ATA",rs.getString("ATA").contains("1900")?"":mmddyyy.format(sdfDB.parse(rs.getString("ATA"))));
				// sum of actual transit time
				sumActualTransitTime+=actualTransitTime;
				json.put("Actual Transit Time (incl. planned and unplanned stoppages) (HH:mm:ss)",(actualTransitTime!=0)?formattedHoursMinutesSeconds(actualTransitTime):"");
				// sum of Transit Delay 
				sumTransitDelay+=transitDelay;
				json.put("Transit Delay (HH:mm:ss)",(transitDelay!=0)?formattedHoursMinutesSeconds(transitDelay):"");
				json.put("Trip Status",jsonTrip.getString("Trip Status"));
				if(rs.getString("ATA").contains("1900") || rs.getString("ATD").contains("1900")){
					json.put("Origin Point Stoppage Allowed (HH:mm:ss)"," ");
					json.put("Origin Point Stoppage Actual Duration (HH:mm:ss)"," ");
					json.put("Origin Point Detention (HH:mm:ss)"," ");
					json.put("Destination Point Stoppage Allowed (HH:mm:ss)"," ");
					json.put("Destination Point Stoppage Actual Duration (HH:mm:ss)"," ");
					json.put("Destination Point Detention (HH:mm:ss)"," ");
					json.put("Temp @ Reefer(Actual Temperature at ATA (°C))", "");
					json.put("Temp @ Middle(Actual Temperature at ATA (°C))", "");
					json.put("Temp @ Door(Actual Temperature at ATA (°C))", "");
					json.put("Reefer(GREEN-BAND) - Temp Duration % (% of actual transit time)", "");																																																																																																																																																																																																																																																										
					json.put("Middle(GREEN-BAND) - Temp Duration % (% of actual transit time)", "");																																																																																																																																																																																																																																																												
					json.put("Door(GREEN-BAND) - Temp Duration % (% of actual transit time)", "");																																																																																																																																																																																																																																																												
					json.put("Reefer(YELLOW-BAND) - Temp Duration % (% of actual transit time)", "");																																																																																																																																																																																																																																																												
					json.put("Middle(YELLOW-BAND) - Temp Duration % (% of actual transit time)", "");																																																																																																																																																																																																																																																													
					json.put("Door(YELLOW-BAND) - Temp Duration % (% of actual transit time)", "");
					json.put("Reefer(RED-BAND) - Temp Duration % (% of actual transit time)", "");																																																																																																																																																																																																																																																												
					json.put("Middle(RED-BAND) - Temp Duration % (% of actual transit time)", "");																																																																																																																																																																																																																																																													
					json.put("Door(RED-BAND) - Temp Duration % (% of actual transit time)", "");
				}else{
					json.put("Temp @ Reefer(Actual Temperature at ATA (°C))", rs.getLong("ATA_TEMPA")!=0?rs.getLong("ATA_TEMPA"):"");
					json.put("Temp @ Middle(Actual Temperature at ATA (°C))",  rs.getLong("ATA_TEMPB")!=0?rs.getLong("ATA_TEMPB"):"");
					json.put("Temp @ Door(Actual Temperature at ATA (°C))",  rs.getLong("ATA_TEMPC")!=0?rs.getLong("ATA_TEMPC"):"");
					
					long ATAATD = getDiffinMS(rs.getString("ATA"),rs.getString("ATD"));
					double travelTime=ATAATD/(1000*60);
					
					double gRefer= GR!=0?(GR/travelTime)*100:0;
					double gMiddle=GM!=0?((GM*100)/travelTime):0;
					double gDoor=GD!=0?((GD*100)/travelTime):0;
					double yRefer=YR!=0?((YR*100)/travelTime):0;
					double yMiddle=YM!=0?((YM*100)/travelTime):0;
					double yDoor=YD!=0?((YD*100)/travelTime):0;
					double rRefer=RR!=0?((RR*100)/travelTime):0;
					double rMiddle=RM!=0?((RM*100)/travelTime):0;
					double rDoor=RD!=0?((RD*100)/travelTime):0;

					json.put("Reefer(GREEN-BAND) - Temp Duration % (% of actual transit time)", GM!=0?df2.format(gRefer)+"%":"");																																																																																																																																																																																																																																																									
					json.put("Middle(GREEN-BAND) - Temp Duration % (% of actual transit time)", GD!=0?df2.format(gMiddle)+"%":"");																																																																																																																																																																																																																																																											
					json.put("Door(GREEN-BAND) - Temp Duration % (% of actual transit time)", GR!=0?df2.format(gDoor)+"%":"");																																																																																																																																																																																																																																																											
					json.put("Reefer(YELLOW-BAND) - Temp Duration % (% of actual transit time)", YR!=0?df2.format(yRefer)+"%":"");																																																																																																																																																																																																																																																												
					json.put("Middle(YELLOW-BAND) - Temp Duration % (% of actual transit time)", YM!=0?df2.format(yMiddle)+"%":"");																																																																																																																																																																																																																																																													
					json.put("Door(YELLOW-BAND) - Temp Duration % (% of actual transit time)", YD!=0?df2.format(yDoor)+"%":"");
					json.put("Reefer(RED-BAND) - Temp Duration % (% of actual transit time)",RR!=0?df2.format(rRefer)+"%":"");																																																																																																																																																																																																																																																											
					json.put("Middle(RED-BAND) - Temp Duration % (% of actual transit time)", RM!=0?df2.format(rMiddle)+"%":"");																																																																																																																																																																																																																																																												
					json.put("Door(RED-BAND) - Temp Duration % (% of actual transit time)", RD!=0?df2.format(rDoor)+"%":"");
					long actulaDurationS=0;
					long actulaDurationD=0;
					 if(jsonTrip.has(rs.getString("SOURCE"))){
						 String actDurS= jsonTrip.getString(rs.getString("SOURCE"));
						 actulaDurationS=(actDurS!=null)?Integer.parseInt(actDurS):0;  
					 }
					 if(jsonTrip.has(rs.getString("DESTIANTION"))){
						String actDurD= jsonTrip.getString(rs.getString("DESTIANTION"));
						actulaDurationD=(actDurD!=null)?Integer.parseInt(actDurD):0;  
					 }
					json.put("Origin Point Stoppage Allowed (HH:mm:ss)",(orginDetn!=0)?formattedHoursMinutesSeconds(orginDetn):"");
					json.put("Origin Point Stoppage Actual Duration (HH:mm:ss)",(actulaDurationS!=0)?formattedHoursMinutesSeconds(actulaDurationS):"");
					json.put("Origin Point Detention (HH:mm:ss)",(orginDetn!=0 && actulaDurationS!=0)?formattedHoursMinutesSeconds((actulaDurationS-orginDetn)):"");

					json.put("Destination Point Stoppage Allowed (HH:mm:ss)",(destnDetn!=0)?formattedHoursMinutesSeconds(destnDetn):"");
					json.put("Destination Point Stoppage Actual Duration (HH:mm:ss)",(actulaDurationD!=0)?formattedHoursMinutesSeconds(actulaDurationD):"");
					json.put("Destination Point Detention (HH:mm:ss)",(destnDetn!=0 && actulaDurationD!=0)?formattedHoursMinutesSeconds((actulaDurationD-destnDetn)):"");
				}
				// sum of Unplanned Stopage
				sumUnplannedStoppage+=total_stop_duration;
				json.put("Unplanned Stoppages (HH:mm:ss)",(total_stop_duration!=0)?formattedHoursMinutesSeconds(total_stop_duration):"00:00:00");
				// sum of Total Truck Running
				sumTruckinngRunningTime+=truckinngRunningTime;
				json.put("Total Truck Running Time (HH:mm:ss)",(truckinngRunningTime!=0)?formattedHoursMinutesSeconds(truckinngRunningTime):"");
				//sum of leg distance 
				sumDistance+=distance;
				json.put("Leg Distance (Kms)",(distance!=0)?distance:"");
				json.put("Avg. Speed(Kmph)",rs.getDouble("AVG_SPEED"));
				json.put("LLS Mileage (KMPL)",rs.getDouble("MILEAGE"));
				json.put("OBD Mileage (KMPL)",rs.getDouble("OBD_MILEAGE"));
				json.put("Fuel Consumed(L)",rs.getDouble("FUEL_CONSUMED"));
				for (int j = 1; j < arrayList.size(); j++) {
					try {
						Cell cell = row.createCell(j);
						String format = formatList.get(j);
						String val = json.getString(arrayList.get(j));
						if(val.trim().equalsIgnoreCase("")||val.equalsIgnoreCase("NA")){
							cell.setCellValue(val);
							cell.setCellStyle(blankOrNAStyle);
						}else{
							if(format.equalsIgnoreCase("datetime")){
								if(val.contains("1900")){
									cell.setCellValue(val);
									cell.setCellStyle(defaultStyle);
								}else{
									cell.setCellValue(val);
									cell.setCellStyle(dateCellStyle);
								}
							}
							else if(format.equalsIgnoreCase("Number")){
								boolean numeric=true;
								try {
									//Double num = Double.parseDouble(val);
								} catch (NumberFormatException e) {
									numeric = false;
								}
								double nval=(numeric)?Double.valueOf(val):0;
								cell.setCellValue(nval);
								cell.setCellStyle(decimalStyle);
							}else{
								cell.setCellValue(val);
								cell.setCellStyle(defaultStyle);
							}
						}
					}catch (JSONException e) {
						// e.printStackTrace();
						System.out.println(e.getMessage());
					} catch (Exception e) {
						// TODO: handle exception
					}
				}
			}
			++rowNumber;
			row=sheet.createRow((short)rowNumber);
			for(int jj=0;jj<55;jj++){
				Cell cell=row.createCell(jj);
				cell.setCellStyle(summaryStyle);
			}
			for (int j = 0; j < summationArray.length; j++) {
				try {
					Cell cell = row.createCell(indexArray[j]);
					if(summationArray[j].equals("Planned Transit Time (incl. planned stoppages) (HH:mm:ss)")){
						cell.setCellValue((sumPlannedTransitTime)!=0?formattedHoursMinutesSeconds(sumPlannedTransitTime):"");
						cell.setCellStyle(summaryStyle);
					}
					else if(summationArray[j].equals("Actual Transit Time incl. planned and unplanned stoppages (HH:mm:ss)"))
					{
						cell.setCellValue((sumActualTransitTime)!=0?formattedHoursMinutesSeconds(sumActualTransitTime):"");
						cell.setCellStyle(summaryStyle);
					}
					else if(summationArray[j].equals("Transit Delay (HH:mm:ss)")){
						cell.setCellValue(sumTransitDelay!=0?formattedHoursMinutesSeconds(sumTransitDelay):"");
						cell.setCellStyle(summaryStyle);
					}
					else if(summationArray[j].equals("Unplanned Stoppage (HH:mm:ss)")){
						cell.setCellValue(sumUnplannedStoppage!=0?formattedHoursMinutesSeconds(sumUnplannedStoppage):"");
						cell.setCellStyle(summaryStyle);
					}
					else if(summationArray[j].equals("Total Truck Running Time (HH:mm:ss)"))
					{
						cell.setCellValue(sumTruckinngRunningTime!=0?formattedHoursMinutesSeconds(sumTruckinngRunningTime):"");
						cell.setCellStyle(summaryStyle);
					}
					else if(summationArray[j].equals("Leg Distance (Kms)")){
						cell.setCellValue(sumDistance);
						cell.setCellStyle(summaryStyle);
					}
					else
					{
						String val = jsonTrip.getString(summationArray[j]);
						if(!val.trim().equalsIgnoreCase("")||!val.equalsIgnoreCase("NA")){
							cell.setCellValue(val);
							cell.setCellStyle(summaryStyle);
						}
					}
				}catch (final JSONException e) {
					e.printStackTrace();
				} catch (final Exception e) {
					e.printStackTrace();
				}
			}
			rowNumber++;
		}catch(final Exception e){
			e.printStackTrace();
		}
	}
	public  String formattedHoursMinutesSeconds(long diff) {
		String hhmmssformat="";
		String format="";
		boolean negative=false;
		try {
			diff=(diff*60)*1000;
			if(diff==0){
				return hhmmssformat="";
			}
			long diffSeconds = diff / 1000 % 60;
			long diffMinutes = diff / (60 * 1000) % 60;
			long diffHours = diff / (60 * 60 * 1000);
			hhmmssformat=df1.format(diffHours)+":"+df1.format(diffMinutes)+":"+df1.format(diffSeconds);
			negative = hhmmssformat.contains("-")?true:false;
			format=negative?"-"+hhmmssformat.replaceAll("-", ""):hhmmssformat;
		} catch (final Exception e) {
			System.out.println("hh:mm:ss exception :::::   "+e.getLocalizedMessage());
			e.printStackTrace();
		}
		return format;
	}
	public String getDate(String date,long mins){
		 String newDate ="";
		try {
			if(!date.contains("1900") && mins>0){
				Date d = sdfDB.parse(date); 
				 Calendar cal = Calendar.getInstance();
				 cal.setTime(d);
				 cal.add(Calendar.MINUTE, (int) mins);
				 newDate = sdfDB.format(cal.getTime());
				 newDate=mmddyyy.format(sdfDB.parse(newDate)); 	
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return newDate;
	}
	public long getDiffinMS(String date1,String date2) {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date d1 = null;
		Date d2 = null;
		long diff = 0;
		try {
			d1 = format.parse(date1);
			d2 = format.parse(date2);
			diff = d1.getTime() - d2.getTime();
		} catch (Exception e) {
			System.out.println("hh:mm:ss exception :::::   "+e.getLocalizedMessage());
			e.printStackTrace();
		}
		return diff;
	}
}
