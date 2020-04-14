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
	String SandInwardReport=convertedWords.get(11);
	String Permit=convertedWords.get(12);
	String ValidFrom=convertedWords.get(13);
	String ValidTo=convertedWords.get(14);
			
%>

<jsp:include page="../Common/header.jsp" />
        <title>
            <%=SandInwardReport%>
        </title>

    
    
    <div height="100%">
       <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
		<jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else{%>
		<jsp:include page="../Common/ImportJS.jsp" /><%}%>
         <!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
		<% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		alert
		<style>			
			label {
				display : inline !important;
			}			
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}						
			.x-menu-list {
				height:auto !important;
			}				
			.x-window-tl *.x-window-header {			
				padding-top : 6px !important;
				height : 38px !important;
			}			
			.x-panel-body-noborder  {
				height : 366px !important;
			}
		</style>
	 <%}%>
	 
	 <style>
		.x-panel-body-noborder  {
				height : 366px !important;
			}
	 </style>
        <script>
            var jspName = 'SandInwardReport';
            var dtcur = datecur;
       		var dtprev = dateprev;
       		var datenxt=datenext;
       		var startdatepassed;
       		var custId;
       		var enddatepassed;
            Ext.Ajax.timeout = 300000;
            var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string";
       
       
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
						width : 90,
						cls: 'labelstyle'
				     },Client,{width:10},{width:10},{
	        			xtype: 'label',
						text: 'Start Date :',
						width : 90,
						cls: 'labelstyle'
				     },{
                        xtype: 'datefield',
                        cls: 'selectstylePerfect',
                        format: getDateFormat(),
                        id:'startdate',
                    //  disabled:true,
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
                        
                    },{width:20},{
	        			xtype: 'label',
						text: 'End Date :',
						width : 90,
						cls: 'labelstyle'
				     },
                    {
                        xtype: 'datefield',
                        cls: 'selectstylePerfect',
                        format: getDateFormat(),
                        emptyText: 'Select Date',
                    //  disabled:true,
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
                    },{width:25}
            ]
        });
        
            var submitButton = new Ext.Button({
            text: 'Submit',
            cls: 'sandreportbutton',
            handler: function ()
            {
                   startdatepassed=Ext.getCmp('startdate').getValue();
                   enddatepassed=Ext.getCmp('enddate').getValue();
                   custId = Ext.getCmp('custcomboId').getValue();
                   
                    if (Ext.getCmp('custcomboId').getValue() == "") {
                        Ext.example.msg("Select Division");
                        return;
                    }
                    if (Ext.getCmp('startdate').getValue() == "") {
                        Ext.example.msg("Select Start date");
                        return;
                    }
                    if (Ext.getCmp('enddate').getValue() == "") {
                        Ext.example.msg("Select end date");
                        return;
                    }
                   
					store.load({
							   params:{
							   jspName:jspName,
							   startdate:startdatepassed,
							   enddate:enddatepassed,
							   custId:custId
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
            items: [{width:100},submitButton]
        });
        
        
        var durartionPanel = new Ext.Panel({
            frame: false,
            height:40,
            layout: 'column',
    		layoutConfig: {
        				columns: 2
    		},
            items: [customDatePanel,buttonPanel]
        });

        var mainPanel = new Ext.Panel({
          title:'<%=SandInwardReport%>',
            frame: true,
            items: [durartionPanel]
        });
		

        //********************************* Reader Config***********************************
            var reader = new Ext.data.JsonReader({
                idProperty: 'gridrootid',
                root: 'SandInwardGridRoot',
                totalProperty: 'total',
                fields: [{
                        name: 'slnoIndex'
                    },{
                		name: 'ContractorNameDataIndex'
                	},{
                	    name: 'SandBlockFromDataIndex'
                	},{
                        name: 'StockyardToDataIndex'
                    },{
                        name: 'PermitNoDataIndex'
                    },{
                        name: 'ContractNoDataIndex'
                    },{
                        name: 'PermitDataIndex',
                        type: 'date'
                    },{
                       name: 'VehicleNoDataIndex'
                    },{
                       name: 'QuantityDataIndex' 
                    },{
                       name: 'PrintedDataIndex',
                       type: 'date'
                    },{
                       name: 'ValidFromDataIndex',
                       type: 'date'
                    },{
                       name: 'ValidToDataIndex',
                       type: 'date'
                    }
                ]
            });
             //******************************** Grid Store*************************************** 
            var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getSandInwardReport',
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
                        dataIndex: 'ContractorNameDataIndex',
                        type: 'string'
                    }, {
                        type: 'string',
                        dataIndex: 'SandBlockFromDataIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'StockyardToDataIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'PermitNoDataIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'ContractNoDataIndex'
                    }, {
                        type: 'date',
                        dataIndex: 'PermitDataIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'VehicleNoDataIndex'
                    }, {
                        type: 'numeric',
                        dataIndex: 'QuantityDataIndex' 
                    },{
                        type: 'date',
                        dataIndex: 'PrintedDataIndex' 
                    },{
                        type: 'date',
                        dataIndex: 'ValidFromDataIndex' 
                    },{
                        type: 'date',
                        dataIndex: 'ValidToDataIndex' 
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
                        header: "<span style=font-weight:bold;><%=ContractorName%></span>",
                        dataIndex: 'ContractorNameDataIndex',
                        //width:40,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=SandBlockFrom%></span>",
                        dataIndex: 'SandBlockFromDataIndex',
                        //width:30,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=StockyardTo%></span>",
                        dataIndex: 'StockyardToDataIndex',
                        //width:30,
                        filter: {
                            type: 'string'
                            }
                    }, {
                        header: "<span style=font-weight:bold;><%=PermitNo%></span>",
                        dataIndex: 'PermitNoDataIndex',
                        //width:70,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=ContractNo%></span>",
                        dataIndex: 'ContractNoDataIndex',
                        //width:40,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=Permit%></span>",
                        dataIndex: 'PermitDataIndex',
                        renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                        filter: {
                            type: 'date'
                        }
                    },{
                       header: "<span style=font-weight:bold;><%=VehicleNo%></span>",
                       dataIndex: 'VehicleNoDataIndex',
                       //width:40,
                       filter: {
                           type: 'string'
                       }
                    },{
                       header: "<span style=font-weight:bold;><%=Quantity%></span>",
                       dataIndex: 'QuantityDataIndex',
                       //width:40,
                       filter: {
                           type: 'string'
                       }
                    },{
                       header: "<span style=font-weight:bold;><%=Printed%></span>",
                       dataIndex: 'PrintedDataIndex',
                       renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                       filter: {
                           type: 'date'
                       }
                     },{
                       header: "<span style=font-weight:bold;><%=ValidFrom%></span>",
                       dataIndex: 'ValidFromDataIndex',
                       renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                       filter: {
                           type: 'date'
                       }
                     },{
                       header: "<span style=font-weight:bold;><%=ValidTo%></span>",
                       dataIndex: 'ValidToDataIndex',
                       renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
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
            var userGrid = getGrid('<%=SandInwardReport%>', '<%=NoRecordsFound%>', store, screen.width - 25, 450, 20, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF');
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
                    width : screen.width-22,
	        		height : 550,
					cls: 'mainpanelpercentage',
                    items: [ mainPanel,userGrid ]
                });
            });
    </script>
  </div>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->

