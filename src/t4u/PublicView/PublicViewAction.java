package t4u.PublicView;

import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.ApplicationListener;



public class PublicViewAction extends Action{
	
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
	        String param = "";
	        Properties properties = ApplicationListener.prop;
			String eeslSystemId=properties.getProperty("eeslSystemId").trim();
			int systemId = Integer.parseInt(eeslSystemId);
	        int offset = 330;
	        JSONArray jsonArray = null;
	        JSONObject jsonObject = new JSONObject();
	        PublicViewFunction pvf = new PublicViewFunction();
	        if (request.getParameter("param") != null) {
	            param = request.getParameter("param").toString();
	        }
	        if(param.equals("getDashBoardDetails")){
				try {
					jsonObject = new JSONObject();
					jsonArray = pvf.getEvehicleInfo(systemId,offset);
					jsonObject.put("Details", jsonArray);
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}
		return null;
	}

}
	

