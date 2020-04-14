<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String TcNum=request.getParameter("TcNum");
String MonthYear=request.getParameter("MonthYear");
String custId=request.getParameter("custIdDetails");
String custName=request.getParameter("custNameDetails");
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();

		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		LoginInfoBean loginInfo1=new LoginInfoBean();
		loginInfo1=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		if(loginInfo1!=null)
		{
		int isLtsp=loginInfo1.getIsLtsp();
		loginInfo.setIsLtsp(isLtsp);
		}
		loginInfo.setSystemId(systemid);
		loginInfo.setCustomerId(customerid);
		loginInfo.setUserId(userid);
		loginInfo.setLanguage(language);
		loginInfo.setStyleSheetOverride("N");
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		if (str.length > 11) {
			loginInfo.setStyleSheetOverride("N");
		}
		loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));

		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf=new CommonFunctions();
	LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
	if(loginInfo==null){
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
	}
	else
	{   
	    session.setAttribute("loginInfoDetails", loginInfo);    
		String language = loginInfo.getLanguage();
		ArrayList<String> tobeConverted=new ArrayList<String>();
	
	tobeConverted.add("SLNO");
	tobeConverted.add("Owner_Name");
	tobeConverted.add("Bank");
	tobeConverted.add("Branch");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Error");
	tobeConverted.add("Acknowledgement");
	tobeConverted.add("Challan_Number");
	tobeConverted.add("Challen_Date");
	tobeConverted.add("Bank_Transaction_Number");
	tobeConverted.add("Amount_Paid");
	tobeConverted.add("Type");
	tobeConverted.add("Unique_Id");
	tobeConverted.add("Challan_Number");
	tobeConverted.add("TC_Number");
	tobeConverted.add("Mineral_Type");
	tobeConverted.add("Grade");
	tobeConverted.add("Rate");
	tobeConverted.add("Quantity");
	tobeConverted.add("Payment_Description");
	tobeConverted.add("Date_and_Time_of_Generation");
	tobeConverted.add("Challan_Details");
	tobeConverted.add("Payment_Acc_Head");
	tobeConverted.add("Mining_Lease_Name");
	tobeConverted.add("Adjustment_Type");
	tobeConverted.add("Previous_Challan_Reference");
	tobeConverted.add("Previous_Challan_Date_Reference");
	tobeConverted.add("Lease_No/Mine_Owner");
	tobeConverted.add("Royalty_for_the_month/year");
	tobeConverted.add("Exact_Grade");
	tobeConverted.add("Total_Payable");
	tobeConverted.add("NIC_Challan_No");
	tobeConverted.add("NIC_Challan_Date");
	tobeConverted.add("Acknowledgement_Generation_Datetime");
	tobeConverted.add("Mine_Owner_Chalan_Details");
	
ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
 
	String SLNO=convertedWords.get(0);
	String OwnerName=convertedWords.get(1);
	String Bank=convertedWords.get(2);
	String Branch=convertedWords.get(3);
	String noRecordsFound=convertedWords.get(4);
	String error=convertedWords.get(5);
	String Acknowledgement=convertedWords.get(6);
	String ChallanNumber=convertedWords.get(7);
	String ChallenDate=convertedWords.get(8);
	String BankTransactionNumber=convertedWords.get(9);
	String AmountPaid=convertedWords.get(10);
	String Type=convertedWords.get(11);
	String Unique_Id=convertedWords.get(12);
	String Challan_Number=convertedWords.get(13);
	String TC_Number=convertedWords.get(14);
	String Mineral_Type=convertedWords.get(15);
	String Grade=convertedWords.get(16);
	String Rate=convertedWords.get(17);
	String Quantity=convertedWords.get(18);
	String Payment_Description=convertedWords.get(19);
	String Date_and_Time_of_Generation=convertedWords.get(20);
	String Challan_Details=convertedWords.get(21);
	String Payment_Acc_Head=convertedWords.get(22);
	String Mining_Lease_Name=convertedWords.get(23);
	String Adjustment_Type=convertedWords.get(24);
	String Previous_Challan_Reference=convertedWords.get(25);
	String Previous_Challan_Date_Reference=convertedWords.get(26);
	String Lease_NoMine_Owner=convertedWords.get(27);
	String Royalty_for_the_monthyear=convertedWords.get(28);
	String Exact_Grade=convertedWords.get(29);
	String Total_Payable=convertedWords.get(30);
	String NIC_Challan_No=convertedWords.get(31);
	String NIC_Challan_Date=convertedWords.get(32);
	String Acknowledgement_Generation_Datetime=convertedWords.get(33);
	String Mine_Owner_Chalan_Details=convertedWords.get(34);

	
	int systemId = loginInfo.getSystemId();
	int userId=loginInfo.getUserId(); 
	int customerId = loginInfo.getCustomerId();
	String userAuthority=cf.getUserAuthority(systemId,userId);
	if(customerId > 0 && loginInfo.getIsLtsp()== -1 && !userAuthority.equalsIgnoreCase("Admin"))
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
	else{
%>
	


<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
    <title><%=Challan_Details%></title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<style>
	             .x-btn-text addbutton{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;}
				.x-btn-text editbutton{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;}
				.x-btn-text excelbutton{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;}
				.x-btn-text pdfbutton{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;}
				.x-btn-text{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;}
				.x-btn-text clearfilterbutton{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;
				}
				
				.x-combo-list {
				position: absolute;
    			z-index: 9010;
    			visibility: visible;
    			left: 307px;
    			top: 139px;
    			width: 168px !important;
    			height: 40px;
    			font-size: 12px;
				}
	
				.x-combo-list-inner{
				width: 168px !important;
    			height: 40px;
				}
				.ext-strict .x-form-text {
    			height: 15px !important;
				}
	</style>
  </head>
  <body>
        <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/ImportJSSandMining.jsp" />                                                    
        <%}else {%>  
        <jsp:include page="../Common/ImportJS.jsp" /><%} %>
        <jsp:include page="../Common/ExportJS.jsp" />
        <script>
		var grid;
		var myWin;
		var buttonValue;
		var uniqueId;
		var closewin;
		var approveWin;
		var outerPanel;
		var AssetNo;
	 	var jspName='<%=Challan_Details%>';
    	var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,string,number,number,number,number,string,string,string,string,string,string,string,number,string,string";
  
	
   	// **********************************************Reader configs Starts******************************
    
     var reader = new Ext.data.JsonReader({
        idProperty: 'tripcreationId',
    	root: 'challanDetailsRoot',
    	totalProperty: 'total',
    	fields: [{
        name: 'slnoIndex'
    	},{
        name: 'uniqueIdDataIndex'
    	},{
        name: 'challanNumberDataIndex'
    	},{
        name: 'paymentAcHeadDataIndex'
    	},{
        name: 'typeDataIndex'
    	},{
        name: 'TCNODataIndex'
    	},{
        name: 'MineNameDataIndex'
    	},{
        name: 'AdjustmentTypeDataIndex'
    	},{
        name: 'PreviousChallanDataIndex'
    	},{
        name: 'PreviousDateDataIndex'
    	},{
        name: 'ownerNameDataIndex'
    	},{
    	name: 'mineralTypeDataIndex'
    	},{
    	name: 'royaltyDataIndex',
    	},{
    	name: 'gradeDataIndex'
    	},{
    	name: 'extractGradeDataIndex'
    	},{
        name: 'rateDataIndex'
    	},{
		name:'quantityDataIndex'
		},{
    	name:'totalPayableDataIndex'
    	},{
        name: 'paymentDescriptionDataIndex'
    	},{
        name: 'generationDateDataIndex',
    	},{
        name: 'challanNoDataIndex'
    	},{
        name: 'challanDateDataIndex',
    	},{
    	name: 'transactionDataIndex'
    	},{
    	name: 'bankDataIndex'
    	},{
        name: 'branchDataIndex'
    	},{
        name: 'amountDataIndex'
    	},{
        name: 'paymentDataIndex'
    	},{
        name: 'AckGenDataIndex'
    	}]
    });
    
    // **********************************************Reader configs Ends******************************
    //********************************************Store Configs For Grid*************************

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/SummaryDetailsAction.do?param=getSummarDetails',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'challanDetailsStore',
        reader: reader
        });
        
   //********************************************Store Configs For Grid Ends*************************
    //********************************************************************Filter Config***************
       
    	var filters = new Ext.ux.grid.GridFilters({
        local: true,
    	filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    	},{
        type: 'numeric',
        dataIndex: 'uniqueIdDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'challanNumberDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'paymentAcHeadDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'typeDataIndex'
    	},
    	{
    	type: 'string',
        dataIndex: 'TCNODataIndex'
    	},{
    	type: 'string',
        dataIndex: 'MineNameDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'AdjustmentTypeDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'PreviousChallanDataIndex'
    	},{
    	type: 'date',
        dataIndex: 'PreviousDateDataIndex'
    	},{
        type: 'string',
        dataIndex: 'ownerNameDataIndex'
    	},{
        type: 'string',
        dataIndex: 'mineralTypeDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'royaltyDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'gradeDataIndex'
    	}, {
        type: 'string',
        dataIndex: 'extractGradeDataIndex'
    	}, {
    	type:'numeric',
    	dataIndex:'rateDataIndex'
    	},{
        type: 'numeric',
        dataIndex: 'quantityDataIndex'
    	},{
        type: 'numeric',
        dataIndex: 'totalPayableDataIndex'
    	}, {
        type: 'string',
        dataIndex: 'paymentDescriptionDataIndex'
    	}, {
        type: 'string',
        dataIndex: 'generationDateDataIndex'
    	}, {
        type: 'string',
        dataIndex: 'challanNoDataIndex'
    	}, {
        type: 'date',
        dataIndex: 'challanDateDataIndex'
    	}, {
        type: 'string',
        dataIndex: 'transactionDataIndex'
    	}, {
        type: 'string',
        dataIndex: 'BankDataIndex'
    	}, {
        type: 'string',
        dataIndex: 'branchDataIndex'
    	},{
        type: 'numeric',
        dataIndex: 'amountDataIndex'
    	},{
        type: 'string',
        dataIndex: 'paymentDataIndex'
    	},{
        type: 'string',
        dataIndex: 'AckGenDataIndex'
    	}]
    	});
    	
    	//***************************************************Filter Config Ends ***********************

    //*********************************************Column model config**********************************
    var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
        	header: "<span style=font-weight:bold;><%=SLNO%></span>",
        	width: 50
    		}), {
        	dataIndex: 'slnoIndex',
        	hidden: true,
        	header: "<span style=font-weight:bold;><%=SLNO%></span>",
        	filter: {
            type: 'numeric'
        	}
    		}, {
        	dataIndex: 'uniqueIdDataIndex',
        	hidden: true,
        	header: "<span style=font-weight:bold;><%=Unique_Id%></span>",
        	filter: {
            type: 'numeric'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=Challan_Number%></span>",
        	dataIndex: 'challanNumberDataIndex',
        	filter: {
            type: 'string'
        	}
    		}, {
        	header: "<span style=font-weight:bold;><%=Payment_Acc_Head%></span>",
        	dataIndex: 'paymentAcHeadDataIndex',
        	filter: {
            type: 'string'
        	}
    		},{
    		header: "<span style=font-weight:bold;><%=Type%></span>",
    		dataIndex: 'typeDataIndex',
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=TC_Number%></span>",
    		dataIndex: 'TCNODataIndex',
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=Mining_Lease_Name%></span>",
    		dataIndex: 'MineNameDataIndex',
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=Adjustment_Type%></span>",
    		dataIndex: 'AdjustmentTypeDataIndex',
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=Previous_Challan_Reference%></span>",
    		dataIndex: 'PreviousChallanDataIndex',
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=Previous_Challan_Date_Reference%></span>",
    		dataIndex: 'PreviousDateDataIndex',
    		//renderer: Ext.util.Format.dateRenderer(getDateFormat()),
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},{
        	header: "<span style=font-weight:bold;><%=Lease_NoMine_Owner%></span>",
        	dataIndex: 'ownerNameDataIndex',
        	//width: 80,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=Mineral_Type%></span>",
        	dataIndex: 'mineralTypeDataIndex',
        	//width: 80,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=Royalty_for_the_monthyear%></span>",
        	dataIndex: 'royaltyDataIndex',
        	//renderer: Ext.util.Format.dateRenderer(getDateFormat()),
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=Grade%></span>",
        	dataIndex: 'gradeDataIndex',
        	//width: 120,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=Exact_Grade%></span>",
        	dataIndex: 'extractGradeDataIndex',
        	//width: 80,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=Rate%></span>",
        	dataIndex: 'rateDataIndex',
        	//width: 80,
        	filter: {
            type: 'numeric'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=Quantity%></span>",
        	dataIndex: 'quantityDataIndex',
        	filter: {
            type: 'numeric'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=Total_Payable%></span>",
        	dataIndex: 'totalPayableDataIndex',
        	filter: {
            type: 'numeric'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=Payment_Description%></span>",
        	dataIndex: 'paymentDescriptionDataIndex',
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=Date_and_Time_of_Generation%></span>",
        	dataIndex: 'generationDateDataIndex',
        	//renderer: Ext.util.Format.dateRenderer(getDateFormat()),
        	//width: 80,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=NIC_Challan_No%></span>",
        	dataIndex: 'challanNoDataIndex',
        	//width: 80,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=NIC_Challan_Date%></span>",
        	dataIndex: 'challanDateDataIndex',
        	//renderer: Ext.util.Format.dateRenderer(getDateFormat()),
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=BankTransactionNumber%></span>",
        	dataIndex: 'transactionDataIndex',
        	//hidden:true,
        	//hideable: false,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=Bank%></span>",
        	dataIndex: 'bankDataIndex',
        	//hidden:true,
        	//hideable: false,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=Branch%></span>",
        	dataIndex: 'branchDataIndex',
        	//hidden:true,
        	//hideable: false,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=AmountPaid%></span>",
        	dataIndex: 'amountDataIndex',
        	//hidden:true,
        	//hideable: false,
        	filter: {
            type: 'numeric'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=Payment_Description%></span>",
        	dataIndex: 'paymentDataIndex',
        	//hidden:true,
        	//hideable: false,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=Acknowledgement_Generation_Datetime%></span>",
        	dataIndex: 'AckGenDataIndex',
        	//hidden:true,
        	//hideable: false,
        	filter: {
            type: 'string'
        	}
    		}
	       ];
 			return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        	});
    		};
    		
    		var buttonPanel=new Ext.FormPanel({
		        	id: 'buttonid',
		        	cls:'colorid',
		        	frame:true,
		            buttons:[{
			              		text: 'Back',
			              		cls:'colorid',
			              		iconCls:'backbutton',
			              		handler : function(){
			              		 window.location="<%=request.getContextPath()%>/Jsps/IronMining/ReconcilationReport.jsp";
	
			              		}
			              }]
		    });  
    		
     //*********************************************Column model config Ends*************************** 	
    //******************************************Creating Grid By Passing Parameter***********************
    
     grid = getGrid('<%=Challan_Details%>', '<%=noRecordsFound%>', store,screen.width-55,420, 30, filters, 'Clear Filter Data', false, '', 20, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', false, 'Add', false, 'Modify', false, '', false , '',false,'');
     		
	//**********************************End Of Creating Grid By Passing Parameter*************************
   
	Ext.onReady(function () {
        outerPanel = new Ext.Panel({
        //title: 'Trip Creation',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        //cls: 'outerpanel',
        height:500,
        width:screen.width-35,
        items: [grid,buttonPanel]
        
    });  
    
    store.load({
                    params: {
                        CustID: '<%=custId%>',
                        jspName: jspName,
                        CustName: '<%=custName%>',
                        TcNum:'<%=TcNum%>',
                        MonthYear:'<%=MonthYear%>'
                  }
              });  
               var cm = grid.getColumnModel();  
   for (var j = 1; j < cm.getColumnCount(); j++) {
      cm.setColumnWidth(j,120);
   } 
});				
   </script>
  </body>
</html>
<%}%>
<%}%>
