package t4u.sandmining;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.functions.AdminFunctions;
import t4u.functions.CommonFunctions;
import t4u.functions.SandMiningPermitFunctions;

public class ConsumerMDPGeneratorAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		String param = "";
		String zone = "";
		int systemId = 0;
		int clientID = 0;
		int userId = 0;
		int offset = 0;
		String message="";
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		AdminFunctions adfunc = new AdminFunctions();
		SandMiningPermitFunctions smpf = new SandMiningPermitFunctions();
		systemId = loginInfo.getSystemId();
		clientID = loginInfo.getCustomerId();
		zone = loginInfo.getZone();
		userId = loginInfo.getUserId();
		offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		String ltspName = loginInfo.getSystemName();
		String userName = loginInfo.getUserName();
		CommonFunctions cf = new CommonFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if(param.equals("getVehicleNoGRID")){
			try{
				String clientId=request.getParameter("clientId");
				String type=request.getParameter("type");
				jsonObject =new JSONObject();
				jsonArray = smpf.getVehicleGRID(systemId,clientId,type,userId,offset);
				jsonObject.put("vehicleNoRoot", jsonArray);
				response.getWriter().print(jsonObject.toString());	
			}
			catch(Exception e){
				e.printStackTrace();
			}
		} else  if (param.equals("getFromSandPortStore")) {
			 try{
					String clientId=request.getParameter("clientId");
					String appNo=request.getParameter("appNo");
					jsonObject =new JSONObject();
					jsonArray = smpf.getFromSandPortStore(systemId,clientId,userId,appNo);
					jsonObject.put("FromSandPortStoreList", jsonArray);
					response.getWriter().print(jsonObject.toString());	
				}
				catch(Exception e){
					e.printStackTrace();
				}
		} else  if (param.equals("getFromSandPortDetailsStore")) {
			 try{
					String clientId=request.getParameter("clientId");
					String portname=request.getParameter("portname");
					String applicationNo=request.getParameter("applicationNo");
					jsonObject =new JSONObject();
					jsonArray = smpf.getFromSandPortDetailsStore(systemId,clientId,portname,applicationNo);
					jsonObject.put("FromSandPortDetailsStoreList", jsonArray);
					response.getWriter().print(jsonObject.toString());	
				}
				catch(Exception e){
					e.printStackTrace();
				}
		} else if (param.equals("getToPlaceStore")) {
			 try{
					String clientId=request.getParameter("clientId");
					jsonObject =new JSONObject();
					jsonArray = smpf.getToPlaceStore(systemId,clientId,userId);
					jsonObject.put("ToPlaceStoreList", jsonArray);
					response.getWriter().print(jsonObject.toString());	
				}
				catch(Exception e){
					e.printStackTrace();
				}
		} else if(param.equals("getTSDetailsGRID"))
		{
		 
			String clientIdFromJsp = request.getParameter("ClientId");
			String custName = request.getParameter("custname");
			String jspName="";
			try{
				JSONArray jsonArray1 = new JSONArray(); 
				JSONObject jsonObject1 = new JSONObject();
				 if(request.getParameter("jspname")!=null)
		         jspName=request.getParameter("jspname");
				 
				ArrayList finlist = smpf.getTSDetailsGRID_Kan_Shimoga(systemId,clientIdFromJsp,offset,userId);
				jsonArray1= (JSONArray) finlist.get(0);
				if(jsonArray1.length()>0)
				{
					jsonObject1.put("newGridRoot", jsonArray1);
				} else {
					jsonObject1.put("newGridRoot", "");
				}
					
				ReportHelper reportHelper=(ReportHelper)finlist.get(1);
				request.getSession().setAttribute(jspName,reportHelper);
				request.getSession().setAttribute("custId", custName);
				response.getWriter().print(jsonObject1.toString());
	        	}
			catch(Exception e)
			{
				System.out.println("Error in getting Master Details:"+e.toString());
				e.printStackTrace();
	        }
			
		} else if(param.equals("getRoyalityStoreStore")){
			 try{
				 String portname=request.getParameter("portname");
				 jsonObject =new JSONObject();
				 jsonArray=smpf.getRoyalityStoreStore(systemId,portname);
				 jsonObject.put("RoyalityStoreStoreList", jsonArray);
				 response.getWriter().print(jsonObject.toString());
			 }catch(Exception e){
				 
			 }
			 
		 }else if(param.equals("getApplicationNo")){
			 try{
				 String clientId=request.getParameter("clientId");
				 jsonObject =new JSONObject();
				 jsonArray=smpf.getApplicationNoStore(systemId,clientId,userId);
				 jsonObject.put("ApplicationNoStoreList", jsonArray);
				 response.getWriter().print(jsonObject.toString());
			 }catch(Exception e){
				 
			 }
			 
		 } else if(param.equals("saveGRID"))
		    {
			 try {
				 String buttonValue=request.getParameter("buttonValue");
				 String custId= request.getParameter("custId");
				 String mdpNoAdd = request.getParameter("mdpNoAdd");
				 String permitNoAdd = request.getParameter("permitNoAdd");
				 String transporterNameAdd = request.getParameter("transporterNameAdd");
				 String loadingTypeAdd = request.getParameter("loadingTypeAdd");
				 String surveyNoAdd = request.getParameter("surveyNoAdd");
				 String villageAdd = request.getParameter("villageAdd");
				 String talukAdd = request.getParameter("talukAdd");
				 String districtAdd = request.getParameter("districtAdd");
				 String quantityAdd = request.getParameter("quantityAdd");
				 String amountAdd = request.getParameter("amountAdd");
				 String totalFeeAdd = request.getParameter("totalFeeAdd");
				 String fromPlaceAdd = request.getParameter("fromPlaceAdd");
				 String toPlaceAdd = request.getParameter("toPlaceAdd");
				 String sandPortNoAdd = request.getParameter("sandPortNoAdd");
				 String sandPortUniqueIdAdd = request.getParameter("sandPortUniqueIdAdd");
				 String validFromAdd = request.getParameter("validFromAdd");
				 String distanceAdd = request.getParameter("distanceAdd");
				 String validToAdd = request.getParameter("validToAdd");
				 String customerNameAdd =request.getParameter("customerNameAdd");
				 String customerMobileAdd =request.getParameter("customerMobileAdd");
				 String driverNameAdd = request.getParameter("driverNameAdd");
				 String viaRouteAdd = request.getParameter("viaRouteAdd");
				 String mineralTypeAdd = request.getParameter("mineralTypeAdd");
                 String applicationNoAdd = request.getParameter("applicationNoAdd");
                 String validityPeriodAdd =request.getParameter("validityPeriodAdd");
				 String transporterAdd = request.getParameter("transporterAdd");
                 //String MlNoModify = request.getParameter("custId");
				 String processingFeeAdd = request.getParameter("processingFeeAdd");
				 String vehicleAddrAdd = request.getParameter("vehicleAddrAdd");
				 String printedAdd = request.getParameter("printedAdd");
				 String TSDateAdd = request.getParameter("TSDateAdd");
				 String DDNoAdd = request.getParameter("DDNoAdd");
				 String bankNameAdd = request.getParameter("bankNameAdd");
				 String DDDateAdd =request.getParameter("DDDateAdd");
				 String groupIdAdd = request.getParameter("groupIdAdd");
				 String groupNameAdd = request.getParameter("groupNameAdd");
				 String vehicleNoAdd = request.getParameter("vehicleNoAdd");
				 String SandLoadingFromTimeAdd = request.getParameter("SandLoadingFromTimeAdd");
                 String SandLoadingToTimeAdd = request.getParameter("SandLoadingToTimeAdd");
                 String sandExtraction=request.getParameter("sandExtraction");
                 String fromstockyard=request.getParameter("fromstockyard");
                 String fromstockyardId=request.getParameter("fromstockyardId");
                 
				 String mineralTypeModify = request.getParameter("mineralTypeModify");
				 String uniqueIdModify = request.getParameter("uniqueIdModify");
				 String validityPeriodModify = request.getParameter("validityPeriodModify");
				 String transporterModify = request.getParameter("transporterModify");
				 //String MlNoModify = request.getParameter("MlNoModify");
				 String processingFeeModify = request.getParameter("processingFeeModify");
				 String vehicleAddrModify = request.getParameter("vehicleAddrModify");
				 String printedModify = request.getParameter("printedModify");
				 String TSDateModify = request.getParameter("TSDateModify");
				 String DDNoModify = request.getParameter("DDNoModify");
				 String bankNameModify = request.getParameter("bankNameModify");
				 String DDDateModify = request.getParameter("DDDateModify");
				 String groupIdModify = request.getParameter("groupIdModify");
				 String groupNameModify = request.getParameter("groupNameModify");
				 String vehicleNoModify = request.getParameter("vehicleNoModify");
				 String SandLoadingFromTimeModify = request.getParameter("SandLoadingFromTimeModify");
                 String SandLoadingToTimeModify = request.getParameter("SandLoadingToTimeModify");
                 String quantityModify = request.getParameter("quantityModify");
                 String sandportUniqueidModify=request.getParameter("sandportUniqueidModify");
                 String extractionTypeModify=request.getParameter("extractionTypeModify");
                 String latitude=request.getParameter("latitude");
                 String longitude=request.getParameter("longitude");
             
				 if(buttonValue.equals("Add"))
				    {
				    	message = smpf.insert_TS_GRID_Kan(uniqueIdModify,mdpNoAdd,permitNoAdd,transporterNameAdd,amountAdd,vehicleNoAdd,fromPlaceAdd,toPlaceAdd,validFromAdd,printedAdd,systemId,custId,offset,surveyNoAdd,villageAdd,talukAdd,mineralTypeAdd,quantityAdd,processingFeeAdd,totalFeeAdd,transporterAdd,validToAdd,TSDateAdd,userId,vehicleAddrAdd,sandPortNoAdd,loadingTypeAdd,DDNoAdd,bankNameAdd,DDDateAdd,groupIdAdd,groupNameAdd,driverNameAdd,viaRouteAdd,sandPortUniqueIdAdd,SandLoadingFromTimeAdd,SandLoadingToTimeAdd,customerNameAdd,applicationNoAdd,validityPeriodAdd,sandPortUniqueIdAdd,sandExtraction,fromstockyard,fromstockyardId,distanceAdd,latitude,longitude,customerMobileAdd);
				    }
				    else
				    {
				    	message = smpf.update_TS_GRID_Kan(uniqueIdModify,mdpNoAdd,permitNoAdd,transporterNameAdd,amountAdd,vehicleNoModify,fromPlaceAdd,toPlaceAdd,validFromAdd,printedModify,systemId,custId,offset,surveyNoAdd,villageAdd,talukAdd,mineralTypeModify,quantityAdd,processingFeeModify,totalFeeAdd,transporterModify,validToAdd,TSDateModify,userId,districtAdd,vehicleAddrModify,sandPortNoAdd,validityPeriodModify,loadingTypeAdd,DDNoModify,bankNameModify,DDDateModify,groupIdModify,groupNameModify,driverNameAdd,viaRouteAdd,sandPortUniqueIdAdd,SandLoadingFromTimeModify,SandLoadingToTimeModify,customerNameAdd,applicationNoAdd,validityPeriodModify,quantityModify,sandportUniqueidModify,extractionTypeModify,distanceAdd);
				    			  
				    }  
				 response.getWriter().print(message);
			 } catch(Exception e){
					e.printStackTrace();
			}
			   
	} else if(param.equals("maxTSGRID")){
					try{
						
						String clientId=request.getParameter("ClientId");
						int no = smpf.getMaxno(systemId,clientId);
						response.getWriter().print(no);	
					}
					catch(Exception e){
						e.printStackTrace();
					}
				} else if(param.equals("getAmtGRID")){
					try{
						String clientId=request.getParameter("clientId");
						String applicationNo=request.getParameter("applicationNo");
						String uniqueId=request.getParameter("uniqueID");
						message = smpf.getAmtGRID(systemId,clientId,applicationNo,uniqueId);
						response.getWriter().print(message);	
					}
					catch(Exception e){
						e.printStackTrace();
					}
				} else  if(param.equals("getVehicleTScount")){
					try{
						String clientId=request.getParameter("clientId");
						String vehNo=request.getParameter("vehno");
						Date date=(new Date());
						message = smpf.getVehicleTScount(systemId,clientId,vehNo,date,offset);
						response.getWriter().print(message);	
					}
					catch(Exception e){
						e.printStackTrace();
					}
				} else  if(param.equals("checkTSCOuntFORPORT")){
					try{
						String clientId=request.getParameter("clientId");
						String loadType=request.getParameter("loadType");
						String fromPort=request.getParameter("fromPort");
						String groupId=request.getParameter("groupId");
						String groupName=request.getParameter("groupName");
						message = smpf.getTSCountForPort(systemId,clientId,loadType,fromPort,offset,groupId,groupName);
						response.getWriter().print(message);	
					}
					catch(Exception e){
						e.printStackTrace();
					}
				} else if(param.equals("checkTotal")){
					try{
						String clientId=request.getParameter("clientId");
						String PERMITNO=request.getParameter("PERMITNO");
						String TYPE=request.getParameter("TYPE");
						String total=request.getParameter("total");
						String applicatn=request.getParameter("applicatn");
						message = smpf.CheckBalanceGRID(systemId,clientId,PERMITNO,TYPE,total,applicatn);
						response.getWriter().print(message);	
					}
					catch(Exception e){
						e.printStackTrace();
					}
				}  else if(param.equals("getPDFFileType"))
				  {
				    try
						{
				    	String SID= request.getParameter("systemId");
						message = smpf.getPDFFileType(SID);	
						request.getSession().setAttribute("valid", true);
						response.getWriter().print(message);
						}
						catch(Exception e)
						{
							System.out.println("Error in Save else-if block"+e);
					   		e.printStackTrace();
						}
				 } else if(param.equals("getPermitsNewGRID")){
						try{
							String clientId=request.getParameter("clientId");
							jsonObject =new JSONObject();
							jsonArray = smpf.getPermitNosForShimoga(systemId,clientId,userId,offset);
							jsonObject.put("PermitstoreNewList", jsonArray);
							response.getWriter().print(jsonObject.toString());	
						}
						catch(Exception e){
							e.printStackTrace();
						}
					}else if(param.equals("updateQuantity")){
						try{
							String clientId=request.getParameter("clientId");
							String applicationNo=request.getParameter("applicationNo");
							String qty=request.getParameter("qty");
							String vehicleNo=request.getParameter("permitNo");
							message = smpf.updateQuantity(systemId,clientId,applicationNo,qty,vehicleNo);
							response.getWriter().print(message);	
						}
						catch(Exception e){
							e.printStackTrace();
						}
					}
		
					else if(param.equals("getStockyards")){
						 try{
							 String clientId=request.getParameter("clientId");
							 String appNo=request.getParameter("appNo");
							 jsonObject =new JSONObject();
							 jsonArray=smpf.getStockyards(systemId,clientId,appNo);
							 jsonObject.put("fromStockyardRoot", jsonArray);
							 response.getWriter().print(jsonObject.toString());
						 }catch(Exception e){
							 
						 }
						 
					 }
					else if(param.equals("getmaxTripSheetNo")){
						try{
							
							String clientId=request.getParameter("ClientId");
							String no = smpf.getmaxTripSheetNo(systemId,clientId);
							response.getWriter().print(no);	
						}
						catch(Exception e){
							e.printStackTrace();
						}
					}
					else if(param.equals("getDataForConsumerApproval")){
						try{
							String clientId=request.getParameter("ClientId");
							String appType=request.getParameter("Type");						 
							jsonArray=smpf.getConsumerEnrolementData(systemId,Integer.parseInt(clientId),appType);
							jsonObject.put("ConsumerEnrolementDataRoot", jsonArray);						
							response.getWriter().print(jsonObject.toString());	
						}
						catch(Exception e){
							e.printStackTrace();
						}
					}
					else if(param.equals("manageDataOfConsumerEnrolement")){
						try{
							String clientId=request.getParameter("ClientId");
							String status=request.getParameter("Status");
							String uniqueId=request.getParameter("UniqueId");
							String arrovedQty=request.getParameter("ApprovedQty");
							String tpId=request.getParameter("TpId");
							String reason=request.getParameter("Reason");
							String remarks=request.getParameter("remarks");
							String mobile=request.getParameter("mobile");
							String balanceSandQty=request.getParameter("BalanceSandQty");
							String app=request.getParameter("appNo");
							String appStatus=request.getParameter("AppStatus");
							String newQty=request.getParameter("newQty");
							String msg="";
							if(appStatus.equals("approved")){
								 msg=smpf.UpdateConsumerApprovalData(systemId,Integer.parseInt(clientId),Integer.parseInt(uniqueId),userId,arrovedQty,balanceSandQty,app,newQty);
							}
							else{
								 msg=smpf.getManageConsumerEnrolementData(systemId,Integer.parseInt(clientId),status,Integer.parseInt(uniqueId),userId,arrovedQty,Integer.parseInt(tpId),reason,remarks,mobile,app);				
							}
								response.getWriter().print(msg);		
						}
						catch(Exception e){
							e.printStackTrace();
						}
					}
					
					else if(param.equals("getTempPermitNumbers")){
						try{
							// String clientId=request.getParameter("CustId");
							// System.out.println(clientID);
							String portId=request.getParameter("stockyardId");
							 jsonObject =new JSONObject();
							 jsonArray=smpf.getTemporaryPermitNumbers(systemId,clientID,userId,Integer.parseInt(portId));
							 jsonObject.put("TempPermitNoRoot", jsonArray);
							 response.getWriter().print(jsonObject.toString());
						 }
						catch(Exception e){
							e.printStackTrace();
						}
					}
		
					else if(param.equals("getCheckposts")){
						try{
							// String clientId=request.getParameter("CustId");
							// System.out.println(clientID);
							 jsonObject =new JSONObject();
							 jsonArray=smpf.getCheckpost(systemId,clientID);
							 jsonObject.put("CheckpostRoot", jsonArray);
							 response.getWriter().print(jsonObject.toString());
						 }
						catch(Exception e){
							e.printStackTrace();
						}
					}
		
					else if(param.equals("getStockyardsForConsumer")){
						try{
							 String sandTalukNameValue=request.getParameter("sandTalukNameValue");
							 String sandTalukName=request.getParameter("sandTalukName");
							// System.out.println(clientID);
							 jsonObject =new JSONObject();
							 jsonArray=smpf.getStockyardsForConsumer(systemId,clientID,sandTalukName);
							 jsonObject.put("stockyardRoot", jsonArray);
							 response.getWriter().print(jsonObject.toString());
						 }
						catch(Exception e){
							e.printStackTrace();
						}
					}
					else if (param.equals("addModifySandMdpLimit"))
					{
						
					try{
					message=null;	
					String buttonValue=request.getParameter("buttonValue");
					String fromDateId=request.getParameter("fromDateId");
					String endDateId=request.getParameter("endDateId");
					String governmentNameId=request.getParameter("governmentNameId");
					String publictextId=request.getParameter("publictextId");
					String contractortextId=request.getParameter("contractortextId");
					String ashrayatextId=request.getParameter("ashrayatextId");
					String custId=request.getParameter("custId");
					String uniqueId=request.getParameter("uniqueId");
					fromDateId=cf.getFormattedDateddMMYYYY(fromDateId.replaceAll("T"," "));
					endDateId=cf.getFormattedDateddMMYYYY(endDateId.replaceAll("T"," "));
					if(buttonValue.equals("Add"))
					{
						message=smpf.insertSandMdpLimitDetails(userId,systemId,custId,fromDateId,endDateId,governmentNameId,publictextId,contractortextId,ashrayatextId);
					}
					else{
						message=smpf.updateSandMdpLimitDetails(userId,systemId,custId,fromDateId,governmentNameId,publictextId,contractortextId,ashrayatextId,uniqueId);
					}
					response.getWriter().print(message);
					}catch (Exception e) {
		        	 e.printStackTrace();
					}
				}
					else if(param.equals("getMdpGenerationLimitDetails"))
					{
					 
						String custId=request.getParameter("CustId");
			            String custName=request.getParameter("custName");
			            String startDate=request.getParameter("startDate");
			            String endDate=request.getParameter("endDate");
			            startDate=cf.getFormattedDateddMMYYYY(startDate.replaceAll("T"," "));
			            endDate=cf.getFormattedDateddMMYYYY(endDate.replaceAll("T"," "));
						String jspName="";
						try{
							JSONArray jsonArray1 = new JSONArray(); 
							JSONObject jsonObject1 = new JSONObject();
							 if(request.getParameter("jspname")!=null)
					         jspName=request.getParameter("jspname");
							 
							ArrayList finlist = smpf.getMdpGenerationLimit(systemId,custId,offset,userId,startDate,endDate);
							jsonArray1= (JSONArray) finlist.get(0);
							if(jsonArray1.length()>0)
							{
								jsonObject1.put("MdpGenerationLimitRoot", jsonArray1);
							} else {
								jsonObject1.put("MdpGenerationLimitRoot", "");
							}
								
							ReportHelper reportHelper=(ReportHelper)finlist.get(1);
							request.getSession().setAttribute(jspName,reportHelper);
							request.getSession().setAttribute("custId", custName);
							request.getSession().setAttribute("startDate", startDate);
							request.getSession().setAttribute("endDate", endDate);
							response.getWriter().print(jsonObject1.toString());
				        	}
						catch(Exception e)
						{
							System.out.println("Error in getting Master Details:"+e.toString());
							e.printStackTrace();
				        }
						
					}else if(param.equals("getMDPLimitStore")){
						 try{
							 String clientId=request.getParameter("clientId");
							 String applicationNO=request.getParameter("applicationNO");
							 String date = request.getParameter("date");
							 date=cf.getFormattedDateddMMYYYY(date.replaceAll("T"," "));
							 SimpleDateFormat simpleDateFormatddMMYYYYDB1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
							 SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd");
							 if(date == null || date.equals("")){
								 
								 date = simpleDateFormatddMMYYYYDB.format(new Date());
							 }else{
								 date = simpleDateFormatddMMYYYYDB.format(simpleDateFormatddMMYYYYDB1.parse(date));
							 }
							 jsonObject =new JSONObject();
							 jsonArray=smpf.getMdpLimitStore(systemId,clientId,userId,date,applicationNO,offset);
							 if(jsonArray.length() > 0){
								 jsonObject.put("MDPLimitStoreList", jsonArray);
							 }else{
								 jsonObject.put("MDPLimitStoreList", "");
							 }
							 response.getWriter().print(jsonObject.toString());
						 }catch(Exception e){
							 
						 }
						 
					 }
		
		return null;
	}
	
}
