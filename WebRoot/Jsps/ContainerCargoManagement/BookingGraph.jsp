<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8" %>
<% String path=request.getContextPath(); String basePath=request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
     if(request.getParameter( "list")!=null){ 
	     String list=request.getParameter( "list").toString().trim(); 
	     String[] str=list.split( ","); 
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
		   } if(str.length>9){ 
	     			loginInfo.setCategoryType(str[9].trim()); 
	    		} if(str.length>10){ 
	     				loginInfo.setUserName(str[10].trim()); 
	     			} if(str.length>11){
	     				loginInfo.setStyleSheetOverride(str[11].trim()); 
	     				} 
	     session.setAttribute("loginInfoDetails",loginInfo); 
     } 
     CommonFunctions cf = new CommonFunctions(); 
     cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response); 
     String responseaftersubmit="''"; String feature="1"; 
     if(session.getAttribute("responseaftersubmit")!=null){ 
	     responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'"; 
	     session.setAttribute("responseaftersubmit",null); 
     } 
     LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails"); 
     String language = loginInfo.getLanguage(); 
     int systemId = loginInfo.getSystemId(); 
     int customerId = loginInfo.getCustomerId(); 
     
     ArrayList<String>tobeConverted = new ArrayList<String>(); 
     
     tobeConverted.add("Start_Date"); 
     tobeConverted.add("Select_Start_Date"); 
     tobeConverted.add("End_Date"); 
     tobeConverted.add("Select_End_Date"); 
     tobeConverted.add("Submit"); 
     tobeConverted.add("Month_Validation"); 
     tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date"); 
     tobeConverted.add("Select_client"); 
     tobeConverted.add("Please_Select_Client"); 
     tobeConverted.add("Client_Name"); 
     tobeConverted.add("Booking_Graph"); 
     
     ArrayList<String>convertedWords = new ArrayList <String>(); 
     convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language); 
     
     String StartDate = convertedWords.get(0); 
     String SelectStartDate = convertedWords.get(1); 
     String EndDate = convertedWords.get(2); 
     String SelectEndDate = convertedWords.get(3); 
     String Submit = convertedWords.get(4); 
     String monthValidation = convertedWords.get(5); 
     String EndDateMustBeGreaterthanStartDate = convertedWords.get(6); 
     String Selectclient = convertedWords.get(7); 
     String PleaseSelectClient = convertedWords.get(8); 
     String ClientName = convertedWords.get(9); 
     String BookingGraph = convertedWords.get(10); 
 %>
 
<!DOCTYPE HTML>
<html class="largehtml">
	<head>
		  <title>
	          <%=BookingGraph%>
	      </title>
	  </head>
	<body class="largebody">
	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
		
      <!--   for exporting to excel***** -->
      
     <jsp:include page="../Common/ExportJS.jsp" />
     <script type="text/javascript" src="../../Main/Js/jsapi.js"></script>
      
    <script>
          google.load("visualization", "1", {
              packages: ["corechart"]
          });
          var outerPanel;
          var ctsb;
          var globalClientId;
          var wait = 0;
          var clientNameStore = new Ext.data.JsonStore({
              url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
              id: 'clientNameStoreId',
              root: 'CustomerRoot',
              autoLoad: true,
              remoteSort: true,
              fields: ['CustId', 'CustName']
          });
          clientNameStore.on('load', function() {
              if (clientNameStore.data.items.length == 1) {
                  var rec = clientNameStore.getAt(0);
                  Ext.getCmp('clientid').setValue(rec.data['clientId']);
                  globalClientId = Ext.getCmp('clientid').getValue();
              }
          });
          var CountStore = new Ext.data.JsonStore({
              url: '<%=request.getContextPath()%>/BookingGraphAction.do?param=GetCount',
              id: 'CountId',
              root: 'CountstoreList',
              autoLoad: true,
              remoteSort: true,
              fields: ['SANAND', 'JODHPUR', 'KHODIYAR', 'JAIPUR', 'DELHI', 'MUMBAI', 'KANDLA/MUMDRA', 'PIPAVAV', 'VAPI', 'bookingType']
          });
          var clientCombo = new Ext.form.ComboBox({
              id: 'clientid',
              name: 'client',
              triggerAction: 'all',
              mode: 'local',
              width: 175,
              anyMatch: true,
              onTypeAhead: true,
              minChars: 1,
              resizable: true,
              emptyText: '<%=Selectclient%>',
              store: clientNameStore,
              valueField: 'CustId',
              displayField: 'CustName',
              selectOnFocus: true,
              forceSelection: true,
              labelSeparator: '',
              enableKeyEvents: true,
              listeners: {
                  select: {
                      fn: function() {
                          globalClientId = Ext.getCmp('clientid').getValue();
                      }
                  }
              }
          });
          var comboPanel = new Ext.Panel({
              standardSubmit: true,
              collapsible: false,
              id: 'comboId',
              layout: 'table',
              frame: true,
              height: 50,
              width:screen.width-42,
              layoutConfig: {
                  columns: 14
              },
              items: [{
                      width: 50
                  }, {
                      xtype: 'label',
                      text: '<%=ClientName%> ' + ' :',
                      cls: 'labelstyle'
                  }, {
                      width: 10
                  },
                  clientCombo,  {
                      width: 50
                  }, {
                      xtype: 'label',
                      cls: 'labelstyle',
                      id: 'startdatelab',
                      text: '<%=StartDate%>' + ':'
                  }, {
                      width: 10
                  }, {
                      xtype: 'datefield',
                      cls: 'selectstylePerfect',
                      format: getDateFormat(),
                      emptyText: '<%=SelectStartDate%>',
                      allowBlank: false,
                      blankText: '<%=SelectStartDate%>',
                      id: 'startdate'
                  }, {
                      width: 50
                  }, {
                      xtype: 'label',
                      cls: 'labelstyle',
                      id: 'enddatelab',
                      text: '<%=EndDate%>' + ':'
                  }, {
                      width: 10
                  }, {
                      xtype: 'datefield',
                      cls: 'selectstylePerfect',
                      format: getDateFormat(),
                      emptyText: '<%=SelectEndDate%>',
                      allowBlank: false,
                      blankText: '<%=SelectEndDate%>',
                      id: 'enddate'
                  }, {
                      width: 50
                  }, {
                      xtype: 'button',
                      text: '<%=Submit%>',
                      id: 'addbuttonid',
                      cls: ' ',
                      width: 50,
                      listeners: {
                          click: {
                              fn: function() {
                                  if (Ext.getCmp('clientid').getValue() == "") {
                                      Ext.example.msg("<%=PleaseSelectClient%>");
                                      Ext.getCmp('clientid').focus();
                                      return;
                                  }
                                  if (Ext.getCmp('startdate').getValue() == "") {
                                      Ext.example.msg("<%=SelectStartDate%>");
                                      Ext.getCmp('startdate').focus();
                                      return;
                                  }
                                  if (Ext.getCmp('enddate').getValue() == "") {
                                      Ext.example.msg("<%=SelectEndDate%>");
                                      Ext.getCmp('enddate').focus();
                                      return;
                                  }
                                  if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                                      Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                                      Ext.getCmp('enddate').focus();
                                      return;
                                  }
                                  if (checkMonthValidation(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue())) {
                                      Ext.example.msg("<%=monthValidation%>");
                                      Ext.getCmp('enddate').focus();
                                      return;
                                  }
                                  Ext.getCmp('graphid').disable();
                                  Ext.example.msg("Loading data......");
                                  bookGraph();
                              }
                          }
                      }
                  }
              ]
          });
          var graphPannel = new Ext.Panel({
              id: 'graphid',
              standardSubmit: true,
              height: 430,
              width: screen.width - 42,
              frame: true,
              html: '<table width="100%"><tr><tr> <td> <div id="bookingchartdiv" align="center"> </div></td></tr></table>'
          });

          function bookGraph() {
              CountStore.load({
                  params: {
                      CustId: globalClientId,
                      StartDate: Ext.getCmp('startdate').getValue(),
                      EndDate: Ext.getCmp('enddate').getValue()
                  },
                  callback: function() {
                      var barchartBookinggraph = new google.visualization.ColumnChart(document.getElementById('bookingchartdiv'));
                      var barchartBookingdata = new google.visualization.DataTable();
                      barchartBookingdata.addColumn('string', 'Count');
                      barchartBookingdata.addColumn('number', 'SANAND');
                      barchartBookingdata.addColumn('number', 'JODHPUR');
                      barchartBookingdata.addColumn('number', 'KHODIYAR');
                      barchartBookingdata.addColumn('number', 'JAIPUR');
                      barchartBookingdata.addColumn('number', 'DELHI');
                      barchartBookingdata.addColumn('number', 'MUMBAI');
                      barchartBookingdata.addColumn('number', 'KANDLA/MUMDRA');
                      barchartBookingdata.addColumn('number', 'PIPAVAV');
                      barchartBookingdata.addColumn('number', 'VAPI');
                      var rowdata = new Array();
                      var bookingsubdivision = '';
                      var count = 0;
                      var sanand = 0;
                      var jodhpur = 0;
                      var khodiyar = 0;
                      var jaipur = 0;
                      var delhi = 0;
                      var mumbai = 0;
                      var kandlamumdra = 0;
                      var pipavav = 0;
                      var vapi = 0;
                      for (var i = 0; i < CountStore.getCount(); i++) {
                          var rec = CountStore.getAt(i);
                          bookingsubdivision = rec.data['bookingType'];
                          sanand =  parseInt(rec.data['SANAND']);
                          jodhpur =  parseInt(rec.data['JODHPUR']);
                          khodiyar =  parseInt(rec.data['KHODIYAR']);
                          jaipur =  parseInt(rec.data['JAIPUR']);
                          delhi =  parseInt(rec.data['DELHI']);
                          mumbai =  parseInt(rec.data['MUMBAI']);
                          kandlamumdra =  parseInt(rec.data['KANDLA/MUMDRA']);
                          pipavav =  parseInt(rec.data['PIPAVAV']);
                          vapi =  parseInt(rec.data['VAPI']);
                          rowdata.push(bookingsubdivision);
                          rowdata.push(sanand);
                          rowdata.push(jodhpur);
                          rowdata.push(khodiyar);
                          rowdata.push(jaipur);
                          rowdata.push(delhi);
                          rowdata.push(mumbai);
                          rowdata.push(kandlamumdra);
                          rowdata.push(pipavav);
                          rowdata.push(vapi);
                          sanand = 0;
                          jodhpur = 0;
                          khodiyar = 0;
                          jaipur = 0;
                          delhi = 0;
                          mumbai = 0;
                          kandlamumdra = 0;
                          pipavav = 0;
                          vapi = 0;
                          count++;
                      }
                      if (count == 7) {
                          Ext.getCmp('graphid').enable();
                      }
                      barchartBookingdata.addRows(count + 1);
                      var k = 0;
                      var m = 0;
                      var n = 0;
                      for (i = 0; i < count; i++) {
                          for (j = 0; j <= 9; j++) {
                              rowdata[k];
                              var rec = CountStore.getAt(i);
                              barchartBookingdata.setCell(i, j, rowdata[k]);
                              k++;
                          }
                      }
                      count = 0;
                      var options = {
                          title: 'Booking Graph Branch Wise',
                          titleTextStyle: {
                              align: 'center',
                              fontSize: 15
                          },
                          bar: {
                              groupWidth: '100%'
                          },
                          pieSliceText: "value",
                          legend: {
                              position: 'right',
                              textStyle: {
                                  color: 'black',
                                  fontSize: 12
                              }
                          },
                          sliceVisibilityThreshold: 0,
                          width: screen.width-45,
                          height: 390,
                          isStacked: false,
                          hAxis: {
                              title: 'Booking Type',
                              textStyle: {
                                  fontSize: 10
                              },
                              titleTextStyle: {
                                  italic: false
                              }
                          },
                          vAxis: {
                              title: 'No of booking',
                              titleTextStyle: {
                                  italic: false
                              }
                          }
                      };
                      barchartBookinggraph.draw(barchartBookingdata, options);
                  }
              });
          }
          Ext.onReady(function() {
              ctsb = tsb;
              Ext.QuickTips.init();
              Ext.form.Field.prototype.msgTarget = 'side';
              outerPanel = new Ext.Panel({
                  title: '<%=BookingGraph%>',
                  renderTo: 'content',
                  standardSubmit: true,
                  frame: true,
                  height: 515,
                  cls: 'outerpanel',
                  width: screen.width-33,
                  layout: 'table',
                  layoutConfig: {
                      columns: 1
                  },
                  items: [comboPanel, graphPannel]
              });
              sb = Ext.getCmp('form-statusbar');
          });
      </script>
  </body>
</html>

