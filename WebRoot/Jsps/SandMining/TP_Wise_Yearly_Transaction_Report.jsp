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
	lwb = null;
	
	
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



		<title>Yearly TP Report</title>


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
			.mainpanelpercentage {
				height : 560px !important;
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
   		var outerPanel;
        var jspName = "SandTPYearlyPermitReport";
        var exportDataType = "int,string,string,string,string,string,string";
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
                        url:'<%=request.getContextPath()%>/Sand_TP_Report_Action.do?param=getPermitNo',
                        id:'PermitStoreId',
                        root: 'PermitNoStoreList',
                        autoLoad: false,
                        remoteSort: true,
                        fields: ['Permitid'],
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
                        valueField: 'Permitid',
                        displayField: 'Permitid',
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
        fields:['yearId'],
        data:[
        		['2016 - 2017'],
        		['2017 - 2018'],
        		['2018 - 2019'],
        		['2019 - 2020'],
        		['2020 - 2021']
        		
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
           // value:getcurrentYear(),
            valueField: 'yearId',
            displayField: 'yearId',
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
            setMsgBoxStatus('Select TP Number');
            return;
            }
            
             if(Ext.getCmp('yearlistId').getValue()=='')
            {
            setMsgBoxStatus('Select Year');
            return;
            }
            var startdate = Ext.getCmp('yearlistId').getValue();
				store.load({
						   params:{
						   CustID:Ext.getCmp('CustomerNameId').getValue(),
						   permitNo:Ext.getCmp('assetgroupcomboId').getValue(),
						   jspName:jspName,
						   year:startdate
						  
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
                    text: 'TP Number:',
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
                name: 'TpNumberIndex'
            }, {
                name: 'monthIndex'
            }, {
                name: 'approvedQtyIndex'
            }, {
                name: 'dispatchedQtyIndex'
            }, {
                name: 'remainingQtyIndex'
            }, {
                name: 'carryforwardQtyIndex'
            }]
        });

         //***************************************Store Config*****************************************
        var store = new Ext.data.GroupingStore({
            autoLoad: false,
            proxy: new Ext.data.HttpProxy({
                url: '<%=request.getContextPath()%>/Sand_TP_Report_Action.do?param=getYearlyPermitReport',
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
                dataIndex: 'TpNumberIndex'
            }, {
                type: 'string',
                dataIndex: 'monthIndex'
            }, {
                type: 'numeric',
                dataIndex: 'carryforwardQtyIndex'
            }, {
                type: 'numeric',
                dataIndex: 'approvedQtyIndex'
            } , {
                type: 'numeric',
                dataIndex: 'dispatchedQtyIndex'
            }, {
                type: 'numeric',
                dataIndex: 'remainingQtyIndex'
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
                        type: 'int'
                    }
                }, {
               		header: "<span style=font-weight:bold;>TP Number</span>",
                    dataIndex: 'TpNumberIndex',
                    width: 50,
                    filter: {
                        type: 'string'
                    }
                }, {
                    dataIndex: 'monthIndex',
                    header: "<span style=font-weight:bold;>Month</span>",
                    filter: {
                        type: 'string'
                    }
                }, {
                    dataIndex: 'carryforwardQtyIndex',
                    header: "<span style=font-weight:bold;>Carry Forward Quantity</span>",
                    filter: {
                        type: 'float'
                    }
                }, {
                    dataIndex: 'approvedQtyIndex',
                    header: "<span style=font-weight:bold;>Approved Quantity</span>",
                    filter: {
                        type: 'float'
                    }
                }, {
                    dataIndex: 'dispatchedQtyIndex',
                    header: "<span style=font-weight:bold;>Dispatched Quantity</span>",
                    filter: {
                        type: 'float'
                    }
                }, {
                    dataIndex: 'remainingQtyIndex',
                    header: "<span style=font-weight:bold;>Remaining Quantity</span>",
                    filter: {
                        type: 'float'
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

        var grid = getGrid('', '<%=NoRecordsFound%>', store, screen.width-50, 450, 17, filters, '<%=ClearFilterData%>', false, '<%=ReconfigureGrid%>', 10, false, '<%=ClearGrouping%>', false, '', true, '<%=Excel%>', jspName, exportDataType, false, '');
   	
   	
   	
      Ext.onReady(function () {
            Ext.QuickTips.init();
            Ext.form.Field.prototype.msgTarget = 'side';
            outerPanel = new Ext.Panel({
                title: 'TP Wise Yearly Transaction Report',
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
                  //  monthlyRevenueTabs
                  grid
                ]
            });
                

            sb = Ext.getCmp('form-statusbar');

        }); // END OF ONREADY  	
</script>
</div>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->