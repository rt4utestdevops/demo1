<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf=new CommonFunctions();
String responseaftersubmit="''";
//String feature=session.getAttribute("feature").toString();
String feature="1";
if(session.getAttribute("responseaftersubmit")!=null){
   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
	session.setAttribute("responseaftersubmit",null);
}
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
String systemID=Integer.toString(systemid);
int customeridlogged=loginInfo.getCustomerId();
int CustIdPassed=0;
String zone=loginInfo.getZone();
String monthValidation=cf.getLabelFromDB("Month_Validation",language);

if(request.getParameter("CustId")!=null){
	CustIdPassed=Integer.parseInt(request.getParameter("CustId").toString().trim());
}


ArrayList<String> tobeConverted=new ArrayList<String>();
tobeConverted.add("Trip_Report");  //0
tobeConverted.add("Select_Customer"); //1
tobeConverted.add("Start_Date"); //2
tobeConverted.add("End_Date");  //3
tobeConverted.add("Customer_Name");  //4
tobeConverted.add("SLNO");  //5
tobeConverted.add("Asset_Number");  //6
tobeConverted.add("Owner_Name");  //7
tobeConverted.add("Start_Date");  //8
tobeConverted.add("Start_Location");  //9
tobeConverted.add("End_Date");  //10
tobeConverted.add("End_Location"); //11
tobeConverted.add("GPS_Distance_Travelled");  //12
tobeConverted.add("Estimated_Distance");  //13
tobeConverted.add("Trip_Duration");  //14
tobeConverted.add("Clear_Filter_Data");  //15
tobeConverted.add("No_Records_Found");   //16
tobeConverted.add("Reconfigure_Grid");   //17
tobeConverted.add("Clear_Grouping");   //18
tobeConverted.add("Excel");  //19
tobeConverted.add("Please_Select_customer");  //20
tobeConverted.add("Please_Select_Start_Date");  //21
tobeConverted.add("Please_Select_End_Date");  //22
tobeConverted.add("Month_Validation");  //23


ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
String TripCreationReport=convertedWords.get(0);
String Selectclient=convertedWords.get(1);
String selectstartdate=convertedWords.get(2);
String selectenddate=convertedWords.get(3);
String Client=convertedWords.get(4);
String SLNO=convertedWords.get(5);
String VehicleNo=convertedWords.get(6);
String VendorName=convertedWords.get(7);
String TripStartDateTime=convertedWords.get(8);
String VaultStartingLocation=convertedWords.get(9);
String TripEndDateTime=convertedWords.get(10);
String VaultEndinglocation=convertedWords.get(11);
String KmsTravelledFromGPS=convertedWords.get(12);
String ManualKmsTravelled=convertedWords.get(13);
String TotalTripDuration=convertedWords.get(14);
String ClearFilterData=convertedWords.get(15);
String NoRecordsFound=convertedWords.get(16);
String ReconfigureGrid=convertedWords.get(17);
String ClearGrouping=convertedWords.get(18);
String Excel=convertedWords.get(19);
String Pleaseselectclient=convertedWords.get(20);
String Pleaseselectstartdate=convertedWords.get(21);
String Pleaseselectenddate=convertedWords.get(22);
String differencebetweentwodayscannotbegreaterthanonemonth=convertedWords.get(23);

%>

<!DOCTYPE HTML>
<html>
 <head>
 
		<title><%=TripCreationReport%></title>		
	</head>	    
	    <style>
  
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  <body height="100%">
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/ImportJSCashVan.jsp" />                                               
        <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script>
    var outerPanel;
    var ctsb;
    var jspName = "TripCreationReport";
    var exportDataType = "int,string,string,date,string,date,string,int,int,string";
    var dtcur = datecur;
    var dtprev = dateprev;
    
  var clientcombostore = new Ext.data.JsonStore({
            url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
            id: 'CustomerStoreId',
        root: 'CustomerRoot',
        autoLoad: true,
        remoteSort: true,
       fields: ['CustId', 'CustName'],
        listeners: {
                 load: function (custstore, records, success, options) {
  		            if ( <%= customeridlogged %> > 0) {
  		                Ext.getCmp('custcomboId').setValue('<%=customeridlogged%>');
  		              
  		            }
  		        }
        }
    });
         //**************************** Combo for Client Name***************************************************
        var Client = new Ext.form.ComboBox({
            store: clientcombostore,
            id: 'clientId',
            mode: 'local',
            hidden: false,
            resizable: true,
            forceSelection: true,
            emptyText: '<%=Selectclient%>',
            blankText: '<%=Selectclient%>',
            selectOnFocus: true,
            allowBlank: false,
            typeAhead: true,
            triggerAction: 'all',
            lazyRender: true,
            valueField: 'CustId',
            displayField: 'CustName',
            cls: 'selectstyle',
            listeners: {
                select: {
                fn: function () {
                   // globalCustomerID=Ext.getCmp('clientId').getValue();
                   //store.reload();
                  //// Ext.getCmp('startdate').reset;
                  // Ext.getCmp('enddate').reset();
                   		grid.store.clearData();
  		                grid.view.refresh();
               
                   
                    
                }
            }
        }
        });

    
 var startdate = new Ext.form.DateField({
            fieldLabel: '<%=selectstartdate%>',
            cls: 'selectstyle',
            format: getDateFormat(),
            emptyText: '<%=selectstartdate%>',
            allowBlank: false,
            blankText: '<%=selectstartdate%>',
            format: getDateTimeFormat(),
            submitFormat: getDateTimeFormat(),
            labelSeparator: '',
            allowBlank: false,           
            id: 'startdate',
            value: dtprev,
           // maxValue: dtprev,
            vtype: 'daterange',
            endDateField: 'enddate'

        });
        
        
        
  var enddate = new Ext.form.DateField({
             fieldLabel: '<%=selectenddate%>',
            cls: 'selectstyle',
            format: getDateFormat(),
            emptyText: '<%=selectenddate%>',
            allowBlank: false,
            blankText: '<%=selectenddate%>',
            format: getDateTimeFormat(),
            submitFormat: getDateTimeFormat(),
            labelSeparator: '',
            id: 'enddate',
            value: dtcur,
          //  maxValue: dtcur,
            vtype: 'daterange',
            startDateField: 'startdate'
        });
        
        
     var editInfo1 = new Ext.Button({
            text: 'Submit',
            cls: 'buttonStyle',
            width: 70,
            handler: function ()

            {
                var clientName = Ext.getCmp('clientId').getValue();
                var startdate = Ext.getCmp('startdate').getValue();
                var enddate = Ext.getCmp('enddate').getValue();
                if(checkMonthValidation(startdate,enddate))
            		 				{
            		 					ctsb.setStatus({
              		    				text: getMessageForStatus('<%=monthValidation%>'), 
              		    				iconCls:'',
              		    				clear: true
               							});
               		   	 				Ext.getCmp('enddate').focus(); 
               		    				return;
            		 				}
                if (Ext.getCmp('clientId').getValue() == "") {
                    ctsb.setStatus({
                        text: getMessageForStatus('<%=Pleaseselectclient%>'),
                        iconCls: '',
                        clear: true
                    });
                    Ext.getCmp('clientId').focus();
                    return;
                }

                if (Ext.getCmp('startdate').getValue() == "") {
                    ctsb.setStatus({
                        text: getMessageForStatus('<%=Pleaseselectstartdate%>'),
                        iconCls: '',
                        clear: true
                    });
                    Ext.getCmp('startdate').focus();
                    return;
                }
                if (Ext.getCmp('enddate').getValue() == "") {
                    ctsb.setStatus({
                        text: getMessageForStatus('<%=Pleaseselectenddate%>'),
                        iconCls: '',
                        clear: true
                    });
                    Ext.getCmp('enddate').focus();
                    return;
                }
                store.load({
                    params: {
                        CustID: Ext.getCmp('clientId').getValue(),
                        startdate: Ext.getCmp('startdate').getValue(),
                        enddate: Ext.getCmp('enddate').getValue(),
                        custName : Ext.getCmp('clientId').getRawValue(),
                         zone:"<%=zone%>",
                        jspName: jspName
                   }

                });

            }
        });


        
   var comboPanel = new Ext.Panel({
   			standardSubmit: true,
    		collapsible: false,
    		id: 'customerMaster',
    		layout: 'table',
    		cls: 'innerpanelsmallest',
    		frame: false,
    		width: '100%',
            layout: 'table',
            layoutConfig: {
                columns: 11
            },
            items: [ {
                    xtype: 'label',
                    text: '<%=Client%> :',
                    width: 20,
                    cls: 'labelstyle'
                },
                Client, {
                    width: 50
                }, {
                    xtype: 'label',
                    text: '<%=selectstartdate%>:',
                    width: 20,
                    cls: 'labelstyle'

                },
                startdate, {
                    width: 50
                },

                {
                    xtype: 'label',
                    cls: 'labelstyle',
                    text: '<%=selectenddate%>:',
                    width: 20,
                    cls: 'labelstyle'
                },
                 enddate, {
                    width: 50
                },
                editInfo1
             ]
        });  
        
	var reader = new Ext.data.JsonReader({
	    idProperty: 'clientreaderid',
	    root: 'tripreportroot',
	    totalProperty: 'total',
	    fields: [{
	        name: 'slnoIndex'
	    }, {
	        name: 'VehicleNo'
	    }, {
	        name: 'VendorName'
	    }, {
	        name: 'TripStartDateTime',
	        type: 'date',
	        dateFormat: getDateTimeFormat()
	    }, {
	        name: 'VaultStartingLocation'
	    }, {
	        name: 'TripEndDateTime',
	        type: 'date',
	        dateFormat: getDateTimeFormat()
	    }, {
	        name: 'VaultEndinglocation'
	    }, {
	        name: 'KmsTravelledFromGPS'
	    }, {
	        name: 'ManualKmsTravelled'
	    }, {
	        name: 'TotalTripDuration'
	    }]
	});


	 //***************************************Store Config*****************************************
	var store = new Ext.data.GroupingStore({
	    autoLoad: false,
	    proxy: new Ext.data.HttpProxy({
	        url: '<%=request.getContextPath()%>/TripCreationReportAction.do?param=getTripCreationDetails',
	        method: 'POST'
	    }),

	    storeId: 'clientreaderid',
	    reader: reader
	});

	 //**********************Filter Config****************************************************
	var filters = new Ext.ux.grid.GridFilters({
	    local: true,
	    filters: [{
	        type: 'numeric',
	        dataIndex: 'slnoIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'VehicleNo'
	    }, {
	        type: 'string',
	        dataIndex: 'VendorName'
	    }, {
	        type: 'date',
	        dataIndex: 'TripStartDateTime'
	    }, {
	        type: 'string',
	        dataIndex: 'VaultStartingLocation'
	    }, {
	        type: 'date',
	        dataIndex: 'TripEndDateTime'
	    }, {
	        type: 'string',
	        dataIndex: 'VaultEndinglocation'
	    }, {
	        type: 'int',
	        dataIndex: 'KmsTravelledFromGPS'
	    }, {
	        type: 'int',
	        dataIndex: 'ManualKmsTravelled'
	    }, {
	        type: 'int',
	        dataIndex: 'TotalTripDuration'
	    }]
	});

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
	            dataIndex: 'VehicleNo',
	            header: "<span style=font-weight:bold;><%=VehicleNo%></span>",
	            width: 50,
	            filter: {
	                type: 'string'
	            }
	        }, {
	            dataIndex: 'VendorName',
	            header: "<span style=font-weight:bold;><%=VendorName%></span>",
	            width: 50,
	            filter: {
	                type: 'string'
	            }
	        }, {
	            dataIndex: 'TripStartDateTime',
	            header: "<span style=font-weight:bold;><%=TripStartDateTime%></span>",
	            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
	            width: 50,
	            filter: {
	                type: 'date'
	            }
	        }, {
	            dataIndex: 'VaultStartingLocation',
	            header: "<span style=font-weight:bold;><%=VaultStartingLocation%></span>",
	            width: 50,
	            filter: {
	                type: 'string'
	            }
	        }, {
	            dataIndex: 'TripEndDateTime',
	            header: "<span style=font-weight:bold;><%=TripEndDateTime%></span>",
	            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
	            width: 50,
	            filter: {
	                type: 'date'
	            }
	        }, {
	            dataIndex: 'VaultEndinglocation',
	            header: "<span style=font-weight:bold;><%=VaultEndinglocation%></span>",
	            width: 50,
	            filter: {
	                type: 'string'
	            }
	        }, {
	            dataIndex: 'KmsTravelledFromGPS',
	            header: "<span style=font-weight:bold;><%=KmsTravelledFromGPS%></span>",
	            width: 50,
	            filter: {
	                type: 'int'
	            }
	        }, {
	            dataIndex: 'ManualKmsTravelled',
	            header: "<span style=font-weight:bold;><%=ManualKmsTravelled%></span>",
	            width: 50,
	            filter: {
	                type: 'int'
	            }
	        }, {
	            dataIndex: 'TotalTripDuration',
	            header: "<span style=font-weight:bold;><%=TotalTripDuration%></span>",
	            width: 50,
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
        
    //*****************************************************************Grid *****************************************************************************************************************************************************************************************
     var grid = getGrid('<%=TripCreationReport%>', '<%=NoRecordsFound%>', store, screen.width-40, 450, 12, filters, '<%=ClearFilterData%>', true, '<%=ReconfigureGrid%>', 12, true, '<%=ClearGrouping%>', false, '', true, '<%=Excel%>', jspName, exportDataType, true, 'PDF');
    //***************************************************************************************************************************************************************************************************************************************************************

    Ext.onReady(function () {
            ctsb = tsb;
            Ext.QuickTips.init();
            Ext.form.Field.prototype.msgTarget = 'side';
            outerPanel = new Ext.Panel({
               // title: '<%=TripCreationReport%>',
                renderTo: 'content',
                standardSubmit: true,
                frame: true,
                //cls: 'outerpanel',
                height:520,
                width:screen.width-25,
                items: [comboPanel, grid],
                bbar: ctsb
            });


            sb = Ext.getCmp('form-statusbar');

        }); // END OF ONREADY

</script>
</body>
</html>
    
    
    
    
    
    
    