package t4u.GeneralVertical;

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
import t4u.functions.GeneralVerticalFunctions;

public class MaterialMasterAction extends Action{
	public ActionForward execute(ActionMapping map,ActionForm form,HttpServletRequest req,HttpServletResponse resp){
		try{
			HttpSession session = req.getSession();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			int systemId = 0;
			int clientId = 0;
			int offset = 0;
			int userId = 0;
			@SuppressWarnings("unused")
			int isLtsp = 0;
			@SuppressWarnings("unused")
			int nonCommHrs = 0;
			@SuppressWarnings("unused")
			String lang = "";
			@SuppressWarnings("unused")
			String zone="";
			if(loginInfo != null){
				systemId = loginInfo.getSystemId();
				clientId = loginInfo.getCustomerId();
				offset = loginInfo.getOffsetMinutes();
				userId = loginInfo.getUserId();
				isLtsp = loginInfo.getIsLtsp();
				nonCommHrs = loginInfo.getNonCommHrs();
				lang = loginInfo.getLanguage();
				zone=loginInfo.getZone();
			}
			
			String param = "";
			if(req.getParameter("param") != null){
				param = req.getParameter("param");
			}
			JSONArray jArr = new JSONArray();
			JSONObject obj = null;
			GeneralVerticalFunctions gf = new GeneralVerticalFunctions();
			
			if(param.equals("saveMaterialMasterDetails")){
				String materialName = req.getParameter("materialName");
				String message=gf.saveMaterialMasterDetails(materialName,systemId,userId,clientId,offset );
				resp.getWriter().print(message);
				
			}else if(param.equals("getMaterialMasterDetails")){
				try {
					obj = new JSONObject();
					jArr = new JSONArray();
					String customerId=req.getParameter("custId");
					if(customerId != null && !customerId.equals("")){
						jArr = gf.getMaterialMasterDetails(systemId,clientId);
						if(jArr.length()>0){
							obj.put("materialListRoot",jArr);
						}else{
							obj.put("materialListRoot","");
						}
					}else{
						obj.put("materialListRoot","");
					}
						
					resp.getWriter().print(obj.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			else if(param.equals("updateMaterialMasterDetails")){
				String materialName = req.getParameter("materialName");
				String id = req.getParameter("id");
				
				String message=gf.updateMaterialMasterDetails(materialName,systemId,userId,clientId,Integer.parseInt(id));
				resp.getWriter().print(message);
				
			}
			else if(param.equals("deleteMaterialMasterDetails")){
				String materialName = req.getParameter("materialName");
				String id = req.getParameter("id");
				
				String message=gf.deleteMaterialMasterDetails(materialName,systemId,userId,clientId,Integer.parseInt(id) );
				resp.getWriter().print(message);
				
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}		
}