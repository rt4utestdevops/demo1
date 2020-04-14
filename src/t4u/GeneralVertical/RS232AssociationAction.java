package t4u.GeneralVertical;

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
import t4u.functions.GeneralVerticalFunctions;

public class RS232AssociationAction extends Action{
	public ActionForward execute(ActionMapping map,ActionForm form,HttpServletRequest req,HttpServletResponse resp){
		try{
			HttpSession session = req.getSession();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			
			int systemId = 0;
			int clientId = 0;
			int offset = 0;
			int userId = 0;
			if(loginInfo != null){
				systemId = loginInfo.getSystemId();
				clientId = loginInfo.getCustomerId();
				offset = loginInfo.getOffsetMinutes();
				userId = loginInfo.getUserId();
			}
			String param = "";
			if(req.getParameter("param") != null){
				param = req.getParameter("param");
			}
			JSONArray jArr = new JSONArray();
			JSONObject obj = null;
			GeneralVerticalFunctions gf = new GeneralVerticalFunctions();

			if(param.equals("getAssociationDetails")){
				String vehicleNo = req.getParameter("vehicleNo");
				String unitTypeCode = req.getParameter("unitTypeCode");
				try{
					obj = new JSONObject();
						jArr = gf.getAssociationDetails(systemId,clientId,offset,vehicleNo,userId,unitTypeCode);
						if(jArr.length() > 0){
							obj.put("associationDetailsRoot", jArr);
						}else{
							obj.put("associationDetailsRoot", "");
						}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equalsIgnoreCase("getVehicleList")){
				try{
					obj = new JSONObject();
					jArr = gf.getVehicleList(systemId,clientId,userId);
					if(jArr.length() > 0){
						obj.put("VehicleNoRoot", jArr);
					}else{
						obj.put("VehicleNoRoot", "");
					}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			} else if(param.equals("saveAssociation")){
				try {
					String json = req.getParameter("json");
					String vehicleNo = req.getParameter("vehicleNo");
					String unitNo = req.getParameter("unitNo");
					String message="";
					boolean valid = true;
					ArrayList<String> categoryList = new ArrayList<String>();
					if(json != null){
						String st = "["+json+"]";
						JSONArray js = null;
						try{
							js = new JSONArray(st.toString());
						}catch(JSONException e){
							e.printStackTrace();
						}
						for(int i = 0; i<js.length(); i++){
							obj = js.getJSONObject(i);
							if(!obj.getString("categoryDI").equals("NA")){
								categoryList.add(obj.getString("categoryDI"));
							}
						}
						if(categoryList.size()>0){
							for(int j = 0; j<categoryList.size();j++){
								for(int k=j+1; k<categoryList.size();k++){
									if(categoryList.get(j).equals(categoryList.get(k))){
										message = categoryList.get(j)+" is repeated, please check.";
										valid = false;
									}
								}
							}
						}
						if(valid){
							message = gf.insertAssociationDetails(systemId,clientId,userId,js,vehicleNo,unitNo);
						}
						resp.getWriter().print(message.toString());
					}	
				}
				catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equalsIgnoreCase("getCategoryList")) {
				String type = req.getParameter("type");
				try {
					obj = new JSONObject();
					jArr = gf.getCategoryList(type);
					if (jArr.length() > 0) {
						obj.put("categoryCombostoreRoot", jArr);
					} else {
						obj.put("categoryCombostoreRoot", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {

				}
			}
			else if(param.equalsIgnoreCase("getIOTypeList")){
				String type = req.getParameter("type");
				try{
					obj = new JSONObject();
					jArr = gf.getIOTypeList(type);
					if(jArr.length() > 0){
						obj.put("ioTypeCombostoreRoot", jArr);
					}else{
						obj.put("ioTypeCombostoreRoot", "");
					}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			} 
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
}
