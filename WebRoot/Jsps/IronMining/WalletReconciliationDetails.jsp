
<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String orgId = request.getParameter("orgId");
String orgName = request.getParameter("orgName");
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
	    int userId=loginInfo.getUserId(); 
	    String userAuthority=cf.getUserAuthority(systemId,userId);	
   if(false)
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
	else{
		
%>

<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
    <title>Wallet Reconciliation Details</title>
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
    var jspName = "Wallet Reconciliation Report";
    var grid;
	var exportDataType = "int,string,string,string,string,number,number,number,number";
	var buttonValue;
	var dtcur = datecur;
    //---------------------------------------------------Reader-------------------------------------------------------//
    var reader = new Ext.data.JsonReader({
        idProperty: 'readerId',
        root: 'routeTripDetailsRoot',
        totalProperty: 'total',
        fields: [ {
            name: 'slnoIndex'
        },{
            name: 'challanPermitIndex'
        },{
            name: 'typeIndex'
        },{
            name: 'issuedDateIndex'
        },{
            name: 'orgNameIndex'
        },{
            name: 'qtyIndex'
        },{
            name: 'rateIndex'
        },{
            name: 'creditamountIndex'
        },{
            name: 'debitamountIndex'
        }]
    });
    //-----------------------------------------------store---------------------------------------------------//
    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/MiningReportsAction.do?param=getWalletReconciliationReport',
            method: 'POST'
        }),
        remoteSort: false,
        sortInfo: {
            field: 'slnoIndex',
            direction: 'ASC'
        },
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
            dataIndex: 'challanPermitIndex',
            type: 'string'
        }, {
            dataIndex: 'typeIndex',
            type: 'string'
        }, {
            dataIndex: 'issuedDateIndex',
            type: 'string'
        }, {
            dataIndex: 'orgNameIndex',
            type: 'string'
        }, {
            dataIndex: 'qtyIndex',
            type: 'numeric'
        }, {
            dataIndex: 'rateIndex',
            type: 'numeric'
        }, {
            dataIndex: 'creditamountIndex',
            type: 'numeric'
        }, {
            dataIndex: 'debitamountIndex',
            type: 'numeric'
        }]
    });
    //--------------------------------------------------column Model---------------------------------------//
    var createColModel = function(finish, start) {
        var columns = [
             new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;>SLNO</span>",
                width: 50
            }), {
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;>SlNo</span>"
            }, {
                header: '<b>Challan/Permit No</b>',
                dataIndex: 'challanPermitIndex'
            }, {
                header: '<b>Type</b>',
                dataIndex: 'typeIndex'
            }, {
                header: '<b>Date</b>',
                dataIndex: 'issuedDateIndex'
            }, {
                header: '<b>Organization Name</b>',
                dataIndex: 'orgNameIndex'
            }, {
                header: '<b>Quantity</b>',
                dataIndex: 'qtyIndex'
            }, {
                header: '<b>Rate</b>',
                dataIndex: 'rateIndex'
            }, {
                header: '<b>Credit Amount</b>',
                dataIndex: 'creditamountIndex'
            }, {
                header: '<b>Debit Amount</b>',
                dataIndex: 'debitamountIndex'
            }];
        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };
    //---------------------------------------------------------grid-------------------------------------------//

	grid = getGrid('', 'No Records found', store, screen.width - 55, 380, 20, filters, 'Clear Filter Data', false, '', 12, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF',false,'View Details',false,'Modify',false,'',false,'',false,'Generate PDF');

    //--------------------------------------------------------------------------------------------------------//
    Ext.onReady(function() {
        outerPanel = new Ext.Panel({
            renderTo: 'content',
            standardSubmit: true,
            autoScroll: false,
            frame: true,
            border: false,
            id: 'outer',
            layout: 'table',
            width: screen.width-45,
            height: screen.height-380,
            cls: 'outerpanel',
            layoutConfig: {
                columns: 1
            },
            items: [grid]
        });
        var cm =grid.getColumnModel();  
	    for (var j = 1; j < cm.getColumnCount(); j++) {
	       cm.setColumnWidth(j,160);
	    }
    });
    store.load({
        params: {
            jspName:jspName,
            orgId:'<%=orgId%>',
            orgName:'<%=orgName%>'
       }
   });
        
    
</script>
  </body>
</html>
<%}%>
<%} %>
