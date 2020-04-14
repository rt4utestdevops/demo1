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
		//if (str.length > 11) {
		//	loginInfo.setStyleSheetOverride("N");
		//}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session
			.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
ArrayList<String> tobeConverted=new ArrayList<String>();
		tobeConverted.add("Customer_Name");
		tobeConverted.add("Please_Select_customer");
		tobeConverted.add("Select_business_Type");
		tobeConverted.add("Select_Route");
        tobeConverted.add("SLNO");
		tobeConverted.add("Business_Id");
		tobeConverted.add("Business_Type");
		tobeConverted.add("Msp");
		tobeConverted.add("Bank");
		tobeConverted.add("Adress");
		tobeConverted.add("Region");
		tobeConverted.add("Location");
		tobeConverted.add("Hub_Location");
		tobeConverted.add("Route_Id");
		tobeConverted.add("Latitude");
		tobeConverted.add("Longitude");
		tobeConverted.add("Business_Details");
		tobeConverted.add("Enter_Business_Id");
		tobeConverted.add("Enter_MSP");
		tobeConverted.add("Enter_Bank");
		tobeConverted.add("Enter_Address");
		tobeConverted.add("Enter_Region");
		tobeConverted.add("Enter_Location");
		tobeConverted.add("Enter_Hub_Location");
		tobeConverted.add("Enter_Latitude");
		tobeConverted.add("Enter_Longitude");
		tobeConverted.add("Save");
		tobeConverted.add("Cancel");
		tobeConverted.add("No_Rows_Selected");
		tobeConverted.add("Route_Type");
		tobeConverted.add("Route_Name");
		tobeConverted.add("Select_Single_Row");
		tobeConverted.add("Add_Business_Details");
		tobeConverted.add("Modify_Business_Details");
		tobeConverted.add("Radius");
		tobeConverted.add("Status");
		
ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);

		String selectCustomer=convertedWords.get(0);
		String pleaseSelectcustomer=convertedWords.get(1);
		String SelectbusinessType=convertedWords.get(2);
		String SelectRoute=convertedWords.get(3);
		String SLNO=convertedWords.get(4);
		String BusinessId=convertedWords.get(5);
		String BusinessType=convertedWords.get(6);
		String Msp=convertedWords.get(7);
		String Bank=convertedWords.get(8);
		String Adress=convertedWords.get(9);
		String Region=convertedWords.get(10);
		String Location=convertedWords.get(11);
		String HubLocation=convertedWords.get(12);
		String RouteId=convertedWords.get(13);
		String Latitude=convertedWords.get(14);
		String Longitude=convertedWords.get(15);
		String BusinessDetails=convertedWords.get(16);
		String EnterBusinessId=convertedWords.get(17);
		String EnterMSP=convertedWords.get(18);
		String EnterBank=convertedWords.get(19);
		String EnterAddress=convertedWords.get(20);
		String EnterRegion=convertedWords.get(21);
		String EnterLocation=convertedWords.get(22);
		String EnterHubLocation=convertedWords.get(23);
		String EnterLatitude=convertedWords.get(24);
		String EnterLongitude=convertedWords.get(25);
		String Save=convertedWords.get(26);
		String Cancel=convertedWords.get(27);
		String noRecordsFound=convertedWords.get(28);
		String RouteType=convertedWords.get(29);
		String RouteName=convertedWords.get(30);
		String SelectSingleRow=convertedWords.get(31);
		String AddBusinessDetails=convertedWords.get(32);
		String ModifyBusinessDetails=convertedWords.get(33);
		String Radius=convertedWords.get(34);
		String Status=convertedWords.get(35);		
double lat = 6.9271;
double lon = 79.8612;
double rad = 1.0;		
%>

<jsp:include page="../Common/header.jsp" />
	
		<title>Business Details</title>
	<style>
	.x-table-layout td {
    vertical-align: inherit !important;
    }
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
	</style>
	
		<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/ImportJSSandMining.jsp" />                                                    
        <%}else {%>  
        <jsp:include page="../Common/ImportJS.jsp" /><%} %>
        <jsp:include page="../Common/ExportJS.jsp" />
		<style>
			.x-panel-header
		{
				height: 28% !important;
		}
		
		.x-grid3-cell-inner,.ext-strict .x-grid3-hd-inner {
			height: 26px !important;
			padding-top: 8px;
		}
		.x-form-text {
			height: 21px !important;
		}
		label {
			display : inline !important;
		}
		</style>
        <script>
     
		var grid;
		var myWin;
		var buttonValue;
		var uniqueId;
		var globaltripId;
		var jspName='BusinessDetailsReport';	
    	var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string";
    
	function isValidEmailAddress(emailAddress) {
    	var pattern = new RegExp(/^(\s*,?\s*[0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9})+\s*$/);
    	return pattern.test(emailAddress);
	}

	//*********************** Store For Customer *****************************************//
	
	var cvsCustomerDetailscombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/BusinessDetails.do?param=getCVSCustomerDetails',
    id: 'CVSCustomerDetailsStoreId',
    root: 'CVSCustomerDetailsRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['Address', 'Region']
   });
	
	var cvsCustomercombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/BusinessDetails.do?param=getCVSCustomer',
    id: 'CVSCustomerStoreId',
    root: 'CVSCustomerRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['CVSCustId', 'CVSCustName']
   });
	
    var cvsCustomerCombo = new Ext.form.ComboBox({
    store: cvsCustomercombostore,
    id: 'cvsCustcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=pleaseSelectcustomer%>',
    selectOnFocus: true,
    resizable: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'CVSCustId',
    displayField: 'CVSCustName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function () {            
            			   
                     cvsCustomerDetailscombostore.load({
                     params:{
                     cvsCustId : Ext.getCmp('cvsCustcomboId').getValue(),
                     CustId: Ext.getCmp('custcomboId').getValue()
                     },
                     callback: function(){
                      var rec = cvsCustomerDetailscombostore.getAt(0);
                      if(typeof rec == 'undefined'){
                      Ext.getCmp('AddressId').setValue('');
                      Ext.getCmp('RegionId').setValue('');
                      }else{
                      
                      Ext.getCmp('AddressId').setValue(rec.data['Address']);
                      Ext.getCmp('RegionId').setValue(rec.data['Region']);
                      }   
                     }
                     }); 
            }
        }
    }
	});
	
	
	var customercombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
    id: 'CustomerStoreId',
    root: 'CustomerRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['CustId', 'CustName'],
    listeners: {
        load: function (custstore, records, success, options) {
            if ( <%= customerId %> > 0) {                
                Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                 store.load({
                 params: {
                        CustId: Ext.getCmp('custcomboId').getValue()
                        }
                   });
                businessTypeStore.load({
                params: {
                        CustId: Ext.getCmp('custcomboId').getValue()
                        }
                   });
                 routeCombostore.load({
                 params: {
                        CustId: Ext.getCmp('custcomboId').getValue()
                        }
                   });
            }
        }
    }
   });
   
   var statuscombostore = new Ext.data.SimpleStore({
    id: 'statuscombostoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Active', 'Active'],
        ['Inactive', 'Inactive']
    ]
});

var statuscombo = new Ext.form.ComboBox({
    store: statuscombostore,
    id: 'statuscomboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    emptyText: 'Select Status',
    blankText: 'Select Status',
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    value: 'Active',
    displayField: 'Name',
    cls: 'selectstylePerfect'
});

	//*********************** Store For Customer Ends Here*****************************************//
<!--	var businessTypeStore =new Ext.data.JsonStore({-->
<!--        url: '<%=request.getContextPath()%>/BusinessDetails.do?param=getBusinessType',-->
<!--        id:'businessTypeId',-->
<!--		root: 'BusinessTypeRoot',-->
<!--        autoLoad:false,-->
<!--		remoteSort: true,-->
<!--        fields:['businessType']-->
<!--        });-->

var businessTypeStore = new Ext.data.SimpleStore({
    id: 'businessTypeId',
    fields: ['businessType', 'businessType'],
    data: [
        ['ATM Replenishment', 'ATM Replenishment'],
        ['ATM Deposit','ATM Deposit'],
        ['Cash pickup', 'Cash pickup'],
        ['Cash Delivery','Cash Delivery'],
        ['Pay Packeting','Pay Packeting'],
        ['Bank','Bank'],
        ['Manpower(Cashier/Gunmen)','Manpower(Cashier/Gunmen)'],
        ['Cash Transfer','Cash Transfer']
    ]
});
	//******************************Business Type Combo****************************************************//
	var businessTypeCombo = new Ext.form.ComboBox({
    store: businessTypeStore,
    id: 'businessTypecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectbusinessType%>',
    blankText: '<%=SelectbusinessType%>',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'businessType',
    displayField: 'businessType',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
               
            }
        }
    }
  });
  //------------------------routeId ---------------------------------------------------------//
   var routeCombostore = new Ext.data.JsonStore({
    id: 'routeCombostoreId',
    url: '<%=request.getContextPath()%>/BusinessDetails.do?param=getRouteId',
    root: 'routeTypeRoot',
    autoLoad:false,
	remoteSort: true,
    fields: ['uniqueRouteId','routeId','routeType','routeName']
});
/*********************************RfidCombo********************************************/
var routeIdCombo = new Ext.form.ComboBox({
    store: routeCombostore,
    id: 'routeComboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'routeId',
	emptyText: '<%=SelectRoute%>',
    blankText: '<%=SelectRoute%>',
    displayField: 'routeId',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
         		   var routeId = Ext.getCmp('routeComboId').getValue();
                   var row = routeCombostore.find('routeId',Ext.getCmp('routeComboId').getValue());
                   var rec = routeCombostore.getAt(row);
                  // Ext.getCmp('routeTypeId').setValue(rec.data['routeType']);
                   Ext.getCmp('routeNameId').setValue(rec.data['routeName']);
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
    emptyText: '<%=pleaseSelectcustomer%>',
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
            fn: function () {
                custId = Ext.getCmp('custcomboId').getValue();
                //alert(custId);
                 store.load({
                 params: {
                        CustId: custId
                        }
                   });
                 businessTypeStore.load({
                 params: {
                        CustId: Ext.getCmp('custcomboId').getValue()
                        }
                   });
                   routeCombostore.load({
                   params: {
                        CustId: Ext.getCmp('custcomboId').getValue()
                        }
                   });
            }
        }
    }
	});
	
	
	//************************ Combo for Customer Ends Here***************************************//	
	
	
	 //********************************************Grid config starts***********************************
  
  
    // **********************************************Reader configs Starts******************************
    
     var reader = new Ext.data.JsonReader({
        idProperty: 'businessDetailsId',
    	root: 'businessDetailsRoot',
    	totalProperty: 'total',
    	fields: [{
        name: 'slnoIndex'
    	},{
        name: 'businessIdIndex'
    	},{
    	name: 'businessTypeIndex'
    	},{
    	name: 'bankIndex'
    	},{
        name: 'addressIndex'
    	},{
        name: 'EmailDataIndex'
    	},{
    	name: 'regionIndex'
    	},{
    	name: 'hubLocationIndex'
    	},{
        name: 'routeIdIndex'
    	},{
        name: 'routeNameIndex'
    	},{
    	name: 'latitudeIndex'
    	},{
    	name: 'longitudeIndex'
    	},{
    	name:'uniqueIdDataIndex'
    	},{
    	name:'radiusIndex'
    	},{
    	name:'statusIndex'
    	}]
    });
    
    // **********************************************Reader configs Ends******************************

    //********************************************Store Configs For Grid*************************

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/BusinessDetails.do?param=getBusinessDetails',
            method: 'POST'
        }),
        remoteSort: false,
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
        type: 'string',
        dataIndex: 'businessIdIndex'
    	}, {
        type: 'string',
        dataIndex: 'businessTypeIndex'
    	},{
        type: 'string',
        dataIndex: 'bankIndex'
    	},{
        type: 'string',
        dataIndex: 'addressIndex'
    	},{
        type: 'string',
        dataIndex: 'EmailDataIndex'
    	},{
        type: 'string',
        dataIndex: 'regionIndex'
    	},{
        type: 'string',
        dataIndex: 'hubLocationIndex'
    	},{
        type: 'string',
        dataIndex: 'routeIdIndex'
    	},{
        type: 'string',
        dataIndex: 'routeNameIndex'
    	},{
        type: 'numeric',
        dataIndex: 'latitudeIndex'
    	},{
        type: 'numeric',
        dataIndex: 'longitudeIndex'
    	},{
        type: 'numeric',
        dataIndex: 'radiusIndex'
    	},{
        type: 'string',
        dataIndex: 'statusIndex'
    	}]
    	});
    	
    	//***************************************************Filter Config Ends ***********************

    //*********************************************Column model config**********************************
    
    var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
        	header: "<span style=font-weight:bold;>SLNO</span>",
        	width: 50
    		}), {
        	dataIndex: 'slnoIndex',
        	hidden: true,
        	header: "<span style=font-weight:bold;><%=SLNO%></span>",
        	filter: {
            type: 'numeric'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=BusinessId%></span>",
        	dataIndex: 'businessIdIndex',
        	width: 110,
        	filter: {
            type: 'string'
        	}
    		},
			{
        	header: "<span style=font-weight:bold;><%=BusinessType%></span>",
        	dataIndex: 'businessTypeIndex',
        	width: 110,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=Bank%></span>",
        	dataIndex: 'bankIndex',
        	width: 110,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=Adress%></span>",
        	dataIndex: 'addressIndex',
        	width: 110,
        	filter: {
            type: 'string'
        	}
    		},{
            header: "<span style=font-weight:bold;>Email</span>",
            dataIndex: 'EmailDataIndex',
            width: 110,
            filter: {
                type: 'string'
            }
        	},{
        	header: "<span style=font-weight:bold;><%=Region%></span>",
        	dataIndex: 'regionIndex',
        	width: 110,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=HubLocation%></span>",
        	dataIndex: 'hubLocationIndex',
        	width: 110,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=RouteId%></span>",
        	dataIndex: 'routeIdIndex',
        	width: 110,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=RouteName%></span>",
        	dataIndex: 'routeNameIndex',
        	width: 110,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=Latitude%></span>",
        	dataIndex: 'latitudeIndex',
        	width: 110,
        	filter: {
            type: 'numeric'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=Longitude%></span>",
        	dataIndex: 'longitudeIndex',
        	width: 80,
        	filter: {
            type: 'numeric'
        	}
    		},
    		 {
    		header: "<span style=font-weight:bold;><%=Radius%></span>",
        	dataIndex: 'radiusIndex',
        	width: 80,
        	hidden: true,
        	filter: {
            type: 'numeric'
        	}
    		}, 
    		{
    		header: "<span style=font-weight:bold;><%=Status%></span>",
        	dataIndex: 'statusIndex',
        	width: 80,
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
 
     //*********************************************Column model config Ends***************************
     //******************************************Creating Grid By Passing Parameter***********************

    grid = getGrid('<%=BusinessDetails%>', '<%=noRecordsFound%>', store,screen.width-40,430, 22, filters, 'Clear Filter Data', false, '', 14, false, '', false, '', false, '', jspName, exportDataType, false, '', true, 'Add', true, 'Modify', false, '', false , '');	
		
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
        		columns: 4
    			},
    			items: [{
                    width: 50
                },{
            		xtype: 'label',
           		    text: '<%=selectCustomer%>' + ' :',
            		cls: 'labelstyle',
            		id: 'custnamelab'
        			},
        			custnamecombo, {
                    width: 50
                }]
				});
 
   //****************************** Inner Pannel Starts Here For Adding Trip Inforamtion ***************
   
   var innerPanel2 = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 430,
    width: 900,
    frame: false,
    id: 'addmap',
     items: [{
        	html: "<iframe id = 'xyz' style = 'height:420px;width:890px'; src='<%=request.getContextPath()%>/Jsps/CashVanManagement/BusinessDetailsMapView.jsp'></iframe>"
        	}]
});
   
   var innerPanel = new Ext.form.FormPanel({
    title:"Business Details",
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 430,
    width: 390,
    frame: false,
    id: 'addFuel',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
        items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryBusiness'
            },{
                xtype: 'label',
                text: '<%=BusinessId%>' +' :',
                cls: 'labelstyle',
                id: 'BusinessLabelId'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',               
                emptyText: '<%=EnterBusinessId%>',
                blankText: '<%=EnterBusinessId%>',
                maxLength: 50,
                id: 'businessId',
                allowBlank: false,
			maskRe: /[a-zA-Z0-9\s]/i,
			labelSeparator: '',
			autoCreate: {
				tag: "input",
				maxlength: 50,
				type: "text",
				size: "50",
				autocomplete: "off"
			}
                
            },{},{   
               xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'businessTypelabelId'
            }, {
                xtype: 'label',
                text: '<%=BusinessType%>' + ':',
                cls: 'labelstyle',
                id: 'businessTypeId'
            }, businessTypeCombo,{},{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryBank'
            },{
                xtype: 'label',
                text: '<%=selectCustomer%>' +' :',
                cls: 'labelstyle',
                id: 'BankLabelId'
            }, 
               cvsCustomerCombo
            ,{},{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryAddress'
            },{
                xtype: 'label',
                text: '<%=Adress%>' +' :',
                cls: 'labelstyle',
                id: 'AddressLabelId'
            }, {
                xtype: 'textarea',
                cls: 'selectstylePerfect',               
                emptyText: '<%=EnterAddress%>',
                blankText: '<%=EnterAddress%>',
                maxLength: 500,
                id: 'AddressId'
            },{},{
            	xtype: 'label',
            	text: '*',
            	cls: 'mandatoryfield',
            	id: 'mandatoryEmail'
        	},{
            	xtype: 'label',
            	text: 'Email' + ' :',
            	cls: 'labelstyle',
            	id: 'EmailLabelId'
        	}, {
            	xtype: 'textfield',
            	//vtype: 'email',
            	cls: 'selectstylePerfect',
            	id: 'EmailTextId',
            	mode: 'local',
            	forceSelection: true,
            	emptyText: 'Enter Email',
            	blankText: 'Enter Email',
            	selectOnFocus: true,
            	allowBlank: false,
            	regex:/^(\w+)([\-+.\'][\w]+)*@(\w[\-\w]*\.){1,5}([A-Za-z]){2,6}$/,
            	//regex:/[a-z0-9_.-@]/i,
               	autoCreate: { //restricts user to 100 chars max, 
				tag: "input",
				maxlength: 100,
				type: "text",
				size: "100",
				autocomplete: "off"
			}
       	 	},{},{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryregion'
            },{
                xtype: 'label',
                text: '<%=Region%>' +' :',
                cls: 'labelstyle',
                id: 'RegionLabelId'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',               
                emptyText: '<%=EnterRegion%>',
                blankText: '<%=EnterRegion%>',
                maxLength: 50,
                id: 'RegionId'
            },{},{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryHublocation'
            },{
                xtype: 'label',
                text: '<%=HubLocation%>' +' :',
                cls: 'labelstyle',
                id: 'hubLocationLabelId'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',               
                emptyText: '<%=EnterHubLocation%>',
                blankText: '<%=EnterHubLocation%>',
                maxLength: 50,
                id: 'hubLocationId',
                allowBlank: false,
			maskRe: /[a-zA-Z0-9\s]/i,
			labelSeparator: '',
			autoCreate: {
				tag: "input",
				maxlength: 50,
				type: "text",
				size: "50",
				autocomplete: "off"
			}
            },{},{   
               xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'routeIdlabelId'
            }, {
                xtype: 'label',
                text: '<%=RouteId%>' + ':',
                cls: 'labelstyle',
                id: 'routeId'
            }, routeIdCombo,{},{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryRouteName'
            },{
                xtype: 'label',
                text: '<%=RouteName%>' +' :',
                cls: 'labelstyle',
                id: 'routeNameLabelId'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',               
                emptyText: 'Enter Route Name',
                blankText: 'Enter Route Name',
                maxLength: 50,
                id: 'routeNameId'
            },{},{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorylatitude'
            },{
                xtype: 'label',
                text: '<%=Latitude%>' +' :',
                cls: 'labelstyle',
                id: 'latitudeLabelId'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',   
                maskRe: /[0-9.]/,            
                emptyText: '<%=EnterLatitude%>',
                blankText: '<%=EnterLatitude%>',
                allowBlank: false,
                allowDecimals: false,
                id: 'latitudeId'
            },{},{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorylongitude'
            },{
                xtype: 'label',
                text: '<%=Longitude%>' +' :',
                cls: 'labelstyle',
                id: 'longitudeLabelId'
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect', 
                maskRe: /[0-9.]/,           
                emptyText: '<%=EnterLongitude%>',
                blankText: '<%=EnterLongitude%>',
                allowBlank: false,
                allowDecimals: false,
                id: 'longitudeId'
            }, {},
            {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                hidden: true,
                id: 'mandatoryradius'
            },
             {
                xtype: 'label',
                text: 'Radius' +' :',
                hidden: true,
                cls: 'labelstyle',
                id: 'radiusLabelId'
            }, {
                xtype: 'numberfield',
                cls: 'selectstylePerfect', 
                emptyText: 'Enter Radius',
                blankText: 'Enter Radius',
                value: '<%=30%>',
                maxValue: 300,
                regexText:'validate',
                hidden: true,
                allowBlank: false,
                id: 'radiusId'
            }, {
                html: '(meters)',
                hidden: true,
                id: 'mandatoryDefaultDistanceId1'           
            },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'statusEmptyId1'
        }, {
            xtype: 'label',
            text: 'Status' + ' :',
            cls: 'labelstyle',
            id: 'statusLabelId'
        },statuscombo,{}]
});

//****************************** Window For Adding Trip Information****************************
   
    var winButtonPanel2 = new Ext.Panel({
    id: 'winbuttonid2',
    standardSubmit: true,
    collapsible: false,
    height:50,
    width:390,
    cls: 'windowbuttonpanel',
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 3
    },
    items: []
    });
   
   
   var winButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    height:50,
    width:450,
    cls: 'windowbuttonpanel',
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [ {
    
     xtype: 'button',
        text: 'Set LatLong',
        id: 'setLatLongButt',
        cls: 'buttonstyle',
       // iconCls : 'cancelbutton',
        width: '90',
        listeners: {
     
            click: {
                fn: function () {
                lat = Ext.getCmp('latitudeId').getValue();
                lon = Ext.getCmp('longitudeId').getValue();
                rad = Ext.getCmp('radiusId').getValue();
           
               document.getElementById('xyz').contentWindow.setLatLng();
                }
                }
                }
    
    },{
    
      xtype: 'button',
        text: 'Set Radius',
        id: 'setRadiusId',
        cls: 'buttonstyle',
        hidden: true,
       // iconCls : 'cancelbutton',
        width: '90',
        listeners: {
      
            click: {
                fn: function () {
                lat = Ext.getCmp('latitudeId').getValue();
                lon = Ext.getCmp('longitudeId').getValue();
                rad = Ext.getCmp('radiusId').getValue();
                document.getElementById('xyz').contentWindow.setLatLng();
                }
                }
                }
    
    },{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'addButtId',
        cls: 'buttonstyle',
        iconCls : 'savebutton',
        width: 80,
        listeners: {
         
            click: {
           
                fn: function () {
                    if (Ext.getCmp('businessId').getValue().trim() == "") {
						 Ext.example.msg('<%=EnterBusinessId%>');                    
                        return;
                    }
                    if (Ext.getCmp('businessTypecomboId').getValue() == "") {
						 Ext.example.msg('<%=SelectbusinessType%>');
                        return;
                    }
					
									
					if (Ext.getCmp('cvsCustcomboId').getValue() == "") {
					Ext.example.msg('<%=pleaseSelectcustomer%>');
                        return;
                    }
                    if (Ext.getCmp('AddressId').getValue() == "") {
					Ext.example.msg('<%=EnterAddress%>');
                        return;
                    }
                    
                    if (Ext.getCmp('EmailTextId').getValue() == "") {
                    Ext.example.msg("Enter Email");
                        return;
                    }
                    var emailId = Ext.getCmp('EmailTextId').getValue();
                    	if(!isValidEmailAddress(emailId))
    					{
       						Ext.example.msg("Invalid email Id");
        					return;
    					}        
                   
                    if (Ext.getCmp('RegionId').getValue() == "") {
					Ext.example.msg('<%=EnterRegion%>');
                        return;
                    }
					 
					  if (Ext.getCmp('hubLocationId').getValue() == "") {
					  Ext.example.msg('<%=EnterHubLocation%>');
                        return;
                    }
									
					 if (Ext.getCmp('routeComboId').getValue() == "") {
					 Ext.example.msg('<%=SelectRoute%>');
                        return;
                    }
					
					 if (Ext.getCmp('latitudeId').getValue() == "") {
					 Ext.example.msg('<%=EnterLatitude%>');
                        return;
                    }
                      if (Ext.getCmp('longitudeId').getValue() == "") {
					  Ext.example.msg('<%=EnterLongitude%>');
                        return;
                    }   
                    	if (Ext.getCmp('statuscomboId').getValue() == "") {
                    	Ext.example.msg("Select Status");
                    	return;
                    }   
                    if (Ext.getCmp('radiusId').getValue() == "0") {
                    	Ext.example.msg("Radius value should not be 0.");
                    	return;
                    }  
                    if (Ext.getCmp('radiusId').getValue() > "300") {
                    	Ext.example.msg("Radius value should not be greater than 300 meters.");
                    	return;
                    }   
                    
					 var uniqueId;
                    if (buttonValue == 'modify') {
                        var selected = grid.getSelectionModel().getSelected();
						 uniqueId=selected.get('uniqueIdDataIndex');
                    }
                   var row = routeCombostore.find('routeId',Ext.getCmp('routeComboId').getValue());
                   var rec = routeCombostore.getAt(row);
                   var uniqroutid= rec.data['uniqueRouteId'];
                    myWin.getEl().mask();
                    //Performs Save Operation
                     //Ajax request starts here
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/BusinessDetails.do?param=saveormodifyBusinessDetails',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                businessId: Ext.getCmp('businessId').getValue(),
								businessType:Ext.getCmp('businessTypecomboId').getValue(),
								bank: Ext.getCmp('cvsCustcomboId').getRawValue(),   
					            address: Ext.getCmp('AddressId').getValue(),
					            email: Ext.getCmp('EmailTextId').getValue(),
                    			region: Ext.getCmp('RegionId').getValue(),
								hublocation: Ext.getCmp('hubLocationId').getValue(),
								routeId:Ext.getCmp('routeComboId').getValue(),
                    			latitude: Ext.getCmp('latitudeId').getValue(),
								longitude: Ext.getCmp('longitudeId').getValue(),
                    			customerID: Ext.getCmp('custcomboId').getValue(),
							    uniqueId:uniqueId,
							    status:Ext.getCmp('statuscomboId').getValue(),
							    
                    			routeName:Ext.getCmp('routeNameId').getValue(),
                    			radius:Ext.getCmp('radiusId').getValue(),
                    			uniqueRouteId:uniqroutid,
                    			cvscustomerId:Ext.getCmp('cvsCustcomboId').getValue()
                    			
                            },
                            success: function (response, options) {
								var message = response.responseText;
                                 Ext.example.msg(message);
                               
								Ext.getCmp('businessId').reset();
								Ext.getCmp('businessTypecomboId').reset();
                                Ext.getCmp('cvsCustcomboId').reset();
                                Ext.getCmp('AddressId').reset();
                                Ext.getCmp('EmailTextId').reset();
                    			Ext.getCmp('RegionId').reset();   
                    			Ext.getCmp('hubLocationId').reset();  
                    			Ext.getCmp('routeComboId').reset();
                    			//Ext.getCmp('routeTypeId').reset();
                    			Ext.getCmp('routeNameId').reset();   
                    			Ext.getCmp('latitudeId').reset();   
                    			Ext.getCmp('longitudeId').reset(); 
                    			Ext.getCmp('statuscomboId').reset();
                    			Ext.getCmp('radiusId').reset();
                    			document.getElementById('xyz').contentWindow.clear();
                    			myWin.hide();
                    			myWin.getEl().unmask();  
                    			store.reload({
				                    params: {
				                        CustId: Ext.getCmp('custcomboId').getValue()    
				                  }
				               });
                              	custId=Ext.getCmp('custcomboId').getValue();								  	   
                                businessTypeStore.reload();
				                routeCombostore.reload();
                            },
                            failure: function () {
								Ext.example.msg("Error");
								document.getElementById('xyz').contentWindow.clear();
                                 myWin.hide();
                            }
                        });
                }
            }
        }
    }, {
        xtype: 'button',
        text: '<%=Cancel%>',
        id: 'canButtId',
        cls: 'buttonstyle',
        iconCls : 'cancelbutton',
        width: '80',
        listeners: {
      
            click: {
                fn: function () {
				                Ext.getCmp('businessId').reset();
								Ext.getCmp('businessTypecomboId').reset();
                                Ext.getCmp('cvsCustcomboId').reset();
                                Ext.getCmp('AddressId').reset();
                                Ext.getCmp('EmailTextId').reset();
                    			Ext.getCmp('RegionId').reset();   
                    			Ext.getCmp('hubLocationId').reset();  
                    			Ext.getCmp('routeComboId').reset();
                    			//Ext.getCmp('routeTypeId').reset();
                    			Ext.getCmp('routeNameId').reset();    
                    			Ext.getCmp('latitudeId').reset();   
                    			Ext.getCmp('longitudeId').reset(); 
                    			Ext.getCmp('statuscomboId').reset(); 
                    			Ext.getCmp('radiusId').reset(); 
                    		    document.getElementById('xyz').contentWindow.clear();
                    myWin.hide();
                }
            }
        }
    }]
});

   //****************************** Window For Adding Trip Information Ends Here************************
 		var outerPanelWindow = new Ext.Panel({
   		standardSubmit: true,
    	frame: true,
    	id:'sam1',
        height: 530,
        width: screen.width - 65,
         layout: 'table',
    layoutConfig: {
        columns: 2
    },  
    	items: [innerPanel,innerPanel2, winButtonPanel2,winButtonPanel]
		});
  
   //************************* Outer Pannel *******************************************//
var	 myWin = new Ext.Window({
	   
	    closable: false,
	    modal: true,
	    id:'sam2',
	    resizable: false,
	    autoScroll: false,
	    height: 530,
	    width:  screen.width - 65,
	    id: 'myWin',
	    items: [outerPanelWindow]
	    	
	});
   //**************************Outer Pannel Ends Here *********************************//
    //**************************Function For Adding Business Details*******************
   
      function addRecord() {
                   cvsCustomercombostore.load({
                 params: {
                        CustId: Ext.getCmp('custcomboId').getValue()
                        }
                   });
        routeCombostore.load({
                   params: {
                        CustId: Ext.getCmp('custcomboId').getValue()
                        }
                   });
	//alert('Insdie Add');

    	if (Ext.getCmp('custcomboId').getValue() == "") {
    	 Ext.example.msg('<%=pleaseSelectcustomer%>');
        return;
    }
    	buttonValue = "add";
    	title = '<%=AddBusinessDetails%>';
    	
								//myWin.setTitle(title);
								  myWin.show();
							
							    Ext.getCmp('businessId').enable();
								Ext.getCmp('RegionId').disable();
								 Ext.getCmp('AddressId').disable();
								 Ext.getCmp('EmailTextId').enable();
								//Ext.getCmp('locationId').enable();
								Ext.getCmp('hubLocationId').enable();
								Ext.getCmp('routeComboId').enable();
								//Ext.getCmp('routeTypeId').disable();
							    Ext.getCmp('routeNameId').disable();
								Ext.getCmp('businessId').reset();
								Ext.getCmp('businessTypecomboId').reset();
                               // Ext.getCmp('MspId').reset();
                                Ext.getCmp('cvsCustcomboId').reset();
                                Ext.getCmp('AddressId').reset();
                                Ext.getCmp('EmailTextId').reset();
                    			Ext.getCmp('RegionId').reset();   
                    			//Ext.getCmp('locationId').reset();  
                    			Ext.getCmp('hubLocationId').reset();  
                    			Ext.getCmp('routeComboId').reset();  
                    			//Ext.getCmp('routeTypeId').reset();
                    			Ext.getCmp('routeNameId').reset();  
                    			Ext.getCmp('latitudeId').reset();   
                    			Ext.getCmp('longitudeId').reset(); 
                    			Ext.getCmp('statuscomboId').reset();   
                    		    
                    		    lat = <%=lat%>;
								lon = <%=lon%>;
								rad = <%=rad%>;						
						        //document.getElementById('xyz').contentWindow.createCircle2(lat,lon,rad);
	}
	
	
   //*********************** Function to Modify Data ***********************************
    
    function modifyData() {
    routeCombostore.load({
    	params: {
        	CustId: Ext.getCmp('custcomboId').getValue()
        }
    });
    if (Ext.getCmp('custcomboId').getValue() == "") {
    						Ext.example.msg('<%=pleaseSelectcustomer%>');
           					return;
       						}
    if(grid.getSelectionModel().getCount()>1){
   							 Ext.example.msg('<%=SelectSingleRow%>');
           					return;
       						}
 
    if (grid.getSelectionModel().getSelected() == null) {
    						Ext.example.msg('<%=noRecordsFound%>');
           					return;
       						}
      
        buttonValue = "modify";
       // disableTabElements();
        titel = '<%=ModifyBusinessDetails%>'
        myWin.setTitle(titel);
        
        
        var selected = grid.getSelectionModel().getSelected();
		//Ext.getCmp('routeTypeId').disable();
	    Ext.getCmp('RegionId').disable();
	    Ext.getCmp('AddressId').disable();
	    Ext.getCmp('EmailTextId').enable();
	    Ext.getCmp('routeNameId').disable();
        Ext.getCmp('businessId').setValue(selected.get('businessIdIndex'));
        Ext.getCmp('businessTypecomboId').setValue(selected.get('businessTypeIndex'));
       // Ext.getCmp('MspId').setValue(selected.get('mspIndex'));
        Ext.getCmp('cvsCustcomboId').setValue(selected.get('bankIndex')); 
        Ext.getCmp('AddressId').setValue(selected.get('addressIndex'));  
        Ext.getCmp('EmailTextId').setValue(selected.get('EmailDataIndex'));   
        Ext.getCmp('RegionId').setValue(selected.get('regionIndex'));
       // Ext.getCmp('locationId').setValue(selected.get('locationIndex'));
        Ext.getCmp('hubLocationId').setValue(selected.get('hubLocationIndex'));
	    Ext.getCmp('routeComboId').setValue(selected.get('routeIdIndex'));
	    //Ext.getCmp('routeTypeId').setValue(selected.get('routeTypeIndex'));
	    Ext.getCmp('routeNameId').setValue(selected.get('routeNameIndex'));
        Ext.getCmp('latitudeId').setValue(selected.get('latitudeIndex'));
        Ext.getCmp('longitudeId').setValue(selected.get('longitudeIndex'));
        Ext.getCmp('statuscomboId').setValue(selected.get('statusIndex'));
        Ext.getCmp('radiusId').setValue(selected.get('radiusIndex'));
        myWin.show();
        
                lat = Ext.getCmp('latitudeId').getValue();
                lon = Ext.getCmp('longitudeId').getValue();
                rad = Ext.getCmp('radiusId').getValue();
                document.getElementById('xyz').contentWindow.setLatLng();
    }
   
   //*********************** Function to Modify Data Ends Here **************************	
    
   // ***********************    Main Starts From Here *********************************//		
   	
   	Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';

    outerPanel = new Ext.Panel({
        //title: 'Business Details',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        //cls: 'outerpanel',
        height:510,
        width:screen.width-22,
        items: [customerPanel,grid],
        bbar: ctsb
    });
     
});

	// ***********************    Main Ends Here *********************************//	
   			</script>
	<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>
