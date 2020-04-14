<%@ page language="java"
	import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
	String responseafterview="''";
	String feature="1";
	if(session.getAttribute("responseafterview")!=null){
	   responseafterview="'"+session.getAttribute("responseafterview").toString()+"'";
		session.setAttribute("responseafterview",null);
	}
		
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
    
 if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
  
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	
	


ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("SLNO");
tobeConverted.add("Registration_No");
tobeConverted.add("Group_Name");
tobeConverted.add("Vehicle_Model");
tobeConverted.add("Event_Date_Time");
tobeConverted.add("Event_Voltage");
tobeConverted.add("Location");
tobeConverted.add("Action_Taken");
tobeConverted.add("Remarks");
tobeConverted.add("Updated_By");
tobeConverted.add("Updated_Date_Time");
tobeConverted.add("Select_Customer");
tobeConverted.add("Customer_Name");
tobeConverted.add("Start_Date");
tobeConverted.add("Select_Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("Select_End_Date");
tobeConverted.add("Please_Select_customer");
tobeConverted.add("Please_Select_Start_Date");
tobeConverted.add("Please_Select_End_Date");
tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
tobeConverted.add("Month_Validation");
tobeConverted.add("Excel");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("No_Records_Found");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SLNO=convertedWords.get(0);
String RegistrationNo=convertedWords.get(1);
String GroupName=convertedWords.get(2);
String VehicleModel=convertedWords.get(3);
String EventDateTime=convertedWords.get(4);
String EventVoltage=convertedWords.get(5);
String Location=convertedWords.get(6);
String ActionTaken=convertedWords.get(7);
String Remarks=convertedWords.get(8);
String UpdatedBy=convertedWords.get(9);
String UpdatedDateTime=convertedWords.get(10);
String SelectCustomer=convertedWords.get(11);
String CustomerName=convertedWords.get(12);
String StartDate=convertedWords.get(13);
String SelectStartDate=convertedWords.get(14);
String EndDate=convertedWords.get(15);
String SelectEndDate=convertedWords.get(16);
String PleaseSelectCustomer=convertedWords.get(17);
String PleaseSelectStartDate=convertedWords.get(18);
String PleaseSelectEndDate=convertedWords.get(19);
String EndDateMustBeGreaterthanStartDate=convertedWords.get(20);
String MonthValidation=convertedWords.get(21);
String Excel=convertedWords.get(22);
String ClearFilterData=convertedWords.get(23);
String NoRecordsFound=convertedWords.get(24);

%>
<jsp:include page="../Common/header.jsp" />
    <base href="<%=basePath%>">
    
    <title>Device/Wire Connection Report.jsp</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

 
	
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
		<jsp:include page="../Common/ExportJS.jsp" />
<style>
.x-panel-tl {
	border-bottom: 0px solid !important;
} 
.ext-strict .x-form-text {
    height: 21px !important;
}
label {
	display : inline !important;
}
.x-layer ul {
	min-height: 27px !important;
}
.x-window-tl *.x-window-header {
	padding-top : 6px !important;
}
.footer {
	bottom : -8px !important;
}
</style>
		
		<script>
   var outerPanel;
    var dtprev = dateprev;
  var dtcur = datecur;
  var dtnxt = datenext;
  var jspName = "DeviceWireConnectionReport";
  var exportDataType = "int,string,string,string,string,string,string,string,string,string,string";
  var endDate = "";
  var grid;
  
   var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
        type: 'int',
            dataIndex: 'slnoDataIndex'
        }, {
            type: 'string',
            dataIndex: 'RegistrationDataIndex'
        }, {
            type: 'string',
            dataIndex: 'GroupnameDataIndex'
     
        }, {
            type: 'string',
            dataIndex: 'VehiclemodelDataIndex'
        }, {
            type: 'Date',
            dataIndex: 'Eventdate&timeDataIndex'
        }, {
            type: 'string',
            dataIndex: 'EventvoltageDataIndex'
        }, {
            type: 'string',
            dataIndex: 'LocationDataIndex'
        }, {
            type: 'string',
            dataIndex: 'ActiontakenDataIndex'
        },{
            type: 'string',
            dataIndex: 'RemarksDataIndex'
        },{
            type: 'string',
            dataIndex: 'UsernameDataIndex'
        },
        {
            type: 'Date',
            dataIndex: 'UpdatedtimeDataIndex'
         }
        ]
    });
  
   var reader = new Ext.data.JsonReader({
         idProperty: 'vehicledetailid',
        root: 'VehicleTypeRoot',
        totalProperty: 'total',
        fields: [{
        name: 'slnoDataIndex'
        }, {
            name: 'RegistrationDataIndex'
        
        }, {
            name: 'GroupnameDataIndex'
        }, 
        {
            name: 'VehiclemodelDataIndex'
        },{
            name: 'Eventdate&timeDataIndex'
        }, {
            name: 'EventvoltageDataIndex'
        }, {
            name: 'LocationDataIndex'
        },{
           name: 'ActiontakenDataIndex'
        },{
           name: 'RemarksDataIndex'
        },{
           name: 'UsernameDataIndex'
        },{
           name: 'UpdatedtimeDataIndex'
         }
        ]
    });
  
   var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/CarRentalAction.do?param=getDeviceWireConnectionReport',
            method: 'POST'
        }),
        remoteSort: false,
        sortInfo: {
            field: 'RegistrationDataIndex',
            direction: 'ASC'
        },
        storeId: 'vehicletypedetailid',
        reader: reader
        });
        store.on('beforeload', function (store, operation, eOpts) {
                operation.params = {
                     CustId: Ext.getCmp('custcomboId').getValue(),
                     custName: Ext.getCmp('custcomboId').getRawValue(),
                     startDate: Ext.getCmp('startdate').getValue(),
                     endDate: Ext.getCmp('enddate').getValue(),
                     jspName: jspName
                    
                };
            }, this);
  
  
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
                  custId = Ext.getCmp('custcomboId').getValue();
                  custName = Ext.getCmp('custcomboId').getRawValue();
                   parent.globalCustomerID=Ext.getCmp('custcomboId').getValue();                    
<!--                      servicenamestore.load({-->
<!--                         params: {-->
<!--                           customerID: Ext.getCmp('custcomboId').getValue()-->
<!--                        }-->
<!--                   });-->
                  
              }
          }
      }
  });
  
 
      
  

  var custnamecombo = new Ext.form.ComboBox({
      store: customercombostore,
      id: 'custcomboId',
      mode: 'local',
      forceSelection: true,
      emptyText: '<%=SelectCustomer%>',
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
                   parent.globalCustomerID=Ext.getCmp('custcomboId').getValue();
<!--                      servicenamestore.load({-->
<!--                         params: {-->
<!--                           customerID: Ext.getCmp('custcomboId').getValue()-->
<!--                        }-->
<!--                   });-->
                   
              }
          }
      }
  });
  var editInfo1 = new Ext.Button({
      text: 'View',
      id: 'viewId',
      cls: 'buttonStyle',
      width: 80,
  
        handler: function () {
           //store.load();
          var clientName = Ext.getCmp('custcomboId').getValue();
          var startdate = Ext.getCmp('startdate').getValue();
          var enddate = Ext.getCmp('enddate').getValue();
           if (Ext.getCmp('custcomboId').getValue() == "") {

              Ext.example.msg("<%=PleaseSelectCustomer%>");
              Ext.getCmp('custcomboId').focus();
              return;
          }

              if (Ext.getCmp('startdate').getValue() == "") {
           
                  Ext.example.msg("<%=PleaseSelectStartDate%>");
                  Ext.getCmp('startdate').focus();
                  return;
              }
              if (Ext.getCmp('enddate').getValue() == "") {
                 
                  Ext.example.msg("<%=PleaseSelectEndDate%>");
                  Ext.getCmp('enddate').focus();
                  return;
              }
              if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                  
                  Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                  Ext.getCmp('enddate').focus();
                  return;
              }
              if (checkMonthValidation(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue())) {
                  Ext.example.msg("<%=MonthValidation%>");
                  Ext.getCmp('enddate').focus();
                  return;
              }
          store.load({
              params: {
                  CustId: Ext.getCmp('custcomboId').getValue(),
                  custName: Ext.getCmp('custcomboId').getRawValue(),
                  startDate: Ext.getCmp('startdate').getValue(),
                  endDate: Ext.getCmp('enddate').getValue(),
                  jspName: jspName
              }
          });
      }
  });
  
var clientPanel = new Ext.Panel({
      standardView: true,
      collapsible: false,
      id: 'clientPanelId',
      layout: 'table',
      frame: true,
      width: screen.width - 40,
      height: 70,
      layoutConfig: {
          columns: 10
      },
      items: [{
              xtype: 'label',
              text: '<%=CustomerName%>' + ' :',
              cls: 'labelstyle',
              id: 'custnamelab'
          },
          custnamecombo, {
              width: 100
         
          },
          
         {
              xtype: 'label',
              cls: 'labelstyle',
              id: 'startdatelab',
              text: '<%=StartDate%>' + ' :'
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfect',
              width: 185,
              format: getDateFormat(),
              emptyText: '<%=SelectStartDate%>',
              allowBlank: false,
              blankText: '<%=SelectStartDate%>',
              id: 'startdate',
              maxValue:dtcur,
               value: dtcur,
              endDateField: 'enddate'
          }, {
              width: 80
          }, {
              xtype: 'label',
              cls: 'labelstyle',
              id: 'enddatelab',
              text: '<%=EndDate%>' + ' :'
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfect',
              width: 185,
              format: getDateFormat(),
              emptyText: '<%=SelectEndDate%>',
              allowBlank: false,
              blankText: '<%=SelectEndDate%>',
              id: 'enddate',
              maxValue:dtnxt,
              //minValue:dtprev.add(Date.DAY,1),
              value: dtnxt,
              startDateField: 'startdate'
          },
           {
              width: 80
          },editInfo1
      ]
  });
  
   var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 60
        }), 
        {
        dataIndex: 'slnoDataIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 200,
            
            filter: {
                type: 'int'
            }
            }, 
            {
        
            dataIndex: 'RegistrationDataIndex',
            hidden: false,
            header: "<span style=font-weight:bold;><%=RegistrationNo%></span>",
            width: 400,
         
            filter: {
                type: 'string'
            }
            }, {
            dataIndex: 'GroupnameDataIndex',
            hidden: false,
            header: "<span style=font-weight:bold;><%=GroupName%></span>",
            width: 400,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=VehicleModel%></span>",
            hidden: false,
            width: 500,
            //sortable: false,
            dataIndex: 'VehiclemodelDataIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=EventDateTime%></span>",
            hidden: false,
            width:500,
            //sortable: true,
            dataIndex: 'Eventdate&timeDataIndex',
            renderer: Ext.util.Format.dateRenderer('d/m/Y H:i:s'),
            filter: {
                type: 'Date'
            }
        },{
            header: "<span style=font-weight:bold;><%=EventVoltage%></span>",
            hidden: false,
            width: 500,
            //sortable: true,
            dataIndex: 'EventvoltageDataIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Location%></span>",
            hidden: false,
            width: 900,
            //sortable: true,
            dataIndex: 'LocationDataIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=ActionTaken%></span>",
            hidden: false,
            width: 300,
            //sortable: true,
            dataIndex: 'ActiontakenDataIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Remarks%></span>",
            hidden: false,
            width: 300,
            //sortable: true,
            dataIndex: 'RemarksDataIndex',
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=UpdatedBy%></span>",
            hidden: false,
            width: 400,
            //sortable: true,
            dataIndex: 'UsernameDataIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=UpdatedDateTime%></span>",
            hidden: false,
            width: 400,
           // sortable: true,
            dataIndex: 'UpdatedtimeDataIndex',
            renderer: Ext.util.Format.dateRenderer('d/m/Y H:i:s'),
            filter: {
                type: 'Date'
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
grid = getGrid('', '<%=NoRecordsFound%>', store, screen.width-40, 350, 60, filters,'', false, '', 60, false, '', false, '', true, '<%=Excel%>',jspName, exportDataType,'Pdf',true);





   Ext.onReady(function () {
    Ext.QuickTips.init();
    Ext.Ajax.timeout = 180000;
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'Device/Wire Connection Report',
        renderTo: 'content',
        id:'outerPanel',
        standardView: true,
        autoScroll: false,
        frame: true,
        border: false,
        width:screen.width-22,
        height:550,
        layout: 'table',
        cls: 'outerpanel',
        layoutConfig: {
            columns: 1
        },
        items: [clientPanel,grid]
    });
    store.load();
});

   </script>
	 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
    









