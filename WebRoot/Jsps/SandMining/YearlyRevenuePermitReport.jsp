<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
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
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session
			.getAttribute("loginInfoDetails"), session, request,
			response);
	LoginInfoBean loginInfo = (LoginInfoBean) session
			.getAttribute("loginInfoDetails");
	//getting language
	String language = loginInfo.getLanguage();
	int systemid = loginInfo.getSystemId();
	String systemID = Integer.toString(systemid);
	//getting hashmap with language specific words

	HashMap langConverted = ApplicationListener.langConverted;
	LanguageWordsBean lwb = null;
	int customeridlogged = loginInfo.getCustomerId();
	//Getting words based on language 

	String CustomerName;
	lwb = (LanguageWordsBean) langConverted.get("Customer_Name");
	if (language.equals("ar")) {
		CustomerName = lwb.getArabicWord();
	} else {
		CustomerName = lwb.getEnglishWord();
	}
	System.out.println(CustomerName);
	lwb = null;

/*String YearlyRevenuePermitReport;
lwb=(LanguageWordsBean)langConverted.get("Yearly_Revenue_Permit_Report");
if(language.equals("ar")){
	YearlyRevenuePermitReport=lwb.getArabicWord();
}else{
	YearlyRevenuePermitReport=lwb.getEnglishWord();
}
lwb=null;*/

	String selectstartdate;
	lwb = (LanguageWordsBean) langConverted.get("Start_Date");
	if (language.equals("ar")) {
		selectstartdate = lwb.getArabicWord();
	} else {
		selectstartdate = lwb.getEnglishWord();
	}
	lwb = null;

	String selectenddate;
	lwb = (LanguageWordsBean) langConverted.get("End_Date");
	if (language.equals("ar")) {
		selectenddate = lwb.getArabicWord();
	} else {
		selectenddate = lwb.getEnglishWord();
	}
	lwb = null;

	String SelectCustomer;
	lwb = (LanguageWordsBean) langConverted.get("Select_Customer");
	if (language.equals("ar")) {
		SelectCustomer = lwb.getArabicWord();
	} else {
		SelectCustomer = lwb.getEnglishWord();
	}
	lwb = null;

	String Pleaseselectcustomer;
	lwb = (LanguageWordsBean) langConverted.get("Select_Customer");
	if (language.equals("ar")) {
		Pleaseselectcustomer = lwb.getArabicWord();
	} else {
		Pleaseselectcustomer = lwb.getEnglishWord();
	}
	lwb = null;

	String Pleaseselectstartdate;
	lwb = (LanguageWordsBean) langConverted.get("Select_Start_Date");
	if (language.equals("ar")) {
		Pleaseselectstartdate = lwb.getArabicWord();
	} else {
		Pleaseselectstartdate = lwb.getEnglishWord();
	}
	lwb = null;

	String YearlyRevenuePermitReport = "Yearly Revenue Report";

	String Pleaseselectenddate;
	lwb = (LanguageWordsBean) langConverted.get("Select_End_Date");
	if (language.equals("ar")) {
		Pleaseselectenddate = lwb.getArabicWord();
	} else {
		Pleaseselectenddate = lwb.getEnglishWord();
	}
	lwb = null;

	String NoRecordsFound;
	lwb = (LanguageWordsBean) langConverted.get("No_Records_Found");
	if (language.equals("ar")) {
		NoRecordsFound = lwb.getArabicWord();
	} else {
		NoRecordsFound = lwb.getEnglishWord();
	}
	lwb = null;

	String ClearFilterData;
	lwb = (LanguageWordsBean) langConverted.get("Clear_Filter_Data");
	if (language.equals("ar")) {
		ClearFilterData = lwb.getArabicWord();
	} else {
		ClearFilterData = lwb.getEnglishWord();
	}
	lwb = null;

	String ReconfigureGrid;
	lwb = (LanguageWordsBean) langConverted.get("Reconfigure_Grid");
	if (language.equals("ar")) {
		ReconfigureGrid = lwb.getArabicWord();
	} else {
		ReconfigureGrid = lwb.getEnglishWord();
	}
	lwb = null;

	String ClearGrouping;
	lwb = (LanguageWordsBean) langConverted.get("Clear_Grouping");
	if (language.equals("ar")) {
		ClearGrouping = lwb.getArabicWord();
	} else {
		ClearGrouping = lwb.getEnglishWord();
	}
	lwb = null;

	String SLNO;
	lwb = (LanguageWordsBean) langConverted.get("SLNO");
	if (language.equals("ar")) {
		SLNO = lwb.getArabicWord();
	} else {
		SLNO = lwb.getEnglishWord();
	}
	lwb = null;

	String AssetNO;
	lwb = (LanguageWordsBean) langConverted.get("Asset_No");
	if (language.equals("ar")) {
		AssetNO = lwb.getArabicWord();
	} else {
		AssetNO = lwb.getEnglishWord();
	}
	lwb = null;

	String SandBlockName;
	lwb = (LanguageWordsBean) langConverted.get("Sand_Block_Name");
	if (language.equals("ar")) {
		SandBlockName = lwb.getArabicWord();
	} else {
		SandBlockName = lwb.getEnglishWord();
	}
	lwb = null;

	String ArrivingDateTime;
	lwb = (LanguageWordsBean) langConverted.get("Arriving_Date_Time");
	if (language.equals("ar")) {
		ArrivingDateTime = lwb.getArabicWord();
	} else {
		ArrivingDateTime = lwb.getEnglishWord();
	}
	lwb = null;

	String Excel = cf.getLabelFromDB("Excel", language);
	//String monthValidation=cf.getLabelFromDB("Month_Validation",language);
	langConverted = null;
%>




<jsp:include page="../Common/header.jsp" />
	<style>
.mystyle1 {
	margin-left: 10px;
}
</style>


	
		<title><%=YearlyRevenuePermitReport%></title>


	<div height="100%">
		<jsp:include page="../Common/ImportJSSandMining.jsp" />
		<!-- for exporting to excel***** -->
		<jsp:include page="../Common/ExportJS.jsp" />
		<% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		<style>	
			label {
				display : inline !important;
			}		
			.ext-strict .x-form-text {
				height: 21px !important;
			}			
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;							
			}
			.x-layer ul {
				min-height: 27px !important;
			}		
			.x-menu-list {
				height:auto !important;
			}

		</style>
	 <%}%>
		<script type="text/javascript" src="../../Main/Js/jsapi.js"></script>
   	<script>
    google.load("visualization", "1", {packages:["corechart"]});
        var outerPanel;
        var jspName = "YearlyRevenuePermitReport";
        var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string";
        var dtcur = datecur;
        var dtprev = dateprev;

        var customercombostore = new Ext.data.JsonStore({
            url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
            id: 'CustomerStoreId',
            root: 'CustomerRoot',
            autoLoad: true,
            remoteSort: true,
            fields: ['CustId', 'CustName'],
            listeners: {
                load: function (custstore, records, success, options) {
                    if ( <%=customeridlogged%> > 0) {
                        Ext.getCmp('CustomerNameId').setValue('<%=customeridlogged%>');
                         assetgroupcombostore.load({
                                   params:{CustId:Ext.getCmp('CustomerNameId').getValue()}, 

                    });
                    }
                }
            }
        });
         //**************************** Combo for Customer Name***************************************************
            var CustomerName = new Ext.form.ComboBox({
            store: customercombostore,
            id: 'CustomerNameId',
            mode: 'local',
            hidden: false,
            resizable: true,
            forceSelection: true,
            selectOnFocus: true,
            allowBlank: false,
            typeAhead: true,
            triggerAction: 'all',
            lazyRender: true,
            valueField: 'CustId',
            displayField: 'CustName',
            cls: 'sandselectstyle',
            listeners: {
                select: {
                    fn: function () {
                                   assetgroupcombostore.load({
                                   params:{CustId:Ext.getCmp('CustomerNameId').getValue()}, 

                    });
                }
            }}
        });
 //***************************************************** Asset Group Store***********************************************************
             var assetgroupcombostore= new Ext.data.JsonStore({
                        url:'<%=request.getContextPath()%>/CommonAction.do?param=getGroupIncludingAllOption',
                        id:'GroupStoreId',
                        root: 'GroupRoot',
                        autoLoad: false,
                        remoteSort: true,
                        fields: ['GroupId','GroupName'],
                        listeners: {
                        load: function(store, records, success, options) {
                        }
                        }
                  });
             
 
         var assetgroupcombo=new Ext.form.ComboBox({
                        store: assetgroupcombostore,
                        id:'assetgroupcomboId',
                        mode: 'local',
                        forceSelection: true,
                        selectOnFocus:true,
                        allowBlank: false,
                        anyMatch:true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        valueField: 'GroupId',
                        displayField: 'GroupName',
                        listWidth : 200,
                        cls:'sandselectstyle',
                        listeners: 
                        {
                          select: 
                            {
                              fn:function()
                                {
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
        		['2010','2010 - 2011'],
        		['2011','2011 - 2012'],
        		['2012','2012 - 2013'],
        		['2013','2013 - 2014'],
        		['2014','2014 - 2015'],
        		['2015','2015 - 2016'],
        		['2016','2016 - 2017'],
        		['2017','2017 - 2018'],
        		['2018','2018 - 2019']
        ]
        });
        
        //********************************************Combo for Year**************************************************************
		var yearListCombo = new Ext.form.ComboBox({
            store: yearliststore,
            id: 'yearlistId',
            mode: 'local',
            hidden: false,
            resizable: true,
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
                    }
                }
            }
        });
     
        var submitButton = new Ext.Button({
            text: 'Submit',
            cls: 'sandreportbutton',
            handler: function ()
            {
            if(Ext.getCmp('CustomerNameId').getValue()=='')
            {
            setMsgBoxStatus('Select Division');
            return;
            }
            
            if(Ext.getCmp('assetgroupcomboId').getValue()=='')
            {
            setMsgBoxStatus('Select Sub Division');
            return;
            }
            var startdate = new Date(Ext.getCmp('yearlistId').getValue(),3,1);
			var enddate = new Date(Ext.getCmp('yearlistId').getValue()-1+2,3,1);
				store.load({
						   params:{
						   CustID:Ext.getCmp('CustomerNameId').getValue(),
						   subdivisionId:Ext.getCmp('assetgroupcomboId').getValue(),
						   jspName:jspName,
						   startdate:startdate,
						   enddate:enddate
						   }
            });
           
            }
        });


        var comboPanel = new Ext.Panel({
            frame: false,
            layout: 'column',
            layoutConfig: {
                columns: 7
            },
            items: [ {
                    xtype: 'label',
                    text: 'Divison:',
                    cls: 'sandlblstyle'
                	},
                	CustomerName,
                	{
                    xtype: 'label',
                    text: 'Sub Divison:',
                    cls: 'sandlblstyle'
                	},
                	assetgroupcombo,
                	{
                    xtype: 'label',
                    text: 'Year:',
                    cls: 'sandlblstyle'
                	},
                	yearListCombo,
                	submitButton
            ]
        });




        var reader = new Ext.data.JsonReader({
            idProperty: 'darreaderid',
            root: 'YearlyRevenueReport',
            totalProperty: 'total',
            fields: [{
                name: 'slnoIndex'
            }, {
                name: 'subdivisionIndex'
            }, {
                name: 'sandblockIndex'
            }, {
                name: 'aprIndex'
            }, {
                name: 'mayIndex'
            }, {
                name: 'junIndex'
            }, {
                name: 'julIndex'
            }, {
                name: 'augIndex'
            }, {
                name: 'sepIndex'
            }, {
                name: 'octIndex'
            }, {
                name: 'novIndex'
            }, {
                name: 'decIndex'
            }, {
                name: 'janIndex'
            }, {
                name: 'febIndex'
            }, {
                name: 'marIndex'
            }, {
                name: 'annualrevenueIndex'
            }]
        });

         //***************************************Store Config*****************************************
        var store = new Ext.data.GroupingStore({
            autoLoad: false,
            proxy: new Ext.data.HttpProxy({
                url: '<%=request.getContextPath()%>/SandMiningAction.do?param=getYearlyRevenuePermitReport',
                method: 'POST'
            }),

            storeId: 'YearlyRevenueReportId',
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
                dataIndex: 'subdivisionIndex'
            }, {
                type: 'string',
                dataIndex: 'sandblockIndex'
            }, {
                type: 'numeric',
                dataIndex: 'aprIndex'
            } , {
                type: 'numeric',
                dataIndex: 'mayIndex'
            }, {
                type: 'numeric',
                dataIndex: 'junIndex'
            } , {
                type: 'numeric',
                dataIndex: 'julIndex'
            }, {
                type: 'numeric',
                dataIndex: 'augIndex'
            } , {
                type: 'numeric',
                dataIndex: 'sepIndex'
            }, {
                type: 'numeric',
                dataIndex: 'octIndex'
            } , {
                type: 'numeric',
                dataIndex: 'novIndex'
            }, {
                type: 'numeric',
                dataIndex: 'decIndex'
            } , {
                type: 'numeric',
                dataIndex: 'janIndex'
            }, {
                type: 'numeric',
                dataIndex: 'febIndex'
            } , {
                type: 'numeric',
                dataIndex: 'marIndex'
            }, {
                type: 'numeric',
                dataIndex: 'annualrevenueIndex'
            }]
        });

         //************************************Column Model Config******************************************
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
                    dataIndex: 'subdivisionIndex',
                    header: "<span style=font-weight:bold;>Sub Division</span>",
                    width: 50,
                    filter: {
                        type: 'string'
                    }
                }, {
                    dataIndex: 'sandblockIndex',
                    header: "<span style=font-weight:bold;>Sand Block Name</span>",
                    filter: {
                        type: 'string'
                    }
                }, {
                    dataIndex: 'aprIndex',
                    renderer: Ext.util.Format.numberRenderer('0.00'),
                    header: "<span style=font-weight:bold;>APR</span>",
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    dataIndex: 'mayIndex',
                    renderer: Ext.util.Format.numberRenderer('0.00'),
                    header: "<span style=font-weight:bold;>MAY</span>",
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    dataIndex: 'junIndex',
                    renderer: Ext.util.Format.numberRenderer('0.00'),
                    header: "<span style=font-weight:bold;>JUN</span>",
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    dataIndex: 'julIndex',
                    renderer: Ext.util.Format.numberRenderer('0.00'),
                    header: "<span style=font-weight:bold;>JUL</span>",
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    dataIndex: 'augIndex',
                    renderer: Ext.util.Format.numberRenderer('0.00'),
                    header: "<span style=font-weight:bold;>AUG</span>",
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    dataIndex: 'sepIndex',
                    renderer: Ext.util.Format.numberRenderer('0.00'),
                    header: "<span style=font-weight:bold;>SEP</span>",
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    dataIndex: 'octIndex',
                    renderer: Ext.util.Format.numberRenderer('0.00'),
                    header: "<span style=font-weight:bold;>OCT</span>",
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    dataIndex: 'novIndex',
                    renderer: Ext.util.Format.numberRenderer('0.00'),
                    header: "<span style=font-weight:bold;>NOV</span>",
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    dataIndex: 'decIndex',
                    renderer: Ext.util.Format.numberRenderer('0.00'),
                    header: "<span style=font-weight:bold;>DEC</span>",
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    dataIndex: 'janIndex',
                    renderer: Ext.util.Format.numberRenderer('0.00'),
                    header: "<span style=font-weight:bold;>JAN</span>",
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    dataIndex: 'febIndex',
                    renderer: Ext.util.Format.numberRenderer('0.00'),
                    header: "<span style=font-weight:bold;>FEB</span>",
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    dataIndex: 'marIndex',
                    renderer: Ext.util.Format.numberRenderer('0.00'),
                    header: "<span style=font-weight:bold;>MAR</span>",
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    dataIndex: 'annualrevenueIndex',
                    renderer: Ext.util.Format.numberRenderer('0.00'),
                    header: "<span style=font-weight:bold;>Annual Revenue</span>",
                    filter: {
                        type: 'numeric' 
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

         //*******************************************Grid Panel Config***************************************

        var grid = getGrid('<%=YearlyRevenuePermitReport%>', '<%=NoRecordsFound%>', store, screen.width-50, 400, 17, filters, '<%=ClearFilterData%>', true, '<%=ReconfigureGrid%>', 10, true, '<%=ClearGrouping%>', false, '', true, '<%=Excel%>', jspName, exportDataType, false, '');


		function getStartDate(month,year)
		{
			var startdate = new Date();
			startdate.setDate(01);
			startdate.setMonth(month+2);
			startdate.setYear(year);
			startdate.setHours(0,0,0,0);
			alert(startdate);
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
			alert(enddate);
			return enddate;
		}


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
		
		function revenuePieChart() {        	
  	 		var data = new google.visualization.DataTable();
  			var subdivision='';
  	        var prevsubdivision=false;
  		    var amount=0;
			data.addColumn('string', 'Sub Division');
			data.addColumn('number', 'Revenue(Rs)'); 
		    data.addRows(store.getCount());
			for  (var i = 0; i < store.getCount(); i++){
			var rec = store.getAt(i);
			subdivision=rec.data['subdivisionIndex'];
					if(store.getCount()!=1 && i!=store.getCount()-1 && i!=store.getCount()-2  && subdivision==store.getAt(i+1).data['subdivisionIndex'])
									{
									amount=parseFloat(amount)+parseFloat(rec.data['annualrevenueIndex']);
									continue;
									}
									else if(store.getCount()!=1 && i==store.getCount()-2 && subdivision==store.getAt(i-1).data['subdivisionIndex'])
									{
									amount=parseFloat(amount)+parseFloat(rec.data['annualrevenueIndex']);
									}
									else if(i!=store.getCount()-1)
									{
									prevsubdivision=rec.data['subdivisionIndex'];
									amount=parseFloat(amount)+parseFloat(rec.data['annualrevenueIndex']);
									}
									prevsubdivision=false;								
  									data.setCell(i,0,subdivision);
  									data.setCell(i,1,Math.round(amount)*1);
  									amount=0;
									}
  					    var vehiclestatusgraph=new google.visualization.PieChart(document.getElementById('revenuepiechratId'));
  						var options = {
  						title:'Revenue Chart',
  						titleTextStyle:{color:'#686262',fontSize:13,align:'center'},
          				pieSliceText: "value",
          				forceIFrame: true,
          				width:400,
          				height:395,
          				backgroundColor: '#E4E4E4',         				
          				legend:{position: 'bottom'},
          				//colors:['#61D961','#5757FE','#BDBDBD'],
        				};
      					vehiclestatusgraph.draw(data,options);
      					var revenuelinegraph=new google.visualization.LineChart(document.getElementById('revenuelinechratId'));
      					var revenuedata = new google.visualization.DataTable();
						var rec = store.getAt(store.getCount()-1);
						 		revenuedata.addColumn('string', 'Month');
						 		revenuedata.addColumn('number', 'Revenue(Rs)'); 
						 		revenuedata.addRows([
									['APR', parseFloat(rec.data['aprIndex'])],
									['MAY', parseFloat(rec.data['mayIndex'])],
									['JUN', parseFloat(rec.data['junIndex'])],
									['JUL', parseFloat(rec.data['julIndex'])],
									['AUG', parseFloat(rec.data['augIndex'])],
									['SEP', parseFloat(rec.data['sepIndex'])],
									['OCT', parseFloat(rec.data['octIndex'])],
									['NOV', parseFloat(rec.data['novIndex'])],
									['DEC', parseFloat(rec.data['decIndex'])],
									['JAN', parseFloat(rec.data['janIndex'])],
									['FEB', parseFloat(rec.data['febIndex'])],
									['MAR', parseFloat(rec.data['marIndex'])]
									]);	
									
						var monthlyoptions = {
  						title:'Month Revenue Chart',
  						titleTextStyle:{color:'#686262',fontSize:13,align:'center'},
          				pieSliceText: "value",
          				forceIFrame: true,
          				width:400,
          				height:395,
          				backgroundColor: '#E4E4E4',         				
          				legend:{position: 'bottom'},
        				};								 
      					revenuelinegraph.draw(revenuedata,monthlyoptions);
      					//google.visualization.events.addListener(vehiclestatusgraph, 'select', selectHandler);
                   	
}
		
			 var gridPannel = new Ext.Panel({
                id:'gridpannelid',
                height: 380,
                frame: true,
                cls: 'gridpanelpercentage',
                layout: 'column',
                layoutConfig: {
                columns: 2
            	},
                items:[ 
                		{
                		 xtype:'panel',
	     				 id:'revenuechart',
	     				 border:false,
	     				 height: 560,
       	 				 html : '<table width="100%"><tr><tr> <td> <div id="revenuepiechratId" align="left"> </div></td></tr></table>'
       					},
       					{
                		 xtype:'panel',
	     				 id:'revenielinechart',
	     				 border:false,
	     				 height: 560,
       	 				 html : '<table width="100%"><tr><tr> <td> <div id="revenuelinechratId" align="left"> </div></td></tr></table>'
       					}
                ]
            });	
            
         
 	var monthlyRevenueTabs = new Ext.TabPanel({
	    resizeTabs: false, // turn off tab resizing
	    enableTabScroll: true,
	    activeTab: 'revenueGridTab',
	    id: 'mainTabPanelId',
	    height: 430,
	    width: screen.width-40,
	    listeners: {
	    	'tabchange': function(tabPanel, tab){
            	if(tab.id == 'graphTab'){
            	revenuePieChart();
                }
             }
        }
	});

	addTab();

	function addTab() {
	   monthlyRevenueTabs.add({
	        title: 'Details',
	        iconCls: 'admintab',
	        id: 'revenueGridTab',
	        //width:'100%',
	        items: [grid]
	    }).show();

	   monthlyRevenueTabs.add({
	        title: 'Graph',
	        iconCls: 'admintab',
	        autoScroll: true,
	        id: 'graphTab',
	        items:[gridPannel]
	    }).show();
	    
	    
	}


     Ext.onReady(function () {
            Ext.QuickTips.init();
            Ext.form.Field.prototype.msgTarget = 'side';
            outerPanel = new Ext.Panel({
                title: '<%=YearlyRevenuePermitReport%>',
                renderTo: 'content',
                standardSubmit: true,
                height: 550,
                 width:screen.width-24,
                frame: true,
                cls: 'mainpanelpercentage',
                items: [{
                        height: 10,
                    },
                    comboPanel, {
                        height: 10,
                    },
                    monthlyRevenueTabs
                ]
            });
                

            sb = Ext.getCmp('form-statusbar');

        }); // END OF ONREADY

</script>
	</div>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
