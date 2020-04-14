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
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("SLNO");
tobeConverted.add("Registration_No");
tobeConverted.add("Excel");
tobeConverted.add("PDF");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Hub_Arrival_Hub_Departure_Report");
tobeConverted.add("Details");
tobeConverted.add("Customer_Name");
tobeConverted.add("From_Location");
tobeConverted.add("To_Place");
tobeConverted.add("Driver_Name");
tobeConverted.add("Quantity");
tobeConverted.add("eWayBill_Number");
tobeConverted.add("eWayBill_Date");
tobeConverted.add("eWayBill_Without_GPS");
tobeConverted.add("Valid_From");
tobeConverted.add("Valid_To");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String StartDate=convertedWords.get(0);
String EndDate=convertedWords.get(1);
String SLNO=convertedWords.get(2);
String AssetNumber=convertedWords.get(3);
String Excel=convertedWords.get(4);
String PDF=convertedWords.get(5);
String ClearFilterData=convertedWords.get(6);
String NoRecordsfound=convertedWords.get(7);
String HubArrDep=convertedWords.get(8);
String Details=convertedWords.get(9);
String CustomerName=convertedWords.get(10);
String FromLocation=convertedWords.get(11);
String ToPlace=convertedWords.get(12);
String DriverName=convertedWords.get(13);
String Quantity=convertedWords.get(14);
String eWayBillNumber=convertedWords.get(15);
String eWayBillDate=convertedWords.get(16);
String eWayBillWithoutGPS=convertedWords.get(17);
String ValidFrom=convertedWords.get(18);
String ValidTo=convertedWords.get(19);

%>

<!DOCTYPE HTML>
<html class="largehtml">
 <head>
 		<title><%=eWayBillWithoutGPS%></title>		
</head>	    

  <body onLoad="gridload();">
    <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>     
    <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" />
   <%} %>
   <jsp:include page="../Common/ExportJS.jsp" />
   
   <script>
   var outerPanel;
  var dtprev = dateprev;
  var dtcur = currentDate;
  var datenxt=nextDate;
  var jspName = "VehWithoutGPSReport";
  var startdate;
  var enddate;
  var startdatepassed;
  var enddatepassed;
  var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,string";
   var grid;

//--------------Date Panel------------------------
   var customDatePanel = new Ext.Panel({
            frame: false,
            height:40,
           // width:100,
            layout: 'table',
            layoutConfig: {
                columns:6
            },
            items: [{
			           xtype: 'label',
			           text: 'Select Date:',
			           cls: 'labelstyle',
			           id: 'stateLabelId'
        			},
                	{
                        xtype: 'datefield',
                        cls: 'selectstyle',
                        format: getDateFormat(),
                        id:'startdate',
                        emptyText: 'Select Start Date',
                        value: dtcur,
                        maxValue: dtcur,
                        vtype: 'daterange',
                        endDateField: 'enddate',
                        listeners: {
              			select: function(  ){
                    		startdatepassed=Ext.getCmp('startdate').getValue()
                		}
            			}
                        
                    },{width:10},
                    {
                        xtype: 'datefield',
                        cls: 'selectstyle',
                        format: getDateFormat(),
                        emptyText: 'Select End Date',
                        id: 'enddate',
                        value: datenxt,
                        maxValue: datenxt,
                        vtype: 'daterange',
                        startDateField: 'startdate',
                        listeners: {
              			select: function(  ){
                    		enddatepassed=Ext.getCmp('enddate').getValue()
                		}
            			}
                    },{width:50},
                    {	
									xtype: 'button',
				    				id:'button1',
				    				text : 'Submit',
				    				width:80,
				    				cls:'bskExtStyle',
				    				listeners:{
				      				click:{
				      					fn:function(){
				      				
				      				 startdatepassed=Ext.getCmp('startdate').getValue();
  									 enddatepassed=Ext.getCmp('enddate').getValue();
  									 
	  									  if (Ext.getCmp('startdate').getValue() == "") {
						                          Ext.example.msg("Select Start Date");
						                          Ext.getCmp('startdate').focus();
						                          return;
					                      }
					                      if (Ext.getCmp('enddate').getValue() == "") {
					                          Ext.example.msg("Select End Date");
					                          Ext.getCmp('enddate').focus();
					                          return;
					                      }
					                      var startdates = Ext.getCmp('startdate').getValue();
					                      var enddates = Ext.getCmp('enddate').getValue();
					                      
					                      if (dateCompare(startdates,enddates) == -1) {
						                       Ext.example.msg("End Date must be Greater Than Start Date");
						                       Ext.getCmp('enddate').focus();
						                       return;
					                      }
					                      
					                      if (checkWeekValidation(startdates, enddates)) {
					                          Ext.example.msg("Please take the report for maximum 7 days");
					                            Ext.getCmp('enddate').focus();
					                            return;
					                       }
					  									 
				      					store.load({
				      					params:
				      						{
				      							jspName:jspName,
				      							startdate:startdatepassed,
				      							enddate:enddatepassed
				      						}
				      				});
				      				
										//	getReportData();
											} // End of Function
										} // End of Click
									}  // End of Listeners
					}
            ]
        });

 
//Back Button
var buttonPanel=new Ext.FormPanel({
		        	id: 'buttonid',
		        	cls:'colorid',
		        	frame:false,
		            buttons:[{
			              		text: 'Back',
			              		cls:'colorid',
			              		iconCls:'backbutton',
			              		handler : function(){
			              		window.location="<%=request.getContextPath()%>/Jsps/SandMining/Dashboard.jsp";
	
			              		}
			              }]
		    });    
  
  var reader = new Ext.data.JsonReader({
     // idProperty: 'hubArrDepId',
      root: 'VehWithoutGPSNewRoot',
      totalProperty: 'total',
      fields: [{
          name: 'slnoIndex'
      }, {
          name: 'assetNumberDataIndex'
      }, {
          name: 'DriverNameIndex'
      }, {
          name: 'TSNumberIndex'
      }, {
          name: 'DateTSIndex'
      }, {
          name: 'FromPlaceIndex'
      }, {
          name: 'ToPlaceIndex'
      }, {
          name: 'CustomerNameIndex'
      }, {
          name: 'QuantityIndex'
      }, {
          name: 'ValidFromIndex'
      }, {
          name: 'ValidToIndex'
      }, {
          name: 'RoyaltyIndex'
      }
      ]
  });
  
  var store = new Ext.data.GroupingStore({
      
      proxy: new Ext.data.HttpProxy({
          url: '<%=request.getContextPath()%>/SandMiningAction.do?param=getVehWithoutGPSNew',
          method: 'POST'
      }),
      autoLoad: false,
      remoteSort: true,
     // storeId: 'hubArrDepreport',
      reader: reader
  });
  
   
  var filters = new Ext.ux.grid.GridFilters({
      local: true,
      filters: [{
          type: 'numeric',
          dataIndex: 'slnoIndex'
      }, {
          type: 'string',
          dataIndex: 'assetNumberDataIndex'
      }, {
          type: 'string',
          dataIndex: 'DriverNameIndex'
      }, {
          type: 'string',
          dataIndex: 'TSNumberIndex'
      }, {
          type: 'date',
          dataIndex: 'DateTSIndex'
      }, {
          type: 'string',
          dataIndex: 'FromPlaceIndex'
      }, {
          type: 'string',
          dataIndex: 'ToPlaceIndex'
      }, {
          type: 'string',
          dataIndex: 'CustomerNameIndex'
      }, {
          type: 'numeric',
          dataIndex: 'QuantityIndex'
      }, {
          type: 'date',
          dataIndex: 'ValidFromIndex'
      } ,{
          type: 'date',
          dataIndex: 'ValidToIndex'
      } ,{
          type: 'numeric',
          dataIndex: 'RoyaltyIndex'
      }
      ]
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
          }, {
              header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
              dataIndex: 'assetNumberDataIndex',
              width: 50,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=eWayBillNumber%></span>",
              dataIndex: 'TSNumberIndex',
              width: 60,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=eWayBillDate%></span>",
              dataIndex: 'DateTSIndex',
              width: 60,
              filter: {
                  type: 'date'
              }
          }, {
              header: "<span style=font-weight:bold;><%=FromLocation%></span>",
              dataIndex: 'FromPlaceIndex',
              width: 50,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=ToPlace%></span>",
              dataIndex: 'ToPlaceIndex',
              width: 100,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=ValidFrom%></span>",
              dataIndex: 'ValidFromIndex',
              width: 100,
              filter: {
                  type: 'date'
              }
          },{
              header: "<span style=font-weight:bold;><%=ValidTo%></span>",
              dataIndex: 'ValidToIndex',
              width: 100,
              filter: {
                  type: 'date'
              }
          },{
              header: "<span style=font-weight:bold;><%=DriverName%></span>",
              dataIndex: 'DriverNameIndex',
              width: 50,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=CustomerName%></span>",
              dataIndex: 'CustomerNameIndex',
              width: 50,
              filter: {
                  type: 'string'
              }
          }, {
              header: "<span style=font-weight:bold;><%=Quantity%></span>",
              dataIndex: 'QuantityIndex',
              width: 50,
              filter: {
                  type: 'numeric'
              }
          }, {
              header: "<span style=font-weight:bold;>Royalty</span>",
              dataIndex: 'RoyaltyIndex',
              width: 50,
              filter: {
                  type: 'numeric'
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
  
  var grid = getGrid('<%=eWayBillWithoutGPS%>', '<%=NoRecordsfound%>', store, screen.width - 30, 450, 15, filters, '<%=ClearFilterData%>', false, '', 14, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>');
  
 function gridload()
  {
  startdatepassed=Ext.getCmp('startdate').getValue();
  enddatepassed=Ext.getCmp('enddate').getValue();
  store.load({params:{jspName:jspName,
  					  startdate:startdatepassed,
				      enddate:enddatepassed} });
  }
  Ext.onReady(function () {
    // ctsb = tsb;
      Ext.QuickTips.init();
      Ext.form.Field.prototype.msgTarget = 'side';
      outerPanel = new Ext.Panel({
         // title:'<%=HubArrDep%>',
          renderTo: 'content',
          standardSubmit: true,
          frame: true,
          cls: 'outerpanel',
          layout: 'table',
          layoutConfig: {
              columns: 1
          },
          items: [ customDatePanel,grid, buttonPanel ]
          //bbar: ctsb
      });
      sb = Ext.getCmp('form-statusbar');
          
  }); 
   </script>
 </body>
</html>