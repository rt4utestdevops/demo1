<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	int systemid=Integer.parseInt(str[0].trim());
	int customerid=Integer.parseInt(str[1].trim());
	int userid=Integer.parseInt(str[2].trim());
	String language=str[3].trim();
	LoginInfoBean loginInfo=new LoginInfoBean();
	loginInfo.setSystemId(systemid);
	loginInfo.setCustomerId(customerid);
	loginInfo.setUserId(userid);
	loginInfo.setLanguage(language);
	loginInfo.setZone(str[4].trim());
	loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
	loginInfo.setSystemName(str[6].trim());
	loginInfo.setCategory(str[7].trim());
	loginInfo.setStyleSheetOverride("N");
	if(str.length>8){
	loginInfo.setCustomerName(str[8].trim());
	}
	if(str.length>9){
	loginInfo.setCategoryType(str[9].trim());
	}
	if(str.length>10){
	loginInfo.setUserName(str[10].trim());
	}
	loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
	session.setAttribute("loginInfoDetails",loginInfo);
}
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		boolean isLtsp=loginInfo.getIsLtsp()==0;
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("SLNO");
tobeConverted.add("Id");
tobeConverted.add("Excel");
tobeConverted.add("Delete");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("Mine_Code");
tobeConverted.add("Enter_Mine_Code");
tobeConverted.add("Permit_Details");
tobeConverted.add("Permit_No");
tobeConverted.add("Date");
tobeConverted.add("TC_No");
tobeConverted.add("Route_Id");
tobeConverted.add("From_Location");
tobeConverted.add("To_Location");
tobeConverted.add("Enter_Date");
tobeConverted.add("Select_TC_Number");
tobeConverted.add("Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("Application_No");
tobeConverted.add("Enter_Application_No");
tobeConverted.add("Remarks");
tobeConverted.add("Enter_Remarks");
tobeConverted.add("Status");
tobeConverted.add("Id");
tobeConverted.add("Permit_Date");
tobeConverted.add("Select_Start_Date");
tobeConverted.add("Select_End_Date");
tobeConverted.add("Select_Route");
tobeConverted.add("Select_Mineral_Type");
tobeConverted.add("Route_Id");
tobeConverted.add("Select_Permit_No");
tobeConverted.add("Mineral_Type");
tobeConverted.add("Financial_Year");
tobeConverted.add("Enter_Financial_Year");
tobeConverted.add("Permit_Request_Type");
tobeConverted.add("Select_Permit_Request_Type");
tobeConverted.add("Owner_Type");
tobeConverted.add("Select_Owner_Type");
tobeConverted.add("Permit_Type");
tobeConverted.add("Select_Permit_Type");
tobeConverted.add("Lease_Name");
tobeConverted.add("Lease_Owner");
tobeConverted.add("Organization_Trader_Name");
tobeConverted.add("Ref");
tobeConverted.add("Select_Ref_Number");
tobeConverted.add("Add_Permit_Details");
tobeConverted.add("Modify_Permit_Details");
tobeConverted.add(" Route");
tobeConverted.add("Select_Route_ID");
tobeConverted.add("Permit_Closure");
tobeConverted.add("Add_Permit_Closure_Details");
tobeConverted.add("Tripsheet_Quantity");
tobeConverted.add("Quantity");
tobeConverted.add("Closed_Quantity");
tobeConverted.add("Enter_Closed_Quantity");
tobeConverted.add("Vessel_Name");
tobeConverted.add("Enter_Ship_Name");
tobeConverted.add("State");
tobeConverted.add("Select_State");
tobeConverted.add("Country");
tobeConverted.add("Select_Country");
tobeConverted.add("Buyer_Name");
tobeConverted.add("Enter_Buyer_Name");
tobeConverted.add("Total_Rejects");
tobeConverted.add("Total_Tailings");
tobeConverted.add("Total_Lumps");
tobeConverted.add("Total_Fines");
tobeConverted.add("Organization_Trader_Code");
tobeConverted.add("Select_Organisation_Trader_Code");
tobeConverted.add("Existing_Permit_No");
tobeConverted.add("Select_Buying_OrgTrader_Name");
tobeConverted.add("Buying_Organization_Trader_Code");
tobeConverted.add("Buying_Organization_Trader_Name");
tobeConverted.add("Permit_Quantity");
tobeConverted.add("Used_Quantity");
tobeConverted.add("Permit_Balance");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String Add=convertedWords.get(0);
String Modify=convertedWords.get(1);
String CustomerName=convertedWords.get(2);
String SelectCustomerName=convertedWords.get(3);
String NoRecordsFound=convertedWords.get(4);
String ClearFilterData=convertedWords.get(5);
String SLNO=convertedWords.get(6);
String ID=convertedWords.get(7);
String Excel=convertedWords.get(8);
String Delete=convertedWords.get(9);
String NoRowsSelected=convertedWords.get(10);
String SelectSingleRow=convertedWords.get(11);
String Save=convertedWords.get(12);
String Cancel=convertedWords.get(13);
String Mine_Code=convertedWords.get(14);
String Enter_Mine_Code=convertedWords.get(15);
String Permit_Details=convertedWords.get(16);
String Permit_No=convertedWords.get(17);
String Date=convertedWords.get(18);
String Tc_No=convertedWords.get(19);
String Route_Id=convertedWords.get(20);
String From_Location=convertedWords.get(21);
String To_Location=convertedWords.get(22);
String Enter_Date=convertedWords.get(23);
String Select_TC_Number=convertedWords.get(24);
String Start_Date=convertedWords.get(25);
String End_Date=convertedWords.get(26);
String Application_No=convertedWords.get(27);
String Enter_Application_No=convertedWords.get(28);
String Remarks=convertedWords.get(29);
String Enter_Remarks=convertedWords.get(30);
String Status=convertedWords.get(31);
String Id=convertedWords.get(32);
String Permit_Date=convertedWords.get(33);
String Enter_Start_Date=convertedWords.get(34);
String Enter_End_Date=convertedWords.get(35);
String Select_Route=convertedWords.get(36);
String SelectMineral=convertedWords.get(37);
String RouteID=convertedWords.get(38);
String Select_Permit_No=convertedWords.get(39);
String Mineral=convertedWords.get(40);
String Financial_Year=convertedWords.get(41);
String Enter_Financial_Year=convertedWords.get(42);
String Permit_Request_Type=convertedWords.get(43);
String Select_Permit_Request_Type=convertedWords.get(44);
String Owner_Type=convertedWords.get(45);
String Select_Owner_Type=convertedWords.get(46);
String Permit_Type=convertedWords.get(47);
String Select_Permit_Type=convertedWords.get(48);
String Lease_Name=convertedWords.get(49);
String Lease_Owner=convertedWords.get(50);
String OrganizationTrader_Name=convertedWords.get(51);
String Ref=convertedWords.get(52);
String Select_Ref_Number=convertedWords.get(53);
String Add_Permit_Details=convertedWords.get(54);
String Modify_Permit_Details=convertedWords.get(55);
String Route=convertedWords.get(56);
String Select_Route_ID=convertedWords.get(57);
String Permit_Closure=convertedWords.get(58);
String Add_Permit_Closure_Details=convertedWords.get(59);
String Tripsheet_Qty=convertedWords.get(60);
String Qty=convertedWords.get(61);
String Closed_Qty=convertedWords.get(62);
String Enter_Closed_Qty=convertedWords.get(63);
String Ship_Name=convertedWords.get(64);
String Select_Vessel_Name="Select Vessel Name";//convertedWords.get(65);
String State_Name=convertedWords.get(66);
String Select_State=convertedWords.get(67);
String Country_Name=convertedWords.get(68);
String Select_Country=convertedWords.get(69);
String Buyer_Name=convertedWords.get(70);
String Enter_Buyer_Name=convertedWords.get(71);
String Total_Rejects=convertedWords.get(72);
String Total_Tailings=convertedWords.get(73);
String Total_Lumps=convertedWords.get(74);
String Total_Fines=convertedWords.get(75);
String OrganizationTrader_Code=convertedWords.get(76);
String Select_OrganisationTrader_Code=convertedWords.get(77);
String Existing_Permit_No=convertedWords.get(78);
String Select_Buying_OrgTrader_Name=convertedWords.get(79);
String Buying_OrganizationTrader_Code=convertedWords.get(80);
String Buying_OrganizationTrader_Name=convertedWords.get(81);
String Permit_Quantity=convertedWords.get(82);
String Used_Quantity=convertedWords.get(83);
String Permit_Balance=convertedWords.get(84);

String exactFines = "Fines";
String exactLumps = "Lumps";
int userId=loginInfo.getUserId(); 
String userAuthority=cf.getUserAuthority(systemId,userId);	
boolean ackvalue = true;
boolean Inactivevalue = true;
	if(userAuthority.equalsIgnoreCase("Supervisor")){
		ackvalue = false;
		Inactivevalue=false;
	}
%>
<jsp:include page="../Common/header.jsp" />
 		<title>Permit Details</title>	
 		<script src="../../Main/modules/ironMining/PermitFunctions.js"></script>
 		<script src="../../Main/modules/ironMining/PermitType.js"></script>
    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
.labelsize {
	spacing: 10px;
	height: 20px;
	width: 150 px !important;
	min-width: 150px !important;
	margin-bottom: 10px !important;
	margin-top: 10px !important;
	margin-left: 15px !important;
	font-size: 12px;
	font-family: sans-serif;
	font-weight:bold !important;
}
.ui-helper-hidden-accessible{visibility: hidden; display: none;}
.ui-autocomplete { overflow-y: scroll; max-height: 130px; position: absolute; min-width: 160px; padding: 4px 0; margin: 0 0 10px 25px; background-color: #ffffff;}
.ui-menu-item { background: #ffffff; border-color: #ffffff; padding: 2.5px 0;}
.ui-state-hover, .ui-state-focus, .ui-state-active { color: #ffffff; text-decoration: none; background-color: #5f6f81; border-radius: 0px; -webkit-border-radius: 0px; -moz-border-radius: 0px; background-image: none; }
#mwalletId{
	font-weight:bolder !important;
	font-size: 15px !important;
}
	
  </style>
  
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
    <% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		<style>
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			label {
				display : inline !important;
			}
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
				height : 38px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}
			.x-menu-list {
				height:auto !important;
			}
			fieldset#PermitInfoId {
				width : 500px !important;
			}
			fieldset#PermitclId {
				width : 452px !important;	
			}
			.innerpanelsmallest {
				//margin-top: -44px !important;
				//height: 88px  !important;
			}
			.x-form-check-wrap {
				float: left;
				margin-top: -16px;
			}
			.innerpanelsmallest {
				height: 61px !important;
			}
			
		</style>
		
	<%}%>
   <script src="../../Main/modules/ironMining/PermitPreview.js"></script>
   <script>
   
    var outerPanel;
    var ctsb;
    var jspName = "Permit Details";
    var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,string,string,number3,number3,number3,number3,number3,number,number,number3,string,string,string,string,string,string,string,string,string,string,string,int,string,string,string,string,string,string,string,string,string,int,string,string,string,string,string,string,string,string,string,string,string";
    var selected;
    var grid;
    var buttonValue;
    var titelForInnerPanel;
    var dtcur = datecur;
    var dtprev = dateprev;
    var myWin;
    var tripSheetQty;
    var romAmt;
    var romQty;
    var eWalletAmt;
    var eWalletQty;
    var countryid;
    var editedRowsForGrid = "";
    var editedRows = "";
    var challanID;
    var totalAmtt=0;
    var d = new Date();
    var d1 = new Date();
    var totalPayableRom;
    var TcorgId;
    var datenext= new Date(d1.setDate(d1.getDate() + 30));
    var datenext1= nextDate;
    var curYear = d.getFullYear();
    var preYear = d.getFullYear()-1;
    var year;
    var RomState;
    var challanId;
    var orgCode = '';
    var json = '';
    var stockValue="";
    var permitIDD=0;
    var basePath = '<%=basePath%>';
    var nextYear = d.getFullYear()+1;
    if(d.getMonth()>=3){
      year=curYear + '-' + nextYear;
    }else{
      year=preYear + '-' + curYear;
    }
    var loadMask = new Ext.LoadMask(Ext.getBody(), {
        msg: "Saving"
    });
    var listOfPermitNo = [];
    var listOfOrgName = [];
    var isSelected = false;
    function stockTyperender(value, p, r) {
        var returnValue = "";
        var idx = StockTypeStore1.findBy(function (record) {
            if (record.get('routeId') == value) {
                returnValue = record.get('stockType');
            }
        });
        return returnValue;
    }
    var clientcombostore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
        id: 'CustomerStoreId',
        root: 'CustomerRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['CustId', 'CustName'],
        listeners: {
            load: function(custstore, records, success, options) {
                if (<%= customerId %> > 0) {
                    Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                    custId = Ext.getCmp('custcomboId').getValue();
                    store.load({
                        params: {
                            CustId: custId,
                            jspName: jspName,
                            CustName: Ext.getCmp('custcomboId').getRawValue(),
                            endDate: Ext.getCmp('enddate').getValue(),
                            startDate: Ext.getCmp('startdate').getValue()
                        }
                    });
        			PermitsForSearchStore.load({ 
                    	params: {custId: custId},
                    	callback: function(){
                    		listOfPermitNo=[];
			 				for(var i=0; i<PermitsForSearchStore.getCount(); i++){
								var rec = PermitsForSearchStore.getAt(i);
								listOfPermitNo.push(rec.data['PERMIT_NO']);
							}
                    	}
                    });
                    OrgNamesForSearchStore.load({ 
                    	params: {custId: custId},
                    	callback: function(){
                    	listOfOrgName=[];
			 				for(var i=0; i<OrgNamesForSearchStore.getCount(); i++){
								var rec = OrgNamesForSearchStore.getAt(i);
								listOfOrgName.push(rec.data['ORG_NAME']);
							}
						}
                    });          
                    TcNoComboStore.load({
                        params: {
                            CustID: Ext.getCmp('custcomboId').getValue()
                        }
                    });
                    organizationCodeStore.load({
                        params: {
                            CustId: custId
                        }
                    });
                    hubStore.load({
                    params: {
                            CustID: custId,
                            permitType:'',
                            orgId: 0,
                            mineral:''
                        }
                    });
                }
            }
        }
    });
    var Client = new Ext.form.ComboBox({
        store: clientcombostore,
        id: 'custcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectCustomerName%>',
        blankText: '<%=SelectCustomerName%>',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'CustId',
        displayField: 'CustName',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    custId = Ext.getCmp('custcomboId').getValue();
                    store.load({
                        params: {
                            CustId: custId,
                            jspName: jspName,
                            CustName: Ext.getCmp('custcomboId').getRawValue(),
                            endDate: Ext.getCmp('enddate').getValue(),
                            startDate: Ext.getCmp('startdate').getValue()
                        }
                    });
                    PermitsForSearchStore.load({ 
                    	params: {custId: custId},
                    	callback: function(){
                    		listOfPermitNo=[];
			 				for(var i=0; i<PermitsForSearchStore.getCount(); i++){
								var rec = PermitsForSearchStore.getAt(i);
								listOfPermitNo.push(rec.data['PERMIT_NO']);
							}
                    	}
                    });
                    OrgNamesForSearchStore.load({ 
                    	params: {custId: custId},
                    	callback: function(){
                    		listOfOrgName=[];
			 				for(var i=0; i<OrgNamesForSearchStore.getCount(); i++){
								var rec = OrgNamesForSearchStore.getAt(i);
								listOfOrgName.push(rec.data['ORG_NAME']);
							}
						}
                    });
                    TcNoComboStore.load({
                        params: {
                            CustID: Ext.getCmp('custcomboId').getValue()
                        }
                    });
                    organizationCodeStore.load({
                        params: {
                            CustId: custId
                        }
                    });
                    hubStore.load({
	                    params: {
	                            CustID: custId,
	                            permitType:'',
	                            orgId: 0,
	                            mineral:''
	                        }
                    });
                }
            }
        }
    });
    var customerComboPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'customerComboPanelId',
        layout: 'table',
        cls: 'innerpanelsmallest',
        frame: false,
        width: '100%',
        layoutConfig: {
            columns: 13
        },
        items: [{
                xtype: 'label',
                text: '<%=CustomerName%>' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
            },
            Client,
            {
                width: 10
            }, {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'startdatelab',
                width: 200,
                text: 'Start Date' + ' :'
            }, {
                width: 10
            }, {
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                width: 120,
                format: getDateFormat(),
                emptyText: 'Select Start Date',
                allowBlank: false,
                blankText: 'Select Start Date',
                id: 'startdate',
                value: currentDate
            }, {
                width: 50
            }, {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'enddatelab',
                width: 200,
                text: 'End Date' + ' :'
            }, {
                width: 30
            }, {
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                width: 160,
                format: getDateFormat(),
                emptyText: 'Select End Date',
                allowBlank: false,
                blankText: 'Select End Date',
                id: 'enddate',
                value: datenext1
            }, {
                width: 20
            }, {
                xtype: 'button',
                text: 'View',
                id: 'submitId',
                cls: 'buttonStyle',
                width: 60,
                handler: function() {
                Ext.getCmp('customSearchPanelId').collapse();
                Ext.getCmp('radioGroupId').reset();
                Ext.getCmp('SearchTextId').reset();
                if (Ext.getCmp('custcomboId').getValue() == "") {
                        Ext.example.msg("Select Customer");
                        Ext.getCmp('custcomboId').focus();
                        return;
                    }
                    if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                        Ext.example.msg("End date must be greater than Start date");
                        Ext.getCmp('enddate').focus();
                        return;
                    }
                    var Startdates = Ext.getCmp('startdate').getValue();
                    var Enddates = Ext.getCmp('enddate').getValue();
                    var dateDifrnc = new Date(Enddates).add(Date.DAY, -90);
                    if (Startdates < dateDifrnc) {
                        Ext.example.msg("Difference between two dates should not be  greater than 31 days.");
                        Ext.getCmp('startdate').focus();
                        return;
                    }
                	store.load({
		               params: {
		               	jspName: jspName,
		               	CustName: Ext.getCmp('custcomboId').getRawValue(),
	                    CustId: custId,
	                    endDate: Ext.getCmp('enddate').getValue(),
	                    startDate: Ext.getCmp('startdate').getValue()
		               }
		           });
                }
            }
        ]
    });
    //************************************Permit Number Store for Custom Search **************************************
    var PermitsForSearchStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getPermitsForCustomSearch',
        root: 'PermitsForSearchRoot',
        autoLoad: false,
        remoteSort: true,
        id: 'PermitsForSearchStoreId',
        fields: ['PERMIT_ID', 'PERMIT_NO']
    });
    //************************************Organization Number Store for Custom Search **************************************
    var OrgNamesForSearchStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getOrgNamesForCustomSearch',
        root: 'OrgNamesForSearchRoot',
        autoLoad: false,
        remoteSort: true,
        id: 'OrgNamesForSearchStoreId',
        fields: ['ORG_ID', 'ORG_NAME','ORG_CODE']
    });
    //************************************Custom Search Panel**************************************
   var customSearchPanel = new Ext.form.FieldSet({
        standardSubmit: true,
        collapsible: true,
        collapsed : true,
        title : 'Custom Search',
        id: 'customSearchPanelId',
        layout: 'table',
        cls: 'innerpanelsmallest',
        frame: false,
        width: '99%',
        layoutConfig: {
            columns: 8
        },
        items: [{width:230},{xtype: 'label',
        		text: 'Search by :',
                cls: 'labelstyle',
        		},{width:30},{
	            xtype: 'radiogroup',
	            fieldLabel: 'Search by',
	            id:'radioGroupId',
	            column:4,
	            cls: 'x-check-group-alt',
	            items: [{xtype: 'radio', boxLabel: 'Permit Number&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;', name: 'radio_selection', inputValue: 1, checked: false},
	                	{xtype: 'radio', boxLabel: 'Organization Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;', name: 'radio_selection', inputValue: 2, checked: false},
	                	{xtype: 'radio', boxLabel: 'Buying Organization Name&nbsp;&nbsp;&nbsp;&nbsp;', name: 'radio_selection', inputValue: 3, checked: false},
	                	{xtype: 'radio', boxLabel: 'All Permits', name: 'radio_selection', inputValue: 4, checked: false, id:'allPermitsId'}],
	                	listeners: { change : function(obj, value){
	                	    Ext.getCmp('SearchTextId').reset();
	                	    Ext.getCmp('SearchTextId').focus();
	                	    store.removeAll();
	                	    isSelected = false;
	                	  }
	                     }
             },{width:30}, 
             { xtype: 'textfield',
              enableKeyEvents : true,
              id: 'SearchTextId',
              resizable:true, 
              width:180,
              style: {
		           
		      },
              mode: 'local',
              forceSelection: false,
              selectOnFocus: true,
              autoScroll: true,
              listeners: { keyup: function(f,n,o){
              			var checked= Ext.DomQuery.selectValue('input[name=radio_selection]:checked/@value');
			 			if(checked==null){Ext.example.msg("Select Search by");}
			 			else if(checked==1){
							$( "#SearchTextId" ).autocomplete({
								source: listOfPermitNo,
								
						      	select: function(event, ui) {
						      		isSelected = true;
				            	}
						    });
			 			}
			 			else if(checked==2){
							$( "#SearchTextId" ).autocomplete({
								source: listOfOrgName,
						      	select: function(event, ui) {
						      		isSelected = true;
				            	}
						    });
			 			}
			 			else if(checked==3){
							$( "#SearchTextId" ).autocomplete({
								source: listOfOrgName,
						      	select: function(event, ui) {
						      		isSelected = true;
				            	}
						    });
			 			}else if(checked==4){
			 				Ext.getCmp('SearchTextId').hide();
			 			}
		 			} },
        	},{width:35}, {
            xtype: 'button',
            text: 'Search',
            id: 'searchButtonId',
            cls: 'buttonstyle',
            width: 70,
            listeners: {
                click: {
                    fn: function() {
	                    if (Ext.getCmp('custcomboId').getValue() == "") {
	                        Ext.example.msg("Select Customer");
	                        Ext.getCmp('custcomboId').focus();
	                        return;
	                    }
	                    var checked= Ext.DomQuery.selectValue('input[name=radio_selection]:checked/@value');
			 			if(checked==null){Ext.example.msg("Select Search by");}
			 			else if(checked==1){
			 				if(isSelected == false){
			 					Ext.example.msg("Enter Permit Number");
			 					Ext.getCmp('SearchTextId').reset();
			 				}else{
			 				var row=PermitsForSearchStore.find('PERMIT_NO',Ext.getCmp('SearchTextId').getRawValue());
			 				var rec=PermitsForSearchStore.getAt(row);
			 				if(rec==null){
			 					Ext.example.msg("Permit Number mismatch");
			 				}else{
			 				var selectedPermitId=rec.data['PERMIT_ID'];
			 				store.load({
                                    params: {
                                    	jspName: jspName,
                                    	CustName: Ext.getCmp('custcomboId').getRawValue(),
                                        CustId: custId,
                                        endDate: Ext.getCmp('enddate').getValue(),
                                        startDate: Ext.getCmp('startdate').getValue(),
                                        selectedPermitId: selectedPermitId
                                    }
                                });
							}
						  }
			 			}
			 			else if(checked==2){
			 				if(isSelected == false){
			 					Ext.example.msg("Select Organization Name");
			 					Ext.getCmp('SearchTextId').reset();
			 				}else{
							var row=OrgNamesForSearchStore.find('ORG_NAME',Ext.getCmp('SearchTextId').getRawValue());
			 				var rec=OrgNamesForSearchStore.getAt(row);
			 				if(rec==null){
			 					Ext.example.msg("Organization mismatch");
			 				}else{
			 				var selectedOrgId=rec.data['ORG_ID'];
			 				store.load({
                                    params: {
                                    	jspName: jspName,
                                    	CustName: Ext.getCmp('custcomboId').getRawValue(),
                                        CustId: custId,
                                        endDate: Ext.getCmp('enddate').getValue(),
                                        startDate: Ext.getCmp('startdate').getValue(),
                                        selectedOrgId: selectedOrgId
                                    }
                                });
                            }
                          }     
			 			}
			 			else if(checked==3){
			 				if(isSelected == false){
			 					Ext.example.msg("Select Buying Organization Name");
			 					Ext.getCmp('SearchTextId').reset();
			 				}else{
							var row=OrgNamesForSearchStore.find('ORG_NAME',Ext.getCmp('SearchTextId').getRawValue());
			 				var rec=OrgNamesForSearchStore.getAt(row);
			 				if(rec==null){
			 					Ext.example.msg("Organization mismatch");
			 				}else{
			 				var selectedBuyingOrgId=rec.data['ORG_ID'];
			 				store.load({
                                    params: {
                                    	jspName: jspName,
                                    	CustName: Ext.getCmp('custcomboId').getRawValue(),
                                        CustId: custId,
                                        endDate: Ext.getCmp('enddate').getValue(),
                                        startDate: Ext.getCmp('startdate').getValue(),
                                        selectedBuyOrgId: selectedBuyingOrgId
                                    }
                                });
                            }
                          }     
			 			}
			 			else if(checked==4){
			 				window.open("<%=request.getContextPath()%>/AllChallansOrPermitsExcel?requesrtingFor=PermitDetails");
			 			}
                    }
                }    
               }
            }]//panel
    }); 
    //******************************store for Permit request type**********************************
    var permitrequesttypeStore = new Ext.data.SimpleStore({
        id: 'permitrequestTypeId',
        fields: ['Name', 'Value'],
        autoLoad: true,
        data: [
            ['New Permit Request', 'New Permit Request']
        ]
    });
    //****************************combo for Permit request type****************************************
    var permitrequesttypeCombo = new Ext.form.ComboBox({
        store: permitrequesttypeStore,
        id: 'permitreqtypecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_Permit_Request_Type%>',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        value: permitrequesttypeStore.getAt(0).data['Value'],
        valueField: 'Value',
        displayField: 'Name',
        cls: 'selectstylePerfect',
    });
     //******************************store for Transportation type**********************************
    var transportationTypeStore = new Ext.data.SimpleStore({
        id: 'transportnType',
        fields: ['Name', 'Value'],
        autoLoad: true,
        data: [
            ['Road', 'Road'],
            ['Railways', 'Railways'],
            ['WaterWays', 'WaterWays'],
            ['Sea', 'Sea']
        ]
    });
    //****************************combo for Transportation type****************************************
    var transPortationTypeCombo = new Ext.form.ComboBox({
        store: transportationTypeStore,
        id: 'transportnTypecomboId',
        mode: 'local',
        emptyText: 'Select Transportation Type',
        resizable: true,
        selectOnFocus: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                }
            }
        }
    });
    var gradeStore1 = new Ext.data.SimpleStore({
        id: 'gradeStoreId',
        fields: ['Name', 'Value'],
        autoLoad: false,
        data: [
            ['Lumps', 'Lumps'],
            ['Fines', 'Fines'],
            ['Rom', 'Rom'],
            ['Concentrates', 'Concentrates'],
            ['Tailings', 'Tailings'],
            ['NA', 'NA']
        ]
    });
    var gradeCombo = new Ext.form.ComboBox({
        store: gradeStore1,
        id: 'grdecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Grade',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        listeners: {
            select: {
                fn: function() {
                }
            }
        }
    });
    var hubStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getHubLocation',
        root: 'sourceHubStoreRoot',
        autoLoad: false,
        remoteSort: true,
        id: 'hubStoreId',
        fields: ['Hubname', 'HubID']
    });
    var hubCombo = new Ext.form.ComboBox({
        store: hubStore,
        id: 'hubId',
        mode: 'local',
        resizable: true,
        forceSelection: true,
        emptyText: 'Select Source Hub',
        blankText: 'Select Source Hub',
        selectOnFocus: true,
        cls: 'selectstylePerfect',
        submitValue: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        displayField: 'Hubname',
        valueField: 'HubID',
        listeners: {
            select: {
                fn: function() {
                	exportStore.load({
                        params: {
                            orgCode: Ext.getCmp('organizationcodeid').getValue(),
                            CustID: Ext.getCmp('custcomboId').getValue(),
                            routeId:Ext.getCmp('hubId').getValue(),
                            mineralType: Ext.getCmp('mineralcomboId').getValue(),
                            permitType:Ext.getCmp('permittypecomboId').getValue()
                        }
                   });
                   StockTypeStore1.load({
                        params: {
                            orgCode: Ext.getCmp('organizationcodeid').getValue(),
                            CustID: Ext.getCmp('custcomboId').getValue(),
                            routeId:Ext.getCmp('hubId').getValue(),
                            mineralType: Ext.getCmp('mineralcomboId').getValue(),
                            permitType:Ext.getCmp('permittypecomboId').getValue()
                        }
                   });
                }
            }
        }
    });
    var StockTypeStore1 = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getStockType',
        root: 'stockTypeRoot',
        autoLoad: false,
        remoteSort: true,
        id: 'StockmineralStoreId',
        fields: ['stockType', 'totalLumps', 'totalFines', 'totalTailings', 'totalRejects','routeId','totalQty','romQty','totalConc']
    });
    var stockTypeCombo = new Ext.form.ComboBox({
        store: StockTypeStore1,
        id: 'stockcomboId',
        mode: 'local',
        forceSelection: true,
        resizable: true,
        emptyText: 'Select Stock Type',
        blankText: 'Select Stock Type',
        selectOnFocus: true,
        submitValue: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        displayField: 'stockType',
        valueField: 'routeId',
        listeners: {
            select: {
                fn: function() {}
            }
        }
    });
    //******************************store for OwnerType**********************************
    var ownertypeStore = new Ext.data.SimpleStore({
        id: 'ownerTypeId',
        fields: ['Name', 'Value'],
        autoLoad: false,
        data: [
            ['Bidder', 'Bidder'],
            ['Mining Lease', 'Mining Lease'],
            ['Trader', 'Trader'],
            ['Exporter', 'Exporter']
        ]
    });

    //****************************combo for Ownertype****************************************
    var ownertypeCombo = new Ext.form.ComboBox({
        store: ownertypeStore,
        id: 'ownertypecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_Owner_Type%>',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                }
            }
        }
    });
    //******************************store for PermitType**********************************
    var permittypeStore = new Ext.data.SimpleStore({
        id: 'permitTypeId',
        fields: ['Name', 'Value'],
        autoLoad: false,
        data: [
           ['ROM Transit', 'Rom Transit'],
           ['ROM Sale', 'Rom Sale'],
           ['Purchased ROM Sale Transit Permit', 'Purchased Rom Sale Transit Permit'],
           ['Processed Ore Transit', 'Processed Ore Transit'],
           ['Processed Ore Sale', 'Processed Ore Sale'],
           ['Processed Ore Sale Transit', 'Processed Ore Sale Transit'],
           ['Domestic Export', 'Domestic Export'],
           ['International Export', 'International Export'],
           ['Import Permit', 'Import Permit'],
           ['Import Transit Permit', 'Import Transit Permit'],
           ['Bauxite Transit', 'Bauxite Transit']
        ]
    });

 //******************************store for PermitType**********************************
    var permittypeStoreForClose = new Ext.data.SimpleStore({
        id: 'permitTypecloId',
        fields: ['Name', 'Value'],
        autoLoad: false,
        data: [
        	['Rom Transit', 'Rom Transit'],
            ['Processed Ore Transit', 'Processed Ore Transit'],
            ['Domestic Export', 'Domestic Export'],
            ['International Export', 'International Export'],
            ['Processed Ore Sale Transit', 'Processed Ore Sale Transit'],
            ['ROM Sale', 'Rom Sale'],
            ['Purchased ROM Sale Transit Permit', 'Purchased Rom Sale Transit Permit']
        ]
    });
    
     //******************************store for Type**********************************
    var typeStoreForClose = new Ext.data.SimpleStore({
        id: 'cloId',
        fields: ['Name', 'Value'],
        autoLoad: false,
        data: [
        	['Refundable', 'Refundable'],
            ['Non-Refundable', 'Non-Refundable']
        ]
    });
    
    var typeComboForClose = new Ext.form.ComboBox({
        store: typeStoreForClose,
        id: 'refundId',
        mode: 'local',
        forceSelection: true,
        resizable: true,
        emptyText: 'Select Processing Fee Amount',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                }
            }
        }
    });
    
    //****************************combo for PermitType****************************************
    var permittypeCombo = new Ext.form.ComboBox({
        store: permittypeStore,
        id: 'permittypecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_Permit_Type%>',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        cls: 'selectstylePerfect',
        resizable: true,
        listeners: {
            select: {
                fn: function() {
                	Store2.load({
			            params: {
			                CustID: Ext.getCmp('custcomboId').getValue(),
			                id: 0,
			                permitType:Ext.getCmp('permittypecomboId').getValue(),
			                mineralType: Ext.getCmp('mineralcomboId').getValue()
			            }
			        });
                      getPermitLabels();
					}
                }
            }
    });
        //******************************store for Import Type**********************************
    var typeOfImportStore = new Ext.data.SimpleStore({
        id: 'importTypeId',
        fields: ['Name', 'Value'],
        autoLoad: false,
        data: [
            ['Domestic Import', 'Domestic Import'],
            ['International Import', 'International Import']
        ]
    });
        //****************************combo for Import Type****************************************
    var ImporttypeCombo = new Ext.form.ComboBox({
        store: typeOfImportStore,
        id: 'importtypecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Import Permit Type',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    Ext.getCmp('buyerId').setValue('');
                    Ext.getCmp('countryComboId').setValue('');
                    Ext.getCmp('shipId').setValue('');
                    Ext.getCmp('stateComboId').setValue('');
                    Ext.getCmp('organizationcodeid').setValue('');
                    Ext.getCmp('buyingOrgComboId').setValue('');
                    Ext.getCmp('buyingOrgCodeid').setValue('');
                    Ext.getCmp('ownertypecomboId').reset();
                    if (Ext.getCmp('importtypecomboId').getValue() == 'Domestic Import' || Ext.getCmp('importtypecomboId').getValue() == 'International Import') {
                        proccessedOreGrid.show();
                        outerPanelForGrid.hide();
                        gridPanel.show();
                        gridForExportDetails.hide();
                        proccessedOreGrid.getColumnModel().setHidden(proccessedOreGrid.getColumnModel().findColumnIndex('stockTypeIdIndex'), true);
                        Ext.getCmp('mandatoryHead200').show(); Ext.getCmp('mandatorystate').show(); Ext.getCmp('labelstate').show(); Ext.getCmp('stateComboId').show();
                        Ext.getCmp('mandatorycountry').hide(); Ext.getCmp('labelcountry').hide(); Ext.getCmp('countryComboId').hide(); Ext.getCmp('mandatoryHead199').hide();
                        Ext.getCmp('countryLabId').hide();Ext.getCmp('countryTxtId').hide();Ext.getCmp('hos38').hide();
						Ext.getCmp('stateLabId').show();Ext.getCmp('stateTxtId').show();Ext.getCmp('hos40').show();
                    }if(Ext.getCmp('importtypecomboId').getValue() == 'International Import'){
                    	Ext.getCmp('mandatoryHead200').hide(); Ext.getCmp('mandatorystate').hide(); Ext.getCmp('labelstate').hide(); Ext.getCmp('stateComboId').hide();
                    	Ext.getCmp('mandatorycountry').show(); Ext.getCmp('labelcountry').show(); Ext.getCmp('countryComboId').show(); Ext.getCmp('mandatoryHead199').show();
                    	Ext.getCmp('countryLabId').show();Ext.getCmp('countryTxtId').show();Ext.getCmp('hos38').show();
						Ext.getCmp('stateLabId').hide();Ext.getCmp('stateTxtId').hide();Ext.getCmp('hos40').hide();
                    }
                }
            }
        }
    });
         //******************************store for Import purpose**********************************
    var importPurposeStore = new Ext.data.SimpleStore({
        id: 'importPurposeId',
        fields: ['Name', 'Value'],
        autoLoad: false,
        data: [
            ['Self Consumption', 'Self Consumption'],
            ['Trading', 'Trading'],
            ['Other', 'Other']
        ]
    });
        //****************************combo for Import purpose****************************************
    var ImportPurposeCombo = new Ext.form.ComboBox({
        store: importPurposeStore,
        id: 'importpurposecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Import Purpose',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        cls: 'selectstylePerfect',
    });
    //******************************store for Source**********************************
    var newsourceStore = new Ext.data.SimpleStore({
        id: 'newsourceId',
        fields: ['Name', 'Value'],
        autoLoad: false,
        data: [
            ['ROM', 'ROM'],
            ['E-Wallet', 'E-Wallet']
        ]
    });
    //****************************combo for New Source for ROM Closure Type**************************************** 
       var NewSourceCombo = new Ext.form.ComboBox({
        store: newsourceStore,
        id: 'newsourcecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Source ',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    Ext.getCmp('organizationcodeCloseid').reset();
                    Ext.getCmp('organizationid1').reset();
                    Ext.getCmp('minecodeId1').reset();
                    Ext.getCmp('leaseNameid1').reset();
                    Ext.getCmp('leaseOwnerid1').reset();
                    Ext.getCmp('TccomboId1').reset();
                    Ext.getCmp('PermitNocomboId').reset();
                    Ext.getCmp('ownertypecomboId').reset();
                    Ext.getCmp('vesselNameClose').reset();
                    PermitNoStore.removeAll(true);
                    PermitNoDetailsStore.removeAll(true);
                    Ext.getCmp('permitdateId').reset(),
			        Ext.getCmp('qtyId').reset();
			        Ext.getCmp('qtydeductionId').reset();
			        Ext.getCmp('closedqtyId').reset();
			        Ext.getCmp('romQuantityid').reset();
                    PermitNoStore.load({
                        params: {
                        }
                    });
                     
                    if ((Ext.getCmp('permittypeCloseId').getValue() == 'Rom Sale' && Ext.getCmp('newsourcecomboId').getValue()=='ROM')){
                        
                        Ext.getCmp('mandatoryidorg').show();
                        Ext.getCmp('mandatoryorg1').show();
                        Ext.getCmp('orgcode1LabelId1').show();
                        Ext.getCmp('organizationcodeCloseid').show();
                        Ext.getCmp('mandatoryid5').show();
                        Ext.getCmp('mandatoryorganization1').show();
                        Ext.getCmp('orgnamelabelid').show();
                        Ext.getCmp('organizationid1').show();
                        Ext.getCmp('mandatoryid2').hide();
                        Ext.getCmp('mandatoryminecode1').hide();
                        Ext.getCmp('minecodeLabelId').hide();
                        Ext.getCmp('minecodeId1').hide();
                        Ext.getCmp('mandatoryid3').hide();
                        Ext.getCmp('mandatoryleasename1').hide();
                        Ext.getCmp('leasenameLabelid').hide();
                        Ext.getCmp('leaseNameid1').hide();
                        Ext.getCmp('mandatoryid4').hide();
                        Ext.getCmp('mandatoryleaseowner1').hide();
                        Ext.getCmp('leaseOwnerIdlabel').hide();
                        Ext.getCmp('leaseOwnerid1').hide();
                        Ext.getCmp('mandatoryid01').hide();
                        Ext.getCmp('mandatorytcno1').hide();
                        Ext.getCmp('TcNoLabelId1').hide();
                        Ext.getCmp('TccomboId1').hide();
                    }
					if ((Ext.getCmp('permittypeCloseId').getValue() == 'Rom Sale' && Ext.getCmp('newsourcecomboId').getValue()=='E-Wallet')) {
                        
                        Ext.getCmp('mandatoryidorg').hide();
                        Ext.getCmp('mandatoryorg1').hide();
                        Ext.getCmp('orgcode1LabelId1').hide();
                        Ext.getCmp('organizationcodeCloseid').hide();
                        Ext.getCmp('mandatoryid5').hide();
                        Ext.getCmp('mandatoryorganization1').hide();
                        Ext.getCmp('orgnamelabelid').hide();
                        Ext.getCmp('organizationid1').hide();
                        Ext.getCmp('mandatoryid2').show();
                        Ext.getCmp('mandatoryminecode1').show();
                        Ext.getCmp('minecodeLabelId').show();
                        Ext.getCmp('minecodeId1').show();
                        Ext.getCmp('mandatoryid3').show();
                        Ext.getCmp('mandatoryleasename1').show();
                        Ext.getCmp('leasenameLabelid').show();
                        Ext.getCmp('leaseNameid1').show();
                        Ext.getCmp('mandatoryid4').show();
                        Ext.getCmp('mandatoryleaseowner1').show();
                        Ext.getCmp('leaseOwnerIdlabel').show();
                        Ext.getCmp('leaseOwnerid1').show();
                        Ext.getCmp('mandatoryid01').show();
                        Ext.getCmp('mandatorytcno1').show();
                        Ext.getCmp('TcNoLabelId1').show();
                        Ext.getCmp('TccomboId1').show();
					}
					if (Ext.getCmp('permittypeCloseId').getValue() == 'International Export'){
						vesselNameStore.load({
				            params: {
				                custId: Ext.getCmp('custcomboId').getValue()
				            }
				        });
				        Ext.getCmp('mandatoryid100').show();
                        Ext.getCmp('mandatoryvesselClose').show();
                        Ext.getCmp('vesselnameLabelId1').show();
                        Ext.getCmp('vesselNameClose').show();
					}else{
						Ext.getCmp('mandatoryid100').hide();
                        Ext.getCmp('mandatoryvesselClose').hide();
                        Ext.getCmp('vesselnameLabelId1').hide();
                        Ext.getCmp('vesselNameClose').hide();
					}
                }
            }
        }
    });
        //****************************combo for PermitType****************************************
    var permittypeComboForClosure = new Ext.form.ComboBox({
        store: permittypeStoreForClose,
        id: 'permittypeCloseId',
        mode: 'local',
        forceSelection: true,
        resizable: true,
        emptyText: '<%=Select_Permit_Type%>',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    Ext.getCmp('organizationcodeCloseid').reset();
                    Ext.getCmp('organizationid1').reset();
                    Ext.getCmp('minecodeId1').reset();
                    Ext.getCmp('leaseNameid1').reset();
                    Ext.getCmp('leaseOwnerid1').reset();
                    Ext.getCmp('TccomboId1').reset();
                    Ext.getCmp('PermitNocomboId').reset();
                    Ext.getCmp('ownertypecomboId').reset();
                    Ext.getCmp('vesselNameClose').reset();
                    PermitNoStore.removeAll(true);
                    PermitNoDetailsStore.removeAll(true);
                    Ext.getCmp('permitdateId').reset(),
			        Ext.getCmp('qtyId').reset();
			        Ext.getCmp('qtydeductionId').reset();
			        Ext.getCmp('closedqtyId').reset();
			        Ext.getCmp('romQuantityid').reset();
			        Ext.getCmp('newsourcecomboId').reset();
                    PermitNoStore.load({
                        params: {
                        }
                    });
                    if (Ext.getCmp('permittypeCloseId').getValue() == 'Rom Sale'){
                   		Ext.getCmp('mandatoryidSource').show();
                        Ext.getCmp('mandatorytcnoSource').show();
                        Ext.getCmp('SourcetypeLabelId1').show();
                        Ext.getCmp('newsourcecomboId').show();
                    }else{
                    	Ext.getCmp('mandatoryidSource').hide();
                        Ext.getCmp('mandatorytcnoSource').hide();
                        Ext.getCmp('SourcetypeLabelId1').hide();
                        Ext.getCmp('newsourcecomboId').hide();
                    }
                    
                    if (Ext.getCmp('permittypeCloseId').getValue() == 'Purchased Rom Sale Transit Permit' || Ext.getCmp('permittypeCloseId').getValue() == 'Processed Ore Transit' 
                        || Ext.getCmp('permittypeCloseId').getValue() == 'Processed Ore Sale' || Ext.getCmp('permittypeCloseId').getValue() == 'Processed Ore Sale Transit' ||
                        Ext.getCmp('permittypeCloseId').getValue() == 'Domestic Export' || Ext.getCmp('permittypeCloseId').getValue() == 'International Export'){
                        
                        Ext.getCmp('mandatoryidorg').show();
                        Ext.getCmp('mandatoryorg1').show();
                        Ext.getCmp('orgcode1LabelId1').show();
                        Ext.getCmp('organizationcodeCloseid').show();
                        Ext.getCmp('mandatoryid5').show();
                        Ext.getCmp('mandatoryorganization1').show();
                        Ext.getCmp('orgnamelabelid').show();
                        Ext.getCmp('organizationid1').show();
                        Ext.getCmp('mandatoryid2').hide();
                        Ext.getCmp('mandatoryminecode1').hide();
                        Ext.getCmp('minecodeLabelId').hide();
                        Ext.getCmp('minecodeId1').hide();
                        Ext.getCmp('mandatoryid3').hide();
                        Ext.getCmp('mandatoryleasename1').hide();
                        Ext.getCmp('leasenameLabelid').hide();
                        Ext.getCmp('leaseNameid1').hide();
                        Ext.getCmp('mandatoryid4').hide();
                        Ext.getCmp('mandatoryleaseowner1').hide();
                        Ext.getCmp('leaseOwnerIdlabel').hide();
                        Ext.getCmp('leaseOwnerid1').hide();
                        Ext.getCmp('mandatoryid01').hide();
                        Ext.getCmp('mandatorytcno1').hide();
                        Ext.getCmp('TcNoLabelId1').hide();
                        Ext.getCmp('TccomboId1').hide();
                    }
					if (Ext.getCmp('permittypeCloseId').getValue() == 'Rom Sale' || Ext.getCmp('permittypeCloseId').getValue() == 'Rom Transit' || Ext.getCmp('permittypeCloseId').getValue() == 'Bauxite Transit') {
                        
                        Ext.getCmp('mandatoryidorg').hide();
                        Ext.getCmp('mandatoryorg1').hide();
                        Ext.getCmp('orgcode1LabelId1').hide();
                        Ext.getCmp('organizationcodeCloseid').hide();
                        Ext.getCmp('mandatoryid5').hide();
                        Ext.getCmp('mandatoryorganization1').hide();
                        Ext.getCmp('orgnamelabelid').hide();
                        Ext.getCmp('organizationid1').hide();
                        Ext.getCmp('mandatoryid2').show();
                        Ext.getCmp('mandatoryminecode1').show();
                        Ext.getCmp('minecodeLabelId').show();
                        Ext.getCmp('minecodeId1').show();
                        Ext.getCmp('mandatoryid3').show();
                        Ext.getCmp('mandatoryleasename1').show();
                        Ext.getCmp('leasenameLabelid').show();
                        Ext.getCmp('leaseNameid1').show();
                        Ext.getCmp('mandatoryid4').show();
                        Ext.getCmp('mandatoryleaseowner1').show();
                        Ext.getCmp('leaseOwnerIdlabel').show();
                        Ext.getCmp('leaseOwnerid1').show();
                        Ext.getCmp('mandatoryid01').show();
                        Ext.getCmp('mandatorytcno1').show();
                        Ext.getCmp('TcNoLabelId1').show();
                        Ext.getCmp('TccomboId1').show();
					}
					if (Ext.getCmp('permittypeCloseId').getValue() == 'International Export'){
						vesselNameStore.load({
				            params: {
				                custId: Ext.getCmp('custcomboId').getValue()
				            }
				        });
				        Ext.getCmp('mandatoryid100').show();
                        Ext.getCmp('mandatoryvesselClose').show();
                        Ext.getCmp('vesselnameLabelId1').show();
                        Ext.getCmp('vesselNameClose').show();
					}else{
						Ext.getCmp('mandatoryid100').hide();
                        Ext.getCmp('mandatoryvesselClose').hide();
                        Ext.getCmp('vesselnameLabelId1').hide();
                        Ext.getCmp('vesselNameClose').hide();
					}
                }
            }
        }
    });
    //*******************************store for TC NO**********************************
    var TcNoComboStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getTcNumber',
        root: 'TcNumberRoot',
        autoLoad: false,
        id: 'tcnumberid',
        fields: ['MiningName', 'TCno', 'TCID', 'MineCode', 'ownerName', 'orgName','orgId','mwalletBal','orgCode','aliasName','ctoDate']
    });
    //****************************combo for TCNo****************************************
    var TcNoCombo = new Ext.form.ComboBox({
        store: TcNoComboStore,
        id: 'TccomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_TC_Number%>',
        blankText: '<%=Select_TC_Number%>',
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        resizable: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'TCID',
        displayField: 'TCno',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {

                    var id = Ext.getCmp('TccomboId').getValue();
                    var row = TcNoComboStore.findExact('TCID', id);
                    var rec = TcNoComboStore.getAt(row);
                    leaseowner = rec.data['ownerName'];
                    mineCode = rec.data['MineCode'];
                    leaseName = rec.data['MiningName'];
                    orgname = rec.data['orgName'];
                    TcorgId = rec.data['orgId'];
                    mWalletB = rec.data['mwalletBal'];
                    ctoDate = rec.data['ctoDate'];
                    Ext.getCmp('leaseOwnerid').setValue(leaseowner);
                    Ext.getCmp('leaseNameid').setValue(leaseName);
                    Ext.getCmp('minecodeId').setValue(mineCode);
                    Ext.getCmp('organizationid').setValue(rec.data['orgCode']);
                    Ext.getCmp('mwalletId').setValue(mWalletB);
                    Ext.getCmp('applicationid').setValue(rec.data['aliasName']);
                    RefStore.load({
                        params: {
                            CustId: Ext.getCmp('custcomboId').getValue(),
                            tcId: Ext.getCmp('TccomboId').getValue()
                        }
                    });
                    bauxiteChallanStore.load({
                        params: {
                            CustId: Ext.getCmp('custcomboId').getValue(),
                            tcId: Ext.getCmp('TccomboId').getValue()
                        }
                    });
                    RouteIdStore.load({
                        params: {
                            CustId: custId,
                            orgId: TcorgId,
                            permitType :Ext.getCmp('permittypecomboId').getValue(),
                            permit: 0
                        }
                    });
                    buyingOrgComboStore.load({
			            params: {
			                CustID: Ext.getCmp('custcomboId').getValue(),
			                orgCode:TcorgId
			            }
			        });
                    Ext.getCmp('RefcomboId').reset();
                    Ext.getCmp('BuChallancomboId').reset();
                    outerPanelForGrid.hide();
                    Ext.getCmp('routeidcomboId').reset();
                 	var today = new Date();     //Mon Nov 25 2013 14:13:55 GMT+0530 (IST) 
				    var d = new Date(ctoDate);     //Mon Nov 25 2013 00:00:00 GMT+0530 (IST) 
				    var todayDateOnly = new Date(today.getFullYear(),today.getMonth(),today.getDate()); //This will write a Date with time set to 00:00:00 so you kind of have date only
				    var dDateOnly = new Date(d.getFullYear(),d.getMonth(),d.getDate());
<!--				    alert(dDateOnly);-->
<!--					alert(todayDateOnly);-->
<!--				    if(dDateOnly < todayDateOnly){               -->
<!--				        Ext.example.msg("CTO Date Expired");-->
<!--                 	 	Ext.getCmp('TccomboId').reset();-->
<!--                 	 	return;-->
<!--				    }-->
                }
            }
        }
    });
    //****************************combo for TCNo1****************************************
    var TcNoCombo1 = new Ext.form.ComboBox({
        store: TcNoComboStore,
        id: 'TccomboId1',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_TC_Number%>',
        blankText: '<%=Select_TC_Number%>',
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        resizable: true,
        lazyRender: true,
        valueField: 'TCID',
        displayField: 'TCno',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    var id = Ext.getCmp('TccomboId1').getValue();
                    var row = TcNoComboStore.findExact('TCID', id);
                    var rec = TcNoComboStore.getAt(row);
                    leaseowner = rec.data['ownerName'];
                    mineCode = rec.data['MineCode'];
                    leaseName = rec.data['MiningName'];
                    orgname = rec.data['orgName'];

                    Ext.getCmp('leaseOwnerid1').setValue(leaseowner);
                    Ext.getCmp('leaseNameid1').setValue(leaseName);
                    Ext.getCmp('minecodeId1').setValue(mineCode);
                    PermitNoStore.load({
                        params: {
                            CustID: Ext.getCmp('custcomboId').getValue(),
                            tcId: Ext.getCmp('TccomboId1').getValue(),
                            orgCode: 0,
                            permitType: Ext.getCmp('permittypeCloseId').getValue(),
                            vesselName: Ext.getCmp('vesselNameClose').getValue()
                        }
                    });
                    RefStore.load({
                        params: {
                            CustId: Ext.getCmp('custcomboId').getValue(),
                            tcId: Ext.getCmp('TccomboId1').getValue()
                        }
                    });
                    Ext.getCmp('RefcomboId').reset();
                    Ext.getCmp('BuChallancomboId').reset();
                    Ext.getCmp('PermitNocomboId').reset();
                    Ext.getCmp('permitdateId').reset();
                    Ext.getCmp('qtyId').reset();
                    Ext.getCmp('qtydeductionId').reset();
					outerPanelForGrid.hide();
                }
            }
        }
    });
        var EwalletDetailsStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getEwalletDetails',
        root: 'eWalletRoot',
        autoLoad: false,
        id: 'ewelletcomboId',
        fields: ['ewalletQty', 'ewalletAmount']
    });
    //************************************store for Permit No ***************************
    var PermitNoStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getPermitNumber',
        root: 'PermitNumberRoot',
        autoLoad: false,
        id: 'refcomboId',
        fields: ['PermitNo', 'ID',]
    });
    //************************************store for Permit Closure Datails ***************************
    var PermitNoDetailsStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getPermitDetailsForClosure',
        root: 'PermitNumberRoot',
        autoLoad: false,
        id: 'refcomboId',
        fields: ['PermitNo', 'ID', 'PermitDate', 'Qty', 'tripSheetQty','blnceEwalletQty','blnceRomAmt','permitQty','totalPayableRom','tripCount','bargeTripCount','rmCount','srcTypeIndex','mineralType','processingFee']
    });
    //****************************combo for Ref****************************************
    var PermitNoCombo = new Ext.form.ComboBox({
        store: PermitNoStore,
        id: 'PermitNocomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_Permit_No%>',
        blankText: '<%=Select_Permit_No%>',
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        resizable: true,
        valueField: 'ID',
        displayField: 'PermitNo',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                PermitNoDetailsStore.load({
                        params: {
                            CustID: Ext.getCmp('custcomboId').getValue(),
                            tcId: 0,
                            orgCode: Ext.getCmp('organizationcodeCloseid').getValue(),
                            permitType: Ext.getCmp('permittypeCloseId').getValue(),
                            vesselName: Ext.getCmp('vesselNameClose').getValue(),
                            selectedPermitId: Ext.getCmp('PermitNocomboId').getValue()
                        },
               callback: function(){
                    var id = Ext.getCmp('PermitNocomboId').getValue();
                    var row = PermitNoDetailsStore.findExact('ID', id);
                    var rec = PermitNoDetailsStore.getAt(row);
                    permitdate = rec.data['PermitDate'];
                    qty = rec.data['Qty'];
                    romQty = rec.data['blnceEwalletQty'];
                    romAmt = rec.data['blnceRomAmt'];
                    tripSheetQty=rec.data['tripSheetQty'];
                    permitQty=rec.data['permitQty'];
                    totalPayableRom=rec.data['totalPayableRom'];
                    tripCount=rec.data['tripCount'];
                    bargeTripCount=rec.data['bargeTripCount'];
                    rmCount = rec.data['rmCount'];
                    srcTypeClose=rec.data['srcTypeIndex'];
                    mineralType = rec.data['mineralType'];
                    processingFee=rec.data['processingFee'];
                    if(Ext.getCmp('permittypeCloseId').getValue()=='Rom Sale'){
                    	tripSheetQty=0;
                    }
                    if(parseFloat(tripSheetQty)>0){
                    	covertedTripSheetQty=parseFloat(tripSheetQty)/1000;
	                     Ext.getCmp('refundLabelId1').hide();
	                     Ext.getCmp('mandatoryrefund').hide();
	                     Ext.getCmp('mandatoryid1111').hide();
	                     Ext.getCmp('refundId').hide();
                    }else{
                     	covertedTripSheetQty=0;
	                     Ext.getCmp('refundLabelId1').show();
	                     Ext.getCmp('mandatoryrefund').show();
	                     Ext.getCmp('mandatoryid1111').show();
	                     Ext.getCmp('refundId').show();
                    }
                    Ext.getCmp('permitdateId').setValue(permitdate);
                    Ext.getCmp('qtydeductionId').setValue(covertedTripSheetQty);
                    Ext.getCmp('qtyId').setValue(qty);
                    Ext.getCmp('romQuantityid').setValue(romQty);
                    Ext.getCmp('closedqtyId').setValue(covertedTripSheetQty);
                    EwalletDetailsStore.load({
                    params: {
                            CustID: Ext.getCmp('custcomboId').getValue(),
                            permitId: Ext.getCmp('PermitNocomboId').getValue()
                        },
                        callback: function() {
                                for (var i = 0; i < EwalletDetailsStore.getCount(); i++) {
                                    var rec = EwalletDetailsStore.getAt(i);
                                    eWalletAmt =  rec.data['ewalletAmount'];
    								eWalletQty =  rec.data['ewalletQty'];
                                }
                            }
                    });
                    if(parseFloat(tripCount)>0 || parseFloat(bargeTripCount)>0 ){
                       Ext.example.msg(" Please close all tripsheets of this permit before permit closure ");
                       Ext.getCmp('PermitNocomboId').reset();
                       return;
                    }
                    if( parseFloat(rmCount)>0){
                       Ext.example.msg(" Please Approve all the rom challans for the permit before permit closure ");
                       Ext.getCmp('PermitNocomboId').reset();
                       return;
                    }
                   } });//callback  
                }
            }
        }
    });
        //************************************store for Imported Permit No ***************************
    var importedPermitStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getImportedPermitNo',
        root: 'importedPermitNoRoot',
        autoLoad: false,
        id: 'importedPermitcomboId',
        fields: ['PermitNo', 'ID','processingFeeImport']
    });
    //****************************combo for Imported****************************************
    var ImportedPermitCombo = new Ext.form.ComboBox({
        store: importedPermitStore,
        id: 'importedPermitId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Imported Permit No',
        blankText: 'Select Imported Permit No',
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        resizable: true,
        valueField: 'ID',
        displayField: 'PermitNo',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                   Store2.load({
				                params: {
				                    CustID: Ext.getCmp('custcomboId').getValue(),
				                    id: Ext.getCmp('importedPermitId').getValue()
				                }
				            });
                }
            }
        }
    });
    //******************************store for Mineral**********************************
    var mineralStore = new Ext.data.SimpleStore({
        id: 'mineralsComboStoreId',
        fields: ['Name', 'Value'],
        autoLoad: false,
        data: [
            ['Iron Ore', 'Iron Ore'],
            ['Bauxite/Laterite', 'Bauxite/Laterite'],
            ['Manganese', 'Manganese'],
            ['Iron Ore(E-Auction)', 'Iron Ore(E-Auction)']
        ]
    });
    //****************************combo for Mineral****************************************
    var mineralCombo = new Ext.form.ComboBox({
        store: mineralStore,
        id: 'mineralcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectMineral%>',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                	Ext.getCmp('routeidcomboId').reset();
                	Ext.getCmp('hubId').reset();
                	hubStore.load({
	                   params: {
	                           CustID: custId,
	                           permitType:Ext.getCmp('permittypecomboId').getValue(),
	                           orgId : Ext.getCmp('organizationcodeid').getValue(),
	                           mineral:Ext.getCmp('mineralcomboId').getValue()
	                       }
		            });
		            Store2.load({
                       params: {
                           CustID: Ext.getCmp('custcomboId').getValue(),
                           id: 0,
                           permitType:Ext.getCmp('permittypecomboId').getValue(),
                           mineralType: Ext.getCmp('mineralcomboId').getValue()
                       }
                   });
                   
                   rsPermitStore.load({
				           params: {
				               custId: Ext.getCmp('custcomboId').getValue(),
				               orgId: Ext.getCmp('organizationcodeid').getValue(),
				               mineralType: Ext.getCmp('mineralcomboId').getValue()
				           }
				       });
                }
            }
        }
    });
    //*******************************store for Route ID**********************************
    var RouteIdStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getRouteList',
        id: 'routeidcomboId11',
        root: 'routeComboStoreRoot',
        autoload: false,
        remoteSort: true,
        fields: ['routeId', 'routeName', 'fromlocation', 'tolocation','status']
    });
    //****************************combo for RouteId****************************************
    var RouteIdCombo = new Ext.form.ComboBox({
        store: RouteIdStore,
        id: 'routeidcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_Route_ID%>',
        blankText: '<%=Select_Route_ID%>',
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'routeId',
        displayField: 'routeName',
        resizable: true,
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    var routeName = Ext.getCmp('routeidcomboId').getValue();
                    var row = RouteIdStore.findExact('routeId', routeName);
                    var rec = RouteIdStore.getAt(row);
                    fromloc = rec.data['fromlocation'];
                    toloc = rec.data['tolocation'];
                    routeStatus= rec.data['status'];
                    Ext.getCmp('fromlocId').setValue(fromloc);
                    Ext.getCmp('tolocId').setValue(toloc);
                    var stockOrg=0;
                    if(Ext.getCmp('permittypecomboId').getValue() == 'Purchased Rom Sale Transit Permit' && Ext.getCmp('toLocationId').getValue() == 'Plant'){
                   	   if(routeStatus=='FALSE'){
                   	   	   Ext.example.msg("Dest hub is not associated to any plant");
                           Ext.getCmp('routeidcomboId').reset();
                           return;
                   	   }
                    }
                    StockTypeStore1.load({
                        params: {
                            orgCode: Ext.getCmp('organizationcodeid').getValue(),
                            CustID: Ext.getCmp('custcomboId').getValue(),
                            routeId:Ext.getCmp('routeidcomboId').getValue(),
                            mineralType: Ext.getCmp('mineralcomboId').getValue(),
                            permitType:Ext.getCmp('permittypecomboId').getValue()
                        }
                   });
                   exportStore.load({
                        params: {
                            orgCode: Ext.getCmp('organizationcodeid').getValue(),
                            CustID: Ext.getCmp('custcomboId').getValue(),
                            routeId:Ext.getCmp('routeidcomboId').getValue(),
                            mineralType: Ext.getCmp('mineralcomboId').getValue(),
                            permitType:Ext.getCmp('permittypecomboId').getValue()
                        }
                   });
                   if(Ext.getCmp('permittypecomboId').getValue() == 'Purchased Rom Sale Transit Permit' && srcTypeR=='ROM'){
                   gridPanel.show();
		           proccessedOreGrid.show();
		           outerPanelForGrid.hide();
		           gridForExportDetails.hide();
		           outerPanelForBauxiteGrid.hide();
                    //setTimeout(function() {
			            Store2.load({
			                params: {
			                    CustID: Ext.getCmp('custcomboId').getValue(),
			                    permitType:Ext.getCmp('permittypecomboId').getValue(),
			                    mineralType: Ext.getCmp('mineralcomboId').getValue(),
			                    id: permitID
			                }
			            });
			       // }, 500);
			        }
			       else if(Ext.getCmp('permittypecomboId').getValue() == 'Purchased Rom Sale Transit Permit' && srcTypeR=='E-Wallet'){
			       		outerPanelForGrid.show();
			       		gridPanel.hide();
			       		proccessedOreGrid.hide();
			        }
                   else if(Ext.getCmp('permittypecomboId').getValue() != 'Import Transit Permit'){
                   Store2.load({
                       params: {
                           CustID: Ext.getCmp('custcomboId').getValue(),
                           id: 0,
                           permitType:Ext.getCmp('permittypecomboId').getValue(),
                           mineralType: Ext.getCmp('mineralcomboId').getValue()
                       }
                   });
                   }
                }
            }
        }
    });
    //*******************************store for ref**********************************
    var RefStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getRefNumber',
        root: 'RefNumberRoot',
        autoLoad: false,
        id: 'refcomboId',
        fields: ['ChallanNo', 'ChallanID']
    });
    //****************************combo for Ref****************************************
    var RefCombo = new Ext.form.ComboBox({
        store: RefStore,
        id: 'RefcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_Ref_Number%>',
        blankText: '<%=Select_Ref_Number%>',
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'ChallanID',
        displayField: 'ChallanNo',
        cls: 'selectstylePerfect',
        resizable: true,
        listeners: {
            select: {
                fn: function() {
                	totalAmtt=0;
                    outerPanelForGrid.show();
                    editedRows = "";
                    gradeStore.load({
                        params: {
                            CustID: custId,
                            challanid: Ext.getCmp('RefcomboId').getValue(),
                            permitId: 0,
                            permitType: Ext.getCmp('permittypecomboId').getValue(),
                            buttinValue: 'add'
                        },
                        callback: function(){
                           var rec = gradeStore.getAt(6);
                           totalAmtt = rec.data['payableIdIndex'];
                        }
                    });
                }
            }
        }
    });
    //*******************************store for bauxiteChallan**********************************
    var bauxiteChallanStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getBauxiteChallan',
        root: 'bauxiteChallanRoot',
        autoLoad: false,
        id: 'bucomboId',
        fields: ['BauxiteChallanNo', 'BuChallanID']
    });
    //****************************combo for bauxiteChallan****************************************
    var bauxiteCombo = new Ext.form.ComboBox({
        store: bauxiteChallanStore,
        id: 'BuChallancomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Bauxite Challan',
        blankText: 'Select Bauxite Challan',
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'BuChallanID',
        displayField: 'BauxiteChallanNo',
        resizable: true,
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    outerPanelForBauxiteGrid.show();
                    outerPanelForGrid.hide();
                    storeForBauxite.load({
                        params: {
                            CustID: Ext.getCmp('custcomboId').getValue(),
                            challanid: Ext.getCmp('BuChallancomboId').getValue()
                        }
                    });
                }
            }
        }
    });
    //*******************************store for organization code**********************************
    var organizationCodeStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getorganizationCode',
        root: 'organizationCodeRoot',
        autoLoad: false,
        id: 'organizationCodeStoreId',
        fields: ['id', 'organizationCode', 'organizationName', 'type', 'totalFines', 'totalLumps', 'totalTailing', 'totalRejects','mWalletBalance','aliasName']
    });
    //****************************combo for Ref****************************************
    var organizationCodeCombo = new Ext.form.ComboBox({
        store: organizationCodeStore,
        id: 'organizationcodeid',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_OrganisationTrader_Code%>',
        blankText: '<%=Select_OrganisationTrader_Code%>',
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'id',
        resizable: true,
        displayField: 'organizationName',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                	RouteIdStore.removeAll(true);
                    var row = organizationCodeStore.findExact('id', Ext.getCmp('organizationcodeid').getValue());
                    var rec = organizationCodeStore.getAt(row);
                    var organisationName = rec.data['organizationCode'];
                    var type = rec.data['type'];
                    var totFines = rec.data['totalFines'];
                    var totLumps = rec.data['totalLumps'];
                    var totTailings = rec.data['totalTailing'];
                    var totRegects = rec.data['totalRejects'];
                    var mWalletBalance = rec.data['mWalletBalance'];
                    Ext.getCmp('organizationid').setValue(organisationName);
                    Ext.getCmp('applicationid').setValue(rec.data['aliasName']);
                    Ext.getCmp('importedPermitId').setValue('');
                    Ext.getCmp('routeidcomboId').reset();
                    Ext.getCmp('romPermitId').reset();
                    Ext.getCmp('hubId').setValue('');
                    Ext.getCmp('buyingOrgComboId').reset();
                    
                    Store2.load({
			            params: {
			                CustID: Ext.getCmp('custcomboId').getValue(),
			                id: 0,
			                permitType:Ext.getCmp('permittypecomboId').getValue(),
			                mineralType: Ext.getCmp('mineralcomboId').getValue()
			            }
			        });
			        RouteIdStore.load({
                        params: {
                            CustId: custId,
                            orgId: Ext.getCmp('organizationcodeid').getValue(),
                            permitType :Ext.getCmp('permittypecomboId').getValue(),
                            permit: 0
                        }
                    });
                    buyingOrgComboStore.load({
                    params: {
                            orgCode: Ext.getCmp('organizationcodeid').getValue(),
                            CustID: Ext.getCmp('custcomboId').getValue()
                        }
                    });
                    importedPermitStore.load({
			            params: {
			                CustID: Ext.getCmp('custcomboId').getValue(),
			                orgCode: Ext.getCmp('organizationcodeid').getValue()
			            }
			        });
			        			        rsPermitStore.load({
				           params: {
				               custId: Ext.getCmp('custcomboId').getValue(),
				               orgId: Ext.getCmp('organizationcodeid').getValue(),
				               mineralType: Ext.getCmp('mineralcomboId').getValue()
				           }
				       });
			        
                    Ext.getCmp('mandatoryHead0m').show();
                    Ext.getCmp('mandatoryMwallet').show();
                    Ext.getCmp('mwalletLabelId').show();
                    Ext.getCmp('mwalletId').show();
                    
                    Ext.getCmp('mwalletId').setValue(mWalletBalance);
                    
                    if(type=="ORGANIZATION"){
                    	Ext.getCmp('ownertypecomboId').setValue(ownertypeStore.getAt(1).data['Value']);
                    }else if(type=="TRADER"){
                    	Ext.getCmp('ownertypecomboId').setValue(ownertypeStore.getAt(2).data['Value']);
                    }
                    if(Ext.getCmp('permittypecomboId').getValue()!='Processed Ore Sale'){
                    	Ext.getCmp('mineralcomboId').setValue(mineralStore.getAt(0).data['Value']);
                    }
                    if(Ext.getCmp('permittypecomboId').getValue()=='Processed Ore Sale'){
                    	Ext.getCmp('mineralcomboId').setValue('');
                    }
                }
            }
        }
    });
    //****************************combo for orgcode closure****************************************
    var organizationCodeComboForClose = new Ext.form.ComboBox({
        store: organizationCodeStore,
        id: 'organizationcodeCloseid',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_OrganisationTrader_Code%>',
        blankText: '<%=Select_OrganisationTrader_Code%>',
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        resizable: true,
        lazyRender: true,
        valueField: 'id',
        displayField: 'organizationName',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                	Ext.getCmp('PermitNocomboId').reset();
                	Ext.getCmp('permitdateId').reset();
                	Ext.getCmp('qtyId').reset();
                	Ext.getCmp('qtydeductionId').reset();
                	Ext.getCmp('romQuantityid').reset();
                	Ext.getCmp('closedqtyId').reset();
                    var row = organizationCodeStore.findExact('id', Ext.getCmp('organizationcodeCloseid').getValue());
                    var rec = organizationCodeStore.getAt(row);
                    var organisationNameForClose = rec.data['organizationCode'];
                    Ext.getCmp('organizationid1').setValue(organisationNameForClose);
                    PermitNoStore.load({
                        params: {
                            CustID: Ext.getCmp('custcomboId').getValue(),
                            tcId: 0,
                            orgCode: Ext.getCmp('organizationcodeCloseid').getValue(),
                            permitType: Ext.getCmp('permittypeCloseId').getValue(),
                            vesselName: Ext.getCmp('vesselNameClose').getValue()
                        }
                    });
                }
            }
        }
    });
    //*******************************store for country**********************************
    var countryComboStore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getCountry',
	    id: 'countryStoreId',
	    root: 'countryRoot',
	    autoLoad: false,
	    remoteSort: true,
	    fields: ['CountryID', 'CountryName'],
	    listeners: {
		    }
	});
	//****************************combo for country****************************************
    var countryCombo = new Ext.form.ComboBox({
	    store: countryComboStore,
	    id: 'countryComboId',
	    mode: 'local',
	    forceSelection: true,
	    emptyText: '<%=Select_Country%>',
	    blankText: '<%=Select_Country%>',
	    selectOnFocus: true,
	    allowBlank: false,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    lazyRender: true,
	    valueField: 'CountryID',
	    displayField: 'CountryName',
	    resizable: true,
	    width:200,
	    cls: 'selectstylePerfect',
	    listeners: {
	        select: {
	            fn: function () {
	            countryid = Ext.getCmp('countryComboId').getValue();
	            if (Ext.getCmp('permittypecomboId').getValue() == 'Purchased Rom Sale Transit Permit' || Ext.getCmp('permittypecomboId').getValue() == 'Processed Ore Sale' || Ext.getCmp('permittypecomboId').getValue() == 'Rom Sale' || Ext.getCmp('permittypecomboId').getValue() == 'Processed Ore Sale Transit'){
                    Ext.getCmp('stateComboId1').reset();
                    stateComboStore1.load({
                        params: {
                            countryid: countryid
                        }
                    });
	             }
	             else {
	               stateComboStore.load();
	             }           
	            }
	        }
	    }
	});
	 //*******************************store for state**********************************
    var stateComboStore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getStates',
	    id: 'stateStoreId',
	    root: 'stateRoot',
	    autoLoad: false,
	    remoteSort: true,
	    fields: ['StateID', 'StateName'],
	    listeners: {
		    }
	});
	//****************************combo for state****************************************
    var stateCombo = new Ext.form.ComboBox({
	    store: stateComboStore,
	    id: 'stateComboId',
	    mode: 'local',
	    forceSelection: true,
	    emptyText: '<%=Select_State%>',
	    blankText: '<%=Select_State%>',
	    selectOnFocus: true,
	    allowBlank: false,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    lazyRender: true,
	    valueField: 'StateID',
	    displayField: 'StateName',
	    resizable: true,
	    width:200,
	    cls: 'selectstylePerfect',
	    listeners: {
	        select: {
	            fn: function () {
	            			                 
	            }
	        }
	    }
	});
	//************************store for statebased on country******************************//
	  var stateComboStore1 = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getStatesnew',
	    id: 'stateStoreId1',
	    root: 'stateRoot1',
	    autoLoad: false,
	    remoteSort: true,
	    fields: ['StateID', 'StateName'],
	    listeners: {
		    }
	});
	    var stateCombonew = new Ext.form.ComboBox({
	    store: stateComboStore1,
	    id: 'stateComboId1',
	    mode: 'local',
	    forceSelection: true,
	    emptyText: '<%=Select_State%>',
	    blankText: '<%=Select_State%>',
	    selectOnFocus: true,
	    allowBlank: false,
	    anyMatch: true,
	    resizable: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    lazyRender: true,
	    valueField: 'StateID',
	    displayField: 'StateName',
	    width:200,
	    cls: 'selectstylePerfect',
	    listeners: {
	        select: {
	            fn: function () {            
	            }
	        }
	    }
	});
		 //*******************************store for Buying org name**********************************
    var buyingOrgComboStore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getBuyingOrgName',
	    id: 'buyingOrgStoreId',
	    root: 'buyingOrgRoot',
	    autoLoad: false,
	    remoteSort: true,
	    fields: ['ID','BuyingOrgName','BuyingOrgCode'],
	    listeners: {
		    }
	});
	//****************************combo for state****************************************
    var buyingOrgCombo = new Ext.form.ComboBox({
	    store: buyingOrgComboStore,
	    id: 'buyingOrgComboId',
	    mode: 'local',
	    forceSelection: true,
	    emptyText: '<%=Select_Buying_OrgTrader_Name%>',
	    blankText: '<%=Select_Buying_OrgTrader_Name%>',
	    selectOnFocus: true,
	    allowBlank: false,
	    resizable: true,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    lazyRender: true,
	    valueField: 'ID',
	    displayField: 'BuyingOrgName',
	    width:200,
	    cls: 'selectstylePerfect',
	    listeners: {
	        select: {
	            fn: function () {
	            	var row = buyingOrgComboStore.findExact('ID', Ext.getCmp('buyingOrgComboId').getValue());
                    var rec = buyingOrgComboStore.getAt(row);
                    var BuyingorgCode = rec.data['BuyingOrgCode'];

                    Ext.getCmp('buyingOrgCodeid').setValue(BuyingorgCode);                 
	            }
	        }
	    }
	});
	//************************************store for Imported Permit No ***************************
    var vesselNameStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getVesselNames',
        root: 'vesselNameRoot',
        autoLoad: false,
        id: 'vesselNameIddd',
        fields: ['vesselName','buyerName']
    });
    //****************************combo for Imported****************************************
    var vesselNameCombo = new Ext.form.ComboBox({
        store: vesselNameStore,
        id: 'shipId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_Vessel_Name%>',
        blankText: '<%=Select_Vessel_Name%>',
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        resizable: true,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'vesselName',
        displayField: 'vesselName',
        cls: 'selectstylePerfect',
        listeners: {
        change: function(f,n,o){ //restrict 50
			 if(f.getValue().length> 50){ Ext.example.msg("Field reached it's Maximum Size"); 
				f.setValue(n.substr(0,50)); f.focus(); 
				}
		    },select: {
	            fn: function () {
	            	var row = vesselNameStore.findExact('vesselName', Ext.getCmp('shipId').getValue());
                    var rec = vesselNameStore.getAt(row);
                    var Buyer = rec.data['buyerName'];
                    Ext.getCmp('buyerId').setValue(Buyer);   
                    }              
	            }
		}
    });
    //****************************combo for vessel****************************************
    var vesselNameComboForApp = new Ext.form.ComboBox({
        store: vesselNameStore,
        id: 'vesselNameModify',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_Vessel_Name%>',
        blankText: '<%=Select_Vessel_Name%>',
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        resizable: true,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'vesselName',
        displayField: 'vesselName',
        cls: 'selectstylePerfect',
        listeners: { change: function(f,n,o){ //restrict 50
			 if(f.getValue().length> 50){ Ext.example.msg("Field reached it's Maximum Size"); 
				f.setValue(n.substr(0,50)); f.focus(); }
		} },
    });
    
     var vesselNameComboForCLOSE = new Ext.form.ComboBox({
        store: vesselNameStore,
        id: 'vesselNameClose',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_Vessel_Name%>',
        blankText: '<%=Select_Vessel_Name%>',
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        resizable: true,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'vesselName',
        displayField: 'vesselName',
        cls: 'selectstylePerfect',
        listeners: { 
          select: {
                fn: function() {
                	Ext.getCmp('permitdateId').reset(),
			        Ext.getCmp('qtyId').reset(),
			        Ext.getCmp('qtydeductionId').reset(),
			        Ext.getCmp('closedqtyId').reset(),
			        Ext.getCmp('romQuantityid').reset(),
			        Ext.getCmp('PermitNocomboId').reset(),
                	PermitNoStore.load({
			              params: {
			                  CustID: Ext.getCmp('custcomboId').getValue(),
			                  tcId: 0,
			                  orgCode: Ext.getCmp('organizationcodeCloseid').getValue(),
			                  permitType: Ext.getCmp('permittypeCloseId').getValue(),
			                  vesselName: Ext.getCmp('vesselNameClose').getValue()
			              }
			          });
                }
            },
         change: function(f,n,o){ //restrict 50
			 if(f.getValue().length> 50){ Ext.example.msg("Field reached it's Maximum Size"); 
				f.setValue(n.substr(0,50)); f.focus(); }
		} },
    });
    
    
    	//************************************store for RS Permit No ***************************
    var rsPermitStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getRSPermitNo',
        root: 'rsPermitRoot',
        autoLoad: false,
        id: 'rsPermitId',
        fields: ['rsPermitId','rsPermitNo','challanId','totProcessingFee','srcType']
    });
    //****************************combo for RS permit no****************************************
    var romSaleCombo = new Ext.form.ComboBox({
        store: rsPermitStore,
        id: 'romPermitId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select RS Permit',
        blankText: 'Select RS Permit',
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        resizable: true,
        valueField: 'rsPermitId',
        displayField: 'rsPermitNo',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                Ext.getCmp('routeidcomboId').reset();
                 RouteIdStore.load({
                        params: {
                            CustId: custId,
                            orgId: Ext.getCmp('organizationcodeid').getValue(),
                            permitType :Ext.getCmp('permittypecomboId').getValue(),
                            permit: Ext.getCmp('romPermitId').getValue()
                        }
                    });
                 var row = rsPermitStore.findExact('rsPermitId',  Ext.getCmp('romPermitId').getValue());
                 var rec = rsPermitStore.getAt(row);
                 challanID=rec.data['challanId'];
                 permitID=rec.data['rsPermitId'];
                 srcTypeR=rec.data['srcType'];
                 if(srcTypeR=='ROM'){
                 
                 }else{
                 outerPanelForGrid.show();
                 editedRows = "";
                 	gradeStore.load({
                        params: {
                            CustID: custId,
                            challanid: challanID,
                            permitId: permitID,
                            permitType: Ext.getCmp('permittypecomboId').getValue(),
                            buttinValue: 'add'
                        },
                        callback: function(){
                           var rec = gradeStore.getAt(6);
                           totalAmtt = rec.data['payableIdIndex'];
                        }
                    });
                 }
               }
            }
        }
    });
    
        //******************************store for Mineral**********************************
    var toLocStore = new Ext.data.SimpleStore({
        id: 'toLocationStoreId',
        fields: ['Name', 'Value'],
        autoLoad: false,
        data: [
            ['Plant', 'Plant'],
            ['Stock', 'Stock']
        ]
    });
    //****************************combo for Mineral****************************************
    var toLocationCombo = new Ext.form.ComboBox({
        store: toLocStore,
        id: 'toLocationId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select To location',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                	Ext.getCmp('routeidcomboId').reset();
                }
            }
        }
    });
            //******************************store for Mineral**********************************
    var destTypeStore = new Ext.data.SimpleStore({
        id: 'destTypeStoreId',
        fields: ['Name', 'Value'],
        autoLoad: false,
        data: [
            ['E-Wallet', 'E-Wallet'],
            ['ROM', 'ROM']
        ]
    });

    //****************************combo for Mineral****************************************
    var destTypeCombo = new Ext.form.ComboBox({
        store: destTypeStore,
        id: 'desttypeId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Source Type',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        cls: 'selectstylePerfect',
        resizable: true,
        listeners: {
            select: {
                fn: function() {
                	Ext.getCmp('organizationcodeid').reset();
                	if(Ext.getCmp('desttypeId').getValue()=='E-Wallet'){
                		Ext.getCmp('mandatoryHead15').show();Ext.getCmp('mandatoryref').show();Ext.getCmp('refId').show();Ext.getCmp('RefcomboId').show();
                        Ext.getCmp('mandatoryHead6').show();Ext.getCmp('mandatorytcno').show();Ext.getCmp('TcNoLabelId').show();Ext.getCmp('TccomboId').show();
                        Ext.getCmp('mandatoryHead7').show();Ext.getCmp('mandatoryminecode').show();Ext.getCmp('mineCodeLabel').show();Ext.getCmp('minecodeId').show();
                        Ext.getCmp('mandatoryHead8').show();Ext.getCmp('mandatoryleasename').show();Ext.getCmp('leaseNameLabel').show();Ext.getCmp('leaseNameid').show();
                        Ext.getCmp('mandatoryHead9').show();Ext.getCmp('mandatoryleaseowner').show();Ext.getCmp('leaseOwnerLabel').show();Ext.getCmp('leaseOwnerid').show();
                        Ext.getCmp('mandatoryHead19').hide();Ext.getCmp('mandatoryorganizationCode').hide();Ext.getCmp('organizationCodeLabel').hide();Ext.getCmp('organizationcodeid').hide();
                        
                        Ext.getCmp('tcN0LabId').show();Ext.getCmp('tcN0TxtId').show();Ext.getCmp('hos7').show();
						Ext.getCmp('mineCodLabId').show();Ext.getCmp('MineCodTxtId').show();Ext.getCmp('hos8').show();
						Ext.getCmp('leaseNamLabId').show();Ext.getCmp('leaseNamTxtId').show();Ext.getCmp('hos9').show();
						Ext.getCmp('leaseOwnLabId').show();Ext.getCmp('leaseOwnTxtId').show();Ext.getCmp('hos10').show();
						Ext.getCmp('orgCodLabId').hide();Ext.getCmp('orgCodTxtId').hide();Ext.getCmp('hos11').hide();
						Ext.getCmp('refLabId').show();Ext.getCmp('refTxtId').show();Ext.getCmp('hos33').show();
						
						Ext.getCmp('exactGradeLabId').hide();Ext.getCmp('exactGradeTxtId').hide();Ext.getCmp('hos43').hide();
						Ext.getCmp('gradeTypeLabId').hide();Ext.getCmp('gardeTypeTxtId').hide();Ext.getCmp('hos44').hide();
						Ext.getCmp('stockLocLabId').hide();Ext.getCmp('stockLocTxtId').hide();Ext.getCmp('hos45').hide();
						Ext.getCmp('quantityLabId').show();Ext.getCmp('QuantityTxtId').show();Ext.getCmp('hos46').show();
						Ext.getCmp('processFeeLabId').show();Ext.getCmp('processFeeTxtId').show();Ext.getCmp('hos47').show();
						Ext.getCmp('totalProcessFeeLabId').show();Ext.getCmp('totalProcessFeeTxtId').show();Ext.getCmp('hos48').show();
						
                        gridPanel.hide();
                        proccessedOreGrid.hide();
                        outerPanelForGrid.hide();
                        gridForExportDetails.hide();
                       
                	}else{
                		Ext.getCmp('mandatoryHead15').hide();
                        Ext.getCmp('mandatoryref').hide();
                        Ext.getCmp('refId').hide();
                        Ext.getCmp('RefcomboId').hide();
                        
                        Ext.getCmp('mandatoryHead6').hide();Ext.getCmp('mandatorytcno').hide(); Ext.getCmp('TcNoLabelId').hide();Ext.getCmp('TccomboId').hide();
                        Ext.getCmp('mandatoryHead7').hide();Ext.getCmp('mandatoryminecode').hide();Ext.getCmp('mineCodeLabel').hide();Ext.getCmp('minecodeId').hide();
                        Ext.getCmp('mandatoryHead8').hide();Ext.getCmp('mandatoryleasename').hide();Ext.getCmp('leaseNameLabel').hide();Ext.getCmp('leaseNameid').hide();
                        Ext.getCmp('mandatoryHead9').hide();Ext.getCmp('mandatoryleaseowner').hide();Ext.getCmp('leaseOwnerLabel').hide();Ext.getCmp('leaseOwnerid').hide();
                        Ext.getCmp('mandatoryHead15').hide();Ext.getCmp('mandatoryref').hide();Ext.getCmp('refId').hide();Ext.getCmp('RefcomboId').hide();
                        Ext.getCmp('mandatoryHead19').show(); Ext.getCmp('mandatoryorganizationCode').show();Ext.getCmp('organizationCodeLabel').show();Ext.getCmp('organizationcodeid').show();
                        
                        Ext.getCmp('tcN0LabId').hide();Ext.getCmp('tcN0TxtId').hide();Ext.getCmp('hos7').hide();
						Ext.getCmp('mineCodLabId').hide();Ext.getCmp('MineCodTxtId').hide();Ext.getCmp('hos8').hide();
						Ext.getCmp('leaseNamLabId').hide();Ext.getCmp('leaseNamTxtId').hide();Ext.getCmp('hos9').hide();
						Ext.getCmp('leaseOwnLabId').hide();Ext.getCmp('leaseOwnTxtId').hide();Ext.getCmp('hos10').hide();
						Ext.getCmp('orgCodLabId').show();Ext.getCmp('orgCodTxtId').show();Ext.getCmp('hos11').show();
						Ext.getCmp('refLabId').hide();Ext.getCmp('refTxtId').hide();Ext.getCmp('hos33').hide();
						
						Ext.getCmp('exactGradeLabId').show();Ext.getCmp('exactGradeTxtId').show();Ext.getCmp('hos43').show();
						Ext.getCmp('gradeTypeLabId').show();Ext.getCmp('gardeTypeTxtId').show();Ext.getCmp('hos44').show();
						Ext.getCmp('stockLocLabId').show();Ext.getCmp('stockLocTxtId').show();Ext.getCmp('hos45').show();
						Ext.getCmp('quantityLabId').show();Ext.getCmp('QuantityTxtId').show();Ext.getCmp('hos46').show();
						Ext.getCmp('processFeeLabId').show();Ext.getCmp('processFeeTxtId').show();Ext.getCmp('hos47').show();
						Ext.getCmp('totalProcessFeeLabId').show();Ext.getCmp('totalProcessFeeTxtId').show();Ext.getCmp('hos48').show();
						
                        gridPanel.show();
                        proccessedOreGrid.show();
                        outerPanelForGrid.hide();
                        gridForExportDetails.show();
                        proccessedOreGrid.getColumnModel().setHidden(proccessedOreGrid.getColumnModel().findColumnIndex('stockTypeIdIndex'), false);
                	}
                }
            }
        }
    });
    var innerPanelForPermitDetails = new Ext.form.FormPanel({
        standardSubmit: true,
        collapsible: false,
        frame: false,
        id: 'innerPanelForPermitDetailsId',
        items: [{
            xtype: 'fieldset',
            width: 500,
            height: 400,
            title: '<%=Permit_Details%>',
            id: 'PermitInfoId',
            autoScroll: true,
            collapsible: false,
            layout: 'table',
            layoutConfig: {
                columns: 5
            },
            items: [ {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead1'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorydate'
            }, {
                xtype: 'label',
                text: '<%=Date%>' + ' :',
                cls: 'labelstyle'
            }, {
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                id: 'dateid',
                format: getDateFormat(),
                allowBlank: true,
                blankText: '<%=Enter_Date%>',
                submitFormat: getDateFormat(),
                labelSeparator: '',
                value: dtcur
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead2'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryfinyear'
            }, {
                xtype: 'label',
                text: '<%=Financial_Year%>' + ' :',
                cls: 'labelstyle',
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                id: 'finyearId',
                mode: 'local',
                forceSelection: true,
                emptyText: '<%=Enter_Financial_Year%>',
                blankText: '<%=Enter_Financial_Year%>',
                selectOnFocus: true,
                allowBlank: false,
                listeners: {}
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead3'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorypermitrequest'
            }, {
                xtype: 'label',
                text: '<%=Permit_Request_Type%>' + ' :',
                cls: 'labelstyle',
                id: 'permitReqid'
            }, permitrequesttypeCombo, {
                width: '20px'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead4'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorypermittype'
            }, {
                xtype: 'label',
                text: '<%=Permit_Type%>' + ' :',
                cls: 'labelstyle',
                id: 'permitTypeId'
            }, permittypeCombo, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'importTypeHeader'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorydesttype'
            }, {
                xtype: 'label',
                text: 'Source Type' + '  :',
                cls: 'labelstyle',
                id: 'destLabelId1'
            }, destTypeCombo, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead1d6'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryImporttype'
            }, {
                xtype: 'label',
                text: 'Import Permit Type' + ' :',
                cls: 'labelstyle',
                id: 'importTypeId'
            }, ImporttypeCombo, {
                width: 10
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'importPurposeHeader'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryImportPurpose'
            }, {
                xtype: 'label',
                text: 'Purpose of Import' + ' :',
                cls: 'labelstyle',
                id: 'importPurId'
            },ImportPurposeCombo , {
                width: 10
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead6'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorytcno'
            }, {
                xtype: 'label',
                text: '<%=Tc_No%>' + '  :',
                cls: 'labelstyle',
                id: 'TcNoLabelId'
            }, TcNoCombo, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead7'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryminecode'
            }, {
                xtype: 'label',
                text: '<%=Mine_Code%>' + ' :',
                cls: 'labelstyle',
                id: 'mineCodeLabel'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                autoCreate: {
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "200",
                    autocomplete: "off"
                },
                id: 'minecodeId',
                readOnly: true,
                mode: 'local',
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead8'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryleasename'
            }, {
                xtype: 'label',
                text: '<%=Lease_Name%>' + ' :',
                cls: 'labelstyle',
                id: 'leaseNameLabel'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                autoCreate: {
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "200",
                    autocomplete: "off"
                },
                id: 'leaseNameid',
                readOnly: true,
                mode: 'local',
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead9'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryleaseowner'
            }, {
                xtype: 'label',
                text: '<%=Lease_Owner%>' + ' :',
                cls: 'labelstyle',
                id: 'leaseOwnerLabel'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                autoCreate: {
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "200",
                    autocomplete: "off"
                },
                id: 'leaseOwnerid',
                readOnly: true,
                mode: 'local',
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead19'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryorganizationCode'
            }, {
                xtype: 'label',
                text: '<%=OrganizationTrader_Name%>' + ' :',
                cls: 'labelstyle',
                id: 'organizationCodeLabel'
            }, organizationCodeCombo, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead10'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryorganization'
            }, {
                xtype: 'label',
                text: '<%=OrganizationTrader_Code%>' + ' :',
                cls: 'labelstyle'
            }, {
                xtype: 'textarea',
                cls: 'textareastyle',
                stripCharsRe: /[,]/,
                height  : 60,
                id: 'organizationid',
                readOnly: true,
                mode: 'local',
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead0m',
                disabled:true
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryMwallet',
                disabled:true
            }, {
                xtype: 'label',
                text: 'M-wallet Balance' + ' :',
                cls: 'labelstyle',
                id:'mwalletLabelId'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                mode: 'local',
                id:'mwalletId',
                forceSelection: true,
                readOnly:true,
                fieldStyle: 'font-weight: bold',
                labelWidth: 170
            }, {
                width: 10
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead0'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryapplno'
            }, {
                xtype: 'label',
                text: '<%=Application_No%>' + ' :',
                cls: 'labelstyle',
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                id: 'applicationid',
                mode: 'local',
                forceSelection: true,
                emptyText: '<%=Enter_Application_No%>',
                blankText: '<%=Enter_Application_No%>',
                selectOnFocus: true,
                allowBlank: false,
                listeners: { change: function(f,n,o){ //restrict 100
				 if(f.getValue().length> 100){ Ext.example.msg("Field reached it's Maximum Size"); 
					f.setValue(n.substr(0,100)); f.focus(); }
				 } },
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead001'
            }, 
            {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryrstoLocId'
            }, {
                xtype: 'label',
                text: 'To Location' + ' :',
                cls: 'labelstyle',
                id: 'toLoclabelId'
            }, toLocationCombo, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead1to'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryoBuyingOrgName'
            }, {
                xtype: 'label',
                text: '<%=Buying_OrganizationTrader_Name%>' + ' :',
                cls: 'labelstyle',
                id: 'BuyingOrgNameLabel'
            }, buyingOrgCombo, {
                width: 10
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead002'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorybuyingOrgCode'
            }, {
                xtype: 'label',
                text: '<%=Buying_OrganizationTrader_Code%>' + ' :',
                cls: 'labelstyle',
                id:'buyingOrgCodeLabel'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                autoCreate: {
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "200",
                    autocomplete: "off"
                },
                id: 'buyingOrgCodeid',
                readOnly: true,
                mode: 'local',
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead11'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryownertype'
            }, {
                xtype: 'label',
                text: '<%=Owner_Type%>' + ' :',
                cls: 'labelstyle',
                id: 'ownertypeId',
            }, ownertypeCombo, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead5'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorymineral'
            }, {
                xtype: 'label',
                text: '<%=Mineral%>' + ' :',
                cls: 'labelstyle',
                id: 'mineralTypeId'
            }, mineralCombo, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'importPermitHeader'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryImportPermit'
            }, {
                xtype: 'label',
                text: 'Imported Permit No' + ' :',
                cls: 'labelstyle',
                id: 'importPermitLabelId'
            }, ImportedPermitCombo, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'importVesselHeader'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryImportVessel'
            }, {
                xtype: 'label',
                text: 'Vessel Name' + ' :',
                cls: 'labelstyle',
                id: 'vesselLabelId'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                listeners: { change: function(f,n,o){ //restrict 50
				 if(f.getValue().length> 50){ Ext.example.msg("Field reached it's Maximum Size"); 
					f.setValue(n.substr(0,50)); f.focus(); }
				 } },
                id: 'vesselNameId',
                mode: 'local',
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'importExpPermitHeader'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryExpPermitNo'
            }, {
                xtype: 'label',
                text: 'Export Permit No' + ' :',
                cls: 'labelstyle',
                id: 'expPermitLabel'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                listeners: { change: function(f,n,o){ //restrict 50
				 if(f.getValue().length> 50){ Ext.example.msg("Field reached it's Maximum Size"); 
					f.setValue(n.substr(0,50)); f.focus(); }
				} },
                id: 'exportPermitNoId',
                mode: 'local',
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'exportPermitDateHeader'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryExpPermitDate'
            }, {
                xtype: 'label',
                text: 'Export Permit Date' + ' :',
                cls: 'labelstyle',
                id: 'expPermitDtLabel'
            }, {
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                format: getDateFormat(),
                id: 'exportPermitDateId',
                mode: 'local',
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'importExpChallanHeader'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryExpChallanNo'
            }, {
                xtype: 'label',
                text: 'Export Challan No' + ' :',
                cls: 'labelstyle',
                id: 'expChallanLabel'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                listeners: { change: function(f,n,o){ //restrict 50
				 if(f.getValue().length> 50){ Ext.example.msg("Field reached it's Maximum Size"); 
					f.setValue(n.substr(0,50)); f.focus(); }
				 } },
                id: 'exportChallanNoId',
                mode: 'local',
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'exportchallanDateHeader'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryExpchallanDate'
            }, {
                xtype: 'label',
                text: 'Export Challan Date' + ' :',
                cls: 'labelstyle',
                id: 'expChallanDtLabel'
            }, {
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                format: getDateFormat(),
                id: 'exportChallanDateId',
                mode: 'local',
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'saleInvoiceNoHeader'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorySaleInvoiceNo'
            }, {
                xtype: 'label',
                text: 'Sale Invoice No' + ' :',
                cls: 'labelstyle',
                id: 'saleInvoiceLabel'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                listeners: { change: function(f,n,o){ //restrict 50
				 if(f.getValue().length> 50){ Ext.example.msg("Field reached it's Maximum Size"); 
					f.setValue(n.substr(0,50)); f.focus(); }
				} },
                id: 'saleInvoiceNoId',
                mode: 'local',
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'saleInvoiceDateHeader'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorysaleInvoiceDate'
            }, {
                xtype: 'label',
                text: 'Sale Invoice Date' + ' :',
                cls: 'labelstyle',
                id: 'saleInvoiceDtLabel'
            }, {
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                format: getDateFormat(),
                id: 'saleInvoiceDateId',
                mode: 'local',
            }, {
                width: 10
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'transportnTypeHeader'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorytransportnType'
            }, {
                xtype: 'label',
                text: 'Transportation Type' + ' :',
                cls: 'labelstyle',
                id: 'transportnTypeLabelId'
            }, transPortationTypeCombo, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead12ty'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryrspermitId'
            }, {
                xtype: 'label',
                text: 'RS Permit' + ' :',
                cls: 'labelstyle',
                id: 'rspermitLabelId'
            }, romSaleCombo, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead1e'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'manrouteId'
            }, {
                xtype: 'label',
                text: 'Source Hub' + ' :',
                cls: 'labelstyle',
                id: 'hubLablelId'
            }, hubCombo, {
                width: 10
            },
            {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead12'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryrouteid'
            }, {
                xtype: 'label',
                text: '<%=RouteID%>' + ' :',
                cls: 'labelstyle',
                id: 'mineralRouteId'
            }, RouteIdCombo, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead13'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryfromloc'
            }, {
                xtype: 'label',
                text: '<%=From_Location%>' + ' :',
                cls: 'labelstyle',
                id: 'fromId'
            }, {
                xtype: 'textarea',
                cls:'textareastyle',
                stripCharsRe: /[,]/,
                height  : 60,
                id: 'fromlocId',
                readOnly: true,
                mode: 'local',
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead14'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorytoloc'
            }, {
                xtype: 'label',
                text: '<%=To_Location%>' + ' :',
                cls: 'labelstyle',
                id:'toId'
            }, {
                xtype: 'textarea',
                cls:'textareastyle',
                height  : 60,
                stripCharsRe: /[,]/,
               
                id: 'tolocId',
                readOnly: true,
                mode: 'local',
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead15'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryref'
            }, {
                xtype: 'label',
                text: '<%=Ref%>' + '  :',
                cls: 'labelstyle',
                id: 'refId'
            }, RefCombo, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead16'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorybu'
            }, {
                xtype: 'label',
                text: 'Bauxite Challan' + '  :',
                cls: 'labelstyle',
                id: 'bauxiteChallanId'
            }, bauxiteCombo, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead160'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorystartdate'
            }, {
                xtype: 'label',
                text: '<%=Start_Date%>' + ' :',
                cls: 'labelstyle'
            }, {
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                id: 'startdateid',
                format: getDateFormat(),
                allowBlank: false,
                blankText: '<%=Enter_Start_Date%>',
                submitFormat: getDateFormat(),
                labelSeparator: '',
                allowBlank: false,
                value: dtcur
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead17'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryenddate'
            }, {
                xtype: 'label',
                text: '<%=End_Date%>' + ' :',
                cls: 'labelstyle'
            }, {
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                id: 'enddateid',
                format: getDateFormat(),
                allowBlank: false,
                blankText: '<%=Enter_End_Date%>',
                submitFormat: getDateFormat(),
                labelSeparator: '',
                allowBlank: false,
                value: datenext
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead18'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryship'
            }, {
                xtype: 'label',
                text: '<%=Ship_Name%>' + ' :',
                cls: 'labelstyle',
                id:'labelShip'
            }, vesselNameCombo, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead21'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorybuyer'
            }, {
                xtype: 'label',
                text: '<%=Buyer_Name%>' + ' :',
                cls: 'labelstyle',
                id:'labelBuyer'
            }, {
                xtype: 'textfield',
                emptyText: '<%=Enter_Buyer_Name%>',
                allowBlank: true,
                cls: 'selectstylePerfect',
                id: 'buyerId',
                mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
                listeners: { change: function(f,n,o){ //restrict 100
				 if(f.getValue().length> 100){ Ext.example.msg("Field reached it's Maximum Size"); 
					f.setValue(n.substr(0,100)); f.focus(); }
				} },
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead199'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorycountry'
            }, {
                xtype: 'label',
                text: '<%=Country_Name%>' + ' :',
                cls: 'labelstyle',
                id:'labelcountry'
            }, countryCombo,
            {
                width: 10
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead200'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorystate'
            }, {
                xtype: 'label',
                text: '<%=State_Name%>' + ' :',
                cls: 'labelstyle',
                id:'labelstate'
            }, stateCombo,
            {
                width: 10
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHeadState'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorystateName'
            }, {
                xtype: 'label',
                text: 'State' + ' :',
                cls: 'labelstyle',
                id:'labelstateName'
            }, stateCombonew,
            {
                width: 10
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryHead20'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryremarks'
            }, {
                xtype: 'label',
                text: '<%=Remarks%>' + ' :',
                cls: 'labelstyle'
            }, {
                xtype: 'textfield',
                emptyText: '<%=Enter_Remarks%>',
                allowBlank: true,
                cls: 'selectstylePerfect',
                id: 'remarksid',
                mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
                listeners: { change: function(f,n,o){ //restrict 500
				 if(f.getValue().length> 500){ Ext.example.msg("Field reached it's Maximum Size"); 
					f.setValue(n.substr(0,500)); f.focus(); }
				} },
            }, {
                width: 10
            }]
        }]
    });
    var exportReader = new Ext.data.JsonReader({
        idProperty: 'exportRootId',
        root: 'exportRoot',
        totalProperty: 'total',
        fields: [{
            name: 'SLNOIndex'
        }, {
            name: 'stockLocIndex'
        }, {
            name: 'stockTypeIndex'
        }, {
            name: 'totalFinesIndex'
        }, {
            name: 'totalLumpsIndex'
        }, {
            name: 'totalConcentratesIndex'
        }, {
            name: 'totalRejectsIndex'
        }, {
            name: 'totalTailingsIndex'
        }, {
            name:'totalufoIndex'
        },{
            name:'totalQtyIndex'
        },{
            name:'romQtyIndex'
        }]
    });
    var exportFilters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'int',
            dataIndex: 'SLNOIndex'
        }, {
            type: 'string',
            dataIndex: 'stockLocIndex'
        }, {
            type: 'string',
            dataIndex: 'stockTypeIndex'
        }, {
            type: 'int',
            dataIndex: 'totalFinesIndex',
        }, {
            type: 'int',
            dataIndex: 'totalLumpsIndex',
        }, {
            type: 'int',
            dataIndex: 'totalConcentratesIndex',
        }, {
            type: 'int',
            dataIndex: 'totalRejectsIndex'
        }, {
            type: 'int',
            dataIndex: 'totalTailingsIndex'
        },{
            type: 'int',
            dataIndex: 'totalufoIndex'
        },{
            type: 'int',
            dataIndex: 'totalQtyIndex'
        },{
            type: 'int',
            dataIndex: 'romQtyIndex'
        }]
    });
    var columnModelExp = new Ext.grid.ColumnModel({
        columns: [{
            header: "<span style=font-weight:bold;>SLNO</span>",
            dataIndex: 'SLNOIndex',
            hidden: true,
            width: 50
        }, {
            header: "<span style=font-weight:bold;>Stock Location</span>",
            sortable: true,
            hidden: false,
            width: 170,
            dataIndex: 'stockLocIndex',

        }, {
            header: "<span style=font-weight:bold;>Stock Type</span>",
            sortable: true,
            hidden: false,
            width: 100,
            dataIndex: 'stockTypeIndex',

        }, {
            header: "<span style=font-weight:bold;>Total Fines(MT)</span>",
            sortable: true,
            align: 'right',
            hidden: false,
            width: 100,
            dataIndex: 'totalFinesIndex'

        }, {
            header: "<span style=font-weight:bold;>Total Lumps(MT)</span>",
            sortable: false,
            align: 'right',
            hidden: false,
            width: 100,
            dataIndex: 'totalLumpsIndex',
        }, {
            header: "<span style=font-weight:bold;>Total Concentrates(MT)</span>",
            sortable: false,
            align: 'right',
            hidden: false,
            width: 100,
            dataIndex: 'totalConcentratesIndex',
        }, {
            header: "<span style=font-weight:bold;>Total Rejects(MT)</span>",
            sortable: false,
            align: 'right',
            hidden: false,
            width: 100,
            dataIndex: 'totalRejectsIndex',
        }, {
            header: "<span style=font-weight:bold;>Total Tailing(MT)</span>",
            sortable: false,
            align: 'right',
            hidden: false,
            width: 100,
            dataIndex: 'totalTailingsIndex',
        },{
            header: "<span style=font-weight:bold;>Total UFO</span>",
            sortable: false,
            align: 'right',
            hidden: false,
            width: 100,
            dataIndex: 'totalufoIndex'
        },{
            header: "<span style=font-weight:bold;>Total Quantity</span>",
            sortable: false,
            align: 'right',
            hidden: false,
            width: 100,
            dataIndex: 'totalQtyIndex'
        },{
            header: "<span style=font-weight:bold;>Rom Quantity</span>",
            sortable: false,
            align: 'right',
            hidden: false,
            width: 100,
            dataIndex: 'romQtyIndex'
        }]
    });

    var exportStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getDataForExport',
            method: 'POST'
        }),
        reader: exportReader
    });

    var selModelExport = new Ext.grid.RowSelectionModel({
        singleSelect: true
    });
    var gridForExportDetails = new Ext.grid.EditorGridPanel({
        title: 'Export Grid Details',
        height: 230,
        width: 740,
        autoScroll: true,
        border: false,
        hidden: true,
        store: exportStore,
        id: 'exportgridId',
        colModel: columnModelExp,
        sm: selModelExport,
        plugins: [exportFilters],
        clicksToEdit: 1
    });
    var gradeReader = new Ext.data.JsonReader({
        idProperty: 'gradeRootId',
        root: 'gradeRoot',
        totalProperty: 'total',
        fields: [{
            name: 'SLNOIndex'
        }, {
            name: 'gradeIdIndex'
        }, {
            name: 'rateIdIndex'
        }, {
            name: 'qtyIdIndex'
        }, {
            name: 'payableIdIndex'
        }]
    });
    var gradeFilters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'int',
            dataIndex: 'SLNOIndex'
        }, {
            type: 'string',
            dataIndex: 'gradeIdIndex'
        }, {
            type: 'int',
            dataIndex: 'rateIdIndex',
        }, {
            type: 'int',
            dataIndex: 'qtyIdIndex',
        }, {
            type: 'int',
            dataIndex: 'payableIdIndex'
        }]
    });
    var columnModel = new Ext.grid.ColumnModel({
        columns: [{
            header: "<span style=font-weight:bold;>SLNO</span>",
            dataIndex: 'SLNOIndex',
            hidden: true,
            width: 50
        }, {
            header: "<span style=font-weight:bold;>Grade</span>",
            sortable: true,
            hidden: false,
            width: 240,
            dataIndex: 'gradeIdIndex'
        }, {
            header: "<span style=font-weight:bold;>Rate</span>",
            sortable: true,
            align: 'right',
            width: 150,
            dataIndex: 'rateIdIndex',
            editable:false,
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                decimalPrecision: 3,
                allowNegative: false
            })),
            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } }
        }, {
            header: "<span style=font-weight:bold;>Quantity</span>",
            sortable: false,
            align: 'right',
            width: 100,
            dataIndex: 'qtyIdIndex',
            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } }
        }, {
            header: "<span style=font-weight:bold;>Payable</span>",
            sortable: false,
            align: 'right',
            width: 180,
            dataIndex: 'payableIdIndex',
        }]
    });

    var gradeStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getGradeData',
            method: 'POST'
        }),
        reader: gradeReader
    });

    var selModel = new Ext.grid.RowSelectionModel({
        singleSelect: true
    });
    var gradeplant = Ext.data.Record.create([{
        name: 'SLNOIndex'
    }, {
        name: 'gradeIdIndex'
    }, {
        name: 'rateIdIndex'
    }, {
        name: 'qtyIdIndex'
    }, {
        name: 'payableIdIndex'
    }]);


    var ReaderForOthers = new Ext.data.JsonReader({
        idProperty: 'otherRootId',
        root: 'otherRoot',
        totalProperty: 'total',
        fields: [{
            name: 'SLNOIndex'
        }, {
            name: 'uniqueIdIndex'
        }, {
            name: 'gardeDataIndex'
        }, {
            name: 'type2IdIndex'
        }, {
            name: 'stockTypeIdIndex'
        }, {
            name: 'qty2IdIndex'
        },{
            name: 'processingFeeIndex'
        },{
            name: 'totalPfeeIndex'
        }]
    });
    var otherFilters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'int',
            dataIndex: 'SLNOIndex'
        }, {
            type: 'int',
            dataIndex: 'uniqueIdIndex'
        }, {
            type: 'string',
            dataIndex: 'gardeDataIndex'
        }, {
            type: 'int',
            dataIndex: 'type2IdIndex',
        }, {
            type: 'string',
            dataIndex: 'stockTypeIdIndex',
        }, {
            type: 'int',
            dataIndex: 'qty2IdIndex'
        },{
            type: 'int',
            dataIndex: 'processingFeeIndex'
        },{
            type: 'int',
            dataIndex: 'totalPfeeIndex'
        }]
    });

    var columnModel2 = new Ext.grid.ColumnModel({
        columns: [{
            header: "<span style=font-weight:bold;>SLNO</span>",
            dataIndex: 'SLNOIndex',
            hidden: true,
            width: 50
        }, {
            header: "<span style=font-weight:bold;>Unique Id</span>",
            dataIndex: 'uniqueIdIndex',
            hidden: true,
            width: 50
        }, {
            header: "<span style=font-weight:bold;>Exact Grade</span>",
            sortable: true,
            hidden: false,
            width: 86,
            dataIndex: 'gardeDataIndex',
            editor: new Ext.grid.GridEditor(new Ext.form.TextField({
                width: 100,
                listeners: { change: function(f,n,o){ //restrict 50
				 if(f.getValue().length> 50){ Ext.example.msg("Field reached it's Maximum Size"); 
					f.setValue(n.substr(0,50)); f.focus(); }
				} },
                id: 'remarks'
            }))
        }, {
            header: "<span style=font-weight:bold;>Type</span>",
            sortable: true,
            width: 70,
            dataIndex: 'type2IdIndex',
            editor: new Ext.grid.GridEditor(gradeCombo)

        }, {
            header: "<span style=font-weight:bold;>Stock Location</span>",
            sortable: true,
            width: 199,
            dataIndex: 'stockTypeIdIndex',
            editor: new Ext.grid.GridEditor(stockTypeCombo),
            renderer: stockTyperender
        }, {
            header: "<span style=font-weight:bold;>Quantity</span>",
            sortable: false,
            align: 'right',
            width: 100,
            dataIndex: 'qty2IdIndex',
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
            	id: 'qty2Id',
                decimalPrecision: 2,
                allowNegative: false,
                listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
                autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
            })),
           
        },{
            header: "<span style=font-weight:bold;>Processing Fee</span>",
            sortable: false,
            align: 'right',
            width: 120,
            dataIndex: 'processingFeeIndex',editable:false,
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
               id: 'proFeeId',
               decimalPrecision: 2,
               allowNegative: false,
               listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
               autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
            }))
        },{
            header: "<span style=font-weight:bold;>Total Processing Fee</span>",
            sortable: false,
            align: 'right',
            width: 150,
            dataIndex: 'totalPfeeIndex'
        }]
    });
    var Store2 = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getGrid2Data',
            method: 'POST'
        }),
        reader: ReaderForOthers
    });

    var selModel2 = new Ext.grid.RowSelectionModel({
        singleSelect: true
    });
    var proccessedOreGrid = new Ext.grid.EditorGridPanel({
        title: 'Details',
        layout: 'fit',
        stripeRows: true,
        height: 150,
        width: 740,
        autoScroll: true,
        hidden: true,
        border: false,
        store: Store2,
        id: 'poregridId',
        colModel: columnModel2,
        sm: selModel2,
        plugins: [otherFilters],
        clicksToEdit: 1
    });
    proccessedOreGrid.on({
        beforeedit: function(e) {
            var cellEditable = e.record.get('gardeDataIndex');
            if (cellEditable == "Total")
                return false;
            else
                return true;
        }
    });
        proccessedOreGrid.on({
        beforeedit: function(e) {
            var slno = e.record.data['SLNOIndex'];
            var grade = e.record.data['gardeDataIndex'];
            if(Ext.getCmp('permittypecomboId').getValue()=='Purchased Rom Sale Transit Permit'  && buttonValue=='Add'){
            	return false;
            }
            if(Ext.getCmp('permittypecomboId').getValue()=='Import Transit Permit'  && buttonValue=='Add'){
              if (slno == "1" && (e.field != 'processingFeeIndex'))
                return false;
            else
                return true;
            }
            if(buttonValue=='Modify'){
                return false;
            }
        }
    });
    proccessedOreGrid.on({
        afteredit: function(e) {
            var field = e.field;
            var slno = e.record.data['SLNOIndex'];
            var temp = editedRowsForGrid.split(",");
            var isIn = 0;
            for (var i = 0; i < temp.length; i++) {
                if (temp[i] == slno) {
                    isIn = 1
                }
            }
            if (isIn == 0) {
                editedRowsForGrid = editedRowsForGrid + slno + ",";
            }
            if (e.record.data['qty2IdIndex'] > 0) {
                getTotal('qty2IdIndex','totalPfeeIndex');
            }
        }
    });
    function getTotal(e,e1) {
        var tot1 = 0;
        var tot = 0;
        var tot2 = 0;
        var totPF = 0;
        proccessedOreGrid.store.each(function(record2)     {  
            if ((record2.data['qty2IdIndex'] != '' || record2.data['qty2IdIndex'] > 0)) {
                tot = record2.data['qty2IdIndex'];
            }
            if ((record2.data['processingFeeIndex'] != '' || record2.data['processingFeeIndex'] > 0)) {
                totPF = (record2.data['processingFeeIndex'] * record2.data['qty2IdIndex']);
            }
            record2.set(e1, (totPF.toFixed(2)));
        })
    }
    var readerForBauxite = new Ext.data.JsonReader({
        idProperty: 'BauxiteGradeRootId',
        root: 'BauxiteGradeRoot',
        totalProperty: 'total',
        fields: [{
            name: 'SLNOIndex'
        }, {
            name: 'uniqueIdIndex'
        }, {
            name: 'inputDataIndex'
        }, {
            name: 'valueDataIndex'
        },{
            name: 'statusBuDataIndex'
        }]
    });
	
	   var FilterForBauxite = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'int',
            dataIndex: 'SLNOIndex'
        }, {
            type: 'int',
            dataIndex: 'uniqueIdIndex'
        }, {
            type: 'string',
            dataIndex: 'inputDataIndex'
        }, {
            type: 'int',
            dataIndex: 'valueDataIndex',
        },{
            type: 'string',
            dataIndex: 'statusBuDataIndex',
        }]
    });
	
	    var columnModelForBauxite = new Ext.grid.ColumnModel({
        columns: [{
            header: "<span style=font-weight:bold;>SLNO</span>",
            dataIndex: 'SLNOIndex',
            hidden: true,
            width: 50
        }, {
            header: "<span style=font-weight:bold;>Unique Id</span>",
            dataIndex: 'uniqueIdIndex',
            hidden: true,
            width: 50
        }, {
            header: "<span style=font-weight:bold;>Inputs</span>",
            sortable: false,
            hidden: false,
            width: 370,
            dataIndex: 'inputDataIndex'  
        }, {
            header: "<span style=font-weight:bold;>Values</span>",
            sortable: false,
            align: 'right',
            width: 300,
            dataIndex: 'valueDataIndex'
        },{
            header: "<span style=font-weight:bold;>Status</span>",
            dataIndex: 'statusBuDataIndex',
            hidden: true,
            width: 50
        }]
    });
	
	var storeForBauxite = new Ext.data.GroupingStore({
        autoLoad: false,
        remoteSort: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getGridDataForBauxiteChallan',
            method: 'POST'
        }),
        reader: readerForBauxite
    });
	var selModelForBauxite = new Ext.grid.RowSelectionModel({
        singleSelect: true
    });
	
    var outerPanelForGrid = new Ext.grid.EditorGridPanel({
        title: 'Grade Details',
        layout: 'fit',
        height: 400,
        width: 720,
        autoScroll: true,
        border: false,
        store: gradeStore,
        id: 'employmentgridId',
        colModel: columnModel,
        sm: selModel,
        plugins: [gradeFilters],
        clicksToEdit: 1,
    });
    outerPanelForGrid.on({
    
        beforeedit: function(e) {
            if ((e.field == 'rateIdIndex') && e.record.get('gradeIdIndex') != 'PROCESS FEE(Automatic based on total ton)') {
                return false;
            }
            if(buttonValue=='Modify'){
                return false;
            }   
            else{
                return true;
            }
        },
        afteredit: function(e) {
            var field = e.field;
            var slno = e.record.data['SLNOIndex'];
            var temp = editedRows.split(",");
            var isIn = 0;
            for (var i = 0; i < temp.length; i++) {
                if (temp[i] == slno) {
                    isIn = 1
                }
            }
            if (isIn == 0) {
                editedRows = editedRows + slno + ",";
            }
            var payable = parseFloat(e.record.data['qtyIdIndex'] * e.record.data['rateIdIndex']);
            e.record.set('payableIdIndex', (payable).toFixed(2));
            getTotalAmt('payableIdIndex',payable);
        }
    });
    function getTotalAmt(e,payable){
       var total=0;
       outerPanelForGrid.store.each(function(record2){
            if (record2.data['gradeIdIndex'].trim() == 'Total') {
                var n = parseFloat(Math.round(parseFloat(totalAmtt)).toFixed(2)) + parseFloat(Math.round(payable).toFixed(2));
                record2.set(e, n.toFixed(2));
            }
        })
    }
    var outerPanelForBauxiteGrid = new Ext.grid.EditorGridPanel({
        title: 'Details',
        height: 400,
        width: 731,
        autoScroll: true,
        border: false,
        store: storeForBauxite,
        id: 'bauxiteGridId',
        colModel: columnModelForBauxite,
        sm: selModelForBauxite,
        plugins: [FilterForBauxite],
        clicksToEdit: 1,
        hidden:true
    });
    var gridPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: true,
        height: 400,
        width: '755px',
        frame: true,
        id: 'addPanelInfo',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [proccessedOreGrid, gridForExportDetails]
    });
    var caseInnerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: true,
        height: 440,
        width: 1280,
        frame: true,
        id: 'addCaseInfo',
        layout: 'table',
        layoutConfig: {
            columns: 5
        },
        items: [innerPanelForPermitDetails, {
            width: 10
        }, gridPanel, outerPanelForGrid,outerPanelForBauxiteGrid]
    });
    
        var innerPanelForPermitClosure = new Ext.form.FormPanel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: true,
        height: 350,
        width: 500,
        frame: false,
        id: 'innerPanelForPermitClosureId',
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [{
            xtype: 'fieldset',
            title: '<%=Permit_Closure%>',
            cls: 'fieldsetpanel',
            autoScroll: true,
            collapsible: false,
            colspan: 3,
            id: 'PermitclId',
            width: 450,
            height: 342,
            layout: 'table',
            layoutConfig: {
                columns: 4
            },
            items: [{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryid001'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorypermitTyp1'
            }, {
                xtype: 'label',
                text: '<%=Permit_Type%>' + '  :',
                cls: 'labelstyle',
                id: 'PermitTypeLabelId1'
            }, permittypeComboForClosure,
            {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryidSource'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorytcnoSource'
            }, {
                xtype: 'label',
                text: 'Source Type' + '  :',
                cls: 'labelstyle',
                id: 'SourcetypeLabelId1'
            }, NewSourceCombo,
            {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryid01'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorytcno1'
            }, {
                xtype: 'label',
                text: '<%=Tc_No%>' + '  :',
                cls: 'labelstyle',
                id: 'TcNoLabelId1'
            }, TcNoCombo1,
            {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryid2'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryminecode1'
            }, {
                xtype: 'label',
                text: '<%=Mine_Code%>' + ' :',
                id:'minecodeLabelId',
                cls: 'labelstyle'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                autoCreate: {
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "200",
                    autocomplete: "off"
                },
                id: 'minecodeId1',
                readOnly: true,
                mode: 'local'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryid3'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryleasename1'
            }, {
                xtype: 'label',
                text: 'Lease Name' + ' :',
                id: 'leasenameLabelid',
                cls: 'labelstyle'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                autoCreate: {
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "200",
                    autocomplete: "off"
                },
                id: 'leaseNameid1',
                readOnly: true,
                mode: 'local',
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryid4'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryleaseowner1'
            }, {
                xtype: 'label',
                text: 'Lease Owner' + ' :',
                id:'leaseOwnerIdlabel',
                cls: 'labelstyle'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                autoCreate: {
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "200",
                    autocomplete: "off"
                },
                id: 'leaseOwnerid1',
                readOnly: true,
                mode: 'local',
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryidorg'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryorg1'
            }, {
                xtype: 'label',
                text: '<%=OrganizationTrader_Name%>' + '  :',
                cls: 'labelstyle',
                id: 'orgcode1LabelId1'
            }, organizationCodeComboForClose, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryid5'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryorganization1'
            }, {
                xtype: 'label',
                text: '<%=OrganizationTrader_Code%>' + ' :',
                id:'orgnamelabelid',
                cls: 'labelstyle'
            }, {
                xtype: 'textarea',
                cls: 'textareastyle',
                stripCharsRe: /[,]/,
                height  : 60,
                id: 'organizationid1',
                readOnly: true,
                mode: 'local'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryid100'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryvesselClose'
            }, {
                xtype: 'label',
                text: 'Vessel Name' + '  :',
                cls: 'labelstyle',
                id: 'vesselnameLabelId1'
            }, vesselNameComboForCLOSE, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryid1'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorypermno1'
            }, {
                xtype: 'label',
                text: '<%=Permit_No%>' + '  :',
                cls: 'labelstyle',
                id: 'PermitNoLabelId1'
            }, PermitNoCombo, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatid4'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorypermitdate'
            }, {
                xtype: 'label',
                text: '<%=Permit_Date%>' + ' :',
                cls: 'labelstyle'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                autoCreate: {
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "200",
                    autocomplete: "off"
                },
                id: 'permitdateId',
                readOnly: true,
                mode: 'local',
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryqt'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryqty'
            }, {
                xtype: 'label',
                text: 'Permit Quantity' + ' :',
                cls: 'labelstyle',
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                id: 'qtyId',
                mode: 'local',
                stripCharsRe: /[,]/,
                autoCreate: {
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "200",
                    autocomplete: "off"
                },
                readOnly: true,
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryqd'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryqtyded'
            }, {
                xtype: 'label',
                text: '<%=Tripsheet_Qty%>' + ' :',
                cls: 'labelstyle',
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                id: 'qtydeductionId',
                mode: 'local',
                stripCharsRe: /[,]/,
                autoCreate: {
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "200",
                    autocomplete: "off"
                },
                readOnly: true,
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatidr7'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryromqty'
            }, {
                xtype: 'label',
                text: 'ROM Quantity' + ' :',
                cls: 'labelstyle'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                id: 'romQuantityid',
                mode: 'local',
                forceSelection: true,
                emptyText: 'Enter ROM Quantity',
                blankText: 'Enter ROM Quantity',
                selectOnFocus: true,
                allowBlank: false,
                readOnly: true,
                listeners: {}
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatid7'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryclosedqty'
            }, {
                xtype: 'label',
                text: 'Closed Quantity' + ' :',
                cls: 'labelstyle'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                id: 'closedqtyId',
                mode: 'local',
                forceSelection: true,
                readOnly: true,
                emptyText: 'Enter Closed Quantity',
                blankText: 'Enter Closed Quantity',
                selectOnFocus: true,
                allowBlank: false,
                //disabled: true,
                listeners: {}
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryid1111'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryrefund'
            }, {
                xtype: 'label',
                text: 'Processing Fee Amount' + '  :',
                cls: 'labelstyle',
                id: 'refundLabelId1'
            }, typeComboForClose]
        }]
    });

    var innerWinButtonPanel = new Ext.Panel({
        id: 'innerWinButtonPanelId',
        standardSubmit: true,
        collapsible: false,
        autoHeight: true,
        cls: 'windowbuttonpanel',
        frame: false,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        buttons: [{
            xtype: 'button',
            text: 'Save',
            id: 'saveButtonId',
            cls: 'buttonstyle',
            iconCls: 'savebutton',
            width: 70,
            listeners: {
                click: {
                    fn: function() {
                        var JSON = '';
                        var JSON1 = '';
                        var totfines = 0;
                        var totLumps = 0;
                        var totTailings = 0;
                        var totRejects = 0;
                        var totQty = 0;
                        var pattern = /[12][0-9]{3}-[12][0-9]{3}$/;
                        var storeR;
                       if (!pattern.test(Ext.getCmp('finyearId').getValue())) {
                           Ext.example.msg("Enter Valid Financial Year(Eg:2015-2016)");
                           Ext.getCmp('finyearId').focus();
                           return;
                       }
                       var fyear=Ext.getCmp('finyearId').getValue();
                       var syear=fyear.substr(0, 4);
                       var eYear=fyear.substr(5);
                       if((eYear-syear) == 1 && (eYear-syear) !=0){
                           }
                           else if((eYear-syear) < 1 ){
                            Ext.example.msg(" Enter Valid Year");
                           Ext.getCmp('finyearId').focus();
                           return;
                           }
                           else{
                           Ext.example.msg("Only One Year Difference Is Allowed");
                           Ext.getCmp('finyearId').focus();
                           return;
                           }
                           
                        if (Ext.getCmp('dateid').getValue()=="") {
                           Ext.example.msg("Select date");
                           Ext.getCmp('dateid').focus();
                           return;
                        }
                        if (Ext.getCmp('startdateid').getValue()=="") {
                           Ext.example.msg("Select Start date");
                           Ext.getCmp('startdateid').focus();
                           return;
                        }
                        if (Ext.getCmp('permitreqtypecomboId').getValue() == "") {
                            Ext.example.msg("<%=Select_Permit_Request_Type%>");
                            Ext.getCmp('permitreqtypecomboId').focus();
                            return;
                        }
                        if (Ext.getCmp('permittypecomboId').getRawValue() == "") {
                            Ext.example.msg("<%=Select_Permit_Type%>");
                            Ext.getCmp('permittypecomboId').focus();
                            return;
                        }
                        if (Ext.getCmp('permittypecomboId').getValue() == 'Rom Transit' || Ext.getCmp('permittypecomboId').getValue() == 'Rom Sale'){
	                        if (Ext.getCmp('desttypeId').getValue() == "") {
	                            Ext.example.msg("Select Source type");
	                            Ext.getCmp('desttypeId').focus();
	                            return;
	                        }
	                    } 
                        if (Ext.getCmp('permittypecomboId').getValue() == 'Import Permit') {
                             if (Ext.getCmp('importtypecomboId').getValue() == "") {
                                Ext.example.msg("Select Import Type");
                                Ext.getCmp('importtypecomboId').focus();
                                return;
                            }
                            if (Ext.getCmp('importpurposecomboId').getValue() == "") {
                                Ext.example.msg("Select Purpose of Import");
                                Ext.getCmp('importpurposecomboId').focus();
                                return;
                            }
                        }
                        if ((Ext.getCmp('permittypecomboId').getValue() == 'Rom Transit' && Ext.getCmp('desttypeId').getValue()=='E-Wallet') || (Ext.getCmp('permittypecomboId').getValue() == 'Rom Sale' && Ext.getCmp('desttypeId').getValue()=='E-Wallet')) {
                            if (Ext.getCmp('TccomboId').getValue() == "") {
                                Ext.example.msg("<%=Select_TC_Number%>");
                                Ext.getCmp('TccomboId').focus();
                                return;
                            }
                        }
                       if ((Ext.getCmp('permittypecomboId').getValue() == 'Import Transit Permit' || 
                        		Ext.getCmp('permittypecomboId').getValue() == 'Import Permit' || 
                        			Ext.getCmp('permittypecomboId').getValue() == 'Processed Ore Transit' || 
                        				Ext.getCmp('permittypecomboId').getValue() == 'Domestic Export' ||
                        					 Ext.getCmp('permittypecomboId').getValue() == 'International Export') ||
                        					 	 Ext.getCmp('permittypecomboId').getValue() == 'Processed Ore Sale' || 
                        					 	 	Ext.getCmp('permittypecomboId').getValue() == 'Processed Ore Sale Transit' || 
                        					 	 		Ext.getCmp('permittypecomboId').getValue() == 'Purchased Rom Sale Transit Permit' ||
                        					 	 			(Ext.getCmp('permittypecomboId').getValue() == 'Rom Transit' && Ext.getCmp('desttypeId').getValue()=='ROM') || 
                        					 	 				(Ext.getCmp('permittypecomboId').getValue() == 'Rom Sale' && Ext.getCmp('desttypeId').getValue()=='ROM')
                        					 	 			&& buttonValue == '<%=Add%>') {
                            if (Ext.getCmp('organizationcodeid').getValue() == "") {
                                Ext.example.msg("<%=Select_OrganisationTrader_Code%>");
                                Ext.getCmp('organizationcodeid').focus();
                                return;
                            }
                        }
                        if (Ext.getCmp('permittypecomboId').getValue() == 'Purchased Rom Sale Transit Permit'){
	                        if (Ext.getCmp('toLocationId').getValue() == "") {
                                Ext.example.msg("Select To Location");
                                Ext.getCmp('toLocationId').focus();
                                return;
	                        }
                        }
						if (Ext.getCmp('permittypecomboId').getValue() == 'Rom Sale' || Ext.getCmp('permittypecomboId').getValue() == 'Processed Ore Sale' || Ext.getCmp('permittypecomboId').getValue() == 'Processed Ore Sale Transit') {
                            if (Ext.getCmp('buyingOrgComboId').getValue() == "") {
                                Ext.example.msg("<%=Select_Buying_OrgTrader_Name%>");
                                Ext.getCmp('buyingOrgComboId').focus();
                                return;
                            }
                        }
                        if (Ext.getCmp('permittypecomboId').getValue() == 'Import Transit Permit' && buttonValue=='Add') {
                           if (Ext.getCmp('importedPermitId').getValue() == "") {
                                Ext.example.msg("Select Imported Permit No");
                                Ext.getCmp('importedPermitId').focus();
                                return;
                            }
                        }
						if (Ext.getCmp('ownertypecomboId').getValue() == "") {
                            Ext.example.msg("<%=Select_Owner_Type%>");
                            Ext.getCmp('ownertypecomboId').focus();
                            return;
                        }
                        if (Ext.getCmp('mineralcomboId').getValue() == "") {
                            Ext.example.msg("<%=SelectMineral%>");
                            Ext.getCmp('mineralcomboId').focus();
                            return;
                        }
                        if (Ext.getCmp('permittypecomboId').getValue() == 'Purchased Rom Sale Transit Permit'){
	                        if (Ext.getCmp('romPermitId').getValue() == "") {
                                Ext.example.msg("Select RS permit");
                                Ext.getCmp('romPermitId').focus();
                                return;
	                        }
	                    }   
                        if(Ext.getCmp('permittypecomboId').getValue() != 'Processed Ore Sale' && Ext.getCmp('permittypecomboId').getValue() != 'Rom Sale'){
                          if (Ext.getCmp('routeidcomboId').getValue() == "") {
                            Ext.example.msg("<%=Select_Route%>");
                            Ext.getCmp('routeidcomboId').focus();
                            return;
                           }
                        }else{
                        	if (Ext.getCmp('hubId').getValue() == "") {
                            Ext.example.msg("Select Source Hub");
                            Ext.getCmp('hubId').focus();
                            return;
                           }
                        }
                         
                        if ((Ext.getCmp('permittypecomboId').getValue() == 'Rom Transit' && Ext.getCmp('desttypeId').getValue()=='E-Wallet') || (Ext.getCmp('permittypecomboId').getValue() == 'Rom Sale' && Ext.getCmp('desttypeId').getValue()=='E-Wallet')) {
                            if (Ext.getCmp('RefcomboId').getValue() == "") {
                                Ext.example.msg("<%=Select_Ref_Number%>");
                                Ext.getCmp('RefcomboId').focus();
                                return;
                            }
                        }
                        if (Ext.getCmp('permittypecomboId').getValue() == 'Bauxite Transit') {
                           if (Ext.getCmp('mineralcomboId').getValue() != "Bauxite/Laterite") {
                                Ext.example.msg("Select mineral Type as Bauxite/Laterite");
                                Ext.getCmp('mineralcomboId').reset();
                                Ext.getCmp('mineralcomboId').focus();
                                return;
                            }
                            if (Ext.getCmp('BuChallancomboId').getValue() == "") {
                                Ext.example.msg("Select Bauxite Transit");
                                Ext.getCmp('BuChallancomboId').focus();
                                return;
                            }
                        }
                        if (Ext.getCmp('permittypecomboId').getValue() == 'Processed Ore Sale Transit' || Ext.getCmp('permittypecomboId').getValue() == 'Purchased Rom Sale Transit Permit') {
                            if (Ext.getCmp('countryComboId').getValue() == "") {
                            Ext.example.msg("<%=Select_Country%>");
                            Ext.getCmp('countryComboId').focus();
                                return;
                            }
                        }
                        if (Ext.getCmp('permittypecomboId').getValue() == 'Processed Ore Sale Transit' || Ext.getCmp('permittypecomboId').getValue() == 'Purchased Rom Sale Transit Permit') {
                        if (Ext.getCmp('stateComboId1').getValue() == "") {
                            Ext.example.msg("<%=Select_State%>");
                            Ext.getCmp('stateComboId1').focus();
                            return;
                            }
                        }
                        if (Ext.getCmp('permittypecomboId').getValue() == 'Domestic Export') {
                            if (Ext.getCmp('buyerId').getValue() == "") {
                            Ext.example.msg("<%=Enter_Buyer_Name%>");
                            Ext.getCmp('buyerId').focus();
                            return;
                            }
                            if (Ext.getCmp('stateComboId').getValue() == "") {
                            Ext.example.msg("<%=Select_State%>");
                            Ext.getCmp('stateComboId').focus();
                            return;
                            }
                        }
                       if (Ext.getCmp('permittypecomboId').getValue() == 'International Export') {
                            if (Ext.getCmp('buyerId').getValue() == "") {
                            Ext.example.msg("<%=Enter_Buyer_Name%>");
                            Ext.getCmp('buyerId').focus();
                            return;
                            }
                            if (Ext.getCmp('countryComboId').getValue() == "") {
                            Ext.example.msg("<%=Select_Country%>");
                            Ext.getCmp('countryComboId').focus();
                            return;
                            }
                            if (Ext.getCmp('shipId').getValue() == "") {
                            Ext.example.msg("<%=Select_Vessel_Name%>");
                            Ext.getCmp('shipId').focus();
                            return;
                            }
                        }
                        if(Ext.getCmp('importtypecomboId').getValue() == 'Domestic Import'){
                        	 if (Ext.getCmp('stateComboId').getValue() == "") {
	                            Ext.example.msg("<%=Select_State%>");
	                            Ext.getCmp('stateComboId').focus();
	                            return;
	                         }
                        }
                        if(Ext.getCmp('importtypecomboId').getValue() == 'International Import'){
                        	if (Ext.getCmp('countryComboId').getValue() == "") {
	                            Ext.example.msg("<%=Select_Country%>");
	                            Ext.getCmp('countryComboId').focus();
	                            return;
                            }
                        }
                        var pattern = /\d{4}-\d{4}$/;
                        if (!pattern.test(Ext.getCmp('finyearId').getValue())) {
                            Ext.example.msg("Enter Valid Financial Year(Eg:2014-2015)");
                            Ext.getCmp('finyearId').focus();
                            return;
                        }
                        if (dateCompareForStartDate(Ext.getCmp('dateid').getValue(), Ext.getCmp('startdateid').getValue()) == -1) {
                           Ext.example.msg("Start date should be greater than Permit date");
                           Ext.getCmp('startdateid').focus();
                           return;
                       }

                        if (dateCompare(Ext.getCmp('startdateid').getValue(), Ext.getCmp('enddateid').getValue()) == -1) {
                            Ext.example.msg("End date should be greater than Start date");
                            Ext.getCmp('enddate').focus();
                            return;
                        }
                        if (Ext.getCmp('permittypecomboId').getValue() == 'Import Permit' || Ext.getCmp('permittypecomboId').getValue() == 'Processed Ore Transit' || Ext.getCmp('permittypecomboId').getValue() == 'Domestic Export' || Ext.getCmp('permittypecomboId').getValue() == 'International Export'
                            || Ext.getCmp('permittypecomboId').getValue() == 'Processed Ore Sale' || Ext.getCmp('permittypecomboId').getValue() == 'Processed Ore Sale Transit') {
                            
                            if (editedRowsForGrid == "" && buttonValue == '<%=Add%>') {
                                Ext.example.msg("Please Enter Exact Grade Details");
                                return;
                            }
                            var tempForGrid = editedRowsForGrid.split(",");
                            for (var i = 0; i < tempForGrid.length; i++) {
                                var row1 = proccessedOreGrid.store.find('SLNOIndex', tempForGrid[i]);
                                if (row1 == -1) {
                                    continue;
                                }
                                var store1 = proccessedOreGrid.store.getAt(row1);
                                if (store1.data['gardeDataIndex'] == "") {
                                    Ext.example.msg("Please Enter Exact Grade");
                                    proccessedOreGrid.startEditing(row1, 2);
                                    return;
                                }
                                if (store1.data['type2IdIndex'] == "") {
                                    Ext.example.msg("Please Select Type");
                                    proccessedOreGrid.startEditing(row1, 3);
                                    return;
                                }
                                if(Ext.getCmp('permittypecomboId').getValue() != 'Import Permit'){
                                   if (store1.data['stockTypeIdIndex'] == "") {
                                    Ext.example.msg("Please Select Stock Location");
                                    proccessedOreGrid.startEditing(row1, 4);
                                    return;
                                   }
                                }
                                if (store1.data['qty2IdIndex'] == "" || store1.data['qty2IdIndex'] == 0) {
                                    Ext.example.msg("Please Enter Quantity");
                                    proccessedOreGrid.startEditing(row1, 5);
                                    return;
                                }
                                //|| store1.data['type2IdIndex'] == "Concentrates" || store1.data['type2IdIndex'] == "Tailings"
                                if(Ext.getCmp('mineralcomboId').getValue() == 'Bauxite/Laterite' && (store1.data['type2IdIndex'] == "Fines" 
                                		|| store1.data['type2IdIndex'] == "Lumps" )){
                                    Ext.example.msg("Please Select type as NA");
                                    proccessedOreGrid.startEditing(row1, 3);
                                    return;
                                }
                                if(Ext.getCmp('mineralcomboId').getValue() == 'Iron Ore' && (store1.data['type2IdIndex'] == "NA")){
                                    Ext.example.msg("Please Select Stock type either Fines or Lumps");
                                    proccessedOreGrid.startEditing(row1, 3);
                                    return;
                                }
                                if((store1.data['type2IdIndex'] == "Rom")){
                                    Ext.example.msg("Please Select Stock type either Fines or Lumps");
                                    proccessedOreGrid.startEditing(row1, 3);
                                    return;
                                }
                                if(buttonValue == '<%=Add%>'){
                                if (Ext.getCmp('permittypecomboId').getValue() == 'Domestic Export' || Ext.getCmp('permittypecomboId').getValue() == 'International Export' || Ext.getCmp('permittypecomboId').getValue() == 'Processed Ore Transit' || Ext.getCmp('permittypecomboId').getValue() == 'Processed Ore Sale' || Ext.getCmp('permittypecomboId').getValue() == 'Processed Ore Sale Transit'
                                    || Ext.getCmp('permittypecomboId').getValue() == 'Import Permit') {
                                    
                                    if(Ext.getCmp('permittypecomboId').getValue() != 'Import Permit'){
                                    var id = stockTypeCombo.getValue();
                                    stockValue=stockTypeCombo.getRawValue();
                                    
                                    var row = StockTypeStore1.findExact('routeId', id);
                                    var rec = StockTypeStore1.getAt(row);
                                    totalLumps = rec.data['totalLumps'];
                                    totalFines = rec.data['totalFines'];
                                    totalConc = rec.data['totalConc'];
                                    totalTailings = rec.data['totalTailings'];
                                    totQty = rec.data['totalQty'];
                                    if (store1.data['type2IdIndex'] == 'Lumps') {

                                        var qty = store1.data['qty2IdIndex'];
                                        if (parseFloat(totalLumps) < parseFloat(qty)) {
                                            Ext.example.msg("Quantity should be less than or equals to stock");
                                            return;
                                        }
                                    }
                                    if (store1.data['type2IdIndex'] == 'Fines') {
                                        var qty = store1.data['qty2IdIndex'];
                                        if (parseFloat(totalFines) < parseFloat(qty)) {
                                            Ext.example.msg("Quantity should be less than or equals to stock");
                                            return;
                                        }
                                    }
                                    if (store1.data['type2IdIndex'] == 'Concentrates') {

                                        var qty = store1.data['qty2IdIndex'];
                                        if (parseFloat(totalConc) < parseFloat(qty)) {
                                            Ext.example.msg("Quantity should be less than or equals to stock");
                                            return;
                                        }
                                    }
                                    if (store1.data['type2IdIndex'] == 'Tailings') {

                                        var qty = store1.data['qty2IdIndex'];
                                        if (parseFloat(totalTailings) < parseFloat(qty)) {
                                            Ext.example.msg("Quantity should be less than or equals to stock");
                                            return;
                                        }
                                    }
                                    if (store1.data['type2IdIndex'] == 'NA') {
                                        var qty = store1.data['qty2IdIndex'];
                                        if (parseFloat(totQty) < parseFloat(qty)) {
                                            Ext.example.msg("Quantity should be less than or equals to stock");
                                            return;
                                        }
                                    }
                                    }
                                    var processFee = store1.data['totalPfeeIndex'];
                                    var mwalletBalance=Ext.getCmp('mwalletId').getValue();
                                    if (parseFloat(mwalletBalance) < parseFloat(processFee)) {
                                        Ext.example.msg("Processing Fee is greater than M-wallet balance.Please Pay the challan");
                                        return;
                                    }
                                }
                                JSON += Ext.util.JSON.encode(store1.data) + ',';
                            }
                            }
                            if (JSON != '') {
                                JSON = JSON.substring(0, JSON.length - 1);
                            }
                            json = JSON;
                        }
                        
                        if (Ext.getCmp('permittypecomboId').getValue() == 'Import Transit Permit' && buttonValue=='Add') {
                            if(editedRowsForGrid==""){
                            	var permitId = ImportedPermitCombo.getValue();
                                var row = importedPermitStore.findExact('ID', permitId);
                                var rec1 = importedPermitStore.getAt(row);
                                ImpprocessFee=rec1.data['processingFeeImport'];
                                var mwalletBalance=Ext.getCmp('mwalletId').getValue();
                                 if (parseFloat(mwalletBalance) < parseFloat(ImpprocessFee)) {
                                     Ext.example.msg("Processing Fee is greater than M-wallet balance.Please Pay the challan");
                                     return;
                                 }
                            }else{
                            	var tempGrid = editedRowsForGrid.split(",");
                           		for (var i = 0; i < tempGrid.length; i++) {
                                var row = proccessedOreGrid.store.find('SLNOIndex', tempGrid[i]);
                                if (row == -1) {
                                    continue;
                                }
                                var ImpStore = proccessedOreGrid.store.getAt(row);
                                var processFee = ImpStore.data['totalPfeeIndex'];
                                var mwalletBalance=Ext.getCmp('mwalletId').getValue();
                                if (parseFloat(mwalletBalance) < parseFloat(processFee)) {
                                    Ext.example.msg("Processing Fee is greater than M-wallet balance.Please Pay the challan");
                                    return;
                                }
                                 JSON += Ext.util.JSON.encode(ImpStore.data) + ',';
                            }
                            if (JSON != '') {
                                JSON = JSON.substring(0, JSON.length - 1);
                            }
                            json = JSON;
                        }
                        }
                        if ((Ext.getCmp('permittypecomboId').getValue() == 'Purchased Rom Sale Transit Permit' ||((Ext.getCmp('permittypecomboId').getValue() == 'Rom Transit' || Ext.getCmp('permittypecomboId').getValue() == 'Rom Sale') && Ext.getCmp('desttypeId').getValue()=='E-Wallet')) && buttonValue=='Add'){
							if(Ext.getCmp('permittypecomboId').getValue() == 'Purchased Rom Sale Transit Permit' && srcTypeR=='ROM' && editedRows==""){
								storeR = proccessedOreGrid.store.getAt(0);
                                proFee=storeR.data['totalPfeeIndex'];
                                var mwalletBalance=Ext.getCmp('mwalletId').getValue();
                                if (parseFloat(mwalletBalance) < parseFloat(proFee)) {
                                   Ext.example.msg("Processing Fee is greater than M-wallet balance.Please Pay the challan");
                                   return;
                                }
                                JSON1 += Ext.util.JSON.encode(storeR.data) + ',';
							}
							
							//if(Ext.getCmp('permittypecomboId').getValue() != 'Purchased Rom Sale Transit Permit' && srcTypeR!='E-Wallet'){
							if(((Ext.getCmp('permittypecomboId').getValue() == 'Rom Transit' || Ext.getCmp('permittypecomboId').getValue() == 'Rom Sale')
 									&& Ext.getCmp('desttypeId').getValue()=='E-Wallet') || (Ext.getCmp('permittypecomboId').getValue() == 'Purchased Rom Sale Transit Permit' && srcTypeR=='E-Wallet' )){
								var r = outerPanelForGrid.store.find('SLNOIndex', 6);
								 storeR = outerPanelForGrid.store.getAt(5);
								 if (storeR.data['rateIdIndex'] == "" || storeR.data['rateIdIndex'] == "0") {
						            Ext.example.msg("Please Enter Processing Fee rate");
						            outerPanelForGrid.startEditing(r, 2);
						            return;
						         }
								 var PF = storeR.data['payableIdIndex'];
						         var mwalletBal=Ext.getCmp('mwalletId').getValue();
						         if (parseFloat(mwalletBal) < parseFloat(PF)) {
									 Ext.example.msg("Processing Fee is greater than M-wallet balance.Please Pay the challan");
									 return;
						         }
								 JSON1 += Ext.util.JSON.encode(storeR.data) + ',';
								 }
								 
							 if (JSON1 != '') {
						       JSON1 = JSON1.substring(0, JSON1.length - 1);
						     }
						      json = JSON1;
						   //}
						}
						if ((Ext.getCmp('permittypecomboId').getValue() == 'Rom Transit' || Ext.getCmp('permittypecomboId').getValue() == 'Rom Sale') && Ext.getCmp('desttypeId').getValue()=='ROM'){
                            if (editedRowsForGrid == "" && buttonValue == '<%=Add%>') {
                                Ext.example.msg("Please Enter Exact Grade Details");
                                return;
                            }
                            var tempForGrid = editedRowsForGrid.split(",");
                            for (var i = 0; i < tempForGrid.length; i++) {
                                var row1 = proccessedOreGrid.store.find('SLNOIndex', tempForGrid[i]);
                                if (row1 == -1) {
                                    continue;
                                }
                                var store1 = proccessedOreGrid.store.getAt(row1);
                                if (store1.data['gardeDataIndex'] == "") {
                                    Ext.example.msg("Please Enter Exact Grade");
                                    proccessedOreGrid.startEditing(row1, 2);
                                    return;
                                }
                                if (store1.data['type2IdIndex'] == "") {
                                    Ext.example.msg("Please Select Type");
                                    proccessedOreGrid.startEditing(row1, 3);
                                    return;
                                }
                                if (store1.data['stockTypeIdIndex'] == "") {
	                                 Ext.example.msg("Please Select Stock Location");
	                                 proccessedOreGrid.startEditing(row1, 4);
	                                 return;
                                }
                                if (store1.data['qty2IdIndex'] == "" || store1.data['qty2IdIndex'] == 0) {
                                    Ext.example.msg("Please Enter Quantity");
                                    proccessedOreGrid.startEditing(row1, 5);
                                    return;
                                }
                                if((store1.data['type2IdIndex'] != "Rom")){
                                    Ext.example.msg("Please Select Stock type as Rom");
                                    proccessedOreGrid.startEditing(row1, 3);
                                    return;
                                }
                                if(buttonValue == '<%=Add%>'){
                                    var id = stockTypeCombo.getValue();
                                    stockValue=stockTypeCombo.getRawValue();
                                    
                                    var row = StockTypeStore1.findExact('routeId', id);
                                    var rec = StockTypeStore1.getAt(row);
                                    romQty = rec.data['romQty'];

                                    var qty = store1.data['qty2IdIndex'];
                                    if (parseFloat(romQty) < parseFloat(qty)) {
                                        Ext.example.msg("Quantity should be less than or equals to stock");
                                        return;
                                    }
                                    var processFee = store1.data['totalPfeeIndex'];
                                    var mwalletBalance=Ext.getCmp('mwalletId').getValue();
                                    if (parseFloat(mwalletBalance) < parseFloat(processFee)) {
                                        Ext.example.msg("Processing Fee is greater than M-wallet balance.Please Pay the challan");
                                        return;
                                    }
                                JSON += Ext.util.JSON.encode(store1.data) + ',';
                            }
                            }
                            if (JSON != '') {
                                JSON = JSON.substring(0, JSON.length - 1);
                            }
                            json = JSON;
						}
                        if (Ext.getCmp('permittypecomboId').getValue() == 'Processed Ore Transit' || Ext.getCmp('permittypecomboId').getValue() == 'Domestic Export' || 
                        		Ext.getCmp('permittypecomboId').getValue() == 'International Export' || Ext.getCmp('permittypecomboId').getValue() == 'Processed Ore Sale' ||
                        	 		Ext.getCmp('permittypecomboId').getValue() == 'Processed Ore Sale Transit' ||
                             			Ext.getCmp('permittypecomboId').getValue() == 'Import Permit' || Ext.getCmp('permittypecomboId').getValue() == 'Import Transit Permit' ||
                             				((Ext.getCmp('permittypecomboId').getValue() == 'Rom Transit' || Ext.getCmp('permittypecomboId').getValue() == 'Rom Sale') && Ext.getCmp('desttypeId').getValue()=='ROM') ||
                             				    Ext.getCmp('permittypecomboId').getValue() == 'Purchased Rom Sale Transit Permit') {
                            orgCode = Ext.getCmp('organizationcodeid').getValue();
                        }
                        if (Ext.getCmp('permittypecomboId').getValue() == 'Domestic Export' || Ext.getCmp('importtypecomboId').getValue() == 'Domestic Import') {
                            RomState=Ext.getCmp('stateComboId').getValue();
                        }
                         if (Ext.getCmp('permittypecomboId').getValue() == 'Purchased Rom Sale Transit Permit' || Ext.getCmp('permittypecomboId').getValue() == 'Rom Sale' || Ext.getCmp('permittypecomboId').getValue() == 'Processed Ore Sale Transit') {
                            RomState=Ext.getCmp('stateComboId1').getValue();
                        }
                        if(Ext.getCmp('permitreqtypecomboId').getValue()=='Permit Request on existing Request'){
                           challanId=challanID;
                        }else{
	                        if(Ext.getCmp('permittypecomboId').getValue() == 'Bauxite Transit'){
	                           challanId=Ext.getCmp('BuChallancomboId').getValue();
	                        }else{
	                           challanId=Ext.getCmp('RefcomboId').getValue();
	                        }
                        }
                        if(Ext.getCmp('permittypecomboId').getValue() == 'Purchased Rom Sale Transit Permit'){
                          permitIDD=Ext.getCmp('romPermitId').getValue();
                        }else{
                          permitIDD=Ext.getCmp('importedPermitId').getValue();
                        }
                      
                        var rec;
                        var route;
                        var country;
                        var state;
                        var state1;
                        var orgCodeModify;
                        var buyingOrgIdmodify;
                        var Status;
                        if (buttonValue == 'Modify') {
                            var selected = grid.getSelectionModel().getSelected();
                            id = selected.get('uniqueidDataIndex');
                            orgCodeModify=selected.get('organizationIdDataIndex');
                            Status=selected.get('statusDataIndex');
                            var route = selected.get('routeDataIndex');
                            if (selected.get('routeIdDataIndex') != Ext.getCmp('routeidcomboId').getValue()) {
                                route = Ext.getCmp('routeidcomboId').getValue();
                            } else {
                                route = selected.get('routeDataIndex');
                            }
                            if (Ext.getCmp('permittypecomboId').getValue() == 'International Export' || Ext.getCmp('importtypecomboId').getValue() == 'International Import') {
                            if (selected.get('countryNameDataIndex') != Ext.getCmp('countryComboId').getValue()) {
                                country = Ext.getCmp('countryComboId').getValue();
                            } else {
                                country = selected.get('countryIdDataIndex');
                            }
                            }
                            if (Ext.getCmp('permittypecomboId').getValue() == 'Domestic Export' || Ext.getCmp('importtypecomboId').getValue() == 'Domestic Import') {
                            if (selected.get('stateNameDataIndex') != Ext.getCmp('stateComboId').getValue()) {
                                state = Ext.getCmp('stateComboId').getValue();
                            } else {
                                state = selected.get('stateIdDataIndex');
                            }
                            }
                            if (Ext.getCmp('permittypecomboId').getValue() == 'Purchased Rom Sale Transit Permit'  || Ext.getCmp('permittypecomboId').getValue() == 'Processed Ore Sale' || Ext.getCmp('permittypecomboId').getValue() == 'Rom Sale' || Ext.getCmp('permittypecomboId').getValue() == 'Processed Ore Sale Transit') {
                            
                            if (selected.get('buyingOrgNameDataIndex') != Ext.getCmp('buyingOrgComboId').getValue()) {
                                buyingOrgIdmodify = Ext.getCmp('buyingOrgComboId').getValue();
                            } else {
                                buyingOrgIdmodify = selected.get('buyingOrgIdDataIndex');
                            }
                            if (selected.get('countryNameDataIndex') != Ext.getCmp('countryComboId').getValue()) {
                                country = Ext.getCmp('countryComboId').getValue();
                            } else {
                                country = selected.get('countryIdDataIndex');
                            }
                             if (selected.get('stateNameDataIndex') != Ext.getCmp('stateComboId1').getValue()) {
                                state = Ext.getCmp('stateComboId1').getValue();
                            } else {
                                state = selected.get('stateIdDataIndex');
                            }
                            }
                        }
                        if (buttonValue == 'Modify') {
                        routeMasterOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=AddorModifyPermitDetails',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId: Ext.getCmp('custcomboId').getValue(),
                                date: Ext.getCmp('dateid').getValue(),
                                finyear: Ext.getCmp('finyearId').getValue(),
                                permitreq: Ext.getCmp('permitreqtypecomboId').getValue(),
                                ownertype: Ext.getCmp('ownertypecomboId').getValue(),
                                permittype: Ext.getCmp('permittypecomboId').getValue(),
                                tcid: Ext.getCmp('TccomboId').getValue(),
                                minecode: Ext.getCmp('minecodeId').getValue(),
                                leasename: Ext.getCmp('leaseNameid').getValue(),
                                leaseowner: Ext.getCmp('leaseOwnerid').getValue(),
                                orgname: Ext.getCmp('organizationid').getValue(),
                                mineral: Ext.getCmp('mineralcomboId').getValue(),
                                routeid: Ext.getCmp('routeidcomboId').getValue(),
                                fromloc: Ext.getCmp('fromlocId').getValue(),
                                toloc: Ext.getCmp('tolocId').getValue(),
                                challanid: challanId,
                                startdate: Ext.getCmp('startdateid').getValue(),
                                enddate: Ext.getCmp('enddateid').getValue(),
                                remarks: Ext.getCmp('remarksid').getValue(),
                                CustName: Ext.getCmp('custcomboId').getRawValue(),
                                applicationno: Ext.getCmp('applicationid').getRawValue(),
                                selectedRoute: route,
                                Id: id,
                                orgCode: orgCode,
                                json: json,
                                countryModify: country,
                                country: Ext.getCmp('countryComboId').getValue(),
                                buyer: Ext.getCmp('buyerId').getValue(),
                                ship: Ext.getCmp('shipId').getValue(),
                                state: RomState,
                                stateModify: state,
                                orgCodeModify: orgCodeModify,
                                buyingOrgId: Ext.getCmp('buyingOrgComboId').getValue(),
                                buyingOrgIdmodify: buyingOrgIdmodify,
                                stockName: stockValue,
                                vesselName: Ext.getCmp('vesselNameId').getValue(),
                                importType: Ext.getCmp('importtypecomboId').getValue(),
                                importPurpose: Ext.getCmp('importpurposecomboId').getValue(),
                                exportPermitNo: Ext.getCmp('exportPermitNoId').getValue(),
                                exportPermitDate: Ext.getCmp('exportPermitDateId').getValue(),
                                exportChallanNo: Ext.getCmp('exportChallanNoId').getValue(),
                                exportChallanDate: Ext.getCmp('exportChallanDateId').getValue(),
                                saleInvoiceNo: Ext.getCmp('saleInvoiceNoId').getValue(),
                                saleInvoiceDate: Ext.getCmp('saleInvoiceDateId').getValue(),
                                transportnType: Ext.getCmp('transportnTypecomboId').getValue(),
                                ImporteiPermitId: permitIDD,
                                status:Status,
                                hubId: Ext.getCmp('hubId').getValue(),
                                TcorgId : TcorgId,
                                toLocation : Ext.getCmp('toLocationId').getValue(),
                                destType: Ext.getCmp('desttypeId').getValue()
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                if(message=="0"){
			                       message="Error in updating Permit Details";
			                       Ext.example.msg(message);
		                     	}else if(message>0){
		                     	   window.open(basePath+"/PermitPDF?autoGeneratedKeys=" + message+"&buttonType="+buttonValue);
			                       message="Permit Updated Successfully";
			                       Ext.example.msg(message);
		                     	}
                                loadMask.hide();
                                Ext.getCmp('dateid').reset(),
                                Ext.getCmp('finyearId').reset(),
                                Ext.getCmp('permitreqtypecomboId').reset(),
                                Ext.getCmp('ownertypecomboId').reset(),
                                Ext.getCmp('permittypecomboId').reset(),
                                Ext.getCmp('TccomboId').reset(),
                                Ext.getCmp('minecodeId').reset(),
                                Ext.getCmp('leaseNameid').reset(),
                                Ext.getCmp('leaseOwnerid').reset(),
                                Ext.getCmp('organizationid').reset(),
                                Ext.getCmp('mineralcomboId').reset(),
                                Ext.getCmp('routeidcomboId').reset(),
                                Ext.getCmp('fromlocId').reset(),
                                Ext.getCmp('tolocId').reset(),
                                Ext.getCmp('RefcomboId').reset(),
                                Ext.getCmp('BuChallancomboId').reset(),
                                Ext.getCmp('startdateid').reset(),
                                Ext.getCmp('enddateid').reset(),
                                Ext.getCmp('remarksid').reset(),
                                Ext.getCmp('applicationid').reset(),
                                Ext.getCmp('shipId').reset(),
                                Ext.getCmp('countryComboId').reset(),
                                Ext.getCmp('buyerId').reset(),
                                Ext.getCmp('importtypecomboId').reset(),
                                Ext.getCmp('importpurposecomboId').reset(),
                                
                                Ext.getCmp('importedPermitId').reset(),
                                Ext.getCmp('vesselNameId').reset(),
                                Ext.getCmp('exportPermitNoId').reset(),
                                Ext.getCmp('exportPermitDateId').reset(),
                                Ext.getCmp('exportChallanNoId').reset(),
                                Ext.getCmp('exportChallanDateId').reset(),
                                Ext.getCmp('saleInvoiceNoId').reset(),
                                Ext.getCmp('saleInvoiceDateId').reset(),
                                Ext.getCmp('transportnTypecomboId').reset(),
                                Ext.getCmp('hubId').reset(),
                                Ext.getCmp('romPermitId').reset();
						        Ext.getCmp('toLocationId').reset();
						        Ext.getCmp('desttypeId').reset();
                                previewWin.hide();
                                myWin.hide();
                                routeMasterOuterPanelWindow.getEl().unmask();
                                store.reload();     
                                organizationCodeStore.load({
			                        params: {
			                            CustId: custId
			                        }
			                    });
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                loadMask.hide();
                                store.reload();
                                previewWin.hide();
                                myWin.hide();
                            }
                        });
                        }else{
                       		Ext.getCmp('AppNoTxtId').setText(Ext.getCmp('applicationid').getValue());
                       		Ext.getCmp('dateDateId').setText(Ext.getCmp('dateid').getValue().toLocaleDateString('en-GB'));
                       		Ext.getCmp('FinanYearTxtId').setText(Ext.getCmp('finyearId').getValue());
                       		Ext.getCmp('permtTypeTxtId').setText(Ext.getCmp('permittypecomboId').getRawValue());
                       		Ext.getCmp('impPrmtTypeTxtId').setText(Ext.getCmp('importtypecomboId').getRawValue());
                       		Ext.getCmp('prpsOfImpTxtId').setText(Ext.getCmp('importpurposecomboId').getRawValue());
                       		Ext.getCmp('tcN0TxtId').setText(Ext.getCmp('TccomboId').getRawValue());
                       		Ext.getCmp('MineCodTxtId').setText(Ext.getCmp('minecodeId').getValue());
                       		Ext.getCmp('leaseNamTxtId').setText(Ext.getCmp('leaseNameid').getValue());
                       		Ext.getCmp('leaseOwnTxtId').setText(Ext.getCmp('leaseOwnerid').getValue());
                       		Ext.getCmp('orgNamTxtId').setText(Ext.getCmp('organizationcodeid').getRawValue());
                       		Ext.getCmp('orgCodTxtId').setText(Ext.getCmp('organizationid').getValue());
                       		Ext.getCmp('M-walBalTxtId').setText(Ext.getCmp('mwalletId').getValue());
                       		Ext.getCmp('RSPrmtTxtId').setText(Ext.getCmp('romPermitId').getRawValue());
                       		Ext.getCmp('to_LocTxtId').setText(Ext.getCmp('toLocationId').getValue());
                       		Ext.getCmp('buyOrgNamTxtId').setText(Ext.getCmp('buyingOrgComboId').getRawValue());
                       		Ext.getCmp('buyOrgCodTxtId').setText(Ext.getCmp('buyingOrgCodeid').getValue());
                       		Ext.getCmp('owneTypeTxtId').setText(Ext.getCmp('ownertypecomboId').getRawValue());
                       		Ext.getCmp('mineralTxtId').setText(Ext.getCmp('mineralcomboId').getRawValue());
                       		Ext.getCmp('impPrmtNoTxtId').setText(Ext.getCmp('importedPermitId').getRawValue());
                       		Ext.getCmp('expPrmtNoTxtId').setText(Ext.getCmp('exportPermitNoId').getValue());
                       		if(Ext.getCmp('exportPermitDateId').getValue()!="")
                       		Ext.getCmp('expPrmtDatTxtId').setText(Ext.getCmp('exportPermitDateId').getValue().toLocaleDateString('en-GB'));
                       		Ext.getCmp('expChalNoTxtId').setText(Ext.getCmp('exportChallanNoId').getValue());
                       		if(Ext.getCmp('exportChallanDateId').getValue()!="")
                       		Ext.getCmp('expChalDatTxtId').setText(Ext.getCmp('exportChallanDateId').getValue().toLocaleDateString('en-GB'));
                       		Ext.getCmp('saleInvoiceNoTxtId').setText(Ext.getCmp('saleInvoiceNoId').getValue());
                       		if(Ext.getCmp('saleInvoiceDateId').getValue()!="")
                       		Ext.getCmp('saleInvoiceDatTxtId').setText(Ext.getCmp('saleInvoiceDateId').getValue().toLocaleDateString('en-GB'));
                       		Ext.getCmp('TransportTypeTxtId').setText(Ext.getCmp('transportnTypecomboId').getValue());
                       		Ext.getCmp('sourceTypeTxtId').setText(Ext.getCmp('desttypeId').getValue());
                       		Ext.getCmp('sourceHubTxtId').setText(Ext.getCmp('hubId').getRawValue());
                       		Ext.getCmp('routeTxtId').setText(Ext.getCmp('routeidcomboId').getRawValue());
                       		Ext.getCmp('fromLocTxtId').setText(Ext.getCmp('fromlocId').getValue());
                       		Ext.getCmp('toLocTxtId').setText(Ext.getCmp('tolocId').getValue());
                       		Ext.getCmp('refTxtId').setText(Ext.getCmp('RefcomboId').getRawValue());
                       		Ext.getCmp('bauxChalTxtId').setText(Ext.getCmp('BuChallancomboId').getRawValue());
                       		Ext.getCmp('startDatTxtId').setText(Ext.getCmp('startdateid').getValue().toLocaleDateString('en-GB'));
                       		Ext.getCmp('endDatTxtId').setText(Ext.getCmp('enddateid').getValue().toLocaleDateString('en-GB'));
                       		Ext.getCmp('buyerNamTxtId').setText(Ext.getCmp('buyerId').getValue());
                       		Ext.getCmp('countryTxtId').setText(Ext.getCmp('countryComboId').getRawValue());
                       		if(Ext.getCmp('stateComboId1').getRawValue()!=""){
                       		Ext.getCmp('stateTxtId').setText(Ext.getCmp('stateComboId1').getRawValue());
                       		}else{
                       		Ext.getCmp('stateTxtId').setText(Ext.getCmp('stateComboId').getRawValue());
                       		}
                       		if(Ext.getCmp('shipId').getRawValue()!=""){
                       		Ext.getCmp('vesselNamTxtId').setText(Ext.getCmp('shipId').getRawValue());
                       		}else{
                       		Ext.getCmp('vesselNamTxtId').setText(Ext.getCmp('vesselNameId').getValue());
                       		}
                       		Ext.getCmp('remarksTxtId').setText(Ext.getCmp('remarksid').getValue());
                       		
                       		if(((Ext.getCmp('permittypecomboId').getValue() == 'Rom Transit' || Ext.getCmp('permittypecomboId').getValue() == 'Rom Sale' )&& Ext.getCmp('desttypeId').getValue()=='E-Wallet') || (Ext.getCmp('permittypecomboId').getValue() == 'Purchased Rom Sale Transit Permit' && srcTypeR=='E-Wallet')){
                       		    var qty = storeR.data['qtyIdIndex'];
								var pf = storeR.data['rateIdIndex'];
								var tpf = storeR.data['payableIdIndex'];
	                            Ext.getCmp('QuantityTxtId').setText(qty);
	                            Ext.getCmp('processFeeTxtId').setText(pf);
	                            Ext.getCmp('totalProcessFeeTxtId').setText(tpf);
                       		}else{
                       			Ext.getCmp('exactGradeTxtId').setText(Ext.getCmp('remarks').getValue());
	                            Ext.getCmp('gardeTypeTxtId').setText(Ext.getCmp('grdecomboId').getRawValue());
	                            Ext.getCmp('stockLocTxtId').setText(Ext.getCmp('stockcomboId').getRawValue());
	                            Ext.getCmp('QuantityTxtId').setText(Ext.getCmp('qty2Id').getValue());
                           
	                            //pfff=proccessedOreGrid.getSelectionModel().getSelected().get('processingFeeIndex');
	                            var storeP = proccessedOreGrid.store.getAt(0);
	                            pfff=storeP.data['processingFeeIndex'];
	                            Ext.getCmp('processFeeTxtId').setText(pfff); 
	                            
	                            if(Ext.getCmp('qty2Id').getValue()==""){
	                            Ext.getCmp('exactGradeTxtId').setText(storeP.data['gardeDataIndex']);
	                            Ext.getCmp('gardeTypeTxtId').setText(storeP.data['type2IdIndex']);
	                            Ext.getCmp('stockLocTxtId').setText(storeP.data['stockTypeIdIndex']);
	                            Ext.getCmp('QuantityTxtId').setText(storeP.data['qty2IdIndex']);
		                            Ext.getCmp('totalProcessFeeTxtId').setText(storeP.data['qty2IdIndex']*parseFloat(pfff).toFixed(2));
		                        }else{
		                            Ext.getCmp('totalProcessFeeTxtId').setText((parseFloat(Ext.getCmp('qty2Id').getValue())*parseFloat(pfff)).toFixed(2));
		                        }
	                           // Ext.getCmp('totalProcessFeeTxtId').setText((parseFloat(Ext.getCmp('qty2Id').getValue())*parseFloat(pfff)).toFixed(2));
                       		}
                       	   previewWin.show();
						   previewWinPanel.show();
                       }
                    }
                }
            }
        }, {
            xtype: 'button',
            text: '<%=Cancel%>',
            id: 'canButtId',
            cls: 'buttonstyle',
            iconCls: 'cancelbutton',
            width: 70,
            listeners: {
                click: {
                    fn: function() {
                    	previewWin.hide();
                        myWin.hide();
                    }
                }
            }
        }]
    });
    var innerPanelForDates = new Ext.form.FormPanel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: true,
        height: 300,
        width: 500,
        frame: false,
        id: 'innerPanelForDatesId',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [{
            xtype: 'fieldset',
            title: 'Dates',
            cls: 'fieldsetpanel',
            autoScroll: true,
            collapsible: false,
            id: 'PermitclId',
            width: 450,
            height: 290,
            layout: 'table',
            layoutConfig: {
                columns: 4
            },
            items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'ml1'
            }, {
                xtype: 'label',
                text: '<%=Date%>' + '  :',
                cls: 'labelstyle',
                id: 'pdl1'
            },{height:35,width:30,hidden:true}, {
            	xtype: 'datefield',
                cls: 'selectstylePerfect',
                id: 'mdateid1',
                readOnly: true,
                format: getDateFormat(),
                allowBlank: true,
                blankText: '<%=Enter_Date%>',
                submitFormat: getDateFormat(),
                labelSeparator: '',
                value: dtcur
           	},{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'ml2'
            }, {
                xtype: 'label',
                text: '<%=Start_Date%>' + '  :',
                cls: 'labelstyle',
                id: 'pdl2'
            },{height:35,width:30,hidden:true}, {
            	xtype: 'datefield',
                cls: 'selectstylePerfect',
                id: 'mdateid2',
                readOnly: true,
                format: getDateFormat(),
                allowBlank: true,
                blankText: '<%=Enter_Date%>',
                submitFormat: getDateFormat(),
                labelSeparator: '',
                value: dtcur
           	},{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'ml3'
            }, {
                xtype: 'label',
                text: '<%=End_Date%>' + '  :',
                cls: 'labelstyle',
                id: 'pdl3'
            },{height:35,width:30,hidden:true}, {
            	xtype: 'datefield',
                cls: 'selectstylePerfect',
                id: 'mdateid3',
                format: getDateFormat(),
                allowBlank: true,
                blankText: '<%=Enter_Date%>',
                submitFormat: getDateFormat(),
                labelSeparator: '',
                value: dtcur
           	},{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'vesselModLable'
            }, {
                xtype: 'label',
                text: 'Vessel Name' + '  :',
                cls: 'labelstyle',
                id: 'labelV'
            },{height:35,width:30,hidden:true}, vesselNameComboForApp,
            {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'm30'
            }, {
                xtype: 'label',
                text: 'Buyer Name' + '  :',
                cls: 'labelstyle',
                id: 'buyerModLab'
            },{height:35,width:30,hidden:true}, {
            	xtype: 'textfield',
                cls: 'selectstylePerfect',
                id: 'buyerModId',
                allowBlank: true,
                blankText: 'Enter Buyer Name',
                labelSeparator: '',
                listeners: { change: function(f,n,o){ //restrict 100
				 if(f.getValue().length> 100){ Ext.example.msg("Field reached it's Maximum Size"); 
					f.setValue(n.substr(0,100)); f.focus(); }
				 } },
           	},{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'm31'
            }, {
                xtype: 'label',
                text: 'Exact Grade' + '  :',
                cls: 'labelstyle',
                id: 'exactGradeModLab'
            },{height:35,width:30,hidden:true}, {
            	xtype: 'textfield',
                cls: 'selectstylePerfect',
                id: 'gradeModId',
                allowBlank: true,
                blankText: 'Enter Exact Grade',
                labelSeparator: '',
                listeners: { change: function(f,n,o){ //restrict 50
				 if(f.getValue().length> 50){ Ext.example.msg("Field reached it's Maximum Size"); 
					f.setValue(n.substr(50)); f.focus(); }
				 } },
           	},{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'ml14'
            }, {
                xtype: 'label',
                text: 'Remarks' + '  :',
                cls: 'labelstyle',
                id: 'remarksss'
            },{height:35,width:30,hidden:true}, {
            	xtype: 'textarea',
                cls: 'selectstylePerfect',
                id: 'remarksModifyId',
                allowBlank: true,
                blankText: 'Enter Remarks',
                labelSeparator: '',
                listeners: { change: function(f,n,o){ //restrict 500
				 if(f.getValue().length> 500){ Ext.example.msg("Field reached it's Maximum Size"); 
					f.setValue(n.substr(0,500)); f.focus(); }
				 } },
           	}]
        }]
    });
    
    var innerWinButtonPanel1 = new Ext.Panel({
        id: 'innerWinButtonPanelId1',
        standardSubmit: true,
        collapsible: false,
        autoHeight: true,
        cls: 'windowbuttonpanel',
        frame: false,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        buttons: [{
            xtype: 'button',
            text: 'Close',
            id: 'closeButtonId1',
            cls: 'buttonstyle',
            iconCls: 'closebutton',
            width: 70,
            listeners: {
                click: {
                    fn: function() {
                        if (Ext.getCmp('permittypeCloseId').getValue() == "") {
                            Ext.example.msg("<%=Select_Permit_Type%>");
                            Ext.getCmp('permittypeCloseId').focus();
                            return;
                        }
                         if(Ext.getCmp('permittypeCloseId').getValue()=='Rom Sale'){
                        	 if (Ext.getCmp('newsourcecomboId').getValue() == "") {
	                            Ext.example.msg("Select Source type");
	                            Ext.getCmp('newsourcecomboId').focus();
	                            return;
	                        }
	                        }
                       if(Ext.getCmp('permittypeCloseId').getValue()=='Rom Transit' ||( Ext.getCmp('permittypeCloseId').getValue()=='Rom Sale' && Ext.getCmp('newsourcecomboId').getValue()=='E-Wallet')|| Ext.getCmp('permittypeCloseId').getValue()=='Bauxite Transit'){
                          if (Ext.getCmp('TccomboId1').getValue() == "") {
                            Ext.example.msg("<%=Select_TC_Number%>");
                            Ext.getCmp('TccomboId1').focus();
                            return;
                          }
                       }else{
                          if (Ext.getCmp('organizationcodeCloseid').getValue() == "") {
                            Ext.example.msg("<%=Select_OrganisationTrader_Code%>");
                            Ext.getCmp('organizationcodeCloseid').focus();
                            return;
                          }
                       }
	                    if(Ext.getCmp('permittypeCloseId').getValue()=='International Export'){
	                    if (Ext.getCmp('vesselNameClose').getValue() == "") {
	                       	Ext.example.msg("Select Vessel Name");
                            Ext.getCmp('vesselNameClose').focus();
                            return;
	                    }
	                    }
                        if (Ext.getCmp('PermitNocomboId').getValue() == "") {
                            Ext.example.msg("<%=Select_Permit_No%>");
                            Ext.getCmp('PermitNocomboId').focus();
                            return;
                        }
                        if (Ext.getCmp('closedqtyId').getValue() == "") {
                            Ext.example.msg("<%=Enter_Closed_Qty%>");
                            Ext.getCmp('closedqtyId').focus();
                            return;
                        }
                        if (Ext.getCmp('permittypeCloseId').getValue() == "Purchased Rom Sale Transit Permit" && parseFloat(Ext.getCmp('qtydeductionId').getValue())>0) {
                            Ext.example.msg("The permit is already used, cannot close the permit");
                            Ext.getCmp('permittypeCloseId').focus();
                            return;
                        }
                        if (parseFloat(Ext.getCmp('closedqtyId').getValue()) < parseFloat(Ext.getCmp('qtydeductionId').getValue())) {
                            Ext.example.msg("Enter closed qty greater than Or equals to Tripsheet Qty");
                            Ext.getCmp('closedqtyId').focus();
                            return;
                        }
                        if((Ext.getCmp('permittypeCloseId').getValue()=='Rom Transit' && srcTypeClose=='E-Wallet') ){
                           if (parseFloat(Ext.getCmp('qtydeductionId').getValue()) > parseFloat(Ext.getCmp('romQuantityid').getValue())) {
                            Ext.example.msg("Rom qty is less than closed qty");
                            Ext.getCmp('closedqtyId').focus();
                            return;
                        }
                        if (parseFloat(Ext.getCmp('romQuantityid').getValue()) > parseFloat(Ext.getCmp('qtyId').getValue())) {
                            Ext.example.msg("Enter rom qty less than Or equals to Permit Qty");
                            Ext.getCmp('closedqtyId').focus();
                            return;
                        }
                        }
                        if (parseFloat(Ext.getCmp('closedqtyId').getValue()) > parseFloat(Ext.getCmp('qtyId').getValue())) {
                            Ext.example.msg("Enter closed qty less than Or equals to Permit Qty");
                            Ext.getCmp('closedqtyId').focus();
                            return;
                        }
                        if(parseFloat(Ext.getCmp('qtydeductionId').getValue())==0){
                          if (Ext.getCmp('refundId').getValue() == "") {
                            Ext.example.msg("Select Processing Fee Amount");
                            Ext.getCmp('refundId').focus();
                            return;
                        	}
                        }
                        myWin1.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=ClosePermitClosureDetails',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId: Ext.getCmp('custcomboId').getValue(),
                                tcid: Ext.getCmp('TccomboId1').getValue(),
                                minecode: Ext.getCmp('minecodeId1').getValue(),
                                leasename: Ext.getCmp('leaseNameid1').getValue(),
                                leaseowner: Ext.getCmp('leaseOwnerid1').getValue(),
                                orgname: Ext.getCmp('organizationid1').getValue(),
                                permitno: Ext.getCmp('PermitNocomboId').getValue(),
                                permitdate: Ext.getCmp('permitdateId').getValue(),
                                permitQty: Ext.getCmp('qtyId').getValue(),
                                tsQty: Ext.getCmp('qtydeductionId').getValue(),
                                romQty: Ext.getCmp('romQuantityid').getValue(),
                                closedqty: Ext.getCmp('closedqtyId').getValue(),
                                permitName : Ext.getCmp('PermitNocomboId').getRawValue(),
                                romAmt : romAmt,
                                totalPayableRom: totalPayableRom,
						        eWalletAmt : eWalletAmt,
						        eWalletQty : eWalletQty,
						        orgCode: Ext.getCmp('organizationcodeCloseid').getValue(),
						        srcTypeClose : srcTypeClose,
						        mineralType : mineralType,
						        processingFee: processingFee,
						        refundType: Ext.getCmp('refundId').getValue()
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                myWin1.getEl().unmask();
                                Ext.getCmp('TccomboId1').reset(),
                                Ext.getCmp('minecodeId1').reset(),
                                Ext.getCmp('leaseNameid1').reset(),
                                Ext.getCmp('leaseOwnerid1').reset(),
                                Ext.getCmp('organizationid1').reset(),
                                Ext.getCmp('PermitNocomboId').reset(),
                                Ext.getCmp('permitdateId').reset(),
                                Ext.getCmp('qtyId').reset(),
                                Ext.getCmp('qtydeductionId').reset(),
                                Ext.getCmp('closedqtyId').reset(),
                                Ext.getCmp('romQuantityid').reset(),
                                Ext.getCmp('permittypeCloseId').reset(),
                                Ext.getCmp('organizationcodeCloseid').reset(),
                                Ext.getCmp('refundId').reset(),
                                myWin1.hide();
                             	store.reload();
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                store.reload();
                                myWin1.hide();
                                myWin1.getEl().unmask();
                            }
                        });
                    }
                }
            }
        }, {
            xtype: 'button',
            text: '<%=Cancel%>',
            id: 'canButtId1',
            cls: 'buttonstyle',
            iconCls: 'cancelbutton',
            width: 70,
            listeners: {
                click: {
                    fn: function() {
                        myWin1.hide();
                    }
                }
            }
        }]
    });
    var dateWinButtonPanel = new Ext.Panel({
        id: 'dateWinButtonPanelId',
        standardSubmit: true,
        collapsible: false,
        autoHeight: true,
        cls: 'windowbuttonpanel',
        frame: false,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        buttons: [{
            xtype: 'button',
            text: 'Save',
            id: 'saveButtonId2',
            cls: 'buttonstyle',
            iconCls: 'savebutton',
            width: 70,
            listeners: {
                click: {
                    fn: function() {
                     var selected = grid.getSelectionModel().getSelected();
                      if(Ext.getCmp('mdateid1').getValue()==''){
                    	   Ext.example.msg("Select Date");
                           Ext.getCmp('mdateid1').focus();
                           return;
                      }
                      if (dateCompareForStartDate(Ext.getCmp('mdateid1').getValue(), Ext.getCmp('mdateid2').getValue()) == -1) {
                           Ext.example.msg("Start date should be greater than Permit date");
                           Ext.getCmp('mdateid2').focus();
                           return;
                      }
                      if (dateCompare(Ext.getCmp('mdateid2').getValue(), Ext.getCmp('mdateid3').getValue()) == -1) {
                          Ext.example.msg("End date should be greater than Start date");
                          Ext.getCmp('mdateid3').focus();
                          return;
                      }
                      if(selected.get('permitTypeIndex')=='International Export'){
                      	if (Ext.getCmp('vesselNameModify').getValue()=="") {
                           Ext.example.msg("Select Vessel Name");
                           Ext.getCmp('vesselNameModify').focus();
                           return;
                        }
                      }
                      if(selected.get('permitTypeIndex')=='International Export' || selected.get('permitTypeIndex')=='Domestic Export'){
                       if (Ext.getCmp('buyerModId').getValue()=="") {
                           Ext.example.msg("Enter Buyer Name");
                           Ext.getCmp('buyerModId').focus();
                           return;
                        }
                      }
                      if(selected.get('permitTypeIndex')!='Rom Transit' && selected.get('permitTypeIndex')!='Rom Sale' && selected.get('permitTypeIndex')!='Purchased Rom Sale Transit Permit'){
                      	if (Ext.getCmp('gradeModId').getValue()=="") {
                           Ext.example.msg("Enter Grade");
                           Ext.getCmp('gradeModId').focus();
                           return;
                        }
                      }
                      if(Ext.getCmp('remarksModifyId').getValue()==''){
                    	   Ext.example.msg("Enter Remarks");
                           Ext.getCmp('remarksModifyId').focus();
                           return;
                      }
                        id = selected.get('uniqueidDataIndex');
                        permitTypeMod = selected.get('permitTypeIndex');
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=approvedPermitDatesModify',
                            method: 'POST',
                            params: {
                            	id: id,
                            	date: Ext.getCmp('mdateid1').getValue(),
                            	startdate: Ext.getCmp('mdateid2').getValue(),
                                enddate: Ext.getCmp('mdateid3').getValue(),
                                remarks: Ext.getCmp('remarksModifyId').getValue(),
                                vessel : Ext.getCmp('vesselNameModify').getValue(),
                                buyer : Ext.getCmp('buyerModId').getValue(),
                                grade : Ext.getCmp('gradeModId').getValue(),
                                permitType : permitTypeMod
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                if(message>0){
                                	window.open("<%=request.getContextPath()%>/PermitPDF?autoGeneratedKeys="+message+"&buttonType="+buttonValue);
                                	Ext.example.msg("Permit Details Saved Successfully");
                                }else{
                                	message="Error in Saving Permit Details or You cant change vessel name as permit is already used";
                                	Ext.example.msg(message);
                                }
                                Ext.getCmp('mdateid1').reset(),
                                Ext.getCmp('mdateid2').reset(),
                                Ext.getCmp('mdateid3').reset(),
                                Ext.getCmp('remarksModifyId').reset(),
                                Ext.getCmp('vesselNameModify').reset(),
                                Ext.getCmp('buyerModId').reset(),
                                Ext.getCmp('gradeModId').reset(),
                                dateWin.hide();
                                store.reload();
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                store.reload();
                                dateWin.hide();
                            }
                        });
                    }
                }
            }
        }, {
            xtype: 'button',
            text: '<%=Cancel%>',
            id: 'canButtId2',
            cls: 'buttonstyle',
            iconCls: 'cancelbutton',
            width: 70,
            listeners: {
                click: {
                    fn: function() {
                        dateWin.hide();
                    }
                }
            }
        }]
    });
    
    var routeMasterOuterPanelWindow = new Ext.Panel({
        cls: 'outerpanelwindow',
        standardSubmit: true,
        id: 'radiocasewinpanelId',
        frame: true,
        height: 540,
        width: 1320,
        items: [caseInnerPanel, innerWinButtonPanel]
    });

    myWin = new Ext.Window({
        title: titelForInnerPanel,
        closable: false,
        resizable: false,
        modal: true,
        autoScroll: false,
        height: 540,
        width: 1320,
        id: 'myWin',
        items: [routeMasterOuterPanelWindow]
    });
    myWin1 = new Ext.Window({
        title: titelForInnerPanel,
        closable: false,
        resizable: false,
        modal: true,
        autoScroll: false,
        height: 450,
        width: 470,
        id: 'myWin1',
        items: [innerPanelForPermitClosure, innerWinButtonPanel1]
    });
    dateWin = new Ext.Window({
        title: 'Modify Permit Dates',
        closable: false,
        resizable: false,
        modal: true,
        autoScroll: false,
        height: 400,
        width: 470,
        id: 'dateWinId',
        items: [innerPanelForDates, dateWinButtonPanel]
    });

	function importExcelData(){
		getordreport('xls','All',jspName,grid,exportDataType);
	}
	function dateCompareForStartDate(fromDate, toDate) {
	if(fromDate < toDate) {
	return 1;
	} else if(toDate < fromDate) {
	return -1;
	}
	return 0;
	}

    function verifyFunction() {
        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("<%=SelectCustomerName%>");
            Ext.getCmp('custcomboId').focus();
            return;
        }
        if (grid.getSelectionModel().getCount() > 1) {
            Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }
        if (grid.getSelectionModel().getSelected() == null) {
            Ext.example.msg("No Records Found");
            Ext.getCmp('custcomboId').focus();
            return;
        }
        buttonValue = "acknowledge";
        var selected = grid.getSelectionModel().getSelected();

        status = selected.get('statusDataIndex');
        if (status == 'APPROVED' || status == 'ACKNOWLEDGED') {
            Ext.example.msg("Record Already Approved");
        }
        if (status == 'OPEN' || status == 'MODIFIED') {
            Ext.example.msg("Please Submit Before Approve");
        }
        if(status == 'CLOSE' || status == 'CANCEL'){
            Ext.example.msg("Record either Closed or Cancelled");
        }
        if (status == 'INACTIVE') {
            Ext.example.msg("Record is Inactive");
        }
        if (status == 'PENDING APPROVAL' || status == 'MODIFIED-SUBMIT') {
            Ext.MessageBox.show({
                title: '',
                msg: 'Are you sure you want to Approve?',
                buttons: Ext.MessageBox.YESNO,
                icon: Ext.MessageBox.QUESTION,
                fn: function(btn) {
                    if (btn == 'yes') {
                        var selected = grid.getSelectionModel().getSelected();
                        permitNo = selected.get('permitNoDataIndex');
                        status = selected.get('statusDataIndex');
                        permitId=selected.get('uniqueidDataIndex');
                        routeId=selected.get('routeDataIndex');
                        buyOrgId=selected.get('buyingOrgIdDataIndex');
                        mineralType=selected.get('mineralDataIndex');
                        impPermitId=selected.get('ExtpermitIdDataIndex');
                        sourceHubId=selected.get('hubIdIndex');
                        sourceT=selected.get('destTypeDataIndex');
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=acknowledgeStatus',
                            method: 'POST',
                            params: {
                                permitNo: permitNo,
                                CustID: Ext.getCmp('custcomboId').getValue(),
                                status: status,
                                permitId: permitId,
                                routeId: routeId,
                                buyOrgId: buyOrgId,
                                mineralType: mineralType,
                                impPermitId: impPermitId,
                                sourceHubId: sourceHubId,
                                sourceT: sourceT
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                store.reload();
                            },
                            failure: function() {
                                Ext.example.msg("Error");

                            }
                        });
                    }
                }
            });
        }
    }
    function saveDate() {
        var selected = grid.getSelectionModel().getSelected();
        if (grid.getSelectionModel().getCount() > 1) {
           Ext.example.msg("<%=SelectSingleRow%>");
           return;
       }
        status = selected.get('statusDataIndex');
        if (status != 'APPROVED' && status != 'ACKNOWLEDGED' && status != 'CLOSE' && status != 'CANCEL') {
            Ext.example.msg("Please Approve before taking PDF");
            return;
        }
        var id = selected.get('uniqueidDataIndex');
        window.open("<%=request.getContextPath()%>/PermitPDF?autoGeneratedKeys=" + id+"&buttonType="+"default");
    }

    function copyData() {
        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("<%=SelectCustomerName%>");
            Ext.getCmp('custcomboId').focus();
            return;
        }
        if (grid.getSelectionModel().getCount() > 1) {
            Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }

        if (grid.getSelectionModel().getSelected() == null) {
            Ext.example.msg("<%=NoRecordsFound%>");
            Ext.getCmp('custcomboId').focus();
            return;
        }
        buttonValue = "finalsubmit";
        var selected = grid.getSelectionModel().getSelected();

        status = selected.get('statusDataIndex');
        if (status == 'APPROVED' || status == 'ACKNOWLEDGED') {
            Ext.example.msg("Record Already Approved");
        }
        if (status == 'PENDING APPROVAL' || status == 'CLOSE' || status == 'MODIFIED-SUBMIT') {
            Ext.example.msg("Record Already SUBMITTED");
        }
        if (status == 'INACTIVE') {
            Ext.example.msg("Record is Inactive");
        }
        if (status == 'OPEN' || status == '' || status == 'MODIFIED') {
            Ext.MessageBox.show({
                title: '',
                msg: 'Are you sure you want to FinalSubmit?',
                buttons: Ext.MessageBox.YESNO,
                icon: Ext.MessageBox.QUESTION,
                fn: function(btn) {
                    if (btn == 'yes') {
                        var selected = grid.getSelectionModel().getSelected();
                        permitNo = selected.get('permitNoDataIndex');
                        status = selected.get('statusDataIndex');
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=finalsubmitStatus',
                            method: 'POST',
                            params: {
                                permitNo: permitNo,
                                CustID: Ext.getCmp('custcomboId').getValue(),
                                status: status
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                store.reload();
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                            }
                        });
                    }
                }
            });
        }
    }
   function addRecord() {
   Ext.getCmp('previewWin').hide();
   previewWinPanel.hide();
        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("<%=SelectCustomerName%>");
            return;
        }
        buttonValue = '<%=Add%>';
        titelForInnerPanel = '<%=Add_Permit_Details%>';
        myWin.show();
        Store2.load({
            params: {
                CustID: Ext.getCmp('custcomboId').getValue(),
                id: 0,
                permitType:Ext.getCmp('permittypecomboId').getValue(),
                mineralType: Ext.getCmp('mineralcomboId').getValue()
            }
        });
        TcNoComboStore.load({
                        params: {
                            CustID: Ext.getCmp('custcomboId').getValue()
                        }
                    });
        exportStore.load({
            params: {
                orgCode: 0,
                 CustID: 0,
                 mineralType: '',
                 routeId:0,
                 permitType:''
            }
        });
        StockTypeStore1.load({
            params: {
                orgCode: 0,
                CustID: 0,
                mineralType: '',
                routeId:0,
                permitType:''
            }
        });
        countryComboStore.load();
        stateComboStore.load();
        vesselNameStore.load({
            params: {
                custId: Ext.getCmp('custcomboId').getValue()
            }
        });
        Ext.getCmp('buyerId').setValue('');
        Ext.getCmp('countryComboId').setValue('');
        Ext.getCmp('shipId').setValue('');
        Ext.getCmp('stateComboId').setValue('');
        Ext.getCmp('stateComboId1').setValue('');
        Ext.getCmp('organizationcodeid').setValue('');
        Ext.getCmp('buyingOrgComboId').setValue('');
        Ext.getCmp('buyingOrgCodeid').setValue('');
        Ext.getCmp('organizationcodeid').setReadOnly(false);
        Ext.getCmp('finyearId').setValue(year);
        Ext.getCmp('mandatoryHead19').hide();
        Ext.getCmp('mandatoryorganizationCode').hide();
        Ext.getCmp('organizationCodeLabel').hide();
        Ext.getCmp('organizationcodeid').hide();
        Ext.getCmp('permitreqtypecomboId').setReadOnly(false);
        Ext.getCmp('permittypecomboId').setReadOnly(false);
        Ext.getCmp('TccomboId').setReadOnly(false);
        Ext.getCmp('mineralcomboId').setReadOnly(false);
        Ext.getCmp('RefcomboId').setReadOnly(false);
        Ext.getCmp('BuChallancomboId').setReadOnly(false);
        Ext.getCmp('routeidcomboId').setReadOnly(false);
        Ext.getCmp('mandatorybuyer').hide();
		Ext.getCmp('labelBuyer').hide();
		Ext.getCmp('buyerId').hide();
		Ext.getCmp('mandatoryHead18').hide();
		Ext.getCmp('mandatorycountry').hide();
		Ext.getCmp('labelcountry').hide();
		Ext.getCmp('countryComboId').hide();
		Ext.getCmp('mandatoryHead199').hide();
		Ext.getCmp('mandatoryship').hide();
		Ext.getCmp('labelShip').hide();
		Ext.getCmp('shipId').hide();
		Ext.getCmp('mandatoryHead20').hide();
        Ext.getCmp('mandatoryHead200').hide();
		Ext.getCmp('mandatorystate').hide();
		Ext.getCmp('labelstate').hide();
		Ext.getCmp('stateComboId').hide();
		Ext.getCmp('mandatoryHead001').hide();
		Ext.getCmp('mandatoryoBuyingOrgName').hide();
		Ext.getCmp('BuyingOrgNameLabel').hide();
		Ext.getCmp('buyingOrgComboId').hide();
		
		Ext.getCmp('mandatoryHead002').hide();
		Ext.getCmp('mandatorybuyingOrgCode').hide();
		Ext.getCmp('buyingOrgCodeid').hide();
		Ext.getCmp('buyingOrgCodeLabel').hide();
		
		Ext.getCmp('mandatoryHeadState').hide();
		Ext.getCmp('mandatorystateName').hide();
		Ext.getCmp('labelstateName').hide();
		Ext.getCmp('stateComboId1').hide();
		
        Ext.getCmp('mandatoryHead160').hide();
        Ext.getCmp('bauxiteChallanId').hide();
        Ext.getCmp('mandatorybu').hide();
        Ext.getCmp('BuChallancomboId').hide();
		
        myWin.setTitle(titelForInnerPanel);
        Ext.getCmp('dateid').reset(),
        Ext.getCmp('permitreqtypecomboId').reset(),
        Ext.getCmp('ownertypecomboId').reset(),
        Ext.getCmp('permittypecomboId').reset(),
        Ext.getCmp('TccomboId').reset(),
        Ext.getCmp('minecodeId').reset(),
        Ext.getCmp('leaseNameid').reset(),
        Ext.getCmp('leaseOwnerid').reset(),
        Ext.getCmp('organizationid').reset(),
        Ext.getCmp('mineralcomboId').reset(),
        Ext.getCmp('routeidcomboId').reset(),
        Ext.getCmp('fromlocId').reset(),
        Ext.getCmp('tolocId').reset(),
        Ext.getCmp('RefcomboId').reset(),
        Ext.getCmp('BuChallancomboId').reset(),
        Ext.getCmp('startdateid').reset(),
        Ext.getCmp('enddateid').reset(),
        Ext.getCmp('remarksid').reset(),
        Ext.getCmp('applicationid').reset(),
        Ext.getCmp('importpurposecomboId').setValue(''),
        Ext.getCmp('importtypecomboId').setValue(''),
        Ext.getCmp('importedPermitId').setValue(''),
        Ext.getCmp('importedPermitId').setValue(''),
        Ext.getCmp('vesselNameId').setValue(''),
        Ext.getCmp('exportPermitNoId').setValue(''),
        Ext.getCmp('exportPermitDateId').setValue(''),
        Ext.getCmp('exportChallanNoId').setValue(''),
        Ext.getCmp('exportChallanDateId').setValue(''),
        Ext.getCmp('saleInvoiceNoId').setValue(''),
        Ext.getCmp('saleInvoiceDateId').setValue(''),
        Ext.getCmp('transportnTypecomboId').setValue(''),
        Ext.getCmp('hubId').setValue(''),
        Ext.getCmp('romPermitId').setValue(''),
        Ext.getCmp('toLocationId').setValue(''),
        Ext.getCmp('desttypeId').setValue('');
        Ext.getCmp('desttypeId').setReadOnly(false);
        Ext.getCmp('proFeeId').reset();
        Ext.getCmp('qty2Id').reset();
        Ext.getCmp('stockcomboId').reset();
        Ext.getCmp('grdecomboId').reset();
        Ext.getCmp('remarks').reset();
        Ext.getCmp('mwalletId').reset();
        outerPanelForBauxiteGrid.hide();
        outerPanelForGrid.hide();
        gridPanel.hide();
        proccessedOreGrid.hide();
        gridForExportDetails.hide();
        editedRows="";
        Ext.getCmp('dateid').focus();
    }
    function modifyData() {
    	Ext.getCmp('previewWin').hide();
   		previewWinPanel.hide();
        var selected = grid.getSelectionModel().getSelected();
        status = selected.get('statusDataIndex');

        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("<%=SelectCustomerName%>");
            return;
        }
        if (grid.getSelectionModel().getCount() == 0) {
            Ext.example.msg("<%=NoRowsSelected%>");
            return;
        }
        if (grid.getSelectionModel().getCount() > 1) {
            Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }
        var selected = grid.getSelectionModel().getSelected();
        buttonValue = '<%=Modify%>';
        if(status == "APPROVED"){ 
          Ext.getCmp('mdateid1').setValue(selected.get('dateIndex'));
          Ext.getCmp('mdateid2').setValue(selected.get('startdateDataIndex'));
          Ext.getCmp('mdateid3').setValue(selected.get('enddateDataIndex'));
          Ext.getCmp('vesselNameModify').setValue(selected.get('shipNameDataIndex'));
          Ext.getCmp('buyerModId').setValue(selected.get('buyerDataIndex'));
          Ext.getCmp('remarksModifyId').setValue(selected.get('remarksDataIndex'));
          var gradeMod;
          if(selected.get('exactLumpsIndex')!=""){
          	gradeMod=selected.get('exactLumpsIndex');
          }else if(selected.get('exactFinesIndex')!=""){
          	gradeMod=selected.get('exactFinesIndex');
          }
          Ext.getCmp('gradeModId').setValue(gradeMod);
          
         if(selected.get('permitTypeIndex') == 'International Export'){
        	vesselNameStore.load({
	            params: {
	                custId: Ext.getCmp('custcomboId').getValue()
	            }
	        });
	        if(selected.get('usedQtyIndex')==0){
	          	Ext.getCmp('vesselModLable').show();
	          	Ext.getCmp('labelV').show();
	          	Ext.getCmp('vesselNameModify').show();
	          	
	          	Ext.getCmp('vesselNameModify').setReadOnly(false);
          	}else{
	          	Ext.getCmp('vesselNameModify').setReadOnly(true);
          	}
          	Ext.getCmp('m30').show();
          	Ext.getCmp('buyerModLab').show();
          	Ext.getCmp('buyerModId').show();
          	
          	Ext.getCmp('m31').show();
          	Ext.getCmp('exactGradeModLab').show();
          	Ext.getCmp('gradeModId').show();
          	
        }else if(selected.get('permitTypeIndex') == 'Domestic Export'){
        	
          	Ext.getCmp('vesselModLable').hide();
          	Ext.getCmp('labelV').hide();
          	Ext.getCmp('vesselNameModify').hide();
          	Ext.getCmp('vesselNameModify').setValue('');
          	
          	Ext.getCmp('m30').show();
          	Ext.getCmp('buyerModLab').show();
          	Ext.getCmp('buyerModId').show();
          	
          	Ext.getCmp('m31').show();
          	Ext.getCmp('exactGradeModLab').show();
          	Ext.getCmp('gradeModId').show();
          	
        }else if(selected.get('permitTypeIndex') == 'Rom Transit' || selected.get('permitTypeIndex') == 'Rom Sale' || selected.get('permitTypeIndex') == 'Purchased Rom Sale Transit Permit'){
        	Ext.getCmp('vesselModLable').hide();
          	Ext.getCmp('labelV').hide();
          	Ext.getCmp('vesselNameModify').hide();
          	Ext.getCmp('vesselNameModify').setValue('');
          	
          	Ext.getCmp('m30').hide();
          	Ext.getCmp('buyerModLab').hide();
          	Ext.getCmp('buyerModId').hide();
          	Ext.getCmp('buyerModId').setValue('');
          	
          	Ext.getCmp('m31').hide();
          	Ext.getCmp('exactGradeModLab').hide();
          	Ext.getCmp('gradeModId').hide();
          	Ext.getCmp('gradeModId').setValue('');
        }else{
        	Ext.getCmp('vesselModLable').hide();
          	Ext.getCmp('labelV').hide();
          	Ext.getCmp('vesselNameModify').hide();
          	Ext.getCmp('vesselNameModify').setValue('');
          	
          	Ext.getCmp('m30').hide();
          	Ext.getCmp('buyerModLab').hide();
          	Ext.getCmp('buyerModId').hide();
          	Ext.getCmp('buyerModId').setValue('');
          	
          	Ext.getCmp('m31').show();
          	Ext.getCmp('exactGradeModLab').show();
          	Ext.getCmp('gradeModId').show();
        }
        dateWin.show();
        }else{
	        titelForInnerPanel = '<%=Modify_Permit_Details%>';
	        myWin.setTitle(titelForInnerPanel);
	        modifyFunction(selected,status);
	        Ext.getCmp('dateid').focus();
        }
    }
    //****************************** Function for Permit Closure***************************//  
    function postponeFunction() {
        var selected = grid.getSelectionModel().getSelected();
        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("<%=SelectCustomerName%>");
            return;
        }
        buttonValue = 'Close';
        titelForInnerPanel = '<%=Add_Permit_Closure_Details%>';
        myWin1.setTitle(titelForInnerPanel);
        myWin1.show();
        Ext.getCmp('permittypeCloseId').reset(),
        Ext.getCmp('TccomboId1').reset(),
        Ext.getCmp('minecodeId1').reset(),
        Ext.getCmp('leaseNameid1').reset(),
        Ext.getCmp('leaseOwnerid1').reset(),
        Ext.getCmp('organizationid1').reset(),
        Ext.getCmp('organizationcodeCloseid').reset(),
        Ext.getCmp('PermitNocomboId').reset(),
        Ext.getCmp('permitdateId').reset(),
        Ext.getCmp('qtyId').reset(),
        Ext.getCmp('qtydeductionId').reset(),
        Ext.getCmp('closedqtyId').reset(),
        Ext.getCmp('romQuantityid').reset(),
        Ext.getCmp('refundId').reset();
        Ext.getCmp('newsourcecomboId').reset();
    }
//****************************** Function for delete record***************************//   
function deleteData() {
    var selected = grid.getSelectionModel().getSelected();
       status = selected.get('statusDataIndex');
       if (status == 'PENDING APPROVAL') {
           Ext.example.msg("Record Already Submitted");
           return;
       }
       if (status == 'APPROVED') {
           Ext.example.msg("Record Already Approved");
           return;
       }
       if (status == 'INACTIVE') {
            Ext.example.msg("Permit is inactive");
       }
       Ext.MessageBox.show({
           title: '',
           msg: 'Are you sure you want to Delete?',
           buttons: Ext.MessageBox.YESNO,
           icon: Ext.MessageBox.QUESTION,
           fn: function(btn) {
               if (btn == 'yes') {
                   var selected = grid.getSelectionModel().getSelected();
                   id=selected.get('uniqueidDataIndex');
                   orgCode=selected.get('organizationIdDataIndex');
                   permitNo = selected.get('permitNoDataIndex');
                   status = selected.get('statusDataIndex');
                   Ext.Ajax.request({
                       url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=deleteRecord',
                       method: 'POST',
                       params: {
                           permitNo: permitNo,
                           CustID: Ext.getCmp('custcomboId').getValue(),
                           status: status,
                           orgCode: orgCode,
                           id: id
                       },
                       success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                store.reload();
                            },
                       failure: function() {
                           Ext.example.msg("Error");
                           approveWin.hide();
                       }
                   });
               }
           }
       });
   }
   function approveFunction(){
   	   var selected = grid.getSelectionModel().getSelected();
       status = selected.get('statusDataIndex');
       if (status == 'PENDING APPROVAL' || status == 'OPEN' || status == 'CLOSE' || status == 'MODIFIED-SUBMIT' || status == 'MODIFIED') {
           Ext.example.msg("Record either Submitted or open");
           return;
       }
       if (status == 'APPROVED' || status == 'ACKNOWLEDGED' || status == 'INACTIVE') {
       Ext.MessageBox.show({
           title: '',
           msg: 'Are you sure you want to Inactive or Active?',
           buttons: Ext.MessageBox.YESNO,
           icon: Ext.MessageBox.QUESTION,
           fn: function(btn) {
               if (btn == 'yes') {
                   var selected = grid.getSelectionModel().getSelected();
                   id=selected.get('uniqueidDataIndex');
                   status = selected.get('statusDataIndex');
                   Ext.Ajax.request({
                       url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=InactiveStatus',
                       method: 'POST',
                       params: {
                           CustID: Ext.getCmp('custcomboId').getValue(),
                           status: status,
                           id: id
                       },
                       success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                store.reload();
                            },
                       failure: function() {
                           Ext.example.msg("Error");
                           approveWin.hide();
                       }
                   });
               }
           }
       });
       }
   }
    var reader = new Ext.data.JsonReader({
        idProperty: 'ownMasterid',
        root: 'PermitDetailsRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'uniqueidDataIndex'
        }, {
            name: 'permitNoDataIndex'
        }, {
            name: 'statusDataIndex'
        }, {
        	type: 'date',
    		dateFormat: getDateFormat(),
            name: 'dateIndex'
        }, {
            name: 'financialYearIndex'
        }, {
            name: 'permitRequestTypeIndex'
        }, {
            name: 'ownerTypeIndex'
        }, {
            name: 'permitTypeIndex'
        }, {
            name: 'exactRomIndex'
        }, {
            name: 'exactFinesIndex'
        }, {
            name: 'exactLumpsIndex'
        }, {
            name: 'exactConcentratesIndex'
        }, {
            name: 'exactTailingsIndex'
        }, {
            name: 'tcNoIndex'
        }, {
            name: 'mineCodeDataIndex'
        }, {
            name: 'leaseNameDataIndex'
        }, {
            name: 'leaseOwnerDataIndex'
        }, {
            name: 'organizationCodeDataIndex'
        }, {
            name: 'organizationNameDataIndex'
        }, {
            name: 'mineralDataIndex'
        }, {
            name: 'routeIdDataIndex'
        }, {
            name: 'fromLocationDataIndex'
        }, {
            name: 'toLocationDataIndex'
        }, {
            name: 'refDataIndex'
        }, {
            name: 'quantityDataIndex'
        }, {
            name: 'usedQtyIndex'
        }, {
            name: 'permitBalanceIndex'
        }, {
            name: 'toSourceIndex'
        },{
            name: 'selfconsIndex'
        },{
            name: 'pfIndex'
        }, {
            name: 'totalPfIndex'
        },  {
            name: 'closedQtyIndex'
        }, {
            name: 'applicationNoDataIndex'
        }, {
            name: 'startdateDataIndex'
        }, {
            name: 'enddateDataIndex'
        },{
            name: 'buyerDataIndex'
        },{
            name: 'countryNameDataIndex'
        },{
            name: 'countryIdDataIndex'
        },{
            name: 'stateNameDataIndex'
        },{
            name: 'stateIdDataIndex'
        },{
            name: 'shipNameDataIndex'
        }, {
            name: 'remarksDataIndex'
        }, {
            name: 'routeDataIndex'
        }, {
            name: 'organizationIdDataIndex'
        }, {
            name: 'challanIdDataIndex'
        }, {
            name: 'buyingOrgIdDataIndex'
        }, {
            name: 'buyingOrgNameDataIndex'
        }, {
            name: 'buyingOrgCodeDataIndex'
        },{
            name: 'existingPermitIndex'
        },{
            name: 'ExtpermitIdDataIndex'
        },{
            name: 'importTypeDataIndex'
        },{
            name: 'importPurposeDataIndex'
        },{
            name: 'exportPermitDataIndex'
        },{
            name: 'exportPermitDateDataIndex'
        },{
            name: 'exportChallanDataIndex'
        },{
            name: 'exportChallanDateDataIndex'
        },{
            name: 'saleInvoiceDataIndex'
        },{
            name: 'saleInvoiceDateDataIndex'
        },{
            name: 'transportnDataIndex'
        },{
            name: 'vesselNameDataIndex'
        },{
            name: 'hubNameIndex'
        },{
            name: 'hubIdIndex'
        },{
            name: 'toLocIndex'
        },{
            name: 'destTypeDataIndex'
        },{
            name: 'srcTypePrstpIndex'
        },{
            name: 'motherRDataIndex'
        },{
            name: 'leaseTypeDataIndex'
        },{
            name: 'processingFeeTypeDataIndex'
        }]
    });
    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({

            url: '<%=request.getContextPath()%>/PermitDetailsAction.do?param=getPermitDetails',
            method: 'POST'
        }),
        storeId: 'permitId',
        reader: reader
    });
    if(<%=userAuthority.equalsIgnoreCase("User")%>){
    grid = getGrid('<%=Permit_Details%>', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 60, filters, '<%=ClearFilterData%>', false, '', 46, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', false, '<%=Add%>', false, 'Modify/Extension', false, 'Delete', false, '', false, 'Approve', false, 'Active/Inactive', false, 'Final Submit', false, 'Permit Closure',true,'',true,'PDF');
    }else{
    grid = getGrid('<%=Permit_Details%>', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 60, filters, '<%=ClearFilterData%>', false, '', 46, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, 'Modify/Extension', false, 'Delete', false, '', <%=ackvalue%>, 'Approve', <%=Inactivevalue%>, 'Active/Inactive', true, 'Final Submit', true, 'Permit Closure',true,'',true,'PDF');
    }
    Ext.onReady(function() {
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            title: '',
            renderTo: 'content',
            standardSubmit: true,
            frame: true,
            width: screen.width - 22,
            cls: 'outerpanel',
            layout: 'table',
            layoutConfig: {
                columns: 1
            },
            items: [customerComboPanel, customSearchPanel, grid]
        });
        sb = Ext.getCmp('form-statusbar');
        var cm = grid.getColumnModel();
        for (var j = 1; j < cm.getColumnCount(); j++) {
            cm.setColumnWidth(j, 170);
        }
        if(!<%=isLtsp%>){
        	Ext.getCmp('allPermitsId').hide();
        }
    }); 
</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>
