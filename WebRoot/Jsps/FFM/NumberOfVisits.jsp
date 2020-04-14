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
	session.setAttribute("loginInfoDetails",loginInfo);
	
}
	int usrId=Integer.parseInt(request.getParameter("usrId"));	
	String style=request.getParameter("style");
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
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();

	ArrayList<String> tobeConverted = new ArrayList<String>();
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Back");
	tobeConverted.add("SLNO");
	tobeConverted.add("No_Of_Customer_Visits");
	tobeConverted.add("Company_Name");
	tobeConverted.add("Call_Type");
	tobeConverted.add("Updated_Time");
	tobeConverted.add("Customer_Information");
	tobeConverted.add("Remarks");
	tobeConverted.add("Customer_Name");	
	
	ArrayList<String> convertedWords = new ArrayList<String>();
	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);	 
	String NoRecordsFound=convertedWords.get(0);
	String ClearFilterData=convertedWords.get(1);	
	String Back=convertedWords.get(2);
	String SLNO=convertedWords.get(3);
	String NoOfVisits=convertedWords.get(4);
	String CompanyName=convertedWords.get(5);
	String CallType=convertedWords.get(6);   
	String UpdatedTime=convertedWords.get(7);
	String CustomerInformation=convertedWords.get(8); 
	String Remarks=convertedWords.get(9);
	String CustomerName=convertedWords.get(10);

%>

<!DOCTYPE HTML>
<html class="largehtml">
<style type="text/css">
.x-panel-bc,.x-panel-br{
   height:0px;
}
</style>
<head>
    <title>
        <%=NoOfVisits%> 
    </title>
</head>


<body>
    <%if (style.equals( "Y")){%>
        <jsp:include page="../Common/ImportJSSandMining.jsp" />
        <%}else{%>
            <jsp:include page="../Common/ImportJS.jsp" />
            <%}%>
                <jsp:include page="../Common/ExportJS.jsp" />
                <script>
var outerpanel;
var ctsb;
var jspName = "Number Of Visits";
var exportDataType = "";      
var grid;


function goBack() {
	window.location = "<%=request.getContextPath()%>/Jsps/FFM/DashBoard.jsp";
}


var reader = new Ext.data.JsonReader({
    idProperty: 'numOfVisitsId',
    root: 'visitRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex',
        type: 'int'
    },{
    	name: 'customerNameIndex',
    	type: 'string'    
    }, {
        name: 'companyNameIndex',
        type: 'string'
    }, {
        name: 'callTypeIndex',
        type: 'string'
    }, {
        name: 'remarksIndex',
        type: 'string'
    },  {
        name: 'updatedTimeIndex',
        type: 'date',
        format: getDateTimeFormat()
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/FFMDashBoardAction.do?param=getVisitDetails', 
        method: 'POST'        
    }),
    storeId: 'storeId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
    	dataIndex: 'customerNameIndex',
    	type: 'string'
    },{
        dataIndex: 'companyNameIndex',
        type: 'string'
    },{
        dataIndex: 'callTypeIndex',
        type: 'string'
    }, {
        dataIndex: 'remarksIndex',
        type: 'string'
    }, {
        dataIndex: 'updatedTimeIndex',
        type: 'date'
    }]
});

var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            hidden: true,
            filter: {
                type: 'numeric'
            }
        },
        {
            dataIndex: 'customerNameIndex',
            header: "<span style=font-weight:bold;><%=CustomerName%></span>",
            width: 120,
            filter: {
                type: 'string'
            }
        },
        {
            dataIndex: 'companyNameIndex',
            header: "<span style=font-weight:bold;><%=CompanyName%></span>",
            width: 120,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'callTypeIndex',
            header: "<span style=font-weight:bold;><%=CallType%></span>",
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'remarksIndex',
            header: "<span style=font-weight:bold;><%=Remarks%></span>",
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'updatedTimeIndex',
            header: "<span style=font-weight:bold;><%=UpdatedTime%></span>",
            width: 150,
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            filter: {
                type: 'date'
            }
        }];
    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish), 
        defaults: {
            sortable: true
        }
    });
};

//*****************************************************************Grid *******************************************************************************
grid = getGrid(' ', '<%=NoRecordsFound%>', store, screen.width - 40, 460, 7, filters, '<%=ClearFilterData%>', false,'', 7, false, '', false, '', false, '', jspName, exportDataType, false, 'PDF', false, '', false, '', false, '');
//******************************************************************************************************************************************************
Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
        grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'<%=Back%>', 
			    iconCls : 'backbutton',
			    handler : function(){
			    goBack();

			    }    
			  }]);  
    outerPanel = new Ext.Panel({
        title: '<%=CustomerInformation%>',
        renderTo: 'content',
        standardSubmit: true,
        autoscroll: true,
        frame: true,
        width: screen.width - 22,
        cls: 'outerpanel',
      	layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [grid],
        bbar: ctsb
    });

    store.load({
               params: {
                   usrid: '<%=usrId%>'
               }
           });
    sb = Ext.getCmp('form-statusbar');
});
</script>
</body>
</html>

    
    
    
    
    

