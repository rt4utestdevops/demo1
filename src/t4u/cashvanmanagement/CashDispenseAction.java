package t4u.cashvanmanagement;

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
import t4u.functions.CashVanManagementFunctions;

public class CashDispenseAction extends Action {
	public ActionForward execute(ActionMapping map,ActionForm form,HttpServletRequest request,HttpServletResponse response){
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId= loginInfo.getSystemId();
		int clientId = loginInfo.getCustomerId();
		int offset = loginInfo.getOffsetMinutes();
		String param = "";
		int userId = loginInfo.getUserId();
		if(request.getParameter("param") != null){
			param = request.getParameter("param");
		}
		CashVanManagementFunctions cvmFunc = new CashVanManagementFunctions();
		JSONArray jArray = new JSONArray();
		JSONObject obj = null;
	
		 if(param.equalsIgnoreCase("getGridForSummary")){
		    	JSONArray	jsonArray = new JSONArray();
				JSONObject jsonObjecT=new JSONObject();	
		    	try {
					   
			    	jsonArray = new JSONArray();
			    	jsonArray =cvmFunc.getGridForSummaryForCashDispense(systemId,clientId ) ;  
			    	if(jsonArray.length()>0){
						jsonObjecT.put("cashDispenseSummary", jsonArray);
					}else{
						jsonObjecT.put("cashDispenseSummary", "");
					}
			    	//System.out.println("jsonArray == "+jsonArray);
					response.getWriter().print(jsonObjecT.toString());
				} catch (Exception e) {
				e.printStackTrace();
				}
		    }
		 
		 if(param.equalsIgnoreCase("getGridForSummaryEnrouteDispense")){
		    	JSONArray	jsonArray = new JSONArray();
				JSONObject jsonObjecT=new JSONObject();	
		    	try {
					   
			    	jsonArray = new JSONArray();
			    	jsonArray =cvmFunc.getGridForSummaryEnrouteDispense(systemId,clientId ) ;  
			    	if(jsonArray.length()>0){
						jsonObjecT.put("getGridForSummaryEnrouteDispense", jsonArray);
					}else{
						jsonObjecT.put("getGridForSummaryEnrouteDispense", "");
					}
			    	//System.out.println("jsonArray == "+jsonArray);
					response.getWriter().print(jsonObjecT.toString());
				} catch (Exception e) {
				e.printStackTrace();
				}
		    }else if(param.equals("getRoute")){
				try{
					obj = new JSONObject();
					jArray = cvmFunc.getRouteNames(clientId,systemId);
					if(jArray.length() > 0){
						obj.put("routeRoot", jArray);
					}else{
						obj.put("routeRoot", "");
					}
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getCashDespenseViewDetail")){
				String routeId = "";
				String tripSheetNo = "";
				String date = "";
				String btnValue = request.getParameter("btnValue");
				if(btnValue != null && !btnValue.equals("")){
					if(btnValue.equals("Create")){
						routeId = request.getParameter("routeId");
					}else if(btnValue.equals("Modify")){
						tripSheetNo = request.getParameter("tripSheetNo");
			    		routeId = request.getParameter("routeId");
			    		date = request.getParameter("date");
					}
				}
				try{
					obj = new JSONObject();
					if(routeId != null && !routeId.equals("")){
						jArray = cvmFunc.getCashDespenseView(systemId,clientId,Integer.parseInt(routeId),tripSheetNo,date,btnValue);
						if(jArray.length() > 0){
							obj.put("cashDespenseDetailsViewRoot", jArray);
						}else{
							obj.put("cashDespenseDetailsViewRoot", "");
						}
					}else{
						obj.put("cashDespenseDetailsViewRoot", "");
					}
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getOnAccOf")){
				try{
					obj = new JSONObject();
					jArray = cvmFunc.getCustomerForVault(clientId, systemId);
					if(jArray.length() > 0){
						obj.put("onAccRoot", jArray);
					}else{
						obj.put("onAccRoot", "");
					}
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("saveCashDispense")){
				String json = request.getParameter("json");
				String routeId = request.getParameter("routeId");
				String date = request.getParameter("date");
				String message= "";
				String btnValue = request.getParameter("btnValue");
				String tripSheetNo = request.getParameter("tripSheetNo");
				ArrayList<String> sealNoList = new ArrayList<String>();
				ArrayList<String> checkNoList = new ArrayList<String>();
				ArrayList<String> jewellryNoList = new ArrayList<String>();
				ArrayList<String> foreignList = new ArrayList<String>();
				boolean valid = true;
				try{
					if(json != null){
						String st = "["+json+"]";
						JSONArray js = null;
						try{
							js = new JSONArray(st.toString());
							for(int i = 0; i<js.length(); i++){
								obj = js.getJSONObject(i);
								if(obj.getString("customerTypeDI").equals("Cash Delivery")&& obj.getString("sealedBagCashDI").contains("Sealed Bag")){
									if(obj.getString("sealNoDI").contains(",")){
										String array[] = obj.getString("sealNoDI").split(",");
										for(String s:array){
											sealNoList.add(s);
										}
									}else{
										sealNoList.add(obj.getString("sealNoDI"));
									}
								}
								if(obj.getString("customerTypeDI").equals("Cash Delivery")&& obj.getString("sealedBagCashDI").contains("Cheque")){
									if(obj.getString("checkNoDI").contains(",")){
										String array[] = obj.getString("checkNoDI").split(",");
										for(String s:array){
											checkNoList.add(s);
										}
									}else{
										checkNoList.add(obj.getString("checkNoDI"));
									}
								}
								if(obj.getString("customerTypeDI").equals("Cash Delivery")&& obj.getString("sealedBagCashDI").contains("Jewellery")){
									if(obj.getString("jewellaryNoDI").contains(",")){
										String array[] = obj.getString("jewellaryNoDI").split(",");
										for(String s:array){
											jewellryNoList.add(s);
										}
									}else{
										jewellryNoList.add(obj.getString("jewellaryNoDI"));
									}
								}
								if(obj.getString("customerTypeDI").equals("Cash Delivery")&& obj.getString("sealedBagCashDI").contains("Foreign Currency")){
									if(obj.getString("foreignCurrencyDI").contains(",")){
										String array[] = obj.getString("foreignCurrencyDI").split(",");
										for(String s:array){
											foreignList.add(s);
										}
									}else{
										foreignList.add(obj.getString("foreignCurrencyDI"));
									}
								}
							}
							if(sealNoList.size()>0){
								for(int j = 0; j<sealNoList.size();j++){
									for(int k=j+1; k<sealNoList.size();k++){
										if(sealNoList.get(j).equals(sealNoList.get(k))){
											message = "Same seal no selected for two records";
											valid = false;
										}
									}
								}
							}
							if(checkNoList.size()>0){
								for(int j = 0; j<checkNoList.size();j++){
									for(int k=j+1; k<checkNoList.size();k++){
										if(checkNoList.get(j).equals(checkNoList.get(k))){
											message = "Same check no selected for two records";
											valid = false;
										}
									}
								}
							}
							if(jewellryNoList.size()>0){
								for(int j = 0; j<jewellryNoList.size();j++){
									for(int k=j+1; k<jewellryNoList.size();k++){
										if(jewellryNoList.get(j).equals(jewellryNoList.get(k))){
											message = "Same jewellery ref. no selected for two records";
											valid = false;
										}
									}
								}
							}
							if(foreignList.size()>0){
								for(int j = 0; j<foreignList.size();j++){
									for(int k=j+1; k<foreignList.size();k++){
										if(foreignList.get(j).equals(foreignList.get(k))){
											message = "Same foreign currency no selected for two records";
											valid = false;
										}
									}
								}
							}
						}catch(org.json.JSONException e1){
							e1.printStackTrace();
						}
						if(valid){
							if(btnValue.equals("Create")){
								message = cvmFunc.saveCashDispenseDetails(js,systemId,clientId,Integer.parseInt(routeId),date,userId);
							}else if (btnValue.equals("Modify")){
								message = cvmFunc.modifyCashDispenseDetails(js,systemId,clientId,userId,tripSheetNo,date,Integer.parseInt(routeId));
							}
						}
						
						response.getWriter().println(message.toString());
					}
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getCurrentVaultDetails")){
				String cvsCustomerId = request.getParameter("cvsCustId");
				try{
					obj = new JSONObject();
					jArray = cvmFunc.getCurrentVaultDetails(systemId,clientId,Integer.parseInt(cvsCustomerId));
					if(jArray.length() > 0){
						obj.put("valutRoot", jArray);
					}else{
						obj.put("valutRoot", "");
					}
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getSealNo")){
				String customerId = request.getParameter("customerId");
				String btn = request.getParameter("btn");
				try{
					obj = new JSONObject();
					if(customerId != null && !customerId.equals("")){
						jArray = cvmFunc.getSelaNos(systemId,clientId,Integer.parseInt(customerId),btn);
						if(jArray.length() > 0){
							obj.put("sealNoRoot", jArray);
						}else{
							obj.put("sealNoRoot", "");
						}
					}else{
						obj.put("sealNoRoot", "");
					}
					
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getTotalAmount")){
				String sealNos = request.getParameter("sealNos");
				String cvsCustId = request.getParameter("cvsCustId");
				try{
					obj = new JSONObject();
					if(sealNos != null && !sealNos.equals("")){
						jArray = cvmFunc.getTotalAmount(systemId,clientId,sealNos,cvsCustId);
						obj.put("totalAmtRoot", jArray);
					}else{
						obj.put("totalAmtRoot", "0");
					}
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getDispenseHistory")){
				String startDate = request.getParameter("startDate");
				String endDate = request.getParameter("endDate");
				try{
					obj = new JSONObject();
					if(startDate != null && !startDate.equals("")){
						jArray =cvmFunc.getDispenseHistory(systemId,clientId,startDate,endDate) ;  
						if(jArray.length() > 0){
							obj.put("getDispenseHistoryRoot", jArray);
						}else{
							obj.put("getDispenseHistoryRoot", "");
						}
					}else{
						obj.put("getDispenseHistoryRoot", "");
					}
					response.getWriter().print(obj.toString());
				 }catch(Exception e) {
					 e.printStackTrace();
				 }
			}else if(param.equals("getCustomer")){
				try{
					obj = new JSONObject();
					jArray = cvmFunc.getAllCutomers(systemId,clientId);
					if(jArray.length() > 0){
						obj.put("CustomerRoot", jArray);
					}else{
						obj.put("CustomerRoot", "");
					}
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getAllCustomer")){
				try{
					obj = new JSONObject();
					jArray = cvmFunc.getCutomerswithALL(systemId,clientId);
					if(jArray.length() > 0){
						obj.put("CustomerRoot", jArray);
					}else{
						obj.put("CustomerRoot", "");
					}
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getVaultLedger")){
				String cvsCustId = request.getParameter("CustId");
				String startDate = request.getParameter("startDate");
				String endDate = request.getParameter("endDate");
				String custType = request.getParameter("custType");
				try{
					obj = new JSONObject();
					if(cvsCustId != null && !cvsCustId.equals("")){
						jArray = cvmFunc.getVaultLedgerDetails(systemId,clientId,Integer.parseInt(cvsCustId),startDate,endDate,offset,custType);
						if(jArray.length() > 0){
							obj.put("vaultLedgerRoot", jArray);
						}else{
							obj.put("vaultLedgerRoot", "");
						}
					}else{
						obj.put("vaultLedgerRoot", "");
					}
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getCurrentInventoryBalance")){
				String cvsCustId = request.getParameter("custId");
				try{
					obj = new JSONObject();
					if(cvsCustId != null && !cvsCustId.equals("")){
						jArray = cvmFunc.getCurrentInventoryBalance(systemId,clientId,Integer.parseInt(cvsCustId));
						if(jArray.length() > 0){
							obj.put("currentInventoryRoot", jArray);
						}else{
							obj.put("currentInventoryRoot", "");
						}
					}else{
						obj.put("currentInventoryRoot", "");
					}
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getDenominationGrid")){
				String cvsbusinessId = request.getParameter("cvsbusinessId");
				String uniqueId = request.getParameter("uniqueId");
				String businessId = request.getParameter("businessId");
				String btnValue = request.getParameter("btnValue");
				try{
					obj = new JSONObject();
					jArray = cvmFunc.getDenominationGrid(systemId,clientId,cvsbusinessId,Integer.parseInt(uniqueId),Integer.parseInt(businessId),btnValue);
					if(jArray.length() > 0){
						obj.put("atmRepRoot", jArray);
					}else{
						obj.put("atmRepRoot", "");
					}
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getDenominationDetails")){
				String cvsbusinessId = request.getParameter("cvsbusinessId");
				String uniqueId = request.getParameter("uniqueId");
				String businessId = request.getParameter("businessId");
				try{
					obj = new JSONObject();
					if(cvsbusinessId != null && !cvsbusinessId.equals("")){
						jArray = cvmFunc.getDenominationDetails(systemId,clientId,cvsbusinessId,Integer.parseInt(uniqueId),Integer.parseInt(businessId));
						if(jArray.length() > 0){
							obj.put("denominationStoreRoot", jArray);
						}else{
							obj.put("denominationStoreRoot", "");
						}
					}else{
						obj.put("denominationStoreRoot", "");
					}
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("SaveForReconcilation")){
				String message;
				String json = request.getParameter("json");
				String customer = request.getParameter("customer");
				String atmId = request.getParameter("atmId");
				String businessId = request.getParameter("businessId");
				String tripSheetNo = request.getParameter("tripNo");
				String uniqueId = request.getParameter("uniqueId");
				String date = request.getParameter("date");
				String tripId = request.getParameter("tripId");
				session.setAttribute("json", json);
				session.setAttribute("customer", customer);
				session.setAttribute("atmId", atmId);
				session.setAttribute("businessId", businessId);
				session.setAttribute("uniqueId", uniqueId);
				session.setAttribute("date", date);
				session.setAttribute("tripId", tripId);
				try{
					message = cvmFunc.saveReconciliationForAtmRep(systemId,clientId,json,uniqueId,tripSheetNo,userId);
					response.getWriter().println(message.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("amendment")){
				String message = "";
				String uniqueId = request.getParameter("uniqueId");
				String lastRow = request.getParameter("lastRow");
				String tripSheetNo = request.getParameter("tripSheetNo");
				try{
					message = cvmFunc.amendMentFunction(systemId,clientId,Integer.parseInt(uniqueId),lastRow,userId,tripSheetNo);
					response.getWriter().println(message.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			} else if(param.equals("getSuspenseReport")){
				String startDate = request.getParameter("startDate");
				String endDate = request.getParameter("endDate");
				String type = request.getParameter("type");
				try{
					obj = new JSONObject();
					if(startDate != null && !startDate.equals("")){
						jArray =cvmFunc.getSuspenseReportDetails(systemId,clientId,startDate,endDate,offset,type) ;  
						if(jArray.length() > 0){
							obj.put("getSuspenseReportRoot", jArray);
						}else{
							obj.put("getSuspenseReportRoot", "");
						}
					}else{
						obj.put("getSuspenseReportRoot", "");
					}
					response.getWriter().print(obj.toString());
				 }catch(Exception e) {
					 e.printStackTrace();
				 }
			}else if(param.equals("getCheckNo")){
				String customerId = request.getParameter("customerId");
				String btn = request.getParameter("btn");
				try{
					obj = new JSONObject();
					if(customerId != null && !customerId.equals("")){
						jArray = cvmFunc.getCheckNos(systemId,clientId,Integer.parseInt(customerId),btn);
						if(jArray.length() > 0){
							obj.put("checkNoRoot", jArray);
						}else{
							obj.put("checkNoRoot", "");
						}
					}else{
						obj.put("checkNoRoot", "");
					}
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getTotalCheckAmount")){
				String checkNos = request.getParameter("checkNos");
				String cvsCustId = request.getParameter("cvsCustId");
				try{
					obj = new JSONObject();
					if(checkNos != null && !checkNos.equals("")){
						jArray = cvmFunc.getTotalAmount(systemId,clientId,checkNos,cvsCustId);
						obj.put("totalCheckAmtRoot", jArray);
					}else{
						obj.put("totalCheckAmtRoot", "0");
					}
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getJewellary")){
				String customerId = request.getParameter("customerId");
				String btn = request.getParameter("btn");
				try{
					obj = new JSONObject();
					if(customerId != null && !customerId.equals("")){
						jArray = cvmFunc.getJewellaryNos(systemId,clientId,Integer.parseInt(customerId),btn);
						if(jArray.length() > 0){
							obj.put("jewellaryRoot", jArray);
						}else{
							obj.put("jewellaryRoot", "");
						}
					}else{
						obj.put("jewellaryRoot", "");
					}
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getForeignCurrency")){
				String customerId = request.getParameter("customerId");
				String btn = request.getParameter("btn");
				try{
					obj = new JSONObject();
					if(customerId != null && !customerId.equals("")){
						jArray = cvmFunc.getForeignCurrency(systemId,clientId,Integer.parseInt(customerId),btn);
						if(jArray.length() > 0){
							obj.put("foreignRoot", jArray);
						}else{
							obj.put("foreignRoot", "");
						}
					}else{
						obj.put("foreignRoot", "");
					}
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getTotalJewelleryAmount")){
				String checkNos = request.getParameter("checkNos");
				String cvsCustId = request.getParameter("cvsCustId");
				try{
					obj = new JSONObject();
					if(checkNos != null && !checkNos.equals("")){
						jArray = cvmFunc.getTotalAmount(systemId,clientId,checkNos,cvsCustId);
						obj.put("totalJewelleryAmtRoot", jArray);
					}else{
						obj.put("totalJewelleryAmtRoot", "0");
					}
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getTotalForeignAmount")){
				String checkNos = request.getParameter("checkNos");
				String cvsCustId = request.getParameter("cvsCustId");
				try{
					obj = new JSONObject();
					if(checkNos != null && !checkNos.equals("")){
						jArray = cvmFunc.getTotalAmount(systemId,clientId,checkNos,cvsCustId);
						obj.put("totalForeignAmtRoot", jArray);
					}else{
						obj.put("totalForeignAmtRoot", "0");
					}
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getShortExcessDetails")){
				String uId = request.getParameter("uId");
				String typeId = request.getParameter("typeId");
				try{
					obj = new JSONObject();
					jArray = cvmFunc.getShortExcessDetails(systemId,clientId,uId,typeId);
					if(jArray.length() > 0){
						obj.put("writeOffCloseRoot", jArray);
					}else{
						obj.put("writeOffCloseRoot", jArray);
					}
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("saveWriteOffOrClose")){
				String message;
				String json = request.getParameter("json");
				String uniqueId = request.getParameter("uniqueId");
				String cvsCustId = request.getParameter("cvsCustId");
				String tripSheetNo = request.getParameter("tripSheetNo");
				String remarks = request.getParameter("remarks");
				String chequeNo = request.getParameter("chequeNo");
				try{
					message = cvmFunc.updateWriteOffOrClose(systemId,clientId,json,uniqueId,userId,cvsCustId,tripSheetNo,remarks,chequeNo);
					response.getWriter().println(message.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("settlement")){
				String message = "";
				String uniqueId = request.getParameter("uniqueId");
				String cvsCustId = request.getParameter("cvsCustId");
				String tripSheerNo = request.getParameter("tripSheetNo");
				try{
					message = cvmFunc.settlementSuspenseRecord(systemId,clientId,uniqueId,cvsCustId,tripSheerNo,userId);
					response.getWriter().println(message.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("businessId")){
				String routeId = request.getParameter("routeId");
				String tripSheetNo = request.getParameter("tripSheetNo");
				try{
					obj = new JSONObject();
					jArray = cvmFunc.getNonAssignedBusinessIds(systemId,clientId,routeId,tripSheetNo);
					if(jArray.length() > 0){
						obj.put("businessIdRoot", jArray);
					}else{
						obj.put("businessIdRoot", "");
					}
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("insertNewBusiness")){
				String message = "";
				int onAccOf = 0;
				String onAccName = "";
				String sealOrCash = "";
				String sealNo = "";
				String chequeNo = "";
				String jewelleryNo = "";
				String foreignCurrencyNo = "";
				int denom5000 = 0;
				int denom2000 = 0;
				int denom1000 = 0;
				int denom500 = 0;
				int denom100 = 0;
				int denom50 = 0;
				int denom20 = 0;
				int denom10 = 0;
				int denom5 = 0;
				int denom2 = 0;
				int denom1 = 0;
				String routeId = request.getParameter("routeId");
				String tripSheetNo = request.getParameter("tripSheetNo");
				String businessType = request.getParameter("businessType");
				String businessId = request.getParameter("businessId");
				String cvsCustomerId = request.getParameter("cvsCustomerId");
				String cvsCustomerName = request.getParameter("cvsCustomerName");
				String date = request.getParameter("date");
				//--------------------t4u506 Begin ------------------------------//
				String DelivCustomerId = request.getParameter("customerId");
				String DelCustomerName = request.getParameter("deliveryLocationId");
				//-----------------------t4u end -----------------------------------//
				
				if(request.getParameter("onAccOf") != null && !request.getParameter("onAccOf").equals("")){
					onAccOf = Integer.parseInt(request.getParameter("onAccOf"));
				}
				if(request.getParameter("onAccName") != null && !request.getParameter("onAccName").equals("")){
					onAccName = request.getParameter("onAccName");
				}
				if(request.getParameter("sealOrCash") != null && !request.getParameter("sealOrCash").equals("")){
					sealOrCash = request.getParameter("sealOrCash");
				}
				if(request.getParameter("sealNo") != null && !request.getParameter("sealNo").equals("")){
					sealNo = request.getParameter("sealNo");
				}
				if(request.getParameter("chequeNo") != null && !request.getParameter("chequeNo").equals("")){
					chequeNo = request.getParameter("chequeNo");
				}
				if(request.getParameter("jewelleryNo") != null && !request.getParameter("jewelleryNo").equals("")){
					jewelleryNo = request.getParameter("jewelleryNo");
				}
				if(request.getParameter("foreignCurrencyNo") != null && !request.getParameter("foreignCurrencyNo").equals("")){
					foreignCurrencyNo = request.getParameter("foreignCurrencyNo");
				}
				if(request.getParameter("denom5000") != null && !request.getParameter("denom5000").equals("")){
					denom5000 = Integer.parseInt(request.getParameter("denom5000"));
				}
				if(request.getParameter("denom2000") != null && !request.getParameter("denom2000").equals("")){
					denom2000 = Integer.parseInt(request.getParameter("denom2000"));
				}
				if(request.getParameter("denom1000") != null && !request.getParameter("denom1000").equals("")){
					denom1000 = Integer.parseInt(request.getParameter("denom1000"));
				}
				if(request.getParameter("denom500") != null && !request.getParameter("denom500").equals("")){
					denom500 = Integer.parseInt(request.getParameter("denom500"));
				}
				if(request.getParameter("denom100") != null && !request.getParameter("denom100").equals("")){
					denom100 = Integer.parseInt(request.getParameter("denom100"));
				}
				if(request.getParameter("denom50") != null && !request.getParameter("denom50").equals("")){
					denom50 = Integer.parseInt(request.getParameter("denom50"));
				}
				if(request.getParameter("denom20") != null && !request.getParameter("denom20").equals("")){
					denom20 = Integer.parseInt(request.getParameter("denom20"));
				}
				if(request.getParameter("denom10") != null && !request.getParameter("denom10").equals("")){
					denom10 = Integer.parseInt(request.getParameter("denom10"));
				}
				if(request.getParameter("denom5") != null && !request.getParameter("denom5").equals("")){
					denom5 = Integer.parseInt(request.getParameter("denom5"));
				}
				if(request.getParameter("denom2") != null && !request.getParameter("denom2").equals("")){
					denom2 = Integer.parseInt(request.getParameter("denom2"));
				}
				if(request.getParameter("denom1") != null && !request.getParameter("denom1").equals("")){
					denom1 = Integer.parseInt(request.getParameter("denom1"));
				}
				try{
				/* message = cvmFunc.insertNewBusinessDetail(systemId,clientId,routeId,tripSheetNo,businessType,businessId,onAccOf,sealOrCash,sealNo,chequeNo,jewelleryNo,foreignCurrencyNo,
							denom5000,denom2000,denom1000,denom500,denom100,denom50,denom20,denom10,denom5,denom2,denom1,cvsCustomerId,cvsCustomerName,userId,onAccName,date);
					*/
					//New code t4u506 Begin //
					 message = cvmFunc.insertNewBusinessDetail(systemId,clientId,routeId,tripSheetNo,businessType,businessId,onAccOf,sealOrCash,sealNo,chequeNo,jewelleryNo,foreignCurrencyNo,
								denom5000,denom2000,denom1000,denom500,denom100,denom50,denom20,denom10,denom5,denom2,denom1,cvsCustomerId,cvsCustomerName,userId,onAccName,date,DelCustomerName,DelivCustomerId);
						
					//New code t4u506 end  //
					response.getWriter().println(message.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("insertJournalEntry")){
				String message = "";
				int denom5000 = 0;
				int denom2000 = 0;
				int denom1000 = 0;
				int denom500 = 0;
				int denom100 = 0;
				int dispUid = Integer.parseInt(request.getParameter("dispUID"));
				if(request.getParameter("denom5000") != null && !request.getParameter("denom5000").equals("")){
					denom5000 = Integer.parseInt(request.getParameter("denom5000"));
				}
				if(request.getParameter("denom2000") != null && !request.getParameter("denom2000").equals("")){
					denom2000 = Integer.parseInt(request.getParameter("denom2000"));
				}
				if(request.getParameter("denom1000") != null && !request.getParameter("denom1000").equals("")){
					denom1000 = Integer.parseInt(request.getParameter("denom1000"));
				}
				if(request.getParameter("denom500") != null && !request.getParameter("denom500").equals("")){
					denom500 = Integer.parseInt(request.getParameter("denom500"));
				}
				if(request.getParameter("denom100") != null && !request.getParameter("denom100").equals("")){
					denom100 = Integer.parseInt(request.getParameter("denom100"));
				}
				try{
					message = cvmFunc.insertJournalData(systemId,clientId,dispUid,denom5000,denom2000,denom1000,denom500,denom100);
					response.getWriter().println(message.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("insertPhysicalCashData")){
				String message = "";
				int pgdenom5000 = 0;
				int pgdenom2000 = 0;
				int pgdenom1000 = 0;
				int pgdenom500 = 0;
				int pgdenom100 = 0;
				int pbdenom5000 = 0;
				int pbdenom2000 = 0;
				int pbdenom1000 = 0;
				int pbdenom500 = 0;
				int pbdenom100 = 0;
				int rgdenom5000 = 0;
				int rgdenom2000 = 0;
				int rgdenom1000 = 0;
				int rgdenom500 = 0;
				int rgdenom100 = 0;
				int rbdenom5000 = 0;
				int rbdenom2000 = 0;
				int rbdenom1000 = 0;
				int rbdenom500 = 0;
				int rbdenom100 = 0;
				int dispUid = Integer.parseInt(request.getParameter("dispUID"));
				if( request.getParameter("pgdenom5000") != null && !request.getParameter("pgdenom5000").equals("")){
					pgdenom5000 = Integer.parseInt(request.getParameter("pgdenom5000"));
				}
				if( request.getParameter("pgdenom2000") != null && !request.getParameter("pgdenom2000").equals("")){
					pgdenom2000 = Integer.parseInt(request.getParameter("pgdenom2000"));
				}
				if( request.getParameter("pgdenom1000") != null && !request.getParameter("pgdenom1000").equals("")){
					pgdenom1000 = Integer.parseInt(request.getParameter("pgdenom1000"));
				}
				if( request.getParameter("pgdenom500") != null && !request.getParameter("pgdenom500").equals("")){
					pgdenom500 = Integer.parseInt(request.getParameter("pgdenom500"));
				}
				if( request.getParameter("pgdenom100") != null && !request.getParameter("pgdenom100").equals("")){
					pgdenom100 = Integer.parseInt(request.getParameter("pgdenom100"));
				}
				if( request.getParameter("pbdenom5000") != null && !request.getParameter("pbdenom5000").equals("")){
					pbdenom5000 = Integer.parseInt(request.getParameter("pbdenom5000"));
				}
				if( request.getParameter("pbdenom2000") != null && !request.getParameter("pbdenom2000").equals("")){
					pbdenom2000 = Integer.parseInt(request.getParameter("pbdenom2000"));
				}
				if( request.getParameter("pbdenom1000") != null && !request.getParameter("pbdenom1000").equals("")){
					pbdenom1000 = Integer.parseInt(request.getParameter("pbdenom1000"));
				}
				if( request.getParameter("pbdenom500") != null && !request.getParameter("pbdenom500").equals("")){
					pbdenom500 = Integer.parseInt(request.getParameter("pbdenom500"));
				}
				if( request.getParameter("pbdenom100") != null && !request.getParameter("pbdenom100").equals("")){
					pbdenom100 = Integer.parseInt(request.getParameter("pbdenom100"));
				}
				if( request.getParameter("rgdenom5000") != null && !request.getParameter("rgdenom5000").equals("")){
					rgdenom5000 = Integer.parseInt(request.getParameter("rgdenom5000"));
				}
				if( request.getParameter("rgdenom2000") != null && !request.getParameter("rgdenom2000").equals("")){
					rgdenom2000 = Integer.parseInt(request.getParameter("rgdenom2000"));
				}
				if( request.getParameter("rgdenom1000") != null && !request.getParameter("rgdenom1000").equals("")){
					rgdenom1000 = Integer.parseInt(request.getParameter("rgdenom1000"));
				}
				if( request.getParameter("rgdenom500") != null && !request.getParameter("rgdenom500").equals("")){
					rgdenom500 = Integer.parseInt(request.getParameter("rgdenom500"));
				}
				if( request.getParameter("rgdenom100") != null && !request.getParameter("rgdenom100").equals("")){
					rgdenom100 = Integer.parseInt(request.getParameter("rgdenom100"));
				}
				if( request.getParameter("rbdenom5000") != null && !request.getParameter("rbdenom5000").equals("")){
					rbdenom5000 = Integer.parseInt(request.getParameter("rbdenom5000"));
				}
				if( request.getParameter("rbdenom2000") != null && !request.getParameter("rbdenom2000").equals("")){
					rbdenom2000 = Integer.parseInt(request.getParameter("rbdenom2000"));
				}
				if( request.getParameter("rbdenom1000") != null && !request.getParameter("rbdenom1000").equals("")){
					rbdenom1000 = Integer.parseInt(request.getParameter("rbdenom1000"));
				}
				if( request.getParameter("rbdenom500") != null && !request.getParameter("rbdenom500").equals("")){
					rbdenom500 = Integer.parseInt(request.getParameter("rbdenom500"));
				}
				if( request.getParameter("rbdenom100") != null && !request.getParameter("rbdenom100").equals("")){
					rbdenom100 = Integer.parseInt(request.getParameter("rbdenom100"));
				}
				try{
					message = cvmFunc.insertPhysicalCashDetails(systemId,clientId,dispUid,pgdenom5000,pgdenom2000,pgdenom1000,pgdenom500,pgdenom100,pbdenom5000,pbdenom2000,pbdenom1000,
							pbdenom500,pbdenom100,rgdenom5000,rgdenom2000,rgdenom1000,rgdenom500,rgdenom100,rbdenom5000,rbdenom2000,rbdenom1000,rbdenom500,rbdenom100);
				response.getWriter().println(message.toString());	
				}catch(Exception e){
					e.printStackTrace();
				}
			} 
		 //************************************* t4u506 begin ****************************//
		 
			else if(param.equals("customerId")){
			//	String routeId = request.getParameter("routeId");
			//	String tripSheetNo = request.getParameter("tripSheetNo");
				try{
					obj = new JSONObject();
					jArray = cvmFunc.getCustomerNames(systemId,clientId);
					if(jArray.length() > 0){
						obj.put("customerIdRoot", jArray);
					}else{
						obj.put("customerIdRoot", "");
					}
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
		 
		 //************************************* t4u506 end ****************************//
		 
		 //************************************* t4u506 begin ****************************//
		 
			else if(param.equals("deliveryLocation")){
			//	String routeId = request.getParameter("routeId");
			//	String tripSheetNo = request.getParameter("tripSheetNo");
				String customerId = request.getParameter("customerId");
				try{
					obj = new JSONObject();
					jArray = cvmFunc.getDeliveryLocation(systemId,clientId,customerId);
					if(jArray.length() > 0){
						obj.put("deliveryLocationIdRoot", jArray);
					}else{
						obj.put("deliveryLocationIdRoot", "");
					}
					response.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
		 
		 //************************************* t4u506 end ****************************//
			
		return null;
	}
}
