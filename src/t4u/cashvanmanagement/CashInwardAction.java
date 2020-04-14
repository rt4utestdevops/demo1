package t4u.cashvanmanagement;

import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;

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
import t4u.beans.ReportHelper;
import t4u.functions.AdminFunctions;
import t4u.functions.ArmoryFunction;
import t4u.functions.CashVanManagementFunctions;

public class CashInwardAction  extends Action{
	public ActionForward execute(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response){
		
		HttpSession session = request.getSession();
	    String param = "";
	    String zone = "";
	    int systemId = 0;
	    int custId = 0;
	    int userId = 0;
	    int offset = 0;
	    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	    AdminFunctions adfunc = new AdminFunctions();
	    systemId = loginInfo.getSystemId();
	    zone = loginInfo.getZone();
	    userId = loginInfo.getUserId();
	    offset = loginInfo.getOffsetMinutes();
	    custId = loginInfo.getCustomerId();
	    String lang = loginInfo.getLanguage();
	    String ltspName = loginInfo.getSystemName();
	    String userName = loginInfo.getUserFirstName()+" "+loginInfo.getUserLastName(); 
	    String category = loginInfo.getCategory();
	    String categoryType = loginInfo.getCategoryType();
	    CashVanManagementFunctions cashVanfunc = new CashVanManagementFunctions();
	   
	    if (request.getParameter("param") != null) {
	        param = request.getParameter("param").toString();
	    }
	  
	    if(param.equalsIgnoreCase("getGrid")){
	    	JSONArray	jsonArray = new JSONArray();
			JSONObject jsonObjecT=new JSONObject();				
			JSONObject	jsonObject=new JSONObject();
	    	String buttonValue = request.getParameter("ButtonValue");
	    	String InwardId = request.getParameter("InwardId");
	    	try {
				
			if(buttonValue.equalsIgnoreCase("Modify") ) {    
		    	jsonArray = new JSONArray();
		    	jsonArray =cashVanfunc.getCashInwardDetails(Integer.parseInt(InwardId) ) ;
			}else { 
				
				
				 
				 
				 jsonObject=new JSONObject();
			     jsonObject.put( "DenominationDataIndex",5000);
	             jsonObject.put("GoodNoOfNotesDataIndex",0);
	             jsonObject.put("GoodValueDataIndex",0);
	             jsonObject.put("BadNoOfNotesDataIndex",0);
	             jsonObject.put("BadValueDataIndex",0);
	             jsonObject.put("SoiledNoOfNotesDataIndex",0);
	             jsonObject.put("SoiledValueDataIndex",0);
	             jsonObject.put("CounterfeitNoOfNotesDataIndex",0);
	             jsonObject.put("CounterfeitValueDataIndex",0);
	             jsonObject.put("TotalAmountDataIndex",0);
				 jsonArray.put(jsonObject);
				
			     jsonObject=new JSONObject();
			     jsonObject.put( "DenominationDataIndex",2000);
	             jsonObject.put("GoodNoOfNotesDataIndex",0);
	             jsonObject.put("GoodValueDataIndex",0);
	             jsonObject.put("BadNoOfNotesDataIndex",0);
	             jsonObject.put("BadValueDataIndex",0);
	             jsonObject.put("SoiledNoOfNotesDataIndex",0);
	             jsonObject.put("SoiledValueDataIndex",0);
	             jsonObject.put("CounterfeitNoOfNotesDataIndex",0);
	             jsonObject.put("CounterfeitValueDataIndex",0);
	             jsonObject.put("TotalAmountDataIndex",0);
				 jsonArray.put(jsonObject); 
			
				 jsonObject=new JSONObject();				
				 jsonObject.put( "DenominationDataIndex",1000);
	             jsonObject.put("GoodNoOfNotesDataIndex",0);
	             jsonObject.put("GoodValueDataIndex",0);
	             jsonObject.put("BadNoOfNotesDataIndex",0);
	             jsonObject.put("BadValueDataIndex",0);
	             jsonObject.put("SoiledNoOfNotesDataIndex",0);
	             jsonObject.put("SoiledValueDataIndex",0);
	             jsonObject.put("CounterfeitNoOfNotesDataIndex",0);
	             jsonObject.put("CounterfeitValueDataIndex",0);
	             jsonObject.put("TotalAmountDataIndex",0);
				 jsonArray.put(jsonObject); 
				
				 jsonObject=new JSONObject();				
				 jsonObject.put( "DenominationDataIndex",500);
	             jsonObject.put("GoodNoOfNotesDataIndex",0);
	             jsonObject.put("GoodValueDataIndex",0);
	             jsonObject.put("BadNoOfNotesDataIndex",0);
	             jsonObject.put("BadValueDataIndex",0);
	             jsonObject.put("SoiledNoOfNotesDataIndex",0);
	             jsonObject.put("SoiledValueDataIndex",0);
	             jsonObject.put("CounterfeitNoOfNotesDataIndex",0);
	             jsonObject.put("CounterfeitValueDataIndex",0);
	             jsonObject.put("TotalAmountDataIndex",0);
				 jsonArray.put(jsonObject); 
				 
				 jsonObject=new JSONObject();				
				 jsonObject.put( "DenominationDataIndex",100);
	             jsonObject.put("GoodNoOfNotesDataIndex",0);
	             jsonObject.put("GoodValueDataIndex",0);
	             jsonObject.put("BadNoOfNotesDataIndex",0);
	             jsonObject.put("BadValueDataIndex",0);
	             jsonObject.put("SoiledNoOfNotesDataIndex",0);
	             jsonObject.put("SoiledValueDataIndex",0);
	             jsonObject.put("CounterfeitNoOfNotesDataIndex",0);
	             jsonObject.put("CounterfeitValueDataIndex",0);
	             jsonObject.put("TotalAmountDataIndex",0);
				 jsonArray.put(jsonObject); 
				 
				 
				 jsonObject=new JSONObject();				
				 jsonObject.put( "DenominationDataIndex",50);
	             jsonObject.put("GoodNoOfNotesDataIndex",0);
	             jsonObject.put("GoodValueDataIndex",0);
	             jsonObject.put("BadNoOfNotesDataIndex",0);
	             jsonObject.put("BadValueDataIndex",0);
	             jsonObject.put("SoiledNoOfNotesDataIndex",0);
	             jsonObject.put("SoiledValueDataIndex",0);
	             jsonObject.put("CounterfeitNoOfNotesDataIndex",0);
	             jsonObject.put("CounterfeitValueDataIndex",0);
	             jsonObject.put("TotalAmountDataIndex",0);
				 jsonArray.put(jsonObject); 
				 
				 jsonObject=new JSONObject();				
				 jsonObject.put( "DenominationDataIndex",20);
	             jsonObject.put("GoodNoOfNotesDataIndex",0);
	             jsonObject.put("GoodValueDataIndex",0);
	             jsonObject.put("BadNoOfNotesDataIndex",0);
	             jsonObject.put("BadValueDataIndex",0);
	             jsonObject.put("SoiledNoOfNotesDataIndex",0);
	             jsonObject.put("SoiledValueDataIndex",0);
	             jsonObject.put("CounterfeitNoOfNotesDataIndex",0);
	             jsonObject.put("CounterfeitValueDataIndex",0);
	             jsonObject.put("TotalAmountDataIndex",0);
				 jsonArray.put(jsonObject); 
				 
				 jsonObject=new JSONObject();				
				 jsonObject.put( "DenominationDataIndex",10);
	             jsonObject.put("GoodNoOfNotesDataIndex",0);
	             jsonObject.put("GoodValueDataIndex",0);
	             jsonObject.put("BadNoOfNotesDataIndex",0);
	             jsonObject.put("BadValueDataIndex",0);
	             jsonObject.put("SoiledNoOfNotesDataIndex",0);
	             jsonObject.put("SoiledValueDataIndex",0);
	             jsonObject.put("CounterfeitNoOfNotesDataIndex",0);
	             jsonObject.put("CounterfeitValueDataIndex",0);
	             jsonObject.put("TotalAmountDataIndex",0);
				 jsonArray.put(jsonObject); 
				 
				 jsonObject=new JSONObject();				
				 jsonObject.put( "DenominationDataIndex",5);
	             jsonObject.put("GoodNoOfNotesDataIndex",0);
	             jsonObject.put("GoodValueDataIndex",0);
	             jsonObject.put("BadNoOfNotesDataIndex",0);
	             jsonObject.put("BadValueDataIndex",0);
	             jsonObject.put("SoiledNoOfNotesDataIndex",0);
	             jsonObject.put("SoiledValueDataIndex",0);
	             jsonObject.put("CounterfeitNoOfNotesDataIndex",0);
	             jsonObject.put("CounterfeitValueDataIndex",0);
	             jsonObject.put("TotalAmountDataIndex",0);
				 jsonArray.put(jsonObject); 
				 
				 
				 jsonObject=new JSONObject();				
				 jsonObject.put( "DenominationDataIndex",2);
	             jsonObject.put("GoodNoOfNotesDataIndex",0);
	             jsonObject.put("GoodValueDataIndex",0);
	             jsonObject.put("BadNoOfNotesDataIndex",0);
	             jsonObject.put("BadValueDataIndex",0);
	             jsonObject.put("SoiledNoOfNotesDataIndex",0);
	             jsonObject.put("SoiledValueDataIndex",0);
	             jsonObject.put("CounterfeitNoOfNotesDataIndex",0);
	             jsonObject.put("CounterfeitValueDataIndex",0);
	             jsonObject.put("TotalAmountDataIndex",0);
				 jsonArray.put(jsonObject); 
				 
				 
				 jsonObject=new JSONObject();				
				 jsonObject.put( "DenominationDataIndex",1);
	             jsonObject.put("GoodNoOfNotesDataIndex",0);
	             jsonObject.put("GoodValueDataIndex",0);
	             jsonObject.put("BadNoOfNotesDataIndex",0);
	             jsonObject.put("BadValueDataIndex",0);
	             jsonObject.put("SoiledNoOfNotesDataIndex",0);
	             jsonObject.put("SoiledValueDataIndex",0);
	             jsonObject.put("CounterfeitNoOfNotesDataIndex",0);
	             jsonObject.put("CounterfeitValueDataIndex",0);
	             jsonObject.put("TotalAmountDataIndex",0);
				 jsonArray.put(jsonObject); 
				 
				 
			}
				if(jsonArray.length()>0){
					jsonObjecT.put("rows", jsonArray);
				}else{
					jsonObjecT.put("rows", "");
				}
				response.getWriter().print(jsonObjecT.toString());
			} catch (Exception e) {
			e.printStackTrace();
			}
			
	 	    
	 	    
	    }
	    else if(param.equalsIgnoreCase("getCustomer")){ 

			try{
			JSONArray jsonArray = new JSONArray();
            JSONObject	jsonObject    = new JSONObject();
			 jsonArray=cashVanfunc.getCustomerForVault(custId,systemId);
			 
				if (jsonArray.length() > 0) {
					jsonObject.put("customerStoreRoot", jsonArray);
				} else {
					jsonObject.put("customerStoreRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
		}catch (Exception e) {
			e.printStackTrace();
		}	
		
	    }
	    else if(param.equalsIgnoreCase("getSealNo")){ 
			try{
			JSONArray jsonArray = new JSONArray();
            JSONObject	jsonObject    = new JSONObject();
            String	cVSCustId = request.getParameter("CVSCustId");
            if(cVSCustId != null && !cVSCustId.equalsIgnoreCase("") ){
			 jsonArray=cashVanfunc.getSealNoForVault(custId,systemId,Integer.parseInt(cVSCustId));
            }
				if (jsonArray.length() > 0) {
					jsonObject.put("sealNoStoreRoot", jsonArray);
				} else {
					jsonObject.put("sealNoStoreRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
		}catch (Exception e) {
			e.printStackTrace();
		}	
		
	    }
	    else if(param.equalsIgnoreCase("Save")){

	    	String totalAmount = "0";
	    	String date = request.getParameter("Date");
	    	if(date.contains("T")){
				date=date.replace("T", " ");
	    	}
	       String cashType = request.getParameter("CashType");
           String  datajson = request.getParameter("datajson");
           String   customerId=request.getParameter("CustId");
			String	cVSCustId = request.getParameter("CVSCustId");
			String sealNo = request.getParameter("SealNo"); 
			if(request.getParameter("TotalAmount")!=null && !request.getParameter("TotalAmount").equalsIgnoreCase("")){
			totalAmount = request.getParameter("TotalAmount"); 
			}
			String buttonValue = request.getParameter("ButtonValue");
			String inwardId = "0";
			if(request.getParameter("InwardId")!=null && !request.getParameter("InwardId").equalsIgnoreCase("")){
				inwardId =  request.getParameter("InwardId");
			}
             String message = "";
             try {
             message  = cashVanfunc.saveDenomination(Integer.parseInt(inwardId),buttonValue,datajson,date,Integer.parseInt(cVSCustId),cashType,Integer.parseInt(customerId),
            		 systemId,userId,sealNo,Double.parseDouble(totalAmount));              
			   response.getWriter().print(message);
			} catch (IOException e) {				
				e.printStackTrace();
			} catch (NumberFormatException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	
	    }
	    else if(param.equalsIgnoreCase("Move")){

	    	String totalAmount = "0";
	    	String date = request.getParameter("Date");
	    	if(date.contains("T")){
				date=date.replace("T", " ");
	    	}
	       String cashType = request.getParameter("CashType");
           String  datajson = request.getParameter("datajson");
           String   customerId=request.getParameter("CustId");
			String	cVSCustId = request.getParameter("CVSCustId");
			String sealNo = request.getParameter("SealNo"); 
			if(request.getParameter("TotalAmount")!=null && !request.getParameter("TotalAmount").equalsIgnoreCase("")){
			totalAmount = request.getParameter("TotalAmount"); 
			}
			String buttonValue = request.getParameter("ButtonValue");
			String inwardId = "0";
			if(request.getParameter("InwardId")!=null && !request.getParameter("InwardId").equalsIgnoreCase("")){
				inwardId =  request.getParameter("InwardId");
			}
             String message = "";
             try {
             message  = cashVanfunc.saveDenomination(Integer.parseInt(inwardId),buttonValue,datajson,date,Integer.parseInt(cVSCustId),cashType,Integer.parseInt(customerId),systemId,userId,sealNo,Integer.parseInt(totalAmount));              
			 if(message.contains("Saved Successfully!!")){
				 message  = cashVanfunc.updateSealBag(Integer.parseInt(customerId), systemId, sealNo) ; 
			  }
             response.getWriter().print(message);
			} catch (IOException e) {				
				e.printStackTrace();
			} catch (NumberFormatException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	
	    }
	    else if(param.equalsIgnoreCase("getVaultInventorySummary")){
	  	    	
	  	    	try{
	  				JSONArray jsonArray = new JSONArray();
	  	            JSONObject	jsonObject    = new JSONObject();
	  				 jsonArray = cashVanfunc.getVaultInventorySummary(systemId,custId);
	  				 
	  					if (jsonArray.length() > 0) {
	  						jsonObject.put("getVaultInventorySummaryRoot", jsonArray);
	  					} else {
	  						jsonObject.put("getVaultInventorySummaryRoot", "");
	  					}
	  					response.getWriter().print(jsonObject.toString());
	  			}catch (Exception e) {
	  				e.printStackTrace();
	  			}	
	  	
	  		}
	    else if(param.equalsIgnoreCase("getVaultInventory")){
	    	
	    	try{
				JSONArray jsonArray = new JSONArray();
				JSONArray jsonArray2 = new JSONArray();
	            JSONObject	jsonObject    = new JSONObject();
				 jsonArray2 = cashVanfunc.getVaultInventory(systemId,custId);
				 //System.out.println(" jsonArray2 == "+jsonArray2);
				 HashMap<Integer, Double> hmp = new HashMap<Integer, Double> ();
				 hmp = cashVanfunc.getForexOrderByCvsCustId(systemId,custId);
				 //System.out.println(" hmp === "+hmp);
				 if (jsonArray2.length() > 0) {
					 for( int i = 0; i < jsonArray2.length(); i++ ){
							JSONObject obj = (JSONObject) jsonArray2.get(i);							
							if(hmp.containsKey(obj.getInt("customerIDindex"))){
							obj.remove("forexcashindex");
							obj.put("forexcashindex",hmp.get(obj.getInt("customerIDindex")));
							}
							jsonArray.put(obj);
						}	
					} 
				 //System.out.println(" jsonArray == "+jsonArray);
				 
				 
					if (jsonArray.length() > 0) {
						jsonObject.put("VaultIventoryRoot", jsonArray);
					} else {
						jsonObject.put("VaultIventoryRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
			}catch (Exception e) {
				e.printStackTrace();
			}	
	
		}
	    if(param.equalsIgnoreCase("getGridForSummary")){
	    	JSONArray	jsonArray = new JSONArray();
			JSONObject jsonObjecT=new JSONObject();	
			String cvsCustId = "0";
			if( request.getParameter("CvsCustId") != null && !request.getParameter("CvsCustId").equals("")){
	    	 cvsCustId = request.getParameter("CvsCustId");
			}
	    	try {
				   
		    	jsonArray = new JSONArray();
		    	jsonArray =cashVanfunc.getCashInwardDetailsSummary(systemId,custId,Integer.parseInt(cvsCustId) ) ;  
		    	if(jsonArray.length()>0){
					jsonObjecT.put("rows", jsonArray);
				}else{
					jsonObjecT.put("rows", "");
				}
				response.getWriter().print(jsonObjecT.toString());
			} catch (Exception e) {
			e.printStackTrace();
			}
	    }	
	 	
	    if(param.equalsIgnoreCase("getGridForSummaryForSealBag")){
	    	JSONArray	jsonArray = new JSONArray();
			JSONObject jsonObjecT=new JSONObject();	
			JSONObject jsonObject=new JSONObject();	
			String cvsCustId = "0";
			int count = 0;
			if( request.getParameter("CvsCustId") != null && !request.getParameter("CvsCustId").equals("")){
	    	 cvsCustId = request.getParameter("CvsCustId");
			}
	    	try {
				   
	    		ArrayList<String> sealeBagsList = new ArrayList<String>();
	    		sealeBagsList =cashVanfunc.getGridForSummaryForSealBag(systemId,custId,Integer.parseInt(cvsCustId),"SEALED BAG" ) ;  
		    	if(sealeBagsList.size()>0){		 
						count =sealeBagsList.size();
				    	if(count>0){
				    	int remain = count%3;
				    	if(remain>0){
				    	for(int i=0; i<3-remain;i++){
				    		sealeBagsList.add("");
				    	}
				    	}
				    	}
		    for(int i = 0; i<sealeBagsList.size();i= i+3){
		    	jsonObject=new JSONObject();
		    	jsonObject.put("SealBagAmount1", sealeBagsList.get(i));
		    	jsonObject.put("SealBagAmount2", sealeBagsList.get(i+1));
		    	jsonObject.put("SealBagAmount3", sealeBagsList.get(i+2));
		    	jsonArray.put(jsonObject);
		    }
					jsonObjecT.put("rowsForSealBag", jsonArray);
				}else{
					jsonObjecT.put("rowsForSealBag", "");
				}
				response.getWriter().print(jsonObjecT.toString());
			} catch (Exception e) {
			e.printStackTrace();
			}
	    }
		
	    else if(param.equalsIgnoreCase("getGridForSummaryForJewellery")){
	    	JSONArray	jsonArray = new JSONArray();
			JSONObject jsonObjecT=new JSONObject();	
			JSONObject jsonObject=new JSONObject();	
			String cvsCustId = "0";
			int count = 0;
			if( request.getParameter("CvsCustId") != null && !request.getParameter("CvsCustId").equals("")){
	    	 cvsCustId = request.getParameter("CvsCustId");
			}
		
	    	try {
				   
	    		ArrayList<String> sealeBagsList = new ArrayList<String>();
	    		sealeBagsList =cashVanfunc.getGridForSummaryForSealBag(systemId,custId,Integer.parseInt(cvsCustId),"JEWELLERY" );
		    	if(sealeBagsList.size()>0){		 
						count =sealeBagsList.size();
				    	if(count>0){
				    	int remain = count%3;
				    	if(remain>0){
				    	for(int i=0; i<3-remain;i++){
				    		sealeBagsList.add("");
				    	}
				    	}
				    	}
		    for(int i = 0; i<sealeBagsList.size();i= i+3){
		    	jsonObject=new JSONObject();
		    	jsonObject.put("JewelleryAmount1", sealeBagsList.get(i));
		    	jsonObject.put("JewelleryAmount2", sealeBagsList.get(i+1));
		    	jsonObject.put("JewelleryAmount3", sealeBagsList.get(i+2));
		    	jsonArray.put(jsonObject);
		    }
					jsonObjecT.put("rowsForJewellery", jsonArray);
				}else{
					jsonObjecT.put("rowsForJewellery", "");
				}
				response.getWriter().print(jsonObjecT.toString());
			} catch (Exception e) {
			e.printStackTrace();
			}
	    }
	    else if(param.equalsIgnoreCase("getGridForSummaryForCheck")){
	    	JSONArray	jsonArray = new JSONArray();
			JSONObject jsonObjecT=new JSONObject();	
			JSONObject jsonObject=new JSONObject();	
			String cvsCustId = "0";
			int count = 0;
			if( request.getParameter("CvsCustId") != null && !request.getParameter("CvsCustId").equals("")){
	    	 cvsCustId = request.getParameter("CvsCustId");
			}
			
	    	try {
				   
	    		ArrayList<String> sealeBagsList = new ArrayList<String>();
	    		sealeBagsList =cashVanfunc.getGridForSummaryForSealBag(systemId,custId,Integer.parseInt(cvsCustId),"CHEQUE");
		    	if(sealeBagsList.size()>0){		 
						count =sealeBagsList.size();
				    	if(count>0){
				    	int remain = count%3;
				    	if(remain>0){
				    	for(int i=0; i<3-remain;i++){
				    		sealeBagsList.add("");
				    	}
				    	}
				    	}
		    for(int i = 0; i<sealeBagsList.size();i= i+3){
		    	jsonObject=new JSONObject();
		    	jsonObject.put("CheckAmount1", sealeBagsList.get(i));
		    	jsonObject.put("CheckAmount2", sealeBagsList.get(i+1));
		    	jsonObject.put("CheckAmount3", sealeBagsList.get(i+2));
		    	jsonArray.put(jsonObject);
		    }
					jsonObjecT.put("rowsForCheck", jsonArray);
				}else{
					jsonObjecT.put("rowsForCheck", "");
				}
				response.getWriter().print(jsonObjecT.toString());
			} catch (Exception e) {
			e.printStackTrace();
			}
	    }
	    else if(param.equalsIgnoreCase("getGridForSummaryForForex")){
	    	JSONArray	jsonArray = new JSONArray();
			JSONObject jsonObjecT=new JSONObject();	
			JSONObject jsonObject=new JSONObject();	
			String cvsCustId = "0";
			int count = 0;
			if( request.getParameter("CvsCustId") != null && !request.getParameter("CvsCustId").equals("")){
	    	 cvsCustId = request.getParameter("CvsCustId");
			}
			
	    	try {
				   
	    		ArrayList<String> sealeBagsList = new ArrayList<String>();
	    		sealeBagsList =cashVanfunc.getGridForSummaryForSealBag(systemId,custId,Integer.parseInt(cvsCustId),"FOREIGN CURRENCY" );
		    	if(sealeBagsList.size()>0){		 
						count =sealeBagsList.size();
				    	if(count>0){
				    	int remain = count%3;
				    	if(remain>0){
				    	for(int i=0; i<3-remain;i++){
				    		sealeBagsList.add("");
				    	}
				    	}
				    	}
		    for(int i = 0; i<sealeBagsList.size();i= i+3){
		    	jsonObject=new JSONObject();
		    	jsonObject.put("ForexAmount1", sealeBagsList.get(i));
		    	jsonObject.put("ForexAmount2", sealeBagsList.get(i+1));
		    	jsonObject.put("ForexAmount3", sealeBagsList.get(i+2));
		    	jsonArray.put(jsonObject);
		    }
					jsonObjecT.put("rowsForForex", jsonArray);
				}else{
					jsonObjecT.put("rowsForForex", "");
				}
				response.getWriter().print(jsonObjecT.toString());
			} catch (Exception e) {
			e.printStackTrace();
			}
	    }
	    
	    
	    if(param.equalsIgnoreCase("getGridForSummaryForSealBagForReconcilation")){
	    	JSONArray	jsonArray = new JSONArray();
			JSONObject jsonObjecT=new JSONObject();	
			JSONObject jsonObject=new JSONObject();	
			String cvsCustId = "0";
			int count = 0;
			if( request.getParameter("CvsCustId") != null && !request.getParameter("CvsCustId").equals("")){
	    	 cvsCustId = request.getParameter("CvsCustId");
			}
			String tripshhetNo = request.getParameter("TripshhetNo");
			String dispenseId = request.getParameter("UniqueId");
	    	try {
				   
	    		ArrayList<String> sealeBagsList = new ArrayList<String>();
	    		sealeBagsList =cashVanfunc.getGridForSummaryForSealBagForReconcilation(systemId,custId,Integer.parseInt(cvsCustId),tripshhetNo,Integer.parseInt(dispenseId) ) ;  
		    	if(sealeBagsList.size()>0){		 
						count =sealeBagsList.size();
				    	if(count>0){
				    	int remain = count%3;
				    	if(remain>0){
				    	for(int i=0; i<3-remain;i++){
				    		sealeBagsList.add("");
				    	}
				    	}
				    	}
		    for(int i = 0; i<sealeBagsList.size();i= i+3){
		    	jsonObject=new JSONObject();
		    	jsonObject.put("SealBagAmount1", sealeBagsList.get(i));
		    	jsonObject.put("SealBagAmount2", sealeBagsList.get(i+1));
		    	jsonObject.put("SealBagAmount3", sealeBagsList.get(i+2));
		    	jsonArray.put(jsonObject);
		    }
					jsonObjecT.put("rowsForSealBag", jsonArray);
				}else{
					jsonObjecT.put("rowsForSealBag", "");
				}
				response.getWriter().print(jsonObjecT.toString());
			} catch (Exception e) {
			e.printStackTrace();
			}
	    }
	    else if(param.equalsIgnoreCase("getGridForSummaryForJewelleryForReconcilation")){
	    	JSONArray	jsonArray = new JSONArray();
			JSONObject jsonObjecT=new JSONObject();	
			JSONObject jsonObject=new JSONObject();	
			String cvsCustId = "0";
			int count = 0;
			if( request.getParameter("CvsCustId") != null && !request.getParameter("CvsCustId").equals("")){
	    	 cvsCustId = request.getParameter("CvsCustId");
			}
			String tripshhetNo = request.getParameter("TripshhetNo");
			String dispenseId = request.getParameter("UniqueId");
	    	try {
				   
	    		ArrayList<String> sealeBagsList = new ArrayList<String>();
	    		sealeBagsList =cashVanfunc.getGridForSummaryForJewelleryForReconcilation(systemId,custId,Integer.parseInt(cvsCustId),tripshhetNo,Integer.parseInt(dispenseId) ) ;  
		    	if(sealeBagsList.size()>0){		 
						count =sealeBagsList.size();
				    	if(count>0){
				    	int remain = count%3;
				    	if(remain>0){
				    	for(int i=0; i<3-remain;i++){
				    		sealeBagsList.add("");
				    	}
				    	}
				    	}
		    for(int i = 0; i<sealeBagsList.size();i= i+3){
		    	jsonObject=new JSONObject();
		    	jsonObject.put("JewelleryAmount1", sealeBagsList.get(i));
		    	jsonObject.put("JewelleryAmount2", sealeBagsList.get(i+1));
		    	jsonObject.put("JewelleryAmount3", sealeBagsList.get(i+2));
		    	jsonArray.put(jsonObject);
		    }
					jsonObjecT.put("rowsForJewellery", jsonArray);
				}else{
					jsonObjecT.put("rowsForJewellery", "");
				}
				response.getWriter().print(jsonObjecT.toString());
			} catch (Exception e) {
			e.printStackTrace();
			}
	    }
	    else if(param.equalsIgnoreCase("getGridForSummaryForCheckForReconcilation")){
	    	JSONArray	jsonArray = new JSONArray();
			JSONObject jsonObjecT=new JSONObject();	
			JSONObject jsonObject=new JSONObject();	
			String cvsCustId = "0";
			int count = 0;
			if( request.getParameter("CvsCustId") != null && !request.getParameter("CvsCustId").equals("")){
	    	 cvsCustId = request.getParameter("CvsCustId");
			}
			String tripshhetNo = request.getParameter("TripshhetNo");
			String dispenseId = request.getParameter("UniqueId");
	    	try {
				   
	    		ArrayList<String> sealeBagsList = new ArrayList<String>();
	    		sealeBagsList =cashVanfunc.getGridForSummaryForCheckForReconcilation(systemId,custId,Integer.parseInt(cvsCustId),tripshhetNo,Integer.parseInt(dispenseId) ) ;  
		    	if(sealeBagsList.size()>0){		 
						count =sealeBagsList.size();
				    	if(count>0){
				    	int remain = count%3;
				    	if(remain>0){
				    	for(int i=0; i<3-remain;i++){
				    		sealeBagsList.add("");
				    	}
				    	}
				    	}
		    for(int i = 0; i<sealeBagsList.size();i= i+3){
		    	jsonObject=new JSONObject();
		    	jsonObject.put("CheckAmount1", sealeBagsList.get(i));
		    	jsonObject.put("CheckAmount2", sealeBagsList.get(i+1));
		    	jsonObject.put("CheckAmount3", sealeBagsList.get(i+2));
		    	jsonArray.put(jsonObject);
		    }
					jsonObjecT.put("rowsForCheck", jsonArray);
				}else{
					jsonObjecT.put("rowsForCheck", "");
				}
				response.getWriter().print(jsonObjecT.toString());
			} catch (Exception e) {
			e.printStackTrace();
			}
	    }
	    else if(param.equalsIgnoreCase("getGridForSummaryForForexForReconcilation")){
	    	JSONArray	jsonArray = new JSONArray();
			JSONObject jsonObjecT=new JSONObject();	
			JSONObject jsonObject=new JSONObject();	
			String cvsCustId = "0";
			int count = 0;
			if( request.getParameter("CvsCustId") != null && !request.getParameter("CvsCustId").equals("")){
	    	 cvsCustId = request.getParameter("CvsCustId");
			}
			String tripshhetNo = request.getParameter("TripshhetNo");
			String dispenseId = request.getParameter("UniqueId");
	    	try {
				   
	    		ArrayList<String> sealeBagsList = new ArrayList<String>();
	    		sealeBagsList =cashVanfunc.getGridForSummaryForForexForReconcilation(systemId,custId,Integer.parseInt(cvsCustId),tripshhetNo,Integer.parseInt(dispenseId) ) ;  
		    	if(sealeBagsList.size()>0){		 
						count =sealeBagsList.size();
				    	if(count>0){
				    	int remain = count%3;
				    	if(remain>0){
				    	for(int i=0; i<3-remain;i++){
				    		sealeBagsList.add("");
				    	}
				    	}
				    	}
		    for(int i = 0; i<sealeBagsList.size();i= i+3){
		    	jsonObject=new JSONObject();
		    	jsonObject.put("ForexAmount1", sealeBagsList.get(i));
		    	jsonObject.put("ForexAmount2", sealeBagsList.get(i+1));
		    	jsonObject.put("ForexAmount3", sealeBagsList.get(i+2));
		    	jsonArray.put(jsonObject);
		    }
					jsonObjecT.put("rowsForForex", jsonArray);
				}else{
					jsonObjecT.put("rowsForForex", "");
				}
				response.getWriter().print(jsonObjecT.toString());
			} catch (Exception e) {
			e.printStackTrace();
			}
	    }
	    
	    
	    else if(param.equals("getCashDespenseViewForRecocilation")){
			String routeId = "0";
			String tripSheetNo = "0";
			String date = "";
			String btnValue = request.getParameter("btnValue");
			tripSheetNo = request.getParameter("tripSheetNo");
			routeId = request.getParameter("routeId");
			date = request.getParameter("date");				
			
			try{
				JSONArray jsonArray = new JSONArray();
	            JSONObject	jsonObject    = new JSONObject();
	            jsonObject = new JSONObject();
				if(routeId != null && !routeId.equals("")){
					ArrayList < Object > list1 =cashVanfunc.getCashDespenseViewForReconcilation(systemId,custId,Integer.parseInt(routeId),tripSheetNo,date,btnValue);
	   	             jsonArray = (JSONArray) list1.get(0);
					//jsonArray = 
					if(jsonArray.length() > 0){
						jsonObject.put("cashDespenseDetailsViewRoot", jsonArray);
					}else{
						jsonObject.put("cashDespenseDetailsViewRoot", "");
					}
					ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute("RealTimeDataReport", reportHelper);
					request.getSession().setAttribute("routeId",routeId);
					request.getSession().setAttribute("tripSheetNo",tripSheetNo);
				}else{
					jsonObject.put("cashDespenseDetailsViewRoot", "");
				}
				response.getWriter().println(jsonObject.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		} 
	     
	    else if(param.equalsIgnoreCase("SaveForReconcilation")){ 
	    String message = "";
	    String  tripSheetNo = request.getParameter("TripSheetNo");
        String   uniqueId=request.getParameter("UniqueId");
        String  datajson = request.getParameter("datajson");
        String cashType =request.getParameter("checkBoxType");
        String totalAmount = request.getParameter("TotalAmount");
        String keyPressed = request.getParameter("KeyPressed");
        String CashSealNo = request.getParameter("CashSealNo");
        try {
        message  = cashVanfunc.saveDenominationForReconcilation(tripSheetNo,Integer.parseInt(uniqueId),systemId,custId,datajson,userId, cashType,totalAmount,keyPressed,CashSealNo);              
		   response.getWriter().print(message);
		} catch (IOException e) {				
			e.printStackTrace();
		}
	    }
	    //added Vin: To set grid datas in session
	    else if(param.equals("setGridData")){
	    	String jsonDenom = request.getParameter("jsonDenom");
	    	String jsonSb = request.getParameter("jsonSb");
	    	String jsonJw = request.getParameter("jsonJw");
	    	String jsonChq = request.getParameter("jsonChq");
	    	String jsonFx = request.getParameter("jsonFx");
	    	if(jsonDenom != ""){
	    		session.setAttribute("jsonDenom", jsonDenom);
	    	}
	    	if(jsonSb == ""){
	    		session.setAttribute("jsonSb", "empty");
	    	}else{
	    		session.setAttribute("jsonSb", jsonSb);
	    	}
	    	if(jsonChq == ""){
	    		session.setAttribute("jsonChq", "empty");
	    	}else{
	    		session.setAttribute("jsonChq", jsonChq);
	    	}
	    	if(jsonJw == ""){
	    		session.setAttribute("jsonJw", "empty");
	    	}else{
	    		session.setAttribute("jsonJw", jsonJw);
	    	}
	    	if(jsonFx == ""){
	    		session.setAttribute("jsonFx", "empty");
	    	}else{
	    		session.setAttribute("jsonFx", jsonFx);
	    	}
	    	try{
	    		response.getWriter().println("true");
	    	}catch(Exception e){
	    		e.printStackTrace();
	    	}
	    }
return null;
	}	
	
}
