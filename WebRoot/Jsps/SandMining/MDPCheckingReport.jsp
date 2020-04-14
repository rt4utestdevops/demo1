<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
	session.setAttribute("loginInfoDetails",loginInfo);
}
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
		
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customeridlogged=loginInfo.getCustomerId();
	
	ArrayList<String> tobeConverted = new ArrayList<String>();

	tobeConverted.add("Select_Customer");
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Location");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("SLNO");
	tobeConverted.add("Group_Name");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Registration_Number");
	tobeConverted.add("Latest_Date_and_Time");
	tobeConverted.add("Latest_MDP_Issued_Date_and_Time");
	tobeConverted.add("MDP_Checking_Report");
	tobeConverted.add("Details");
	
	ArrayList<String> convertedWords = new ArrayList<String>();
	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
	
	String SelectCustomer=convertedWords.get(0);
	String CustomerName=convertedWords.get(1);
	String Location=convertedWords.get(2);
	String NoRecordsFound=convertedWords.get(3);
	String SLNO=convertedWords.get(4);
	String Group=convertedWords.get(5);
	String ClearFilterData=convertedWords.get(6);
	String RegistrationNo=convertedWords.get(7);
	String LatestDateandTime=convertedWords.get(8);
	String LatestMDPIssuedDateandTime=convertedWords.get(9);
	String MDPCheckingReport=convertedWords.get(10);;	
	String Details=convertedWords.get(11);
			
%>

<jsp:include page="../Common/header.jsp" />
        <title>
            <%=MDPCheckingReport%>
        </title>

    
    <div height="100%">
        <jsp:include page="../Common/ImportJSSandMining.jsp" />
         <!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
		<style>
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			
			label {
				display : inline !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
			}
		</style>
        <script>
            var jspName = "MDPCheckingReport";
            Ext.Ajax.timeout = 300000;
            var exportDataType = "int,string,string,string,string,string,string";
             //******************************Store for getting customer name************************
            var custmastcombostore = new Ext.data.JsonStore({
                url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
                id: 'CustomerStoreId',
                root: 'CustomerRoot',
                autoLoad: true,
                remoteSort: true,
                fields: ['CustId', 'CustName'],
                listeners: {
                    load: function (custstore, records, success, options) {
                        if ( <%= customeridlogged %> > 0) {
                            Ext.getCmp('custmastcomboId').setValue('<%=customeridlogged%>');
                            var custName1=Ext.getCmp('custmastcomboId').getRawValue();
                            store.load({
                                params: {
                                    custID: Ext.getCmp('custmastcomboId').getValue(),
                                    custName: custName1,
                                    jspName:jspName
                                		}
                                });
                        }
                    }
                }
            });
            
             //**************************** Combo for Client Name***************************************************
            var clientnamecombo = new Ext.form.ComboBox({
                store: custmastcombostore,
                id: 'custmastcomboId',
                mode: 'local',
                hidden: false,
                resizable: true,
                forceSelection: true,
                emptyText: '<%=SelectCustomer%>',
                blankText: '<%=SelectCustomer%>',
                selectOnFocus: true,
                allowBlank: false,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                valueField: 'CustId',
                height: 20,
                displayField: 'CustName',
                cls: 'selectstyle',
                listeners: {
                    select: {
                        fn: function () {
                        var custName1=Ext.getCmp('custmastcomboId').getRawValue();
                            store.load({
                                params: {
                                    custID: Ext.getCmp('custmastcomboId').getValue(),
                                    custName: custName1,
                                    jspName:jspName
                                		  }
                            });
                        }
                    }
                }
            });
            
              //************************************* Inner panel start******************************************* 
            var innerPanel = new Ext.Panel({
                standardSubmit: true,
                collapsible: false,
                //height:200,
                frame: true,
                cls: 'innerpanelsmallestpercentage',
                id: 'custMaster',
                //title:'MDP Checking',
                layout: 'table',
                layoutConfig: {
                    columns: 5
                },
                items: [{
                        xtype: 'label',
                        text: '<%=CustomerName%>' + '  :',
                        allowBlank: false,
                        hidden: false,
                        cls: 'labelstyle',
                        id: 'clientnamhidlab'
                    },
                    clientnamecombo
                ]
            }); // End of Panel	
            
             //********************************* Reader Config***********************************
            var reader = new Ext.data.JsonReader({
                idProperty: 'gridrootid',
                root: 'GridRoot',
                totalProperty: 'total',
                fields: [{
                        name: 'slnoIndex'
                    },{
                		name: 'PermitNoDataIndex'
                	},{
                	    name: 'CustomerNameDataIndex'
                	},{
                        name: 'GroupNmaeDataIndex'
                    },{
                        name: 'LocationDataIndex'
                    },{
                        name: 'LatestDateDataIndex'
                    },{
                        name: 'MDPIssuedDataIndex'
                    }
                ]
            });
             //******************************** Grid Store*************************************** 
            var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getMDPCheckingReport',
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
                        dataIndex: 'PermitNoDataIndex',
                        type: 'string'
                    }, {
                        type: 'string',
                        dataIndex: 'CustomerNameDataIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'GroupNmaeDataIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'LocationDataIndex'
                    }, {
                        type: 'date',
                        dataIndex: 'LatestDateDataIndex'
                    }, {
                        type: 'date',
                        dataIndex: 'MDPIssuedDataIndex'
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
                        header: "<span style=font-weight:bold;><%=RegistrationNo%></span>",
                        dataIndex: 'PermitNoDataIndex',
                        //width:40,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=CustomerName%></span>",
                        dataIndex: 'CustomerNameDataIndex',
                        //width:30,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=Group%></span>",
                        dataIndex: 'GroupNmaeDataIndex',
                        //width:30,
                        filter: {
                            type: 'string'
                            }
                    }, {
                        header: "<span style=font-weight:bold;><%=Location%></span>",
                        dataIndex: 'LocationDataIndex',
                        //width:70,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=LatestDateandTime%></span>",
                        dataIndex: 'LatestDateDataIndex',
                        //width:40,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=LatestMDPIssuedDateandTime%></span>",
                        dataIndex: 'MDPIssuedDataIndex',
                        //width:40,
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
            var userGrid = getGrid('<%=Details%>', '<%=NoRecordsFound%>', store, screen.width - 23, 450, 20, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF');
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
                    title: '<%=MDPCheckingReport%>',
                    renderTo: 'content',
                    standardSubmit: true,
                    width:screen.width-22,
                    autoHeight:true,
					frame: false,
                    cls: 'mainpanelpercentage',
                    items: [innerPanel,userGrid]
                });
            });
    </script>
  </div>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->

