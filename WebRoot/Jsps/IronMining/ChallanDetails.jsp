<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
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
		boolean isLtsp=loginInfo.getIsLtsp()==0;
ArrayList<String> tobeConverted=new ArrayList<String>();
	tobeConverted.add("Select_Customer");
	tobeConverted.add("Please_Select_customer");
	tobeConverted.add("SLNO");
	tobeConverted.add("Owner_Name");
	tobeConverted.add("Bank");
	tobeConverted.add("Branch");
	tobeConverted.add("Save");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Cancel");
	tobeConverted.add("Error");
	tobeConverted.add("Select_Single_Row");
	tobeConverted.add("Acknowledgement_Information");
	tobeConverted.add("Acknowledgement");
	tobeConverted.add("Challan_Number");
	tobeConverted.add("Enter_Challan_Number");
	tobeConverted.add("Challen_Date");
	tobeConverted.add("Enter_Challen_Date");
	tobeConverted.add("Bank_Transaction_Number");
	tobeConverted.add("Enter_Bank_Transaction_Number");
	tobeConverted.add("Amount_Paid");
	tobeConverted.add("Enter_Paid_Amount");
	tobeConverted.add("Type");
	tobeConverted.add("Select_Type");
	tobeConverted.add("Select_Payment_A/C_Head");
	tobeConverted.add("Unique_Id");
	tobeConverted.add("Challan_Number");
	tobeConverted.add("TC_Number");
	tobeConverted.add("Mineral_Type");
	tobeConverted.add("Grade");
	tobeConverted.add("Rate");
	tobeConverted.add("Quantity");
	tobeConverted.add("Select_Grade");
	tobeConverted.add("Select_TC_Number");
	tobeConverted.add("Select_Mineral_Type");
	tobeConverted.add("Enter_Quantity");
	tobeConverted.add("Select_Bank_Name");
	tobeConverted.add("Select_Branch");
	tobeConverted.add("Payment_Description");
	tobeConverted.add("Enter_Payment_Description");
	tobeConverted.add("Date_and_Time_of_Generation");
	tobeConverted.add("Select_Date");
	tobeConverted.add("Enter_Amount");
	tobeConverted.add("Challan_Details");
	tobeConverted.add("Select_Adjustment_Type");
	tobeConverted.add("Select_Lease_No/Mine_Owner");
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
	tobeConverted.add("Enter_Prevoius_Challan_Reference");
	tobeConverted.add("Enter_Exact_Grade");
	tobeConverted.add("Mine_Code");
ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
    String selectCustomer=convertedWords.get(0);
    String pleaseSelectCustomer=convertedWords.get(1);
	String SLNO=convertedWords.get(2);
	String OwnerName=convertedWords.get(3);
	String Bank=convertedWords.get(4);
	String Branch=convertedWords.get(5);
	String save =convertedWords.get(6);
	String noRecordsFound=convertedWords.get(7);
	String cancel=convertedWords.get(8);
	String error=convertedWords.get(9);
	String SelectSingleRow=convertedWords.get(10);
	String AcknowledgementInfo=convertedWords.get(11);
	String Acknowledgement=convertedWords.get(12);
	String ChallanNumber=convertedWords.get(13);
	String EnterChallanNumber=convertedWords.get(14);
	String ChallenDate=convertedWords.get(15);
	String EnterChallenDate=convertedWords.get(16);
	String BankTransactionNumber=convertedWords.get(17);
	String EnterBankTransactionNumber=convertedWords.get(18);
	String AmountPaid=convertedWords.get(19);
	String EnterPaidAmount=convertedWords.get(20);
	String Type=convertedWords.get(21);
	String Select_Type=convertedWords.get(22);
	String Select_Payment_Acc_Head=convertedWords.get(23);
	String Unique_Id=convertedWords.get(24);
	String Challan_Number=convertedWords.get(25);
	String TC_Number=convertedWords.get(26);
	String Mineral_Type=convertedWords.get(27);
	String Grade=convertedWords.get(28);
	String Rate=convertedWords.get(29);
	String Quantity=convertedWords.get(30);
	String Select_Grade=convertedWords.get(31);
	String Select_TC_Number=convertedWords.get(32);
	String Select_Mineral_Type=convertedWords.get(33);
	String Enter_Quantity=convertedWords.get(34);
	String Select_Bank_Name=convertedWords.get(35);
	String Select_Branch=convertedWords.get(36);
	String Payment_Description=convertedWords.get(37);
	String Enter_Payment_Description=convertedWords.get(38);
	String Date_and_Time_of_Generation=convertedWords.get(39);
    String Select_Date=convertedWords.get(40);		
	String Enter_Amount=convertedWords.get(41);
	String Challan_Details=convertedWords.get(42);
	String Select_Adjustment_Type=convertedWords.get(43);
	String Select_Lease_NoMine_Owner=convertedWords.get(44);
	String Payment_Acc_Head=convertedWords.get(45);
	String Mining_Lease_Name=convertedWords.get(46);
	String Adjustment_Type=convertedWords.get(47);
	String Previous_Challan_Reference=convertedWords.get(48);
	String Previous_Challan_Date_Reference=convertedWords.get(49);
	String Lease_NoMine_Owner=convertedWords.get(50);
	String Royalty_for_the_monthyear=convertedWords.get(51);
	String Exact_Grade=convertedWords.get(52);
	String Total_Payable=convertedWords.get(53);
	String NIC_Challan_No=convertedWords.get(54);
	String NIC_Challan_Date=convertedWords.get(55);
	String Acknowledgement_Generation_Datetime=convertedWords.get(56);
	String Mine_Owner_Chalan_Details=convertedWords.get(57);
	String Enter_Prevoius_Challan_Reference=convertedWords.get(58);
	String Enter_Exact_Grade=convertedWords.get(59);
	String Mine_Code=convertedWords.get(60);
	int systemId = loginInfo.getSystemId();
	int userId=loginInfo.getUserId(); 
	int customerId = loginInfo.getCustomerId();
	String userAuthority=cf.getUserAuthority(systemId,userId);
boolean delAuth = true;
boolean finalSubAuth = true;
boolean approvalAuth = true;
	if(userAuthority.equalsIgnoreCase("Supervisor")){
		delAuth = false;
		finalSubAuth=true;
		approvalAuth=false;
	}
	
%>
	


<jsp:include page="../Common/header.jsp" />
    <base href="<%=basePath%>">
    <title>
        <%=Challan_Details%>
    </title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <style>
.x-btn-text addbutton { font-family: 'Helvetica', sans-serif;  font-size: 12px !important; }
.x-btn-text editbutton { font-family: 'Helvetica', sans-serif;  font-size: 12px !important; }
.x-btn-text excelbutton { font-family: 'Helvetica', sans-serif;  font-size: 12px !important; }
.x-btn-text pdfbutton { font-family: 'Helvetica', sans-serif;  font-size: 12px !important; }
.x-btn-text { font-family: 'Helvetica', sans-serif;  font-size: 12px !important; }
.x-btn-text clearfilterbutton { font-family: 'Helvetica', sans-serif;  font-size: 12px !important; }
.ui-helper-hidden-accessible{visibility: hidden; display: none;}
.ui-autocomplete { overflow-y: scroll; max-height: 130px; position: absolute; min-width: 160px; padding: 4px 0; margin: 0 0 10px 25px; background-color: #ffffff;}
.ui-menu-item { background: #ffffff; border-color: #ffffff; padding: 2.5px 0;}
.ui-state-hover, .ui-state-focus, .ui-state-active { color: #ffffff; text-decoration: none; background-color: #5f6f81; border-radius: 0px; -webkit-border-radius: 0px; -moz-border-radius: 0px; background-image: none; }
.x-resizable-pinned {min-width: 200px !important;}
.x-combo-list-inner {min-width: 200px !important;}
    </style>

    <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
        <jsp:include page="../Common/ImportJSSandMining.jsp" />
        <%}else {%>
            <jsp:include page="../Common/ImportJS.jsp" />
            <%} %>
           <jsp:include page="../Common/ExportJS.jsp" />
		   <style>
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			label {
				display : inline !important;
			}
			.x-window-tl *.x-window-header {
				height : 38px !important;
			}
			.selectstylePerfect {
				width: 150px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}
			
			.x-fieldset-bwrap
			{
				margin-top:-4px;
				margin-left:-140px;
			}
			
			
element.style {
}
.ext-webkit .x-fieldset-header {
    padding-top: 1px;
}
*.x-fieldset legend {
    font: bold 11px tahoma , arial , helvetica , sans-serif;
    color: #111111;
}
.x-fieldset legend {
    font: bold 11px tahoma, arial, helvetica, sans-serif;
    color: #15428b;
}
.x-unselectable, .x-unselectable * {
    -moz-user-select: none;
    -khtml-user-select: none;
    -webkit-user-select: ignore;
}
fieldset legend {
    background: ;
    padding: 6px;
    font-weight: bold;
}
.innerpanelsmallest {
    height: 80px !important;
}	
	 <% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		.x-form-cb-label {   
			padding-left: 8px !important;
		}
		.x-form-check-wrap {
			float: left;
			margin-top: -16px;
		}
		.innerpanelsmallest {
			height: 61px !important;
		}
		div#customerMaster {
			margin-bottom : -20px !important;
		}	
		input#challanCheckBoxId{
			margin-top:16px !important;
	    }
		.innerpanelsmallest {
			height: 61px !important;
		}
		.x-fieldset-bwrap {    
			margin-left: 0px !important;
		}
		
		.x-menu-list {
				height:auto !important;
		}
	
	 <%} else {%>
		.x-form-cb-label {   
			top: -14px !important;
			    padding-left: 117px !important;
		}
	 <%}%>
	 
		   </style>
<script>
    var grid;
    var myWin;
    var buttonValue;
    var uniqueId;
    var closewin;
    var approveWin;
    var outerPanel;
    var AssetNo;
    var dtcur = datecur;
    var jspName = 'ChallanDetails';
    var newRowAdded = 0;
    var editedRows = "";
    var editedRowsForGrid = "";
    var editedRowsForBuGrid = "";
    var gradeSelect = false;
    var IndexPayable = 0;
    var exportDataType = "int,int,string,string,string,int,string,int,string,string,number,number,number,number,number,number,number,number,number,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,number,string,string,int,string,number,string,number,number,string,string,string,string,string,string,string,string,string,string,int,string,string,string";
    var ewallet = "No";
    var processingFee = 0;
    var ewalletId = '';
    var rateindex = false;
    var ewalletAmount = 0;
    var ewalletQty = 0;
    var grade2;
    var grade1;
    var year;
    var giopfStatus;
    var d = new Date();
    var curYear = d.getFullYear();
    var preYear = d.getFullYear() - 1;
    var nextYear = d.getFullYear() + 1;
    var grdeselect;
    var datenext1= nextDate;
    var listOfChallanNo = [];
    var loadMask = new Ext.LoadMask(Ext.getBody(), {
        msg: "Submitting.."
    });
    if (d.getMonth() >= 3) {
        year = curYear + '-' + nextYear;
    } else {
        year = preYear + '-' + curYear;
    }
    //*********************** Store For Customer *****************************************//
    var customercombostore = new Ext.data.JsonStore({
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
                    var cm = grid.getColumnModel();
                    for (var j = 1; j < cm.getColumnCount(); j++) {
                        cm.setColumnWidth(j, 155);
                    }
                    custId = Ext.getCmp('custcomboId').getValue();
                    store.load({
                        params: {
                            CustID: Ext.getCmp('custcomboId').getValue(),
                            jspName: jspName,
                            CustName: Ext.getCmp('custcomboId').getRawValue(),
                            endDate: Ext.getCmp('enddate').getValue(),
			                startDate: Ext.getCmp('startdate').getValue()
                        }
                    });
                    ChallansForSearchStore.load({ 
                    	params: {custId: custId},
                    	callback: function(){
                    		listOfChallanNo=[];
			 				for(var i=0; i<ChallansForSearchStore.getCount(); i++){
								var rec = ChallansForSearchStore.getAt(i);
								listOfChallanNo.push(rec.data['CHALLAN_NO']);
							}
                    	}
                    });
                    OrgNamesForSearchStore.load({ 
                    	params: {custId: custId}
                    });
                    paymentComboStore.load({
                        params: {
                            CustID: Ext.getCmp('custcomboId').getValue()
                        }
                    });

                    mineOwnerComboStore.load({
                        params: {
                            CustID: Ext.getCmp('custcomboId').getValue()
                        }
                    });
                    mineralTypeComboStore.load({
                        params: {

                        }
                    });
                    TcNoComboStore.load({
                        params: {
                            CustID: Ext.getCmp('custcomboId').getValue()
                        }
                    });
                }
            }
        }
    });
    //************************ Combo for Customer Starts Here***************************************//
    var custnamecombo = new Ext.form.ComboBox({
        store: customercombostore,
        id: 'custcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=pleaseSelectCustomer%>',
        selectOnFocus: true,
        resizable: true,
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
                    var cm = grid.getColumnModel();
                    for (var j = 1; j < cm.getColumnCount(); j++) {
                        cm.setColumnWidth(j, 155);
                    }
                    store.load({
                        params: {
                            CustID: Ext.getCmp('custcomboId').getValue(),
                            jspName: jspName,
                            CustName: Ext.getCmp('custcomboId').getRawValue(),
                            endDate: Ext.getCmp('enddate').getValue(),
			                startDate: Ext.getCmp('startdate').getValue()
                        }
                    });
                    ChallansForSearchStore.load({ 
                    	params: {custId: custId},
                    	callback: function(){
                    		listOfChallanNo=[];
			 				for(var i=0; i<ChallansForSearchStore.getCount(); i++){
								var rec = ChallansForSearchStore.getAt(i);
								listOfChallanNo.push(rec.data['CHALLAN_NO']);
							}
                    	}
                    });
                    OrgNamesForSearchStore.load({ 
                    	params: {custId: custId}
                    });
                    paymentComboStore.load({
                        params: {
                            CustID: Ext.getCmp('custcomboId').getValue()
                        }
                    });

                    mineOwnerComboStore.load({
                        params: {
                            CustID: Ext.getCmp('custcomboId').getValue()
                        }
                    });
                    mineralTypeComboStore.load({
                        params: {

                        }
                    });
                    TcNoComboStore.load({
                        params: {
                            CustID: Ext.getCmp('custcomboId').getValue()

                        }
                    });
                }
            }
        }
    });
    //************************************Challan Number Store for Custom Search **************************************
    var ChallansForSearchStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/ChallanDetailsAction.do?param=getChallansForCustomSearch',
        root: 'ChallansForSearchRoot',
        autoLoad: false,
        remoteSort: true,
        id: 'ChallansForSearchStoreId',
        fields: ['CHALLAN_ID', 'CHALLAN_NO']
    });
    //************************************Organization Number Store for Custom Search **************************************
    var OrgNamesForSearchStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/ChallanDetailsAction.do?param=getOrgNamesForCustomSearch',
        root: 'OrgNamesForSearchRoot',
        autoLoad: false,
        remoteSort: true,
        id: 'OrgNamesForSearchStoreId',
        fields: ['ORG_ID', 'ORG_NAME','ORG_CODE']
    });
    //************************ Organization Combo for Custom Search ***************************************//
    var SearchOrgCombo = new Ext.form.ComboBox({
        store: OrgNamesForSearchStore,
        id: 'SearchOrgComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Organization',
        blankText: 'Select Organization',
        selectOnFocus: true,
        resizable: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        hidden: true,
        valueField: 'ORG_ID',
        displayField: 'ORG_NAME',
        cls: 'selectstylePerfect',
      });  
       //************************ Organization Combo for Custom Search ***************************************//
    var OrgComboForReport = new Ext.form.ComboBox({
        store: OrgNamesForSearchStore,
        id: 'ReportOrgComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Organization',
        blankText: 'Select Organization',
        selectOnFocus: true,
        resizable: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        hidden: true,
        valueField: 'ORG_ID',
        displayField: 'ORG_NAME',
        cls: 'selectstylePerfect',
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
            columns: 10
        },
        items: [{width:270},{xtype: 'label',
        		text: 'Search by :',
                cls: 'labelstyle',
        		},{width:30},{
	            xtype: 'radiogroup',
	            fieldLabel: 'Search by',
	            id:'radioGroupId',
	            column:4,
	            cls: 'x-check-group-alt',
	            items: [{xtype: 'radio', boxLabel: 'Challan Number&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;', name: 'radio_selection', inputValue: 1, checked: false},
	                	{xtype: 'radio', boxLabel: 'Organization Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;', name: 'radio_selection', inputValue: 2, checked: false},
	                	{xtype: 'radio', boxLabel: 'All Challans', name: 'radio_selection', inputValue: 3, checked: false, id:'allChallanId'}],
	                	listeners: { change : function(obj, value){
	                	var checked= Ext.DomQuery.selectValue('input[name=radio_selection]:checked/@value');
	                		if(checked==1){
		                	    Ext.getCmp('SearchTextId').reset();
		                	    Ext.getCmp('SearchOrgComboId').reset();
		                	    Ext.getCmp('SearchTextId').show();
		                	    Ext.getCmp('SearchTextId').focus();
		                	    Ext.getCmp('SearchOrgComboId').hide();
		                	    Ext.getCmp('someSpaceId').hide();
		                	    store.removeAll();
	                	    }else if(checked==2){
	                	    	Ext.getCmp('SearchTextId').reset();
	                	    	Ext.getCmp('SearchOrgComboId').reset();
		                	    Ext.getCmp('SearchTextId').hide();
		                	    Ext.getCmp('SearchOrgComboId').show();
		                	    Ext.getCmp('SearchOrgComboId').focus();
		                	    Ext.getCmp('someSpaceId').show();
		                	    store.removeAll();
	                	    }else if(checked==3){
	                	    	Ext.getCmp('SearchTextId').reset();
	                	    	Ext.getCmp('SearchOrgComboId').reset();
		                	    Ext.getCmp('SearchTextId').hide();
		                	    Ext.getCmp('SearchOrgComboId').hide();
		                	    Ext.getCmp('someSpaceId').hide();
		                	    store.removeAll();
	                	    }
	                	  }
	                     }
             },{width:20}, 
             { xtype: 'textfield',
              enableKeyEvents : true,
              id: 'SearchTextId',
              hidden: true,
              resizable:true, 
              width:180,
              style: {
		           
		      },
              mode: 'local',
              forceSelection: false,
              selectOnFocus: true,
              autoScroll: true,
              //allowBlank: false,
              listeners: { keyup: function(f,n,o){
              			var checked= Ext.DomQuery.selectValue('input[name=radio_selection]:checked/@value');
			 			//checked=1 --> Challan  //checked=2 --> Organization //checked=undefined --> No selection
			 			if(checked==null){Ext.example.msg("Select Search by");}
			 			else if(checked==1){
							$( "#SearchTextId" ).autocomplete({
								source: listOfChallanNo,
						      	select: function(event, ui) {
				            	}
						    });
			 			}
			 			
		 			} },
        	},SearchOrgCombo,{width:35},{id:'someSpaceId',hidden:true,width:150},
        	{xtype: 'button',
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
	                    custId = Ext.getCmp('custcomboId').getValue();
	                    var checked= Ext.DomQuery.selectValue('input[name=radio_selection]:checked/@value');
			 			//checked=1 --> Challan  //checked=2 --> Organization //checked=undefined --> No selection
			 			if(checked==null){Ext.example.msg("Select Search by");}
			 			else if(checked==1){
			 				if(Ext.getCmp('SearchTextId').getValue() == ""){
			 					Ext.example.msg("Enter Challan Number");
		                        Ext.getCmp('SearchTextId').focus();
		                        return;
			 				}
			 				var row=ChallansForSearchStore.find('CHALLAN_NO',Ext.getCmp('SearchTextId').getRawValue());
			 				var rec=ChallansForSearchStore.getAt(row);
			 				if(rec==null){
			 					Ext.example.msg("Challan Number mismatch");
			 					Ext.getCmp('SearchTextId').focus();
			 				}else{
			 				var selectedChallanId=rec.data['CHALLAN_ID'];
			 				store.load({
                                    params: {
                                    	jspName: jspName,
                                    	CustName: Ext.getCmp('custcomboId').getRawValue(),
                                        CustID: custId,
                                        endDate: Ext.getCmp('enddate').getValue(),
                                        startDate: Ext.getCmp('startdate').getValue(),
                                        selectedChallanId: selectedChallanId
                                    }
                                });
							}
			 			}
			 			else if(checked==2){
				 			if (Ext.getCmp('SearchOrgComboId').getValue() == "") {
		                        Ext.example.msg("Select Organization Name");
		                        Ext.getCmp('SearchOrgComboId').focus();
		                        return;
		                    }
			 				store.load({
                                    params: {
                                    	jspName: jspName,
                                    	CustName: Ext.getCmp('custcomboId').getRawValue(),
                                        CustID: custId,
                                        endDate: Ext.getCmp('enddate').getValue(),
                                        startDate: Ext.getCmp('startdate').getValue(),
                                        selectedOrgId: Ext.getCmp('SearchOrgComboId').getValue()
                                    }
                           		});
			 			}else if(checked==3){
			 				window.open("<%=request.getContextPath()%>/AllChallansOrPermitsExcel?requesrtingFor=ChallanDetails");
			 			}
                    }
                }    
               }
            }]//panel
    });
    
       //************************************challan report Panel**************************************
    var challanReportPanel = new Ext.form.FieldSet({
        standardSubmit: true,
        collapsible: true,
        collapsed : true,
        title : 'Challan Report',
        id: 'challanReportPanelId',
        layout: 'table',
        cls: 'innerpanelsmallest',
        frame: false,
        width: '99%',
        layoutConfig: {
            columns: 10
        },
        items: [{width:270},
				{
					xtype: 'label',
					text: 'Get Report by :',
					cls: 'labelstyle',
        		},{width:30},
				{
					xtype: 'radiogroup',
					fieldLabel: 'Get Report by',
					id:'radioGroupId1',
					column:4,
					cls: 'x-check-group-alt',
					items: [
					    {xtype: 'radio', boxLabel: 'Date&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;', name: 'radio_selection', inputValue: 1, checked: false},
	                    {xtype: 'radio', boxLabel: 'Organization Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;', name: 'radio_selection', inputValue: 2, checked: false}],
	                	listeners: { change : function(obj, value){
	                	var checked= Ext.DomQuery.selectValue('input[name=radio_selection]:checked/@value');
	                		if(checked==1){
		                	    Ext.getCmp('ReportOrgComboId').reset();
		                	    Ext.getCmp('ReportOrgComboId').hide();
		                	    Ext.getCmp('ReportDateId').show();
		                	    Ext.getCmp('ReportDateId').focus();
		                	    Ext.getCmp('someSpaceId2').show();
		                	    store.removeAll();
	                	    }else if(checked==2){
	                	    	Ext.getCmp('ReportOrgComboId').show();
	                	    	Ext.getCmp('ReportOrgComboId').focus();
	                	    	Ext.getCmp('ReportDateId').reset();
	                	    	Ext.getCmp('ReportOrgComboId').reset();
		                	    Ext.getCmp('ReportDateId').hide();
		                	    Ext.getCmp('someSpaceId2').show();
		                	    store.removeAll();
	                	    }
	                	  }
	                     }
             },{width:20}, 
             { xtype: 'datefield',
              format: getDateFormat(),
              submitFormat: getMonthYearFormat(),
              plugins: 'monthPickerPlugin',
              enableKeyEvents : true,
              id: 'ReportDateId',
              hidden: true,
              resizable:true, 
              width:180,
              mode: 'local',
              forceSelection: false,
              selectOnFocus: true,
              autoScroll: true,
              listeners: {
              	
              },
        	},OrgComboForReport,{width:35},{id:'someSpaceId2',hidden:true,width:150},
        	{xtype: 'button',
            text: 'Get Report',
            id: 'reportButtonId',
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
	                    custId = Ext.getCmp('custcomboId').getValue();
	                    var checked= Ext.DomQuery.selectValue('input[name=radio_selection]:checked/@value');
			 			//checked=1 --> Challan  //checked=2 --> Organization //checked=undefined --> No selection
			 			if(checked==null){
			 				Ext.example.msg("Get Report by");
			 			}
			 			else if(checked==1){
			 				if(Ext.getCmp('ReportDateId').getValue() == ""){
			 					Ext.example.msg("Select Date");
		                        Ext.getCmp('ReportDateId').focus();
		                        return;
			 				}
			 				var date=Ext.getCmp('ReportDateId').getValue();
			 				formatDate=date.format('Y-m-d');
			 				window.open("<%=request.getContextPath()%>/ChallanReport?date="+formatDate);
			 			}
			 			else if(checked==2){
				 			if (Ext.getCmp('ReportOrgComboId').getValue() == "") {
		                        Ext.example.msg("Select Organization Name");
		                        Ext.getCmp('ReportOrgComboId').focus();
		                        return;
		                    }
		                    var orgId=Ext.getCmp('ReportOrgComboId').getValue();
		                    //alert(orgId);
		                   	window.open("<%=request.getContextPath()%>/ChallanReport?orgId="+Ext.getCmp('ReportOrgComboId').getValue());
			 			}
                    }
                }    
               }
            }]//panel
    });

    var paymentComboStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/ChallanDetailsAction.do?param=getPaymentAccHead',
        root: 'paymentAccRoot',
        autoLoad: false,
        remoteSort: true,
        id: 'test',
        fields: ['paymentAccHeadId', 'paymentAccHead']
    });

    var paymentCombo = new Ext.form.ComboBox({
        store: paymentComboStore,
        id: 'paymentcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_Payment_Acc_Head%>',
        blankText: '<%=Select_Payment_Acc_Head%>',
        resizable: true,
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'paymentAccHeadId',
        displayField: 'paymentAccHead',
        width: 150,
        cls: 'selectstylePerfect',
        listeners: {

        }
    });

    var typeComboStore = new Ext.data.SimpleStore({
        id: 'typecomboStoreId',
        autoLoad: true,
        fields: ['Name', 'Value'],
        data: [
            ['Surface Rent', 'Surface Rent'],
            ['Dead Rent', 'Dead Rent'],
            ['Single', 'Single'],
            ['Calculation', 'Calculation'],
            ['DMF', 'DMF'],
            ['NMET', 'NMET'],
            ['Royalty', 'Royalty'],
            ['GIOPF', 'GIOPF']
        ]
    });

    var typeCombo = new Ext.form.ComboBox({
        store: typeComboStore,
        id: 'typeComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_Type%>',
        blankText: '<%=Select_Type%>',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        hidden: true,
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                 Ext.getCmp('PayableId').reset();
                    if (Ext.getCmp('typeComboId').getValue() == 'Single' || Ext.getCmp('typeComboId').getValue() == 'DMF' ||
                    Ext.getCmp('typeComboId').getValue() == 'NMET' || Ext.getCmp('typeComboId').getValue() == 'GIOPF' || Ext.getCmp('typeComboId').getValue() == 'Royalty') {
                        outerPanelForGrid2.hide();
                        outerPanelForGrid.hide();
                        Ext.getCmp('mandatorypayable').show();
                        Ext.getCmp('mandatorypayable1').show();
                        Ext.getCmp('payableLabelId').show();
                        Ext.getCmp('PayableId').show();
                    } else {
                        outerPanelForGrid2.show();
                        Ext.getCmp('PayableId').reset();
                        Ext.getCmp('mandatorypayable').hide();
                        Ext.getCmp('mandatorypayable1').hide();
                        Ext.getCmp('payableLabelId').hide();
                        Ext.getCmp('PayableId').hide();
                    }
                }
            }
        }
    });

    var challanTypestore = new Ext.data.SimpleStore({
        id: 'challanTypeStoreId',
        autoLoad: true,
        fields: ['Name', 'Value'],
        data: [
            ['E-Wallet Challan', 'E-Wallet Challan'],
            ['Processed Ore', 'Processed Ore'],
            ['Processing Fee', 'Processing Fee'],
            ['ROM', 'ROM'],
            ['Others', 'Others'],
            ['Bauxite Challan', 'Bauxite Challan'],
           
        ]
    });


    var challanTypeCombo = new Ext.form.ComboBox({
        store: challanTypestore,
        id: 'challantypeId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Challan Type',
        blankText: 'Select Challan Type',
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
        autoLoad: true,
        listeners: {
            select: {
                fn: function() {
                    Ext.getCmp('typeComboId').setValue('');
                    Ext.getCmp('mineralTypecomboId').setValue('');
                    if (Ext.getCmp('challantypeId').getValue() == 'ROM') {
                        ewalletChallanPanel.show();
                    } else {
                        ewalletChallanPanel.hide();
                    }
                    if (Ext.getCmp('challantypeId').getValue() == 'E-Wallet Challan' || Ext.getCmp('challantypeId').getValue() == 'ROM' || Ext.getCmp('challantypeId').getValue() == 'Processed Ore') {
                        outerPanelForGrid2.hide();
                        outerPanelForGrid.show();
                        outerPanelForBauxiteGrid.hide();
                        gridPanelForBauxite.hide();
                        gridPanel.show();

                        Ext.getCmp('TccomboId').setReadOnly(false);
                        Ext.getCmp('TcNoLabelId').enable();
                        Ext.getCmp('mandatoryTcNo').enable();
                        Ext.getCmp('mandatoryMineCodelabel').enable();

                        Ext.getCmp('mandatorypayable').hide();
                        Ext.getCmp('mandatorypayable1').hide();
                        Ext.getCmp('payableLabelId').hide();
                        Ext.getCmp('PayableId').hide();

                        Ext.getCmp('orgTraderNameLabelId').enable();

                        Ext.getCmp('mandatoryorgTraderId').enable();
                        Ext.getCmp('orgTraderId').enable();
                        Ext.getCmp('organizationcodeComboid').setReadOnly(true);
                        Ext.getCmp('labelLastId').disable();

                        gradeStore.load({
                            params: {
                                CustID: Ext.getCmp('custcomboId').getValue(),
                                type: Ext.getCmp('challantypeId').getValue(),
                                id: 0
                            }
                        });
                    } else {
                        outerPanelForGrid.hide();
                        outerPanelForGrid2.show();
                        outerPanelForBauxiteGrid.hide();
                        gridPanelForBauxite.hide();

                        Ext.getCmp('TccomboId').setReadOnly(false);
                        Ext.getCmp('TcNoLabelId').enable();
                        Ext.getCmp('mandatoryTcNo').enable();
                        Ext.getCmp('mandatoryMineCodelabel').enable();

                        Ext.getCmp('mandatorypayable').hide();
                        Ext.getCmp('mandatorypayable1').hide();
                        Ext.getCmp('payableLabelId').hide();
                        Ext.getCmp('PayableId').hide();
                        Ext.getCmp('orgTraderNameLabelId').enable();

                        Ext.getCmp('mandatoryorgTraderId').enable();
                        Ext.getCmp('orgTraderId').enable();
                        Ext.getCmp('organizationcodeComboid').setReadOnly(true);
                        Ext.getCmp('labelLastId').disable();
                    }
                    if (Ext.getCmp('challantypeId').getValue() == 'Others') {
                        outerPanelForGrid2.show();
                        outerPanelForGrid.hide();
                        outerPanelForBauxiteGrid.hide();
                        gridPanelForBauxite.hide();
                        Ext.getCmp('typeComboId').reset();
                        Ext.getCmp('typeComboId').show();
                        Ext.getCmp('mandatoryTypeid1').show();
                        Ext.getCmp('typeAdjLabelId1').show();
                        Ext.getCmp('mandatorydtLabel1').show();

                        Ext.getCmp('organizationcodeComboid').reset();
                        Ext.getCmp('orgTraderNameId').reset();

                        Ext.getCmp('TccomboId').setReadOnly(false);
                        Ext.getCmp('TcNoLabelId').enable();
                        Ext.getCmp('mandatoryTcNo').enable();
                        Ext.getCmp('mandatoryMineCodelabel').enable();
                        Ext.getCmp('orgTraderNameLabelId').enable();

                        Ext.getCmp('mandatoryorgTraderId').enable();
                        Ext.getCmp('orgTraderId').enable();
                        Ext.getCmp('organizationcodeComboid').setReadOnly(true);
                        Ext.getCmp('labelLastId').disable();

                    } else {
                        gridPanel.show();
                        outerPanelForGrid.show();
                        outerPanelForGrid2.hide();
                        outerPanelForBauxiteGrid.hide();
                        gridPanelForBauxite.hide();
                        Ext.getCmp('typeComboId').hide();
                        Ext.getCmp('mandatoryTypeid1').hide();
                        Ext.getCmp('typeAdjLabelId1').hide();
                        Ext.getCmp('mandatorydtLabel1').hide();

                        Ext.getCmp('TccomboId').setReadOnly(false);
                        Ext.getCmp('TcNoLabelId').enable();
                        Ext.getCmp('mandatoryTcNo').enable();
                        Ext.getCmp('mandatoryMineCodelabel').enable();

                        Ext.getCmp('mandatorypayable').hide();
                        Ext.getCmp('mandatorypayable1').hide();
                        Ext.getCmp('payableLabelId').hide();
                        Ext.getCmp('PayableId').hide();

                        Ext.getCmp('organizationcodeComboid').reset();
                        Ext.getCmp('orgTraderNameId').reset();

                        Ext.getCmp('mandatoryorgTraderId').enable();
                        Ext.getCmp('orgTraderId').enable();
                        Ext.getCmp('organizationcodeComboid').setReadOnly(true);
                        Ext.getCmp('labelLastId').disable();

                        Ext.getCmp('orgTraderNameLabelId').enable();

                    }
                    if (Ext.getCmp('challantypeId').getValue() == 'ROM') {

                        Ext.getCmp('TccomboId').reset();
                        Ext.getCmp('mandatoryTypeclose').show(),
                        Ext.getCmp('mandatoryTypeclose1').show(),
                        Ext.getCmp('typeclose').show(),
                        Ext.getCmp('closecomboId').show();

                        Ext.getCmp('TccomboId').setReadOnly(false);
                        Ext.getCmp('TcNoLabelId').enable();
                        Ext.getCmp('mandatoryTcNo').enable();
                        Ext.getCmp('mandatoryMineCodelabel').enable();

                        Ext.getCmp('mandatorypayable').hide();
                        Ext.getCmp('mandatorypayable1').hide();
                        Ext.getCmp('payableLabelId').hide();
                        Ext.getCmp('PayableId').hide();

                        Ext.getCmp('orgTraderNameLabelId').enable();
                        Ext.getCmp('organizationcodeComboid').reset();
                        Ext.getCmp('orgTraderNameId').reset();

                        Ext.getCmp('mandatoryorgTraderId').enable();
                        Ext.getCmp('orgTraderId').enable();
                        Ext.getCmp('organizationcodeComboid').setReadOnly(true);
                        Ext.getCmp('labelLastId').disable();
                    } else {
                        Ext.getCmp('mandatoryTypeclose').hide(),
                        Ext.getCmp('mandatoryTypeclose1').hide(),
                        Ext.getCmp('typeclose').hide(),
                        Ext.getCmp('closecomboId').hide();

                        Ext.getCmp('TccomboId').setReadOnly(false);
                        Ext.getCmp('TcNoLabelId').enable();
                        Ext.getCmp('mandatoryTcNo').enable();
                        Ext.getCmp('mandatoryMineCodelabel').enable();

                        Ext.getCmp('mandatorypayable').hide();
                        Ext.getCmp('mandatorypayable1').hide();
                        Ext.getCmp('payableLabelId').hide();
                        Ext.getCmp('PayableId').hide();

                        Ext.getCmp('orgTraderNameLabelId').enable();
                        Ext.getCmp('organizationcodeComboid').reset();
                        Ext.getCmp('orgTraderNameId').reset();

                        Ext.getCmp('mandatoryorgTraderId').enable();
                        Ext.getCmp('orgTraderId').enable();
                        Ext.getCmp('organizationcodeComboid').setReadOnly(true);
                        Ext.getCmp('labelLastId').disable();
                    }

                    if (Ext.getCmp('challantypeId').getValue() == 'Processed Ore' || Ext.getCmp('challantypeId').getValue() == 'Others') {
                        challanDetailsPanel.hide();
                    } else {
                        challanDetailsPanel.show();
                    }
                    editedRows = "";
                    editedRowsForBuGrid = "";
                    if (Ext.getCmp('challantypeId').getValue() == 'Bauxite Challan') {
                        gridPanelForBauxite.show();
                        outerPanelForBauxiteGrid.show();
                        gridPanel.hide();
                        outerPanelForGrid2.hide();
                        outerPanelForGrid.hide();
                        ewalletChallanPanel.hide();
                        challanDetailsPanel.hide();
                        Ext.getCmp('mandatorDateId').show();
                        Ext.getCmp('dateLabelId').show();
                        Ext.getCmp('dateId').show();
                        Ext.getCmp('mandatorydate16').show();

                        Ext.getCmp('TccomboId').setReadOnly(false);
                        Ext.getCmp('TcNoLabelId').enable();
                        Ext.getCmp('mandatoryTcNo').enable();
                        Ext.getCmp('mandatoryMineCodelabel').enable();

                        Ext.getCmp('mandatorypayable').hide();
                        Ext.getCmp('mandatorypayable1').hide();
                        Ext.getCmp('payableLabelId').hide();
                        Ext.getCmp('PayableId').hide();

                        Ext.getCmp('orgTraderNameLabelId').enable();
                        Ext.getCmp('organizationcodeComboid').reset();
                        Ext.getCmp('orgTraderNameId').reset();

                        Ext.getCmp('mandatoryorgTraderId').enable();
                        Ext.getCmp('orgTraderId').enable();
                        Ext.getCmp('organizationcodeComboid').setReadOnly(true);
                        Ext.getCmp('labelLastId').disable();

                        Ext.getCmp('mineralTypecomboId').setValue('BAUXITE');
                        storeForBauxite.load({
                            params: {
                                CustID: Ext.getCmp('custcomboId').getValue(),
                                id: 0
                            }
                        });
                    }
                    if (Ext.getCmp('challantypeId').getValue() == 'Processing Fee') {

                        gridPanel.hide();
                        ewalletChallanPanel.hide();
                        outerPanelForGrid2.hide();
                        outerPanelForGrid.hide();
                        outerPanelForBauxiteGrid.hide();
                        gridPanelForBauxite.hide();

                        Ext.getCmp('typeComboId').reset();

                        Ext.getCmp('typeComboId').hide();
                        Ext.getCmp('mandatoryTypeid1').hide();
                        Ext.getCmp('typeAdjLabelId1').hide();
                        Ext.getCmp('mandatorydtLabel1').hide();

                        Ext.getCmp('mandatorypayable').show();
                        Ext.getCmp('mandatorypayable1').show();
                        Ext.getCmp('payableLabelId').show();
                        Ext.getCmp('PayableId').show();

                        Ext.getCmp('TccomboId').setValue('');
                        Ext.getCmp('mplAllocatedId').setValue('');
                        Ext.getCmp('mplBalId').setValue('');

                        Ext.getCmp('mandatorypayable').show();
                        Ext.getCmp('mandatorypayable1').show();
                        Ext.getCmp('payableLabelId').show();
                        Ext.getCmp('PayableId').show();

                        Ext.getCmp('mandatorypayable').show();
                        Ext.getCmp('mandatorypayable1').show();
                        Ext.getCmp('payableLabelId').show();
                        Ext.getCmp('PayableId').show();

                        Ext.getCmp('TccomboId').setReadOnly(true);
                        Ext.getCmp('TcNoLabelId').enable();
                        Ext.getCmp('mandatoryTcNo').enable();
                        Ext.getCmp('mandatoryMineCodelabel').disable();

                        Ext.getCmp('MineCodeId').setValue('');
                        Ext.getCmp('leaseNameId').setValue('');
                        Ext.getCmp('MineOwnerId').setValue('');
                        Ext.getCmp('orgNameId').setValue('');

                        Ext.getCmp('orgTraderNameLabelId').enable();

                        Ext.getCmp('mandatoryorgTraderId').enable();
                        Ext.getCmp('orgTraderId').enable();
                        Ext.getCmp('organizationcodeComboid').setReadOnly(false);
                        Ext.getCmp('labelLastId').enable();


                        Ext.getCmp('typeComboId').reset();
                        Ext.getCmp('typeComboId').hide();
                        Ext.getCmp('mandatoryTypeid1').hide();
                        Ext.getCmp('typeAdjLabelId1').hide();
                        Ext.getCmp('mandatorydtLabel1').hide();
                        
                         Ext.getCmp('TransMonthId').setValue('');
                    	Ext.getCmp('royaltydatelab').setValue('');
                        Ext.getCmp('TransMonthId').setReadOnly(true);
                    	Ext.getCmp('royaltydatelab').setReadOnly(true);

                        organizationCodeStore.load({
                            params: {
                                CustId: Ext.getCmp('custcomboId').getValue()
                            }
                        });
                    }else{
                    	Ext.getCmp('TransMonthId').setReadOnly(false);
                    	Ext.getCmp('royaltydatelab').setReadOnly(false);
                    }
                }
            }
        }
    });


    var mineOwnerComboStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/ChallanDetailsAction.do?param=getMineOwner',
        root: 'mineOwnerRoot',
        autoLoad: false,
        fields: ['mineOwnerId', 'mineOwnerName']
    });
    var mineOwnerCombo = new Ext.form.ComboBox({
        store: mineOwnerComboStore,
        id: 'ownercomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_Lease_NoMine_Owner%>',
        blankText: '<%=Select_Lease_NoMine_Owner%>',
        resizable: true,
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'mineOwnerId',
        displayField: 'mineOwnerName',
        cls: 'selectstylePerfect',
        listeners: {

        }
    });

    var TcNoComboStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/ChallanDetailsAction.do?param=getTcNumber',
        root: 'TcNumberRoot',
        autoLoad: false,
        fields: ['MiningName', 'TCno', 'TCID', 'MineCode', 'ownerName', 'orgName', 'quantity','ecAllocated','mplBal']
    });

    var TcNoCombo = new Ext.form.ComboBox({
        store: TcNoComboStore,
        id: 'TccomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_TC_Number%>',
        blankText: '<%=Select_TC_Number%>',
        resizable: true,
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
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
                    leaseName = rec.data['MiningName'];
                    mineCode = rec.data['MineCode'];
                    ownerName = rec.data['ownerName'];
                    orgName = rec.data['orgName'];
                    quantity = rec.data['quantity'];
                    ecAllocated= rec.data['ecAllocated'];
                    mplBal= rec.data['mplBal'];
                    Ext.getCmp('leaseNameId').setValue(leaseName);
                    Ext.getCmp('MineCodeId').setValue(mineCode);
                    Ext.getCmp('MineOwnerId').setValue(ownerName);
                    Ext.getCmp('orgNameId').setValue(orgName);
                    Ext.getCmp('balanceId').setValue(quantity);
                    Ext.getCmp('mplBalId').setValue(mplBal);
                    Ext.getCmp('mplAllocatedId').setValue(ecAllocated);
                    Ext.getCmp('challanCheckBoxId').setValue(false);
                    gradeStore.load({
                          params: {
                              CustID: Ext.getCmp('custcomboId').getValue(),
                              type: Ext.getCmp('challantypeId').getValue(),
                              id: 0
                          }
                    });
                    Store2.load({
                        params: {
                            CustID: Ext.getCmp('custcomboId').getValue(),
                            type: 'Others',
                            tcno: Ext.getCmp('TccomboId').getValue(),
                            id: 0
                        }
                    });

                    Ext.getCmp('closecomboId').reset();
                    if (Ext.getCmp('challantypeId').getValue() == 'ROM') {
                        closeComboStore.load({
                            params: {
                                CustID: Ext.getCmp('custcomboId').getValue(),
                                tcId: Ext.getCmp('TccomboId').getValue()
                            }
                        });
                    } else {
                        closeComboStore.load({
                            params: {
                                CustID: 0,
                                tcId: 0
                            }
                        });
                    }
                    editedRowsForBuGrid = "";
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
        fields: ['id', 'organizationCode', 'organizationName']
    });
    //****************************combo for orgcode****************************************
    var organizationCodeCombo = new Ext.form.ComboBox({
        store: organizationCodeStore,
        id: 'organizationcodeComboid',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Organization/Trader Name',
        blankText: 'Select Organization/Trader Name',
        resizable: true,
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'id',
        displayField: 'organizationName',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    var row = organizationCodeStore.findExact('id', Ext.getCmp('organizationcodeComboid').getValue());
                    var rec = organizationCodeStore.getAt(row);
                    var organisationCode = rec.data['organizationCode'];
                    Ext.getCmp('orgTraderNameId').setValue(organisationCode);
                }
            }
        }
    });

    var mineralTypeComboStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/ChallanDetailsAction.do?param=getMineralType',
        root: 'mineralTypeRoot',
        autoLoad: false,
        fields: ['mineralCode', 'mineralName']
    });

    var mineralTypeCombo = new Ext.form.ComboBox({
        store: mineralTypeComboStore,
        id: 'mineralTypecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_Mineral_Type%>',
        blankText: '<%=Select_Mineral_Type%>',
        resizable: true,
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'mineralCode',
        displayField: 'mineralName',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    gradeComboStore.load({
                        params: {
                            mineralType: Ext.getCmp('mineralTypecomboId').getValue(),
                            CustID: Ext.getCmp('custcomboId').getValue(),
                            RoyaltyDate: Ext.getCmp('royaltydatelab').getValue()
                        }
                    });
                    gradeStore.load({
                        params: {
                            CustID: Ext.getCmp('custcomboId').getValue(),
                            type: Ext.getCmp('challantypeId').getValue(),
                            id: 0
                        }
                    });
                }
            }
        }
    });

    var gradeComboStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/ChallanDetailsAction.do?param=getGradeAndRate',
        root: 'gradeRoot',
        autoLoad: false,
        fields: ['rate', 'grade','Giopfrate']
    });


    var gradeCombo = new Ext.form.ComboBox({
        store: gradeComboStore,
        id: 'gradecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=Select_Grade%>',
        blankText: '<%=Select_Grade%>',
        resizable: true,
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'grade',
        displayField: 'grade',
        width: 100,
        listeners: {
            select: {
                fn: function() {
                    gradeSelect = true;
                    grdeselect = Ext.getCmp('gradecomboId').getValue();
                }
            }
        }
    });

    var eWalletStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/ChallanDetailsAction.do?param=getEwalletNumber',
        root: 'eWalletRoot',
        autoLoad: false,
        remoteSort: true,
        id: 'eWallet',
        fields: ['ewalletNo', 'qty', 'amount', 'usedQty', 'usedAmount', 'ewalletId','giopfStatus']
    });


    var closeComboStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/ChallanDetailsAction.do?param=getClosedPermitNo',
        root: 'closePermitRoot',
        autoLoad: false,
        remoteSort: true,
        id: 'close',
        fields: ['permit_id', 'permit_no']
    });

    var closeCombo = new Ext.form.ComboBox({
        store: closeComboStore,
        id: 'closecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Permit',
        blankText: 'Select Permit',
        resizable: true,
        selectOnFocus: true,
        allowBlank: true,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'permit_id',
        displayField: 'permit_no',
        width: 150,
        hidden: true,
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    var ewalletNumber;
                    var amt;
                    var qty;
                    var usedQty;
                    var usedAmount;
                    gradeStore.load({
		            params: {
		                CustID: Ext.getCmp('custcomboId').getValue(),
		                type: 'E-Wallet Challan',
		                id: 0
			            }
			        });
                    eWalletStore.load({
                        params: {
                            permitId: Ext.getCmp('closecomboId').getValue(),
                            custId: Ext.getCmp('custcomboId').getValue(),
                        },
                        callback: function() {
                            for (var i = 0; i < eWalletStore.getCount(); i++) {
                                var rec = eWalletStore.getAt(i);
                                ewalletNumber = rec.data['ewalletNo'];
                                amt = rec.data['amount'];
                                qty = rec.data['qty'];
                                usedQty = rec.data['usedQty'];
                                usedAmount = rec.data['usedAmount'];
                                ewalletId = rec.data['ewalletId'];
                                giopfStatus= rec.data['giopfStatus'];
                            }
                            if (parseFloat(usedQty) == 0 && parseFloat(usedAmount) == 0) {
                                Ext.getCmp('eWalletNo').setValue(ewalletNumber);
                                Ext.getCmp('eWalletQty').setValue(qty);
                                Ext.getCmp('ewalletAmtId').setValue(amt);
                            } else {
                                Ext.getCmp('eWalletNo').setValue(ewalletNumber);
                                var eQty = parseFloat(qty) - parseFloat(usedQty);
                                var eAmt = parseFloat(amt) - parseFloat(usedAmount);
                                if (parseFloat(eAmt) < 0) {
                                    eAmt = 0;
                                }
                                Ext.getCmp('eWalletQty').setValue(eQty);
                                Ext.getCmp('ewalletAmtId').setValue(eAmt);
                            }
                        }
                    });
                }
            }
        }
    });
    // **********************************************Reader configs Starts******************************

    var reader = new Ext.data.JsonReader({
        idProperty: 'tripcreationId',
        root: 'challanDetailsRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'uniqueIdDataIndex'
        }, {
            name: 'challanNumberDataIndex'
        }, {
            name: 'openStatusDataIndex'
        }, {
            name: 'paymentAcHeadDataIndex'
        }, {
            name: 'paymentAcHeadIdDataIndex'
        }, {
            name: 'TCNODataIndex'
        }, {
            name: 'TCNOIdDataIndex'
        }, {
            name: 'MineNameDataIndex'
        }, {
            name: 'orgNameDataIndex'
        }, {
            name: 'totalQtyDataIndex'
        }, {
            name: 'usedQtyDataIndex'
        }, {
            name: 'royaltyAmtDataIndex'
        }, {
            name: 'DMFDataIndex'
        }, {
            name: 'NMETDataIndex'
        }, {
            name: 'GIDataIndex'
        }, {
            name: 'pFeeAmtDataIndex'
        }, {
            name: 'totalPayableDataIndex'
        }, {
            name: 'payableDataIndex'
        }, {
            name: 'typeDataIndex'
        }, {
            name: 'MineCodeDataIndex'
        }, {
            name: 'ownerNameDataIndex'
        }, {
            name: 'royaltyDataIndex',
        }, {
        	type: 'date',
    		dateFormat: getMonthYearFormat(),
            name: 'TransMonthIndex',
        }, {
            name: 'royaltyDateDataIndex',
        }, {
            name: 'mineralTypeDataIndex'
        }, {
            name: 'mineralCodeDataIndex'
        }, {
            name: 'challanTypeDataIndex'
        }, {
            name: 'financialYrDataIndex'
        }, {
            name: 'paymentDescriptionDataIndex'
        }, {
        	type: 'date',
    		dateFormat: getDateFormat(),
            name: 'dateDataIndex'
        }, {
            name: 'challanNoDataIndex'
        }, {
            name: 'challanDateDataIndex'
        }, {
            name: 'transactionDataIndex'
        }, {
            name: 'bankDataIndex'
        }, {
            name: 'branchDataIndex'
        }, {
            name: 'amountDataIndex'
        }, {
            name: 'paymentDataIndex'
        }, {
            name: 'AckGenDataIndex'
        }, {
            name: 'closedPermitIdDataIndex'
        }, {
            name: 'closedPermitNoDataIndex'
        }, {
            name: 'ewalletBalance2DataIndex'
        }, {
            name: 'ewalletBalanceDataIndex'
        }, {
            name: 'ewalletPayableDataIndex'
        }, {
            name: 'pFeeDataIndex'
        },  {
            name: 'DMFchallanNoDataIndex'
        }, {
            name: 'NMETchallanNoDataIndex'
        }, {
            name: 'PFchallanNoDataIndex'
        }, {
            name: 'GIchallanNoDataIndex'
        }, {
            name: 'DMFchallanDateDataIndex'
        }, {
            name: 'NMETchallanDateDataIndex'
        }, {
            name: 'PFchallanDateDataIndex'
        }, {
            name: 'GIchallanDateDataIndex'
        }, {
            name: 'organizationIdDataIndex'
        }, {
            name: 'organizationCodeDataIndex'
        }, {
        	name: 'EWC_ID_Ind'
        }, {
        	name: 'insertedTimeInd',
        	dateFormat: getDateTimeFormat(),
        }, {
        	name: 'districtNameInd'
        }]
    });

    // **********************************************Reader configs Ends******************************
    //********************************************Store Configs For Grid*************************

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/ChallanDetailsAction.do?param=getChallanDetails',
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
        }, {
            type: 'numeric',
            dataIndex: 'uniqueIdDataIndex'
        }, {
            type: 'string',
            dataIndex: 'challanNumberDataIndex'
        }, {
            type: 'string',
            dataIndex: 'openStatusDataIndex'
        }, {
            type: 'string',
            dataIndex: 'paymentAcHeadDataIndex'
        }, {
            type: 'string',
            dataIndex: 'paymentAcHeadIdDataIndex'
        }, {
            type: 'string',
            dataIndex: 'TCNODataIndex'
        }, {
            type: 'string',
            dataIndex: 'TCNOIdDataIndex'
        }, {
            type: 'string',
            dataIndex: 'MineNameDataIndex'
        }, {
            type: 'string',
            dataIndex: 'orgNameDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'totalQtyDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'usedQtyDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'royaltyAmtDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'DMFDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'NMETDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'GIDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'pFeeAmtDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'payableDataIndex'
        }, {
            type: 'string',
            dataIndex: 'typeDataIndex'
        }, {
            type: 'string',
            dataIndex: 'MineCodeDataIndex'
        }, {
            type: 'string',
            dataIndex: 'ownerNameDataIndex'
        }, {
            type: 'string',
            dataIndex: 'royaltyDataIndex'
        }, {
            type: 'date',
            dateFormat: getMonthYearFormat(),
	        onText: '',  
            dataIndex: 'TransMonthIndex'
        },{
            type: 'date',
            dataIndex: 'royaltyDateDataIndex'
        }, {
            type: 'string',
            dataIndex: 'mineralTypeDataIndex'
        }, {
            type: 'string',
            dataIndex: 'mineralCodeDataIndex'
        }, {
            type: 'string',
            dataIndex: 'challanTypeDataIndex'
        }, {
            type: 'string',
            dataIndex: 'financialYrDataIndex'
        }, {
            type: 'string',
            dataIndex: 'paymentDescriptionDataIndex'
        }, {
            type: 'date',
            dataIndex: 'dateDataIndex'
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
        }, {
            type: 'numeric',
            dataIndex: 'amountDataIndex'
        }, {
            type: 'string',
            dataIndex: 'paymentDataIndex'
        }, {
            type: 'string',
            dataIndex: 'AckGenDataIndex'
        }, {
            type: 'int',
            dataIndex: 'closedPermitIdDataIndex'
        }, {
            type: 'string',
            dataIndex: 'closedPermitNoDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'totalPayableDataIndex'
        }, {
            type: 'string',
            dataIndex: 'ewalletBalance2DataIndex'
        }, {
            type: 'string',
            dataIndex: 'ewalletBalanceDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'ewalletPayableDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'pFeeDataIndex'
        }, {
            type: 'string',
            dataIndex: 'DMFchallanNoDataIndex'
        }, {
            type: 'string',
            dataIndex: 'NMETchallanNoDataIndex'
        }, {
            type: 'string',
            dataIndex: 'PFchallanNoDataIndex'
        }, {
            type: 'string',
            dataIndex: 'GIchallanNoDataIndex'
        }, {
            type: 'date',
            dataIndex: 'DMFchallanDateDataIndex'
        }, {
            type: 'date',
            dataIndex: 'NMETchallanDateDataIndex'
        }, {
            type: 'date',
            dataIndex: 'PFchallanDateDataIndex'
        }, {
            type: 'date',
            dataIndex: 'GIchallanDateDataIndex'
        }, {
            type: 'int',
            dataIndex: 'organizationIdDataIndex'
        }, {
            type: 'string',
            dataIndex: 'organizationCodeDataIndex'
        }, {
            type: 'date',
            dataIndex: 'insertedTimeInd'
        }, {
        	type: 'string',
        	dataIndex: 'districtNameInd'
        }]
    });

    //***************************************************Filter Config Ends ***********************

    //*********************************************Column model config**********************************
    var createColModel = function(finish, start) {

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
            }, {
                header: "<span style=font-weight:bold;><%=Challan_Number%></span>",
                dataIndex: 'challanNumberDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Status</span>",
                dataIndex: 'openStatusDataIndex',
                hidden: false,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=Payment_Acc_Head%></span>",
                dataIndex: 'paymentAcHeadDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Payment Account Head Id</span>",
                dataIndex: 'paymentAcHeadIdDataIndex',
                hidden: true,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TC_Number%></span>",
                dataIndex: 'TCNODataIndex',
                sortable: true,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Tc Number Id</span>",
                dataIndex: 'TCNOIdDataIndex',
                sortable: true,
                hidden: true,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Lease Name</span>",
                dataIndex: 'MineNameDataIndex',
                sortable: true,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Organisation Name</span>",
                dataIndex: 'orgNameDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Total Quantity</span>",
                dataIndex: 'totalQtyDataIndex',
                align: 'right',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>Used Quantity</span>",
                dataIndex: 'usedQtyDataIndex',
                align: 'right',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>Royalty</span>",
                dataIndex: 'royaltyAmtDataIndex',
                align: 'right',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>DMF</span>",
                dataIndex: 'DMFDataIndex',
                align: 'right',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>NMET</span>",
                dataIndex: 'NMETDataIndex',
                align: 'right',
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;>GIOPF</span>",
                dataIndex: 'GIDataIndex',
                align: 'right',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>Processing Fee Amount</span>",
                dataIndex: 'pFeeAmtDataIndex',
                align: 'right',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>PF Payable</span>",
                dataIndex: 'totalPayableDataIndex',
                hidden: false,
                align: 'right',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>Total Challan Amount</span>",
                align: 'right',
                dataIndex: 'payableDataIndex',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=Type%></span>",
                dataIndex: 'typeDataIndex',
                sortable: true,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=Mine_Code%></span>",
                dataIndex: 'MineCodeDataIndex',
                sortable: true,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Mine Owner</span>",
                dataIndex: 'ownerNameDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>IBM Average Sale Price Month</span>",
                dataIndex: 'royaltyDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Transportation Month</span>",
                dataIndex: 'TransMonthIndex',
                renderer: Ext.util.Format.dateRenderer(getMonthYearFormat()),
                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;>Royalty date</span>",
                dataIndex: 'royaltyDateDataIndex',
                hidden: true,
                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;><%=Mineral_Type%></span>",
                dataIndex: 'mineralTypeDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Mineral Code</span>",
                dataIndex: 'mineralCodeDataIndex',
                hidden: true,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Challan Type</span>",
                dataIndex: 'challanTypeDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Financial Year</span>",
                dataIndex: 'financialYrDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=Payment_Description%></span>",
                dataIndex: 'paymentDescriptionDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Date</span>",
                dataIndex: 'dateDataIndex',
                renderer: Ext.util.Format.dateRenderer(getDateFormat()),
                hidden: false,
                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;><%=BankTransactionNumber%></span>",
                dataIndex: 'transactionDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=Bank%></span>",
                dataIndex: 'bankDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=Branch%></span>",
                dataIndex: 'branchDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=AmountPaid%></span>",
                dataIndex: 'amountDataIndex',
                align: 'right',
                hidden: true,
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=Payment_Description%></span>",
                dataIndex: 'paymentDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=Acknowledgement_Generation_Datetime%></span>",
                dataIndex: 'AckGenDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Closed Permit ID</span>",
                dataIndex: 'closedPermitIdDataIndex',
                hidden: true,
                filter: {
                    type: 'int'
                }
            }, {
                header: "<span style=font-weight:bold;>Closed Permit NO</span>",
                dataIndex: 'closedPermitNoDataIndex',
                hidden: true,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>E-Wallet Balance</span>",
                dataIndex: 'ewalletBalance2DataIndex',
                align: 'right',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>E-Wallet Used</span>",
                dataIndex: 'ewalletBalanceDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Total Payable</span>",
                dataIndex: 'ewalletPayableDataIndex',
                align: 'right',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>Processing Fee</span>",
                dataIndex: 'pFeeDataIndex',
                align: 'right',
                hidden: true,
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>Royalty Challan No</span>",
                dataIndex: 'challanNoDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Royalty Challan Date</span>",
                dataIndex: 'challanDateDataIndex',
                renderer: Ext.util.Format.dateRenderer(getDateFormat()),
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>DMF Challan No</span>",
                dataIndex: 'DMFchallanNoDataIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>DMF Challan Date</span>",
                dataIndex: 'DMFchallanDateDataIndex',
                renderer: Ext.util.Format.dateRenderer(getDateFormat()),
                hidden: false,
                filter: {
                    type: 'date'
                }
            },{
                header: "<span style=font-weight:bold;>NMET Challan No</span>",
                dataIndex: 'NMETchallanNoDataIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>NMET Challan Date</span>",
                dataIndex: 'NMETchallanDateDataIndex',
                renderer: Ext.util.Format.dateRenderer(getDateFormat()),
                hidden: false,
                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;>PF Challan No</span>",
                dataIndex: 'PFchallanNoDataIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>PF Challan Date</span>",
                dataIndex: 'PFchallanDateDataIndex',
                renderer: Ext.util.Format.dateRenderer(getDateFormat()),
                hidden: false,
                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;>GIOPF Challan No</span>",
                dataIndex: 'GIchallanNoDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>GIOPF Challan Date</span>",
                dataIndex: 'GIchallanDateDataIndex',
                renderer: Ext.util.Format.dateRenderer(getDateFormat()),
                hidden: false,
                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;>orgId</span>",
                dataIndex: 'organizationIdDataIndex',
                hidden: true,
                filter: {
                    type: 'int'
                }
            }, {
                header: "<span style=font-weight:bold;>Organization/Trader Code</span>",
                dataIndex: 'organizationCodeDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Issued Date Time</span>",
                dataIndex: 'insertedTimeInd',
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                hidden: true,
                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;>District Name</span>",
                dataIndex: 'districtNameInd',
            }
        ];
        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };
    //*********************************************Column model config Ends*************************** 	
    //******************************************Creating Grid By Passing Parameter***********************
	if(<%=userAuthority.equalsIgnoreCase("User")%>){
		grid = getGrid('<%=Challan_Details%>', '<%=noRecordsFound%>', store, screen.width - 40, 380, 70, filters, 'Clear Filter Data', false, '', 20, false, '', false, 'Approval', true, 'Excel', jspName, exportDataType, false, 'PDF', false, 'Add', false, 'Modify', false, 'Delete', false, '', false, '', true, 'PDF', false, 'Final Submit', false, '');
	}else{
	    grid = getGrid('<%=Challan_Details%>', '<%=noRecordsFound%>', store, screen.width - 40, 380, 70, filters, 'Clear Filter Data', false, '', 20, false, '', <%=approvalAuth%>, 'Approval', true, 'Excel', jspName, exportDataType, false, 'PDF', true, 'Add', true, 'Modify', <%=delAuth%>, 'Delete', false, '', false, '', true, 'PDF', <%=finalSubAuth%>, 'Final Submit', false, '');
	}
    //**********************************End Of Creating Grid By Passing Parameter*************************
    var customerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'customerMaster',
        layout: 'table',
        cls: 'innerpanelsmallest',
        frame: false,
        width: '100%',
        layoutConfig: {
            columns: 13
        },
        items: [
            {
                xtype: 'label',
                text: '<%=selectCustomer%>' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
            },
            custnamecombo,
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
                                        Ext.getCmp('challanReportPanelId').collapse();
						                Ext.getCmp('radioGroupId').reset();
						                Ext.getCmp('SearchTextId').reset();
						                Ext.getCmp('SearchOrgComboId').reset();
						                Ext.getCmp('radioGroupId1').reset();
						                Ext.getCmp('ReportDateId').reset();
	                	    			Ext.getCmp('ReportOrgComboId').reset();
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
                                            var dateDifrnc = new Date(Enddates).add(Date.DAY, -31);
                                            if (Startdates < dateDifrnc) {
                                                Ext.example.msg("Difference between two dates should not be  greater than 31 days.");
                                                Ext.getCmp('startdate').focus();
                                                return;
                                            }
                                        	store.load({
			                                    params: {
			                                        CustID: Ext.getCmp('custcomboId').getValue(),
			                                        jspName: jspName,
			                                        CustName: Ext.getCmp('custcomboId').getRawValue(),
			                                        endDate: Ext.getCmp('enddate').getValue(),
						                            startDate: Ext.getCmp('startdate').getValue()
			                                    }
			                                });
                                        }
                                    }
        ]
    });

    //****************************** Inner Pannel  Adding Inforamtion ***************

    //****************************************asset Owner Details*******************************//
    var ownerChalanDetailsPanel = new Ext.form.FormPanel({
        standardSubmit: true,
        collapsible: false,
        frame: false,
        id: 'OwnerDetailsId',
        items: [{
            xtype: 'fieldset',
            width: 500,
            title: '<%=Mine_Owner_Chalan_Details%>',
            id: 'OwnerDetailspanelId',
            collapsible: false,
            layout: 'table',
            layoutConfig: {
                columns: 5
            },
            items: [{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryPaymentACHead1'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryPaymentACHead'
            }, {
                xtype: 'label',
                text: '<%=Payment_Acc_Head%>' + '  :',
                cls: 'labelstyle',
                id: 'OwnerNameLabelId'
            }, {
                width: 10
            }, paymentCombo, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryPaymentACHead3'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryChallanId'
            }, {
                xtype: 'label',
                text: 'Type Of Challan' + '  :',
                cls: 'labelstyle',
                id: 'challanLabelId'
            }, {
                width: 10
            }, challanTypeCombo, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryTypeAdj',
                hidden: true
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryTcNo'
            }, {
                xtype: 'label',
                text: '<%=TC_Number%>' + '  :',
                cls: 'labelstyle',
                id: 'TcNoLabelId'
            }, {
                width: 10
            }, TcNoCombo, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryMineCodelabel'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryMplAllo'
            }, {
                xtype: 'label',
                text: 'Mpl Allocated' + ' :',
                cls: 'labelstyle',
                id: 'mplalloLabelId'
            }, {
                width: 10
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                autoCreate: { //restricts 
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "200",
                    autocomplete: "off"
                },
                id: 'mplAllocatedId',
                readOnly: true,
                mode: 'local'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorymplalo2'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryMplBal'
            }, {
                xtype: 'label',
                text: 'Mpl Balance' + ' :',
                cls: 'labelstyle',
                id: 'mplBalLabelId'
            }, {
                width: 10
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                autoCreate: { //restricts 
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "200",
                    autocomplete: "off"
                },
                id: 'mplBalId',
                readOnly: true,
                mode: 'local'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorymplbal2'
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryMineCode'
            }, {
                xtype: 'label',
                text: '<%=Mine_Code%>' + ' :',
                cls: 'labelstyle',
                id: 'MineCodeLabelId'
            }, {
                width: 10
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                autoCreate: { //restricts 
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "200",
                    autocomplete: "off"
                },
                id: 'MineCodeId',
                readOnly: true,
                mode: 'local'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryPaymentACHead4'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryMiningLease'
            }, {
                xtype: 'label',
                text: 'Lease Name' + ' :',
                cls: 'labelstyle',
                id: 'leaseNameLabelId'
            }, {
                width: 10
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                autoCreate: { //restricts 
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "200",
                    autocomplete: "off"
                },
                id: 'leaseNameId',
                readOnly: true,
                mode: 'local'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryPaymentACHead8'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryleaseNo'
            }, {
                xtype: 'label',
                text: 'Mine Owner' + '  :',
                cls: 'labelstyle',
                id: 'leaseNoLabelId'
            }, {
                width: 10
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                autoCreate: { //restricts 
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "200",
                    autocomplete: "off"
                },
                id: 'MineOwnerId',
                readOnly: true,
                mode: 'local',
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryorg'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryorgLabel'
            }, {
                xtype: 'label',
                text: 'Organization Name' + ' :',
                cls: 'labelstyle',
                id: 'orgNameLabelId'
            }, {
                width: 10
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                autoCreate: { //restricts 
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "200",
                    autocomplete: "off"
                },
                id: 'orgNameId',
                readOnly: true,
                mode: 'local'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryFinance'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryorgTraderId'
            }, {
                xtype: 'label',
                text: 'Organization/Trader Name' + ' :',
                cls: 'labelstyle',
                id: 'orgTraderId'
            }, {
                width: 10
            }, organizationCodeCombo, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'labelLastId'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryorgTraderNameId',
                disabled: true
            }, {
                xtype: 'label',
                text: 'Organization/Trader Code' + ' :',
                cls: 'labelstyle',
                id: 'orgTraderNameLabelId'
            }, {
                width: 10
            }, {
                xtype: 'textarea',
                cls: 'textareastyle',
                stripCharsRe: /[,]/,
                height: 60,
                id: 'orgTraderNameId',
                readOnly: true,
                mode: 'local'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorydate16',
                //hidden: true
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorDateId',
                //hidden: true
            }, {
                xtype: 'label',
                text: 'Date' + ' :',
                cls: 'labelstyle',
                id: 'dateLabelId',
                //hidden: true
            }, {
                width: 10
            }, {
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                id: 'dateId',
                emptyText: 'Select Date',
                blankText: 'Select Date',
                format: getDateFormat(),
                submitFormat: getDateFormat(),
                value: dtcur,
                listeners: {
                    change: {
                        fn: function(f,n,o) {
                            date=Ext.getCmp('dateId').getValue();
                            Fyear=date.getFullYear();
                            preFYear = date.getFullYear() - 1;
    						nextFYear = date.getFullYear() + 1;
                        	if (date.getMonth() >= 3) {
						        Year = Fyear + '-' + nextFYear;
						    } else {
						        Year = preFYear + '-' + Fyear;
						    }
						    Ext.getCmp('financeId').setValue(Year);
                        }
                    }
                }
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'labelLast1Id',
                disabled: true
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryFinanceLabel'
            }, {
                xtype: 'label',
                text: 'Financial Year' + ' :',
                cls: 'labelstyle',
                id: 'financeLabelId'
            }, {
                width: 10
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                stripCharsRe: /[,]/,
                autoCreate: { //restricts 
                    tag: "input",
                    maxlength: 50,
                    type: "text",
                    size: "200",
                    autocomplete: "off"
                },
                id: 'financeId',
                disabled: false,
                mode: 'local',
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryChallan'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                hidden: true,
                id: 'mandatoryTypeid1'
            }, {
                xtype: 'label',
                text: 'Type' + '  :',
                cls: 'labelstyle',
                hidden: true,
                id: 'typeAdjLabelId1'
            }, {
                width: 10
            }, typeCombo, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorypayable',
                hidden: true
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorypayable1',
                hidden: true
            }, {
                xtype: 'label',
                text: 'Total Payable ' + '  :',
                cls: 'labelstyle',
                id: 'payableLabelId',
                hidden: true
            }, {
                width: 10
            }, {
                xtype: 'numberfield',
                cls: 'selectstylePerfect',
                id: 'PayableId',
                decimalPrecision: 2,
                emptyText: 'Enter Total Payable',
                blankText: 'Enter Total Payable',
                allowNegative: false,
                autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
                listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
                hidden: true
            }, {
                xtype: 'label',
                text: '',
                hidden: true,
                cls: 'mandatoryfield',
                id: 'mandatoryTransMonth1'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryTransMonth2'
            }, {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'TransMonthLabel',
                text: 'Transportation month :'
            }, {
                width: 10
            }, {
                xtype: 'datefield',
                format: getMonthYearFormat(),
                submitFormat: getMonthYearFormat(),
                emptyText: 'Select Month',
                blankText: 'Select Month',
                plugins: 'monthPickerPlugin',
                id: 'TransMonthId',
                value: dtcur,
                vtype: 'daterange',
                cls: 'selectstylePerfect',
                listeners: {
                    change: {
                        fn: function(f,n,o) {
                        var d1= Date.parse(new Date(new Date().getFullYear(), new Date().getMonth(), 1,0,0,0,0));
                        var d2= Date.parse(Ext.getCmp('TransMonthId').getValue());
                       	 if(d1 > d2){
                       	 	Ext.example.msg("Transportation month can't be past month.");
                       	 	Ext.getCmp('TransMonthId').setValue('');
                       	 }
                        }
                    }
                }
            }, {
                xtype: 'label',
                text: '',
                hidden: true,
                cls: 'mandatoryfield',
                id: 'mandatorydtLabel1'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorydt'
            }, {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'royaltydatelable',
                text: 'IBM Average Sale Price Month  :'
            }, {
                width: 10
            }, {
                xtype: 'datefield',
                format: getMonthYearFormat(),
                plugins: 'monthPickerPlugin',
                id: 'royaltydatelab',
                value: '',
                emptyText: 'Select Month',
                blankText: 'Select Month',
                vtype: 'daterange',
                cls: 'selectstylePerfect',
                listeners: {
                    select: {
                        fn: function() {
                            if (Ext.getCmp('mineralTypecomboId').getValue() != "") {
                                gradeComboStore.load({
                                    params: {
                                        mineralType: Ext.getCmp('mineralTypecomboId').getValue(),
                                        CustID: Ext.getCmp('custcomboId').getValue(),
                                        RoyaltyDate: Ext.getCmp('royaltydatelab').getValue()
                                    }
                                });
                                gradeStore.load({
                                    params: {
                                        CustID: Ext.getCmp('custcomboId').getValue(),
                                        type: Ext.getCmp('challantypeId').getValue(),
                                        id: 0
                                    }
                                });
                            }
                        }
                    }
                }
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryPaymentACHead10'
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryMineralType'
            }, {
                xtype: 'label',
                text: '<%=Mineral_Type%>' + '  :',
                cls: 'labelstyle',
                id: 'mineralTypeLabelId'
            }, {
                width: 10
            }, mineralTypeCombo, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryTypeclose',
                hidden: true
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryTypeclose1',
                hidden: true
            }, {
                xtype: 'label',
                text: 'Permit No ' + '  :',
                cls: 'labelstyle',
                id: 'typeclose',
                hidden: true
            }, {
                width: 10
            }, closeCombo, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryPaymentACHead16'
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorypaymentDe'
            }, {
                xtype: 'label',
                text: '<%=Payment_Description%>' + ' :',
                cls: 'labelstyle',
                id: 'paydescId'
            }, {
                width: 10
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                id: 'paymentDescriptionId',
                emptyText: '<%=Enter_Payment_Description%>',
                blankText: '<%=Enter_Payment_Description%>',
                listeners: { change: function(f,n,o){ //restrict 100
				 if(f.getValue().length> 100){ Ext.example.msg("Field exceeded it's Maximum length"); 
					f.setValue(n.substr(0,100)); f.focus(); }
					f.setValue(n.toUpperCase().trim());
				 } },
            }]
        }]
    });

    var challanDetailsPanel = new Ext.form.FormPanel({
        standardSubmit: true,
        collapsible: false,
        frame: false,
        id: 'challanId',
        items: [{
            xtype: 'fieldset',
            width: 700,
            title: 'Payable Across E-Wallet Challan',
            id: 'challanPanelpanelId',
            collapsible: false,
            layout: 'table',
            layoutConfig: {
                columns: 5
            },
            items: [{    
                xtype: 'checkbox',
                name: 'active',
                inputValue: '1',
                height: '25px',
                id: 'challanCheckBoxId',
                listeners: {
                    check: function(cb, checked) {
                        var romTotalPayable = 0;
                        if (Ext.getCmp('challantypeId').getValue() == 'ROM') {
                            romTotalPayable = Ext.getCmp('payableId1').getValue();
                        }
                        if (Ext.getCmp('challanCheckBoxId').getValue() == true) {
                            if (Ext.getCmp('balanceId').getValue() == 0) {
                                Ext.example.msg("E-Wallet balance is zero.");
                                Ext.getCmp('challanCheckBoxId').setValue(false);
                                ewallet = 'No';
                                return;
                            }
                            if (Ext.getCmp('challantypeId').getValue() == 'ROM') {
                                ewallet = 'Yes';
                                romTotalPayable = Ext.getCmp('payableId1').getValue();
                                var ewalletBalance = Ext.getCmp('balanceId').getValue();
                                if (editedRows == "" && buttonValue == 'Modify') {
                                    if (romTotalPayable > ewalletBalance) {
                                        Ext.getCmp('totalPayableId').setValue((romTotalPayable - ewalletBalance));
                                    } else {
                                        Ext.getCmp('totalPayableId').setValue(0);
                                    }
                                } else if (editedRows == "") {
                                    Ext.getCmp('totalPayableId').setValue(0);
                                } else if ((romTotalPayable - ewalletBalance) < 0) {
                                    Ext.getCmp('totalPayableId').setValue(0);
                                } else {
                                    Ext.getCmp('totalPayableId').setValue((romTotalPayable - ewalletBalance));
                                }
                            } else {
                                var ewalletBalance = Ext.getCmp('balanceId').getValue();
                                ewallet = 'Yes';
                                var selected = grid.getSelectionModel().getSelected();
                                var totalchallanAmt = selected.get('payableDataIndex');
                                if (editedRows == "" && buttonValue == 'Modify') {
                                    if ((parseFloat(totalchallanAmt) - ewalletBalance) < 0) {
                                        Ext.getCmp('totalPayableId').setValue(0);
                                    } else {
                                        Ext.getCmp('totalPayableId').setValue((totalchallanAmt - ewalletBalance));
                                    }
                                } else if (editedRows != "" && buttonValue == 'Modify') {
                                    //var payableModify = IndexPayable - parseFloat(totalchallanAmt);
                                    //if ((payableModify - ewalletBalance) < 0) {
                                    //    Ext.getCmp('totalPayableId').setValue(0);
                                    //} else {
                                    //    Ext.getCmp('totalPayableId').setValue((payableModify - ewalletBalance));
                                    //}
                                    if ((IndexPayable - ewalletBalance) < 0) {
                                        Ext.getCmp('totalPayableId').setValue(0);
                                    } else {
                                        Ext.getCmp('totalPayableId').setValue((IndexPayable - ewalletBalance));
                                    }
                                } else {
                                    if ((IndexPayable - ewalletBalance) < 0) {
                                        Ext.getCmp('totalPayableId').setValue(0);
                                    } else {
                                        Ext.getCmp('totalPayableId').setValue((IndexPayable - ewalletBalance));
                                    }
                                }
                            }
                        } else {
                            if (Ext.getCmp('challantypeId').getValue() == 'ROM') {
                                ewallet = 'No';
                                if (editedRows == "" && buttonValue == 'Modify') {
                                    Ext.getCmp('totalPayableId').setValue(romTotalPayable);
                                } else if (editedRows == "") {
                                    Ext.getCmp('totalPayableId').setValue(0);
                                } else {
                                    Ext.getCmp('totalPayableId').setValue(romTotalPayable);
                                }
                            } else {
                                ewallet = 'No';
                                var selected = grid.getSelectionModel().getSelected();
                                var totalchallanAmt = selected.get('payableDataIndex');
                                if (editedRows == "" && buttonValue == 'Modify') {
                                    Ext.getCmp('totalPayableId').setValue(totalchallanAmt);
                                } else if (editedRows != "" && buttonValue == 'Modify') {
                                    //var payableModify = parseFloat(totalchallanAmt) - IndexPayable;
                                    //if ((parseFloat(IndexPayable) - parseFloat(totalchallanAmt)) < 0) {
                                    //    Ext.getCmp('totalPayableId').setValue(0);
                                    //} else {
                                    //    Ext.getCmp('totalPayableId').setValue(IndexPayable - parseFloat(totalchallanAmt));
                                    //}
                                    Ext.getCmp('totalPayableId').setValue(IndexPayable);
                                } else {
                                    Ext.getCmp('totalPayableId').setValue(IndexPayable);
                                }
                            }
                        }
                    }//check
                }
            }, {
                xtype: 'label',
                text: 'E-Wallet' + '  :',
                cls: 'labelstyle',
                id: 'ELabelId'
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: 'E-Wallet Balance' + '  :',
                cls: 'labelstyle',
                id: 'ewalletLabelId'
            }, {
                xtype: 'numberfield',
                cls: 'selectstylePerfect',
                id: 'balanceId',
                decimalPrecision: 2,
                readOnly: true,
                allowNegative: false
            }, {
                width: 10
            }, {
                width: 10
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: 'Total Payable' + '  :',
                cls: 'labelstyle',
                id: 'TpayableLabel'
            }, {
                xtype: 'numberfield',
                cls: 'selectstylePerfect',
                id: 'totalPayableId',
                readOnly: true
            }]
        }]
    });


    var ewalletChallanPanel = new Ext.form.FormPanel({
        standardSubmit: true,
        collapsible: false,
        frame: false,
        id: 'ewalletchallanId',
        items: [{
            xtype: 'fieldset',
            width: 700,
            title: 'E-Wallet Challan Details',
            id: 'ewalletchallanPanelpanelId',
            collapsible: false,
            layout: 'table',
            layoutConfig: {
                columns: 5
            },
            items: [{
                xtype: 'label',
                text: 'E-Wallet Challan Number' + '  :',
                cls: 'labelstyle',
                id: 'EwLabelId'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                id: 'eWalletNo',
                readOnly: true,
            }, {
                width: 10
            }, {
                width: 10
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: 'E-Wallet Quantity' + '  :',
                cls: 'labelstyle',
                id: 'ewalletLabelid'
            }, {
                xtype: 'numberfield',
                cls: 'selectstylePerfect',
                id: 'eWalletQty',
                decimalPrecision: 2,
                readOnly: true,
                allowNegative: false
            }, {
                width: 10
            }, {
                width: 10
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: 'E-Wallet Amount' + '  :',
                cls: 'labelstyle',
                id: 'TpayableLabelId'
            }, {
                xtype: 'numberfield',
                cls: 'selectstylePerfect',
                id: 'ewalletAmtId',
                readOnly: true
            }, {
                width: 10
            }, {
                width: 10
            }, {
                width: 10
            }, {
                xtype: 'label',
                text: 'Total Payable' + '  :',
                cls: 'labelstyle',
                id: 'TpayableLabelIdForEwallet'
            }, {
                xtype: 'numberfield',
                cls: 'selectstylePerfect',
                id: 'payableId1',
                readOnly: true
            }]
        }]
    });

    var gradeReader = new Ext.data.JsonReader({
        idProperty: 'gradeRootId',
        root: 'gradeRoot',
        totalProperty: 'total',
        fields: [{
            name: 'SLNOIndex'
        }, {
            name: 'uniqueIdIndex'
        }, {
            name: 'gradeIdIndex'
        }, {
            name: 'rateIdIndex'
        }, {
            name: 'qtyIdIndex'
        }, {
            name: 'payableIdIndex'
        }, {
            name: 'gridStatusDataIndex'
        }]
    });
    var gradeFilters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'int',
            dataIndex: 'SLNOIndex'
        }, {
            type: 'int',
            dataIndex: 'uniqueIdIndex'
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
        }, {
            type: 'string',
            dataIndex: 'gridStatusDataIndex'
        }]
    });

    var columnModel = new Ext.grid.ColumnModel({
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
            header: "<span style=font-weight:bold;>Grade</span>",
            sortable: false,
            hidden: false,
            width: 370,
            dataIndex: 'gradeIdIndex',
            editor: new Ext.grid.GridEditor(gradeCombo)
        }, {
            header: "<span style=font-weight:bold;>Rate</span>",
            sortable: false,
            align: 'right',
            width: 50,
            dataIndex: 'rateIdIndex'
        }, {
            header: "<span style=font-weight:bold;>Quantity</span>",
            sortable: false,
            align: 'right',
            width: 70,
            dataIndex: 'qtyIdIndex',
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                decimalPrecision: 2,
                allowNegative: false,
                autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
                listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } }
            }))
        }, {
            header: "<span style=font-weight:bold;>Payable</span>",
            sortable: false,
            align: 'right',
            width: 80,
            dataIndex: 'payableIdIndex'
        }, {
            header: "<span style=font-weight:bold;>Status </span>",
            sortable: false,
            width: 180,
            hidden: true,
            dataIndex: 'gridStatusDataIndex'
        }]
    });

    var gradeStore = new Ext.data.GroupingStore({
        autoLoad: false,
        remoteSort: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/ChallanDetailsAction.do?param=getGridData',
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
    }, {
        name: 'gridStatusDataIndex'
    }]);
    var outerPanelForGrid = new Ext.grid.EditorGridPanel({
        title: 'Grade Details',
        height: 320,
        width: 731,
        autoScroll: true,
        border: false,
        store: gradeStore,
        id: 'employmentgridId',
        colModel: columnModel,
        sm: selModel,
        plugins: [gradeFilters],
        clicksToEdit: 1
    });

    outerPanelForGrid.on({
        beforeedit: function(e) {
            if ((e.field == 'rateIdIndex') && e.record.get('gridStatusDataIndex') == '') {
                return false;
            }
            if ((e.field == 'qtyIdIndex') && (e.record.get('gridStatusDataIndex') != '' && e.record.get('gridStatusDataIndex') != 'L4' )) {
                return false;
            }
            if( Ext.getCmp('challantypeId').getValue() == 'ROM' && (e.field == 'qtyIdIndex') && 
            	(e.record.get('gridStatusDataIndex') != '' && e.record.get('gridStatusDataIndex') == 'L4' )){
            	return false;
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
            if (gradeSelect == true) {
            	if(field == 'qtyIdIndex'){
            		var qty = 0;
            		qty = e.record.get('qtyIdIndex');
            		e.record.set('qtyIdIndex',qty.toFixed(2));
            	}
                var row1 = grdeselect;
                var rate = 0;
                var giopfrate = 0;
                if (buttonValue == 'Modify') {
                    if (e.record.data['SLNOIndex'] == '1' || e.record.data['gridStatusDataIndex'] == 'L4') {
                        var row = gradeComboStore.findExact('grade', e.record.data['gradeIdIndex']);
                        var rec = gradeComboStore.getAt(row);
                        rate = rec.data['rate'];
                        giopfrate = rec.data['Giopfrate'];
                    }
                } else if (buttonValue == 'add') {
                    if (e.record.data['SLNOIndex'] == 'new1' || e.record.data['gridStatusDataIndex'] == 'L4') {
                        var row = gradeComboStore.findExact('grade', gradeCombo.getValue());
                        var rec = gradeComboStore.getAt(row);
                        rate = rec.data['rate'];
                        giopfrate = rec.data['Giopfrate'];
                    }
                }
                e.record.set('rateIdIndex', rate);
                var payable = parseFloat(e.record.data['qtyIdIndex'] * e.record.data['rateIdIndex']);
                e.record.set('payableIdIndex', Math.round(payable).toFixed(2));
                if (e.record.data['qtyIdIndex'] >= 0) {
                    gettotalForROM('payableIdIndex', 'qtyIdIndex','rateIdIndex',giopfrate,e);
                }
                gettotal('payableIdIndex');
            } else if (gradeSelect == false) {
                var rg = gradeStore.findExact('gradeIdIndex', 'GIOPF 10%');
                var res = gradeStore.getAt(rg);
                giopfrates = res.data['rateIdIndex'];
                var temp = editedRows.split(",");
                for (var i = 0; i < temp.length; i++) {
                    var row = outerPanelForGrid.store.find('SLNOIndex', temp[i]);
                    var store1 = outerPanelForGrid.store.getAt(row);
                 if(store1!=null){
                    var rateSel = store1.data['rateIdIndex'];
                    var qtySel = store1.data['qtyIdIndex'];
                    var payable = parseFloat(parseFloat(rateSel) * parseFloat(qtySel));
                    e.record.set('payableIdIndex', Math.round(payable).toFixed(2));
                    if (e.record.data['qtyIdIndex'] > 0) {
                        gettotalForROM('payableIdIndex', 'qtyIdIndex','rateIdIndex',giopfrates,e);
                    }
                 }
                    gettotal('payableIdIndex');
                }
            }
        }
    });

    function gettotalForROM(e, e1,e2,giopfrate,field) {
        var ROMtotal = 0;
        var ROMqty = 0;
        var total = 0;
        outerPanelForGrid.store.each(function(record1) {
            if (record1.data['gradeIdIndex'].trim() != 'Royalty' && record1.data['gradeIdIndex'].trim() != 'Royalty' && record1.data['gradeIdIndex'].trim() != 'DMF 30% (Automatically calculate on total)' && record1.data['gradeIdIndex'].trim() != 'NMET 2%(Automatically calculate on total)' && record1.data['gradeIdIndex'].trim() != 'GIOPF 10%' && record1.data['gradeIdIndex'].trim() != 'Total Challan Amount' && record1.data[e] != '') {
                ROMtotal = Math.round((parseFloat(parseFloat(ROMtotal)) + parseFloat(record1.data[e]))).toFixed(2);
            }
            if (record1.data['gradeIdIndex'].trim() != 'Royalty' && record1.data['gradeIdIndex'].trim() != 'Royalty' && record1.data['gradeIdIndex'].trim() != 'DMF 30% (Automatically calculate on total)' && record1.data['gradeIdIndex'].trim() != 'NMET 2%(Automatically calculate on total)' && record1.data['gradeIdIndex'].trim() != 'GIOPF 10%' && record1.data['gradeIdIndex'].trim() != 'Total Challan Amount' && record1.data[e1] != '') {
                ROMqty = ((parseFloat(parseFloat(ROMqty)) + parseFloat(record1.data[e1]))).toFixed(2);
            }    
        })
        outerPanelForGrid.store.each(function(record2) {
            if (record2.data['gradeIdIndex'].trim() == 'Royalty') {
                var tot = Math.round(ROMtotal).toFixed(2);
                record2.set(e, tot);
                record2.set(e1, ROMqty);
            }
            if (record2.data['gradeIdIndex'].trim() == 'DMF 30% (Automatically calculate on total)') {
                var tot1 = ROMtotal * 0.3;
                var totl = Math.round(tot1).toFixed(2);
                record2.set(e, totl);
            }
            if (record2.data['gradeIdIndex'].trim() == 'NMET 2%(Automatically calculate on total)') {
                var tot2 = ROMtotal * 0.02;
                var totl1 = Math.round(tot2).toFixed(2);
                record2.set(e, totl1);
            }
             if (record2.data['gradeIdIndex'].trim() == 'GIOPF 10%') {
             	if(field.record.get('gradeIdIndex') == 'GIOPF 10%'){
             	    record2.set(e2, giopfrate);
		            record2.set(e1, record2.data['qtyIdIndex']);
		            var tot3 = giopfrate*record2.data['qtyIdIndex'];
		            var tot31 = Math.round(tot3).toFixed(2);
		            record2.set(e, tot31);  
             	}else if(Ext.getCmp('challantypeId').getValue() == 'ROM'){
	             	var qtyG=0;
	             	if(giopfStatus=='TRUE'){
	             	  qtyG=ROMqty;
	             	}
             		record2.set(e2, giopfrate);
		            record2.set(e1, qtyG);
		            var tot3 = giopfrate*qtyG;
		            var tot31 = Math.round(tot3).toFixed(2);
		            record2.set(e, tot31);
             	}else{
		 			record2.set(e2, giopfrate);
		            record2.set(e1, ROMqty);
		            var tot3 = giopfrate*record2.data['qtyIdIndex'];
		            var tot31 = Math.round(tot3).toFixed(2);
		            record2.set(e, tot31);
                }
            }
        })
    }

    function gettotal(e) {
        var total = 0;
        outerPanelForGrid.store.each(function(record1)     {      
            if (record1.data['gradeIdIndex'].trim() == 'Royalty' && record1.data[e] != '') {
                total = (parseFloat(parseFloat(total)) + parseFloat(record1.data[e]));
            }
            if (record1.data['gradeIdIndex'].trim() == 'DMF 30% (Automatically calculate on total)' && record1.data[e] != '') {
                total = (parseFloat(parseFloat(total)) + parseFloat(record1.data[e]));
            }
            if (record1.data['gradeIdIndex'].trim() == 'NMET 2%(Automatically calculate on total)' && record1.data[e] != '') {
                total = (parseFloat(parseFloat(total)) + parseFloat(record1.data[e]));
            }
            if (record1.data['gradeIdIndex'].trim() == 'GIOPF 10%' && record1.data[e] != '') {
                total = (parseFloat(parseFloat(total)) + parseFloat(record1.data[e]));
            }
        })
        outerPanelForGrid.store.each(function(record2) {
            if (record2.data['gradeIdIndex'].trim() == 'Total Challan Amount') {
                var n = Math.round(total).toFixed(2);
                record2.set(e, n);
                IndexPayable = n;
                Ext.getCmp('challanCheckBoxId').setValue(false);
                var selected = grid.getSelectionModel().getSelected();

                if (Ext.getCmp('challantypeId').getValue() == 'ROM') {
                    var payable = parseFloat(IndexPayable) - parseFloat(Ext.getCmp('ewalletAmtId').getValue());
                    if (buttonValue == 'Modify') {
                        var totalchallanAmt = selected.get('payableDataIndex');
                        if ((parseFloat(IndexPayable)) < parseFloat(Ext.getCmp('ewalletAmtId').getValue())) {
                            Ext.getCmp('payableId1').setValue(0);
                            Ext.getCmp('totalPayableId').setValue(0);
                        } else {
                            var amtt = (parseFloat(IndexPayable));
                            payable = (amtt - parseFloat(Ext.getCmp('ewalletAmtId').getValue()));
                            Ext.getCmp('payableId1').setValue(payable);
                            Ext.getCmp('totalPayableId').setValue(payable);
                        }
                    } else {
                        if (parseFloat(payable) < 0) {
                            Ext.getCmp('payableId1').setValue(0);
                            Ext.getCmp('totalPayableId').setValue(0);
                        } else {
                            Ext.getCmp('payableId1').setValue(payable);
                            Ext.getCmp('totalPayableId').setValue(payable);
                        }
                    }
                } else {
                    Ext.getCmp('totalPayableId').setValue(IndexPayable);
                }
            }
        })
    }

    function onCellClick(grid, rowIndex, columnIndex, e) {
        var r = outerPanelForGrid.store.getAt(rowIndex);
        var status = r.data['gridStatusDataIndex'];
        if ((status.trim() == 'L1') || (status.trim() == 'L2') || (status.trim() == 'L3') || (status.trim() == 'L5')) {
            outerPanelForGrid.getColumnModel().config[columnIndex].editable = false;
        } else {
            outerPanelForGrid.getColumnModel().config[columnIndex].editable = true;
        }
        if ((status.trim() == 'L4')) {
            outerPanelForGrid.getColumnModel().config[outerPanelForGrid.getColumnModel().findColumnIndex('gradeIdIndex')].editable = false;
        } 

    }
    var UGrid = function() {
        return {
            init: function() {
                outerPanelForGrid.on({
                    "cellclick": {
                        fn: onCellClick
                    }
                });
            },
            getDS: function() {
                return gradeStore;
            }
        }
    }();

    Ext.onReady(UGrid.init, UGrid, true);

    var ReaderForOthers = new Ext.data.JsonReader({
        idProperty: 'otherRootId',
        root: 'otherRoot',
        totalProperty: 'total',
        fields: [{
            name: 'SLNOIndex'
        }, {
            name: 'uniqueIdIndex'
        }, {
            name: 'leaseAreaDataIndex'
        }, {
            name: 'rate2IdIndex'
        }, {
            name: 'payable2IdIndex'
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
            type: 'numeric',
            dataIndex: 'leaseAreaDataIndex'
        }, {
            type: 'int',
            dataIndex: 'rate2IdIndex',
        }, {
            type: 'int',
            dataIndex: 'payable2IdIndex'
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
            header: "<span style=font-weight:bold;>Lease Area/Factors(sq mts)</span>",
            sortable: false,
            hidden: false,
            width: 240,
            dataIndex: 'leaseAreaDataIndex'

        }, {
            header: "<span style=font-weight:bold;>Rate</span>",
            sortable: false,
            align: 'right',
            width: 180,
            dataIndex: 'rate2IdIndex',
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                decimalPrecision: 0,
                autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
                allowNegative: false
            }))
        }, {
            header: "<span style=font-weight:bold;>Payable</span>",
            sortable: false,
            align: 'right',
            width: 180,
            dataIndex: 'payable2IdIndex',
        }]
    });

    var Store2 = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/ChallanDetailsAction.do?param=getGrid2Data',
            method: 'POST'
        }),
        reader: ReaderForOthers
    });

    var selModel2 = new Ext.grid.RowSelectionModel({
        singleSelect: true
    });

    var outerPanelForGrid2 = new Ext.grid.EditorGridPanel({
        title: 'Details',
        layout: 'fit',
        stripeRows: true,
        height: 300,
        width: 731,
        autoScroll: true,
        hidden: true,
        border: false,
        store: Store2,
        id: 'othersgridId',
        colModel: columnModel2,
        sm: selModel2,
        plugins: [otherFilters],
        clicksToEdit: 1
    });
    outerPanelForGrid2.on({
        beforeedit: function(e) {
            var cellEditable = e.record.get('leaseAreaDataIndex');
            if (cellEditable == "TOTAL PAYABLE")
                return false;
            else
                return true;
        }
    });

    outerPanelForGrid2.on({
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
            if (e.record.data['rate2IdIndex'] > 0) {
                getTotal('payable2IdIndex');
            }
        }
    });

    function getTotal(e) {
        var tot1 = 0;
        var tot = 0;
        var tot2 = 0;
        outerPanelForGrid2.store.each(function(record2)     {  

            if (buttonValue == 'Modify') {
                if (record2.data['SLNOIndex'] == '1') {
                    tot1 = record2.data['rate2IdIndex'] * record2.data['leaseAreaDataIndex'];
                    record2.set(e, tot1);
                }
            }
            if (record2.data['SLNOIndex'] == 'new1') {
                tot1 = record2.data['rate2IdIndex'].toFixed(2) * record2.data['leaseAreaDataIndex'];
                record2.set(e, tot1);
            }
            if (record2.data['leaseAreaDataIndex'] == 'Interest if Any') {
                tot2 = record2.data['rate2IdIndex'] * 1;
                record2.set(e, tot2);
            }
            if (record2.data['leaseAreaDataIndex'] == 'TOTAL PAYABLE') {
                tot = (parseFloat(parseFloat(tot1)) + (parseFloat(tot2)));
                record2.set(e, tot);
            }    
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
        }, {
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
        }, {
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
            dataIndex: 'valueDataIndex',
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                decimalPrecision: 3,
                allowNegative: false,
                autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
                listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } }
            }))
        }, {
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
            url: '<%=request.getContextPath()%>/ChallanDetailsAction.do?param=getGridDataForBauxite',
            method: 'POST'
        }),
        reader: readerForBauxite
    });
    var selModelForBauxite = new Ext.grid.RowSelectionModel({
        singleSelect: true
    });

    var outerPanelForBauxiteGrid = new Ext.grid.EditorGridPanel({
        title: 'Details',
        // layout: 'fit',
        height: 360,
        width: 731,
        autoScroll: true,
        border: false,
        store: storeForBauxite,
        id: 'bauxiteGridId',
        colModel: columnModelForBauxite,
        sm: selModelForBauxite,
        plugins: [FilterForBauxite],
        clicksToEdit: 1
    });

    outerPanelForBauxiteGrid.on({
        beforeedit: function(e) {
            if ((e.field == 'valueDataIndex') && (e.record.get('statusBuDataIndex') == 'S1') || (e.record.get('statusBuDataIndex') == 'S2') || (e.record.get('statusBuDataIndex') == 'S3') ||
                (e.record.get('statusBuDataIndex') == 'S4') || (e.record.get('statusBuDataIndex') == 'S5') || (e.record.get('statusBuDataIndex') == 'S6') || (e.record.get('statusBuDataIndex') == 'S7') ||
                (e.record.get('statusBuDataIndex') == 'S8') || (e.record.get('statusBuDataIndex') == 'S9') || (e.record.get('statusBuDataIndex') == 'S10') || (e.record.get('statusBuDataIndex') == 'S11')) {
                return false;
            }
        },
        afteredit: function(e) {
            var field = e.field;
            var slno = e.record.data['SLNOIndex'];
            var temp = editedRowsForBuGrid.split(",");
            var isIn = 0;
            for (var i = 0; i < temp.length; i++) {
                if (temp[i] == slno) {
                    isIn = 1
                }
            }
            if (isIn == 0) {
                editedRowsForBuGrid = editedRowsForBuGrid + slno + ",";
            }
            startCalculationForBauxite('valueDataIndex');
            getTotalChallanAmtForBauxite('valueDataIndex');
        }
    });

    function startCalculationForBauxite(e) {
        var LMERate = 0;
        var dollarRate = 0;
        var gradeRate = 0;
        var rateBu = 0;
        var qty = 0;
        var cellAmountRate = 0;
        var processfeeRate = 0;
        var tdsPerc = 0;
        outerPanelForBauxiteGrid.store.each(function(record1) {      
            if (record1.data['inputDataIndex'] == 'LME RATE') {
                LMERate = (parseFloat(LMERate) + parseFloat(record1.data[e])).toFixed(2);
            }
            if (record1.data['inputDataIndex'] == 'DOLLAR RATE') {
                dollarRate = (parseFloat(dollarRate) + parseFloat(record1.data[e])).toFixed(2);
            }
            if (record1.data['inputDataIndex'] == 'GRADE RATE') {
                gradeRate = (parseFloat(gradeRate) + parseFloat(record1.data[e])).toFixed(3);
            }
            if (record1.data['inputDataIndex'] == 'RATE') {
                rateBu = (parseFloat(rateBu) + parseFloat(record1.data[e])).toFixed(2);
            }
            if (record1.data['inputDataIndex'] == 'QUANTITY') {
                qty = (parseFloat(qty) + parseFloat(record1.data[e])).toFixed(2);
            }
            if (record1.data['inputDataIndex'] == 'CELL AMOUNT RATE') {
                cellAmountRate = (parseFloat(cellAmountRate) + parseFloat(record1.data[e])).toFixed(2);
            }
            if (record1.data['inputDataIndex'] == 'PROCESSING FEE RATE') {
                processfeeRate = (parseFloat(processfeeRate) + parseFloat(record1.data[e])).toFixed(2);
            }
            if (record1.data['inputDataIndex'] == 'TDS PERCENTAGE') {
                tdsPerc = (parseFloat(tdsPerc) + parseFloat(record1.data[e])).toFixed(2);
            }

        })
        if (LMERate > 0 && dollarRate > 0 && gradeRate > 0 && rateBu > 0 && qty > 0 && cellAmountRate > 0 && processfeeRate > 0 && tdsPerc > 0) {

            outerPanelForBauxiteGrid.store.each(function(record2) {
                if (record2.data['inputDataIndex'] == 'LME RATE * DOLLAR PRICE') {
                    var tot0 = LMERate * dollarRate;
                    var tot = Math.round(tot0).toFixed(2);
                    record2.set(e, tot);
                }
                if (record2.data['inputDataIndex'] == '(LME RATE * DOLLAR PRICE) * GRADE RATE') {
                    var tot1 = (LMERate * dollarRate) * (gradeRate);
                    var totl1 = (tot1).toFixed(2);
                    record2.set(e, totl1);
                }
                if (record2.data['inputDataIndex'] == '((LME RATE * DOLLAR PRICE) * GRADE RATE)* RATE/100') {
                    var tot2 = (LMERate * dollarRate) * (gradeRate);
                    var tot21 = rateBu / 100;
                    var tot22 = tot2 * tot21;
                    var tot23 = tot22.toFixed(2);
                    record2.set(e, tot23);
                }
                if (record2.data['inputDataIndex'] == 'ROYALTY/M.T.') {
                    var tot3 = (LMERate * dollarRate) * (gradeRate);
                    var tot31 = rateBu / 100;
                    var tot32 = tot3 * tot31;
                    var tot33 = tot32.toFixed(2);
                    record2.set(e, tot33);
                }
                if (record2.data['inputDataIndex'] == '(QUANTITY * ROYALTY)/ M T') {
                    var tot4 = (LMERate * dollarRate) * (gradeRate);
                    var tot41 = rateBu / 100;
                    var tot42 = tot4 * tot41;
                    var tot44 = (tot42 * qty).toFixed(2);
                    record2.set(e, tot44);
                }
                if (record2.data['inputDataIndex'] == 'TDS') {
                    var tot5 = (LMERate * dollarRate) * (gradeRate);
                    var tot51 = rateBu / 100;
                    var tot52 = tot5 * tot51;
                    var tot54 = (tot52 * qty).toFixed(2);
                    var tot56 = (tdsPerc / 100);
                    var tot55 = (tot54 * tot56).toFixed(2);
                    record2.set(e, tot55);
                }
                if (record2.data['inputDataIndex'] == 'Cell Amount') {
                    var tot6 = (cellAmountRate * qty).toFixed(2);
                    record2.set(e, tot6);
                }
                if (record2.data['inputDataIndex'] == 'Processing Fees') {
                    var tot7 = (processfeeRate * qty).toFixed(2);
                    record2.set(e, tot7);
                }
                if (record2.data['inputDataIndex'] == 'DMF (30%)') {
                    var tot8 = (LMERate * dollarRate) * (gradeRate);
                    var tot81 = rateBu / 100;
                    var tot82 = tot8 * tot81;
                    var tot84 = (tot82 * qty).toFixed(2);
                    var tot85 = (tot84 * 0.3).toFixed(2);
                    record2.set(e, tot85);
                }
                if (record2.data['inputDataIndex'] == 'NMET (2%)') {
                    var tot9 = (LMERate * dollarRate) * (gradeRate);
                    var tot91 = rateBu / 100;
                    var tot92 = tot9 * tot91;
                    var tot94 = (tot92 * qty).toFixed(2);
                    var tot95 = (tot94 * 0.02).toFixed(2);
                    record2.set(e, tot95);
                }
            })
        }
    }

    function getTotalChallanAmtForBauxite(e) {
        var total = 0;
        outerPanelForBauxiteGrid.store.each(function(record1)     {      
            if (record1.data['inputDataIndex'] == '(QUANTITY * ROYALTY)/ M T' && record1.data[e] != '') {
                total = (parseFloat(parseFloat(total)) + parseFloat(record1.data[e]));
            }
            if (record1.data['inputDataIndex'] == 'TDS' && record1.data[e] != '') {
                total = (parseFloat(parseFloat(total)) + parseFloat(record1.data[e]));
            }
            if (record1.data['inputDataIndex'] == 'Cell Amount' && record1.data[e] != '') {
                total = (parseFloat(parseFloat(total)) + parseFloat(record1.data[e]));
            }
            if (record1.data['inputDataIndex'] == 'Processing Fees' && record1.data[e] != '') {
                total = (parseFloat(parseFloat(total)) + parseFloat(record1.data[e]));
            }    
            if (record1.data['inputDataIndex'] == 'DMF (30%)' && record1.data[e] != '') {
                total = (parseFloat(parseFloat(total)) + parseFloat(record1.data[e]));
            }
            if (record1.data['inputDataIndex'] == 'NMET (2%)' && record1.data[e] != '') {
                total = (parseFloat(parseFloat(total)) + parseFloat(record1.data[e]));
            }
        })
        outerPanelForBauxiteGrid.store.each(function(record2)     {      
            if (record2.data['inputDataIndex'] == 'TOTAL CHALLAN AMOUNT') {
                var totalBu = (total).toFixed(2);
                record2.set(e, totalBu);
            }
        })
    }
    var gridPanelForBauxite = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: true,
        height: 420,
        width: 760,
        frame: true,
        hidden: true,
        id: 'addPanelInfo1',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [outerPanelForBauxiteGrid]
    });
    var gridPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: true,
        height: 420,
        width: 760,
        frame: true,
        id: 'addPanelInfo',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [outerPanelForGrid, outerPanelForGrid2, {
            width: 10
        }, ewalletChallanPanel, {
            width: 10
        }, challanDetailsPanel]
    });
    var caseInnerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: true,
        height: 440,
        width: 1320,
        frame: true,
        id: 'addCaseInfo',
        layout: 'table',
        layoutConfig: {
            columns: 5
        },
        items: [ownerChalanDetailsPanel, {
            width: 10
        }, gridPanel, {
            width: 10
        }, gridPanelForBauxite]
    });

    //****************************** Window For Adding Trip Information****************************
    var winButtonPanel = new Ext.Panel({
        id: 'winbuttonid',
        standardSubmit: true,
        collapsible: false,
        height: 8,
        cls: 'windowbuttonpanel',
        frame: true,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        buttons: [{
            xtype: 'button',
            text: '<%=save%>',
            id: 'addButtId',
            cls: 'buttonstyle',
            iconCls: 'savebutton',
            width: 80,
            listeners: {
                click: {
                    fn: function() {
                        var json = "";
                        var closePermit = 0;
                        var totalPayable = 0;
                        var type = "";
                        //var date = "";
                        var orgId = 0;
                        var globalClientId = Ext.getCmp('custcomboId').getValue();
                        var customerName = Ext.getCmp('custcomboId').getRawValue();
                        var quantityRom;

                        if (Ext.getCmp('paymentcomboId').getRawValue() == "") {
                            Ext.example.msg("<%=Select_Payment_Acc_Head%>");
                            Ext.getCmp('paymentcomboId').focus();
                            return;
                        }
                        if (Ext.getCmp('challantypeId').getValue() == "") {
                            Ext.example.msg("Select challan type");
                            Ext.getCmp('challantypeId').focus();
                            return;
                        }
                        if (Ext.getCmp('challantypeId').getValue() != "Processing Fee") {
                            if (Ext.getCmp('TccomboId').getValue() == "") {
                                Ext.example.msg("<%=Select_TC_Number%>");
                                Ext.getCmp('TccomboId').focus();
                                return;
                            }
                        }
                        if (Ext.getCmp('challantypeId').getValue() == "Processing Fee") {
                            if (Ext.getCmp('organizationcodeComboid').getValue() == "") {
                                Ext.example.msg("Select Organization Code");
                                Ext.getCmp('organizationcodeComboid').focus();
                                return;
                            }
                        }
                        if (Ext.getCmp('financeId').getValue() == "") {
                            Ext.example.msg("Enter Financial Year");
                            Ext.getCmp('financeId').focus();
                            return;
                        }
                        if (Ext.getCmp('challantypeId').getValue() == 'Others') {
                            if (Ext.getCmp('typeComboId').getValue() == "") {
                                Ext.example.msg("<%=Select_Type%>");
                                Ext.getCmp('typeComboId').focus();
                                return;
                            }
                        }
                        if (Ext.getCmp('challantypeId').getValue() == 'ROM') {
                            if (Ext.getCmp('closecomboId').getValue() == "") {
                                Ext.example.msg("Select Permit");
                                Ext.getCmp('closecomboId').focus();
                                return;
                            }
                        }
                        var pattern = /[12][0-9]{3}-[12][0-9]{3}$/;
                        if (!pattern.test(Ext.getCmp('financeId').getValue())) {
                            Ext.example.msg("Enter Valid Financial Year(Eg:2015-2016)");
                            Ext.getCmp('financeId').focus();
                            return;
                        }
                        var fyear = Ext.getCmp('financeId').getValue();
                        var syear = fyear.substr(0, 4);
                        var eYear = fyear.substr(5);
                        if ((eYear - syear) == 1 && (eYear - syear) != 0) {} else if ((eYear - syear) < 1) {
                            Ext.example.msg(" Enter Valid Year");
                            Ext.getCmp('financeId').focus();
                            return;
                        } else {
                            Ext.example.msg("Only One Year Difference Is Allowed");
                            Ext.getCmp('financeId').focus();
                            return;
                        }
                        if (Ext.getCmp('challantypeId').getValue() != "Processing Fee") {
                        if(Ext.getCmp('TransMonthId').getValue() == ""){
	                        Ext.example.msg("Select Transportation Month");
	                        Ext.getCmp('TransMonthId').focus();
	                        return;
                        }
						if(Ext.getCmp('royaltydatelab').getValue() == ""){
	                        Ext.example.msg("Select IBM Average Sale Price Month ");
	                        Ext.getCmp('royaltydatelab').focus();
	                        return;
                        }
                        }
                        if (Ext.getCmp('mineralTypecomboId').getValue() == "") {
                            Ext.example.msg("<%=Select_Mineral_Type%>");
                            Ext.getCmp('mineralTypecomboId').focus();
                            return;
                        }
                        if (Ext.getCmp('dateId').getValue() == "") {
                                Ext.example.msg("Select Date");
                                Ext.getCmp('dateId').focus();
                                return;
                            }
                        if (Ext.getCmp('challantypeId').getValue() == 'Bauxite Challan') {
                            if (Ext.getCmp('mineralTypecomboId').getRawValue() != 'BAUXITE') {
                                Ext.example.msg("Please select mineral type as bauxite");
                                Ext.getCmp('mineralTypecomboId').reset();
                                Ext.getCmp('mineralTypecomboId').focus();
                                return;
                            }
                        }
                        if (Ext.getCmp('challantypeId').getValue() == 'ROM' || Ext.getCmp('challantypeId').getValue() == 'Processed Ore' || Ext.getCmp('challantypeId').getValue() == 'E-Wallet Challan') {
                            if(buttonValue == 'add'){
                            var editR='new1,new2,';
                            var temp = editR.split(",");
                            for (var i = 0; i < temp.length; i++) {
                                var row = outerPanelForGrid.store.find('SLNOIndex', temp[i]);
                                if (row == -1) {
                                    continue;
                                }
                                var store1 = outerPanelForGrid.store.getAt(row);
                                if (store1.data['gradeIdIndex'] == "") {
                                    Ext.example.msg("Please select grade");
                                    outerPanelForGrid.startEditing(row, 2);
                                    return;
                                }
                                if(store1.data['SLNOIndex']=='new1'){
                                if (store1.data['qtyIdIndex'] == "" || store1.data['qtyIdIndex'] == "0") {
                                    Ext.example.msg("Please Enter Quantity");
                                    outerPanelForGrid.startEditing(row, 4);
                                    return;
                                }
                                }
                                var row2 = outerPanelForGrid.store.find('gradeIdIndex', "GIOPF 10%");
                                if (row2 == -1) {
                                    continue;
                                }
                                 var store2 = outerPanelForGrid.store.getAt(row2);
                                 if(buttonValue == 'add'){
                                    var pattern = /^[0-9][0-9\s]*/;
<!--                                    if(store2.data['gridStatusDataIndex']=='L4'){-->
<!--                                     	if (!pattern.test(store2.data['qtyIdIndex'])) {-->
<!--				                         Ext.example.msg("Please Enter GIOPF Quantity");-->
<!--				                         outerPanelForGrid.startEditing(row2, 4);-->
<!--				                         return;-->
<!--			                          	}-->
<!--			                         }-->
                                 }
                                 if (!(store2.data['qtyIdIndex'] ==0 || parseFloat(store2.data['qtyIdIndex']) == parseFloat(store1.data['qtyIdIndex']))) {
                                     Ext.example.msg("GIOPF quantity can be zero or equal to quantity.");
                                     outerPanelForGrid.startEditing(row2, 4);
                                     return;
                                 }
                                if (Ext.getCmp('challantypeId').getValue() == 'ROM') {
                                    if ((parseFloat(store1.data['qtyIdIndex'])) > parseFloat(Ext.getCmp('eWalletQty').getValue())) {
                                        Ext.example.msg("Quantity entered should be less then or equals to ewallet quantity");
                                        return;
                                    }
                                }
                               
                                json += Ext.util.JSON.encode(store1.data) + ',';
                            }
                            }else if (buttonValue == 'Modify'){
                                    var selected = grid.getSelectionModel().getSelected();
                                    quantityRom = selected.get('totalQtyDataIndex');
                            	for (var l = 0; l <5; l++) {
                            	var storeQ1;
                            	var storeQ2;
                            	   if(l==0 || l==4){
							           var store1 = outerPanelForGrid.getStore().getAt(l); 
		                               json += Ext.util.JSON.encode(store1.data) + ',';
							       }
							       storeQ1=outerPanelForGrid.getStore().getAt(0); 
							       storeQ2=outerPanelForGrid.getStore().getAt(4); 
							       if (storeQ1.data['gradeIdIndex'] == "") {
		                                    Ext.example.msg("Please select grade");
		                                    outerPanelForGrid.startEditing(row, 2);
		                                    return;
		                                }
		                       if(storeQ1.data['SLNOIndex']=='1'){
                                if (storeQ1.data['qtyIdIndex'] == "" || storeQ1.data['qtyIdIndex'] == "0") {
                                    Ext.example.msg("Please Enter Quantity");
                                    outerPanelForGrid.startEditing(row, 4);
                                    return;
                                }
                                }
                               
		                         if (!(storeQ2.data['qtyIdIndex'] == 0 || parseFloat(storeQ1.data['qtyIdIndex']) == parseFloat(storeQ2.data['qtyIdIndex']))) {
                                     Ext.example.msg("GIOPF quantity can be zero or equal to quantity.");
                                     outerPanelForGrid.startEditing(row2, 4);
                                     return;
                                 }
                                if (Ext.getCmp('challantypeId').getValue() == 'ROM') {
                                    if ((parseFloat(storeQ1.data['qtyIdIndex'])) > parseFloat(Ext.getCmp('eWalletQty').getValue())) {
                                        Ext.example.msg("Quantity entered should be less then or equals to ewallet quantity");
                                        return;
                                    }
                                }
							  }
                            }

                            if (json != '') {
                                json = json.substring(0, json.length - 1);
                            }
                            if (editedRows == "" && buttonValue == 'add') {
                                Ext.example.msg("Please fill the Grade Details");
                                outerPanelForGrid.startEditing(0, 2);
                                return;
                            }
                        }
                        if (Ext.getCmp('challantypeId').getValue() == 'Others') {
                            type = Ext.getCmp('typeComboId').getValue();
                            if (Ext.getCmp('typeComboId').getValue() != 'Single' && Ext.getCmp('typeComboId').getValue() != 'DMF' && 
                            Ext.getCmp('typeComboId').getValue() != 'NMET' && Ext.getCmp('typeComboId').getValue() != 'GIOPF' && Ext.getCmp('typeComboId').getValue() != 'Royalty') {
                                var JSON = '';
                                var tempForGrid = editedRowsForGrid.split(",");
                                for (var i = 0; i < tempForGrid.length; i++) {
                                    var row1 = outerPanelForGrid2.store.find('SLNOIndex', tempForGrid[i]);
                                    if (row1 == -1) {
                                        continue;
                                    }
                                    var store1 = outerPanelForGrid2.store.getAt(row1);
                                    if (store1.data['rate2IdIndex'] == "" || store1.data['rate2IdIndex'] == "0") {
                                        Ext.example.msg("Please Enter Rate");
                                        outerPanelForGrid2.startEditing(row1, 3);
                                        return;
                                    }
                                    JSON += Ext.util.JSON.encode(store1.data) + ',';
                                }
                                if (JSON != '') {
                                    JSON = JSON.substring(0, JSON.length - 1);
                                }
                                if (editedRowsForGrid == "" && buttonValue == 'add') {
                                    Ext.example.msg("Please fill the Lease Details");
                                    outerPanelForGrid2.startEditing(0, 3);
                                    return;
                                }
                                json = JSON;
                            }
                        }
                        if (Ext.getCmp('challantypeId').getValue() == 'Bauxite Challan') {
                            //date = Ext.getCmp('dateId').getValue();
                            var JSONBauxite = '';
                            var temp = editedRowsForBuGrid.split(",");
                            if (editedRowsForBuGrid == "" && buttonValue == 'add') {
                                Ext.example.msg("Please fill the Details");
                                outerPanelForBauxiteGrid.startEditing(0, 3);
                                return;
                            }
                            for (var j = 1; j < 9; j++) {
                                var slnumber;
                                if (buttonValue == 'Modify') {
                                    slnumber = j;
                                } else {
                                    slnumber = "new" + j;
                                }
                                var rowV = outerPanelForBauxiteGrid.store.find('SLNOIndex', slnumber);
                                if (rowV == -1) {
                                    continue;
                                }
                                var storeV = outerPanelForBauxiteGrid.store.getAt(rowV);
                                if (storeV.data['valueDataIndex'] == "" || storeV.data['valueDataIndex'] == "0") {
                                    Ext.example.msg("Please Enter " + storeV.data['inputDataIndex']);
                                    outerPanelForBauxiteGrid.startEditing(rowV, 3);
                                    return;
                                }
                            }
                            for (var i = 0; i < temp.length; i++) {
                                var row = outerPanelForBauxiteGrid.store.find('SLNOIndex', temp[i]);
                                if (row == -1) {
                                    continue;
                                }
                                var storeBu = outerPanelForBauxiteGrid.store.getAt(row);
                                JSONBauxite += Ext.util.JSON.encode(storeBu.data) + ',';
                            }
                            if (JSONBauxite != '') {
                                JSONBauxite = JSONBauxite.substring(0, JSONBauxite.length - 1);
                            }
                            json = JSONBauxite;
                        }
                        if (Ext.getCmp('challantypeId').getValue() == 'ROM') {
                            closePermit = Ext.getCmp('closecomboId').getValue();
                            ewalletQty = Ext.getCmp('eWalletQty').getValue();
                            ewalletAmount = Ext.getCmp('ewalletAmtId').getValue();
                        }
                        if (Ext.getCmp('typeComboId').getValue() == 'Single' || Ext.getCmp('challantypeId').getValue() == 'Processing Fee' || Ext.getCmp('typeComboId').getValue() == 'DMF' 
                        || Ext.getCmp('typeComboId').getValue() == 'NMET'  || Ext.getCmp('typeComboId').getValue() == 'GIOPF' || Ext.getCmp('typeComboId').getValue() == 'Royalty') {
                            if (Ext.getCmp('PayableId').getValue() == "") {
                                Ext.example.msg("Enter Total Payable");
                                Ext.getCmp('PayableId').focus();
                                return;
                            }
                            totalPayable = Ext.getCmp('PayableId').getValue();
                        }
                        if (Ext.getCmp('challantypeId').getValue() == "Processing Fee") {
                            orgId = Ext.getCmp('organizationcodeComboid').getValue();
                        }
                        var selectedPayAccHead;
                        var uniqueId;
                        var processingFeeModify;
                        var challanAmount;
                        if (buttonValue == 'Modify') {
                            var selected = grid.getSelectionModel().getSelected();
                            if (selected.get('paymentAcHeadDataIndex') != Ext.getCmp('paymentcomboId').getValue()) {
                                selectedPayAccHead = Ext.getCmp('paymentcomboId').getValue();
                            } else {
                                selectedPayAccHead = selected.get('paymentAcHeadIdDataIndex');
                            }
                          
                            uniqueId = selected.get('uniqueIdDataIndex');
                            processingFeeModify = selected.get('pFeeDataIndex');
                            challanAmount = selected.get('payableDataIndex');
                            var updatepayable = selected.get('ewalletPayableDataIndex');
                        }
                        outerPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/ChallanDetailsAction.do?param=saveormodifyChallanDetails',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustID: Ext.getCmp('custcomboId').getValue(),
                                paymentAccHead: Ext.getCmp('paymentcomboId').getValue(),
                                type: type,
                                tcNum: Ext.getCmp('TccomboId').getValue(),
                                mineName: Ext.getCmp('leaseNameId').getValue(),
                                mineralType: Ext.getCmp('mineralTypecomboId').getRawValue(),
                                royalty: Ext.getCmp('royaltydatelab').getValue(),
                                financeYr: Ext.getCmp('financeId').getValue(),
                                challanType: Ext.getCmp('challantypeId').getValue(),
                                CustName: Ext.getCmp('custcomboId').getRawValue(),
                                jasondata: json,
                                description: Ext.getCmp('paymentDescriptionId').getValue(),
                                selectedPayAccHead: selectedPayAccHead,
                                uniqueId: uniqueId,
                                closePermit: closePermit,
                                totalPayable: totalPayable,
                                ewalletCheck: ewallet,
                                ewalletPayable: Ext.getCmp('totalPayableId').getValue(),
                                ewalletQbalance: Ext.getCmp('balanceId').getValue(),
                                processingFee: processingFee,
                                processingFeeModify: processingFeeModify,
                                ewalletQty: ewalletQty,
                                ewalletAmount: ewalletAmount,
                                ewalletId: ewalletId,
                                payableAmount: IndexPayable,
                                challanAmount: challanAmount,
                                totalQty: quantityRom,
                                updatepayable: updatepayable,
                                date: Ext.getCmp('dateId').getValue(),
                                orgId: orgId,
                                TransMonth: Ext.getCmp('TransMonthId').getValue()
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                if (buttonValue == 'add') {
                                    if(message=="0"){
                                        message="Error in Saving Challan Details";
                                        Ext.example.msg(message);
                                     }else if(message>0){
										window.open("<%=request.getContextPath()%>/ChallanPDF?autoGeneratedKeys=" + message + "&buttonType=" + buttonValue);	                                                           
										message="Challan Details Saved Successfully";
                                        Ext.example.msg(message);
                                     }
                                } else {
                                	if(message=="0"){
                                        message="Error in Saving Challan Details";
                                        Ext.example.msg(message);
                                     }else if(message>0){
										window.open("<%=request.getContextPath()%>/ChallanPDF?autoGeneratedKeys=" + message + "&buttonType=" + buttonValue);	                                                        
										message="Updated Successfully";
                                        Ext.example.msg(message);
                                     }
                                }
                                Ext.getCmp('paymentcomboId').reset();
                                Ext.getCmp('TccomboId').reset();
                                Ext.getCmp('leaseNameId').reset();
                                Ext.getCmp('MineOwnerId').reset();
                                Ext.getCmp('orgNameId').reset();
                                Ext.getCmp('MineCodeId').reset();
                                Ext.getCmp('mineralTypecomboId').reset();
                                Ext.getCmp('royaltydatelab').reset();
                                Ext.getCmp('challantypeId').reset();
                                Ext.getCmp('financeId').reset();
                                Ext.getCmp('paymentDescriptionId').reset();
                                Ext.getCmp('PayableId').reset();
                                Ext.getCmp('closecomboId').reset();
                                Ext.getCmp('balanceId').reset();
                                Ext.getCmp('totalPayableId').reset();
                                Ext.getCmp('challantypeId').reset();
                                myWin.hide();
                                outerPanelWindow.getEl().unmask();
                                editedRows = "";
                                editedRowsForBuGrid = "";
                                gradeSelect = false;
                                store.load({
                                    params: {
                                        CustID: Ext.getCmp('custcomboId').getValue(),
                                        jspName: jspName,
                                        CustName: Ext.getCmp('custcomboId').getRawValue(),
                                        endDate: Ext.getCmp('enddate').getValue(),
			                            startDate: Ext.getCmp('startdate').getValue()
                                    }
                                });
                                gradeStore.load({
                                    params: {
                                        CustID: Ext.getCmp('custcomboId').getValue(),
                                        type: Ext.getCmp('challantypeId').getValue(),
                                        id: 0
                                    }
                                });
                                TcNoComboStore.load({
                                    params: {
                                        CustID: Ext.getCmp('custcomboId').getValue()
                                    }
                                });
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                myWin.hide();
                                editedRows = "";
                                editedRowsForBuGrid = "";
                            }
                        });
                    }
                }
            }
        }, {
            xtype: 'button',
            text: '<%=cancel%>',
            id: 'canButtId',
            cls: 'buttonstyle',
            iconCls: 'cancelbutton',
            width: '80',
            listeners: {
                click: {
                    fn: function() {
                        myWin.hide();
                    }
                }
            }
        }]
    });
    //****************************** Window For Adding Trip Information Ends Here************************
    var outerPanelWindow = new Ext.Panel({
        standardSubmit: true,
        id: 'radiocasewinpanelId',
        frame: true,
        height: 550, 
        width: 1347, 
        items: [caseInnerPanel, winButtonPanel]
    });
    //************************* Outer Pannel *******************************************//
    myWin = new Ext.Window({
        closable: false,
        modal: true,
        resizable: false,
        autoScroll: false,
        height: 550, 
        width: 1347, 
        id: 'myWin',
        items: [outerPanelWindow]
    });
    //*****************************************acknowledgement window**********************************//

    var bankNameStore = new Ext.data.SimpleStore({
        id: 'bankNamecomboStoreId',
        autoLoad: true,
        fields: ['Name', 'Value'],
        data: [
            ['State Bank of India', 'State Bank of India']
        ]
    });

    var branchStore = new Ext.data.SimpleStore({
        id: 'branchNamecomboStoreId',
        autoLoad: true,
        fields: ['Name', 'Value'],
        data: [
            ['Panaji', 'Panaji']
        ]
    });

    var aknowledgePanel = new Ext.form.FormPanel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: true,
        height: 250,
        width: 1200,
        frame: true,
        id: 'approveid',
        layout: 'table',
        layoutConfig: {
            columns: 4,
            style: {}
        },
        items: [{
            xtype: 'fieldset',
            title: '<%=AcknowledgementInfo%>',
            cls: 'fieldsetpanel',
            collapsible: false,
            colspan: 3,
            id: 'apprpanelid',
            width: 1150,
            layout: 'table',
            layoutConfig: {
                columns: 13
            },
            items: [{
                xtype: 'label',
                text: 'Royalty',
                cls: 'labelstyle',
                width: 150,
                id: 'labelstyle'
            }, {
                width: 100,
                height: 40
            }, {
                xtype: 'label',
                text: '*',
                width: 10,
                cls: 'mandatoryfield',
                id: 'mandatoryq'
            }, {
                xtype: 'label',
                text: '<%=NIC_Challan_No%>' + ' :',
                cls: 'labelstyle',
                width: 150,
                id: 'ChallanNumbertxt'
            }, {
                xtype: 'textfield',
                emptyText: '<%=EnterChallanNumber%>',
                allowBlank: false,
                blankText: '<%=EnterChallanNumber%>',
                listeners: { change: function(f,n,o){ //restrict 50
			 		if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
					f.setValue(n.substr(0,50)); f.focus(); }
				} },
                cls: 'selectstylePerfect',
                width: 100,
                id: 'ChallanNumberid',
                mode: 'local',
                forceSelection: true,
                selectOnFocus: true
            }, {
                xtype: 'label',
                text: '',
                width: 50,
                cls: 'selectstylePerfect',
                id: 'mandatorytss'
            }, {
                xtype: 'label',
                text: '*',
                width: 10,
                cls: 'mandatoryfield',
                id: 'mandatorysfd'
            }, {
                xtype: 'label',
                text: '<%=NIC_Challan_Date%>' + ' :',
                cls: 'labelstyle',
                width: 150,
                id: 'rem2txtss'
            }, {
                xtype: 'datefield',
                emptyText: '<%=EnterChallenDate%>',
                allowBlank: false,
                editable: false,
                blankText: '<%=EnterChallenDate%>',
                cls: 'selectstylePerfect',
                width: 100,
                format: getDateTimeFormat(),
                value: datecur,
                id: 'challanDateId'
            }, {
                xtype: 'label',
                text: '',
                width: 50,
                cls: 'selectstylePerfect',
                id: 'mandatoryt'
            }, {
                xtype: 'label',
                text: '*',
                width: 10,
                cls: 'mandatoryfield',
                id: 'mandatoryTran'
            }, {
                xtype: 'label',
                text: '<%=AmountPaid%>' + ' :',
                cls: 'labelstyle',
                width: 100,
                id: 'AmountPaidLabel'
            }, {
                xtype: 'numberfield',
                emptyText: '<%=EnterPaidAmount%>',
                allowBlank: false,
                blankText: '<%=EnterPaidAmount%>',
                autoCreate: { //restricts 
                    tag: "input",
                    maxlength: 20,
                    type: "numeric",
                    size: "200",
                    autocomplete: "off"
                },
                cls: 'selectstylePerfect',
                width: 100,
                id: 'amountId'
            }, {
                xtype: 'label',
                text: 'DMF',
                cls: 'labelstyle',
                width: 150,
                id: 'DMFlabelstyle'
            }, {
                width: 100,
                height: 40
            }, {
                xtype: 'label',
                text: '*',
                width: 10,
                cls: 'mandatoryfield',
                id: 'DMFmandatoryq'
            }, {
                xtype: 'label',
                text: '<%=NIC_Challan_No%>' + ' :',
                cls: 'labelstyle',
                width: 150,
                id: 'DMFChallanNumbertxt'
            }, {
                xtype: 'textfield',
                emptyText: '<%=EnterChallanNumber%>',
                allowBlank: false,
                blankText: '<%=EnterChallanNumber%>',
                listeners: { change: function(f,n,o){ //restrict 50
				 if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
					f.setValue(n.substr(0,50)); f.focus(); }
			    } },
                cls: 'selectstylePerfect',
                width: 100,
                id: 'DMFChallanNumberid',
                mode: 'local',
                forceSelection: true,
                selectOnFocus: true
            }, {
                xtype: 'label',
                text: '',
                width: 50,
                cls: 'selectstylePerfect',
                id: 'DMFmandatorytss'
            }, {
                xtype: 'label',
                text: '*',
                width: 10,
                cls: 'mandatoryfield',
                id: 'DMFmandatorysfd'
            }, {
                xtype: 'label',
                text: '<%=NIC_Challan_Date%>' + ' :',
                cls: 'labelstyle',
                width: 150,
                id: 'DMFrem2txtss'
            }, {
                xtype: 'datefield',
                emptyText: '<%=EnterChallenDate%>',
                allowBlank: false,
                editable: false,
                blankText: '<%=EnterChallenDate%>',
                cls: 'selectstylePerfect',
                width: 100,
                format: getDateTimeFormat(),
                value: datecur,
                id: 'DMFchallanDateId'
            }, {
                xtype: 'label',
                text: '',
                width: 50,
                cls: 'selectstylePerfect',
                id: 'DMFmandatoryt'
            }, {
                xtype: 'label',
                text: '*',
                width: 10,
                cls: 'mandatoryfield',
                id: 'DMFmandatoryTran'
            }, {
                xtype: 'label',
                text: '<%=AmountPaid%>' + ' :',
                cls: 'labelstyle',
                width: 100,
                id: 'DMFAmountPaidLabel'
            }, {
                xtype: 'numberfield',
                emptyText: '<%=EnterPaidAmount%>',
                allowBlank: false,
                blankText: '<%=EnterPaidAmount%>',
                autoCreate: { //restricts 
                    tag: "input",
                    maxlength: 20,
                    type: "numeric",
                    size: "200",
                    autocomplete: "off"
                },
                cls: 'selectstylePerfect',
                width: 100,
                id: 'DMFamountId'
            }, {
                xtype: 'label',
                text: 'NMET',
                cls: 'labelstyle',
                width: 150,
                id: 'NMETlabelstyle'
            }, {
                width: 100,
                height: 40
            }, {
                xtype: 'label',
                text: '*',
                width: 10,
                cls: 'mandatoryfield',
                id: 'NMETmandatoryq'
            }, {
                xtype: 'label',
                text: '<%=NIC_Challan_No%>' + ' :',
                cls: 'labelstyle',
                width: 150,
                id: 'NMETChallanNumbertxt'
            }, {
                xtype: 'textfield',
                emptyText: '<%=EnterChallanNumber%>',
                allowBlank: false,
                blankText: '<%=EnterChallanNumber%>',
                listeners: { change: function(f,n,o){ //restrict 50
			 		if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
					f.setValue(n.substr(0,50)); f.focus(); }
				} },
                cls: 'selectstylePerfect',
                width: 100,
                id: 'NMETChallanNumberid',
                mode: 'local',
                forceSelection: true,
                selectOnFocus: true
            }, {
                xtype: 'label',
                text: '',
                width: 50,
                cls: 'selectstylePerfect',
                id: 'NMETmandatorytss'
            }, {
                xtype: 'label',
                text: '*',
                width: 10,
                cls: 'mandatoryfield',
                id: 'NMETmandatorysfd'
            }, {
                xtype: 'label',
                text: '<%=NIC_Challan_Date%>' + ' :',
                cls: 'labelstyle',
                width: 150,
                id: 'NMETrem2txtss'
            }, {
                xtype: 'datefield',
                emptyText: '<%=EnterChallenDate%>',
                allowBlank: false,
                editable: false,
                blankText: '<%=EnterChallenDate%>',
                cls: 'selectstylePerfect',
                width: 100,
                format: getDateTimeFormat(),
                value: datecur,
                id: 'NMETchallanDateId'
            }, {
                xtype: 'label',
                text: '',
                width: 50,
                cls: 'selectstylePerfect',
                id: 'NMETmandatoryt'
            }, {
                xtype: 'label',
                text: '*',
                width: 10,
                cls: 'mandatoryfield',
                id: 'NMETmandatoryTran'
            }, {
                xtype: 'label',
                text: '<%=AmountPaid%>' + ' :',
                cls: 'labelstyle',
                width: 100,
                id: 'NMETAmountPaidLabel'
            }, {
                xtype: 'numberfield',
                emptyText: '<%=EnterPaidAmount%>',
                allowBlank: false,
                blankText: '<%=EnterPaidAmount%>',
                autoCreate: { //restricts 
                    tag: "input",
                    maxlength: 20,
                    type: "numeric",
                    size: "200",
                    autocomplete: "off"
                },
                cls: 'selectstylePerfect',
                width: 100,
                id: 'NMETamountId'
            }, {
                xtype: 'label',
                text: 'Processing Fee',
                cls: 'labelstyle',
                width: 150,
                id: 'ProFeelabelstyle'
            }, {
                width: 100,
                height: 40
            }, {
                xtype: 'label',
                text: '*',
                width: 10,
                cls: 'mandatoryfield',
                id: 'ProFeemandatoryq'
            }, {
                xtype: 'label',
                text: '<%=NIC_Challan_No%>' + ' :',
                cls: 'labelstyle',
                width: 150,
                id: 'ProFeeChallanNumbertxt'
            }, {
                xtype: 'textfield',
                emptyText: '<%=EnterChallanNumber%>',
                allowBlank: false,
                blankText: '<%=EnterChallanNumber%>',
                listeners: { change: function(f,n,o){ //restrict 50
			 		if(f.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
					f.setValue(n.substr(0,50)); f.focus(); }
				} },
                cls: 'selectstylePerfect',
                width: 100,
                id: 'ProFeeChallanNumberid',
                mode: 'local',
                forceSelection: true,
                selectOnFocus: true
            }, {
                xtype: 'label',
                text: '',
                width: 50,
                cls: 'selectstylePerfect',
                id: 'ProFeemandatorytss'
            }, {
                xtype: 'label',
                text: '*',
                width: 10,
                cls: 'mandatoryfield',
                id: 'ProFeemandatorysfd'
            }, {
                xtype: 'label',
                text: '<%=NIC_Challan_Date%>' + ' :',
                cls: 'labelstyle',
                width: 150,
                id: 'ProFeerem2txtss'
            }, {
                xtype: 'datefield',
                emptyText: '<%=EnterChallenDate%>',
                allowBlank: false,
                editable: false,
                blankText: '<%=EnterChallenDate%>',
                cls: 'selectstylePerfect',
                width: 100,
                format: getDateTimeFormat(),
                value: datecur,
                id: 'ProFeechallanDateId'
            }, {
                xtype: 'label',
                text: '',
                width: 50,
                cls: 'selectstylePerfect',
                id: 'ProFeemandatoryt'
            }, {
                xtype: 'label',
                text: '*',
                width: 10,
                cls: 'mandatoryfield',
                id: 'ProFeemandatoryTran'
            }, {
                xtype: 'label',
                text: '<%=AmountPaid%>' + ' :',
                cls: 'labelstyle',
                width: 100,
                id: 'ProFeeAmountPaidLabel'
            }, {
                xtype: 'numberfield',
                emptyText: '<%=EnterPaidAmount%>',
                allowBlank: false,
                blankText: '<%=EnterPaidAmount%>',
                autoCreate: { //restricts 
                    tag: "input",
                    maxlength: 20,
                    type: "numeric",
                    size: "200",
                    autocomplete: "off"
                },
                cls: 'selectstylePerfect',
                width: 100,
                id: 'ProFeeamountId'
            },{
                xtype: 'label',
                text: 'GIOPF',
                cls: 'labelstyle',
                width: 150,
                id: 'labelstyleg'
            }, {
                width: 100,
                height: 40
            }, {
                xtype: 'label',
                text: '*',
                width: 10,
                cls: 'mandatoryfield',
                id: 'mandatoryg'
            }, {
                xtype: 'label',
                text: '<%=NIC_Challan_No%>' + ' :',
                cls: 'labelstyle',
                width: 150,
                id: 'challangid'
            }, {
                xtype: 'textfield',
                emptyText: '<%=EnterChallanNumber%>',
                allowBlank: false,
                blankText: '<%=EnterChallanNumber%>',
                listeners: { change: function(f,n,o){ //restrict 100
			 		if(f.getValue().length> 100){ Ext.example.msg("Field exceeded it's Maximum length"); 
					f.setValue(n.substr(0,100)); f.focus(); }
				} },
                cls: 'selectstylePerfect',
                width: 100,
                id: 'ChallanNumberidg',
                mode: 'local',
                forceSelection: true,
                selectOnFocus: true
            }, {
                xtype: 'label',
                text: '',
                width: 50,
                cls: 'selectstylePerfect',
                id: 'mandatorytssg'
            }, {
                xtype: 'label',
                text: '*',
                width: 10,
                cls: 'mandatoryfield',
                id: 'mandatorysfdg'
            }, {
                xtype: 'label',
                text: '<%=NIC_Challan_Date%>' + ' :',
                cls: 'labelstyle',
                width: 150,
                id: 'rem2txtssg'
            }, {
                xtype: 'datefield',
                emptyText: '<%=EnterChallenDate%>',
                allowBlank: false,
                editable: false,
                blankText: '<%=EnterChallenDate%>',
                cls: 'selectstylePerfect',
                width: 100,
                format: getDateTimeFormat(),
                value: datecur,
                id: 'challanDateIdg'
            }, {
                xtype: 'label',
                text: '',
                width: 50,
                cls: 'selectstylePerfect',
                id: 'mandatorytg'
            }, {
                xtype: 'label',
                text: '*',
                width: 10,
                cls: 'mandatoryfield',
                id: 'mandatoryTrang'
            }, {
                xtype: 'label',
                text: '<%=AmountPaid%>' + ' :',
                cls: 'labelstyle',
                width: 100,
                id: 'AmountPaidLabelg'
            }, {
                xtype: 'numberfield',
                emptyText: '<%=EnterPaidAmount%>',
                allowBlank: false,
                blankText: '<%=EnterPaidAmount%>',
                autoCreate: { //restricts 
                    tag: "input",
                    maxlength: 20,
                    type: "numeric",
                    size: "200",
                    autocomplete: "off"
                },
                cls: 'selectstylePerfect',
                width: 100,
                id: 'amountIdg'
            }]
        }]
    });

    var aknowledgeButtonPanel = new Ext.Panel({
        id: 'approvepanelid',
        standardSubmit: true,
        collapsible: false,
        autoHeight: true,
        height: 10,
        width: 1180,
        frame: true,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        buttons: [{
            xtype: 'button',
            text: 'Approval',
            id: 'saveId',
            cls: 'buttonstyle',
            width: 70,
            listeners: {
                click: {
                    fn: function() {
                        var selected = grid.getSelectionModel().getSelected();
                        var ackGlobalId = Ext.getCmp('custcomboId').getValue();
                        var pattern = /[a-zA-Z0-9][a-zA-Z0-9\s]*/;
                        if (!(pattern.test(Ext.getCmp('ChallanNumberid').getValue()) || pattern.test(Ext.getCmp('DMFChallanNumberid').getValue()) || pattern.test(Ext.getCmp('NMETChallanNumberid').getValue()) || pattern.test(Ext.getCmp('ChallanNumberidg').getValue())|| pattern.test(Ext.getCmp('ProFeeChallanNumberid').getValue()))) {
                           
                            Ext.example.msg("<%=EnterChallanNumber%>");
                            Ext.getCmp('ChallanNumberid').focus();
                            return;
                        }
                        if ((Ext.getCmp('ChallanNumberid').getValue() == "" && Ext.getCmp('challanDateId').getValue() != "") || (Ext.getCmp('ChallanNumberid').getValue() != "" && Ext.getCmp('challanDateId').getValue() == "")) {
                            if (Ext.getCmp('ChallanNumberid').getValue() == "") {
                                Ext.example.msg("<%=EnterChallanNumber%>");
                                Ext.getCmp('ChallanNumberid').focus();
                                return;
                            } else {
                                Ext.example.msg("<%=EnterChallenDate%>");
                                Ext.getCmp('challanDateId').focus();
                                return;
                            }
                        }
                        if ((Ext.getCmp('DMFChallanNumberid').getValue() == "" && Ext.getCmp('DMFchallanDateId').getValue() != "") || (Ext.getCmp('DMFChallanNumberid').getValue() != "" && Ext.getCmp('DMFchallanDateId').getValue() == "")) {
                            if (Ext.getCmp('DMFChallanNumberid').getValue() == "") {
                                Ext.example.msg("<%=EnterChallanNumber%>");
                                Ext.getCmp('DMFChallanNumberid').focus();
                                return;
                            } else {
                                Ext.example.msg("<%=EnterChallenDate%>");
                                Ext.getCmp('DMFchallanDateId').focus();
                                return;
                            }
                        }
                        if ((Ext.getCmp('NMETChallanNumberid').getValue() == "" && Ext.getCmp('NMETchallanDateId').getValue() != "") || (Ext.getCmp('NMETChallanNumberid').getValue() != "" && Ext.getCmp('NMETchallanDateId').getValue() == "")) {
                            if (Ext.getCmp('NMETChallanNumberid').getValue() == "") {
                                Ext.example.msg("<%=EnterChallanNumber%>");
                                Ext.getCmp('NMETChallanNumberid').focus();
                                return;
                            } else {
                                Ext.example.msg("<%=EnterChallenDate%>");
                                Ext.getCmp('NMETchallanDateId').focus();
                                return;
                            }
                        }
                        if ((Ext.getCmp('ProFeeChallanNumberid').getValue() == "" && Ext.getCmp('ProFeechallanDateId').getValue() != "") || (Ext.getCmp('ProFeeChallanNumberid').getValue() != "" && Ext.getCmp('ProFeechallanDateId').getValue() == "")) {
                            if (Ext.getCmp('ProFeeChallanNumberid').getValue() == "") {
                                Ext.example.msg("<%=EnterChallanNumber%>");
                                Ext.getCmp('ProFeeChallanNumberid').focus();
                                return;
                            } else {
                                Ext.example.msg("<%=EnterChallenDate%>");
                                Ext.getCmp('ProFeechallanDateId').focus();
                                return;
                            }
                        }
                        
                        if ((Ext.getCmp('ChallanNumberidg').getValue() == "" && Ext.getCmp('challanDateIdg').getValue() != "") || (Ext.getCmp('ChallanNumberidg').getValue() != "" && Ext.getCmp('challanDateIdg').getValue() == "")) {
                            if (Ext.getCmp('ChallanNumberidg').getValue() == "") {
                                Ext.example.msg("<%=EnterChallanNumber%>");
                                Ext.getCmp('ChallanNumberidg').focus();
                                return;
                            } else {
                                Ext.example.msg("<%=EnterChallenDate%>");
                                Ext.getCmp('challanDateIdg').focus();
                                return;
                            }
                        }
                        var pattern = /[a-zA-Z0-9][a-zA-Z0-9\s]*/;
                        var cudate = Ext.getCmp('challanDateId').getRawValue();
                        approveWin.getEl().mask();

                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/ChallanDetailsAction.do?param=acknowledgeSave',
                            method: 'POST',
                            params: {
                                challanNo: selected.get('challanNumberDataIndex'),
                                nicChallanNo: Ext.getCmp('ChallanNumberid').getValue(),
                                nicChallanDate: Ext.getCmp('challanDateId').getValue(),
                                amount: Ext.getCmp('amountId').getValue(),
                                DMFnicChallanNo: Ext.getCmp('DMFChallanNumberid').getValue(),
                                DMFnicChallanDate: Ext.getCmp('DMFchallanDateId').getValue(),
                                DMFamount: Ext.getCmp('DMFamountId').getValue(),
                                NMETnicChallanNo: Ext.getCmp('NMETChallanNumberid').getValue(),
                                NMETnicChallanDate: Ext.getCmp('NMETchallanDateId').getValue(),
                                NMETamount: Ext.getCmp('NMETamountId').getValue(),
                                PFnicChallanNo: Ext.getCmp('ProFeeChallanNumberid').getValue(),
                                PFnicChallanDate: Ext.getCmp('ProFeechallanDateId').getValue(),
                                GInicChallanNo: Ext.getCmp('ChallanNumberidg').getValue(),
                                GInicChallanDate: Ext.getCmp('challanDateIdg').getValue(),
                                PFamount: Ext.getCmp('ProFeeamountId').getValue(),
                                GIamount: Ext.getCmp('amountIdg').getValue(),
                                ackuniqueId: selected.get('uniqueIdDataIndex'),
                                CustID: Ext.getCmp('custcomboId').getValue(),
                                challantype: selected.get('challanTypeDataIndex'),
                                orgId: selected.get('organizationIdDataIndex'),
                                mwallet: selected.get('totalPayableDataIndex')
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                approveWin.hide();
                                approveWin.getEl().unmask();
                                store.load({
                                    params: {
                                        CustID: Ext.getCmp('custcomboId').getValue(),
                                        jspName: jspName,
                                        CustName: Ext.getCmp('custcomboId').getRawValue(),
                                        endDate: Ext.getCmp('enddate').getValue(),
			                            startDate: Ext.getCmp('startdate').getValue()
                                    }
                                });
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                approveWin.hide();
                            }
                        });
                    }
                }
            }
        }, {
            xtype: 'button',
            text: '<%=cancel%>',
            id: 'cancelButtonId',
            cls: 'buttonstyle',
            iconCls: 'cancelbutton',
            width: 70,
            listeners: {
                click: {
                    fn: function() {
                        approveWin.hide();
                    }
                }
            }
        }]
    });

    var aknowledgePanelWindow = new Ext.Panel({
        id: 'mainPanelId',
        height: 360,
        width: 1200,
        standardSubmit: true,
        frame: true,
        items: [aknowledgePanel, aknowledgeButtonPanel]
    });

    approveWin = new Ext.Window({
        title: '<%=AcknowledgementInfo%>',
        closable: false,
        resizable: false,
        modal: true,
        autoScroll: false,
        height: 360,
        width: 1200,
        id: 'myWinApprove',
        items: [aknowledgePanelWindow]
    });
    //**************************Function For Adding Customer Information For Trip*******************
    function addRecord() {
        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("<%=pleaseSelectCustomer%>");
            Ext.getCmp('custcomboId').focus();
            return;
        }
        buttonValue = "add";
        title = 'Add Challan Details';
        myWin.setTitle(title);
        gradeStore.load({
            params: {
                CustID: Ext.getCmp('custcomboId').getValue(),
                type: 'E-Wallet Challan',
                id: 0
            }
        });
        gradeComboStore.load({
            params: {
                mineralType: '',
                CustID: '0',
                RoyaltyDate: ''
            }
        });
        Store2.load({
            params: {
                CustID: Ext.getCmp('custcomboId').getValue(),
                type: 'Others',
                tcno: 0,
                id: 0
            }
        });
        gridPanelForBauxite.hide();
        gridPanel.show();
        Ext.getCmp('eWalletNo').setValue('');
        Ext.getCmp('eWalletQty').setValue('');
        Ext.getCmp('ewalletAmtId').setValue('');
        Ext.getCmp('payableId1').setValue('');
        Ext.getCmp('payableId1').setValue(0);
        Ext.getCmp('totalPayableId').setValue('');
        Ext.getCmp('totalPayableId').reset();
        Ext.getCmp('challantypeId').reset();
        Ext.getCmp('mineralTypecomboId').reset();
        ewalletChallanPanel.hide();
        myWin.show();
        myWin.setTitle(title);
        outerPanelForGrid.show();
        outerPanelForGrid2.hide();
        challanDetailsPanel.show();
        Ext.getCmp('TccomboId').setReadOnly(false);
        Ext.getCmp('challantypeId').setReadOnly(false);
        Ext.getCmp('typeComboId').setReadOnly(false);
        Ext.getCmp('mineralTypecomboId').setReadOnly(false);
        Ext.getCmp('royaltydatelab').setReadOnly(false);
        Ext.getCmp('closecomboId').enable();

        Ext.getCmp('paymentcomboId').setValue(paymentComboStore.getAt(0).data['paymentAccHeadId']);
        Ext.getCmp('paymentcomboId').setRawValue(paymentComboStore.getAt(0).data['paymentAccHead']);
        Ext.getCmp('mineralTypecomboId').setValue(mineralTypeComboStore.getAt(0).data['mineralName']);
        Ext.getCmp('TccomboId').clearValue();
        Ext.getCmp('mplAllocatedId').setValue('');
        Ext.getCmp('mplBalId').setValue('');
        Ext.getCmp('leaseNameId').setValue('');
        Ext.getCmp('MineOwnerId').setValue('');
        Ext.getCmp('orgNameId').setValue('');
        organizationCodeStore.removeAll();
        Ext.getCmp('organizationcodeComboid').reset();
        Ext.getCmp('orgTraderNameId').reset();
        Ext.getCmp('MineCodeId').setValue('');
       // Ext.getCmp('mineralTypecomboId').clearValue();
        Ext.getCmp('royaltydatelab').reset();
        Ext.getCmp('challantypeId').setValue('');
        Ext.getCmp('financeId').setValue(year);
        Ext.getCmp('paymentDescriptionId').setValue('');
        Ext.getCmp('closecomboId').setValue('');

        Ext.getCmp('mandatorypayable').hide();
        Ext.getCmp('mandatorypayable1').hide();
        Ext.getCmp('payableLabelId').hide();
        Ext.getCmp('PayableId').hide();

        Ext.getCmp('typeComboId').hide();
        Ext.getCmp('mandatoryTypeid1').hide();
        Ext.getCmp('typeAdjLabelId1').hide();
        Ext.getCmp('mandatorydtLabel1').hide();

        Ext.getCmp('closecomboId').hide();
        Ext.getCmp('typeclose').hide();
        Ext.getCmp('mandatoryTypeclose1').hide();
        Ext.getCmp('mandatoryTypeclose').hide();

        Ext.getCmp('challanCheckBoxId').setValue(false);
        Ext.getCmp('totalPayableId').setValue(0);
        Ext.getCmp('balanceId').setValue(0);

        editedRows = "";
        editedRowsForBuGrid = "";
        IndexPayable = 0;
        
        Ext.getCmp('paymentcomboId').focus();
    }

    //*********************** Function to Modify Data ***********************************

    function modifyData() {
    	Ext.getCmp('mplAllocatedId').setValue('');
        Ext.getCmp('mplBalId').setValue('');
    	Ext.getCmp('challanCheckBoxId').reset();
        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("Select client");
            return;
        }
        if (grid.getSelectionModel().getCount() == 0) {
            Ext.example.msg("No Rows Selected");
            return;
        }
        if (grid.getSelectionModel().getCount() > 1) {
            Ext.example.msg("Select Single Row");
            return;
        }
        buttonValue = "Modify";
        titel = "Modify Challan Details"
        myWin.setTitle(titel);
        editedRows = "";
        editedRowsForBuGrid = "";
        IndexPayable = 0;
        Ext.getCmp('paymentcomboId').focus();
        var selected = grid.getSelectionModel().getSelected();
        var selectedGrade = outerPanelForGrid.getSelectionModel().getSelected();
        var status = selected.get('openStatusDataIndex');
        if (status == 'PENDING APPROVAL' || status == 'CLOSE' || status == '') {
            Ext.example.msg("Record Already Submitted,Can not Modify");
            return;
        }
        if (status == 'APPROVED' || status == 'ACKNOWLEDGED') {
            Ext.example.msg("Record Already Approved,Can not Modify");
            return;
        }
        type = selected.get('typeDataIndex');
        Ext.getCmp('closecomboId').reset();
        var challanType = selected.get('challanTypeDataIndex');
        var tcId = selected.get('TCNOIdDataIndex');
        if (challanType == 'ROM') {
            closeComboStore.load({
                params: {
                    CustID: Ext.getCmp('custcomboId').getValue(),
                    tcId: tcId
                }
            });
            Ext.getCmp('closecomboId').show();
            Ext.getCmp('typeclose').show();
            Ext.getCmp('mandatoryTypeclose1').show();
            Ext.getCmp('mandatoryTypeclose').show();
            Ext.getCmp('closecomboId').setValue(selected.get('closedPermitNoDataIndex'));
            Ext.getCmp('closecomboId').disable();

            var ewalletNumber;
            var amt;
            var qty;
            var usedQty;
            var usedAmount;
            var eAmt;
            eWalletStore.load({
                params: {
                    permitId: selected.get('closedPermitIdDataIndex'),
                    custId: Ext.getCmp('custcomboId').getValue(),
                },
                callback: function() {
                    for (var i = 0; i < eWalletStore.getCount(); i++) {
                        var rec = eWalletStore.getAt(i);
                        ewalletNumber = rec.data['ewalletNo'];
                        amt = rec.data['amount'];
                        qty = rec.data['qty'];
                        usedQty = rec.data['usedQty'];
                        usedAmount = rec.data['usedAmount'];
                        ewalletId = rec.data['ewalletId'];
                        giopfStatus= rec.data['giopfStatus'];
                    }
                    if (parseFloat(usedQty) == 0 && parseFloat(usedAmount) == 0) {
                        Ext.getCmp('eWalletNo').setValue(ewalletNumber);
                        Ext.getCmp('eWalletQty').setValue(qty);
                        Ext.getCmp('ewalletAmtId').setValue(amt);
                    } else {
                        Ext.getCmp('eWalletNo').setValue(ewalletNumber);
                        var eQty = parseFloat(qty) - parseFloat(usedQty);
                        eAmt = parseFloat(amt) - parseFloat(usedAmount);
                        if (parseFloat(eAmt) < 0) {
                            eAmt = 0;
                        }
                        Ext.getCmp('eWalletQty').setValue(eQty);
                        Ext.getCmp('ewalletAmtId').setValue(eAmt);
                    }
                    if(selected.get('ewalletBalanceDataIndex') == "Yes"){
	                    Ext.getCmp('payableId1').setValue(parseFloat(selected.get('ewalletBalance2DataIndex')) + parseFloat(selected.get('ewalletPayableDataIndex')));
                    }else{    
	                    Ext.getCmp('payableId1').setValue(parseFloat(selected.get('ewalletPayableDataIndex')));
                    }                
                }
            });
            gridPanel.show();
            ewalletChallanPanel.show();
            gridPanelForBauxite.hide();

        } else {
            Ext.getCmp('closecomboId').hide();
            Ext.getCmp('typeclose').hide();
            Ext.getCmp('mandatoryTypeclose1').hide();
            Ext.getCmp('mandatoryTypeclose').hide();
            gridPanel.show();
            ewalletChallanPanel.hide();
            gridPanelForBauxite.hide();
            if(challanType=="Processed Ore"){
              Ext.getCmp('totalPayableId').setValue(selected.get('ewalletPayableDataIndex'));
            }else{
              Ext.getCmp('totalPayableId').setValue(IndexPayable);
            }

        }
        if (challanType == 'Others') {
            Ext.getCmp('typeComboId').show();
            Ext.getCmp('mandatoryTypeid1').show();
            Ext.getCmp('typeAdjLabelId1').show();
            Ext.getCmp('mandatorydtLabel1').show();

            Ext.getCmp('typeComboId').setValue(selected.get('typeDataIndex'));
            gridPanel.show();
            outerPanelForGrid.hide();
            outerPanelForGrid2.show();
            gridPanelForBauxite.hide();
            Store2.load({
                params: {
                    CustID: Ext.getCmp('custcomboId').getValue(),
                    type: 'Others',
                    tcno: selected.get('TCNOIdDataIndex'),
                    id: selected.get('uniqueIdDataIndex')
                }
            });
        } else {
            Ext.getCmp('typeComboId').hide();
            Ext.getCmp('mandatoryTypeid1').hide();
            Ext.getCmp('typeAdjLabelId1').hide();
            Ext.getCmp('mandatorydtLabel1').hide();

            gridPanel.show();

            outerPanelForGrid.show();
            outerPanelForGrid2.hide();
            gridPanelForBauxite.hide();
            gradeStore.load({
                params: {
                    CustID: Ext.getCmp('custcomboId').getValue(),
                    type: challanType,
                    id: selected.get('uniqueIdDataIndex')
                }
            });
            gradeComboStore.load({
                params: {
                    mineralType: selected.get('mineralCodeDataIndex'),
                    CustID: Ext.getCmp('custcomboId').getValue(),
                    RoyaltyDate: selected.get('royaltyDataIndex')
                }
            });
        }
        if (type == 'Single' || type == 'DMF' || type == 'NMET' || type == 'GIOPF' || type == 'Royalty') {
            gridPanel.hide();
            outerPanelForGrid2.hide();
            outerPanelForGrid.hide();
            gridPanelForBauxite.hide();
            Ext.getCmp('mandatorypayable').show();
            Ext.getCmp('mandatorypayable1').show();
            Ext.getCmp('payableLabelId').show();
            Ext.getCmp('PayableId').show();
            Ext.getCmp('PayableId').setValue(selected.get('totalPayableDataIndex'));
        } else {
            Ext.getCmp('mandatorypayable').hide();
            Ext.getCmp('mandatorypayable1').hide();
            Ext.getCmp('payableLabelId').hide();
            Ext.getCmp('PayableId').hide();
        }

        Ext.getCmp('TccomboId').setReadOnly(true);
        Ext.getCmp('challantypeId').setReadOnly(true);
        Ext.getCmp('typeComboId').setReadOnly(true);
        Ext.getCmp('mineralTypecomboId').setReadOnly(true);
        Ext.getCmp('royaltydatelab').setReadOnly(true);
        Ext.getCmp('paymentcomboId').setValue(selected.get('paymentAcHeadDataIndex'));
        Ext.getCmp('TccomboId').setValue(selected.get('TCNODataIndex'));
        Ext.getCmp('leaseNameId').setValue(selected.get('MineNameDataIndex'));
        Ext.getCmp('MineOwnerId').setValue(selected.get('ownerNameDataIndex'));
        Ext.getCmp('orgNameId').setValue(selected.get('orgNameDataIndex'));
        Ext.getCmp('MineCodeId').setValue(selected.get('MineCodeDataIndex'));
        Ext.getCmp('mineralTypecomboId').setValue(selected.get('mineralTypeDataIndex'));
        Ext.getCmp('royaltydatelab').setValue(selected.get('royaltyDateDataIndex'));
        Ext.getCmp('TransMonthId').setValue(selected.get('TransMonthIndex'));
        Ext.getCmp('challantypeId').setValue(selected.get('challanTypeDataIndex'));
        Ext.getCmp('financeId').setValue(selected.get('financialYrDataIndex'));
        Ext.getCmp('paymentDescriptionId').setValue(selected.get('paymentDescriptionDataIndex'));
        Ext.getCmp('orgTraderNameId').setValue(selected.get('organizationNameDataIndex'));
        Ext.getCmp('organizationcodeComboid').setValue(selected.get('organizationCodeDataIndex'));

        Ext.getCmp('orgTraderNameId').setReadOnly(true);
        Ext.getCmp('organizationcodeComboid').setReadOnly(true);
	    TcNoComboStore.load({ params: { CustID: Ext.getCmp('custcomboId').getValue() } });
		var row = TcNoComboStore.findExact('TCno', selected.get('TCNODataIndex'));
		if(row>=0){
	       var rec = TcNoComboStore.getAt(row);
	       Ext.getCmp('mplBalId').setValue(rec.data['mplBal']);
	       Ext.getCmp('mplAllocatedId').setValue(rec.data['ecAllocated']);
		}
        myWin.show();
        if (challanType == 'Processed Ore' || challanType == 'Others') {
            gridPanel.show();
            challanDetailsPanel.hide();
            gridPanelForBauxite.hide();
        } else {
            gridPanel.show();
            challanDetailsPanel.show();
            gridPanelForBauxite.hide();
            Ext.getCmp('balanceId').setValue(selected.get('ewalletBalance2DataIndex'));
            Ext.getCmp('totalPayableId').setValue(selected.get('ewalletPayableDataIndex'));
        }

        if (challanType == 'Bauxite Challan') {
            gridPanel.hide();
            gridPanelForBauxite.show();
            outerPanelForBauxiteGrid.show();

            Ext.getCmp('mandatorDateId').show();
            Ext.getCmp('dateLabelId').show();
            Ext.getCmp('dateId').show();
            Ext.getCmp('mandatorydate16').show();
            //Ext.getCmp('dateId').setValue(selected.get('dateDataIndex'));

            storeForBauxite.load({
                params: {
                    CustID: Ext.getCmp('custcomboId').getValue(),
                    id: selected.get('uniqueIdDataIndex')
                }
            });
        }
        if (challanType == 'Processing Fee') {

            gridPanel.hide();
            outerPanelForGrid2.hide();
            outerPanelForGrid.hide();
            gridPanelForBauxite.hide();

            Ext.getCmp('mandatorypayable').show();
            Ext.getCmp('mandatorypayable1').show();
            Ext.getCmp('payableLabelId').show();
            Ext.getCmp('PayableId').show();
            Ext.getCmp('PayableId').setValue(selected.get('totalPayableDataIndex'));

        }
        if (selected.get('ewalletBalanceDataIndex') == 'Yes') {
            Ext.getCmp('challanCheckBoxId').setValue(true);
        }
        if (selected.get('ewalletBalanceDataIndex') == "") {
            Ext.getCmp('challanCheckBoxId').setValue('');
        }
        Ext.getCmp('dateId').setValue(selected.get('dateDataIndex'));
    }
    //*********************** Function to Modify Data Ends Here **************************	
    //*********************** Function to Acknowledgement ***********************************
    function columnchart() {
        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("<%=pleaseSelectCustomer%>");
            Ext.getCmp('custcomboId').focus();
            return;
        }
        if (grid.getSelectionModel().getCount() > 1) {
            Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }
        if (grid.getSelectionModel().getSelected() == null) {
            Ext.example.msg("<%=noRecordsFound%>");
            Ext.getCmp('custcomboId').focus();
            return;
        }
        buttonValue = "Approval";
        var selected = grid.getSelectionModel().getSelected();
        NicChallanNo = selected.get('challanNoDataIndex');
        status = selected.get('openStatusDataIndex');
        Ext.getCmp('amountId').disable();
        Ext.getCmp('DMFamountId').disable();
        Ext.getCmp('NMETamountId').disable();
        Ext.getCmp('ProFeeamountId').disable();
        Ext.getCmp('amountIdg').disable();
        Ext.getCmp('ChallanNumberid').enable(),
        Ext.getCmp('challanDateId').enable(),
        Ext.getCmp('DMFChallanNumberid').enable(),
        Ext.getCmp('DMFchallanDateId').enable(),
        Ext.getCmp('NMETChallanNumberid').enable(),
        Ext.getCmp('NMETchallanDateId').enable(),
        Ext.getCmp('ProFeeChallanNumberid').enable(),
        Ext.getCmp('ProFeechallanDateId').enable(),
        Ext.getCmp('ChallanNumberidg').enable(),
        Ext.getCmp('challanDateIdg').enable(),
        Ext.getCmp('ChallanNumberid').reset(),
        Ext.getCmp('challanDateId').reset(),
        Ext.getCmp('amountId').reset(),
        Ext.getCmp('DMFChallanNumberid').reset(),
        Ext.getCmp('DMFamountId').reset(),
        Ext.getCmp('DMFchallanDateId').reset(),
        Ext.getCmp('NMETChallanNumberid').reset(),
        Ext.getCmp('NMETamountId').reset(),
        Ext.getCmp('NMETchallanDateId').reset(),
        Ext.getCmp('ProFeeChallanNumberid').reset(),
        Ext.getCmp('ProFeeamountId').reset(),
        Ext.getCmp('ProFeechallanDateId').reset(),
        Ext.getCmp('ProFeechallanDateId').reset(),
        Ext.getCmp('ChallanNumberidg').reset(),
        Ext.getCmp('amountId').setValue(selected.get('royaltyAmtDataIndex'));
        Ext.getCmp('DMFamountId').setValue(selected.get('DMFDataIndex'));
        Ext.getCmp('NMETamountId').setValue(selected.get('NMETDataIndex'));
        Ext.getCmp('amountIdg').setValue(selected.get('GIDataIndex'));
        if (selected.get('challanTypeDataIndex') == 'Processing Fee') {
            Ext.getCmp('ProFeeamountId').setValue(selected.get('totalPayableDataIndex'));
        } else {
            Ext.getCmp('ProFeeamountId').setValue(selected.get('pFeeAmtDataIndex'));
        }
        Ext.getCmp('ChallanNumberid').setValue(selected.get('challanNoDataIndex'));
        if (Ext.getCmp('amountId').getValue() == "0") {
            Ext.getCmp('ChallanNumberid').disable();
        } else if (selected.get('challanNoDataIndex') != "") {
            Ext.getCmp('ChallanNumberid').disable();
        }
        Ext.getCmp('challanDateId').setValue(selected.get('challanDateDataIndex'));
        if (Ext.getCmp('amountId').getValue() == "0") {
            Ext.getCmp('challanDateId').disable();
        } else if (selected.get('challanDateDataIndex') != "") {
            Ext.getCmp('challanDateId').disable();
        }
        Ext.getCmp('DMFChallanNumberid').setValue(selected.get('DMFchallanNoDataIndex'));
        if (Ext.getCmp('DMFamountId').getValue() == "0") {
            Ext.getCmp('DMFChallanNumberid').disable();
        } else if (selected.get('DMFchallanNoDataIndex') != "") {
            Ext.getCmp('DMFChallanNumberid').disable();
        }
        Ext.getCmp('DMFchallanDateId').setValue(selected.get('DMFchallanDateDataIndex'));
        if (Ext.getCmp('DMFamountId').getValue() == "0") {
            Ext.getCmp('DMFchallanDateId').disable();
        } else if (selected.get('DMFchallanDateDataIndex') != "") {
            Ext.getCmp('DMFchallanDateId').disable();
        }
        Ext.getCmp('NMETChallanNumberid').setValue(selected.get('NMETchallanNoDataIndex'));
        if (Ext.getCmp('NMETamountId').getValue() == "0") {
            Ext.getCmp('NMETChallanNumberid').disable();
        } else if (selected.get('NMETchallanNoDataIndex') != "") {
            Ext.getCmp('NMETChallanNumberid').disable();
        }
        Ext.getCmp('NMETchallanDateId').setValue(selected.get('NMETchallanDateDataIndex'));
        if (Ext.getCmp('NMETamountId').getValue() == "0") {
            Ext.getCmp('NMETchallanDateId').disable();
        } else if (selected.get('NMETchallanDateDataIndex') != "") {
            Ext.getCmp('NMETchallanDateId').disable();
        }
        Ext.getCmp('ProFeeChallanNumberid').setValue(selected.get('PFchallanNoDataIndex'));
        if (Ext.getCmp('ProFeeamountId').getValue() == "0") {
            Ext.getCmp('ProFeeChallanNumberid').disable();
        } else if (selected.get('PFchallanNoDataIndex') != "") {
            Ext.getCmp('ProFeeChallanNumberid').disable();
        }
        Ext.getCmp('ProFeechallanDateId').setValue(selected.get('PFchallanDateDataIndex'));
        if (Ext.getCmp('ProFeeamountId').getValue() == "0") {
            Ext.getCmp('ProFeechallanDateId').disable();
        } else if (selected.get('PFchallanDateDataIndex') != "") {
            Ext.getCmp('ProFeechallanDateId').disable();
        }
        Ext.getCmp('ChallanNumberidg').setValue(selected.get('GIchallanNoDataIndex'));
        if (Ext.getCmp('amountIdg').getValue() == "0") {
            Ext.getCmp('ChallanNumberidg').disable();
        } else if (selected.get('GIchallanNoDataIndex') != "") {
            Ext.getCmp('ChallanNumberidg').disable();
        }
         Ext.getCmp('challanDateIdg').setValue(selected.get('GIchallanDateDataIndex'));
         if (Ext.getCmp('amountIdg').getValue() == "0") {
            Ext.getCmp('challanDateIdg').disable();
        } else if (selected.get('GIchallanDateDataIndex') != "") {
            Ext.getCmp('challanDateIdg').disable();
        }
        if (status == 'OPEN') {
            Ext.example.msg("Please submit the challan before approval");
            return;
        }
        if (status == 'APPROVED' || status == 'ACKNOWLEDGED') {
            Ext.example.msg("Record Already Approved");
            return;
        }
        approveWin.show();
      <%--  if (selected.get('ewalletPayableDataIndex') == 0 && selected.get('challanTypeDataIndex') != 'Processing Fee') {
            approveWin.hide();
            Ext.MessageBox.show({
                title: '',
                msg: 'Are you sure you want to Approve?',
                buttons: Ext.MessageBox.YESNO,
                icon: Ext.MessageBox.QUESTION,
                fn: function(btn) {
                    if (btn == 'yes') {
                        var selected = grid.getSelectionModel().getSelected();
                        ChallanNo = selected.get('challanNumberDataIndex');
                        status = selected.get('openStatusDataIndex');
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/ChallanDetailsAction.do?param=acknowledgeSave',
                            method: 'POST',
                            params: {
                                challanNo: ChallanNo,
                                CustID: Ext.getCmp('custcomboId').getValue(),
                                status: status,
                                ackuniqueId: selected.get('uniqueIdDataIndex'),
                                challantype: selected.get('challanTypeDataIndex'),
                                nicChallanNo: '',
                                nicChallanDate: '',
                                DMFnicChallanNo: '',
                                DMFnicChallanDate: '',
                                DMFamount: '',
                                NMETnicChallanNo: '',
                                NMETnicChallanDate: '',
                                NMETamount: '',
                                PFnicChallanNo: '',
                                PFnicChallanDate: '',
                                GInicChallanNo: '',
                                GInicChallanDate: '',
                                PFamount: '',
                                GIamount: '',
                                bankTranscNumber: '',
                                bankName: '',
                                branchName: '',
                                amount: '',
                                payDesc: '',
                                dateTymOfGen: ''
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                store.load({
                                    params: {
                                        CustID: Ext.getCmp('custcomboId').getValue(),
                                        jspName: jspName,
                                        CustName: Ext.getCmp('custcomboId').getRawValue(),
                                        endDate: Ext.getCmp('enddate').getValue(),
			                            startDate: Ext.getCmp('startdate').getValue()
                                    }
                                });
                                gradeStore.load({
                                    params: {
                                        CustID: Ext.getCmp('custcomboId').getValue(),
                                        type: challanType,
                                        id: selected.get('uniqueIdDataIndex')
                                    }
                                });
                                gradeComboStore.load({
                                    params: {
                                        mineralType: selected.get('mineralCodeDataIndex'),
                                        CustID: Ext.getCmp('custcomboId').getValue(),
                                        RoyaltyDate: selected.get('royaltyDataIndex')
                                    }
                                });
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                approveWin.hide();
                            }
                        });
                    }
                }
            });
        } else {
            approveWin.show();
        }  --%>
    }
    function getMonthYearFormat() {
        return 'F Y';
    }

    //*************************** function for final submit*******************************//
    function copyData() {
        var selected = grid.getSelectionModel().getSelected();
        NicChallanNo = selected.get('challanNoDataIndex');
        status = selected.get('openStatusDataIndex');
        if (grid.getSelectionModel().getCount() > 1) {
            Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }
        if (status == 'PENDING APPROVAL' || status == 'CLOSE') {
            Ext.example.msg("Record Already Submitted");
            return;
        }
        if (status == 'APPROVED' || status == 'ACKNOWLEDGED') {
            Ext.example.msg("Record Already Approved");
            return;
        }
        var ewalletNumber;
        var amt;
        var qty;
        var usedQty;
        var usedAmount;
        var eAmt;
        eWalletStore.load({
            params: {
                permitId: selected.get('closedPermitIdDataIndex'),
                custId: Ext.getCmp('custcomboId').getValue(),
            },
            callback: function() {
                for (var i = 0; i < eWalletStore.getCount(); i++) {
                    var rec = eWalletStore.getAt(i);
                    ewalletNumber = rec.data['ewalletNo'];
                    amt = rec.data['amount'];
                    qty = rec.data['qty'];
                    usedQty = rec.data['usedQty'];
                    usedAmount = rec.data['usedAmount'];
                    ewalletId = rec.data['ewalletId'];
                    eAmt = parseFloat(amt) - parseFloat(usedAmount);
                }
            }
        });
        Ext.MessageBox.show({
            title: '',
            msg: 'Are you sure you want to submit?',
            buttons: Ext.MessageBox.YESNO,
            icon: Ext.MessageBox.QUESTION,
            fn: function(btn) {
                if (btn == 'yes') {
                    var selected = grid.getSelectionModel().getSelected();
                    ChallanNo = selected.get('challanNumberDataIndex');
                    status = selected.get('openStatusDataIndex');
                    ewalletUsed = selected.get('ewalletBalanceDataIndex');
                    challanType = selected.get('challanTypeDataIndex');
                    totalQuantity = selected.get('totalQtyDataIndex');
                    payableAmount = selected.get('totalPayableDataIndex');
                    totalAmt = selected.get('payableDataIndex');
                    tcNo = selected.get('TCNOIdDataIndex');
                    eWalletBalance = selected.get('ewalletBalance2DataIndex');
                    orgId = selected.get('organizationIdDataIndex');
                    mwallet = selected.get('totalPayableDataIndex');
                    EWC_ID = selected.get('EWC_ID_Ind');
                    loadMask.show();
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/ChallanDetailsAction.do?param=finalSubmit',
                        method: 'POST',
                        params: {
                            CustID: Ext.getCmp('custcomboId').getValue(),
                            uniqueId: selected.get('uniqueIdDataIndex'),
                            status: status,
                            ewalletId: EWC_ID,
                            ewalletUsed: ewalletUsed,
                            challanType: challanType,
                            totalQuantity: totalQuantity,
                            ewalletAmount: eAmt,
                            payableAmount: payableAmount,
                            ewalletPayable: totalAmt,
                            tcNo: tcNo,
                            eWalletBalance: eWalletBalance,
                            orgId: orgId,
                            mwallet: mwallet
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            loadMask.hide();
                            store.load({
                                params: {
                                    CustID: Ext.getCmp('custcomboId').getValue(),
                                    jspName: jspName,
                                    CustName: Ext.getCmp('custcomboId').getRawValue(),
                                    endDate: Ext.getCmp('enddate').getValue(),
			                        startDate: Ext.getCmp('startdate').getValue()
                                }
                            });
                            gradeComboStore.load({
                                params: {
                                    mineralType: selected.get('mineralCodeDataIndex'),
                                    CustID: Ext.getCmp('custcomboId').getValue(),
                                    RoyaltyDate: selected.get('royaltyDataIndex')
                                }
                            });
                            TcNoComboStore.load({
                                params: {
                                    CustID: Ext.getCmp('custcomboId').getValue()

                                }
                            });
                        },
                        failure: function() {
                            Ext.example.msg("Error");
                            loadMask.hide();
                        }
                    });
                }
            }
        });
    }
    //*************************** function for pdf****************************//
    function approveFunction() {
        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("<%=pleaseSelectCustomer%>");
            Ext.getCmp('custcomboId').focus();
            return;
        }
        if (grid.getSelectionModel().getCount() > 1) {
            Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }
        if (grid.getSelectionModel().getCount() == 0) {
            Ext.example.msg("No Rows Selected");
            return;
        }
        var selected = grid.getSelectionModel().getSelected();
        status = selected.get('openStatusDataIndex');

        if (status != 'APPROVED' && status != 'ACKNOWLEDGED') {
            Ext.example.msg("Please Approve before taking PDF");
            return;
        }
        var id = selected.get('uniqueIdDataIndex');
        window.open("<%=request.getContextPath()%>/ChallanPDF?autoGeneratedKeys=" + id + "&buttonType='default'");
    }

    //****************************** Function for delete record***************************//   
    function deleteData() {
        var selected = grid.getSelectionModel().getSelected();
        NicChallanNo = selected.get('challanNoDataIndex');
        status = selected.get('openStatusDataIndex');
        if (grid.getSelectionModel().getCount() > 1) {
            Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }
        if (status == 'PENDING APPROVAL' || status == 'CLOSE') {
            Ext.example.msg("Record Already Submitted");
            return;
        }
        if (status == 'APPROVED' || status == 'ACKNOWLEDGED') {
            Ext.example.msg("Record Already Approved");
            return;
        }
        Ext.MessageBox.show({
            title: '',
            msg: 'Are you sure you want to Delete?',
            buttons: Ext.MessageBox.YESNO,
            icon: Ext.MessageBox.QUESTION,
            fn: function(btn) {
                if (btn == 'yes') {
                    var selected = grid.getSelectionModel().getSelected();
                    ChallanNo = selected.get('challanNumberDataIndex');
                    status = selected.get('openStatusDataIndex');
                    challanAmount = selected.get('payableDataIndex');
                    var quantityRom = selected.get('totalQtyDataIndex');
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/ChallanDetailsAction.do?param=deleteRecord',
                        method: 'POST',
                        params: {
                            challanNo: ChallanNo,
                            CustID: Ext.getCmp('custcomboId').getValue(),
                            tcNo: selected.get('TCNODataIndex'),
                            uniqueId: selected.get('uniqueIdDataIndex'),
                            challanType: selected.get('challanTypeDataIndex'),
                            payableAmount: IndexPayable,
                            ewalletBalance: ewallet,
                            ewalletPayable: Ext.getCmp('totalPayableId').getValue(),
                            ewalletQty: ewalletQty,
                            ewalletAmount: ewalletAmount,
                            ewalletId: ewalletId,
                            status: status,
                            challanAmount: challanAmount,
                            quantityRom: quantityRom
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            store.load({
                                params: {
                                    CustID: Ext.getCmp('custcomboId').getValue(),
                                    jspName: jspName,
                                    CustName: Ext.getCmp('custcomboId').getRawValue(),
                                    endDate: Ext.getCmp('enddate').getValue(),
			                        startDate: Ext.getCmp('startdate').getValue()
                                }
                            });
                            gradeStore.load({
                                params: {
                                    CustID: Ext.getCmp('custcomboId').getValue(),
                                    type: challanType,
                                    id: selected.get('uniqueIdDataIndex')
                                }
                            });
                            gradeComboStore.load({
                                params: {
                                    mineralType: selected.get('mineralCodeDataIndex'),
                                    CustID: Ext.getCmp('custcomboId').getValue(),
                                    RoyaltyDate: selected.get('royaltyDataIndex')
                                }
                            });
                        },
                        failure: function() {
                            Ext.example.msg("Error");
                            approveWin.hide();
                        }
                    });
                }
            }
        });
        var ewalletNumber;
        var amt;
        var qty;
        var usedQty;
        var usedAmount;
        eWalletStore.load({
            params: {
                permitId: selected.get('closedPermitIdDataIndex'),
                custId: Ext.getCmp('custcomboId').getValue(),
            },
            callback: function() {
                for (var i = 0; i < eWalletStore.getCount(); i++) {
                    var rec = eWalletStore.getAt(i);
                    ewalletNumber = rec.data['ewalletNo'];
                    amt = rec.data['amount'];
                    qty = rec.data['qty'];
                    usedQty = rec.data['usedQty'];
                    usedAmount = rec.data['usedAmount'];
                    ewalletId = rec.data['ewalletId'];
                }
                if (parseFloat(usedQty) == 0 && parseFloat(usedAmount) == 0) {
                    Ext.getCmp('eWalletNo').setValue(ewalletNumber);
                    Ext.getCmp('eWalletQty').setValue(qty);
                    Ext.getCmp('ewalletAmtId').setValue(amt);
                } else {
                    Ext.getCmp('eWalletNo').setValue(ewalletNumber);
                    var eQty = parseFloat(qty) - parseFloat(usedQty);
                    var eAmt = parseFloat(amt) - parseFloat(usedAmount);
                    if (parseFloat(eAmt) < 0) {
                        eAmt = 0;
                    }
                    Ext.getCmp('eWalletQty').setValue(eQty);
                    Ext.getCmp('ewalletAmtId').setValue(eAmt);

                }
            }
        });
    }
    Ext.onReady(function() {
        outerPanel = new Ext.Panel({
            renderTo: 'content',
            standardSubmit: true,
            frame: true,
            //height: 500,
            //width: screen.width - 40,
            width: screen.width - 22,
            cls: 'outerpanel',
            layout: 'table',
            layoutConfig: {
                columns: 1
            },
            items: [customerPanel, customSearchPanel,challanReportPanel, grid]
        });
        if(!<%=isLtsp%>){
        	Ext.getCmp('allChallanId').hide();
        }
    });
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
    <%}%>