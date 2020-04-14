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
	if(str.length>11){
	loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
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
	int customerId = loginInfo.getCustomerId();
	ArrayList<String> tobeConverted = new ArrayList<String>();
	
	tobeConverted.add("SLNO");
	tobeConverted.add("Contractor");
	tobeConverted.add("Sand_Block_From");
	tobeConverted.add("Stockyard_To");
	tobeConverted.add("Permit_No");
	tobeConverted.add("Contract_No");
	tobeConverted.add("Vehicle_No");
	tobeConverted.add("Quantity");
	tobeConverted.add("Printed");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Sand_Inward_Report");
	tobeConverted.add("Permit_Date");
	tobeConverted.add("Valid_From");
	tobeConverted.add("Valid_To");
	
	ArrayList<String> convertedWords = new ArrayList<String>();
	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
	
	String SLNO=convertedWords.get(0);
	String ContractorName=convertedWords.get(1);
	String SandBlockFrom=convertedWords.get(2);
	String StockyardTo=convertedWords.get(3);
	String PermitNo=convertedWords.get(4);
	String ContractNo=convertedWords.get(5);
	String VehicleNo=convertedWords.get(6);
	String Quantity=convertedWords.get(7);
	String Printed=convertedWords.get(8);
	String NoRecordsFound=convertedWords.get(9);
	String ClearFilterData=convertedWords.get(10);
	String SandInwardReport="Reconciliation Report";//convertedWords.get(11);
	String Permit=convertedWords.get(12);
	String ValidFrom=convertedWords.get(13);
	String ValidTo=convertedWords.get(14);
			
%>

<!DOCTYPE HTML>
<html>
  <head>
        <title>
            <%=SandInwardReport%>
        </title>

    </head>
    
    <body height="100%"">
       <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
		<jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else{%>
		<jsp:include page="../Common/ImportJS.jsp" /><%}%>
         <!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
        <script>
            var jspName = 'SandReconciliationReport';
            var dtcur = new Date();
       		var dtprev = dtcur;
       		dtprev.setDate(dtprev.getDate()-7);
       		 var dtcurt = new Date()
       		var startdatepassed;
       		var custId;
       		var enddatepassed;
            Ext.Ajax.timeout = 300000;
            var exportDataType = "int,int,string,string,string,string,string,string,string";
       
//-----------------*********client Store**********--------------------------------
    var clientcombostore = new Ext.data.JsonStore({
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
            }
        }
    }
});

var Client = new Ext.form.ComboBox({
    store: clientcombostore,
     hidden: true,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select Division',
    blankText: 'Select Division',
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
                custName=Ext.getCmp('custcomboId').getRawValue();
               
            }
        }
    }
});
		
		var monthComboStore = new Ext.data.SimpleStore({
    id: 'monthComboStoreId',
    autoLoad: true,
    fields: ['Name','Value'],
    data: [
        ['January',0],
        ['February',1],
        ['March',2],
        ['April',3],
        ['May',4],
        ['June',5],
        ['July',6],
        ['August',7],
        ['September',8],
        ['October', 9],
        ['November',10],
        ['December',11]
    ]
});

var monthCombo= new Ext.form.ComboBox({
    store: monthComboStore,
    id: 'monthComboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: 'Select Month',
    resizable: true,
    displayField: 'Name',
    cls: 'labelstyle',
    resizable:true,
     height: 350
}); 

  

          var customDatePanel = new Ext.Panel({
            frame: false,
            height:40,
            layout: 'table',
            layoutConfig: {
                columns:10
            },
           items: [{
	        			xtype: 'label',
						text: 'Client :',
						hidden: true,
						width : 90,
						cls: 'labelstyle'
				     },Client,{width:10},{width:60}, 
				     {
			            xtype: 'label',
			            text: 'Month' + ' :',
			            cls: 'labelstylenew',
			            id: 'monthLabelId',
			            resizable:true
			        },
			        monthCombo,{width:60},{
		            xtype: 'label',
		            text: 'Year' + ' :',
		            cls: 'labelstyle',
		            id: 'yearLabelId'
		       		 },{
		            xtype: 'numberfield',
		            cls: 'selectstylePerfect',
		            allowBlank: false,
		            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
		            blankText: 'Enter Year',
		            emptyText: 'Enter Year',
		            autoCreate: {//restricts user to 4 chars max, 
		                   tag: "input",
		                   maxlength: 4,
		                   type: "text",
		                   size: "4",
		                   autocomplete: "off"
		               },
		            labelSeparator: '',
		            allowBlank: false,
		            id: 'yearId'
		        },{width:25}
            ]
        });
        
            var submitButton = new Ext.Button({
            text: 'Submit',
            cls: 'sandreportbutton',
            handler: function ()
            {
                   
                    if (Ext.getCmp('custcomboId').getValue() == "") {
                        Ext.example.msg("Select Division");
                        return;
                    }
                    if (Ext.getCmp('monthComboId').getValue() == "") {
                        Ext.example.msg("Select Month");
                        return;
                    }
                    if (Ext.getCmp('yearId').getValue() == "") {
                        Ext.example.msg("Enter Year");
                        return;                                                                                                                                              
                    }
					store.load({
							   params:{
							   jspName:jspName,
							   custId:Ext.getCmp('custcomboId').getValue(),
							   year: Ext.getCmp('yearId').getValue(),
							   month:Ext.getCmp('monthComboId').getValue() ,
							   custName: Ext.getCmp('custcomboId').getRawValue()
							   }
	            });
	           
            }
        });
        
            var buttonPanel = new Ext.Panel({
            frame: false,
            layout: 'column',
            layoutConfig: {
                columns: 2
            },
            items: [{width:90},submitButton]
        });
        
        
        

        var mainPanel = new Ext.Panel({
          //title:' <%=SandInwardReport%>',
          width : screen.width-45,
            frame: true,
            height:40,
            layout: 'column',
    		layoutConfig: {
        				columns: 2
    		},
            items: [customDatePanel,buttonPanel]
        });
		

        //********************************* Reader Config***********************************
            var reader = new Ext.data.JsonReader({
                idProperty: 'gridrootid',
                root: 'reconciliationtroot',
                totalProperty: 'total',
                fields: [{
                        name: 'slnoIndex'
                    },{
                		name: 'idIndex'
                	},{
                		name: 'VehicleNoindex'
                	},{
                       name: 'startDateindex',
                       type: 'date'
                    },{
                       name: 'endDateindex',
                       type: 'date'
                    },{
				        name: 'noOfDaysIndex'
				    },{
				        name: 'pricePerDayIndex'
				    },{
				        name: 'totalAmountindex'
				    },{
				    	name: 'insertedDateindex'
				    }
                ]
            });
         
        
            var filters = new Ext.ux.grid.GridFilters({
                local: true,
                filters: [{
                        type: 'numeric',
                        dataIndex: 'slnoIndex'
                    },{
      					 type: 'numeric',
     					 dataIndex: 'idIndex'
   					},{
                        dataIndex: 'VehicleNoindex',
                        type: 'string'
                    },{
                        type: 'date',
                        dataIndex: 'startDateindex' 
                    },{
                        type: 'date',
                        dataIndex: 'endDateindex' 
                    }, {
				        type: 'string',
				        dataIndex: 'noOfDaysIndex'
				    },{
				        type: 'numeric',
				        dataIndex: 'totalAmountindex'
				    }, {
				        type: 'numeric',
				        dataIndex: 'pricePerDayIndex'
				    },{
				        type: 'date',
				        dataIndex: 'insertedDateindex'
				    }
                    
                ]
            });
            
                //******************************** Grid Store*************************************** 
            var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/VehicleSubscriptionAction.do?param=getReconcelationReportDetails',
                    method: 'POST'
                }),
                remoteSort: false,
                storeId: 'gridStore',
                reader: reader
            });
             //**************************** Grid Pannel Config ******************************************

            var createColModel = function (finish, start) {
                var columns = [
                    new Ext.grid.RowNumberer({
                        header: "<span style=font-weight:bold;><%=SLNO%></span>",
                        width: 60
                    }),{
                        dataIndex: 'slnoIndex',
                        hidden: true,
                        header: "<span style=font-weight:bold;><%=SLNO%></span>",
                        filter: {
                            type: 'numeric'
                        }
                    }, {
			            dataIndex: 'idIndex',
			            hidden: true,
			            header: "<span style=font-weight:bold;>ID</span>",
			            filter: {
			                type: 'numeric'
			            }
			        }, {
                        header: "<span style=font-weight:bold;>Vehicle Number</span>",
                        dataIndex: 'VehicleNoindex',
                        width:60,
                        filter: {
                            type: 'string'
                        }
                    },{
                       header: "<span style=font-weight:bold;>Start Date</span>",
                       dataIndex: 'startDateindex',
                        width: 60,
                       renderer: Ext.util.Format.dateRenderer(getDateFormat()),
                       filter: {
                           type: 'date'
                       }
                     },{
                       header: "<span style=font-weight:bold;>End Date</span>",
                       dataIndex: 'endDateindex',
                        width: 60,
                       renderer: Ext.util.Format.dateRenderer(getDateFormat()),
                       filter: {
                           type: 'date'
                       }
			           }, {
			            header: "<span style=font-weight:bold;>Number Of Days</span>",
			            dataIndex: 'noOfDaysIndex',
			            width: 100,
			            filter: {
			                type: 'string'
			            }
			        }, {
			            header: "<span style=font-weight:bold;>Price Per Day</span>",
			            dataIndex: 'pricePerDayIndex',
			            width: 100,
			            filter: {
			                type: 'numeric'
			            }
			        }, {
			            header: "<span style=font-weight:bold;>Total Amount</span>",
			            dataIndex: 'totalAmountindex',
			            width: 100,
			            filter: {
			                type: 'numeric'
			            }
			        }, {
			            header: "<span style=font-weight:bold;>Inserted Date</span>",
			            dataIndex: 'insertedDateindex',
			            width: 100,
			            hidden:true,
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
            
             //**************************** Grid Panel Config ends here**********************************
            var userGrid = getGrid('Details of <%=SandInwardReport%>', '<%=NoRecordsFound%>', store, screen.width - 45, 450, 20, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF');
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
                    width : screen.width-45,
	        		height : 540,
					cls: 'mainpanelpercentage',
                    items: [ mainPanel,userGrid ]
                });
            });
    </script>
  </body>
</html>

