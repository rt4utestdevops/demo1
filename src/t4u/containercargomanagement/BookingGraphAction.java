package t4u.containercargomanagement;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;
import org.apache.struts.action.Action;
import t4u.beans.LoginInfoBean;
import t4u.functions.ContainerCargoManagementFunctions;
public class BookingGraphAction extends Action {
    public ActionForward execute(ActionMapping mapping, ActionForm form,
        HttpServletRequest request, HttpServletResponse response)
    throws Exception {
        String param = "";
        int systemId = 0;
        int offset = 0;
        int clientIdInt = 0;
        String clientId = "";
        HttpSession session = request.getSession();
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        ContainerCargoManagementFunctions conCargo = new ContainerCargoManagementFunctions();
        systemId = loginInfo.getSystemId();
        offset = loginInfo.getOffsetMinutes();
        clientIdInt = loginInfo.getCustomerId();
        JSONArray jsonArray = null;
        JSONObject jsonObject = new JSONObject();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }
        if (param.equals("getClientNames")) {
            jsonArray = conCargo.getClientNames(systemId, clientIdInt);
            try {
                jsonObject = new JSONObject();
                jsonObject.put("clientNameList", jsonArray);
                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (param.equals("GetCount")) {
            try {
                clientId = request.getParameter("CustId");
                String sDate = "";
                String sDateSplit[];
                String eDate = "";
                String eDateSplit[];
                if (request.getParameter("StartDate") != null && request.getParameter("EndDate") != null) {
                    if (request.getParameter("StartDate").contains("T")) {
                        sDateSplit = request.getParameter("StartDate").split("T");
                        sDate = sDateSplit[0] + " " + sDateSplit[1];
                    } else {
                    	sDate = request.getParameter("StartDate");
                    }
                    if (request.getParameter("EndDate").contains("T")) {
                        eDateSplit = request.getParameter("EndDate").split("T");
                        eDate = eDateSplit[0] + " " + eDateSplit[1];
                    } else {
                    	eDate = request.getParameter("EndDate");
                    }
                }
                if (clientId != null && !clientId.equals("")) {
                    clientIdInt = Integer.parseInt(clientId);
                }
                jsonObject = new JSONObject();
                jsonArray = conCargo.getBookingCount(systemId, clientIdInt, sDate, eDate, offset);
                jsonObject.put("CountstoreList", jsonArray);
                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return null;
    }
}