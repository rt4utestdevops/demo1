<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
loginInfo.setUserName("vidwath");
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
session.setAttribute("loginInfoDetails",loginInfo);	
CommonFunctions cf=new CommonFunctions();
String language="en";
ArrayList<String> tobeConverted=new ArrayList<String>();
tobeConverted.add("Monitoring_FDAS_Report");
tobeConverted.add("LTSP");
tobeConverted.add("Customer_Name");
tobeConverted.add("Asset_No");
tobeConverted.add("Last_Caliberated_Date");
tobeConverted.add("No_of_Refuels_Entered_in_Check_List");
tobeConverted.add("No_of_Spurious_Refuel");
tobeConverted.add("No_of_Invalid_Voltages");
tobeConverted.add("No_of_Unexpected_Refuel");
tobeConverted.add("No_of_Probable_Pilfreges");
tobeConverted.add("Excel");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Reconfigure_Grid");
tobeConverted.add("Clear_Grouping");
tobeConverted.add("SLNO");
ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
String monitoringFDAS=convertedWords.get(0);
String ltspName=convertedWords.get(1);
String customerName=convertedWords.get(2);
String assetNo=convertedWords.get(3);
String daysAfterCaliberation=convertedWords.get(4);
String noofRefuel=convertedWords.get(5);
String noofSupriousRefuel=convertedWords.get(6);
String noofInvalidVoltage=convertedWords.get(7);
String noofUnexpectedRefuel=convertedWords.get(8);
String noofProbablePilfreges=convertedWords.get(9);
String Excel=convertedWords.get(10);
String NoRecordsFound=convertedWords.get(11);
String ClearFilterData=convertedWords.get(12);
String ReconfigureGrid=convertedWords.get(13);
String ClearGrouping=convertedWords.get(14);
String SLNO=convertedWords.get(15);
%>




<!DOCTYPE HTML>
<html>
<style>
.mystyle1{
margin-left:10px;
}
</style>

    
    <head>
        <title><%=monitoringFDAS%></title>
    </head>
    
    <body height="100%">
        <jsp:include page="../Common/ImportJS.jsp" />
        <!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
        <script>
        var outerPanel;
        var ctsb;
        var jspName = "MonitoringFDASReport";
        var exportDataType = "int,string,string,string,date,int,int,int,int,int";
        var dtcur = datecur;
        var dtprev = dateprev;


        var reader = new Ext.data.JsonReader({
            idProperty: 'darreaderid',
            root: 'MonitoringFDASRoot',
            totalProperty: 'total',
            fields: [{
                name: 'slnoIndex'
            }, {
                name: 'ltspnameIndex'
            }, {
                name: 'customernameIndex'
            },{
                name: 'assetnoIndex'
            }, {
            	name: 'daysaftercaliberation'
            },{
            	name: 'noofrefulesIndex'
            }, {
                name: 'noofspuriousrefuelIndex'
            }, {
                name: 'noofinvalidvoltagesIndex'
            }, {
            	name: 'noofunexpectedrefuelIndex'
            },{
            	name: 'noofprobablepilfreges'
            }]
        });

         //***************************************Store Config*****************************************
        var store = new Ext.data.GroupingStore({
            autoLoad: false,
            proxy: new Ext.data.HttpProxy({
                url: '<%=request.getContextPath()%>/CalibrationstatusAction.do?param=getMonitoringFDASDetails',
                method: 'POST'
            }),
            storeId: 'MonitoringFDASId',
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
                dataIndex: 'ltspnameIndex'
            }, {
                type: 'string',
                dataIndex: 'customernameIndex'
            },{
                type: 'string',
                dataIndex: 'assetnoIndex'
            }, {
                type: 'date',
                dataIndex: 'daysaftercaliberation'
            }, {
                type: 'int',
                dataIndex: 'noofrefulesIndex'
            }, {
                type: 'int',
                dataIndex: 'noofspuriousrefuelIndex'
            }, {
                type: 'int',
                dataIndex: 'noofinvalidvoltagesIndex'
            }, {
                type: 'int',
                dataIndex: 'noofunexpectedrefuelIndex'
            }, {
                type: 'int',
                dataIndex: 'noofprobablepilfreges'
            } ]
        });

         //************************************Column Model Config******************************************
        var createColModel = function (finish, start) {

            var columns = [new Ext.grid.RowNumberer({
                    header: "<span style=font-weight:bold;><%=SLNO%></span>",
                    width: 50
                }), {
                    dataIndex: 'slnoIndex',
                    hidden: true,
                    header: "<span style=font-weight:bold;><%=SLNO%></span>",
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    dataIndex: 'ltspnameIndex',
                    header: "<span style=font-weight:bold;><%=ltspName%></span>",
                    filter: {
                        type: 'string'
                    }
                }, {
                    dataIndex: 'customernameIndex',
                    header: "<span style=font-weight:bold;><%=customerName%></span>",
                    filter: {
                        type: 'string'
                    }
                },  {
                    dataIndex: 'assetnoIndex',
                    header: "<span style=font-weight:bold;><%=assetNo%></span>",
                    filter: {
                        type: 'string'
                    }
                },{
                    dataIndex: 'daysaftercaliberation',
                    header: "<span style=font-weight:bold;><%=daysAfterCaliberation%></span>",
                    filter: {
                        type: 'date'
                    }
                }, {
                    dataIndex: 'noofrefulesIndex',
                    header: "<span style=font-weight:bold;><%=noofRefuel%></span>",
                    filter: {
                        type: 'int'
                    }
                }, {
                    dataIndex: 'noofspuriousrefuelIndex',
                    header: "<span style=font-weight:bold;><%=noofSupriousRefuel%></span>",
                    filter: {
                        type: 'int'
                    }
                }, {
                    dataIndex: 'noofinvalidvoltagesIndex',
                    header: "<span style=font-weight:bold;><%=noofInvalidVoltage%></span>",
                    filter: {
                        type: 'int'
                    }
                }, {
                    dataIndex: 'noofunexpectedrefuelIndex',
                    header: "<span style=font-weight:bold;><%=noofUnexpectedRefuel%></span>",
                    filter: {
                        type: 'int'
                    }
                }, {
                    dataIndex: 'noofprobablepilfreges',
                    header: "<span style=font-weight:bold;><%=noofProbablePilfreges%></span>",
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

         //*******************************************Grid Panel Config***************************************

        var grid = getGrid('<%=monitoringFDAS%>', '<%=NoRecordsFound%>', store, screen.width-50, 520, 11, filters, '<%=ClearFilterData%>', true, '<%=ReconfigureGrid%>', 10, true, '<%=ClearGrouping%>', false, '', true, '<%=Excel%>', jspName, exportDataType, false, '');
        Ext.onReady(function () {
            ctsb = tsb;
            Ext.QuickTips.init();
            Ext.form.Field.prototype.msgTarget = 'side';
            outerPanel = new Ext.Panel({
                renderTo: 'content',
                standardSubmit: true,
                height: 550,
                width:'99%',
                frame: false,
                cls: 'mainpanelpercentage',
                items: [grid],
                bbar: ctsb
            });


            sb = Ext.getCmp('form-statusbar');
		    store.load({
		    params:{jspName:jspName}
		    });
        }); // END OF ONREADY

</script>
</body>
</html>	
<%}%>