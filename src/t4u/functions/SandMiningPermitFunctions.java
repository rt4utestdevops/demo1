package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.SandMiningStatements;

public class SandMiningPermitFunctions {

CommonFunctions cf = new CommonFunctions();	
SimpleDateFormat simpleDateFormatYYYY = new SimpleDateFormat(
"MM/dd/yyyy HH:mm:ss");
SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat(
"yyyy-MM-dd HH:mm:ss");
SimpleDateFormat simpleDateFormatddMMYYYYDB1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

SimpleDateFormat simpleDateFormatddMMYY = new SimpleDateFormat(
"dd/MM/yyyy HH:mm:ss");
SimpleDateFormat simpleDateFormatddMMYYAMPM = new SimpleDateFormat(
"dd/MM/yyyy hh:mm aa");
SimpleDateFormat simpleDateFormatddMMYY1 = new SimpleDateFormat(
"dd/MM/yyyy");
SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
SimpleDateFormat simpleDateFormatdd_MM_YY = new SimpleDateFormat(
"dd-MM-yyyy");
DecimalFormat df = new DecimalFormat("#.##");

/**
 * converts minutes into HH.MM format
 * @param minutes
 * @return
 */
public String convertMinutesToHHMMFormat1(int minutes) 
{
	String duration="";
	
	long durationHrslong = minutes / 60;
	String durationHrs = String.valueOf(durationHrslong);
	if(durationHrs.length()==1)
	{
		durationHrs = "0"+ durationHrs;
	}
	
	long durationMinsLong = minutes % 60;
	String durationMins = String.valueOf(durationMinsLong);
	if(durationMins.length()==1)
	{
		durationMins = "0"+ durationMins;
	}
	
	duration = durationHrs + "." + durationMins;
	
	return duration;
}

public double checkDistance(double initialLat, double initialLong, double finalLat, double finalLong){
	
	double latDiff = finalLat - initialLat;
	double longDiff = finalLong - initialLong;
	double earthRadius = 6371; //In Km if you want the distance in km
	
	double distance = 2*earthRadius*Math.asin(Math.sqrt(Math.pow(Math.sin(latDiff/2.0),2)+Math.cos(initialLat)*Math.cos(finalLat)*Math.pow(Math.sin(longDiff/2),2)));

	distance = ((distance*1.85200)/100);
	DecimalFormat twoDForm = new DecimalFormat("#.##");
	
	return Double.valueOf(twoDForm.format(distance));
}
	
public String insertPermitDetails(int systemId,String custId,int userId,String permitNo,String ContractorId,
		String ContractNo,String vehicleNo,double quantity,String sandBlockFrom,String stockyardTo,String validFrom,String validTo,String processingFees)
{
	Connection con = null;
    PreparedStatement pstmt = null, pstmt1=null;
    ResultSet rs = null,rs1 = null;
    String message = null;
    int capacityOfStockyard=0;
    int availableQuantity=0;
    int updateStockyard=0;
    int excavationLimit=0; 
    if(processingFees=="")
    processingFees="0";
   
    try {
    	 Date date = simpleDateFormatddMMYYYYDB1.parse(validFrom);
    	 validFrom=simpleDateFormatddMMYYYYDB.format(date); 
    	 Date date1 = simpleDateFormatddMMYYYYDB1.parse(validTo);
    	 validTo=simpleDateFormatddMMYYYYDB.format(date1); 
        con = DBConnection.getConnectionToDB("AMS");
        con.setAutoCommit(false);
        pstmt = con.prepareStatement(SandMiningStatements.INSERT_SAND_PERMIT_DETAILS);
        pstmt.setString(1, permitNo);
        pstmt.setInt(2, Integer.parseInt(ContractorId));
        pstmt.setString(3, ContractNo);
        pstmt.setString(4, vehicleNo);
        pstmt.setDouble(5, quantity);
        pstmt.setInt(6, Integer.parseInt(sandBlockFrom));
        pstmt.setInt(7, Integer.parseInt(stockyardTo));
       pstmt.setString(8, validFrom);
       pstmt.setString(9, validTo);
        pstmt.setInt(10, Integer.parseInt(processingFees));
        pstmt.setInt(11, systemId);
        pstmt.setInt(12, Integer.parseInt(custId));
        pstmt.setString(13, "N");
        pstmt.setInt(14,userId);
        
        
        int inserted = pstmt.executeUpdate();
        if (inserted > 0 ) {
        message = "Saved Successfully";
        pstmt1=con.prepareStatement(SandMiningStatements.CHECK_ASSESSED_QUANTITY);
        pstmt1.setInt(1, systemId);
        pstmt1.setInt(2, Integer.parseInt(custId));
        pstmt1.setInt(3, Integer.parseInt(sandBlockFrom));
        rs1=pstmt1.executeQuery();
        if(rs1.next())
        {
        int assessedQuantity=rs1.getInt("ASSESSED_QUANTITY");
        if(assessedQuantity<quantity)
        {
        message = "Quantity Available in Sand Block is less than Quantity Entered";	
        return message;
        }
        else
        {
        pstmt=con.prepareStatement(SandMiningStatements.UPDATE_ASSESSED_QUANTITY);
        pstmt.setDouble(1, quantity);
        pstmt.setInt(2, systemId);
        pstmt.setInt(3, Integer.parseInt(custId));
        pstmt.setInt(4, Integer.parseInt(sandBlockFrom));
        int quantityUpdate=pstmt.executeUpdate();
        if(quantityUpdate>0)
        {
        pstmt1=con.prepareStatement(SandMiningStatements.CHECK_CAPACITY_STOCKYARD);
        pstmt1.setInt(1, Integer.parseInt(stockyardTo));
        pstmt1.setInt(2, systemId);
        pstmt1.setInt(3, Integer.parseInt(custId));
        rs1=pstmt1.executeQuery();
        if(rs1.next())
        {
        	availableQuantity=rs1.getInt("ESTIMATED_SAND_QUANTITY_AVAILABLE");
        	capacityOfStockyard=rs1.getInt("CAPACITY_OF_STOCKYARD");
        	if(capacityOfStockyard<availableQuantity+quantity)
        	{
        		message="Capacity of stockyard is less than Quantity entered";
        		return message;
        	}
        	else
        	{
        	pstmt=con.prepareStatement(SandMiningStatements.UPDATE_AVAILABLE_QUANTITY_STOCKYARD);	
        	pstmt.setDouble(1, quantity);
        	pstmt.setInt(2, Integer.parseInt(stockyardTo));
        	pstmt.setInt(3, systemId);
            pstmt.setInt(4, Integer.parseInt(custId));
        	updateStockyard=pstmt.executeUpdate();
        	if(updateStockyard>0)
        	{
        	message="Saved Successfully";
        	pstmt1=con.prepareStatement(SandMiningStatements.CHECK_EXCAVATION_LIMIT);
        	pstmt1.setInt(1, Integer.parseInt(ContractorId));
        	pstmt1.setInt(2, systemId);
        	pstmt1.setInt(3, Integer.parseInt(custId));
        	pstmt1.setInt(4, Integer.parseInt(sandBlockFrom));
            rs1=pstmt1.executeQuery();
            if(rs1.next())
            {
            excavationLimit=rs1.getInt("SAND_EXCAVATION_LIMIT");
            if(excavationLimit<quantity)
            {
            	message="Contractor's Sand Excavation Limit is Less than Quantity Entered";
            	return message;
            }
            else
            {   updateStockyard=0;
            	pstmt=con.prepareStatement(SandMiningStatements.UPDATE_EXCAVATION_LIMIT);	
            	pstmt.setDouble(1, quantity);
            	pstmt.setInt(2, Integer.parseInt(ContractorId));
            	pstmt.setInt(3, systemId);
            	pstmt.setString(4, custId);
            	pstmt.setInt(5, Integer.parseInt(sandBlockFrom));
            	updateStockyard=pstmt.executeUpdate();
            	if(updateStockyard>0)
            	{
            		message="Saved Successfully";
            	}
            }
            }
        	}
        	}
        }
        }
        }
        }
        }
        else
        {
        message="Error while Saving.";	
        }
        if(updateStockyard>0)
        {con.commit();}
    } catch (Exception e) {
        e.printStackTrace();
        try {
            if (con != null)
                con.rollback();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);	
        DBConnection.releaseConnectionToDB(null, pstmt1, rs1);	
	
}
    return message;
}

public String ModifyPermitDetails(int systemId,String custId,int userId,String permitNo,String ContractorId,
		String ContractNo,String vehicleNo,double quantity,String sandBlockFrom,String stockyardTo,String validFrom,String validTo,String processingFees,int selectedQuantity)
{
	Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String message = null;
    int assessedQuantity=0;
    try {
        con = DBConnection.getConnectionToDB("AMS");
        if(selectedQuantity!=quantity)
        {
        pstmt=con.prepareStatement(SandMiningStatements.CHECK_ASSESSED_QUANTITY);
        pstmt.setString(1, sandBlockFrom);
        pstmt.setInt(2, systemId);
        pstmt.setString(3, custId);
        pstmt.setInt(4, 0000);
        rs=pstmt.executeQuery();
        if(rs.next())
        {
        assessedQuantity=rs.getInt("ASSESSED_QUANTITY");	
        }
        }
        pstmt = con.prepareStatement(SandMiningStatements.UPDATE_PERMIT_DETAILS);
        int inserted = pstmt.executeUpdate();
        if (inserted > 0) {
        message = "Updated Successfully";
        }
        
       
    } catch (Exception e) {
        e.printStackTrace();
        
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);	
	
}
    return message;
}

public ArrayList<Object> getSandPermitDetails(int systemId,String customerId,String jspName,String language)
{ JSONArray JsonArray = null;
Connection con = null;
PreparedStatement pstmt = null;
PreparedStatement pstmt1 = null;
JSONObject hubdetails = null;
ArrayList < String > headersList = new ArrayList < String > ();
int count=0;
ResultSet rs = null;
ResultSet rs1 = null;

ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
ReportHelper finalreporthelper = new ReportHelper();
ArrayList < Object > finlist = new ArrayList < Object > ();

try {
JsonArray = new JSONArray();
headersList.add(cf.getLabelFromDB("SLNO", language));
headersList.add(cf.getLabelFromDB("UNIOQUEID", language));
headersList.add(cf.getLabelFromDB("Permit_No", language));
headersList.add(cf.getLabelFromDB("Contractor_Name", language));
headersList.add(cf.getLabelFromDB("Contract_No", language));
headersList.add(cf.getLabelFromDB("Vehicle_No", language));
headersList.add(cf.getLabelFromDB("Quantity", language));
headersList.add(cf.getLabelFromDB("Sand_Block_From", language));
headersList.add(cf.getLabelFromDB("Stockyard_To", language));
headersList.add(cf.getLabelFromDB("Valid_From", language));
headersList.add(cf.getLabelFromDB("Valid_To", language));
headersList.add(cf.getLabelFromDB("Processing_Fees", language));

con = DBConnection.getConnectionToDB("AMS");
pstmt=con.prepareStatement(SandMiningStatements.GET_PERMIT_DETAILS);
pstmt.setInt(1, systemId);
pstmt.setString(2, customerId);
rs=pstmt.executeQuery();
while(rs.next())
{
count++;
JSONObject inwardPermitDetails=new JSONObject();
ArrayList < Object > informationList = new ArrayList < Object > ();
ReportHelper reporthelper = new ReportHelper();
inwardPermitDetails.put("slnoIndex", count);
inwardPermitDetails.put("uniqueid", rs.getString("PERMIT_ID"));
inwardPermitDetails.put("permitnoindex", rs.getString("PERMIT_NO"));
inwardPermitDetails.put("contractornameindex", rs.getString("CONTRACTOR_ID"));
inwardPermitDetails.put("contractornoindex", rs.getString("CONTRACT_NO"));
inwardPermitDetails.put("vehiclenoindex", rs.getString("VEHICLE_NO"));
inwardPermitDetails.put("quantityindex", rs.getString("QUANTITY"));
inwardPermitDetails.put("sandblockindex", rs.getString("SAND_BLOCK_ID"));
inwardPermitDetails.put("stockyardindex", rs.getString("STOCKYARD_ID"));
inwardPermitDetails.put("validfromindex", simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("VALID_FROM")));
inwardPermitDetails.put("validtoindex",  simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("VALID_TO")));
inwardPermitDetails.put("processingfeesindex", rs.getString("PROCESSING_FEES"));

informationList.add(count);
informationList.add(rs.getString("PERMIT_ID"));
informationList.add(rs.getString("PERMIT_NO"));
informationList.add(rs.getString("CONTRACTOR_ID"));
informationList.add(rs.getString("CONTRACT_NO"));
informationList.add(rs.getString("VEHICLE_NO"));
informationList.add(rs.getString("QUANTITY"));
informationList.add(rs.getString("SAND_BLOCK_ID"));
informationList.add(rs.getString("STOCKYARD_ID"));
informationList.add(  simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("VALID_FROM")));
informationList.add( simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("VALID_TO")));
informationList.add(rs.getString("PROCESSING_FEES"));


JsonArray.put(inwardPermitDetails);
reporthelper.setInformationList(informationList);
reportsList.add(reporthelper);

}
finalreporthelper.setReportsList(reportsList);
finalreporthelper.setHeadersList(headersList);
finlist.add(JsonArray);
finlist.add(finalreporthelper);
}
catch (Exception e) {
e.printStackTrace();
}finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);	
}

return finlist;
}


public ArrayList getPrintList(String uids, int offset) {

	JSONArray jsonArray = new JSONArray();
	JSONObject obj1 = null;
	
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null,rs1=null;
	PreparedStatement pstmt1 = null;
	String vehicleType=null;

	ArrayList finlist = new ArrayList();
	ArrayList list = new ArrayList();
	int count = 0;
	int updated1 = 0;

	try {
		String[] ids = uids.split(",");
		
		con = DBConnection.getConnectionToDB("AMS");

		pstmt1 = con
				.prepareStatement("update AMS.dbo.SAND_INWARD_TRIP_SHEET set PRINTED_DATE=getUTCDate() where PERMIT_ID in("
						+ uids + ")");
		updated1 = pstmt1.executeUpdate();
		pstmt = con
				.prepareStatement("SELECT a.PERMIT_DATE,a.PERMIT_ID,isnull(d.CONTRACTOR_NAME,'') as CONTRACTOR_ID, isnull (c.SAND_STOCKYARD_NAME,'') as STOCKYARD_ID, "+ 
						"isnull (b.Port_Name,'') as SAND_BLOCK_ID,a.PERMIT_NO,a.CONTRACT_NO,a.VEHICLE_NO,a.QUANTITY, "+
						"isnull (a.VALID_FROM,'') as VALID_FROM ,isnull (a.VALID_TO,'') as VALID_TO,ISNULL(PROCESSING_FEES,0) AS PROCESSING_FEES FROM AMS.dbo.SAND_INWARD_TRIP_SHEET a  "+
						"left outer join AMS.dbo.Sand_Port_Details b on b.UniqueId=a.SAND_BLOCK_ID "+
						"left outer join AMS.dbo.SAND_STOCKYARD_MASTER_TABLE c on c.UNIQUE_ID=a.STOCKYARD_ID "+
						"left outer join AMS.dbo.SAND_CONTRACTOR_MASTER d on d.UNIQUE_ID=a.CONTRACTOR_ID "+
						"where a.PERMIT_ID in ("+ uids +") ");

		rs = pstmt.executeQuery();

		while (rs.next()) {
            
			pstmt1=con.prepareStatement("select isnull(VehicleType,'') as VehicleType from AMS.dbo.tblVehicleMaster where VehicleNo=? ");
			pstmt1.setString(1, rs.getString("VEHICLE_NO"));
			rs1=pstmt1.executeQuery();
			if(rs1.next())
			{
			vehicleType=rs1.getString("VehicleType");	
			}
			else
			{
			vehicleType="NA";
			}
			String vaalidFrom=rs.getString("VALID_FROM");
			
			if (rs.getString("VALID_FROM") != null
					&& !rs.getString("VALID_FROM").equals("")) {
				java.util.Date date = simpleDateFormatddMMYYYYDB
						.parse(rs.getString("VALID_FROM"));
			vaalidFrom = simpleDateFormatYYYY.format(date);
				
				java.util.Date date1 = simpleDateFormatYYYY
						.parse(vaalidFrom);
				vaalidFrom = simpleDateFormatddMMYYAMPM.format(date1);				
				
				
				String substr = vaalidFrom.substring(6, 10);
				if (substr.equals("1900")) {
					vaalidFrom = "";
				}
			} else {
				vaalidFrom = "";
			}

			String ToDate = rs.getString("VALID_TO");
			
			if (rs.getString("VALID_TO") != null
					&& !rs.getString("VALID_TO").equals("")) {
				java.util.Date date = simpleDateFormatddMMYYYYDB
						.parse(ToDate);
				ToDate = simpleDateFormatYYYY.format(date);
				
				java.util.Date date1 = simpleDateFormatYYYY.parse(ToDate);
				ToDate = simpleDateFormatddMMYYAMPM.format(date1);					
			
				
				String substr = ToDate.substring(6, 10);
				if (substr.equals("1900")) {
					ToDate = "";
				}
			} else {
				ToDate = "";
			}

			String DT = rs.getString("PERMIT_DATE");
			if (rs.getString("PERMIT_DATE") != null
					&& !rs.getString("PERMIT_DATE").equals("")) {
				java.util.Date date = simpleDateFormatddMMYYYYDB.parse(DT);
				DT = simpleDateFormatYYYY.format(date);
				
				java.util.Date date1 = simpleDateFormatYYYY.parse(DT);
				DT = simpleDateFormatddMMYY.format(date1);
				String substr = DT.substring(6, 10);
				if (substr.equals("1900")) {
					DT = "";
				}
			} else {
				DT = "";
			}

		    finlist = new ArrayList();
		    finlist.add(rs.getInt("PERMIT_ID"));
			finlist.add(rs.getString("PERMIT_NO"));
			finlist.add(DT);
			finlist.add(rs.getString("CONTRACTOR_ID"));
			finlist.add(rs.getString("CONTRACT_NO"));
			finlist.add(rs.getString("VEHICLE_NO"));
			finlist.add(rs.getDouble("QUANTITY")+" CBM");
			finlist.add(rs.getString("SAND_BLOCK_ID"));
			finlist.add(rs.getString("STOCKYARD_ID"));
			finlist.add(vaalidFrom);
			finlist.add(ToDate);
			finlist.add(rs.getString("PROCESSING_FEES"));
			finlist.add(vehicleType);
			
			list.add(finlist);
			
		}
		pstmt.close();
		rs.close();

		pstmt = con
				.prepareStatement("update AMS.dbo.SAND_INWARD_TRIP_SHEET set PRINTED='Y'  where PERMIT_ID in("
						+ uids + ") ");
		int updated = pstmt.executeUpdate();
		pstmt.close();


	}

	catch (Exception e) {
		System.out.println("Error in getting Master Details:"
				+ e.toString());
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}

	return list;

}

public String getPermitNo(String custId,int systemId) {
    
    PreparedStatement pstmt = null;
    Connection con = null;
    String permitNo=null;
    ResultSet rs = null;
    try {
    	con = DBConnection.getConnectionToDB("AMS");
        pstmt = con.prepareStatement(SandMiningStatements.GET_PERMIT_NO);
        pstmt.setInt(1, systemId);
        pstmt.setInt(2, Integer.parseInt(custId));
        
        rs = pstmt.executeQuery();
        if (rs.next()) {
        	permitNo=rs.getString("PERMIT_NO") ; 
        	if(permitNo!=null && permitNo!="")
        	{
        		permitNo=permitNo.substring(permitNo.lastIndexOf("-")+1, permitNo.length());
        		permitNo="SIP-2016-17-"+(Integer.parseInt(permitNo)+1);
        		
        	}
        }
        else
        {
        permitNo="SIP-2016-17-1";	
        }

    } catch (Exception e) {
    	 e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return permitNo;
}

public JSONArray getBankNames()
{
	PreparedStatement pstmt = null;
    Connection con = null;
    String permitNo=null;
    ResultSet rs = null;
    String bankName=null;
    JSONArray jsonArray=new JSONArray();
    try {
    	con = DBConnection.getConnectionToDB("AMS");
        pstmt = con.prepareStatement(SandMiningStatements.GET_BANK_NAMES);
        rs = pstmt.executeQuery();
            while (rs.next()) {
            JSONObject bankDetails=new JSONObject();
            bankDetails.put("bankid", rs.getInt("ID"));
            bankName=rs.getString("BANK_NAME")+"(" +rs.getString("BANK_CODE")+ ")";
            bankDetails.put("bankName", bankName);
            jsonArray.put(bankDetails);
            }
          

    } catch (Exception e) {
    	 e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return jsonArray;
}


public String getBankCode(String bankId,String ddNo,String custId,int systemId)
{
	PreparedStatement pstmt = null;
    Connection con = null;
    ResultSet rs = null;
    String bankCode=null;
   
    try {
    	
    	String ddnos[]=ddNo.split("-");
    	if(ddnos.length>0)
    	{
    	ddNo=ddnos[0];	
    	}
    	con = DBConnection.getConnectionToDB("AMS");
        pstmt = con.prepareStatement(SandMiningStatements.GET_BANK_CODE);
        pstmt.setInt(1, Integer.parseInt(bankId));
        rs = pstmt.executeQuery();
            if (rs.next()) {
            bankCode=ddNo+"-"+rs.getString("BANK_CODE");
            //    pstmt1=con.prepareStatement(SandMiningStatements.GET_BANK_CODE);
            // pstmt1.setString(1, bankCode);
            // rs1=pstmt1.executeQuery();
            // if(rs1.next())
            //  {
            //  bankCode="DD No : "+ddNo+" Already Exist Please Enter Unique DD No";	
            // return bankCode;
            //  }
            }
            else bankCode="";

    } catch (Exception e) {
    	 e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return bankCode;	
	
}

//*******************************Application Nos************************************************//
public JSONArray getApplicationNos(String custId,int systemId,String tpNo)
{
	PreparedStatement pstmt = null;
    Connection con = null;
    ResultSet rs = null;
    JSONArray jsonArray=new JSONArray();
    String consumerName=null;
    try {
    	con = DBConnection.getConnectionToDB("AMS");
    	if(tpNo !=null && tpNo !=""){
    		pstmt = con.prepareStatement(SandMiningStatements.GET_APPLICATION_NOS  +" and TP_ID="+tpNo);
    	}else{
    		pstmt = con.prepareStatement(SandMiningStatements.GET_APPLICATION_NOS);
    	}
    		 
    		pstmt.setInt(1, systemId);
    		pstmt.setString(2, custId);
       
        rs = pstmt.executeQuery();
            while (rs.next()) {
            JSONObject applicationNos=new JSONObject();
            applicationNos.put("applicationNo", rs.getString("CONSUMER_APPLICATION_NO")); 
            String c=rs.getString("SAND_CONSUMER_NAME");
            if(!rs.getString("SAND_CONSUMER_NAME").equals(""))
            { consumerName=rs.getString("SAND_CONSUMER_NAME");}
            else if(!rs.getString("CONTRACTOR_NAME").equals(""))
            {consumerName=rs.getString("CONTRACTOR_NAME"); }
            else if(!rs.getString("GOVERNMENT_DEPT_NAME").equals(""))
            {  consumerName=rs.getString("GOVERNMENT_DEPT_NAME"); }
            if(consumerName.isEmpty()) consumerName="NA";
            applicationNos.put("consumerName", consumerName);
            applicationNos.put("sandQuantity", rs.getString("APPROVED_SAND_QUNATITY"));
            applicationNos.put("mobileNo", rs.getString("MOBILE_NUMBER"));
            jsonArray.put(applicationNos);
            }
          

    } catch (Exception e) {
    	 e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return jsonArray;
}

//********************************Add credit details*********************************************//

public String insertSandCreditDetails(int userId,int systemId,String custId,String applicationNo,String consumerName,double sandQuantity,double ddAmount,String ddNo,String ddDate,String bankName,String branchName,String tpNo,String consumerMobileNo,String tpMobileNo,int tpId)

{
	PreparedStatement pstmt=null,pstmt1 = null;
    Connection connection = null;
    ResultSet rs=null,rs1 = null;
    int update=0;
    String messsage=null;
    double balAmount=0.0;
    try{
    	 Date date = simpleDateFormatddMMYYYYDB1.parse(ddDate);
    	 ddDate=simpleDateFormatddMMYYYYDB.format(date); 
        connection=DBConnection.getConnectionToDB("AMS");
        if(!ddNo.equals(null) && !ddNo.equals("")){
        pstmt1=connection.prepareStatement(SandMiningStatements.CHECK_DUPLICATE_DD_NO);
        pstmt1.setInt(1,systemId);
        pstmt1.setString(2,custId);
        pstmt1.setString(3,ddNo);
        rs1=pstmt1.executeQuery();
        if(rs1.next())
        {
        	messsage="DD No is Already Exist. Please Enter Unique DD No";
        	return messsage;
        }
        }
        pstmt1=connection.prepareStatement(SandMiningStatements.CHECK_APPLICATION_NO);
        pstmt1.setInt(1, systemId);
        pstmt1.setString(2, custId);
        pstmt1.setString(3, applicationNo);
        pstmt1.setInt(4, userId);
        rs1=pstmt1.executeQuery();
        if(rs1.next())
        {
        balAmount=rs1.getDouble("BALANCE_AMOUNT")+ddAmount;	
        //**************Update previous balance amount to 0 *****************
        pstmt1=connection.prepareStatement(SandMiningStatements.UPDATE_PREVIOUS_BALANCE_AMOUNT);	
    	pstmt1.setDouble(1,0 );
    	pstmt1.setString(2, applicationNo);
    	pstmt1.setInt(3, systemId);
    	pstmt1.setString(4, custId);
    	pstmt1.setInt(5, userId);
    	int update1=pstmt1.executeUpdate();
        }
        else
        balAmount=ddAmount;
        pstmt1.close();
        rs1.close();
        
//        pstmt1=connection.prepareStatement(SandMiningStatements.CHECK_APPLICATION_NO);
//        pstmt1.setInt(1, systemId);
//        pstmt1.setString(2, custId);
//        pstmt1.setString(3, applicationNo);
//        rs1=pstmt1.executeQuery();
        
        pstmt = connection.prepareStatement(SandMiningStatements.INSERT_CREDIT_DETAILS);
    	pstmt.setString(1, applicationNo);
    	pstmt.setString(2, consumerName);
    	pstmt.setDouble(3, sandQuantity);
    	pstmt.setString(4, ddNo);
    	pstmt.setDouble(5, ddAmount);
    	pstmt.setString(6, ddDate);
    	pstmt.setString(7, bankName);
    	pstmt.setString(8, branchName);
    	pstmt.setInt(9, systemId);
    	pstmt.setInt(10, Integer.parseInt(custId));
    	pstmt.setInt(11, userId);
    	pstmt.setDouble(12, balAmount);
    	pstmt.setInt(13, tpId);
    	pstmt.setString(14, tpNo);
    	
    	update=pstmt.executeUpdate();
    	if(update>0)
    	{
//    	update=0;	
//    	pstmt1=connection.prepareStatement(SandMiningStatements.UPDATE_BALANCE_AMOUNT);	
//    	pstmt1.setDouble(1,balAmount );
//    	pstmt1.setString(2, applicationNo);
//    	pstmt1.setInt(3, systemId);
//    	pstmt1.setString(4, custId);
//    	update=pstmt1.executeUpdate();
//    	if(update>0)
//    	{
    		pstmt = connection.prepareStatement(SandMiningStatements.CONSUMER_CREDIT_SMS);
    		pstmt.setInt(1, systemId);
	        rs = pstmt.executeQuery();
	        if(rs.next()){
	        	if(rs.getString("value").equalsIgnoreCase("Y")){
	        		messsage=sendConsumerSMS(consumerMobileNo,consumerName,custId,systemId,applicationNo,tpNo,tpMobileNo,ddAmount,balAmount,sandQuantity,connection );
	        		messsage=sendTpOwnerSMS(consumerMobileNo,consumerName,custId,systemId,applicationNo,tpNo,tpMobileNo,ddAmount,balAmount,sandQuantity,connection );
	        	}else{
	        		messsage = "Saved Successfully";
		        }
	        }else{
	        	messsage = "Saved Successfully";
            }
    	  //}
    	}
    	else
    	messsage="Error While Saving";
    		
    }
    catch (Exception e) {
		// TODO: handle exception
    	e.printStackTrace();
	}
    finally
    {
    DBConnection.releaseConnectionToDB(connection, pstmt, rs);	
    DBConnection.releaseConnectionToDB(null, pstmt1, rs);	
    }
    
    return messsage;
}

//*******************************************Consumer Credit Details***********************************************//

public ArrayList<Object> getConsumerCreditDetails(int systemId,String customerId,String jspName,String language,String startDate,String endDate)
{ JSONArray JsonArray = null;
Connection con = null;
PreparedStatement pstmt = null;
PreparedStatement pstmt1 = null;
JSONObject hubdetails = null;
ArrayList < String > headersList = new ArrayList < String > ();
int count=0;
ResultSet rs = null;
ResultSet rs1 = null;
String s=null;

ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
ReportHelper finalreporthelper = new ReportHelper();
ArrayList < Object > finlist = new ArrayList < Object > ();

try {
	
Date date = simpleDateFormatddMMYYYYDB1.parse(startDate);
startDate=simpleDateFormatddMMYYYYDB.format(date); 
Date date1 = simpleDateFormatddMMYYYYDB1.parse(endDate);
endDate=simpleDateFormatddMMYYYYDB.format(date1); 
JsonArray = new JSONArray();
headersList.add(cf.getLabelFromDB("SLNO", language));
headersList.add(cf.getLabelFromDB("Consumer_Application_No", language));
headersList.add(cf.getLabelFromDB("Enter_Consumer_Name", language));
headersList.add(cf.getLabelFromDB("Approved_Sand_Quantity", language));
headersList.add(cf.getLabelFromDB("DD_Amount", language));
headersList.add(cf.getLabelFromDB("Balance_Amount", language));
headersList.add(cf.getLabelFromDB("DD_No", language));
headersList.add(cf.getLabelFromDB("DD_Date", language));
headersList.add(cf.getLabelFromDB("Bank_Name", language));
headersList.add(cf.getLabelFromDB("Branch_Name", language));
headersList.add(cf.getLabelFromDB("Entry_Date", language));


con = DBConnection.getConnectionToDB("AMS");
pstmt=con.prepareStatement(SandMiningStatements.GET_CREDIT_DETAILS);
pstmt.setInt(2, systemId);
pstmt.setString(1, customerId);
pstmt.setString(3, startDate);
pstmt.setString(4, endDate);
rs=pstmt.executeQuery();
while(rs.next())
{
count++;
JSONObject creditDetails=new JSONObject();
ArrayList < Object > informationList = new ArrayList < Object > ();
ReportHelper reporthelper = new ReportHelper();

creditDetails.put("slnoIndex", count);
creditDetails.put("applicationNoindex", rs.getString("CONSUMER_APPLICATION_NO"));
creditDetails.put("consumerNameindex", rs.getString("CONSUMER_NAME"));
creditDetails.put("approvedQuantityindex", rs.getString("APPROVED_SAND_QUANTITY"));
creditDetails.put("ddAmountindex", rs.getString("DD_AMOUNT"));
creditDetails.put("balanceAmountindex", rs.getString("BALANCE_AMOUNT"));
creditDetails.put("ddNoindex", rs.getString("DD_NO"));
creditDetails.put("ddDateindex", simpleDateFormatdd_MM_YY.format(rs.getTimestamp("DD_DATE")));
creditDetails.put("bankNameindex", rs.getString("BANK_NAME"));
creditDetails.put("branchNameindex", rs.getString("BRANCH_NAME"));
creditDetails.put("entryDateindex", simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("CREATED_DATE")));

informationList.add(count);
informationList.add(rs.getString("CONSUMER_APPLICATION_NO"));
informationList.add(rs.getString("CONSUMER_NAME"));
informationList.add(rs.getString("APPROVED_SAND_QUANTITY"));
informationList.add(rs.getString("DD_AMOUNT"));
informationList.add(rs.getString("BALANCE_AMOUNT"));
informationList.add(rs.getString("DD_NO"));
informationList.add(simpleDateFormatdd_MM_YY.format(rs.getTimestamp("DD_DATE")));
informationList.add(rs.getString("BANK_NAME"));
informationList.add(rs.getString("BRANCH_NAME"));
informationList.add(simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("CREATED_DATE")));

JsonArray.put(creditDetails);
reporthelper.setInformationList(informationList);
reportsList.add(reporthelper);
}
finalreporthelper.setReportsList(reportsList);
finalreporthelper.setHeadersList(headersList);
finlist.add(JsonArray);
finlist.add(finalreporthelper);
}
catch (Exception e) {
e.printStackTrace();
} finally {
    DBConnection.releaseConnectionToDB(con, pstmt, rs);
}
return finlist;
}

public JSONArray getVehicleGRID(int systemid, String clientId,
		String type, int userId, int offset) {

	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs1 = null;
	ArrayList L = new ArrayList();
	SimpleDateFormat sdfFrom = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdfTo = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	String vehicle="";
	try {
		con = DBConnection.getConnectionToDB("AMS");
		if (type != null && type.equalsIgnoreCase("LeaseOwner")) {
			if(systemid==192)
			{
				pstmt = con.prepareStatement(SandMiningStatements.GET_VEHICLE_NO_SYS_LEASE_OWNER_FOR_MDP_GENERATOR);
			}
			else
			{
				pstmt = con.prepareStatement(SandMiningStatements.GET_VEHICLE_NO_LEASE_OWNER_FOR_MDP_GENERATOR);
		
			}
			//pstmt.setString(1, systemid);
			pstmt.setString(1, clientId);
			pstmt.setInt(2, systemid);
			pstmt.setInt(3, userId);

			rs = pstmt.executeQuery();
			JSONObject obj1 = new JSONObject();
			while (rs.next()) {
				obj1 = new JSONObject();
				vehicle=rs.getString("VEHICLENO");
				obj1.put("vehicleno", rs.getString("VEHICLENO"));
				obj1.put("VehOwner", rs.getString("OwnerName"));
				obj1.put("VehAddr", rs.getString("OwnerAddress"));
				obj1.put("model", rs.getString("Model"));
				jsonArray.put(obj1);
			}

		} else {
			pstmt = con.prepareStatement(SandMiningStatements.GET_VEHICLE_NO_FOR_MDP_GENERATOR);
			//pstmt.setString(1, systemid);
			pstmt.setInt(1, systemid);
			pstmt.setString(2, type);
			rs = pstmt.executeQuery();
			JSONObject obj1 = new JSONObject();
			while (rs.next()) {
				obj1 = new JSONObject();
				vehicle=rs.getString("VEHICLENO");
				obj1.put("vehicleno", rs.getString("VEHICLENO"));
				obj1.put("VehOwner", rs.getString("OwnerName"));
				obj1.put("VehAddr", rs.getString("OwnerAddress"));
				obj1.put("model", rs.getString("Model"));
				jsonArray.put(obj1);
			}
		}
		pstmt1= con.prepareStatement(SandMiningStatements.GET_VEHICLE_NO_FOR_MDP_GENERATOR);
		pstmt.setString(1, vehicle);

	} catch (Exception e) {
		System.out.println("Exception getting getVehicle(): " + e);
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;

}

public JSONArray getFromSandPortStore(int systemid, String clientId,
		int userId,String appNo ) {

	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs1 = null;
	boolean CONSUMER_MDP_FEATURE = false;
	try {
		con = DBConnection.getConnectionToDB("AMS");
		CONSUMER_MDP_FEATURE = CONSUMER_MDP_FEATURE(systemid,con);
		if(CONSUMER_MDP_FEATURE){
			pstmt = con.prepareStatement(SandMiningStatements.GET_CONSUMER_SAND_PORT);
			pstmt.setInt(1, systemid);
			pstmt.setString(2,clientId);
			pstmt.setInt(3, systemid);
			pstmt.setString(4,appNo);
			rs = pstmt.executeQuery();
		}else{
		pstmt = con.prepareStatement(SandMiningStatements.GET_FROM_SAND_PORT);
		pstmt.setInt(1, systemid);
		pstmt.setString(2,clientId);
		pstmt.setInt(3, systemid);
		rs = pstmt.executeQuery();
		}
		JSONObject obj1 = new JSONObject();
		while (rs.next()) {
			obj1 = new JSONObject();
			obj1.put("portNo", rs.getString("Port_No"));
			obj1.put("portName", rs.getString("Port_Name"));
			obj1.put("portVillage", rs.getString("Port_Village"));
			obj1.put("portTaluk", rs.getString("Port_Taluk"));
			obj1.put("portSurveyNumber", rs.getString("Port_Survey_Number"));
			obj1.put("portUniqueid", rs.getString("UniqueId"));
			obj1.put("assessedQuantity", rs.getString("ASSESSED_QUANTITY"));
			obj1.put("lat", rs.getString("LATITUDE"));
			obj1.put("longi", rs.getString("LONGITUDE"));
			jsonArray.put(obj1);
		}
	} catch (Exception e) {
		System.out.println("Exception getting getPermitNosALL(): " + e);
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;

}

public JSONArray getToPlaceStore(int systemid, String clientId,
		int userId) {

	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_DISTINCT_TO_PLACE);
		pstmt.setInt(1, systemid);
		pstmt.setString(2, clientId);
		rs = pstmt.executeQuery();
		JSONObject obj1 = new JSONObject();
		while (rs.next()) {
			obj1 = new JSONObject();
			obj1.put("toPlace", rs.getString("To_Palce").toUpperCase());

			jsonArray.put(obj1);
		}
	} catch (Exception e) {
		System.out.println("Exception getting getToPlaceStore(): " + e);
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;

}

public JSONArray getApplicationNoStore(int systemid, String clientId,int userId)
 {

	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	boolean CONSUMER_MDP_FEATURE = false;
	try {
		con = DBConnection.getConnectionToDB("AMS");
		CONSUMER_MDP_FEATURE = CONSUMER_MDP_FEATURE(systemid,con);
		if(CONSUMER_MDP_FEATURE){
			pstmt = con.prepareStatement(SandMiningStatements.GET_APPLICATION_NO + "order by a.CREATED_DATE asc");
			pstmt.setInt(1, systemid);
			pstmt.setString(2, clientId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
		}else{
		pstmt = con.prepareStatement(SandMiningStatements.GET_APPLICATION_NO);
		pstmt.setInt(1, systemid);
		pstmt.setString(2, clientId);
		pstmt.setInt(3, userId);
		rs = pstmt.executeQuery();
		}
		JSONObject obj1 = new JSONObject();
		while (rs.next()) {
			obj1 = new JSONObject();
			obj1.put("ApplicationNo", rs.getString("CONSUMER_APPLICATION_NO"));
			obj1.put("consumerName", rs.getString("CONSUMER_NAME"));
			obj1.put("workAddress",rs.getString("WORK_ADDRESS") );
			obj1.put("latitude",rs.getString("LATITUDE") );
			obj1.put("longitude",rs.getString("LONGITUDE") );
			obj1.put("consumerMobile",rs.getString("MOBILE_NUMBER") );
			jsonArray.put(obj1);
		}
	} catch (Exception e) {
		System.out.println("Exception getting getApplicationNoStore(): " + e);
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;

}

public ArrayList getTSDetailsGRID_Kan_Shimoga(int systemid,
		String clientIdFromJsp, int offset, int userId) {
	JSONArray jsonArray = new JSONArray();
	JSONObject obj1 = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String stmt = "";
	String DateofEntry = "";
	String ValidFrom = "";
	String ValidTo = "";
	String ddDate = "";
	String DateofEntry1 = "";
	String ValidFrom1 = "";
	String ValidTo1 = "";
	String ddDate1 = "";
	
	ArrayList reportsList = new ArrayList();
	ArrayList headersList = new ArrayList();
	ReportHelper finalreporthelper = new ReportHelper();
	ArrayList finlist = new ArrayList();
	int count = 0;

	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_MDP_GENERATOR_DETAILS);
		pstmt.setInt(1, offset);
		pstmt.setInt(2, offset);
		pstmt.setInt(3, offset);
		pstmt.setInt(4, offset);
		pstmt.setInt(5, systemid);
		pstmt.setString(6, clientIdFromJsp);
		pstmt.setInt(7, userId);
		pstmt.setInt(8, offset);
		pstmt.setInt(9, offset);
		pstmt.setInt(10, offset);
		pstmt.setInt(11, offset);
		pstmt.setInt(12, systemid);
		pstmt.setString(13, clientIdFromJsp);
		pstmt.setInt(14, userId);


		rs = pstmt.executeQuery();
		headersList.add("SLNO");
		headersList.add("Unique Id");
		headersList.add("Application No");
		headersList.add("MDP No");
		headersList.add("Permit No");
		headersList.add("Validity Period");
		headersList.add("Transporter Name");
		headersList.add("Customer Name");
		headersList.add("Driver Name");
		headersList.add("Transporter");
		headersList.add("Ml No");
		headersList.add("Vehicle No");
		headersList.add("Customer Address");
		headersList.add("District");
		headersList.add("Quantity");
		headersList.add("From Sand Port");
		headersList.add("Via Route");
		headersList.add("To Place");
		headersList.add("Sand Port No");
		headersList.add("Sand Port Unique No");
		headersList.add("Valid From");
		headersList.add("Valid To");
		headersList.add("Mineral Type");
		headersList.add("Loading Type");
		headersList.add("Survey No");
		headersList.add("Village");
		headersList.add("Taluk");
		headersList.add("Amount/CubicMeter (Rs.)");
		headersList.add("Processing Fee (Rs.)");
		headersList.add("Total Fee (Rs.)");
		headersList.add("Printed");
		headersList.add("MDP Date");
		headersList.add("DD Number");
		headersList.add("Bank Name");
		headersList.add("DD Date");
		headersList.add("Group Id");
		headersList.add("Group Name");
		headersList.add("Index No");
		headersList.add("Sand Loading From Time");
		headersList.add("Sand Loading To Time");
		headersList.add("Sand Extraction From");
		headersList.add("Distance");
		
		while (rs.next()) {
			count++;
			obj1 = new JSONObject();
			ArrayList informationList = new ArrayList();
			ReportHelper reporthelper = new ReportHelper();

			// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
			
			if (rs.getString("Date_TS") != null && !rs.getString("Date_TS").equals("") && !rs.getString("Date_TS").contains("1900")) {
				DateofEntry = sdf.format(rs.getTimestamp("Date_TS"));
				DateofEntry1 = simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("Date_TS"));
			} else {
				DateofEntry = "";
				DateofEntry1 = "";
			}

			if (rs.getString("From_Date") != null && !rs.getString("From_Date").equals("") && !rs.getString("From_Date").contains("1900")) {
				ValidFrom = sdf.format(rs.getTimestamp("From_Date"));
				ValidFrom1 = simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("From_Date"));
			} else {
				ValidFrom = "";
				ValidFrom1 = "";
			}

			if (rs.getString("To_Date") != null && !rs.getString("To_Date").equals("") && !rs.getString("To_Date").contains("1900")) {
				ValidTo = sdf.format(rs.getTimestamp("To_Date"));
				ValidTo1 = simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("To_Date"));
			} else {
				ValidTo = "";
				ValidTo1 = "";
			}

			if (rs.getString("DD_Date") != null && !rs.getString("DD_Date").equals("")) {
				ddDate = sdf.format(rs.getTimestamp("DD_Date"));
				ddDate1 = simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("DD_Date"));
			} else {
				ddDate = "";
				ddDate1 = "";
			}

			informationList.add(count);
			obj1.put("SLNODataIndex", count);

			informationList.add(rs.getString("TS_ID"));
			obj1.put("UniqueIdDataIndex", rs.getString("TS_ID"));
			
			informationList.add(rs.getString("CONSUMER_APPLICATION_NO"));
			obj1.put("applicationNODataIndex",rs.getString("CONSUMER_APPLICATION_NO"));

			informationList.add(rs.getString("Trip_Sheet_No"));
			obj1.put("TripSheetNODataIndex", rs.getString("Trip_Sheet_No"));

			informationList.add(rs.getString("Permit_No"));
			obj1.put("PermitNoDataIndex", rs.getString("Permit_No"));

			informationList.add(rs.getString("Validity_Period"));
			obj1.put("ValidityPeriodDataIndex", rs.getString("Validity_Period"));
			
			informationList.add(rs.getString("Lessee_Name"));
			obj1.put("PermitHolderDataIndex", rs.getString("Lessee_Name"));
			
			informationList.add(rs.getString("Customer_Name"));
			obj1.put("CustomerNameDataIndex",rs.getString("Customer_Name"));
			
			informationList.add(rs.getString("Driver_Name"));
			obj1.put("DriverIndex", rs.getString("Driver_Name"));

			informationList.add(rs.getString("Lessee_Type"));
			obj1.put("TransporterDataIndex", rs.getString("Lessee_Type"));

			informationList.add(rs.getString("MiNo"));
			obj1.put("MlnoDataIndex", rs.getString("MiNo"));

			informationList.add(rs.getString("Vehicle_No"));
			obj1.put("VehicleNoDataIndex", rs.getString("Vehicle_No"));

			informationList.add(rs.getString("Vehicle_Addr"));
			obj1.put("VehicleAddrDataIndex", rs.getString("Vehicle_Addr"));

			informationList.add(rs.getString("District"));
			obj1.put("DistrictDataIndex", rs.getString("District"));

			informationList.add(rs.getString("Quantity"));
			obj1.put("QuantityDataIndex", rs.getString("Quantity"));

			informationList.add(rs.getString("From_Place"));
			obj1.put("FromPlaceDataIndex", rs.getString("From_Place"));

			informationList.add(rs.getString("Via_Route"));
			obj1.put("ViaRouteDataIndex", rs.getString("Via_Route"));

			informationList.add(rs.getString("To_Palce"));
			obj1.put("ToPlaceIndex", rs.getString("To_Palce"));

			informationList.add(rs.getString("Port_No"));
			obj1.put("SandPortNoIndex", rs.getString("Port_No"));
			
			informationList.add(rs.getString("PORT_ID"));
			obj1.put("SandPortUniqueIdIndex", rs.getString("PORT_ID"));

			informationList.add(ValidFrom1);
			obj1.put("DateOfEntryDataIndex", ValidFrom);

			informationList.add(ValidTo1);
			obj1.put("DateOfEntryDataIndex1", ValidTo);

			informationList.add(rs.getString("Mineral_Type"));
			obj1.put("MiningTypeDataIndex", rs.getString("Mineral_Type"));

			informationList.add(rs.getString("Loading_Type"));
			obj1.put("LoadingTypeDataIndex", rs.getString("Loading_Type"));

			informationList.add(rs.getString("Survey_No"));
			obj1.put("SurveyNoDataIndex", rs.getString("Survey_No"));

			informationList.add(rs.getString("Village"));
			obj1.put("VillageDataIndex", rs.getString("Village"));

			informationList.add(rs.getString("Taluk"));
			obj1.put("TalukDataIndex", rs.getString("Taluk"));

			informationList.add(rs.getDouble("Royalty"));
			obj1.put("RoyalityDataIndex", rs.getDouble("Royalty"));

			informationList.add(rs.getDouble("Processing_Fee"));
			obj1.put("ProcessingFeeDataIndex", rs.getDouble("Processing_Fee"));

			informationList.add(rs.getDouble("Total_Fee"));
			obj1.put("TotalFeeDataIndex", rs.getDouble("Total_Fee"));

			informationList.add(rs.getString("Printed"));
			obj1.put("PrintedIndex", rs.getString("Printed"));

			informationList.add(DateofEntry1);
			obj1.put("TSDateDataIndex", DateofEntry);

			informationList.add(rs.getString("DD_No"));
			obj1.put("DDNumberDataIndex", rs.getString("DD_No"));

			informationList.add(rs.getString("Bank_Name"));
			obj1.put("BankNameIndex", rs.getString("Bank_Name"));

			informationList.add(ddDate1);
			obj1.put("DDDateDataIndex", ddDate);

			informationList.add(rs.getString("Group_Id"));
			obj1.put("GroupIdDataIndex", rs.getString("Group_Id"));

			informationList.add(rs.getString("Group_Name"));
			obj1.put("GroupNameIndex", rs.getString("Group_Name"));

			informationList.add(rs.getString("Index_No"));
			obj1.put("IndexNoIndex", rs.getString("Index_No"));
			
			informationList.add(rs.getString("Sand_Loading_From_Time"));
			obj1.put("SandLoadingFromTimeIndex", rs.getString("Sand_Loading_From_Time"));
			
			informationList.add(rs.getString("Sand_Loading_To_Time"));
			obj1.put("SandLoadingToTimeIndex", rs.getString("Sand_Loading_To_Time"));
			
			informationList.add(rs.getString("SAND_EXTRACTION_FROM"));
			obj1.put("extractionindx", rs.getString("SAND_EXTRACTION_FROM"));
			
			informationList.add(rs.getString("DISTANCE"));
			obj1.put("distanceindex", rs.getString("DISTANCE"));

			jsonArray.put(obj1);
			reporthelper.setInformationList(informationList);
			reportsList.add(reporthelper);
		}

		finalreporthelper.setReportsList(reportsList);
		finalreporthelper.setHeadersList(headersList);
	}

	catch (Exception e) {
		System.out.println("Error in getting Master Details:"
				+ e.toString());
		e.printStackTrace();
	} finally {
		finlist.add(jsonArray);
		finlist.add(finalreporthelper);
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}

	return finlist;

}

public JSONArray getRoyalityStoreStore(int systemId,String portName){
	
	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs1 = null;
	
	try{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_ROYALTY);
		pstmt.setInt(1, systemId);
		pstmt.setString(2,portName);
		rs = pstmt.executeQuery();
		JSONObject obj1 = new JSONObject();
		while (rs.next()) {
			obj1 = new JSONObject();
			obj1.put("SelfAmountNew", rs.getString("Self_Amount"));
			obj1.put("MachineAmountNew", rs.getString("Machine_Amount"));
			obj1.put("DefaultLoadType", rs.getString("Default_Load_Type"));
			obj1.put("TalukNew", rs.getString("Taluka"));
			obj1.put("TSNOFormat", rs.getString("Trip_Sheet_Format"));
			obj1.put("SandLoadingFromTime", rs.getString("Sand_Loading_From_Time"));
			obj1.put("SandLoadingToTime", rs.getString("Sand_Loading_To_Time"));

			jsonArray.put(obj1);
		}	
	}catch(Exception e){
		
	}
	finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;
	
}

public String insert_TS_GRID_Kan(String uniqueId,
		String tripSheetNO, String permitNo, String permitHolder,
		String royality, String vehicleNo, String fromPlace,
		String toPlace, String dateOfEntry, String printed,
		int systemid, String globalClientId, int offset,
		String surveyNoNew, String villageNew, String talukNew,
		String miningType, String quantity, String processing,
		String totalFee, String transporter, String validTo,
		String tSDATE, int userId,String vehAddr,
		String portNo, String loadingType,
		String dDNO, String bANKNAME, String dDDATE, String gROUPID,
		String gROUPNAME, String driverNAME, String viaRoute,String SandPortUniqueId,
		String sandLoadingFromTime,String sandLoadingToTime,String customerName,String applicationNoAdd,String validityPeriodModify,String sandPortUniqueIdAdd,String sandExtraction,String fromstockyard,String fromstockyardId,String distanceAdd,String latitude,String longitude, String customerMobileAdd) {

	String message = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt1 = null;
	PreparedStatement pstmt2 = null;
	ResultSet rs1 = null;
	boolean f = false;
	String fromdatenew=null;
	int inserted = 0;
	int inserted1 = 0;
	int count = 0;
	try {
		con = DBConnection.getConnectionToDB("AMS");
		//message = getConsumerType(systemid,globalClientId,applicationNoAdd,offset);
		
		//if(!message.equals(""))
		//{
		//	return message;
		//} else {
		//if(sandExtraction.equals("Sand Block")){
		//message = getTSCountForPort(systemid, globalClientId, loadingType,
		//		fromPlace, offset, gROUPID, gROUPNAME);
		//}
		//if (!message.equalsIgnoreCase("Error")) {
		Date date = (new Date());
			if (dateOfEntry.contains("T")) {
				dateOfEntry = dateOfEntry.replace("T", " ");
				fromdatenew=dateOfEntry;
			}
			
			if (validTo.contains("T")) {
				validTo = validTo.replace("T", " ");
			} 
			
//			if (tSDATE.contains("T")) {
//				tSDATE = tSDATE.replace("T", " ");
//			} 
			
			if (dDDATE.contains("T")) {
				dDDATE = dDDATE.replace("T", " ");
			}
			
			String[] temp = tripSheetNO.split("-");

			String teest = tripSheetNO.substring(0, tripSheetNO
					.lastIndexOf("-") + 1);

			int tno = Integer.parseInt(temp[temp.length - 1]);

			pstmt1 = con.prepareStatement(SandMiningStatements.GET_TRIP_SHEET_NO);

			pstmt1.setInt(1, systemid);
			pstmt1.setInt(2, Integer.parseInt(globalClientId));
			pstmt1.setInt(3, systemid);
			pstmt1.setInt(4, Integer.parseInt(globalClientId));
			rs1 = pstmt1.executeQuery();
			if (rs1.next()) {
				String newTS = rs1.getString("Trip_Sheet_No");
				String[] temp1 = newTS.split("-");
				tno = Integer.parseInt(temp1[temp1.length - 1]);
				tno++;
				tripSheetNO = teest + Integer.toString(tno);

			}
			Date date4 = new Date();
			String D1 = simpleDateFormatddMMYYYYDB.format(date4).substring(0, 10)+ " 00:00:00";
			String D2 = simpleDateFormatddMMYYYYDB.format(date4).substring(0, 10)+ " 23:59:59";
			
			pstmt1 = con.prepareStatement(SandMiningStatements.GET_COUNT_TRIP_SHEET_NO);
			pstmt1.setInt(1, systemid);
			pstmt1.setString(2, globalClientId);
			pstmt1.setString(3, fromPlace);
			pstmt1.setInt(4, offset);
			pstmt1.setString(5, D1);
			pstmt1.setInt(6, offset);
			pstmt1.setString(7, D2);
			rs1 = pstmt1.executeQuery();
			if (rs1.next()) {
				count = rs1.getInt("count");
			}
			pstmt1.close();
			rs1.close();

			String bal = CheckBalanceGRID(systemid, globalClientId,
					permitNo, permitHolder, totalFee,applicationNoAdd);
			if (!bal.equalsIgnoreCase("Error")) {
				
				pstmt1 = con.prepareStatement(SandMiningStatements.GET_LATEST_MDP_DETAILS);
				pstmt1.setString(1, vehicleNo);
				pstmt1.setInt(2, systemid);
				pstmt1.setString(3, globalClientId);
				rs1=pstmt1.executeQuery();
				if(rs1.next())
				{
					String tdate=rs1.getString("To_Date");
					Date tdate1=simpleDateFormatddMMYYYYDB.parse(tdate);
					Date tdate2=simpleDateFormatddMMYYYYDB.parse(fromdatenew);
					
					if(tdate2.getTime()-tdate1.getTime()<=0)
					{
					return "Vehicle has Already Trip Sheet within this Duration";	
					}
				}
				if(sandExtraction.equals("Sand Block")){
				pstmt1 = con.prepareStatement(SandMiningStatements.GET_ASSESSED_QUANTITY);
				}
				else{
					pstmt1 = con.prepareStatement(SandMiningStatements.GET_STOCKYARD_QUANTITY);
				}
				pstmt1.setInt(1, systemid);
				pstmt1.setString(2, globalClientId);
				pstmt1.setInt(3,Integer.parseInt(SandPortUniqueId));
				pstmt1.setString(4, quantity);
				rs1=pstmt1.executeQuery();
				if(!rs1.next())
				{
					return "In-sufficient balance in sand port";
				}
				
				pstmt = con.prepareStatement(SandMiningStatements.INSERT_MDP_DETAILS);
				pstmt.setString(1, tripSheetNO);
				//pstmt.setInt(2, offset);
				//pstmt.setString(3, tSDATE);
				pstmt.setString(2, permitNo);
				pstmt.setString(3, permitHolder);
				pstmt.setString(4, transporter);
				pstmt.setString(5, miningType);
				pstmt.setString(6, surveyNoNew);
				pstmt.setString(7, villageNew);
				pstmt.setString(8, talukNew);
				pstmt.setString(9, quantity);
				pstmt.setString(10, royality);
				pstmt.setString(11, vehicleNo);
				pstmt.setString(12, fromPlace);
				pstmt.setString(13, toPlace);
				pstmt.setInt(14, offset);
				pstmt.setString(15, dateOfEntry);
				pstmt.setInt(16, offset);
				pstmt.setString(17, validTo);// todate
				pstmt.setInt(18, systemid);
				pstmt.setString(19, globalClientId);
				//pstmt.setString(22, mlno);
				pstmt.setString(20, processing);
				pstmt.setString(21, totalFee);
				pstmt.setString(22, printed);
				pstmt.setInt(23, userId);
				//pstmt.setString(27, district);
				pstmt.setString(24, vehAddr);
				pstmt.setString(25, portNo);
				pstmt.setString(26, loadingType);
				pstmt.setString(27, dDNO);
				pstmt.setString(28, bANKNAME);
				pstmt.setInt(29, offset);
				pstmt.setString(30, dDDATE);
				pstmt.setString(31, gROUPID);
				pstmt.setString(32, gROUPNAME);
				pstmt.setInt(33, ++count);
				pstmt.setString(34, driverNAME);
				pstmt.setString(35, viaRoute);
				pstmt.setInt(36,Integer.parseInt(SandPortUniqueId));
				pstmt.setString(37, sandLoadingFromTime);
				pstmt.setString(38, sandLoadingToTime);
				pstmt.setString(39, customerName);
				pstmt.setString(40, validityPeriodModify);
				pstmt.setString(41, applicationNoAdd);
				pstmt.setString(42, sandExtraction);
				pstmt.setString(43, distanceAdd);
				pstmt.setString(44, latitude);
				pstmt.setString(45, longitude);
				inserted = pstmt.executeUpdate();
				pstmt.close();

				if (inserted == 1) {
					
					if(sandExtraction.equals("Sand Block"))
					{
						pstmt1 = con.prepareStatement(SandMiningStatements.UPDATE_ASSESSED_QUANTITY);
						pstmt1.setDouble(1, Double.parseDouble(quantity));
						pstmt1.setInt(2, systemid);
						pstmt1.setString(3, globalClientId);
						pstmt1.setString(4, sandPortUniqueIdAdd);
						int updated1 = pstmt1.executeUpdate();	
					}
					else
					{
						pstmt1 = con.prepareStatement(SandMiningStatements.UPDATE_AVAILABLE_QUANTITY);
						pstmt1.setDouble(1, Double.parseDouble(quantity));
						pstmt1.setString(2, fromstockyardId);
						pstmt1.setInt(3, systemid);
						pstmt1.setString(4, globalClientId);
						int updated1 = pstmt1.executeUpdate();		
					}

					pstmt = con.prepareStatement(SandMiningStatements.UPDATE_GENERAL_SETTINGS);
					pstmt.setInt(1, tno);
					pstmt.setInt(2, systemid);
					pstmt.setString(3, globalClientId);
					inserted1 = pstmt.executeUpdate();
					pstmt.close();

					pstmt1 = con.prepareStatement(SandMiningStatements.UPDATE_CREDIT_AGAINST_TEMP_PERMIT);
					pstmt1.setDouble(1, Double.parseDouble(totalFee));
					pstmt1.setString(2, applicationNoAdd);
					pstmt1.setInt(3, systemid);
					pstmt1.setString(4, globalClientId);
					pstmt1.setDouble(5, Double.parseDouble(totalFee));
					int updated1 = pstmt1.executeUpdate();

					pstmt2 = con.prepareStatement(SandMiningStatements.UPDATE_QUANTITY_FOR_MDP);
					pstmt2.setString(1, quantity);
					pstmt2.setString(2, applicationNoAdd);
					pstmt2.setInt(3, systemid);
					pstmt2.setInt(4, Integer.parseInt(globalClientId));
					pstmt2.executeUpdate();
					
					pstmt = con.prepareStatement(SandMiningStatements.CONSUMER_MODULE_SMS);
			        pstmt.setInt(1, systemid);
			        rs = pstmt.executeQuery();
			        if(rs.next()){
			        	if(rs.getString("value").equalsIgnoreCase("Y")){
			         String Sms="Dear Consumer,The Vehicle No: "+vehicleNo+" is Taken MDP From: "+fromPlace+" To: "+toPlace+", Valid From: "+dateOfEntry+", Expected Delivery: "+validTo+" Generated on: "+simpleDateFormatddMMYY.format(date);
					 pstmt = con.prepareStatement(SandMiningStatements.UPDATE_SMS);
					 pstmt.setString(1, customerMobileAdd);
					 pstmt.setString(2, Sms);
					 pstmt.setString(3, "N");
					 pstmt.setString(4, globalClientId);
					 pstmt.setInt(5, systemid);
				     int insert=pstmt.executeUpdate();
			       }
			     }  	

				}
			} else {
				return "Balance is less then Total Fee..Deposit the amount";
			}

		//} else {
		//	return "Max number of Trip Sheets reached for this sand port and loading type combination...!";
		//}
		//}
	} catch (Exception e) {

		System.out.println("Exception getting getClientName(): " + e);
		e.printStackTrace();
	} finally {

		if (inserted > 0) {
			message = "Saved Successfully..!";
			System.out.println("Rest Of Karnataka MDP generated.. LTSP - "+systemid);
		} else {
			message = "Error in saving..Please Re-Enter!";
		}
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
	}
	return message;

}

public String update_TS_GRID_Kan(String uniqueId,
		String tripSheetNO, String permitNo, String permitHolder,
		String royality, String vehicleNo, String fromPlace,
		String toPlace, String dateOfEntry, String printed,
		int systemid, String globalClientId, int offset,
		String surveyNoNew, String villageNew, String talukNew,
		String miningType, String quantity, String processing,
		String totalFee, String transporter,String validTo,
		String tSDATE, int userId, String district, String vehAddr,
		String portNo, String validityPeriod, String loadingType,
		String dDNO, String bANKNAME, String dDDATE, String gROUPID,
		String gROUPNAME, String driverNAME, String viaRoute,String SandPortUniqueId,
		String sandLoadingFromTime,String sandLoadingToTime,String customerName,String applicationNoModify,String validityPeriodModify,String quantityModify,String sandportUniqueidModify,String extractionTypeModify,String distanceAdd) {

	String message = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt1 = null;
	PreparedStatement pstmt2 = null;
	ResultSet rs1 = null;
	String fromdatenew=null;
	String todatenew=null;
	boolean f = false;
	int inserted = 0;
	int updated1 = 0;
	try {
		con = DBConnection.getConnectionToDB("AMS");

		if(extractionTypeModify.equals("Sand Block")){
		message = getTSCountForPort(systemid, globalClientId, loadingType,
				fromPlace, offset, gROUPID, gROUPNAME);
		}
		if (!message.equalsIgnoreCase("Error")) {
			if (dateOfEntry.contains("T")) {
				dateOfEntry = dateOfEntry.replace("T", " ");
				fromdatenew=dateOfEntry;
			} 
			else fromdatenew=dateOfEntry;
				
			if (validTo.contains("T")) {
				validTo = validTo.replace("T", " ");
				todatenew=validTo;

			}
			else todatenew=validTo;
			if (tSDATE.contains("T")) {
				tSDATE = tSDATE.replace("T", " ");
			} 
			if (dDDATE.contains("T")) {
				dDDATE = dDDATE.replace("T", " ");
			}
			
			pstmt = con.prepareStatement(SandMiningStatements.GET_TOTAL_FEE);
			pstmt.setInt(1, Integer.parseInt(uniqueId));
			rs = pstmt.executeQuery();
			double add = 0;
			while (rs.next()) {
				add = rs.getDouble("Total_Fee");

			}
			String sdate=fromdatenew+".0";
			String edate=todatenew+".0";
			pstmt=con.prepareStatement(SandMiningStatements.GET_LATEST_MDP_MODIFY);
			pstmt.setString(1, vehicleNo);
			pstmt.setInt(2, systemid);
			pstmt.setString(3, globalClientId);
			pstmt.setString(4, tripSheetNO);
			rs=pstmt.executeQuery();
			if(rs.next())
			{ 
			if(sdate.equals(rs.getString("From_Date")) && edate.equals(rs.getString("To_Date"))){}
			else
			{
			pstmt1 = con.prepareStatement(SandMiningStatements.GET_LATEST_MDP_DETAILS);
			pstmt1.setString(1, vehicleNo);
			pstmt1.setInt(2, systemid);
			pstmt1.setString(3, globalClientId);
			rs1=pstmt1.executeQuery();
			if(rs1.next())
			{
				String tdate=rs1.getString("To_Date");
				Date tdate1=simpleDateFormatddMMYYYYDB.parse(tdate);
				Date tdate2=simpleDateFormatddMMYYYYDB.parse(fromdatenew);
				
				if(tdate2.getTime()-tdate1.getTime()<=0)
				{
				return "Vehicle has Already Trip Sheet cannot modify Validity";	
				}
			}
			}
			}
			pstmt = con.prepareStatement(SandMiningStatements.UPDATE_MDP_DETAILS);
			// pstmt.setString(1,tripSheetNO);
			// pstmt.setString(2,dateOfEntry);
			pstmt.setString(1, permitNo);
			pstmt.setString(2, permitHolder);
			pstmt.setString(3, transporter);
			pstmt.setString(4, miningType);
			pstmt.setString(5, surveyNoNew);
			pstmt.setString(6, villageNew);
			pstmt.setString(7, talukNew);
			pstmt.setString(8, quantity);
			pstmt.setString(9, royality);
			pstmt.setString(10, vehicleNo);
			pstmt.setString(11, fromPlace);
			pstmt.setString(12, toPlace);
			pstmt.setInt(13, offset);
			pstmt.setString(14, dateOfEntry);
			pstmt.setInt(15, offset);
			pstmt.setString(16, validTo);// todate
			//pstmt.setString(17, mlno);
			pstmt.setString(17, processing);
			pstmt.setString(18, totalFee);
			pstmt.setString(19, printed);
			pstmt.setInt(20, offset);
			pstmt.setString(21, tSDATE);
			pstmt.setString(22, district);
			pstmt.setString(23, vehAddr);
			pstmt.setString(24, portNo);
			pstmt.setString(25, validityPeriod);
			pstmt.setString(26, loadingType);
			pstmt.setString(27, dDNO);
			pstmt.setString(28, bANKNAME);
			pstmt.setInt(29, offset);
			pstmt.setString(30, dDDATE);
			pstmt.setString(31, gROUPID);
			pstmt.setString(32, gROUPNAME);
			pstmt.setString(33, driverNAME);
			pstmt.setString(34, viaRoute);
			pstmt.setInt(35,Integer.parseInt(SandPortUniqueId));
			pstmt.setString(36, sandLoadingFromTime);
			pstmt.setString(37, sandLoadingToTime);
			pstmt.setString(38, customerName);
			pstmt.setString(39, applicationNoModify);
			pstmt.setString(40, distanceAdd);
			pstmt.setInt(41, systemid);
			pstmt.setString(42, globalClientId);
			pstmt.setString(43, uniqueId);
			pstmt.setInt(44, userId);
			inserted = pstmt.executeUpdate();
			pstmt.close();
			if (inserted > 0) {

				pstmt.close();
				rs.close();
				
				if(extractionTypeModify.equals("Sand Block"))
				{
					pstmt1 = con.prepareStatement(SandMiningStatements.UPDATE_ASSESSED_QUANTITY1);
					pstmt1.setDouble(1, Double.parseDouble(quantityModify));
					pstmt1.setInt(2, systemid);
					pstmt1.setString(3, globalClientId);
					pstmt1.setString(4, sandportUniqueidModify);
					int updated2 = pstmt1.executeUpdate();	
					if(updated2>0)
					{   updated2=0;
						pstmt2 = con.prepareStatement(SandMiningStatements.UPDATE_ASSESSED_QUANTITY);
						pstmt2.setDouble(1, Double.parseDouble(quantity));
						pstmt2.setInt(2, systemid);
						pstmt2.setString(3, globalClientId);
						pstmt2.setString(4, SandPortUniqueId);
						updated2 = pstmt2.executeUpdate();	
					}
				}
				else
				{
					pstmt1 = con.prepareStatement(SandMiningStatements.UPDATE_AVAILABLE_QUANTITY1);
					pstmt1.setDouble(1, Double.parseDouble(quantityModify));
					pstmt1.setString(2,  sandportUniqueidModify);
					pstmt1.setInt(3, systemid);
					pstmt1.setString(4, globalClientId);
					int updated3 = pstmt1.executeUpdate();
					if(updated3>0)
					{   updated3=0;
						pstmt2 = con.prepareStatement(SandMiningStatements.UPDATE_AVAILABLE_QUANTITY);
					    pstmt2.setDouble(1, Double.parseDouble(quantity));
						pstmt2.setString(2,  SandPortUniqueId);
						pstmt2.setInt(3, systemid);
						pstmt2.setString(4, globalClientId);
						updated3 = pstmt2.executeUpdate();	
					}
				}
				
				pstmt1 = con.prepareStatement(SandMiningStatements.UPDATE_CREDIT_AGAINST_TEMP_PERMIT1);// and
				pstmt1.setDouble(1, add);
				pstmt1.setDouble(2, Double.parseDouble(totalFee));
				pstmt1.setString(3, applicationNoModify);
				pstmt1.setInt(4, systemid);
				pstmt1.setString(5, globalClientId);
				updated1 = pstmt1.executeUpdate();
				
				pstmt2 = con.prepareStatement(SandMiningStatements.UPDATE_QUANTITY_FOR_MDP_MODIFY);
				pstmt2.setString(1, quantityModify);
				pstmt2.setString(2, quantity);
				pstmt2.setString(3, applicationNoModify);
				pstmt2.setInt(4, systemid);
				pstmt2.setInt(5, Integer.parseInt(globalClientId));
				pstmt2.executeUpdate();
				
				
			}
			if (updated1 > 0) {
				message = "Updated Successfully..!";
			} else {
				message = "Error in saving..!";
			}
		} else {
			return "Max number of Trip Sheets reached for this sand port and loading type combination...!";
		}
	} catch (Exception e) {
		System.out.println("Exception getting update_TS_GRID(): " + e);
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(null, pstmt1, null);
		DBConnection.releaseConnectionToDB(null, pstmt2, null);
	}
	return message;

}

public int getMaxno(int sid, String cid) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	int max = 0;
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_MAX_NO);
		pstmt.setInt(1, sid);
		pstmt.setString(2, cid);
		rs = pstmt.executeQuery();

		while (rs.next()) {
			max = rs.getInt("value") + 1;
		}
	} catch (Exception e) {
		System.out.println("Exception getting getMaxTSno(): " + e);
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return max;
}

public String getAmtGRID(int systemId, String clientId, String applcnNo,
		String uniqueId) {

	String message = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	boolean f = false;

	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_AMOUNT_MDP_GENERATOR);
		pstmt.setInt(1, systemId);
		pstmt.setString(2, clientId);
		pstmt.setString(3, applcnNo);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			f = true;
		}

		if (f) {
			message = "Done";
		} else {
			message = "Error";
		}
	} catch (Exception e) {
		System.out.println("Exception getting getClientName(): " + e);
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return message;

}

public String getVehicleTScount(int systemId, String clientId,
		String vehNo, Date date1, int offset) {

	String message = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	boolean f = false;

	try {

		Date date = new Date();
		String D1 = simpleDateFormatddMMYYYYDB1.format(date).substring(0, 10)+ " 00:00:00";
		D1 = simpleDateFormatddMMYYYYDB.format(D1);

		String D2 = simpleDateFormatddMMYYYYDB1.format(date).substring(0, 10)+ " 23:59:59";
		D2 = simpleDateFormatddMMYYYYDB.format(D2);
		
		con = DBConnection.getConnectionToDB("AMS");

		pstmt = con.prepareStatement(SandMiningStatements.GET_VEHICLE_NO_COUNT);
		pstmt.setInt(1, systemId);
		pstmt.setString(2, clientId);
		pstmt.setInt(3, offset);
		pstmt.setString(4, D1);
		pstmt.setInt(5, offset);
		pstmt.setString(6, D2);
		pstmt.setString(7, vehNo);
		rs = pstmt.executeQuery();
		int count = 0;
		if (rs.next()) {
			count = rs.getInt("count");
		}

		if (systemId == 134 && count > 0) {
			message = "Error";
		} 
		else if (systemId == 133 && count > 2) {
			message = "Error1";
		} 
		else if (systemId == 210 && count > 0) {
			message = "Error";
		}else {
			message = "Done";
		}
	} catch (Exception e) {
		System.out.println("Exception getting getClientName(): " + e);
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return message;

}

public String getTSCountForPort(int systemId, String clientId,
		String loadType, String fromPort, int offset, String groupId,
		String groupName) {

	String message = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs1 = null;
	boolean f = false;
	int count = 0;

	try {
		con = DBConnection.getConnectionToDB("AMS");
		// GET THE DEFAULT COUNT SETTING FPR SYSTEM
		int countSetting = 0;
		pstmt = con.prepareStatement(SandMiningStatements.GET_TS_COUNT_FOR_PORT1);
		pstmt.setInt(1, systemId);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			countSetting = rs.getInt("value");
		}
		pstmt.close();
		rs.close();

		Date date = new Date();
		String D1 = simpleDateFormatddMMYYYYDB.format(date).substring(0, 10)+ " 00:00:00";
		//D1 = simpleDateFormatddMMYYYYDB.format(D1);
		String D2 = simpleDateFormatddMMYYYYDB.format(date).substring(0, 10)+ " 23:59:59";
		//D2 = simpleDateFormatddMMYYYYDB.format(D2);

		pstmt = con.prepareStatement(SandMiningStatements.GET_TS_COUNT_FOR_PORT2);
		pstmt.setInt(1, systemId);
		pstmt.setString(2, clientId);
		// pstmt.setString(3, loadType);
		pstmt.setString(3, fromPort);
		pstmt.setString(4, groupName);
		// pstmt.setString(5, D2);
		rs = pstmt.executeQuery();

		if (rs.next()) {
			if (loadType.equalsIgnoreCase("Machine")) {
				countSetting = rs.getInt("No_Of_Trip_Sheets_Machine");

			} else if (loadType.equalsIgnoreCase("Self")) {
				countSetting = rs.getInt("No_Of_Trip_Sheets_Self");
			}
		}
		int TSCount = -1;
		pstmt1 = con.prepareStatement(SandMiningStatements.GET_TS_COUNT_FOR_PORT3);
		pstmt1.setInt(1, systemId);
		pstmt1.setString(2, clientId);
		pstmt1.setString(3, loadType);
		pstmt1.setString(4, fromPort);
		pstmt1.setInt(5, offset);
		pstmt1.setString(6, D1);
		pstmt1.setInt(7, offset);
		pstmt1.setString(8, D2);
		pstmt1.setString(9, groupName);
		rs1 = pstmt1.executeQuery();
		if (rs1.next()) {
			TSCount = rs1.getInt("count");
		}
		if (TSCount < countSetting) {
			message = "Done";
		} else {
			message = "Error";
		}
	} catch (Exception e) {
		System.out.println("Exception getting getTSCountForPort(): " + e);
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return message;

}

public String CheckBalanceGRID(int systemId, String clientId,
		String pERMITNO, String tYPE, String total,String applicatn) {

	String message = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	boolean f = false;
    Double Total=0.0;
	try {
		if(total!=null && !total.equals("") && !total.equals("NaN"))
		{
		Total=Double.parseDouble(total);
		}
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.CHECK_BALANCE);
		pstmt.setString(1, applicatn);
		pstmt.setInt(2, systemId);
		pstmt.setInt(3, Integer.parseInt(clientId));
		pstmt.setDouble(4,Total);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			f = true;
		}
		if (f) {
			message = "Done";
		} else {
			message = "Error";
		}
	} catch (Exception e) {
		System.out.println("Exception getting getClientName(): " + e);
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return message;

}

public String getPDFFileType(String systemid) {

	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String stmt = "";
	String message="";

	int count = 0;
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_PDF_FILE_TYPE);
		pstmt.setString(1, systemid);

		rs = pstmt.executeQuery();

		while (rs.next()) {
			message = rs.getString("value");
		}
	}
	catch (Exception e) {
		System.out.println("Error in getting Default Details:"
				+ e.toString());
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}

	return message;

}

public JSONArray getPermitNosForShimoga(int systemid, String clientId,
		int userId, int offset) {

	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs1 = null;
	String vehicleNo1="";
	String vehicleNo2="";
	boolean b=false;
	int count=0;

	try {
		con = DBConnection.getConnectionToDB("AMS");
		
//		if ( systemid == 130 || systemid == 165 || systemid == 133 || systemid == 178 || systemid == 210 || systemid == 183 || systemid == 216 || systemid == 134 )
//		{
//		pstmt = con.prepareStatement(SandMiningStatements.GET_PERMIT_NO_FOR_MDP_GENERATOR_NO_GPS);
//		}
//		else
//		{
//		String query = (SandMiningStatements.GET_PERMIT_NO_FOR_MDP_GENERATOR);
//		 if(systemid == 153) 
//	        {	
//	        pstmt = con.prepareStatement(query.concat(" and DATEDIFF(hh,g.GMT,getutcdate())<48 "));
//	        }
//	        else   pstmt = con.prepareStatement(query);
//		}
		String qtyMeasure="";
		pstmt = con.prepareStatement(SandMiningStatements.GET_QUANTITY_MEASURE);
		pstmt.setInt(1, systemid);
		rs = pstmt.executeQuery();
		if(rs.next()){
			qtyMeasure=rs.getString("value");
		}
		
		pstmt = con.prepareStatement(SandMiningStatements.GET_PERMIT_NO_FOR_MDP_GENERATOR);
		pstmt.setInt(1, systemid);
		pstmt.setString(2, clientId);
		pstmt.setInt(3, userId);
		rs = pstmt.executeQuery();
		JSONObject obj1 = new JSONObject();
		while (rs.next()) {
			obj1 = new JSONObject();
			obj1.put("PermitNoNew", rs.getString("VehicleNo"));
			obj1.put("OwnerNameNew", rs.getString("OwnerName"));
			obj1.put("Owner_TypeNew", "Transporter");
			obj1.put("PortNew", rs.getString("VehicleType"));
			obj1.put("Group_Name", rs.getString("GROUP_NAME"));
			obj1.put("Group_Id", rs.getString("GROUP_ID"));
			if(qtyMeasure.equalsIgnoreCase("TONS")){
				obj1.put("LoadCapacityNew", rs.getString("LoadingCapacityTons"));
			}else{
			obj1.put("LoadCapacityNew", rs.getString("LoadingCapacity"));
			}
			jsonArray.put(obj1);
			
		}
		} catch (Exception e) {
		System.out.println("Exception getting getPermitNosALL(): " + e);
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;

}

public String getCurrency(int systemId) {
	String currency = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	try {
		con = DBConnection.getConnectionToDB("AMS");

		pstmt = con.prepareStatement(SandMiningStatements.GET_CURRENCY_FOR_MDP);
		pstmt.setInt(1, systemId);
		rs = pstmt.executeQuery();

		while (rs.next()) { 
				currency = rs.getString("CURRENCY_SYMBOL");
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return currency;
}

public ArrayList getotherDetails(String pERMITNO, String systemid,
		String tSNO) {

	ArrayList list = new ArrayList();
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String stmt = "";

	int count = 0;
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_VEHICLE_NO_FOR_MDP);
		pstmt.setString(1, systemid);
		pstmt.setString(2, pERMITNO);
		rs = pstmt.executeQuery();
		while (rs.next()) {
			list.add(rs.getString("VehicleAlias"));
		}
		// System.out.println("TS_NO"+tSNO);
		pstmt = con.prepareStatement(SandMiningStatements.GET_COUNT_TRIP_FOR_MDP);
		pstmt.setString(1, systemid);
		pstmt.setString(2, pERMITNO);
		pstmt.setInt(3, Integer.parseInt(tSNO));
		rs = pstmt.executeQuery();
		while (rs.next()) {
			list.add(rs.getString("count"));
		}
	}

	catch (Exception e) {
		System.out.println("Error in getting Default Details:"
				+ e.toString());
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}

	return list;

}

public String getCity(String systemid, String clientId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String City = "";

	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_VALUE_FROM_GENERAL_SETTING_FOR_MDP);
		pstmt.setString(1, systemid);
		pstmt.setString(2, clientId);
		rs = pstmt.executeQuery();
		while (rs.next()) {
			City = rs.getString("value");
		}
		if (City.equals("")) {
			pstmt = con.prepareStatement(SandMiningStatements.GET_VALUE_FROM_GENERAL_SETTING1_FOR_MDP);
			pstmt.setString(1, systemid);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				City = rs.getString("value");
			}
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return City;
}

public ArrayList getChallanDetails(String systemid) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs1 = null;
	boolean Challan_SID = false;
	String PDF_TREASURY_CODE = "";
	String PDF_BANK = "";
	String PDF_ADDRESS = "";
	String PDF_ACCOUNT = "";
	ArrayList details = new ArrayList();

	int count = 0;
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_DETAILS_FROM_GENERAL_SETTING_FOR_MDP);
		pstmt.setString(1, systemid);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			Challan_SID = true;
			pstmt1 = con.prepareStatement(SandMiningStatements.GET_DETAILS_FROM_GENERAL_SETTING1_FOR_MDP);
			pstmt1.setString(1, systemid);
			rs1 = pstmt1.executeQuery();
			while (rs1.next()) {
				if (rs1.getString("name").equalsIgnoreCase("PDF_BANK")) {
					PDF_BANK = rs1.getString("value");
					PDF_ADDRESS = rs1.getString("value2");
				}
				if (rs1.getString("name").equalsIgnoreCase(
						"PDF_TREASURY_CODE")) {
					PDF_TREASURY_CODE = rs1.getString("value");
					PDF_ACCOUNT = rs1.getString("value2");
				}
			}

		} else {
			Challan_SID = false;
			PDF_TREASURY_CODE = "";
			PDF_BANK = "";
		}
		details.add(Challan_SID);
		details.add(PDF_TREASURY_CODE);
		details.add(PDF_BANK);
		details.add(PDF_ADDRESS);
		details.add(PDF_ACCOUNT);

	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
	}
	return details;
}

public ArrayList getPrintListForMDP(String uids, int offset) {

	JSONArray jsonArray = new JSONArray();
	JSONObject obj1 = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null,rs1 = null;
	PreparedStatement pstmt1 = null;
	String stmt = "";
	String DateofEntry="";
	String ValidFrom="";
	String ValidTo="";
	String ddDate="";
	

	ArrayList finlist = new ArrayList();
	ArrayList list = new ArrayList();
	int count = 0;
	int updated1 = 0;

	try {
		String[] ids = uids.split(",");
		con =  DBConnection.getConnectionToDB("AMS");

		pstmt1 = con.prepareStatement("update Sand_Mining_Trip_Sheet set Printed_Date=getUTCDate() where TS_ID in("+ uids + ")");
		updated1 = pstmt1.executeUpdate();
		pstmt = con.prepareStatement("SELECT TS_ID, isnull(Trip_Sheet_No,'') as Trip_Sheet_No,isnull(a.CONSUMER_APPLICATION_NO,'') as ApplicationNo, dateadd(mi,"+offset+",isnull(Date_TS,'')) as Date_TS, isnull(Permit_No,'') as Permit_No, isnull(Lessee_Name,'') "
				+ "as Lessee_Name, isnull(Lessee_Type,'') as Lessee_Type, isnull(Mineral_Type,'') as Mineral_Type, isnull(Survey_No,'') as Survey_No, "
				+ " isnull(Village,'') as Village, isnull(Taluk,'') as Taluk, isnull(Quantity,'') as Quantity, isnull(Royalty,0) as Royalty, isnull(Vehicle_No,'') as Vehicle_No, isnull(Total_Fee,0) as Total_Fee,isnull(Printed,'') as Printed, "
				+ "isnull(From_Place,'') as From_Place,isnull(Via_Route,'') as Via_Route,isnull(To_Palce,'') as To_Palce, dateadd(mi,"+offset+",isnull(From_Date,'')) as From_Date, dateadd(mi,"+offset+",isnull(To_Date,'')) as To_Date, isnull(MiNo,'') as MiNo, isnull(Processing_Fee,0) as Processing_Fee "
				+ ", System_Id,Client_Id,isnull(District,'') as District,isnull(Vehicle_Addr,'') as Vehicle_Addr,isNull(Port_No,'') as Port_No,isNull(Validity_Period,'') as Validity_Period,isNull(Loading_Type,'') as Loading_Type,isNull(Index_No,'') as Index_No "
				+ ",isNull(DD_No,'') as DD_No,dateadd(mi,"+offset+",isNull(DD_Date,'')) as DD_Date,isNull(Bank_Name,'') as Bank_Name,isNull(Driver_Name,'') as Driver_Name,isnull(Sand_Loading_From_Time,'')as Sand_Loading_From_Time,isnull(Sand_Loading_To_Time,'')as Sand_Loading_To_Time,isnull(CUSTOMER_NAME,'') as Customer_Name,isnull(DISTANCE,0) as Distance, "
				+ " isnull(b.MOBILE_NUMBER,'') as MobileNo,isnull(a.MOBILE_NO,'') as ClientMobileNo,isnull(LOADING_WEIGHT,0) as LoadingWeight,isnull(UNLOADING_WEIGHT,0) as UnloadingWeight FROM Sand_Mining_Trip_Sheet a "
				+ " left outer join AMS.dbo.SAND_CONSUMER_ENROLMENT b on b.CONSUMER_APPLICATION_NO=a.CONSUMER_APPLICATION_NO and a.System_Id=b.SYSTEM_ID "
				+ " where TS_ID in("
				+ uids + ") ");

		rs = pstmt.executeQuery();

		while (rs.next()) {

			double total = rs.getDouble("Total_Fee");
			String pn = rs.getString("Permit_No");
			int sid = rs.getInt("System_Id");
			int cid = rs.getInt("Client_Id");
			String ph = rs.getString("Lessee_Name");
			String customerMobileNo = rs.getString("MobileNo");
			
//***************************************MANGALORE CONSUMER MDP GENERATION SMS ALERT**************************************
			if(sid==8)
		    {  
			  int smsVolume=0;
			  pstmt1 = con.prepareStatement( "select isnull(SMS_VOLUME,0) as SMS_VOLUME from SMS.dbo.CLIENT_SMS_MASTER A,SMS.dbo.SMS_PROVIDER_MASTER B where CLIENT_ID=? and A.PROVIDER_ID=B.PROVIDER_ID order by SMS_VOLUME" );
			  pstmt1.setInt(1, cid);
			  rs1=pstmt1.executeQuery();
			  if(rs1.next())
			  {
				 if(rs1.getInt("SMS_VOLUME") > 0 ) 
				 {
					 String mobileNo="8147051251,8867549651,9980525277";
					 String MobileNos[]=mobileNo.split(",");
					 for (int i = 0; i < MobileNos.length; i++) {
						Date date=new Date();
						String Message="The Vehicle No: "+rs.getString("Permit_No")+" is Taken MDP From: "+rs.getString("From_Place")+" To: "+rs.getString("To_Palce")+", Valid From: "+simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("From_Date"))+", Valid Till: "+simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("To_Date"))+" Generated on: "+simpleDateFormatddMMYY.format(date);    
						pstmt = con.prepareStatement("INSERT INTO dbo.SEND_SMS(PhoneNo,Message,Status,ClientId,SystemId,AlertTypeForSchool,InsertedTime) values (?,?,?,?,?,?,getUTCDate())");
				        pstmt.setString(1, MobileNos[i]);
				        pstmt.setString(2, Message);
				        pstmt.setString(3, "N");
				        pstmt.setInt(4, 4895);
				        pstmt.setInt(5, 8);
				        pstmt.setInt(6, 146);
				        int insert=pstmt.executeUpdate(); 
					   if(insert>0){
						 // System.out.println("sms sent successfully");
					   }
					 }	 
				 }
			  } 
			  }else {
				  int smsVolume=0;
				  pstmt1 = con.prepareStatement( "select isnull(SMS_VOLUME,0) as SMS_VOLUME from SMS.dbo.CLIENT_SMS_MASTER A,SMS.dbo.SMS_PROVIDER_MASTER B where CLIENT_ID=? and A.PROVIDER_ID=B.PROVIDER_ID order by SMS_VOLUME" );
				  pstmt1.setInt(1, cid);
				  rs1=pstmt1.executeQuery();
				  if(rs1.next())
				  {
					 if(rs1.getInt("SMS_VOLUME") > 0 ) 
					 {
				  Date date=new Date();
				  String Sms="The Vehicle No: "+rs.getString("Permit_No")+" is Taken MDP From: "+rs.getString("From_Place")+" To: "+rs.getString("To_Palce")+", Valid From: "+simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("From_Date"))+", Valid Till: "+simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("To_Date"))+" Generated on: "+simpleDateFormatddMMYY.format(date);
					pstmt = con.prepareStatement("INSERT INTO dbo.SEND_SMS(PhoneNo,Message,Status,ClientId,SystemId,InsertedTime) values (?,?,?,?,?,getUTCDate())");
					pstmt.setString(1, customerMobileNo);
					pstmt.setString(2, Sms);
					pstmt.setString(3, "N");
					pstmt.setInt(4, cid);
					pstmt.setInt(5, sid);
			        int insert=pstmt.executeUpdate(); 
			        if (insert > 0) {
			        	//System.out.println("message sent successfully");
					}
				  }
				}
			  }
		
			
			// if (rs.getString("Printed").equalsIgnoreCase("N")) {
			// +" cid "+cid+" ph"+ph);
			// pstmt1 =
			// con.prepareStatement("update dbo.Credit_Against_Temp_Permit set Balance_Amount=Balance_Amount-?,Taken_Trips=Taken_Trips+1 "
			// +
			// " where Permit_No=? and Credited_By=? and  System_Id=? and Client_Id=? and ? between 0 and  Balance_Amount");
			// pstmt1.setInt(1, total);
			// pstmt1.setString(2, pn);
			// pstmt1.setString(3, ph);
			// pstmt1.setInt(4, sid);
			// pstmt1.setInt(5, cid);
			// pstmt1.setInt(6, total);
			//			 
			// updated1= pstmt1.executeUpdate();
			//				
			// }
			// if(updated1>0)
			// {
			if (rs.getString("Date_TS") != null && !rs.getString("Date_TS").equals("") && !rs.getString("Date_TS").contains("1900")) {
				DateofEntry = simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("Date_TS"));
			} else {
				DateofEntry = "";
			}

			if (rs.getString("From_Date") != null && !rs.getString("From_Date").equals("") && !rs.getString("From_Date").contains("1900")) {
				ValidFrom = simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("From_Date"));
			} else {
				ValidFrom = "";
			}

			if (rs.getString("To_Date") != null && !rs.getString("To_Date").equals("") && !rs.getString("To_Date").contains("1900")) {
				ValidTo = simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("To_Date"));
			} else {
				ValidTo = "";
			}

			if (rs.getString("DD_Date") != null && !rs.getString("DD_Date").equals("")) {
				ddDate = simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("DD_Date"));
			} else {
				ddDate = "";
			}


			finlist = new ArrayList();
			finlist.add(rs.getString("Trip_Sheet_No"));
			finlist.add(DateofEntry);
			finlist.add(rs.getString("Permit_No"));
			finlist.add(rs.getString("MiNo"));
			finlist.add(rs.getString("Lessee_Name"));
			finlist.add(rs.getString("Lessee_Type"));
			finlist.add(rs.getString("Mineral_Type"));
			finlist.add(rs.getString("Survey_No"));
			finlist.add(rs.getString("Village"));
			finlist.add(rs.getString("Taluk"));
			finlist.add(rs.getString("Quantity"));
			finlist.add(rs.getString("Royalty"));
			finlist.add(rs.getString("Processing_Fee"));
			finlist.add(rs.getString("Total_Fee"));
			finlist.add(rs.getString("Vehicle_No"));
			finlist.add(ValidFrom);
			finlist.add(rs.getString("From_Place"));
			finlist.add(rs.getString("To_Palce"));
			finlist.add(ValidTo);
			finlist.add(rs.getString("District"));
			finlist.add(rs.getString("Vehicle_Addr"));
			finlist.add(rs.getString("Port_No"));
			finlist.add(rs.getString("Validity_Period"));
			finlist.add(rs.getString("Loading_Type"));
			finlist.add(rs.getString("DD_No"));
			finlist.add(ddDate);
			finlist.add(rs.getString("Bank_Name"));
			finlist.add(rs.getString("Index_No"));
			finlist.add(rs.getString("Driver_Name"));
			finlist.add(rs.getString("TS_ID"));
			finlist.add(rs.getString("Via_Route"));
			finlist.add(rs.getString("Sand_Loading_From_Time"));
			finlist.add(rs.getString("Sand_Loading_To_Time"));
			finlist.add(rs.getString("Customer_Name"));
			finlist.add(rs.getString("Distance"));
			finlist.add(rs.getString("MobileNo"));
			finlist.add(rs.getString("ClientMobileNo"));
			finlist.add(rs.getString("LoadingWeight"));
			finlist.add(rs.getString("UnloadingWeight"));
			list.add(finlist);
			// }
		}
		pstmt.close();
		rs.close();

		pstmt = con
				.prepareStatement("update Sand_Mining_Trip_Sheet set Printed='Y'  where TS_ID in("
						+ uids + ") ");
		int updated = pstmt.executeUpdate();
		pstmt.close();


	}

	catch (Exception e) {
		System.out.println("Error in getting Master Details:"
				+ e.toString());
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
	}

	return list;

}
public String getConsumerType(int systemId, String clientId,
		String applicationNo,int offset) {

	String message = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String consumerType="";
	try {
		Date date = new Date();
		String D1 = simpleDateFormatddMMYYYYDB.format(date).substring(0, 10)+ " 00:00:00";
		String D2 = simpleDateFormatddMMYYYYDB.format(date).substring(0, 10)+ " 23:59:59";
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_CONSUMER_TYPE_FOR_MDP);
		pstmt.setString(1, applicationNo);
		pstmt.setInt(2, systemId);
		pstmt.setInt(3, Integer.parseInt(clientId));
		pstmt.setInt(4, offset);
		pstmt.setString(5, D1);
		pstmt.setInt(6, offset);
		pstmt.setString(7, D2);
		rs = pstmt.executeQuery();
		while (rs.next()) {
			consumerType = rs.getString("CONSUMER_TYPE");
			if(consumerType.equals("Public"))
			{
				if(rs.getInt("countTrip")>=1)
				{
					message = "MDP limit is 1 for Public so you cannot add another";
				}
				
			} else if(consumerType.equals("Contractor") || consumerType.equals("Government"))
			{
				if(rs.getInt("countTrip")>=3)
				{
					message = "MDP limit is 3 for "+consumerType+" so you cannot add another";
				}
			} 
		}
	} catch (Exception e) {
		System.out.println("Exception getting getConsumerType(): " + e);
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return message;

}

public String updateQuantity(int systemId, String clientId,
		String applicationNo,String quantity,String vehicleNo) {

	String message = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs1 = null;
	try {
		
		con = DBConnection.getConnectionToDB("AMS");
		pstmt1 = con.prepareStatement(SandMiningStatements.Check_Vehicle_Blocked);
		pstmt1.setString(1, vehicleNo);
		
		rs1=pstmt1.executeQuery();
		if(!rs1.next()){
		pstmt = con.prepareStatement(SandMiningStatements.CHECK_QUANTITY_FOR_MDP);
		pstmt.setString(1, applicationNo);
		pstmt.setInt(2, systemId);
		pstmt.setInt(3, Integer.parseInt(clientId));
		rs = pstmt.executeQuery();
		while (rs.next())
		{
			if(Float.parseFloat(quantity)>rs.getFloat("BALANCE_SAND_QUANTITY"))
			{
				message = "ERROR";
			}
		}
		}
		else{
			message = "Sorry!! Vehicle is in Blocked state, You cannot perform Credit/MDP";
		}
		
	} catch (Exception e) {
		System.out.println("Exception getting getConsumerType(): " + e);
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(null, pstmt1, null);
	}
	return message;

}

public JSONArray getFromSandPortDetailsStore(int systemid, String clientId,
		String portname,String applicationNo) {

	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs1 = null;

	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_DEFAULT_SETTINGS_FOR_MDP);
		pstmt.setInt(1, systemid);
		pstmt.setString(2,clientId);
		pstmt.setString(3, portname);
		rs = pstmt.executeQuery();
		JSONObject obj1 = new JSONObject();
		if (rs.next()) {
			obj1 = new JSONObject();
			obj1.put("ValidFromNew", rs.getString("Valid_From").toUpperCase());
			obj1.put("ValidToNew", rs.getString("Valid_To").toUpperCase());
			obj1.put("TSFormatNew", rs.getString("Trip_Sheet_Format"));
			obj1.put("SelfAmountNew", rs.getString("Self_Amount"));
			obj1.put("MachineAmountNew", rs.getString("Machine_Amount"));
			obj1.put("LoadTypeNew", rs.getString("Default_Load_Type"));
			obj1.put("DailyOff1", simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("d1")));
			obj1.put("DailyOff2", simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("d2")));
		}
		pstmt1 = con.prepareStatement(SandMiningStatements.GET_DD_NO_DATE_FOR_MDP);
		pstmt1.setInt(1, systemid);
		pstmt1.setString(2,clientId);
		pstmt1.setString(3, applicationNo);
		rs1 = pstmt1.executeQuery();
		if (rs1.next()) {
			obj1.put("DD_Date", rs1.getString("DD_DATE"));
			obj1.put("DD_NoNew", rs1.getString("DD_NO"));
			obj1.put("Bank_Name", rs1.getString("BANK_NAME"));
			obj1.put("uniqueId", rs1.getString("UNIQUE_ID"));
		}
		jsonArray.put(obj1);
	} catch (Exception e) {
		System.out.println("Exception getting getPermitNosALL(): " + e);
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
	}
	return jsonArray;

}

public JSONArray getStockyards(int systemid, String clientId,String appNo)
{

	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt=null,pstmt1 = null;
	ResultSet rs=null,rs1 = null;
	boolean CONSUMER_MDP_FEATURE = false;
	try {
		con = DBConnection.getConnectionToDB("AMS");
		CONSUMER_MDP_FEATURE = CONSUMER_MDP_FEATURE(systemid,con);
		if(CONSUMER_MDP_FEATURE){
			pstmt = con.prepareStatement(SandMiningStatements.GET_CONSUMER_STOCK_YARD);
			pstmt.setInt(1, systemid);
			pstmt.setString(2,clientId);
			pstmt.setString(3,appNo);
			rs = pstmt.executeQuery();
		}else{
		pstmt = con.prepareStatement(SandMiningStatements.GET_STOCKYARDS_TO);
		pstmt.setInt(1, systemid);
		pstmt.setString(2, clientId);
		rs = pstmt.executeQuery();
		}
		JSONObject obj1 = new JSONObject();
		while (rs.next()) {
			obj1 = new JSONObject();
			obj1.put("stockyardName", rs.getString("SAND_STOCKYARD_NAME"));
			obj1.put("stockyardId", rs.getString("UNIQUE_ID"));
			obj1.put("availablesand", rs.getString("ESTIMATED_SAND_QUANTITY_AVAILABLE"));
			obj1.put("rate", rs.getString("RATE"));
			obj1.put("stockyardvillage", rs.getString("VILLAGE"));
			obj1.put("stockyardtaluka", rs.getString("TALUKA"));
			obj1.put("stockyardlat", rs.getString("LATITUDE"));
			obj1.put("stockyardlong", rs.getString("LONGITUDE"));
			jsonArray.put(obj1);
		}
	} catch (Exception e) {
		System.out.println("Exception getting STOCKYARDS(): " + e);
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;

}

public String getmaxTripSheetNo(int sid, String cid) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String max = null;
	String tsNoforstockyard="";
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_TRIP_SHEET_NO);
		pstmt.setInt(1, sid);
		pstmt.setString(2, cid);
		pstmt.setInt(3, sid);
		pstmt.setString(4, cid);
		rs = pstmt.executeQuery();

		if (rs.next()) {
			max = rs.getString("Trip_Sheet_No");
			if(max!=null && max!=""){
			
			int x=Integer.parseInt(max.substring(max.lastIndexOf("-")+1,max.length()))+1;
			tsNoforstockyard=max.substring(0,max.lastIndexOf("-")+1)+x;
			}
			else
			tsNoforstockyard="";	
		}else{
			tsNoforstockyard="1";
		}
	} catch (Exception e) {
		System.out.println("Exception getting getMaxTSno(): " + e);
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return tsNoforstockyard;
}

//*******************************Generic Method to add New Line In Inward MDP Generation PDF*************************************
public String getSIPHeader(int systemId) {
    
    PreparedStatement pstmt = null;
    Connection con = null;
    String SIPHeader=null;
    ResultSet rs = null;
    try {
    	con = DBConnection.getConnectionToDB("AMS");
        pstmt = con.prepareStatement(SandMiningStatements.GET_SIP_HEADER);
        pstmt.setInt(1, systemId);
        
        rs = pstmt.executeQuery();
        if (rs.next()) {
        	SIPHeader=rs.getString("value") ; 
        }

    } catch (Exception e) {
    	 e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
    }
    return SIPHeader;
}

public JSONArray getConsumerEnrolementData(int systemid, int clientId,String type) {

	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	
	try {
		String qry=qry=SandMiningStatements.CONSUMER_ENROLEMENT_DETAILS;
		if(type.equals("pending")){		  
		  qry=SandMiningStatements.CONSUMER_ENROLEMENT_FOR_APPROVAL;
		}
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(qry);
		pstmt.setInt(1, systemid);
		pstmt.setInt(2, clientId);
		pstmt.setString(3,type );
		rs = pstmt.executeQuery();
		JSONObject obj1 = new JSONObject();
		while (rs.next()) {
			obj1 = new JSONObject();
			obj1.put("uniqueIdDataIndex", rs.getString("UNIQUE_ID"));
			obj1.put("applicationNoDataIndex", rs.getString("CONSUMER_APPLICATION_NO"));
			obj1.put("ConsumerNameDataIndex", rs.getString("SAND_CONSUMER_NAME"));
			obj1.put("MobileDataIndex", rs.getString("MOBILE_NUMBER"));
			obj1.put("typeDataIndex", rs.getString("CONSUMER_TYPE"));
			obj1.put("qtyReqDataIndex", rs.getString("ESTIMATED_SAND_REQUIREMENT"));
			obj1.put("destinationDataIndex", rs.getString("WORK_LOCATION"));
			obj1.put("approvedQtyDataIndex", rs.getString("APPROVED_SAND_QUNATITY"));
			obj1.put("tpNoDataIndex", rs.getString("TP_NO"));
			obj1.put("tpIdDataIndex", rs.getString("TP_ID"));
			obj1.put("viaDataIndex", rs.getString("CHECK_POST"));
			obj1.put("stockyardDataIndex", rs.getString("ADHAR_NO"));
			obj1.put("propertyAssessmentDataIndex", rs.getString("PROPERTY_ASSESSMENT_NO"));
			if(type.equals("pending")){
			obj1.put("balanceDataIndex", rs.getString("balance"));
			}
			else if(type.equals("approved")){
			obj1.put("totalDispatchQty", rs.getString("TotalDispatchQty"));
			obj1.put("balanceSandQuantity", rs.getString("BALANCE_SAND_QUANTITY"));
			}
			obj1.put("remarksDataIndex", rs.getString("REJECT_REMARKS"));
			jsonArray.put(obj1);
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;

}

public String getManageConsumerEnrolementData(int systemid, int clientId,String status,int uniqueId,int userId,String approvedQty,
		int tpId,String reason,String reamrks,String mobileNo,String value) {

	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt=null;
	PreparedStatement pstmt3=null;
	String msg="Error"; 
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.MANAGE_CONSUMER_ENROLEMENT_FOR_APPROVAL);
		pstmt.setString(1,status.trim());
		pstmt.setInt(2, userId);
		pstmt.setString(3,approvedQty);
		pstmt.setString(4,approvedQty);
		pstmt.setString(5,reason);
		pstmt.setString(6,reamrks.substring(0, Math.min(reamrks.length(), 49)));
		pstmt.setString(7,approvedQty);
		pstmt.setInt(8, userId);
		pstmt.setInt(9, uniqueId);
		pstmt.setInt(10, systemid);
		pstmt.setInt(11, clientId);
		int c = pstmt.executeUpdate();
		if(c>0){
			String sms="";
			 if(status.equals("approved")){
			          sms="SAND: Your Application No "+value+" has been Approved for Qty: "+approvedQty
			              +" CBM Please contact Taluka Office and submit sufficient DDs \nDistrict Sand Committee, CKM";
			 }else if(status.equals("rejected")){
		          sms="SAND: Your Application No "+value+" has been Rejected by concerned authorities due to "+reason;
	          }else if(status.equals("hold")){
	        	  sms="SAND: Your Application No "+value+" has been held by concerned authorities due to "+reason;
		      }
		        pstmt3 = con.prepareStatement(SandMiningStatements.UPDATE_SMS);
		        pstmt3.setString(1, mobileNo);
		        pstmt3.setString(2, sms);
		        pstmt3.setString(3, "N");
		        pstmt3.setInt(4, clientId);
		        pstmt3.setInt(5, systemid);
		        int insert=pstmt3.executeUpdate(); 
		        if (insert > 0) {
					//msg = "Saved & SMS Sent successfully";
				}else {
					//msg = "Saved & Error in sending SMS";
				}
		  if(status.equals("approved") && systemid!=153){
			pstmt = con.prepareStatement(SandMiningStatements.UPDATE_CREDIT);
			pstmt.setDouble(1,(Double.parseDouble(approvedQty)*60));
			pstmt.setInt(2, tpId);
			int d = pstmt.executeUpdate();
			if(d>0){
				msg="Application "+status+" Successfully..!!";	
			}
		  }else{
			   msg="Application "+status+" Successfully..!!";	
		  }	
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, null);
	}
	return msg;
}

public JSONArray getTemporaryPermitNumbers(int systemId, int customerId,int userId,int portId) {

	JSONArray jsonArray = new JSONArray();
	JSONObject obj = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try {
		con = DBConnection.getConnectionToDB("AMS"); //and s.USER_ID=? and c.Client_Id=?
		pstmt = con.prepareStatement("select TP_ID as Unique_Id,Permit_NoNEW as Permit_No from dbo.Temporary_Permit_Master " +
				" where System_Id=? and Client_Id=? and PORT_ID=?  and getUTCdate() between Date_of_Issue " +
				" and Date_of_Expiry and (Status ='Active' or Status is null)");
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);
		pstmt.setInt(3,portId);
		rs = pstmt.executeQuery();
		while (rs.next()) {
				obj = new JSONObject();
				obj.put("uniqueId", rs.getString("Unique_Id"));
				obj.put("permitNo", rs.getString("Permit_No"));
				jsonArray.put(obj);
	
		}		
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;
}
///////////////////////////////////////////////MDP Generator new /////////////////////////////////////
public JSONArray getApplicationDetails(int systemid, String clientId,int userId,String tpno)
{

	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_APPLICATION_DETAILS);
		pstmt.setInt(1, systemid);
		pstmt.setString(2, clientId);
		pstmt.setString(3,tpno);
		rs = pstmt.executeQuery();
		JSONObject obj1 = new JSONObject();
		while (rs.next()) {
			obj1 = new JSONObject();
			obj1.put("ApplicationNo", rs.getString("CONSUMER_APPLICATION_NO"));
			obj1.put("consumerName", rs.getString("CONSUMER_NAME"));
			obj1.put("workAddress",rs.getString("WORK_LOCATION") );
			obj1.put("latitude",rs.getString("LATITUDE") );
			obj1.put("longitude",rs.getString("LONGITUDE") );
			obj1.put("approvedqty",rs.getString("APPROVED_SAND_QUNATITY"));
			obj1.put("balanceqty", rs.getString("BALANCE_SAND_QUANTITY"));
			obj1.put("phone", rs.getString("PHONE"));
			obj1.put("checkpost",rs.getString("CHECKPOST"));
			jsonArray.put(obj1);
		}
	} catch (Exception e) {
		System.out.println("Exception getting getApplicationNoStore(): " + e);
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;

}
public JSONArray getFromLocLatLong(int systemid, String clientId,int userId,String tpno)
{

	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_FROM_LOC_LATLONG);
		pstmt.setInt(1, systemid);
		pstmt.setString(2, clientId);
		pstmt.setString(3,tpno);
		pstmt.setInt(4, systemid);
		rs = pstmt.executeQuery();
		JSONObject obj1 = new JSONObject();
		while (rs.next()) {
			obj1 = new JSONObject();
			obj1.put("FromLat", rs.getString("LATITUDE"));
			obj1.put("FromLong", rs.getString("LONGITUDE"));
			obj1.put("TripSheetFormat",rs.getString("Trip_Sheet_Format"));
			obj1.put("fromport", rs.getString("Port_Name"));
			obj1.put("river",rs.getString("RIVER_NAME"));
			obj1.put("Port_No",rs.getString("Port_No"));
			jsonArray.put(obj1);
		}
	} catch (Exception e) {
		System.out.println("Exception getting getApplicationNoStore(): " + e);
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;

}
public JSONArray getTpNo(int systemid, String clientId,int userId)
{

	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_TPNO);
		pstmt.setInt(1, systemid);
		pstmt.setString(2, clientId);
		pstmt.setInt(3, userId);
		rs = pstmt.executeQuery();
		JSONObject obj1 = new JSONObject();
		while (rs.next()) {
			obj1 = new JSONObject();
			obj1.put("TpNo", rs.getString("TP_NO"));
			obj1.put("TpId", rs.getString("TP_ID"));
			obj1.put("DD_No", rs.getString("DD_NO"));
			obj1.put("DD_Date", rs.getString("DD_Date"));
			obj1.put("Bank_Name", rs.getString("Bank_Name"));
			obj1.put("Village", rs.getString("Village"));
			obj1.put("Taluk", rs.getString("Taluk"));
			obj1.put("TripStartCode", rs.getString("TripStartCode"));
			obj1.put("TripEndCode", rs.getString("TripEndCode"));
			obj1.put("BarStartCode", rs.getString("BarStartCode"));
			obj1.put("BarEndCode", rs.getString("BarEndCode"));
			jsonArray.put(obj1);
		}
	} catch (Exception e) {
		System.out.println("Exception getting getApplicationNoStore(): " + e);
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;

}
public ArrayList getGRIDDetails(int systemid,String clientIdFromJsp, int offset, int userId) {
	JSONArray jsonArray = new JSONArray();
	JSONObject obj1 = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String stmt = "";
	String DateofEntry = "";
	String ValidFrom = "";
	String ValidTo = "";
	String ddDate = "";
	String DateofEntry1 = "";
	String ValidFrom1 = "";
	String ValidTo1 = "";
	String ddDate1 = "";
	
	ArrayList reportsList = new ArrayList();
	ArrayList headersList = new ArrayList();
	ReportHelper finalreporthelper = new ReportHelper();
	ArrayList finlist = new ArrayList();
	int count = 0;

	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_MDP_GENERATOR_NEW_DETAILS);
		pstmt.setInt(1,offset);
		pstmt.setInt(2,offset);
		pstmt.setInt(3, systemid);
		pstmt.setString(4, clientIdFromJsp);
		pstmt.setInt(5, userId);
		pstmt.setInt(6,offset);
		pstmt.setInt(7,offset);
		pstmt.setInt(8, systemid);
		pstmt.setString(9, clientIdFromJsp);
		pstmt.setInt(10, userId);

		rs = pstmt.executeQuery();
		headersList.add("SLNO");
		headersList.add("Unique Id");
		headersList.add("Tp No");
		headersList.add("Application No");
		headersList.add("Customer Name");
		headersList.add("Customer PhoneNo");
		headersList.add("MDP No");
		headersList.add("Approved Qty");
		headersList.add("Balance Qty");
		headersList.add("Vehicle No");
		headersList.add("Transporter Name");
		headersList.add("Driver Name");
		headersList.add("Quantity");
		headersList.add("To Place");
		headersList.add("Via Route");
		headersList.add("Valid From");
		headersList.add("Valid To");
		headersList.add("Distance");
		headersList.add("Loading Type");		
		
		while (rs.next()) {
			count++;
			obj1 = new JSONObject();
			ArrayList informationList = new ArrayList();
			ReportHelper reporthelper = new ReportHelper();

			// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
			if (rs.getString("From_Date") != null && !rs.getString("From_Date").equals("") && !rs.getString("From_Date").contains("1900")) {
				ValidFrom = sdf.format(rs.getTimestamp("From_Date"));
				ValidFrom1 = simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("From_Date"));
			} else {
				ValidFrom = "";
				ValidFrom1 = "";
			}

			if (rs.getString("To_Date") != null && !rs.getString("To_Date").equals("") && !rs.getString("To_Date").contains("1900")) {
				ValidTo = sdf.format(rs.getTimestamp("To_Date"));
				ValidTo1 = simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("To_Date"));
			} else {
				ValidTo = "";
				ValidTo1 = "";
			}

			informationList.add(count);
			obj1.put("SLNODataIndex", count);

			informationList.add(rs.getString("TS_ID"));
			obj1.put("UniqueIdDataIndex", rs.getString("TS_ID"));
			
			informationList.add(rs.getString("TP_NO"));
			obj1.put("tpNODataIndex", rs.getString("TP_NO"));
			
			informationList.add(rs.getString("CONSUMER_APPLICATION_NO"));
			obj1.put("applicationNODataIndex",rs.getString("CONSUMER_APPLICATION_NO"));

			informationList.add(rs.getString("Consumer_Name"));
			obj1.put("ConsumerNameDataIndex",rs.getString("Consumer_Name"));
			
			informationList.add(rs.getString("PHONE"));
			obj1.put("ConsumerPhoneDataIndex",rs.getString("PHONE"));
			
			informationList.add(rs.getString("Trip_Sheet_No"));
			obj1.put("TripSheetNODataIndex", rs.getString("Trip_Sheet_No"));

			informationList.add(rs.getString("APPROVED_SAND_QUNATITY"));
			obj1.put("approvedDataIndex", rs.getString("APPROVED_SAND_QUNATITY"));

			informationList.add(rs.getString("BALANCE_SAND_QUANTITY"));
			obj1.put("balanceDataIndex", rs.getString("BALANCE_SAND_QUANTITY"));
			
			informationList.add(rs.getString("Vehicle_No"));
			obj1.put("PermitNoDataIndex", rs.getString("Vehicle_No"));
			
			informationList.add(rs.getString("Transporter_Name"));
			obj1.put("PermitHolderDataIndex", rs.getString("Transporter_Name"));
			
			informationList.add(rs.getString("Driver_Name"));
			obj1.put("DriverIndex", rs.getString("Driver_Name"));
			
			informationList.add(rs.getString("Quantity"));
			obj1.put("QuantityDataIndex", rs.getString("Quantity"));

			informationList.add(rs.getString("To_Palce"));
			obj1.put("destinationDataIndex", rs.getString("To_Palce"));
			
			informationList.add(rs.getString("Via_Route"));
			obj1.put("ViaRouteDataIndex", rs.getString("Via_Route"));

			informationList.add(ValidFrom1);
			obj1.put("DateOfEntryDataIndex", ValidFrom);

			informationList.add(ValidTo1);
			obj1.put("DateOfEntryDataIndex1", ValidTo);
			
			informationList.add(rs.getString("DISTANCE"));
			obj1.put("distanceindex", rs.getString("DISTANCE"));

			informationList.add(rs.getString("Loading_Type"));
			obj1.put("LoadingTypeDataIndex", rs.getString("Loading_Type"));

			jsonArray.put(obj1);
			reporthelper.setInformationList(informationList);
			reportsList.add(reporthelper);
		}

		finalreporthelper.setReportsList(reportsList);
		finalreporthelper.setHeadersList(headersList);
	}

	catch (Exception e) {
		System.out.println("Error in getting Master Details:"
				+ e.toString());
		e.printStackTrace();
	} finally {
		finlist.add(jsonArray);
		finlist.add(finalreporthelper);
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}

	return finlist;

}

public String insert_GRID_Details(String tripSheetNO, String permitNo, String permitHolder,String vehicleNo,
		int systemid, String globalClientId, String ValidFromDate,String validToDate, String loadingType,String driverNAME, String viaRoute,String customerName,String applicationNoAdd,String distanceAdd,String latitude,String longitude,String quantity,int userId,String fromPlace,String toPlace,int offset,String village,String taluk,int royalty,String surveyNo,String MineralType,String Lessetype,int tripcode,int barcode,String Bank_Name,String SandLoadingFromTime,String SandLoadingToTime,String DD_No,String DD_Date,String port_no,String VehicleType,double totalfee) {

	String message = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt1 = null;
	PreparedStatement pstmt2 = null;
	ResultSet rs1 = null;
	boolean f = false;
	String fromdatenew=null;
	int inserted = 0;
	int inserted1 = 0;
	int count = 0;
	String ValidFrom="";
	String ValidTo="";
	try {
		con = DBConnection.getConnectionToDB("AMS");
		
		if (ValidFromDate.contains("T")) {
			ValidFrom = ValidFromDate.replace("T", " ");
		}
		if (validToDate.contains("T")) {
			ValidTo = validToDate.replace("T", " ");
		}
		String[] temp = tripSheetNO.split("-");

		String teest = tripSheetNO.substring(0, tripSheetNO
				.lastIndexOf("-") + 1);

		int tno = Integer.parseInt(temp[temp.length - 1]);
		pstmt1 = con.prepareStatement(SandMiningStatements.GET_TRIP_SHEET_NO);

		pstmt1.setInt(1, systemid);
		pstmt1.setInt(2, Integer.parseInt(globalClientId));
		pstmt1.setInt(3, systemid);
		pstmt1.setInt(4, Integer.parseInt(globalClientId));
		rs1 = pstmt1.executeQuery();
		if (rs1.next()) {
			String newTS = rs1.getString("Trip_Sheet_No");
			String[] temp1 = newTS.split("-");
			tno = Integer.parseInt(temp1[temp1.length - 1]);
			tno++;
			tripSheetNO = teest + Integer.toString(tno);

		}
		
		pstmt1 = con.prepareStatement(SandMiningStatements.GET_LATEST_MDP_DETAILS);
		pstmt1.setString(1, vehicleNo);
		pstmt1.setInt(2, systemid);
		pstmt1.setString(3, globalClientId);
		rs1=pstmt1.executeQuery();
		if(rs1.next())
		{
			String tdate=rs1.getString("To_Date");
			Date tdate1=simpleDateFormatddMMYYYYDB.parse(tdate);
			Date tdate2=simpleDateFormatddMMYYYYDB.parse(ValidFrom);
			if((tdate2.getTime()-tdate1.getTime())<=0)
			{
			return "Vehicle has Already Trip Sheet within this Duration";	
			}
		}
		pstmt = con.prepareStatement(SandMiningStatements.INSERT_MDP_NEW_DETAILS);
		pstmt.setString(1, tripSheetNO);
		pstmt.setString(2, permitNo);
		pstmt.setString(3, permitHolder);
		pstmt.setString(4, quantity);
		pstmt.setString(5, vehicleNo);
		pstmt.setString(6, fromPlace);
		pstmt.setString(7, toPlace);
		pstmt.setInt(8,offset);
		pstmt.setString(9,ValidFrom);
		pstmt.setInt(10,offset);
		pstmt.setString(11, ValidTo);
		pstmt.setInt(12, systemid);
		pstmt.setInt(13, Integer.parseInt(globalClientId));
		pstmt.setInt(14, userId);
		pstmt.setString(15, loadingType);
		pstmt.setString(16, driverNAME);
		pstmt.setString(17, viaRoute);
		pstmt.setString(18, customerName);
		pstmt.setString(19, applicationNoAdd);
		if(distanceAdd !=""){
			pstmt.setDouble(20, Double.parseDouble(distanceAdd));
		}else{
			pstmt.setDouble(20, 0);
		}
		pstmt.setDouble(21, Double.parseDouble(latitude));
		pstmt.setDouble(22, Double.parseDouble(longitude));
		pstmt.setString(23,village);
		pstmt.setString(24,taluk);
		pstmt.setString(25,Lessetype);
		pstmt.setString(26,surveyNo);
		pstmt.setString(27,MineralType);
		pstmt.setInt(28,royalty);
		pstmt.setInt(29, tripcode);
		pstmt.setInt(30, barcode);
		pstmt.setString(31, VehicleType);
		pstmt.setString(32, port_no);
		pstmt.setString(33, DD_No);
		pstmt.setString(34, Bank_Name);
		pstmt.setString(35, DD_Date);
		pstmt.setString(36, SandLoadingFromTime);
		pstmt.setString(37, SandLoadingToTime);
		pstmt.setDouble(38, totalfee);
		inserted = pstmt.executeUpdate();
		pstmt.close();

		if (inserted == 1) {
			pstmt2 = con.prepareStatement(SandMiningStatements.UPDATE_QUANTITY_FOR_MDP);
			pstmt2.setString(1, quantity);
			pstmt2.setString(2, applicationNoAdd);
			pstmt2.setInt(3, systemid);
			pstmt2.setInt(4, Integer.parseInt(globalClientId));
			pstmt2.executeUpdate();
		}
	}
		catch (Exception e) {

			System.out.println("Exception getting getClientName(): " + e);
			e.printStackTrace();
		} finally {

			if (inserted > 0) {
				message = "Saved Successfully..!";
				System.out.println("Rest Of Karnataka MDP generated.. LTSP - "+systemid);
			} else {
				message = "Error in saving..Please Re-Enter!";
			}
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return message;

	}

public JSONArray getCheckpost(int systemId, int customerId) { //getStockyards

	JSONArray jsonArray = new JSONArray();
	JSONObject obj = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try {
		con = DBConnection.getConnectionToDB("AMS"); //and s.USER_ID=? and c.Client_Id=?
		pstmt = con.prepareStatement("select value from General_Settings where name='checkpost' and System_Id=? order by value ");
		pstmt.setInt(1, systemId);
	//	pstmt.setInt(3,userId);
		rs = pstmt.executeQuery();
		while (rs.next()) {
				obj = new JSONObject();
				obj.put("checkpostsvalue", rs.getString("value"));
				jsonArray.put(obj);
	
		}		
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;
}
public JSONArray getTripSheetCode1(int systemId, int customerId, int tripStartCode, int tripEndCode, int userId) {

	JSONArray jsonArray = new JSONArray();
	JSONObject obj = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	try {
		con = DBConnection.getConnectionToDB("AMS"); 
		ArrayList tripCodeGeneratedlist = new ArrayList();
		pstmt = con.prepareStatement("select TRIP_CODE from dbo.Sand_Mining_Trip_Sheet where System_Id=? and Client_Id=? and BAR_CODE between ? and ? "
				+ "union "
				+ "select BAR_CODE from dbo.Sand_Mining_Trip_Sheet_History where System_Id=? and Client_Id=? and BAR_CODE between ? and ? ");
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);
		pstmt.setInt(3, tripStartCode);
		pstmt.setInt(4, tripEndCode);
		pstmt.setInt(5, systemId);
		pstmt.setInt(6, customerId);
		pstmt.setInt(7, tripStartCode);
		pstmt.setInt(8, tripEndCode);
		rs = pstmt.executeQuery();
		while (rs.next()) {
			tripCodeGeneratedlist.add(rs.getInt("TRIP_CODE"));					
		}	
		boolean notFound = false;
		for(int code = tripStartCode; code <= tripEndCode ; code++) {
			if(tripCodeGeneratedlist.size() > 0){
				for(int i = 0; i< tripCodeGeneratedlist.size(); i++) {
					if((Integer)tripCodeGeneratedlist.get(i) == code) {
						notFound = false; 
						break;
					} else {
						notFound = true; 							
					}
				}
				if(notFound){
					obj = new JSONObject();
					obj.put("tripSheetCode", code);
					jsonArray.put(obj);
					notFound = false;
				} 					
			} else {
				obj = new JSONObject();
				obj.put("tripSheetCode", code);
				jsonArray.put(obj);
			}
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;
}

public JSONArray getBarCode1(int systemId, int customerId, int barStartCode, int barEndCode, int userId) {

	JSONArray jsonArray = new JSONArray();
	JSONObject obj = null;
	Connection jc = null;
	
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	

	try {
		con = DBConnection.getConnectionToDB("AMS"); 
		ArrayList barCodeGeneratedlist = new ArrayList();
		pstmt = con.prepareStatement("select BAR_CODE from dbo.Sand_Mining_Trip_Sheet where System_Id=? and Client_Id=? and BAR_CODE between ? and ? "
				+ "union "
				+ "select BAR_CODE from dbo.Sand_Mining_Trip_Sheet_History where System_Id=? and Client_Id=? and BAR_CODE between ? and ? ");
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);
		pstmt.setInt(3, barStartCode);
		pstmt.setInt(4, barEndCode);
		pstmt.setInt(5, systemId);
		pstmt.setInt(6, customerId);
		pstmt.setInt(7, barStartCode);
		pstmt.setInt(8, barEndCode);
		rs = pstmt.executeQuery();
		while (rs.next()) {
			barCodeGeneratedlist.add(rs.getInt("BAR_CODE"));					
		}	
		boolean notFound = false;
		for(int code = barStartCode; code <= barEndCode ; code++) {
			if(barCodeGeneratedlist.size() > 0){
				for(int i = 0; i< barCodeGeneratedlist.size(); i++) {
					if((Integer)barCodeGeneratedlist.get(i) == code) {
						notFound = false; 
						break;
					} else {
						notFound = true; 							
					}
				}
				if(notFound){
					obj = new JSONObject();
					obj.put("barCode", code);
					jsonArray.put(obj);
					notFound = false;
				} 					
			} else {
				obj = new JSONObject();
				obj.put("barCode", code);
				jsonArray.put(obj);
			}
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;
}

public JSONArray getStockyardsForConsumer(int systemId, int customerId,String stockyardName) { 

	JSONArray jsonArray = new JSONArray();
	JSONObject obj = null;
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try {
		con = DBConnection.getConnectionToDB("AMS"); //and s.USER_ID=? and c.Client_Id=?
		pstmt = con.prepareStatement("select UniqueId,Port_Name,Port_Taluk from Sand_Port_Details where System_Id=? and Client_Id=? and ASSESSED_QUANTITY >0 and Port_Taluk=? ");
		pstmt.setInt(1, systemId);
		pstmt.setInt(2,customerId);
		pstmt.setString(3,stockyardName);
		rs = pstmt.executeQuery();
		while (rs.next()) {
				obj = new JSONObject();
				obj.put("stockyardIdValue", rs.getString("UniqueId"));
				obj.put("stockyardValue", rs.getString("Port_Name"));
				jsonArray.put(obj);
	
		}		
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;
}

public String UpdateConsumerApprovalData(int systemid, int clientId,int uniqueId,int userId,String approvedQty,String balanceSandQty,String AppNo,String newQty) {

	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt=null;
	ResultSet rs = null;
	JSONObject obj = null;
	String msg="Error"; 
	try {
		
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.INSERT_CONSUMER_ADDITIONAL_QTY_DATA);
		
		pstmt.setInt(1, systemid);
		pstmt.setInt(2, clientId);
		pstmt.setInt(3, uniqueId);
		
		int p = pstmt.executeUpdate();
		if (p > 0) {
			pstmt = con.prepareStatement(SandMiningStatements.UPDATE_CONSUMER_ENROLMENT);
			
			pstmt.setString(1, approvedQty);
			pstmt.setString(2, balanceSandQty);
			pstmt.setString(3, newQty);
			pstmt.setInt(4, userId);
			pstmt.setInt(5, systemid);
			pstmt.setInt(6, clientId);
			pstmt.setInt(7, uniqueId);
			
			int i = pstmt.executeUpdate();
			if (i > 0) {
				msg=" Updated Successfully..!!";	
			}
		}
		
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, null);
	}
	return msg;
}
public JSONArray getPermitNosForILMS(int systemid, String clientId,
		int userId, int offset,String sourceLat,String sourceLng) {

	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs1 = null;
	String vehicleNo1="";
	String vehicleNo2="";
	boolean b=false;
	int count=0;
	double bufferDistance=0.0;
	double VehNonCommHrs = 6.0;

	try {
		con = DBConnection.getConnectionToDB("AMS");
		
		pstmt1=con.prepareStatement(" select isnull(MDP_BUFFER_DISTANCE,0) as MdpBufferDistance , isnull(NON_COMMUNICATING_HOURS,0) as nonCommHrs from dbo.SAND_MDP_TIME_SETTING" +
						" where SYSTEM_ID=? and CUSTOMER_ID=? ");
		pstmt1.setInt(1, systemid);
		pstmt1.setInt(2, Integer.parseInt(clientId));
		rs1=pstmt1.executeQuery();
		if(rs1.next()){
			bufferDistance = Double.parseDouble(rs1.getString("MdpBufferDistance"));
			VehNonCommHrs=Double.parseDouble(convertMinutesToHHMMFormat1(Integer.parseInt(rs1.getString("nonCommHrs")))) ;
		}
		if(VehNonCommHrs == 0.0){
			VehNonCommHrs =6.0;
		}
		
		pstmt = con.prepareStatement(SandMiningStatements.GET_PERMIT_NO_FOR_ILMS_MDP_GENERATOR);
		
		pstmt.setInt(1, systemid);
		pstmt.setString(2, clientId);
		pstmt.setInt(3, userId);
		pstmt.setDouble(4, VehNonCommHrs);
		rs = pstmt.executeQuery();
		JSONObject obj1 = new JSONObject();
		double reachDistance=0.0;
		while (rs.next()) {
			
			//System.out.println("veh no--"+rs.getString("VEHICLENO"));
			//System.out.println("bufferDistance--"+bufferDistance);
			if(bufferDistance >0){
			reachDistance = checkDistance(Double.parseDouble(sourceLat),Double.parseDouble(sourceLng),
					Double.parseDouble(rs.getString("LATITUDE")),Double.parseDouble(rs.getString("LONGITUDE")));
			//System.out.println("reachDistance--"+reachDistance);
			if(!(reachDistance <= bufferDistance)){
				//System.out.println("skip veh--"+rs.getString("VEHICLENO"));
				continue;
				
			}
			}
			
			obj1 = new JSONObject();
			obj1.put("PermitNoNew", rs.getString("VehicleNo"));
			obj1.put("OwnerNameNew", rs.getString("OwnerName"));
			obj1.put("Owner_TypeNew", "Transporter");
			obj1.put("PortNew", rs.getString("VehicleType"));
			obj1.put("Group_Name", rs.getString("GROUP_NAME"));
			obj1.put("Group_Id", rs.getString("GROUP_ID"));
			obj1.put("LoadCapacityNew", rs.getString("UnLadenWeight"));
			obj1.put("blockVehicle", rs.getString("BLOCKED_VEHICLE_NO"));
			obj1.put("loadingCapacity", rs.getString("LoadingCapacity"));
			jsonArray.put(obj1);
			
		}
		} catch (Exception e) {
		System.out.println("Exception getting getPermitNosALL(): " + e);
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;

}
public JSONArray getFromSandPort(int systemid, String clientId,int userId) {

	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs1 = null;

	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_ILMS_SAND_PORT);
		pstmt.setInt(1, systemid);
		pstmt.setString(2,clientId);
		rs = pstmt.executeQuery();
		JSONObject obj1 = new JSONObject();
		while (rs.next()) {
			obj1 = new JSONObject();
			obj1.put("portNo", rs.getString("Port_No"));
			obj1.put("portName", rs.getString("Port_Name"));
			obj1.put("portVillage", rs.getString("Port_Village"));
			obj1.put("portTaluk", rs.getString("Port_Taluk"));
			obj1.put("portSurveyNumber", rs.getString("Port_Survey_Number"));
			obj1.put("portUniqueid", rs.getString("UniqueId"));
			obj1.put("assessedQuantity", rs.getString("ASSESSED_QUANTITY"));
			obj1.put("lat", rs.getString("LATITUDE"));
			obj1.put("longi", rs.getString("LONGITUDE"));
			jsonArray.put(obj1);
		}
	} catch (Exception e) {
		System.out.println("Exception getting getPermitNosALL(): " + e);
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return jsonArray;

}
 public String insert_ILMS_MDP_GRID(String uniqueId,
		String tripSheetNO, String permitNo, 
		String vehicleNo, String fromPlace,
		String toPlace, String dateOfEntry, String printed,
		int systemid, String globalClientId, int offset,
		String processing, String validTo,
		String tSDATE, int userId,String gROUPID, String gROUPNAME, String distanceAdd, String contactNoAdd,
		String customerNameOrAddressAdd,String unloadWeight,String loadWeight,String destLat,String destLng,String netWeight) {

	String message = "";
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt1 = null;
	PreparedStatement pstmt2 = null;
	ResultSet rs1 = null;
	boolean f = false;
	String fromdatenew=null;
	int inserted = 0;
	int inserted1 = 0;
	int count = 0;
	try {
		con = DBConnection.getConnectionToDB("AMS");
		//message = getConsumerType(systemid,globalClientId,applicationNoAdd,offset);
		
		if(!message.equals(""))
		{
			return message;
		} else {
		Date date = (new Date());
		
		if (!message.equalsIgnoreCase("Error")) {
			if (dateOfEntry.contains("T")) {
				dateOfEntry = dateOfEntry.replace("T", " ");
			} 
			
			if (validTo.contains("T")) {
				validTo = validTo.replace("T", " ");
			} 
			
			if (tSDATE.contains("T")) {
				tSDATE = tSDATE.replace("T", " ");
			} 
			
			
			String[] temp = tripSheetNO.split("-");

			String teest = tripSheetNO.substring(0, tripSheetNO
					.lastIndexOf("-") + 1);

			int tno = Integer.parseInt(temp[temp.length - 1]);
			
			pstmt1 = con.prepareStatement(SandMiningStatements.CHECK_DUPLICATE_PERMIT_NO);

			pstmt1.setInt(1, systemid);
			pstmt1.setInt(2, Integer.parseInt(globalClientId));
			pstmt1.setInt(3, userId);
			pstmt1.setString(4, permitNo);
			rs1 = pstmt1.executeQuery();
			if (rs1.next()) {
				message = "Trip sheet number already exist..!";
				return message;
			}

			pstmt1 = con.prepareStatement(SandMiningStatements.GET_TRIP_SHEET_NO);

			pstmt1.setInt(1, systemid);
			pstmt1.setInt(2, Integer.parseInt(globalClientId));
			pstmt1.setInt(3, systemid);
			pstmt1.setInt(4, Integer.parseInt(globalClientId));
			rs1 = pstmt1.executeQuery();
			if (rs1.next()) {
				String newTS = rs1.getString("Trip_Sheet_No");
				String[] temp1 = newTS.split("-");
				tno = Integer.parseInt(temp1[temp1.length - 1]);
				tno++;
				tripSheetNO = teest + Integer.toString(tno);

			}
			Date date4 = new Date();
			String D1 = simpleDateFormatddMMYYYYDB.format(date4).substring(0, 10)+ " 00:00:00";
			String D2 = simpleDateFormatddMMYYYYDB.format(date4).substring(0, 10)+ " 23:59:59";
			
			pstmt1 = con.prepareStatement(SandMiningStatements.GET_COUNT_TRIP_SHEET_NO);
			pstmt1.setInt(1, systemid);
			pstmt1.setString(2, globalClientId);
			pstmt1.setString(3, fromPlace);
			pstmt1.setInt(4, offset);
			pstmt1.setString(5, D1);
			pstmt1.setInt(6, offset);
			pstmt1.setString(7, D2);
			rs1 = pstmt1.executeQuery();
			if (rs1.next()) {
				count = rs1.getInt("count");
			}
			pstmt1.close();
			rs1.close();
				
				pstmt = con.prepareStatement(SandMiningStatements.INSERT_ILMS_MDP_DETAILS);
				pstmt.setString(1, tripSheetNO);
				pstmt.setString(2, permitNo);
				pstmt.setString(3, vehicleNo);
				pstmt.setString(4, fromPlace);
				pstmt.setString(5, toPlace);
				pstmt.setInt(6, offset);
				pstmt.setString(7, dateOfEntry);
				pstmt.setInt(8, offset);
				pstmt.setString(9, validTo);// todate
				pstmt.setInt(10, systemid);
				pstmt.setString(11, globalClientId);
				pstmt.setString(12, processing);
				pstmt.setString(13, printed);
				pstmt.setInt(14, userId);
				pstmt.setString(15, gROUPID);
				pstmt.setString(16, gROUPNAME);
				pstmt.setInt(17, ++count);
				pstmt.setInt(18,Integer.parseInt(uniqueId));
				pstmt.setString(19, distanceAdd);
				pstmt.setString(20, customerNameOrAddressAdd);
				pstmt.setString(21, contactNoAdd);
				pstmt.setString(22, unloadWeight);
				pstmt.setString(23, loadWeight);
				pstmt.setString(24, destLat);
				pstmt.setString(25, destLng);
				pstmt.setString(26, netWeight);
				inserted = pstmt.executeUpdate();
				pstmt.close();

				if (inserted == 1) {
					
					pstmt = con.prepareStatement(SandMiningStatements.UPDATE_GENERAL_SETTINGS);
					pstmt.setInt(1, tno);
					pstmt.setInt(2, systemid);
					pstmt.setString(3, globalClientId);
					inserted1 = pstmt.executeUpdate();
					pstmt.close();

				}
			} 

		 else {
			return "Max number of Trip Sheets reached for this sand port and loading type combination...!";
		}
		}
	} catch (Exception e) {

		System.out.println("Exception getting getClientName(): " + e);
		e.printStackTrace();
	} finally {

		if (inserted > 0) {
			message = "Saved Successfully..!";
		} else {
			message = "Error in saving..Please Re-Enter!";
		}
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
	}
	return message;

}  
 public String insertSandMdpLimitDetails(int userId,int systemId,String custId,String fromDateId,String endDateId,String governmentNameId,String publictextId,String contractortextId,String ashrayatextId)

 {
 	PreparedStatement pstmt=null,pstmt1 = null;
     Connection connection = null;
     ResultSet rs=null,rs1 = null;
     int inserted=0;
     String messsage=null;
     double balAmount=0.0;
     try{
     	 Date date = simpleDateFormatddMMYYYYDB1.parse(fromDateId);
     	 fromDateId=simpleDateFormatddMMYYYYDB.format(date);
     	 Date date1 = simpleDateFormatddMMYYYYDB1.parse(endDateId);
     	 endDateId=simpleDateFormatddMMYYYYDB.format(date1); 
         connection=DBConnection.getConnectionToDB("AMS");
         pstmt1=connection.prepareStatement(SandMiningStatements.CHECK_DUPLICATE_DATE);
         pstmt1.setInt(1,systemId);
         pstmt1.setString(2,custId);
         pstmt1.setString(3,fromDateId);
         pstmt1.setString(4,endDateId);
         rs1=pstmt1.executeQuery();
         if(rs1.next())
         {
         	messsage="Records/MDP limits alredy exist for the given date, please use update option";
         	return messsage;
         }
     	int inserted_rec = 0;
      	int days = 0;
      	int dayteadd =  0 ;
        pstmt = connection.prepareStatement("Select DATEDIFF(dd,?,?) as DAYS");
      	pstmt.setString(1, fromDateId);
      	pstmt.setString(2, endDateId);
      	rs1 = pstmt.executeQuery();
      	
      	if(rs1.next()){
      		 days = rs1.getInt("DAYS");
      	}
      while(inserted_rec<=days){
        pstmt = connection.prepareStatement(SandMiningStatements.INSERT_MDP_GENERATION_LIMIT_DETAILS);
     	pstmt.setInt(1, dayteadd);
     	pstmt.setString(2, fromDateId);
     	pstmt.setString(3, governmentNameId);
     	pstmt.setString(4, publictextId);
     	pstmt.setString(5, contractortextId);
     	pstmt.setString(6, ashrayatextId);
     	pstmt.setInt(7, userId);
     	pstmt.setInt(8, userId);
     	pstmt.setInt(9, systemId);
     	pstmt.setInt(10, Integer.parseInt(custId));
     	
     	inserted=pstmt.executeUpdate();
     	inserted_rec++;
     	dayteadd++;
     	
      }
     	if(inserted>0)
     	{
     	messsage="INSERTED SUCCESSFULLY";	
     	}
     	else
     	messsage="ERROR WHILE INSERTING";
     		
     	
     }
     catch (Exception e) {
 		// TODO: handle exception
     	e.printStackTrace();
 	}
     finally
     {
     DBConnection.releaseConnectionToDB(connection, pstmt, rs);	
     DBConnection.releaseConnectionToDB(connection, pstmt1, rs1);	
     }
     
     return messsage;
 }
 
 public String updateSandMdpLimitDetails(int userId,int systemId,String custId,String fromDateId,String governmentNameId,String publictextId,String contractortextId,String ashrayatextId,String uniqueId)

 {
 	PreparedStatement pstmt=null;
     Connection connection = null;
     ResultSet rs=null;
     int updated=0;
     String messsage=null;
     double balAmount=0.0;
     try{
     	 
         connection=DBConnection.getConnectionToDB("AMS");
        pstmt = connection.prepareStatement(SandMiningStatements.UPDATE_MDP_GENERATION_LIMIT_DETAILS);
     	pstmt.setString(1, governmentNameId);
     	pstmt.setString(2, publictextId);
     	pstmt.setString(3, contractortextId);
     	pstmt.setString(4, ashrayatextId);
     	pstmt.setInt(5, userId);
     	pstmt.setInt(6, systemId);
     	pstmt.setInt(7, Integer.parseInt(custId));
     	pstmt.setInt(8, Integer.parseInt(uniqueId));
     	
     	
     	updated=pstmt.executeUpdate();
     	if(updated>0)
     	{
     	messsage="UPDATED SUCCESSFULLY";	
     	}
     	else
     	messsage="ERROR WHILE UPDATING";
     		
     	
     }
     catch (Exception e) {
 		// TODO: handle exception
     	e.printStackTrace();
 	}
     finally
     {
     DBConnection.releaseConnectionToDB(connection, pstmt, rs);	
     }
     
     return messsage;
 }
 public ArrayList getMdpGenerationLimit(int systemid,
			String custId, int offset, int userId, String startDate, String endDate) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj1 = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String stmt = "";
		String DateofEntry = "";
		String DateofEntry1 = "";
		String date = "";
		String date1 = "";
		
		ArrayList reportsList = new ArrayList();
		ArrayList headersList = new ArrayList();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList finlist = new ArrayList();
		int count = 0;

		try {
			Date fromDateId = simpleDateFormatddMMYYYYDB1.parse(startDate);
			startDate=simpleDateFormatddMMYYYYDB.format(fromDateId); 
	   	 	Date toDateId = simpleDateFormatddMMYYYYDB1.parse(endDate);
	   	 	endDate=simpleDateFormatddMMYYYYDB.format(toDateId); 
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SandMiningStatements.GET_MDP_GENERATOR_LIMIT_DETAILS);
			
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemid);
			pstmt.setString(3, custId);
			pstmt.setString(4, startDate);
			pstmt.setString(5, endDate);

			rs = pstmt.executeQuery();
			headersList.add("SLNO");
			headersList.add("Unique Id");
			headersList.add("Date");
			headersList.add("Government");
			headersList.add("Public");
			headersList.add("Contractor");
			headersList.add("Ashraya");
			headersList.add("Updated By");
			headersList.add("Updated Date");
			
			while (rs.next()) {
				count++;
				obj1 = new JSONObject();
				ArrayList informationList = new ArrayList();
				ReportHelper reporthelper = new ReportHelper();

				// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				

				if (rs.getString("fromDate") != null && !rs.getString("fromDate").equals("") && !rs.getString("fromDate").contains("1900")) {
					date = sdf.format(rs.getTimestamp("fromDate"));
					date1 = simpleDateFormatdd_MM_YY.format(rs.getTimestamp("fromDate"));
				} else {
					date = "";
					date1 = "";
				}
				if (rs.getString("updatedDate") != null && !rs.getString("updatedDate").equals("") && !rs.getString("updatedDate").contains("1900")) {
					DateofEntry = sdf.format(rs.getTimestamp("updatedDate"));
					DateofEntry1 = simpleDateFormatddMMYYYYDB1.format(rs.getTimestamp("updatedDate"));
				} else {
					DateofEntry = "";
					DateofEntry1 = "";
				}

				informationList.add(count);
				obj1.put("slnoIndex", count);

				informationList.add(rs.getString("ID"));
				obj1.put("uniqueIdDataIndex", rs.getString("ID"));
				
				informationList.add(date1);
				obj1.put("Dateindex", date1);
				
				informationList.add(rs.getString("governmentLimit"));
				obj1.put("govtDataIndex", rs.getString("governmentLimit"));

				informationList.add(rs.getString("publicLimit"));
				obj1.put("publicDataIndex", rs.getString("publicLimit"));

				informationList.add(rs.getString("contractorLimit"));
				obj1.put("contractorDataIndex", rs.getString("contractorLimit"));
				
				informationList.add(rs.getString("ashrayaLimit"));
				obj1.put("ashrayaDataIndex", rs.getString("ashrayaLimit"));
				
				informationList.add(rs.getString("updatedBy"));
				obj1.put("updatedbyindex",rs.getString("updatedBy"));
				
				informationList.add(DateofEntry);
				obj1.put("updatedDateindex", DateofEntry1);

				jsonArray.put(obj1);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}

			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
		}

		catch (Exception e) {
			System.out.println("Error in getting Master Details:"
					+ e.toString());
			e.printStackTrace();
		} finally {
			finlist.add(jsonArray);
			finlist.add(finalreporthelper);
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return finlist;

	}
 public JSONArray getMdpLimitStore(int systemid, String clientId,int userId,String date,String applicationNO, int offset )
 {

	JSONArray jsonArray = new JSONArray();
	Connection con = null;
	PreparedStatement pstmt = null,pstmt1 = null;
	ResultSet rs = null , rs1 = null;
	String governmentLimit = "NA";
	String publicLimit = "NA";
	String contractorLimit = "NA";
	String ashrayaLimit = "NA";
	String applicationType = "";
	
	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(SandMiningStatements.GET_MDP_GENERATOR_LIMIT_DETAILS);
		pstmt.setInt(1, offset);
		pstmt.setInt(2, systemid);
		pstmt.setString(3, clientId);
		pstmt.setString(4, date+" 00:00:00");
		pstmt.setString(5, date+" 23:59:59");
		rs = pstmt.executeQuery();
		if (rs.next()) {
			governmentLimit = rs.getString("governmentLimit");
			publicLimit = rs.getString("publicLimit");
			contractorLimit = rs.getString("contractorLimit");
			ashrayaLimit = rs.getString("ashrayaLimit");
		}
		pstmt1 = con.prepareStatement(SandMiningStatements.GET_APPLICTION_TYPE);
		pstmt1.setInt(1, systemid);
		pstmt1.setString(2, clientId);
		pstmt1.setString(3, applicationNO);
		rs1 = pstmt1.executeQuery(); 
		if (rs1.next()) {
			applicationType = rs1.getString("CONSUMER_TYPE");
			
		}
		pstmt = con.prepareStatement(SandMiningStatements.GET_MDP_GENERATOR_LIMIT_COUNT_DETAILS);
		pstmt.setInt(1, systemid);
		pstmt.setString(2, clientId);
		pstmt.setString(3, applicationType);
		pstmt.setString(4, date+" 00:00:00");
		pstmt.setString(5, date+" 23:59:59");
		
		rs = pstmt.executeQuery();
		
		if (rs.next()) {
			JSONObject obj1 = new JSONObject();
			obj1.put("ConsumerType", rs.getString("CONSUMER_TYPE"));
			obj1.put("TotalMdpUsed", rs.getString("CNT"));
			
			if(rs.getString("CONSUMER_TYPE").equals("Ashraya")){
				
				obj1.put("TotalMdpLimit", ashrayaLimit);
			}
			if(rs.getString("CONSUMER_TYPE").equals("Government")){
				obj1.put("TotalMdpLimit", governmentLimit);
			}
			if(rs.getString("CONSUMER_TYPE").equals("Public")){
				obj1.put("TotalMdpLimit", publicLimit);
			}
			if(rs.getString("CONSUMER_TYPE").equals("Contractor")){
				obj1.put("TotalMdpLimit", contractorLimit);
			}
			jsonArray.put(obj1);
			
		}else{
			JSONObject obj1 = new JSONObject();
			obj1.put("ConsumerType", applicationType);
			obj1.put("TotalMdpUsed", 0);
			if(applicationType.equals("Ashraya")){
				
				obj1.put("TotalMdpLimit", ashrayaLimit);
			}
			if(applicationType.equals("Government")){
				obj1.put("TotalMdpLimit", governmentLimit);
			}
			if(applicationType.equals("Public")){
				obj1.put("TotalMdpLimit", publicLimit);
			}
			if(applicationType.equals("Contractor")){
				obj1.put("TotalMdpLimit", contractorLimit);
			}
			jsonArray.put(obj1);
		}
		
	} catch (Exception e) {
		System.out.println("Exception getting getApplicationNoStore(): " + e);
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
	}
	return jsonArray;

}
 
 
 public JSONArray getIssueNosForReprint(int systemid, String clientId) {

		JSONArray jsonArray = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		String vehicleNo1="";
		String vehicleNo2="";
		boolean b=false;
		int count=0;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			
			pstmt = con.prepareStatement(SandMiningStatements.GET_ISSUE_NO_FOR_MDP_REPRINT);
			
			pstmt.setInt(1, systemid);
			pstmt.setString(2, clientId);
			//pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			JSONObject obj1 = new JSONObject();
			while (rs.next()) {
				obj1 = new JSONObject();
				obj1.put("IssueTPIDNoNew", rs.getString("TpID"));
				obj1.put("TemporaryPermitNoNew", rs.getString("PermitNoNew"));				
				jsonArray.put(obj1);
				
			}
			} catch (Exception e) {
			System.out.println("Exception getting getPermitNosALL(): " + e);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

 
 public ArrayList getViewSheetDetails(int systemId, int customerId, int offset, int userId,String tpOwner,String startDate,String endDate) {
		SimpleDateFormat ddMMYYHHmmss = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		
		//JDBCConnection jc = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		ArrayList reportsList = new ArrayList();
		ArrayList headersList = new ArrayList();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList finlist = new ArrayList();
		int count = 0;

		try {
			//jc = new JDBCConnection();
			//con = jc.getConnection("sqlserver");
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SandMiningStatements.GET_REPRINT_DATA);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, customerId);
			pstmt.setInt(5, userId);
			pstmt.setInt(6, userId);
			pstmt.setString(7, tpOwner);
			pstmt.setInt(8, offset);
			pstmt.setString(9, startDate);
			pstmt.setInt(10, offset);
			pstmt.setString(11, endDate);
			pstmt.setInt(12, offset);
			pstmt.setInt(13, offset);
			pstmt.setInt(14, systemId);
			pstmt.setInt(15, customerId);
			pstmt.setInt(16, userId);
			pstmt.setInt(17, userId);
			pstmt.setString(18, tpOwner);
			pstmt.setInt(19, offset);
			pstmt.setString(20, startDate);
			pstmt.setInt(21, offset);
			pstmt.setString(22, endDate);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				obj = new JSONObject();
				ArrayList informationList = new ArrayList();
				ReportHelper reporthelper = new ReportHelper();

				informationList.add(count);
				obj.put("slnoId", count);

				informationList.add(rs.getString("ASSET_NO"));
				obj.put("vehicleNumber", rs.getString("ASSET_NO"));
				
				informationList.add(rs.getString("TP_NUMBER"));
				obj.put("tempPermitNumber", rs.getString("TP_NUMBER"));
				
				informationList.add(rs.getString("DISTRICT_IN_OUT"));
				obj.put("IOdistrict", rs.getString("DISTRICT_IN_OUT"));

				informationList.add(rs.getString("LeaseNumber"));
				obj.put("leaseNumber", rs.getString("LeaseNumber"));

				informationList.add(rs.getString("LeaseName"));
				obj.put("leaseName", rs.getString("LeaseName"));
				
				informationList.add(rs.getString("PERMIT_NO"));
				obj.put("permitNumber", rs.getString("PERMIT_NO"));
				
				informationList.add(rs.getString("TRIP_CODE"));
				obj.put("tripSheetCodeNumber", rs.getString("TRIP_CODE"));

				informationList.add(rs.getString("BAR_CODE"));
				obj.put("barCodeNumber", rs.getString("BAR_CODE"));
				
				informationList.add(ddMMYYHHmmss.format(rs.getTimestamp("VALID_FROM")));
				obj.put("validFrom", ddMMYYHHmmss.format(rs.getTimestamp("VALID_FROM")));
				
				informationList.add(ddMMYYHHmmss.format(rs.getTimestamp("VALID_TO")));
				obj.put("validTo", ddMMYYHHmmss.format(rs.getTimestamp("VALID_TO")));
				
				informationList.add(rs.getString("BUYER"));
				obj.put("buyer", rs.getString("BUYER"));
				
				informationList.add(rs.getString("Taluk"));
				obj.put("talukDistrict", rs.getString("Taluk"));
				
				informationList.add(rs.getString("QUANTITY"));
				obj.put("quantity", rs.getString("QUANTITY"));
				
				informationList.add(rs.getString("ROYALTY"));
				obj.put("royalty", rs.getString("ROYALTY"));
				
				informationList.add(rs.getString("PROCESSING_FEE"));
				obj.put("processingFees", rs.getString("PROCESSING_FEE"));

				informationList.add(rs.getString("SAND_PORT"));
				obj.put("sourcePlace", rs.getString("SAND_PORT"));
				
				informationList.add(rs.getString("DESTINATION"));
				obj.put("destinationPlace", rs.getString("DESTINATION"));
								
				informationList.add(rs.getString("DISTANCE"));
				obj.put("distanceindex", rs.getString("DISTANCE"));

				informationList.add(rs.getString("Via_Route"));
				obj.put("route", rs.getString("Via_Route"));
				
				informationList.add(rs.getString("TYPE_OF_LAND"));
				obj.put("typeOfLand", rs.getString("TYPE_OF_LAND"));
				
				
				jsonArray.put(obj);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
		}

		catch (Exception e) {
			e.printStackTrace();
		} finally {
			finlist.add(jsonArray);
			finlist.add(finalreporthelper);
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}
 public String getDistrict(int systemId) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String message = null;
		String MdpStatus="";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement("select value from General_Settings where name='District' and System_Id=? ");
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				 MdpStatus = rs.getString("value");
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return MdpStatus;
	}
 public JSONArray getTpNosForCredit(String custId,int systemId)
 {
 	PreparedStatement pstmt = null;
     Connection con = null;
     ResultSet rs = null;
     JSONArray jsonArray=new JSONArray();
     String consumerName=null;
     JSONObject obj1 = new JSONObject();
     try {
     	con = DBConnection.getConnectionToDB("AMS");
     	
     		pstmt = con.prepareStatement(SandMiningStatements.GET_TP_NO_FOR_CREDIT);
     		 pstmt.setInt(1, systemId);
     		 pstmt.setString(2, custId);
        
         rs = pstmt.executeQuery();
             while (rs.next()) {
            	obj1 = new JSONObject();
 				obj1.put("tpNo", rs.getString("TP_NO"));
 				obj1.put("tpId", rs.getString("TP_ID"));
 				obj1.put("tpMobileNo", rs.getString("TP_PHONE"));
 				jsonArray.put(obj1);
             }
           

     } catch (Exception e) {
     	 e.printStackTrace();
     } finally {
         DBConnection.releaseConnectionToDB(con, pstmt, rs);
     }
     return jsonArray;
 }
 public String sendConsumerSMS(String consumerMobileNo,String consumerName, String customerId, int systemId,String applicationNo,String tpNo,String tpMobileNo,double ddAmount,double balAmount,double sandQuantity, Connection con ) {
		PreparedStatement pstmt = null;
		String message = "";
		try {
		 String Sms="SAND: Application NO: "+applicationNo+" and Consumer Name :"+consumerName+" has made a payment of Rs."+ddAmount+" for the sand quantity:"+sandQuantity+" to the TP Owner.:"+tpNo+",you can reach TP Owner at:"+tpMobileNo+" ";
		 pstmt = con.prepareStatement(SandMiningStatements.UPDATE_SMS);
		 pstmt.setString(1, consumerMobileNo);
		 pstmt.setString(2, Sms);
		 pstmt.setString(3, "N");
		 pstmt.setString(4, customerId);
		 pstmt.setInt(5, systemId);
	     int insert=pstmt.executeUpdate();
	     //int insert = 1;
	     if (insert > 0) {
				message = "Saved & SMS Sent successfully,";
			}else {
				message = "Saved & Error in sending SMS,";
			}
		}catch (Exception e) {
			e.printStackTrace();
			message = "error";
		}  finally {
			DBConnection.releaseConnectionToDB(null, pstmt, null);
		}
		return message;
	}
 public String sendTpOwnerSMS(String consumerMobileNo,String consumerName, String customerId, int systemId,String applicationNo,String tpNo,String tpMobileNo,double ddAmount,double balAmount,double sandQuantity, Connection con ) {
		PreparedStatement pstmt = null;
		String message = "";
		try {
		 String Sms="SAND: TP Owner.:"+tpNo+" has received an amount of Rs."+ddAmount+" from the Consumer Application NO:"+applicationNo+" for the sand quantity:"+sandQuantity+" "  ;
		 //String Sms="SAND: Consumer Application NO: "+applicationNo+" has credited successfully with the amount:"+ddAmount+" to the TP Owner.:"+tpNo+",and you can reach consumer at:"+consumerMobileNo+"   ";
		 pstmt = con.prepareStatement(SandMiningStatements.UPDATE_SMS);
		 pstmt.setString(1, tpMobileNo);
		 pstmt.setString(2, Sms);
		 pstmt.setString(3, "N");
		 pstmt.setString(4, customerId);
		 pstmt.setInt(5, systemId);
	     int insert=pstmt.executeUpdate();
	     //int insert = 1;
	     if (insert > 0) {
				message = "Saved & SMS Sent successfully,";
			}else {
				message = "Saved & Error in sending SMS,";
			}
		}catch (Exception e) {
			e.printStackTrace();
			message = "error";
		}  finally {
			DBConnection.releaseConnectionToDB(null, pstmt, null);
		}
		return message;
	}
 public boolean CONSUMER_MDP_FEATURE(int systemId,Connection con) {
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		boolean CONSUMER_MDP_FEATURE = false;
		String message = null;
		try {
			pstmt = con
					.prepareStatement("select value from General_Settings where name='CONSUMER_MDP_FEATURE' and System_Id=? ");
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				String ConsumerMdpStatus = rs.getString("value");
				if (ConsumerMdpStatus.equals("Y")) {
					CONSUMER_MDP_FEATURE = true;
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return CONSUMER_MDP_FEATURE;
	}
 public String CONSUMER_MDP_PDF_NOTE(int systemId) {
	 	Connection con = null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		boolean CONSUMER_MDP_FEATURE = false;
		String value2 = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con
					.prepareStatement("select * from dbo.General_Settings where name='CONSUMER_MDP_NOTE' and value='Y' and System_Id=?");
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				String ConsumerMdpStatus = rs.getString("value");
				if (ConsumerMdpStatus.equals("Y")) {
					value2=rs.getString("value2");
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return value2;
	}
 public JSONArray getVehicleWeight(String permitNo,int systemId){

	JSONArray jsonArray = new JSONArray();
	Connection con=null;
	Connection con1=null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt1 = null;
	ResultSet rs1 = null;
	JSONObject obj1 = new JSONObject();
	String unloadWeight = "0";
	String loadWeight = "0";
	String netWeight = "0";
	String readUnladenWeightFromApp="N";
	try {
		con=DBConnection.getConnectionMysToMysqlDB("sandUrl");
	    con1=DBConnection.getConnectionToDB("AMS");
	    pstmt1=con1.prepareStatement(SandMiningStatements.READ_UNLADEN_WEIGHT_FROM_APPLICATION);
		pstmt1.setInt(1, systemId);
		rs1=pstmt1.executeQuery();
		if(rs1.next())
		{
			readUnladenWeightFromApp=rs1.getString("value");
			
		}
		pstmt = con
		.prepareStatement("select  ifnull(ulw,0) as ulw,ifnull(glw,0) as glw,ifnull(final_wt,0.0) as final_wt,veh_reg_no from Intelly_Serve_Weights.wts_exchange where replace(veh_reg_no,' ','')=? and inserted_time between DATE_ADD(NOW(),INTERVAL -30 MINUTE) and NOW() order by inserted_time desc limit 1");
		pstmt.setString(1, permitNo);
		rs = pstmt.executeQuery();
		if(rs.next()){
			obj1 = new JSONObject();
			obj1.put("UnloadWeight", rs.getString("ulw"));
			obj1.put("loadWeight", rs.getString("glw"));
			obj1.put("netWeight", rs.getString("final_wt"));
			obj1.put("readUnladenWeightFromApp", readUnladenWeightFromApp);
			jsonArray.put(obj1);
		}else{
			obj1 = new JSONObject();
			obj1.put("UnloadWeight", unloadWeight);
			obj1.put("loadWeight", loadWeight);
			obj1.put("netWeight", netWeight);
			obj1.put("readUnladenWeightFromApp", readUnladenWeightFromApp);
			jsonArray.put(obj1);
		}
	}catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToMysqlDB(con1, pstmt1, rs1);
		DBConnection.releaseConnectionToMysqlDB(con, pstmt, rs);
		
	}
	return jsonArray;
}
 public JSONArray getMDPTimengs(int systemid, int clientId) {

		JSONArray jsonArray = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList L = new ArrayList();
		String vehicle="";
		String message="";
		JSONObject obj1 = new JSONObject();
		try {
			int startHrs=0;
	        int currentHrs=0;
	        int endHrs=0;
	        SimpleDateFormat sdf=new SimpleDateFormat("HH:mm");
	        con = DBConnection.getConnectionToDB("AMS");
			
			pstmt=con.prepareStatement(SandMiningStatements.GET_MDP_RESTRICTION_TIMENGS);
			pstmt.setInt(1, systemid);
			pstmt.setInt(2, clientId);
			rs=pstmt.executeQuery();
			if(rs.next())
			{
				//CURRENT_TIME
				String dateArr[]=rs.getString("CUR_TIME").split(" ");
				String dateAr=dateArr[1].substring(0,5);
				Date currentTime= sdf.parse(dateAr);
		        Date endTime = sdf.parse(rs.getString("END_TIME")); //rs.getString("END_TIME");
		        Date startTime = sdf.parse(rs.getString("START_TIME")); ;//rs.getString("START_TIME");
		        //Date validTime = sdf.parse(rs.getString("VALID_TIME")); //rs.getString("VALID_TIME");
		        String validTime = rs.getString("VALID_TIME");
			
		        if((currentTime.after(startTime) || currentTime.equals(startTime)) && currentTime.before(endTime)  )
		        {
		        	obj1 = new JSONObject();	
					obj1.put("messageId", "Success");
					obj1.put("validTime", validTime);
		        }else{
		        	obj1 = new JSONObject();	
					obj1.put("messageId", "Faile");
					obj1.put("validTime", validTime);
		        }
			}else{
				pstmt=con.prepareStatement(SandMiningStatements.GET_DEFAULT_MDP_TIMENGS);
				rs=pstmt.executeQuery();
				if(rs.next())
				{
					//CURRENT_TIME
					String dateArr[]=rs.getString("CUR_TIME").split(" ");
					String dateAr=dateArr[1].substring(0,5);
					Date currentTime= sdf.parse(dateAr);
			        Date endTime = sdf.parse(rs.getString("END_TIME")); //rs.getString("END_TIME");
			        Date startTime = sdf.parse(rs.getString("START_TIME")); ;//rs.getString("START_TIME");
			        //Date validTime = sdf.parse(rs.getString("VALID_TIME")); //rs.getString("VALID_TIME");
			        String validTime = rs.getString("VALID_TIME");
				
			        if((currentTime.after(startTime) || currentTime.equals(startTime)) && currentTime.before(endTime)  )
			        {
			        	obj1 = new JSONObject();	
						obj1.put("messageId", "Success");
						obj1.put("validTime", validTime);
			        }else{
			        	obj1 = new JSONObject();	
						obj1.put("messageId", "Faile");
						obj1.put("validTime", validTime);
			        }
				}
			}
			jsonArray.put(obj1);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToMysqlDB(con, pstmt, rs);
		}
		return jsonArray;

	}
 public String CONSUMER_ENROLMENT_PDF_NOTE(int systemId) {
	 	Connection con = null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		boolean CONSUMER_MDP_FEATURE = false;
		String value2 = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con
					.prepareStatement("select * from dbo.General_Settings where name='CONSUMER_ENROLMENT_NOTE' and value='Y' and System_Id=?");
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				String ConsumerMdpStatus = rs.getString("value");
				if (ConsumerMdpStatus.equals("Y")) {
					value2=rs.getString("value2");
				}
			}else{
				value2="Note: Your Application for SAND will be approved based on Document verification.";
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return value2;
	}
 
 public ArrayList<Object> getUnrecordedWeighBridgeReport(String startDate,String endDate,int systemId,int clientId,int offset)
	{
		
		SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
 	Connection con = null;
 	PreparedStatement pstmt = null;
 	ResultSet rs = null;
 	JSONArray jsArr = new JSONArray();
 	JSONObject obj = new JSONObject();
 	int slcount = 0; 
 	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
 	ArrayList<String> headersList = new ArrayList<String>();
 	ReportHelper finalreporthelper = new ReportHelper();
 	ArrayList<Object> finlist = new ArrayList<Object>();
 	String remarks = " Data is unavailable from weigh bridge provider";
 	
 	headersList.add("SLNO");
 	headersList.add("Vehicle No");
 	headersList.add("ILMS Trip Sheet No");
 	headersList.add("MDP No");
 	headersList.add("Loading Location");
 	headersList.add("Destination");
 	headersList.add("Valid From");
 	headersList.add("Valid To");
 	headersList.add("Gross Weight");
 	headersList.add("Unladen Weight");
 	headersList.add("Remarks");
 	
 	try{
 		con = DBConnection.getConnectionToDB("AMS");
 			pstmt = con.prepareStatement(SandMiningStatements.GET_UNRECORDED_WEIGH_BRIDGE_REPORT);
 			pstmt.setInt(1, offset);
	    	pstmt.setInt(2, offset);
	    	pstmt.setInt(3, systemId);
	    	pstmt.setInt(4, clientId);
 			pstmt.setString(5, startDate);
	    	pstmt.setString(6, endDate);
	    	rs = pstmt.executeQuery();
 		while (rs.next()) {
 			obj = new JSONObject();
 			ArrayList<Object> informationList=new ArrayList<Object>();
 			ReportHelper reporthelper=new ReportHelper();
 			slcount++;
 			
 			informationList.add(Integer.toString(slcount));
 			obj.put("slnoIndex", slcount);
 			
 			informationList.add(rs.getString("vehicleNo"));
 			obj.put("vehicleNoDataIndex", rs.getString("vehicleNo"));
 			
 			informationList.add(rs.getString("IlmsTripSheetNo"));
 			obj.put("tripSheetNoDataIndex", rs.getString("IlmsTripSheetNo"));
 			
 			informationList.add(rs.getString("mdpNo"));
 			obj.put("mdpNoDataIndex", rs.getString("mdpNo"));
 			
 			informationList.add(rs.getString("From_Place"));
 			obj.put("loadingLocationDataIndex", rs.getString("From_Place"));
 			
 			informationList.add(rs.getString("To_Palce"));
 			obj.put("destinationDataIndex", rs.getString("To_Palce"));
 			
 			if(!rs.getString("From_Date").contains("1900")){
     			informationList.add(sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parseObject(rs.getString("From_Date"))));
     			obj.put("validFromDataIndex", sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parse(rs.getString("From_Date"))));
     			}else{
 					obj.put("validFromDataIndex", "");
 					informationList.add("");
 				}
 			
 			if(!rs.getString("To_Date").contains("1900")){
     			informationList.add(sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parseObject(rs.getString("To_Date"))));
     			obj.put("validToDataIndex", sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parse(rs.getString("To_Date"))));
     			}else{
 					obj.put("validToDataIndex", "");
 					informationList.add("");
 				}
 			
 			informationList.add(rs.getString("LOADING_WEIGHT"));
 			obj.put("grossWeightDataIndex", rs.getString("LOADING_WEIGHT"));
 			
 			informationList.add(rs.getString("UNLOADING_WEIGHT"));
 			obj.put("unladenWeightDataIndex", rs.getString("UNLOADING_WEIGHT"));
 			
 			informationList.add(remarks);
 			obj.put("remarksDataIndex", remarks);
 			
 			jsArr.put(obj);
 			reporthelper.setInformationList(informationList);
 			reportsList.add(reporthelper);
 		}
 		finlist.add(jsArr);
 		finalreporthelper.setReportsList(reportsList);
 		finalreporthelper.setHeadersList(headersList);
 		finlist.add(finalreporthelper);
 	} catch (Exception e) {
 		e.printStackTrace();
 	} finally {
 		DBConnection.releaseConnectionToDB(con, pstmt, rs);
 	}
 		return finlist;
	}
 
 
 	public JSONArray getUnladenWeight(int systemid,int userId, String vehicleNo) {

		JSONArray jsonArray = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SandMiningStatements.GET_MDP_COUNT_TAKEN);
			pstmt.setInt(1, systemid);
			pstmt.setString(2,vehicleNo);
			rs = pstmt.executeQuery();
			JSONObject obj = new JSONObject();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("count", rs.getString("Unladencount"));  
				jsonArray.put(obj);
			}
		} catch (Exception e) {
			System.out.println("Exception getting getUnladenWeight(): " + e);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}
 	
 	public JSONArray getMDPCountForLocation4(int systemid,int userId, String vehicleNo) {

		JSONArray jsonArray = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SandMiningStatements.GET_MDP_LOCATION_COUNT_TAKEN_4);
			pstmt.setInt(1, systemid);
			pstmt.setString(2,vehicleNo);
			rs = pstmt.executeQuery();
			JSONObject obj = new JSONObject();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("count", rs.getString("LocationCount"));  
				jsonArray.put(obj);
			}
		} catch (Exception e) {
			System.out.println("Exception getting getMDPCountForLocation(): " + e);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}
 	public JSONArray getMdpCountAndLoadingCapacityFromDb(int systemid,String customerId,int portId) {

		JSONArray jsonArray = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SandMiningStatements.GET_TOTAL_MDP_AND_LOADCAPACITY);
			pstmt.setInt(1, systemid);
			pstmt.setString(2,customerId);
			pstmt.setInt(3, portId);
			rs = pstmt.executeQuery();
			JSONObject obj = new JSONObject();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("loadingCapacityFromDBType1", rs.getString("LOADING_CAPACITY_TYPE1")); 
				obj.put("mdpCountFromDBType1", rs.getString("MDP_ALLOWED_TYPE1")); 
				obj.put("loadingCapacityFromDBType2", rs.getString("LOADING_CAPACITY_TYPE2")); 
				obj.put("mdpCountFromDBType2", rs.getString("MDP_ALLOWED_TYPE2")); 
				obj.put("loadingCapacityFromDBType3", rs.getString("LOADING_CAPACITY_TYPE3")); 
				obj.put("mdpCountFromDBType3", rs.getString("MDP_ALLOWED_TYPE3")); 
				jsonArray.put(obj);
			}
		} catch (Exception e) {
			System.out.println("Exception getting getMdpCountAndLoadingCapacityFromDb(): " + e);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}
 	
 	public JSONArray getMDPCountForLocation6(int systemid,int userId, String vehicleNo) {

		JSONArray jsonArray = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SandMiningStatements.GET_MDP_LOCATION_COUNT_TAKEN_6);
			pstmt.setInt(1, systemid);
			pstmt.setString(2,vehicleNo);
			rs = pstmt.executeQuery();
			JSONObject obj = new JSONObject();
			while (rs.next()) {
				obj = new JSONObject();
				obj.put("count", rs.getString("LocationCount"));  
				jsonArray.put(obj);
			}
		} catch (Exception e) {
			System.out.println("Exception getting getMDPCountForLocation(): " + e);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;

	}

 	
 
}
