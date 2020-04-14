package t4u.consignment;

import java.util.ArrayList;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;

import java.util.Iterator;
import java.util.List;

import java.util.StringTokenizer;

import javax.servlet.ServletOutputStream;


import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;



import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.functions.BookingCustomerFunctions;
import t4u.functions.CommonFunctions;

public class BookingCustomerAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception {
		
		String param = "";
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId=0;
		int customerID = 0;	
		int userID=0;
		int offmin=0;
		String lang="";
		int isLtsp=2;
		String zone=null;
		if(loginInfo!=null)
		{
		systemId = loginInfo.getSystemId();
		customerID = loginInfo.getCustomerId();		
		userID=loginInfo.getUserId();
		offmin=loginInfo.getOffsetMinutes();
		lang=loginInfo.getLanguage();
		isLtsp=loginInfo.getIsLtsp();
		zone=loginInfo.getZone();
		}
        String typeOfVehicle="All";
		BookingCustomerFunctions BookingCustFunc = new BookingCustomerFunctions();
		CommonFunctions cf = new CommonFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		//int prcessId=commonFunctions.getProcessID(systemId, customerID);
		int prcessId=0;
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		
		if (param.equalsIgnoreCase("bookingCustomerAddAndModify")) {
	        try {
	            String buttonValue = request.getParameter("buttonValue");
	        	String custId = request.getParameter("custId");
	        	String customerId=request.getParameter("customerId");
	        	String name = request.getParameter("name");
	        	String email = request.getParameter("email");
	        	String phone = request.getParameter("phone");
	        	String mobile = request.getParameter("mobile");
	        	String fax = request.getParameter("fax");
	        	String tin = request.getParameter("tin");
	        	String address = request.getParameter("address");
	        	String city = request.getParameter("city");
	        	String userName = request.getParameter("usernameId");
	        	String password = request.getParameter("password");
	        	String state = request.getParameter("state");
	        	String region = request.getParameter("region");
	        	String status = request.getParameter("status");
	        	String uniqueId = request.getParameter("id");
	        	String selectedCustomerId = request.getParameter("selectedCustomerId");
	        	String selectedCustomerName = request.getParameter("selectedCustomerName");
	        	String selectedEmail = request.getParameter("selectedEmail");
	        	String selectedPhoneNo = request.getParameter("selectedPhoneNo");
	        	String selectedMobileNo = request.getParameter("selectedMobileNo");
	        	String selectedFax = request.getParameter("selectedFax");
	        	String selectedTin = request.getParameter("selectedTin");
	        	String selectedAddress = request.getParameter("selectedAddress");
	        	String selectedCity = request.getParameter("selectedCity");
	        	String selectedState = request.getParameter("selectedState");
	        	String selectedRegion = request.getParameter("selectedRegion");
	        	String selectedStatus = request.getParameter("selectedStatus");
	        	String selectedUserName  = request.getParameter("selectedUserName");
	        	String selectedPassword  = request.getParameter("selectedPassword");

	        	
	            String message="";
	            if (buttonValue.equals("Add") && custId != null && !custId.equals("")) {
	                message = BookingCustFunc.insertCustomerInformation(Integer.parseInt(custId),customerId,name,email,phone,mobile,fax,tin,address,city,userName,password,state,region,status,userID,systemId);
	            } else if (buttonValue.equals("Modify") && custId != null && !custId.equals("")) {
	            	       message = BookingCustFunc.modifyCustomerInformation(Integer.parseInt(custId),selectedCustomerId,selectedCustomerName,selectedEmail,selectedPhoneNo,selectedMobileNo,
	            	    		   selectedFax,selectedTin,selectedAddress,selectedCity,selectedUserName,selectedPassword,selectedState,selectedRegion,selectedStatus,systemId,Integer.parseInt(uniqueId),userID);
	            }
	            response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
		
		
		 else if (param.equalsIgnoreCase("getBookingCustomerReport")) {
		        try {
		            String custId = request.getParameter("CustId");
		             jsonArray = new JSONArray();
		            if (custId != null && !custId.equals("")) {
		                ArrayList < Object > list1 = BookingCustFunc.getBookingCustomerReport(Integer.parseInt(custId),systemId,userID);
		                jsonArray = (JSONArray) list1.get(0);
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("bookingCustomerRoot", jsonArray);
		                } else {
		                    jsonObject.put("bookingCustomerRoot", "");
		                }
			         	response.getWriter().print(jsonObject.toString());
		            } else {
		                jsonObject.put("bookingCustomerRoot", "");
		                response.getWriter().print(jsonObject.toString());
		            }
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }
		
		
		 else if (param.equalsIgnoreCase("getDealers")){
			 try{
				 	jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = BookingCustFunc.getDealers(systemId);
					if(jsonArray.length() > 0){
						jsonObject.put("DealerRoot", jsonArray);
					}else{
						jsonObject.put("DealerRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
		            
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
			 }
		
		 else if (param.equalsIgnoreCase("getConsignmentTrackingUsageReport")){
			 try{
				 String dealerId = request.getParameter("DealerId");
				 String startDate = request.getParameter("startdate");
				 String endDate = request.getParameter("enddate");
				 String jspName=request.getParameter("jspName");
				 jsonArray = new JSONArray();
				 if (dealerId != null && !dealerId.equals("")) {
		                ArrayList < Object > list1 = BookingCustFunc.getConsignmentTrackingUsageReport(Integer.parseInt(dealerId),systemId,offmin,startDate,endDate);
		                jsonArray = (JSONArray) list1.get(0);
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("ConsignmentRequestRoot", jsonArray);
		                } else {
		                    jsonObject.put("ConsignmentRequestRoot", "");
		                }
		                ReportHelper reportHelper = (ReportHelper) list1.get(1);
		                request.getSession().setAttribute(jspName, reportHelper);
		                request.getSession().setAttribute("startdate",cf.getFormattedDateddMMYYYY(startDate.replaceAll("T", " ")));
						request.getSession().setAttribute("enddate",cf.getFormattedDateddMMYYYY(endDate.replaceAll("T", " ")));
						response.getWriter().print(jsonObject.toString());
		            } else {
		                jsonObject.put("ConsignmentRequestRoot", "");
		                response.getWriter().print(jsonObject.toString());
		            }
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
			 }
		
		 else if(param != null && param.equals("importBookConsignmentExcel")){
			 String importMessage = "";
				try {
					String message = "";
					String fileName = null;
					int clientIdInt = 0;
					String customerId = request.getParameter("importCustomerId");
					if (customerId != null) {
						clientIdInt = Integer.parseInt(customerId);
					}
					boolean isMultipart = ServletFileUpload.isMultipartContent(request);
					if (isMultipart) {
						FileItemFactory factory = new DiskFileItemFactory();
						ServletFileUpload upload = new ServletFileUpload(factory);
						List items = upload.parseRequest(request);
						Iterator iter = items.iterator();
						Properties properties = ApplicationListener.prop;
						String path = properties
								.getProperty("TempFileDownloadPath").trim()
								+ "/";
						while (iter.hasNext()) {
							FileItem item = (FileItem) iter.next();
							String fileExtension = "";
							if (!item.isFormField()) {
								File uploadedFile = null;
								File f = null;
								if (item.getName() != "") {
									fileName = item.getName();
									fileExtension = fileName.substring(
											fileName.lastIndexOf("."), fileName
													.length());

									String excelPath = path
											+ "BookConsignmentImportData-" + systemId
											+ userID + fileExtension;
									uploadedFile = new File(excelPath);

									f = new File(path);
									if (!f.exists()) {
										f.mkdirs();
									}
									item.write(uploadedFile);
								}
								BookConsignmentImportExcel dei = new BookConsignmentImportExcel(
										uploadedFile, userID, systemId,
										clientIdInt, offmin, fileExtension);
								importMessage = dei.importData();
								message = dei.getMessage();
								// message = importData(uploadedFile,
								// userId,systemId, clientIdInt, offset);
								File errorFile = new File(path
										+ "BookingCustomerLogFile" + systemId + userID
										+ ".txt");
								writeMessageToTextFile(message, errorFile);
								deleteFile(uploadedFile);
							}
						}
					} else {
						System.out.println("Request Does Not Support Multipart");
					}
					if (importMessage.equals("Success")) {
						response.getWriter().print("{success:true}");
					} else {
						response.getWriter().print("{success:false}");
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		 else if (param.equalsIgnoreCase("openLogFile")) {
				try {

					Properties properties = ApplicationListener.prop;
					String path = properties.getProperty("TempFileDownloadPath").trim()+ "/";
					File errorFile = new File(path + "BookingCustomerLogFile"+ systemId + userID + ".txt");
					String filename = "lastLog";
					response.setContentType("application/txt");
					response.setHeader("Content-disposition","attachment;filename=" + filename + ".txt");
					FileInputStream fis = new FileInputStream(errorFile);
					ServletOutputStream servletOutputStream = response.getOutputStream();
					DataOutputStream outputStream = new DataOutputStream(servletOutputStream);
					byte[] buffer = new byte[1024];
					int len = 0;
					while ((len = fis.read(buffer)) >= 0) {
						outputStream.write(buffer, 0, len);
					}
					outputStream.flush();
					outputStream.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		 else if (param.equalsIgnoreCase("getImportConsignmentDetails")) {

				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();

					String fuelImportResponse = request.getParameter("consignmentImportResponse");
					if (fuelImportResponse.equals("{success:true}")) {
						jsonArray = BookConsignmentImportExcel.globalJsonArray;
					}
					if (jsonArray.length() > 0) {
						jsonObject.put("ConsignmentBookingRoot", jsonArray);
					} else {
						jsonObject.put("ConsignmentBookingRoot", "");
					}
					response.getWriter().print(jsonObject.toString());

				} catch (Exception e) {
					e.printStackTrace();
				}
		 }
		
		
	   	 else if (param.equalsIgnoreCase("loginDetails")) {
	  	        try {
	  	              String userId =request.getParameter("userId");
	  				  String password = request.getParameter("password");
	  				  String  message="";
	   	              message = BookingCustFunc.checkLoginDetails(userId,password,systemId);
	     	            response.getWriter().print(message);
	  	        } catch (Exception e) {
	  	            e.printStackTrace();
	  	        }
	  	    }
			
	    	 else if (param.equals("toGetLoginDetailsData")) {
	             try {
	                 jsonArray = new JSONArray();
	                 jsonObject = new JSONObject();
	                 String userId =request.getParameter("userId");
	                 if (userId != null && !userId.equals("")) {
	                     jsonArray = BookingCustFunc.toGetLoginDetailsData(userId);
	                     if (jsonArray.length() > 0) {
	                         jsonObject.put("dashBoardDataRoot", jsonArray);
	                     } else {
	                         jsonObject.put("dashBoardDataRoot", "");
	                     }
	                 }else {
	                     jsonObject.put("dashBoardDataRoot", "");
	                 }
	                 response.getWriter().print(jsonObject.toString());
	             } catch (Exception e) {
	                 e.printStackTrace();
	             }
	         } 
				
		
		
		return null;
	}
	
	
public void writeMessageToTextFile(String message,File errorFile){
		
		try{
			PrintWriter pw = new PrintWriter(errorFile);
			
			StringTokenizer st = new StringTokenizer(message,"\n");
			while(st.hasMoreElements()){
				String line = st.nextToken();
				pw.println(line);
				pw.println(".....................................................................................");
			}
			pw.flush();
			pw.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}

public void deleteFile(File uploadedFile){
	if(uploadedFile.exists()){
		uploadedFile.delete();
	}
}


	
  }
