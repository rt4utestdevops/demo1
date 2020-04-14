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
	session.setAttribute("loginInfoDetails",loginInfo);
	
}
	
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}
		
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("SLNO");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Excel");
tobeConverted.add("Id");
tobeConverted.add("Modify_Details");
tobeConverted.add("Customer_Name");
tobeConverted.add("Are_you_sure_you_want_to_delete");
tobeConverted.add("Delete");
tobeConverted.add("Not_Deleted");
tobeConverted.add("Employee_Details");
tobeConverted.add("Employee_Name");
tobeConverted.add("Employee_Id");
tobeConverted.add("Mobile_No");
tobeConverted.add("Rfid_Key");
tobeConverted.add("Add_Details");
tobeConverted.add("Latitude");
tobeConverted.add("Longitude");
tobeConverted.add("Email_ID");
tobeConverted.add("Gender");
tobeConverted.add("Route_Name");
tobeConverted.add("Enter_Employee_Name");
tobeConverted.add("Enter_Employee_Id");
tobeConverted.add("Enter_Mobile_No");
tobeConverted.add("Enter_Rfid_Key");
tobeConverted.add("Enter_Latitude");
tobeConverted.add("Validate_Mesg_For_Form");
tobeConverted.add("Enter_Longitude");
tobeConverted.add("Error");
tobeConverted.add("Enter_Email_Id");
tobeConverted.add("Select_Gender");
tobeConverted.add("Select_Route_Name");
tobeConverted.add("Route_Id");
tobeConverted.add("PDF");
tobeConverted.add("Gender_Id");
tobeConverted.add("Employee_Information");

tobeConverted.add("PickUp_Route_Name");
tobeConverted.add("Drop_Route_Name");
tobeConverted.add("Select_PickUp_Route_Name");
tobeConverted.add("Select_Drop_Route_Name");
tobeConverted.add("Route_Id_For_Drop");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String SelectCustomerName=convertedWords.get(0);
String Add=convertedWords.get(1);
String Modify=convertedWords.get(2);
String NoRowSelected=convertedWords.get(3);
String SelectSingleRow=convertedWords.get(4);
String ClearFilterData=convertedWords.get(5);
String Save=convertedWords.get(6);
String Cancel=convertedWords.get(7);
String SlNo=convertedWords.get(8);
String NoRecordFound=convertedWords.get(9);
String Excel=convertedWords.get(10);
String Id=convertedWords.get(11);
String ModifyDetails=convertedWords.get(12);
String CustomerName=convertedWords.get(13);
String AreYouSureWantToDelete=convertedWords.get(14);
String Delete=convertedWords.get(15);
String NotDeleted=convertedWords.get(16);
String EmployeeDetails=convertedWords.get(17);
String EmployeeName=convertedWords.get(18);
String EmployeeId=convertedWords.get(19);
String MobileNo=convertedWords.get(20);
String RfidKey=convertedWords.get(21);
String AddDetails=convertedWords.get(22);
String Latitude=convertedWords.get(23);
String Longitude=convertedWords.get(24);
String EmailID=convertedWords.get(25);
String Gender=convertedWords.get(26);
String RouteName=convertedWords.get(27);
String EnterEmployeeName=convertedWords.get(28);
String EnterEmployeeId=convertedWords.get(29);
String EnterMobileNo=convertedWords.get(30);
String EnterRfidKey=convertedWords.get(31);
String EnterLatitude=convertedWords.get(32);
String ValidateMesgForForm=convertedWords.get(33);
String EnterLongitude=convertedWords.get(34);
String Error=convertedWords.get(35);
String EnterEmailId=convertedWords.get(36);
String SelectGender=convertedWords.get(37);
String SelectRouteName=convertedWords.get(38);
String RouteId=convertedWords.get(39);
String PDF=convertedWords.get(40);
String GenderId=convertedWords.get(41);
String EmployeeInformation=convertedWords.get(42);

String PickUpRouteName=convertedWords.get(43);
String DropRouteName=convertedWords.get(44);
String SelectPickUpRouteName=convertedWords.get(45);
String SelectDropRouteName=convertedWords.get(46);
String RouteIdForDrop=convertedWords.get(47);
%>
<jsp:include page="../Common/header.jsp" />

 		<title><%=EmployeeInformation%></title>		
    
	 <style>
	  .x-panel-tl
		{
			border-bottom: 0px solid !important;
		}
   </style>

   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
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
			padding-top : 6px !important;
			height : 38px !important;
		}
		fieldset#EmployeeInformationId {
			width : 339px !important;
		}
		.x-layer ul {
			min-height: 27px !important;
		}
   </style>
   <script>
   var outerPanel;
var ctsb;
var jspName = "<%=EmployeeInformation%>";
var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var clientcombostore = new Ext.data.JsonStore({
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
                custId = Ext.getCmp('custcomboId').getValue();

            }
            store.load({
                     params: {
                         CustId: Ext.getCmp('custcomboId').getValue(),
                         jspName:jspName,
                         custname:Ext.getCmp('custcomboId').getRawValue()
                     }
                 });
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
            fn: function () {
                custId = Ext.getCmp('custcomboId').getValue();
                store.load({
                    params: {
                        CustId: custId,
                        jspName:jspName,
                        custname:Ext.getCmp('custcomboId').getRawValue()
                    }
                });
            }
        }
    }
});

    var genderStore = new Ext.data.SimpleStore({
            id: 'genderId',
            fields: ['id','Name'],
            autoLoad: true,
            data:[[ ['M'],['Male']],
           [['F'], [ 'Female']]]
        });
        
var gender = new Ext.form.ComboBox({
	  frame:true,
	 store:genderStore,
	 id:'genId',
	 width: 150,
	 cls: 'selectstylePerfect',
	 hidden:false,
	 anyMatch:true,
	 onTypeAhead:true,
	 forceSelection:true,
	 enableKeyEvents:true,
	 mode: 'local',
	 emptyText:'<%=SelectGender%>',
	 triggerAction: 'all',
	 displayField: 'Name',
	 valueField: 'id',
	 listeners: {
		                   select: {
		                 	   fn:function(){
		                 	   genderValue = Ext.getCmp('genId').getValue();
		                 	   }
		                 	  }
		                    }	    
                        });
                        
var regStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/EmployeeInformationAction.do?param=getRouteNames',
			       root: 'routeName',
			       autoLoad: false,
				   fields: ['Route_Id','Route_Name']
				   
			     });
			     
var dropStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/EmployeeInformationAction.do?param=getDropRouteNames',
			       root: 'droprouteName',
			       autoLoad: false,
				   fields: ['Route_Id','Route_Name']
				   
			     });
			     
			    
var pickUpRouteName = new Ext.form.ComboBox({
	  frame:true,
	 store:regStore,
	 id:'RouteNameId',
	 width: 150,
	 cls: 'selectstylePerfect',
	 hidden:false,
	 anyMatch:true,
	 onTypeAhead:true,
	 forceSelection:true,
	 enableKeyEvents:true,
	 mode: 'local',
	 emptyText:'<%=SelectRouteName%>',
	 triggerAction: 'all',
	 displayField: 'Route_Name',
	 valueField: 'Route_Id',
	 listeners: {
	           select: {
		     fn:function(){
		                 	   routeValue = Ext.getCmp('RouteNameId').getValue();
		                 	   }
		                 	  }
		                    }	    
                        });
                               
 var dropRouteName = new Ext.form.ComboBox({
	  frame:true,
	 store:dropStore,
	 id:'dropRouteNameId',
	 width: 150,
	 cls: 'selectstylePerfect',
	 hidden:false,
	 anyMatch:true,
	 onTypeAhead:true,
	 forceSelection:true,
	 enableKeyEvents:true,
	 mode: 'local',
	 emptyText:'<%=SelectRouteName%>',
	 triggerAction: 'all',
	 displayField: 'Route_Name',
	 valueField: 'Route_Id',
	 listeners: {
		                   select: {
		                 	   fn:function(){
		                 	   routeValueforDrop= Ext.getCmp('dropRouteNameId').getValue();
		                 	   }
		                 	  }
		                    }	    
                        });
                               
                               
                               
var customerComboPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'customerComboPanelId',
    layout: 'table',
    frame: false,
    width: screen.width - 12,
    height: 50,
    layout: 'table',
    layoutConfig: {
        columns: 3
    },
    items: [{
            xtype: 'label',
            text: '<%=CustomerName%>' + ' :',
            cls: 'labelstyle'
        },{width:10},
        Client
        
    ]
});
var reader = new Ext.data.JsonReader({
    idProperty: 'employeeId',
    root: 'employeeDetails',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'employeeNameIndex'
    }, {
        name: 'employeeIdIndex'
    }, {
        name: 'mobileNoIndex'
    },{
        name: 'rfidKeyIndex'
    },{
        name: 'lattitudeIndex'
    },{
        name: 'longitudeIndex'
    }, {
        name: 'emailIndex'
    },{
        name: 'genderIndex'
    },{
        name: 'idIndex'
    },{
        name: 'pickUpRouteNameIndex'
    },{
        name: 'dropRouteNameIndex'
    },{
        name: 'routeIdIndex'
    },{
        name: 'genderIdIndex'
    },{
        name: 'routeIdIndexForDrop'
    }
     ]
});
var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'employeeNameIndex'
    }, {
        type: 'string',
        dataIndex: 'employeeIdIndex'
    }, {
        type: 'string',
        dataIndex: 'mobileNoIndex'
    },{
        type: 'string',
        dataIndex: 'rfidKeyIndex'
    },{
        type: 'string',
        dataIndex: 'lattitudeIndex'
    },{
        type: 'string',
        dataIndex: 'longitudeIndex'
    }, {
        type: 'string',
        dataIndex: 'emailIndex'
    }, {
        type: 'string',
        dataIndex: 'genderIndex'
    },{
        type: 'numeric',
        dataIndex: 'idIndex'
    },{
        type: 'string',
        dataIndex: 'pickUpRouteNameIndex'
    },{
        type: 'string',
        dataIndex: 'dropRouteNameIndex'
    },{
        type: 'numeric',
        dataIndex: 'routeIdIndex'
    },{
        type: 'numeric',
        dataIndex: 'routeIdIndexForDrop'
    },{
        type: 'string',
        dataIndex: 'genderIdIndex'
    }]
});
var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/EmployeeInformationAction.do?param=getEmployeeDetails',
        method: 'POST'
    }),
    storeId: 'empId',
    reader: reader
});

var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SlNo%></span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=SlNo%></span>",
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=EmployeeName%></span>",
            dataIndex: 'employeeNameIndex',
            width: 30,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=EmployeeId%></span>",
            dataIndex: 'employeeIdIndex',
            width: 30,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=MobileNo%></span>",
            dataIndex: 'mobileNoIndex',
            width: 30,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=RfidKey%></span>",
            dataIndex: 'rfidKeyIndex',
            width: 30,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Latitude%></span>",
            dataIndex: 'lattitudeIndex',
            width: 30,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Longitude%></span>",
            dataIndex: 'longitudeIndex',
            width: 30,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=EmailID%></span>",
            dataIndex: 'emailIndex',
            width: 40,
            filter: {
                type: 'string'
            }
            },
            {
            header: "<span style=font-weight:bold;><%=Gender%></span>",
            dataIndex: 'genderIndex',
            width: 30,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Id%></span>",
            dataIndex: 'idIndex',
            hidden: true,
            width: 30,
            filter: {
                type: 'int'
            }
        },{
            header: "<span style=font-weight:bold;><%=PickUpRouteName%></span>",
            dataIndex: 'pickUpRouteNameIndex',
            width: 30,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=DropRouteName%></span>",
            dataIndex: 'dropRouteNameIndex',
            width: 30,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=RouteId%></span>",
            dataIndex: 'routeIdIndex',
            hidden: true,
            width: 30,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;><%=RouteIdForDrop%></span>",
            dataIndex: 'routeIdIndexForDrop',
            hidden: true,
            width: 30,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;><%=GenderId%></span>",
            dataIndex: 'genderIdIndex',
            hidden: true,
            width: 30,
            filter: {
                type: 'string'
            }
        }];
    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: true
        }
    });
};
var innerPanelForEmployeeDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 345,
    width: 450,
    frame: true,
    id: 'innerPanelForEmployeeDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=EmployeeDetails%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        id: 'EmployeeInformationId',
        width: 350,
        height:320,
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [ 
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'Id2'
        },
        {
            xtype: 'label',
            text: '<%=EmployeeName%>' + ' :',
            cls: 'labelstyle',
            id: 'Id1'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterEmployeeName%>',
            emptyText: '<%=EnterEmployeeName%>',
            labelSeparator: '',
            allowBlank: false,
            id: 'employeeNameId'
        },
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'Id4'
        },
        {
            xtype: 'label',
            text: '<%=EmployeeId%>' + ' :',
            cls: 'labelstyle',
            id: 'empIdLabelId'
        },{
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            blankText: '<%=EnterEmployeeId%>',
            emptyText: '<%=EnterEmployeeId%>',
            allowBlank: false,
            labelSeparator: '',
            allowBlank: false,
            id: 'empIDId'
        },
        {
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'Id6'
        },{
            xtype: 'label',
            text: '<%=MobileNo%>' + ' :',
            cls: 'labelstyle',
            id: 'mobileNoLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            blankText: '<%=EnterMobileNo%>',
            emptyText: '<%=EnterMobileNo%>',
            allowBlank: true,
            labelSeparator: '',
            id: 'mobileNoId'
        }, 
        {
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'Id8'
        },{
            xtype: 'label',
            text: '<%=RfidKey%>'+':',
            cls: 'labelstyle',
            id: 'rfidKeyLabelId'
        }, {
            xtype: 'textfield',
            cls:'selectstylePerfect',
	    	blankText:'<%=EnterRfidKey%>',
	    	regex:validate('alphanumericname'),
	    	emptyText:'<%=EnterRfidKey%>',
            id: 'rfidKey',
            listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase().trim());
					}
					}
        }, {
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'Id10'
        }, {
            xtype: 'label',
            text: '<%=Latitude%>' + ' :',
            cls: 'labelstyle',
            id: 'latitudeLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: true,
            blankText: '<%=EnterLatitude%>',
            emptyText: '<%=EnterLatitude%>',
            labelSeparator: '',
            decimalPrecision : 20,
            id: 'latitudeId'
        },
        {
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'Id12'
        },{
            xtype: 'label',
            text: '<%=Longitude%>' + ' :',
            cls: 'labelstyle',
            id: 'longitudeLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: true,
            blankText: '<%=EnterLongitude%>',
            emptyText: '<%=EnterLongitude%>',
            labelSeparator: '',
           decimalPrecision : 20,
            id: 'longitudeId'
        },{
            xtype: 'label',
            text: ' ',
            cls: 'mandatoryfield',
            id: 'Id14'
        },{
            xtype: 'label',
            text: '<%=EmailID%>' + ' :',
            cls: 'labelstyle',
            id: 'emailLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: true,
            blankText: '<%=EnterEmailId%>',
            emptyText: '<%=EnterEmailId%>',
            vtype:'email',
            labelSeparator: '',
            maxLength : 30,
            id: 'emailIDId'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'Id15'
        },{
            xtype: 'label',
            text: '<%=Gender%>' + ' :',
            cls: 'labelstyle',
            id: 'genderLabelId'
        }, gender,{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'Id17'
        },{
            xtype: 'label',
            text: '<%=PickUpRouteName%>' + ' :',
            cls: 'labelstyle',
            id: 'routeNameLabelId'
        }, pickUpRouteName,
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'dropEmptyRouteNameId'
        },
        {
            xtype: 'label',
            text: '<%=DropRouteName%>' + ' :',
            cls: 'labelstyle',
            id: 'dropRouteNameLabelId'
        }, dropRouteName
        ]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 10,
    width: 350,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        iconCls:'savebutton',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                    if (Ext.getCmp('employeeNameId').getValue() == "") {
                        Ext.example.msg("<%=EnterEmployeeName%>");
                        Ext.getCmp('employeeNameId').focus();
                        return;
                    }
                    if (Ext.getCmp('empIDId').getValue() == "") {
                       Ext.example.msg("<%=EnterEmployeeId%>");
                        Ext.getCmp('empIDId').focus();
                        return;
                    }
                    if (Ext.getCmp('genId').getValue() == "") {
                        Ext.example.msg("<%=SelectGender%>");
                        Ext.getCmp('genId').focus();
                        return;
                    }
                    if (Ext.getCmp('RouteNameId').getValue() == "") {
                        Ext.example.msg("<%=SelectPickUpRouteName%>");
                        Ext.getCmp('RouteNameId').focus();
                        return;
                    }
                    
                     if (Ext.getCmp('dropRouteNameId').getValue() == "") {
                        Ext.example.msg("<%=SelectDropRouteName%>");
                        Ext.getCmp('dropRouteNameId').focus();
                        return;
                    }
                    
                   if (innerPanelForEmployeeDetails.getForm().isValid()) {
                        var seletedEmployeeName;
                        var selectedEmployeeID;
                        var selectedMobileNo;
                        var selectedRFIDKey;
                        var selectedLatitude;
                        var selectedLongitude;
                        var selectedEmailID;
                        var selectedGender;
                        var selectedRouteName;
                        var id;
                        
                        if (buttonValue == '<%=Modify%>') {
                            var selected = grid.getSelectionModel().getSelected();
                            id = selected.get('idIndex');
                            seletedEmployeeName=selected.get('employeeNameIndex');
                            selectedEmployeeID=selected.get('employeeIdIndex');
                            selectedMobileNo=selected.get('mobileNoIndex');
                            selectedRFIDKey=selected.get('rfidKeyIndex');
                            selectedLatitude=selected.get('lattitudeIndex');
                            selectedLongitude=selected.get('longitudeIndex');
                            selectedEmailID=selected.get('emailIndex');
                            selectedGender=selected.get('genderIndex');
                            selectedRouteName=selected.get('routeNameIndex');
                        }
                        manageEmployeeOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/EmployeeInformationAction.do?param=employeeRouteAddAndModify',
                            method: 'POST',
                            params: {
                                CustId:custId,
                                buttonValue: buttonValue,
                                employeeName: Ext.getCmp('employeeNameId').getValue(),
                                employeeId: Ext.getCmp('empIDId').getValue(),
                                mobileNo: Ext.getCmp('mobileNoId').getValue(),
                                rfidKey: Ext.getCmp('rfidKey').getValue(),
                                latitude: Ext.getCmp('latitudeId').getValue(),
                                longitude: Ext.getCmp('longitudeId').getValue(),
                                emailId: Ext.getCmp('emailIDId').getValue(),
                                gender: Ext.getCmp('genId').getValue(),
                                id: id,
                                routeId: Ext.getCmp('RouteNameId').getValue(),
                                gridRouteId:routeValue,
                                gridGender:genderValue,
                                gridRouteIdForDrop:routeValueforDrop,
                                dropRouteName:Ext.getCmp('dropRouteNameId').getValue()
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                Ext.getCmp('employeeNameId').reset();
                                Ext.getCmp('empIDId').reset();
                                Ext.getCmp('mobileNoId').reset();
                                Ext.getCmp('rfidKey').reset();
                                Ext.getCmp('latitudeId').reset();
                                Ext.getCmp('longitudeId').reset();
                                Ext.getCmp('emailIDId').reset();
                                Ext.getCmp('genId').reset();
                                Ext.getCmp('RouteNameId').reset();
                                Ext.getCmp('dropRouteNameId').reset();
                                myWin.hide();
                                manageEmployeeOuterPanelWindow.getEl().unmask();
                                store.load({
                                params: {
                                    CustId: Ext.getCmp('custcomboId').getValue(),
                                    jspName:jspName,
                                    custname:Ext.getCmp('custcomboId').getRawValue()
                                }
                            });
                            },
                            failure: function () {
                                Ext.example.msg("<%=Error%>");
                                store.reload();
                                myWin.hide();
                            }
                        });
                    }else{
                    Ext.example.msg("<%=ValidateMesgForForm%>");
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
                fn: function () {
                    myWin.hide();
                }
            }
        }
    }]
});

var manageEmployeeOuterPanelWindow = new Ext.Panel({
    width: 370,
    height: 400,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForEmployeeDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    frame:true,
    height: 450,
    width: 390,
    id: 'myWin',
    items: [manageEmployeeOuterPanelWindow]
});
function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomerName%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    regStore.load({
                      params:{
			          clientId:Ext.getCmp('custcomboId').getValue()
			                   }
				             });
				             
	    dropStore.load({
                      params:{
			          clientId:Ext.getCmp('custcomboId').getValue()
			                   }
				             });
				             
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=AddDetails%>';
    myWin.setPosition(400, 50);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('employeeNameId').reset();
    Ext.getCmp('empIDId').reset();
    Ext.getCmp('mobileNoId').reset();
    Ext.getCmp('rfidKey').reset();
    Ext.getCmp('latitudeId').reset();
    Ext.getCmp('longitudeId').reset();
    Ext.getCmp('emailIDId').reset();
    Ext.getCmp('genId').reset();
    Ext.getCmp('RouteNameId').reset();
    Ext.getCmp('dropRouteNameId').reset()
}

function modifyData() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomerName%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    if (grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("<%=NoRowSelected%>");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
    var routeid;
    regStore.load({
                      params:{
			          clientId:Ext.getCmp('custcomboId').getValue()
			                   }});
			                   
	dropStore.load({
                      params:{
			          clientId:Ext.getCmp('custcomboId').getValue()
			                   }
				             });
			                   
    buttonValue = '<%=Modify%>';
    titelForInnerPanel = '<%=ModifyDetails%>';
    myWin.setPosition(400, 50);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    var selected = grid.getSelectionModel().getSelected();   
    Ext.getCmp('RouteNameId').setValue(selected.get('pickUpRouteNameIndex'));
    Ext.getCmp('dropRouteNameId').setValue(selected.get('dropRouteNameIndex'));
    Ext.getCmp('employeeNameId').setValue(selected.get('employeeNameIndex'));
    Ext.getCmp('empIDId').setValue(selected.get('employeeIdIndex'));
    Ext.getCmp('mobileNoId').setValue(selected.get('mobileNoIndex'));
    Ext.getCmp('rfidKey').setValue(selected.get('rfidKeyIndex'));
    Ext.getCmp('latitudeId').setValue(selected.get('lattitudeIndex'));
    Ext.getCmp('longitudeId').setValue(selected.get('longitudeIndex'));
    Ext.getCmp('emailIDId').setValue(selected.get('emailIndex'));
    Ext.getCmp('genId').setValue(selected.get('genderIndex'));
    routeValue = selected.get('routeIdIndex');
    genderValue=selected.get('genderIdIndex');
    routeValueforDrop=selected.get('routeIdIndexForDrop');
}

function deleteData() {

 if (Ext.getCmp('custcomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectCustomerName%>");
                        Ext.getCmp('custcomboId').focus();
                        return;
                    }
                    
    if (grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("<%=NoRowSelected%>");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
    Ext.Msg.show({
        title: '<%=Delete%>',
        msg: '<%=AreYouSureWantToDelete%>',
        buttons: {
            yes: true,
            no: true
        },
        fn: function (btn) {
            switch (btn) {
            case 'yes':
                var selected = grid.getSelectionModel().getSelected();
                id = selected.get('idIndex');
                outerPanel.getEl().mask();
                Ext.Ajax.request({
                    url: '<%=request.getContextPath()%>/EmployeeInformationAction.do?param=deleteData',
                    method: 'POST',
                    params: {
                        CustId: Ext.getCmp('custcomboId').getValue(),
                        id: id
                        },
                    success: function (response, options) {
                        var message = response.responseText;
                        Ext.example.msg(message);
                        outerPanel.getEl().unmask();
                        store.load({
                            params: {
                                CustId: custId
                            }
                        });
                    },
                    failure: function () {
                        Ext.example.msg("<%=Error%>");
                        store.reload();
                    }
                });
                break;
            case 'no':
                Ext.example.msg("<%=NotDeleted%>");
                store.reload();
                break;
            }
        }
    });
}
//*****************************************************************Grid *******************************************************************************
grid = getGrid(
		'<%=EmployeeInformation%>', 
		'<%=NoRecordFound%>',
		store, 
		screen.width - 40, 
		400, 
		16, 
		filters, 
		'<%=ClearFilterData%>', 
		false, 
		'', 
		9, 
		false, 
		'', 
		false, 
		'', 
		true, 
		'<%=Excel%>',
		jspName, 
		exportDataType, 
		false, 
		'<%=PDF%>', 
		true, 
		'<%=Add%>',
		true, 
		'<%=Modify%>', 
		true, 
		'<%=Delete%>'
		);
//******************************************************************************************************************************************************
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=EmployeeInformation%>',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width-22,
        height:520,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerComboPanel,grid]
    });
    sb = Ext.getCmp('form-statusbar');
});
 </script>
	<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
