package t4u.statements;

public class TripSummaryStatement {

      public static final String GET_GROUP_NAME = "select distinct GROUP_NAME from AMS. dbo.Live_Vision_Support where SYSTEM_ID=? and CLIENT_ID=? ";
	
	
	  public static final String GET_VEHICLE_TRIP_DETAILS = "SELECT vm.VehicleType,ASSET_NUMBER,dm.Fullname,dateadd(mi,?,ACTUAL_TRIP_START_TIME) as ACTUAL_TRIP_START_TIME," +
	  		" dateadd(mi,?,ACTUAL_TRIP_END_TIME) as ACTUAL_TRIP_END_TIME," +
	  		" START_ODOMETER,END_ODOMETER,datediff(mi,ACTUAL_TRIP_START_TIME,ACTUAL_TRIP_END_TIME) as TOTAL_TRIP_MIN," +
	  		" ACTUAL_DISTANCE,SWIPE_COUNT,lvs.GROUP_NAME FROM TRACK_TRIP_DETAILS td " +
	        " INNER JOIN TRACK_TRIP_DETAILS_SUB ttds on td.TRIP_ID=ttds.TRIP_ID " +
	  		" inner join dbo.Live_Vision_Support lvs on lvs.REGISTRATION_NO=td.ASSET_NUMBER AND lvs.SYSTEM_ID=td.SYSTEM_ID and lvs.CLIENT_ID=td.CUSTOMER_ID "+
	        " LEFT OUTER JOIN Driver_Master dm on dm.Driver_id = ttds.DRIVER_ID " +
	         " left join tblVehicleMaster vm on vm.VehicleNo=td.ASSET_NUMBER " +
	       " WHERE # AND td.STATUS='CLOSED' AND ACTUAL_TRIP_END_TIME BETWEEN dateadd(mi,-?,?)" +
	       " AND  dateadd(mi,-?,?) AND td.SYSTEM_ID =? AND td.CUSTOMER_ID =? ";

	  public static final String GET_VEHICLE_TRIP_SUMMARY = "SELECT ASSET_NUMBER,"+
	       "count(td.TRIP_ID) AS TRIP_COUNT,sum(ACTUAL_DISTANCE) AS TOTAL_DISTANCE,sum(SWIPE_COUNT) AS SUM_PAS,"  +
		  " AVG(SWIPE_COUNT) AS AVG_PAS, AVG(ACTUAL_DISTANCE) AS AVG_DIS , avg(datediff(mi,ACTUAL_TRIP_START_TIME,ACTUAL_TRIP_END_TIME))  AS AVG_TIME " +
	      " FROM TRACK_TRIP_DETAILS td " +
	      " INNER JOIN TRACK_TRIP_DETAILS_SUB ttds on td.TRIP_ID=ttds.TRIP_ID " +
	      " inner join dbo.Live_Vision_Support lvs on lvs.REGISTRATION_NO=td.ASSET_NUMBER AND lvs.SYSTEM_ID=td.SYSTEM_ID and lvs.CLIENT_ID=td.CUSTOMER_ID "+
	      " left join tblVehicleMaster vm on vm.VehicleNo=td.ASSET_NUMBER WHERE td.ASSET_NUMBER=? and td.STATUS='CLOSED' " +
	       " AND ACTUAL_TRIP_END_TIME BETWEEN dateadd(mi,-?,?) AND " +  
	       " dateadd(mi,-?,?) and td.SYSTEM_ID =? AND td.CUSTOMER_ID =? group by ASSET_NUMBER  ";
	  
	  public static final String GET_GROUP_TRIP_SUMMARY = "SELECT GROUP_NAME,"+
	  " count(td.TRIP_ID) AS TRIP_COUNT,sum(ACTUAL_DISTANCE) AS TOTAL_DISTANCE,sum(SWIPE_COUNT) AS SUM_PAS, " +
	  " AVG(SWIPE_COUNT) AS AVG_PAS, AVG(ACTUAL_DISTANCE) AS AVG_DIS ,avg(datediff(mi,ACTUAL_TRIP_START_TIME,ACTUAL_TRIP_END_TIME))  AS AVG_TIME " +
	  " FROM TRACK_TRIP_DETAILS td " +
	  " INNER JOIN TRACK_TRIP_DETAILS_SUB ttds on td.TRIP_ID=ttds.TRIP_ID " +
	  " inner join dbo.Live_Vision_Support lvs on lvs.REGISTRATION_NO=td.ASSET_NUMBER AND lvs.SYSTEM_ID=td.SYSTEM_ID and lvs.CLIENT_ID=td.CUSTOMER_ID "+
	  " left join tblVehicleMaster vm on vm.VehicleNo=td.ASSET_NUMBER WHERE lvs.GROUP_NAME=? and td.STATUS='CLOSED' " +
	   " AND ACTUAL_TRIP_END_TIME BETWEEN dateadd(mi,-?,?) AND " +  
	   " dateadd(mi,-?,?) and td.SYSTEM_ID =? AND td.CUSTOMER_ID =? group by GROUP_NAME  ";
	}


