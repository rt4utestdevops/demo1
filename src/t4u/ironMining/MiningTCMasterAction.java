package t4u.ironMining;



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
import t4u.functions.CommonFunctions;
import t4u.functions.IronMiningFunction;

public class MiningTCMasterAction extends Action{

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String param = "";
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		IronMiningFunction tcMaster = new IronMiningFunction();
		int systemId = loginInfo.getSystemId();
		String lang = loginInfo.getLanguage();
		int custid=loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		String zone=loginInfo.getZone();
		CommonFunctions cf = new CommonFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();

		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		//*****************************************************District Information ******************************************************//
		if (param.equals("getDistrictNames")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String stateId=request.getParameter("stateId");
				jsonArray = tcMaster.getDistrictNames(systemId,Integer.parseInt(stateId));
				if (jsonArray.length() > 0) {
					jsonObject.put("districtCodeRoot", jsonArray);
				} else {
					jsonObject.put("districtCodeRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 
		//*****************************************************Taluk Information ******************************************************//
		else  if (param.equals("gettalukNames")) {
			try {
				String DistId=request.getParameter("DistId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (DistId != null && !DistId.equals("")) {
					jsonArray = tcMaster.getTalukNames(systemId,Integer.parseInt(DistId));
					if (jsonArray.length() > 0) {
						jsonObject.put("talukRoot", jsonArray);
					} else {
						jsonObject.put("talukRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
				else {
					jsonObject.put("talukRoot", "");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 
 //*************************************************TC Mater Details **********************************************************************************************************//	    
	    
	     if  (param.equalsIgnoreCase("getTCMasterDetails")) {
	        try {
	            String CustId= request.getParameter("CustId");
	            String jspName=request.getParameter("jspName");
				String customerName=request.getParameter("CustName");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
	            if (CustId != null && !CustId.equals("")) {
	                ArrayList < Object > list1 = tcMaster.getTCMasterDetails( systemId ,lang,Integer.parseInt(CustId),zone, userId);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("getTCMasterDetails", jsonArray); 
	                } else {
	                    jsonObject.put("getTCMasterDetails", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
	                request.getSession().setAttribute("custId", customerName);
					response.getWriter().print(jsonObject.toString());
	            }
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	 }	
//-------------------------------------Insert/Modify TC Master Information-----------------------------------------------------------//
	     else if (param.equalsIgnoreCase("tcMasterAddModify")) {
		        try {
		        	String CustId= request.getParameter("CustID");
		        	String buttonValue = request.getParameter("buttonValue");
		        	String tcNumber = request.getParameter("tcNumber");
		        	String nameOfTheIssue = request.getParameter("nameOfTheIssue");
		        	String OrderNuber = request.getParameter("OrderNuber");
		        	String isuuedDate = request.getParameter("isuuedDate");
		        	String district= request.getParameter("district");
		        	String taluk = request.getParameter("taluk");
		        	String village= request.getParameter("village");
		        	String postOffice = request.getParameter("area");
		        	String status= request.getParameter("status");
		        	String id = request.getParameter("id");
		        	String districtModify= request.getParameter("districtModify");
		        	String talukModify = request.getParameter("talukModify");
		        	String regIbm=request.getParameter("regIbm");
		        	String mineCode=request.getParameter("mineCode");
		        	String mineCodeValue=request.getParameter("mineCodeValue");
		        	String mineralName=request.getParameter("mineralName");
		        	String mineName=request.getParameter("mineName");
		        	String state=request.getParameter("state");
		        	String faxNo=request.getParameter("faxNo");
		        	String phoneNo=request.getParameter("phoneNo");
		        	String emailId=request.getParameter("emailId");
		        	String stateModify=request.getParameter("stateModify");
		        	String EcCappingLimit=request.getParameter("EcCappingLimit");
		        	String processingPlant=request.getParameter("processingPlant");
		        	String walletLinked=request.getParameter("walletLinked");
		        	String pin="0";
		        	String hub="0";
		        	String hubModify="0";
		        	String mineCodeModify=request.getParameter("mineCodeModify");
		        	String minenamee=request.getParameter("minenamee");
		        	String leasearea=request.getParameter("leasearea");
		        	String year=request.getParameter("year");
		        	String ctoCode=request.getParameter("ctoCode");
		        	String ctoDate=request.getParameter("ctoDate");
		        	String mplEnh= request.getParameter("mplenh");
		        	String mplProd=request.getParameter("mplprod");
		        	String mpltCarry=request.getParameter("mpltcarry");
		        	String mplTrans=request.getParameter("mpltrans");
		        	String financial=request.getParameter("financialyear");
		            String message = "";
		            if (request.getParameter("pin")!= null && !request.getParameter("pin").equals("")) {
		            	pin = request.getParameter("pin");
		            }
		            if (request.getParameter("hub")!= null && !request.getParameter("hub").equals("")) {
		            	hub = request.getParameter("hub");
		            }
		            if (request.getParameter("hubModify")!= null && !request.getParameter("hubModify").equals("")) {
		            	hubModify = request.getParameter("hubModify");
		            }
		            if (buttonValue.equals("Add") && CustId != null && !CustId.equals("")) {
		              message = tcMaster.insertTCMasterInformation(tcNumber,nameOfTheIssue,OrderNuber,isuuedDate,Integer.parseInt(district),taluk,village,postOffice,status,Integer.parseInt(CustId),systemId,regIbm,mineCode,mineralName,mineName,Integer.parseInt(state),Integer.parseInt(pin),faxNo,phoneNo,emailId,userId,Float.parseFloat(EcCappingLimit),processingPlant,walletLinked,Integer.parseInt(hub),mineCodeValue,minenamee,Double.valueOf(leasearea),Integer.parseInt(year),ctoCode,ctoDate,mplEnh,mplProd,mpltCarry,mplTrans,financial);
		            } 
		            else if (buttonValue.equals("Modify")&& CustId != null && !CustId.equals("")) {
		              message = tcMaster.modifyTCMasterInformation(Integer.parseInt(id),tcNumber,nameOfTheIssue,OrderNuber,isuuedDate,Integer.parseInt(districtModify),Integer.parseInt(talukModify),village,postOffice,status,Integer.parseInt(CustId),systemId,regIbm,mineCodeModify,mineralName,mineName,Integer.parseInt(stateModify),Integer.parseInt(pin),faxNo,phoneNo,emailId,userId,Float.parseFloat(EcCappingLimit),processingPlant,walletLinked,Integer.parseInt(hubModify),mineCodeValue,minenamee,Double.valueOf(leasearea),Integer.parseInt(year),ctoCode,ctoDate,mplEnh,mplProd,mpltCarry,mplTrans);
		            }
		            response.getWriter().print(message);
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    } 
	   //-------------------------------------get TC Number for Mine Owner Master----------------------------------------------------------// 
	     else  if (param.equals("getTCNumber")) {
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					String custId=request.getParameter("CustId");
					if (custId != null && !custId.equals("")) {
						jsonArray = tcMaster.getTCNumber(Integer.parseInt(custId),systemId);
						if (jsonArray.length() > 0) {
							jsonObject.put("TCNoRoot", jsonArray);
						} else {
							jsonObject.put("TCNoRoot", "");
						}
						response.getWriter().print(jsonObject.toString());
					}
		            else {
		                jsonObject.put("TCNoRoot", "");
		                response.getWriter().print(jsonObject.toString());
		            }
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
//-------------------------------------get Type for Mine Owner Master-----------------------------------------------------------//    
	     else  if (param.equals("getType")) {
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
						jsonArray = tcMaster.getType();
						if (jsonArray.length() > 0) {
							jsonObject.put("TYPERoot", jsonArray);
						}else {
							jsonObject.put("TYPERoot", "");
						}
						response.getWriter().print(jsonObject.toString());
					}
				catch (Exception e) {
					e.printStackTrace();
				}
			}
//-------------------------------------Insert/Modify Mine Owner Master Information-----------------------------------------------------------//
	     else if (param.equalsIgnoreCase("addAndModifyMineOwnerDetails")) {
		        try {
		        	String CustId= request.getParameter("CustID");
		        	String buttonValue = request.getParameter("buttonValue");
		        	String tcNumber = request.getParameter("tcNumber");
		        	String TCID = request.getParameter("tcID");
		        	String year = request.getParameter("year");
		        	String name = request.getParameter("name");
		        	String lesseeName = request.getParameter("lesseeName");
		        	String state= request.getParameter("state");
		        	String district = request.getParameter("district");
		        	String taluk= request.getParameter("taluk");
		        	String village = request.getParameter("village");
		        	String postOffice= request.getParameter("postOffice");
		        	String address=request.getParameter("address");
		        	String pin=request.getParameter("pin");
		        	String phoneNo=request.getParameter("phoneNo");
		        	String contactPerson=request.getParameter("contactPerson");
		        	String panNo=request.getParameter("panNo");
		        	String tanNo=request.getParameter("tanNo");
		        	String banker=request.getParameter("banker");
		        	String branch=request.getParameter("branch");
		        	String stateModify=request.getParameter("stateModify");
		        	String id = request.getParameter("id");
		        	String districtModify= request.getParameter("districtModify");
		        	String talukModify = request.getParameter("talukModify");
		        	String faxNo=request.getParameter("faxNo");
		        	String emailId=request.getParameter("emailId");
		        	String tcid=request.getParameter("tCID");
		            String message = "";
		            if (buttonValue.equals("Add") && CustId != null && !CustId.equals("")) {
		              message = tcMaster.insertMineOwnerInformation(tcNumber,Integer.parseInt(TCID),year,name,lesseeName,Integer.parseInt(state),Integer.parseInt(district),Integer.parseInt(taluk),village,postOffice,address,Integer.parseInt(pin),phoneNo,contactPerson,panNo,tanNo,banker,branch,Integer.parseInt(CustId),systemId,userId,faxNo,emailId);
		            } 
		            else if (buttonValue.equals("Modify")&& CustId != null && !CustId.equals("")) {
		              message = tcMaster.modifyMineOwnerInformation(Integer.parseInt(id),Integer.parseInt(CustId),systemId,tcNumber,Integer.parseInt(tcid),year,name,lesseeName,Integer.parseInt(stateModify),Integer.parseInt(districtModify),Integer.parseInt(talukModify),village,postOffice,address,Integer.parseInt(pin),phoneNo,contactPerson,panNo,tanNo,banker,branch,userId,faxNo,emailId);
		            }
		            response.getWriter().print(message);
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    } 
 //*************************************************MINE OWNER MASTER Details **********************************************************************************************************//	    
		    
	     else if  (param.equalsIgnoreCase("getOwnerMasterDeatils")) {
	        try {
	            String CustId= request.getParameter("CustId");
	            String jspName=request.getParameter("jspName");
				String customerName=request.getParameter("CustName");
	            jsonArray = new JSONArray();
	            if (CustId != null && !CustId.equals("")) {
	                ArrayList < Object > list1 = tcMaster.getOwnerMasterDeatils( systemId ,Integer.parseInt(CustId) );
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("mineOwnerMasterDetailsRoot", jsonArray); 
	                } else {
	                    jsonObject.put("mineOwnerMasterDetailsRoot", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
	                request.getSession().setAttribute("custId", customerName);
	                response.getWriter().print(jsonObject.toString());   
	            }
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	 }	
	     
		//********************************Insert/Modify MineDetails********************************************************//
			else if (param.equalsIgnoreCase("AddorModifyMineDetails")) {
				try {

					String buttonValue = request.getParameter("buttonValue");
					String CustId=request.getParameter("CustId");
					String MineralCode=request.getParameter("mineralCode");
					String MiningName=request.getParameter("miningName");
					String IBMno=request.getParameter("ibmNo");
					String financialYear=request.getParameter("financialYear");
					String carryedEC=request.getParameter("carryedEC");
					String ecLimit=request.getParameter("EcLimit");
					String enhancedEC=request.getParameter("enhancedEC");
					String totalEC=request.getParameter("totalEC");
					String remarks=request.getParameter("remarks");
					String id= request.getParameter("id");
					String orgcode= request.getParameter("orgcode");
					String orgname= request.getParameter("orgname");
					String orgid= request.getParameter("orgid");
					String orgidModify=request.getParameter("orgidModify");
					String message="";
					//for(Object o:request.getParameterMap().keySet()) System.out.println((String)o+"::"+request.getParameter((String)o));
				
					if(buttonValue.equals("Add") && CustId != null && !CustId.equals(""))
					{
	                     message=tcMaster.addMiningdetails(MineralCode,MiningName,systemId,Integer.parseInt(CustId),IBMno,Double.parseDouble(ecLimit),userId,orgcode,orgname,orgid,financialYear,Double.parseDouble(carryedEC),Double.parseDouble(enhancedEC),remarks);
					}else if(buttonValue.equals("Modify") && CustId != null && !CustId.equals(""))
					{
						message=tcMaster.modifyMiningDetails(MineralCode,MiningName,systemId,Integer.parseInt(CustId),Integer.parseInt(id),IBMno,Double.parseDouble(ecLimit),userId,orgcode,orgname,orgidModify,Double.parseDouble(carryedEC),Double.parseDouble(enhancedEC),remarks,financialYear);
					}
					
					response.getWriter().print(message);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
	     
	     //***********************************getMineDetails***********************************//
	     
	     if (param.equalsIgnoreCase("getMineDetails")) {
		        try {
		        	ArrayList list=null;
		            String CustomerId = request.getParameter("CustId");
		            String jspName=request.getParameter("jspName");
					String customerName=request.getParameter("CustName");
		            jsonArray = new JSONArray();
		            jsonObject = new JSONObject();
		            
		            if (CustomerId != null && !CustomerId.equals("")) {
		            	
		                list =tcMaster.getMineDetails(systemId, Integer.parseInt(CustomerId), userId);
		                jsonArray = (JSONArray) list.get(0);
		            //    System.out.println(jsonArray.toString());
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("mineDetailsRoot", jsonArray);
		                } else {
		                    jsonObject.put("mineDetailsRoot", "");
		                }
		            ReportHelper reportHelper = (ReportHelper) list.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
	                request.getSession().setAttribute("custId", customerName);
	                response.getWriter().print(jsonObject.toString());
		            }
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
	    	}
	     
	     else if (param.equalsIgnoreCase("getMaxCarryForwardedEC")) {
		        try {
		            String custId = request.getParameter("custId");
					int orgId = request.getParameter("orgId")!=null?Integer.parseInt(request.getParameter("orgId")):0;
					String[] years = request.getParameter("year").split("-");
					String year = (Integer.parseInt(years[0])-1)+"-"+(Integer.parseInt(years[1])-1); 
		            jsonArray = new JSONArray();
		            jsonObject = new JSONObject();
		            
		            if (custId != null && !custId.equals("")) {
		            	jsonArray =tcMaster.getMaxCarryForwardedEC(systemId, Integer.parseInt(custId), orgId, year,request.getParameter("year"));
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("maxCarryedECRoot", jsonArray);
		                } else {
		                    jsonObject.put("maxCarryedECRoot", "");
		                }
	                response.getWriter().print(jsonObject.toString());
		            }
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
	    	} else if (param.equalsIgnoreCase("getMaxCarryForwardedTC")) {
		        try {
		            String custId = request.getParameter("custId");
					int MineId = request.getParameter("mineId")!=null?Integer.parseInt(request.getParameter("mineId")):0;
					String[] years = request.getParameter("year").split("-");
					String year = (Integer.parseInt(years[0])-1)+"-"+(Integer.parseInt(years[1])-1); 
		            jsonArray = new JSONArray();
		            jsonObject = new JSONObject();
		            
		            if (custId != null && !custId.equals("")) {
		            	jsonArray =tcMaster.getMaxCarryForwardedTC(systemId, Integer.parseInt(custId), MineId, year,request.getParameter("year"));
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("maxCarryedTCRoot", jsonArray);
		                } else {
		                    jsonObject.put("maxCarryedTCRoot", "");
		                }
	                response.getWriter().print(jsonObject.toString());
		            }
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
	    	}
		
	     else if  (param.equalsIgnoreCase("getHubForTCMaster")) {
	    	 String clientId=request.getParameter("clientId");
	    	 try {
	    		 
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
						jsonArray = tcMaster.getHubForTcMaster(Integer.parseInt(clientId), systemId,zone);
						if (jsonArray.length() > 0) {
							jsonObject.put("hubRoot", jsonArray);
						}else {
							jsonObject.put("hubRoot", "");
						}
						response.getWriter().print(jsonObject.toString());
					} catch (Exception e) {
	            e.printStackTrace();
	        }
	 }
	     
	     else if  (param.equalsIgnoreCase("getMineCodeForTCMaster")) {
	    	 String clientId=request.getParameter("clientId");
	    	 try {
	    		 
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
						jsonArray = tcMaster.getMineCodeForTcMaster(systemId,Integer.parseInt(clientId));
						if (jsonArray.length() > 0) {
							jsonObject.put("mineCodeRoot", jsonArray);
						}else {
							jsonObject.put("mineCodeRoot", "");
						}
						response.getWriter().print(jsonObject.toString());
					} catch (Exception e) {
	            e.printStackTrace();
	        }
	 }  
	     else if  (param.equalsIgnoreCase("getOrgcode")) {
	    	 String clientId=request.getParameter("clientId");
	    	 try {
	    		 
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
						jsonArray = tcMaster.getOrgcode(systemId,Integer.parseInt(clientId));
						if (jsonArray.length() > 0) {
							jsonObject.put("OrgcodeRoot", jsonArray);
						}else {
							jsonObject.put("OrgcodeRoot", "");
						}
						response.getWriter().print(jsonObject.toString());
					} catch (Exception e) {
	            e.printStackTrace();
	        }
	 }else if (param.equalsIgnoreCase("getProductionQty")) {
	        try {
	        	String tcId=request.getParameter("tcId");
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            	jsonArray =tcMaster.getProductionBalance(systemId,custid,tcId);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("proRoot", jsonArray);
	                } else {
	                    jsonObject.put("proRoot", "");
	                }
                response.getWriter().print(jsonObject.toString());
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
    	}

		return null;
	}


}


