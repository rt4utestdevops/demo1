package t4u.sandmining;

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
import t4u.functions.CommonFunctions;
import t4u.functions.WebVideoStreamFunction;

public class WebVideoStreamAction extends Action{
	

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
        HttpSession session = request.getSession();
        String param = "";
        String zone = "";
        int systemId = 0;
        int userId = 0;
        int offset = 0;
        int clientId = 0;
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        WebVideoStreamFunction outdoorfunc = new WebVideoStreamFunction();
        systemId = loginInfo.getSystemId();
        clientId=loginInfo.getCustomerId();
        zone = loginInfo.getZone();
        userId = loginInfo.getUserId();
        offset = loginInfo.getOffsetMinutes();
        String lang = loginInfo.getLanguage();
        zone = loginInfo.getZone();
        JSONArray jsonArray = null;
        JSONObject jsonObject = new JSONObject();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }
        if (param.equals("getRtsplinks")) {
            try {
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                int clientid = Integer.parseInt(request.getParameter("customerid"));
               
                    jsonArray = outdoorfunc.getLinks(systemId,clientid);
                    if (jsonArray.length() > 0) {
                        jsonObject.put("panelDetailsRoot", jsonArray);
                    } else {
                        jsonObject.put("panelDetailsRoot", "");
                    }
                    response.getWriter().print(jsonArray.toString());
              
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
		return null; 
}

}
