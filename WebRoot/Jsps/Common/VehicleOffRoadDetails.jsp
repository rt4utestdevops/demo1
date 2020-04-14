<%@ page language="java" import="t4u.functions.CommonFunctions,t4u.beans.*" pageEncoding="utf-8"%>

<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
//getting language
String language=loginInfo.getLanguage();
int customerId=loginInfo.getCustomerId();
int systemid=loginInfo.getSystemId();
String pageid=request.getParameter("pageId");

	
	String NoRecordsFound=cf.getLabelFromDB("No_Records_Found",language);
	String ClearFilterData=cf.getLabelFromDB("Clear_Filter_Data",language);
	String ReconfigureGrid=cf.getLabelFromDB("Reconfigure_Grid",language);
	String ClearGrouping=cf.getLabelFromDB("Clear_Grouping",language);
	String registrationNo=cf.getLabelFromDB("Registration_No",language);
	String slNo=cf.getLabelFromDB("SLNO",language);
	String jobCardType=cf.getLabelFromDB("Job_Card_Type",language);
	String jobCardDate=cf.getLabelFromDB("Job_Card_Date",language);
 %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html:html lang="true">
  <head>
    <html:base />
    
    <title>VehicleOffRoadDetails.jsp</title>

	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
  
  <body>
  <jsp:include page="../Common/ImportJSCashVan.jsp" />
        <!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
   <script type="text/javascript">
    var outerPanel;
    Ext.Ajax.timeout = 360000;
    
       var reader = new Ext.data.JsonReader({
                idProperty: 'darreaderid',
                root: 'vehicleOffRoadDetailsRoot',
                totalProperty: 'total',
                fields: [{
                        name: 'VehicleNo'
                    },{ name: 'jobcardtypeindex'
                    }, {
                        name: 'jobcarddateindex',
						type: 'date',
                        dateFormat: getDateTimeFormat()
                    }
                ]
            });
    
      var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=getVehicleOffRoadDetails',
                    method: 'POST'
                }),
                remoteSort: false,
                sortInfo: {
                    field: 'jobcarddateindex',
                    direction: 'ASC'
                },
                storeId: 'darStore',
                reader: reader
            });
            
             var filters = new Ext.ux.grid.GridFilters({
                local: true,
                filters: [{
                        type: 'string',
                        dataIndex: 'VehicleNo'
                    },{
                        type: 'string',
                        dataIndex: 'jobcardtypeindex'
                    }, {
                        type: 'date',
                        dataIndex: 'jobcarddateindex'
                    }
                ]
            });
            
             var createColModel = function (finish, start) {

                var columns = [
                    new Ext.grid.RowNumberer({
                        header: "<span style=font-weight:bold;><%=slNo%></span>",
                        width: 50
                    }),{
                        header: "<span style=font-weight:bold;><%=registrationNo%></span>",
                        dataIndex: 'VehicleNo',
                        width:70,
                        filter: {
                            type: 'string'
                        }
                    },{
                        header: "<span style=font-weight:bold;><%=jobCardType%></span>",
                        dataIndex: 'jobcardtypeindex',
                        width:70,
                        filter: {
                            type: 'string'
                        }
                    },  {
                        header: "<span style=font-weight:bold;><%=jobCardDate%></span>",
                        dataIndex: 'jobcarddateindex',
                        width:70,
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
    
    var grid = getVerticalPlatFormGrid('', '<%=NoRecordsFound%>', store,screen.width-45,500, 9, filters,false, '<%=ClearFilterData%>', false, '<%=ReconfigureGrid%>', 10, false, '<%=ClearGrouping%>', false, '', false, '', '', '', false, '');
    
     var buttonPanel = new Ext.Panel({
                standardSubmit: true,
                collapsible: false,
                border:false,
                cls: 'dashboardinnerpanelgridpercentage',
                height:40,
                id: 'buttonpanel',
                layout: 'column',
                layoutConfig: {
                    columns: 12
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
                                	if(<%=pageid%>==1){
                                   window.location ="<%=request.getContextPath()%>/Jsps/CashVanManagement/Dashboard.jsp";
                                   }else if(<%=pageid%>==2){
                                   window.location ="<%=request.getContextPath()%>/Jsps/AutomotiveLogistics/Dashboard.jsp";
                                   }else if(<%=pageid%>==3){
                                   window.location ="<%=request.getContextPath()%>/Jsps/DistributionLogistics/Dashboard.jsp";
                                   }else if(<%=pageid%>==4){
                                   window.location ="<%=request.getContextPath()%>/Jsps/ColdChainLogistics/Dashboard.jsp";
                                   }else if(<%=pageid%>==5){
                                   window.location ="<%=request.getContextPath()%>/Jsps/CarRental/CommonDashboard.jsp";
                                   }else{
                                   window.location ="<%=request.getContextPath()%>/Jsps/GeneralVertical/Dashboard.jsp";
                                   }  
                                }
                            }
                        }
                    }
                ]
            }); // End of Panel	
    
     Ext.onReady(function () {
                Ext.QuickTips.init();
                Ext.form.Field.prototype.msgTarget = 'side';                            
                outerPanel = new Ext.Panel({
                    renderTo: 'content',
                    standardSubmit: true,
                    frame: false,
                    //width:'99%',
                    cls: 'outerpanel',
                    items: [grid,buttonPanel]
                });  
                store.load(); 
            });
   </script>
  </body>
</html:html>
