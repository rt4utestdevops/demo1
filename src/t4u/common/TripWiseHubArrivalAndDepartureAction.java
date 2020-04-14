package t4u.common;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.LabelValueBean;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.functions.CommonFunctions;


public class TripWiseHubArrivalAndDepartureAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) {
		String param = "";
		
		CommonFunctions sqlfunction = new CommonFunctions();
		
		HttpSession session = ((HttpServletRequest) request).getSession();
		LoginInfoBean logininfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		
		
		int systemId = logininfo.getSystemId();
		int clientIdNew = logininfo.getCustomerId();
		int userId = logininfo.getUserId();
		int offset = logininfo.getOffsetMinutes();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equals("getclients")) {
			
			JSONArray clientJsonArr = new JSONArray();
			clientJsonArr = sqlfunction.getClientNames(systemId, clientIdNew);
			try {
				JSONObject clientJsonObj = new JSONObject();
				clientJsonObj.put("clientRoot", clientJsonArr);
				response.getWriter().print(clientJsonObj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		if (param.equals("getvehilcesforclients")) {
			String clientId = request.getParameter("clientId");
			String group = request.getParameter("group");

			if (clientId != null && !clientId.equals("")) {
				JSONArray jsonArray = new JSONArray();
				JSONObject jsonObject = new JSONObject();

				jsonArray = sqlfunction.getVehiclesBasedOnGroup(String.valueOf(systemId), String.valueOf(clientId), userId,group);
				try {
					jsonObject = new JSONObject();

					jsonObject.put("clientVehicles", jsonArray);
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}
		else if(param.equals("getGroupForClient")){
			try{
				int clientId = 0;		
				String clientIdSelected = request.getParameter("globalClientId");
				if(clientIdSelected != null && !clientIdSelected.equals("")){
					 clientId = Integer.parseInt(clientIdSelected);
				}
				JSONArray jsonArray = new JSONArray();
				JSONObject jsonObject = new JSONObject();
				if(clientIdSelected != null){
						jsonArray = sqlfunction.getgroupnamesForAlert(systemId,clientId,userId);
						jsonObject.put("GroupStoreList", jsonArray);
				}
				else{
					    jsonObject.put("GroupStoreList", "");
				}
			response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e){
				e.printStackTrace();
			}
}
		
		return null;
	}


}
