<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
LoginInfoBean loginInfo=new LoginInfoBean();
loginInfo.setSystemId(12);
loginInfo.setUserId(1);
loginInfo.setLanguage("en");
loginInfo.setZone("A");
loginInfo.setOffsetMinutes(330);
loginInfo.setCategory("India");
loginInfo.setCategoryType("South India");
loginInfo.setSystemName("T4U");
loginInfo.setCustomerId(0);
loginInfo.setUserName("t4uaccounts");
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
	session.setAttribute("loginInfoDetails",loginInfo);	
	String language="en";
	
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}
		
	ArrayList<String> tobeConverted = new ArrayList<String>();
	
	tobeConverted.add("SLNO");
	tobeConverted.add("District_Name");
	tobeConverted.add("Total_Vehicles");
	tobeConverted.add("No_GPS");
	tobeConverted.add("Communication");
	tobeConverted.add("Non_Communicating");
	tobeConverted.add("Total_MDP");
	tobeConverted.add("Quantity");
	tobeConverted.add("Total_Price");
	
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Summary_Of_SandMining_ROK_Report");
	
	ArrayList<String> convertedWords = new ArrayList<String>();
	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
	
	String SLNO=convertedWords.get(0);
	String DistrictName=convertedWords.get(1);
	String TotalVehicles=convertedWords.get(2);
	String NoGPS=convertedWords.get(3);
	String Communication=convertedWords.get(4);
	String NonCommunicating=convertedWords.get(5);
	String TotalMDP=convertedWords.get(6);
	String Quantity=convertedWords.get(7);
	String TotalPrice=convertedWords.get(8);
	String NoRecordsFound=convertedWords.get(9);
	String ClearFilterData=convertedWords.get(10);
	String SummaryOfSandMiningROKReport=convertedWords.get(11);
			
%>

<!DOCTYPE HTML>
<html>
  <head>
        <title>
            <%=SummaryOfSandMiningROKReport%>
        </title>

    </head>
    
    <body height="100%"">
        <jsp:include page="../Common/ImportJS.jsp" />
         <!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
        <script>
            var jspName = 'SummaryOfSandMiningROKReport';
            var dtcur = datecur;
       		var dtprev = dateprev;
       		var datenxt=datenext;
            Ext.Ajax.timeout = 300000;
            var exportDataType = "int,string,number,number,number,number,number,number,number";
       
            
    //***************************************************** Months Store***********************************************************
        var monthliststore =new Ext.data.SimpleStore({
        id:'monthlistId',
        autoLoad:true,
        fields:['MonthId','MonthName'],
        data:[
        		['1','Januvary'],
        		['2','Februvary'],
        		['3','March'],
        		['4','April'],
        		['5','May'],
        		['6','June'],
        		['7','July'],
        		['8','August'],
        		['9','September'],
        		['10','October'],
        		['11','November'],
        		['12','December']
        ]
        });

		//********************************************Combo for Months**************************************************************
		var monthListCombo = new Ext.form.ComboBox({
            store: monthliststore,
            id: 'monthlistId',
            mode: 'local',
            hidden: false,
            resizable: true,
            forceSelection: true,
            selectOnFocus: true,
            allowBlank: false,
            disabled:true,
            typeAhead: true,
            triggerAction: 'all',
            lazyRender: true,
            valueField: 'MonthId',
            value:getcurrentMonth(),
            displayField: 'MonthName',
            cls: 'sandselectstyle',
            listeners: {
                select: {
                    fn: function () {
					startdatepassed=getStartDate(Ext.getCmp('monthlistId').getValue(),Ext.getCmp('yearlistId').getValue());
					enddatepassed=getEndDate(Ext.getCmp('monthlistId').getValue(),Ext.getCmp('yearlistId').getValue());
                    }
                }
            }
        });
        
        //*******************************************************Year Store**********************************************************
        var yearliststore =new Ext.data.SimpleStore({
        id:'yearlistId',
        autoLoad:true,
        fields:['yearId','yearName'],
        data:[
        		['2010','2010'],
        		['2011','2011'],
        		['2012','2012'],
        		['2013','2013'],
        		['2014','2014'],
        		['2015','2015'],
        		['2016','2016'],
        		['2017','2017'],
        		['2018','2018']
        ]
        });
        
        //********************************************Combo for Year**************************************************************
		var yearListCombo = new Ext.form.ComboBox({
            store: yearliststore,
            id: 'yearlistId',
            mode: 'local',
            hidden: false,
            resizable: true,
            disabled:true,
            forceSelection: true,
            selectOnFocus: true,
            allowBlank: false,
            typeAhead: true,
            triggerAction: 'all',
            lazyRender: true,
            value:getcurrentYear(),
            valueField: 'yearId',
            displayField: 'yearName',
            cls: 'sandselectstyle',
            listeners: {
                select: {
                    fn: function () {
					startdatepassed=getStartDate(Ext.getCmp('monthlistId').getValue(),Ext.getCmp('yearlistId').getValue());
					enddatepassed=getEndDate(Ext.getCmp('monthlistId').getValue(),Ext.getCmp('yearlistId').getValue());
                    }
                }
            }
        });
        
       //************************************************************************************
        var weeklyPanel = new Ext.Panel({
            frame: false,
            height:30,
            width:185,
            layout: 'column',
            layoutConfig: {
                columns:3
            },
            items: [{
                    xtype: 'radio',
                    x: 350,
                    y: 70,
                    boxLabel: 'Week',
                    id: 'weeklyid',
                    listeners:{
		        	check:{fn:function(){
		        	getWeek(Ext.getCmp('weekdate').getValue());
		        	Ext.getCmp('customid').setValue(false);
		        	Ext.getCmp('monthlyid').setValue(false);
		        	Ext.getCmp('monthlistId').disable();
					Ext.getCmp('yearlistId').disable();
					Ext.getCmp('weekdate').enable();
					Ext.getCmp('startdate').disable();
					Ext.getCmp('enddate').disable();
					}
                    }
                    }
                    },{
                        xtype: 'datefield',
                        cls: 'selectstyle',
                        format: getDateFormat(),
                        width:250,
                        emptyText: 'Select Date',
                        enableKeyEvents: true,
                        allowBlank: false,
                        disabled:true,
                        value: dtcur,
                        maxValue: dtcur,
                        blankText: 'Select Date',
                        id: 'weekdate',
                        vtype: 'daterange',
                        startDateField: 'startdate',
                        listeners: {
              			select: function(  ){
                    		getWeek(Ext.getCmp('weekdate').getValue())
                		}
            			}
                    	}
            ]
        });
       
        var monthlyPanel = new Ext.Panel({
            frame: false,
            height:30,
            layout: 'table',
            layoutConfig: {
                columns:4
            },
            items: [{
                    xtype: 'radio',
                    x: 350,
                    y: 90,
                    boxLabel: 'Month',
                    id: 'monthlyid',
                    listeners:{
		        	check:{fn:function(){
		        	startdatepassed=getStartDate(Ext.getCmp('monthlistId').getValue(),Ext.getCmp('yearlistId').getValue());
					enddatepassed=getEndDate(Ext.getCmp('monthlistId').getValue(),Ext.getCmp('yearlistId').getValue());
					Ext.getCmp('customid').setValue(false);
		        	Ext.getCmp('weeklyid').setValue(false);
		        	Ext.getCmp('monthlistId').enable();
					Ext.getCmp('yearlistId').enable();
					Ext.getCmp('weekdate').disable();
					Ext.getCmp('startdate').disable();
					Ext.getCmp('enddate').disable();
					}
                    }
                    }
                    },monthListCombo,{width:'2%',height:10},yearListCombo
            ]
        });
        
          var customDatePanel = new Ext.Panel({
            frame: false,
            height:40,
            layout: 'table',
            layoutConfig: {
                columns:3
            },
            items: [{
                    xtype: 'radio',
                    boxLabel: 'Custom',
                    id: 'customid',
                    listeners:{
		        	check:{fn:function(){
		        	startdatepassed=Ext.getCmp('startdate').getValue();
		        	enddatepassed=Ext.getCmp('enddate').getValue();
		        	Ext.getCmp('weeklyid').setValue(false);
		        	Ext.getCmp('monthlyid').setValue(false);
		        	Ext.getCmp('monthlistId').disable();
					Ext.getCmp('yearlistId').disable();
					Ext.getCmp('weekdate').disable();
					Ext.getCmp('startdate').enable();
					Ext.getCmp('enddate').enable();
					}
                    }
                    }
                    },
                	{
                        xtype: 'datefield',
                        cls: 'selectstyle',
                        format: getDateFormat(),
                        id:'startdate',
                        disabled:true,
                        emptyText: 'Select Date',
                        value: dtprev,
                        maxValue: dtcur,
                        vtype: 'daterange',
                        endDateField: 'enddate',
                        listeners: {
              			select: function(  ){
                    		startdatepassed=Ext.getCmp('startdate').getValue()
                		}
            			}
                        
                    },
                    {
                        xtype: 'datefield',
                        cls: 'selectstyle',
                        format: getDateFormat(),
                        emptyText: 'Select Date',
                        disabled:true,
                        id: 'enddate',
                        value: dtcur,
                        maxValue: datenxt,
                        vtype: 'daterange',
                        startDateField: 'startdate',
                        listeners: {
              			select: function(  ){
                    		enddatepassed=Ext.getCmp('enddate').getValue()
                		}
            			}
                    }
            ]
        });
        
           var submitButton1 = new Ext.Button({
            text: 'Send SMS',
            cls: 'sandreportbutton',
            handler: function ()
            {
            if(validation()){
            Ext.Ajax.request({
  															url: '<%=request.getContextPath()%>/SandMiningSummaryAction.do?param=sendSMS',
															method: 'POST',
															params:
															{
																
																
															},
															success:function(response, options)
															{
			   													   alert(response.responseText);
                           										 	outerPanel.getEl().unmask();
                           										 
			   												}, // end of success
															failure: function() 
															{
															    outerPanel.getEl().unmask();
															}// end of failure
 															}); // end of Ajax
            
            
            
            
            }
            }
            });
        	
        	function validation(){
        		 if (confirm("Do You Want to Send SMS!!!") == true) {
       					return true;
    				}
    			else{
    				return false;
    			}
        	
        	}
            var submitButton = new Ext.Button({
            text: 'Submit',
            cls: 'sandreportbutton',
            handler: function ()
            {
            
	            if(Ext.getCmp('weeklyid').getValue()==false && Ext.getCmp('monthlyid').getValue()==false && Ext.getCmp('customid').getValue()==false)
	            {
	            alert("Please Check any one Radio Button");
	            return;
	            }
					store.load({
							   params:{
							   jspName:jspName,
							   startdate:startdatepassed,
							   enddate:enddatepassed
							   },
	            });
	           
            }
        });
        
<!--            var buttonPanel = new Ext.Panel({-->
<!--            frame: false,-->
<!--            layout: 'column',-->
<!--            layoutConfig: {-->
<!--                columns: 3-->
<!--            },-->
<!--            items: [submitButton,{width:200},submitButton1]-->
<!--        }); -->
<!--        -->
        
        var durartionPanel = new Ext.Panel({
            frame: false,
            height:40,
            layout: 'column',
    		layoutConfig: {
        			tableAttrs: { style: { width: '100%'  } }, 
        			columns: 9
    		},
            items: [{width:'12%',height: 5},{width:'12%',height: 5},{width:'12%',height: 5},{width:'12%',height: 5},{width:'12%',height: 5},{width:'12%',height: 5},{width:'12%',height: 5},{width:'12%',height: 5},
            weeklyPanel,monthlyPanel,{width:'1%',height: 10},customDatePanel,{width:'3%',height: 10},submitButton,{width:'3%'},submitButton1]
        });

        var mainPanel = new Ext.Panel({
          title:'<%=SummaryOfSandMiningROKReport%>',
            frame: true,
            items: [durartionPanel]
        });
		
		function getcurrentMonth()
		{
			var currentdate=new Date();
			return parseInt(currentdate.getMonth())+1;
		}
		
		function getcurrentYear()
		{
			var currentdate=new Date();
			return currentdate.getFullYear();
		}
		
		function getWeek(date)
		{
		var first = date.getDate() - date.getDay(); // First day is the day of the month - the day of the week
		var last = first + 7; // last day is the first day + 6

		var firstday = new Date(date.setDate(first));
		var lastday = new Date(date.setDate(last));
		startdatepassed=firstday;
		enddatepassed=lastday;
		//var weeknumber=22;
		//Ext.getCmp('weekdate').setValue(weeknumber);
		}
	
		function getStartDate(month,year)
		{
			var startdate = new Date();
			startdate.setDate(01);
			startdate.setMonth(month-1);
			startdate.setYear(year);
			startdate.setHours(0,0,0,0);
			
			return startdate;
		}
		
		function getEndDate(month,year)
		{
			if(month==12)
			{
			year=parseInt(year)+1;
			}
			var enddate = new Date();
			enddate.setDate(01);
			enddate.setMonth(month);
			enddate.setYear(year);
			enddate.setHours(0,0,0,0);
			
			return enddate;
		}
		
        //********************************* Reader Config***********************************
            var reader = new Ext.data.JsonReader({
                idProperty: 'gridrootid',
                root: 'GridRoot',
                totalProperty: 'total',
                fields: [{
                        name: 'slnoIndex'
                    },{
                		name: 'DistrictNameDataIndex'
                	},{
                	    name: 'TotalVehiclesDataIndex'
                	},{
                        name: 'NoGPSDataIndex'
                    },{
                        name: 'CommunicationDataIndex'
                    },{
                        name: 'NonCommunicatingDataIndex'
                    },{
                        name: 'TotalMDPDataIndex'
                    },{
                       name: 'QuantityDataIndex'
                    },{
                       name: 'TotalPriceDataIndex'
                    }
                ]
            });
             //******************************** Grid Store*************************************** 
            var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/SandMiningSummaryAction.do?param=getSandMiningSummaryReport',
                    method: 'POST'
                }),
                remoteSort: false,
                storeId: 'gridStore',
                reader: reader
            });
        
            var filters = new Ext.ux.grid.GridFilters({
                local: true,
                filters: [{
                        type: 'numeric',
                        dataIndex: 'slnoIndex'
                    },{
                        dataIndex: 'DistrictNameDataIndex',
                        type: 'string'
                    }, {
                        type: 'numeric',
                        dataIndex: 'TotalVehiclesDataIndex'
                    }, {
                        type: 'numeric',
                        dataIndex: 'NoGPSDataIndex'
                    }, {
                        type: 'numeric',
                        dataIndex: 'CommunicationDataIndex'
                    }, {
                        type: 'numeric',
                        dataIndex: 'NonCommunicatingDataIndex'
                    }, {
                        type: 'numeric',
                        dataIndex: 'TotalMDPDataIndex'
                    }, {
                        type: 'numeric',
                        dataIndex: 'QuantityDataIndex'
                    }, {
                        type: 'numeric',
                        dataIndex: 'TotalPriceDataIndex'
                    }
                    
                ]
            });
            
             //**************************** Grid Pannel Config ******************************************

            var createColModel = function (finish, start) {
                var columns = [
                    new Ext.grid.RowNumberer({
                        header: "<span style=font-weight:bold;><%=SLNO%></span>",
                        width: 40
                    }),{
                        dataIndex: 'slnoIndex',
                        hidden: true,
                        header: "<span style=font-weight:bold;><%=SLNO%></span>",
                        filter: {
                            type: 'numeric'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=DistrictName%></span>",
                        dataIndex: 'DistrictNameDataIndex',
                        //width:40,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=TotalVehicles%></span>",
                        dataIndex: 'TotalVehiclesDataIndex',
                        //width:30,
                        align: 'right',
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=NoGPS%></span>",
                        dataIndex: 'NoGPSDataIndex',
                        //width:30,
                        align: 'right',
                        filter: {
                            type: 'string'
                            }
                    }, {
                        header: "<span style=font-weight:bold;><%=Communication%></span>",
                        dataIndex: 'CommunicationDataIndex',
                        //width:70,
                        align: 'right',
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=NonCommunicating%></span>",
                        dataIndex: 'NonCommunicatingDataIndex',
                        //width:40,
                        align: 'right',
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=TotalMDP%></span>",
                        dataIndex: 'TotalMDPDataIndex',
                        //width:40,
                        align: 'right',
                        filter: {
                            type: 'string'
                        }
                    },{
                       header: "<span style=font-weight:bold;><%=Quantity%></span>",
                       dataIndex: 'QuantityDataIndex',
                       //width:40,
                       align: 'right',
                       filter: {
                           type: 'string'
                       }
                    },{
                       header: "<span style=font-weight:bold;><%=TotalPrice%></span>",
                       dataIndex: 'TotalPriceDataIndex',
                       //width:40,
                       align: 'right',
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
            
             //**************************** Grid Panel Config ends here**********************************
            var userGrid = getGrid('<%=SummaryOfSandMiningROKReport%>', '<%=NoRecordsFound%>', store, screen.width - 60, 465, 20, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF');
            userGrid.on({
                cellclick: {
                    fn: function (userGrid, rowIndex, columnIndex, e) {
                    }
                }
            });
            
          //***************************  Main starts from here **************************************************
            Ext.onReady(function () {
                Ext.QuickTips.init();
                Ext.form.Field.prototype.msgTarget = 'side';
                outerPanel = new Ext.Panel({
                    renderTo: 'content',
                    standardSubmit: true,
		  			frame:false,
		  			border:true,
                    width : screen.width-50,
	        		height : 550,
					cls: 'mainpanelpercentage',
                    items: [
                    mainPanel,
                     userGrid
                    ]
                });
            });
    </script>
  </body>
</html>
<%}%>
