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
		if (str.length > 11) {
			loginInfo.setStyleSheetOverride("N");
		}
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
tobeConverted.add("SLNO");
tobeConverted.add("Trip_Start_Date_Time");
tobeConverted.add("Asset_Number");
tobeConverted.add("Please_Select_Start_Date");
tobeConverted.add("Start_Date");
tobeConverted.add("No_Rows_Selected");

ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);

String selectCustomer=convertedWords.get(0);
String pleaseSelectcustomer=convertedWords.get(1);
String SLNO=convertedWords.get(2);
String tripStartDateTime=convertedWords.get(3);
String assetNumber=convertedWords.get(4);
String selectStartDate=convertedWords.get(5);
String startDate=convertedWords.get(6);
String noRecordsFound=convertedWords.get(7);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
	
		<title>DayWiseNoShowReport</title>
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
	</head>

	<body>
		<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/ImportJSSandMining.jsp" />                                                    
        <%}else {%>  
        <jsp:include page="../Common/ImportJS.jsp" /><%} %>
        <jsp:include page="../Common/ExportJS.jsp" />
        <script>
        
		var dtprev=dateprev;
		var grid;
		var myWin;
		var buttonValue;
		var uniqueId;
		var dtcur=datecur;
		var globaltripId;	
	 	var jspName='DayWiseNoShowReport';
    	var exportDataType = "int,string,string,string";

	//*********************** Store For Customer *****************************************//
	
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
            }
        }
    }
});

	//*********************** Store For Customer Ends Here*****************************************//
		
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
                 store.load();
            }
        }
    }
	});
	
	
	//************************ Combo for Customer Ends Here***************************************//	
	
	
	 //********************************************Grid config starts***********************************
  
  
    // **********************************************Reader configs Starts******************************
    
     var reader = new Ext.data.JsonReader({
        idProperty: 'tripcreationId',
    	root: 'DayWiseNoShowRoot',
    	totalProperty: 'total',
    	fields: [{
        name: 'slnoIndex'
    	},{
        name: 'sdate',
        type: 'date',
        dateFormat: getDateTimeFormat()
    	},{
        name: 'registrationNo'
    	}, {
    	name: 'groupNameIndex'
    	}]
    });
    
    // **********************************************Reader configs Ends******************************

    //********************************************Store Configs For Grid*************************

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/TripCreation.do?param=getDayWiseNoShowTripDetails',
            method: 'POST'
        }),
        remoteSort: false,
        sortInfo: {
            field: 'registrationNo',
            direction: 'ASC'
        },
        storeId: 'DaywiseNoShowtripDetailsStore',
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
        type: 'date',
        dataIndex: 'sdate'
    	},{
        type: 'string',
        dataIndex: 'registrationNo'
    	}, {
        type: 'string',
        dataIndex: 'groupNameIndex'
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
    		}, {
        	dataIndex: 'sdate',
        	header: "<span style=font-weight:bold;><%=tripStartDateTime%></span>",
        	 renderer: Ext.util.Format.dateRenderer('d-m-Y'),
        	 hidden:true,
        	width: 80,        	
        	filter: {
            type: 'date'
        	}
    		},
			 {
        	header: "<span style=font-weight:bold;><%=assetNumber%></span>",
        	dataIndex: 'registrationNo',
        	width: 110,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;>Group Name</span>",
        	dataIndex: 'groupNameIndex',
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
   
   
    grid = getGrid('Day Wise No Show Details', '<%=noRecordsFound%>', store,screen.width-40,430, 17, filters, 'Clear Filter Data', false, '', 14, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', false, '', false, '', false, '', false , '');	
		
	//**********************************End Of Creating Grid By Passing Parameter*************************	
		
		 var editInfo1 = new Ext.Button({
            text: 'Submit',
            cls: 'buttonStyle',
            width: 70,
            handler: function ()

            {
                var clientName = Ext.getCmp('custcomboId').getValue();
                var startdate = Ext.getCmp('startdate').getValue();
               // alert(clientName);alert(startdate);alert(enddate);
              
                if (Ext.getCmp('custcomboId').getValue() == "") {
                	Ext.example.msg("<%=pleaseSelectcustomer%>");
                    Ext.getCmp('custcomboId').focus();
                    return;
                }

                if (Ext.getCmp('startdate').getValue() == "") {
                	Ext.example.msg("<%=selectStartDate%>");
                    Ext.getCmp('startdate').focus();
                    return;
                }
                store.load({
                    params: {
                        CustID: Ext.getCmp('custcomboId').getValue(),
                        startdate: Ext.getCmp('startdate').getValue(),
                        custName : Ext.getCmp('custcomboId').getRawValue(),
                        jspName: jspName
                  }

               });

            }
        });

		
			
   	// ***********************   Pannel For Customer For Adding Trip Inforamtion**************************		
 
   			var customerPanel = new Ext.Panel({
   				standardSubmit: true,
    			collapsible: false,
    			id: 'customerMaster',
    			layout: 'table',
    			cls: 'innerpanelsmallest',
    			frame: false,
    			width: screen.width-35,
    			layoutConfig: {
        		columns: 11
    			},
    			items: [{
            		xtype: 'label',
           		    text: '<%=selectCustomer%>' + ' :',
            		cls: 'labelstyle',
            		id: 'custnamelab'
        			},
        			custnamecombo, {
                    width: 49
                },
                  {
                    xtype: 'label',
                    text: '<%=startDate%>'+ ' :',
                    width: 20,
                    cls: 'labelstyle'

                },{
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               width:250,
               //width: 185,
               format: getDateFormat(),
               allowBlank: false,
               id: 'startdate',
               value: dtcur,
               //emptyText: '<%=selectStartDate%>'
               endDateField: 'enddate'
            },{
                    width: 225
              },editInfo1
    				]
				});
 
   // ***********************    Main Starts From Here *********************************//		
   	
   	Ext.onReady(function () {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';

    outerPanel = new Ext.Panel({
        //title: 'Trip Creation',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        //cls: 'outerpanel',
        height:510,
        width:screen.width-22,
        items: [customerPanel,grid]
    });
     
});

	// ***********************    Main Ends Here *********************************//	
   			</script>
	</body>
</html>
<%}%>
