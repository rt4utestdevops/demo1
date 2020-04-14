package t4u.statements;

public class ArmoryStatements {

	public static String INSERT_ARMORY_ITEM="INSERT INTO AMS.dbo.ARMORY_ITEM VALUES(?,?,?,getutcdate(),?,?)";
	public static String GET_ARMORY_ITEMS="SELECT Id,ITEM_NAME FROM ARMORY_ITEM WHERE SYSTEM_ID=? and CLIENTID=? and ASSET_TYPE  = 'Armory' ";
	
	public static String GET_ARMORY_STATIONARY_ITEMS="SELECT Id,ITEM_NAME,ASSET_TYPE FROM ARMORY_ITEM WHERE SYSTEM_ID=? and CLIENTID=? ";
	public static String GET_BRANCHES="SELECT BranchId,BranchName FROM Maple.dbo.tblBranchMaster WHERE  SystemId=? and ClientId=? ";

	public static String INSERT_ARMORY_INVENTORY="INSERT INTO ARMORY_INVENTORY (ASSET_NO,QR_CODE,ASSET_ITEM,STATUS,BRANCH_ID,VENDOR_NAME,CREATED_BY_ID,SYSTEM_ID,CLIENT_ID,CREATED_DATE) VALUES(?,?,?,?,?,?,?,?,?,getutcdate())";
	public static final String GET_ARMORY_INVENTORY = "SELECT isnull(ai.ASSET_NO,'') as assetNo,isnull(ai.QR_CODE,'')as qrCode,isnull(ai.STATUS,'') as status,isnull (dateadd(mi,?,ai.CREATED_DATE),'')  as date,isnull(ai.VENDOR_NAME,'') as vendorName,isnull(at.ITEM_NAME,'') as assetName,m.BranchName as branchName, isnull(ai.REASON,'') as reason, isnull(ai.ISACTIVE,'') as isActive FROM ARMORY_INVENTORY ai join ARMORY_ITEM at on ai.ASSET_ITEM=at.Id join  Maple.dbo.tblBranchMaster m on ai.BRANCH_ID=m.BranchId WHERE   ai.SYSTEM_ID=? and ai.CLIENT_ID=? ";

	public static String UPDATE_ARMORY_ITEMS= "update dbo.ARMORY_INVENTORY set ISACTIVE=?,UPDATED_DATE=getutcdate() where CLIENT_ID=? and SYSTEM_ID=? and ASSET_NO in (#)";
	
	public static String GET_PENDING_ARMORIES="select distinct( tp.TRIP_ID ) AS tripNo , ot.ASSET_NAME as assetName,ot.ASSET_NO as assetNo,b.BranchName,ci.CustomerName , tp.TRIP_START_DATETIME AS date from ams.dbo.ON_TRIP_ARMORY ot "+
   " join AMS.dbo.ARMORY_INVENTORY ai on ai.ASSET_NO=ot.ASSET_NO "+
" JOIN Maple.dbo.tblBranchMaster b on ai.BRANCH_ID=b.BranchId "+
" join LMS.dbo.Customer_Information ci on ot.CUSTOMER_ID=ci.CustomerId  "+
" join AMS.dbo.TRIP_PLANNER tp on ot.TRIP_NO=tp.TRIP_ID "+
" where ot.CUSTOMER_ID IS NOT NULL and  ai.STATUS=? and ai.SYSTEM_ID=? and ai.CLIENT_ID=? and tp.SYSTEM_ID=? and tp.CUSTOMER_ID =?";
	
	
	public static final String CHECK_ASSET_IF_ALREADY_EXIST = " select ITEM_NAME from dbo.ARMORY_ITEM where SYSTEM_ID=? AND CLIENTID=? AND ITEM_NAME=? ";

	public static String GET_ALL_ASSET_NO = " select ASSET_NO from AMS.dbo.ARMORY_INVENTORY where SYSTEM_ID  = ?  AND CLIENT_ID  = ?  ";

	
	public static final String GET_VAULT_INWARD = " select INWARD_MODE,CASH_TYPE,isnull(TRIP_SHEET_NO,'') as TRIP_SHEET_NO ,CVS_CUST_ID,INWARD_ID,INWARD_DATE,SEAL_NO,TOTAL_AMOUNT,b.CustomerName, isnull(CASH_SEAL_NO,'') as CASH_SEAL_NO from dbo.CASH_INWARD_DETAILS "+
	" inner join LMS.dbo.Customer_Information b on CVS_CUST_ID = b.CustomerId where SYSTEM_ID = ?  AND CUSTOMER_ID = ? and INWARD_DATE between ? and ? order by INWARD_DATE";
	
	public static final String GET_CUSTOMER_NAME ="select CustomerName from LMS.dbo.Customer_Information where CustomerId=?and SystemId=?";
	
}