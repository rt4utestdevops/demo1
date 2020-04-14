package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.AdminStatements;
import t4u.statements.BillingStatements;
import t4u.statements.PreventiveMaintenanceStatements;
public class BillingFunctions {
	SimpleDateFormat sdfyyyymmdd=new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat sdfddmmyyyy=new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat sdfddmmyy = new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat sdfyyyymmddhhmmss = new SimpleDateFormat(
	"dd-MM-yyyy HH:mm:ss");
	CommonFunctions cf=new CommonFunctions();

	
	public JSONArray getLtsp(int systemId) {
	    JSONArray JsonArray = null;
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        JsonArray = new JSONArray();
	        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
	        pstmt = con.prepareStatement(BillingStatements.GET_LTSP);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            JsonObject.put("systemId", rs.getInt("System_id"));
	            JsonObject.put("systemName", rs.getString("System_Name"));
	            JsonArray.put(JsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}

	public ArrayList < Object > getBillingReport(int ltspId, String invoiceNo, String language, int month,String insertedDate) {
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		ReportHelper finalreporthelper = new ReportHelper();

		ArrayList < ReportHelper > reportsList1 = new ArrayList < ReportHelper > ();  //delete
		ArrayList < String > headersList1 = new ArrayList < String > ();			//delete
		ReportHelper finalreporthelper1 = new ReportHelper();                        //delete

		ArrayList < ReportHelper > reportsList2 = new ArrayList < ReportHelper > ();  //delete
		ArrayList < String > headersList2 = new ArrayList < String > ();			//delete

		ArrayList < Object > finlist = new ArrayList < Object > ();
		try {
			headersList.add(cf.getLabelFromDB("SLNO", language));
			headersList.add(cf.getLabelFromDB("Vehicle_No", language));
			headersList.add(cf.getLabelFromDB("Billing_Start_Date", language));
			headersList.add(cf.getLabelFromDB("Billing_End_Date", language));
			headersList.add(cf.getLabelFromDB("GPS_Vehicle_Days", language));
			headersList.add(cf.getLabelFromDB("NON_GPS_Vehicle_Days", language));
			headersList.add(cf.getLabelFromDB("Vehicle_Id", language));
			headersList.add(cf.getLabelFromDB("Transporter", language));
			headersList.add(cf.getLabelFromDB("Vehicle_Model", language));
			headersList.add(cf.getLabelFromDB("IMEI_No", language));
			headersList.add(cf.getLabelFromDB("Installation_Date", language));
			headersList.add(cf.getLabelFromDB("HID_Card_Reader_Auto_Grade_Model", language));
			headersList.add(cf.getLabelFromDB("EAM_With_Panic_Button_Installed", language));
			headersList.add(cf.getLabelFromDB("Facility", language));
			headersList.add(cf.getLabelFromDB("GPS_Installed", language));
			headersList.add(cf.getLabelFromDB("No_Of_Days_Active", language));
			headersList.add(cf.getLabelFromDB("GPS_Per_Day_Price", language));
			headersList.add(cf.getLabelFromDB("FMS_Per_Day_Price", language));
			headersList.add(cf.getLabelFromDB("FDAS_Per_Day_Price", language));
			headersList.add(cf.getLabelFromDB("Total_Price", language));

			
			headersList1.add(cf.getLabelFromDB("Vertical_Name", language));			//delete
			headersList1.add(cf.getLabelFromDB("Vehicle_Count", language));			//delete
			headersList1.add(cf.getLabelFromDB("Amount", language));					//delete

			DecimalFormat df = new DecimalFormat("##.##");
			con = DBConnection.getConnectionToDB("AMS");

			pstmt = con.prepareStatement(BillingStatements.GET_BILLING_MATRIX_REPORT);
			pstmt.setString(1, invoiceNo);
			pstmt.setInt(2, ltspId);
			pstmt.setString(3, insertedDate);
			pstmt.setString(4, insertedDate);
			pstmt.setString(5, invoiceNo);
			pstmt.setInt(6, ltspId);
			pstmt.setString(7, insertedDate);
			pstmt.setString(8, insertedDate);
			rs = pstmt.executeQuery();

			pstmt1 = con.prepareStatement(BillingStatements.GET_VERTICAL_WIZE_BILLING_DETAILS); 			//delete
			pstmt1.setInt(1, ltspId);
			pstmt1.setString(2, invoiceNo);
			pstmt1.setString(3, insertedDate);
			pstmt1.setString(4, insertedDate);
			pstmt1.setInt(5, ltspId);
			pstmt1.setString(6, invoiceNo);
			pstmt1.setString(7, insertedDate);
			pstmt1.setString(8, insertedDate);
			pstmt1.setInt(9, ltspId);
			pstmt1.setString(10, invoiceNo);
			pstmt1.setString(11, insertedDate);
			pstmt1.setString(12, insertedDate);
			pstmt1.setInt(13, ltspId);
			pstmt1.setString(14, invoiceNo);
			pstmt1.setString(15, insertedDate);
			pstmt1.setString(16, insertedDate);
			rs1 = pstmt1.executeQuery();	

			
			int count = 0;

			//delete
			while (rs1.next()) {
				ArrayList < Object > informationList1 = new ArrayList < Object > ();
				ReportHelper reporthelper1 = new ReportHelper();
				count++;
				
				if(rs1.getString("VerticalName")=="zzzzz" || rs1.getString("VerticalName").contains("zzzzz"))
				{
					informationList1.add("");
					informationList1.add("Total");
				}else
				{
					informationList1.add(count);
					informationList1.add(rs1.getString("VerticalName"));
				}
				
				if(rs1.getString("Vehicalcount") == null || rs1.getString("Vehicalcount").equals(""))
				{
					informationList1.add("0");
				}else
				{
					informationList1.add(rs1.getString("Vehicalcount"));
				}
				
				float Amount1 = rs1.getFloat("Amount");
				if (rs1.getString("Amount") == null || rs1.getString("Amount").equals("")) {
					informationList1.add("0");
				} else {
					informationList1.add(df.format(Amount1));
				}
				
				reporthelper1.setInformationList1(informationList1);
				reportsList1.add(reporthelper1);
			}
			//delete
			while (rs.next()) {
				JsonObject = new JSONObject();
				ArrayList < Object > informationList = new ArrayList < Object > ();
				ReportHelper reporthelper = new ReportHelper();
				count++;
				informationList.add(count);
				JsonObject.put("slnoIndex", count);
				if (rs.getString("VehicleNo") == null || rs.getString("VehicleNo").equals("")) {
					JsonObject.put("vehicleNumberDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("vehicleNumberDataIndex", rs.getString("VehicleNo"));
					informationList.add(rs.getString("VehicleNo"));
				}

				if (rs.getString("StartDate") == null || rs.getString("StartDate").equals("") || rs.getString("StartDate").contains("1900")) {
					JsonObject.put("billingStartDateDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("billingStartDateDataIndex", rs.getString("StartDate"));
					informationList.add(rs.getString("StartDate"));
				}

				if (rs.getString("EndDate") == null || rs.getString("EndDate").equals("") || rs.getString("EndDate").contains("1900")) {
					JsonObject.put("billingEndDateDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("billingEndDateDataIndex", rs.getString("EndDate"));
					informationList.add(rs.getString("EndDate"));
				}

				if (rs.getString("gpsvehicledays") == null || rs.getString("gpsvehicledays").equals("")) {
					JsonObject.put("gpsVehicleDaysDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("gpsVehicleDaysDataIndex", rs.getString("gpsvehicledays"));
					informationList.add(rs.getString("gpsvehicledays"));
				}

				if (rs.getString("NongpsVehicleDays") == null || rs.getString("NongpsVehicleDays").equals("")) {
					JsonObject.put("nonGpsVehicleDaysDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("nonGpsVehicleDaysDataIndex", rs.getString("NongpsVehicleDays"));
					informationList.add(rs.getString("NongpsVehicleDays"));
				}

				if (rs.getString("VehicleId") == null || rs.getString("VehicleId").equals("")) {
					JsonObject.put("vehicleIdDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("vehicleIdDataIndex", rs.getString("VehicleId"));
					informationList.add(rs.getString("VehicleId"));
				}

				if (rs.getString("GroupName") == null || rs.getString("GroupName").equals("")) {
					JsonObject.put("transpoterDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("transpoterDataIndex", rs.getString("GroupName"));
					informationList.add(rs.getString("GroupName"));
				}

				if (rs.getString("ModelName") == null || rs.getString("ModelName").equals("")) {
					JsonObject.put("vehicleModelDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("vehicleModelDataIndex", rs.getString("ModelName"));
					informationList.add(rs.getString("ModelName"));
				}

				if (rs.getString("UnitNo") == null || rs.getString("UnitNo").equals("")) {
					JsonObject.put("imeiNoDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("imeiNoDataIndex", rs.getString("UnitNo"));
					informationList.add(rs.getString("UnitNo"));
				}

				if (rs.getString("installed") == null || rs.getString("installed").equals("") || rs.getString("installed").contains("1900")) {
					JsonObject.put("installationDateDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("installationDateDataIndex", rs.getString("installed"));
					informationList.add(rs.getString("installed"));
				}

				if (rs.getString("hid") == null || rs.getString("hid").equals("")) {
					JsonObject.put("hidCardReaderAutoGradeModelDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("hidCardReaderAutoGradeModelDataIndex", rs.getString("hid"));
					informationList.add(rs.getString("hid"));
				}

				if (rs.getString("eam") == null || rs.getString("eam").equals("")) {
					JsonObject.put("eamWithPanicButtonInstalledDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("eamWithPanicButtonInstalledDataIndex", rs.getString("eam"));
					informationList.add(rs.getString("eam"));
				}

				if (rs.getString("ClientName") == null || rs.getString("ClientName").equals("")) {
					JsonObject.put("facilityDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("facilityDataIndex", rs.getString("ClientName"));
					informationList.add(rs.getString("ClientName"));
				}

				if (rs.getString("GpsInstalled") == null || rs.getString("GpsInstalled").equals("")) {
					JsonObject.put("gpsInstalledDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("gpsInstalledDataIndex", rs.getString("GpsInstalled"));
					informationList.add(rs.getString("GpsInstalled"));
				}

				if (rs.getString("noOfDays") == null || rs.getString("noOfDays").equals("")) {
					JsonObject.put("NoOfDaysActiveDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("NoOfDaysActiveDataIndex", rs.getString("noOfDays"));
					informationList.add(rs.getString("noOfDays"));
				}

				float PerDayCost1 = rs.getFloat("PerDayCost");
				if (rs.getString("PerDayCost") == null || rs.getString("PerDayCost").equals("")) {
					JsonObject.put("gpsPerDaypriceDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("gpsPerDaypriceDataIndex", df.format(PerDayCost1));
					informationList.add(df.format(PerDayCost1));
				}

				float NongpsPerDayCost1 = rs.getFloat("NongpsPerDayCost");
				if (rs.getString("NongpsPerDayCost") == null || rs.getString("NongpsPerDayCost").equals("")) {
					JsonObject.put("fmsPerDaypriceDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("fmsPerDaypriceDataIndex",  df.format(NongpsPerDayCost1));
					informationList.add( df.format(NongpsPerDayCost1));
				}

				float NongpsPerDayCost2 = rs.getFloat("NongpsPerDayCost");
				if (rs.getString("NongpsPerDayCost") == null || rs.getString("NongpsPerDayCost").equals("")) {
					JsonObject.put("fdasDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("fdasDataIndex", df.format(NongpsPerDayCost2));
					informationList.add(df.format(NongpsPerDayCost2));
				}

				float totalCost = rs.getFloat("TotalCost");
				if (rs.getString("TotalCost") == null || rs.getString("TotalCost").equals("")) {
					JsonObject.put("totalpriceDataIndex", "");
					informationList.add("");
				} else {
					JsonObject.put("totalpriceDataIndex", df.format(totalCost));
					informationList.add(df.format(totalCost));
				}

				JsonArray.put(JsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);

			finalreporthelper.setReportsList1(reportsList1);			//delete
			finalreporthelper.setHeadersList1(headersList1);			//delete
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);


		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return finlist;
	}
	
	public JSONArray getInvoiceNumber(String ltspId, String billMonth, String billYear) {
	    JSONArray JsonArray = null;
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    Calendar cal = Calendar.getInstance();
		int CrntYear = cal.get(Calendar.YEAR);
		int PrevYear = cal.get(Calendar.YEAR)-1;
		String PrevYear1 = String.valueOf(PrevYear);
	    try {
	        JsonArray = new JSONArray();
	        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
	        
	        if(billYear.equals(PrevYear1) && (billMonth.equals("10") || billMonth.equals("11") || billMonth.equals("12")))
	        {
	        	pstmt = con.prepareStatement(BillingStatements.GET_INVOICE_NUMBER);
	 	        pstmt.setString(1, ltspId);
	 	        pstmt.setString(2, billMonth);
	 	        pstmt.setString(3, billYear);
	 	       rs = pstmt.executeQuery();
	 	        
	        }else if(!(billYear.equals(PrevYear1)))
	        {
	        pstmt = con.prepareStatement(BillingStatements.GET_INVOICE_NUMBER);
	        pstmt.setString(1, ltspId);
	        pstmt.setString(2, billMonth);
	        pstmt.setString(3, billYear);
	        rs = pstmt.executeQuery();
	        }
	        if (rs != null) {
	        	while (rs.next()) {
		            JsonObject = new JSONObject();
		            JsonObject.put("invoiceId", rs.getInt("INVOICE_NO"));
		            JsonArray.put(JsonObject);
		        }
				
			}
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}
	
	
	public JSONArray getMonth() {
	    JSONArray JsonArray = null;
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    int month1 = 0;
	    int month2 = 0;
	    int month3 = 0;
	    String strArray[] = {
	        "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
	    };
	    try {
	        JsonArray = new JSONArray();
	        Calendar cal = Calendar.getInstance();
	        int CrntMonth = cal.get(Calendar.MONTH);
	        int CrntDate = cal.get(Calendar.DATE);
	        if (CrntDate <= 20) {
	            if (CrntMonth == 0) {
	                month1 = 11;  //dec
	                month2 = 10;  //nov
	                month3 = 9;   //oct
	            } else if (CrntMonth == 1) {
	                month1 = 0;   //jan
	                month2 = 11;  //dec
	                month3 = 10;  //nov
	            } else if (CrntMonth == 2) {
	                month1 = 11;  //dec
	                month2 = 1;   //feb
	                month3 = 0;   //jan
	            } else {
	                month1 = (CrntMonth - 1);
	                month2 = (month1 - 1);
	                month3 = (month2 - 1);
	            }
	        } else {
	            if (CrntMonth == 0) {
	                month1 = 0;
	                month2 = 11;
	                month3 = 10;
	            } else if (CrntMonth == 1) {
	                month1 = 1;
	                month2 = 0;
	                month3 = 11;
	            } else {
	                month1 = (CrntMonth);
	                month2 = (month1 - 1);
	                month3 = (month2 - 1);
	            }
	        }
	        String beforeMonths1 = strArray[month1];
	        String beforeMonths2 = strArray[month2];
	        String beforeMonths3 = strArray[month3];
	        JsonObject = new JSONObject();
	        JsonObject.put("monthName", beforeMonths1);
	        JsonArray.put(JsonObject);
	        JsonObject = new JSONObject();
	        JsonObject.put("monthName", beforeMonths2);
	        JsonArray.put(JsonObject);
	        JsonObject = new JSONObject();
	        JsonObject.put("monthName", beforeMonths3);
	        JsonArray.put(JsonObject);
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}
	public JSONArray getGroup(int systemId,int custId){
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			
			con=DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt=con.prepareStatement(BillingStatements.GET_GROUP);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, custId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("groupId", rs.getInt("ID"));
				jsonObject.put("groupName", rs.getString("BILLING_GROUP_NAME"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			System.out.println("Error in getGroup "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	}

	public String saveGroupDetails(String custId, String sysId,String groupAddress,String groupName) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message="";
		try {
			con = DBConnection.getConnectionToDB("AMS");
	    	pstmt = con.prepareStatement(BillingStatements.INSERT_GROUP_DETAILS);
	     	pstmt.setString(1, sysId);
			pstmt.setString(2, custId);
			pstmt.setString(3, groupAddress);
			pstmt.setString(4, groupName);
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "Saved Successfully";
			}else{
				message="Error in Saving";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}
	public ArrayList < Object > getDataForNonAssociation(int customerId, int systemId, int groupId) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    int count=0;
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt=con.prepareStatement(BillingStatements.GET_DATA_FOR_NON_ASSOCIATION);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        pstmt.setInt(3, systemId);
	        pstmt.setInt(4, customerId);
	       // pstmt.setInt(5, groupId);
	        rs=pstmt.executeQuery();
	        while(rs.next()){
	        	JsonObject=new JSONObject();
	        	count++;
	        	JsonObject.put("slnoIndex",count);
	        	JsonObject.put("regNoDataIndex", rs.getString("REGISTRATION_NUMBER"));
	        	JsonObject.put("groupNameDataIndex", rs.getString("GROUP_NAME"));
	        	JsonObject.put("groupIdDataIndex", rs.getInt("GROUP_ID"));
	        	JsonArray.put(JsonObject);
	        }
	        finlist.add(JsonArray);
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return finlist;
	}
	
	public ArrayList < Object > getDataForAssociation(int customerId, int systemId, int groupId) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    int count=0;
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt=con.prepareStatement(BillingStatements.GET_DATA_FOR_ASSOCIATION);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, customerId);
	        pstmt.setInt(3, groupId);
	        rs=pstmt.executeQuery();
	        while(rs.next()){
	        	JsonObject=new JSONObject();
	        	count++;
	        	JsonObject.put("slnoIndex2",count);
	        	JsonObject.put("regNoDataIndex2", rs.getString("REGISTRATION_NO"));
	        	JsonObject.put("groupNameDataIndex2", rs.getString("GROUP_NAME"));
	        	JsonArray.put(JsonObject);
	        }
	        finlist.add(JsonArray);
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return finlist;
	}
	
	public String associateGroup(int customerId, int systemId, int groupId, JSONArray js) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        for (int i = 0; i < js.length(); i++) {
	            JSONObject obj = js.getJSONObject(i);
	            String regNo = obj.getString("regNoDataIndex");
	            pstmt = con.prepareStatement(BillingStatements.CHECK_IF_PRESENT);
	            pstmt.setInt(1, systemId);
	            pstmt.setInt(2, customerId);
	            pstmt.setInt(3, groupId);
	            pstmt.setString(4, regNo);
	            rs = pstmt.executeQuery();
	            if (!rs.next()) {
	                pstmt = con.prepareStatement(BillingStatements.INSERT_INTO_VEHICLE_GROUP_ASSOCIATION);
	                pstmt.setInt(1, groupId);
	                pstmt.setInt(2, systemId);
	                pstmt.setInt(3, customerId);
	                pstmt.setString(4, regNo);
	                pstmt.executeUpdate();
	            }
	        }
	        message = "Associated Successfully.";
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return message;
	}
	public String dissociateGroup(int customerId, int systemId, int groupId, JSONArray js) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    String message = "";
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        for (int i = 0; i < js.length(); i++) {
	            JSONObject obj = js.getJSONObject(i);
	            String regNo = obj.getString("regNoDataIndex2");
	            pstmt = con.prepareStatement(BillingStatements.MOVE_DATA_TO_VEHICLE_GROUP_HISTORY);
	            pstmt.setInt(1, systemId);
	            pstmt.setInt(2, customerId);
	            pstmt.setInt(3, groupId);
	            pstmt.setString(4, regNo);
	            int inserted =pstmt.executeUpdate();
	            if(inserted > 0)
	            {
		            pstmt = con.prepareStatement(BillingStatements.DELETE_FROM_VEHICLE_GROUP);
		            pstmt.setInt(1, systemId);
		            pstmt.setInt(2, customerId);
		            pstmt.setInt(3, groupId);
		            pstmt.setString(4, regNo);
		            pstmt.executeUpdate();
	            }
	        }
	        message = "Disassociated Successfully.";
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(null, pstmt, null);
	    }
	    return message;
	}



	}
