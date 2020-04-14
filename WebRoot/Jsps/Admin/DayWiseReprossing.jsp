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
  tobeConverted.add("Select_Customer_Name");
  tobeConverted.add("Customer_Name");
  tobeConverted.add("Vehicle_No");
  tobeConverted.add("select_vehicle_No");
  tobeConverted.add("Date");
  tobeConverted.add("Select_Date");
  tobeConverted.add("Reprocess");
  tobeConverted.add("Day_Wise_Reprocessing");
  
  
  ArrayList<String> convertedWords = new ArrayList<String>();
  convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
  String SelectCustomer = convertedWords.get(0);
  String CustomerName = convertedWords.get(1);
  String vehicle=convertedWords.get(2);
  String selectVehicle=convertedWords.get(3);
  String date=convertedWords.get(4);
  String selectDate=convertedWords.get(5);
  String reprocess=convertedWords.get(6);
  String dayWiseReprocessing=convertedWords.get(7);
  
  %>

 <jsp:include page="../Common/header.jsp" />   
 <title><%=dayWiseReprocessing%></title>
 
 

 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
<jsp:include page="../Common/ImportJSSandMining.jsp"/>
<%}else {%>
<jsp:include page="../Common/ImportJS.jsp" /><%} %>
  <!--   for exporting to excel***** -->
 <jsp:include page="../Common/ExportJS.jsp" />
 <style>
	.ext-strict .x-form-text {
    height: 21px !important;
}
 </style>
  <script type="text/javascript" src="../../Main/Js/jsapi.js"></script>
 <script>
 var outerPanel;
 var ctsb;
 var jspName="DayWiseReprocessing";
 var dtcur = datecur.add(Date.DAY, -1); 
 var globalClientId ;
 
 var customercombostore= new Ext.data.JsonStore({
			       url:'<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
				   id:'CustomerStoreId',
			       root: 'CustomerRoot',
			       autoLoad: true,
			       remoteSort: true,
				   fields: ['CustId','CustName'],
				   listeners: 
				   {
	    				load: function(custstore, records, success, options) 
	    				{
	        				 if(<%=customerId%>>0)
	        				 {
					 			Ext.getCmp('custcomboId').setValue('<%=customerId%>');
					 			globalClientId=Ext.getCmp('custcomboId').getValue();
	                	        globalClientId='<%=customerId%>';
	                         	vehiclecombostore.load({
								params:{CustId : globalClientId}
								});
                        		
					 		 }
	    				}
    			  }
});


	
 var custnamecombo=new Ext.form.ComboBox({
	        store: customercombostore,
	        id:'custcomboId',
	        mode: 'local',
	        forceSelection: true,
	        emptyText:'<%=SelectCustomer%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'CustId',
	    	displayField: 'CustName',
	    	cls:'selectstylePerfect',
	    	listeners: 
	    	{
                  select: 
                  {
                	   fn:function()
                	   {    
                	        Ext.getCmp('vehicleComboId').reset();
                	        globalClientId=Ext.getCmp('custcomboId').getValue();
                         	vehiclecombostore.load({
							params:{CustId : globalClientId}
							});
							}
				  }
 			}
 });
 
  var vehiclecombostore= new Ext.data.JsonStore({
			       url:'<%=request.getContextPath()%>/DayWiseReprocessAction.do?param=getVehicle',
				   id:'VehicleStoreId',
			       root: 'VehicleRoot',
			       autoLoad: false,
			       remoteSort: true,
				   fields: ['VehiName','VehiName']
				   });
				   
				   
				   
 var vehicleCombo=new Ext.form.ComboBox({
            store: vehiclecombostore,
	        id:'vehicleComboId',
	        mode: 'local',
	        forceSelection: true,
	        emptyText:'<%=selectVehicle%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'VehiName',
	    	displayField: 'VehiName',
	    	enableKeyEvents:true,
	    	cls:'selectstylePerfect',
	    	listeners: 
	    	{
                  select: 
                  {
                	   fn:function()
                	   {
                	   		globalClientId=Ext.getCmp('custcomboId').getValue();
                	   		vehicleNo=Ext.getCmp('vehicleComboId').getValue();
                       }
				  }
 			}
 });
 
 var innerPanel = new Ext.Panel({
 			standardSubmit: true,
            frame: true,
            id:'innerpanelid',
			cls:'innerpanelpercentage',
            layout:'table',
		    layoutConfig: {
			columns:2
		    },
			items: [
			{
					xtype: 'label',
					text: '<%=CustomerName%>'+':',
					cls:'labelstyle',
					id:'custnamelab'
			    },
				custnamecombo,{height:20},{height:20},
				{
					xtype: 'label',
					text: '<%=vehicle%>'+':',
					cls:'labelstyle',
					id:'groupnamelab'
				},
				vehicleCombo,{height:20},{height:20},
				{
					xtype: 'label',
					cls:'labelstyle',
					id:'datelab',
					text: '<%=date%>'+':'
				},
				{
					xtype:'datefield',
		    		cls:'selectstylePerfect',
		    		format:getDateFormat(),
		    		emptyText:'<%=selectDate%>',
		    		allowBlank: false,
		    		blankText :'<%=selectDate%>',
		    		id:'date',
		    		maxValue:dtcur,
		    		value:dtcur
		   	   },
		   	   {cls:'labelstyle'},{height:20},{height:20},
	    		{
	       			xtype:'button',
	      			text:'<%=reprocess%>',
	        		id:'reprocessbuttonid',
	        		cls:'buttonstyle ',
	        		width:80,
	        		listeners: 
	       			{
		        		click:
		        		{
			       			fn:function()
			       			{
			       			   if(Ext.getCmp('custcomboId').getValue() == "" )
							    {
							         Ext.example.msg("<%=SelectCustomer%>");
				                      	 Ext.getCmp('custcomboId').focus();
				                      	 return;
							    }
							    if(Ext.getCmp('vehicleComboId').getValue() == "" )
							    {
							             Ext.example.msg("<%=selectVehicle%>");
				                      	 Ext.getCmp('vehicleComboId').focus();
				                      	 return;
							    }
							   
							    if(Ext.getCmp('date').getValue() == "" )
							    {
							         Ext.example.msg("<%=selectDate%>");
				                     Ext.getCmp('date').focus();
				                     return;
							    }
							   innerPanel.getEl().mask();
							   Ext.Ajax.request({
					 				url: '<%=request.getContextPath()%>/DayWiseReprocessAction.do?param=reProcess',
									method: 'POST',
									params: 
									{ 
									     custName:Ext.getCmp('custcomboId').getValue(),
										 vehicleNo:Ext.getCmp('vehicleComboId').getValue(),
										 date:Ext.getCmp('date').getValue(),
									},
									success:function(response, options)//start of success
									{
									  Ext.example.msg(response.responseText);
								      innerPanel.getEl().unmask();
								      Ext.getCmp('custcomboId').reset(); 
									  Ext.getCmp('vehicleComboId').reset();
							    },
								    failure: function()//start of failure 
								    {
								     Ext.example.msg("error");
									 myWin.hide();
									 enableTabElements();
									 innerPanel.getEl().unmask();
									 Ext.getCmp('custcomboId').reset(); 
									Ext.getCmp('vehicleComboId').reset();
							    }
									});   
								}
	        		}
	        		}
	        		}]
	        		});
 
  Ext.onReady(function()
    {
	ctsb=tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';		         	   			
 	outerPanel = new Ext.Panel({
 			title:'<%=dayWiseReprocessing%>',
			renderTo: 'content',
            standardSubmit: true,
            id:'outerPanel',
            frame: true,
            height:550,
			cls: 'mainpanelpercentage',
            items:[innerPanel]
			//bbar:ctsb			
			}); 
			sb = Ext.getCmp('form-statusbar');
			});
 </script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
 