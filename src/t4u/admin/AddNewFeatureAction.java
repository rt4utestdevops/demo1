package t4u.admin;

import java.util.ArrayList;

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
import t4u.functions.AdminFunctions;
import t4u.functions.CommonFunctions;

public class AddNewFeatureAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		String param = "";
		String zone = "";
		int systemId = 0;
		int userId = 0;
		int offset = 0;
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		AdminFunctions adfunc = new AdminFunctions();
		systemId = loginInfo.getSystemId();
		zone = loginInfo.getZone();
		userId = loginInfo.getUserId();
		offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		String ltspName = loginInfo.getSystemName();
		String userName = loginInfo.getUserName();
		CommonFunctions cf = new CommonFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equalsIgnoreCase("getLTSP")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = adfunc.getLTSP();
				if (jsonArray.length() > 0) {
					jsonObject.put("LTSPRoot", jsonArray);
				} else {
					jsonObject.put("LTSPRoot", "");
				} 
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 

		else if (param.equalsIgnoreCase("getProcessType")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = adfunc.getProcessType();
				if (jsonArray.length() > 0) {
					jsonObject.put("processTypeRoot", jsonArray);
				} else {
					jsonObject.put("processTypeRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 

		else if (param.equalsIgnoreCase("getProcessName")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String processType=request.getParameter("processType");
				if (processType != null && !processType.equals("")) {
					jsonArray = adfunc.getProcessName(processType);
					if (jsonArray.length() > 0) {
						jsonObject.put("processNameRoot", jsonArray);
					} else {
						jsonObject.put("processNameRoot", "");
					}
				}else {
					jsonObject.put("processNameRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 


		else if (param.equalsIgnoreCase("getSubProcessName")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String processId=request.getParameter("processId");
				if (processId != null && !processId.equals("")) {
					jsonArray = adfunc.getSubProcessName(processId);
					if (jsonArray.length() > 0) {
						jsonObject.put("subProcessNameRoot", jsonArray);
					} else {
						jsonObject.put("subProcessNameRoot", "");
					}
				}else {
					jsonObject.put("subProcessNameRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 

		else if (param.equalsIgnoreCase("getSecondSubProcessName")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String processId=request.getParameter("processId");
				if (processId != null && !processId.equals("")) {
					jsonArray = adfunc.getSecondSubProcessName(processId);
					if (jsonArray.length() > 0) {
						jsonObject.put("subProcessStoreForSecondPanelRoot", jsonArray);
					} else {
						jsonObject.put("subProcessStoreForSecondPanelRoot", "");
					}
				}else {
					jsonObject.put("subProcessStoreForSecondPanelRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 
		else if (param.equalsIgnoreCase("getmenuGroupName")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String subProcessId=request.getParameter("subProcessId");
				if (subProcessId != null && !subProcessId.equals("")) {
					jsonArray = adfunc.getmenuGroupName(subProcessId);
					if (jsonArray.length() > 0) {
						jsonObject.put("menuGroupNameRoot", jsonArray);
					} else {
						jsonObject.put("menuGroupNameRoot", "");
					}
				}else {
					jsonObject.put("menuGroupNameRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 

		else if (param.equalsIgnoreCase("getPageLink")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = adfunc.getPageLink();
				if (jsonArray.length() > 0) {
					jsonObject.put("pageLinkRoot", jsonArray);
				} else {
					jsonObject.put("pageLinkRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 

		else if (param.equalsIgnoreCase("getMenuGroupNameForAddOnPackage")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String processNameFromFirstPanel = request.getParameter("processNameFromFirstPanel");
				String subProcessRawNameFromSecondPanel = request.getParameter("subProcessRawNameFromSecondPanel");
				//System.out.println("subProcessRawName======"   +processNameFromFirstPanel);
				//System.out.println("subProcessRawNameFromSecondPanel======"   +subProcessRawNameFromSecondPanel);
				if (processNameFromFirstPanel != null && !processNameFromFirstPanel.equals("") && subProcessRawNameFromSecondPanel != null && !subProcessRawNameFromSecondPanel.equals("") ) {
					jsonArray = adfunc.getMenuGroupNameForAddOnPackage(processNameFromFirstPanel,subProcessRawNameFromSecondPanel);
					if (jsonArray.length() > 0) {
						jsonObject.put("menuGroupNameComboForAddOnPackageRoot", jsonArray);
					} else {
						jsonObject.put("menuGroupNameComboForAddOnPackageRoot", "");
					}
				}else {
					jsonObject.put("menuGroupNameComboForAddOnPackageRoot", "");
				}

				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 

		else if (param.equalsIgnoreCase("getAddNewFeatureReport")) {
			try {
				String systemIdFromJsp = request.getParameter("systemIdFromJsp");
				jsonArray = new JSONArray();
				if (systemIdFromJsp != null && !systemIdFromJsp.equals("")) {
					ArrayList < Object > list1 = adfunc.getAddNewFeatureReport(Integer.parseInt(systemIdFromJsp));
					jsonArray = (JSONArray) list1.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("ltspMasterRoot", jsonArray);
					} else {
						jsonObject.put("ltspMasterRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("ltspMasterRoot", "");
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equalsIgnoreCase("addNewFeatureAddAndModify")) {
			try {
				String buttonValue = request.getParameter("buttonValue");
				String systemIdFromJsp = request.getParameter("systemIdFromJsp");
				String processType = request.getParameter("processType");
				String processName = request.getParameter("processName");
				String subProcessName = request.getParameter("subProcessName");
				String menuGroupName = request.getParameter("menuGroupName");
				String pageTitle = request.getParameter("pageTitle");
				String pageLink = request.getParameter("pageLink");
				String secondSubProcessId = request.getParameter("secondSubProcessId");
				String secondMenuGroupId = request.getParameter("secondMenuGroupId");
				String pageLinkName = request.getParameter("pageTitleName");
				String subProcessRawName = request.getParameter("subProcessRawName");
				String message="";
				String secondSubProcessIdForAddOnPackage = request.getParameter("secondSubProcessIdForAddOnPackage");
				String secondMenuGroupIdForAddOnPackage = request.getParameter("secondMenuGroupIdForAddOnPackage");
				if (buttonValue.equals("Add") && systemIdFromJsp != null && !systemIdFromJsp.equals("")) {
					   message = adfunc.insertAddFeatureInformation(Integer.parseInt(systemIdFromJsp),processType,processName,subProcessName,menuGroupName,pageTitle,pageLink,secondSubProcessId,secondMenuGroupId,pageLinkName,subProcessRawName,secondSubProcessIdForAddOnPackage,secondMenuGroupIdForAddOnPackage);
				} 
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equalsIgnoreCase("deleteAddFeatureDetails")) {
			try {
				String systemIdFromJsp = request.getParameter("systemIdFromJsp");
				String processName = "0";
				String pageLink = request.getParameter("pageLink");
				String message="";
				  message = adfunc.deleteAddFeatureDetails(Integer.parseInt(systemIdFromJsp),Integer.parseInt(processName),pageLink);
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
//***********************************************************CREATE LTSP ACTIONS*****************************************************************************************//		
		else if (param.equalsIgnoreCase("getSubCategory")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String categoryId=request.getParameter("categoryId");
				if (categoryId != null && !categoryId.equals("")) {
					jsonArray = adfunc.getSubCategory(categoryId);
					if (jsonArray.length() > 0) {
						jsonObject.put("subCategoryStoreRoot", jsonArray);
					} else {
						jsonObject.put("subCategoryStoreRoot", "");
					}
				}else {
					jsonObject.put("subCategoryStoreRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 

		else if (param.equalsIgnoreCase("getCountryListForCreateLtsp")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
					jsonArray = adfunc.getCountryListForCreateLtsp();
					if (jsonArray.length() > 0) {
						jsonObject.put("countryStoreRoot", jsonArray);
					} else {
						jsonObject.put("countryStoreRoot", "");
					}
				
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 

		else if (param.equalsIgnoreCase("CreateLtspAddAndModify")) {
			try {
				String buttonValue = request.getParameter("buttonValue");
				String company = request.getParameter("company");
				String address = request.getParameter("address");
				String city = request.getParameter("city");
				String country = request.getParameter("country");
				String postalCode = request.getParameter("postalCode");
				String latitude = request.getParameter("latitude");
				String longitude = request.getParameter("longitude");
				String category = request.getParameter("category");
				String subcategory = request.getParameter("subcategory");
				String bccOil = request.getParameter("bccOil");
				String platformTitle = request.getParameter("platformTitle");
				String companyLogo = request.getParameter("companyLogo");
				String emailId = request.getParameter("emailId");
				String phoneNo = request.getParameter("phoneNo");
				String mobileNo = request.getParameter("mobileNo");
				String currencyType = request.getParameter("currencyType");
				String panNo = request.getParameter("panNo");
				String tinNo = request.getParameter("tinNo");
				String faxNo = request.getParameter("faxNo");
				String invoiceNo = request.getParameter("invoiceNo");
				String groupWiseBilling = request.getParameter("groupWiseBilling");
				String name = request.getParameter("name");
				String loginName = request.getParameter("loginName");
				String password = request.getParameter("password");
				String confirmPassword = request.getParameter("confirmPassword");
				String contactPerson = request.getParameter("contactPerson");
				String SystemId =  request.getParameter("systemId");
				String categoryId1 =  request.getParameter("categoryId1");
				String message="";
				    if (buttonValue.equals("Add")) {
					    message = adfunc.CreateLtspAddAndModify(company,address,city,country,postalCode,latitude,longitude,category,subcategory,bccOil,platformTitle,companyLogo,emailId,phoneNo,mobileNo,currencyType,panNo,tinNo,faxNo,invoiceNo,groupWiseBilling,name,loginName,password,confirmPassword,contactPerson);
				    } else if (buttonValue.equals("Modify")) {
	            	       message = adfunc.CreateLtspModify(company,address,city,country,postalCode,latitude,longitude,category,subcategory,bccOil,platformTitle,companyLogo,emailId,phoneNo,mobileNo,currencyType,panNo,tinNo,faxNo,invoiceNo,groupWiseBilling,contactPerson,Integer.parseInt(SystemId),categoryId1);
		            }
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if (param.equalsIgnoreCase("getCreateLtspReport")) {
			try {
				jsonArray = new JSONArray();
					ArrayList < Object > list1 = adfunc.getCreateLtspReport();
					jsonArray = (JSONArray) list1.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("createLtspRoot", jsonArray);
					} else {
						jsonObject.put("createLtspRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return null;
	}

}
