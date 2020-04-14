
	package t4u.ironMining;

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

import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.functions.CommonFunctions;
import t4u.functions.IronMiningFunction;

	public class TripSheetGenerationForTruckAction extends Action{
		private static final Object LOCK = new Object();
		@SuppressWarnings("unchecked")
		public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
			HttpSession session = request.getSession();
			ReportHelper reportHelper = null;
			LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
			int systemId  = loginInfo.getSystemId();
			//int customerId = loginInfo.getCustomerId();
			int userId = loginInfo.getUserId();
			int offset = loginInfo.getOffsetMinutes();
			String lang = loginInfo.getLanguage();
			CommonFunctions cf=new CommonFunctions();
			IronMiningFunction ironfunc = new IronMiningFunction();
			JSONArray jsonArray = null;
			JSONObject jsonObject=null;
			String message="";
			String param = "";
			if (request.getParameter("param") != null) {
				param = request.getParameter("param").toString();
			}
			
			 if (param.equalsIgnoreCase("saveormodifyGenrateTripSheet")) {
				try {
					String buttonValue=request.getParameter("buttonValue");
					String CustomerId = request.getParameter("CustID");
					String type=request.getParameter("type");
					String AssetNo=request.getParameter("vehicleNo");
					String leaseName=request.getParameter("tcLeaseName");
					String quantity=request.getParameter("quantity");
					String validityDateTime=request.getParameter("validityDateTime");
					String gradetype=request.getParameter("gradetype");
					String routeId=request.getParameter("routeId");
					String quantity1= request.getParameter("quantity1");
					String srcHubId=request.getParameter("srcHubId");
					String desHubId=request.getParameter("desHubId");
					String permitNo= request.getParameter("permitNo");
					String pId = request.getParameter("pId");
					String actualQuantity= request.getParameter("actualQuantity");
					String userSettingId = request.getParameter("userSettingId");
					String tripNo = request.getParameter("tripNo");
					String bargeId= request.getParameter("bargeId");
					int orgCode = Integer.parseInt(request.getParameter("orgCode"));
					String bargeQuantity = request.getParameter("bargeQuantity");
					String rsSource = request.getParameter("rsSource");
					String rsDestination = request.getParameter("rsDestination");
					String transactionNo = request.getParameter("transactionNo");
					String bargeNo = request.getParameter("bargeNo");
					String bargeCapacity="0";
					String tripSheetType="";
					String nonCommHrs=request.getParameter("nonCommHrs");
					message = "";
					if(request.getParameter("tripSheetType")!=null && !request.getParameter("tripSheetType").equals("")){
						tripSheetType=request.getParameter("tripSheetType");
					}
					if(request.getParameter("bargeCapacity")!=null && !request.getParameter("bargeCapacity").equals("")){
						bargeCapacity=request.getParameter("bargeCapacity");
					}
					if (buttonValue.equals("add")) {

							if (CustomerId != null || AssetNo != null
									|| leaseName != null || quantity != null || gradetype != null
									|| routeId != null ) {
								synchronized (LOCK) {
								message = ironfunc.saveTripSheetDetailsInformationForTruck(Integer.parseInt(CustomerId),type,AssetNo,leaseName,quantity,validityDateTime,
										routeId,userId,systemId,quantity1,srcHubId,desHubId,permitNo,Integer.parseInt(pId),Float.parseFloat(actualQuantity),Integer.parseInt(userSettingId),orgCode,gradetype,tripNo,Integer.parseInt(bargeId),Float.parseFloat(bargeQuantity),tripSheetType,rsSource,rsDestination,transactionNo,bargeNo,Float.parseFloat(bargeCapacity),nonCommHrs);
								}
							}
					}
					response.getWriter().print(message);

				} catch (Exception e) {
					e.printStackTrace();
					System.out.println("Error in Mining Trip Generation Action:-saveORmodifyDetails"+e.toString());
				}

			}	
		   
		   else if (param.equalsIgnoreCase("getMiningTripSheetDetails")) {
				try {
					ArrayList list=null;
					String jspName=request.getParameter("jspName");
					String CustomerId = request.getParameter("CustID");
					String bargeId = request.getParameter("bargeId");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					if (CustomerId != null && !CustomerId.equals("")) {
						list =ironfunc.getTripSheetDetailsForTruck(systemId, Integer.parseInt(CustomerId),userId,Integer.parseInt(bargeId));
						jsonArray = (JSONArray) list.get(0);
						if (jsonArray.length() > 0) {
							jsonObject.put("miningTripSheetDetailsRoot", jsonArray);
						} else {
							jsonObject.put("miningTripSheetDetailsRoot", "");
						}
						reportHelper = (ReportHelper) list.get(1);
						request.getSession().setAttribute(jspName,reportHelper);
						//request.getSession().setAttribute("custId", customerName);
						response.getWriter().print(jsonObject.toString());
					} else {
						jsonObject.put("miningTripSheetDetailsRoot", "");
						response.getWriter().print(jsonObject.toString());
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		   
			else if (param.equalsIgnoreCase("closeTrip")) {
				try {
					
					String CustomerId = request.getParameter("CustID");
					String assetNo=request.getParameter("assetNo");
					String tripSheetNo=request.getParameter("tripSheetNo");
					message = "";
					
						if (CustomerId != null || assetNo != null){
							message = ironfunc.closeTripForBarge(Integer.parseInt(CustomerId),assetNo,tripSheetNo,userId,systemId);
						}
					response.getWriter().print(message);

				} catch (Exception e) {
					e.printStackTrace();
					System.out.println("Error in Mining Trip Generation Action:-saveORmodifyDetails"+e.toString());
				}
			}	
		   
			else if (param.equalsIgnoreCase("getRFID")) {
				String ClientId = request.getParameter("CustID");
				String rfidValue=request.getParameter("RFIDValue");
				if (ClientId != null && !ClientId.equals("")) {
					JSONArray jsonarray = null;
					jsonObject = new JSONObject();
					try {
						String ip = request.getRemoteAddr();
						jsonarray = ironfunc.getRFIDForBarge(ClientId, systemId,rfidValue,userId);
						if (jsonarray.length() > 0) {
							jsonObject.put("tripRoot",jsonarray);
						} else {
							jsonObject.put("tripRoot", "");
						}
						response.getWriter().print(jsonObject.toString());
					} catch (Exception e) {
						e.printStackTrace();
					}
				}

			}
			
			else if (param.equalsIgnoreCase("getBargeQuantity")) {
				String ClientId = request.getParameter("CustID");
			//	int bargeId = Integer.parseInt(request.getParameter("bargeId")) ;
				String bargeNo = request.getParameter("bargeNo");
					if (ClientId != null && !ClientId.equals("")) {
					JSONArray jsonarray = null;
					jsonObject = new JSONObject();
					try {
						jsonarray = ironfunc.getBargeQuantity(ClientId, systemId,bargeNo);
						if (jsonarray.length() > 0) {
							jsonObject.put("bargeRoot",jsonarray);
						} else {
							jsonObject.put("bargeRoot", "");
						}
						response.getWriter().print(jsonObject.toString());
					} catch (Exception e) {
						e.printStackTrace();
					}
				}

			}
			 
			 if (param.equalsIgnoreCase("getVehicleList")) {
					String ClientId = request.getParameter("CustId");
					if (ClientId != null && !ClientId.equals("")) {
						JSONArray jsonarray = null;
						jsonObject = new JSONObject();
						try {
							jsonarray = ironfunc.getVehicleNoListForTruck(ClientId, systemId);
							if (jsonarray.length() > 0) {
								jsonObject.put("vehicleComboStoreRoot", jsonarray);
							} else {
								jsonObject.put("vehicleComboStoreRoot", "");
							}
							response.getWriter().print(jsonObject.toString());
						} catch (Exception e) {
							e.printStackTrace();
						}
					}

				}
			 
				else if (param.equalsIgnoreCase("getPermitNo")) {
					String ClientId = request.getParameter("CustID");
					if (ClientId != null && !ClientId.equals("")) {
						JSONArray jsonarray = null;
						jsonObject = new JSONObject();
						try {
							jsonarray = ironfunc.getPermitNoForTruckTripSheet(ClientId, systemId,userId);
							if (jsonarray.length() > 0) {
								jsonObject.put("permitRoot", jsonarray);
							} else {
								jsonObject.put("permitRoot", "");
							}
							response.getWriter().print(jsonObject.toString());
						} catch (Exception e) {
							e.printStackTrace();
						}
					}

				}
			 
				else if (param.equalsIgnoreCase("importTripDetailsExcel")) {

					String importMessage = "";
					try {
						String messages = "";
						String fileName = null;
						String bargeNo="";
						String bargeCapacit="";
						float bargeCapacity=0;
						String clientId="";
						String bargeLocation="";
						int bargeLocationId=0;
						int clientIdint=0;
						String orgId="";
						int orgIdI=0;
						if(session.getAttribute("bargeNo")!=null){
						  bargeNo=session.getAttribute("bargeNo").toString();
						}if(session.getAttribute("bargeCapacity")!=null){
							bargeCapacit=session.getAttribute("bargeCapacity").toString();
						}
						if(bargeCapacit!=null || bargeCapacit!= ""){
							bargeCapacity = Float.parseFloat(bargeCapacit);
						}
						if(session.getAttribute("clientId")!=null){
							clientId=session.getAttribute("clientId").toString();
						}
						if(clientId!="" || clientId!=null){
							clientIdint=Integer.parseInt(clientId);
						}
						if(session.getAttribute("bargeLocation")!=null){
							bargeLocation=session.getAttribute("bargeLocation").toString();
						}
						
						if(bargeLocation!="" || bargeLocation!=null){
							bargeLocationId=Integer.parseInt(bargeLocation);
						}
						
						if(session.getAttribute("orgId")!=null){
							orgId=session.getAttribute("orgId").toString();
						}
						if(orgId!="" || orgId!=null){
							orgIdI=Integer.parseInt(orgId);
						}
						boolean isMultipart = ServletFileUpload.isMultipartContent(request);
						if (isMultipart) {
							FileItemFactory factory = new DiskFileItemFactory();
							ServletFileUpload upload = new ServletFileUpload(factory);
							List items = upload.parseRequest(request);
							Iterator iter = items.iterator();
							Properties properties = ApplicationListener.prop;
							String path = properties.getProperty("TempFileDownloadPath").trim()+ "/";
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
												+ "TripDetailsImportData-" + systemId
												+ userId + fileExtension;
										uploadedFile = new File(excelPath);

										f = new File(path);
										if (!f.exists()) {
											f.mkdirs();
										}
										item.write(uploadedFile);
									}
									TripDetailsExcelImport dei = new TripDetailsExcelImport(
											uploadedFile, userId, systemId,
											clientIdint, offset, fileExtension,bargeNo,bargeCapacity,orgIdI,bargeLocationId);
									

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
				else if (param.equalsIgnoreCase("getImportTripDetails")) {

					try {
						jsonArray = new JSONArray();
						jsonObject = new JSONObject();

						String fuelImportResponse = request.getParameter("simImportResponse");
						if (fuelImportResponse.equals("{success:true}")) {
							jsonArray = TripDetailsExcelImport.globalJsonArray;
						}
						if (jsonArray.length() > 0) {
							jsonObject.put("TripDetailsImportRoot", jsonArray);
						} else {
							jsonObject.put("TripDetailsImportRoot", "");
						}
						response.getWriter().print(jsonObject.toString());

					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			 
				else if(param.equalsIgnoreCase("saveImportTripDetails")){
					String messages = "";
					String saveTripData = request.getParameter("tripDataSaveParam");
					String customerId = request.getParameter("custId");
					String bargeId = request.getParameter("bargeId");
					String bargeNo = request.getParameter("bargeNo");
					String tripNo = request.getParameter("tripNo");
					int userSettingId = Integer.parseInt(request.getParameter("userSettingId"));
					int desHubId = Integer.parseInt(request.getParameter("desHubId"));
					int srcHubId = Integer.parseInt(request.getParameter("srcHubId"));
					float bargecapacity = Float.parseFloat(request.getParameter("bargeCapacity"));
					try {
						if (saveTripData != null && !saveTripData.equals("")) {
							JSONArray fuelJs = null;
							try {
								fuelJs = new JSONArray(saveTripData.toString());
									messages = ironfunc.saveTripSheetDetailsInformationForImport(systemId,Integer.parseInt(customerId) ,userId,fuelJs,Integer.parseInt(bargeId),bargecapacity,bargeNo,tripNo,userSettingId,srcHubId,desHubId);
							} catch (Exception e) {
								e.printStackTrace();
							}
						} else {
							messages = "No Trip Data To Save";
						}
						response.getWriter().print(messages);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			 
			 if(param.equals("openStandardFileFormats")){
					try{
						File stdFile;
						String filename;
						Properties properties = ApplicationListener.prop;
						String path=properties.getProperty("TempFileDownloadPath").trim()+"/";
						stdFile = new File(path + "StandardFormatImportTripSheet.xls");
						filename = "TripSheetDetails";
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
			 
			 else if (param.equalsIgnoreCase("cancelBargeTruckTrip")) {
					String customerId = request.getParameter("CustID");
					String id = request.getParameter("id");
					String permitNo = request.getParameter("permitNo");
					String tcId="0";
					String routeId="0";
					String assetNo =request.getParameter("assetNo");
					String remark=request.getParameter("remark");
					if(request.getParameter("tcId")!=null && !request.getParameter("tcId").equals("")){
					   tcId = request.getParameter("tcId");
					}
					if(request.getParameter("routeId")!=null && !request.getParameter("routeId").equals("")){
						routeId = request.getParameter("routeId");
					}
					String message1="";
					if (customerId != null && !customerId.equals("") && id != null && !id.equals("")) {
						try {
							synchronized (LOCK) {
							message1 = ironfunc.cancelBargeTruckTrip(customerId, systemId,userId,id,permitNo,Integer.parseInt(tcId),Integer.parseInt(routeId),assetNo,remark);
							response.getWriter().print(message1);
							}
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}
			 
			return null;
		}
	

}
