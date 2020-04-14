<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	
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
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		loginInfo.setStyleSheetOverride("N");
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		session.setAttribute("loginInfoDetails", loginInfo);

	}

	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request,response);
	String responseaftersubmit = "''";
	String feature = "1";
	if (session.getAttribute("responseaftersubmit") != null) {
		responseaftersubmit = "'"+ session.getAttribute("responseaftersubmit").toString() + "'";
		session.setAttribute("responseaftersubmit", null);
	}

	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	
	ArrayList<String> tobeConverted = new ArrayList<String>();

	tobeConverted.add("Route_Master");
	tobeConverted.add("Route_Master_Details");
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Select_Customer_Name");
	tobeConverted.add("SLNO");
	tobeConverted.add("Route_Id");
	tobeConverted.add("Vehicle_Type");
	tobeConverted.add("Select_Vehicle_Type");
	tobeConverted.add("Route_Mode");
	tobeConverted.add("Select_Route_Mode");
	tobeConverted.add("Route_Name");
	tobeConverted.add("Select_Route_Name");
	tobeConverted.add("ETA(HH:MM)");
	tobeConverted.add("Enter_ETA");
	tobeConverted.add("Source");
	tobeConverted.add("Source_Id");
	tobeConverted.add("Select_Source");
	tobeConverted.add("Destination");
	tobeConverted.add("Destination_Id");
	tobeConverted.add("Select_Destination");
	tobeConverted.add("Check_Point");
	tobeConverted.add("Check_Point_ETA");
	tobeConverted.add("No_Of_Check_Point");
	tobeConverted.add("Select_Check_Point");
	tobeConverted.add("KMS");
	tobeConverted.add("Enter_KMS");
	tobeConverted.add("Add");
	tobeConverted.add("Modify");
	tobeConverted.add("Add_Details");
	tobeConverted.add("Modify_Details");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("No_Rows_Selected");
	tobeConverted.add("Select_Single_Row");
	tobeConverted.add("PDF");
	tobeConverted.add("Excel");
	tobeConverted.add("Time_Valid_Format");
	tobeConverted.add("No_Field_Has_Changed_To_Save");
	tobeConverted.add("Already_Exist");
	tobeConverted.add("Error");
	tobeConverted.add("BA_Name");
	
	
	ArrayList<String> convertedWords = new ArrayList<String>();
	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

	String RouteMaster = convertedWords.get(0);
	String RouteMasterDetails = convertedWords.get(1);
	String CustomerName = convertedWords.get(2);
	String SelectCustomerName = convertedWords.get(3);
	String SLNO = convertedWords.get(4);
	String RouteId = convertedWords.get(5);
	String VehicleType = convertedWords.get(6);
	String SelectVehicleType = convertedWords.get(7);
	String RouteMode = convertedWords.get(8);
	String SelectRouteMode = convertedWords.get(9);
	String RouteName = convertedWords.get(10);
	String SelectRouteName = convertedWords.get(11);
	String ETA = convertedWords.get(12);
	String EnterETA = convertedWords.get(13);
	String Source = convertedWords.get(14);
	String SourceId = convertedWords.get(15);
	String SelectSource = convertedWords.get(16);
	String Destination = convertedWords.get(17);
	String DestinationId = convertedWords.get(18);
	String SelectDestination = convertedWords.get(19);
	String CheckPoint = convertedWords.get(20);
	String CheckPointETA = convertedWords.get(21);
	String NoofCheckPoint = convertedWords.get(22);
	String SelectCheckPoint = convertedWords.get(23);
	String KMS = convertedWords.get(24);
	String EnterKMS = convertedWords.get(25);
	String Add = convertedWords.get(26);
	String Modify = convertedWords.get(27);
	String AddDetails = convertedWords.get(28);
	String ModifyDetails = convertedWords.get(29);
	String NoRecordsFound = convertedWords.get(30);
	String ClearFilterData = convertedWords.get(31);
	String NoRowsSelected = convertedWords.get(32);
	String SelectSingleRow = convertedWords.get(33);
	String PDF = convertedWords.get(34);
	String Excel = convertedWords.get(35);
	String ETAValidFormat = convertedWords.get(36);
	String NoChange = convertedWords.get(37);
	String AlreadyExist = convertedWords.get(38);
	String Error = convertedWords.get(39);
	String BAName = convertedWords.get(40);
	String routeETAValidation = "Enter Valid Format Eg,(HHH:MM)";
%>

<jsp:include page="../Common/header.jsp" />
 	<title><%=RouteMaster%></title>
<style>
	.x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	label{
		display: inline !important;
	}
	html{
		overflow: hidden !important;
	}
</style>

   	<%
      		if (loginInfo.getStyleSheetOverride().equals("Y")) {
      	%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%
		} else {
	%>
	<jsp:include page="../Common/ImportJS.jsp" /><%
		}
	%>
    <jsp:include page="../Common/ExportJS.jsp" />
<script>
	var outerPanel;
	var ctsb;
	var jspName = "RouteMaster";
	var exportDataType = "int,int,string,string,string,string,int,string,int,string,int,int,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string";
	var selected;
	var grid;
	var buttonValue;
	var titelForInnerPanel;
	var myWin;

	var clientcombostore = new Ext.data.JsonStore({
    					   url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
    					   id: 'CustomerStoreId',
    					   root: 'CustomerRoot',
    					   autoLoad: true,
    					   remoteSort: true,
    					   fields: ['CustId', 'CustName'],
    					   listeners: {
        				   load: function (custstore, records, success, options) {
            			   	    if ( <%=customerId%> > 0) {
                					Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                					custId = Ext.getCmp('custcomboId').getValue();
                					VehicleTypeStore.load({
                									params: {
                					     				CustId: custId
                									}
                					});
                					LocationStore.load({
                         							params: {
                             							CustId: custId
                         							}
                					});
                					store.load({
                         							params: {
                             							CustId: custId,
 		                     							jspName:jspName
                         						}
									});
									BAStore.load({
                         							params: {
                             							CustId: custId
                         						}
									});
            			     }
        				   }
    					 }
	  });
	  
	var Client = new Ext.form.ComboBox({
    store: clientcombostore,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectCustomerName%>',
    blankText: '<%=SelectCustomerName%>',
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
            fn: function () {
                custId = Ext.getCmp('custcomboId').getValue();
                
                VehicleTypeStore.load({
                					params: {
                					     CustId: custId
                					}
                });
                LocationStore.load({
                         params: {
                             CustId: custId
                         }
                });
                store.load({
                         params: {
                             CustId: custId,
 		                     jspName:jspName
                         }
				});
				BAStore.load({
          					params: {
                               CustId: custId
                         		}
						});
               
            }
        }
      }
	});
	var customerComboPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'customerComboPanelId',
    layout: 'table',
    frame: false,
    width: screen.width - 40,
    height: 40,
    layoutConfig: {
        columns: 20
    },
    items: [{
            	xtype: 'label',
            	text: '<%=CustomerName%>' + ' :',
            	cls: 'labelstyle'
        	},
        	Client,{width:30}
    	   ]
	});

	  	var RouteStore = [['ORDINARY','ORDINARY'],['GDS','GDS']];   
	  	
		var RouteModeStore = new  Ext.data.SimpleStore({
			       	   		 data:RouteStore,
				       		 fields: ['RouteModeId','RouteModeName']
	  	});
	
		var RouteModeCombo = new Ext.form.ComboBox({
	  	frame:true,
	 	store: RouteModeStore,
	 	id:'RouteModeComboId',
	 	width: 150,
	 	cls: 'selectstylePerfect',
	 	hidden:false,
	 	anyMatch:true,
	 	onTypeAhead:true,
	 	forceSelection:true,
	 	enableKeyEvents:true,
	 	mode: 'local',
	 	value:'ORDINARY',
	 	emptyText:'<%=SelectRouteMode%>',
	 	blankText:'<%=SelectRouteMode%>',
	 	triggerAction: 'all',
	 	displayField: 'RouteModeName',
	 	valueField: 'RouteModeId',
	 	listeners: {
		             select: {
		                 	   fn:function(){
		                 	   	  	  
		                 	   }
		                 	}
		          }	    
      });
      
      var VehicleTypeStore = new Ext.data.JsonStore({
				   		   url:'<%=request.getContextPath()%>/RouteMasterAction.do?param=getVehicleType',
			       		   root: 'VehicleTypeRoot',
			       		   autoLoad: false,
				           fields: ['Vehicle_Type']
	  });
	  
	  
	   var BAStore = new Ext.data.JsonStore({
				   		   url:'<%=request.getContextPath()%>/drivarPerformanceAction.do?param=getGroupNames',
			       		   root: 'GroupStoreList',
			       		   autoLoad: false,
				           fields: ['groupId','groupName']
	  });
		
	  var BaCombo = new Ext.form.ComboBox({
	  frame:true,
	  store: BAStore,
	  id:'BAId',
	  width: 150,
	  cls: 'selectstylePerfect',
	  hidden:false,
	  anyMatch:true,
	  onTypeAhead:true,
	  forceSelection:true,
	  enableKeyEvents:true,
	  mode: 'local',
	  emptyText:'Select BA',
	  blankText:'Select BA',
	  triggerAction: 'all',
	  displayField: 'groupName',
	  valueField: 'groupId',
	  listeners: {
		             select: {
		                	   fn:function(){
		                	   		  
		                 	   }
		                 	}
		          }	    
      });	
		
		
	  var VehicleTypeCombo = new Ext.form.ComboBox({
	  frame:true,
	  store: VehicleTypeStore,
	  id:'VehicleTypeId',
	  width: 150,
	  cls: 'selectstylePerfect',
	  hidden:false,
	  anyMatch:true,
	  onTypeAhead:true,
	  forceSelection:true,
	  enableKeyEvents:true,
	  mode: 'local',
	  emptyText:'<%=SelectVehicleType%>',
	  blankText:'<%=SelectVehicleType%>',
	  triggerAction: 'all',
	  displayField: 'Vehicle_Type',
	  valueField: 'Vehicle_Type',
	  listeners: {
		             select: {
		                	   fn:function(){
		                	   		  
		                 	   }
		                 	}
		          }	    
      });
    		  
      var LocationStore = new Ext.data.JsonStore({
				   		   url:'<%=request.getContextPath()%>/RouteMasterAction.do?param=getSourceDestinationAndCheckPoints',
			       		   root: 'SourceDestinationCheckPointRoot',
			       		   autoLoad: false,
				           fields: ['Hub_Id','Hub_Name']
	  });
	  
	  var SourceCombo = new Ext.form.ComboBox({
	  frame:true,
	  store: LocationStore,
	  id:'SourceComboId',
	  width: 150,
	  cls: 'selectstylePerfect',
	  hidden:false,
	  anyMatch:true,
	  onTypeAhead:true,
	  forceSelection:true,
	  enableKeyEvents:true,
	  mode: 'local',
	  emptyText:'<%=SelectSource%>',
	  blankText:'<%=SelectSource%>',
	  triggerAction: 'all',
	  displayField: 'Hub_Name',
	  valueField: 'Hub_Id',
	  listeners: {
		            change: function(field, value) {
		            				var source = Ext.getCmp('SourceComboId').getRawValue();
		                	   		var destination = Ext.getCmp('DestinationComboId').getRawValue();
		                	   		if(destination!=""){
		                	   		    var sour = source.split(",");
		                	   		    var dest = destination.split(",");
		                	   			Ext.getCmp('RouteNameFieldId').setValue(sour[0]+" - "+dest[0]);
		                	   		}
		                    }
		         }
      });
      
	  var DestinationCombo = new Ext.form.ComboBox({
	  	frame:true,
	 	store: LocationStore,
	 	id:'DestinationComboId',
	 	width: 150,
	 	cls: 'selectstylePerfect',
	 	hidden:false,
	 	anyMatch:true,
	 	onTypeAhead:true,
	 	forceSelection:true,
	 	enableKeyEvents:true,
	 	mode: 'local',
	 	emptyText:'<%=SelectDestination%>',
	 	blankText:'<%=SelectDestination%>',
	 	triggerAction: 'all',
	 	displayField: 'Hub_Name',
	 	valueField: 'Hub_Id',
	  	listeners: {
		            change: function(field, value) {
		                	   		var source = Ext.getCmp('SourceComboId').getRawValue();
		                	   		var destination = Ext.getCmp('DestinationComboId').getRawValue();
		                	   		if(source!=""){
		                	   		    var dest = destination.split(",");
		                	   		    var sour = source.split(",");
		                	   			Ext.getCmp('RouteNameFieldId').setValue(sour[0]+" - "+dest[0]);
		                	   		}
		                    }
		         }
      }); 

 	  var CheckPointCombo1 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId1',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId1');
             			}
         			}
     	  }
      }); 
      
      var CheckPointCombo2 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId2',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId2');
             			}
         			}
     	  }
      }); 
      
      var CheckPointCombo3 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId3',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId3');
             			}
         			}
     	  }
      }); 
      
      var CheckPointCombo4 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId4',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId4');
             			}
         			}
     	  }
      }); 
      
      var CheckPointCombo5 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId5',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId5');
             			}
         			}
     	  }
      }); 
      
      var CheckPointCombo6 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId6',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId6');
             			}
         			}
     	  }
      }); 
      
      var CheckPointCombo7 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId7',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId7');
             			}
         			}
     	  }
      }); 
      
      var CheckPointCombo8 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId8',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId8');
             			}
         			}
     	  }
      }); 
      
      var CheckPointCombo9 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId9',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId9');
             			}
         			}
     	  }
      }); 
      
      var CheckPointCombo10 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId10',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId10');
             			}
         			}
     	  }
      }); 
      
      var CheckPointCombo11 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId11',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId11');
             			}
         			}
     	  }
      }); 
      
      var CheckPointCombo12 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId12',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId12');
             			}
         			}
     	  }
      }); 
      
      var CheckPointCombo13 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId13',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId13');
             			}
         			}
     	  }
      }); 
      
      var CheckPointCombo14 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId14',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId14');
             			}
         			}
     	  }
      }); 
      
      var CheckPointCombo15 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId15',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId15');
             			}
         			}
     	  }
      }); 
      
      var CheckPointCombo16 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId16',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId16');
             			}
         			}
     	  }
      }); 
      
      var CheckPointCombo17 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId17',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId17');
             			}
         			}
     	  }
      }); 
      
      var CheckPointCombo18 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId18',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId18');
             			}
         			}
     	  }
      }); 
      
      var CheckPointCombo19 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId19',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId19');
             			}
         			}
     	  }
      }); 
      
      var CheckPointCombo20 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId20',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId20');
             			}
         			}
     	  }
      }); 
      
      var CheckPointCombo21 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId21',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId21');
             			}
         			}
     	  }
      }); 
      
      var CheckPointCombo22 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId22',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId22');
             			}
         			}
     	  }
      }); 
      var CheckPointCombo23 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId23',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId23');
             			}
         			}
     	  }
      }); 
      var CheckPointCombo23 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId23',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId23');
             			}
         			}
     	  }
      }); 
      var CheckPointCombo24 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId24',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId24');
             			}
         			}
     	  }
      }); 
      var CheckPointCombo25 = new Ext.form.ComboBox({
	 	  frame:true,
		  store: LocationStore,
	 	  id:'CheckPointId25',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectCheckPoint%>',
	 	  blankText:'<%=SelectCheckPoint%>',
	 	  triggerAction: 'all',
	 	  displayField: 'Hub_Name',
	 	  valueField: 'Hub_Id',
	 	  listeners: {
         			select: {
             			fn: function () {
             				checkFunction('CheckPointId25');
             			}
         			}
     	  }
      }); 
      
 var innerPanelForRateMasterDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 320,
    width: 700,
    frame: true,
    id: 'innerPanelForRateMasterDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 10
    },
    items: [{
        xtype: 'fieldset',
        title: '',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 9,
        id: 'RateMasterId',
        width: 670,
        layout: 'table',
        layoutConfig: {
            columns: 9
        },
        items: [{
            		xtype: 'label',
            		text: '*',
            		cls: 'mandatoryfield',
            		id: 'baMandotoryId'
        		},{
            		xtype: 'label',
            		text: '<%=BAName%>' + ' :',
            		cls: 'labelstyle',
            		id: 'BaLabelId'
        		},
        			BaCombo
        		,
        		{xtype: 'label'},
        		{xtype: 'label'},
        		{xtype: 'label'},
        		{xtype: 'label'},
        		{xtype: 'label'},
        		{xtype: 'label'},
        		
        		{
            		xtype: 'label',
            		text: '*',
            		cls: 'mandatoryfield',
            		id: 'VehicleTypeMandotoryId'
        		},{
            		xtype: 'label',
            		text: '<%=VehicleType%>' + ' :',
            		cls: 'labelstyle',
            		id: 'VehicleTypeLabelId'
        		},
        			VehicleTypeCombo
        		,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'VehicleETAMandotoryId'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'VehicleETALabelId'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		hidden:true,
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		id: 'VehicleETAFieldId'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'VehicleKMSMandotoryId'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'VehicleKMSLabelId'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'VehicleKMSFieldId'
				},{
            		xtype: 'label',
            		text: '*',
            		cls: 'mandatoryfield',
            		id: 'RouteModeMandotoryId'
        		},{
        			xtype: 'label',
            		text: '<%=RouteMode%>' + ' :',
            		cls: 'labelstyle',
            		id: 'RouteModeLabelId'
        		},
					RouteModeCombo
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'RouteModelETAMandotoryId'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'RouteModelETALabelId'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		hidden:true,
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		id: 'RouteModelETAFieldId'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'RouteModelKMSMandotoryId'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'RouteModelKMSLabelId'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		disabled : true,
            		hidden:true,
            		allowDecimals:true,
            		id: 'RouteModelKMSFieldId'
				},{
            		xtype: 'label',
            		text: '*',
            		cls: 'mandatoryfield',
            		id: 'RouteNameMandotoryId'
        		},{
					xtype: 'label',
            		text: '<%=RouteName%>' + ' :',
            		cls: 'labelstyle',
            		id: 'RouteNameLabelId'
				},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		allowBlank: false,
            		labelSeparator: '',
            		disabled:true,
            		allowBlank: false,
            		id: 'RouteNameFieldId'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'RouteNameETAMandotoryId'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'RouteNameETALabelId'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		allowBlank: false,
            		labelSeparator: ':',
            		allowBlank: false,
            		regex:/^(\d{0,2}[0-999]:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=routeETAValidation%>',
                 	emptyText:'000:00',
                 	width: 80,
            		id: 'RouteNameETAFieldId'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'RouteNameKMSMandotoryId'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		cls: 'labelstyle',
            		id: 'RouteNameKMSLabelId'
        		},{
					xtype: 'numberfield',
            		//cls: 'selectstylePerfect',
            		allowBlank: false,
            		labelSeparator: '',
            		allowBlank: false,
            		disabled : false,
            		allowDecimals:false,
            		width:100,
            		emptyText:'<%=EnterKMS%>',
            		id: 'RouteNameKMSFieldId'
				},{
            		xtype: 'label',
            		text: '*',
            		cls: 'mandatoryfield',
            		id: 'SourceMandotoryId'
        		},{
        			xtype: 'label',
            		text: '<%=Source%>' + ' :',
            		cls: 'labelstyle',
            		id: 'SourceLabelId'
        		},
        			SourceCombo
        		,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'SourceETAMandotoryId'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'SourceETALabelId'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		hidden:true,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'SourceETAFieldId'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'SourceKMSMandotoryId'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'SourceKMSLabelId'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		disabled : true,
            		hidden:true,
            		allowDecimals:true,
            		id: 'SourceKMSFieldId'
				},{
            		xtype: 'label',
            		text: '*',
            		cls: 'mandatoryfield',
            		id: 'DestinationMandotoryId'
        		},{
        			xtype: 'label',
            		text: '<%=Destination%>' + ' :',
            		cls: 'labelstyle',
            		id: 'DestinationLabelId'
        		},
        			DestinationCombo
        		,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'DestinationETAMandotoryId'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'DestinationETALabelId'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		hidden:true,
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'DestinationETAFieldId'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'DestinationKMSMandotoryId'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'DestinationKMSLabelId'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'DestinationKMSFieldId'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId1'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 1 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId1'
				},
					CheckPointCombo1
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId1'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId1'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId1'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId1'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId1'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId1'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId2'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 2 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId2'
				},
					CheckPointCombo2
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId2'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId2'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId2'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId2'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId2'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId2'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId3'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 3 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId3'
				},
					CheckPointCombo3
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId3'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId3'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId3'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId3'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId3'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId3'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId4'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 4 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId4'
				},
					CheckPointCombo4
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId4'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId4'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId4'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId4'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId4'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId4'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId5'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 5 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId5'
				},
					CheckPointCombo5
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId5'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId5'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId5'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId5'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId5'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId5'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId6'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 6 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId6'
				},
					CheckPointCombo6
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId6'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId6'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId6'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId6'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId6'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId6'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId7'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 7 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId7'
				},
					CheckPointCombo7
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId7'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId7'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId7'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId7'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId7'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId7'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId8'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 8 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId8'
				},
					CheckPointCombo8
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId8'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId8'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId8'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId8'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId8'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId8'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId9'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 9 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId9'
				},
					CheckPointCombo9
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId9'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId9'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId9'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId9'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId9'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId9'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId10'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 10 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId10'
				},
					CheckPointCombo10
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId10'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId10'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId10'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId10'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId10'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId10'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId11'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 11 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId11'
				},
					CheckPointCombo11
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId11'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId11'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId11'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId11'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId11'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId11'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId12'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 12 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId12'
				},
					CheckPointCombo12
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId12'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId12'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId12'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId12'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId12'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId12'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId13'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 13 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId13'
				},
					CheckPointCombo13
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId13'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId13'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId13'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId13'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId13'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId13'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId14'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 14 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId14'
				},
					CheckPointCombo14
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId14'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId14'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId14'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId14'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId14'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId14'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId15'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 15 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId15'
				},
					CheckPointCombo15
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId15'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId15'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId15'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId15'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId15'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId15'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId16'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 16 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId16'
				},
					CheckPointCombo16
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId16'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId16'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId16'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId16'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId16'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId16'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId17'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 17 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId17'
				},
					CheckPointCombo17
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId17'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId17'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId17'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId17'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId17'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId17'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId18'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 18 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId18'
				},
					CheckPointCombo18
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId18'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId18'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId18'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId18'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId18'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId19'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 19 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId19'
				},
					CheckPointCombo19
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId19'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId19'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId19'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId91'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId19'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId19'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId20'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 20 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId20'
				},
					CheckPointCombo20
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId20'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId20'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId20'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId20'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId20'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId20'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId21'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 21 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId21'
				},
					CheckPointCombo21
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId21'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId21'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId21'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId21'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId21'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId21'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId22'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 22 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId22'
				},
					CheckPointCombo22
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId22'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId22'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId22'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId22'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId22'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId22'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId23'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 23 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId23'
				},
					CheckPointCombo23
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId23'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId23'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId23'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId23'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId23'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId23'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId24'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 24 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId24'
				},
					CheckPointCombo24
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId24'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId24'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId24'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId24'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId24'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId24'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointMandotoryId25'
        		},{
					xtype: 'label',
            		text: '<%=CheckPoint%>' + ' 25 :',
            		cls: 'labelstyle',
            		id: 'CheckPointLabelId25'
				},
					CheckPointCombo25
				,{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointETAMandotoryId25'
        		},{
            		xtype: 'label',
            		text: '<%=ETA%>' + '  :',
            		cls: 'labelstyle',
            		id: 'CheckPointETALabelId25'
        		},{
					xtype: 'textfield',
            		//cls: 'selectstylePerfect',
            		regex:/^(\d{0,2}:[0-5][0-9])$/,
            		disabled : false,
            		regexText:'<%=ETAValidFormat%>',
                 	emptyText:'00:00',
                 	width: 80,
            		id: 'CheckPointETAFieldId25'
				},{
            		xtype: 'label',
            		text: '  ',
            		cls: 'mandatoryfield',
            		id: 'CheckPointKMSMandotoryId25'
        		},{
            		xtype: 'label',
            		text: '<%=KMS%>' + ' :',
            		hidden:true,
            		cls: 'labelstyle',
            		id: 'CheckPointKMSLabelId25'
        		},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		hidden:true,
            		disabled : true,
            		allowDecimals:true,
            		id: 'CheckPointKMSFieldId25'
				}
       
            ]
    }]
});
    				
var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 70,
    width: 700,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: 'Save',
        iconCls: 'savebutton',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                
                    if (Ext.getCmp('BAId').getValue() == "") {
     				    Ext.example.msg("Select BA");
         				Ext.getCmp('BAId').focus();
         				return;
    				}else if (Ext.getCmp('VehicleTypeId').getValue() == "") {
     				    Ext.example.msg("<%=SelectVehicleType%>");
         				Ext.getCmp('VehicleTypeId').focus();
         				return;
    				}else if (Ext.getCmp('RouteModeComboId').getValue() == "") {
     				    Ext.example.msg("<%=SelectRouteMode%>");
         				Ext.getCmp('RouteModeComboId').focus();
         				return;
    				}else if (Ext.getCmp('RouteNameETAFieldId').getValue() == "") {
     				    Ext.example.msg("<%=EnterETA%>");
         				Ext.getCmp('RouteNameETAFieldId').focus();
         				return;
    				}else if (Ext.getCmp('RouteNameKMSFieldId').getValue() == "") {
     				    Ext.example.msg("<%=EnterKMS%>");
         				Ext.getCmp('RouteNameKMSFieldId').focus();
         				return;
    				}else if (Ext.getCmp('SourceComboId').getValue() == "") {
     				    Ext.example.msg("<%=SelectSource%>");
         				Ext.getCmp('SourceComboId').focus();
         				return;
    				}else if (Ext.getCmp('DestinationComboId').getValue() == "") {
     				    Ext.example.msg("<%=SelectDestination%>");
         				Ext.getCmp('DestinationComboId').focus();
         				return;
    				}
    				
    				var regdep = /^(\d{0,2}:[0-5][0-9])$/;
    				var routeRegExp = /^(\d{0,2}[0-999]:[0-5][0-9])$/;
    				var routeNameETA = Ext.getCmp('RouteNameETAFieldId').getValue();
    				if(!routeRegExp.test(routeNameETA)){
    					Ext.example.msg("<%=routeETAValidation%>");
    					Ext.getCmp('RouteNameETAFieldId').focus();
         				return;
    				}
                    
                    for(var i=1;i<=25;i++){
                        var cId='CheckPointId'+i;
                        var eId = 'CheckPointETAFieldId'+i;
                      	if (Ext.getCmp(cId).getValue() == ""){
                      	     if (Ext.getCmp(eId).getValue() != ""){
                      	     	if(!regdep.test(Ext.getCmp(eId).getValue())){
    								Ext.example.msg("<%=ETAValidFormat%>");
    								Ext.getCmp(eId).focus();
         							return;
    							}else{
    							  	Ext.example.msg("<%=SelectCheckPoint%>");
    								Ext.getCmp(cId).focus();
         							return;
    							}
                      	     }
                      	}else{
                      		 if (Ext.getCmp(eId).getValue() != ""){
                      	     	if(!regdep.test(Ext.getCmp(eId).getValue())){
    								Ext.example.msg("<%=ETAValidFormat%>");
    								Ext.getCmp(eId).focus();
         							return;
    							}
                      	     }else{
    							  	Ext.example.msg("<%=EnterETA%>");
    								Ext.getCmp(eId).focus();
         							return;
    							}
                      	}
                    }
                    
                    if (innerPanelForRateMasterDetails.getForm().isValid()) {                     	
                     	var id=0;
                      	if(buttonValue == 'Modify'){
                    		var selected = grid.getSelectionModel().getSelected();
                            id = selected.get('RouteIdDataIndex');
                            if(selected.get('BaDataIdIndex')== Ext.getCmp('BAId').getValue() &&
                            selected.get('VehicleTypeDataIndex')== Ext.getCmp('VehicleTypeId').getValue() &&
                            	selected.get('RouteModeDataIndex') == Ext.getCmp('RouteModeComboId').getValue() &&
                            	selected.get('RouteNameDataIndex') == Ext.getCmp('RouteNameFieldId').getValue() &&
                            	selected.get('ETADataIndex') == Ext.getCmp('RouteNameETAFieldId').getValue() &&
                            	selected.get('KMSDataIndex') == Ext.getCmp('RouteNameKMSFieldId').getValue() &&
                                selected.get('SourceIdDataIndex') == Ext.getCmp('SourceComboId').getValue()  && 
                                selected.get('DestinationIdDataIndex') == Ext.getCmp('DestinationComboId').getValue() &&
                                selected.get('CheckPoint1DataIndex') == Ext.getCmp('CheckPointId1').getValue()  &&
                                selected.get('CheckPoint2DataIndex') == Ext.getCmp('CheckPointId2').getValue() &&
                                selected.get('CheckPoint3DataIndex') == Ext.getCmp('CheckPointId3').getValue() &&
                                selected.get('CheckPoint4DataIndex') == Ext.getCmp('CheckPointId4').getValue() &&
                                selected.get('CheckPoint5DataIndex') == Ext.getCmp('CheckPointId5').getValue() &&
                                selected.get('CheckPoint6DataIndex') == Ext.getCmp('CheckPointId6').getValue() &&
                                selected.get('CheckPoint7DataIndex') == Ext.getCmp('CheckPointId7').getValue() &&
                                selected.get('CheckPoint8DataIndex') == Ext.getCmp('CheckPointId8').getValue() &&
                                selected.get('CheckPoint9DataIndex') == Ext.getCmp('CheckPointId9').getValue() &&
                                selected.get('CheckPoint10DataIndex') == Ext.getCmp('CheckPointId10').getValue() &&
                                selected.get('CheckPoint11DataIndex') == Ext.getCmp('CheckPointId11').getValue() &&
                                selected.get('CheckPoint12DataIndex') == Ext.getCmp('CheckPointId12').getValue() &&
                                selected.get('CheckPoint13DataIndex') == Ext.getCmp('CheckPointId13').getValue() &&
                                selected.get('CheckPoint14DataIndex') == Ext.getCmp('CheckPointId14').getValue() &&
                                selected.get('CheckPoint15DataIndex') == Ext.getCmp('CheckPointId15').getValue() &&
                                selected.get('CheckPoint16DataIndex') == Ext.getCmp('CheckPointId16').getValue() &&
                                selected.get('CheckPoint17DataIndex') == Ext.getCmp('CheckPointId17').getValue() &&
                                selected.get('CheckPoint18DataIndex') == Ext.getCmp('CheckPointId18').getValue() &&
                                selected.get('CheckPoint19DataIndex') == Ext.getCmp('CheckPointId19').getValue() &&
                                selected.get('CheckPoint20DataIndex') == Ext.getCmp('CheckPointId20').getValue() &&
                                selected.get('CheckPoint21DataIndex') == Ext.getCmp('CheckPointId21').getValue() &&
                                selected.get('CheckPoint22DataIndex') == Ext.getCmp('CheckPointId22').getValue() &&
                                selected.get('CheckPoint23DataIndex') == Ext.getCmp('CheckPointId23').getValue() &&
                                selected.get('CheckPoint24DataIndex') == Ext.getCmp('CheckPointId24').getValue() &&
                                selected.get('CheckPoint25DataIndex') == Ext.getCmp('CheckPointId25').getValue() &&
                                selected.get('CheckPointETA1DataIndex') == Ext.getCmp('CheckPointETAFieldId1').getValue() &&
                                selected.get('CheckPointETA2DataIndex') == Ext.getCmp('CheckPointETAFieldId2').getValue() &&
                                selected.get('CheckPointETA3DataIndex') == Ext.getCmp('CheckPointETAFieldId3').getValue() &&
                                selected.get('CheckPointETA4DataIndex') == Ext.getCmp('CheckPointETAFieldId4').getValue() &&
                                selected.get('CheckPointETA5DataIndex') == Ext.getCmp('CheckPointETAFieldId5').getValue() &&
                                selected.get('CheckPointETA6DataIndex') == Ext.getCmp('CheckPointETAFieldId6').getValue() &&
                                selected.get('CheckPointETA7DataIndex') == Ext.getCmp('CheckPointETAFieldId7').getValue() &&
                                selected.get('CheckPointETA8DataIndex') == Ext.getCmp('CheckPointETAFieldId8').getValue() &&
                                selected.get('CheckPointETA9DataIndex') == Ext.getCmp('CheckPointETAFieldId9').getValue() &&
                                selected.get('CheckPointETA10DataIndex') == Ext.getCmp('CheckPointETAFieldId10').getValue() &&
                                selected.get('CheckPointETA11DataIndex') == Ext.getCmp('CheckPointETAFieldId11').getValue() &&
                                selected.get('CheckPointETA12DataIndex') == Ext.getCmp('CheckPointETAFieldId12').getValue() &&
                                selected.get('CheckPointETA13DataIndex') == Ext.getCmp('CheckPointETAFieldId13').getValue() &&
                                selected.get('CheckPointETA14DataIndex') == Ext.getCmp('CheckPointETAFieldId14').getValue() &&
                                selected.get('CheckPointETA15DataIndex') == Ext.getCmp('CheckPointETAFieldId15').getValue() &&
                                selected.get('CheckPointETA16DataIndex') == Ext.getCmp('CheckPointETAFieldId16').getValue() &&
                                selected.get('CheckPointETA17DataIndex') == Ext.getCmp('CheckPointETAFieldId17').getValue() &&
                                selected.get('CheckPointETA18DataIndex') == Ext.getCmp('CheckPointETAFieldId18').getValue() &&
                                selected.get('CheckPointETA19DataIndex') == Ext.getCmp('CheckPointETAFieldId19').getValue() &&
                                selected.get('CheckPointETA20DataIndex') == Ext.getCmp('CheckPointETAFieldId20').getValue() &&
                                selected.get('CheckPointETA21DataIndex') == Ext.getCmp('CheckPointETAFieldId21').getValue() &&
                                selected.get('CheckPointETA22DataIndex') == Ext.getCmp('CheckPointETAFieldId22').getValue() &&
                                selected.get('CheckPointETA23DataIndex') == Ext.getCmp('CheckPointETAFieldId23').getValue() &&
                                selected.get('CheckPointETA24DataIndex') == Ext.getCmp('CheckPointETAFieldId24').getValue() &&
                                selected.get('CheckPointETA25DataIndex') == Ext.getCmp('CheckPointETAFieldId25').getValue()){
                               Ext.example.msg("<%=NoChange%>");
                               return;
                            }
                      	}
                       RateMasterOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/RouteMasterAction.do?param=saveandModifyRouteMasterDetails',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId:Ext.getCmp('custcomboId').getValue(),
                                Ba: Ext.getCmp('BAId').getValue(),
                                VehicleType: Ext.getCmp('VehicleTypeId').getValue(),
                                RouteMode: Ext.getCmp('RouteModeComboId').getValue(),
                                RouteName: Ext.getCmp('RouteNameFieldId').getValue(),
                                RouteETA: Ext.getCmp('RouteNameETAFieldId').getValue(),
                                RouteKMS:Ext.getCmp('RouteNameKMSFieldId').getValue(),
                                Source:Ext.getCmp('SourceComboId').getValue(),
                                Destination:Ext.getCmp('DestinationComboId').getValue(),
                                CheckPoint1: Ext.getCmp('CheckPointId1').getValue(),
                                CheckPoint1ETA:Ext.getCmp('CheckPointETAFieldId1').getValue(),
                                CheckPoint2: Ext.getCmp('CheckPointId2').getValue(),
                                CheckPoint2ETA:Ext.getCmp('CheckPointETAFieldId2').getValue(),
                                CheckPoint3: Ext.getCmp('CheckPointId3').getValue(),
                                CheckPoint3ETA:Ext.getCmp('CheckPointETAFieldId3').getValue(),
                                CheckPoint4: Ext.getCmp('CheckPointId4').getValue(),
                                CheckPoint4ETA:Ext.getCmp('CheckPointETAFieldId4').getValue(),
                                CheckPoint5: Ext.getCmp('CheckPointId5').getValue(),
                                CheckPoint5ETA:Ext.getCmp('CheckPointETAFieldId5').getValue(),
                                CheckPoint6: Ext.getCmp('CheckPointId6').getValue(),
                                CheckPoint6ETA:Ext.getCmp('CheckPointETAFieldId6').getValue(),
                                CheckPoint7: Ext.getCmp('CheckPointId7').getValue(),
                                CheckPoint7ETA:Ext.getCmp('CheckPointETAFieldId7').getValue(),
                                CheckPoint8: Ext.getCmp('CheckPointId8').getValue(),
                                CheckPoint8ETA:Ext.getCmp('CheckPointETAFieldId8').getValue(),
                                CheckPoint9: Ext.getCmp('CheckPointId9').getValue(),
                                CheckPoint9ETA:Ext.getCmp('CheckPointETAFieldId9').getValue(),
                                CheckPoint10: Ext.getCmp('CheckPointId10').getValue(),
                                CheckPoint10ETA:Ext.getCmp('CheckPointETAFieldId10').getValue(),
                                CheckPoint11: Ext.getCmp('CheckPointId11').getValue(),
                                CheckPoint11ETA:Ext.getCmp('CheckPointETAFieldId11').getValue(),
                                CheckPoint12: Ext.getCmp('CheckPointId12').getValue(),
                                CheckPoint12ETA:Ext.getCmp('CheckPointETAFieldId12').getValue(),
                                CheckPoint13: Ext.getCmp('CheckPointId13').getValue(),
                                CheckPoint13ETA:Ext.getCmp('CheckPointETAFieldId13').getValue(),
                                CheckPoint14: Ext.getCmp('CheckPointId14').getValue(),
                                CheckPoint14ETA:Ext.getCmp('CheckPointETAFieldId14').getValue(),
                                CheckPoint15: Ext.getCmp('CheckPointId15').getValue(),
                                CheckPoint15ETA:Ext.getCmp('CheckPointETAFieldId15').getValue(),
                                CheckPoint16: Ext.getCmp('CheckPointId16').getValue(),
                                CheckPoint16ETA:Ext.getCmp('CheckPointETAFieldId16').getValue(),
                                CheckPoint17: Ext.getCmp('CheckPointId17').getValue(),
                                CheckPoint17ETA:Ext.getCmp('CheckPointETAFieldId17').getValue(),
                                CheckPoint18: Ext.getCmp('CheckPointId18').getValue(),
                                CheckPoint18ETA:Ext.getCmp('CheckPointETAFieldId18').getValue(),
                                CheckPoint19: Ext.getCmp('CheckPointId19').getValue(),
                                CheckPoint19ETA:Ext.getCmp('CheckPointETAFieldId19').getValue(),
                                CheckPoint20: Ext.getCmp('CheckPointId20').getValue(),
                                CheckPoint20ETA:Ext.getCmp('CheckPointETAFieldId20').getValue(),
                                CheckPoint21: Ext.getCmp('CheckPointId21').getValue(),
                                CheckPoint21ETA:Ext.getCmp('CheckPointETAFieldId21').getValue(),
                                CheckPoint22: Ext.getCmp('CheckPointId22').getValue(),
                                CheckPoint22ETA:Ext.getCmp('CheckPointETAFieldId22').getValue(),
                                CheckPoint23: Ext.getCmp('CheckPointId23').getValue(),
                                CheckPoint23ETA:Ext.getCmp('CheckPointETAFieldId23').getValue(),
                                CheckPoint24: Ext.getCmp('CheckPointId24').getValue(),
                                CheckPoint24ETA:Ext.getCmp('CheckPointETAFieldId24').getValue(),
                                CheckPoint25: Ext.getCmp('CheckPointId25').getValue(),
                                CheckPoint25ETA:Ext.getCmp('CheckPointETAFieldId25').getValue(),
                                Id:id
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                Ext.getCmp('BAId').reset();
                                Ext.getCmp('VehicleTypeId').reset();
                                Ext.getCmp('RouteModeComboId').reset();
                                Ext.getCmp('RouteNameFieldId').reset();
                                Ext.getCmp('RouteNameETAFieldId').reset();
                                Ext.getCmp('RouteNameKMSFieldId').reset();
                                Ext.getCmp('SourceComboId').reset();
                                Ext.getCmp('DestinationComboId').reset();
                                Ext.getCmp('CheckPointId1').reset();
                                Ext.getCmp('CheckPointId2').reset();
                                Ext.getCmp('CheckPointId3').reset();
                                Ext.getCmp('CheckPointId4').reset();
                                Ext.getCmp('CheckPointId5').reset();
                                Ext.getCmp('CheckPointId6').reset();
                                Ext.getCmp('CheckPointId7').reset();
                                Ext.getCmp('CheckPointId8').reset();
                                Ext.getCmp('CheckPointId9').reset();
                                Ext.getCmp('CheckPointId10').reset();
                                Ext.getCmp('CheckPointId11').reset();
                                Ext.getCmp('CheckPointId12').reset();
                                Ext.getCmp('CheckPointId13').reset();
                                Ext.getCmp('CheckPointId14').reset();
                                Ext.getCmp('CheckPointId15').reset();
                                Ext.getCmp('CheckPointId16').reset();
                                Ext.getCmp('CheckPointId17').reset();
                                Ext.getCmp('CheckPointId18').reset();
                                Ext.getCmp('CheckPointId19').reset();
                                Ext.getCmp('CheckPointId20').reset();
                                Ext.getCmp('CheckPointId21').reset();
                                Ext.getCmp('CheckPointId22').reset();
                                Ext.getCmp('CheckPointId23').reset();
                                Ext.getCmp('CheckPointId24').reset();
                                Ext.getCmp('CheckPointId25').reset();
                                Ext.getCmp('CheckPointETAFieldId1').reset();
                                Ext.getCmp('CheckPointETAFieldId2').reset();
                                Ext.getCmp('CheckPointETAFieldId3').reset();
                                Ext.getCmp('CheckPointETAFieldId4').reset();
                                Ext.getCmp('CheckPointETAFieldId5').reset();
                                Ext.getCmp('CheckPointETAFieldId6').reset();
                                Ext.getCmp('CheckPointETAFieldId7').reset();
                                Ext.getCmp('CheckPointETAFieldId8').reset();
                                Ext.getCmp('CheckPointETAFieldId9').reset();
                                Ext.getCmp('CheckPointETAFieldId10').reset();
                                Ext.getCmp('CheckPointETAFieldId11').reset();
                                Ext.getCmp('CheckPointETAFieldId12').reset();
                                Ext.getCmp('CheckPointETAFieldId13').reset();
                                Ext.getCmp('CheckPointETAFieldId14').reset();
                                Ext.getCmp('CheckPointETAFieldId15').reset();
                                Ext.getCmp('CheckPointETAFieldId16').reset();
                                Ext.getCmp('CheckPointETAFieldId17').reset();
                                Ext.getCmp('CheckPointETAFieldId18').reset();
                                Ext.getCmp('CheckPointETAFieldId19').reset();
                                Ext.getCmp('CheckPointETAFieldId20').reset();
                                Ext.getCmp('CheckPointETAFieldId21').reset();
                                Ext.getCmp('CheckPointETAFieldId22').reset();
                                Ext.getCmp('CheckPointETAFieldId23').reset();
                                Ext.getCmp('CheckPointETAFieldId24').reset();
                                Ext.getCmp('CheckPointETAFieldId25').reset();
                                myWin.hide();

                                RateMasterOuterPanelWindow.getEl().unmask();
                                store.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
 		                                jspName:jspName
                                    }
                                });
                            },
                            failure: function () {
                                 Ext.example.msg("<%=Error%>");
                                 store.reload();
                                 myWin.hide();
                            }
                        });
                    }
                }
            }
        }
    }, {
        xtype: 'button',
        text: 'Cancel',
        id: 'canButtId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                    myWin.hide();
                }
            }
        }
    }]
});

var RateMasterOuterPanelWindow = new Ext.Panel({
    width: 710,
    height: 420,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForRateMasterDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 433,
    width: 720,
    id: 'myWin',
    items: [RateMasterOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
         Ext.example.msg("<%=SelectCustomerName%>");
         Ext.getCmp('custcomboId').focus();
         return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=AddDetails%>';
    myWin.setPosition(330, 50);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('BAId').reset();
    Ext.getCmp('VehicleTypeId').reset();
	Ext.getCmp('RouteModeComboId').reset();
    Ext.getCmp('RouteNameFieldId').reset();
    Ext.getCmp('RouteNameETAFieldId').reset();
    Ext.getCmp('RouteNameKMSFieldId').reset();
    Ext.getCmp('SourceComboId').reset();
    Ext.getCmp('DestinationComboId').reset();
    Ext.getCmp('CheckPointId1').reset();
    Ext.getCmp('CheckPointId2').reset();
    Ext.getCmp('CheckPointId3').reset();
    Ext.getCmp('CheckPointId4').reset();
    Ext.getCmp('CheckPointId5').reset();
    Ext.getCmp('CheckPointId6').reset();
    Ext.getCmp('CheckPointId7').reset();
    Ext.getCmp('CheckPointId8').reset();
    Ext.getCmp('CheckPointId9').reset();
    Ext.getCmp('CheckPointId10').reset();
    Ext.getCmp('CheckPointId11').reset();
    Ext.getCmp('CheckPointId12').reset();
    Ext.getCmp('CheckPointId13').reset();
    Ext.getCmp('CheckPointId14').reset();
    Ext.getCmp('CheckPointId15').reset();
    Ext.getCmp('CheckPointId16').reset();
    Ext.getCmp('CheckPointId17').reset();
    Ext.getCmp('CheckPointId18').reset();
    Ext.getCmp('CheckPointId19').reset();
    Ext.getCmp('CheckPointId20').reset();
    Ext.getCmp('CheckPointId21').reset();
    Ext.getCmp('CheckPointId22').reset();
    Ext.getCmp('CheckPointId23').reset();
    Ext.getCmp('CheckPointId24').reset();
    Ext.getCmp('CheckPointId25').reset();
    Ext.getCmp('CheckPointETAFieldId1').reset();
    Ext.getCmp('CheckPointETAFieldId2').reset();
    Ext.getCmp('CheckPointETAFieldId3').reset();
    Ext.getCmp('CheckPointETAFieldId4').reset();
    Ext.getCmp('CheckPointETAFieldId5').reset();
    Ext.getCmp('CheckPointETAFieldId6').reset();
    Ext.getCmp('CheckPointETAFieldId7').reset();
    Ext.getCmp('CheckPointETAFieldId8').reset();
    Ext.getCmp('CheckPointETAFieldId9').reset();
    Ext.getCmp('CheckPointETAFieldId10').reset();
    Ext.getCmp('CheckPointETAFieldId11').reset();
    Ext.getCmp('CheckPointETAFieldId12').reset();
    Ext.getCmp('CheckPointETAFieldId13').reset();
    Ext.getCmp('CheckPointETAFieldId14').reset();
    Ext.getCmp('CheckPointETAFieldId15').reset();
    Ext.getCmp('CheckPointETAFieldId16').reset();
    Ext.getCmp('CheckPointETAFieldId17').reset();
    Ext.getCmp('CheckPointETAFieldId18').reset();
    Ext.getCmp('CheckPointETAFieldId19').reset();
    Ext.getCmp('CheckPointETAFieldId20').reset();
    Ext.getCmp('CheckPointETAFieldId21').reset();
    Ext.getCmp('CheckPointETAFieldId22').reset();
    Ext.getCmp('CheckPointETAFieldId23').reset();
    Ext.getCmp('CheckPointETAFieldId24').reset();
    Ext.getCmp('CheckPointETAFieldId25').reset();
}

function modifyData() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    if (grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("<%=NoRowsSelected%>");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
    buttonValue = '<%=Modify%>';
    titelForInnerPanel = '<%=ModifyDetails%>';
    myWin.setPosition(330, 50);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('BAId').setValue(selected.get('BaDataIdIndex'));
    Ext.getCmp('VehicleTypeId').setValue(selected.get('VehicleTypeDataIndex'));
    Ext.getCmp('RouteModeComboId').setValue(selected.get('RouteModeDataIndex'));
    Ext.getCmp('RouteNameFieldId').setValue(selected.get('RouteNameDataIndex'));
    Ext.getCmp('RouteNameETAFieldId').setValue(selected.get('ETADataIndex'));
    Ext.getCmp('RouteNameKMSFieldId').setValue(selected.get('KMSDataIndex'));
    Ext.getCmp('SourceComboId').setValue(selected.get('SourceIdDataIndex'));
    Ext.getCmp('DestinationComboId').setValue(selected.get('DestinationIdDataIndex'));
    
    Ext.getCmp('CheckPointId1').setValue(selected.get('CheckPoint1DataIndex'));
    Ext.getCmp('CheckPointETAFieldId1').setValue(selected.get('CheckPointETA1DataIndex'));
    Ext.getCmp('CheckPointId2').setValue(selected.get('CheckPoint2DataIndex'));
    Ext.getCmp('CheckPointETAFieldId2').setValue(selected.get('CheckPointETA2DataIndex'));
    Ext.getCmp('CheckPointId3').setValue(selected.get('CheckPoint3DataIndex'));
    Ext.getCmp('CheckPointETAFieldId3').setValue(selected.get('CheckPointETA3DataIndex'));
    Ext.getCmp('CheckPointId4').setValue(selected.get('CheckPoint4DataIndex'));
    Ext.getCmp('CheckPointETAFieldId4').setValue(selected.get('CheckPointETA4DataIndex'));
    Ext.getCmp('CheckPointId5').setValue(selected.get('CheckPoint5DataIndex'));
    Ext.getCmp('CheckPointETAFieldId5').setValue(selected.get('CheckPointETA5DataIndex'));
    Ext.getCmp('CheckPointId6').setValue(selected.get('CheckPoint6DataIndex'));
    Ext.getCmp('CheckPointETAFieldId6').setValue(selected.get('CheckPointETA6DataIndex'));
    Ext.getCmp('CheckPointId7').setValue(selected.get('CheckPoint7DataIndex'));
    Ext.getCmp('CheckPointETAFieldId7').setValue(selected.get('CheckPointETA7DataIndex'));
    Ext.getCmp('CheckPointId8').setValue(selected.get('CheckPoint8DataIndex'));
    Ext.getCmp('CheckPointETAFieldId8').setValue(selected.get('CheckPointETA8DataIndex'));
    Ext.getCmp('CheckPointId9').setValue(selected.get('CheckPoint9DataIndex'));
    Ext.getCmp('CheckPointETAFieldId9').setValue(selected.get('CheckPointETA9DataIndex'));
    Ext.getCmp('CheckPointId10').setValue(selected.get('CheckPoint10DataIndex'));
    Ext.getCmp('CheckPointETAFieldId10').setValue(selected.get('CheckPointETA10DataIndex'));
    Ext.getCmp('CheckPointId11').setValue(selected.get('CheckPoint11DataIndex'));
    Ext.getCmp('CheckPointETAFieldId11').setValue(selected.get('CheckPointETA11DataIndex'));
    Ext.getCmp('CheckPointId12').setValue(selected.get('CheckPoint12DataIndex'));
    Ext.getCmp('CheckPointETAFieldId12').setValue(selected.get('CheckPointETA12DataIndex'));
    Ext.getCmp('CheckPointId13').setValue(selected.get('CheckPoint13DataIndex'));
    Ext.getCmp('CheckPointETAFieldId13').setValue(selected.get('CheckPointETA13DataIndex'));
    Ext.getCmp('CheckPointId14').setValue(selected.get('CheckPoint14DataIndex'));
    Ext.getCmp('CheckPointETAFieldId14').setValue(selected.get('CheckPointETA14DataIndex'));
    Ext.getCmp('CheckPointId15').setValue(selected.get('CheckPoint15DataIndex'));
    Ext.getCmp('CheckPointETAFieldId15').setValue(selected.get('CheckPointETA15DataIndex'));
    Ext.getCmp('CheckPointId16').setValue(selected.get('CheckPoint16DataIndex'));
    Ext.getCmp('CheckPointETAFieldId16').setValue(selected.get('CheckPointETA16DataIndex'));
    Ext.getCmp('CheckPointId17').setValue(selected.get('CheckPoint17DataIndex'));
    Ext.getCmp('CheckPointETAFieldId17').setValue(selected.get('CheckPointETA17DataIndex'));
    Ext.getCmp('CheckPointId18').setValue(selected.get('CheckPoint18DataIndex'));
    Ext.getCmp('CheckPointETAFieldId18').setValue(selected.get('CheckPointETA18DataIndex'));
    Ext.getCmp('CheckPointId19').setValue(selected.get('CheckPoint19DataIndex'));
    Ext.getCmp('CheckPointETAFieldId19').setValue(selected.get('CheckPointETA19DataIndex'));
    Ext.getCmp('CheckPointId20').setValue(selected.get('CheckPoint20DataIndex'));
    Ext.getCmp('CheckPointETAFieldId20').setValue(selected.get('CheckPointETA20DataIndex'));
    Ext.getCmp('CheckPointId21').setValue(selected.get('CheckPoint21DataIndex'));
    Ext.getCmp('CheckPointETAFieldId21').setValue(selected.get('CheckPointETA21DataIndex'));
    Ext.getCmp('CheckPointId22').setValue(selected.get('CheckPoint22DataIndex'));
    Ext.getCmp('CheckPointETAFieldId22').setValue(selected.get('CheckPointETA22DataIndex'));
    Ext.getCmp('CheckPointId23').setValue(selected.get('CheckPoint23DataIndex'));
    Ext.getCmp('CheckPointETAFieldId23').setValue(selected.get('CheckPointETA23DataIndex'));
    Ext.getCmp('CheckPointId24').setValue(selected.get('CheckPoint24DataIndex'));
    Ext.getCmp('CheckPointETAFieldId24').setValue(selected.get('CheckPointETA24DataIndex'));
    Ext.getCmp('CheckPointId25').setValue(selected.get('CheckPoint25DataIndex'));
    Ext.getCmp('CheckPointETAFieldId25').setValue(selected.get('CheckPointETA25DataIndex'));
}    

	function checkFunction(currentid)
		{
 				    
                     if  (Ext.getCmp(currentid).getValue() == Ext.getCmp('SourceComboId').getValue())
                     {
                   	     Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     
                     if  (Ext.getCmp(currentid).getValue() == Ext.getCmp('DestinationComboId').getValue())
                     {
                   		 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     
                     if  ((currentid.toString() != 'CheckPointId1')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId1').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     
                     if  ((currentid.toString() != 'CheckPointId2')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId2').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId3')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId3').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId4')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId4').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId5')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId5').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId6')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId6').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId7')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId7').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId8')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId8').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId9')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId9').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId10')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId10').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId11')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId11').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId12')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId12').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId13')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId13').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId14')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId14').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId15')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId15').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId16')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId16').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId17')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId17').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId18')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId18').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId19')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId19').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId20')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId20').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId21')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId21').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId22')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId22').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId23')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId23').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId24')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId24').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'CheckPointId25')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('CheckPointId25').getValue()))
                     {
                    	 Ext.example.msg("<%=AlreadyExist%>");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
      }
                     
var reader = new Ext.data.JsonReader({
    idProperty: 'RouteMasterRootId',
    root: 'RouteMasterRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    },{
        name: 'RouteIdDataIndex'
    },{
        name: 'BaDataIdIndex'
    },{
        name: 'BaDataIndex'
    },{
        name: 'VehicleTypeDataIndex'
    },{
    	name: 'RouteModeDataIndex'
    },{
        name: 'RouteNameDataIndex'
    },{
        name: 'ETADataIndex'
    },{
        name: 'KMSDataIndex'
    },{
        name: 'SourceDataIndex'
    }, {
        name: 'SourceIdDataIndex'
    },{
        name: 'DestinationDataIndex'
	}, {
        name: 'DestinationIdDataIndex'
    }, {
        name: 'NoofCheckPointDataIndex'
    },{
        name: 'CheckPoint1DataIndex'
    },{
        name: 'CheckPointETA1DataIndex'
    },{
        name: 'CheckPoint2DataIndex'
    },{
        name: 'CheckPointETA2DataIndex'
    },{
        name: 'CheckPoint3DataIndex'
    },{
        name: 'CheckPointETA3DataIndex'
    },{
        name: 'CheckPoint4DataIndex'
    },{
        name: 'CheckPointETA4DataIndex'
    },{
        name: 'CheckPoint5DataIndex'
    },{
        name: 'CheckPointETA5DataIndex'
    },{
        name: 'CheckPoint6DataIndex'
    },{
        name: 'CheckPointETA6DataIndex'
    },{
        name: 'CheckPoint7DataIndex'
    },{
        name: 'CheckPointETA7DataIndex'
    },{
        name: 'CheckPoint8DataIndex'
    },{
        name: 'CheckPointETA8DataIndex'
    },{
        name: 'CheckPoint9DataIndex'
    },{
        name: 'CheckPointETA9DataIndex'
    },{
        name: 'CheckPoint10DataIndex'
    },{
        name: 'CheckPointETA10DataIndex'
    },{
        name: 'CheckPoint11DataIndex'
    },{
        name: 'CheckPointETA11DataIndex'
    },{
        name: 'CheckPoint12DataIndex'
    },{
        name: 'CheckPointETA12DataIndex'
    },{
        name: 'CheckPoint13DataIndex'
    },{
        name: 'CheckPointETA13DataIndex'
    },{
        name: 'CheckPoint14DataIndex'
    },{
        name: 'CheckPointETA14DataIndex'
    },{
        name: 'CheckPoint15DataIndex'
    },{
        name: 'CheckPointETA15DataIndex'
    },{
        name: 'CheckPoint16DataIndex'
    },{
        name: 'CheckPointETA16DataIndex'
    },{
        name: 'CheckPoint17DataIndex'
    },{
        name: 'CheckPointETA17DataIndex'
    },{
        name: 'CheckPoint18DataIndex'
    },{
        name: 'CheckPointETA18DataIndex'
    },{
        name: 'CheckPoint19DataIndex'
    },{
        name: 'CheckPointETA19DataIndex'
    },{
        name: 'CheckPoint20DataIndex'
    },{
        name: 'CheckPointETA20DataIndex'
    },{
        name: 'CheckPoint21DataIndex'
    },{
        name: 'CheckPointETA21DataIndex'
    },{
        name: 'CheckPoint22DataIndex'
    },{
        name: 'CheckPointETA22DataIndex'
    },{
        name: 'CheckPoint23DataIndex'
    },{
        name: 'CheckPointETA23DataIndex'
    },{
        name: 'CheckPoint24DataIndex'
    },{
        name: 'CheckPointETA24DataIndex'
    },{
        name: 'CheckPoint25DataIndex'
    },{
        name: 'CheckPointETA25DataIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/RouteMasterAction.do?param=getRouteMasterDetails',
        method: 'POST'
    }),
    storeId: 'RouteMasterId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    },{
    	type:'string',
    	dataIndex: 'RouteIdDataIndex'
    },{
    	type:'string',
    	dataIndex: 'BaDataIdIndex'
    },{
    	type:'string',
    	dataIndex: 'BaDataIndex'
    },{
    	type:'string',
    	dataIndex: 'VehicleTypeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'RouteModeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'RouteNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'ETADataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'KMSDataIndex'
    },{
        type: 'string',
        dataIndex: 'SourceDataIndex'
    },{
        type: 'string',
        dataIndex: 'SourceIdDataIndex'
    },{
        type: 'string',
        dataIndex: 'DestinationDataIndex'
    },{
        type: 'string',
        dataIndex: 'DestinationIdDataIndex'
    },{
        type: 'numeric',
        dataIndex: 'NoofCheckPointDataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint1DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA1DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint2DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA2DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint3DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA3DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint4DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA4DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint5DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA5DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint6DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA6DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint7DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA7DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint8DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA8DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint9DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA9DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint10DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA10DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint11DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA11DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint12DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA12DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint13DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA13DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint14DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA14DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint15DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA15DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint16DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA16DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint17DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA17DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint18DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA18DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint191DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA19DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint20DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA20DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint21DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA21DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint22DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA22DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint23DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA23DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint24DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA24DataIndex'
    },{	
    	type: 'string',
        dataIndex: 'CheckPoint25DataIndex'
    },{
    	type: 'string',
        dataIndex: 'CheckPointETA25DataIndex'
    }]
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
            dataIndex: 'RouteIdDataIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=RouteId%></span>"
        }, {
            dataIndex: 'BaDataIndex',
            hidden: false,
            header: "<span style=font-weight:bold;><%=BAName%></span>"
        }, {
            dataIndex: 'VehicleTypeDataIndex',
            hidden: false,
            header: "<span style=font-weight:bold;><%=VehicleType%></span>"
        }, {
            dataIndex: 'RouteModeDataIndex',
            header: "<span style=font-weight:bold;><%=RouteMode%></span>",
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=RouteName%></span>",
            dataIndex: 'RouteNameDataIndex',
            hidden: false,
            width: 100
        },{
            header: "<span style=font-weight:bold;><%=ETA%></span>",
            dataIndex: 'ETADataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=KMS%></span>",
            dataIndex: 'KMSDataIndex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Source%></span>",
            dataIndex: 'SourceDataIndex',
            hidden: false,
            width: 100
        }, {
            header: "<span style=font-weight:bold;><%=SourceId%></span>",
            dataIndex: 'SourceIdDataIndex',
            hidden: true,
            width: 100
        }, {
            header: "<span style=font-weight:bold;><%=Destination%></span>",
            dataIndex: 'DestinationDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=DestinationId%></span>",
            dataIndex: 'DestinationIdDataIndex',
            width: 100,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=NoofCheckPoint%></span>",
            dataIndex: 'NoofCheckPointDataIndex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint1DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA1DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint2DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA2DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint3DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA3DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint4DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA4DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint5DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA5DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint6DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA6DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint7DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA7DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint8DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA8DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint9DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA9DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint10DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA10DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint11DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA11DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint12DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA12DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint13DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA13DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint14DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA14DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint15DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA15DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint16DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA16DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint17DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA17DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint18DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA18DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint19DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA19DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint20DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA20DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint21DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA21DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint22DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA22DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint23DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA23DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint24DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA24DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPoint%></span>",
            dataIndex: 'CheckPoint25DataIndex',
            width: 30,
            hidden:true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=CheckPointETA%></span>",
            dataIndex: 'CheckPointETA25DataIndex',
            width: 30,
            hidden:true,
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
//*****************************************************************Grid *******************************************************************************
grid = getGrid('<%=RouteMasterDetails%>','<%=NoRecordsFound%>', store, screen.width - 40, 420, 18, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, '<%=PDF%>', true, '<%=Add%>',true,'<%=Modify%>');
//******************************************************************************************************************************************************
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=RouteMaster%>',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width-28,
        height: 540,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerComboPanel, grid]
    });
});</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
