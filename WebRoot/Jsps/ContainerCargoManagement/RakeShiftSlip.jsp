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
	loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
	session.setAttribute("loginInfoDetails",loginInfo);
	
}
	
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();

ArrayList<String> tobeConverted = new ArrayList<String>();

tobeConverted.add("Modified_Date_Time");
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("SLNO");
tobeConverted.add("Id");
tobeConverted.add("Delete");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("Excel");



ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String ModifiedDateTime=convertedWords.get(0);
String Add=convertedWords.get(1);
String Modify=convertedWords.get(2);
String NoRecordsFound=convertedWords.get(3);
String ClearFilterData=convertedWords.get(4);
String SLNO=convertedWords.get(5);
String ID=convertedWords.get(6);
String Delete=convertedWords.get(7);
String NoRowsSelected=convertedWords.get(8);
String SelectSingleRow=convertedWords.get(9);
String Save=convertedWords.get(10);
String Cancel=convertedWords.get(11);
String Excel=convertedWords.get(12);


int userId=loginInfo.getUserId(); 

%>
<!DOCTYPE HTML>
<html>
 <head>
 		<title>Rake Shift Slip</title>		
</head>	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	.buttonStyle {
	text-align: center;
	}
  </style>
  <body onload=setValue();>
  <div id="clientdiv">
		</div>
		<div id="panel">
		</div>
	
		<table align="center">
			<tr>
				<td id="container"></td>
			</tr>
		</table>
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<jsp:include page="../IronMining/css.jsp" />
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
	<jsp:include page="../IronMining/css.jsp" />
	<%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script>
   
var outerPanel;
var ctsb;
var jspName = "Rake Approval";
var exportDataType = "";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var editedRows = "";
var globalClientId = "";

 function setValue()
  	{
  		Ext.getCmp('tripnoid').setValue('customTripId');
  		Ext.getCmp('vehicleId').setValue('KA17M3959');
  	}
	function openmywindow(clientId1, tripno1, type1, diesel1, dieall, subtripId, issubtrip, AdditionalDiesel, tripStatus) {
                                        var previouspopup = new Ext.Window({
                                            title: "Diesel Allocation",
                                            autoShow: false,
                                            constrain: true,
                                            constrainHeader: false,
                                            resizable: false,
                                            maximizable: false,
                                            buttonAlign: "center",
                                            id: 'my2',
                                            width: 550,
                                            height: 450,
                                            plain: false,
                                            footer: true,
                                            closable: true,
                                            stateful: false,
                                            html: "<iframe style='width:100%;height:100%' src=<%=request.getContextPath()%>/Jsps/ContainerCargoManagement/RakeShiftAllocateFuel.jsp?clientid=" + clientId1 + "&tripid=" + tripno1 + "&type=" + type1 + "&diesel=" + diesel1 + "&dieall=" + dieall + "&subtripId=" + subtripId + "&issubtrip=" + issubtrip + "&AdditionalDiesel=" + AdditionalDiesel + "&tripStatus=" + tripStatus + "></iframe>",
                                            scripts: true,
                                            shim: false
                                        });
                                        previouspopup.setPosition(50, 50);
                                        previouspopup.show();
                                    }
  	 var SubmitButton = new Ext.Panel({
				layout:'table',
				height: 50,
				buttonAlign:'center',
				layoutConfig: {
						columns: 15
				},
				items: [{		
			      	text: 'Allocate Diesel',
				        xtype: 'button',
				        width: 20,
				       <%-- disabled:<%=allocate%>,  --%>
				        cls: 'bskExtStyle',
				        id: 'ADId',
				        handler: function()
				        {
				            var clientId1='782';
	 						var tripno1='123';
	 						var type1='Type';
	 						var diesel1='diesel';
	 						var dieall='DieAll';
	 						var STid1='';
	 						var FromSubTrip="no";
	 						var AdditionalDiesel='AdditionalDiesel';
	 						var tripStatus = 'tripStatus';  
	 						
					        openmywindow(clientId1,tripno1,type1,diesel1,dieall,STid1,FromSubTrip,AdditionalDiesel,tripStatus);
					        
					   //     setTimeout('window.parent.printAllslipspopup.close()',500)
					        	
					          // parent.openWindow("fdrfg","Diesel","<%=request.getContextPath()%>/jsps/TDP_LMS_jsps/AllocateFuel.jsp?clientid="+clientId1+"&tripid="+tripno1+"&type="+type1+"&diesel="+diesel1,940,600);
			      		
			      		}	
					},{width:5},{		
			      	text: 'Diesel Slip',
			      		id:'dieselSlipId',
				        xtype: 'button',
				        width: 20,
				        id:'DSId',
				    <%--    disabled:<%=dieselSlipButtonDisplay%>,  --%>
				        cls: 'bskExtStyle',
				        handler: function()
				        {
				        	//dieselSlipPdf();
			      		}	
				}
				]
				});
  	var tripnoText = new Ext.form.TextField({
				fieldLabel: 'Trip Chart No',
				width: 180,
				labelWidth: 140,
				name: 'tripno',
				labelSeparator: '',
				id: 'tripnoid',
				align:'center',
				readOnly: true,	
				value: '',
				maxLength: 30
	    	});	

  	var customerText = new Ext.form.TextField({
				fieldLabel: 'Vehicle No',
				width: 180,
				labelWidth: 140,
				align:'center',
				name: 'vehicleNo',
				labelSeparator: '',
				id: 'vehicleId',
				readOnly: true,	
				value: '',
				maxLength: 100
	    	});

  		Ext.onReady(function()
  		{
			Ext.QuickTips.init();
			var timewindowform1 = new Ext.FormPanel({
      					width: 400,
      					frame:true,
      					renderTo:'container',
      					align:'center',
	    			 	items: [tripnoText,{height:20},customerText,{height:20}]
      					});		 
              
		new Ext.Panel({
			 renderTo:'container',
			 title:'Builty Print/Diesel Slip/Driver Voucher',
			 width:450,
			 //height:290,
			 frame:true,
		 	 align:'center',
			 items: [timewindowform1,{height:20},SubmitButton],
        	})
		  
		});

</script>
</body>
</html>
<%}%>