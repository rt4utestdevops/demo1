package t4u.democar;

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
import t4u.functions.DemoCarFunctions;


public class AssetGroupHubAssociationAction extends Action
{
	public ActionForward execute(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response)
	{
			HttpSession session = ((HttpServletRequest)request).getSession();
			LoginInfoBean  logininfo=(LoginInfoBean)session.getAttribute("loginInfoDetails"); 
			String systemid = String.valueOf(logininfo.getSystemId());
			int clientIdInt = logininfo.getCustomerId();
			int userId = logininfo.getUserId();
			JSONArray jsonArray = new JSONArray();
			JSONObject jsonObject = null;
		    String param = "";
			String zone = logininfo.getZone();
			
			DemoCarFunctions dcf = new DemoCarFunctions();
			CommonFunctions cf = new CommonFunctions();

			String message="";
			
			if(request.getParameter("param") != null)
			{
				param = request.getParameter("param").toString();
			}
	        
		   	if(param.equals("getNonAssociatedHubsData"))
		   	{
		   		 
					String clientIdSelected = request.getParameter("globalClientId");
					String groupId = request.getParameter("assetGroup");
	
					try
					{
						jsonObject = new JSONObject();
						if(clientIdSelected != null)  
						{
							clientIdInt = Integer.parseInt(clientIdSelected);
							jsonArray = dcf.getNonAssociatedHubsDetails(clientIdInt,Integer.parseInt(systemid),groupId,zone);
							jsonObject.put("reader1root", jsonArray);
	
						}
						else
						{
							jsonObject.put("reader1root", "");
						}
						response.getWriter().print(jsonObject.toString());	
					}
					catch(Exception e)
					{
						e.printStackTrace();
					}
	
			}
		   	else if(param.equals("getAssociatedHubsData"))
		   	{
		   		String clientIdSelected = request.getParameter("globalClientId");
				String groupId = request.getParameter("assetGroup");

				try
				{
					jsonObject = new JSONObject();
					if(clientIdSelected != null)  
					{
						clientIdInt = Integer.parseInt(clientIdSelected);
						jsonArray = dcf.getAssociatedHubsDetails(clientIdInt,Integer.parseInt(systemid),groupId,zone);
						jsonObject.put("reader2root", jsonArray);

					}
					else
					{
						jsonObject.put("reader2root", "");
					}
					response.getWriter().print(jsonObject.toString());	
				}
				catch(Exception e)
				{
					e.printStackTrace();
				}
		   	}
		   	else if(param.equals("getgroup"))
		    {
				try
				{
					String clientIdSelected = request.getParameter("globalClientId");
					
					jsonObject = new JSONObject();
					if(clientIdSelected != null)
					{
							jsonArray = cf.getgroupnames(Integer.parseInt(clientIdSelected),Integer.parseInt(systemid));
							jsonObject.put("GroupRoot", jsonArray);
					}
					else
					{
						    jsonObject.put("GroupRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
				catch(Exception e)
				{
					e.printStackTrace();
				}
		    }
		    else if(param.equals("Associate"))
		 	{
		 		try
		 		{
		 			String associateHubs = request.getParameter("associateHubs");
		    		String globalClientId = request.getParameter("globalClientId");
		    		String assetGroup = request.getParameter("assetGroup");

		 			if(associateHubs!=null)
		 			{
		 				 message = dcf.associateHubs(associateHubs,globalClientId,assetGroup,systemid,userId); 
		 			} 
		 				
		 		    response.getWriter().print(message);
		 		} 
		 		catch(Exception e)
		 		{
		 			System.out.println("Error in upDate else-if block"+e);
		 			e.printStackTrace();
		 		}
		 	}  
		    else if(param.equals("DisAssociate"))
		 	{
		 		try
		 		{
		 			String disassociateHubs = request.getParameter("disassociateHubs");
		    		String globalClientId = request.getParameter("globalClientId");
		    		String assetGroup = request.getParameter("assetGroup");

		 			if(disassociateHubs!=null)
		 			{
		 				 message = dcf.disassociateHubs(disassociateHubs,globalClientId,assetGroup,systemid,userId); 
		 			} 
		 				
		 		    response.getWriter().print(message);
		 		} 
		 		catch(Exception e)
		 		{
		 			System.out.println("Error in upDate else-if block"+e);
		 			e.printStackTrace();
		 		}
		 	}  
		   	return null;
	}

}