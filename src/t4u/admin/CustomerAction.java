package t4u.admin;

import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.functions.AdminFunctions;
import t4u.functions.CommonFunctions;

import org.json.JSONArray;
import org.json.JSONObject;

/**
 * 
 * This Class is used to get,save,modify and delete customer details
 *
 */
public class CustomerAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response){
			HttpSession session = request.getSession();
			JSONArray jsonArray = new JSONArray();
			JSONObject jsonObject = new JSONObject();
			AdminFunctions adfunc= new AdminFunctions();
			LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
			int systemId=loginInfo.getSystemId();
			int createdUser=loginInfo.getUserId();
			int customerIdlogged=loginInfo.getCustomerId();
			int userId=loginInfo.getUserId();
			CommonFunctions cf=new CommonFunctions();
			String userName=loginInfo.getUserName();
			String deletedUser=loginInfo.getUserName();
			String systemName=loginInfo.getSystemName();
			String categoryType=loginInfo.getCategoryType();
			String language=loginInfo.getLanguage();
			int offset=loginInfo.getOffsetMinutes();
			int countryCode = loginInfo.getCountryCode();
			String param = "";
			String serverName=request.getServerName();
			String sessionId = request.getSession().getId();
			String jspName=request.getRequestURI();
			System.out.println(serverName+sessionId+' '+jspName);
			if(request.getParameter("param")!=null)
			{
				param=request.getParameter("param").toString();
			}
			
			/**
			 * Saving or modifying Customer Details based on button value and returning the response
			 */
			if(param.equals("saveCustomerDetails")){
				
				try{
					String buttonValue=request.getParameter("buttonValue").trim();
					String custId=request.getParameter("custId").trim();
					String custName= request.getParameter("custName").trim();
					String custNewName="";
					String pageName=request.getParameter("pageName");
					double convertionFactor=adfunc.getUnitOfMeasureConvertionsfactor(systemId);
					if(request.getParameter("custNewName")!=null){
					custNewName=request.getParameter("custNewName").trim();
					}
					String custAddress =request.getParameter("custAddress");
					custAddress = custAddress.toUpperCase();
					String custCity = request.getParameter("custCity");
					custCity = custCity.toUpperCase();
					
					String custState="";
					if(request.getParameter("custState")!=null){
						custState=request.getParameter("custState");
					}
					String custCountry="";
					if(request.getParameter("custCountry")!=null){
					 custCountry=request.getParameter("custCountry");
					}
					String custZipcode="";
					if(request.getParameter("custZipcode")!=null){
					custZipcode=request.getParameter("custZipcode");
					}
					String custPhone =request.getParameter("custPhone");
					
					String custMobile="";
					if(request.getParameter("custMobile")!=null){
					custMobile = request.getParameter("custMobile");
					}
					String custFax = "";
					if(request.getParameter("custFax")!=null)
					{
						custFax=request.getParameter("custFax");
					}
					String custEmail="";
					if(request.getParameter("custEmail")!=null){
					custEmail=request.getParameter("custEmail");
					}
					String custWebsiteString="";
					if(custWebsiteString!=null){
					custWebsiteString=request.getParameter("custWebsite");
					}
					String custStatus =request.getParameter("custStatus");
					String paymentduedate=request.getParameter("custPaymentduedate").trim();
					
					String paymentnotificationperiod="";
					if(request.getParameter("custPaymentNotification").trim()!=null && !request.getParameter("custPaymentNotification").trim().equals("")){
						
					 paymentnotificationperiod=request.getParameter("custPaymentNotification").trim();
					}
					int speedLimit = 10;
					if(request.getParameter("speedLimit").trim()!=null && !request.getParameter("speedLimit").trim().equals("")){
						speedLimit = Integer.parseInt(request.getParameter("speedLimit").trim());
					}
					speedLimit= (int)Math.ceil(speedLimit/convertionFactor);
					
					String snoozeTime = "";
					if(request.getParameter("snoozeTime").trim()!=null && !request.getParameter("snoozeTime").trim().equals("")){
						snoozeTime = request.getParameter("snoozeTime").trim();
					}
					String message=adfunc.saveCustomerDetails(systemId,createdUser,buttonValue,custName,custNewName,custId, custAddress,custCity,custState,custCountry,custZipcode, custPhone, custMobile, custFax,custEmail,custWebsiteString, custStatus,paymentduedate,paymentnotificationperiod,userName,systemName,categoryType,speedLimit,snoozeTime,serverName,sessionId,pageName,userId);
					
					response.getWriter().print(message);	
				}catch(Exception e){
					System.out.println("Error in Customer Action:-saveCustomerDetails "+e.toString());
				}			
			}
			/**
			 * getting country list 
			 */
			else if(param.equals("getCountryList")){
				
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray=adfunc.getCountryList();
					if(jsonArray.length()>0){
					jsonObject.put("CountryRoot", jsonArray);
					}else{
						jsonObject.put("CountryRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					System.out.println("Error in Customer Action:-getCountryList "+e.toString());
				}
				
			}
			/**
			 * getting statelist of particular country
			 */
			else if(param.equals("getStateList")){
				
				String countryId="0";
				if(request.getParameter("countryId")!=null || request.getParameter("countryId").equals("")){
					countryId=request.getParameter("countryId").trim();
				}
				else
				{
					countryId=String.valueOf(countryCode);
				}
				
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					if(!countryId.equals("0")){
					jsonArray=adfunc.getStateList(countryId);
					}
					if(jsonArray.length()>0){
					jsonObject.put("StateRoot", jsonArray);
					}else{
						jsonObject.put("StateRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					System.out.println("Error in Customer Action:-getStateList "+e.toString());
				}
				
			}
			
			/**
			 * Getting customer details and returning the details getCustomerDetails
			 */
			else if(param.equals("getCustomerDetails")){
				
				try{
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray=adfunc.getCustomerDetails(systemId,customerIdlogged);
					if(jsonArray.length()>0){
					jsonObject.put("CustomerDetailsRoot", jsonArray);
					}else{
						jsonObject.put("CustomerDetailsRoot", "");
					}
					
					response.getWriter().print(jsonObject.toString());
				
					cf.insertDataIntoAuditLogReport(sessionId, null, "Master Operation", "View", userId, serverName, systemId, customerIdlogged,
					"Visited This Page");
				}catch(Exception e){
					System.out.println("Error in Customer Action:-getCustomerDetails "+e.toString());
				}
			}
			/**
			 * Deleting customer details and returning the response
			 */
			else if(param.equals("deleteCustomerDetails")){
				try{
					String CustId="0";
					if(request.getParameter("custId")!=null){
						CustId=request.getParameter("custId");
					}
					String pageName=request.getParameter("pageName");
					String custName= request.getParameter("custName").trim();
					String message=adfunc.deleteCustomerDetails(custName,systemId,CustId,deletedUser,systemName,categoryType,pageName,sessionId,serverName,userId);
					response.getWriter().print(message);
				}catch(Exception e){
					System.out.println("Error in Customer Action:-deleteCustomerDetails "+e.toString());
				}
			}
			
			/**
			 * getting all vehicle images from Application Image Folder
			 */
			else if(param.equals("getVehicleImages")){
				try{
					Properties properties = null;
					properties = ApplicationListener.prop;
					String imagePath = properties.getProperty("CustomerSettingGetImagePath");
					String ImageFolderPath=properties.getProperty("CustomerSettingImageFolderPath");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray= adfunc.getVehicleImages(request,imagePath,ImageFolderPath);
					if(jsonArray.length()>0){
					jsonObject.put("vehicleImagesRoot", jsonArray);
					}else{
						jsonObject.put("vehicleImagesRoot", "");
					}
					
					response.getWriter().print(jsonObject.toString());
				}catch(Exception e){
					System.out.println("Error in Customer Action:-getVehicleImages "+e.toString());
				}
			}
			/**
			 * Block & Unblock Customer based on Payment Due
			 */
			else if(param.equals("block_UnblockCustomer")){
				try{
					String custId="0";
					String paymentDue=request.getParameter("paymentDue");
					String pageName=request.getParameter("pageName");
					if(request.getParameter("custId")!=null){
						custId=request.getParameter("custId");
					}
					String message=adfunc.blockUnblockCustomer(systemId,Integer.parseInt(custId),paymentDue,pageName,sessionId,serverName,userId);
					response.getWriter().print(message);
				}catch(Exception e){
					System.out.println("Error in Customer Action:- Changing Pament Due "+e.toString());
				}
			}
			else if(param.equals("getAuditLogReport")){
				try {
					String userIdd=request.getParameter("userId");
					String timeBand=request.getParameter("timeBand");
					if(timeBand!=null){
						jsonArray = adfunc.getAuditLogReport(systemId, customerIdlogged,userIdd,timeBand,offset,serverName);
					}
					
					if(jsonArray.length()>0){
						jsonObject.put("auditReport", jsonArray);
						}else{
							jsonObject.put("auditReport", "");
						}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equals("getUsers")) {
				try {
					jsonArray = new JSONArray();
					jsonArray = adfunc.getUsers(systemId,customerIdlogged);
					response.getWriter().print(jsonArray.toString());
				} catch (Exception e) {
					System.out.println("Error in Common Action:-getCustomer "
							+ e.toString());
				}
			}
			else if (param.equals("getUsers1")) {
				try {
					jsonArray = new JSONArray();
					jsonArray = adfunc.getUsers1(systemId,userId,customerIdlogged);
					response.getWriter().print(jsonArray.toString());
				} catch (Exception e) {
					System.out.println("Error in Common Action:-getCustomer "
							+ e.toString());
				}
			}
			else if (param.equals("getGroupsForTreeView")) {
				try {
					jsonArray = new JSONArray();
					String userIdd=request.getParameter("userId");
					if(userIdd != null && !userIdd.equals("")){
						jsonArray = adfunc.getGroupsForTreeView(systemId,Integer.parseInt(userIdd),customerIdlogged,language);
					}
					response.getWriter().print(jsonArray.toString());
				} catch (Exception e) {
					System.out.println("Error in Common Action:-getUsersForTreeView "
							+ e.toString());
				}
			}
			else if (param.equals("getVehiclesForTreeView")) {
				try {
					jsonArray = new JSONArray();
					String groupId=request.getParameter("groupId");
					jsonArray = adfunc.getVehiclesForTreeView(systemId,userId,groupId);
					response.getWriter().print(jsonArray.toString());
				} catch (Exception e) {
					System.out.println("Error in Common Action:-getUsersForTreeView "
							+ e.toString());
				}
			}
			else if(param.equals("getUserDetails")){
				try {
					jsonObject = new JSONObject();
					String userIdd=request.getParameter("userId");
					if(userIdd != null && !userIdd.equals("")){
						jsonArray = adfunc.getUserDetails(systemId, customerIdlogged,Integer.parseInt(userIdd));
					}
					if (jsonArray.length() > 0) {
						jsonObject.put("DBoardRoot", jsonArray);
					} else {
						jsonObject.put("DBoardRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if(param.equals("getCountryListCreateLandmark")){
				
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					String countryId=request.getParameter("countryId");
					jsonArray=adfunc.getCountryListCreateLandmark(countryId);
					if(jsonArray.length()>0){
					jsonObject.put("CountryRoot", jsonArray);
					}else{
						jsonObject.put("CountryRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					System.out.println("Error in Customer Action:-getCountryList "+e.toString());
				}
				
			}
			return null;
	}

}
