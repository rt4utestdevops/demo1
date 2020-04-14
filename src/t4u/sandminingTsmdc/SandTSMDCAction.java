package t4u.sandminingTsmdc;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.admin.UnitDetailsExcelImport;
import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.sandminingTsmdc.SandTSMDCFunction;

public class SandTSMDCAction extends Action{

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		 HttpSession session = request.getSession();
	        String param = "";
	        String zone = "";
	        int systemId = 0;
	        int userId = 0;
	        int offset = 0;
	        int clientId = 0;
	        String message="";
	        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	        SandTSMDCFunction tsmdcFunc = new SandTSMDCFunction();
	        systemId = loginInfo.getSystemId();
	        clientId=loginInfo.getCustomerId();
	        zone = loginInfo.getZone();
	        userId = loginInfo.getUserId();
	        offset = loginInfo.getOffsetMinutes();
	        String lang = loginInfo.getLanguage();
	        zone = loginInfo.getZone();
	        JSONArray jsonArray = null;
	        JSONObject jsonObject = new JSONObject();
	        if (request.getParameter("param") != null) {
	            param = request.getParameter("param").toString();
	        }
	       
	        if (param.equals("getSandVehicleMasterDetails")) {
	        	String jspName=request.getParameter("jspName");
				try {
					jsonObject = new JSONObject();
					ArrayList<Object> vehicleDetails= tsmdcFunc.getSandVehicleMasterDetails(systemId,clientId);
					jsonArray = (JSONArray) vehicleDetails.get(0);
					if (jsonArray.length() > 0){
						jsonObject.put("sandVehicleMasterRoot", jsonArray);
						ReportHelper reportHelper = (ReportHelper) vehicleDetails.get(1);
						request.getSession().setAttribute(jspName, reportHelper);
					} else {
						jsonObject.put("sandVehicleMasterRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
			    }
			}
	        else if(param.equals("getVehicleNoList"))
	        {
	        	try {	            	    		
					jsonObject = new JSONObject();
	    			jsonArray =tsmdcFunc.getVehicleNoList(systemId, clientId);
					if(jsonArray.length()>0)
					{
					jsonObject.put("VehicleStoreRoot", jsonArray);
					}
		    		else 
		    		{
						jsonObject.put("VehicleStoreRoot", "");				}
						response.getWriter().print(jsonObject.toString());
					} 
					catch (Exception e) {
					e.printStackTrace();
				}
	        }
	        else if(param.equals("AddorModifyVehicleDetails"))
	    	{
	    		try
	    		{
	    			String buttonValue = request.getParameter("buttonValue");
	    			String Id = request.getParameter("Id");
	    			String vehicleNo = request.getParameter("vehicleNo");
	    			String tareWeight = request.getParameter("tareWeight");
	    			String rfidNo = request.getParameter("rfidNo");
	    			String chassisNo = request.getParameter("chassisNo");
	    			String ownerName = request.getParameter("ownerName");
	    			String vehicleCapacity = request.getParameter("vehicleCapacity");
	    			
	    			message = "";
	    			if(buttonValue.equals("Add"))
	    			{
	    				message=tsmdcFunc.addVehicleMasterDetails(Integer.parseInt(Id),vehicleNo,tareWeight,rfidNo, systemId,clientId,userId,chassisNo,ownerName,vehicleCapacity);
	    			}
	    			else if(buttonValue.equals("Modify"))
	    			{
	    				message=tsmdcFunc.modifyVehicleMasterDetails(Integer.parseInt(Id),vehicleNo,tareWeight,rfidNo, systemId,clientId,userId);
	    			}
	    			response.getWriter().print(message);
	    		}
	    		catch(Exception e)
	    		{
	    			e.printStackTrace();
	    		}
	    	}
	      //--------t4u445---------------
			else if (param.equalsIgnoreCase("getWeighBridgeRFID")) {
				String ClientId = request.getParameter("CustID");
				String rfidValue=request.getParameter("RFIDValue");
				if (ClientId != null && !ClientId.equals("")) {
					JSONArray jsonarray = null;
					jsonObject = new JSONObject();
					try {
						String ip = request.getRemoteAddr();
						jsonarray = tsmdcFunc.getRFIDForWeighBridge(Integer.parseInt(ClientId) , systemId,rfidValue);
						//String VehicleNo=(String) jsonarray.getJSONObject(0).get("jsonString");
						if (jsonarray.length() > 0) {
							jsonObject.put("vno",jsonarray);
						} else {
							jsonObject.put("vno", "");
						}
						response.getWriter().print(jsonObject.toString());
					} catch (Exception e) {
						e.printStackTrace();
					}
				}

			}
			else if (param.equalsIgnoreCase("saveWeighBridgeData")) {
				try {
					String CustomerId = request.getParameter("CustID");
					String transitPermit=request.getParameter("transitPermit");
					String AssetNo=request.getParameter("vehicleNo");
					String tareWeight=request.getParameter("tareWeight");
					String grossWeight=request.getParameter("grossWeight");
					String netWeight=request.getParameter("netWeight");
					String CustName=request.getParameter("CustName");	
					String transitPassQuantity = request.getParameter("transitPassQuantity");
					String orderId = request.getParameter("orderId");
					String transitPassDate = request.getParameter("transitPassDate");
					message = "";
					
					if(transitPassQuantity == null || transitPassQuantity.isEmpty() || transitPassQuantity.equalsIgnoreCase("")){
						transitPassQuantity ="";
					}  
					if(orderId == null || orderId.isEmpty() || orderId.equalsIgnoreCase("")){
						orderId ="";
					}
					if(transitPassDate == null || transitPassDate.isEmpty() || transitPassDate.equalsIgnoreCase("")){
						transitPassDate ="";
					}  

					if (CustomerId != null || AssetNo != null
							|| tareWeight != null || grossWeight != null) {
						message = tsmdcFunc.saveWeighBridgeInformation(systemId,userId,Integer.parseInt(CustomerId),transitPermit,AssetNo,tareWeight,grossWeight,netWeight,transitPassQuantity,orderId,transitPassDate);
					}
					response.getWriter().print(message);

				} catch (Exception e) {
					e.printStackTrace();
					System.out.println("Error in save Weigh Bridge Data Action:-saveWeighBridgeData"+e.toString());
				}

			}
			else if (param.equals("getSandWeighBridgeDetails")) {
				String custId=request.getParameter("CustId");
				String CustName=request.getParameter("CustName");
	        	String jspName=request.getParameter("jspName");
	        	String startDate=request.getParameter("startDate").replaceAll("T"," ");
	        	String endDate=request.getParameter("endDate");
	        	endDate=endDate.substring(0, endDate.indexOf("T"))+" 23:59:59";
				try {
					jsonObject = new JSONObject();
					if(custId==null || custId=="")
			         {
			         	custId=	String.valueOf(clientId);
			         }
					ArrayList<Object> weightDetails= tsmdcFunc.getSandWeighBridgeDetails(startDate,endDate,systemId,Integer.parseInt(custId));
					jsonArray = (JSONArray) weightDetails.get(0);
					if (jsonArray.length() > 0){
						jsonObject.put("weighBridgeDetailsRoot", jsonArray);
						ReportHelper reportHelper = (ReportHelper) weightDetails.get(1);
						request.getSession().setAttribute(jspName, reportHelper);
						request.getSession().setAttribute("custId", CustName);
				     	request.getSession().setAttribute("startDate", startDate);
				     	request.getSession().setAttribute("endDate", endDate);
					} else {
						jsonObject.put("weighBridgeDetailsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
			    }
			}
			else if (param.equals("getTransitViolationDetails")) {
				String custId=request.getParameter("CustId");
				String CustName=request.getParameter("CustName");
	        	String jspName=request.getParameter("jspName");
	        	String startDate=request.getParameter("startDate").replaceAll("T"," ");
	        	String endDate=request.getParameter("endDate");
	        	endDate=endDate.substring(0, endDate.indexOf("T"))+" 23:59:59";
	        	String reportType = request.getParameter("reportType");
				try {
					jsonObject = new JSONObject();
					if(custId==null || custId=="")
			         {
			         	custId=	String.valueOf(clientId);
			         }
					ArrayList<Object> weightDetails= tsmdcFunc.getTransitViolationDetails(startDate,endDate,systemId,Integer.parseInt(custId),Integer.parseInt(reportType));
					jsonArray = (JSONArray) weightDetails.get(0);
					if (jsonArray.length() > 0){
						jsonObject.put("TransitValidityViolationRoot", jsonArray);
						ReportHelper reportHelper = (ReportHelper) weightDetails.get(1);
						request.getSession().setAttribute(jspName, reportHelper);
						request.getSession().setAttribute("custId", CustName);
				     	request.getSession().setAttribute("startDate", startDate);
				     	request.getSession().setAttribute("endDate", endDate);
					} else {
						jsonObject.put("TransitValidityViolationRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
			    }
			}  
			else if (param.equals("getWeighBridgeViolationDetails")) {
				String custId=request.getParameter("CustId");
				String CustName=request.getParameter("CustName");
	        	String jspName=request.getParameter("jspName");
	        	String startDate=request.getParameter("startDate").replaceAll("T"," ");
	        	String endDate=request.getParameter("endDate");
	        	endDate=endDate.substring(0, endDate.indexOf("T"))+" 23:59:59";
	        	String reportType = request.getParameter("reportType");
				try {
					jsonObject = new JSONObject();
					if(custId==null || custId=="")
			         {
			         	custId=	String.valueOf(clientId);
			         }
					ArrayList<Object> weightDetails= tsmdcFunc.getWeighBridgeViolationDetails(startDate,endDate,systemId,Integer.parseInt(custId),Integer.parseInt(reportType));
					jsonArray = (JSONArray) weightDetails.get(0);
					if (jsonArray.length() > 0){
						jsonObject.put("WeighBridgeViolationRoot", jsonArray);
						ReportHelper reportHelper = (ReportHelper) weightDetails.get(1);
						request.getSession().setAttribute(jspName, reportHelper);
						request.getSession().setAttribute("custId", CustName);
				     	request.getSession().setAttribute("startDate", startDate);
				     	request.getSession().setAttribute("endDate", endDate);
					} else {
						jsonObject.put("WeighBridgeViolationRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
			    }
			} 
			else if (param.equals("getOrderDetailsReport")) {
				String custId=request.getParameter("CustId");
				String CustName=request.getParameter("CustName");
	        	String jspName=request.getParameter("jspName");
	        	String startDate=request.getParameter("startDate").replaceAll("T"," ");
	        	String endDate=request.getParameter("endDate");
	        	endDate=endDate.substring(0, endDate.indexOf("T"))+" 23:59:59";
				try {
					jsonObject = new JSONObject();
					if(custId==null || custId=="")
			         {
			         	custId=	String.valueOf(clientId);
			         }
					ArrayList<Object> weightDetails= tsmdcFunc.getOrderDetailsReport(startDate,endDate,systemId,Integer.parseInt(custId));
					jsonArray = (JSONArray) weightDetails.get(0);
					if (jsonArray.length() > 0){
						jsonObject.put("orderDetailsRoot", jsonArray);
						ReportHelper reportHelper = (ReportHelper) weightDetails.get(1);
						request.getSession().setAttribute(jspName, reportHelper);
						request.getSession().setAttribute("custId", CustName);
				     	request.getSession().setAttribute("startDate", startDate);
				     	request.getSession().setAttribute("endDate", endDate);
					} else {
						jsonObject.put("orderDetailsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
			    }
			} 
			else if(param.equals("maxSerialNo")){
				try{
					
					String custId=request.getParameter("ClientId");
					int no = tsmdcFunc.getMaxSerialNo(systemId,custId);
					response.getWriter().print(no);	
				}
				catch(Exception e){
					e.printStackTrace();
				}
			} 
			else if (param.equalsIgnoreCase("importVehicleDetailsExcel")) {

				String importMessage = "";
				try {
					String messages = "";
					String fileName = null;
					int clientIdInt = 0;
					
					boolean isMultipart = ServletFileUpload.isMultipartContent(request);
					if (isMultipart) {
						FileItemFactory factory = new DiskFileItemFactory();
						ServletFileUpload upload = new ServletFileUpload(factory);
						List items = upload.parseRequest(request);
						Iterator iter = items.iterator();
						Properties properties = ApplicationListener.prop;
						String path = properties.getProperty("ILMSDayWiseDataCapturing").trim()+ "/";
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
											+ "VehicleDetailsImportData-" + systemId
											+ userId + fileExtension;
									uploadedFile = new File(excelPath);

									f = new File(path);
									if (!f.exists()) {
										f.mkdirs();
									}
									item.write(uploadedFile);
								}
								VehicleRegistrationExcelImport dei = new VehicleRegistrationExcelImport(
										uploadedFile, userId, systemId,
										clientIdInt, offset, fileExtension);
								

								importMessage = dei.importExcelData();
								message = dei.getMessage();
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
			else if (param.equalsIgnoreCase("getImportVehicleDetails")) {

				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();

					String fuelImportResponse = request.getParameter("vehicleImportResponse");
					if (fuelImportResponse.equals("{success:true}")) {
						jsonArray = VehicleRegistrationExcelImport.globalJsonArray;
					}
					if (jsonArray.length() > 0) {
						jsonObject.put("VehicleDetailsImportRoot", jsonArray);
					} else {
						jsonObject.put("VehicleDetailsImportRoot", "");
					}
					response.getWriter().print(jsonObject.toString());

				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if(param.equals("openStandardFileFormats")){
				try{
					File stdFile;
					String filename;
					Properties properties = ApplicationListener.prop;
					String path=properties.getProperty("ILMSDayWiseDataCapturing").trim()+"/";
					stdFile = new File(path + "SandVehicleRegistrationStandardFormate.xls");
					filename = "VehicleRegistrationDetails";
					response.setContentType("application/xls");
					response.setHeader("Content-disposition","attachment;filename="+filename+".xls");
					FileInputStream fis = new FileInputStream(stdFile);
					ServletOutputStream servletOutputStream = response.getOutputStream();
					DataOutputStream outputStream = new	DataOutputStream(servletOutputStream);
					byte [] buffer = new byte [1024];
					int len = 0;
					while ( (len = fis.read(buffer)) >= 0 ) 
					{
						outputStream.write(buffer, 0, len);
					}
					outputStream.flush();
					outputStream.close();
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			else if(param.equalsIgnoreCase("saveImportVehicleDetails")){
				String messages = "";
				JSONArray fuelJs = null;
				String saveUnitData = request.getParameter("vehicleDataSaveParam");
				try {
					if (saveUnitData != null && !saveUnitData.equals("")) {
						try {
							fuelJs = new JSONArray(saveUnitData.toString());
								messages = tsmdcFunc.saveVehicleExcelDetails(systemId, userId,clientId, VehicleRegistrationExcelImport.dataMap.get("Valid"));
						} catch (Exception e) {
							e.printStackTrace();
						}
					} else {
						messages = "No Data To Save";
					}
					response.getWriter().print(messages);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
	        
		return null;
	}
	
}
