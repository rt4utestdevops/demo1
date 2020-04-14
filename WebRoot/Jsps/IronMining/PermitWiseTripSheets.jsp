
<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
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
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
			response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		     
			 ArrayList<String> tobeConverted = new ArrayList<String>();
			 tobeConverted.add("SLNO");
			 tobeConverted.add("Select_Customer");
			 tobeConverted.add("Customer_Name");
			 tobeConverted.add("Mineral_Name");
			 tobeConverted.add("Mine_Code");
			 tobeConverted.add("Month_Year");
			 tobeConverted.add("TC_No");
			 tobeConverted.add("Generate_Report");
			 tobeConverted.add("Communication_Status");
			 tobeConverted.add("Remarks");
			 tobeConverted.add("No_Records_Found");
			 tobeConverted.add("Clear_Filter_Data");
			 tobeConverted.add("Excel");
			 
ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

		    String SLNO = convertedWords.get(0);
		    String SelectCustomer = convertedWords.get(1);
		    String CustomerName = convertedWords.get(2);
		    String MineralName=convertedWords.get(3);
		    String MineCode=convertedWords.get(4);
		    String MonthYear=convertedWords.get(5);
		    String TcNo=convertedWords.get(6);
		    String GenerateReport=convertedWords.get(7);
			String CommunicationStatus= convertedWords.get(8);
			String remarks= convertedWords.get(9);
			String NoRecordsfound= convertedWords.get(10);
			String ClearFilterData = convertedWords.get(11);
		    String Excel=convertedWords.get(12);
		    String View = "View";
		    String SelectPermit = "Select Permit";
		    String SelectType = "Select Type";
		    String ValidityDateTime ="Validity Date Time";
		    String Organization_Trader_Name = "Organization Trader Name";
		    String TCLeaseName = "TCLease Name";
		    String assetNumber = "Asset Number";
		    String TripSheetNumber = "TripSheet Number";
		    String SelectSingleRow = "Please Select Single Row";
%>

<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
    <title>Permit Wise TripSheet Report</title>
  </head>
  <body>
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		 <jsp:include page="../Common/ExportJS.jsp" />
 <script>
    //-------------------------------------------------------------------------------//
    var outerPanel;
    var jspName = "PermitWiseTripSheets";
    var json = "";
    var deductionClaimedGrid;
	var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,number,number,number,string,string,number,number,string,string,string,string,string,string,string,string,string,string";
	var exportDataType2 = "int,string,string,string,string,string,string,string,number,number,int,string";
	var buttonValue;
	
    //----------------------------------customer store---------------------------// 
    var customercombostore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
        id: 'CustomerStoreId',
        root: 'CustomerRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['CustId', 'CustName'],
        listeners: {
            load: function(custstore, records, success, options) {
                if ( <%= customerId %> > 0) {
                    Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                    custId = Ext.getCmp('custcomboId').getValue();
                    custName = Ext.getCmp('custcomboId').getRawValue();
                    permitStore.load({
                    	params:{
                    		custId: custId
                    	}
                    });
                }
            }
        }
    });

    //******************************************************************customer Combo******************************************//
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
                fn: function() {
                    custId = Ext.getCmp('custcomboId').getValue();
                    custName = Ext.getCmp('custcomboId').getRawValue();
                    permitStore.load({
                    	params:{
                    		custId: custId
                    	}
                    });
                    }
                }
            }
    });

       
     var typeStore =new Ext.data.SimpleStore({
        id: 'typeStoreId',
        autoLoad: true,
        fields: ['name','value'],
        data: [['Truck','Truck'], 
        	   ['Barge','Barge']]
    });

    var typeComboStore = new Ext.form.ComboBox({
        store: typeStore,
        id: 'typeComboStoreId',
        mode: 'local',
        forceSelection: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'value',
        emptyText: '<%=SelectType%>',
        displayField: 'name',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                    Ext.getCmp('permitComboId').reset();
                    store1.removeAll();
                    store2.removeAll();
                    if(Ext.getCmp('typeComboStoreId').getValue()=="Truck"){
                    	Grid2.hide();
						Grid1.show();
                    }else{
                    	Grid1.hide();
						Grid2.show();
                    }
                }
            }
        }
    });
    
    //----------------------------------Permit store---------------------------// 
    var permitStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/PermitWiseTripSheets.do?param=getPermits',
        id: 'permitStoreId',
        root: 'permitStoreRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['permitId', 'permitNo']
    });

    var permitCombo = new Ext.form.ComboBox({
        store: permitStore,
        id: 'permitComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectPermit%>',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'permitId',
        displayField: 'permitNo',
        cls: 'selectstylePerfect',
        listeners: {
        	select: {
                fn: function() {
                    store1.removeAll();
                    store2.removeAll();
                }
            }
         }
    });  
    //-------------------------------------------------------------------------------------------------------//
    var clientPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: '',
        layout: 'table',
        frame: true,
        width: screen.width - 20,
        height: 75,
        layoutConfig: {
            columns: 14
        },
        items: [{
                xtype: 'label',
                text: '<%=CustomerName%>' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab' 
             },{width: 5},custnamecombo,{width: 45},
               {xtype: 'label',
                text: 'Type' + ' :',
                cls: 'labelstyle',
                id: 'typelab'
            },{width: 5},typeComboStore,{width: 100},
               {xtype: 'label',
                text: 'Permit No' + ' :',
                cls: 'labelstyle',
                id: 'permitlab'
            },{width: 5},permitCombo,{width: 45},
              {xtype: 'button',
                text: '<%=View%>',
                id: 'viewId',
                cls: 'buttonwastemanagement',
                width: 50,
                listeners: {
                    click: {
                        fn: function() {
                            if (Ext.getCmp('custcomboId').getValue() == "") {
                                Ext.example.msg("<%=SelectCustomer%>");
                                Ext.getCmp('custcomboId').focus();
                                 return;
             				  }
                            if (Ext.getCmp('typeComboStoreId').getValue() == "") {
                                Ext.example.msg("<%=SelectType%>");
                   				Ext.getCmp('typeComboStoreId').focus();
                                return;
                            }

                            if (Ext.getCmp('permitComboId').getValue() == "") {
                                Ext.example.msg("<%=SelectPermit%>");
                                Ext.getCmp('permitComboId').focus();
                                return;
                            } 
                           var custName=Ext.getCmp('custcomboId').getRawValue();
                           var selectedType=Ext.getCmp('typeComboStoreId').getValue();
                           if(selectedType=="Truck"){
	                           	store1.load({
	                               params: {
	                                   CustID: Ext.getCmp('custcomboId').getValue(),
	                                   jspName: jspName,
	                                   CustName: Ext.getCmp('custcomboId').getRawValue(),
	                                   permitId: Ext.getCmp('permitComboId').getValue(),
	                                   permitNo: Ext.getCmp('permitComboId').getRawValue()
	                               }
	                           });
	                           Grid2.hide();
							   Grid1.show();
                          }else{
	                          	store2.load({
	                               params: {
	                                  CustID: Ext.getCmp('custcomboId').getValue(),
			                          jspName: jspName,
			                          CustName: Ext.getCmp('custcomboId').getRawValue(),
			                          permitId: Ext.getCmp('permitComboId').getValue(),
	                                  permitNo: Ext.getCmp('permitComboId').getRawValue()
	                               }
		                           });
	                           Grid1.hide();
							   Grid2.show();
                          }
                            
                           
                        }
                    }
                }
            }
        ]
    });
    //---------------------------------------------------Trip Sheet Generation Configuration-------------------------------------------------------//
	var reader1 = new Ext.data.JsonReader({
	     idProperty: 'tripcreationId1',
	     root: 'miningTripSheetDetailsRoot',
	     totalProperty: 'total',
	     fields: [{
	         name: 'slnoIndex'
	     }, {
	         name: 'TypeIndex'
	     }, {
	         name: 'TripSheetNumberIndex'
	     }, {
	         name: 'assetNoIndex'
	     }, {
	         name: 'tcLeaseNoIndex'
	     }, {
	         name: 'validityDateDataIndex',
	         type: 'date',
	         dateFormat: getDateTimeFormat()
	     }, {
	         name: 'gradeAndMineralIndex'
	     }, {
	         name: 'RouteIndex'
	     }, {
	         name: 'uniqueIDIndex'
	     }, {
	         name: 'tcLeaseNoIndexId'
	     }, {
	         name: 'orgNameIndex'
	     }, {
	         name: 'RouteIndexId'
	     },{
	         name: 'wbsIndex'
	     }, {
	         name: 'statusIndexId'
	     }, {
	         name: 'q1IndexId'
	     }, {
	         name: 'QuantityIndex'
	     }, {
	         name: 'netIndexId'
	     }, {
	         name: 'typedestIndex'
	     }, {
	         name: 'q2IndexId'
	     }, {
	         name: 'q3IndexId'
	     },{
	         name: 'netWghtDestIndex'
	     },{
	         name: 'wbdIndex'
	     },{
	         name: 'closingTypeDataIndex'
	     }, {
	         name: 'actualQtyIndexId'
	     }, {
	         name: 'permitIndexId'
	     }, {
	         name: 'pIdIndexId'
	     }, {
	         name: 'issuedIndexId'
	     }, {
	         name: 'closedDateIndexId'
	     },{
	         name: 'dsSourceIndex'
	     },{
	         name: 'dsdestIndex'
	     },{
	         name: 'transactnIndex'
	     },{
	         name: 'commStatus'
	     },{
	         name: 'reasonIndex'
	     }]
	 });
    var store1 = new Ext.data.GroupingStore({
       autoLoad: false,
       proxy: new Ext.data.HttpProxy({
           url: '<%=request.getContextPath()%>/PermitWiseTripSheets.do?param=getTripSheetGenerationDetails',
           method: 'POST'
       }),
       remoteSort: false,
       storeId: 'miningTripsheetDetailsStore1',
       reader: reader1
   });
    var filters1 = new Ext.ux.grid.GridFilters({
           local: true,
           filters: [{
               type: 'numeric',
               dataIndex: 'slnoIndex'
           }, {
               type: 'string',
               dataIndex: 'TypeIndex'
           }, {
               type: 'string',
               dataIndex: 'TripSheetNumberIndex'
           }, {
               type: 'string',
               dataIndex: 'assetNoIndex'
           }, {
               type: 'string',
               dataIndex: 'tcLeaseNoIndex'
           }, {
               type: 'string',
               dataIndex: 'orgNameIndex'
           }, {
               type: 'date',
               dataIndex: 'validityDateDataIndex'
           }, {
               type: 'string',
               dataIndex: 'gradeAndMineralIndex'
           }, {
               type: 'string',
               dataIndex: 'RouteIndex'
           },{
               type: 'string',
               dataIndex: 'wbsIndex'
           }, {
               type: 'string',
               dataIndex: 'statusIndexId'
           }, {
               type: 'int',
               dataIndex: 'q1IndexId'
           }, {
               type: 'int',
               dataIndex: 'QuantityIndex'
           }, {
               type: 'float',
               dataIndex: 'netIndexId'
           },{
               type: 'string',
               dataIndex: 'typedestIndex'
           }, {
               type: 'string',
               dataIndex: 'q2IndexId'
           }, {
               type: 'string',
               dataIndex: 'q3IndexId'
           },{
               type: 'float',
               dataIndex: 'netWghtDestIndex'
           },{
               type: 'string',
               dataIndex: 'wbdIndex'
           },{
               type: 'string',
               dataIndex: 'closingTypeDataIndex'
           }, {
               type: 'float',
               dataIndex: 'actualQtyIndexId'
           }, {
               type: 'int',
               dataIndex: 'permitIndexId'
           }, {
               type: 'string',
               dataIndex: 'issuedIndexId'
           }, {
               type: 'date',
               dataIndex: 'closedDateIndexId'
           },{
               type: 'string',
               dataIndex: 'dsSourceIndex'
           },{
               type: 'string',
               dataIndex: 'dsdestIndex'
           },{
               type: 'string',
               dataIndex: 'transactnIndex'
           },{
               type: 'string',
               dataIndex: 'commStatus'
           },{
               type: 'string',
               dataIndex: 'reasonIndex'
           }]
       });
    var createColModel = function(finish, start) {
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
                   header: "<span style=font-weight:bold;>Type @ S</span>",
                   dataIndex: 'TypeIndex',
                   width: 100,
                   filter: {
                       type: 'string'
                   }
               }, {
                   header: "<span style=font-weight:bold;><%=TripSheetNumber%></span>",
                   dataIndex: 'TripSheetNumberIndex',
                   width: 100,
                   filter: {
                       type: 'string'
                   }
               }, {
                   header: "<span style=font-weight:bold;><%=assetNumber%></span>",
                   dataIndex: 'assetNoIndex',
                   width: 100,
                   filter: {
                       type: 'string'
                   }
               }, {
                   header: "<span style=font-weight:bold;><%=TCLeaseName%></span>",
                   dataIndex: 'tcLeaseNoIndex',
                   width: 100,
                   filter: {
                       type: 'string'
                   }
               }, {
                   header: "<span style=font-weight:bold;><%=Organization_Trader_Name%></span>",
                   dataIndex: 'orgNameIndex',
                   //width: 80,
                   filter: {
                       type: 'string'
                   }
               }, {
                   header: "<span style=font-weight:bold;>Issued Date</span>",
                   dataIndex: 'issuedIndexId',
                   filter: {
                       type: 'string'
                   }

               }, {
                   header: "<span style=font-weight:bold;><%=ValidityDateTime%></span>",
                   dataIndex: 'validityDateDataIndex',
                   renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                   //width: 80,
                   filter: {
                       type: 'date'
                   }
               }, {
                   header: "<span style=font-weight:bold;>Grade / Type</span>",
                   dataIndex: 'gradeAndMineralIndex',
                   //width: 80,
                   filter: {
                       type: 'string'
                   }
               }, {
                   header: "<span style=font-weight:bold;>Route</span>",
                   dataIndex: 'RouteIndex',
                   //width: 80,
                   filter: {
                       type: 'string'
                   }
               },{
                   header: "<span style=font-weight:bold;>W B @S</span>",
                   dataIndex: 'wbsIndex',
                   // hidden: true,
                   //width: 80,
                   filter: {
                       type: 'string'
                   }
               }, {
                   header: "<span style=font-weight:bold;>Status</span>",
                   dataIndex: 'statusIndexId',
                   hidden: false,
                   filter: {
                       type: 'string'
                   }
               }, {
                   header: "<span style=font-weight:bold;>Tare W @ S</span>",
                   dataIndex: 'q1IndexId',
                   //width: 110,    
                   sortable: true,
                   align: 'right',
                   filter: {
                       type: 'int'
                   }
               }, {
                   header: "<span style=font-weight:bold;>Gross W @ S</span>",
                   dataIndex: 'QuantityIndex',
                   //width: 110,
                   align: 'right',
                   sortable: true,
                   filter: {
                       type: 'int'
                   }
               }, {
                   header: "<span style=font-weight:bold;>Net W @ S</span>",
                   dataIndex: 'netIndexId',
                   //width: 110,    
                   sortable: true,
                   align: 'right',
                   filter: {
                       type: 'float'
                   }
               },{
                   header: "<span style=font-weight:bold;>Type @ D</span>",
                   dataIndex: 'typedestIndex',
                   //width: 110,    
                   //hidden: true,
                   sortable: true,
                   //align: 'right',
                   filter: {
                       type: 'string'
                   }
               }, {
                   header: "<span style=font-weight:bold;>Gross W @ D</span>",
                   dataIndex: 'q2IndexId',
                   //width: 80,
                   align: 'right',
                   filter: {
                       type: 'string'
                   }
               }, {
                   header: "<span style=font-weight:bold;>Tare  W @ D</span>",
                   dataIndex: 'q3IndexId',
                   //width: 80,
                   align: 'right',
                   filter: {
                       type: 'string'
                   }
               }, {
                   header: "<span style=font-weight:bold;>Net  W @ D</span>",
                   dataIndex: 'netWghtDestIndex',
                   //width: 80,
                   align: 'right',
                   filter: {
                       type: 'float'
                   }
               },{
                   header: "<span style=font-weight:bold;>WB @ D</span>",
                   dataIndex: 'wbdIndex',
                   //hidden: true,
                   //align: 'right',
                   filter: {
                       type: 'string'
                   }
               },{
                   header: "<span style=font-weight:bold;>Closing Type</span>",
                   dataIndex: 'closingTypeDataIndex',
                   hidden:true,
                   filter: {
                       type: 'string'
                   }
               },{
                   header: "<span style=font-weight:bold;>Actual Quantity</span>",
                   dataIndex: 'actualQtyIndexId',
                   hidden: true,
                   align: 'right',
                   filter: {
                       type: 'float'
                   }
               }, {
                   header: "<span style=font-weight:bold;>Permit Id</span>",
                   dataIndex: 'permitIndexId',
                   hidden: true,
                   filter: {
                       type: 'int'
                   }

               }, {
                   header: "<span style=font-weight:bold;>Closed DateTime</span>",
                   dataIndex: 'closedDateIndexId',
                   hidden: false,
                   filter: {
                       type: 'date'
                   }

               },{
                   header: "<span style=font-weight:bold;>Source Storage Location</span>",
                   dataIndex: 'dsSourceIndex',
                   hidden: false,
                   filter: {
                       type: 'string'
                   }

               },{
                   header: "<span style=font-weight:bold;>Destination Storage Location</span>",
                   dataIndex: 'dsdestIndex',
                   hidden: false,
                   filter: {
                       type: 'string'
                   }

               },{
                   header: "<span style=font-weight:bold;>Transaction No</span>",
                   dataIndex: 'transactnIndex',
                   hidden: false,
                   filter: {
                       type: 'string'
                   }
               },{
                   header: "<span style=font-weight:bold;>Communicating Status</span>",
                   dataIndex: 'commStatus',
                   hidden: false,
                   filter: {
                       type: 'string'
                   }
               },{
                   header: "<span style=font-weight:bold;>Trip Transfer Reason</span>",
                   dataIndex: 'reasonIndex',
                   hidden: true,
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
       
    //--------------------------------------------------End Trip Sheet Generation Configuration---------------------------------------//
    //--------------------------------------------------Barge Trip Sheet Configuration---------------------------------------//
     var reader2 = new Ext.data.JsonReader({
        idProperty: 'tripcreationId2',
    	root: 'miningTripSheetDetailsRoot',
    	totalProperty: 'total',
    	fields: [{
        name: 'slnoIndex'
    	},{
        name: 'TypeIndex'
    	},{
        name: 'TripSheetNumberIndex'
    	},{
        name: 'assetNoIndex'
    	},{
        name: 'validityDateDataIndex',
          type: 'date',
  		  dateFormat: getDateTimeFormat()
        },{
    	name: 'uniqueIDIndex'
    	},{
    	name: 'statusIndexId'
    	},{
    	name: 'q1IndexId'
    	},{
    	name: 'QuantityIndex'
    	},{
    	name : 'issuedIndexId'
    	},{
    	name : 'orgIdIndex'
    	},{
    	name : 'bargeLocIndex'
    	},{
    	name : 'flagIndex'
    	},{
    	name : 'vesselNameIndex'
    	},{
    	name : 'destinationIndex'
    	},{
    	name : 'boatNote'
    	},{
    	name : 'reason'
    	},{
    	name : 'closedDateIndex'
    	},{
    	name : 'stopBLODateTimeIndexId',
    	type: 'date',
  		  dateFormat: getDateTimeFormat()
    	}
    	]
    });
    var store2 = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/PermitWiseTripSheets.do?param=getBargeTripSheetDetails',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'miningTripsheetDetailsStore2',
        reader: reader2
        });
 
    var filters2 = new Ext.ux.grid.GridFilters({
        local: true,
    	filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    	},{
    	type: 'string',
        dataIndex: 'TypeIndex'
    	},{
    	type: 'string',
        dataIndex: 'TripSheetNumberIndex'
    	},{
    	type: 'string',
        dataIndex: 'assetNoIndex'
    	},{
    	type: 'date',
        dataIndex: 'validityDateDataIndex'
    	},{
    	type: 'string',
        dataIndex: 'statusIndexId'
    	},{
        type: 'int',
        dataIndex: 'q1IndexId'
    	},{
        type: 'int',
        dataIndex: 'QuantityIndex'
    	},{
    	type : 'string',
    	dataIndex : 'issuedIndexId'
    	},{
    	type : 'int',
    	dataIndex : 'uniqueIDIndex'
    	},{
    	type:'string',
    	dataIndex : 'vesselNameIndex'
    	},{
    	type:'string',
    	dataIndex : 'destinationIndex'
    	},{
    	type:'string',
    	dataIndex : 'boatNote'
    	},{
    	type:'string',
    	dataIndex : 'reason'
    	},{
    	type: 'date',
    	dataIndex : 'closedDateIndex'
    	},{
    	type: 'date',
    	dataIndex : 'stopBLODateTimeIndexId'
    	}]
    });
 
    var createColModel2 = function (finish, start) {
        var columns = [
            new Ext.grid.RowNumberer({
        	header: "<span style=font-weight:bold;>SLNO</span>",
        	width: 50
    		}), {
        	dataIndex: 'slnoIndex',
        	width: 50,
        	hidden: true,
        	header: "<span style=font-weight:bold;><%=SLNO%></span>",
        	filter: {
            type: 'numeric'
        	}
    		}, {
        	header: "<span style=font-weight:bold;>Type</span>",
        	dataIndex: 'TypeIndex',
        	width: 100,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=TripSheetNumber%></span>",
        	dataIndex: 'TripSheetNumberIndex',
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;>Barge Name</span>",
        	dataIndex: 'assetNoIndex',
        	filter: {
            type: 'string'
        	}
    		},{
    		header: "<span style=font-weight:bold;>Issued Date</span>",
        	dataIndex: 'issuedIndexId',
        	filter: {
            type: 'string'
        	},
    		hidden :false
    		},{
    		header: "<span style=font-weight:bold;>Stop BLO DateTime</span>",
        	dataIndex: 'stopBLODateTimeIndexId',
        	renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
        	filter: {
            type: 'date'
        	},
    		hidden :true
    		},{
        	header: "<span style=font-weight:bold;><%=ValidityDateTime%></span>",
        	dataIndex: 'validityDateDataIndex',
        	renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
        	//width: 80,
        	filter: {
            type: 'date'
        	}
    		},{
        	header: "<span style=font-weight:bold;>Status</span>",
        	dataIndex: 'statusIndexId',
        	hidden :false,
        	filter: {
            type: 'string'
        	}
    		},{
    		header: "<span style=font-weight:bold;>Barge Capacity</span>",
    		dataIndex: 'QuantityIndex',
    		//width: 110,    
    		sortable: true,	
    		align: 'right',	
    		filter: {
    		type: 'int'
    		}
    		},{
    		header: "<span style=font-weight:bold;>Quantity</span>",
    		dataIndex: 'q1IndexId',
    		//width: 110,    
    		sortable: true,
    		align: 'right',		
    		filter: {
    		type: 'int'
    		}
    		},{
    		header: "<span style=font-weight:bold;>Unique Id</span>",
    		dataIndex: 'uniqueIDIndex',
			hidden : true,
    		sortable: true,		
    		filter: {
    		type: 'int'
    		}
    		},{
        	header: "<span style=font-weight:bold;>Vessel Name</span>",
        	dataIndex: 'vesselNameIndex',
        	hidden :false,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;>Destination</span>",
        	dataIndex: 'destinationIndex',
        	hidden :false,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;>Boat Note</span>",
        	dataIndex: 'boatNote',
        	hidden :false,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;>Reason</span>",
        	dataIndex: 'reason',
        	hidden :false,
        	filter: {
            type: 'string'
        	}
    		},{
    		header: "<span style=font-weight:bold;>Closed DateTime</span>",
    		dataIndex: 'closedDateIndex',
			hidden : false,
    		sortable: true,		
    		filter: {
    		type: 'date'
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
    //--------------------------------------------------Barge Grid Configuration---------------------------------------//    		
    function getBargeGrid(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,nextView,nextViewStr){
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        hidden: true,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid2',
	        colModel: createColModel2(gridnoofcols),
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        listeners: {
                render : function(grid){
                  grid.store.on('load', function(store, records, options){
                    grid.getSelectionModel().selectFirstRow();       
                  });                      
                }
               },
	        plugins: [filters],	       
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
	 grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            iconCls : 'clearfilterbutton',
	            handler: function () {
	        	grid.filters.clearFilters();
	            } 
	        }]);
	if(reconfigure){
		grid.getBottomToolbar().add([
		 '-',                            
			{
            text: reconfigurestr,
            handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
            } 
        }]);
		}
		if(group){
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:groupstr,
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
		}
		if(nextView)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:nextViewStr,
			    iconCls : '',
			    handler : function(){
			    nextWinView();

			    }    
			  }]);
		}
		if(excel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'excelbutton',
			    handler : function(){
				getordreport('xls','All',jspName,grid,exportDataType);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'pdfbutton',
			    handler : function(){
			    getordreport('pdf','All',jspName,grid,exportDataType);

			    }    
			  }]);
		}
	return grid;
	}
    		
    //---------------------------------------------------------grid-------------------------------------------//

	Grid1 = getGrid('Truck Trip Sheet Report', '<%=NoRecordsfound%>', store1, screen.width - 38, 400, 35, filters1, '<%=ClearFilterData%>', false, '', 33, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, 'PDF',false,'Add',false,'Modify',false,'',false,'',false,'Generate PDF');

	Grid2 = getBargeGrid('Barge Trip Sheet Report', '<%=NoRecordsfound%>', store2,screen.width-38,400, 20, filters2, '<%=ClearFilterData%>', false, '', 20, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType2, false, 'PDF',true,'View BLO');

    //--------------------------------------------------------------------------------------------------------//

  function nextWinView() {
  	 if (Grid2.getSelectionModel().getSelected() == null) {
          Ext.example.msg('<%=NoRecordsfound%>');
          Ext.getCmp('permitComboId').focus();
          return;
      }
      if(Grid2.getSelectionModel().getCount()>1){
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
      var custId=Ext.getCmp('custcomboId').getValue();
      var permitId=Ext.getCmp('permitComboId').getValue();
      var permitNo=Ext.getCmp('permitComboId').getRawValue();
      var selected=Grid2.getSelectionModel().getSelected();
      var bargeId=selected.get('uniqueIDIndex');
      var bargeNo=selected.get('TripSheetNumberIndex');
      openPopWin("<%=basePath%>Jsps/IronMining/TruckTripSheetReport.jsp?custId="+custId+"&permitId="+permitId+"&bargeId="+bargeId,'Barge Truck Trip Sheet Report',screen.width*0.98,screen.height*0.60);
  }
function openPopWin(url,title,width,height)
{
	popWin = new Ext.Window({
	title: title,
	autoShow : false,
	constrain : false,
	constrainHeader : false,
	resizable : false,
	maximizable : true,
	minimizable : false,
	width:width,
    height:height,
	closable : true,
	stateful : false,
	html : "<iframe style='width:100%;height:100%' src="+url+"></iframe>",
	scripts:true,
	shim : false
	});
	popWin.setPosition(10, 50);
	popWin.show();
}
    
    var mainPanel = new Ext.Panel({
        id: 'mainPanelId',
        standardSubmit: true,
        autoScroll: false,
        frame: true,
        width: screen.width - 30,
        height: 420,
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [Grid1,Grid2]
    });
  
    Ext.onReady(function() {
        outerPanel = new Ext.Panel({
            renderTo: 'content',
            standardSubmit: true,
            autoScroll: false,
            frame: true,
            border: false,
            id: 'outer',
            layout: 'table',
            width: screen.width-22,
            height: screen.height-250,
            cls: 'outerpanel',
            layoutConfig: {
                columns: 1
            },
            items: [clientPanel, mainPanel]
        });
        var cm = Grid1.getColumnModel();  
	    for (var j = 1; j < cm.getColumnCount(); j++) {
	      cm.setColumnWidth(j,150);
	    }
	    cm = Grid2.getColumnModel();  
	    for (var j = 1; j < cm.getColumnCount(); j++) {
	      cm.setColumnWidth(j,150);
	    }
    });
    
</script>
  </body>
</html>
<%}%>
