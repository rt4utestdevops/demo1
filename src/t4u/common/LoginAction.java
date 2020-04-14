package t4u.common;

import java.util.ArrayList;
import java.util.Hashtable;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import t4u.beans.LoginInfoBean;
import t4u.beans.MapAPIConfigBean;
import t4u.util.MapAPIUtil;

public class LoginAction extends Action {
	ServletContext servletContext = null;

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		ActionForward forward = null;
		Hashtable<String, ArrayList<Object>> loggedInUserTable = new Hashtable<String, ArrayList<Object>>();
		try {
			HttpSession session = request.getSession(true);
			servletContext = session.getServletContext();
			String list = request.getParameter("list").toString().trim();
			String[] str = list.split(",");
			if (servletContext.getAttribute("loggedUsersTable") != null) {
				loggedInUserTable = (Hashtable) servletContext
						.getAttribute("loggedUsersTable");
				ArrayList<Object> loggedUsersDetails = (ArrayList<Object>) loggedInUserTable.get(str[10].trim().toUpperCase());
				if (loggedUsersDetails != null) {
					HttpSession sessionToInvalidate = (HttpSession) loggedUsersDetails
							.get(5);
					try {
						sessionToInvalidate.invalidate();
					} catch (Exception e) {
						System.out.println("Session is invalidated due to timeout for the user :: "+str[10].trim().toUpperCase());
					}
					loggedInUserTable.remove(str[10].trim().toUpperCase());
					servletContext.setAttribute("loggedUsersTable", loggedInUserTable);
				}
				session = request.getSession();
				ArrayList<Object> loggedUserDetails = new ArrayList<Object>();
				loggedUserDetails.add(str[0].trim());
				loggedUserDetails.add(str[1].trim());
				loggedUserDetails.add(str[2].trim());
				loggedUserDetails.add(str[10].trim());
				loggedUserDetails.add(session.getId());
				loggedUserDetails.add(session);
				loggedUserDetails.add(str[18].trim());
				loggedInUserTable.put(str[10].trim().toUpperCase(),
						loggedUserDetails);

			} else {
				ArrayList<Object> loggedUserDetails = new ArrayList<Object>();
				loggedUserDetails.add(str[0].trim());
				loggedUserDetails.add(str[1].trim());
				loggedUserDetails.add(str[2].trim());
				loggedUserDetails.add(str[10].trim());
				loggedUserDetails.add(session.getId());
				loggedUserDetails.add(session);
				loggedUserDetails.add(str[18].trim());
				loggedInUserTable.put(str[10].trim().toUpperCase(),
						loggedUserDetails);

			}

			LoginInfoBean loginInfo = new LoginInfoBean();
			loginInfo.setSystemId(Integer.parseInt(str[0].trim()));
			loginInfo.setCustomerId(Integer.parseInt(str[1].trim()));
			loginInfo.setUserId(Integer.parseInt(str[2].trim()));
			loginInfo.setLanguage(str[3].trim());
			loginInfo.setZone(str[4].trim());
			loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
			loginInfo.setSystemName(str[6].trim());
			loginInfo.setCategory(str[7].trim());
			loginInfo.setCustomerName(str[8].trim());
			loginInfo.setCategoryType(str[9].trim());
			loginInfo.setUserName(str[10].trim());
			loginInfo.setUserFirstName(str[11].trim().toUpperCase());
			loginInfo.setStyleSheetOverride(str[12]);
			session.setAttribute("userName", str[11].trim().toUpperCase());
			loginInfo.setLTSPName(str[13].trim());
			session.setAttribute("ltspName", str[13].trim());
			loginInfo.setIsLtsp(Integer.parseInt(str[14]));
			loginInfo.setCountryCode(Integer.parseInt(str[15]));
			loginInfo.setMapType(Integer.parseInt(str[16]));
			loginInfo.setNonCommHrs(Integer.parseInt(str[17]));
			loginInfo.setNewMenuStyle(str[18].trim());
//			if (str[19].trim().equals("true"))
//				loginInfo.setIsCustomerBasedData(true);
//			else
//				loginInfo.setIsCustomerBasedData(false);
			
			MapAPIUtil mapAPIUtil = new MapAPIUtil();
			MapAPIConfigBean mapAPIConfigBean = mapAPIUtil.getConfiguration(Integer.parseInt(str[0].trim()));
			loginInfo.setMapAPIConfig(mapAPIConfigBean);
			System.out.println("Session is created for the user :: "+str[10].trim().toUpperCase());
			session.setAttribute("loginInfoDetails", loginInfo);
			servletContext.setAttribute("loggedUsersTable", loggedInUserTable);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return forward;
	}

}
