package t4u.statements;

public class PreferencesStatements {
	
	public static final String GET_PREFERENCE_REPORT="select dateadd(mi,?,DATE) as DATE,isnull(REASON,'') as REASON,isnull(ID,'') as ID from dbo.HOLIDAY_LIST where CUSTOMER_ID=? and SYSTEM_ID=? and DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?)";
	
	public static final String INSERT_PREFERENCE_DETAILS="insert into dbo.HOLIDAY_LIST(DATE,REASON,CUSTOMER_ID,SYSTEM_ID,CREATED_BY) values (dateadd(mi,-?,?),?,?,?,?)";
	
	public static final String UPDATE_PREFERENCES_DETAILS="update dbo.HOLIDAY_LIST set DATE=dateadd(mi,-?,?),REASON=?,UPDATED_BY=?,UPDATED_TIME=getUtcDate() where CUSTOMER_ID=? and SYSTEM_ID=? and ID=? ";
	
	
	
	
	
	
	

}
