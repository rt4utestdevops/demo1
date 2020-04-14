package t4u.sandmining;

import java.io.IOException;
import java.util.ArrayList;

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
import t4u.beans.ReportHelper;
import t4u.beans.WorkLocation;
import t4u.functions.CommonFunctions;
import t4u.functions.SandMiningFunctions;
import t4u.functions.SandMiningPermitFunctions;



public class SandBlockManagementAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
        HttpSession session = request.getSession();
        String param = "";
        String zone = "";
        int systemId = 0;
        int userId = 0;
        int offset = 0;
        //HttpSession session = request.getSession();
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        SandMiningFunctions sandfunc = new SandMiningFunctions();
        SandMiningPermitFunctions sandpermitfunc=new SandMiningPermitFunctions();
        systemId = loginInfo.getSystemId();
        //String lang = loginInfo.getLanguage();
        int clientId=loginInfo.getCustomerId();
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
        
		 if (param.equals("getDistirctList")) {
            try {
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                String stateId=request.getParameter("stateId");
                if(stateId != null && !stateId.equals(""))
                {
                jsonArray = sandfunc.getDistirctList(Integer.parseInt(stateId));
                if (jsonArray.length() > 0) {
                    jsonObject.put("districtRoot", jsonArray);
                } else {
                    jsonObject.put("districtRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
                }else {
	                jsonObject.put("districtRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
            } catch (Exception e) {
            	 e.printStackTrace();
             }
        }
    
       
		else if (param.equals("getTaluka")) {
            try {
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                String districtId=request.getParameter("districtId");
                if(districtId != null && !districtId.equals(""))
                {
                jsonArray = sandfunc.getTaluka(Integer.parseInt(districtId));
                if (jsonArray.length() > 0) {
                    jsonObject.put("talukaRoot", jsonArray);
                } else {
                    jsonObject.put("talukaRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
                }else {
	                jsonObject.put("talukaRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
               
            } catch (Exception e) {
            	 e.printStackTrace();
             }
        }
       
		else if (param.equals("getGeoFence")) {
            try {
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                String custId=request.getParameter("custId");
                jsonArray = sandfunc.getGeoFence(Integer.parseInt(custId),systemId);
                if (jsonArray.length() > 0) {
                    jsonObject.put("geoFenceRoot", jsonArray);
                } else {
                    jsonObject.put("geoFenceRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
            	 e.printStackTrace();
             }
        }   
        
	    else if (param.equalsIgnoreCase("sandBlockManagementAddAndModify")) {
	        try {
	            String buttonValue = request.getParameter("buttonValue");
	        	String custId = request.getParameter("custId");
	        	String state = request.getParameter("state");
	        	String district = request.getParameter("district");
	        	String subDivision = request.getParameter("subDivision");
	        	String taluka = request.getParameter("taluka");
	        	String gramPanchayat = request.getParameter("gramPanchayat");
	        	String village = request.getParameter("village");
	        	String sandBlockName = request.getParameter("sandBlockName");
	        	String sandBlockNo = request.getParameter("sandBlockNo");
	        	String surveyNo = request.getParameter("surveyNo");
	        	String sandBlockAddress = request.getParameter("sandBlockAddress");
	        	String riverName = request.getParameter("riverName");
	        	String environmentalClearence = request.getParameter("environmentalClearence");
	        	String sandBlockType = request.getParameter("sandBlockType");
	        	String sandBlockStatus = request.getParameter("sandBlockStatus");
	        	String assessedQuantityMetric = request.getParameter("assessedQuantityMetric");
	        	String assessedQuantity = request.getParameter("assessedQuantity");
	        	String directLoading = request.getParameter("directLoading");
	        	String associatedGeoFence = request.getParameter("associatedGeoFence");
	        	String uniqueId = request.getParameter("id");
	        	
	        	String stateModify = request.getParameter("stateModify");
	        	String districtModify = request.getParameter("districtModify");
	        	String subDivisionModify = request.getParameter("subDivisionModify");
	        	String geoModify = request.getParameter("geoModify");
	        	
	            String message="";
	            if (buttonValue.equals("Add") && custId != null && !custId.equals("")) {
	                message = sandfunc.insertSandBlockInformation(Integer.parseInt(custId),state,district,subDivision,taluka,gramPanchayat,village,
	                		sandBlockName,sandBlockNo,surveyNo,sandBlockAddress,riverName,environmentalClearence,sandBlockType,sandBlockStatus,assessedQuantityMetric,assessedQuantity,directLoading,associatedGeoFence,systemId,userId);
	            } else if (buttonValue.equals("Modify") && custId != null && !custId.equals("")) {
	            	       message = sandfunc.modifySandBlockInformation(Integer.parseInt(custId),stateModify,districtModify,subDivisionModify,taluka,gramPanchayat,village,
	   	                		sandBlockName,sandBlockNo,surveyNo,sandBlockAddress,riverName,environmentalClearence,sandBlockType,sandBlockStatus,assessedQuantityMetric,assessedQuantity,directLoading,geoModify,systemId,Integer.parseInt(uniqueId),userId);
	            }
	            response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
        
	    else if (param.equalsIgnoreCase("getSandBlockManagementReport")) {
	        try {
	            String custId = request.getParameter("CustId");
	            String custName = request.getParameter("custName");
	            String jspName = request.getParameter("jspName");
	            jsonArray = new JSONArray();
	            if (custId != null && !custId.equals("")) {
	                ArrayList < Object > list1 = sandfunc.getSandBlockManagementReport(Integer.parseInt(custId),systemId,userId,lang);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("sandBlockManagementRoot", jsonArray);
	                } else {
	                    jsonObject.put("sandBlockManagementRoot", "");
	                }
		    		ReportHelper reportHelper = (ReportHelper) list1.get(1);
		         	request.getSession().setAttribute(jspName, reportHelper);
		         	request.getSession().setAttribute("custId", custName);
		         	response.getWriter().print(jsonObject.toString());
		         	
	            } else {
	                jsonObject.put("sandBlockManagementRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
        
		else if (param.equalsIgnoreCase("contractorAddAndModify")) {
	        try {
	            String custId = request.getParameter("CustId");
	            String buttonValue = request.getParameter("buttonValue");
	            String state = request.getParameter("state");
	            String district = request.getParameter("district");
	            String subDivision = request.getParameter("subDivision");
	            String taluka = request.getParameter("taluka");
	            String village = request.getParameter("village");
	            String gramPanchayat = request.getParameter("gramPanchayat");
	            String contractorName = request.getParameter("contractorName");
	            String contractNo= request.getParameter("contractNo");
	            String contractStartDate= request.getParameter("contractStartDate");
	            String contractEndDate= request.getParameter("contractEndDate");
	            String contractorStatus= request.getParameter("contractorStatus");
	            String contractAddress= request.getParameter("contractAddress");
	            String sandBlock = request.getParameter("sandBlock");
	            String contractorSandExcavationLimit = request.getParameter("contractorSandExcavationLimit");
	            String Uniqueid=request.getParameter("Uniqueid");
	            String districtModify=request.getParameter("districtModify");
	            String stateModify=request.getParameter("stateModify");
	            
	            String subDivisionModify=request.getParameter("subDivisionModify");
	            String sandBlockModify=request.getParameter("sandBlockModify");
	            String message="";
	            if (buttonValue.equals("Add") && custId != null && !custId.equals("")) {
	                message = sandfunc.insertContractorInformation(Integer.parseInt(custId),state,district,subDivision,taluka,village,gramPanchayat,contractorName,contractNo,contractStartDate,contractEndDate,contractorStatus,contractAddress,systemId,userId,sandBlock,Float.parseFloat(contractorSandExcavationLimit));
	            } else if (buttonValue.equals("Modify") && custId != null && !custId.equals("")) {
	            	      message = sandfunc.modifyContractorInformation(Integer.parseInt(custId),Integer.parseInt(stateModify),Integer.parseInt(districtModify),Integer.parseInt(subDivisionModify),taluka,village,gramPanchayat,contractorName,contractNo,contractStartDate,contractEndDate,contractorStatus,contractAddress,systemId,userId ,Integer.parseInt(Uniqueid),Integer.parseInt(sandBlockModify),Float.parseFloat(contractorSandExcavationLimit));
	            	 
	            }
	            response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
		else if (param.equalsIgnoreCase("getContractorReport")) {
	        try {
	            String customerId = request.getParameter("CustId");
	            String customerName = request.getParameter("custName");
	            String jspName = request.getParameter("jspName");
	            jsonArray = new JSONArray();
	            if (customerId != null && !customerId.equals("")) {
	                ArrayList < Object > list1 = sandfunc.getContractorReport(systemId, Integer.parseInt(customerId),lang);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("contractorRoot", jsonArray);
	                } else {
	                    jsonObject.put("contractorRoot", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) list1.get(1);
		         	request.getSession().setAttribute(jspName, reportHelper);
		         	request.getSession().setAttribute("custId", customerName);
	                response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("contractorRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
		
		else if (param.equals("getSandBlocks")) {
            try {
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                String custId=request.getParameter("custId");
                if (custId != null && !custId.equals("")) {	                
	                jsonArray = sandfunc.getSandBlocks(Integer.parseInt(custId),systemId);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("sandBlocksRoot", jsonArray);
	                } else {
	                    jsonObject.put("sandBlocksRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	                } else {
		                jsonObject.put("sandBlocksRoot", "");
		                response.getWriter().print(jsonObject.toString());
		            }
            } catch (Exception e) {
            	 e.printStackTrace();
             }
        }   
		else if (param.equals("getAssignedContractor")) {
            try {
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
             
                String custId=request.getParameter("custId");
                if (custId != null && !custId.equals("")) {
	                jsonArray = sandfunc.getAssignedContractor(Integer.parseInt(custId),systemId);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("assignedContractorRoot", jsonArray);
	                } else {
	                    jsonObject.put("assignedContractorRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	                }else {
		                jsonObject.put("assignedContractorRoot", "");
		                response.getWriter().print(jsonObject.toString());
		            }
            } catch (Exception e) {
            	 e.printStackTrace();
             }
        }
		else if (param.equalsIgnoreCase("stockyardManagementAddAndModify")) {
	        try {
	        	
	        //	String custId=request.getParameter("custId");
	            String buttonValue = request.getParameter("buttonValue");
	            String custId = request.getParameter("divId");
	            String state=request.getParameter("state");
                String district=request.getParameter("district");
                String subDivision=request.getParameter("subDivision");
                String taluk=request.getParameter("taluk");
                String gramPanchayat=request.getParameter("gramPanchayat");
                String village=request.getParameter("village");
                String sandStockyardName=request.getParameter("sandStockyardName");
             	String sandstockyardAddress=request.getParameter("sandStockyardAddress");
             	String riverName=request.getParameter("riverName");
             	String capacityofStockyard=request.getParameter("capacityofStockyard");
             	String capacityMetric=request.getParameter("capacityMetric");
             	String associatedGeofence=request.getParameter("associatedGeofence");
             	String associatedSandBlocks=request.getParameter("associatedSandBlocks");
             	String estimatedSandQuantity=request.getParameter("estimatedSandQuantity");
             	String rateMetric=request.getParameter("rateMetric");
             	String rates=request.getParameter("rates");
             	String assignedContractor=request.getParameter("assignedContractor");
	            String id=request.getParameter("id");
	            String message="";
	            
	            String stateModify=request.getParameter("stateModify");
           	    String districtModify=request.getParameter("districtModify");
           	    String subDivisionModify=request.getParameter("subDivisionModify");
           	    String geofenceModify=request.getParameter("geofenceModify");
           	
	            if (buttonValue.equals("Add") && custId != null && !custId.equals("")) {
	                message = sandfunc.insertDivisionInformation(Integer.parseInt(custId),state,district,subDivision,taluk,gramPanchayat,village,
	            			sandStockyardName,sandstockyardAddress,riverName,capacityofStockyard,capacityMetric,associatedGeofence,
	            			associatedSandBlocks,estimatedSandQuantity,rateMetric,rates,assignedContractor,userId,systemId);
	            } 
	            else if (buttonValue.equals("Modify") && custId != null && !custId.equals("")) {
	            	message = sandfunc.modifyDivisionInformation(Integer.parseInt(custId),stateModify,districtModify,subDivisionModify,taluk,gramPanchayat,village,
	            			sandStockyardName,sandstockyardAddress,riverName,capacityofStockyard,capacityMetric,geofenceModify,
	            			associatedSandBlocks,estimatedSandQuantity,rateMetric,rates,assignedContractor,userId,systemId,Integer.parseInt(id));
	            }
	           
	            response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    

	    else if (param.equalsIgnoreCase("getDivisionMasterReport")) {
		        try {
		            String customerId = request.getParameter("CustId");
		            String jspName = request.getParameter("jspName");
		            String custName = request.getParameter("CustName");
		            jsonArray = new JSONArray();
		            if (customerId != null && !customerId.equals("")) {
		                ArrayList < Object > list1 = sandfunc.getDivisionMasterReport(systemId, Integer.parseInt(customerId),lang);
		                jsonArray = (JSONArray) list1.get(0);
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("divisionMastersRoot",jsonArray);
		                } else {
		                    jsonObject.put("divisionMastersRoot", "");
		                }
		                ReportHelper reportHelper = (ReportHelper) list1.get(1);
		             	request.getSession().setAttribute(jspName, reportHelper);
		             	request.getSession().setAttribute("customerId", custName);
		             	response.getWriter().print(jsonObject.toString());
		            } else {
		                jsonObject.put("divisionMastersRoot", "");
		                response.getWriter().print(jsonObject.toString());
		            }
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }

			else if (param.equals("getGeoFence1")) {
	            try {
	                jsonArray = new JSONArray();
	                jsonObject = new JSONObject();
	                String custId=request.getParameter("custId");
	                jsonArray = sandfunc.getGeoFence1(Integer.parseInt(custId),systemId);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("geoFenceRoot", jsonArray);
	                } else {
	                    jsonObject.put("geoFenceRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            } catch (Exception e) {
	            	 e.printStackTrace();
	             }
	        }   
			else if (param.equals("getSandBlocksForContractor")) {
	            try {
	                jsonArray = new JSONArray();
	                jsonObject = new JSONObject();
	                String custId=request.getParameter("custId");
	                if (custId != null && !custId.equals("")) {	                
		                jsonArray = sandfunc.getSandBlocksForContractor(Integer.parseInt(custId),systemId);
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("sandBlockRoot", jsonArray);
		                } else {
		                    jsonObject.put("sandBlockRoot", "");
		                }
		                response.getWriter().print(jsonObject.toString());
		                } else {
			                jsonObject.put("sandBlockRoot", "");
			                response.getWriter().print(jsonObject.toString());
			            }
	            } catch (Exception e) {
	            	 e.printStackTrace();
	             }
	        }   
		
		 if (param.equals("getContractorBasedOnCustomer")) {
	            try {
	                jsonArray = new JSONArray();
	                jsonObject = new JSONObject();
	                String custId = null;
	                if (request.getParameter("CustId") != null) {
	                    custId = request.getParameter("CustId");
	                }
	                jsonArray = sandfunc.getcontractorBasedOnCustomer(systemId, Integer.parseInt(custId));
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("contractrRoot", jsonArray);
	                } else {
	                    jsonObject.put("contractrRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	        }    
		 
		 if (param.equals("getDataForNonAssociation")) {
	            try {
	                jsonArray = new JSONArray();
	                jsonObject = new JSONObject();
	                String custId = null;
	                String contractorId=request.getParameter("contractorIdFromJsp");
	                if (request.getParameter("CustId") != null) {
	                    custId = request.getParameter("CustId");
	                }
	                jsonArray = sandfunc.getDataForNonAssociation(systemId, Integer.parseInt(custId), Integer.parseInt(contractorId),userId);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("firstGridRoot", jsonArray);
	                } else {
	                    jsonObject.put("firstGridRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	        }    
		 
		 if (param.equals("getDataForAssociation")) {
	            try {
	                jsonArray = new JSONArray();
	                jsonObject = new JSONObject();
	                String custId = null;
	                String contractorId=request.getParameter("contractorIdFromJsp");
	                if (request.getParameter("CustId") != null) {
	                    custId = request.getParameter("CustId");
	                }
	                jsonArray = sandfunc.getDataForAssociation(systemId, Integer.parseInt(custId), Integer.parseInt(contractorId));
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("secondGridRoot", jsonArray);
	                } else {
	                    jsonObject.put("secondGridRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	        }    
		 else if (param.equalsIgnoreCase("associateVehicle")) {
		        String message = null;
		        String customerId = request.getParameter("CustID");
		        String s = request.getParameter("gridData");
		        String contractorIdFromJsp = request.getParameter("contractorIdFromJsp");
		        try {
		            if (s != null) {
		                String st = "[" + s + "]";
		                JSONArray js = null;
		                try {
		                    js = new JSONArray(st.toString());
		                    if (js.length() > 0) {
		                        message = sandfunc.associateVehicle(Integer.parseInt(customerId), systemId, Integer.parseInt(contractorIdFromJsp), js,userId);
		                    } else {
		                        message = "";
		                    }
		                } catch (Exception e) {
		                    e.printStackTrace();
		                }
		            } else {
		                message = "No Data To Save";
		            }
		            response.getWriter().print(message);
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }	
		 else if (param.equalsIgnoreCase("dissociateVehicle")) {
		        String message = null;
		        String customerId = request.getParameter("CustID");
		        String s = request.getParameter("gridData2");
		        String contractorIdFromJsp = request.getParameter("contractorIdFromJsp");
		        try {
		            if (s != null) {
		                String st = "[" + s + "]";
		                JSONArray js = null;
		                try {
		                    js = new JSONArray(st.toString());
		                    if (js.length() > 0) {
		                        message = sandfunc.dissociateVehicle(Integer.parseInt(customerId), systemId, Integer.parseInt(contractorIdFromJsp), js,userId);
		                    } else {
		                        message = "";
		                    }
		                } catch (Exception e) {
		                    e.printStackTrace();
		                }
		            } else {
		                message = "No Data To Save";
		            }
		            response.getWriter().print(message);
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }	
		 
		 else if (param.equals("getContractor"))
			{
			try{
			jsonArray = new JSONArray();
         jsonObject = new JSONObject();	
         String custId=request.getParameter("CustId");
			jsonArray = sandfunc.getContractor(Integer.parseInt(custId),systemId);
          if (jsonArray.length() > 0) {
              jsonObject.put("contractorRoot", jsonArray);
          } else {
              jsonObject.put("contractorRoot", "");
          }
			  response.getWriter().print(jsonObject.toString());
         } catch (Exception e) {
         	 e.printStackTrace();
          }
     }
			else if (param.equals("getContractNo"))
			{
			try{
			String contractorId=request.getParameter("cname");
			String contract_no="";
			String custId=null;
	         if(request.getParameter("CustId")!=null && request.getParameter("CustId")!="")
	         {
	         	custId=	request.getParameter("CustId");
	         }
	         else
	         {
	         custId="-1";	
	         }
			contract_no = sandfunc.getContractNo(Integer.parseInt(custId),systemId,Integer.parseInt(contractorId));
          if (!contract_no.equals("")) {
         	 response.getWriter().print(contract_no);
          } else {
         	 response.getWriter().print("");
          }
			  
         } catch (Exception e) {
         	 e.printStackTrace();
          }
     } 
		
			else if (param.equals("getSandBlocksFrom"))
			{
			try{
			jsonArray = new JSONArray();
         jsonObject = new JSONObject();
         String custId=null;
         String contractorId=request.getParameter("contractorId");
         if(request.getParameter("CustId")!=null && request.getParameter("CustId")!="")
         {
         	custId=	request.getParameter("CustId");
         }
         else
         {
         custId="-1";	
         }
         jsonArray = sandfunc.getSandBlocksFrom(Integer.parseInt(custId),systemId,contractorId);
         if (jsonArray.length() > 0) {
             jsonObject.put("sandBlockRoot", jsonArray);
         } else {
             jsonObject.put("sandBlockRoot", "");
         }
			  response.getWriter().print(jsonObject.toString());
         } catch (Exception e) {
         	 e.printStackTrace();
          }
     }
		
			else if (param.equals("getStockyardsTo"))
			{
			try{
			jsonArray = new JSONArray();
         jsonObject = new JSONObject();
         String custId=null;
         if(request.getParameter("CustId")!=null && request.getParameter("CustId")!="")
         {
         	custId=	request.getParameter("CustId");
         }
         else
         {
         custId="-1";	
         }
         jsonArray = sandfunc.getStockyardsTo(Integer.parseInt(custId),systemId);
         if (jsonArray.length() > 0) {
             jsonObject.put("stockyardsRoot", jsonArray);
         } else {
             jsonObject.put("stockyardsRoot", "");
         }
			  response.getWriter().print(jsonObject.toString());
         } catch (Exception e) {
         	 e.printStackTrace();
          }
     }
		
			else if (param.equals("getVehicleNos"))
			{
			try{
			jsonArray = new JSONArray();
            jsonObject = new JSONObject();
            String custId=null;
            if(request.getParameter("CustId")!=null && request.getParameter("CustId")!="")
            {
            	custId=	request.getParameter("CustId");
            }
            else
            {
            custId="-1";	
            }
            String contractorId=null;
         if(request.getParameter("contractorName")!=null && request.getParameter("contractorName")!="")
         {contractorId=request.getParameter("contractorName");}
         else
         contractorId="-1";
         jsonArray = sandfunc.getVehicleNos(Integer.parseInt(custId),systemId,Integer.parseInt(contractorId));
         if (jsonArray.length() > 0) {
             jsonObject.put("vehicleRoot", jsonArray);
         } else {
             jsonObject.put("vehicleRoot", "");
         }
			  response.getWriter().print(jsonObject.toString());
         } catch (Exception e) {
         	 e.printStackTrace();
          }
     }
		
			else if (param.equals("addModifyPermitDetails"))
			{
				
			try{
			String message=null;	
			String buttonValue=request.getParameter("buttonValue");
			String permitNo=request.getParameter("permitNo");
			String ContractorId=request.getParameter("contractorName");
			String ContractNo=request.getParameter("contractorNo");
			String vehicleNo=request.getParameter("vehicleNo");
			String quantity=request.getParameter("quantity");
			String sandBlockFrom=request.getParameter("sandblockName");
			String stockyardTo=request.getParameter("stockyardName");
			String validFrom=request.getParameter("validfrom");
			String validTo=request.getParameter("validto");
			String processingFees=request.getParameter("processingFee");
			String custId = request.getParameter("custId");
			validFrom=cf.getFormattedDateddMMYYYY(validFrom.replaceAll("T"," "));
			validTo=cf.getFormattedDateddMMYYYY(validTo.replaceAll("T"," "));
			 

			String contractorNameModify=request.getParameter("contractorNameModify");
			String contractorNoModify=request.getParameter("contractorNoModify");
			String vehicleNoModify=request.getParameter("vehicleNoModify");
			String quantityModify=request.getParameter("quantityModify");
			String sandBlockModify=request.getParameter("sandBlockModify");
			String stockyardModify=request.getParameter("stockyardModify");
			String validFromModify=request.getParameter("validFromModify");
			String validToModify=request.getParameter("validToModify");
			String procFeesModify=request.getParameter("procFeesModify");
			String selectedQuantity=request.getParameter("selectedQuantity");
			
			if(buttonValue.equals("Add"))
			{
			message=sandpermitfunc.insertPermitDetails(systemId,custId,userId,permitNo,ContractorId,
					ContractNo,vehicleNo,Double.parseDouble(quantity),sandBlockFrom,stockyardTo,validFrom,validTo,processingFees);
			response.getWriter().print(message);
			}
			else if(buttonValue.equals("Modify"))
			{
			message=sandpermitfunc.ModifyPermitDetails(systemId,custId,userId,permitNo,contractorNameModify,
					contractorNoModify,vehicleNoModify,Double.parseDouble(quantityModify),sandBlockModify,stockyardModify,validFromModify,validToModify,procFeesModify,Integer.parseInt(selectedQuantity));
			response.getWriter().print(message);
			}
			}
			catch (Exception e) {
        	 e.printStackTrace();
         }
			}
			else if (param.equals("getQuantity"))
			{
			try{
			double loadCapacity=0.0;
			System.out.println("***********************");
			String vehicleNO=request.getParameter("vehicleNo");
			loadCapacity = sandfunc.getQuantity(systemId,vehicleNO);
         if (loadCapacity>0) {
         response.getWriter().print(loadCapacity);
          } else {
          response.getWriter().print("0");
          }
			  
          } catch (Exception e) {
         	 e.printStackTrace();
          }
     } 
		
			else if (param.equals("getSandPermitDetails"))
			{
			try{
			jsonArray = new JSONArray();
            jsonObject = new JSONObject();
            String jspName=null;
         String custId=request.getParameter("CustId");
         String custName=request.getParameter("custname");
         if(request.getParameter("jspname")!=null)
         jspName=request.getParameter("jspname");
         else
         jspName=""; 
         ArrayList<Object> permitDetails = sandpermitfunc.getSandPermitDetails(systemId,custId,jspName,lang);
         jsonArray = (JSONArray) permitDetails.get(0);
     	if (jsonArray.length() > 0) {
     	jsonObject.put("sandInwardPermitRoot", jsonArray);
     	}
     	else
     	{
     	jsonObject.put("sandInwardPermitRoot", "");
     	}	
     	ReportHelper reportHelper = (ReportHelper) permitDetails.get(1);
     	request.getSession().setAttribute(jspName, reportHelper);
     	request.getSession().setAttribute("custId", custName);
     	response.getWriter().print(jsonObject.toString());
     	
         } catch (Exception e) {
         	 e.printStackTrace();
          }
     }
		 
			else if (param.equals("getPermitNo"))
			{
			try{
			String custId=request.getParameter("CustId");
			String contract_no="";
			contract_no = sandpermitfunc.getPermitNo(custId,systemId);
          if (!contract_no.equals("")) {
         	 response.getWriter().print(contract_no);
          } else {
         	 response.getWriter().print("");
          }
			  
         } catch (Exception e) {
         	 e.printStackTrace();
          }
     } 
			else if (param.equals("getDistirctListForConsumer")) {
	            try {
	                jsonArray = new JSONArray();
	                jsonObject = new JSONObject();
	                jsonArray = sandfunc.getDistirctListForConsumer();
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("distRoot", jsonArray);
	                } else {
	                    jsonObject.put("distRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            } catch (Exception e) {
	            	 e.printStackTrace();
	             }
	        }
		 
			 else if (param.equalsIgnoreCase("addSandConsumerDetails")) {
			        try {
			            String buttonValue = request.getParameter("buttonValue");
			        	String custId = request.getParameter("custId");
			        	String consumerType = request.getParameter("consumerType");
			        	String district = request.getParameter("district");
			        	String taluka = request.getParameter("taluka");
			        	String village = request.getParameter("village");
			        	String mobileNo = request.getParameter("mobileNo");
			        	String emailId = request.getParameter("emailId");
			        	String address = request.getParameter("address");
			        	String identityProofType = request.getParameter("identityProofType");
			        	String identityProofNo = request.getParameter("identityProofNo");
			        	String sandConsumerName = request.getParameter("sandConsumerName");
			        	String contractorName = request.getParameter("contractorName");
			        	String projectName = request.getParameter("projectName");
			        	String projectDurationFrom = request.getParameter("projectDurationFrom");
			        	String projectDurationTo = request.getParameter("projectDurationTo");
			        	String governmentDeptName = request.getParameter("governmentDeptName");
			        	String deptContactName = request.getParameter("deptContactName");
			        	
			        	String workdistrict=request.getParameter("workdistrict");
			        	String worktaluka=request.getParameter("worktaluka");
			        	String workvillage=request.getParameter("workvillage");
			        	String workaddress=request.getParameter("workaddress");
			        	String workLocation1=request.getParameter("workLocation");
			        	
			        	String housingApprovalAuthority = request.getParameter("housingApprovalAuthority");
			        	String housingApprovalPlanNumber = request.getParameter("housingApprovalPlanNumber");
			        	String projectApprovalAuthority = request.getParameter("projectApprovalAuthority");
			        	String projectApprovalPlanNumber = request.getParameter("projectApprovalPlanNumber");
			        	String totalBuiltupArea = request.getParameter("totalBuiltupArea");
			        	String noOfBuildings = request.getParameter("noOfBuildings");
			        	String estimatedSandRequirement = request.getParameter("estimatedSandRequirement");
			        	String approvedSandQunatity = request.getParameter("approvedSandQunatity");		
			        	
			        	String fromDistrict = request.getParameter("fromDistrict");	
			        	String fromTaluka = request.getParameter("fromTaluka");	
			        	String tpNumber = request.getParameter("tpNumber");	
			        //	String panNumber = request.getParameter("checkpost");	
			        //	String tinNumber = request.getParameter("tinNumber");	
			        	String tpNumberID = request.getParameter("tpNumberID");
			        	String checkpost = request.getParameter("checkpost");
			        	String stockyard=request.getParameter("stockyard");
			        	String propertyAssessmentNum = request.getParameter("propertyAssessmentNum");
			        	
			            WorkLocation worlLocation = (WorkLocation) session.getAttribute("worklocation");
			            String location=worlLocation.getLocation();
			            float latitude=worlLocation.getLatitude();
			            float longitude=worlLocation.getLongitude();
			        	
			            String message="";
			            if(fromDistrict.equals("") && fromTaluka.equals("")){
			            	fromDistrict ="0";
			            	fromTaluka ="0";
			            	
			            }
			            
			            if(buttonValue.equals("Add") && custId != null && !custId.equals("")){
	 		                message = sandfunc.insertSandConsumerDetails(Integer.parseInt(custId),consumerType, 

	Integer.parseInt(district), Integer.parseInt(taluka), village,mobileNo, emailId, address,
			                		identityProofType, identityProofNo, sandConsumerName, contractorName, 

	projectName, projectDurationFrom, projectDurationTo,governmentDeptName, deptContactName,Integer.parseInt(workdistrict), 

	Integer.parseInt(worktaluka),
			                		workvillage, workaddress, location, housingApprovalAuthority, 

	housingApprovalPlanNumber, projectApprovalAuthority, projectApprovalPlanNumber,Double.parseDouble(totalBuiltupArea), 

	Integer.parseInt(noOfBuildings),
			                	    Double.parseDouble(estimatedSandRequirement), Double.parseDouble

	(approvedSandQunatity), systemId,userId,latitude,longitude,Integer.parseInt(fromDistrict),Integer.parseInt(fromTaluka),tpNumber,tpNumberID,checkpost,stockyard,propertyAssessmentNum );
			            }
			            response.getWriter().print(message);
			        } catch (Exception e) {
			            e.printStackTrace();
			        }
			    }
		 
		 if (param.equalsIgnoreCase("getConsumerReport")) {
		        try {
		        	String custId = request.getParameter("CustId");
		        	String custName=request.getParameter("custName");
		        	String jspName=request.getParameter("jspName");
		        	String startDate=request.getParameter("startDate");
		        	String endDate=request.getParameter("endDate");
		        	startDate=startDate.replace("T", " ");
		        	endDate=endDate.replace("T", " ");
		            jsonArray = new JSONArray();
		            if (custId != null && !custId.equals("")) {
		                ArrayList < Object > list1 = sandfunc.getConsumerReport(systemId, Integer.parseInt(custId),startDate,endDate,offset);
		                jsonArray = (JSONArray) list1.get(0);
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("consumerRoot", jsonArray);
		                } else {
		                    jsonObject.put("consumerRoot", "");
		                }
		                ReportHelper reportHelper = (ReportHelper) list1.get(1);
			        	request.getSession().setAttribute(jspName, reportHelper);
			        	request.getSession().setAttribute("custId", custName);
			        	response.getWriter().print(jsonObject.toString());
			            
		            } else {
		                jsonObject.put("consumerRoot", "");
		                response.getWriter().print(jsonObject.toString());
		            }
		            
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }
		 
		 
//----------------------------------------------getMDPCheckingReport--------------------------
		 
		 else if (param.equalsIgnoreCase("getMDPCheckingReport")) {
		        try {
		        	String custId = request.getParameter("custID");
		        	String custName=request.getParameter("custName");
		        	String jspName=request.getParameter("jspName");
		            jsonArray = new JSONArray();
		            if (custId != null && !custId.equals("")) {
		                ArrayList < Object > list1 = sandfunc.getMDPCheckingReport(systemId, Integer.parseInt(custId),lang,userId);
		                jsonArray = (JSONArray) list1.get(0);
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("GridRoot", jsonArray);
		                } else {
		                    jsonObject.put("GridRoot", "");
		                }
		                ReportHelper reportHelper = (ReportHelper) list1.get(1);
			        	request.getSession().setAttribute(jspName, reportHelper);
			        	request.getSession().setAttribute("custName", custName);
			        	response.getWriter().print(jsonObject.toString());
			            
		            } else {
		                jsonObject.put("GridRoot", "");
		                response.getWriter().print(jsonObject.toString());
		            }
		            
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }
		 
		 
//-------------------------------------------------------------------------------------------------------------------		 
		 
		 
			else if (param.equals("getBankNames"))
			{
			try{
			jsonArray = new JSONArray();
            jsonObject = new JSONObject();
            
         
         jsonArray = sandpermitfunc.getBankNames();
         if (jsonArray.length() > 0) {
             jsonObject.put("bankNameroot", jsonArray);
         } else {
             jsonObject.put("bankNameroot", "");
         }
			  response.getWriter().print(jsonObject.toString());
         } catch (Exception e) {
         	 e.printStackTrace();
          }
     }	 
		 
			else if (param.equals("addModifySandCreditMaster"))
			{
				
			try{
			String message=null;	
			String buttonValue=request.getParameter("buttonValue");
			String tpId=request.getParameter("tpId");
			String tpNo=request.getParameter("tpNo");
			String applicationNo=request.getParameter("applicationNo");
			//String sandQuantity=request.getParameter("sandQuantity");
			String consumerName=request.getParameter("consumerName");
			//String ddAmount=request.getParameter("ddAmount");
			String ddNo=request.getParameter("ddNo");
			String ddDate=request.getParameter("ddDate");
			String bankName=request.getParameter("bankName");
			String branchName=request.getParameter("branchName");
			String custId=request.getParameter("custId");
			String consumerMobileNo = request.getParameter("consumerMobileNo");
			String tpMobileNo = request.getParameter("tpMobileNo");
			double sandQuantity=0.0;
			double ddAmount=0.0;
			if(request.getParameter("sandQuantity")!=null && request.getParameter("sandQuantity")!="")
			sandQuantity=Double.parseDouble(request.getParameter("sandQuantity"));
			
			if(request.getParameter("ddAmount")!=null && request.getParameter("ddAmount")!="")
			ddAmount=Double.parseDouble(request.getParameter("ddAmount"));
			ddDate=cf.getFormattedDateddMMYYYY(ddDate.replaceAll("T"," "));
			
			if(tpId.equals("") || tpId.equals(null)){
				tpId="0";
			}
			if(buttonValue.equals("Add"))
			{
			message=sandpermitfunc.insertSandCreditDetails(userId,systemId,custId,applicationNo,consumerName,sandQuantity,ddAmount,ddNo,ddDate,bankName,branchName,tpNo,consumerMobileNo,tpMobileNo,Integer.parseInt(tpId));
			response.getWriter().print(message);
			}
			
			}
			catch (Exception e) {
        	 e.printStackTrace();
         }
			}
		 
			else if (param.equals("getBankCode"))
			{
			try{
			String bankId=request.getParameter("bankId");
			String ddNo=request.getParameter("ddNo");
			String custId=request.getParameter("custId");
			String ddno=null;
			ddno = sandpermitfunc.getBankCode(bankId,ddNo,custId,systemId);
          if (!ddno.equals("")) {
         	 response.getWriter().print(ddno);
          } else {
         	 response.getWriter().print("");
          }
			  
         } catch (Exception e) {
         	 e.printStackTrace();
          }
     } 
		 
	//*******************************Consumer Credit Master *************************************//	 
			else if (param.equals("getConsumerCreditDetails"))
			{
			try{
			jsonArray = new JSONArray();
            jsonObject = new JSONObject();
            String jspName=null;
            String custId=request.getParameter("CustId");
            String custName=request.getParameter("custName");
            String startDate=request.getParameter("startDate");
            String endDate=request.getParameter("endDate");
            startDate=cf.getFormattedDateddMMYYYY(startDate.replaceAll("T"," "));
            endDate=cf.getFormattedDateddMMYYYY(endDate.replaceAll("T"," "));
         if(request.getParameter("jspname")!=null)
         jspName=request.getParameter("jspname");
         else
         jspName=""; 
         ArrayList<Object> creditDetails = sandpermitfunc.getConsumerCreditDetails(systemId,custId,jspName,lang,startDate,endDate);
         jsonArray = (JSONArray) creditDetails.get(0);
     	if (jsonArray.length() > 0) {
     	jsonObject.put("consumerCreditroot", jsonArray);
     	}
     	else
     	{
     	jsonObject.put("consumerCreditroot", "");
     	}	
     	ReportHelper reportHelper = (ReportHelper) creditDetails.get(1);
     	request.getSession().setAttribute(jspName, reportHelper);
     	request.getSession().setAttribute("custId", custName);
     	response.getWriter().print(jsonObject.toString());
     	
         } catch (Exception e) {
         	 e.printStackTrace();
          }
     }
		
	//*******************************************Consumer Application No********************************//
			else if (param.equals("getApplicationNos"))
			{
			try{
			jsonArray = new JSONArray();
            jsonObject = new JSONObject();
            String customerId=request.getParameter("CustId");
            String tpNo=request.getParameter("tpNo");
         
         jsonArray = sandpermitfunc.getApplicationNos(customerId,systemId,tpNo);
         if (jsonArray.length() > 0) {
             jsonObject.put("applicationNoRoot", jsonArray);
         } else {
             jsonObject.put("applicationNoRoot", "");
         }
			  response.getWriter().print(jsonObject.toString());
         } catch (Exception e) {
         	 e.printStackTrace();
          }
     }	 
			else if (param.equalsIgnoreCase("addLocationDetails")) {
		        try {
		            String location = request.getParameter("location");
		        	String latitude = request.getParameter("latitude");
		        	String longitude = request.getParameter("longitude");
		        	
		        	 WorkLocation workLocation=new WorkLocation();
		            workLocation.setLocation(location);
		            workLocation.setLatitude(Float.parseFloat(latitude));
		            workLocation.setLongitude(Float.parseFloat(longitude));
		            session.setAttribute("worklocation", workLocation);
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }
		 
//------------------------------***************Sand Inward Report ******************************
		 if(param.equals("getSandInwardReport"))
		 {
				try
				{
					String startdate=request.getParameter("startdate");
					String enddate = request.getParameter("enddate");
					String custId = request.getParameter("custId");
					String jspName=null;
					jspName=request.getParameter("jspName");
					jsonObject =new JSONObject();
					jsonArray = new JSONArray();
					ArrayList finlist = sandfunc.getSandInwardReport(systemId,custId,startdate,enddate);
					jsonArray = (JSONArray) finlist.get(0);
					jsonObject.put("SandInwardGridRoot", jsonArray);
					  jsonArray = (JSONArray) finlist.get(0);
				     	if (jsonArray.length() > 0) {
				     	jsonObject.put("SandInwardGridRoot", jsonArray);
				     	}
				     	else
				     	{
				     	jsonObject.put("SandInwardGridRoot", "");
				     	}	
				     	ReportHelper reportHelper = (ReportHelper) finlist.get(1);
				     	request.getSession().setAttribute(jspName, reportHelper);
				     //	request.getSession().setAttribute("custId", custName);
				     	request.getSession().setAttribute("startdate", startdate.replaceAll("T", " "));
				     	request.getSession().setAttribute("enddate", enddate.replaceAll("T", " "));
				     	response.getWriter().print(jsonObject.toString());
				     	
				         } 				
				catch(Exception e)
				{
					e.printStackTrace();
				}
		 }
		 
		 else if(param.equals("getSandBoatReport"))
		 {
				try
				{
					String startdate=request.getParameter("startdate");
					String enddate = request.getParameter("enddate");
					String custId = request.getParameter("custId");
					String jspName=null;
					jspName=request.getParameter("jspName");
					jsonObject =new JSONObject();
					jsonArray = new JSONArray();
					ArrayList finlist = sandfunc.getSandBoatReport(systemId,custId,startdate,enddate);
					jsonArray = (JSONArray) finlist.get(0);
					jsonObject.put("SandBoatGridRoot", jsonArray);
					  jsonArray = (JSONArray) finlist.get(0);
				     	if (jsonArray.length() > 0) {
				     	jsonObject.put("SandBoatGridRoot", jsonArray);
				     	}
				     	else
				     	{
				     	jsonObject.put("SandBoatGridRoot", "");
				     	}	
				     	ReportHelper reportHelper = (ReportHelper) finlist.get(1);
				     	request.getSession().setAttribute(jspName, reportHelper);
				     //	request.getSession().setAttribute("custId", custName);
				     	request.getSession().setAttribute("startdate", startdate.replaceAll("T", " "));
				     	request.getSession().setAttribute("enddate", enddate.replaceAll("T", " "));
				     	response.getWriter().print(jsonObject.toString());
				     	
				         } 				
				catch(Exception e)
				{
					e.printStackTrace();
				}
		 }
		 else if(param.equals("getSandPortList")) {

				try {
					jsonObject = new JSONObject();
					jsonArray = sandfunc.getSandPortList(String.valueOf(clientId), systemId);
					if(jsonArray.length() > 0) {
						jsonObject.put("sandPortStoreRoot", jsonArray);
					} else {
						jsonObject.put("sandPortStoreRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		 else if (param.equals("saveSandPortQuantity")) {
				try {
					String buttonValue = request.getParameter("buttonValue");
					String dateVal = request.getParameter("dateVal").replace("T", " ");
					String sandPort = request.getParameter("sandPort");
					String sandPortId = request.getParameter("sandPortId");
					String excavatedQty = request.getParameter("excavatedQty");
					String qtyMeasure=request.getParameter("qtyMeasure");
					String message = "";								
						if (buttonValue.equals("add")) {						 
							message = sandfunc.saveSandPortQuantity(dateVal, sandPort, sandPortId, excavatedQty, qtyMeasure, clientId,systemId,userId);
						}
							response.getWriter().print(message);					 
					} catch (Exception e) {
					e.printStackTrace();
				}
			} 
		 else if (param.equalsIgnoreCase("getSandPortQuantityData")) {
		        try {
		            String startDate = request.getParameter("startDate").replace("T", " ");
		            String endDate = request.getParameter("endDate").replace("T", " ");
		            String jspName = request.getParameter("jspName");
		            jsonArray = new JSONArray();
		            
		                ArrayList < Object > list = sandfunc.getSandPortQuantityData(clientId,systemId,startDate,endDate);
		                jsonArray = (JSONArray) list.get(0);
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("sandPortQuantityRoot", jsonArray);
							
							ReportHelper reportHelper = (ReportHelper) list.get(1);
							request.getSession().setAttribute(jspName, reportHelper);
							request.getSession().setAttribute("sdate",startDate.replace("T", " "));
							request.getSession().setAttribute("edate",endDate.replace("T", " "));
		                } else {
		                    jsonObject.put("sandPortQuantityRoot", "");
		                }
			                response.getWriter().print(jsonObject.toString());
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }
		 
		 else if(param.equals("getTotalDispatchedDetails")) {
			 	String startDate = request.getParameter("startDate").replace("T", " ");
	            String endDate = request.getParameter("endDate").replace("T", " ");
				try {
					jsonObject = new JSONObject();
					jsonArray = sandfunc.getTotalDispatchedDetails(String.valueOf(clientId), systemId, startDate, endDate);
					if(jsonArray.length() > 0) {
						jsonObject.put("totalDispatchedStoreRoot", jsonArray);
					} else {
						jsonObject.put("totalDispatchedStoreRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		 else if (param.equalsIgnoreCase("getstockLocation")) {
				try {
					String custId=request.getParameter("CustID");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
						jsonArray =sandfunc.getstockLocation(Integer.parseInt(custId),systemId);
						if (jsonArray.length() > 0) {
							jsonObject.put("stockStoreRoot", jsonArray);
						} else {
							jsonObject.put("stockStoreRoot", "");
						}
						response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			  }
		 
		 else if(param.equals("getAbstactDetails")) {
			    String Stockname = request.getParameter("stockname");
			    String uniqueid = request.getParameter("uniqueid");
			    String startDate = request.getParameter("startDate").replace("T", " ");
			 	String endDate = request.getParameter("endDate").replace("T", " ");
			 try {
				    jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = sandfunc.getAbstactDetails(startDate,endDate,Stockname,Integer.parseInt(uniqueid));
					if(jsonArray.length() > 0) {
						jsonObject.put("abstactroot1", jsonArray);
					} else {
						jsonObject.put("abstactroot1", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		 
		 else if(param.equals("getDetailedDetails")) {
			 String Stockname = request.getParameter("stockname");
			 String startDate = request.getParameter("startDate").replace("T", " ");
			 String endDate = request.getParameter("endDate").replace("T", " ");
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					jsonArray = sandfunc.getDetailedDetails(Stockname,startDate,endDate);
					if(jsonArray.length() > 0) {
						jsonObject.put("detailedroot", jsonArray);
					} else {
						jsonObject.put("detailedroot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		 else if (param.equals("activeOrInactiveDetails")) {
			 	String custId=request.getParameter("CustId");
				String applicationNo = request.getParameter("appNoModify");
				String reasonForInactive = request.getParameter("reasonForReject");
				String buttonValue = request.getParameter("buttonValue");
				String message = "";
				String status="";
				try {
					
					message = sandfunc.activeOrInactiveDetails(applicationNo,Integer.parseInt(custId),systemId,buttonValue,reasonForInactive);
					response.getWriter().print(message);
				} catch (IOException e) {
					e.printStackTrace();
				}

			}
		 else if (param.equals("verifyResendOTP")) {
			 try {	
				String custId=request.getParameter("CustId");
				String applicationNo = request.getParameter("appNoModify");
				String mobileNo = request.getParameter("mobileNo");
				String Otp = request.getParameter("OTPNumber");
				String buttonValue = request.getParameter("buttonValue");
				String message = "";
				String status="";
				
					if(buttonValue.equals("Resend")){
						message = sandfunc.regenerateOTP(applicationNo,Integer.parseInt(custId),systemId,mobileNo);
					}else if(buttonValue.equals("Verify")){
						message = sandfunc.verifyOTP(applicationNo,Integer.parseInt(custId),systemId,mobileNo,Otp,userId);
					}
					response.getWriter().print(message);
				} catch (IOException e) {
					e.printStackTrace();
				}

			}
		 else if (param.equals("getTpNos"))
			{
			try{
				jsonArray = new JSONArray();
		         jsonObject = new JSONObject();
		         String customerId=request.getParameter("CustId");
		      
		      jsonArray = sandpermitfunc.getTpNosForCredit(customerId,systemId);
		      if (jsonArray.length() > 0) {
		          jsonObject.put("tpNoRoot", jsonArray);
		      } else {
		          jsonObject.put("tpNoRoot", "");
		      }
					  response.getWriter().print(jsonObject.toString());
		      } catch (Exception e) {
		      	 e.printStackTrace();
		       }
		  }	
        return null;
       }
}
