<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	int systemid=Integer.parseInt(str[0].trim());
	int customerid=Integer.parseInt(str[1].trim());
	int userid=Integer.parseInt(str[2].trim());
	String clientID=request.getParameter("cutomerID");
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

	int systemid=loginInfo.getSystemId();
	String systemID=Integer.toString(systemid);
	String clientID=request.getParameter("cutomerID");
	String status=request.getParameter("status");
	
ArrayList<String> tobeConverted = new ArrayList<String>();
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Reconfigure_Grid");
	tobeConverted.add("Clear_Grouping");
	tobeConverted.add("System_Health_Details");
	tobeConverted.add("SLNO");
	tobeConverted.add("Asset_No");
	tobeConverted.add("Battey_Voltage");
	tobeConverted.add("Date_Time");
	tobeConverted.add("Location");
	tobeConverted.add("Main_Battery_Voltage");
	tobeConverted.add("Battery_Health_Status");
	tobeConverted.add("Asset_Model");
	tobeConverted.add("Status");
	tobeConverted.add("STOPPAGE_TIME_ALERT");
	
	

ArrayList<String> convertedWords = new ArrayList<String>();
 	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
	String NoRecordsFound = convertedWords.get(0);
 	String ClearFilterData = convertedWords.get(1);
 	String ReconfigureGrid = convertedWords.get(2);
 	String ClearGrouping = convertedWords.get(3);
    String SystemHealthDetails = convertedWords.get(4);
    String SLNO = convertedWords.get(5);
    String AssetNo = convertedWords.get(6);
    String BatteyVoltage = convertedWords.get(7);
    String DateTime = convertedWords.get(8);
    String Location = convertedWords.get(9);
    String MainBatteryVoltage = convertedWords.get(10);
    String BatteryHealthStatus = convertedWords.get(11);
    String AssetModel=convertedWords.get(12);
    String category=convertedWords.get(13);
    String duration=convertedWords.get(14);

%>

<!DOCTYPE HTML>
<html class="largehtml">
    
    <head>
        <title>
           <%=SystemHealthDetails%>
        </title>
    </head>
    
    <body class="largebody">
       <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
        <!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
        <script>
            var outerPanel;
            var ctsb;
            var dtprev = dateprev;
            var dtcur = datecur;

             //****************************************Export Excel********************************* 
            var jspName = "SystemHealthDetails";
            var exportDataType = "int,string,string,string,string,number,string,string,string,string";

             // **********************************Reader Config****************************************
            var reader = new Ext.data.JsonReader({
                idProperty: 'darreaderid',
                root: 'SystemHealthDetailsRoot',
                totalProperty: 'total',
                fields: [{name:'slno'
                	}, {
                        name: 'AssetNo'
                    },{
                        name: 'AssetModel'
                    },{ 
                    	name: 'batteryvoltage'
                    },{ 
                    	name: 'categoryDI'
                    },{ 
                    	name: 'durationDI'
                    }, {
                        name: 'alertdate',
						type: 'date',
                        dateFormat: getDateTimeFormat()
                    }, {
                        name: 'location'
                    }, {
                        name: 'MainBatteryVoltage'
                    },{
                        name: 'batteryhealthstatus'
                    }
                ]
            });

             //***************************************Store Config*****************************************
            var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/CommonAction.do?param=getSystemHealthDetails',
                    method: 'POST'
                }),
                remoteSort: false,
                sortInfo: {
                    field: 'alertdate',
                    direction: 'ASC'
                },
                storeId: 'darStore',
                reader: reader
            });
            
             //**********************Filter Config****************************************************
            var filters = new Ext.ux.grid.GridFilters({
                local: true,
                filters: [{
                        type: 'int',
                        dataIndex: 'slno'
                    }, {
                        type: 'string',
                        dataIndex: 'AssetNo'
                    },{
                        type: 'string',
                        dataIndex: 'AssetModel'
                    },{
                        type: 'string',
                        dataIndex: 'categoryDI'
                    },{
                        type: 'string',
                        dataIndex: 'batteryvoltage'
                    }, {
                        type: 'date',
                        dataIndex: 'alertdate'
                    }, {
                        type: 'string',
                        dataIndex: 'location'
                    }, {
                        type: 'int',
                        dataIndex: 'MainBatteryVoltage'
                    },{
                        type: 'string',
                        dataIndex: 'batteryhealthstatus'
                    }
                ]
            });

             //************************************Column Model Config******************************************
            var createColModel = function (finish, start) {

                var columns = [
                    new Ext.grid.RowNumberer({
                        header: "<span style=font-weight:bold;><%=SLNO%></span>",
                        width: 50
                    }), {
                        header: "<span style=font-weight:bold;><%=SLNO%></span>",
                        dataIndex: 'slno',
                        hidden:true,
                        filter: {
                            type: 'string'
                        }
                    },{
                        header: "<span style=font-weight:bold;><%=AssetNo%></span>",
                        dataIndex: 'AssetNo',
                        width:80,
                        filter: {
                            type: 'string'
                        }
                    },{
                        header: "<span style=font-weight:bold;><%=AssetModel%></span>",
                        dataIndex: 'AssetModel',
                        width:80,
                        filter: {
                            type: 'string'
                        }
                    },{
                        header: "<span style=font-weight:bold;><%=BatteyVoltage%></span>",
                        dataIndex: 'batteryvoltage',
                        width:80,
                        filter: {
                            type: 'string'
                        }
                    },{
                        header: "<span style=font-weight:bold;><%=category%></span>",
                        dataIndex: 'categoryDI',
                        hidden:true,
                        width:80,
                        filter: {
                            type: 'string'
                        }
                    },{
                        header: "<span style=font-weight:bold;><%=duration%></span>",
                        dataIndex: 'durationDI',
                        width:80,
                        filter: {
                            type: 'string'
                        }
                    },  {
                        header: "<span style=font-weight:bold;><%=DateTime%></span>",
                        dataIndex: 'alertdate',
                        width:80,
                        renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                        filter: {
                            type: 'date'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=Location%></span>",
                        dataIndex: 'location',
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=MainBatteryVoltage%></span>",
                        dataIndex: 'MainBatteryVoltage',
                        width:80,
                        filter: {
                            type: 'string'
                        }
                    },{ 
                        header: "<span style=font-weight:bold;><%=BatteryHealthStatus%></span>",
                        dataIndex: 'batteryhealthstatus',
                        width:80,
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

             //*******************************************Grid Panel Config***************************************

            var grid = getGrid('<%=SystemHealthDetails%>', '<%=NoRecordsFound%>', store,screen.width-40,450, 11, filters, '<%=ClearFilterData%>', false, '<%=ReconfigureGrid%>', 10, false, '<%=ClearGrouping%>', false, '',true, 'Excel', jspName, exportDataType, true, 'PDF');

             //********************************************Grid Panel Config Ends********************************
             
             //********************************************Inner Pannel Starts******************************************* 
            var buttonPanel = new Ext.Panel({
                standardSubmit: true,
                collapsible: false,
                frame:true,
                cls: 'dashboardinnerpanelgridpercentage',
                height:60,
                id: 'buttonpanel',
                layout: 'column',
                layoutConfig: {
                    columns: 14
                },
                items: [{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},
                	{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},
                	{cls:'dashboarddetailsbutton',border:false},{cls:'dashboarddetailsbutton',border:false},
                	
                    {
                        xtype: 'button',
                        text: 'Back',
                        id: 'backbuttonid',
                        cls: 'dashboarddetailsbutton',
                        listeners: {
                            click: {
                                fn: function () {
                                   window.location ="<%=request.getContextPath()%>/Jsps/Common/SystemHealth.jsp?cutomerIDPassed="+<%=clientID%>;
                                }
                            }
                        }
                    }
                ]
            }); // End of Panel	
             //***************************************Main starts from here*************************
            Ext.onReady(function () {
                ctsb = tsb;
                Ext.QuickTips.init();
                Ext.form.Field.prototype.msgTarget = 'side';
                outerPanel = new Ext.Panel({
                    renderTo: 'content',
                    standardSubmit: true,
                    frame: true,
                    height: 540,
                    width:screen.width-22,
                    cls: 'outerpanel',
                    items: [grid,buttonPanel],
                    bbar: ctsb
                });
                store.load({
                             params: {
                                      custID:<%=clientID%>,
                                      status:'<%=status%>',
                    				  jspName: jspName
                                        }
                                    });
            });
        </script>
    </body>

</html>