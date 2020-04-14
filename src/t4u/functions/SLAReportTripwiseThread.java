package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Map;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import t4u.beans.SLAReportBean;
import t4u.common.DBConnection;
import t4u.statements.CreateTripStatement;

public class SLAReportTripwiseThread implements Runnable{
	private Connection con;
	private SLAReportBean slaReportBean;
	private JSONObject json;
	private Row row;
	private JSONArray jsonArray;
	private Integer count;
	private Integer systemId;
	private Integer clientId;
	private Map<ArrayList<Integer>,ArrayList<String>> userList;
	private ArrayList<String> arrayList;
	private ArrayList<Integer> userformatList;
	private ArrayList<String> formatList;
	private CellStyle blankOrNAStyle;
	private CellStyle timeCellStyle;
	private CellStyle dateCellStyle;
	private CellStyle integerStyle;
	private CellStyle timecellStyle;
	private CellStyle decimalStyle;
	
	public SLAReportTripwiseThread(Connection con, SLAReportBean slaReportBean, JSONObject json, Row row, JSONArray jsonArray, Integer count,
			Integer systemId,Integer clientId, Map<ArrayList<Integer>, ArrayList<String>> userList, ArrayList<String> arrayList,
			ArrayList<Integer> userformatList, ArrayList<String> formatList, CellStyle blankOrNAStyle, CellStyle timeCellStyle,
			CellStyle dateCellStyle,CellStyle integerStyle, CellStyle timecellStyle, CellStyle decimalStyle) {
		this.con = con;
		this.slaReportBean = slaReportBean;
		this.json = json;
		this.row = row;
		this.jsonArray = jsonArray;
		this.count = count;
		this.systemId = systemId;
		this.clientId = clientId;
		this.userList = userList;
		this.arrayList = arrayList;
		this.userformatList = userformatList;
		this.formatList = formatList;
		this.blankOrNAStyle = blankOrNAStyle;
		this.timeCellStyle = timeCellStyle;
		this.dateCellStyle = dateCellStyle;
		this.integerStyle = integerStyle;
		this.timecellStyle = timecellStyle;
		this.decimalStyle = decimalStyle;
	}
	SimpleDateFormat mmddyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	DecimalFormat df1 = new DecimalFormat("00");
    DecimalFormat df2 = new DecimalFormat("00.00");
    
	public static final String GET_DES_HUB_DETAILS = " select isnull(lz0.PINCODE, '') as srcPincode,isnull(lz100.PINCODE, '') as desPincode, b.OPERATION_ID,a.NAME as touchPointName,a.SEQUENCE,isnull(b.NAME,'') as NAME,isnull(b.HUB_CITY,'') as HUB_CITY,isnull(b.HUB_STATE,'') as HUB_STATE , "+
	" dateadd(mi,330,PLANNED_ARR_DATETIME) as PLANNED_ARR_DATETIME,dateadd(mi,330,isnull(ACT_ARR_DATETIME,'')) as ACT_ARR_DATETIME,dateadd(mi,330,isnull(ACT_DEP_DATETIME,isnull(ACTUAL_TRIP_END_TIME,''))) as ACT_DEP_DATETIME, "+
	" isnull(DETENTION_TIME,'') as DETENTION_TIME ,LEG_ID , isnull(datediff(mi,PLANNED_ARR_DATETIME,ACT_ARR_DATETIME),0)  as PLACEMENTDELAY, "+
	" isnull(datediff(mi,ACT_ARR_DATETIME,ACT_DEP_DATETIME),0)  as DEPARTUREDELAY "+
	" from AMS.dbo.DES_TRIP_DETAILS (nolock) a "+
	" LEFT OUTER join AMS.dbo.LOCATION_ZONE_A b on a.HUB_ID=b.HUBID "+
	" left outer join LOCATION_ZONE_A lz0 ON lz0.HUBID=a.HUB_ID "+
	" left outer join LOCATION_ZONE_A lz100 ON lz100.HUBID=a.HUB_ID "+
	" left outer join TRACK_TRIP_DETAILS (nolock) td on td.TRIP_ID= a.TRIP_ID "+
	" WHERE a.TRIP_ID=? "+
	" order by SEQUENCE ";
	
	public static final String GET_DRIVER_DETAILS = "select DRIVER_X from  AMS.dbo.TRIP_LEG_DETAILS  WHERE TRIP_ID=? AND DRIVER_X !=0  ORDER BY ID";
	
	public static final String GET_DRIVER_NAME = "select isnull(Fullname,'') as DRIVER_NAME,Mobile from Driver_Master where Driver_id=?  AND System_id = ?";
	
	public void run() {
		try{
			if(con == null){
				con = DBConnection.getConnectionToDB("AMS");
			}
			
			json = new JSONObject();
			json.put("tripId", slaReportBean.getTripId());
			json.put("Sl. No.", count);
			json.put("Trip Creation Time", 	mmddyyy.format(sdfDB.parse(slaReportBean.getTripCreateTime())));
			json.put("Trip Creation Month", new SimpleDateFormat("MMMM").format(sdfDB.parse(slaReportBean.getTripCreateTime())));
			json.put("Trip ID", slaReportBean.getShipmentId());
			json.put("Trip No.", slaReportBean.getOrderId());
			json.put("Trip Type", slaReportBean.getProductLine());
			json.put("Trip Category", slaReportBean.getTripCategoty());
			json.put("Route ID", slaReportBean.getRouteKey());
			json.put("Make of Vehicle", slaReportBean.getModelName());
			json.put("Type of Vehicle", slaReportBean.getVehicleType());
			json.put("Vehicle Number", slaReportBean.getAssetNumber());
			json.put("Customer Type", (slaReportBean.getCustomerType() !=null ) ? slaReportBean.getCustomerType() : "");
			json.put("Customer Name", slaReportBean.getCustomerName());
			json.put("Customer Reference ID", slaReportBean.getCustomerRefId());

			getDriverName(systemId, clientId, slaReportBean.getTripId(),json);

			if(slaReportBean.getStatus().equalsIgnoreCase("OPEN")){
				json.put("Location", slaReportBean.getCurrentLocation());
				json.put("ETA", mmddyyy.format(sdfDB.parse(slaReportBean.getDesinationETA()))); 
				json.put("Next touching point", slaReportBean.getNextPoint());
				json.put("Distance to next touching point", slaReportBean.getNextPointDistance());
				json.put("ETA to next touching point",slaReportBean.getNextPointETA().contains("1900")? "" : mmddyyy.format(sdfDB.parse(slaReportBean.getNextPointETA()))); 
				json.put("Total Truck Running Time (HH:mm:ss)", "");
				json.put("Transit Delay (HH:mm:ss)", getFormattedHoursMinutes(slaReportBean.getDesinationETA(), slaReportBean.getStawrtATD()));
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
				json.put("Location", slaReportBean.getEndLocation());
				json.put("ETA", "");
				json.put("Next touching point", "");
				json.put("Distance to next touching point", "");
				json.put("ETA to next touching point", "");
				json.put("Temp @ Reefer(Actual Temperature at ATA (°C))",slaReportBean.getAtaTempA() !=0 ? slaReportBean.getAtaTempA() : "");
				json.put("Temp @ Middle(Actual Temperature at ATA (°C))",slaReportBean.getAtaTempB() != 0 ? slaReportBean.getAtaTempB() : "");
				json.put("Temp @ Door(Actual Temperature at ATA (°C))",slaReportBean.getAtaTempA() != 0 ? slaReportBean.getAtaTempA() : "");
				
			}
			json.put("Route Key", slaReportBean.getRouteKey());
			
			getSeqDetails(slaReportBean.getTripId(), json, slaReportBean.getActualTripstartTime(),slaReportBean.getPlannedduration(),
					slaReportBean.getStoppageDuration(),slaReportBean.getStatus(),slaReportBean.getOriginCity(),slaReportBean.getDestinationCity(),
					slaReportBean.getGr(),slaReportBean.getGm(),slaReportBean.getGd(),slaReportBean.getYr(),slaReportBean.getYm(),slaReportBean.getYd(),
					slaReportBean.getRr(),slaReportBean.getRm(),slaReportBean.getRd(),slaReportBean.getTravelTime());

				json.put("STD", mmddyyy.format(sdfDB.parse(slaReportBean.getActualTripstartTime())));
				if(slaReportBean.getStawrtSTD() != null){
					json.put("STA wrt STD", mmddyyy.format(sdfDB.parse(slaReportBean.getStawrtSTD())));
				}else{
					json.put("STA wrt STD", "");
				}
				if(slaReportBean.getActualTripstartTime().contains("1900")){
					json.put("ATD", "");
					json.put("Departure Delay wrt STD (HH:mm:ss)", "");
				}else{
					json.put("ATD", mmddyyy.format(sdfDB.parse(slaReportBean.getActualTripstartTime())));	
					json.put("Departure Delay wrt STD (HH:mm:ss)", getFormattedHoursMinutes(slaReportBean.getActualTripstartTime(), slaReportBean.getActualTripstartTime()));
				}
				json.put("STA wrt ATD", mmddyyy.format(sdfDB.parse(slaReportBean.getStawrtATD())));
				json.put("Planned Transit Time (incl. planned stoppages) (HH:mm:ss)", formattedHoursMinutesSeconds(slaReportBean.getTat()));
				json.put("Trip Close/Canceled Time", (slaReportBean.getCancelledDate() == "" || (slaReportBean.getCancelledDate().contains("1900")))
						? "" : mmddyyy.format(sdfDB.parse(slaReportBean.getCancelledDate())));
				json.put("Trip Status", slaReportBean.getStatus()+"-"+slaReportBean.getTripStatus());
				json.put("Reason for Delay", slaReportBean.getReasonForDelay());
				json.put("Reason for Cancellation", slaReportBean.getReasonForCancellation());	
				json.put("Ops Dry Run (kms)", slaReportBean.getOpsDryRun());
				json.put("Customer Dry Run (kms)", slaReportBean.getCustomerDryRun());
				json.put("Trip Distance (kms)", slaReportBean.getActualDistance());
				json.put("Total Distance (kms)",slaReportBean.getOpsDryRun()+slaReportBean.getCustomerDryRun()+slaReportBean.getActualDistance());
				json.put("Average Speed (kms/h)", slaReportBean.getAvgSpeed());
				json.put("Fuel Consumed(L)", slaReportBean.getFuelConsumed());
				json.put("LLS Mileage (kms/L)", slaReportBean.getLlsMileage());
				json.put("OBD Mileage (kms/L)", slaReportBean.getObdMileage());
				json.put("Temperature required", getTemperaturerequired(slaReportBean.getTripId(), slaReportBean.getAssetNumber()));
				json.put("Precooling  Setup Time", (slaReportBean.getPreCoolingSetUpTime() == "" || slaReportBean.getPreCoolingSetUpTime().contains("1900"))
						? "" : mmddyyy.format(sdfDB.parse(slaReportBean.getPreCoolingSetUpTime())));
				json.put("Precooling Achieved Time", (slaReportBean.getPreCoolingAchievedTime() == "" || slaReportBean.getPreCoolingAchievedTime().contains("1900"))
						? "" : mmddyyy.format(sdfDB.parse(slaReportBean.getPreCoolingAchievedTime())));
				json.put("Time to Achieve Precooling (HH:mm:ss)", slaReportBean.getTimeTakenToPreCool() > 0 ? formattedHoursMinutesSeconds(slaReportBean.getTimeTakenToPreCool()):"");
				int colno=0;//toMap(row,json);
				if(userList!=null){
					for (int i = 0; i < arrayList.size(); i++) {
						try {
							int visbilble=userformatList.get(i);
							if(visbilble==0){
								continue;
							}else{
								//++colno;
								Cell cell = row.createCell(colno++);
								String format = formatList.get(i);
								String val = json.getString(arrayList.get(i)).trim();
								val=(val==null)?"":val;
								if(val.equalsIgnoreCase("")||val.equalsIgnoreCase("NA")){
									cell.setCellValue(val);
									cell.setCellStyle(blankOrNAStyle);
								}
								else
								{
									if(format.equalsIgnoreCase("datetime")){
										if(val.contains("1900")){
											cell.setCellValue(val);
											cell.setCellStyle(timeCellStyle);
										}else{
											cell.setCellValue(val);
											//cell.setCellValue(mmddyyy.parse(val));
											cell.setCellStyle(dateCellStyle);
										}

									}else if(format.equalsIgnoreCase("int")){
										cell.setCellValue(Integer.valueOf(val));
										cell.setCellStyle(integerStyle);
									}  else if(format.equalsIgnoreCase("timeformat")){
										cell.setCellValue(val);
										cell.setCellStyle(timecellStyle);
									}
									else if(format.equalsIgnoreCase("default")){
										cell.setCellValue(val);
										cell.setCellStyle(timeCellStyle);
									}else{
										boolean numeric=true;
										try {
											//Double num = Double.parseDouble(val);
										} catch (NumberFormatException e) {
											numeric = false;
										}
										double nval=(numeric)?Double.valueOf(val):0;
										cell.setCellValue(nval);
										cell.setCellStyle(decimalStyle);

									}
								}
							}
						}catch (JSONException e) {
							// e.printStackTrace();
						} catch (Exception e) {
							// TODO: handle exception
						}
					}
				}else{
					for (int i = 0; i < arrayList.size(); i++) {
						try {
							Cell cell = row.createCell(i);
							String format = formatList.get(i);
							String val = json.getString(arrayList.get(i)).trim();
							val=(val==null)?"":val;
							if(val.equalsIgnoreCase("")||val.equalsIgnoreCase("NA")){
								cell.setCellValue(val);
								cell.setCellStyle(blankOrNAStyle);
							}else{
								if(format.equalsIgnoreCase("datetime")){
									if(val.contains("1900")){
										cell.setCellValue(val);
										cell.setCellStyle(timeCellStyle);
									}else{
										cell.setCellValue(val);
										cell.setCellStyle(dateCellStyle);
									}

								}else if(format.equalsIgnoreCase("int")){
									cell.setCellValue(Integer.valueOf(val));
									cell.setCellStyle(integerStyle);
								} else if(format.equalsIgnoreCase("timeformat")){
									cell.setCellValue(val);
									cell.setCellStyle(timecellStyle);
								}
								else if(format.equalsIgnoreCase("default")){
									cell.setCellValue(val);
									cell.setCellStyle(timeCellStyle);
								}else{
									boolean numeric=true;
									try {
										//Double num = Double.parseDouble(val);
									} catch (NumberFormatException e) {
										numeric = false;
									}
									double nval=(numeric)?Double.valueOf(val):0;
									cell.setCellValue(nval);
									cell.setCellStyle(decimalStyle);
								}
							}
						}catch (JSONException e) {
							e.printStackTrace();
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}
				jsonArray.put(json);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public JSONObject getDriverName(int systemId,int customerId,int tripId, JSONObject json){
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		int evenCounter = 0;
		int oddCounter = 0;
		ArrayList<String> list=new ArrayList<String>();
		JSONArray driver1 = new JSONArray();
		JSONArray driver2 = new JSONArray();
		JSONObject obj = null;
		try {
			if(con == null){
				con = DBConnection.getConnectionToDB("AMS");
			}
			for (int j =1; j <= 2; j++ ) {
			pstmt=con.prepareStatement(GET_DRIVER_DETAILS.replaceAll("X", String.valueOf(j)));
			pstmt.setInt(1, tripId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				if (j==1){
				 obj = new JSONObject();
				 list =	 getDriverDetails(con,rs.getInt("DRIVER_1"), String.valueOf(systemId));
				 obj.put("name",  list.get(0));
				 obj.put("mobile", list.get(1));
				 driver1.put(obj);				 
				}else{
					obj = new JSONObject();
					 list =	 getDriverDetails(con,rs.getInt("DRIVER_2"), String.valueOf(systemId));
					 obj.put("name",  list.get(0));
					 obj.put("mobile", list.get(1));
					 driver2.put(obj);	
				}
			 }
			}
			for (int s=1; s<7; s++){
				if (s%2==0){
					JSONObject object = null;
					try{
						object = driver2.getJSONObject(evenCounter);
					}catch (Exception e) {
						//e.printStackTrace();
					}
					json.put("Driver "+s+" Name", object!=null?object.getString("name"):"");
					json.put("Driver "+s+" Contact", object!=null?object.getString("mobile"):"");
					evenCounter++;
				}else{
					JSONObject object = null;
					try{
						object = driver1.getJSONObject(oddCounter);
					}catch (Exception e) {
						//e.printStackTrace();
					}
					json.put("Driver "+s+" Name", object!=null?object.getString("name"):"");
					json.put("Driver "+s+" Contact", object!=null?object.getString("mobile"):"");
					oddCounter++;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return json;
	}
	public  String getFormattedHoursMinutes(String date1,String date2) {
		String hhmmssformat="";
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date d1 = null;
		Date d2 = null;
		String Timeformat="";
		boolean negative=false;
		try {
			d1 = format.parse(date1);
			d2 = format.parse(date2);

			//in milliseconds
			long diff = d1.getTime() - d2.getTime();
			long diffSeconds = diff / 1000 % 60;
			long diffMinutes = diff / (60 * 1000) % 60;
			long diffHours = diff / (60 * 60 * 1000);
			hhmmssformat=df1.format(diffHours)+":"+df1.format(diffMinutes)+":"+df1.format(diffSeconds);
			negative = hhmmssformat.contains("-")?true:false;
			Timeformat=negative?"-"+hhmmssformat.replaceAll("-", ""):hhmmssformat;
		} catch (Exception e) {
			e.printStackTrace();

		}
		return Timeformat;
	}
	public JSONObject getSeqDetails(int tripId, JSONObject json ,String ATD, long plannedDuration,long totalStoppage,
			String tripStatus,String orginCity,String destCity,long GR,long GM,long GD,long YR,long YM,long YD,long RR,long RM,long RD,double travelTime){
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		int customerDetentionsInMs=0;
		int dhlDetentionsInMs=0;
		int customerActualStoppageInMs=0;
		int dhlActualStoppageInMs=0;
		try {
			if(con == null){
				con = DBConnection.getConnectionToDB("AMS");
			}
			pstmt=con.prepareStatement(GET_DES_HUB_DETAILS);
			pstmt.setInt(1, tripId);
			rs=pstmt.executeQuery();
			String STP=null;
			String ATP=null;
			int touchpointCount=0;
			String ATA="1900";
			long actualPlanedn=0;
			while(rs.next()){
				int seqNo=rs.getInt("SEQUENCE");
				json.put(rs.getString("NAME"), rs.getLong("DEPARTUREDELAY"));
				if(seqNo==0){
					long originDetn=rs.getLong("DETENTION_TIME");
					json.put("Origin Hub", rs.getString("touchPointName"));
					json.put("Origin City", orginCity.equalsIgnoreCase("")?rs.getString("HUB_CITY"):orginCity);
					json.put("Source Pincode", rs.getString("srcPincode"));
					json.put("Origin State", rs.getString("HUB_STATE"));

					STP=rs.getString("PLANNED_ARR_DATETIME");
					if(STP.contains("1900")){
						json.put("STP","" );
					}else{
						json.put("STP",mmddyyy.format(sdfDB.parse(STP)));
					}

					ATP=rs.getString("ACT_ARR_DATETIME");
					if(ATP.contains("1900")){
						json.put("ATP","");
					}else{
						json.put("ATP",mmddyyy.format(sdfDB.parse(ATP)));
					}

					if(ATP!=null && ATP!=null){
						long placementDelay=rs.getLong("PLACEMENTDELAY");
						if(placementDelay!=0){
							json.put("Placement Delay (HH:mm:ss)",formattedHoursMinutesSeconds(placementDelay));
						}else{
							json.put("Placement Delay (HH:mm:ss)","");
						}

					}else{
						json.put("Placement Delay (HH:mm:ss)","");
					}


					json.put("Origin Hub Stoppage Allowed (HH:mm:ss)",(originDetn>0)?formattedHoursMinutesSeconds(originDetn):"");
					if(ATD.contains("1900") && ATP!=null){
						json.put("Origin Hub Stoppage Actual Duration (HH:mm:ss)","");
						json.put("Origin Hub (Loading) Detention (HH:mm:ss)","");
					}else{
						json.put("Origin Hub Stoppage Actual Duration (HH:mm:ss)",getFormattedHoursMinutes(ATD, ATP));
						long diff1 = getDiffinMS(ATD, ATP);
						long diff2=originDetn*60*1000;
						long difference = diff1 - diff2;
						long diffSeconds = difference / 1000 % 60;
						long diffMinutes = difference / (60 * 1000) % 60;
						long diffHours = difference / (60 * 60 * 1000);
						String hhmmssformat=df1.format(diffHours)+":"+df1.format(diffMinutes)+":"+df1.format(diffSeconds);
						boolean negative = hhmmssformat.contains("-")?true:false;
						String Timeformat=negative?"-"+hhmmssformat.replaceAll("-", ""):hhmmssformat;

						json.put("Origin Hub (Loading) Detention (HH:mm:ss)",Timeformat);
					}


				}
				if(seqNo==100){
					ATA=rs.getString("ACT_ARR_DATETIME");
					long DesignDetn=rs.getLong("DETENTION_TIME");
					String departureDatetime=rs.getString("ACT_DEP_DATETIME");

					// System.out.println("name :::::::  "+rs.getString("NAME"));
					json.put("Destination Hub", (rs.getString("touchPointName")!=null)?rs.getString("touchPointName"):"");
					//json.put("Destination City", (rs.getString("HUB_CITY")!=null)?rs.getString("HUB_CITY"):"");
					json.put("Destination City", destCity.equalsIgnoreCase("")?rs.getString("HUB_CITY"):destCity);
					json.put("Destination Pincode", rs.getString("desPincode"));
					json.put("Destination State", (rs.getString("HUB_STATE")!=null)?rs.getString("HUB_STATE"):"");


					json.put("Destination Hub Stoppage Allowed (HH:mm:ss)",(DesignDetn>0)?formattedHoursMinutesSeconds(DesignDetn):"");
					if(departureDatetime.contains("1900") || ATA.contains("1900")){
						json.put("Destination Hub Stoppage Actual Duration (HH:mm:ss)", "");
						json.put("Destination Hub (Unloading) Detention (HH:mm:ss)", "");	
					}else{

						String actualDuration=getFormattedHoursMinutes(departureDatetime, ATA);
						/*
						SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss");
						Date date1 = format.parse(actualDuration);
						Date date2 = format.parse(formattedHoursMinutesSeconds(DesignDetn));*/
						long difference = getDiffinMS(departureDatetime, ATA) - (DesignDetn*60*1000);
						long diffSeconds = difference / 1000 % 60;
						long diffMinutes = difference / (60 * 1000) % 60;
						long diffHours = difference / (60 * 60 * 1000);
						String hhmmssformat=df1.format(diffHours)+":"+df1.format(diffMinutes)+":"+df1.format(diffSeconds);
						boolean negative = hhmmssformat.contains("-")?true:false;
						String Timeformat=negative?"-"+hhmmssformat.replaceAll("-", ""):hhmmssformat;

						json.put("Destination Hub Stoppage Actual Duration (HH:mm:ss)", actualDuration);
						json.put("Destination Hub (Unloading) Detention (HH:mm:ss)", Timeformat);	
					}


					if(ATA.contains("1900") || ATD.contains("1900")){
						json.put("ATA", "");
						json.put("Actual Transit Time incl. planned and unplanned stoppages (HH:mm:ss)", "");
						if(!tripStatus.equalsIgnoreCase("OPEN")){
							json.put("Transit Delay (HH:mm:ss)", "");
						}
					}else{
						String actualTransit=getFormattedHoursMinutes(ATA, ATD);
						json.put("ATA", mmddyyy.format(sdfDB.parse(ATA)));
						json.put("Actual Transit Time incl. planned and unplanned stoppages (HH:mm:ss)", actualTransit);

						long diff2 = (plannedDuration*60*1000);  //planned diff
						long diff1 = getDiffinMS(ATA, ATD); //actualTransit diff
						long difference = diff1 - diff2;
						long diffSeconds = difference / 1000 % 60;
						long diffMinutes = difference / (60 * 1000) % 60;
						long diffHours = difference / (60 * 60 * 1000);
						String hhmmssformat=df1.format(diffHours)+":"+df1.format(diffMinutes)+":"+df1.format(diffSeconds);
						boolean negative = hhmmssformat.contains("-")?true:false;
						String Timeformat=negative?"-"+hhmmssformat.replaceAll("-", ""):hhmmssformat;
						
						if(!tripStatus.equalsIgnoreCase("OPEN")){
							json.put("Transit Delay (HH:mm:ss)", (plannedDuration>0)?Timeformat:"");
						}
						
					}
				}

				if(seqNo!=0 && seqNo!=100){
					++touchpointCount;
					long detention = rs.getLong("DETENTION_TIME");
					long departuredelay=rs.getLong("DEPARTUREDELAY");
					actualPlanedn+=departuredelay;        // total planned stoppage 
					if(rs.getInt("OPERATION_ID")==32){
						customerDetentionsInMs+=rs.getInt("DETENTION_TIME");
						customerActualStoppageInMs+=rs.getInt("DEPARTUREDELAY");



					}else if(rs.getInt("OPERATION_ID")==33){
						dhlDetentionsInMs+=rs.getInt("DETENTION_TIME");
						dhlActualStoppageInMs+=rs.getInt("DEPARTUREDELAY");

					}


					json.put("Touching Point "+touchpointCount+"", rs.getString("touchPointName"));
					json.put("Touching Point "+touchpointCount+" Stoppage Allowed (HH:mm:ss)", formattedHoursMinutesSeconds(detention));
					if(departuredelay>0){


						json.put("Touching Point "+touchpointCount+" Stoppage Actual Duration (HH:mm:ss)", formattedHoursMinutesSeconds(departuredelay));
						long difference =  (departuredelay*60*1000) - (detention*60*1000);
						long diffSeconds = difference / 1000 % 60;
						long diffMinutes = difference / (60 * 1000) % 60;
						long diffHours = difference / (60 * 60 * 1000);
						//String hhmmssformat=diffHours+":"+diffMinutes+":"+diffSeconds;
						String hhmmssformat=df1.format(diffHours)+":"+df1.format(diffMinutes)+":"+df1.format(diffSeconds);
						boolean negative = hhmmssformat.contains("-")?true:false;
						String Timeformat=negative?"-"+hhmmssformat.replaceAll("-", ""):hhmmssformat;

						json.put("Touching Point "+touchpointCount+" Detention (HH:mm:ss)", Timeformat);
						
					}else{
						json.put("Touching Point "+touchpointCount+" Stoppage Actual Duration (HH:mm:ss)", "");
						json.put("Touching Point "+touchpointCount+" Detention (HH:mm:ss)", "");

					}

				}
			}
			touchpointCount++;
			for (int i = touchpointCount; i < 8; i++) {
				json.put("Touching Point "+i+"", "");
				json.put("Touching Point "+i+" Stoppage Allowed (HH:mm:ss)", "");
				json.put("Touching Point "+i+" Stoppage Actual Duration (HH:mm:ss)", "");
				json.put("Touching Point "+i+" Detention (HH:mm:ss)", "");
			}

			json.put("Total In-transit Planned Customer Hub Stoppage Allowed (HH:mm:ss)", formattedHoursMinutesSeconds(customerDetentionsInMs));
			json.put("Total In-transit Planned Customer Hub Stoppage Actual Duration (HH:mm:ss)",formattedHoursMinutesSeconds(customerActualStoppageInMs));
			long difference =  (customerActualStoppageInMs*60*1000) - (customerDetentionsInMs*60*1000);
			long diffSeconds = difference / 1000 % 60;
			long diffMinutes = difference / (60 * 1000) % 60;
			long diffHours = difference / (60 * 60 * 1000);
			String hhmmssformat=df1.format(diffHours)+":"+df1.format(diffMinutes)+":"+df1.format(diffSeconds);
			boolean negative = hhmmssformat.contains("-")?true:false;
			String Timeformat=negative?"-"+hhmmssformat.replaceAll("-", ""):hhmmssformat;

			json.put("Total In-transit Planned Customer Hub Stoppage Detention (HH:mm:ss)", Timeformat);
			json.put("Total In-transit Planned SmartHub Stoppage Allowed (HH:mm:ss)", formattedHoursMinutesSeconds(dhlDetentionsInMs));
			json.put("Total In-transit Planned SmartHub Stoppage Actual Duration (HH:mm:ss)", formattedHoursMinutesSeconds(dhlActualStoppageInMs));
			long difference1 =  (dhlActualStoppageInMs*60*1000) - (dhlDetentionsInMs*60*1000);
			long diffSeconds1 = difference1 / 1000 % 60;
			long diffMinutes1 = difference1 / (60 * 1000) % 60;
			long diffHours1 = difference1 / (60 * 60 * 1000);
			String hhmmssformat1=df1.format(diffHours1)+":"+df1.format(diffMinutes1)+":"+df1.format(diffSeconds1);
			boolean negative1 = hhmmssformat1.contains("-")?true:false;
			String Timeformat1=negative1?"-"+hhmmssformat1.replaceAll("-", ""):hhmmssformat1;
			json.put("Total In-transit Planned SmartHub Stoppage Detention (HH:mm:ss)", Timeformat1);
			
			if((totalStoppage-actualPlanedn)>0){
				json.put("Unplanned Stoppage (HH:mm:ss)", formattedHoursMinutesSeconds(totalStoppage-actualPlanedn));
			}else{
				json.put("Unplanned Stoppage (HH:mm:ss)", "00:00:00");
			}
			if(!tripStatus.equalsIgnoreCase("OPEN")){
				if(travelTime>0){
					double gRefer= GR!=0?(GR*100/travelTime):0;
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
				}else{
					json.put("Reefer(GREEN-BAND) - Temp Duration % (% of actual transit time)", "");																																																																																																																																																																																																																																																										
					json.put("Middle(GREEN-BAND) - Temp Duration % (% of actual transit time)", "");																																																																																																																																																																																																																																																												
					json.put("Door(GREEN-BAND) - Temp Duration % (% of actual transit time)", "");																																																																																																																																																																																																																																																												
					json.put("Reefer(YELLOW-BAND) - Temp Duration % (% of actual transit time)", "");																																																																																																																																																																																																																																																												
					json.put("Middle(YELLOW-BAND) - Temp Duration % (% of actual transit time)", "");																																																																																																																																																																																																																																																													
					json.put("Door(YELLOW-BAND) - Temp Duration % (% of actual transit time)", "");
					json.put("Reefer(RED-BAND) - Temp Duration % (% of actual transit time)", "");																																																																																																																																																																																																																																																												
					json.put("Middle(RED-BAND) - Temp Duration % (% of actual transit time)", "");																																																																																																																																																																																																																																																													
					json.put("Door(RED-BAND) - Temp Duration % (% of actual transit time)", "");
				
					if(ATA.contains("1900") || ATD.contains("1900") || (ATD==null)){
						json.put("Total Truck Running Time (HH:mm:ss)", "");
					}else{
						long ATAATD = getDiffinMS(ATA,ATD);
						//long ATAATD=(diff1/60)/1000;
						long difference2 =  ATAATD - ((totalStoppage*60*1000));
						long diffSeconds2 = difference2 / 1000 % 60;
						long diffMinutes2 = difference2 / (60 * 1000) % 60;
						long diffHours2 = difference2 / (60 * 60 * 1000);
						//String hhmmssformat2=diffHours2+":"+diffMinutes2+":"+diffSeconds2;
						String hhmmssformat2=df1.format(diffHours2)+":"+df1.format(diffMinutes2)+":"+df1.format(diffSeconds2);
						boolean negative2 = hhmmssformat2.contains("-")?true:false;
						if(negative2){
							json.put("Total Truck Running Time (HH:mm:ss)", "");
						}else{
							String Timeformat2=negative2?"-"+hhmmssformat2.replaceAll("-", ""):hhmmssformat2;
							json.put("Total Truck Running Time (HH:mm:ss)", Timeformat2);
						}
					}
				}
			} 
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return json;
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
			} catch (Exception e) {
				e.printStackTrace();

			}
			return format;
		}
		public String  getTemperaturerequired(int tripId,String vehicleNo){
			PreparedStatement pstmt1 =null;
			ResultSet rs1=null;
			String tblData = "";
			try {
				if(con == null){
					con = DBConnection.getConnectionToDB("AMS");
				}
				pstmt1 = con.prepareStatement(CreateTripStatement.GET_TRIP_VEHICLE_TEMPERATURE_DETAILS);
				pstmt1.setInt(1, tripId);
				pstmt1.setString(2, vehicleNo);
				rs1 = pstmt1.executeQuery();
				if(rs1.next()){
					double negativeMaxTemp=rs1.getDouble("MAX_NEGATIVE_TEMP");
					double negativeMinTemp=rs1.getDouble("MIN_NEGATIVE_TEMP");
					double positiveMaxTemp=rs1.getDouble("MAX_POSITIVE_TEMP");
					double positiveMinTemp=rs1.getDouble("MIN_POSITIVE_TEMP");
					double positiveMaxTemp2=positiveMaxTemp;//+1;
					double negativeMinTemp2=negativeMinTemp;//-1;
					//tblData="Green band: "+negativeMaxTemp+" to "+positiveMinTemp+" Yellow band: "+positiveMinTemp+" to "+positiveMaxTemp+" , "+positiveMinTemp+" to "+positiveMaxTemp+" Red band: "+negativeMinTemp2+"; "+positiveMaxTemp2+" ";
					tblData = "GREEN :"+negativeMaxTemp+" to "+positiveMinTemp+" YELLOW band:"+negativeMinTemp+" to "+negativeMaxTemp+"; "+positiveMinTemp+" to "+positiveMaxTemp+" RED band : -70 to "+negativeMinTemp2+"; "+positiveMaxTemp2+" to 70";
				}

			} catch (Exception e) {
				e.printStackTrace();
			}finally{
				DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			}
			return tblData;
		}
		public   long getDiffinMS(String date1,String date2) {
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date d1 = null;
			Date d2 = null;
			long diff = 0;
			try {
				d1 = format.parse(date1);
				d2 = format.parse(date2);
				//	diff = d2.getTime() - d1.getTime();
				diff = d1.getTime() - d2.getTime();
			} catch (Exception e) {
				e.printStackTrace();
			}
			return diff;
		}
		private ArrayList<String> getDriverDetails(Connection con, int driverId,String systemId) throws SQLException {
			ArrayList<String> driverDetails = new ArrayList<String>();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			if(con == null){
				con = DBConnection.getConnectionToDB("AMS");
			}
			pstmt = con.prepareStatement(GET_DRIVER_NAME);
			pstmt.setInt(1, driverId);
			pstmt.setString(2, systemId);
			rs = pstmt.executeQuery();
			if(rs.next()){
				driverDetails.add(rs.getString("DRIVER_NAME"));
				driverDetails.add(rs.getString("Mobile"));
			}
			return driverDetails;
		}
}
