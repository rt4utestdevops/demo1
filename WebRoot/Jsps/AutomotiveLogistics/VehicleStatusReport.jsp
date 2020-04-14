<%@ page language="java"
	import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
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
    
 if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
  
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	
	
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Vehicle_Availability_Report");
tobeConverted.add("Type");
tobeConverted.add("Select_Type");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Customer_Name");
tobeConverted.add("Start_Date");
tobeConverted.add("Select_Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("Select_End_Date");
tobeConverted.add("SLNO");
tobeConverted.add("Vehicle_No");
tobeConverted.add("In_Transit_Vehicles_Report");
tobeConverted.add("Excel");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Last_Service_Date");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Expiry_Date");
tobeConverted.add("Please_Select_customer");
tobeConverted.add("Please_Select_Report_Type");
tobeConverted.add("Please_Select_Start_Date");
tobeConverted.add("Please_Select_End_Date");
tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
tobeConverted.add("Month_Validation");
tobeConverted.add("Current_Location");
tobeConverted.add("Arrival_Date_Time");
tobeConverted.add("Source");
tobeConverted.add("Destination");
tobeConverted.add("Expected_Date_Time");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String VehicleAvailabilityReport=convertedWords.get(0);
String Type=convertedWords.get(1);
String SelectType=convertedWords.get(2);
String SelectCustomer=convertedWords.get(3);
String CustomerName=convertedWords.get(4);
String StartDate=convertedWords.get(5);
String SelectStartDate=convertedWords.get(6);
String EndDate=convertedWords.get(7);
String SelectEndDate=convertedWords.get(8);
String SLNO=convertedWords.get(9);
String AssetNumber=convertedWords.get(10);
String InTransitVehiclesReport=convertedWords.get(11);
String Excel=convertedWords.get(12);
String ClearFilterData=convertedWords.get(13);
String LastServiceDate=convertedWords.get(14);
String NoRecordsfound=convertedWords.get(15);
String ExpiryDate=convertedWords.get(16);
String PleaseSelectCustomer=convertedWords.get(17);
String PleaseSelectReportType=convertedWords.get(18);
String PleaseSelectStartDate=convertedWords.get(19);
String PleaseSelectEndDate=convertedWords.get(20);
String EndDateMustBeGreaterthanStartDate=convertedWords.get(21);
String monthValidation=convertedWords.get(22);
String currentLocation = convertedWords.get(23);
String arrivalTime = convertedWords.get(24);
String source= convertedWords.get(25);
String destination=convertedWords.get(26);
String expectedDateTime=convertedWords.get(27);

%>

<jsp:include page="../Common/header.jsp" />
		<title>VehicleStatusReport</title>
	</head>
	<style>
	.x-panel-tl {
		border-bottom: 0px solid !important;
	}
	label{
		display: inline !important;
	}
	body{
		overflow: hidden !important;
	}
</style>
	<!--<body onload="refresh();"> -->
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
		<jsp:include page="../Common/ExportJS.jsp" />
		<style>
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
			}
		</style>
		<script>
   var outerPanel;
  var dtprev = dateprev;
  var dtcur = datecur;
  var jspName = "VehicleStatusReport";
  var exportDataType = "int,string,string,string,string,string,string";
  var startDate = "";
  var endDate = "";
  var grid;
	
  window.onload = function () { 
		refresh();
  }
   
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
                      Ext.getCmp('serviceTypeComboId').reset();
                      servicenamestore.load();
                   
              
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
                      Ext.getCmp('serviceTypeComboId').reset();
                      servicenamestore.load();
                   
              }
          }
      }
  });

var servicenamestore =new Ext.data.SimpleStore({
        id: 'servicetypeid',
        autoLoad: false,
        fields: ['name','value'],
        data: [['Vehicle Availability','Vehicle Availability'], 
        	   ['In Transit Vehicles','In Transit Vehicles']
        	  ]	  
    });
      
  var serviceTypeCombo = new Ext.form.ComboBox({
      store: servicenamestore,
      id: 'serviceTypeComboId',
      mode: 'local',
      forceSelection: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      emptyText: '<%=SelectType%>',
      valueField: 'name',
      displayField: 'value',
      cls: 'selectstylePerfect',
      listeners:{
       'select': function(combo, record) {
       		store.removeAll();
       		
       		if(Ext.getCmp('serviceTypeComboId').getValue()=="Vehicle Availability"){
       		  Ext.getCmp('outerPanel').setTitle('<%=VehicleAvailabilityReport%>');
       		  Ext.getCmp('startdatelab').hide();
       		  Ext.getCmp('startdate').hide();
       		  Ext.getCmp('enddatelab').hide();
       		  Ext.getCmp('enddate').hide();
       		  Ext.getCmp('Typelab').setWidth(100);
       		  Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(1, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(2, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(3, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(4, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(5, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(6, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(7, true);
              
       		}else if(Ext.getCmp('serviceTypeComboId').getValue()=="In Transit Vehicles"){
       		  Ext.getCmp('outerPanel').setTitle('<%=InTransitVehiclesReport%>');
       		  Ext.getCmp('startdatelab').show();
       		  Ext.getCmp('startdate').show();
       		  Ext.getCmp('enddatelab').show();
       		  Ext.getCmp('enddate').show();
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(1, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(2, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(3, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(4, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(5, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(6, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(7, false);
              }
             }
         
      }
  });
	 
	
  var editInfo1 = new Ext.Button({
      text: 'Submit',
      id: 'submitId',
      cls: 'buttonStyle',
      width: 70,
      handler: function () {
          // store.load();
          var clientName = Ext.getCmp('custcomboId').getValue();
          var startdate = Ext.getCmp('startdate').getValue();
          var enddate = Ext.getCmp('enddate').getValue();
           if (Ext.getCmp('custcomboId').getValue() == "") {

              Ext.example.msg("<%=PleaseSelectCustomer%>");
              Ext.getCmp('custcomboId').focus();
              return;
          }
           if (Ext.getCmp('serviceTypeComboId').getValue() == "") {
             
              Ext.example.msg("<%=PleaseSelectReportType%>");
              Ext.getCmp('custcomboId').focus();
              return;
          }
          if(Ext.getCmp('serviceTypeComboId').getValue()=="In Transit Vehicles"){
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
                  Ext.example.msg("<%=monthValidation%>");
                  Ext.getCmp('enddate').focus();
                  return;
              }
           }
          store.load({
              params: {
                  CustId: Ext.getCmp('custcomboId').getValue(),
                  custName: Ext.getCmp('custcomboId').getRawValue(),
                  startDate: Ext.getCmp('startdate').getValue(),
                  endDate: Ext.getCmp('enddate').getValue(),
                  jspName: jspName,
                  reportType: Ext.getCmp('serviceTypeComboId').getValue()
              }
          });
      }
  });
  
  var clientPanel = new Ext.Panel({
      standardSubmit: true,
      collapsible: false,
      id: 'clientPanelId',
      layout: 'table',
      frame: true,
      width: screen.width - 40,
      height: 70,
      layoutConfig: {
          columns: 7
      },
      items: [{
              xtype: 'label',
              text: '<%=CustomerName%>' + ' :',
              cls: 'labelstyle',
              id: 'custnamelab'
          },
          custnamecombo, {
              width: 80
          }, {
              xtype: 'label',
              text: '<%=Type%>' + ' :',
              cls: 'labelstyle',
              id: 'Typelab'
          },
          serviceTypeCombo, {
              width: 5
          },
          editInfo1, {
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
              maxValue:dtprev,
               value: dtprev,
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
              maxValue:dtprev.add(Date.DAY,1),
              //minValue:dtprev.add(Date.DAY,1),
              value: datecur,
              startDateField: 'startdate'
          }, {
              width: 80
          }
      ]
  });
  
    var reader = new Ext.data.JsonReader({
        idProperty: 'readerdetailid',
        root: 'VehicleReportRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'sourceIndex'
        }, {
            name: 'destinationIndex'
        },{
        	type:'date',
            name: 'arrivalTimeIndex'
        }, {
            name: 'assetNoIndex'
        }, {
            name: 'currentLocationIndex'
        }, {
        	type:'date',
            name: 'expectedDateTimeIndex'
        }]
    });
            
 var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'string',
            dataIndex: 'sourceIndex'
        }, {
            type: 'string',
            dataIndex: 'destinationIndex'
        }, {
            type: 'date',
            dataIndex: 'arrivalTimeIndex'
        }, {
            type: 'string',
            dataIndex: 'assetNoIndex'
        }, {
            type: 'string',
            dataIndex: 'currentLocationIndex'
        },{
            type: 'date',
            dataIndex: 'expectedDateTimeIndex'
        }]
    });
  
  var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/VehicleStatusReportsAction.do?param=getVehicleAvailabilityAndInTransit',
            method: 'POST'
        }),
        remoteSort: false,
        sortInfo: {
            field: 'slnoIndex',
            direction: 'ASC'
        },
        storeId: 'servicetypedetailid',
        reader: reader
        });
        store.on('beforeload', function (store, operation, eOpts) {
                operation.params = {
                     custId: Ext.getCmp('custcomboId').getValue(),
                     custName: Ext.getCmp('custcomboId').getRawValue(),
                     startDate: Ext.getCmp('startdate').getValue(),
                     endDate: Ext.getCmp('enddate').getValue(),
                     jspName: jspName,
                     reportType: Ext.getCmp('serviceTypeComboId').getValue()
                };
            }, this);
  
  
  var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 60
        }), {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 20,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=source%></span>",
            hidden: true,
            //width: 100,
            sortable: false,
            dataIndex: 'sourceIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=destination%></span>",
            hidden: false,
            //width: 120,
            sortable: true,
            dataIndex: 'destinationIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=arrivalTime%></span>",
            hidden: false,
            //width: 120,
            sortable: true,
            dataIndex: 'arrivalTimeIndex',
            renderer: Ext.util.Format.dateRenderer('d-m-Y H:i:s')
        },{
            header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
            hidden: false,
            //width: 120,
            sortable: true,
            dataIndex: 'assetNoIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=currentLocation%></span>",
            hidden: false,
            //width: 120,
            sortable: true,
            dataIndex: 'currentLocationIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=expectedDateTime%></span>",
            hidden: true,
            //width: 120,
            sortable: true,
            dataIndex: 'expectedDateTimeIndex',
            renderer: Ext.util.Format.dateRenderer('d-m-Y H:i:s')
        }
    ];
    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: true
        }
    });
};

//********************************grid***************************//

grid = getGrid('', '<%=NoRecordsfound%>', store, screen.width-40, 350, 60, filters,'', false, '', 60, false, '', false, '', true, '<%=Excel%>',jspName, exportDataType, true, 'PDF');

 Ext.onReady(function () {
    Ext.QuickTips.init();
    Ext.Ajax.timeout = 180000;
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'Vehicle Availability Details',
        renderTo: 'content',
        id:'outerPanel',
        standardSubmit: true,
        autoScroll: false,
        frame: true,
        border: false,
        width:screen.width-22,
        height:510,
        layout: 'table',
        cls: 'outerpanel',
        layoutConfig: {
            columns: 1
        },
        items: [clientPanel,grid]
    });
    //store.load();
});

</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->