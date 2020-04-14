<%@ page language="java"
	import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	int systemid=Integer.parseInt(str[0].trim());
	int customerid=Integer.parseInt(str[1].trim());
	int userid=Integer.parseInt(str[2].trim());
	String clientID=request.getParameter("cutomerID");
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
	int custidpassed=0;
if(request.getParameter("cutomerIDPassed")!= null)
{
custidpassed=Integer.parseInt(request.getParameter("cutomerIDPassed"));
}
	
	ArrayList<String> tobeConverted = new ArrayList<String>();
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Select_Customer");
	tobeConverted.add("Battery_Health");
	tobeConverted.add("System_Health");
	tobeConverted.add("Excess_Alert");
	tobeConverted.add("Excess_Data");
	
	
	
	
	ArrayList<String> convertedWords = new ArrayList<String>();
	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
	String CustomerName = convertedWords.get(0);
	String SelectCustomer = convertedWords.get(1);
	String BatteryHealth = convertedWords.get(2);
	String SystemHealth = convertedWords.get(3);
	String ExcessAlert = convertedWords.get(4);
	String ExcessData = convertedWords.get(5);


%>

<jsp:include page="../Common/header.jsp" />
<style>
.mystyle1{
margin-left:10px;
}
.ext-strict .x-form-text {
	height : 21px !important;
}
div#content {
	height : 254px !important;
}
</style>
 
        <title>
           <%=SystemHealth%>
        </title>
  
    
    
    <div height="100%">
        <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
        <!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
        
    <script type="text/javascript" src="../../Main/Js/jsapi.js"></script>
   	<script>
    google.load("visualization", "1", {packages:["corechart"]});
 var outerPanel;
 var ctsb;
 
	 var customercombostore = new Ext.data.JsonStore({
            url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
            id: 'CustomerStoreId',
            root: 'CustomerRoot',
            autoLoad: true,
            remoteSort: true,
            fields: ['CustId', 'CustName'],
            listeners: {
                load: function (custstore, records, success, options) {
                     if(<%=custidpassed%>>0)
     					{
     					Ext.getCmp('CustomerNameId').setValue('<%=custidpassed%>');
     					systemhealthPieChart();
     					Chart1();
     					Chart2();
     					}
                   else if ( <%= customerId %> > 0) {
                        Ext.getCmp('CustomerNameId').setValue('<%=customerId%>');
                        systemhealthPieChart();
                        Chart1();
                        chart2();
                    }
                }
            }
        });
         
        var CustomerName = new Ext.form.ComboBox({
            store: customercombostore,
            id: 'CustomerNameId',
            mode: 'local',
            hidden: false,	
            resizable: true,
            forceSelection: true,
            emptyText: '<%=SelectCustomer%>',
            blankText: '<%=SelectCustomer%>',
            selectOnFocus: true,
            allowBlank: false,
            typeAhead: true,
            triggerAction: 'all',
            lazyRender: true,
            valueField: 'CustId',
            displayField: 'CustName',
            cls: 'selectstylePerfect',
            listeners: {
                select: {
                    fn: function () {
                    systemhealthPieChart();
                    Chart1();
                    Chart2();
                    }
                }
            }
        });
    
 
 var store=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/CommonAction.do?param=getBatteryVoltage',
				id:'SystemId',
				root: 'Systemroot',
				autoLoad: false,
				remoteSort: true,
				fields: ['goodcountIndex','poorcountIndex']
		});	

		
		
		

		function systemhealthPieChart() {
                    store.load({
                        params: {CustId:Ext.getCmp('CustomerNameId').getValue()},
                        callback  : function() {
                        			Ext.getCmp('systemhealthid').setVisible(true);
                        			var rec = store.getAt(0);
  									var goodcount=rec.data['goodcountIndex'];   
  									var poorcount=rec.data['poorcountIndex']; 
  									var systemhealthgraph=new google.visualization.PieChart(document.getElementById('systemhealthdiv'));
  									  var data = google.visualization.arrayToDataTable([
    								        ['Health', 'count'],
    										['Good', parseInt(goodcount)],
    										['Poor', parseInt(poorcount)]
  										]);
  									var options = {
  									titleTextStyle:{color:'#686262',fontSize:16,align:'center'},
          							pieSliceText: "value",
          							forceIFrame: true,
          							is3D:true,
          							colors:['#61D961','#CC3300',],
          							width:200,
          							height:250,
          							legend:{position: 'bottom'}
        							};
      								systemhealthgraph.draw(data,options);  
      								google.visualization.events.addListener(systemhealthgraph, 'select',function(){			 
                    var selection = systemhealthgraph.getSelection(); 
                    var status='';
                    if(selection[0].row==0)
                    {
                    status='Good';
                    }
                    else 
                    {
                    status='Poor';
                    }
                    var customerIdPassed=Ext.getCmp('CustomerNameId').getValue();
                    window.location ="<%=request.getContextPath()%>/Jsps/Common/SystemHealthDetails.jsp?cutomerID="+customerIdPassed+"&status="+status;	
                    });	
                    }		
      				});   					
      				}
      				
      				function Chart1() {
                    store.load({
                        params: {CustId:Ext.getCmp('CustomerNameId').getValue()},
                        callback  : function() {
                        			Ext.getCmp('chart1id').setVisible(true);
                        			
                        	  		}			
      				});
      				}
      				
      				function Chart2() {
                    store.load({
                        params: {CustId:Ext.getCmp('CustomerNameId').getValue()},
                        callback  : function() {
                        			Ext.getCmp('chart2id').setVisible(true);
                        			
                        	  		}			
      				});
      				}
      				
                  
		var graphpannel=new Ext.Panel({
			frame:true,
			hidden:false,
			border:false,
			padding: '1',
			width:screen.width-40,
			height:screen.height-240,
			//bodyCfg : {style: {'padding-left': '05% !important'}},
			id:'systemhealthpanelid',
		    layout:'table',
		    layoutConfig:{columns:5},
			items: [CustomerName,
                	{width:10,height:50},{width:10,height:50},{width:10,height:50},{width:10,height:50},
       				{
       				 xtype:'panel',
       				 title:'<%=BatteryHealth%>',
	    			 id:'systemhealthid',
	    			 width:'100%',
	    			 hidden:true,
	    			 frame:true,
	     			 border:true,
       	 			 html : '<table width="100%"><tr><tr> <td> <div id="systemhealthdiv" align="left"> </div></td></tr></table>'
       				},
       				{width:30,height:50},
					
       				{
       				 xtype:'panel',
       				 title:'<%=ExcessData%>',
	    			 id:'chart1id',
	    			 width:'100%',
	    			 hidden:true,
	    			 frame:true,
	     			 border:true,
	     			 html : '<table width="100%"><tr><tr> <td> <div id="content" style="background-color:#FFFFFF;height:150px;width:205px;float:left;text-align: center;font-size: 20px;padding-top: 50%;">Coming Soon</div></td></tr></table>'
       	 			 },
       	 			{width:30,height:50},
       	 			 {
       				 xtype:'panel',
       				 title:'<%=ExcessAlert%>',
	    			 id:'chart2id',
	    			 width:'100%',
	    			 hidden:true,
	    			 frame:true,
	     			 border:true,
	     			 html: '<table width="100%"><tr><tr> <td> <div id="content" style="background-color:#FFFFFF;height:150px;width:205px;float:left;text-align: center;font-size: 20px;padding-top: 50%;">Coming Soon</div></td></tr></table>'
       	 			 }
       	 			 
       			]
			});

		
		//***************************  Main starts from here **************************************************
    Ext.onReady(function(){
    ctsb = tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';	
 	outerPanel = new Ext.Panel({
			renderTo : 'content',
			standardSubmit: true,
			width:screen.width-22,
			height: screen.height-215,
			frame:true,
			border:false,
			cls:'outerpanel',
			items: [graphpannel]
			});
	});
	

   </script>
	 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
