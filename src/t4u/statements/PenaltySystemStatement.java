package t4u.statements;

public class PenaltySystemStatement {

	public static final String GET_PENALTY_DETAILS = " SELECT ID,PENALTY_TYPE,AMOUNT FROM AMS.dbo.PENALTY_MASTER WHERE SYSTEM_ID=? AND CUSTOMER_ID=? ";
	
	public static final String GET_PENALTY_SYATEM_REPORT_DETAILS = " SELECT a.[ID],dateadd(mi,?,a.[DATE]) as DATE_TIME,b.[ASSET_NUMBER],b.[ASSET_TYPE],b.[DRIVER_NAME],b.[DRIVER_MOBILE_NUMBER],b.[DISTRICT],b.[DEPARTMENT],b.[GOVERNATE],c.[PENALTY_TYPE],c.[AMOUNT] "+
																   " FROM [AMS].[dbo].[PENALTY_DEATILS] a "+ 
																   " LEFT OUTER JOIN [AMS].[dbo].[ASSET_OPERATION_DETAILS] b ON a.[ASSET_OPERATION_ID]=b.[ID] AND a.[SYSTEM_ID]=b.[SYSTEM_ID] AND a.[CUSTOMER_ID]=b.[CUSTOMER_ID] "+
																   " LEFT OUTER JOIN [AMS].[dbo].[PENALTY_MASTER] c ON a.[SYSTEM_ID]=c.[SYSTEM_ID] AND a.[CUSTOMER_ID]=c.[CUSTOMER_ID] AND a.[PENALTY_ID]=c.[ID] "+
																   " WHERE a.[SYSTEM_ID]=? AND a.[CUSTOMER_ID]=? AND a.[DATE] BETWEEN ? AND ? ";
	
	public static final String SAVE_PENALTY_SYATEM_DETAILS = " INSERT INTO [AMS].[dbo].[PENALTY_DEATILS] "+
															 " ([DATE],[ASSET_OPERATION_ID],[PENALTY_ID],[SYSTEM_ID],[CUSTOMER_ID],[INSERTED_BY],[INSERTED_DATETIME]) "+
															 " VALUES(dateadd(mi,-?,?),?,?,?,?,?,GETDATE()) ";;
	
	public static final String UPDATE_PENALTY_SYATEM_DETAILS = " UPDATE [AMS].[dbo].[PENALTY_DEATILS] SET [PENALTY_ID]= ?,[UPDATED_BY]= ?,[UPDATED_DATETIME]= GETDATE() "+
															   " WHERE [ID] = ? AND [SYSTEM_ID] = ? AND [CUSTOMER_ID] = ? ";
	
	public static final String GET_VEHICLE_DETAILS = " SELECT [ID],[ASSET_NUMBER],[ASSET_TYPE],[DRIVER_NAME],[DRIVER_MOBILE_NUMBER],[DISTRICT],[DEPARTMENT],[GOVERNATE] "+
	 												 " FROM [AMS].[dbo].[ASSET_OPERATION_DETAILS] WHERE [SYSTEM_ID]=? AND [CUSTOMER_ID]=? ";
	
	public static final String CHECK_PENALTY_SYSTEM = "SELECT * FROM [AMS].[dbo].[PENALTY_DEATILS] WHERE [ASSET_OPERATION_ID]= ? AND [PENALTY_ID]= ? AND [SYSTEM_ID]= ? AND [CUSTOMER_ID]= ?";

}
