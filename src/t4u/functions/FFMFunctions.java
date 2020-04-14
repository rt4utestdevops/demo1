package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import com.itextpdf.text.log.SysoLogger;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.FFMStatements;

public class FFMFunctions {
    CommonFunctions cf = new CommonFunctions();
    SimpleDateFormat sdfyyyymmddhhmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

    public JSONArray getASM(int customerId, int systemId) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("AMS");
            pstmt = conAdmin.prepareStatement(FFMStatements.GET_ASM);
            pstmt.setInt(1, systemId);
            pstmt.setInt(2, customerId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("asmName", rs.getString("ASMName"));
                jsonObject.put("asmId", rs.getString("ASMId"));
                jsonArray.put(jsonObject);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }

        return jsonArray;
    }

    public JSONArray getEmail(int customerId, int systemId) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("AMS");
            pstmt = conAdmin.prepareStatement(FFMStatements.GET_EMAIL);
            pstmt.setInt(1, systemId);
            pstmt.setInt(2, customerId);

            rs = pstmt.executeQuery();
            while (rs.next()) {
                if (rs.getString("EmailName") != "") {
                    jsonObject = new JSONObject();
                    jsonObject.put("emailName", rs.getString("EmailName"));
                    jsonObject.put("emailId", rs.getString("EmailId"));
                    jsonArray.put(jsonObject);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }

        return jsonArray;
    }

    public String insertCustomerInformation(int custId, String accountType, String fmDate, String asm, String tsm, String channelpartner, String dst,
        String visittype, String accountName, String accAddress, String accountsegment, String customerName, String mobileNo, String landLineNo,
        String emailId, String accountstatus, String customerstatus, String escalation1, String escalation2, String escalation3,
        String escalation4, String[] product, String[] amount, int systemId, int offset) {
        Connection con = null;
        PreparedStatement pstmt = null, pstmt2 = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        ResultSet rs1 = null;
        String message = "Failed To Save Data";
        try {
            con = DBConnection.getConnectionToDB("AMS");
            con.setAutoCommit(false);
            pstmt = con.prepareStatement(FFMStatements.INSERT_FF_CUSTOMER);
            pstmt.setString(1, accountType);
            pstmt.setInt(2, offset);
            pstmt.setString(3, fmDate);
            pstmt.setString(4, asm);
            pstmt.setString(5, tsm);
            pstmt.setString(6, channelpartner);
            pstmt.setString(7, dst);
            pstmt.setString(8, visittype);
            pstmt.setString(9, accountName);
            pstmt.setString(10, accAddress);
            pstmt.setString(11, accountsegment);
            pstmt.setString(12, mobileNo);
            pstmt.setString(13, landLineNo);
            pstmt.setString(14, emailId);
            pstmt.setString(15, accountstatus);
            pstmt.setString(16, customerstatus);
            pstmt.setString(17, escalation1);
            pstmt.setString(18, escalation2);
            pstmt.setString(19, escalation3);
            pstmt.setString(20, escalation4);
            pstmt.setInt(21, custId);
            pstmt.setInt(22, systemId);
            pstmt.setString(23, customerName);
            int update = pstmt.executeUpdate();
            if (update > 0) {
                int refId = 0;
                pstmt1 = con.prepareStatement(FFMStatements.SELECT_MAX_CUST_ID);
                pstmt1.setInt(1, systemId);
                pstmt1.setInt(2, custId);
                rs1 = pstmt1.executeQuery();
                while (rs1.next()) {
                    refId = rs1.getInt("");
                }
                pstmt2 = con.prepareStatement(FFMStatements.INSERT_FF_CUST_PROD_DETAILS);
                message = "Saved Successfully";
                for (int i = 0; i < product.length; i++) {

                    if (!product[i].equals("-")) {
                        message = "Failed To Save Data";
                        pstmt2.setInt(1, refId);
                        pstmt2.setInt(2, Integer.parseInt(product[i]));
                        pstmt2.setString(3, amount[i]);
                        pstmt2.setInt(4, systemId);
                        pstmt2.setInt(5, custId);
                        int inserted1 = pstmt2.executeUpdate();
                        if (inserted1 > 0) {
                            message = "Saved Successfully";
                        }
                    }
                }
            }
            con.commit();
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (con != null) con.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
            DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
            DBConnection.releaseConnectionToDB(null, pstmt2, null);
        }

        return message;

    }

    public ArrayList < Object > getCustomerDetails(int custId, int systemId, int offset) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null, pstmt1 = null;
        ResultSet rs = null, rs1 = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = null;
        ArrayList < Object > finlist = new ArrayList < Object > ();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        try {
            int count = 0;
            conAdmin = DBConnection.getConnectionToDB("AMS");
            pstmt = conAdmin.prepareStatement(FFMStatements.GET_FFM_CUST_DETAILS);
            pstmt.setInt(1, offset);
            pstmt.setInt(2, systemId);
            pstmt.setInt(3, custId);
            rs = pstmt.executeQuery();
            pstmt1 = conAdmin.prepareStatement(FFMStatements.GET_FFM_CUST_PROD_DETAILS);
            while (rs.next()) {
                count++;
                String Products = "", Amounts = "";
                jsonObject = new JSONObject();
                jsonObject.put("slnoIndex", count);
                jsonObject.put("uniqueIdDataIndex", rs.getString("RefId"));
                jsonObject.put("accountTypeIndex", rs.getString("AccType"));
                jsonObject.put("firstMeetIndex", rs.getString("FirstMeetDate"));
                jsonObject.put("asmIndex", rs.getString("Asm"));
                jsonObject.put("tsmIndex", rs.getString("Tsm"));
                jsonObject.put("channelPartnerIndex", rs.getString("ChannelPartner"));
                jsonObject.put("dstIndex", rs.getString("Dst"));
                jsonObject.put("visitTypeIndex", rs.getString("VisitType"));
                jsonObject.put("accNameIndex", rs.getString("AccName"));
                jsonObject.put("accAddressIndex", rs.getString("AccAddress"));
                jsonObject.put("accSegmentIndex", rs.getString("AccSegment"));
                jsonObject.put("customerNameIndex", rs.getString("CustName"));
                jsonObject.put("landNoIndex", rs.getString("LandlineNum"));
                jsonObject.put("mobileNoIndex", rs.getString("MobileNum"));
                jsonObject.put("emailIndex", rs.getString("Email"));
                jsonObject.put("accStatusIndex", rs.getString("AccStatus"));
                jsonObject.put("customerStatusIndex", rs.getString("CustStatus"));
                jsonObject.put("esclvl1Index", rs.getString("EscEmail1"));
                jsonObject.put("esclvl2Index", rs.getString("EscEmail2"));
                jsonObject.put("esclvl3Index", rs.getString("EscEmail3"));
                jsonObject.put("esclvl4Index", rs.getString("EscEmail4"));
                String refNo = rs.getString("RefId");
                pstmt1.setInt(1, Integer.parseInt(refNo));
                pstmt1.setInt(2, systemId);
                pstmt1.setInt(3, custId);
                rs1 = pstmt1.executeQuery();
                while (rs1.next()) {
                    if (Products.isEmpty()) {
                        Products = rs1.getString("Product");
                        Amounts = rs1.getString("Amount");
                    } else {
                        Products = Products + "," + rs1.getString("Product");
                        Amounts = Amounts + "," + rs1.getString("Amount");
                    }
                }
                jsonObject.put("productsDataIndex", Products);
                jsonObject.put("amountsDataIndex", Amounts);
                if (rs.getString("FirstMeetDate") == null || rs.getString("FirstMeetDate").equals("") || rs.getString("FirstMeetDate").contains("1900")) {
                    jsonObject.put("firstMeetIndex", "");
                } else {
                    jsonObject.put("firstMeetIndex", sdf.format(rs.getTimestamp("FirstMeetDate")));
                }
                jsonArray.put(jsonObject);
            }
            finlist.add(jsonArray);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
            DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
        }
        return finlist;
    }

    public JSONArray getProducts(int custId, int systemId) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("AMS");
            pstmt = conAdmin.prepareStatement(FFMStatements.GET_PRODUCT);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("productName", rs.getString("ProductName"));
                jsonObject.put("productId", rs.getString("ProductId"));
                jsonObject.put("num", "");
                jsonArray.put(jsonObject);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;
    }

    public String updateCustomerInformation(int custId, String accountType, String fmDate, String asmModify, String tsmModify,
        String channelpartnerModify, String dstModify, String visittypeModify, String accountName, String accAddress, String accountsegmentModify,
        String customerName, String mobileNo, String landLineNo, String emailId, String accountstatusModify,
        String customerstatusModify, String escalation1Modify, String escalation2Modify, String escalation3Modify, String escalation4Modify, String[] product, String[] amount,
        int systemId, int offset, int refId) {
        Connection con = null;
        PreparedStatement pstmt = null, pstmt1 = null;
        String message = "Failed to Update Data";
        
        try {
            con = DBConnection.getConnectionToDB("AMS");
            con.setAutoCommit(false);
            pstmt = con.prepareStatement(FFMStatements.MODIFY_FF_CUST_PROD_DETAILS);
            pstmt.setString(1, accountType);
            pstmt.setInt(2, offset);
            pstmt.setString(3, fmDate);
            pstmt.setString(4, asmModify);
            pstmt.setString(5, tsmModify);
            pstmt.setString(6, channelpartnerModify);
            pstmt.setString(7, dstModify);
            pstmt.setString(8, visittypeModify);
            pstmt.setString(9, accountName);
            pstmt.setString(10, accAddress);
            pstmt.setString(11, accountsegmentModify);
            pstmt.setString(12, customerName);
            pstmt.setString(13, mobileNo);
            pstmt.setString(14, landLineNo);
            pstmt.setString(15, emailId);
            pstmt.setString(16, accountstatusModify);
            pstmt.setString(17, customerstatusModify);
            pstmt.setString(18, escalation1Modify);
            pstmt.setString(19, escalation2Modify);
            pstmt.setString(20, escalation3Modify);
            pstmt.setString(21, escalation4Modify);
            pstmt.setInt(22, custId);
            pstmt.setInt(23, systemId);
            pstmt.setInt(24, refId);
            int updated = pstmt.executeUpdate();
            message = "Updated Successfully";
            if (updated > 0) {
                pstmt1 = con.prepareStatement(FFMStatements.DELETE_FF_CUST_PROD_DETAILS);
                pstmt1.setInt(1, refId);
                pstmt1.setInt(2, systemId);
                pstmt1.setInt(3, custId);
                int del = pstmt1.executeUpdate();

                for (int i = 0; i < product.length; i++) {
                    pstmt = con.prepareStatement(FFMStatements.INSERT_FF_CUST_PROD_DETAILS);
                    if (!product[i].equals("-")) {
                        message = "Failed to Update Data";
                        pstmt.setInt(1, refId);
                        pstmt.setInt(2, Integer.parseInt(product[i]));
                        pstmt.setString(3, amount[i]);
                        pstmt.setInt(4, systemId);
                        pstmt.setInt(5, custId);
                        int updated1 = pstmt.executeUpdate();
                    }
                }
                message = "Updated Successfully";
            }
            con.commit();
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (con != null) con.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, null);
            DBConnection.releaseConnectionToDB(null, pstmt1, null);
        }
        return message;

    }

    public String deleteData(int custId, int systemId, int refId) {
        Connection con = null;
        PreparedStatement pstmt = null, pstmt1 = null;
        ResultSet rs = null;
        String message = "Could not delete data";
        try {
            con = DBConnection.getConnectionToDB("AMS");
            con.setAutoCommit(false);
            pstmt = con.prepareStatement(FFMStatements.DELETE_FF_CUSTOMER_DETAILS);
            pstmt.setInt(1, refId);
            pstmt.setInt(2, systemId);
            pstmt.setInt(3, custId);
            int del = pstmt.executeUpdate();
            message = "Deleted Successfully";
            if (del > 0) {
                message = "Could not delete data";
                pstmt1 = con.prepareStatement(FFMStatements.DELETE_FF_CUST_PROD_DETAILS);
                pstmt1.setInt(1, refId);
                pstmt1.setInt(2, systemId);
                pstmt1.setInt(3, custId);
                int del1 = pstmt1.executeUpdate();
                con.commit();
                message = "Deleted Successfully";
            }
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (con != null) con.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
            DBConnection.releaseConnectionToDB(null, pstmt1, null);
        }
        return message;
    }

    public JSONArray getFollowUps(int systemId, int userId , int custId) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("AMS");
            if (userId == 0) {
                pstmt = conAdmin.prepareStatement(FFMStatements.GET_SYS_FOLLOW_UPS);
                pstmt.setInt(1, systemId);
                pstmt.setInt(2, custId);

            } else {
                pstmt = conAdmin.prepareStatement(FFMStatements.GET_FOLLOW_UPS);
                pstmt.setInt(1, systemId);
                pstmt.setInt(2, userId);
                pstmt.setInt(3, custId);
            }
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("registrationNumber", rs.getString("RegistrationNo"));
                jsonObject.put("groupName", rs.getString("GroupName"));
                jsonObject.put("latitude", rs.getString("Latitude"));
                jsonObject.put("longitude", rs.getString("Longitude"));
                jsonObject.put("location", rs.getString("Location"));
                jsonObject.put("mobileNo", rs.getString("PhoneNo"));
                jsonArray.put(jsonObject);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;
    }

    public JSONArray getNumVisits(int custId, int systemId, int userId) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("AMS");
            if (userId != 0) {
                pstmt = conAdmin.prepareStatement(FFMStatements.GET_NO_OF_VISITS);
                pstmt.setInt(1, systemId);
                pstmt.setInt(2, userId);
            } else {
                pstmt = conAdmin.prepareStatement(FFMStatements.GET_NO_OF_VISITS_WITHOUT_USERID);
                pstmt.setInt(1, systemId);
            }
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject.put("NumVisits", rs.getString("NumVisit"));
            }
            jsonArray.put(jsonObject);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;

    }

    public JSONArray getUserName(int customerId, int systemId, int isLTSP) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("AMS");
                pstmt = conAdmin.prepareStatement(FFMStatements.GET_USERNAME_CUST);
                pstmt.setInt(1, systemId);
                pstmt.setInt(2, customerId);

            rs = pstmt.executeQuery();

            jsonObject = new JSONObject();
            jsonObject.put("asmName", "All");
            jsonObject.put("asmId", "");
            jsonArray.put(jsonObject);
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("asmName", rs.getString("ASMName"));
                jsonObject.put("asmId", rs.getString("ASMId"));
                jsonArray.put(jsonObject);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }

        return jsonArray;
    }

    public ArrayList < Object > getVisitDetails(int systemId, int userId, int offset) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = null;
        ArrayList < Object > finlist = new ArrayList < Object > ();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        try {
            int count = 0;
            conAdmin = DBConnection.getConnectionToDB("AMS");
            if (userId == 0) {
                pstmt = conAdmin.prepareStatement(FFMStatements.GET_SYS_VISIT_DETAILS);
                pstmt.setInt(1, offset);
                pstmt.setInt(2, systemId);
            } else {
                pstmt = conAdmin.prepareStatement(FFMStatements.GET_VISIT_DETAILS);
                pstmt.setInt(1, offset);
                pstmt.setInt(2, systemId);
                pstmt.setInt(3, userId);
            }
            rs = pstmt.executeQuery();
            while (rs.next()) {
                count++;
                jsonObject = new JSONObject();
                jsonObject.put("slnoIndex", count);
                jsonObject.put("customerNameIndex", rs.getString("CustomerName"));
                jsonObject.put("companyNameIndex", rs.getString("CompanyName"));
                jsonObject.put("callTypeIndex", rs.getString("CallType"));
                jsonObject.put("remarksIndex", rs.getString("Remarks"));
                if (rs.getString("UpdatedTime") == null || rs.getString("UpdatedTime").equals("") || rs.getString("UpdatedTime").contains("1900")) {
                    jsonObject.put("updatedTimeIndex", "");
                } else {
                    jsonObject.put("updatedTimeIndex", sdf.format(rs.getTimestamp("UpdatedTime")));
                }
                jsonArray.put(jsonObject);
            }
            finlist.add(jsonArray);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return finlist;
    }

    public JSONArray getPendingFollowUps(int systemId, int userId ,int custID) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("AMS");
            if (userId == 0) {
                pstmt = conAdmin.prepareStatement(FFMStatements.GET_SYS_PENDING_FOLLOW_UPS);
                pstmt.setInt(1, systemId);
                pstmt.setInt(2, custID);
                
            } else {
                pstmt = conAdmin.prepareStatement(FFMStatements.GET_PENDING_FOLLOW_UPS);
                pstmt.setInt(1, systemId);
                pstmt.setInt(2, userId);
                pstmt.setInt(3, custID);
            }
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("registrationNumber", rs.getString("RegistrationNo"));
                jsonObject.put("groupName", rs.getString("GroupName"));
                jsonObject.put("latitude", rs.getString("Latitude"));
                jsonObject.put("longitude", rs.getString("Longitude"));
                jsonObject.put("location", rs.getString("Location"));
                jsonObject.put("mobileNo", rs.getString("PhoneNo"));
                jsonArray.put(jsonObject);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;
    }
    
    public ArrayList < Object > getCustomerHistoryDetails(int systemId, String startdate, String enddate, int offset, String language) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        JSONObject jsonObject = null;
        JSONArray jsonArray = new JSONArray();
        ArrayList < Object > finlist = new ArrayList < Object > ();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        ReportHelper reoporthelper = new ReportHelper();
        ArrayList < String > headersList = new ArrayList < String > ();
        ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();

        try {
            headersList.add(cf.getLabelFromDB("SLNO", language).toUpperCase());
            headersList.add(cf.getLabelFromDB("Company_Name", language).toUpperCase());
            headersList.add(cf.getLabelFromDB("Employee", language).toUpperCase());
            headersList.add(cf.getLabelFromDB("Customer", language).toUpperCase());
            headersList.add(cf.getLabelFromDB("Date_Of_Update", language).toUpperCase());
            headersList.add(cf.getLabelFromDB("Call_Type", language).toUpperCase());
            headersList.add(cf.getLabelFromDB("Remarks", language).toUpperCase());


            con = DBConnection.getConnectionToDB("AMS");
            pstmt = con.prepareStatement(FFMStatements.GET_CUSTOMER_HISTORY);
            pstmt.setInt(1, offset);
          //  pstmt.setInt(2, customerId);
            pstmt.setInt(2, systemId);
            pstmt.setInt(3, offset);
            pstmt.setString(4, startdate);
            pstmt.setInt(5, offset);
            pstmt.setString(6, enddate);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                count++;
                jsonObject = new JSONObject();
                ArrayList < Object > informationList = new ArrayList < Object > ();
                ReportHelper reporthelper = new ReportHelper();

                informationList.add(count);
                jsonObject.put("slnoIndex", count);

                jsonObject.put("companynameDataIndex", rs.getString("company"));
                informationList.add(rs.getString("company"));
                
                jsonObject.put("employeeDataIndex", rs.getString("employee"));
                informationList.add(rs.getString("employee"));

                jsonObject.put("customerDataIndex", rs.getString("Customer"));
                informationList.add(rs.getString("customer"));

                if (rs.getString("dateofupdate") == null || rs.getString("dateofupdate").equals("") || rs.getString("dateofupdate").contains("1900")) {
                    jsonObject.put("updateDateDataIndex", "");
                    informationList.add("");
                } else {
                    jsonObject.put("updateDateDataIndex", sdf.format(rs.getTimestamp("dateofupdate")));
                    informationList.add(sdf.format(rs.getTimestamp("dateofupdate")));

                }
                jsonObject.put("callTypeDataIndex", rs.getString("calltype"));
                informationList.add(rs.getString("calltype"));
                
                jsonObject.put("remarksDataIndex", rs.getString("Remarks"));
                informationList.add(rs.getString("Remarks"));

                jsonArray.put(jsonObject);
                reporthelper.setInformationList(informationList);
                reportsList.add(reporthelper);

            }
            reoporthelper.setReportsList(reportsList);
            reoporthelper.setHeadersList(headersList);
            finlist.add(jsonArray);
            finlist.add(reoporthelper);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
        return finlist;
    }

    public JSONArray getCustomerForAppt(int custId, int systemId, int isLTSP) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null, pstmt1 = null;
        ResultSet rs = null, rs1 = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = null;
        try {
            int count = 0;
            conAdmin = DBConnection.getConnectionToDB("AMS");
            if (custId > 0 && isLTSP == -1) {
                pstmt = conAdmin.prepareStatement(FFMStatements.GET_FFM_CUST_FOR_APPT);
                pstmt.setInt(1, systemId);
                pstmt.setInt(2, custId);
            } else {
                pstmt = conAdmin.prepareStatement(FFMStatements.GET_FFM_LTSP_CUST_FOR_APPT);
                pstmt.setInt(1, systemId);
            }
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("customerName", rs.getString("CustomerName"));
                jsonObject.put("customerId", rs.getString("Id"));
                jsonArray.put(jsonObject);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;
    }


    public JSONArray getCustomerForAppt(int custId, int systemId) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null, rs1 = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = null;
        try {
            int count = 0;
            conAdmin = DBConnection.getConnectionToDB("AMS");
            pstmt = conAdmin.prepareStatement(FFMStatements.GET_FFM_CUST_FOR_APPT);
            pstmt.setInt(1, systemId);
            pstmt.setInt(2, custId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("ffmcustomerName", rs.getString("CustomerName"));
                jsonObject.put("ffmcustomerId", rs.getString("Id"));
                jsonArray.put(jsonObject);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;
    }

    public JSONArray getEmployees(int systemId, int custId) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("AMS");
            pstmt = conAdmin.prepareStatement(FFMStatements.GET_FFM_EMPLOYEES);
            pstmt.setInt(1, systemId);
            pstmt.setInt(2, custId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("employeeName", rs.getString("EmployeeName"));
                jsonArray.put(jsonObject);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;
    }

    public JSONArray getSupervisorName(int customerId, int systemId) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("AMS");
            pstmt = conAdmin.prepareStatement(FFMStatements.GET_USERNAME_CUST);
            pstmt.setInt(1, systemId);
            pstmt.setInt(2, customerId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("supervisorName", rs.getString("ASMName"));
                jsonObject.put("supervisorId", rs.getString("ASMId"));
                jsonArray.put(jsonObject);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;
    }

    public String insertAppointment(int custName, int supervisor, String employee, int offset, String appointmentTime, String remark, String followUpDate, int systemId, int customerId, int status, int userId) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String message = "";
        try {
            conAdmin = DBConnection.getConnectionToDB("AMS");
            pstmt = conAdmin.prepareStatement(FFMStatements.INSERT_FFM_APPOINTMENT);
            pstmt.setInt(1, custName);
            pstmt.setInt(2, supervisor);
            pstmt.setString(3, employee);
           // pstmt.setInt(4, offset);
            pstmt.setString(4, appointmentTime);
            pstmt.setString(5, remark);
            pstmt.setInt(6, offset);
            pstmt.setString(7, followUpDate);
            pstmt.setInt(8, systemId);
            pstmt.setInt(9, customerId);
            pstmt.setInt(10, status);
            pstmt.setInt(11, userId);
            int inserted = pstmt.executeUpdate();
            if (inserted > 0) {
                message = "Saved Successfully";
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return message;
    }

    public String modifyAppointment(int uniqueId, int custNameModify, int supervisor, String employee, int offset,
        String appointmentTime, String remark, String followUpDate, int systemId, int customerId, int status, int userId) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String message = "";
        try {
            conAdmin = DBConnection.getConnectionToDB("AMS");
            pstmt = conAdmin.prepareStatement(FFMStatements.MODIFY_FFM_APPOINTMENT);
            pstmt.setInt(1, custNameModify);
            pstmt.setInt(2, supervisor);
            pstmt.setString(3, employee);
          //  pstmt.setInt(4, offset);
            pstmt.setString(4, appointmentTime);
            pstmt.setString(5, remark);
            pstmt.setInt(6, offset);
            pstmt.setString(7, followUpDate);
            pstmt.setInt(8, status);
            pstmt.setInt(9, userId);
            pstmt.setInt(10, uniqueId);
            pstmt.setInt(11, systemId);
            pstmt.setInt(12, customerId);
            
            int inserted = pstmt.executeUpdate();
            if (inserted > 0) {
                message = "Saved Successfully";
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return message;
    }

    public ArrayList < Object > getAppointmentDetails(int custId, int systemId, int offset, String startDate, String endDate) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null, rs1 = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = null;
        ArrayList < Object > finlist = new ArrayList < Object > ();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        try {
            int count = 0;
            conAdmin = DBConnection.getConnectionToDB("AMS");
            pstmt = conAdmin.prepareStatement(FFMStatements.GET_FFM_APPOINTMENT_DETAILS);
         //   pstmt.setInt(1, offset);
            pstmt.setInt(1, offset);
            pstmt.setInt(2, offset);
            pstmt.setInt(3, systemId);
            pstmt.setInt(4, custId);
            pstmt.setInt(5, offset);
            pstmt.setString(6,startDate);
            pstmt.setString(7,endDate);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                count++;
                jsonObject = new JSONObject();
                jsonObject.put("slnoIndex", count);
                jsonObject.put("uniqueIdDataIndex", rs.getString("UniqueId"));
                jsonObject.put("customerIndex", rs.getString("CustomerName"));
                jsonObject.put("supervisorIndex", rs.getString("Supervisor"));
                jsonObject.put("employeeIndex", rs.getString("Employee"));
                jsonObject.put("empuserIndex", rs.getString("EmpUser"));
                jsonObject.put("remarksIndex", rs.getString("Remark"));
                jsonObject.put("locationIndex", rs.getString("Location"));
                if (Integer.parseInt(rs.getString("Status")) == 0) {
                    jsonObject.put("statusIndex", "Pending");
                } else {
                    jsonObject.put("statusIndex", "Completed");
                }
                if (rs.getString("AppointmentTime") == null || rs.getString("AppointmentTime").equals("") || rs.getString("AppointmentTime").contains("1900")) {
                    jsonObject.put("appointmentTimeIndex", "");
                } else {
                    jsonObject.put("appointmentTimeIndex", sdf.format(rs.getTimestamp("AppointmentTime")));
                }
                if (rs.getString("FollowUpDate") == null || rs.getString("FollowUpDate").equals("") || rs.getString("FollowUpDate").contains("1900")) {
                    jsonObject.put("followUpDateIndex", "");
                } else {
                    jsonObject.put("followUpDateIndex", sdf.format(rs.getTimestamp("FollowUpDate")));
                }
                if (rs.getString("LastUpdatedTime") == null || rs.getString("LastUpdatedTime").equals("") || rs.getString("LastUpdatedTime").contains("1900")) {
                    jsonObject.put("lastUpdatedTimeIndex", "");
                } else {
                    jsonObject.put("lastUpdatedTimeIndex", sdf.format(rs.getTimestamp("LastUpdatedTime")));
                }
                jsonArray.put(jsonObject);
            }
            finlist.add(jsonArray);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return finlist;
    }

    public String deleteAppointmentData(int customerId, int systemId, int uniqueId) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String message = "";
        try {
        	
            conAdmin = DBConnection.getConnectionToDB("AMS");
            pstmt = conAdmin.prepareStatement(FFMStatements.DELETE_FFM_APPOINTMENT);
            pstmt.setInt(1, systemId);
            pstmt.setInt(2, customerId);
            pstmt.setInt(3, uniqueId);
        
            int deleted = pstmt.executeUpdate();
            if (deleted > 0) {
                message = "Deleted Successfully";
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return message;
    }
    
    public JSONArray getPendingFollowUp(int systemId, int userId ,int custID) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("AMS");
            if (userId == 0) {
                pstmt = conAdmin.prepareStatement(FFMStatements.GET_SYS_PEND_FOLLOW_UP);
                pstmt.setInt(1, systemId);
                pstmt.setInt(2, custID);
            } else {
                pstmt = conAdmin.prepareStatement(FFMStatements.GET_PEND_FOLLOW_UP);
                pstmt.setInt(1, systemId);
                pstmt.setInt(2, userId);
                pstmt.setInt(3, custID);
            }
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("PendingFollowUpCount", rs.getString("PendingFollowUp"));               
                jsonArray.put(jsonObject);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;
    }
    
    public JSONArray getTotalFollowUp(int systemId, int userId ,int custID) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("AMS");
            if (userId == 0) {
                pstmt = conAdmin.prepareStatement(FFMStatements.GET_SYS_TOTAL_FOLLOW_UP);
                pstmt.setInt(1, systemId);
                pstmt.setInt(2, custID);
            } else {
                pstmt = conAdmin.prepareStatement(FFMStatements.GET_TOTAL_FOLLOW_UP);
                pstmt.setInt(1, systemId);
                pstmt.setInt(2, userId);
                pstmt.setInt(3, custID);
            }
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("totalFollowUpCount", rs.getString("TotalFollowUp"));               
                jsonArray.put(jsonObject);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;
    }
    
    public JSONArray getCommunicatingFollowUps(int systemId, int userId ,int custID) {
        Connection conAdmin = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        try {
            conAdmin = DBConnection.getConnectionToDB("AMS");
            if (userId == 0) {
                pstmt = conAdmin.prepareStatement(FFMStatements.GET_SYS_PENDING_FOLLOW_UPS_FOR_COMMUNICATING);
                pstmt.setInt(1, systemId);
                pstmt.setInt(2, custID);
                
            } else {
                pstmt = conAdmin.prepareStatement(FFMStatements.GET_PENDING_FOLLOW_UPS_FOR_COMMUNICATING);
                pstmt.setInt(1, systemId);
                pstmt.setInt(2, userId);
                pstmt.setInt(3, custID);
            }
            rs = pstmt.executeQuery();
            while (rs.next()) {
                jsonObject = new JSONObject();
                jsonObject.put("registrationNumber", rs.getString("RegistrationNo"));
                jsonObject.put("groupName", rs.getString("GroupName"));
                jsonObject.put("latitude", rs.getString("Latitude"));
                jsonObject.put("longitude", rs.getString("Longitude"));
                jsonObject.put("location", rs.getString("Location"));
                jsonObject.put("mobileNo", rs.getString("PhoneNo"));
                jsonArray.put(jsonObject);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
        }
        return jsonArray;
    }
    
}