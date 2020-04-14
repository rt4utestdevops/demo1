package t4u.containercargomanagement;

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
import t4u.functions.ContainerCargoManagementFunctions;

public class MasterApproveRejectAction extends Action {
	
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		HttpSession session = request.getSession();
		LoginInfoBean loginInfoBean = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId = loginInfoBean.getSystemId();
		int custId = loginInfoBean.getCustomerId();
		int offset = loginInfoBean.getOffsetMinutes();
		int userId = loginInfoBean.getUserId();
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		ContainerCargoManagementFunctions ccmFunc = new ContainerCargoManagementFunctions();
		
		String param = "";
		if(request.getParameter("param") != null) {
			param = request.getParameter("param");
		}
		
		if(param.equals("getMaster")) {

			jsonArray = ccmFunc.getMasterList(systemId, custId);
			if(jsonArray != null) {
				jsonObject.put("masterRoot", jsonArray);
			} else {
				jsonObject.put("masterRoot", "");
			}
//			System.out.println("accountHeaderRoot : "+jsonArray.toString());
			response.getWriter().print(jsonObject.toString());
			
		} else if(param.equals("getMasterDetails")) {
			String masterId = request.getParameter("masterId");
			
			switch(Integer.parseInt(masterId)) {
			case 1://
				jsonArray = ccmFunc.getPendingCustomerMaster(systemId, custId);
				break;
			case 2://
				jsonArray = ccmFunc.getPendingTollModelRateMaster(systemId, custId);
				break;
			case 3://
				jsonArray = ccmFunc.getPendingExpenseMaster(systemId, custId);
				break;
			case 4://
				jsonArray = ccmFunc.getPendingFuelRate(systemId, custId);
				break;
			case 5://
				jsonArray = ccmFunc.getPendingHSCMaster(systemId, custId);
				break;
			case 6://
				jsonArray = ccmFunc.getPendingLeaveMaster(systemId, custId);
				break;
			case 7://
				jsonArray = ccmFunc.getPendingDetentionMaster(systemId, custId);
				break;
			case 8://
				jsonArray = ccmFunc.getPendingConductorMaster(systemId, custId);
				break;
			case 9://
				jsonArray = ccmFunc.getPendingBillingAndUnloadingData(systemId, custId, 1);
				break;
			case 10://
				jsonArray = ccmFunc.getPendingBillingAndUnloadingData(systemId, custId, 2);
				break;
			default: 
				
				
			}
			
			if(jsonArray != null) {
				jsonObject.put("masterRoot", jsonArray);
			} else {
				jsonObject.put("masterRoot", "");
			}
//			System.out.println("accountHeaderRoot : "+jsonArray.toString());
			response.getWriter().print(jsonObject.toString());
			
		} else if(param.equals("getPendingMasterDetails")) {

			String masterId = request.getParameter("masterId");
			String id = request.getParameter("id");
			String principalId = request.getParameter("principalId");
			String consigneeId = request.getParameter("consigneeId");
			String detentionTypeId = request.getParameter("detentionTypeId");
			
			switch(Integer.parseInt(masterId)) {
			case 1://
				jsonArray = ccmFunc.getPendingCustomerMasterBasedOnId(systemId, custId, id);
				break;
			case 2://
				jsonArray = ccmFunc.getPendingTollModelRateBasedOnId(systemId, custId, id, offset);
				break;
			case 3://
				jsonArray = ccmFunc.getPendingExpenseMasterBasedOnId(systemId, custId, id, offset);
				break;
			case 4://
				jsonArray = ccmFunc.getPendingFuelRateBasedOnId(systemId, custId, id, offset);
				break;
			case 5://
				jsonArray = ccmFunc.getPendingHSCMasterBasedOnId(systemId, custId, id);
				break;
			case 6://
				jsonArray = ccmFunc.getPendingLeaveMasterBasedOnId(systemId, custId, id, offset);
				break;
			case 7://
				jsonArray = ccmFunc.getPendingDetentionMasterBasedOnId(systemId, custId, id, principalId, consigneeId, detentionTypeId);
				break;
			case 8://
				jsonArray = ccmFunc.getPendingConductorMasterBasedOnId(systemId, custId, id, offset);
				break;
			case 9://
				jsonArray = ccmFunc.getPendingBillingAndUnloadingDetails(systemId, custId, id, offset, 1);
				break;
			case 10://
				jsonArray = ccmFunc.getPendingBillingAndUnloadingDetails(systemId, custId, id, offset, 2);
				break;
			default: 
				
			}
			
			if(jsonArray != null) {
				jsonObject.put("masterPendingRoot", jsonArray);
			} else {
				jsonObject.put("masterPendingRoot", "");
			}
//			System.out.println("accountHeaderRoot : "+jsonArray.toString());
			response.getWriter().print(jsonObject.toString());
		
		} else if(param.equals("approve")) {
			String msg = "";
			String masterId = request.getParameter("masterId");
			String id = request.getParameter("id");
			String principalId = request.getParameter("principalId");
			String consigneeId = request.getParameter("consigneeId");
			String detentionTypeId = request.getParameter("detentionTypeId");
			
			switch(Integer.parseInt(masterId)) {
			case 1:	
				msg = ccmFunc.approveCustomerMaster(systemId, custId, id, offset);
				break;
			case 2://
				msg = ccmFunc.approveTollModelRateMaster(systemId, custId, id, offset);
				break;
			case 3://
				msg = ccmFunc.approveExpenseMaster(systemId, custId, id, offset);
				break;
			case 4://
				msg = ccmFunc.approveFuelRateMaster(systemId, custId, id);
				break;
			case 5://
				msg = ccmFunc.approveHSCMaster(systemId, custId, id);
				break;
			case 6://
				msg = ccmFunc.approveLeaveMaster(systemId, custId, id);
				break;
			case 7://
				msg = ccmFunc.approveDetentionMaster(systemId, custId, id, principalId, consigneeId, detentionTypeId);
				break;
			case 8://
				msg = ccmFunc.approveConductorMaster(systemId, custId, id);
				break;
			case 9://
				msg = ccmFunc.approveBillingAndUnloadingMaster(systemId, custId, id, 1);
				break;
			case 10://
				msg = ccmFunc.approveBillingAndUnloadingMaster(systemId, custId, id, 2);
				break;
			default: 
				
			}
			
			response.getWriter().print(msg);
		
		} else if(param.equals("reject")) {
			String msg = "";
			String masterId = request.getParameter("masterId");
			String id = request.getParameter("id");
			String principalId = request.getParameter("principalId");
			String consigneeId = request.getParameter("consigneeId");
			String detentionTypeId = request.getParameter("detentionTypeId");
			
			switch(Integer.parseInt(masterId)) {
			case 1://
				msg = ccmFunc.rejectCustomerMaster(systemId, custId, id, userId);
				break;
			case 2://
				msg = ccmFunc.rejectTollModelRateMaster(systemId, custId, id, userId);
				break;
			case 3://
				msg = ccmFunc.rejectExpenseMaster(systemId, custId, id, userId);
				break;
			case 4://
				msg = ccmFunc.rejectFuelRateMaster(systemId, custId, id, userId);
				break;
			case 5://
				msg = ccmFunc.rejectHSCMaster(systemId, custId, id, userId);
				break;
			case 6://
				msg = ccmFunc.rejectLeaveMaster(systemId, custId, id, userId);
				break;
			case 7://
				msg = ccmFunc.rejectDetentionMaster(systemId, custId, id, userId, principalId, consigneeId, detentionTypeId);
				break;
			case 8://
				msg = ccmFunc.rejectConductorMaster(systemId, custId, id, userId);
				break;
			case 9://
				msg = ccmFunc.rejectBillingAndUnloadingMaster(systemId, custId, id, userId);
				break;
			case 10://
				msg = ccmFunc.rejectBillingAndUnloadingMaster(systemId, custId, id, userId);
				break;
			default: 
				
			}
			
			response.getWriter().print(msg);
		
		}
		return null;
	}

}
