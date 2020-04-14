package t4u.statements;

public class MileageandHBAnalysisStatements {

	public static final String GET_REGISTRATION_NO_ALL = "select top 10 isnull(REGISTRATION_NO,'') as registrationNo,count(REGISTRATION_NO) as count,(sum(AVERAGE)/count(REGISTRATION_NO)) as average"+
		" from AMS.dbo.HB_ANALYSIS where SYSTEM_ID=? and CUSTOMER_ID=? and GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) group by REGISTRATION_NO order by count(REGISTRATION_NO) desc,average";
	
	public static final String GET_DAYWISE_VEHICLE_HB_DETAILS = "select ROW_NUMBER() OVER (ORDER BY ID) AS ID,REGISTRATION_NO,Convert(varchar,dateadd(mi,?,GMT),105) as date,CAST(ROUND(AVERAGE,0) / 60 as INT) as Mins,"+ 
		" CAST(ROUND(AVERAGE,0) % 60 AS INT) as sec from AMS.dbo.HB_ANALYSIS where REGISTRATION_NO=? AND SYSTEM_ID=? and CUSTOMER_ID=? and GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) order by ID";
	
	public static final String MODELWISE_AVERAGE_MILEAGE="SELECT MODEL_TYPE,CONVERT(VARCHAR(10),DATE,120) AS DATE,   "+
		" cast( sum(MILEAGE)/count(MILEAGE)  as numeric(32,2) )  'AverageMileage'   "+
		" FROM AMS.dbo.DayWiseMilage   "+
		//	"WHERE CONVERT(VARCHAR(10),DATE,120)='2017-08-29'  "+
		" group by MODEL_TYPE,CONVERT(VARCHAR(10),DATE,120)  ";

	public static final String GET_CITY_DETAILS = "select distinct c.CityName as cityName,CITY as cityId from ADMINISTRATOR.dbo.ASSET_GROUP ag inner join Maple.dbo.tblCity c on c.CityID=ag.CITY" +
		" where ag.SYSTEM_ID=? and CUSTOMER_ID=? order by CITY";

	public static final String GET_REGISTRATION_NO_CITY_BASED = "select top 10 isnull(hb.REGISTRATION_NO,'') as registrationNo,count(hb.REGISTRATION_NO) as count,(sum(hb.AVERAGE)/count(hb.REGISTRATION_NO)) as average"+
		" from AMS.dbo.HB_ANALYSIS hb"+ 
		" left outer join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.CUSTOMER_ID=hb.CUSTOMER_ID and ag.GROUP_ID=hb.VEHICLE_GROUP"+ 
		" left outer join Maple.dbo.tblCity c on c.CityID=ag.CITY"+
		" where hb.SYSTEM_ID=? and hb.CUSTOMER_ID=? and ag.CITY=? and GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) group by hb.REGISTRATION_NO order by count(hb.REGISTRATION_NO) desc,average";
	
	/* **************************MILEAGE AND REFUEL SUMMARY *************************************** */

	public static final String VECHILEWISE_REFUEL_AND_MILEAGE_SUMMARY=" SELECT REGISTRATION_NO , count(REGISTRATION_NO) as TOTAL_RECORDS   ,     "+
	" cast(  sum(DISTANCE_TRAVELLED)/sum(FUEL_CONSUMED)  as numeric(32,2) )  'AverageMileage'   "+
	" FROM AMS.dbo.Refuel_And_Mileage_Summary   "+
	" where MILEAGE<>0  AND CITY=? and MODEL_NAME=? AND  CONVERT(VARCHAR(10),REFUEL_DATE_TIME,120) BETWEEN CONVERT(VARCHAR(10),getdate()-30,120) AND CONVERT(VARCHAR(10),getdate()-1,120) and SYSTEM_ID=? and CUSTOMER_ID=?"+
	" group by REGISTRATION_NO    "+
	//" having  count(REGISTRATION_NO)>1 "+
	" ORDER  by REGISTRATION_NO    ";


	public static final String VEHICLE_REFUEL_DATA="SELECT dateadd(mi,330,REFUEL_DATE_TIME) as REFUEL_DATE_TIME,FUEL_QTY,FUEL_QTY_BEFORE_REFURL,FUEL_CONSUMED,cast(MILEAGE as numeric(32,2) )  'MILEAGE'   , "+
	"ODOMETER,DISTANCE_TRAVELLED,REFUEL_DURATION  "+
	"from AMS.dbo.Refuel_And_Mileage_Summary "+
	"where REGISTRATION_NO=? AND  CONVERT(VARCHAR(10),REFUEL_DATE_TIME,120) BETWEEN CONVERT(VARCHAR(10),getdate()-30,120) AND CONVERT(VARCHAR(10),getdate()-1,120) "+
	"and MILEAGE<>0  and SYSTEM_ID=? and CUSTOMER_ID=? "+
	"order by REFUEL_DATE_TIME ";


	public static final String CITY_WISE_MILEAGE="SELECT CITY,MODEL_NAME  , MODEL_TYPE ,   "+
	"cast( sum(DISTANCE_TRAVELLED)/sum(FUEL_CONSUMED)  as numeric(32,2) )  'AverageMileage' ,count(distinct(REGISTRATION_NO)) as vehiclecount  ,    "+
	" CONVERT(VARCHAR(10),getdate()-30,120) as startDate ,CONVERT(VARCHAR(10),getdate()-1 ,120) as endDate "+
	"FROM AMS.dbo.Refuel_And_Mileage_Summary     "+
	"WHERE CONVERT(VARCHAR(10),REFUEL_DATE_TIME,120) BETWEEN CONVERT(VARCHAR(10),getdate()-30,120) AND CONVERT(VARCHAR(10),getdate()-1,120)  "+
	"and MILEAGE<>0  and SYSTEM_ID=? and CUSTOMER_ID=? "+
	"group by CITY,MODEL_NAME ,MODEL_TYPE    "+
	"ORDER  by CITY      ";
	
	 /*added on 10-10-2017 */
	
	public static final String GET_HB_COUNT_ALL_CITY="select top 10 REGISTRATION_NO,sum(TOTAL_HB_DUR_COUNT+1)as COUNT , sum(AVERAGE) as AVERAGE, "+
	"(sum(AVERAGE)/count(REGISTRATION_NO)) as total_avg  "+
	"from AMS.dbo.HB_ANALYSIS  "+
	"where GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) and  SYSTEM_ID=? and CUSTOMER_ID=? "+
	"group by REGISTRATION_NO   "+
	"order by COUNT desc  ";
	
	public static final String GET_HB_COUNT_CITY="select top 10  hb.REGISTRATION_NO,sum(hb.TOTAL_HB_DUR_COUNT+1)as count , sum(hb.AVERAGE) as AVERAGE,   "+
	"(sum(AVERAGE)/count(REGISTRATION_NO)) as total_avg    "+
	"from AMS.dbo.HB_ANALYSIS hb   "+
	"left outer join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.CUSTOMER_ID=hb.CUSTOMER_ID and ag.GROUP_ID=hb.VEHICLE_GROUP   "+
	"left outer join Maple.dbo.tblCity c on c.CityID=ag.CITY   "+
	"where hb.GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?)   "+
	"and hb.SYSTEM_ID=? and hb.CUSTOMER_ID=? and ag.CITY=?   "+
	"group by hb.REGISTRATION_NO     "+
	"order by count desc    ";
	
	public static final String HARSH_BRAKE_HEAP_MAP_POINTS=" select LATITUDE,LONGITUDE from ALERT.dbo.HARSH_ALERT_DATA where SYSTEM_ID=? and CUSTOMER_ID=?   and TYPE_OF_ALERT=58 "+
	"and GMT between dateadd(mi,-330,CONVERT(VARCHAR(10),getdate()-2,120)) and dateadd(mi,-330,CONVERT(VARCHAR(10),getdate(),120)) "+ 
	"union all "+ 
	"select  LATITUDE,LONGITUDE  from ALERT.dbo.HARSH_ALERT_DATA_HISTORY where SYSTEM_ID=? and CUSTOMER_ID=?  and TYPE_OF_ALERT=58 "+ 
	"and GMT between dateadd(mi,-330,CONVERT(VARCHAR(10),getdate()-2,120)) and dateadd(mi,-330,CONVERT(VARCHAR(10),getdate(),120)) ";



}
