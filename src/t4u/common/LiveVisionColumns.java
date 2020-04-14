package t4u.common;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import t4u.functions.CommonFunctions;
import t4u.statements.MapViewStatements;

/**
 * @author amithn
 *
 */
public class LiveVisionColumns {
	
	private ArrayList<String> listOfIds=null;
	private StringBuilder filterList=null;
	String getLanuage="LANG_ENGLISH";
	
//******************for IDs********************************************************************************
	
	
	
	
	public ArrayList<String> getListOfIds() {
		return listOfIds;
	}

	public StringBuilder getFilterList() {
		return filterList;
	}

	public void setFilterList(StringBuilder filterList) {
		this.filterList = filterList;
	}

	public void setListOfIds(ArrayList<String> listOfIds) {
		this.listOfIds = listOfIds;
	}

	private StringBuffer gridHeaderBuffer = new StringBuffer();
			
	
	
//**********************Column Names Vertical wise for ListView*************************************************************	
		
	public StringBuffer getGridHeaderBuffer(int processId,String language,boolean checkFDAS,int systemid, int clientid, int userId)
	{
		Connection con = null;
		PreparedStatement pstmt = null,pstmt1= null;
		ResultSet rs = null, rs1 = null;
		CommonFunctions cf = new CommonFunctions();
		
		
		ArrayList<String> dataindexList = new ArrayList<String>();
		try {
			if(language.equals("ar"))
			{
				getLanuage="LANG_ARABIC";
			}
		  con = DBConnection.getConnectionToDB("AMS");
		  
		  pstmt1=con.prepareStatement(MapViewStatements.LIVE_VISION_FILTER_DATA_CHECK_BEFORE_DELETION);
		  pstmt1.setInt(1,systemid);
		  pstmt1.setInt(2,clientid);
		  pstmt1.setInt(3,userId);
		  rs1=pstmt1.executeQuery();
		  if(rs1.next()){
			 pstmt = con.prepareStatement(MapViewStatements.GET_HEADERS_FROM_USER_SETTING);
			 pstmt.setInt(1,systemid);
			 pstmt.setInt(2,clientid);
			 pstmt.setInt(3,userId);
		  }else{
			  pstmt=con.prepareStatement(MapViewStatements.LIVE_VISION_HEADERS);
			  pstmt.setInt(1, processId);
		  }
		  rs=pstmt.executeQuery(); 
		  String UnitofMeasure=cf.getUnitOfMeasure(systemid);
		 
		  while(rs.next())
		  {
			 
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Vehicle_No"))
		  {
		  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>', dataIndex: 'vehiclenoindex',width:100,filter: {type:'string'}},");
		  dataindexList.add("vehiclenoindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Date_Time"))
		  {
		  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>', dataIndex: 'datetimeindex',renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),width: 150,filter: {type: 'date'}},");
		  dataindexList.add("datetimeindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Location"))
		  {
		  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>', dataIndex: 'locationindex', width: 400, filter: { type: 'string' }},");
		  dataindexList.add("locationindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Ignition"))
		  {
		  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>', dataIndex: 'ignitionindex', width: 70, filter: { type: 'string' }},");
		  dataindexList.add("ignitionindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Speed"))
		  {
		  gridHeaderBuffer.append("{dataIndex: 'speedindex', header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"("+UnitofMeasure+"/hr)</span>', width: 100, filter: { type: 'numeric' }},");
		  dataindexList.add("speedindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("STOPPAGE_TIME_ALERT"))
		  {
		  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>', dataIndex: 'stoppagetimeindex', renderer: Ext.util.Format.numberRenderer('0.00'),  width: 150, filter: { type: 'numeric'  }},");
		  dataindexList.add("stoppagetimeindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Status"))
		  {
		  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'statusindex',width: 100,filter: { type: 'string' }},");
		  dataindexList.add("statusindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Driver_Name"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'drivernameindex',width: 200,filter: { type: 'string' }},");
			  dataindexList.add("drivernameindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Door_Status"))
		  {
		 gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'doorstatusindex', width: 100,filter: { type: 'string' }},");
		 dataindexList.add("doorstatusindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Vehicle_Group"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'vehiclegroupindex',width: 200,filter: { type: 'string' }},");
			  dataindexList.add("vehiclegroupindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Remarks"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'remarksindex',width: 200,filter: { type: 'string' }},");
			  dataindexList.add("remarksindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Vehicle_Model"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'vehiclemodelindex',width: 200,filter: { type: 'string' }},");
			  dataindexList.add("vehiclemodelindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Customer_Name"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'customernameindex',width: 150,filter: { type: 'string' }},");
			  dataindexList.add("customernameindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Border_Status"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'borderstatusindex',width:250,filter: { type: 'string' }},");
			  dataindexList.add("borderstatusindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("IDLETIME_ALERT"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'idletimeindex', renderer: Ext.util.Format.numberRenderer('0.00'), width:70,filter: { type: 'numeric' }},");
			  dataindexList.add("idletimeindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Owner_Name"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'ownernameindex',width:120,filter: { type: 'string' }},");
			  dataindexList.add("ownernameindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Vehicle_Id"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'vehicleidindex',width:70,filter: { type: 'string' }},");
			  dataindexList.add("vehicleidindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Driver_Number"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'drivernumberindex',width:100,filter: { type: 'string' }},");
			  dataindexList.add("drivernumberindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Booking_Customer"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'bookingcustomerindex',width:100,filter: { type: 'string' }},");
			  dataindexList.add("bookingcustomerindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Container_No"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'containerNoindex',width:100,filter: { type: 'string' }},");
			  dataindexList.add("containerNoindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Vehicle_Type"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'vehicletypeindex',width:100,filter: { type: 'string' }},");
			  dataindexList.add("vehicletypeindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Vehicle_Status"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'vehiclestatusindex',width:100,filter: { type: 'string' }},");
			  dataindexList.add("vehiclestatusindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Trip_Name"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'tripnameindex',width:100,filter: { type: 'string' }},");
			  dataindexList.add("tripnameindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Trip_Start_Date"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'tripstartdateindex',width: 150, renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),filter: { type: 'date' }},");
			  dataindexList.add("tripstartdateindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Beacon_On_Of_Time"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'beacononoffindex',width: 150, renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),filter: { type: 'date' }},");
			  dataindexList.add("beacononoffindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Ignition_2"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'ignition2index',width:100,filter: { type: 'string' }},");
			  dataindexList.add("ignition2index");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Engine_Hours"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'enginehoursindex',renderer: Ext.util.Format.numberRenderer('0.00'), width:70,filter: { type: 'numeric' }},");
			  dataindexList.add("enginehoursindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Engine_2_Hours"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'engine2hoursindex',renderer: Ext.util.Format.numberRenderer('0.00'), width:70,filter: { type: 'numeric' }},");
			  dataindexList.add("engine2hoursindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("AC_HOURS"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'achoursindex',renderer: Ext.util.Format.numberRenderer('0.00'), width:70,filter: { type: 'numeric' }},");
			  dataindexList.add("achoursindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("AC"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'acindex',width:75,filter: { type: 'string' }},");
			  dataindexList.add("acindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("TAXIMETER"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'taximeterindex',width:100,filter: { type: 'string' }},");
			  dataindexList.add("taximeterindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("FUEL_GUAGE")  && checkFDAS==true)
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'fuelguageindex',width:100},");
			  dataindexList.add("fuelguageindex");
		  }
		  
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Vehicle_Image"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'vehicleimageindex',width:60},");
			  dataindexList.add("vehicleimageindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Temperature"))
		  {
			  String temp = rs.getString(getLanuage)+" (\u00B0C)";
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+temp+"</span>',dataIndex: 'temperatureindex',width:100},");
			  dataindexList.add("temperatureindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Odometer"))
		  {
		  gridHeaderBuffer.append("{dataIndex: 'odometerindex', header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>', renderer: Ext.util.Format.numberRenderer('0.00'), width: 70, filter: { type: 'numeric' }},");
		  dataindexList.add("odometerindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Seat_Belt"))
		  {
		  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'seatbeltindex', width: 100,filter: { type: 'string' }},");
		  dataindexList.add("seatbeltindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Person_Status"))
		  {
		  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'personstatusindex', width: 100,filter: { type: 'string' }},");
		  dataindexList.add("personstatusindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("IB_Voltage"))
		  {
		  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'ibvoltageindex', width: 100,filter: { type: 'numeric' }},");
		  dataindexList.add("ibvoltageindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Battery_Voltage"))
		  {
		  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'batteryVoltageIndex', width: 100,filter: { type: 'numeric' }},");
		  dataindexList.add("batteryVoltageIndex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("AD_Light"))
		  {
		  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'adlightindex', width: 100,filter: { type: 'string' }},");
		  dataindexList.add("adlightindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Direction"))
		  {
		  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'directionindex', width: 100,filter: { type: 'string' }},");
		  dataindexList.add("directionindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Internal_Battery_Voltage"))
		  {
		  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'internalbatteryindex', width: 100,filter: { type: 'numeric' }},");
		  dataindexList.add("internalbatteryindex");
		  }		  
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("GMT"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'gmtindex',width: 150, renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),filter: { type: 'date' }},");
			  dataindexList.add("gmtindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Operating_On_Mine"))
		  {
		  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'operatingOnMineIndex', width: 100,filter: { type: 'string' }}");
		  dataindexList.add("operatingOnMineIndex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("OBD_Type"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>', dataIndex: 'obdIndex',width:100,filter: {type:'string'}},");
			  dataindexList.add("obdIndex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Fuel_Litre"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>', dataIndex: 'fuelLtrIndex',width:100,filter: {type:'string'}},");
		      dataindexList.add("fuelLtrIndex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Last_Fuel_Time"))
		  {	
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'fuelTimeIndex',width: 150, renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),filter: { type: 'date' }},");
		      dataindexList.add("fuelTimeIndex");
		  }
		 
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Trip_Customer"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>', dataIndex: 'tripCustomerindex',width:100,filter: {type:'string'}},");
		      dataindexList.add("tripCustomerindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Temp_info_for_TCL"))
		  {
		      gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>', dataIndex: 'tempInfoForTCLindex',width:100,filter: {type:'string'}},");
		      dataindexList.add("tempInfoForTCLindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Set_Temp_limits_for_on_trip"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>', dataIndex: 'setTempLimitsForOnTripindex',width:100,filter: {type:'string'}},");
		      dataindexList.add("setTempLimitsForOnTripindex");
		  }
		  
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("ETP"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>', dataIndex: 'ETPindex',width:100,filter: {type:'string'}},");
		      dataindexList.add("ETPindex");
		  } 
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("ATP"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>', dataIndex: 'ATPindex',width:150,filter: {type:'string'}},");
		      dataindexList.add("ATPindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("ETA"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>', dataIndex: 'ETAindex',width:150,filter: {type:'string'}},");
		      dataindexList.add("ETAindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("ATA"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>', dataIndex: 'ATAindex',width:150,filter: {type:'string'}},");
		      dataindexList.add("ATAindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("City"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>', dataIndex: 'Cityindex',width:100,filter: {type:'string'}},");
		      dataindexList.add("Cityindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Ageing"))  //Ageing (Current time - Last trip close/cancel (Auto/manual))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>', dataIndex: 'Ageingindex',width:100,filter: {type:'string'}},");
		      dataindexList.add("Ageingindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("OBD_Odometer"))
		  {
		  gridHeaderBuffer.append("{dataIndex: 'obdodometerindex', header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>', renderer: Ext.util.Format.numberRenderer('0.00'), width: 70, filter: { type: 'numeric' }},");
		  dataindexList.add("obdodometerindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("OBD_DateTime"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'obddatetimeindex',width: 150, renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),filter: { type: 'date' }},");
			  dataindexList.add("obddatetimeindex");
		  }
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("OBD_Connection_Status"))
		  {
			  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>', dataIndex: 'obdconnectionstatusindex',width:150,filter: {type:'string'}},");
		      dataindexList.add("obdconnectionstatusindex");
		  }
	 }
		 
	    }
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);			
		}
		
		return gridHeaderBuffer;
	}
	private StringBuffer gridHeaderBufferFromUserSetting = new StringBuffer();
	
	/*public Boolean checkVehicleNoExistenceinFirstFour(int systemid,int clientid,int userId){
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean check=false;
		con = DBConnection.getConnectionToDB("AMS");
		  
			 try {
				pstmt = con.prepareStatement(MapViewStatements.GET_HEADERS_FROM_USER_SETTING_FOR_MAPVIEW);
			
			 pstmt.setInt(1,systemid);
			 pstmt.setInt(2,clientid);
			 pstmt.setInt(3,userId);
		  
		  rs=pstmt.executeQuery(); 
		  int noOfColumns=0;
		  while(rs.next() && noOfColumns<4)
		  {
		  noOfColumns++;
		  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Vehicle_No"))
		  {
		 check=true;
		  }}
			 } catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} finally {
					
					DBConnection.releaseConnectionToDB(con, pstmt, rs);			
				}
				
		return check;
		
	}
	*/
	public StringBuffer getGridHeaderBufferFromUserSetting(int processId,String language,int systemid, int clientid, int userId)
	{
		Connection con = null;
		PreparedStatement pstmt = null,pstmt1= null;
		ResultSet rs = null, rs1 = null;
		CommonFunctions cf = new CommonFunctions();
		int vehicleNumberChecker=3;
		
		ArrayList<String> dataindexList = new ArrayList<String>();
		try {
			if(language.equals("ar"))
			{
				getLanuage="LANG_ARABIC";
			}
		  con = DBConnection.getConnectionToDB("AMS");
		  
		  pstmt1=con.prepareStatement(MapViewStatements.LIVE_VISION_FILTER_DATA_CHECK_BEFORE_DELETION);
		  pstmt1.setInt(1,systemid);
		  pstmt1.setInt(2,clientid);
		  pstmt1.setInt(3,userId);
		  rs1=pstmt1.executeQuery();
		  if(rs1.next()){
			 pstmt = con.prepareStatement(MapViewStatements.GET_HEADERS_FROM_USER_SETTING_FOR_MAPVIEW);
			 pstmt.setInt(1,systemid);
			 pstmt.setInt(2,clientid);
			 pstmt.setInt(3,userId);
				  
		  }else{
			  pstmt=con.prepareStatement(MapViewStatements.LIVE_VISION_HEADERS);
			  pstmt.setInt(1, processId);
			  vehicleNumberChecker=4;
		  }
		  rs=pstmt.executeQuery(); 
		  String UnitofMeasure=cf.getUnitOfMeasure(systemid);
		  
		  int colone=0;
		  if(rs.next())
			  
		  {
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Driver_Name"))
			  {
				  gridHeaderBufferFromUserSetting.append("{header: '<span style=font-weight:bold;>"+rs.getString(getLanuage)+"</span>',dataIndex: 'drivername',width: 100,filter: { type: 'string' }},");
				  dataindexList.add("drivername");
			  }
			  gridHeaderBufferFromUserSetting.append("{header: '<span style=font-weight:bold;>Vehicle No(Vehicle Id)</span>', dataIndex: 'assetNo',width:120,filter: {type:'string'}},");
			  dataindexList.add("assetNo");
			  gridHeaderBufferFromUserSetting.append("{header: '<span style=font-weight:bold;>Image</span>',dataIndex: 'imageIcon',width:50},");
			  dataindexList.add("imageIcon");
			  gridHeaderBufferFromUserSetting.append("{header: '<span style=font-weight:bold;>Group Name</span>',dataIndex: 'groupname',width: 150,filter: { type: 'string' }},");
			  dataindexList.add("groupname");
		  	 
		  }
		  
			  
			  
		  
		  
		  
		  
	    }
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			
			DBConnection.releaseConnectionToDB(con, pstmt, rs);			
		}
		
		return gridHeaderBufferFromUserSetting;
	}
	
	
//********************************************Vehicle Details Vertical wise for MapView**************************************************
	
	
	public StringBuilder getVehicleDetails(int processId,String language)
	{
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;			
		String VehicleInfo="",vehicleString="";
		ArrayList<String> detailIds=new ArrayList<String>();
		StringBuilder vehicleDetailsList = new StringBuilder();
		try {
			if(language.equals("ar"))
			{
				getLanuage="LANG_ARABIC";
			}
		  con = DBConnection.getConnectionToDB("AMS");
		  pstmt=con.prepareStatement(MapViewStatements.MAP_VIEW_HEADERS);
		  pstmt.setInt(1, processId);
		  rs=pstmt.executeQuery();		  
		  while(rs.next())
		  {
		  VehicleInfo=rs.getString(getLanuage);
		  vehicleString=rs.getString("DATA_FIELD_LABEL_ID");
		  
		  vehicleDetailsList.append("<li class='me-select-label'><span class='vehicle-details-block-header'>"+VehicleInfo+"</span><span class='vehicle-details-block-sep'>&nbsp;:</span><p class='vehicle-details-block' id='"+vehicleString+"'></p></li>");
		  detailIds.add(vehicleString);
		  
		  }
		  setListOfIds(detailIds);
		}
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
	return vehicleDetailsList;	
	}

	
	public StringBuilder getGridReaders(int processId,boolean checkFDAS)
	{
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;				
		StringBuilder gridFilterList=new StringBuilder();
		StringBuilder gridReaderList = new StringBuilder();
		try {			
		  con = DBConnection.getConnectionToDB("AMS");
		  pstmt=con.prepareStatement(MapViewStatements.LIVE_VISION_HEADERS);
		  pstmt.setInt(1, processId);
		  rs=pstmt.executeQuery();	  
		  while(rs.next()){
			  
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Vehicle_No"))
			  {
			  gridReaderList.append("{name: 'vehiclenoindex',type: 'string'},");
			  gridFilterList.append("{dataIndex: 'vehiclenoindex',type: 'string'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Date_Time"))
			  {
				  gridReaderList.append("{name: 'datetimeindex',type: 'date',dateFormat: getDateTimeFormat() },");
				  gridFilterList.append("{dataIndex: 'datetimeindex',type: 'date'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Location"))
			  {
				  gridReaderList.append("{name: 'locationindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'locationindex',type: 'string'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Ignition"))
			  {
				  gridReaderList.append("{name: 'ignitionindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'ignitionindex',type: 'string'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Speed"))
			  {
				  gridReaderList.append("{name: 'speedindex',type: 'int'},");
				  gridFilterList.append("{dataIndex: 'speedindex',type: 'int'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("STOPPAGE_TIME_ALERT"))
			  {
				  gridReaderList.append("{name: 'stoppagetimeindex',type: 'float'},");
				  gridFilterList.append("{dataIndex: 'stoppagetimeindex',type: 'float'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Status"))
			  {
				  gridReaderList.append("{name: 'statusindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'statusindex',type: 'string'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Driver_Name"))
			  {
				  gridReaderList.append("{name: 'drivernameindex',type: 'string'},");  
				  gridFilterList.append("{dataIndex: 'drivernameindex',type: 'string'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Door_Status"))
			  {
				  gridReaderList.append("{name: 'doorstatusindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'doorstatusindex',type: 'string'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Vehicle_Group"))
			  {
				  gridReaderList.append("{name: 'vehiclegroupindex',type: 'string'},");  
				  gridFilterList.append("{dataIndex: 'vehiclegroupindex',type: 'string'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Remarks"))
			  {
				  gridReaderList.append("{name: 'remarksindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'remarksindex',type: 'string'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Vehicle_Model"))
			  {
				  gridReaderList.append("{name: 'vehiclemodelindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'vehiclemodelindex',type: 'string'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Customer_Name"))
			  {
				  gridReaderList.append("{name: 'customernameindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'customernameindex',type: 'string'},");  
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Border_Status"))
			  {
				  gridReaderList.append("{name: 'borderstatusindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'borderstatusindex',type: 'string'},"); 
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("IDLETIME_ALERT"))
			  {
				  gridReaderList.append("{name: 'idletimeindex',type: 'float'},");
				  gridFilterList.append("{dataIndex: 'idletimeindex',type: 'float'},");  
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Owner_Name"))
			  {
				  gridReaderList.append("{name: 'ownernameindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'ownernameindex',type: 'string'},");  
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Vehicle_Id"))
			  {
				  gridReaderList.append("{name: 'vehicleidindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'vehicleidindex',type: 'string'},");  
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Driver_Number"))
			  {
				  gridReaderList.append("{name: 'drivernumberindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'drivernumberindex',type: 'string'},");  
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Booking_Customer"))
			  {
				  gridReaderList.append("{name: 'bookingcustomerindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'bookingcustomerindex',type: 'string'},");  
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Container_No"))
			  {
				  gridReaderList.append("{name: 'containerNoindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'containerNoindex',type: 'string'},");  
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Vehicle_Type"))
			  {
				  gridReaderList.append("{name: 'vehicletypeindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'vehicletypeindex',type: 'string'},");  
			  }
			  
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Vehicle_Status"))
			  {
				  gridReaderList.append("{name: 'vehiclestatusindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'vehiclestatusindex',type: 'string'},");  
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Trip_Name"))
			  {
				  gridReaderList.append("{name: 'tripnameindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'tripnameindex',type: 'string'},");  
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Trip_Start_Date"))
			  {
				  gridReaderList.append("{name: 'tripstartdateindex',type: 'date' , dateFormat: getDateTimeFormat()},"); 
				  gridFilterList.append("{dataIndex: 'tripstartdateindex',type: 'date'},");  
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Beacon_On_Of_Time"))
			  {
				  gridReaderList.append("{name: 'beacononoffindex',type: 'date' , dateFormat: getDateTimeFormat()},"); 
				  gridFilterList.append("{dataIndex: 'beacononoffindex',type: 'date'},");  
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Ignition_2"))
			  {
				  gridReaderList.append("{name: 'ignition2index',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'ignition2index',type: 'string'},");  
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Engine_Hours"))
			  {
				  gridReaderList.append("{name: 'enginehoursindex',type: 'float'},");
				  gridFilterList.append("{dataIndex: 'enginehoursindex',type: 'float'},");  
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Engine_2_Hours"))
			  {
				  gridReaderList.append("{name: 'engine2hoursindex',type: 'float'},");
				  gridFilterList.append("{dataIndex: 'engine2hoursindex',type: 'float'},");  
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("AC"))
			  {
				  gridReaderList.append("{name: 'acindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'acindex',type: 'string'},");  
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("AC_HOURS"))
			  {
				  gridReaderList.append("{name: 'achoursindex',type: 'float'},");
				  gridFilterList.append("{dataIndex: 'achoursindex',type: 'float'},");  
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("TAXIMETER"))
			  {
				  gridReaderList.append("{name: 'taximeterindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'taximeterindex',type: 'string'},");  
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("FUEL_GUAGE")  && checkFDAS==true)
			  {
				  gridReaderList.append("{name: 'fuelguageindex',type: 'string'},");  
				  gridFilterList.append("{dataIndex: 'fuelguageindex',type: 'string'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Vehicle_Image"))
			  {
				  gridReaderList.append("{name: 'vehicleimageindex',type: 'string'},");  
				  gridFilterList.append("{dataIndex: 'vehicleimageindex',type: 'string'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Temperature"))
			  {
				  gridReaderList.append("{name: 'temperatureindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'temperatureindex',type: 'string'},");  
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Odometer"))
			  {
				  gridReaderList.append("{name: 'odometerindex',type: 'float'},");
				  gridFilterList.append("{dataIndex: 'odometerindex',type: 'float'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Seat_Belt"))
			  {
				  gridReaderList.append("{name: 'seatbeltindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'seatbeltindex',type: 'string'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Person_Status"))
			  {
				  gridReaderList.append("{name: 'personstatusindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'personstatusindex',type: 'string'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("IB_Voltage"))
			  {
				  gridReaderList.append("{name: 'ibvoltageindex',type: 'numeric'},");
				  gridFilterList.append("{dataIndex: 'ibvoltageindex',type: 'numeric'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Battery_Voltage"))
			  {
				  gridReaderList.append("{name: 'batteryVoltageIndex',type: 'numeric'},");
				  gridFilterList.append("{dataIndex: 'batteryVoltageIndex',type: 'numeric'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("AD_Light"))
			  {
				  gridReaderList.append("{name: 'adlightindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'adlightindex',type: 'string'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Direction"))
			  {
				  gridReaderList.append("{name: 'directionindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'directionindex',type: 'string'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Internal_Battery_Voltage"))
			  {
				  gridReaderList.append("{name: 'internalbatteryindex',type: 'numeric'},");
				  gridFilterList.append("{dataIndex: 'internalbatteryindex',type: 'numeric'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("GMT"))
			  {
				  gridReaderList.append("{name: 'gmtindex',type: 'date' , dateFormat: getDateTimeFormat()},"); 
				  gridFilterList.append("{dataIndex: 'gmtindex',type: 'date'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Operating_On_Mine"))
			  {
				  gridReaderList.append("{name: 'operatingOnMineIndex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'operatingOnMineIndex',type: 'string'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("OBD_Type"))
			  {
				  gridReaderList.append("{name: 'obdIndex',type: 'string' },"); 
				  gridFilterList.append("{dataIndex: 'obdIndex',type: 'string'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Fuel_Litre"))
			  {
				  gridReaderList.append("{name: 'fuelLtrIndex',type: 'string' },"); 
				  gridFilterList.append("{dataIndex: 'fuelLtrIndex',type: 'float'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Last_Fuel_Time"))
			  {
				  gridReaderList.append("{name: 'fuelTimeIndex',type: 'date' , dateFormat: getDateTimeFormat()},"); 
				  gridFilterList.append("{dataIndex: 'fuelTimeIndex',type: 'date'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Trip_Customer"))
			  {
				  gridReaderList.append("{name: 'tripCustomerindex',type: 'string' },"); 
				  gridFilterList.append("{dataIndex: 'tripCustomerindex',type: 'string'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Temp_info_for_TCL"))
			  {
				  gridReaderList.append("{name: 'tempInfoForTCLindex',type: 'string' },"); 
				  gridFilterList.append("{dataIndex: 'tempInfoForTCLindex',type: 'string'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Set_Temp_limits_for_on_trip"))
			  {
				  gridReaderList.append("{name: 'setTempLimitsForOnTripindex',type: 'string' },"); 
				  gridFilterList.append("{dataIndex: 'setTempLimitsForOnTripindex',type: 'string'},");
			  }
			  /* if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("ETP"))
			  {
				  gridReaderList.append("{name: 'ETPindex',type: 'date' , dateFormat: getDateTimeFormat()},"); 
				  gridFilterList.append("{dataIndex: 'ETPindex',type: 'date'},");
			  }  */
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("ETP"))
			  {
				  gridReaderList.append("{name: 'ETPindex',type: 'string' },"); 
				  gridFilterList.append("{dataIndex: 'ETPindex',type: 'string'},");
			  }  
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("ATP"))
			  {
				  gridReaderList.append("{name: 'ATPindex',type: 'string' },"); 
				  gridFilterList.append("{dataIndex: 'ATPindex',type: 'string'},");
			  } 
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("ETA"))
			  {
				  gridReaderList.append("{name: 'ETAindex',type: 'string' },"); 
				  gridFilterList.append("{dataIndex: 'ETAindex',type: 'string'},");
			  }  
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("ATA"))
			  {
				  gridReaderList.append("{name: 'ATAindex',type: 'string' }, "); 
				  gridFilterList.append("{dataIndex: 'ATAindex',type: 'string'},");
			  }  
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("City"))
			  {
				  gridReaderList.append("{name: 'Cityindex',type: 'string' },"); 
				  gridFilterList.append("{dataIndex: 'Cityindex',type: 'string'},");
			  }  
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Ageing"))
			  {
				  gridReaderList.append("{name: 'Ageingindex',type: 'float' },"); 
				  gridFilterList.append("{dataIndex: 'Ageingindex',type: 'float'},");
			  } 
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("OBD_Odometer"))
			  {
				  gridReaderList.append("{name: 'obdodometerindex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'obdodometerindex',type: 'string'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("OBD_DateTime"))
			  {
				  gridReaderList.append("{name: 'obddatetimeindex',type: 'date' , dateFormat: getDateTimeFormat()},"); 
				  gridFilterList.append("{dataIndex: 'obddatetimeindex',type: 'date'},");
			  }
			  if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("OBD_CONNECTION_STATUS"))
			  {
				  gridReaderList.append("{name: 'obdconnectionstatusindex',type: 'string' },"); 
				  gridFilterList.append("{dataIndex: 'obdconnectionstatusindex',type: 'string'},");
			  }
		 }
		}
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);			
		}
	setFilterList(gridFilterList);	
	return gridReaderList;	
	}
	
	//*******************************Export data types vertical wise***************************************//
	
	public String exportDataTypes(int processID,boolean checkFDAS)
	{
	String dataTypes="int";
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try
	{
	con = DBConnection.getConnectionToDB("AMS");
	pstmt=con.prepareStatement(MapViewStatements.LIVE_VISION_HEADERS);
	pstmt.setInt(1, processID);
	rs=pstmt.executeQuery();
	while(rs.next()){
		if(rs.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("FUEL_GUAGE") && checkFDAS==false){
			
		}else{
		dataTypes=dataTypes+","+rs.getString("COLOUMN_DATA_TYPE");
		}
	}
	}catch (Exception e) {
		e.printStackTrace();
	}finally {
		
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}	
	return dataTypes;
	}
	
	public boolean checkFDASExistsForCustomer(int systemId,int customerId){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean flag=false;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(MapViewStatements.CHECK_FDAS_EXISTS_FOR_CUSTOMER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs=pstmt.executeQuery();
			if(rs.next()){
				flag=true;
			}
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return flag;
	}
}
