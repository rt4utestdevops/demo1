<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
	CommonFunctions cf = new CommonFunctions();

	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	//int customerId = loginInfo.getCustomerId();
	
	ArrayList<String> tobeConverted=new ArrayList<String>();
	tobeConverted.add("Client");
	tobeConverted.add("Select_client");
	tobeConverted.add("Asset_Delisting_Report");
	tobeConverted.add("SLNO");
	tobeConverted.add("Application_No");
	tobeConverted.add("Name_Of_Reg_Owner");
	tobeConverted.add("Permanent_Address");
	tobeConverted.add("Temporary_Address");
	tobeConverted.add("Mobile_No");
	tobeConverted.add("RTO");
	tobeConverted.add("Registration_Number");
		
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Reconfigure_Grid");
	tobeConverted.add("Clear_Grouping");
	tobeConverted.add("Excel");
	tobeConverted.add("Delisting_Date");
	tobeConverted.add("Delisting_UID");

	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
	String Client=convertedWords.get(0);
	String SelectClient=convertedWords.get(1);
	String AssetDelistingReport=convertedWords.get(2);
	String SLNO=convertedWords.get(3);
	String APPLICATIONNO=convertedWords.get(4);
	String NAMEOFREGOWNER=convertedWords.get(5);
	String PERMANENTADDRESS=convertedWords.get(6);
	String TEMPORARYADDRESS=convertedWords.get(7);
	String MOBILENO=convertedWords.get(8);
	String RTO=convertedWords.get(9);
	String Registration_Number=convertedWords.get(10);
	
	String ClearFilterData=convertedWords.get(11);
	String ReconfigureGrid=convertedWords.get(12);
	String ClearGrouping=convertedWords.get(13);
	String Excel=convertedWords.get(14);
	String DELISTINGDATE=convertedWords.get(15);
	String DELISTINGUID=convertedWords.get(16);
%>


<!DOCTYPE HTML>
<html>
 <head>
 
		<title><%=AssetDelistingReport%></title>		
	</head>	    
   <body>
   <jsp:include page="../Common/ImportJSSandMining.jsp" />
   <jsp:include page="../Common/ExportJS.jsp" />
   <style>
		 .x-toolbar-layout-ct {
			width : 1310px !important;
		}
   </style>
   <script>
   
    var jspName = "AssetDelistingReport";
    var exportDataType = "int,int,string,string,string,string,string,string,date,string";
    var grid;
    
    var reader = new Ext.data.JsonReader({
        idProperty: 'delistingRootId',
        root: 'delistingRoot',
        totalProperty: 'total',
        fields: [{
                name:'slnoIndex'
            }, {
                name:'APPLICATIONNO'
            }, {
                name:'VEHICLEREGISTRATIONNO'
            }, {
                name:'NAMEOFREGOWNER'
            }, {
                name:'PERMANENTADD'
            }, {
                name:'TEMPORARYADD'
            }, {
                name:'CONTACTNO'
            }, {
                name:'RTO'
            },{
                name:'DELISTINGDATETIME',
                type: 'date',
                dateFormat: getDateTimeFormat()
            },{
                name:'DELISTINGUID'
            }
            
          ]
    });         
    
//***************************************Store Config*****************************************
        var store = new Ext.data.GroupingStore({
            autoLoad: false,
            proxy: new Ext.data.HttpProxy({
               url: '<%=request.getContextPath()%>/SandMiningAction.do?param=getDelistingDetails',
            method: 'POST'
            }),
            storeId: 'delistingRootId',
            reader: reader
        });

    
    
    
     var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
                type:'numeric',
        		dataIndex:'slnoIndex'
        	}, {
                type: 'int',
                dataIndex: 'APPLICATIONNO'
            }, {
                type: 'string',
                dataIndex: 'VEHICLEREGISTRATIONNO'
            }, {
                type: 'string',
                dataIndex: 'NAMEOFREGOWNER'

            }, {
                type: 'string',
                dataIndex: 'PERMANENTADD'

            }, {
                type: 'string',
                dataIndex: 'TEMPORARYADD'

            }, {
                type: 'string',
                dataIndex: 'CONTACTNO'

            }, {
                type: 'string',
                dataIndex: 'RTO'

            },{
                type: 'date',
                dataIndex: 'DELISTINGDATETIME'

            },{
                type: 'string',
                dataIndex: 'DELISTINGUID'

            }
        ]
    });
    
   var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                width: 50
            }),
             {
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                filter: {
                    type: 'numeric'
                 }
            },  {
                header: "<span style=font-weight:bold;><%=APPLICATIONNO%></span>",
                dataIndex: 'APPLICATIONNO',
                filter: {
                    type: 'numeric'
                }
            },  {
                header: "<span style=font-weight:bold;><%=Registration_Number%></span>",
                dataIndex: 'VEHICLEREGISTRATIONNO',
                filter: {
                    type: 'string'
                }
            },  {
                header: "<span style=font-weight:bold;><%=NAMEOFREGOWNER%></span>",
                dataIndex: 'NAMEOFREGOWNER',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=PERMANENTADDRESS%></span>",
                dataIndex: 'PERMANENTADD',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=TEMPORARYADDRESS%></span>",
                dataIndex: 'TEMPORARYADD',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=MOBILENO%></span>",
                dataIndex: 'CONTACTNO',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=RTO%></span>",
                dataIndex: 'RTO',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=DELISTINGDATE%></span>",
                dataIndex: 'DELISTINGDATETIME',
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                filter: {
                    type: 'date'
                }
            },{
                header: "<span style=font-weight:bold;><%=DELISTINGUID%></span>",
                dataIndex: 'DELISTINGUID',
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
    
    
//*****************************************************************Grid *******************************************************************************
    grid = getGrid('<%=AssetDelistingReport%>', 'NoRecordsFound', store, screen.width - 25, 500, 24, filters, '<%=ClearFilterData%>', true, '<%=ReconfigureGrid%>', 12, true, '<%=ClearGrouping%>', false, '', true, '<%=Excel%>', jspName, exportDataType, true, 'PDF');
// ******************************************************************************************************************************************************



//****************************************************Main starts from here**************************************************************************
   Ext.namespace('Ext.ux');
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    Ext.onReady(function () {
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            renderTo: 'content',
            standardSubmit: true,
            border: false,
            cls: 'outerpanel',
            items: [grid]
        });

        sb = Ext.getCmp('form-statusbar');
        store.load({
                params:{jspName:jspName}
                });

    });
</script>
</body>
</html>  
    
    
   


