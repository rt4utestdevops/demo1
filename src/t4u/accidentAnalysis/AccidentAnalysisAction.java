package t4u.accidentAnalysis;

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
import t4u.functions.AccidentAnalysisFunctions;

public class AccidentAnalysisAction extends Action{
	@Override
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId = loginInfo.getSystemId();
		int offset = loginInfo.getOffsetMinutes();
		String language = loginInfo.getLanguage();
		int userId = loginInfo.getUserId();
				
		AccidentAnalysisFunctions accidentAnalysisFunctions = new AccidentAnalysisFunctions();
		
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		/*******************************************************************************************************************************
		 * Getting Accident Case Information based on Customer Name
		 ********************************************************************************************************************************/
		if (param.equalsIgnoreCase("getAccidentCaseInformation")) {
			try {				
				String customerId = request.getParameter("clientId");
								
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if(customerId!= null && !customerId.equals("")){
					
					jsonArray = accidentAnalysisFunctions.getcaseInformationDetails(systemId, Integer.parseInt(customerId), offset, language);
										
					if (jsonArray.length() > 0) {
						jsonObject.put("AccidentCaseInformationRoot", jsonArray);
					} else {
						jsonObject.put("AccidentCaseInformationRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("AccidentCaseInformationRoot", "");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		/*******************************************************************************************************************************
		 * Getting Accident Compensation Information based on Customer Name
		 ********************************************************************************************************************************/
		if (param.equalsIgnoreCase("getAccidentCompensationInformation")) {
			try {				
				String customerId = request.getParameter("CustId");
				String caseId = request.getParameter("caseIdParam");			
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if(customerId!= null && !customerId.equals("") && caseId!= null && !caseId.equals("")){
					
					jsonArray = accidentAnalysisFunctions.getCompensationInformationDetails(Integer.parseInt(caseId), Integer.parseInt(customerId));
										
					if (jsonArray.length() > 0) {
						jsonObject.put("AccidentCompensationInformationRoot", jsonArray);
					} else {
						jsonObject.put("AccidentCompensationInformationRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("AccidentCompensationInformationRoot", "");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		/*******************************************************************************************************************************
		 * Getting Accident Look Up Master based on Customer Name and Accident type
		 ********************************************************************************************************************************/
		else if (param.equalsIgnoreCase("getAccidentLookUpMaster")) {
			try {
				String type = request.getParameter("Type");
				String customerId = request.getParameter("CustId");
				jsonObject = new JSONObject();
				if (type != null) {
					jsonArray = accidentAnalysisFunctions.getAccidentLookUpMaster(systemId, Integer.parseInt(customerId), type);
					jsonObject.put("typeRoot", jsonArray);
				} else {
					jsonObject.put("typeRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if (param.equalsIgnoreCase("getCaseNumber")) {
			try {

				String customerId = request.getParameter("CustId");
				jsonObject = new JSONObject();
				if (customerId != null) {
					jsonArray = accidentAnalysisFunctions.getCaseNumber(systemId, Integer.parseInt(customerId));
					jsonObject.put("CaseNumberRoot", jsonArray);
				} else {
					jsonObject.put("CaseNumberRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
						
		else if (param.equalsIgnoreCase("saveAccidentCaseInformation")) {
			String message = "";
			String whichButtonClicked = request.getParameter("buttonValue");
			String customerIdParam = request.getParameter("customerIdParam");
			String caseIdParam = request.getParameter("caseIdParam");
			String caseNumberParam = request.getParameter("caseNumberParam");
			String AssetNoParam = request.getParameter("AssetNoParam");
			String DriverIdParam = request.getParameter("DriverNameParam");
			String AccidentalTypeParam = request.getParameter("AccidentalTypeParam");
			String CollatedWithParam = request.getParameter("CollatedWithParam");					
			String OtherDetailsParam = request.getParameter("OtherDetailsParam");
			String LocationParam = request.getParameter("LocationParam");
			String DateTimeParam = request.getParameter("DateTimeParam");
			String LossOfLifeParam = request.getParameter("LossOfLifeParam");
			String InjuredParam = request.getParameter("InjuredParam");
			String InsuranceClaimedAmtparam = request.getParameter("InsuranceClaimedAmtparam");
			String FaultyVehicleParam = request.getParameter("FaultyVehicleParam");
			String SettlementParam = request.getParameter("SettlementParam");
			String CaseStatusParam = request.getParameter("CaseStatusParam");
			String AssetToAssetVehicleParam = request.getParameter("AssetToAssetVehicleParam");
			String AssetToAssetDriverNameParam = request.getParameter("AssetToAssetDriverNameParam"); 	
			
			try {
				if(customerIdParam != null && !customerIdParam.equals("")){
					if(whichButtonClicked.equals("add")){
						message = accidentAnalysisFunctions.saveAccidentCaseInformation(systemId, Integer.parseInt(customerIdParam), userId, caseNumberParam, AssetNoParam, DriverIdParam, AccidentalTypeParam, CollatedWithParam, OtherDetailsParam, LocationParam, DateTimeParam, LossOfLifeParam, InjuredParam,
								InsuranceClaimedAmtparam, FaultyVehicleParam, SettlementParam, CaseStatusParam, AssetToAssetVehicleParam, AssetToAssetDriverNameParam);

					} else if(whichButtonClicked.equals("modify")){
						message = accidentAnalysisFunctions.upadteAccidentCaseInformation(systemId, Integer.parseInt(customerIdParam), userId, caseIdParam, caseNumberParam, AssetNoParam, DriverIdParam, AccidentalTypeParam, CollatedWithParam, OtherDetailsParam, LocationParam, DateTimeParam, LossOfLifeParam, InjuredParam,
								InsuranceClaimedAmtparam, FaultyVehicleParam, SettlementParam, CaseStatusParam, AssetToAssetVehicleParam, AssetToAssetDriverNameParam);
					}
					response.getWriter().print(message);
				}				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}	
		
		else if (param.equalsIgnoreCase("saveAccidentCompensationInformation")) {
			String message = "";
			String whichButtonClicked = request.getParameter("compensationButtonValue");
			String customerIdParam = request.getParameter("customerIdParam");
			String caseIdParam = request.getParameter("caseIdParam");
			String CompensationIdPrefix = request.getParameter("CompensationIdPrefix");
			String ReferenceNumberParam = request.getParameter("ReferenceNumberParam");
			String CompensationTypeParam = request.getParameter("CompensationTypeParam");
			String ModeOfTransactionParam = request.getParameter("ModeOfTransactionParam");
			String TransactionTypeParam = request.getParameter("TransactionTypeParam");					
			String TransactionDateTimeParam = request.getParameter("TransactionDateTimeParam");
			String TransactionAmtparam = request.getParameter("TransactionAmtparam");
			String CheckOrDDParam = request.getParameter("CheckOrDDParam");
			String NextHearingDateParam = request.getParameter("NextHearingDateParam");
			String CompensationPaidIn = request.getParameter("CompensationPaidIn");
			String CompensationPaidOut = request.getParameter("CompensationPaidOut");
			String InternalExpenses = request.getParameter("InternalExpenses");
							
			try {
				if (customerIdParam != null && !customerIdParam.equals("") && caseIdParam != null && !caseIdParam.equals("")) {
					if (whichButtonClicked.equals("add")) {
						message = accidentAnalysisFunctions.saveAccidentCompensationInformation(Integer.parseInt(customerIdParam), userId, Integer.parseInt(caseIdParam), ReferenceNumberParam, CompensationTypeParam, ModeOfTransactionParam, TransactionTypeParam, TransactionDateTimeParam, TransactionAmtparam, CheckOrDDParam, NextHearingDateParam,CompensationPaidIn,CompensationPaidOut,InternalExpenses);

					} else if (whichButtonClicked.equals("modify") && CompensationIdPrefix != null && !CompensationIdPrefix.equals("")) {
						message = accidentAnalysisFunctions.upadteAccidentCompensationInformation(Integer.parseInt(customerIdParam), userId, Integer.parseInt(caseIdParam), Integer.parseInt(CompensationIdPrefix), ReferenceNumberParam, CompensationTypeParam, ModeOfTransactionParam, TransactionTypeParam, TransactionDateTimeParam, TransactionAmtparam, CheckOrDDParam, NextHearingDateParam,CompensationPaidIn,CompensationPaidOut,InternalExpenses);
					}
					response.getWriter().print(message);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if (param.equalsIgnoreCase("getAccidentExpenditureSummary")) {
			try {				
				String customerId = request.getParameter("CustId");
				String customerName = request.getParameter("CustName");
				String jspName = request.getParameter("jspName");
								
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if(customerId!= null && !customerId.equals("")){
					
					ArrayList<Object> accidentEpenditureSummary = accidentAnalysisFunctions.getAccidentExpenditureSummary(systemId, Integer.parseInt(customerId), language);
					jsonArray = (JSONArray) accidentEpenditureSummary.get(0);
					
					if (jsonArray.length() > 0) {
						jsonObject.put("AccidentExpenditureSummaryRoot", jsonArray);
					} else {
						jsonObject.put("AccidentExpenditureSummaryRoot", "");
					}
					ReportHelper reportHelper = (ReportHelper) accidentEpenditureSummary.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("customerName", customerName);
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("AccidentExpenditureSummaryRoot", "");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if (param.equalsIgnoreCase("getAccidentExpenditureDetails")) {
			try {				
				String customerId = request.getParameter("CustId");
				String customerName = request.getParameter("CustName");
				String assetNumber = request.getParameter("assetNumber");
				String jspName = request.getParameter("jspName");
								
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if(customerId!= null && !customerId.equals("") && assetNumber!= null && !assetNumber.equals("")){
					
					ArrayList<Object> accidentEpenditureDetails =  accidentAnalysisFunctions.getAccidentExpenditureDetails(systemId, Integer.parseInt(customerId), language, assetNumber);
					jsonArray = (JSONArray) accidentEpenditureDetails.get(0);
					
					if (jsonArray.length() > 0) {
						jsonObject.put("AccidentExpenditureDetailsRoot", jsonArray);
					} else {
						jsonObject.put("AccidentExpenditureDetailsRoot", "");
					}
					ReportHelper reportHelper = (ReportHelper) accidentEpenditureDetails.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("customerName", customerName);
					request.getSession().setAttribute("assetNumber", assetNumber);
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("AccidentExpenditureDetailsRoot", "");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if (param.equalsIgnoreCase("getAccidentVehicleNo")) {
			try {

				String customerId = request.getParameter("CustId");
				jsonObject = new JSONObject();
				if (customerId != null) {
					jsonArray = accidentAnalysisFunctions.getAccidentVehicleNo(systemId, Integer.parseInt(customerId));
					jsonObject.put("VehicleNoRoot", jsonArray);
				} else {
					jsonObject.put("VehicleNoRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
			}
		}
		
		return null;
	}	
}
