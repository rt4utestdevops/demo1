package t4u.cashvanmanagement;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.functions.CommonFunctions;
import t4u.functions.CrewMasterFunctions;

public class CrewMasterDataAction extends Action {
    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        String param = "";
        String zone = "";
        int systemId = 0;
        int userId = 0;
        int offset = 0;
        //HttpSession session = request.getSession();
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        CrewMasterFunctions crewMaster = new CrewMasterFunctions();
        systemId = loginInfo.getSystemId();
        //String lang = loginInfo.getLanguage();
        zone = loginInfo.getZone();
        userId = loginInfo.getUserId();
        offset = loginInfo.getOffsetMinutes();
        String lang = loginInfo.getLanguage();
        zone = loginInfo.getZone();
        CommonFunctions cf = new CommonFunctions();
        JSONArray jsonArray = null;
        JSONObject jsonObject = new JSONObject();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }

        if (param.equals("savePersonalInformation")) {
            try {
                String customerId = request.getParameter("CustID");
                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String address = request.getParameter("address");
                String permanentAddress = request.getParameter("permanentAddress");
                String city = request.getParameter("city");
                String otherCity = request.getParameter("otherCity");
                String state = request.getParameter("state");
                String country = request.getParameter("country");
                String telephoneNo = request.getParameter("telephoneNo");
                String mobileNo = request.getParameter("mobileNo");
                String dateOfBirth = request.getParameter("dateOfBirth");
                String gender = request.getParameter("gender");
                String nationality = request.getParameter("nationality");
                String maritialStatus = request.getParameter("maritialStatus");
                String driverId = request.getParameter("driverId");
                String passportNumber = request.getParameter("passportNumber");
                String expiryDate = request.getParameter("expiryDate");
                String message = "";
                if (customerId != null && !customerId.equals("")) {
                    message = crewMaster.updatePersonalInformation(firstName, lastName, address, permanentAddress, city, otherCity, state, country, telephoneNo, mobileNo, dateOfBirth, gender, nationality, maritialStatus,
                        systemId, Integer.parseInt(customerId), userId, offset, Integer.parseInt(driverId),passportNumber,expiryDate);
                }
                response.getWriter().print(message);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
        
        else if (param.equals("saveEmploymentInformation")) {
            try {
                String customerId = request.getParameter("CustID");
                String employmentType = request.getParameter("employementType");
                String employmentId = request.getParameter("employmentId");
                String client = request.getParameter("client");
                String dateOfJoining = request.getParameter("dateOfJoining");
                String dateOfLeaving = request.getParameter("dateOfLeaving");
                String bloodGroup = request.getParameter("bloodGroup");
                String groupName = request.getParameter("groupName");
                String activeStatus = request.getParameter("activeStatus");
                String remarks = request.getParameter("remarks");
                String governmentOrResidenceId = request.getParameter("governmentResidenceId");
                String governmentOrResidenceIdExpiryDate = request.getParameter("governmentResidenceExpiryDate");
                String rfidCode = request.getParameter("rfidCode");
                String driverId = request.getParameter("driverId");
                String workCompensationId = request.getParameter("workCompensationId");
                String workManCompensationExpiryDate = request.getParameter("workCompensationExpiryDate");
                String message = "";
                if (customerId != null && !customerId.equals("")) {
                    message = crewMaster.updateEmployeeInformation(employmentType, employmentId, client, dateOfJoining, dateOfLeaving, bloodGroup, groupName, activeStatus, remarks, governmentOrResidenceId, governmentOrResidenceIdExpiryDate, rfidCode,
                        systemId, Integer.parseInt(driverId), Integer.parseInt(customerId), userId, offset,workCompensationId,workManCompensationExpiryDate);
                }
                response.getWriter().print(message);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
        
        else if (param.equals("saveInsuranceInformation")) {
            try {
                String customerId = request.getParameter("CustID");
                String medicalInsuranceNo = request.getParameter("medicalInsuranceId");
                String medicalInsuranceCompany = request.getParameter("medicalInsuranceCompanyName");
                String medicalInsuranceExpiryDate = request.getParameter("medicalinsuranceExpiryDate");
                String driverId = request.getParameter("driverId");
                String message = "";
                if (customerId != null && !customerId.equals("")) {
                    message = crewMaster.updateInsuranceInformation(medicalInsuranceNo, medicalInsuranceCompany, medicalInsuranceExpiryDate,
                        systemId, Integer.parseInt(driverId), Integer.parseInt(customerId), userId, offset);
                }
                response.getWriter().print(message);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
        
        else if (param.equals("saveDriverInformation")) {
            try {
                String customerId = request.getParameter("CustID");
                String licenceNo = request.getParameter("licenceId");
                String licencePlace = request.getParameter("licencePlace");
                String licenceIssueDate = request.getParameter("licenceIssueDate");
                String licenceRenewedDate = request.getParameter("licenceRenewedDate");
                String licenceExpiryDate = request.getParameter("licenceExpiryDate");
                String driverId = request.getParameter("driverId");
                String preferedCustomerNmaes = request.getParameter("preferedCustomerNmaes");
                if(preferedCustomerNmaes != null && !preferedCustomerNmaes.equals("") ){
                preferedCustomerNmaes = preferedCustomerNmaes.substring(0,preferedCustomerNmaes.lastIndexOf(","));
                }else{
                	preferedCustomerNmaes = "";	
                }
                String message = "";
                if (customerId != null && !customerId.equals("")) {
                    message = crewMaster.updateDriverInformation(licenceNo, licencePlace, licenceIssueDate, licenceRenewedDate, licenceExpiryDate,
                        systemId, Integer.parseInt(driverId), Integer.parseInt(customerId), userId, offset,preferedCustomerNmaes);
                }
                response.getWriter().print(message);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
        
        else if (param.equals("saveGunMenInformation")) {
            try {
                String customerId = request.getParameter("CustID");
                String gunlicenceNo = request.getParameter("gunLicenceId");
                String gunlicenceType = request.getParameter("gunLicenceTypeId");
                String gunlicenceIssueDate = request.getParameter("gunLicenceIssueDate");
                String gunlicenceIssuePlace = request.getParameter("gunLicenceIssuePlace");
                String gunlicenceExpiryDate = request.getParameter("gunLicenceExpiryDate");
                String driverId = request.getParameter("driverId");
                String message = "";

                if (customerId != null && !customerId.equals("")) {
                    message = crewMaster.updateGunMenInformation(gunlicenceNo, gunlicenceType, gunlicenceIssueDate, gunlicenceIssuePlace, gunlicenceExpiryDate,
                        systemId, Integer.parseInt(driverId), Integer.parseInt(customerId), userId, offset);
                }
                response.getWriter().print(message);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        else if (param.equals("getDriverNames")) {
            try {
                String customerId = request.getParameter("CustId");
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                if (customerId != null && !customerId.equals("")) {
                    jsonArray = crewMaster.getDriverNames(systemId, Integer.parseInt(customerId), offset);
                    if (jsonArray.length() > 0) {
                        jsonObject.put("driverNameRoot", jsonArray);
                    } else {
                        jsonObject.put("driverNameRoot", "");
                    }
                    response.getWriter().print(jsonObject.toString());
                } else {
                    jsonObject.put("driverNameRoot", "");
                    // response.getWriter().print(jsonObject.toString());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
        
        else if (param.equals("getCountryList")) {
            try {
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                jsonArray = crewMaster.getCountryList();
                if (jsonArray.length() > 0) {
                    jsonObject.put("CountryRoot", jsonArray);
                } else {
                    jsonObject.put("CountryRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
            	 e.printStackTrace();
             }
        }
        
        
        else if (param.equals("getStateList")) {

            String countryId = "0";
            if (request.getParameter("countryId") != null || request.getParameter("countryId").equals("")) {
                countryId = request.getParameter("countryId").trim();
            }
            try {
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                if (!countryId.equals("0")) {
                    jsonArray = crewMaster.getStateList(countryId);
                }
                if (jsonArray.length() > 0) {
                    jsonObject.put("StateRoot", jsonArray);
                } else {
                    jsonObject.put("StateRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
            }
        }
        
        else if (param.equals("getGroups")) {
            int clientId = 0;
            String customerId = request.getParameter("CustId");
            if (customerId != null) {
                clientId = Integer.parseInt(customerId);
            }

            jsonArray = crewMaster.getGroupNameList(systemId, clientId);
            try {
                if (jsonArray != null) {
                    jsonObject.put("groupNameList", jsonArray);
                } else {
                    jsonObject.put("groupNameList", "");
                }
                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
		if (param.equalsIgnoreCase("getemploymentType")) {
				JSONArray jsonarray = null;
				try {
					jsonarray = crewMaster.getemploymentType();
					if (jsonarray.length() > 0) {
						jsonObject.put("employmentTypeRoot", jsonarray);
					} else {
						jsonObject.put("employmentTypeRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
		}
        
        
       else if (param.equals("saveAllPanelInformation")) {
            try {
                String customerId = request.getParameter("CustID");

                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String address = request.getParameter("address");
                String permanentAddress = request.getParameter("permanentAddress");
                String city = request.getParameter("city");
                String otherCity = request.getParameter("otherCity");
                String state = request.getParameter("state");
                String country = request.getParameter("country");
                String telephoneNo = request.getParameter("telephoneNo");
                String mobileNo = request.getParameter("mobileNo");
                String dateOfBirth = request.getParameter("dateOfBirth");
                String gender = request.getParameter("gender");
                String nationality = request.getParameter("nationality");
                String maritialStatus = request.getParameter("maritialStatus");

                String employmentType = request.getParameter("employementType");
                String employmentId = request.getParameter("employmentId");
                String client = request.getParameter("client");
                String dateOfJoining = request.getParameter("dateOfJoining");
                String dateOfLeaving = request.getParameter("dateOfLeaving");
                String bloodGroup = request.getParameter("bloodGroup");
                String groupName = request.getParameter("groupName");
                String activeStatus = request.getParameter("activeStatus");
                String remarks = request.getParameter("remarks");
                String governmentOrResidenceId = request.getParameter("governmentResidenceId");
                String governmentOrResidenceIdExpiryDate = request.getParameter("governmentResidenceExpiryDate");
                String rfidCode = request.getParameter("rfidCode");

                String medicalInsuranceNo = request.getParameter("medicalInsuranceId");
                String medicalInsuranceCompany = request.getParameter("medicalInsuranceCompanyName");
                String medicalInsuranceExpiryDate = request.getParameter("medicalinsuranceExpiryDate");

                String licenceNo = request.getParameter("licenceId");
                String licencePlace = request.getParameter("licencePlace");
                String licenceIssueDate = request.getParameter("licenceIssueDate");
                String licenceRenewedDate = request.getParameter("licenceRenewedDate");
                String licenceExpiryDate = request.getParameter("licenceExpiryDate");

                String gunlicenceNo = request.getParameter("gunLicenceId");
                String gunlicenceType = request.getParameter("gunLicenceTypeId");
                String gunlicenceIssueDate = request.getParameter("gunLicenceIssueDate");
                String gunlicenceIssuePlace = request.getParameter("gunLicenceIssuePlace");
                String gunlicenceExpiryDate = request.getParameter("gunLicenceExpiryDate");
                
                String passportNumber=request.getParameter("passportNumber");
                String expiryDate = request.getParameter("passwortExpiryDate");
                String workCompensationId= request.getParameter("workCompensationId"); 
                String workCompensationExpiryDate = request.getParameter("workCompensationExpiryDate");
                String preferedCustomerNames = request.getParameter("preferedCustomerNames");
                if(preferedCustomerNames!=null && !preferedCustomerNames.equals("")){
                preferedCustomerNames = preferedCustomerNames.substring(0,preferedCustomerNames.lastIndexOf(","));
                System.out.println("preferedCustomerNames ======== "+preferedCustomerNames); 
                }
                String message = "";

//                if (customerId != null && !customerId.equals("") && (employmentType.equals("1") ||employmentType.equals("3") || employmentType.equals("4") || employmentType.equals("5") || employmentType.equals("6") || employmentType.equals("7"))) {
//                    message = crewMaster.saveGunMenInformationForAddCrew(firstName, lastName, address, permanentAddress, city, otherCity, state, country, telephoneNo, mobileNo, dateOfBirth, gender, nationality, maritialStatus,
//                        employmentType, employmentId, client, dateOfJoining, dateOfLeaving, bloodGroup, groupName, activeStatus, remarks, governmentOrResidenceId, governmentOrResidenceIdExpiryDate, rfidCode,
//                        medicalInsuranceNo, medicalInsuranceCompany, medicalInsuranceExpiryDate, licenceNo, licencePlace, licenceIssueDate, licenceRenewedDate, licenceExpiryDate,
//                        systemId, Integer.parseInt(customerId), userId, offset,passportNumber,expiryDate,workCompensationId,workCompensationExpiryDate);
//                } 
                if (customerId != null && !customerId.equals("") && employmentType.equals("2")) {
                        message = crewMaster.saveGunMenInformationForAddCrewForGunmen(firstName, lastName, address, permanentAddress, city, otherCity, state, country, telephoneNo, mobileNo, dateOfBirth, gender, nationality, maritialStatus,
                            employmentType, employmentId, client, dateOfJoining, dateOfLeaving, bloodGroup, groupName, activeStatus, remarks, governmentOrResidenceId, governmentOrResidenceIdExpiryDate, rfidCode,
                            medicalInsuranceNo, medicalInsuranceCompany, medicalInsuranceExpiryDate, gunlicenceNo, gunlicenceType, gunlicenceIssueDate, gunlicenceIssuePlace, gunlicenceExpiryDate,
                            systemId, Integer.parseInt(customerId), userId, offset,passportNumber,expiryDate,workCompensationId,workCompensationExpiryDate,preferedCustomerNames);
                } 
                else if (customerId != null && !customerId.equals("")) {
                 message = crewMaster.saveGunMenInformationForAddCrew(firstName, lastName, address, permanentAddress, city, otherCity, state, country, telephoneNo, mobileNo, dateOfBirth, gender, nationality, maritialStatus,
                  employmentType, employmentId, client, dateOfJoining, dateOfLeaving, bloodGroup, groupName, activeStatus, remarks, governmentOrResidenceId, governmentOrResidenceIdExpiryDate, rfidCode,
                  medicalInsuranceNo, medicalInsuranceCompany, medicalInsuranceExpiryDate, licenceNo, licencePlace, licenceIssueDate, licenceRenewedDate, licenceExpiryDate,
                  systemId, Integer.parseInt(customerId), userId, offset,passportNumber,expiryDate,workCompensationId,workCompensationExpiryDate,preferedCustomerNames);
          } 
                response.getWriter().print(message);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return null;
    }
}