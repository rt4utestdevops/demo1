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
import org.json.JSONException;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.functions.CommonFunctions;
import t4u.functions.IronMiningFunction;

public class ChallanDetailsAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId = loginInfo.getSystemId();
		//int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		int offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		CommonFunctions cf = new CommonFunctions();
		IronMiningFunction ironfunc = new IronMiningFunction();
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		String message = "";
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equalsIgnoreCase("getPaymentAccHead")) {
			try {
				String CustomerId = request.getParameter("CustID");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					jsonArray = ironfunc.getPaymentACHead(Integer.parseInt(CustomerId), systemId);
					if (jsonArray.length() > 0) {
						jsonObject.put("paymentAccRoot", jsonArray);
					} else {
						jsonObject.put("paymentAccRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (param.equalsIgnoreCase("getClosedPermitNo")) {
			try {
				String CustomerId = request.getParameter("CustID");
				String tcId = request.getParameter("tcId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					jsonArray = ironfunc.getClosedPermitNo(Integer.parseInt(CustomerId), systemId,
							Integer.parseInt(tcId));
					if (jsonArray.length() > 0) {
						jsonObject.put("closePermitRoot", jsonArray);
					} else {
						jsonObject.put("closePermitRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("getMineOwner")) {
			try {
				String CustomerId = request.getParameter("CustID");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					jsonArray = ironfunc.getMineOwnerDetails(Integer.parseInt(CustomerId), systemId);
					if (jsonArray.length() > 0) {
						jsonObject.put("mineOwnerRoot", jsonArray);
					} else {
						jsonObject.put("mineOwnerRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("getTcNumber")) {
			try {
				String CustomerId = request.getParameter("CustID");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					jsonArray = ironfunc.getTCNumberDetails(Integer.parseInt(CustomerId), systemId, userId);
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
		} else if (param.equalsIgnoreCase("getMineralType")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = ironfunc.getMineralType(systemId);
				if (jsonArray.length() > 0) {
					jsonObject.put("mineralTypeRoot", jsonArray);
				} else {
					jsonObject.put("mineralTypeRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("getGradeAndRate")) {
			try {
				String mineralType = request.getParameter("mineralType");
				String custId = request.getParameter("CustID");
				String royaltyDate = request.getParameter("RoyaltyDate");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = ironfunc.getGradeAndRate(mineralType, royaltyDate, Integer.parseInt(custId), systemId);
				if (jsonArray.length() > 0) {
					jsonObject.put("gradeRoot", jsonArray);
				} else {
					jsonObject.put("gradeRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("saveormodifyChallanDetails")) {
			try {
				String buttonValue = request.getParameter("buttonValue");
				String CustomerId = request.getParameter("CustID");
				String paymentAccHead = request.getParameter("paymentAccHead");
				String type = request.getParameter("type");
				String tcNum = "0";
				String mineName = request.getParameter("mineName");
				String mineralType = request.getParameter("mineralType");
				String royalty = request.getParameter("royalty");
				String ChallanType = request.getParameter("challanType");
				String financeYr = request.getParameter("financeYr");
				String CustName = request.getParameter("CustName");
				String jasondata = request.getParameter("jasondata");
				String description = request.getParameter("description");
				String selectedPayAccHead = request.getParameter("selectedPayAccHead");
				String totalPayable = request.getParameter("totalPayable");
				String ewalletPayable = "0";
				String ewalletCheck = "No";
				String ewalletQbalance = "0";
				String processingFee = "0";
				String payableAmount = request.getParameter("payableAmount");
				String challanAmount = request.getParameter("challanAmount");
				float ewalletQty = 0;
				float eWalletAmount = 0;
				int ewalletId = 0;
				String processingFeeModify = request.getParameter("processingFeeModify");
				int uniqueId = 0;
				String closedPermitId = "0";
				String totalQty = request.getParameter("totalQty");
				String updatepayable = "";
				String date = request.getParameter("date");
				String transMonth = request.getParameter("TransMonth");
				String orgId = "0";
				if (request.getParameter("closePermit") != null && !request.getParameter("closePermit").equals("")) {
					closedPermitId = request.getParameter("closePermit");
				}
				if (request.getParameter("ewalletPayable") != null
						&& !request.getParameter("ewalletPayable").equals("")) {
					ewalletPayable = request.getParameter("ewalletPayable");
				}
				if (request.getParameter("ewalletCheck") != null && !request.getParameter("ewalletCheck").equals("")) {
					ewalletCheck = request.getParameter("ewalletCheck");
				}
				if (request.getParameter("ewalletQbalance") != null
						&& !request.getParameter("ewalletQbalance").equals("")) {
					ewalletQbalance = request.getParameter("ewalletQbalance");
				}
				if (request.getParameter("processingFee") != null
						&& !request.getParameter("processingFee").equals("")) {
					processingFee = request.getParameter("processingFee");
				}
				if (request.getParameter("updatepayable") != null
						&& !request.getParameter("updatepayable").equals("")) {
					updatepayable = request.getParameter("updatepayable");
				}
				if (request.getParameter("tcNum") != null && !request.getParameter("tcNum").equals("")) {
					tcNum = request.getParameter("tcNum");
				}
				if (request.getParameter("orgId") != null && !request.getParameter("orgId").equals("")) {
					orgId = request.getParameter("orgId");
				}
				if (buttonValue.equalsIgnoreCase("Modify")) {
					uniqueId = Integer.parseInt(request.getParameter("uniqueId"));
				}
				if (ChallanType.equalsIgnoreCase("ROM")) {
					ewalletQty = Float.parseFloat(request.getParameter("ewalletQty"));
					eWalletAmount = Float.parseFloat(request.getParameter("ewalletAmount"));
					ewalletId = Integer.parseInt(request.getParameter("ewalletId"));
				} else {
					ewalletQty = 0;
					eWalletAmount = 0;
				}
				String SLNO = null;
				JSONObject obj = null;
				JSONArray js = null;
				if (jasondata != null) {
					String st = "[" + jasondata + "]";

					try {
						js = new JSONArray(st.toString());
					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
				if (js.length() > 0) {
					for (int i = 0; i < js.length(); i++) {
						obj = js.getJSONObject(i);
						SLNO = obj.getString("SLNOIndex");
					}
					if (SLNO.contains("new") && buttonValue.equals("add")) {
						if (CustomerId != null) {
							message = ironfunc.saveChallanDetails(Integer.parseInt(CustomerId), paymentAccHead, type,
									tcNum, mineName, mineralType, royalty, ChallanType, financeYr, CustName, systemId,
									userId, js, description, Integer.parseInt(closedPermitId),
									Float.parseFloat(totalPayable), ewalletCheck, Float.parseFloat(ewalletPayable),
									Float.parseFloat(ewalletQbalance), Float.parseFloat(processingFee), ewalletQty,
									eWalletAmount, ewalletId, Float.parseFloat(payableAmount), date, transMonth);
						}
					} else if (buttonValue.equals("Modify")) {

						if (CustomerId != null) {
							message = ironfunc.modifyChallanDetails(Integer.parseInt(CustomerId), selectedPayAccHead,
									ChallanType, financeYr, systemId, userId, js, description, uniqueId,
									Float.parseFloat(totalPayable), ewalletCheck, Float.parseFloat(ewalletPayable),
									Float.parseFloat(ewalletQbalance), Float.parseFloat(processingFeeModify), ewalletId,
									eWalletAmount, Float.parseFloat(payableAmount), ewalletQty,
									Float.parseFloat(challanAmount), totalQty, updatepayable, date, transMonth);
						}
					}
				} else {
					if (buttonValue.equals("add")) {
						if (CustomerId != null) {
							message = ironfunc.saveChallanDetailsForOthers(Integer.parseInt(CustomerId), paymentAccHead,
									type, tcNum, mineName, mineralType, royalty, ChallanType, financeYr, CustName,
									systemId, userId, description, Float.parseFloat(totalPayable),
									Integer.parseInt(orgId), date, transMonth);
						}
					} else if (buttonValue.equals("Modify")) {
						if (CustomerId != null) {
							message = ironfunc.modifyChallanDetailsForOthers(Integer.parseInt(CustomerId),
									selectedPayAccHead, royalty, financeYr, systemId, userId, description, uniqueId,
									Float.parseFloat(totalPayable), ewalletCheck, Float.parseFloat(ewalletPayable),
									Float.parseFloat(ewalletQbalance), date, transMonth);
						}
					}
				}
				response.getWriter().print(message);

			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("Error in Challan Details Action:-saveORmodifyChallanDetails" + e.toString());
			}

		} else if (param.equalsIgnoreCase("getChallanDetails")) {
			try {
				ArrayList list = null;
				String CustomerId = request.getParameter("CustID");
				String jspName = request.getParameter("jspName");
				String customerName = request.getParameter("CustName");
				String fromDate = request.getParameter("startDate");
				fromDate = fromDate.replace('T', ' ');
				String endDate = request.getParameter("endDate");
				endDate = endDate.replace('T', ' ');
				int selectedChallanId = request.getParameter("selectedChallanId") != null
						&& !request.getParameter("selectedChallanId").equals("")
								? Integer.parseInt(request.getParameter("selectedChallanId"))
								: 0;
				int selectedOrgId = request.getParameter("selectedOrgId") != null
						&& !request.getParameter("selectedOrgId").equals("")
								? Integer.parseInt(request.getParameter("selectedOrgId"))
								: 0;
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					list = ironfunc.getChallanDetails(customerName, systemId, Integer.parseInt(CustomerId), userId,
							offset, fromDate, endDate, selectedChallanId, selectedOrgId);
					jsonArray = (JSONArray) list.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("challanDetailsRoot", jsonArray);
					} else {
						jsonObject.put("challanDetailsRoot", "");
					}
					ReportHelper reportHelper = (ReportHelper) list.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("custId", customerName);
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("acknowledgeSave")) {

			String messages = "";
			String ackuniqueId = request.getParameter("ackuniqueId");
			String CustomerId = request.getParameter("CustID");
			String challanNo = request.getParameter("challanNo");
			String nicChallanNo = request.getParameter("nicChallanNo");
			String nicChallanDate = request.getParameter("nicChallanDate");
			String bankTranscNumber = request.getParameter("bankTranscNumber");
			String bankName = request.getParameter("bankName");
			String branchName = request.getParameter("branchName");
			String amount = request.getParameter("amount");
			String payDesc = request.getParameter("payDesc");
			String dateTymOfGen = request.getParameter("dateTymOfGen");
			String challantype = request.getParameter("challantype");

			String DMFnicChallanNo = request.getParameter("DMFnicChallanNo");
			String DMFnicChallanDate = request.getParameter("DMFnicChallanDate");
			String DMFamount = request.getParameter("DMFamount");
			String NMETnicChallanNo = request.getParameter("NMETnicChallanNo");
			String NMETnicChallanDate = request.getParameter("NMETnicChallanDate");
			String NMETamount = request.getParameter("NMETamount");
			String PFnicChallanNo = request.getParameter("PFnicChallanNo");
			String PFnicChallanDate = request.getParameter("PFnicChallanDate");
			String GInicChallanNo = request.getParameter("GInicChallanNo");
			String GInicChallanDate = request.getParameter("GInicChallanDate");
			String PFamount = request.getParameter("PFamount");
			String GIamount = request.getParameter("GIamount");
			String mwallet = "0";
			String orgId = "0";
			if (request.getParameter("orgId") != null && !request.getParameter("orgId").equals("")) {
				orgId = request.getParameter("orgId");
			}
			if (request.getParameter("mwallet") != null && !request.getParameter("mwallet").equals("")) {
				mwallet = request.getParameter("mwallet");
			}
			try {

				messages = ironfunc.saveChallanAcknowledgementInformation(Integer.parseInt(CustomerId),
						Integer.parseInt(ackuniqueId), challanNo, nicChallanNo, nicChallanDate, bankTranscNumber,
						bankName, branchName, amount, payDesc, dateTymOfGen, systemId, userId, challantype,
						DMFnicChallanNo, DMFnicChallanDate, DMFamount, NMETnicChallanNo, NMETnicChallanDate, NMETamount,
						PFnicChallanNo, PFnicChallanDate, PFamount, Float.parseFloat(mwallet), Integer.parseInt(orgId),
						GInicChallanNo, GInicChallanDate, GIamount);
				response.getWriter().print(messages);
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("Inside Aknoledgement Action" + e.toString());
			}
		} else if (param.equalsIgnoreCase("getGridData")) {
			try {
				ArrayList list = null;
				String CustomerId = request.getParameter("CustID");
				String type = request.getParameter("type");
				int id = Integer.parseInt(request.getParameter("id"));
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					list = ironfunc.getGridData(systemId, Integer.parseInt(CustomerId), userId, type, id);
					jsonArray = (JSONArray) list.get(0);
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
		} else if (param.equalsIgnoreCase("getGrid2Data")) {
			try {
				ArrayList list = null;
				String CustomerId = request.getParameter("CustID");
				String type = request.getParameter("type");
				String tcno = request.getParameter("tcno");
				int id = Integer.parseInt(request.getParameter("id"));
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					list = ironfunc.getDataForGrid(systemId, Integer.parseInt(CustomerId), userId, type, id,
							Integer.parseInt(tcno));
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
		} else if (param.equalsIgnoreCase("finalSubmit")) {
			try {
				String CustomerId = request.getParameter("CustID");
				String uniqueId = request.getParameter("uniqueId");
				String status = request.getParameter("status");
				String ewalletUsed = request.getParameter("ewalletUsed");
				String challanType = request.getParameter("challanType");
				String totalQuantity = request.getParameter("totalQuantity");
				String tcNo = request.getParameter("tcNo");
				String ewalletAmount = "0";
				String payableAmount = "0";
				String ewalletPayable = "0";
				String ewalletId = "0";
				String eWalletBalance = "0";
				String mwallet = "0";
				String orgId = "0";
				String message1 = "";
				if (request.getParameter("ewalletId") != null && !request.getParameter("ewalletId").equals("")) {
					ewalletId = request.getParameter("ewalletId");
				}
				if (request.getParameter("ewalletAmount") != null
						&& !request.getParameter("ewalletAmount").equals("")) {
					ewalletAmount = request.getParameter("ewalletAmount");
				}
				if (request.getParameter("payableAmount") != null
						&& !request.getParameter("payableAmount").equals("")) {
					payableAmount = request.getParameter("payableAmount");
				}
				if (request.getParameter("ewalletPayable") != null
						&& !request.getParameter("ewalletPayable").equals("")) {
					ewalletPayable = request.getParameter("ewalletPayable");
				}
				if (request.getParameter("eWalletBalance") != null
						&& !request.getParameter("eWalletBalance").equals("")) {
					eWalletBalance = request.getParameter("eWalletBalance");
				}
				if (request.getParameter("orgId") != null && !request.getParameter("orgId").equals("")) {
					orgId = request.getParameter("orgId");
				}
				if (request.getParameter("mwallet") != null && !request.getParameter("mwallet").equals("")) {
					mwallet = request.getParameter("mwallet");
				}
				if (CustomerId != null && !CustomerId.equals("")) {
					message1 = ironfunc.updateFinalSubmit(status, Integer.parseInt(CustomerId), systemId,
							Integer.parseInt(uniqueId), ewalletId, ewalletUsed, challanType, totalQuantity,
							Float.parseFloat(ewalletAmount), Float.parseFloat(payableAmount),
							Float.parseFloat(ewalletPayable), Integer.parseInt(tcNo), Float.parseFloat(eWalletBalance),
							Integer.parseInt(orgId), Float.parseFloat(mwallet));
					response.getWriter().print(message1);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (param.equalsIgnoreCase("getEwalletNumber")) {
			try {
				String CustomerId = request.getParameter("custId");
				String permitId = request.getParameter("permitId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					jsonArray = ironfunc.getEwalletNumber(Integer.parseInt(CustomerId), systemId,
							Integer.parseInt(permitId));
					if (jsonArray.length() > 0) {
						jsonObject.put("eWalletRoot", jsonArray);
					} else {
						jsonObject.put("eWalletRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("deleteRecord")) {
			try {

				String CustomerId = request.getParameter("CustID");
				String uniqueId = request.getParameter("uniqueId");
				String status = request.getParameter("status");
				String message1 = "";
				if (CustomerId != null && !CustomerId.equals("")) {
					message1 = ironfunc.deleteChallan(status, Integer.parseInt(CustomerId), systemId,
							Integer.parseInt(uniqueId), userId);
					response.getWriter().print(message1);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equalsIgnoreCase("getGridDataForBauxite")) {
			try {
				ArrayList list = null;
				String CustomerId = request.getParameter("CustID");
				int id = Integer.parseInt(request.getParameter("id"));
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					list = ironfunc.getGridDataForBauxite(systemId, Integer.parseInt(CustomerId), userId, id);
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
		} else if (param.equalsIgnoreCase("getChallansForCustomSearch")) {
			try {
				String custId = request.getParameter("custId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (custId != null && !custId.equals("")) {
					jsonArray = ironfunc.getChallanssForCustomSearch(systemId, Integer.parseInt(custId), userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("ChallansForSearchRoot", jsonArray);
					} else {
						jsonObject.put("ChallansForSearchRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("ChallansForSearchRoot", "");
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("getOrgNamesForCustomSearch")) {
			try {
				String custId = request.getParameter("custId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (custId != null && !custId.equals("")) {
					jsonArray = ironfunc.getOrgNamesForChallanCustomSearch(systemId, Integer.parseInt(custId), userId);
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
