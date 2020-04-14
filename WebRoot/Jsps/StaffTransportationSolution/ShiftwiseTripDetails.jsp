
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
	String vehicleNumber="";
	String startDate="";
	String endDate="";
	String startTime="";
	String endTime="";
	int branchId=0;
	int shiftId=0;
	if(request.getParameter("vehicleNo") != null){
		vehicleNumber=request.getParameter("vehicleNo");
		startDate=request.getParameter("startDate");
		endDate=request.getParameter("endDate");
		startTime=request.getParameter("starttime");
		endTime=request.getParameter("endtime");
		shiftId=Integer.parseInt(request.getParameter("shiftId"));
		branchId=Integer.parseInt(request.getParameter("branchId"));
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
		
%>

<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
    <title>Shift Wise Trip Details</title>
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
    var jspName = "ShiftWiseTripDetails";
    var grid;
	var exportDataType = "int,string,string,string,string,string";
	
	function addRecord(){
    if (grid.getSelectionModel().getCount() == 0) {
       Ext.example.msg("No Rows Selected");
       return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
       Ext.example.msg("Select Single Row");
       return;
    }
    var selected = grid.getSelectionModel().getSelected();
	vehicleNo=selected.get('vehicleNoIndex');
	startDate=selected.get('startDateIndex');
	endDate=selected.get('endDateIndex');
	starttime=selected.get('startTimeIndex');
	var startsTime = starttime.split(":");
	var startTimeHr = startsTime[0];
	var startTimeMin = startsTime[1];
	endtime=selected.get('endTimeIndex');
	var endsTime = endtime.split(":");
	var endTimeHr = endsTime[0];
	var endTimeMin = endsTime[1];
	var tripReport=true;
	var url="<%=request.getContextPath()%>/Jsps/Common/HistoryAnalysis.jsp?vehicleNo="+vehicleNo+"&tripReport="+tripReport+"&startDate="+startDate+"&startTimeHr="+startTimeHr+"&startTimeMin="+startTimeMin+"&endDate="+endDate+"&endTimeHr="+endTimeHr+"&endTimeMin="+endTimeMin;
	console.log(url);
	var win = new Ext.Window({
        title:'History Analysis Window',
        autoShow : false,
    	constrain : false,
    	constrainHeader : false,
    	resizable : false,
    	maximizable : true,
    	minimizable :true,
    	footer:true,
    	header:false,
        width:screen.width-40,
        height:510,
        shim:false,
        animCollapse:false,
        border:false,
        constrainHeader:true,
        layout: 'fit',
		html : "<iframe style='width:100%;height:470px;background:#ffffff' src="+url+"></iframe>",
		listeners: {
			maximize: function(){
			},
			minimize:function(){
			},
			resize:function(){
			},
			restore:function(){
			}
		}
    });
  
    win.show();
}
    //---------------------------------------------------Reader-------------------------------------------------------//
    var reader = new Ext.data.JsonReader({
        idProperty: 'readerRootId',
        root: 'detailsStoreRoot',
        totalProperty: 'total',
        fields: [ {
            name: 'slnoIndex'
        },{
            name: 'vehicleNoIndex'
        },{
            name: 'startDateTimeIndex'
        },{
            name: 'endDateTimeIndex'
        }, {
            name: 'totalkmIndex'
        },{
            name: 'totalDurationIndex'
        },{
            name: 'startTimeIndex'
        },{
            name: 'endTimeIndex'
        },{
            name: 'startDateIndex'
        },{
            name: 'endDateIndex'
        }]
    });
    //-----------------------------------------------store---------------------------------------------------//
    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/VehicleTripSummaryAction.do?param=getShiftWiseVehicleDetails',
            method: 'POST'
        }),
        remoteSort: false,
        bufferSize: 700,
        reader: reader
    });
    //------------------------------------------Filters--------------------------------------------------------//
    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [  {
            dataIndex: 'slnoIndex',
            type: 'numeric'
        }, {
            dataIndex: 'vehicleNoIndex',
            type: 'string'
        }, {
            dataIndex: 'startDateTimeIndex',
            type: 'date'
        }, {
            dataIndex: 'endDateTimeIndex',
            type: 'date'
        }, {
            dataIndex: 'totalkmIndex',
            type: 'string'
        }, {
            dataIndex: 'totalDurationIndex',
            type: 'string'
        }]
    });
    //--------------------------------------------------column Model---------------------------------------//
    var createColModel = function(finish, start) {
        var columns = [
             new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;>SL NO</span>",
                width: 50
            }), {
                dataIndex: 'slnoIndex',
                width: 50,
                hidden: true,
                header: "<span style=font-weight:bold;>SlNo</span>"
            }, {
                header: 'Vehicle No', 
                dataIndex: 'vehicleNoIndex'
            }, {
                header: 'Start Time', 
                dataIndex: 'startDateTimeIndex'
            }, {
                header: 'End Time',
                dataIndex: 'endDateTimeIndex'
            }, {
                header: 'Total Km',
                dataIndex: 'totalkmIndex'
            }, {
                header: 'Total Duration', 
                dataIndex: 'totalDurationIndex'
            }];
        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };
    //---------------------------------------------------------grid-------------------------------------------//

	grid = getGrid('Shiftwise Trip Details', 'No Records found', store, screen.width - 38, 495, 20, filters, 'Clear Filter Data', false, '', 12, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF',true,'History Tracking',false,'Modify',false,'',false,'',false,'Generate PDF');

    //--------------------------------------------------------------------------------------------------------//

    var mainPanel = new Ext.Panel({
        standardSubmit: true,
        frame: true,
        width: screen.width - 30,
        height: 510,
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [grid]
       
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
            height: 516,
            cls: 'outerpanel',
            layoutConfig: {
                columns: 1
            },
            items: [mainPanel]
        });
        store.load({
           params:{
              CustId : <%=customerId%>,
              BranchId : <%=branchId%>,
              ShiftId:<%=shiftId%>,
              startDate:'<%=startDate%>',
              endDate:'<%=endDate%>',
              startTime:'<%=startTime%>',
              endTime:'<%=endTime%>',
              vehicleNo: '<%=vehicleNumber%>',
              jspName: jspName
            }
         });
        var cm =grid.getColumnModel();
	    for (var j = 1; j < cm.getColumnCount(); j++) {
			cm.setColumnWidth(j,250);
	    }
    });
    
</script>
  </body>
</html>
<%}%>
