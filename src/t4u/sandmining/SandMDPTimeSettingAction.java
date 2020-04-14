package t4u.sandmining;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.functions.CommonFunctions;
import t4u.functions.IronMiningFunction;
import t4u.functions.SandMiningFunctions;

public class SandMDPTimeSettingAction extends Action{
	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		IronMiningFunction ironfunc = new IronMiningFunction();
		SandMiningFunctions sandfunc = new SandMiningFunctions();
		CommonFunctions cfuncs = new CommonFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject=null;
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		
			if (param.equalsIgnoreCase("getMiningTimes")) {
			try {
				String ltspSystemId=request.getParameter("ltspSystemId")!=null ?request.getParameter("ltspSystemId"):"0";
				String custId=request.getParameter("custId")!=null ?request.getParameter("custId"):"0";
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
					jsonArray =sandfunc.getMiningTimes(Integer.parseInt(custId),Integer.parseInt(ltspSystemId));
					if (jsonArray.length() > 0) {
						jsonObject.put("timesStoreRoot", jsonArray);
					} else {
						jsonObject.put("timesStoreRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		  }else if (param.equalsIgnoreCase("getLTSPS")) {
				jsonObject = new JSONObject();
				jsonArray = new JSONArray();
				try {
					jsonArray = cfuncs.getLTSPS();				
					if(jsonArray.length()>0){
						jsonObject.put("LTSPRoot",jsonArray);
					}else{
						jsonObject.put("LTSPRoot","");
					}
					response.getWriter().print(jsonObject.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equalsIgnoreCase("getCustomersForLTSP")) {
				int ltspSystemId=0;
				if(request.getParameter("ltspSystemId")!=null && !request.getParameter("ltspSystemId").equals("")){
					ltspSystemId=Integer.parseInt(request.getParameter("ltspSystemId"));
				}
				jsonObject = new JSONObject();
				jsonArray = new JSONArray();
				try {
					jsonArray = cfuncs.getCustomersForLTSP(ltspSystemId);				
					if(jsonArray.length()>0){
						jsonObject.put("CustomerRoot",jsonArray);
					}else{
						jsonObject.put("CustomerRoot","");
					}
					response.getWriter().print(jsonObject.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equalsIgnoreCase("getTaluksForLTSP")) {
				int ltspSystemId=0;
				int clientid=0;
				if(request.getParameter("ltspSystemId")!=null && !request.getParameter("ltspSystemId").equals("")){
					ltspSystemId=Integer.parseInt(request.getParameter("ltspSystemId"));
					clientid=Integer.parseInt(request.getParameter("custId"));
				}
				jsonObject = new JSONObject();
				jsonArray = new JSONArray();
				try {
					jsonArray = cfuncs.getTalukNamesForLTSP(ltspSystemId,clientid);				
					if(jsonArray.length()>0){
						jsonObject.put("TalukRoot",jsonArray);
					}else{
						jsonObject.put("TalukRoot","");
					}
					response.getWriter().print(jsonObject.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equalsIgnoreCase("getMDPLimit")) {
				int ltspSystemId=0;
				int clientid=0;
				String talukName=request.getParameter("talukId");
				if(request.getParameter("ltspSystemId")!=null && !request.getParameter("ltspSystemId").equals("")){
					ltspSystemId=Integer.parseInt(request.getParameter("ltspSystemId"));
					clientid=Integer.parseInt(request.getParameter("custId"));
				}
				jsonObject = new JSONObject();
				jsonArray = new JSONArray();
				try {
					jsonArray = cfuncs.getMDPLimit(ltspSystemId,clientid,talukName);				
					if(jsonArray.length()>0){
						jsonObject.put("MDPRoot",jsonArray);
					}else{
						jsonObject.put("MDPRoot","");
					}
					response.getWriter().print(jsonObject.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			  else if (param.equalsIgnoreCase("saveUserSettings")) {
					try {
						String message="";
						String ltspSystemId=request.getParameter("ltspSystemId")!=null ?request.getParameter("ltspSystemId"):"0";
						String custId=request.getParameter("custId")!=null ?request.getParameter("custId"):"0";
						String talukName=request.getParameter("talukId");
	                    String MDPLimit = String.valueOf(request.getParameter("MDPLimit"));

	                   message = sandfunc.saveUserSettings(Integer.parseInt(ltspSystemId),MDPLimit,talukName,custId);
						response.getWriter().print(message);
					} catch (Exception e) {
						e.printStackTrace();
					}
			  }
		  else if (param.equalsIgnoreCase("saveMiningTimes")) {
				try {
					String message="";
					String ltspSystemId=request.getParameter("ltspSystemId")!=null ?request.getParameter("ltspSystemId"):"0";
					String custId=request.getParameter("custId")!=null ?request.getParameter("custId"):"0";
					String startTimeHrs=request.getParameter("startTimeHrs");
					String startTimeMnt=request.getParameter("startTimeMnt");
					String endTimeHrs=request.getParameter("endTimeHrs");
					String endTimeMnt=request.getParameter("endTimeMnt");
					String brStartTimeHrs=request.getParameter("brStartTimeHrs");
					String brStartTimeMnt=request.getParameter("brStartTimeMnt");
					String blockedVehicles  = String.valueOf(request.getParameter("blockedVehicles"));
					String nonCommunicatingId =  String.valueOf(request.getParameter("nonCommunicatingId"));
                    String nonCommunicationHrs =  request.getParameter("nonCommunicationHrs");
                    String nonCommunicationMins  = request.getParameter("nonCommunicationMins");
                    String  insideHub =  String.valueOf(request.getParameter("insideHub"));
                    String  quantityMeasureId =  request.getParameter("quantityMeasureId");
                    String  bufferDistance =  String.valueOf(request.getParameter("bufferDistance"));
                    String  vehGroup =  request.getParameter("vehGroup");
                    String MDPbufferDistance = String.valueOf(request.getParameter("MDPbufferDistance"));
                    String stockYards = String.valueOf(request.getParameter("stockYards"));
                    String totalLoadingCapacityType1Vehicle = request.getParameter("totalLoadingCapacityType1Vehicle") != "" ? request.getParameter("totalLoadingCapacityType1Vehicle") : "0";
                    String totalLoadingCapacityType2Vehicle = request.getParameter("totalLoadingCapacityType2Vehicle") != "" ? request.getParameter("totalLoadingCapacityType2Vehicle") : "0";
                    String totalLoadingCapacityType3Vehicle = request.getParameter("totalLoadingCapacityType3Vehicle") != "" ? request.getParameter("totalLoadingCapacityType3Vehicle") : "0";
                    String totalMDPCountType1Vehicle = request.getParameter("totalMDPCountType1Vehicle") != "" ? request.getParameter("totalMDPCountType1Vehicle") : "0";
                    String totalMDPCountType2Vehicle = request.getParameter("totalMDPCountType2Vehicle") != "" ? request.getParameter("totalMDPCountType2Vehicle") : "0";
                    String totalMDPCountType3Vehicle = request.getParameter("totalMDPCountType3Vehicle") != "" ? request.getParameter("totalMDPCountType3Vehicle") : "0";
                    //System.out.println("totalLoadingCapacity " + totalLoadingCapacity + " totalMDPCount " + totalMDPCount);
                   
                   
                   nonCommunicatingId = nonCommunicatingId.equals("true") ? "Y" : "N";
                   blockedVehicles = blockedVehicles.equals("true") ? "Y" : "N";
                   insideHub = insideHub.equals("true") ? "Y" : "N";
                   
                   String paymentDays=request.getParameter("paymentDays");
                   String paymentHours=request.getParameter("paymentHours");
                   String paymentMins=request.getParameter("paymentMins");
                    
                   
                   message = sandfunc.saveMiningTimes(Integer.parseInt(ltspSystemId),Integer.parseInt(custId),startTimeHrs+":"+startTimeMnt,endTimeHrs+":"+endTimeMnt,brStartTimeHrs+":"+brStartTimeMnt ,
                 		   blockedVehicles,nonCommunicatingId,nonCommunicationHrs+":"+nonCommunicationMins ,insideHub ,quantityMeasureId,bufferDistance,vehGroup,MDPbufferDistance,Integer.parseInt(totalLoadingCapacityType1Vehicle),Integer.parseInt(totalLoadingCapacityType2Vehicle),Integer.parseInt(totalLoadingCapacityType3Vehicle),Integer.parseInt(totalMDPCountType1Vehicle),Integer.parseInt(totalMDPCountType2Vehicle),Integer.parseInt(totalMDPCountType3Vehicle),stockYards,
                 		     paymentDays+":"+paymentHours+":"+paymentMins);
					response.getWriter().print(message);
				} catch (Exception e) {
					e.printStackTrace();
				}
		  }
			
		  else if (param.equalsIgnoreCase("getGroupName")) {
			  String ltspSystemId=request.getParameter("ltspSystemId")!=null ?request.getParameter("ltspSystemId"):"0";
			  String clientId = request.getParameter("custId");
				jsonObject = new JSONObject();
				jsonArray = new JSONArray();
				try {
					jsonArray = sandfunc.getGroupName(Integer.parseInt(ltspSystemId),Integer.parseInt(clientId));				
					if(jsonArray.length()>0){
						jsonObject.put("GroupNameRoot",jsonArray);
					}else{
						jsonObject.put("GroupNameRoot","");
					}
					response.getWriter().print(jsonObject.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		  else if (param.equalsIgnoreCase("getBoatHubBufferData")) {
				try {
					String ltspSystemId=request.getParameter("ltspSystemId")!=null ?request.getParameter("ltspSystemId"):"0";
					String custId=request.getParameter("custId")!=null ?request.getParameter("custId"):"0";
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
						jsonArray =sandfunc.getBoatHubBufferData(Integer.parseInt(custId),Integer.parseInt(ltspSystemId));
						if (jsonArray.length() > 0) {
							jsonObject.put("getStoreRoot", jsonArray);
						} else {
							jsonObject.put("getStoreRoot", "");
						}
						response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			  }
		  else if (param.equalsIgnoreCase("saveBoatHubBufferSettings")) {
				try {
					String message="";
					String ltspSystemId=request.getParameter("ltspSystemId")!=null ?request.getParameter("ltspSystemId"):"0";
					String custId=request.getParameter("custId")!=null ?request.getParameter("custId"):"0";
					String  bufferDistance =  String.valueOf(request.getParameter("bufferDistance"));
					//String  emailList =  request.getParameter("emailList");
					String detentionHrs=request.getParameter("detentionHrs");
					String detentionMnt=request.getParameter("detentionMnt");

                 message = sandfunc.saveBoatHubBufferSettings(Integer.parseInt(ltspSystemId),Integer.parseInt(custId),bufferDistance,detentionHrs+"."+detentionMnt);
					response.getWriter().print(message);
				} catch (Exception e) {
					e.printStackTrace();
				}
		  }	
		  else if (param.equalsIgnoreCase("getStockYards")) {
				jsonObject = new JSONObject();
				jsonArray = new JSONArray();
				int SystemId=Integer.parseInt(request.getParameter("stockYardSystemId"));
				int ClientId=Integer.parseInt(request.getParameter("stockYardClientId"));
				System.out.println();
				try {
					jsonArray = cfuncs.getStockYards(SystemId,ClientId);				
					if(jsonArray.length()>0){
						jsonObject.put("StockYardsRoot",jsonArray);
					}else{
						jsonObject.put("StockYardsRoot","");
					}
					response.getWriter().print(jsonObject.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		//************************************ ***********************************	
			
		}
			return null;
		}
	}
