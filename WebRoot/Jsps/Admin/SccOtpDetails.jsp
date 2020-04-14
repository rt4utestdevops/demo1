<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
	LoginInfoBean loginInfo1=new LoginInfoBean();
	loginInfo1=(LoginInfoBean)session.getAttribute("loginInfoDetails");
	if(loginInfo1!=null)
	{
	int mapType=loginInfo1.getMapType();
	loginInfo.setMapType(mapType);
	}
	loginInfo.setSystemId(systemid);
	loginInfo.setCustomerId(customerid);
	loginInfo.setUserId(userid);
	loginInfo.setLanguage(language);
	loginInfo.setZone(str[4].trim());
	loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
	loginInfo.setSystemName(str[6].trim());
	loginInfo.setCategory(str[7].trim());
	if(str.length>8){
	loginInfo.setCustomerName(str[8].trim());
	}
	if(str.length>9){
	loginInfo.setCategoryType(str[9].trim());
	}
	if(str.length>10){
	loginInfo.setUserName(str[10].trim());
	loginInfo.setStyleSheetOverride(str[11].trim());
	loginInfo.setIsLtsp(Integer.parseInt(str[12].trim()));
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
CommonFunctions cf=new CommonFunctions();
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	int userId = loginInfo.getUserId();
String userAuthority=cf.getUserAuthority(systemId,userId);
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else if(loginInfo.getCustomerId()>0 && loginInfo.getIsLtsp() == -1 && (!userAuthority.equalsIgnoreCase("Admin"))) 
{
	response.sendRedirect(path + "/Jsps/Common/401Error.html");
}
else
{
session.setAttribute("loginInfoDetails",loginInfo);

%>

<jsp:include page="../Common/header.jsp" />
    <base href="<%=basePath%>">

    <title>
       Scc OTP Details
    </title>
<style>
.x-panel-tl {
    border-bottom: 0px solid !important;
}
.x-form-file-wrap .x-form-file {
	position: absolute;
	right: 0;
	-moz-opacity: 0;
	filter:alpha(opacity: 0);
	opacity: 0;
	z-index: 2;
    height: 22px;
    cursor: pointer;
}
.x-form-file-wrap .x-form-file-btn {
	position: absolute;
	right: 0;
	z-index: 1;
}
.x-form-file-wrap .x-form-file-text {
    position: absolute;
    left: 0;
    z-index: 3;
    color: #777;
}
<%
	String ua = request.getHeader("User-Agent");
	boolean isMSIE10 = (ua != null && ua.indexOf("MSIE 10") != -1);
	boolean isMSIE9 = (ua != null && ua.indexOf("MSIE 9") != -1);
	boolean isMSIE8 = (ua != null && ua.indexOf("MSIE 8") != -1);
	if(isMSIE10 || isMSIE9 || isMSIE8){
%>
#ext-gen127{
width:70px;
}
<%}else{%>
#ext-gen126{
width:70px;
}
<%}%>
.x-form-field-wrap{
 height: 35px;
}
<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
.x-form-file-wrap .x-form-file {
height:35px;
}
#filePath{
height:30px;
}
<%}%>
</style>

  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
	<% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		<style>							
			label {
				display : inline !important;
			}			
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
				height : 38px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}
			.x-menu-list {
				height:auto !important;
			}	
		</style>
	 <%}%>
	             
                                           
   <script>
  var interval = setInterval(function() {
    var store = Ext.StoreMgr.lookup('storeId');
    store.reload();
    var countstore = Ext.StoreMgr.lookup('countstoreId');
    countstore.reload();
     var rec1 = countstore.getAt(0);
                        var lockcount = rec1.data['lockcount'];
       var unlockcount = rec1.data['unlockcount'];
       Ext.getCmp('lockCountId').setText(lockcount);
       Ext.getCmp('UnlockCountId').setText(unlockcount); 
}, 20000);
  
  
      var countstore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/SccAction.do?param=getSccLockAndUnlock',
       autoLoad: false,
       id: 'countstoreId',         
       root: 'countroot',      
       fields: ['lockcount','unlockcount']
   });
  
   var clientcombostore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/SccAction.do?param=getCustomerForscc',
       id: 'CustomerStoreId',
       root: 'CustomerRoot',
       autoLoad: true,
       remoteSort: true,
       fields: ['CustId', 'CustName']
     
   });
   
   var Client = new Ext.form.ComboBox({
       store: clientcombostore,
       id: 'custcomboId',
       mode: 'local',
       forceSelection: true,
       emptyText: 'SelectCustomer',
       blankText: 'SelectCustomer',
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
                       custName = Ext.getCmp('custcomboId').getRawValue();
                   
                   vehicleNoStore.load({
                       params: {
                           CustId: custId
                       }
                   });
             }
           }
       }
   });
   
   
   var vehicleNoStore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/SccAction.do?param=getvehiclenoscc',
       id: 'vehiclenoRootId',
       root: 'vehiclenoRoot',
       autoload: true,
       remoteSort: true,
       fields: ['vehicleno',]
   });
   
   var vehicleNo = new Ext.form.ComboBox({
       store: vehicleNoStore,
       id: 'vehicleNocomboId',
       mode: 'local',
       forceSelection: true,
       selectOnFocus: true,
       emptyText: 'Select vehicleNo',
       blankText: 'Select vehicleNo',
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,      
       valueField: 'vehicleno',
       displayField: 'vehicleno',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function() {
                 custId = Ext.getCmp('custcomboId').getValue();
                 vehicleNo = Ext.getCmp('vehicleNocomboId').getValue();
                 store.load({
                       params: {
                           CustId: custId,
                           VehicleNo:vehicleNo
                       }
                   });                   
                   countstore.load({
                       params: {
                           CustId: custId,
                           VehicleNo:vehicleNo
                       },
                       callback: function(){
                       var rec1 = countstore.getAt(0);
                        var lockcount = rec1.data['lockcount'];
       var unlockcount = rec1.data['unlockcount'];
       Ext.getCmp('lockCountId').setText(lockcount);
       Ext.getCmp('UnlockCountId').setText(unlockcount); 
                       }
                   }); 
                    
               }
           }
       }
   });
   
  
   var reader = new Ext.data.JsonReader({
       idProperty: 'taskMasterid',
       root: 'sccMaster',
       totalProperty: 'total',
       fields: [{
           name: 'slnoIndex'
       },  {
           name : 'unitNoDataIndex'
       }, {
           name: 'sccIdDataIndex'
       },  {
           name : 'usedTimeDataIndex'
       },{
           name: 'otpDataIndex'
       }, {
           name: 'otpTypeDataIndex'
       }, {
       	   name:'otpStatusDataIndex'
       }]
   });
   var store = new Ext.data.GroupingStore({
       autoLoad: false,
       id: 'storeId',
       proxy: new Ext.data.HttpProxy({
           url: '<%=request.getContextPath()%>/SccAction.do?param=getSccDataForOTP',
           method: 'POST'
       }),      
       reader: reader
   });
   

   
   var filters = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
           type: 'numeric',
           dataIndex: 'slnoIndex'
       }, {
           type: 'string',
           dataIndex: 'unitNoDataIndex'
       },{
           type: 'string',
           dataIndex: 'sccIdDataIndex'
       }, {
           type: 'date',
           dataIndex: 'usedTimeDataIndex'
       }, {
           type: 'string',
           dataIndex: 'otpDataIndex'
       }, {
           type: 'int',
           dataIndex: 'otpTypeDataIndex'
       }, {
           type: 'string',
           dataIndex: 'otpStatusDataIndex'
       }]
   });
   var createColModel = function(finish, start) {
       var columns = [
           new Ext.grid.RowNumberer({
               header: "<span style=font-weight:bold;>SLNO</span>",
               width: 50
           }), {
               dataIndex: 'slnoIndex',
               hidden: true,
               header: "<span style=font-weight:bold;>SLNO</span>",
               filter: {
                   type: 'numeric'
               }
           }, {
               header: "<span style=font-weight:bold;>UNIT NO</span>",
               dataIndex: 'unitNoDataIndex',
               width: 100,
               filter: {
                   type: 'string'
               }
           },{
               header: "<span style=font-weight:bold;>SCC Id</span>",
               dataIndex: 'sccIdDataIndex',
               width: 100,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;>Used Time</span>",
               dataIndex: 'usedTimeDataIndex',
               hidden: false,
               sortable: true,
               renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
               width: 100,
               filter: {
                   type: 'date'
               }
           }, {
               header: "<span style=font-weight:bold;>OTP</span>",
               dataIndex: 'otpDataIndex',
               width: 100,
               filter: {
                   type: 'string'
               }
           },  {
               header: "<span style=font-weight:bold;>OTP TYPE</span>",
               dataIndex: 'otpTypeDataIndex',
               width: 100,
               filter: {
                   type: 'string'
               }
           }, {
               header: "<span style=font-weight:bold;>OTP STATUS</span>",
               dataIndex: 'otpStatusDataIndex',
               width: 100,
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
   grid = getGrid('', 'NoRecordsFound', store, screen.width - 45, 380, 18, filters, 'ClearFilterData', false, '', 16, false, '', false, '', false, '', '', '', false, '', '' , '', ''  , '', '' , '');
   
   
      var comboPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'traderMaster',
       layout: 'table',
       frame: false,
       width: screen.width - 12,
       height: 40,
       layoutConfig: {
           columns: 13
       },
       items: [{
               xtype: 'label',
               text: 'CustomerName' + ' :',
               cls: 'labelstyle'
           },
           Client,{width:50},
           {
               xtype: 'label',
               text: 'Vehicle Number' + ' :',
               cls: 'labelstyle'
           }, vehicleNo,{width:50},
           {
               xtype: 'label',
               text: 'Lock Count' + ' :',
               cls: 'labelstyle'
           }, {
               xtype: 'label',
               text: '',
               cls: 'labelstyle',
               id: 'lockCountId'
           },{width:50},
           {
               xtype: 'label',
               text: 'UnLock Count' + ' :',
               cls: 'labelstyle'
           }, {
               xtype: 'label',
               text: '',
               cls: 'labelstyle',
               id: 'UnlockCountId'
           }
       ]
   });
 
   Ext.onReady(function() {
       ctsb = tsb;
       Ext.QuickTips.init();
       Ext.form.Field.prototype.msgTarget = 'side';
       outerPanel = new Ext.Panel({
           title: 'SCC OTP DETAILS',
           renderTo: 'content',
           standardSubmit: true,
           frame: true,
           width: screen.width - 38,
           height: 495,
           cls: 'outerpanel',
           layout: 'table',
           layoutConfig: {
               columns: 1
           },
           items: [comboPanel,grid]          
       });
       sb = Ext.getCmp('form-statusbar');
   });
 
 
  </script>   
   <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>