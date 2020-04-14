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

public class LogOutAction extends Action {
	ServletContext servletContext = null;
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) {
		ActionForward forward = null;
		Hashtable<String, ArrayList<Object>> loggedInUserTable = new Hashtable<String, ArrayList<Object>>();
		try {
			String userNameToLogout = "";
			if (request.getParameter("username") != null) {
				userNameToLogout = request.getParameter("username").toString();
			}
			HttpSession session = request.getSession(false);
			servletContext = session.getServletContext();
			loggedInUserTable = (Hashtable) servletContext.getAttribute("loggedUsersTable");
			LoginInfoBean loginInfo= (LoginInfoBean) session.getAttribute("loginInfoDetails");
			if (loggedInUserTable != null && loginInfo!=null ) {				
				ArrayList<Object> loggedUsersDetails = (ArrayList<Object>) loggedInUserTable.get(userNameToLogout.trim().toUpperCase());				
				if (loggedUsersDetails != null) {
					response.setHeader("Cache-Control", "no-cache");
					response.setHeader("Cache-Control", "no-store");
					response.setHeader("Pragma", "no-cache");
					response.setDateHeader("Expires", 0);
					HttpSession sessionToInvalidate = (HttpSession) loggedUsersDetails.get(5);
					loggedInUserTable.remove(userNameToLogout.trim().toUpperCase());
					try {
						sessionToInvalidate.invalidate();
						System.out.println("Session is destoryed due to logout for the user :: "+userNameToLogout.trim().toUpperCase());
					} catch (Exception e) {
						//System.out.println("Session is destoryed due to logout for the user :: "+userNameToLogout.trim().toUpperCase());
					}
					servletContext.setAttribute("loggedUsersTable",loggedInUserTable);
				}

			} else {
				
				if(session!=null)
				{
					System.out.println("Session is already destoryed due to timeout for the user :: "+userNameToLogout.trim().toUpperCase());
					session.invalidate();
				}
			}			
			response.sendRedirect("/jsps/UserLogout.jsp?username="+ userNameToLogout);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return forward;
	}
}
