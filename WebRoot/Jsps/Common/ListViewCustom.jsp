
<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
 	String path = request.getContextPath();
 	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";

 	CommonFunctions cf = new CommonFunctions();
 	LiveVisionColumns liveVisionColumns=new LiveVisionColumns();
 	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
 	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails"); 	
 	String language = loginInfo.getLanguage();
 	int systemid = loginInfo.getSystemId();
 	String systemID = Integer.toString(systemid);
 	int customeridlogged = loginInfo.getCustomerId();
 	int userId = loginInfo.getUserId();
 	String CustName = loginInfo.getCustomerName();
 	int processID = 0;
 	boolean checkFDAS = false;
 	boolean sysId = false;
 	if (session.getAttribute("processId") != null) {
 		processID = Integer.parseInt((String) session
 				.getAttribute("processId"));
 		processID = cf.checkProcessIdExistsForMapView(processID);
 	} else {
 		processID = cf.getProcessID(systemid, customeridlogged);
 		processID = cf.checkProcessIdExistsForMapView(processID);
 	}
 	String userAuthority = cf.getUserAuthority(systemid, userId);

 	checkFDAS = liveVisionColumns.checkFDASExistsForCustomer(systemid,
 			customeridlogged);
 	String dataTypes = liveVisionColumns.exportDataTypes(processID,
 			checkFDAS);
 	String customernamelogged = "null";
 	String vehicleTypeRequest = "all";
 	String category = null;
 	if (request.getParameter("vehicleType") != null) {
 		vehicleTypeRequest = request.getParameter("vehicleType");
 	}
 	if (request.getParameter("category") != null) {
 		category = request.getParameter("category");
 		vehicleTypeRequest = "";
 	}
 	if (request.getParameter("reqType") != null) {
 		processID = 20;
 	}
 	if (customeridlogged > 0) {
 		customernamelogged = cf.getCustomerName(String
 				.valueOf(customeridlogged), systemid);
 	}

 	Properties properties = ApplicationListener.prop;
 	String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen")
 			.trim();
 	String blockedSystemIDs = properties
 			.getProperty("MapviewButtonToBlockinListView");
 	if (blockedSystemIDs != null && !blockedSystemIDs.trim().equals("")) {
 		String[] str = blockedSystemIDs.split(",");
 		List<String> systemList = Arrays.asList(str);
 		if (systemList
 				.contains(String.valueOf(loginInfo.getSystemId()))) {
 			sysId = true;
 		}
 	}
 	ArrayList<String> tobeConverted = new ArrayList<String>();
 	tobeConverted.add("SLNO");
 	tobeConverted.add("Save");
 	tobeConverted.add("Cancel");
 	tobeConverted.add("No_Rows_Selected");
 	tobeConverted.add("Select_Single_Row");
 	tobeConverted.add("Live_Vision");
 	tobeConverted.add("DashBoardMap");
 	tobeConverted.add("List_View");
 	tobeConverted.add("All");
 	tobeConverted.add("Communicating");
 	tobeConverted.add("Non_Communicating");
 	tobeConverted.add("No_GPS_Connected");
 	tobeConverted.add("Do_Not_Select_More_Vehicles");
 	tobeConverted.add("History_Analysis");
 	tobeConverted.add("Running");
 	tobeConverted.add("Stoppage");
 	tobeConverted.add("Idle");

 	ArrayList<String> convertedWords = new ArrayList<String>();
 	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,
 			language);

 	String SLNO = convertedWords.get(0);
 	String Save = convertedWords.get(1);
 	String Cancel = convertedWords.get(2);
 	String NoRowsSelected = convertedWords.get(3);
 	String SelectSingleRow = convertedWords.get(4);
 	String LiveVision = convertedWords.get(5).toUpperCase();
 	String dashBoardMap = convertedWords.get(6);
 	String listView = convertedWords.get(7);
 	String all = convertedWords.get(8);
 	String communicating = convertedWords.get(9);
 	String nonCommunicating = convertedWords.get(10);
 	String noGPSConnected = convertedWords.get(11);
 	String maxRecord = convertedWords.get(12);
 	String historyAnalysis = convertedWords.get(13);
 	String runningVehicle = convertedWords.get(14);
 	String stoppedVehicle = convertedWords.get(15);
 	String idleVehicle = convertedWords.get(16);
 	String AnalysisOnMap = "Analysis On Map";
 %>
<jsp:include page="../Common/header.jsp" />
    <link rel="stylesheet" type="text/css" href="../../Main/modules/LTSP/css/component.css" />
    <link rel="stylesheet" type="text/css" href="../../Main/modules/cashVan/mapView/css/component.css" /> 
    <link rel="stylesheet" type="text/css" href="../../Main/modules/cashVan/mapView/css/layout.css" /> 
    <link rel="stylesheet" type="text/css" href="../../Main/modules/cashVan/theme/css/EXTJSExtn.css" /> 
    <pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
	<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
	<pack:script src="../../Main/Js/Common.js"></pack:script>
	<pack:style src="../../Main/resources/css/examples1.css" />
    <pack:script src="../../Main/Js/MsgBox.js"></pack:script>
    <!-- for grid -->
	<pack:script src="../../Main/resources/ux/gridfilters/menu/RangeMenu.js"></pack:script>
	<pack:script src="../../Main/resources/ux/gridfilters/menu/ListMenu.js"></pack:script>
	<pack:script src="../../Main/resources/ux/gridfilters/GridFilters.js"></pack:script>
	<pack:script src="../../Main/resources/ux/gridfilters/filter/Filter.js"></pack:script>
	<pack:script src="../../Main/resources/ux/gridfilters/filter/StringFilter.js"></pack:script>
	<pack:script src="../../Main/resources/ux/gridfilters/filter/DateFilter.js"></pack:script>
	<pack:script src="../../Main/resources/ux/gridfilters/filter/ListFilter.js"></pack:script>
	<pack:script src="../../Main/resources/ux/gridfilters/filter/NumericFilter.js"></pack:script>
	<pack:script src="../../Main/resources/ux/gridfilters/filter/BooleanFilter.js"></pack:script>
	<pack:script src="../../Main/Js/jquery.min.js"></pack:script>
	<pack:style src="../../Main/resources/css/ext-all.css" />
	<pack:style src="../../Main/resources/css/xtheme-DeepBlue.css" />
	<pack:style src="../../Main/resources/css/common.css" />
	<pack:style src="../../Main/resources/css/commonnew.css" />

	<!-- for grid -->
	<pack:style src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
	<pack:style src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
	<pack:style src="../../Main/resources/css/chooser.css" />
	
<style>	
html{
	position: fixed;
}
#listviewcontainer{
	width:100% !important;
	height:520px !important;
	border:0 !important;
}
#historyAnalysisContainer{
	width:100% !important;
	height:100% !important;
	border:0 !important;
}

@media screen and (device-width:1440px) {
	#listviewcontainer{
		width:100% !important;
		height: 625px !important;
		border:0 !important;
	}
	.list-container-fitscreen {
	    position: fixed;
	    top: 5%;
	    border: 5px solid #ffffff;
	    left: 0%;
	    width: 100%;
	    height: 656px !important;
	}
	#historyAnalysisContainer {
	    width: 100% !important;
	    height: 610px !important;
	    border: 0 !important;
	}
	
}
@media screen and (device-width:1600px) {
	#listviewcontainer{
		width:100% !important;
		height: 610px !important;
		border:0 !important;
	}
	.list-container-fitscreen {
	    position: fixed;
	    top: 5%;
	    border: 5px solid #ffffff;
	    left: 0%;
	    width: 100%;
	    height: 646px !important;
	}
	#historyAnalysisContainer {
	    width: 100% !important;
	    height: 610px !important;
	    border: 0 !important;
	}
	
}
@media screen and (device-width:1920px) {
	#listviewcontainer{
		width:100% !important;
		height:765px !important;
		border:0 !important;
	}
}
@media (device-width: 1280px) and (device-height: 800px) {
	.list-container-fitscreen {
	    position: fixed;
	    top: 7.1%;
	    border: 5px solid #ffffff;
	    left: 0%;
	    width: 100%;
	    height: 545px;
	}
}
*.x-grid3-row-checker, *.x-grid3-hd-checker {
     margin-top: 1px !Important;
}
#pac-input {
     background-color: #fff;
     padding: 0 11px 0 13px;
     width: 400px;
     font-family: Roboto;
     font-size: 15px;
     font-weight: 300;
     text-overflow: ellipsis;
}
.controls {
	margin-top: 6px;
	border: 1px solid transparent;
	border-radius: 2px 0 0 2px;
	box-sizing: border-box;
	-moz-box-sizing: border-box;
	height: 32px;
	outline: none;
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
}
table caption, table th, table td {
	padding: 0px !important;
	margin: 0px !important;
	width: 6px;
}
.x-menu-item-checked *.x-menu-item-icon {
	background-image: url(/ApplicationImages/ApplicationButtonIcons/checkedblue.png)!important;
}
.x-menu-check-item *.x-menu-item-icon {
    background-image: url(/ApplicationImages/ApplicationButtonIcons/uncheckedblue.png);
}
.x-menu-list-item-indent .x-menu-item-icon{
    height:24px;
} 
.x-form-text,.x-form-textarea,.x-combo-list{
	direction: ltr;
}
.x-btn-text-icon .x-btn-icon-small-right .x-btn-text{
	padding-right: 18px !important;
}
.x-btn-text-icon .x-btn-icon-small-left .x-btn-text{
	padding-left: 18px !important;
}
@media (device-width: 1280px) and (device-height: 960px) {
	.liveVisionGridStyle{
		width: 100% !important;
		height: 630px !important;
	}	
	.x-panel-noborder .x-panel-bbar-noborder .x-toolbar{
		width:100% !important;
	}
}
@media (device-width: 1280px) and (device-height: 1024px) {
	.liveVisionGridStyle{
		width: 100% !important;
		height: 680px !important;
	}	
	.x-panel-noborder .x-panel-bbar-noborder .x-toolbar{
		width:100% !important;
	}
}
<!--a {-->
<!--	color: black !important;-->
<!--}-->
.x-grid3-hd-row td {
    font-weight: normal;
    font-size: 11px;
    line-height: 1.36em;
    font-family: arial,tahoma,helvetica,sans-serif;
    color: white;
}
td.x-grid3-hd-over *.x-grid3-hd-inner, td.sort-desc *.x-grid3-hd-inner, td.sort-asc *.x-grid3-hd-inner, td.x-grid3-hd-menu-open *.x-grid3-hd-inner {
	background-color: gray !important;
	background-image: none !important;
}

#grid{
width: 100%;

}

.list-container-fitscreen {
    position: relative !important;
    top: 0%  !important;
    border: 5px solid #ffffff;
    left: 0%  !important;
    width: 100%;
    height: 550px  !important;
    overflow-x: auto;
}
.container {
     width: 100%;
     padding-right: 0px !important;
     padding-left: 0px !important;
     margin-right: 0px !important;
     margin-left: 0px !important;
}

#outerpanel{
width: 100% !important;
}
.x-window-tl {
			margin-top : 54px !important;
		}
		.container {
			margin-top : -14px !important;
		}
		#footSpan {
			margin-top : 14px !important;
			margin-right : 14px !important;
			font-size: 15px !important;
		}
		label {
			display : inline !important;
		}
</style>


<!-- <body oncontextmenu="return false;"> -->
	 <jsp:include page="../Common/LiveVisionExportJs.jsp"/>
	
		<div class="container" style=" margin-top: 1%;">
			<header>
				<select class="combobox" id="vehicletype" onchange="GRID();">
  					<option value="all"><%=all%></option>
  					<option value="comm"><%=communicating%></option>
  					<option value="noncomm"><%=nonCommunicating%></option>
  					<option value="noGPS"><%=noGPSConnected%></option>
  					<option value="running"><%=runningVehicle%></option>
  					<option value="stoppage"><%=stoppedVehicle%></option>
  					<option value="idle"><%=idleVehicle%></option>
				</select>					
				<h1><span><%=LiveVision%></span></h1>					
			</header>					
			<div class = "main" id="map">
			
			    <div class="mp-container" id="mp-container">
			            
			    <div class="mp-map-wrapper" id="map">
			    	<button type="button" class="button" id="listviewid"  onclick="changecolor();gridLoad();"><%=listView%></button>
			        <button type="button" class="button" id="mapviewid"  onclick="changecolor1();reszieFullScreen1();"  ><%=dashBoardMap%></button>
			        <button type="button" class="button" id="history_analysis"  onclick="changecolor2();showHistoryAnalysis();"><%=AnalysisOnMap%></button>
			        <input type="hidden" id="reglist"/>
			        <input type="text" name="search" id="search-input" placeholder="Search Vehicle" autocomplete="off" class="search" onclick="this.value = '';" onkeyup="searchClient()" onkeydown="searchClient()"/>
		            <iframe id="listviewcontainer" src="" scrolling='no'></iframe>
		            <iframe id="historyAnalysisContainer" src="" scrolling='yes'></iframe>	        
					<div id="grid"></div>
				</div>
				</div>
			</div>
			</div>		
		<script type="text/javascript">	
		if('<%=language%>'=='ar'){			
			document.documentElement.setAttribute("dir", "rtl");
			$.ajax({
			  url: "../../Main/Js/extjs_rtl.js",
			  dataType: "script",
			  async: true
			});
			$('head').append('<link rel="stylesheet" type="text/css" href="../../Main/resources/css/extjs_rtl.css">');
			
		}else if('<%=language%>'=='en'){
			document.documentElement.setAttribute("dir", "ltr");
		}	
	
	var userAuth = '<%=userAuthority%>' ;
	var value = '<%=sysId%>';
    if(userAuth == 'User' && value == 'true'){
		document.getElementById('history_analysis').style.display = 'none';
		document.getElementById('mapviewid').style.display = 'none';
    }
	
	<%if(category!=null){%>
	 document.getElementById('vehicletype').style.display = 'none';
	 document.getElementById('mapviewid').style.display = 'none';
	<%}%>
		Ext.Ajax.timeout = 360000;
		var grid;
		var markers = {};
		var outerPanel;
		var infowindows= {};
		var circles = [];
		var polygons =[];
		var buffermarkers = [];
		var polygonmarkers =[];
		var marker;	
		var map;
		var infowindow;
		var jspName="LiveVision";
		var circle;
		var button="Map";
		var selectAll="false";
		var processID=<%=processID%>;
		var exportDataType="<%=dataTypes%>";
		var ctsb;
		var $mpContainer = $('#mp-container');	
		var $mapEl = $('#map');	
		var loadMask = new Ext.LoadMask(Ext.getBody(), { msg: "Loading" });
		var previousVehicleType='<%=vehicleTypeRequest%>';
		var loadfirst = 1;
		document.getElementById("vehicletype").value='<%=vehicleTypeRequest%>';
//******************************** check session ************************//

function CheckSession() {
  						Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/MapView.do?param=checkSession',
                        method: 'POST',
                        success: function (response, options)
                        {
                        if(response.responseText=='InvalidSession')
                        {
                        window.location.href = "<%=request.getContextPath()%>/Jsps/Common/SessionDestroy.html";
                        }
                        },
                        failure: function ()
                        {
                        } 
                    });
            }		
	   
//*************************Serch Vehicle*******************************// 
	    function searchClient()
	    {
	    var val = document.getElementById("search-input").value;
		var cm = grid1.getColumnModel();
		var filter = grid1.filters.getFilter('vehiclenoindex');
 		filter.setValue(val);
 		if(val!="") {
 			 filter.setActive(true);
 		} else {
 			filter.setActive(false);
 		}
	}
	
//*************************Vehicle Type Change*******************************//
function GRID()
{
CheckSession();
document.getElementById("reglist").value='';
vehicleDetailsStore.load({
params:{custName:'<%=customernamelogged%>', jspName:jspName,vehicleType:document.getElementById("vehicletype").value,processID:processID,checkFDAS:'<%=checkFDAS%>' } });
var vehtype=document.getElementById("vehicletype").value;
$('#listviewcontainer').attr('src',"<%=path%>/Jsps/Common/MapViewCustom.jsp?vehicleType="+vehtype+"&processId=<%=processID%>");
}

function selectCheckedVehicles(){
		var cm = this.grid1.getColumnModel();
		var count=grid1.getSelectionModel().getCount();
		if(count<=500){
			var reg="";  	  
  	   	var count=0;
  	   		for (var i = 0, it = this.grid1.store.data.items, l = it.length; i < l; i++) 
            {
               if(this.grid1.getSelectionModel().isSelected(i))
                {
            	   var rec=grid1.store.getAt(i);
            	   
            	  if(count==0){
            	  reg=rec.data['vehiclenoindex']+"|";
            	  }else{
            	  reg=reg+rec.data['vehiclenoindex']+"|";
            	  }
            	  count++; 
            	}
            }	
		document.getElementById("reglist").value=reg;
		return true;
		}else{
		setMsgBoxStatus('<%=maxRecord%>');
         changecolor();
        return false;
		}
  	   
}


function reszieFullScreen1()
{        
		 if(selectCheckedVehicles()){
		 document.getElementById('search-input').style.visibility = 'hidden';
         Ext.getCmp('outerpanel').hide();
         document.getElementById('map').style.display = 'block';
         document.getElementById('grid').style.display = 'block';
         document.getElementById('listviewcontainer').style.display = 'block';
         document.getElementById('historyAnalysisContainer').style.display = 'none';
         var vehtype=document.getElementById("vehicletype").value; 
         $('#listviewcontainer').attr('src',"<%=path%>/Jsps/Common/MapViewCustom.jsp?vehicleType="+vehtype+"&processId=<%=processID%>");
         }                    
}
	function showHistoryAnalysis(){ 
		if (grid1.getSelectionModel().getCount() > 1) {
			setMsgBoxStatus('<%=SelectSingleRow%>');
        	return;
		}
		if (grid1.getSelectionModel().getCount() == 1) {			
	    	document.getElementById('search-input').style.visibility = 'hidden';
			Ext.getCmp('outerpanel').hide();
			document.getElementById('map').style.display = 'block';
			document.getElementById('grid').style.display = 'block';
			document.getElementById('listviewcontainer').style.display = 'none';
			document.getElementById('historyAnalysisContainer').style.display = 'block';
			var selectedCol = grid1.getSelectionModel().getSelected();
	        var vehicleNo = selectedCol.get('vehiclenoindex');
	        var hisTrackNew = true;
			$('#historyAnalysisContainer').attr('src',"<%=request.getContextPath()%>/Jsps/Common/HistoryAnalysis.jsp?vehicleNo="+vehicleNo+"&hisTrackNew="+hisTrackNew);
		}else{
			document.getElementById('search-input').style.visibility = 'hidden';
			Ext.getCmp('outerpanel').hide();
			document.getElementById('map').style.display = 'block';
			document.getElementById('grid').style.display = 'block';
			document.getElementById('listviewcontainer').style.display = 'none';
			document.getElementById('historyAnalysisContainer').style.display = 'block';
			recordstatus = "fromListView";
			if(loadfirst == 1){
			$('#historyAnalysisContainer').attr('src',"<%=request.getContextPath()%>/Jsps/Common/HistoryAnalysis.jsp?recordstatus="+recordstatus);
				loadfirst = 0;
			}
		}
	}
	
	function gridLoad(){
         button="Map";
         document.getElementById('search-input').style.visibility = 'visible';
         document.getElementById('listviewid').style.color='#02B0E6';
         document.getElementById('mapviewid').style.color='#fff';
         document.getElementById('listviewid').style.borderColor='#02B0E6';
         document.getElementById('mapviewid').style.borderColor='#fff';
         Ext.getCmp('outerpanel').show();
         document.getElementById('listviewcontainer').style.display = 'none';
         document.getElementById('historyAnalysisContainer').style.display = 'none';
         document.getElementById('grid').style.display = 'block';
         $mpContainer.addClass('list-container-fitscreen');
         outerPanel.render('grid'); 
         /* to refresh iframe 
         var iframe = document.getElementById('historyAnalysisContainer');
		 iframe.src = iframe.src; */
	}

var innerPanelForHubDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 110,
    width: 400,
    frame: true,
    id: 'custMaster',
    layout: 'table',
    layoutConfig: {
        columns: 3
    },
     items: [{
             xtype: 'label',
             text: 'Remarks:',
             cls: 'labelstyle',
             id: 'defaultDaysTxtId'
         },{
            xtype: 'textarea',
			readOnly: false,
 			width: 300,
 			maxLength: 500,
 			value: '',
 			cls: 'bskExtStyle',
            id: 'hubId'
         }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 110,
    width: 380,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    }, buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'addButtId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                    
                    if (innerPanelForHubDetails.getForm().isValid()) {
                        
                        var selectdName;
                        var selected = grid1.getSelectionModel().getSelected();
                        selectdName= selected.get('vehiclenoindex');
                        if(Ext.getCmp('hubId').getValue()=="")
                        {
   						 var message = 'Please enter Remarks';
                               setMsgBoxStatus(message);
                                myWin.hide();
                        }
                        else
                        {
                        taskMasterOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/MapView.do?param=AddRemarks',
                            method: 'POST',
                            params: {
                                selectdName:selectdName ,
                                jspName: jspName,
                                hubID:Ext.getCmp('hubId').getValue()
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                setMsgBoxStatus(message);
                                myWin.hide();
                                taskMasterOuterPanelWindow.getEl().unmask();
                                vehicleDetailsStore.reload();
                            },
                            failure: function () {
                                ctsb.setStatus({
                                    text: getMessageForStatus("Error"),
                                    iconCls: '',
                                    clear: true
                                });
                                
                                myWin.hide();
                            }
                        });
                        }
                    }
                }
            }
        }
    }, {
        xtype: 'button',
        text: '<%=Cancel%>',
        id: 'canButtId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                    Ext.getCmp('hubId').reset();
                    myWin.hide();
                }
            }
        }
    }]
});
 

var taskMasterOuterPanelWindow = new Ext.Panel({
    width: 390,
    height:175,
    standardSubmit: true,
    frame: false,
    items: [innerPanelForHubDetails, innerWinButtonPanel]
  });

myWin = new Ext.Window({
    title: 'My win',
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 195,
    width: 390,
    id: 'myWin',
    items: [taskMasterOuterPanelWindow]
});
 
 function addRecord() {
    if (grid1.getSelectionModel().getCount() == 0) {
        setMsgBoxStatus('<%=NoRowsSelected%>');
       
        return;
    }
    if (grid1.getSelectionModel().getCount() > 1) {
        setMsgBoxStatus('<%=SelectSingleRow%>');
         
        return;
    }
    var selected = grid1.getSelectionModel().getSelected();
    Ext.getCmp('hubId').setValue(selected.get('remarksindex'));
    buttonValue = 'add';
    titelForInnerPanel = 'Add Remarks';
    myWin.setPosition(450, 150);
    myWin.setTitle(titelForInnerPanel);
    
    myWin.show();
}

 function refreshRecord() {
    CheckSession();
    document.getElementById("reglist").value='';
    vehicleDetailsStore.reload();
}

function readFilterSelectionDetails(){
var locationPage = '<%=request.getContextPath()%>/Jsps/CargoManagement/AddFilter.jsp?processId=<%=processID%>&systemid=<%=systemid%>&checkFDAS=<%=checkFDAS%>&language=<%=language%>';
      createMapWindow(locationPage, "User Setting");
}

function changecolor()
{
document.getElementById('listviewid').style.color='#02B0E6';
document.getElementById('mapviewid').style.color='#fff';
document.getElementById('listviewid').style.borderColor='#02B0E6';
document.getElementById('mapviewid').style.borderColor='#fff';
document.getElementById('history_analysis').style.color='#fff';
document.getElementById('history_analysis').style.borderColor='#fff';
}
function changecolor1()
{
document.getElementById('listviewid').style.color='#fff';
document.getElementById('mapviewid').style.color='#02B0E6';
document.getElementById('listviewid').style.borderColor='#fff';
document.getElementById('mapviewid').style.borderColor='#02B0E6';
document.getElementById('history_analysis').style.color='#fff';
document.getElementById('history_analysis').style.borderColor='#fff';
}
function changecolor2()
{
document.getElementById('listviewid').style.color='#fff';
document.getElementById('listviewid').style.borderColor='#fff';
document.getElementById('mapviewid').style.color='#fff';
document.getElementById('mapviewid').style.borderColor='#fff';
document.getElementById('history_analysis').style.color='#02B0E6';
document.getElementById('history_analysis').style.borderColor='#02B0E6';
}
function changecolor3()
{
document.getElementById('listviewid').style.color='#fff';
document.getElementById('listviewid').style.borderColor='#fff';
document.getElementById('mapviewid').style.color='#fff';
document.getElementById('mapviewid').style.borderColor='#fff';
document.getElementById('history_analysis').style.color='#fff';
document.getElementById('history_analysis').style.borderColor='#fff';
}


var reader1 = new Ext.data.JsonReader({
    idProperty: 'cashVanDetailsid',
    root: 'cashVanListDetailsRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex',
         type: 'int'
    }, 
    <%=liveVisionColumns.getGridReaders(processID,checkFDAS).toString()%>
     {
        name: 'id'
    }]
});

  var vehicleDetailsStore = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/MapView.do?param=getLiveVisionVehicleDetails',
        method: 'POST'
    }),
    storeId: 'taskMasterid',
    reader: reader1
});

var filters1 = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, <%=liveVisionColumns.getFilterList().toString()%>]
});


var selModel = new Ext.grid.CheckboxSelectionModel({
     	singleSelect : false,
     	checkOnly : true
     	     	
 		});

var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            filter: {
                type: 'numeric'
            }
        },selModel, <%=liveVisionColumns.getGridHeaderBuffer(processID,language,checkFDAS,systemid,customeridlogged,userId).toString()%>
    ];
    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: true
        }
    });
}; 
function viewFuelPercentage(grid1,rowIndex,columnIndex,e)
 {
	var record = grid1.getStore().getAt(rowIndex);  // Get the Record
	var fieldName = grid1.getColumnModel().getDataIndex(columnIndex); // Get field name	
	var data = record.get(fieldName);						
	if(columnIndex == grid1.getColumnModel().findColumnIndex('fuelguageindex'))
	{	selModel.selectRow(rowIndex,true);
		var record = grid1.getStore().getAt(rowIndex); 
		viewFuel(record);	
	  } 	
}
 //**************************************GRID***************************************************************
    var grid1= getLiveVisionGrid('', 'No Records Found', selModel,vehicleDetailsStore, screen.width - 35, screen.height-295, 40, true,'Refresh',filters1, 'Clear Filter Data', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', true, 'Acknowledge', false, 'Modify',true,'User Setting');
        outerPanel = new Ext.Panel({
        id:'outerpanel',
        bodyCssClass: 'outerpanellistview',
        autoScroll:true,
        width:screen.width-30,
        layoutConfig: {
            columns: 1
        },
        items: [grid1],
        bbar: ctsb
       
    });

 Ext.onReady(function () {
    gridLoad();
     var systemid = '<%=systemid%>';
		 if(parseInt(systemid) == 27 && ( <%=customeridlogged%> == 2123 || <%=customeridlogged%> == 5020 || <%=customeridlogged%> == 5196 || <%=customeridlogged%> == 5206)){
		 	setInterval('refreshRecord()',20000);  
		 }else{
		 	setInterval('refreshRecord()',500000);  
		 }
    vehicleType="";
    if(previousVehicleType!=null && previousVehicleType!=""){
    	vehicleType=previousVehicleType;
    }
     <% if(category!=null){ %>
	    vehicleDetailsStore.load({
		params:{custName:'<%=customernamelogged%>',jspName:jspName,category:'<%=category%>',processID:processID,checkFDAS:'<%=checkFDAS%>' } });
	 <% }else { %>
	    vehicleDetailsStore.load({
		params:{custName:'<%=customernamelogged%>',jspName:jspName,vehicleType:vehicleType,processID:processID,checkFDAS:'<%=checkFDAS%>' } });
	<%}%>
	if('<%=language%>'=='en'){
		$('head script[src*="extjs_rtl.js"]').remove();
		$('link[rel=stylesheet][href~="../../Main/resources/css/extjs_rtl.css"]').remove();
		$('.x-toolbar-right').attr('style','width:100% !important'); 
	}
  	
});

/*---------------Fuel Guage-----------------------------*/
 function viewFuel(rec)
{
	var cm = this.grid1.getColumnModel();
 	var reg="";
 	var loc="";
 	var vehicleNo=""; 
 	var r = {};
 	
  
    	   loc = rec.data['Location'];
    	   if(loc != "No GPS Device Connected"){    		    		    
    		    var v = rec.data['vehiclenoindex'];    		 
    		    vehicleNo=v.replace(/ /gi,"%20");
	        	var strReplaceAll = v;	        	
	        	var intIndexOfMatch = strReplaceAll.indexOf(" ");				
				     while (intIndexOfMatch != -1){				
					     strReplaceAll = strReplaceAll.replace(" ");
					     intIndexOfMatch = strReplaceAll.indexOf(" ");
				     }
				reg=vehicleNo;
								
	    	   }
    
    
    if(reg=="" )
  	{
    	
   		Ext.MessageBox.show({
   					msg: 'Please select atleast one vehicle to view % of fuel.',
                    buttons: Ext.MessageBox.OK		
   			});
  	}else{
  		var fuelpage="/jsps/FuelGauge.jsp?reg="+reg;
 		openFuelWindow(fuelpage);
	    }
}     

var fuelPopUpWindow;
function openFuelWindow(fuelpage)
{	 	
	if(fuelPopUpWindow){	
		fuelPopUpWindow.close();
	 }  	
	fuelPopUpWindow= new Ext.Window({
 	title : 'Fuel Gauge',
	autoShow : false,
	constrain : false,
	constrainHeader : false,
	resizable : false,
	maximizable : true,
	buttonAlign : "center",
	width:250,
    height:310,
	plain : false, 
	footer : true,
	autoScroll: false,
	closable : true,
	stateful : false,
	html : "<iframe style='width:100%;height:100%' src="+fuelpage+"></iframe>",	
	scripts:true,
	shim : false	
	});
	fuelPopUpWindow.show();
	
}
        
	</script>
	 <jsp:include page="../Common/footer.jsp" />
   <!-- </body>  -->
  <!--    </html>   -->
