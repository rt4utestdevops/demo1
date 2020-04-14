package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;
import t4u.statements.CrewMasterStatements;
import t4u.statements.TripCreationStatements;



public class CrewMasterFunctions {
    SimpleDateFormat ddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
    SimpleDateFormat sdfddmmyy = new SimpleDateFormat("dd-MM-yyyy");
    CommonFunctions cf = new CommonFunctions();

    public String updatePersonalInformation(String firstName, String lastName, String address, String permanentAddress, String city, String otherCity, String state, String country, String telephoneNo, String mobileNo, String dateOfBirth, String gender, String nationality, String maritialStatus,
        int systemId, int customerId, int userId, int offset, int DriverId,String passportNumber,String expiryDate) {
        Connection con = null;
        PreparedStatement pstmt = null;
        String message = "";
        ResultSet rsSelected=null;
        try {
            con = DBConnection.getConnectionToDB("AMS");
            pstmt = con.prepareStatement(CrewMasterStatements.UPDATE_PERSONAL_INFORMATION);
            pstmt.setString(1, firstName.toUpperCase());
            pstmt.setString(2, lastName);
            pstmt.setString(3, address);
            pstmt.setString(4, permanentAddress);
            pstmt.setInt(5, 0);
            pstmt.setString(6, otherCity);
            pstmt.setString(7, state);
            pstmt.setString(8, country);
            pstmt.setString(9, telephoneNo);
            pstmt.setString(10, mobileNo);
            pstmt.setInt(11, offset);
            pstmt.setString(12, dateOfBirth);
            pstmt.setString(13, gender);
            pstmt.setString(14, nationality);
            pstmt.setString(15, maritialStatus);
            pstmt.setInt(16, userId);
            pstmt.setString(17, passportNumber);
            pstmt.setInt(18, offset);
            pstmt.setString(19, expiryDate);
            pstmt.setInt(20, DriverId);
            pstmt.setInt(21, systemId);
            pstmt.setInt(22, customerId);

            int inserted = pstmt.executeUpdate();
            if (inserted > 0) {
            	pstmt=con.prepareStatement(CrewMasterStatements.SELECT_REG_NO);
 				pstmt.setInt(1, systemId);				
 				pstmt.setInt(2,DriverId);
 				rsSelected=pstmt.executeQuery(); 
            	 
 				if(rsSelected.next())
				{
 					pstmt = con.prepareStatement(CrewMasterStatements.UPDATE_GPS_DATA_HISTORY_LATEST);
					pstmt.setString(1, firstName);	
					pstmt.setString(2, mobileNo);
					pstmt.setString(3, rsSelected.getString("REGISTRATION_NO"));
					pstmt.setInt(4, systemId);
					pstmt.setInt(5,customerId);
					pstmt.executeUpdate();
				}
            	
                message = "Updated Successfully";
            } else {
                message = "error";

            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rsSelected);
        }
        return message;
    }


    public String updateEmployeeInformation(String employmentType, String employmentId, String client, String dateOfJoining, String dateOfLeaving, String bloodGroup, String groupName, String activeStatus, String remarks, String governmentOrResidenceId, String governmentOrResidenceIdExpiryDate, String rfidCode,
        int systemId, int driverId, int customerId, int userId, int offset,String workCompensationId,String workCompensationExpiryDate) {
        Connection con = null;
        PreparedStatement pstmt = null;
        String message = "";
        try {
            con = DBConnection.getConnectionToDB("AMS");

            int type = 0;
//            if (employmentType.equalsIgnoreCase("DRIVER")) {
//                type = 1;
//            } else if (employmentType.equalsIgnoreCase("GUNMAN")) {
//                type = 2;
//            } else if (employmentType.equalsIgnoreCase("CLEANER")) {
//                type = 3;
//            } else if (employmentType.equalsIgnoreCase("OPERATOR")) {
//                type = 4;
//            } else if (employmentType.equalsIgnoreCase("ESCORTS")) {
//                type = 5;
//            } else if (employmentType.equalsIgnoreCase("SITE ENGINEERS")) {
//                type = 6;
//            } else if (employmentType.equalsIgnoreCase("MANAGERS")) {
//                type = 7;
//            }
//            
//            else {
                type = Integer.parseInt(employmentType);
            
            pstmt = con.prepareStatement(CrewMasterStatements.UPDATE_EMPLOYMENT_INFORMATION);
            pstmt.setInt(1, type);
            pstmt.setString(2, employmentId);
            pstmt.setInt(3, offset);
            pstmt.setString(4, dateOfJoining);
            pstmt.setInt(5, offset);
            pstmt.setString(6, dateOfLeaving);
            pstmt.setString(7, bloodGroup.trim());
            pstmt.setString(8, groupName);
            pstmt.setString(9, activeStatus);
            pstmt.setString(10, remarks);
            pstmt.setString(11, governmentOrResidenceId);
            pstmt.setInt(12, offset);
            pstmt.setString(13, governmentOrResidenceIdExpiryDate);
            pstmt.setString(14, rfidCode);
            pstmt.setInt(15, userId);
            pstmt.setString(16, workCompensationId);
            pstmt.setInt(17, offset);
            pstmt.setString(18, workCompensationExpiryDate);
            pstmt.setInt(19, systemId);
            pstmt.setInt(20, customerId);
            pstmt.setInt(21, driverId);
            int updated = pstmt.executeUpdate();
            if (updated > 0) {
               
                if (activeStatus.equalsIgnoreCase("Inactive")) {
                    disAssociateDriversToVehicleWhenIncative(driverId, systemId);
                    
					pstmt = con.prepareStatement(CrewMasterStatements.DELETE_FROM_STATUTORY);
					pstmt.setInt(1, driverId);
					pstmt.setInt(2, systemId);
					pstmt.setInt(3, customerId);
					int deletequery = pstmt.executeUpdate();
                }
                message = "Updated Successfully";
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, null);
        }
        return message;
    }


    public void disAssociateDriversToVehicleWhenIncative(int driverId, int systemId) {

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String vehicleNo = "";
        try {
            con = DBConnection.getConnectionToDB("AMS");
            pstmt = con.prepareStatement(CrewMasterStatements.SELECT_DRIVER_LIST_EXISTED);
            pstmt.setInt(1, systemId);
            pstmt.setInt(2, driverId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                vehicleNo = rs.getString("REGISTRATION_NO");
                pstmt = con.prepareStatement(CrewMasterStatements.INSERT_VDASSOCIATION_HISTORY);
                pstmt.setString(1, vehicleNo);
                pstmt.setString(2, rs.getString("DRIVER_ID"));
                pstmt.setString(3, rs.getString("SYSTEM_ID"));
                pstmt.setString(4, rs.getString("DATE_TIME"));
                int updateHistory = pstmt.executeUpdate();

                if (updateHistory > 0) {
                    pstmt = con.prepareStatement(CrewMasterStatements.DELETE_VDASSOCIATION_DRIVER);
                    pstmt.setString(1, vehicleNo);
                    pstmt.setInt(2, driverId);
                    int deleted = pstmt.executeUpdate();
                    if (deleted > 0) {
                        //	message = " Driver is Disassociated from the Vehicle Successfully.";
                        updateDriverNamesListInLiveTable(vehicleNo, systemId);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
    }

    public void updateDriverNamesListInLiveTable(String vehicleNo, int systemId) {
        String message = "";
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer sbuf = new StringBuffer();
        List driverNamesList = null;
        String name = "";
        String number = "";
        String Driver_id = null;

        try {
            con = DBConnection.getConnectionToDB("AMS");
            driverNamesList = getDriverNamesForVehicleandSystemId(vehicleNo,
                String.valueOf(systemId));
            for (int i = 0; i < driverNamesList.size(); i++) {
                name = driverNamesList.get(0).toString();
                number = driverNamesList.get(1).toString();
                Driver_id = driverNamesList.get(2).toString();
                if (number != null && !number.equals("")) {
                    name = name + "(" + number + ")";
                } else {
                    name = name;
                }
            }
            pstmt = con
                .prepareStatement(CrewMasterStatements.UPDATE_DRIVER_NAME_AND_ID);
            pstmt.setString(1, name);
            pstmt.setString(2, Driver_id);
            pstmt.setString(3, vehicleNo);
            int rec = pstmt.executeUpdate();
            if (rec > 0) {
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, null);
        }

    }


    public List getDriverNamesForVehicleandSystemId(String registrationNo,
        String SystemId) {
        List drivers = new ArrayList < String > ();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnectionToDB("AMS");
            pstmt = con.prepareStatement(CrewMasterStatements.GET_DRIVER_NAMES_FOR_VEHICLE_AND_SYSTEM);
            pstmt.setString(1, registrationNo);
            pstmt.setString(2, SystemId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                drivers.add(rs.getString("Fullname"));
                drivers.add(rs.getString("Mobile"));
                drivers.add(rs.getString("Driver_id"));

            }
        } catch (Exception e) {
        	 e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
        return drivers;
    }




    public String updateInsuranceInformation(String medicalInsuranceNo, String medicalInsuranceCompany, String medicalInsuranceExpiryDate,
        int systemId, int driverId, int customerId, int userId, int offset) {
        Connection con = null;
        PreparedStatement pstmt = null;
        String message = "";
        try {
            con = DBConnection.getConnectionToDB("AMS");
            pstmt = con.prepareStatement(CrewMasterStatements.UPDATE_INSURANCE_INFORMATION);
            pstmt.setString(1, medicalInsuranceNo);
            pstmt.setString(2, medicalInsuranceCompany);
            pstmt.setInt(3, offset);
            pstmt.setString(4, medicalInsuranceExpiryDate);
            pstmt.setInt(5, userId);
            pstmt.setInt(6, systemId);
            pstmt.setInt(7, customerId);
            pstmt.setInt(8, driverId);

            int updated = pstmt.executeUpdate();
            if (updated > 0) {
                message = "Updated Successfully";
            } else {
                message = "error";
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, null);
        }
        return message;
    }



    public String updateDriverInformation(String licenceNo, String licencePlace, String licenceIssueDate, String licenceRenewedDate, String licenceExpiryDate,
        int systemId, int driverId, int customerId, int userId, int offset,String preferedCustomerNmaes) {
        Connection con = null;
        PreparedStatement pstmt = null;
        String message = "";
        try {
            con = DBConnection.getConnectionToDB("AMS");
            pstmt = con.prepareStatement(CrewMasterStatements.UPDATE_DRIVER_INFORMATION);
            pstmt.setString(1, licenceNo);
            pstmt.setString(2, licencePlace);
            pstmt.setInt(3, offset);
            pstmt.setString(4, licenceIssueDate);
            pstmt.setInt(5, offset);
            pstmt.setString(6, licenceRenewedDate);
            pstmt.setInt(7, offset);
            pstmt.setString(8, licenceExpiryDate);
            pstmt.setString(9, preferedCustomerNmaes);           
            pstmt.setInt(10, userId);
            pstmt.setInt(11, customerId);
            pstmt.setInt(12, systemId);
            pstmt.setInt(13, driverId);
            int updated = pstmt.executeUpdate();
            if (updated > 0) {
                message = "Updated Successfully";
            } else {}
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, null);
        }
        return message;
    }


    public String updateGunMenInformation(String gunlicenceNo, String gunlicenceType, String gunlicenceIssueDate, String gunlicenceIssuePlace, String gunlicenceExpiryDate,
        int systemId, int driverId, int customerId, int userId, int offset) {
        Connection con = null;
        PreparedStatement pstmt = null;
        String message = "";
        try {
            con = DBConnection.getConnectionToDB("AMS");
            pstmt = con.prepareStatement(CrewMasterStatements.UPDATE_GUNMEN_INFORMATION);
            pstmt.setString(1, gunlicenceNo);
            pstmt.setString(2, gunlicenceType);
            pstmt.setInt(3, offset);
            pstmt.setString(4, gunlicenceIssueDate);
            pstmt.setString(5, gunlicenceIssuePlace);
            pstmt.setInt(6, offset);
            pstmt.setString(7, gunlicenceExpiryDate);
            pstmt.setInt(8, userId);
            pstmt.setInt(9, customerId);
            pstmt.setInt(10, systemId);
            pstmt.setInt(11, driverId);
            int updated = pstmt.executeUpdate();
            if (updated > 0) {
                message = "Updated Successfully";
            } else {}
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, null);
        }
        return message;
    }

    public JSONArray getDriverNames(int systemId, int customerId, int offset) {
        JSONArray JsonArray = null;
        JSONObject JsonObject = null;

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        int count = 0;
        String Type = "";
        String FirstType = "";

        try {
            JsonArray = new JSONArray();

            con = DBConnection.getConnectionToDB("AMS");

            pstmt = con.prepareStatement(CrewMasterStatements.GET_DRIVER_NAMES);
            pstmt.setInt(1, offset);
            pstmt.setInt(2, offset);
            pstmt.setInt(3, offset);
            pstmt.setInt(4, offset);
            pstmt.setInt(5, offset);
            pstmt.setInt(6, offset);
            pstmt.setInt(7, offset);
            pstmt.setInt(8, offset);
            pstmt.setInt(9, offset);
            pstmt.setInt(10, offset);
            pstmt.setInt(11, customerId);
            pstmt.setInt(12, systemId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                count++;
                JsonObject = new JSONObject();
                JsonObject.put("slnoIndex", count);
                JsonObject.put("driverNameDataIndex", rs.getString("FULLNAME").toUpperCase());
                JsonObject.put("employeeNameDataIndex", rs.getString("Fullname").toUpperCase());

//                if (rs.getInt("EMPLOYMENT_TYPE") == 1) {
//                    FirstType = "DRIVER";
//                } else if (rs.getInt("EMPLOYMENT_TYPE") == 2) {
//                    FirstType = "GUNMAN";
//                } else if (rs.getInt("EMPLOYMENT_TYPE") == 3) {
//                    FirstType = "CLEANER";
//                } else if (rs.getInt("EMPLOYMENT_TYPE") == 4) {
//                    FirstType = "OPERATOR";
//                } else if (rs.getInt("EMPLOYMENT_TYPE") == 5) {
//                    FirstType = "ESCORTS";
//                }  else if (rs.getInt("EMPLOYMENT_TYPE") == 6) {
//                    FirstType = "SITE ENGINEERS";
//                }  else if (rs.getInt("EMPLOYMENT_TYPE") == 7) {
//                    FirstType = "MANAGERS";
//                } else 
//                {
//                	 FirstType = "";
//                }
                JsonObject.put("employeeTypeDataIndex",rs.getString("EMPLOYMENT_VALUE"));
                JsonObject.put("employeeTypeIDDataIndex", rs.getInt("EMPLOYMENT_TYPE"));
                JsonObject.put("DriverIdDataIndex", rs.getInt("Driver_id"));
                JsonObject.put("lastNameDataIndex", rs.getString("LAST_NAME"));
                if(rs.getString("PresentAddress")!=null && rs.getString("PresentAddress")!="")
                {
                JsonObject.put("presentAddressDataIndex", rs.getString("PresentAddress"));
                }else{
                	JsonObject.put("presentAddressDataIndex", "");
                 }
                	
                if(rs.getString("PermanentAddress")!=null && rs.getString("PermanentAddress")!="")
                {
                	JsonObject.put("permanentAddressDataIndex", rs.getString("PermanentAddress"));
                }else{
                	JsonObject.put("permanentAddressDataIndex", "");
                 }
                
               JsonObject.put("cityDataIndex", rs.getString("CITY_NEW"));
                JsonObject.put("otherCityDataIndex", rs.getString("OtherCity"));
                JsonObject.put("stateDataIndex", rs.getString("STATE_NAME"));
                JsonObject.put("countryDataIndex", rs.getString("COUNTRY_NAME"));
                JsonObject.put("telephoneDataIndex", rs.getString("Telephone"));
                JsonObject.put("mobileDataIndex", rs.getString("Mobile"));
                JsonObject.put("stateIdDataIndex", rs.getInt("STATE_ID"));
                JsonObject.put("countryIdDataIndex", rs.getInt("COUNTRY_ID"));

                if (rs.getString("Dob") == null || rs.getString("Dob").equals("") || rs.getString("Dob").contains("1900")) {
                    JsonObject.put("dateOfBirthDataIndex", "");

                } else {
                    JsonObject.put("dateOfBirthDataIndex", sdfddmmyy.format(rs.getTimestamp("Dob")));
                }

                JsonObject.put("genderDataIndex", rs.getString("Gender"));
                JsonObject.put("nationalityDataIndex", rs.getString("Nationality"));
                JsonObject.put("maritialDataIndex", rs.getString("MaritalStatus"));


//                if (rs.getInt("EMPLOYMENT_TYPE") == 1) {
//                    Type = "DRIVER";
//                } else if (rs.getInt("EMPLOYMENT_TYPE") == 2) {
//                    Type = "GUNMAN";
//                } else if (rs.getInt("EMPLOYMENT_TYPE") == 3) {
//                    Type = "CLEANER";
//                } else if (rs.getInt("EMPLOYMENT_TYPE") == 4) {
//                    Type = "OPERATOR";
//                } else if (rs.getInt("EMPLOYMENT_TYPE") == 5) {
//                    Type = "ESCORTS";
//                } else if (rs.getInt("EMPLOYMENT_TYPE") == 6) {
//                    Type = "SITE ENGINEERS";
//                } else if (rs.getInt("EMPLOYMENT_TYPE") == 7) {
//                    Type = "MANAGERS";
//                } else
//                {
//                    Type = "";
//                }

                JsonObject.put("employmentTypeDataIndex", rs.getString("EMPLOYMENT_VALUE"));

                //JsonObject.put("employmentTypeDataIndex", rs.getString("EMPLOYMENT_TYPE").toUpperCase());
                JsonObject.put("employmentIdDataIndex", rs.getString("EmployeeID"));

                if (rs.getString("Date_of_join") == null || rs.getString("Date_of_join").equals("") || rs.getString("Date_of_join").contains("1900")) {
                    JsonObject.put("dateOfJoiningDataIndex", "");

                } else {
                    JsonObject.put("dateOfJoiningDataIndex", sdfddmmyy.format(rs.getTimestamp("Date_of_join")));
                }

                if (rs.getString("Date_of_leaving") == null || rs.getString("Date_of_leaving").equals("") || rs.getString("Date_of_leaving").contains("1900")) {
                    JsonObject.put("dateOfLeavingDataIndex", "");

                } else {
                    JsonObject.put("dateOfLeavingDataIndex", sdfddmmyy.format(rs.getTimestamp("Date_of_leaving")));
                }

                JsonObject.put("bloodGroupDataIndex", rs.getString("Blood").trim());
                JsonObject.put("groupNameDataIndex", rs.getString("GROUP_NAME"));
                JsonObject.put("activeStatusDataIndex", rs.getString("Race"));
                
                if(rs.getString("Remarks")!=null && rs.getString("Remarks")!="")
                {
                	JsonObject.put("remarksDataIndex", rs.getString("Remarks"));
                }else{
                	JsonObject.put("remarksDataIndex", "");
                 }
                
                
                //JsonObject.put("remarksDataIndex", rs.getString("Remarks"));
                JsonObject.put("governmentOrResidenceIdDataIndex", rs.getString("GOVERMENT_RESIDENCE_ID"));
                JsonObject.put("groupIdDataIndex", rs.getString("GROUP_ID"));


                if (rs.getString("GOVERMENT_RESIDENCE_EXP_DATE") == null || rs.getString("GOVERMENT_RESIDENCE_EXP_DATE").equals("") || rs.getString("GOVERMENT_RESIDENCE_EXP_DATE").contains("1900")) {
                    JsonObject.put("governmentOrResidenceIdExpiryDateDataIndex", "");

                } else {
                    JsonObject.put("governmentOrResidenceIdExpiryDateDataIndex", sdfddmmyy.format(rs.getTimestamp("GOVERMENT_RESIDENCE_EXP_DATE")));
                }

                JsonObject.put("rfidCodeDataIndex", rs.getString("DriverCodeFromUnit"));

                JsonObject.put("medicalInsuranceDataIndex", rs.getString("MEDICAL_INSURANCE_NUMBER"));
                JsonObject.put("medicalInsuranceCompanyDataIndex", rs.getString("MEDICAL_INSURANCE_COMPANY"));
                JsonObject.put("medicalInsuranceExpiryDateDataIndex", rs.getString("MEDICAL_INSURANCE_EXP_DATE"));
                if (rs.getString("MEDICAL_INSURANCE_EXP_DATE") == null || rs.getString("MEDICAL_INSURANCE_EXP_DATE").equals("") || rs.getString("MEDICAL_INSURANCE_EXP_DATE").contains("1900")) {
                    JsonObject.put("medicalInsuranceExpiryDateDataIndex", "");

                } else {
                    JsonObject.put("medicalInsuranceExpiryDateDataIndex", sdfddmmyy.format(rs.getTimestamp("MEDICAL_INSURANCE_EXP_DATE")));
                }

                JsonObject.put("licenseNoDataIndex", rs.getString("Lic_no"));
                JsonObject.put("licencePlaceDataIndex", rs.getString("Lic_place"));

                if (rs.getString("Lic_issue_date") == null || rs.getString("Lic_issue_date").equals("") || rs.getString("Lic_issue_date").contains("1900")) {
                    JsonObject.put("licenceIssueDateDataIndex", "");

                } else {
                    JsonObject.put("licenceIssueDateDataIndex", sdfddmmyy.format(rs.getTimestamp("Lic_issue_date")));
                }

                if (rs.getString("Lic_renew_date") == null || rs.getString("Lic_renew_date").equals("") || rs.getString("Lic_renew_date").contains("1900")) {
                    JsonObject.put("licenceRewenedDateDataIndex", "");

                } else {
                    JsonObject.put("licenceRewenedDateDataIndex", sdfddmmyy.format(rs.getTimestamp("Lic_renew_date")));
                }

                if (rs.getString("Lic_expiry_date") == null || rs.getString("Lic_expiry_date").equals("") || rs.getString("Lic_expiry_date").contains("1900")) {
                    JsonObject.put("licenceExpiryDateDataIndex", "");

                } else {
                    JsonObject.put("licenceExpiryDateDataIndex", sdfddmmyy.format(rs.getTimestamp("Lic_expiry_date")));
                }

                JsonObject.put("gunLicenceNoDataIndex", rs.getString("Lic_no"));
                JsonObject.put("gunLicenceTypeDataIndex", rs.getString("LICENSE_TYPE"));

                if (rs.getString("Lic_issue_date") == null || rs.getString("Lic_issue_date").equals("") || rs.getString("Lic_issue_date").contains("1900")) {
                    JsonObject.put("gunLicenceIssueDateDataIndex", "");

                } else {
                    JsonObject.put("gunLicenceIssueDateDataIndex", sdfddmmyy.format(rs.getTimestamp("Lic_issue_date")));
                }


                JsonObject.put("gunLicenceIssuePlaceDataIndex", rs.getString("Lic_place"));

                if (rs.getString("Lic_expiry_date") == null || rs.getString("Lic_expiry_date").equals("") || rs.getString("Lic_expiry_date").contains("1900")) {
                    JsonObject.put("gunLicenceExpiryDateDataIndex", "");

                } else {
                    JsonObject.put("gunLicenceExpiryDateDataIndex", sdfddmmyy.format(rs.getTimestamp("Lic_expiry_date")));
                }
                
                
                JsonObject.put("passportNumberDataIndex", rs.getString("PASSPORT_NUMBER"));
                if (rs.getString("EXPIRY_DATE") == null || rs.getString("EXPIRY_DATE").equals("") || rs.getString("EXPIRY_DATE").contains("1900")) {
                    JsonObject.put("expiryDateDataIndexforPersonalInformation", "");

                } else {
                    JsonObject.put("expiryDateDataIndexforPersonalInformation", sdfddmmyy.format(rs.getTimestamp("EXPIRY_DATE")));
                }

                JsonObject.put("workCompensationIdDataIndex", rs.getString("WORKMAN_COMPENSATION_ID"));
                if (rs.getString("WORKMAN_COMPENSATION_EXPIRY_DATE") == null || rs.getString("WORKMAN_COMPENSATION_EXPIRY_DATE").equals("") || rs.getString("WORKMAN_COMPENSATION_EXPIRY_DATE").contains("1900")) {
                    JsonObject.put("workCompensationExpiryDateDataIndex", "");

                } else {
                    JsonObject.put("workCompensationExpiryDateDataIndex", sdfddmmyy.format(rs.getTimestamp("WORKMAN_COMPENSATION_EXPIRY_DATE")));
                }
                JsonObject.put("preferedCompanyLabelDataIndex", rs.getString("PREFERED_COMPANY"));

                
                JsonArray.put(JsonObject);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
        return JsonArray;
    }


    public JSONArray getCountryList() {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
            pstmt = conAdmin.prepareStatement(CrewMasterStatements.Get_COUNTRY_LIST);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("CountryID", rs.getString("COUNTRY_CODE"));
                jsonObject.put("CountryName", rs.getString("COUNTRY_NAME"));
                jsonArray.put(jsonObject);
            }

        } catch (Exception e) {
        	 e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;
    }
    /***
     * function for getting State Name List from db
     * @return
     */
    public JSONArray getStateList(String countryid) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();

        int countrycode = Integer.parseInt(countryid);
        try {
            conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
            pstmt = conAdmin.prepareStatement(CrewMasterStatements.Get_STATE_LIST);
            pstmt.setInt(1, countrycode);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("StateID", rs.getString("STATE_CODE"));
                jsonObject.put("StateName", rs.getString("STATE_NAME"));
                jsonArray.put(jsonObject);
            }

        } catch (Exception e) {
        	 e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;
    }


    public JSONArray getGroupNameList(int systemId, int clientId) {

        JSONArray list2 = new JSONArray();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnectionToDB("AMS");
            String stmt = CrewMasterStatements.SELECT_GROUP_LIST;

            pstmt = con.prepareStatement(stmt);
            pstmt.setInt(1, systemId);
            pstmt.setInt(2, clientId);

            rs = pstmt.executeQuery();

            JSONObject objNone = new JSONObject();
            objNone.put("groupId", "0");
            objNone.put("groupName", "None");
            list2.put(objNone);

            while (rs.next()) {
                JSONObject obj1 = new JSONObject();

                obj1.put("groupId", rs.getString("GROUP_ID"));
                obj1.put("groupName", rs.getString("GROUP_NAME"));
                list2.put(obj1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
        return list2;
    }
    
    public JSONArray getemploymentType() {
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			 String stmt = CrewMasterStatements.GET_EMPLOYMENT_TYPE;
			 pstmt = con.prepareStatement(stmt);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
				jsonObject.put("empId", rs.getString("TYPE"));
				jsonObject.put("employmentType", rs.getString("VALUE"));
				jsonArray.put(jsonObject);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}




    public String saveGunMenInformationForAddCrew(String firstName, String lastName, String address, String permanentAddress, String city, String otherCity, String state, String country, String telephoneNo, String mobileNo, String dateOfBirth, String gender, String nationality, String maritialStatus,
        String employmentType, String employmentId, String client, String dateOfJoining, String dateOfLeaving, String bloodGroup, String groupName, String activeStatus, String remarks, String governmentOrResidenceId, String governmentOrResidenceIdExpiryDate, String rfidCode,
        String medicalInsuranceNo, String medicalInsuranceCompany, String medicalInsuranceExpiryDate, String licenceNo, String licencePlace, String licenceIssueDate, String licenceRenewedDate, String licenceExpiryDate,
        int systemId, int customerId, int userId, int offset,String passportNumber,String expiryDate,String workCompensationId,String workCompensationExpiryDate,String preferedCustomerNames) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ResultSet rs1 = null;
        String message = "";
        try {
        	
            con = DBConnection.getConnectionToDB("AMS");
            pstmt = con.prepareStatement(CrewMasterStatements.SELECT_EMPLOYEE_ID);
            pstmt.setString(1, employmentId);
            pstmt.setInt(2, systemId);
            pstmt.setInt(3, customerId);
            rs1 = pstmt.executeQuery();
            if (rs1.next()) {
                message = "Employee Id Already Exist";
            } else {
                int DriverId = 0;
                String stmt1 = CrewMasterStatements.SELECT_MAX_DRIVER_ID;
                pstmt = con.prepareStatement(stmt1);
                rs = pstmt.executeQuery();
                while (rs.next()) {
                    DriverId = rs.getInt("Driver_id");
                }
                ++DriverId;
                pstmt = con.prepareStatement(CrewMasterStatements.UPDATE_GUNMEN_INFORMATION_FOR_ADD_CREW);
                pstmt.setInt(1, DriverId);
                pstmt.setString(2, firstName.toUpperCase());
                pstmt.setString(3, lastName);
                pstmt.setString(4, address);
                pstmt.setString(5, permanentAddress);
                pstmt.setInt(6, 0);
                pstmt.setString(7, otherCity);
                pstmt.setString(8, state);
                pstmt.setString(9, country);
                pstmt.setString(10, telephoneNo);

                pstmt.setString(11, mobileNo);
                pstmt.setInt(12, offset);
                pstmt.setString(13, dateOfBirth);
                pstmt.setString(14, gender);
                pstmt.setString(15, nationality);
                pstmt.setString(16, maritialStatus);

                pstmt.setString(17, employmentType);
                pstmt.setString(18, employmentId);
                pstmt.setInt(19, offset);
                pstmt.setString(20, dateOfJoining);
                pstmt.setInt(21, offset);
                pstmt.setString(22, dateOfLeaving);
                pstmt.setString(23, bloodGroup.trim());
                pstmt.setString(24, groupName);
                pstmt.setString(25, activeStatus);
                pstmt.setString(26, remarks);
                pstmt.setString(27, governmentOrResidenceId);
                pstmt.setInt(28, offset);
                pstmt.setString(29, governmentOrResidenceIdExpiryDate);
                pstmt.setString(30, rfidCode);

                pstmt.setString(31, medicalInsuranceNo);
                pstmt.setString(32, medicalInsuranceCompany);
                pstmt.setInt(33, offset);
                pstmt.setString(34, medicalInsuranceExpiryDate);
                pstmt.setString(35, licenceNo);
                pstmt.setString(36, licencePlace);
                pstmt.setInt(37, offset);
                pstmt.setString(38, licenceIssueDate);
                pstmt.setInt(39, offset);
                pstmt.setString(40, licenceRenewedDate);
                pstmt.setInt(41, offset);
                pstmt.setString(42, licenceExpiryDate);
                pstmt.setInt(43, customerId);
                pstmt.setInt(44, systemId);
                pstmt.setInt(45, userId);
                
                pstmt.setString(46, passportNumber);
                pstmt.setInt(47, offset);
                pstmt.setString(48, expiryDate);
                pstmt.setString(49, workCompensationId);
                pstmt.setInt(50, offset);
                pstmt.setString(51, workCompensationExpiryDate);
                pstmt.setString(52, preferedCustomerNames);
                

                int updated = pstmt.executeUpdate();
                if (updated > 0) {
                    message = "Saved Successfully";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
            DBConnection.releaseConnectionToDB(null, null, rs1);
        }
        return message;
    }



    public String saveGunMenInformationForAddCrewForGunmen(String firstName, String lastName, String address, String permanentAddress, String city, String otherCity, String state, String country, String telephoneNo, String mobileNo, String dateOfBirth, String gender, String nationality, String maritialStatus,
        String employmentType, String employmentId, String client, String dateOfJoining, String dateOfLeaving, String bloodGroup, String groupName, String activeStatus, String remarks, String governmentOrResidenceId, String governmentOrResidenceIdExpiryDate, String rfidCode,
        String medicalInsuranceNo, String medicalInsuranceCompany, String medicalInsuranceExpiryDate, String gunlicenceNo, String gunlicenceType, String gunlicenceIssueDate, String gunlicenceIssuePlace, String gunlicenceExpiryDate,
        int systemId, int customerId, int userId, int offset,String passportNumber,String expiryDate,String workCompensationId,String workCompensationExpiryDate,String preferedCustomerNames) {
        Connection con = null;
        PreparedStatement pstmt = null;
        String message = "";
        ResultSet rs1 = null;
        try {
        	con = DBConnection.getConnectionToDB("AMS");
            pstmt = con.prepareStatement(CrewMasterStatements.SELECT_EMPLOYEE_ID);
            pstmt.setString(1, employmentId);
            pstmt.setInt(2, systemId);
            pstmt.setInt(3, customerId);
            rs1 = pstmt.executeQuery();
            if (rs1.next()) {
                message = "Employee Id Already Exist";
            } else {

                int DriverId = 0;
                String stmt1 = CrewMasterStatements.SELECT_MAX_DRIVER_ID;
                pstmt = con.prepareStatement(stmt1);
                ResultSet rs = pstmt.executeQuery();
                while (rs.next()) {
                    DriverId = rs.getInt("Driver_id");
                }
                ++DriverId;
                pstmt = con.prepareStatement(CrewMasterStatements.INSERT_GUNMEN_INFORMATION_FOR_ADD_CREW);
                pstmt.setInt(1, DriverId);
                pstmt.setString(2, firstName.toUpperCase());
                pstmt.setString(3, lastName);
                pstmt.setString(4, address);
                pstmt.setString(5, permanentAddress);
                pstmt.setInt(6, 0);
                pstmt.setString(7, otherCity);
                pstmt.setString(8, state);
                pstmt.setString(9, country);
                pstmt.setString(10, telephoneNo);

                pstmt.setString(11, mobileNo);
                pstmt.setInt(12, offset);
                pstmt.setString(13, dateOfBirth);
                pstmt.setString(14, gender);
                pstmt.setString(15, nationality);
                pstmt.setString(16, maritialStatus);

                pstmt.setString(17, employmentType);
                pstmt.setString(18, employmentId);
                pstmt.setInt(19, offset);
                pstmt.setString(20, dateOfJoining);
                pstmt.setInt(21, offset);
                pstmt.setString(22, dateOfLeaving);
                pstmt.setString(23, bloodGroup.trim());
                pstmt.setString(24, groupName);
                pstmt.setString(25, activeStatus);
                pstmt.setString(26, remarks);
                pstmt.setString(27, governmentOrResidenceId);
                pstmt.setInt(28, offset);
                pstmt.setString(29, governmentOrResidenceIdExpiryDate);
                pstmt.setString(30, rfidCode);

                pstmt.setString(31, medicalInsuranceNo);
                pstmt.setString(32, medicalInsuranceCompany);
                pstmt.setInt(33, offset);
                pstmt.setString(34, medicalInsuranceExpiryDate);
                pstmt.setString(35, gunlicenceNo);
                pstmt.setString(36, gunlicenceType);
                pstmt.setInt(37, offset);
                pstmt.setString(38, gunlicenceIssueDate);
                pstmt.setString(39, gunlicenceIssuePlace);
                pstmt.setInt(40, offset);
                pstmt.setString(41, gunlicenceExpiryDate);
                pstmt.setInt(42, customerId);
                pstmt.setInt(43, systemId);
                pstmt.setInt(44, userId);
                
                pstmt.setString(45, passportNumber);
                pstmt.setInt(46, offset);
                pstmt.setString(47, expiryDate);
                pstmt.setString(48, workCompensationId);
                pstmt.setInt(49, offset);
                pstmt.setString(50, workCompensationExpiryDate);
                pstmt.setString(51, preferedCustomerNames);
                
                
                int updated = pstmt.executeUpdate();
                if (updated > 0) {
                    message = "Saved Successfully";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs1);
        }
        return message;
    }

   

}