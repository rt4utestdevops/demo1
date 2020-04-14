package t4u.statements;

public class RMCStatements {
//********************************************* RMC PLANT ASSOCIATION **********************************************//
	
	/**
	 * To fetch List of Hub Names based on Customer
	 */
	public static final String GET_TOTAL_HUBS="select HUBID,NAME from LOCATION_ZONE where OPERATION_ID=1  and CLIENTID=? and HUBID not in(select HUB_ID from dbo.RMC_PLANT_SETTING)";
	/**
	 * To insert to RMC PLANT ASSOCIATION
	 */
	public static final String INSERT_PLANT_ASSOCIATION="insert into dbo.RMC_PLANT_SETTING(HUB_ID,CUSTOMER_ID,SYSTEM_ID,STATUS,CREATED_BY,CREATED_TIME)values(?,?,?,?,?,getutcdate());";
	/**
	 * To fetch details of RMC PLANT ASSOCIATION
	 */
	public static final String GET_PLANT_ASSOCIATION="select r.HUB_ID,l.NAME,r.STATUS from dbo.RMC_PLANT_SETTING r left outer join dbo.LOCATION_ZONE l on l.HUBID=r.HUB_ID where CUSTOMER_ID=? and SYSTEM_ID=?";
	/**
	 * To update to RMC PLANT ASSOCIATION
	 */
	public static final String UPDATE_PLANT_ASSOCIATION="update  dbo.RMC_PLANT_SETTING set STATUS=? where HUB_ID=? and CUSTOMER_ID=? and SYSTEM_ID=?";
	
//******************************************** RMC ASSET SETTINGS *****************************************************//	
	/**
	 * To insert to RMC SETTING
	 */
	public static final String INSERT_PLANT_SETTINGS="insert into dbo.RMC_ASSET_SETTING(REGISTRATION_NO,LOADING,UNLOADING,SYSTEM_ID,CUSTOMER_ID,CREATED_BY,CREATED_TIME)values(?,?,?,?,?,?,getutcdate())";
	/**
	 * To update to RMC SETTING
	 */
	public static final String UPDATE_PLANT_SETTINGS="update dbo.RMC_ASSET_SETTING set LOADING=?,UNLOADING=? where REGISTRATION_NO=? and SYSTEM_ID=? and CUSTOMER_ID=?";
	/**
	 * To fetch details of RMC SETTING
	 */
	public static final String GET_PLANT_SETTING="select a.REGISTRATION_NO,a.LOADING,a.UNLOADING from dbo.RMC_ASSET_SETTING a inner join dbo.Vehicle_User vu on vu.Registration_no=a.REGISTRATION_NO " +
								" where a.CUSTOMER_ID=? and a.SYSTEM_ID=? and vu.User_id=? ";
	/**
	 * To delete to RMC SETTING
	 */
	public static final String DELETE_PLANT_SETTINGS="delete from dbo.RMC_ASSET_SETTING where REGISTRATION_NO=? and LOADING=? and UNLOADING=? and SYSTEM_ID=? and CUSTOMER_ID=?";
	
	/**
	 * To fetch Vehicle Registration, Unit No and Unit type from dbo.Vehicle_association and dbo.Unit_Type_Master table
	 */
	public static final String GET_VEHICLES = "select a.Registration_no,a.Unit_Number,b.UNIT_NAME as Unit_type_desc,c.VehicleAlias from dbo.Vehicle_association a inner join ADMINISTRATOR.dbo.UNIT_TYPE b on a.Unit_Type_Code=b.UNIT_TYPE_CODE "+
										" inner join dbo.Vehicle_User vu on vu.Registration_no=a.Registration_no left outer join tblVehicleMaster c on a.Registration_no=c.VehicleNo where a.System_id=? and a.Client_id=? and a.Registration_no not in (select REGISTRATION_NO from dbo.RMC_ASSET_SETTING)"+
										" and vu.User_id=? and a.Unit_Type_Code in (unitTypeCodeReplace)";

//******************************************  RMC OPERATION REPORT ****************************************************//	
	/**
	 * To fetch RMC Daily Report based on Customer
	 */
	public static final String GET_DAILY_REPORT="select  dateadd(mi,?,a.DATE) as DATE,a.REGISTRATION_NO,a.LOADING_HOUR,a.UNLOADING_HOUR,a.EMPTY_HOUR from dbo.RMC_OPERATION_REPORT a " +
			" inner join dbo.Vehicle_User vu on vu.Registration_no=a.REGISTRATION_NO where " +
			"a.REGISTRATION_NO in (select REGISTRATION_NUMBER from dbo.VEHICLE_CLIENT where SYSTEM_ID=? and GROUP_ID=?) and " +
			"a.DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) and vu.User_id=? ";
	
	
//*********************************************  RMC ACTIVITY REPORT ***************************************************//	
	/**
	 * To fetch RMC Events
	 */
	public static final String GET_RMC_EVENTS="select  LOADING,UNLOADING from RMC_ASSET_SETTING where REGISTRATION_NO=?";
	/**
	 * To fetch RMC Drum Activity
	 */
	public static final String GET_RMC_LOADING_AND_UNLOADING = "select EVENT,EVENT_TYPE,EVENT_ID from dbo.DEVICE_EVENT_MASTER where DEVICE_ID=(select Unit_Type_Code from Vehicle_association where Registration_no=? and System_id=?)";
	/**
	* To fetch RMC Activity Report
	*/
	public static final String GET_RMC_ACTIVITY_REPORT="select LOCATION,GMT,dateadd(mi,?,GMT)as LOCAL_TIME,EVENT_NUMBER,SPEED from dbo.IO_DATA where REGISTRATION_NO=? and GMT  between dateadd(mi,-?,?) and dateadd(mi,-?,?) and SYSTEM_ID=? and EVENT_NUMBER is not null " +
			"union " +
			"select LOCATION,GMT,dateadd(mi,?,GMT)as LOCAL_TIME,EVENT_NUMBER,SPEED from AMS_Archieve.dbo.IO_DATA_HISTORY where REGISTRATION_NO=? and GMT  between dateadd(mi,-?,?) and dateadd(mi,-?,?) and SYSTEM_ID=? and EVENT_NUMBER is not null order by GMT asc";
}
