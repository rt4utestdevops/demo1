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
  tobeConverted.add("Vehicle_Utilization_Summary_Report");
  tobeConverted.add("Select_Customer");
  tobeConverted.add("Select_Asset_Group");
  tobeConverted.add("Please_Select_customer");
  tobeConverted.add("Please_Select_Asset_Group");
  tobeConverted.add("Please_Select_Start_Date");
  tobeConverted.add("Please_Select_End_Date");
  tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
  tobeConverted.add("Month_Validation");
  tobeConverted.add("Customer_Name");
  tobeConverted.add("Asset_Group");
  tobeConverted.add("Start_Date");
  tobeConverted.add("Select_Start_Date");
  tobeConverted.add("End_Date");
  tobeConverted.add("Select_End_Date");
  tobeConverted.add("SLNO");
  tobeConverted.add("Group_Name");
  tobeConverted.add("Asset_Number");
  
  tobeConverted.add("Selected_Days");
  tobeConverted.add("Working_Days");
  tobeConverted.add("Non_Working_Days");
  tobeConverted.add("Utilization_During_Working_Days");
  tobeConverted.add("Utilization_During_Working_Hrs");
  tobeConverted.add("Utilization_After_Working_Hrs");
  tobeConverted.add("Utilization_During_Working_Holidays_And_Weekends");
  tobeConverted.add("Clear_Filter_Data");
  tobeConverted.add("Excel");
  tobeConverted.add("Utilization_Details");
  tobeConverted.add("Utilization_Graph");
  tobeConverted.add("No_Records_Found");
  tobeConverted.add("Asset_Type");
  tobeConverted.add("Submit");
  tobeConverted.add("Lowest_Utilization");
  tobeConverted.add("Highest_Utilization");
  tobeConverted.add("Utilization");
  tobeConverted.add("Asset_Model");
  
       
ArrayList<String> convertedWords = new ArrayList<String>();
 convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String VehicleUtilizationSummaryReport = convertedWords.get(0);
String SelectCustomer = convertedWords.get(1);
String SelectAssetGroup = convertedWords.get(2);
String PleaseselectCustomer = convertedWords.get(3);
String PleaseselectAssetGroup = convertedWords.get(4);
String Pleaseselectstartdate = convertedWords.get(5);
String Pleaseselectenddate = convertedWords.get(6);
String EndDateMustBeGreaterthanStartDate = convertedWords.get(7);
String monthValidation = convertedWords.get(8);
String CustomerName = convertedWords.get(9);
String AssetGroup = convertedWords.get(10);
String StartDate = convertedWords.get(11);
String SelectStartDate = convertedWords.get(12);
String EndDate = convertedWords.get(13);
String SelectEndDate = convertedWords.get(14);
String SLNO = convertedWords.get(15);
String GroupName = convertedWords.get(16);
String AssetNumber = convertedWords.get(17);

String SelectedDays = convertedWords.get(18);
String WorkingDays = convertedWords.get(19);
String NonWorkingDays = convertedWords.get(20);
String UtilizedDuringWorkingDays = convertedWords.get(21);
String UtilizationDuringWorkingHrs = convertedWords.get(22);
String UtilizationAfterWorkingHrs = convertedWords.get(23);
String UtilizationDuringWorkingHolidaysAndWeekends = convertedWords.get(24);
String ClearFilterData = convertedWords.get(25);
String Excel = convertedWords.get(26);
String UtilizationDetails = convertedWords.get(27);
String UtilizationGraph = convertedWords.get(28);
String NoRecordsFound= convertedWords.get(29);
String AssetType = convertedWords.get(30);
String Submit = convertedWords.get(31);
String LowestUtilization = convertedWords.get(32);
String HighestUtilization = convertedWords.get(33);
String Utilization = convertedWords.get(34);
String AssetModel = convertedWords.get(35);	
%>

<!DOCTYPE HTML>
<html class="largehtml">
 <head>
 		<title><%=VehicleUtilizationSummaryReport%></title>		
</head>	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  <body   onLoad=" refresh()">
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script type="text/javascript" src="../../Main/Js/jsapi.js"></script>
   <script>
 google.load("visualization", "1", {packages:["corechart"]});
     var outerPanel;
   var AssetNumber;
   /********************resize window event function***********************/
   Ext.EventManager.onWindowResize(function () {
       var width = '100%';
       var height = '100%';
       grid.setSize(width, height);
       outerPanel.setSize(width, height);
       outerPanel.doLayout();
   });
   
   var dtprev =datecur.add(Date.DAY, -2);
   var dtcur = datecur.add(Date.DAY, -1);
   var jspName = "VehicleUtilizationSummaryReport";
   var exportDataType = "int,string,string,string,string,int,int,int,int,int,int,int";

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
                 // alert(Ext.getCmp('custcomboId').getValue());
                   assetGroupStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                    store.load();
                    
                   Ext.getCmp('assettypecomboId').reset();
                   if(Ext.getCmp('custcomboId').getValue())
						{
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
       fields: ['groupId','groupName'],
       listeners: {
           load: function () {}
       }

   });

   
 var assetGroupCombo = new Ext.form.ComboBox({
       store: assetGroupStore,
       id: 'assettypecomboId',
       mode: 'local',
       forceSelection: true,
       emptyText: '<%=SelectAssetGroup%>',
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
                          if(Ext.getCmp('assettypecomboId').getValue())
                {
                   Ext.getCmp('utilizationGridTab').enable();
                   Ext.getCmp('utilizationGridTab').show();
                } 
                }
           }
       }
   });
   
  
		
  
    var editInfo1 = new Ext.Button({
            text: '<%=Submit%>',
            cls: 'buttonStyle',
            width: 70,
            handler: function ()

            {
                var clientName = Ext.getCmp('custcomboId').getValue();
                var startdate = Ext.getCmp('startdate').getValue();
                var enddate = Ext.getCmp('enddate').getValue();
                if (Ext.getCmp('custcomboId').getValue() == "") {
                    Ext.example.msg("<%=PleaseselectCustomer%>");
                    Ext.getCmp('custcomboId').focus();
                    return;
                }
                
                
                 if (Ext.getCmp('assettypecomboId').getValue() == "") {
                    Ext.example.msg("<%=PleaseselectAssetGroup%>");
                    Ext.getCmp('assettypecomboId').focus();
                    return;
                }

                if (Ext.getCmp('startdate').getValue() == "") {
                    Ext.example.msg("<%=Pleaseselectstartdate%>");
                    Ext.getCmp('startdate').focus();
                    return;
                }
                if (Ext.getCmp('enddate').getValue() == "") {
                    Ext.example.msg("<%=Pleaseselectenddate%>");
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
             
              
	           // alert(Ext.getCmp('assettypecomboId').getValue());
	            type=1;
                store.load({
                    params: {
                        custID: Ext.getCmp('custcomboId').getValue(),
                        startdate: Ext.getCmp('startdate').getValue(),
                        enddate: Ext.getCmp('enddate').getValue(),
                        assetGroup:Ext.getCmp('assettypecomboId').getValue(),
                        custName : Ext.getCmp('custcomboId').getRawValue(),
                        jspName: jspName,
                       type:type
                   }

                });

            }
        });

   
  var clientPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'traderMaster',
       layout: 'table',
       frame: false,
       width: screen.width - 12,
       height: 40,
       layoutConfig: {
           columns: 13
       },
       items: [{
               xtype: 'label',
               text: '<%=CustomerName%>' + ' :',
               cls: 'labelstyle',
               id: 'custnamelab'
           },
           custnamecombo, {
               width: 50
           },{
               xtype: 'label',
               text: '<%=AssetGroup%>' + ' :',
               cls: 'labelstyle',
               id: 'assetGroupId'
           }, assetGroupCombo,{width:50},
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
               value: dtprev,
               endDateField: 'enddate'
           }, {
               width: 50
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
               value: dtcur,
               maxValue:dtcur,
               startDateField: 'startdate'
           },{width: 50},
           editInfo1
       ]
   }); 
   
  var reader = new Ext.data.JsonReader({
            idProperty: 'darreaderid',
            root: 'utilizationSummaryReportRoot',
            totalProperty: 'total',
            fields: [{
                name: 'slnoIndex'
            }, {
                name: 'groupNameDataIndex'
            }, {
                name: 'assetNumberDataIndex'
            }, {
                name: 'assetTypeDataIndex'
            }, {
                name: 'assetModelDataIndex'
            }, {
                name: 'selectedDaysDataIndex'
            }, {
                name: 'workingDaysDataIndex'
            }, {
                name: 'nonWorkingDaysDataIndex'
            }, {
                name: 'UtilizationDuringWorkingDaysDataIndex'
            }, {
                name: 'UtilizationDuringWorkingHrsDataIndex'
            }, {
                name: 'UtilizationAfterWorkingHrsDataIndex'
            }, {
                name: 'UtilizationDuringWorkingHolidaysAndWeekendsDataIndex'
            }]
        });
   
   
    var store = new Ext.data.GroupingStore({
            autoLoad: false,
            proxy: new Ext.data.HttpProxy({
                url: '<%=request.getContextPath()%>/UtilizationReportsAction.do?param=getUtilizationSummaryReport',
                 method: 'POST'
            }),
            
            remoteSort: false,
            sortInfo: {field: 'UtilizationDuringWorkingHolidaysAndWeekendsDataIndex',
                       field: 'UtilizationDuringWorkingDaysDataIndex',
            direction: 'desc'
            },
            storeId: 'utilizationSummaryReportId',
            reader: reader
        });
        
               var filters = new Ext.ux.grid.GridFilters({
            local: true,
            filters: [{
                type: 'numeric',
                dataIndex: 'slnoIndex'
            }, {
                type: 'string',
                dataIndex: 'groupNameDataIndex'
            }, {
                type: 'string',
                dataIndex: 'assetNumberDataIndex'
            }, {
                type: 'string',
                dataIndex: 'assetTypeDataIndex'
            }, {
                type: 'string',
                dataIndex: 'assetModelDataIndex'
            } , {
                type: 'int',
                dataIndex: 'selectedDaysDataIndex'
            },  {
                type: 'int',
                dataIndex: 'workingDaysDataIndex'
            }, {
                type: 'int',
                dataIndex: 'nonWorkingDaysDataIndex'
            }, {
                type: 'int',
                dataIndex: 'UtilizationDuringWorkingDaysDataIndex'
            }, {
                type: 'int',
                dataIndex: 'UtilizationDuringWorkingHrsDataIndex'
            } , {
                type: 'int',
                dataIndex: 'UtilizationAfterWorkingHrsDataIndex'
            },{
                type: 'int',
                dataIndex: 'UtilizationDuringWorkingHolidaysAndWeekendsDataIndex'
            }]
        });
   
   
     var createColModel = function (finish, start) {

            var columns = [
                new Ext.grid.RowNumberer({
                    header: "<span style=font-weight:bold;><%=SLNO%></span>",
                    width:50,
                }), {
                    dataIndex: 'slnoIndex',
                    hidden: true,
                    header: "<span style=font-weight:bold;><%=SLNO%></span>",
                    width:100,
                    filter: {
                        type: 'numeric'
                    }
                },  {
                    dataIndex: 'groupNameDataIndex',
                    header: "<span style=font-weight:bold;><%=AssetGroup%></span>",
                    width:100,
                    filter: {
                        type: 'string'
                    }
                },  {
                    dataIndex: 'assetNumberDataIndex',
                    header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
                    width:100,
                    filter: {
                        type: 'string'
                    }
                },  {
                    dataIndex: 'assetTypeDataIndex',
                    header: "<span style=font-weight:bold;><%=AssetType%></span>",
                    width:100,
                    filter: {
                        type: 'string'
                    }
                 },  {
                    dataIndex: 'assetModelDataIndex',
                    header: "<span style=font-weight:bold;><%=AssetModel%></span>",
                    width:100,
                    filter: {
                        type: 'string'
                    }
                },  {
                    dataIndex: 'selectedDaysDataIndex',
                    header: "<span style=font-weight:bold;><%=SelectedDays%></span>",
                    width:100,
                    filter: {
                        type: 'int'
                    }
                },  {
                    dataIndex: 'workingDaysDataIndex',
                    header: "<span style=font-weight:bold;><%=WorkingDays%></span>",
                    width:100,
                    filter: {
                        type: 'int'
                    }
                },  {
                    dataIndex: 'nonWorkingDaysDataIndex',
                    header: "<span style=font-weight:bold;><%=NonWorkingDays%></span>",
                    width:100,
                    filter: {
                        type: 'int'
                    }
                },  {
                    dataIndex: 'UtilizationDuringWorkingDaysDataIndex',
                    header: "<span style=font-weight:bold;><%=UtilizedDuringWorkingDays%></span>",
                    width:100,
                    filter: {
                        type: 'int'
                    }
                },  {
                    dataIndex: 'UtilizationDuringWorkingHrsDataIndex',
                    header: "<span style=font-weight:bold;><%=UtilizationDuringWorkingHrs%></span>",
                    width:100,
                    filter: {
                        type: 'int'
                    }
                },{
                    dataIndex: 'UtilizationAfterWorkingHrsDataIndex',
                    header: "<span style=font-weight:bold;><%=UtilizationAfterWorkingHrs%></span>",
                    width:100,
                    filter: {
                        type: 'int'
                    }
                },  {
                    dataIndex: 'UtilizationDuringWorkingHolidaysAndWeekendsDataIndex',
                    header: "<span style=font-weight:bold;><%=UtilizationDuringWorkingHolidaysAndWeekends%></span>",
                    width:100,
                    sortable: true,
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
          
   
     var grid = getGrid('<%=VehicleUtilizationSummaryReport%>', '<%=NoRecordsFound%>', store, screen.width - 55, 362, 16, filters, '<%=ClearFilterData%>', false, '', 14, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, 'PDF');
    
    
     var charttypestore =new Ext.data.SimpleStore({
        id:'charttypeId',
        autoLoad:true,
        fields:['charttype'],
        data:[
        		
        		['Highest Utilization'],
        		['Lowest Utilization']
        ]
        });

	var chartCombo = new Ext.form.ComboBox({
            store: charttypestore,
            id: 'charttypeId',
            mode: 'local',
            hidden: false,
            resizable: true,
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
                    
                      if(this.getValue()=='<%=LowestUtilization%>')
                    {
                        Ext.getCmp('utilizationchartid').update('<table width="100%"><tr><tr> <td> <div id="utilizationchartdiv" align="left" > </div></td></tr></table>');
                    	Ext.getCmp('lowutilizationchartid').update('<table width="100%"><tr><tr> <td> <div id="lowutilizationchartdiv" align="left"> </div></td></tr></table>');
                    lowestUtilizationChart();
                    }
                    
                    
                    
                    if(this.getValue()=='<%=HighestUtilization%>')
                    {   
                     	Ext.getCmp('utilizationchartid').update('<table width="10%"><tr><tr> <td> <div id="utilizationchartdiv" align="left"> </div></td></tr></table>');
                    	Ext.getCmp('lowutilizationchartid').update('<table width="10%"><tr><tr> <td> <div id="lowutilizationchartdiv" align="left"> </div></td></tr></table>');
                    higestUtilizationbarChart();
                    }
                   
                    }
                }
            }
        });

     
  //-------------------------function for High utilization---------------------------------------  
     function higestUtilizationbarChart() {
  		var barchartrevenuegraph = new google.visualization.ColumnChart(document.getElementById('utilizationchartdiv'));
            var barchartrevenuedata = new google.visualization.DataTable();
            barchartrevenuedata.addColumn('string', 'Count');
            barchartrevenuedata.addColumn('number', 'Utilization(%) During Working Days');
            barchartrevenuedata.addColumn('number', 'Utilization(%) During Working Days(During Working Hrs)');
            barchartrevenuedata.addColumn('number', 'Utilization(%) During Working Days(After Working Hrs)');
            barchartrevenuedata.addColumn('number', 'Utilization(%) During Holidays and Weekends');
            var rowdata = new Array();
            var revenuesubdivision='';
            var count=0;
  			var revenue=0;
  			 var revenue1=0;
  			 var revenue2=0;
  			 var revenue3=0;
  			
  			var firstTwenty=20;
  			var aa=store.getCount();

  			if(aa < 20)
  			{

  			 firstTwenty=store.getCount();
  			}
 			
  			for (var i = 0; i < firstTwenty; i++){
			    //alert(firstTwenty);
				var rec = store.getAt(i);
				revenuesubdivision=rec.data['assetNumberDataIndex'];
					if(store.getCount()!=1 && i!=store.getCount()-1 && revenuesubdivision==store.getAt(i+1).data['assetNumberDataIndex'])
						{
							revenue=parseInt(revenue)+parseInt(rec.data['UtilizationDuringWorkingDaysDataIndex']);
							revenue1=parseInt(rec.data['UtilizationDuringWorkingHrsDataIndex']);
							revenue2=parseInt(rec.data['UtilizationAfterWorkingHrsDataIndex']);
							revenue3=parseInt(rec.data['UtilizationDuringWorkingHolidaysAndWeekendsDataIndex']);
							continue;
						}
						
					else if(store.getCount()!=1 && i==store.getCount()-1 && revenuesubdivision==store.getAt(i-1).data['assetNumberDataIndex'])
						{
							revenue=parseInt(revenue)+parseInt(rec.data['UtilizationDuringWorkingDaysDataIndex']);
							revenue1=parseInt(rec.data['UtilizationDuringWorkingHrsDataIndex']);
							revenue2=parseInt(rec.data['UtilizationAfterWorkingHrsDataIndex']);
							revenue3=parseInt(rec.data['UtilizationDuringWorkingHolidaysAndWeekendsDataIndex']);
						}
					else
						{
							revenue=parseInt(revenue)+parseInt(rec.data['UtilizationDuringWorkingDaysDataIndex']);
							revenue1=parseInt(rec.data['UtilizationDuringWorkingHrsDataIndex']);
							revenue2=parseInt(rec.data['UtilizationAfterWorkingHrsDataIndex']);
							revenue3=parseInt(rec.data['UtilizationDuringWorkingHolidaysAndWeekendsDataIndex']);
						}
						//alert('revenue' +revenue);
				rowdata.push(revenuesubdivision);
                rowdata.push(Math.round(revenue)*1);
                rowdata.push(Math.round(revenue1)*1);
                 rowdata.push(Math.round(revenue2)*1);
                rowdata.push(Math.round(revenue3)*1);
                revenue=0;
                count++;
                }
                
            barchartrevenuedata.addRows(count + 1);    
            var k = 0;
            var m=0;
            var n=0;
            for (i = 0; i < count; i++) {
                for (j = 0; j <= 4; j++) {
                rowdata[k];
                	var rec = store.getAt(i);
                    barchartrevenuedata.setCell(i, j, rowdata[k]);
                    k++;
                }
            }
            count=0;
	var options = {
                title: '<%=VehicleUtilizationSummaryReport%>',
                titleTextStyle: {
                    color: '#686262',
                    fontSize: 12
                },
                pieSliceText: "value",
                legend: {
                    position: 'right',
                    textStyle: {color: 'black', fontSize: 11}
                },
                //colors: ['#4572A7', '#93A9CF'],
               // sliceVisibilityThreshold: 0,
                width:900,
                height: 350,
                isStacked: false,
                //vAxis:{minValue:0,maxValue:10,gridlines:{count:12}},
                vAxis:{title: '<%=Utilization%>',textStyle:{fontSize:11}},
                hAxis: {title: '<%=AssetNumber%>',textStyle: {color: 'black',fontSize:10}}
            }; 
            barchartrevenuegraph.draw(barchartrevenuedata, options);
             }
  
 //-------------------------function for low utilization--------------------------------------- 
    function lowestUtilizationChart() {
    		var barchartrevenuegraph = new google.visualization.ColumnChart(document.getElementById('lowutilizationchartdiv'));
            var barchartrevenuedata = new google.visualization.DataTable();
            barchartrevenuedata.addColumn('string', 'Count');
     		barchartrevenuedata.addColumn('number', 'Utilization(%) During Working Days');
            barchartrevenuedata.addColumn('number', 'Utilization(%) During Working Days(During Working Hrs)');
            barchartrevenuedata.addColumn('number', 'Utilization(%) During Working Days(After Working Hrs)');
            barchartrevenuedata.addColumn('number', 'Utilization(%) During Holidays and Weekends');	
            
            var rowdata = new Array();
            var revenuesubdivision='';
            var count=0;
  			var revenue=0;
  			var lastTwenty=20;
  			 var revenue1=0;
  			 var revenue2=0;
  			 var revenue3=0;
  			
  			if(store.getCount()<20)
  			{
  			lastTwenty=0;
  			}
  			//alert(store.getCount()+' '+lastTwenty);
  			if(store.getCount()>20)
  			{
  			lastTwenty=store.getCount()-20;
  			}
			for  (var i = store.getCount()-1; i >= lastTwenty; i--){
			    //alert('in for'+i);
				var rec = store.getAt(i);
				//alert(i+'-'+rec.data['utilizationPersentDataIndex']);
				revenuesubdivision=rec.data['assetNumberDataIndex'];
					if(store.getCount()!=1 && i!=store.getCount()-1 && revenuesubdivision==store.getAt(i+1).data['assetNumberDataIndex'])
						{
							revenue=parseInt(revenue)+parseInt(rec.data['UtilizationDuringWorkingDaysDataIndex']);
							revenue1=parseInt(rec.data['UtilizationDuringWorkingHrsDataIndex']);
							revenue2=parseInt(rec.data['UtilizationAfterWorkingHrsDataIndex']);
							revenue3=parseInt(rec.data['UtilizationDuringWorkingHolidaysAndWeekendsDataIndex']);
							continue;
						}
					else if(store.getCount()!=1 && i==store.getCount()-1 && revenuesubdivision==store.getAt(i-1).data['assetNumberDataIndex'])
						{
							revenue=parseInt(revenue)+parseInt(rec.data['UtilizationDuringWorkingDaysDataIndex']);
							revenue1=parseInt(rec.data['UtilizationDuringWorkingHrsDataIndex']);
							revenue2=parseInt(rec.data['UtilizationAfterWorkingHrsDataIndex']);
							revenue3=parseInt(rec.data['UtilizationDuringWorkingHolidaysAndWeekendsDataIndex']);
						}
					else
						{
							revenue=parseInt(revenue)+parseInt(rec.data['UtilizationDuringWorkingDaysDataIndex']);
							revenue1=parseInt(rec.data['UtilizationDuringWorkingHrsDataIndex']);
							revenue2=parseInt(rec.data['UtilizationAfterWorkingHrsDataIndex']);
							revenue3=parseInt(rec.data['UtilizationDuringWorkingHolidaysAndWeekendsDataIndex']);
						}
				rowdata.push(revenuesubdivision);
                rowdata.push(Math.round(revenue)*1);
                rowdata.push(Math.round(revenue1)*1);
                rowdata.push(Math.round(revenue2)*1);
                rowdata.push(Math.round(revenue3)*1);
                revenue=0;
                count++;
                }
            barchartrevenuedata.addRows(count + 1);    
            var k = 0;
            var m=0;
            var n=0;
            for (i = 0; i < count; i++) {
                for (j = 0; j <=4; j++) {
                rowdata[k];
                	var rec = store.getAt(i);
                    barchartrevenuedata.setCell(i, j, rowdata[k]);
                    k++;
                }
            }
            count=0;
			var options = {
                title: '<%=VehicleUtilizationSummaryReport%>',
                titleTextStyle: {
                    color: '#686262',
                    fontSize: 12
                },
                pieSliceText: "value",
                legend: {
                    position: 'right',
                    textStyle: {color: 'black', fontSize: 11}
                },
                //colors: ['#4572A7', '#93A9CF'],
               // sliceVisibilityThreshold: 0,
                width:900,
                height: 350,
                isStacked: false,
                //vAxis:{minValue:0,maxValue:10,gridlines:{count:12}},
                
                vAxis:{title:'<%=Utilization%>',textStyle:{fontSize:11}},
                hAxis: {title: '<%=AssetNumber%>',textStyle: {color: 'black',fontSize:10}}
            
            };
            barchartrevenuegraph.draw(barchartrevenuedata,options);
             }
  
  
  	 var gridPannel = new Ext.Panel({
                id:'gridpannelid',
                height: 430,
                //width:300,
                frame: true,
                cls: 'gridpanelpercentage',
                layout: 'column',
            	layoutConfig: {
                columns: 5
            	},
                items:[
                		chartCombo,{
                		 xtype:'label',
                		 text:'',
	     				 id:'charttypetxtid',
	     				 cls: 'selectstylelan',
	     				 border:false,
       					},
       					
                		{
                		 xtype:'panel',
	     				 id:'utilizationchartid',
	     				 border:false,
	     				 height: 400,
       	 				 html : '<table width="100%"><tr><tr> <td> <div id="utilizationchartdiv" align="left" > </div></td></tr></table>'
       					},
       					{
                		 xtype:'panel',
	     				 id:'lowutilizationchartid',
	     				 border:false,
	     				 height: 400,
       	 				 html : '<table width="100%"><tr><tr> <td> <div id="lowutilizationchartdiv" align="left"> </div></td></tr></table>'
       					}
                ]
            });	
   
   	var utilizationTabs = new Ext.TabPanel({
	    resizeTabs: false, // turn off tab resizing
	    enableTabScroll: true,
	    activeTab: 'utilizationGridTab',
	    id: 'mainTabPanelId',
	    height: 390,
	    width: screen.width-42,
	    listeners: {
	    	'tabchange': function(tabPanel, tab){
	    	Ext.getCmp('charttypeId').setValue('Highest Utilization');
            	if(tab.id == 'graphTab'){
            	higestUtilizationbarChart();
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
	   utilizationTabs.add({
	        title: '<%=UtilizationDetails%>',
	        iconCls: 'admintab',
	        id: 'utilizationGridTab',
	        //width:'100%',
	        items: [grid]
	    }).show();

	   utilizationTabs.add({
	        title: '<%=UtilizationGraph%>',
	        iconCls: 'admintab',
	        autoScroll: false,
	        id: 'graphTab',
	        //height:408px,
	        items:[gridPannel]
	    }).show();
	    
	    
	}
   
       
    Ext.onReady(function () {
       ctsb = tsb;
       Ext.QuickTips.init();
       Ext.form.Field.prototype.msgTarget = 'side';
       Ext.Ajax.timeout = 180000;
       outerPanel = new Ext.Panel({
           title: '<%=VehicleUtilizationSummaryReport%>',
           renderTo: 'content',
           standardSubmit: true,
           frame: true,
           width:screen.width-24,
           cls: 'outerpanel',
           layout: 'table',
           layoutConfig: {
               columns: 1
           },
            items: [{
                        height: 10,
                    },
                    clientPanel, {
                        height: 10,
                    },
                    utilizationTabs
                ]
                //bbar: ctsb
            });
       sb = Ext.getCmp('form-statusbar');

   });
   </script>
 </body>
</html>
   
  
   
   