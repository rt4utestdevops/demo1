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
  		tobeConverted.add("Select_Asset_type");
  		tobeConverted.add("SLNO");
  		tobeConverted.add("Asset_Number");
  		tobeConverted.add("Select_Start_Date");
  		tobeConverted.add("Select_End_Date");
  		tobeConverted.add("Asset_Details");
  		tobeConverted.add("Customer_Name");
  		tobeConverted.add("Asset_Group");
 		tobeConverted.add("Start_Date");
  		tobeConverted.add("End_Date");
  		tobeConverted.add("Trip_Name");
  		tobeConverted.add("Start_Location");
  		tobeConverted.add("End_Time");
  		tobeConverted.add("End_Location");
  		tobeConverted.add("Running_Durations");
  		tobeConverted.add("Travel_Time");
  		tobeConverted.add("Travel_Distance");
  		tobeConverted.add("Clear_Filter_Data");
  		tobeConverted.add("Excel");
  		tobeConverted.add("Month_Validation");  
  		tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
  		tobeConverted.add("Route_Name");
  		tobeConverted.add("Vehicle_Utilization_During_Working_Days_After_Working_Hrs");
  		tobeConverted.add("Clear_Grouping");
  		tobeConverted.add("Reconfigure_Grid");
 	    tobeConverted.add("No_Records_Found");
  		tobeConverted.add("Asset_Group");
  		tobeConverted.add("Registration_Number");
  		tobeConverted.add("Vehicle_Type");
  		tobeConverted.add("Selected_Days");
  		tobeConverted.add("Working_Days");
 	    tobeConverted.add("Non_Working_Days");
  		tobeConverted.add("Utilization_In_Working_Days");
  		tobeConverted.add("Distance_Travelled");
  		tobeConverted.add("Utilizations");
  		tobeConverted.add("Utilized_On_Non_Working_Hrs");
  		tobeConverted.add("Non_Utilization_In_Working_Days");
  		tobeConverted.add("Please_Select_End_Date");
  		tobeConverted.add("Please_Select_Start_Date");
  		tobeConverted.add("Please_Select_customer");
  		tobeConverted.add("Asset_Type");
  		tobeConverted.add("Select_Asset_Group");
  		tobeConverted.add("PDF");
  		tobeConverted.add("Utilization_Details");
  		tobeConverted.add("Utilization_Graph");
  		tobeConverted.add("Asset_Model");
  		tobeConverted.add("Lowest_Utilization");
  		tobeConverted.add("Highest_Utilization");
  		tobeConverted.add("Please_Select_Asset_Group");
  		
  		
  
     
	ArrayList<String> convertedWords = new ArrayList<String>();
 		convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
 		String SelectCustomer = convertedWords.get(0);
 		String SelectAssettype = convertedWords.get(1);
 		String SLNO = convertedWords.get(2);
 		String AssetNumber = convertedWords.get(3);
		String SelectStartDate = convertedWords.get(4);
 		String SelectEndDate = convertedWords.get(5);
 		String AssetDetails = convertedWords.get(6);
 		String CustomerName = convertedWords.get(7);
 		String AssetGroup = convertedWords.get(8);
 		String StartDate = convertedWords.get(9);
 		String EndDate = convertedWords.get(10);
 		String TripName = convertedWords.get(11);
 		String StartLocation = convertedWords.get(12);
 		String EndTime = convertedWords.get(13);
 		String EndLocation = convertedWords.get(14);
 		String RunningDuration = convertedWords.get(15);
 		String TravelTime = convertedWords.get(16);
 		String TravelDistance = convertedWords.get(17);
 		String ClearFilterData = convertedWords.get(18);
 		String Excel = convertedWords.get(19);
 		String monthValidation =  convertedWords.get(20);
 		String EndDateMustBeGreaterthanStartDate = convertedWords.get(21);
 		String RouteName= convertedWords.get(22);
 		String VehicleUtilizationDuringWorkingDaysAfterWorkingHrs = convertedWords.get(23);
 		String ClearGrouping = convertedWords.get(24);
 		String ReconfigureGrid = convertedWords.get(25);
 		String NoRecordsFound = convertedWords.get(26);
 		String GroupName = convertedWords.get(27);
 		String RegistrationNumber = convertedWords.get(28);
 		String VehicleType = convertedWords.get(29);
 		String SelectedDays = convertedWords.get(30);
 		String WorkingDays = convertedWords.get(31);
 		String NonWorkingDays = convertedWords.get(32);
 		String UtilizationInWorkingDays = convertedWords.get(33);
 		String DistanceTravelled = convertedWords.get(34);
 		String Utilizations = convertedWords.get(35);
 		String UtilizedOnNonWorkingHrs = convertedWords.get(36);
 		String NonUtilizationInWorkingDays = convertedWords.get(37);
 		String PleaseSelectEndDate = convertedWords.get(38);
 		String PleaseSelectStartDate = convertedWords.get(39);
 		String PleaseSelectClient = convertedWords.get(40);
 		String AssetType = convertedWords.get(41);
 		String SelectGroup = convertedWords.get(42);
 		String PDF = convertedWords.get(43);
 		String UtilizationDetails = convertedWords.get(44);
		String UtilizationGraph = convertedWords.get(45);
 		String AssetModel = convertedWords.get(46);
 		String LowestUtilization = convertedWords.get(47);
		String HighestUtilization = convertedWords.get(48);
		String PleaseselectAssetGroup = convertedWords.get(49);
%>



<!DOCTYPE HTML>
<html>
<style>
.mystyle1{
margin-left:10px;
}
</style>
  <head>
        <title><%=VehicleUtilizationDuringWorkingDaysAfterWorkingHrs%></title>
    </head>
    
    <body height="100%" background-color: "#ffffff">
        <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
        <!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
        
    <script type="text/javascript" src="../../Main/Js/jsapi.js"></script>
	<style>	
	.x-panel-body-noborder {
		//width : 1305px !important;
	}
  </style>
   	<script>
    google.load("visualization", "1", {packages:["corechart"]});
        var outerPanel;
        var ctsb;
        var jspName = "VehicleUtilizationDuringWorkingDaysAfterWorkingHrs";
        var exportDataType = "int,string,string,string,string,int,int,int,int,int,int,float,float,int";
        var dtprev = datecur.add(Date.DAY, -2); 
   var dtcur = datecur.add(Date.DAY, -1);

//********************************************************* CUSTOMER NAME STORE ********************************************************************
       Ext.EventManager.onWindowResize(function () {
     var width = '100%';
     var height = '100%';
     grid.setSize(width, height);
     outerPanel.setSize(width, height);
     outerPanel.doLayout();
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
                 custId = Ext.getCmp('custcomboId').getValue();
                 custName = Ext.getCmp('custcomboId').getRawValue();
                 assetGroupStore.load({
                     params: {
                         CustId: custId
                     }
                 });
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
                 globalAssetNumber = "";
                 custId = Ext.getCmp('custcomboId').getValue();
                 custName = Ext.getCmp('custcomboId').getRawValue();
                  assetGroupStore.load({
                     params: {
                         CustId: custId
                     }
                 });
                 store.load();
                 Ext.getCmp('assettypecomboId').reset();
                 if (Ext.getCmp('custcomboId').getValue()) {
                     Ext.getCmp('utilizationGridTab').enable();
                     Ext.getCmp('utilizationGridTab').show();
                 }
                 if ( <%= customerId %> > 0) {

                     Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                     custId = Ext.getCmp('custcomboId').getValue();
                     custName = Ext.getCmp('custcomboId').getRawValue();

                     store.load();
                 }
             }
         }
     }
 });

 var assetGroupStore = new Ext.data.JsonStore({
     url: '<%=request.getContextPath()%>/UtilizationReportsAction.do?param=getAssetGroup',
     id: 'assetTypeId',
     root: 'assetGroupRoot',
     autoload: false,
     remoteSort: true,
     fields: ['groupId', 'groupName'],
     listeners: {
         load: function () {}
     }

 });

 var assetGroupCombo = new Ext.form.ComboBox({
     store: assetGroupStore,
     id: 'assettypecomboId',
     mode: 'local',
     forceSelection: true,
     emptyText: '<%=SelectGroup%>',
     selectOnFocus: true,
     allowBlank: false,
     anyMatch: true,
     typeAhead: false,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'groupId',
     displayField: 'groupName',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {
                 assetType = Ext.getCmp('assettypecomboId').getValue();
                 custId = Ext.getCmp('custcomboId').getValue();
                 var globalGroupId = Ext.getCmp('assettypecomboId').getValue();

                 store.load();
                 if (Ext.getCmp('assettypecomboId').getValue()) {
                     Ext.getCmp('utilizationGridTab').enable();
                     Ext.getCmp('utilizationGridTab').show();
                 }


             }
         }
     }
 });


//********************************************************* START DATE / END DATE / SUBMIT ****************************************************************
			
        var editInfo1 = new Ext.Button({
            text: 'Submit',
            cls: 'buttonStyle',
            width: 70,
            handler: function ()

            {  
                //store.load();
                var clientName = Ext.getCmp('custcomboId').getValue();
                var startdate = Ext.getCmp('startdate').getValue();
                var enddate = Ext.getCmp('enddate').getValue();
                
                if (Ext.getCmp('custcomboId').getValue() == "") {
                    Ext.example.msg("<%=PleaseSelectClient%>");
                    Ext.getCmp('custcomboId').focus();
                    return;
                }
                
                if (Ext.getCmp('assettypecomboId').getValue() == "") {
             		Ext.example.msg("<%=PleaseselectAssetGroup%>");
             		Ext.getCmp('assettypecomboId').focus();
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
                       
                if(checkMonthValidation(Ext.getCmp('startdate').getValue(),Ext.getCmp('enddate').getValue()))
            		 				{
            		 					Ext.example.msg("<%=monthValidation%>");
            		 					Ext.getCmp('enddate').focus(); 
               		    				return;
            		 				}
       
               	store.load({
                   		params: {
                        custID: Ext.getCmp('custcomboId').getValue(),
                        startdate: Ext.getCmp('startdate').getValue(),
                        enddate: Ext.getCmp('enddate').getValue(),
                       groupId:Ext.getCmp('assettypecomboId').getValue(),
                        CustName:Ext.getCmp('custcomboId').getRawValue(),
                        jspName:jspName
               		}
               	});
               }
        	});
        	
//********************************************************* COMBO PANEL ********************************************************************        	
 
        var comboPanel = new Ext.Panel({
       		standardSubmit: true,
       		collapsible: false,
       		id: 'traderMaster',
       		layout: 'table',
       		frame: false,
       		width: screen.width - 32,
       		height: 30,
       		layoutConfig: {
            columns: 13
       		},
       		items: [{
               xtype: 'label',
               text: '<%=CustomerName%>' + ' :',
               cls: 'labelstyle',
               id: 'custnamelab'
           		},
           		custnamecombo, 
           		{
               		width: 25
           	   }, {
               xtype: 'label',
               text: '<%=GroupName%>' + ' :',
               cls: 'labelstyle',
               id: 'assetTypelab'
           		},
           		assetGroupCombo,
           		{
               		width: 25
           	   }, {
               xtype: 'label',
               cls: 'labelstyle',
               id: 'startdateId',
               text: '<%=StartDate%>' + ' :'
           		}, {
               xtype: 'datefield',
               cls: 'sandlblstyle',
               width: 160,
               format: getDateFormat(),
               emptyText: '<%=SelectStartDate%>',
               allowBlank: false,
               blankText: '<%=SelectStartDate%>',
               id: 'startdate',
               value: dtprev,
               endDateField: 'enddate'
               }, {
               width: 25
               }, {
               xtype: 'label',
               cls: 'labelstyle',
               id: 'enddatelab',
               text: '<%=EndDate%>' + ' :'
               }, {
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               width: 160,
               format: getDateFormat(),
               emptyText: '<%=SelectEndDate%>',
               allowBlank: false,
               blankText: '<%=SelectEndDate%>',
               id: 'enddate',
               maxValue:dtcur,
               value: dtcur,
               startDateField: 'startdate'
            },{width:25},editInfo1
          ]
       });
       
       
//********************************************************* BAR CHART STORE ********************************************************************

		var charttypestore =new Ext.data.SimpleStore({
        	id:'charttypeId',
        	autoLoad:true,
        	fields:['charttype'],
        	data:[
        		['Highest Utilization'],
        		['Lowest Utilization']
        	   ]
        	});
        	
//********************************************************* BAR CHART COMBO ********************************************************************        	

		var chartCombo = new Ext.form.ComboBox({
            store: charttypestore,
            id: 'charttypeId',
            mode: 'local',
            hidden: false,
            resizable: false,
            forceSelection: true,
            value: 'Highest Utilization',
            selectOnFocus: true,
            allowBlank: false,
            typeAhead: true,
            triggerAction: 'all',
            lazyRender: true,
            valueField: 'charttype',
            displayField: 'charttype',
            cls: 'selectstylePerfect',
            listeners: {
                select: {
                    fn: function () {
                    if(this.getValue()=='Highest Utilization')
                    {
						Ext.getCmp('utilizationchartid').update('<table width="100%"><tr><tr> <td> <div id="highestchartdiv" align="center"> </div></td></tr></table>');
                    	Ext.getCmp('lowutilizationchartid').update('<table width="100%"><tr><tr> <td> <div id="lowestchartdiv" align="center"> </div></td></tr></tr></table>');
                    highestUtilizationChart();
                    }
                     if(this.getValue()=='Lowest Utilization')
                    {
						Ext.getCmp('utilizationchartid').update('<table width="100%"><tr><tr> <td> <div id="highestchartdiv" align="center"> </div></td></tr></table>');
                    	Ext.getCmp('lowutilizationchartid').update('<table width="100%"><tr><tr> <td> <div id="lowestchartdiv" align="center"> </div></td></tr></tr></table>');
                    lowestUtilizationChart();
                    }
                   }
                 } 
               }
           });
           
           
        var reader = new Ext.data.JsonReader({
            idProperty: 'darreaderid',
            root: 'VehicleUtilizationRoot',
            totalProperty: 'total',
            fields: [{
                name: 'slnoIndex'
            }, {
                name: 'groupnameIndex'
            }, {
                name: 'AssetnumberIndex'
            }, {
                name: 'AssettypeIndex'
            }, {
                name: 'AssetmodelIndex'
            }, {
                name: 'selecteddaysIndex'
            }, {
                name: 'workingdaysIndex'
            }, {
                name: 'nonworkingdaysIndex'
            }, {
                name: 'utilizationperdayIndex'
            }, {
                name: 'nonutilizationperdayIndex'
            }, {
                name: 'utilizedonnonworkinghrsIndex'
            }, {
                name: 'TraveltimeIndex'
            }, {
                name: 'distancetravelledIndex'
            }, {
                name: 'utilizationIndex'
            }]
        });

//*********************************************************** STORE CONFIG **************************************************************************

        var store = new Ext.data.GroupingStore({
            autoLoad: false,
            proxy: new Ext.data.HttpProxy({
                url: '<%=request.getContextPath()%>/UtilizationReportsAction.do?param=getDataForWorkingDaysAfterWorkingHrs',
                method: 'POST'
            }),
           remoteSort: false,
         sortInfo: {
         field: 'utilizationIndex',
         direction: 'DESC'
     },
            storeId: 'VehicleUtilizationDuringWorkingDaysAfterWorkingHrs',
            reader: reader
        });
        

 //********************************************************** FILTER CONFIG **************************************************************************
 
        var filters = new Ext.ux.grid.GridFilters({
            local: true,
            filters: [{
                type: 'numeric',
                dataIndex: 'slnoIndex'
            }, {
                type: 'string',
                dataIndex: 'groupnameIndex'
            }, {
                type: 'string',
                dataIndex: 'AssetnumberIndex'
            }, {
                type: 'string',
                dataIndex: 'AssettypeIndex'
            } , {
                type: 'string',
                dataIndex: 'AssetmodelIndex'
            }, {
                type: 'numeric',
                dataIndex: 'selecteddaysIndex'
            }, {
                type: 'numeric',
                dataIndex: 'workingdaysIndex'
            } , {
                type: 'numeric',
                dataIndex: 'nonworkingdaysIndex'
            }, {
                type: 'numeric',
                dataIndex: 'utilizationperdayIndex'
            } , {
                type: 'numeric',
                dataIndex: 'nonutilizationperdayIndex'
            }, {
                type: 'numeric',
                dataIndex: 'utilizedonnonworkinghrsIndex'
            } , {
                type: 'float',
                dataIndex: 'TraveltimeIndex'
            }, {
                type: 'float',
                dataIndex: 'distancetravelledIndex'
            } , {
                type: 'int',
                dataIndex: 'utilizationIndex'
           
            }]
        });

//************************************************ COLUMN MODEL CONFIG **************************************************************************

        var createColModel = function (finish, start) {

            var columns = [
                new Ext.grid.RowNumberer({
                    header: "<span style=font-weight:bold;><%=SLNO%></span>",
                    width: 40
                }), {
                    dataIndex: 'slnoIndex',
                    hidden: true,
                    header: "<span style=font-weight:bold;><%=SLNO%></span>",
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    dataIndex: 'groupnameIndex',
                    header: "<span style=font-weight:bold;><%=GroupName%></span>",
                    width: 50,
                    filter: {
                        type: 'string'
                    }
                }, {
                    dataIndex: 'AssetnumberIndex',
                    header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
                    filter: {
                        type: 'string'
                    }
                }, {
                    dataIndex: 'AssettypeIndex',
                    header: "<span style=font-weight:bold;><%=AssetType%></span>",
                    filter: {
                        type: 'string'
                    }
                }, {
                    dataIndex: 'AssetmodelIndex',
                    header: "<span style=font-weight:bold;><%=AssetModel%></span>",
                    filter: {
                        type: 'string'
                    }
                }, {
                    dataIndex: 'selecteddaysIndex',
                    header: "<span style=font-weight:bold;><%=SelectedDays%></span>",
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    dataIndex: 'workingdaysIndex',
                    header: "<span style=font-weight:bold;><%=WorkingDays%></span>",
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    dataIndex: 'nonworkingdaysIndex',
                    header: "<span style=font-weight:bold;><%=NonWorkingDays%></span>",
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    dataIndex: 'utilizationperdayIndex',
                    header: "<span style=font-weight:bold;><%=UtilizationInWorkingDays%></span>",
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    dataIndex: 'nonutilizationperdayIndex',
                    header: "<span style=font-weight:bold;><%=NonUtilizationInWorkingDays%></span>",
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    dataIndex: 'utilizedonnonworkinghrsIndex',
                    header: "<span style=font-weight:bold;><%=UtilizedOnNonWorkingHrs%></span>",
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    dataIndex: 'TraveltimeIndex',
                    header: "<span style=font-weight:bold;><%=TravelTime%></span>",
                    filter: {
                        type: 'float'
                    }
                }, {
                    dataIndex: 'distancetravelledIndex',
                    header: "<span style=font-weight:bold;><%=DistanceTravelled%></span>",
                    filter: {
                        type: 'float'
                    }
                }, {
                    dataIndex: 'utilizationIndex',
                    header: "<span style=font-weight:bold;><%=Utilizations%></span>",
                    filter: {
                        type: 'int'
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

//************************************************ GRID PANEL CONFIG **************************************************************************

        var grid = getGrid('<%=VehicleUtilizationDuringWorkingDaysAfterWorkingHrs%>', '<%=NoRecordsFound%>', store, screen.width - 58, 362, 16, filters, '<%=ClearFilterData%>', false, '', 10, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>');
        
        



//******************************************************* BAR CHART CONFIG FOR HIGHEST UTILIZATION *******************************************
		
		function highestUtilizationChart() {
		    var barchartgraph = new google.visualization.ColumnChart(document.getElementById('highestchartdiv'));
            var barchartdata = new google.visualization.DataTable();
            barchartdata.addColumn('string', 'Count');
            barchartdata.addColumn('number', 'Utilization(%) During Working Days After Working Hours');
            var rowdata = new Array();
            var assetNo='';
            var count=0;
  			var utilization=0;
  			var record=20;
  			var storeCount = store.getCount();
  			if (storeCount< 20)
  			{
  			record=store.getCount();
  			}
  		
 		for  (var i = 0; i < record; i++){
				var rec = store.getAt(i);
					assetNo=rec.data['AssetnumberIndex'];
					if(store.getCount()!=1 && i!=store.getCount()-1 && assetNo==store.getAt(i+1).data['AssetnumberIndex'])
						{
							utilization=parseInt(utilization)+parseInt(rec.data['utilizationIndex']);
							continue;
						}
					else if(store.getCount()!=1 && i==store.getCount()-1 && assetNo==store.getAt(i-1).data['AssetnumberIndex'])
						{
							utilization=parseInt(utilization)+parseInt(rec.data['utilizationIndex']);
						}
					else
						{
							utilization=parseInt(utilization)+parseInt(rec.data['utilizationIndex']);
						}
				rowdata.push(assetNo);
                rowdata.push(Math.round(utilization)*1);
                utilization=0;
                count++;
                }
            barchartdata.addRows(count + 1);    
            var k = 0;
            var m=0;
            var n=0;
            for (i = 0; i < count; i++) {
                for (j = 0; j <= 1; j++) {
                rowdata[k];
                	var rec = store.getAt(i);
                    barchartdata.setCell(i, j, rowdata[k]);
                    k++;
                }
            }
            count=0;
            
			var options = {
                title: 'Utilization(%) During Working Days After Working Hours',
                titleTextStyle: {
                    color: '#686262',
                    fontSize: 13
                },
                pieSliceText: "value",
                legend: {
                    position: 'right'
                },
                //colors: ['#4572A7', '#93A9CF'],
               // sliceVisibilityThreshold: 0,
                width:800,
                height: 400,
                isStacked: true,
                hAxis:{title:'Asset Number',textStyle:{fontSize: 10},titleTextStyle: { italic: false}},
                vAxis:{title:'Utilization(%)',titleTextStyle: { italic: false} }
            };
            barchartgraph.draw(barchartdata, options);
            }
            
//**************************************************** BAR CHART CONFIG FOR LOWEST UTILIZATION *****************************************************            
		
		
		function lowestUtilizationChart() {
		    var barchartgraph = new google.visualization.ColumnChart(document.getElementById('lowestchartdiv'));
            var barchartdata = new google.visualization.DataTable();
            barchartdata.addColumn('string', 'Count');
            barchartdata.addColumn('number', 'Utilization(%) During Working Days After Working Hours');
            var rowdata = new Array();
            var assetNo='';
            var count=0;
  			var utilization=0;
  			var lastTwenty = 20;

     if (store.getCount() < 20) {
     
         lastTwenty = 0;
     }
    
     if (store.getCount() > 20) {
         lastTwenty = store.getCount()-20;
     }
          for (var i = store.getCount() - 1; i >= lastTwenty; i--) {
  		
				var rec = store.getAt(i);
				assetNo=rec.data['AssetnumberIndex'];
					if(store.getCount()!=1 && i!=store.getCount()-1 && assetNo==store.getAt(i+1).data['AssetnumberIndex'])
						{
							utilization=parseInt(utilization)+parseInt(rec.data['utilizationIndex']);
							continue;
						}
					else if(store.getCount()!=1 && i==store.getCount()-1 && assetNo==store.getAt(i-1).data['AssetnumberIndex'])
						{
							utilization=parseInt(utilization)+parseInt(rec.data['utilizationIndex']);
						}
					else
						{
							utilization=parseInt(utilization)+parseInt(rec.data['utilizationIndex']);
						}
				rowdata.push(assetNo);
                rowdata.push(Math.round(utilization)*1);
                utilization=0;
                count++;
                }
            barchartdata.addRows(count + 1);    
            var k = 0;
            var m=0;
            var n=0;
            for (i = 0; i < count; i++) {
                for (j = 0; j <= 1; j++) {
                rowdata[k];
                	var rec = store.getAt(i);
                    barchartdata.setCell(i, j, rowdata[k]);
                    k++;
                }
            }
            count=0;
            
			var options = {
                title: 'Utilization(%) During Working Days After Working Hours',
                titleTextStyle: {
                    color: '#686262',
                    fontSize: 13
                },
                pieSliceText: "value",
                legend: {
                    position: 'right'
                },
                //colors: ['#4572A7', '#93A9CF'],
                sliceVisibilityThreshold: 0,
                width:800,
                height: 400,
                isStacked: false,
                hAxis:{title:'Asset Number',textStyle:{fontSize: 10},titleTextStyle: { italic: false}},
                vAxis:{title:'Utilization(%)',titleTextStyle: { italic: false} }
            };
            barchartgraph.draw(barchartdata, options);
            }
            

//********************************************************* GRID PANEL FOR GRAPH TAB ********************************************************************            
            
			var gridPannel = new Ext.Panel({
                id:'gridpannelid',
                height: 450,
                frame: true,
                cls: 'gridpanelpercentage',
                layout: 'column',
            	layoutConfig: {
                columns: 2
            	},
                items:[
                		chartCombo,{
                		 xtype:'label',
                		 text:'',
	     				 id:'',
	     				 cls: 'selectstylelan',
	     				 border:false
       					},{
                		 xtype:'panel',
	     				 id:'utilizationchartid',
	     				 border:false,
	     				 height: 500,
       	 				 html : '<table width="100%"><tr><tr> <td> <div id="highestchartdiv" align="right"> </div></td></tr></table>'
       					},
       					
       					{
                		 xtype:'panel',
	     				 id:'lowutilizationchartid',
	     				 border:false,
	     				 height: 500,
       	 				 html : '<table width="100%"><tr><tr> <td> <div id="lowestchartdiv" align="left"> </div></td></tr></table>'
       					}
                    ]
               });	
			 
         
 	
 	
 	var utilizationVehicleTabs = new Ext.TabPanel({
	    resizeTabs: false, // turn off tab resizing
	    enableTabScroll: true,
	    activeTab: 'utilizationGridTab',
	    id: 'mainTabPanelId',
	    height: 390,
	    width: screen.width-65,
	    listeners: {
	    	 'tabchange': function (tabPanel, tab) {
             Ext.getCmp('charttypeId').setValue('Highest Utilization');
             if (tab.id == 'graphTab') {
                 highestUtilizationChart();
                 Ext.getCmp('traderMaster').disable();

             }
             if (tab.id == 'utilizationGridTab') {
                 //higestUtilizationbarChart();
                 Ext.getCmp('traderMaster').enable();
                 Ext.getCmp('traderMaster').show();

             }


        	 }	
           }
	 });  

	addTab();

	function addTab() {
	   	utilizationVehicleTabs.add({
	        title: '<%=UtilizationDetails%>',
	        iconCls: 'admintab',
	        id: 'utilizationGridTab',
	        //width:'100%',
	        items: [grid]
	    	}).show();

	   	utilizationVehicleTabs.add({
	        title: '<%=UtilizationGraph%>',
	        iconCls: 'admintab',
	        autoScroll: true,
	        id: 'graphTab',
	        //width:'100%',
	        items:[gridPannel]
	    	}).show();
	  }


     Ext.onReady(function () {
            ctsb = tsb;
            Ext.QuickTips.init();
            Ext.form.Field.prototype.msgTarget = 'side';
            outerPanel = new Ext.Panel({
                title:'<%=VehicleUtilizationDuringWorkingDaysAfterWorkingHrs%>',
                renderTo: 'content',
                standardSubmit: true,
               //height:560,
                width: screen.width-24,
                frame: true,
                cls: 'mainpanelpercentage',
                items: [{
                        height: 10,
                    },
                    comboPanel, {
                        height: 10,
                    },
                    utilizationVehicleTabs
                ]
                //bbar: ctsb
            });
                

            sb = Ext.getCmp('form-statusbar');

        }); // END OF ONREADY

</script>
	</body>
</html>
