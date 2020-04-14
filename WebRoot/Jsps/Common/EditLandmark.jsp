<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();
		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		LoginInfoBean loginInfo1 = new LoginInfoBean();
		loginInfo1 = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		if (loginInfo1 != null) {
			int mapType = loginInfo1.getMapType();
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
		if (str.length > 11) {
			loginInfo.setStyleSheetOverride(str[11].trim());
		}
		if (str.length > 12) {
			loginInfo.setIsLtsp(Integer.parseInt(str[12].trim()));
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

	Properties properties = ApplicationListener.prop;
	String LtspsToBlockAssetRegCan = properties.getProperty("LtspsToBlockAssetRegCan").trim();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	int userId = loginInfo.getUserId();
	String userAuthority = cf.getUserAuthority(systemId, userId);
	String[] str = LtspsToBlockAssetRegCan.split(",");
	List<String> systemList = Arrays.asList(str);
	String modifybutton = "";
	String deletebutton = "";
	System.out.println(systemId+userAuthority);
	if(systemId==15 && !userAuthority.equalsIgnoreCase("Admin") && loginInfo.getIsLtsp()==0){
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/401Error.html");
	}
	if(systemId==15 && loginInfo.getIsLtsp() == -1){
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/401Error.html");
	}
	if (systemList.contains(String.valueOf(loginInfo.getSystemId()))
			&& (customerId == 0 || loginInfo.getIsLtsp() == 0)) {
		modifybutton = "true";
		deletebutton = "false";
	} else if (systemList.contains(String.valueOf(loginInfo.getSystemId()))
			&& customerId > 0 && loginInfo.getIsLtsp() == -1) {
		modifybutton = "false";
		deletebutton = "false";
		if (userAuthority.equalsIgnoreCase("Admin")) {
			modifybutton = "true";
			deletebutton = "true";
		}
	}

	if (!systemList.contains(String.valueOf(loginInfo.getSystemId()))) {
		if (customerId == 0 || loginInfo.getIsLtsp() == 0) {
			modifybutton = "true";
			deletebutton = "true";
		} else {
			modifybutton = "false";
			deletebutton = "false";
			if (userAuthority.equalsIgnoreCase("Admin")) {
				modifybutton = "true";
				deletebutton = "true";
			}
		}
	}
	String distUnits = cf.getUnitOfMeasure(systemId);

	String EditLandmark = "Edit Hub/POI";
	String Ready = "Ready";
	String SLNO = "SLNO";
	String LocationName = "Hub/POI Name";
	String GeoFenceOperationType = "GeoFence Operation Type";
	String Radius = "Radius"+"("+distUnits+")";
	String Latitude = "Latitude";
	String Longitude = "Longitude";
	String GMTOffset = "GMTOffset";
	String Country = "Country";
	String Region = "Region";
	String Address = "Address";
	String tripCustomer = "Trip Customer";
	String contactPerson = "Contact Person";
	String State = "State";
	String City = "City";
	String EditLandmarkDetails = "Edit Landmark Detail";
	String Refresh = "Refresh";
	String RemoveFilters = "Remove Filters";
	String EditRadius = "";
	String EditLatLng = "";
	String Save = "Save";
	String PleaseWait = "";
	String Remove = "Remove";
	String ViewAllLocations = "";
	String EditPolygon = "";
	String StandardDuration = "Standard Duration";
	String Export = "Export";
	String LandMarkName = "Hub/POI Name";
	String NoRecordsFound = "No records found";
	String ClearFilterData = "Clear Filter Data";
	String Modify = "Modify";
	String Delete = "Delete";
	String Excel = "Excel";
	String Cancel = "Cancel";
	String Note = "Note";
	String Customer = "Customer";
	String LandmarkName = "Landmark Name";
	String DeleteInformation = "Delete Information";
	String DeleteConfirmation = "DELETE CONFIRMATION";
	String TypeDELETEtoconfirm = "Type DELETE to confirm";
	String AllTheDetailsRegardingToThisLandmarkWillBeRemoved = "All the Details Regarding this Landmark Will be Removed";
	String SelectCustomerName = "Select Customer Name";
	String NoRowsSelected = "No Rows Selected";
	String SelectSingleRow = "Select Single Row";
	String SelectTenRows = "Select maximum 10 rows for Delete";
	String DeleteDetails = "Delete Details";
	String PLEASEENTERDELETEINABOVETEXTFIELD = "PLEASE ENTER DELETE IN ABOVE TEXT FIELD";
	String Areyousureyouwanttodelete = "Are you sure you want to delete";
	String LocationNotDeleted = "Location Not Deleted";
	String PleaseEnterDELETEInCapitalLettersToDeleteTheRecord = "Please Enter DELETE in Capital Letters To Delete the Record";
%>

<jsp:include page="../Common/header.jsp" />
 <!--    <base href="<%=basePath%>">
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">   -->
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<style>
	.x-form-text {
    height: 21px;
}
.x-form-text {
		height: 21px;
	}	
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		label {
			display : inline !important;
		}
		.x-layer ul {
		 	min-height: 27px !important;
		}
		
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		 .x-window-maximized {
			 top : 52px !important;
		 }
	</style>
	
	<!-- </head> -->
   
 <!-- <body>  -->
  
 	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
	<jsp:include page="../Common/ExportJS.jsp" />

 <script>
 
 	var jspName = "HUB DETAILS";
 	var exportDataType = "int,String,String,String,String,String,String,String,String,String,String,String,String,String,String,String,String,String";
 	var grid;
 	var titleForInnerPanel;
 	var outerPanel;
 	Ext.Ajax.timeout = 360000;

 	var clientcombostore = new Ext.data.JsonStore({
 	    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
 	    id: 'CustomerStoreId',
 	    root: 'CustomerRoot',
 	    autoLoad: true,
 	    remoteSort: true,
 	    fields: ['CustId', 'CustName'],
 	    listeners: {
 	        load: function(custstore, records, success, options) {
 	            if (<%=customerId%> > 0) {
				 Ext.getCmp('custcomboId').setValue('<%=customerId%>');
 	                store.load({
 	                    params: {
 	                         clientId: '<%=customerId%>',
 	                         jspName: jspName,
 	                         custName: Ext.getCmp('custcomboId').getRawValue()
 	                    }
 	                });
 	            }else{
 	            		store.load({
 	                    params: {
 	                        clientId: Ext.getCmp('custcomboId').getValue(),
 	                        jspName: jspName,
 	                        custName: Ext.getCmp('custcomboId').getRawValue()
 	                    }
 	                });
 	            
 	            }
 	            
 	        }
 	    }
 	});

 	var custCombo = new Ext.form.ComboBox({
 	    store: clientcombostore,
 	    id: 'custcomboId',
 	    mode: 'local',
 	    forceSelection: true,
 	    emptyText: 'Select Customer',
 	    blankText: 'Select Customer',
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
 	              //  custId = Ext.getCmp('custcomboId').getValue();
 	                if (<%=customerId%> > 0) {
 	                    store.load({
 	                        params: {
 	                            clientId: '<%=customerId%>',
 	                            jspName: jspName,
 	                             custName: Ext.getCmp('custcomboId').getRawValue()
 	                        }
 	                    });
 	                } else {
 	                	store.load({
 	                    params: {
 	                        clientId: Ext.getCmp('custcomboId').getValue(),
 	                        jspName: jspName,
 	                         custName: Ext.getCmp('custcomboId').getRawValue()
 	                    }
 	                });
 	                }
 	            }
 	        }
 	    }
 	});


 	var Clientformodify = new Ext.form.ComboBox({
 	    store: clientcombostore,
 	    id: 'custcomboIdForModify',
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
 	                // Ext.getCmp('assetModelcomboId').reset();
 	                custId = Ext.getCmp('custcomboIdForModify').getValue();
 	            }
 	        }
 	    }
 	});
   
   	var countrystore = new Ext.data.JsonStore({
   	    url: '<%=request.getContextPath()%>/CustomerAction.do?param=getCountryList',
   	    id: 'CountryStoreId',
   	    root: 'CountryRoot',
   	    autoLoad: true,
   	    fields: ['CountryID', 'CountryName', 'Offset']
   	});

   	var countryCombo = new Ext.form.ComboBox({
   	    store: countrystore,
   	    id: 'countrycomboId',
   	    mode: 'local',
   	    forceSelection: true,
   	    emptyText: 'Select Country',
   	    selectOnFocus: true,
   	    allowBlank: false,
   	    anyMatch: true,
   	    typeAhead: false,
   	    triggerAction: 'all',
   	    lazyRender: true,
   	    valueField: 'CountryID',
   	    width: 170,
   	    displayField: 'CountryName',
   	    cls: 'selectstylePerfect',
   	    listeners: {
   	        select: {
   	            fn: function() {
   	                statestore.load({
   	                    params: {
   	                        countryId: Ext.getCmp('countrycomboId').getValue()
   	                    }
   	                });
   	                var country = countrystore.find('CountryID', Ext.getCmp('countrycomboId').getValue());
   	                if (country >= 0) {
   	                    var record = countrystore.getAt(country);
   	                    Ext.getCmp('gmtTextId').setValue(record.data['Offset']);
   	                } else {
   	                    Ext.getCmp('gmtTextId').setValue('');
   	                }
   	            }
   	        }
   	    }
   	});

   	var statestore = new Ext.data.JsonStore({
   	    url: '<%=request.getContextPath()%>/CustomerAction.do?param=getStateList',
   	    id: 'StateStoreId',
   	    root: 'StateRoot',
   	    autoLoad: false,
   	    fields: ['StateID', 'StateName']
   	});

   	var stateCombo = new Ext.form.ComboBox({
   	    store: statestore,
   	    id: 'statecomboId',
   	    mode: 'local',
   	    forceSelection: true,
   	    emptyText: 'Select State',
   	    selectOnFocus: true,
   	    allowBlank: false,
   	    anyMatch: true,
   	    typeAhead: false,
   	    triggerAction: 'all',
   	    lazyRender: true,
   	    valueField: 'StateID',
   	    width: 170,
   	    displayField: 'StateName',
   	    cls: 'selectstylePerfect',
   	    listeners: {
   	        select: {
   	            fn: function() {

   	            }
   	        }
   	    }
   	});
   	
   	var panelForClient = new Ext.Panel({
   	    standardSubmit: true,
   	    collapsible: false,
   	    layout: 'table',
   	    frame: false,
   	    width: screen.width,
   	    height: 40,
   	    layoutConfig: {
   	        columns: 20
   	    },
   	    items: [{
   	        width: 20
   	    }, {
   	        xtype: 'label',
   	        text: 'Select Client' + ' :',
   	        cls: 'labelstyle'
   	    }, custCombo]
   	});

   //******************************************************MODIFY******************************************************

   function modifyData() {
       title = "Edit Hub/POI";
		if (grid.getSelectionModel().getCount() > 1) {
            Ext.example.msg("<%=SelectSingleRow%>");
            return;
        }
        if (grid.getSelectionModel().getCount() == 0) {
            Ext.example.msg("<%=NoRowsSelected%>");
            return;
        }        
       var selected = grid.getSelectionModel().getSelected();
       var hubId = selected.get('hubIdDataIndex');
       var id = selected.get('idIndex');
       var isModify = true;
       var custName = "";
       var cname = Ext.getCmp('custcomboId').getRawValue();
       var custId = Ext.getCmp('custcomboId').getValue();
       var tempName = cname.split(" ");
       var i;
       for (i = 0; i < tempName.length; i++) {
           custName = custName + tempName[i] + "@";
       }
		Ext.Ajax.request({
                 		 url: '<%=request.getContextPath()%>/createLandmarkAction.do?param=checkHubInLegDetails',
                         method: 'POST',
                         params: {
                             hubId: hubId,
                         },
                         success: function(response, options) {
                             var message = response.responseText;
                             if(message == "Hub is not associated to leg"){
                                var locationPage = "<%=request.getContextPath()%>/Jsps/Common/CreateLandmark.jsp?hubId=" + hubId + "&isModify=" + isModify + "&id=" + id + "&custName=" + custName + "&custId=" + custId;
       							createMapWindow(locationPage, title);
                             //}else  (message == "Hub is associated to route leg"){
                              }else {
                             	//Ext.example.msg(message);
                             	  Ext.Msg.show({
						                title: 'Alert !!!',
						                msg: message + '. Do you want to proceed?',
						                buttons: {
						                    yes: true,
						                    no: true
						                },
						                fn: function(btn) {
						                    switch (btn) {
						                        case 'yes':
						                        var locationPage = "<%=request.getContextPath()%>/Jsps/Common/CreateLandmark.jsp?hubId=" + hubId + "&isModify=" + isModify + "&id=" + id + "&custName=" + custName + "&custId=" + custId;
       											createMapWindow(locationPage, title);
						                            break;
						                        case 'no':
						                            Ext.example.msg("Not Modified");
						                            // store.reload();
						                            break;
						                    }
						                }
						           
                             	});
                             }
                         },
                         failure: function() {
                             Ext.example.msg(message);
                         }		
		});

   }
   
   //*******************************************************Window*****************************************************
   
   function createMapWindow(locationPage,windowTitle){
		var win = new Ext.Window({
		       title:windowTitle,
		       autoShow : false,
			   constrain : false,
			   constrainHeader : false,
			   resizable : false,
			   maximizable : true,   
		   	   footer:true,
		       width:1335,
		       height:555,
		       shim:false,
		       animCollapse:false,
		       border:false,
		       constrainHeader:true,
		       layout: 'fit',
			   html : "<iframe style='width:100%;height:100%;background:#ffffff' src="+locationPage+"></iframe>",
			   listeners: {
			   maximize: function(){
			   },
			   minimize:function(){
			   },
			   resize:function(){
			   },
			   restore:function(){
			   },
			   close:function(){
                         grid.store.reload();
                  },
               hide:function(){
                 }
			   }
		});
			   win.show();
	}

    //******************************************************DELETE******************************************************

    function deleteData() {
        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("<%=SelectCustomerName%>");
            return;
        }
        if (grid.getSelectionModel().getCount() == 0) {
            Ext.example.msg("<%=NoRowsSelected%>");
            return;
        }
        if (grid.getSelectionModel().getCount() > 10) {
            Ext.example.msg("<%=SelectTenRows%>");
            return;
        }
        buttonValue = '<%=Delete%>';
        title = '<%=DeleteDetails%>';
           var selectedHubs = [];
	       var recordsForDelete = grid.getSelectionModel().getSelections();

      		 for (var i = 0,len = recordsForDelete.length; i < len ; i++) {
      		 	selectedHubs.push(recordsForDelete[i].get('hubIdDataIndex'));
        	}
        	var selectedHubs1 = selectedHubs.join("_");
        	if(recordsForDelete.length == selectedHubs.length ){
        	 		Ext.Ajax.request({
                 		 url: '<%=request.getContextPath()%>/createLandmarkAction.do?param=getLegAssociatedHubs',
                         method: 'POST',
                         params: {
                             hubs: selectedHubs1,
                         },
                         success: function(response, options) {
                             var message = response.responseText;
                             if(message == "Hub is not associated to leg"){
                              deleteDataForSure();
                             }else {
                             //	Ext.example.msg(message);
                             Ext.Msg.show({
                				title: 'Delete',
                				msg: message,
                				buttons: Ext.MessageBox.OK
                			 });
                             }
                         },
                         failure: function() {
                             Ext.example.msg(message);
                         }		
				  });
 	      }
        
       // Ext.getCmp('deleteTypeId').reset();
    }

    function deleteDataForSure() {
            Ext.Msg.show({
                title: 'Delete',
                msg: '<%=Areyousureyouwanttodelete%>',
                buttons: {
                    yes: true,
                    no: true
                },
                fn: function(btn) {
                    switch (btn) {
                        case 'yes':
                            outerPanel.getEl().mask();
                           var selected = grid.getSelectionModel().getSelected();
                            var lName = "";
							var records = grid.getSelectionModel().getSelections();
							var len = grid.getSelectionModel().getCount();	
						    for (var i = 0; i < records.length; i++)
						    {
							  var record = records[i];
						      lName =lName + record.get('landmarkNameDataIndex')+"@";
							}
                            Ext.Ajax.request({
                                url: '<%=request.getContextPath()%>/editLandmarkAction.do?param=deleteRecord',
                                method: 'POST',
                                params: {
                                    landmarkName: lName,
                                    custId: Ext.getCmp('custcomboId').getValue(),
                                },
                                success: function(response, options) {
                                    var message = response.responseText;
                                    Ext.example.msg(message);
                                   grid.store.reload();
									outerPanel.getEl().unmask();
                                },
                                failure: function() {
                                    Ext.example.msg("Error");
                                     grid.store.reload();
                                    outerPanel.getEl().unmask();
                                }
                            });
                            break;
                        case 'no':
                            Ext.example.msg("<%=LocationNotDeleted%>");
                            // store.reload();
                            break;
                    }
                }
            });
        
    }
//===================================================	Grid   =============================================================   

     var reader = new Ext.data.JsonReader({
         idProperty: 'readerId',
         root: 'NewGridRoot',
         totalProperty: 'total',
         fields: [{
             name: 'slnoIndex'
         }, {
             name: 'landmarkNameDataIndex'
         }, {
             name: 'locationNameDataIndex'
         }, {
             name: 'geoFenceDataIndex'
         }, {
             name: 'radiusDataIndex'
         }, {
             name: 'latitudeDataIndex'
         }, {
             name: 'longitudeDataIndex'
         }, {
             name: 'gmtOffsetDataIndex'
         }, {
             name: 'tripCustomerIndex'
         }, {
             name: 'addressIndex'
         }, {
             name: 'cityDataIndex'
         }, {
             name: 'stateDataIndex'
         }, {
             name: 'countryDataIndex'
         }, {
             name: 'regionDataIndex'
         }, {
             name: 'contactPersonIndex'
         }, {
             name: 'stdDurationDataIndex'
         }, {
             name: 'hubIdDataIndex'
         }, {
             name: 'idIndex'
         } ]
     });
     var store = new Ext.data.GroupingStore({
         autoLoad: false,

         proxy: new Ext.data.HttpProxy({
             url: '<%=request.getContextPath()%>/editLandmarkAction.do?param=getGridData',
             method: 'POST'
         }),
         remoteSort: false,
         sortInfo: {
             field: 'landmarkNameDataIndex',
             direction: 'ASC'
         },
         storeId: 'editLandmarkStoreId',
         reader: reader
     });

     var filters = new Ext.ux.grid.GridFilters({
         local: true,
         filters: [{
                 type: 'numeric',
                 dataIndex: 'slnoIndex'
             }, {
                 type: 'string',
                 dataIndex: 'landmarkNameDataIndex'
             }, {
                 type: 'string',
                 dataIndex: 'locationNameDataIndex'
             }, {
                 type: 'string',
                 dataIndex: 'geoFenceDataIndex'
             }, {
                 type: 'string',
                 dataIndex: 'radiusDataIndex'
             }, {
                 type: 'string',
                 dataIndex: 'latitudeDataIndex'
             }, {
                 type: 'string',
                 dataIndex: 'longitudeDataIndex'
             }, {
                 type: 'string',
                 dataIndex: 'gmtOffsetDataIndex'
             }, {
                 type: 'string',
                 dataIndex: 'tripCustomerIndex'
             },{
                 type: 'string',
                 dataIndex: 'addressIndex'
             }, {
                 type: 'string',
                 dataIndex: 'cityDataIndex'
             }, {
                 type: 'string',
                 dataIndex: 'stateDataIndex'
             }, {
                 type: 'string',
                 dataIndex: 'countryDataIndex'
             },  {
                 type: 'string',
                 dataIndex: 'regionDataIndex'
             }, {
                 type: 'string',
                 dataIndex: 'contactPersonIndex'
             }, {
                 type: 'string',
                 dataIndex: 'stdDurationDataIndex'
             }, {
                 type: 'string',
                 dataIndex: 'hubIdDataIndex'
             }, {
                 type: 'string',
                 dataIndex: 'idIndex'
             }
         ]
     });

     var createColModel = function(finish, start) {
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
                 header: "<span style=font-weight:bold;>Landmark Name</span>",
                 dataIndex: 'landmarkNameDataIndex',
                 width: 80,
                 filter: {
                     type: 'String'
                 }
             }, {
                 header: "<span style=font-weight:bold;><%=LocationName%></span>",
                 dataIndex: 'locationNameDataIndex',
                 width: 80,
                 filter: {
                     type: 'String'
                 }
             }, {
                 header: "<span style=font-weight:bold;><%=GeoFenceOperationType%></span>",
                 dataIndex: 'geoFenceDataIndex',
                 width: 80,
                 filter: {
                     type: 'String'
                 }
             }, {
                 header: "<span style=font-weight:bold;><%=Radius%></span>",
                 dataIndex: 'radiusDataIndex',
                 width: 60,
                 filter: {
                     type: 'String'
                 }
             }, {
                 header: "<span style=font-weight:bold;><%=Latitude%></span>",
                 dataIndex: 'latitudeDataIndex',
                 width: 80,
                 filter: {
                     type: 'String'
                 }
             }, {
                 header: "<span style=font-weight:bold;><%=Longitude%></span>",
                 dataIndex: 'longitudeDataIndex',
                 width: 80,
                 filter: {
                     type: 'String'
                 }
             }, {
                 header: "<span style=font-weight:bold;><%=GMTOffset%></span>",
                 dataIndex: 'gmtOffsetDataIndex',
                 width: 80,
                 filter: {
                     type: 'String'
                 }
             }, {
                 header: "<span style=font-weight:bold;><%=tripCustomer%></span>",
                 dataIndex: 'tripCustomerIndex',
                 width: 70,
                 filter: {
                     type: 'String'
                 }
             },{
                 header: "<span style=font-weight:bold;><%=Address%></span>",
                 dataIndex: 'addressIndex',
                 width: 100,
                 filter: {
                     type: 'String'
                 }
             }, {
                 header: "<span style=font-weight:bold;><%=City%></span>",
                 dataIndex: 'cityDataIndex',
                 width: 80,
                 filter: {
                     type: 'String'
                 }
             }, {
                 header: "<span style=font-weight:bold;><%=State%></span>",
                 dataIndex: 'stateDataIndex',
                 width: 80,
                 filter: {
                     type: 'String'
                 }
             }, {
                 header: "<span style=font-weight:bold;><%=Country%></span>",
                 dataIndex: 'countryDataIndex',
                 width: 80,
                 filter: {
                     type: 'String'
                 }
             },	{
                 header: "<span style=font-weight:bold;><%=Region%></span>",
                 dataIndex: 'regionDataIndex',
                 width: 80,
                 filter: {
                     type: 'String'
                 }
             }, {
                 header: "<span style=font-weight:bold;><%=contactPerson%></span>",
                 dataIndex: 'contactPersonIndex',
                 width: 80,
                 filter: {
                     type: 'String'
                 }
             }, {
                 header: "<span style=font-weight:bold;><%=StandardDuration%></span>",
                 dataIndex: 'stdDurationDataIndex',
                 width: 70,
                 filter: {
                     type: 'String'
                 }
             }, {
                 header: 'HUB ID',
                 hidden: true,
                 width: 100,
                 dataIndex: 'hubIdDataIndex',
                 hideable: true
             }, {
                 header: 'id',
                 hidden: true,
                 width: 100,
                 dataIndex: 'idIndex',
                 hideable: true
             }
             
         ];
         return new Ext.grid.ColumnModel({
             columns: columns.slice(start || 0, finish),
             defaults: {
                 sortable: true
             }
         });
     };

     
 
     grid = getGrid('<%=EditLandmark%>', '<%=NoRecordsFound%>', store, screen.width - 35, 450, 20, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, 'PDF', false, false, '<%=modifybutton%>', '<%=Modify%>', '<%=deletebutton%>', '<%=Delete%>');


     Ext.onReady(function() {
         Ext.QuickTips.init();
         outerPanel = new Ext.Panel({
             //title: 'Edit Landmark',
             renderTo: 'content',
             standardSubmit: true,
             autoScroll: false,
             frame: true,
             border: false,
             cls: 'outerpanel',
             width: screen.width - 10,
             layoutConfig: {
                 columns: 1
             },
             items: [panelForClient, grid]
         });
     });
     
    
</script>

<jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->