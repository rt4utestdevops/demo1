package t4u.ironMining;

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
import t4u.functions.IronMiningFunction;
import java.util.ArrayList;
public class PermitDetailsAction extends Action{

	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		ReportHelper reportHelper = null;
		LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId  = loginInfo.getSystemId();
		//int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		//int offset = loginInfo.getOffsetMinutes();
		int countryCode=loginInfo.getCountryCode();
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
		if (param.equalsIgnoreCase("getRefNumber")) {
			try {
				String CustomerId = request.getParameter("CustId");
				String tcid = request.getParameter("tcId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("") && tcid != null && !tcid.equals("")) {
					jsonArray =ironfunc.getRefNumber(Integer.parseInt(CustomerId), systemId,Integer.parseInt(tcid));
					if (jsonArray.length() > 0) {
						jsonObject.put("RefNumberRoot", jsonArray);
					} else {
						jsonObject.put("RefNumberRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} 
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getGradeData")) {
			try {
				String challanid= request.getParameter("challanid");
				String permitId = request.getParameter("permitId");
				String permitType=request.getParameter("permitType");
				String buttinValue=request.getParameter("buttinValue");
				String custId=request.getParameter("CustID");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (challanid != null && !challanid.equals("")) {
					jsonArray =ironfunc.getChallanGradeDetails(Integer.parseInt(challanid),Integer.parseInt(permitId),permitType,buttinValue,systemId,Integer.parseInt(custId));
					if (jsonArray.length() > 0) {
						jsonObject.put("gradeRoot", jsonArray);
					} else {
						jsonObject.put("gradeRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("gradeRoot", "");
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
				}
		else if (param.equalsIgnoreCase("getDataForExport")) {
			try {
				String orgCode= request.getParameter("orgCode");
				String CustomerId = request.getParameter("CustID");
				String mineralType=request.getParameter("mineralType");
				int routeId = Integer.parseInt(request.getParameter("routeId"));
				String permitType=request.getParameter("permitType");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("") && orgCode != null && !orgCode.equals("")) {
					jsonArray =ironfunc.getDetailsForExport(Integer.parseInt(orgCode),Integer.parseInt(CustomerId),systemId,mineralType,routeId,permitType);
					if (jsonArray.length() > 0) {
						jsonObject.put("exportRoot", jsonArray);
					} else {
						jsonObject.put("exportRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("exportRoot", "");
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
				}
//***********************************addpermitdetails***********************
		else if (param.equalsIgnoreCase("AddorModifyPermitDetails")) {
			try {

				String buttonValue = request.getParameter("buttonValue");
				String CustId=request.getParameter("CustId");
				String Mineral=request.getParameter("mineral");
				String Tcid=request.getParameter("tcid");
				String Date=request.getParameter("date");
				String Remarks=request.getParameter("remarks");
				String id= request.getParameter("Id");
				String Startdate= request.getParameter("startdate");
				String Enddate= request.getParameter("enddate");
				
				String Challanid= request.getParameter("challanid");
				String Permittype=request.getParameter("permittype");
				String CustName=request.getParameter("CustName");
				String finyear=request.getParameter("finyear");
				String permitreq=request.getParameter("permitreq");
				String ownertype=request.getParameter("ownertype");
				String applicationNo=request.getParameter("applicationno");
				String selectedRoute =request.getParameter("selectedRoute");
			    String message1="";
			    String json=request.getParameter("json");
			    String orgCode=request.getParameter("orgCode");
			    String buyingOrgId=request.getParameter("buyingOrgId");
			    String buyingOrgIdmodify="0";
			    
			    String Routeid= "0";
			    String countryModify="0";
			    String country="0";
			    String buyer=request.getParameter("buyer");
			    String ship=request.getParameter("ship");
			    String state="0";
			    String hubId="0";
			    String stateModify="0";
			    String orgCodeModify=request.getParameter("orgCodeModify");
			    String ImporteiPermitId="0";
			    String permitQuantity="0";
			    String stockName=request.getParameter("stockName");
			    String importType=request.getParameter("importType");
			    String importPurpose=request.getParameter("importPurpose");
			    
			    String vesselName =request.getParameter("vesselName");
			    String exportPermitNo=request.getParameter("exportPermitNo");
			    String exportPermitDate=request.getParameter("exportPermitDate");
			    String exportChallanNo=request.getParameter("exportChallanNo");
			    String exportChallanDate=request.getParameter("exportChallanDate");
			    String saleInvoiceNo=request.getParameter("saleInvoiceNo");
			    String saleInvoiceDate=request.getParameter("saleInvoiceDate");
			    String transportnType=request.getParameter("transportnType");
			    String status="";
			    String TcorgId="0";
			    String toLocation = request.getParameter("toLocation");
			    String destType = request.getParameter("destType");
			    
			    if(request.getParameter("routeid")!=null && !request.getParameter("routeid").equals(""))
			    {
			    	Routeid=request.getParameter("routeid");
			    }
			    if(request.getParameter("status")!=null && !request.getParameter("status").equals(""))
			    {
			    	status=request.getParameter("status");
			    }
			    if(request.getParameter("permitQuantity")!=null && !request.getParameter("permitQuantity").equals(""))
			    {
			    	permitQuantity=request.getParameter("permitQuantity");
			    }
			    
			    if(request.getParameter("ImporteiPermitId")!=null && !request.getParameter("ImporteiPermitId").equals(""))
			    {
			    	ImporteiPermitId=request.getParameter("ImporteiPermitId");
			    }
			    
			    if(request.getParameter("state")!=null && !request.getParameter("state").equals(""))
			    {
			    	state=request.getParameter("state");
			    }
			    if(request.getParameter("hubId")!=null && !request.getParameter("hubId").equals(""))
			    {
			    	hubId=request.getParameter("hubId");
			    }
			    if(request.getParameter("country")!=null && !request.getParameter("country").equals(""))
			    {
			    	country=request.getParameter("country");
			    }
			    
			    if(request.getParameter("stateModify")!=null && !request.getParameter("stateModify").equals(""))
			    {
			    	stateModify=request.getParameter("stateModify");
			    }
			    if(request.getParameter("countryModify")!=null && !request.getParameter("countryModify").equals(""))
			    {
			    	countryModify=request.getParameter("countryModify");
			    }
			    if(request.getParameter("orgCodeModify")!=null && !request.getParameter("orgCodeModify").equals(""))
			    {
			    	orgCodeModify=request.getParameter("orgCodeModify");
			    }
			    if(request.getParameter("buyingOrgIdmodify")!=null && !request.getParameter("buyingOrgIdmodify").equals(""))
			    {
			    	buyingOrgIdmodify=request.getParameter("buyingOrgIdmodify");
			    }
			    if(request.getParameter("TcorgId")!=null && !request.getParameter("TcorgId").equals(""))
			    {
			    	TcorgId=request.getParameter("TcorgId");
			    }
			    
			    if(Tcid==null||Tcid.equalsIgnoreCase(""))
			    {
			    	Tcid="0";
			    }
			    if(Challanid==null||Challanid.equalsIgnoreCase(""))
			    {
			    	Challanid="0";
			    }
			    if(orgCode==null||orgCode.equalsIgnoreCase(""))
			    {
			    	orgCode="0";
			    }
			    if(buyingOrgId==null||buyingOrgId.equalsIgnoreCase(""))
			    {
			    	buyingOrgId="0";
			    }
			    JSONObject obj = null;
				JSONArray js = null;
				if(json!=null)
				{
					String st = "["+json+"]";
					
					try
					{
						js = new JSONArray(st.toString());
					}
					catch (JSONException e)
				    {
						e.printStackTrace();
					}
				}
				if(buttonValue.equals("Add") && CustId != null && !CustId.equals(""))
				{
                     message1=ironfunc.addPermitdetails(Integer.parseInt(CustId),systemId,Mineral,Integer.parseInt(Tcid),Date,Remarks,Startdate,Enddate,
                    		 Integer.parseInt(Routeid),Integer.parseInt(Challanid),userId,Permittype,CustName,permitreq,ownertype,finyear,applicationNo,
                    		 js,Integer.parseInt(orgCode),buyer,ship,Integer.parseInt(country),Integer.parseInt(state),Integer.parseInt(buyingOrgId),ImporteiPermitId,Float.parseFloat(permitQuantity),stockName,importType,importPurpose,
                    		 vesselName,exportPermitNo,exportPermitDate,exportChallanNo,exportChallanDate,saleInvoiceNo,saleInvoiceDate,transportnType,Integer.parseInt(hubId),Integer.parseInt(TcorgId),toLocation,destType);
				}
				else if(buttonValue.equals("Modify") && CustId != null && !CustId.equals("") && status.equals("OPEN"))
				{
					message1=ironfunc.modifyPermitDetails(Integer.parseInt(CustId),systemId,Date,Remarks,Startdate,Enddate,Integer.parseInt(selectedRoute),userId,ownertype,finyear,applicationNo,Integer.parseInt(id),js,Permittype,buyer,ship,Integer.parseInt(countryModify),Integer.parseInt(stateModify),Integer.parseInt(buyingOrgIdmodify),vesselName,exportPermitNo,exportPermitDate,exportChallanNo,exportChallanDate,saleInvoiceNo,saleInvoiceDate,transportnType,importPurpose);
				}
				
				response.getWriter().print(message1);
			} catch (Exception e) {
				e.printStackTrace();
			}

	}
		 //***********************************getPermitDetails***********************************//
	     
	     if (param.equalsIgnoreCase("getPermitDetails")) {
		        try {
		        	ArrayList list=null;
		            String CustomerId = request.getParameter("CustId");
		            String jspName=request.getParameter("jspName");
					String customerName=request.getParameter("CustName");
					String fromDate=request.getParameter("startDate");
					int selectedPermitId = request.getParameter("selectedPermitId")!=null && !request.getParameter("selectedPermitId").equals("")?
							Integer.parseInt(request.getParameter("selectedPermitId")):0;
					int selectedOrgId = request.getParameter("selectedOrgId")!=null && !request.getParameter("selectedOrgId").equals("")?
							Integer.parseInt(request.getParameter("selectedOrgId")):0;
					int selectedBuyOrgId = request.getParameter("selectedBuyOrgId")!=null && !request.getParameter("selectedBuyOrgId").equals("")?
							Integer.parseInt(request.getParameter("selectedBuyOrgId")):0;
					fromDate = fromDate.replace('T', ' ');
					
					String endDate=request.getParameter("endDate");
					endDate=endDate.replace('T', ' ');
		            jsonArray = new JSONArray();
		            jsonObject = new JSONObject();
		            
		            if (CustomerId != null && !CustomerId.equals("")) {
		            	
		                list =ironfunc.getPermitDetails(systemId, Integer.parseInt(CustomerId), userId,fromDate,endDate,selectedPermitId,selectedOrgId,selectedBuyOrgId);
		                jsonArray = (JSONArray) list.get(0);
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("PermitDetailsRoot", jsonArray);
		                } else {
		                    jsonObject.put("PermitDetailsRoot", "");
		                }
		                reportHelper = (ReportHelper) list.get(1);
						request.getSession().setAttribute(jspName,reportHelper);
						request.getSession().setAttribute("custName", customerName);
		                response.getWriter().print(jsonObject.toString());
		            	
		            } else {
		                jsonObject.put("PermitDetailsRoot", "");
		                response.getWriter().print(jsonObject.toString());
		            }
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
	    	}
	     else if (param.equalsIgnoreCase("acknowledgeStatus")) {
	    		try {
	    			
	    			String CustomerId = request.getParameter("CustID");
	    			String permitNo=request.getParameter("permitNo");
	    	        String status=request.getParameter("status");
	    	        int routeId=0;
	    	        int permitId=0;
	    	        int buyOrgId=0;
	    	        int impPermitId=0;
	    	        int sourceHubId=0;
	    	        String mineralType=request.getParameter("mineralType");
	    	        String sourceT=request.getParameter("sourceT");
	    	        if(request.getParameter("routeId")!=null && !request.getParameter("routeId").equals("")){
	    	        	routeId=Integer.parseInt(request.getParameter("routeId"));
	    	        }
	    	        if(request.getParameter("permitId")!=null && !request.getParameter("permitId").equals("")){
	    	        	permitId=Integer.parseInt(request.getParameter("permitId"));
	    	        }
	    	        if(request.getParameter("buyOrgId")!=null && !request.getParameter("buyOrgId").equals("")){
	    	        	buyOrgId=Integer.parseInt(request.getParameter("buyOrgId"));
	    	        }
	    	        if(request.getParameter("impPermitId")!=null && !request.getParameter("impPermitId").equals("")){
	    	        	impPermitId=Integer.parseInt(request.getParameter("impPermitId"));
	    	        }
	    	        if(request.getParameter("sourceHubId")!=null && !request.getParameter("sourceHubId").equals("")){
	    	        	sourceHubId=Integer.parseInt(request.getParameter("sourceHubId"));
	    	        }
	    	        String message1="";
	    	        
	    			if (CustomerId != null && !CustomerId.equals("")) {
	    				message1  =ironfunc.updateAcknowledgementStatus(status,Integer.parseInt(CustomerId),permitNo, systemId,routeId,permitId,buyOrgId,mineralType,impPermitId,sourceHubId,sourceT);
	    				response.getWriter().print(message1);
	    			}
	    		} catch (Exception e) {
	    			e.printStackTrace();
	    		}
	    			}
	     else if (param.equalsIgnoreCase("finalsubmitStatus")) {
	    		try {
	    			
	    			String CustomerId = request.getParameter("CustID");
	    			String permitNo=request.getParameter("permitNo");
	    	        String status=request.getParameter("status");
	    	        String message1="";
	    			
	    			if (CustomerId != null && !CustomerId.equals("")) {
	    				message1  =ironfunc.updateFinalSubmitPermit(status,Integer.parseInt(CustomerId),permitNo, systemId);
	    				response.getWriter().print(message1);
	    			}
	    		} catch (Exception e) {
	    			e.printStackTrace();
	    		}
	    			}
	 	else if (param.equalsIgnoreCase("getPermitNumber")) {
			try {
				String CustomerId = request.getParameter("CustID");
				String permitType=request.getParameter("permitType");
				String shipName=request.getParameter("vesselName");
				String tcid="0";
				String orgCode="0";
				if(request.getParameter("orgCode")!=null && !request.getParameter("orgCode").equals("")){
					orgCode=request.getParameter("orgCode");
				}
				if(request.getParameter("tcId")!=null && !request.getParameter("tcId").equals("")){
					tcid=request.getParameter("tcId");
				}
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					jsonArray =ironfunc.getPermitNumber(Integer.parseInt(CustomerId), systemId,tcid,orgCode,permitType,shipName);
					if (jsonArray.length() > 0) {
						jsonObject.put("PermitNumberRoot", jsonArray);
					} else {
						jsonObject.put("PermitNumberRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("PermitNumberRoot", "");
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	 	else if (param.equalsIgnoreCase("getPermitDetailsForClosure")) {
			try {
				String permitId = request.getParameter("selectedPermitId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (permitId != null && !permitId.equals("")) {
					jsonArray =ironfunc.getPermitDetailsForClosure(Integer.parseInt(permitId));
					if (jsonArray.length() > 0) {
						jsonObject.put("PermitNumberRoot", jsonArray);
					} else {
						jsonObject.put("PermitNumberRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("PermitNumberRoot", "");
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	 	else if (param.equalsIgnoreCase("ClosePermitClosureDetails")) {
			try {

				String buttonValue = request.getParameter("buttonValue");
				String CustId=request.getParameter("CustId");
				String Tcid="0";
				String permitno= request.getParameter("permitno");
				String permitdate= request.getParameter("permitdate");
				String closedqty= request.getParameter("closedqty");
				String qty= request.getParameter("permitQty");
				String tripsheetqty= request.getParameter("tsQty");
			    String message1="";
			    String romAmt = request.getParameter("romAmt");
		        String permitName = request.getParameter("permitName");
		        String romQty=request.getParameter("romQty");
		        String orgCode="0";
		        String totalPayableRom=request.getParameter("totalPayableRom");
		        String srcTypeClose=request.getParameter("srcTypeClose");
		        String mineralType=request.getParameter("mineralType");
		        String processingFee=request.getParameter("processingFee");
		        String refundType=request.getParameter("refundType");
		        
		        if(request.getParameter("tcid")!=null && !request.getParameter("tcid").equals("")){
		        	Tcid=request.getParameter("tcid");
		        }
		        if(request.getParameter("orgCode")!=null && !request.getParameter("orgCode").equals("")){
		        	orgCode=request.getParameter("orgCode");
		        }
				if(buttonValue.equals("Close") && CustId != null && !CustId.equals(""))
				{
                     message1=ironfunc.closePermitClosuredetails(Integer.parseInt(CustId),systemId,Integer.parseInt(Tcid),permitno,permitdate,userId,
                    		 closedqty,qty,Float.parseFloat(tripsheetqty),Float.parseFloat(romAmt),permitName,Float.parseFloat(romQty),orgCode,
                    		 totalPayableRom,srcTypeClose,mineralType,processingFee,refundType);
                     response.getWriter().print(message1);
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}
				}
	     
	 	else if (param.equalsIgnoreCase("getorganizationCode")) {
			try {
				String CustomerId = request.getParameter("CustId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					jsonArray =ironfunc.getOrganizationCode(Integer.parseInt(CustomerId), systemId,userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("organizationCodeRoot", jsonArray);
					} else {
						jsonObject.put("organizationCodeRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} 
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	     
	 	else if (param.equalsIgnoreCase("getStockType")) {
			try {
				String orgCode = "0";
				String CustomerId = request.getParameter("CustID");
				String mineralType=request.getParameter("mineralType");
				int routeId = Integer.parseInt(request.getParameter("routeId"));
				String permitType=request.getParameter("permitType");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if(request.getParameter("orgCode")!=null && !request.getParameter("orgCode").equals("")){
					orgCode = request.getParameter("orgCode");
				}
					jsonArray =ironfunc.getStockType(Integer.parseInt(orgCode),Integer.parseInt(CustomerId),systemId,mineralType,routeId,permitType);
					if (jsonArray.length() > 0) {
						jsonObject.put("stockTypeRoot", jsonArray);
					} else {
						jsonObject.put("stockTypeRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	     
	 	else if (param.equalsIgnoreCase("getGrid2Data")) {
	 		try {
	 			ArrayList list=null;
	 			String CustomerId = request.getParameter("CustID");
	 			int id= Integer.parseInt(request.getParameter("id"));
	 			String permitType = request.getParameter("permitType");
	 			String mineralType=request.getParameter("mineralType");
	 			jsonArray = new JSONArray();
	 			jsonObject = new JSONObject();
	 			if (CustomerId != null && !CustomerId.equals("")) {
	 				list =ironfunc.getDataForGridForPermit(systemId,Integer.parseInt(CustomerId),userId,id,permitType,mineralType);
	 				jsonArray = (JSONArray) list.get(0);
	 				if (jsonArray.length() > 0) {
	 					jsonObject.put("otherRoot", jsonArray);
	 				} else {
	 					jsonObject.put("otherRoot", "");
	 				}
	 				response.getWriter().print(jsonObject.toString());
	 			} else {
	 				jsonObject.put("otherRoot", "");
	 				response.getWriter().print(jsonObject.toString());
	 			}
	 		} catch (Exception e) {
	 			e.printStackTrace();
	 		}
	 			}
	 	else if (param.equalsIgnoreCase("getCountry")) {
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			AdminFunctions adminF=new AdminFunctions();
			try {
				jsonArray =adminF.getCountryList();
				if (jsonArray.length() > 0) {
					jsonObject.put("countryRoot", jsonArray);
				} else {
					jsonObject.put("countryRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}		
	 	else if (param.equalsIgnoreCase("getStates")) {
			jsonObject = new JSONObject();
			jsonArray = new JSONArray();
			AdminFunctions adminF=new AdminFunctions();
			try {
					jsonArray=adminF.getStateList(String.valueOf(countryCode));
				if (jsonArray.length() > 0) {
					jsonObject.put("stateRoot", jsonArray);
				} else {
					jsonObject.put("stateRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}	
        else if(param.equals("getStatesnew")){
			
			String countryId="0";
			if(request.getParameter("countryid")!=null && !request.getParameter("countryid").equals("")){
				countryId=request.getParameter("countryid").trim();
			}
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if(!countryId.equals("0")){
				jsonArray=ironfunc.getStateList(countryId);
				}
				if(jsonArray.length()>0){
				jsonObject.put("stateRoot1", jsonArray);
				}else{
					jsonObject.put("stateRoot1", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in Action:-getStateList "+e.toString());
			}
			
		}
		else if (param.equalsIgnoreCase("getEwalletDetails")) {
			try {
				String CustomerId = request.getParameter("CustID");
				String permitId=request.getParameter("permitId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					jsonArray =ironfunc.getEwalletDetails(Integer.parseInt(CustomerId), systemId,Integer.parseInt(permitId));
					if (jsonArray.length() > 0) {
						jsonObject.put("eWalletRoot", jsonArray);
					} else {
						jsonObject.put("eWalletRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("PermitNumberRoot", "");
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
				}
		else if (param.equalsIgnoreCase("getTcNumber")) {
			try {
				String CustomerId = request.getParameter("CustID");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					jsonArray =ironfunc.getTCNumberDetailsForPermit(Integer.parseInt(CustomerId), systemId,userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("TcNumberRoot", jsonArray);
					} else {
						jsonObject.put("TcNumberRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} 
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getBuyingOrgName")) {
			try {
				String orgCode= request.getParameter("orgCode");
				String CustomerId = request.getParameter("CustID");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("") && orgCode != null && !orgCode.equals("")) {
					jsonArray =ironfunc.getBuyingOrgName(Integer.parseInt(CustomerId), systemId,userId,Integer.parseInt(orgCode));
					if (jsonArray.length() > 0) {
						jsonObject.put("buyingOrgRoot", jsonArray);
					} else {
						jsonObject.put("buyingOrgRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} 
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	     
		else if (param.equalsIgnoreCase("getImportedPermitNo")) {
			try {
				String custId="0";
				String orgCode="0";
				
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				
				if(request.getParameter("orgCode")!=null && !request.getParameter("orgCode").equals("")){
					orgCode=request.getParameter("orgCode");
				}
				if(request.getParameter("CustID")!=null && !request.getParameter("CustID").equals("")){
					custId=request.getParameter("CustID");
				}
					jsonArray =ironfunc.getImportedPermitNo(Integer.parseInt(custId), systemId,orgCode);
				
				if (jsonArray.length() > 0) {
					jsonObject.put("importedPermitNoRoot", jsonArray);
				} else {
					jsonObject.put("importedPermitNoRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}  
	     
		else if (param.equalsIgnoreCase("getGridDataForBauxiteChallan")) {
			try {
				ArrayList list=null;
				String challanid= request.getParameter("challanid");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (challanid != null && !challanid.equals("")) {
					list =ironfunc.getGridDataForBauxiteChallan(systemId,userId,Integer.parseInt(challanid));
					jsonArray = (JSONArray) list.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("BauxiteGradeRoot", jsonArray);
					} else {
						jsonObject.put("BauxiteGradeRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("BauxiteGradeRoot", "");
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	     
		else if (param.equalsIgnoreCase("getBauxiteChallan")) {
				try {
					String CustomerId = request.getParameter("CustId");
					String tcid = request.getParameter("tcId");
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					if (CustomerId != null && !CustomerId.equals("") && tcid != null && !tcid.equals("")) {
						jsonArray =ironfunc.getBauxiteChallan(Integer.parseInt(CustomerId), systemId,Integer.parseInt(tcid));
						if (jsonArray.length() > 0) {
							jsonObject.put("bauxiteChallanRoot", jsonArray);
						} else {
							jsonObject.put("bauxiteChallanRoot", "");
						}
						response.getWriter().print(jsonObject.toString());
					} 
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		else if (param.equalsIgnoreCase("InactiveStatus")) {
    		try {
    			
    			String CustomerId = request.getParameter("CustID");
    	        String status=request.getParameter("status");
    	        String id=request.getParameter("id");
    	        String message1="";
    			
    			if (CustomerId != null && !CustomerId.equals("") && id != null && !id.equals("")) {
    				message1  =ironfunc.InactiveStatus(status,Integer.parseInt(CustomerId),Integer.parseInt(id), systemId);
    				response.getWriter().print(message1);
    			}
    		} catch (Exception e) {
    			e.printStackTrace();
    		}
    	}
		else if (param.equalsIgnoreCase("approvedPermitDatesModify")) {
    		try {
    			String date= request.getParameter("date");
    			String startdate= request.getParameter("startdate");
				String enddate= request.getParameter("enddate");
    	        String id=request.getParameter("id");
    	        String remarks = request.getParameter("remarks");
    	        String vessel = request.getParameter("vessel");
    	        String buyer = request.getParameter("buyer");
    	        String grade = request.getParameter("grade");
    	        String permitType = request.getParameter("permitType");
    	        
    	        message="";
    			if (id != null && !id.equals("")) {
    				message=ironfunc.modifyApprovedPermits(date,startdate,enddate,Integer.parseInt(id),remarks,userId,vessel,buyer,grade,permitType);
    			}
    			response.getWriter().print(message);
    		} catch (Exception e) {
    			e.printStackTrace();
    		}
    	}
		else if (param.equalsIgnoreCase("getVesselNames")) {
			try {
				String CustId = request.getParameter("custId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustId != null && !CustId.equals("")) {
					jsonArray =ironfunc.getVesselNames(Integer.parseInt(CustId), systemId,userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("vesselNameRoot", jsonArray);
					} else {
						jsonObject.put("vesselNameRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} 
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getRSPermitNo")) {
			try {
				String custId = request.getParameter("custId");
				String orgId = request.getParameter("orgId");
				String mineralType = request.getParameter("mineralType");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (custId != null && !custId.equals("") && orgId != null && !orgId.equals("")) {
					jsonArray =ironfunc.getRSPermitNo(Integer.parseInt(custId), systemId,Integer.parseInt(orgId),mineralType);
					if (jsonArray.length() > 0) {
						jsonObject.put("rsPermitRoot", jsonArray);
					} else {
						jsonObject.put("rsPermitRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} 
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getHubLocation")) {
			try {
				String custId=request.getParameter("CustID");
				String permitType = request.getParameter("permitType");
				String orgId=request.getParameter("orgId");
				String mineral=request.getParameter("mineral");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
					jsonArray =ironfunc.getHubLocationForPermit(Integer.parseInt(custId),systemId,permitType,orgId,mineral);
					if (jsonArray.length() > 0) {
						jsonObject.put("sourceHubStoreRoot", jsonArray);
					} else {
						jsonObject.put("sourceHubStoreRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		  }
		else if (param.equalsIgnoreCase("getPermitsForCustomSearch")) {
			try {
				String custId = request.getParameter("custId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (custId != null && !custId.equals("")) {
					jsonArray =ironfunc.getPermitsForCustomSearch(systemId,Integer.parseInt(custId),userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("PermitsForSearchRoot", jsonArray);
					} else {
						jsonObject.put("PermitsForSearchRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("PermitsForSearchRoot", "");
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getOrgNamesForCustomSearch")) {
			try {
				String custId = request.getParameter("custId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (custId != null && !custId.equals("")) {
					jsonArray =ironfunc.getOrgNamesForCustomSearch(systemId,Integer.parseInt(custId),userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("OrgNamesForSearchRoot", jsonArray);
					} else {
						jsonObject.put("OrgNamesForSearchRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("OrgNamesForSearchRoot", "");
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}
	
}
