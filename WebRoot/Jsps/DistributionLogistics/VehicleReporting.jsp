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
			loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
		}
		session.setAttribute("loginInfoDetails", loginInfo);

	}

	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session
			.getAttribute("loginInfoDetails"), session, request,
			response);
	String responseaftersubmit = "''";
	String feature = "1";
	if (session.getAttribute("responseaftersubmit") != null) {
		responseaftersubmit = "'"
				+ session.getAttribute("responseaftersubmit")
						.toString() + "'";
		session.setAttribute("responseaftersubmit", null);
	}
	String hubId = "0";
	if(request.getParameter("hubId")!=null && !request.getParameter("hubId").equals("")){
		hubId=request.getParameter("hubId");
	}
	LoginInfoBean loginInfo = (LoginInfoBean) session
			.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	int userId = loginInfo.getUserId();

	ArrayList<String> tobeConverted = new ArrayList<String>();
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Excel");
	tobeConverted.add("Cancel");
	tobeConverted.add("Add");
	tobeConverted.add("Delete");
	tobeConverted.add("Modify");
	tobeConverted.add("Modify_Details");
	tobeConverted.add("Save");
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Select_Customer_Name");
	tobeConverted.add("SLNO");
	tobeConverted.add("Select_Group_Name");
	tobeConverted.add("Select_Vehicle");

	ArrayList<String> convertedWords = new ArrayList<String>();
	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,
			language);
	String NoRecordsFound = convertedWords.get(0);
	String ClearFilterData = convertedWords.get(1);
	String Excel = convertedWords.get(2);
	String Cancel = convertedWords.get(3);
	String Add = convertedWords.get(4);
	String Delete = convertedWords.get(5);
	String Modify = convertedWords.get(6);
	String ModifyDetails = convertedWords.get(7);
	String Save = convertedWords.get(8);
	String Customer_Name = convertedWords.get(9);
	String SelectCustomerName = convertedWords.get(10);
	String SLNO = convertedWords.get(11);
	String SelectGroupName = convertedWords.get(12);
	String SelectVehicle = convertedWords.get(13);
	String userAuthority=cf.getUserAuthority(systemId,userId);
%>
<jsp:include page="../Common/header.jsp" />  
    <title>Vehicle Reporting</title>

  <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	
  </style>

   <%
   	if (loginInfo.getStyleSheetOverride().equals("Y")) {
   %>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                              
   <%
                                                 	} else {
                                                 %>  
   <jsp:include page="../Common/ImportJS.jsp" />
   <%
   	}
   %>
    <!-- for exporting to excel***** -->
   <jsp:include page="../Common/ExportJS.jsp" />   
   <style>
		label {
			display : inline !important;
		}
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		.x-layer ul {
			min-height : 27px !important;
		}
   </style>
   <script>    
    var outerPanel;
 	var ctsb;
 	var dtprev=dateprev;
 	var dtcur = currentDate;
 	var dtnxt = nextDate;
 	var jspName="VehicleReportingDetails";
 	var titelForInnerPanel = "Vehicle Reporting Details";
 	var exportDataType="int,string,int,string,string,string,string,string,string,string,string,string,string,string,string";
 	var selected;
 	var grid;
 	var buttonValue;
 	var title;
 	var myWin;
 	var custId = '<%=customerId%>';
 	var globalGroupId;
 	var globalHubId;
 	var id;
 	var editedRowsForGrid = "";
 	
 	function isValidTime(dateTime) {
    	var pattern = new RegExp(/^([0-1][0-9]|2[0-3]):([0-5][0-9])?$/);
    	return pattern.test(dateTime);
	}
 	
 	//override function for showing first row in grid
 	Ext.override(Ext.grid.GridView, {
    	afterRender: function(){
        this.mainBody.dom.innerHTML = this.renderRows();
        this.processRows(0, true);
        if(this.deferEmptyText !== true){
            this.applyEmptyText();
        }
        this.fireEvent("viewready", this);//new event
    	}   
    	
	});  
//**************************customer combo***************************
var customercombostore = new Ext.data.JsonStore({
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
                  custName = Ext.getCmp('custcomboId').getRawValue();
                   
                  hubStore.load({
                       params: {
                           CustID: Ext.getCmp('custcomboId').getValue()
                           
                       }
                   });
              }
          }
      }
  });

  var custnamecombo = new Ext.form.ComboBox({
      store: customercombostore,
      id: 'custcomboId',
      mode: 'local',
      forceSelection: true,
      emptyText: '<%=SelectCustomerName%>',
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
                  custName = Ext.getCmp('custcomboId').getRawValue();
					hubStore.load({
                       params: {
                           CustId: custId
                       }
                   });
                   summaryGrid.store.clearData();
  		           summaryGrid.view.refresh();
              }
          }
      }
  });	

 
 //**********************node combo******************************
   var hubStore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/MiddleMileDashboardAction.do?param=getHubDetails',
       id: 'HubID',
       root: 'HubDetailsRoot',
       autoLoad: false,
       remoteSort: true,
       fields: ['hubId', 'hubName'],
       listeners: {
          load: function () {
              if (<%=hubId%> != null && <%=hubId%> != '') {
                  Ext.getCmp('hubNameComboId').setValue('<%=hubId%>');
                    Store.load({
				                        params: {
				                        	jspName : jspName,
				                            CustId: Ext.getCmp('custcomboId').getValue(),
				                            CustName: Ext.getCmp('custcomboId').getRawValue(),
				                            hubId: Ext.getCmp('hubNameComboId').getValue(),
				                            hubName: Ext.getCmp('hubNameComboId').getRawValue(),
				                            dateId: Ext.getCmp('dateId').getValue().format('Y-m-d')
                       				}
				                });
					loadData();
              }
          }
      }
   });
   
   var hubNameCombo = new Ext.form.ComboBox({
       fieldLabel: '',
       store: hubStore,
       id: 'hubNameComboId',
       emptyText: 'Select Node Name',
       blankText: 'Select Node Name',
       resizable: true,
       hidden: false,
       forceSelection: true,
       enableKeyEvents: true,
       mode: 'local',
       triggerAction: 'all',
       displayField: 'hubName',
       valueField: 'hubId',
       loadingText: 'Searching...',
       cls: 'selectstylePerfect',
       minChars: 3,
       listeners: {
           select: {
               fn: function() {
                   CustId = Ext.getCmp('custcomboId').getValue();
                   loadData();
                   summaryGrid.store.clearData();
  		           summaryGrid.view.refresh();
               }
           }
       }
   });

  	 //***************** vehicle combo **************************		
	var regStore= new Ext.data.JsonStore({
	   url:'<%=request.getContextPath()%>/StoppageReportAction.do?param=getVehicleRegNosNew',
       root: 'RegNosNew',
       autoLoad: true,
	   fields: ['vehicleNoName','groupName','vehicleType']
	   
     });
	 
	var vehiclecombo = new Ext.form.ComboBox({
        store: regStore,
        id: 'vehiclecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectVehicle%>',
        selectOnFocus: true,
        resizable: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'vehicleNoName',
        displayField: 'vehicleNoName',
       // cls: 'selectstylePerfect',
        width:300,
        loadingText: 'Searching...',
	    enableKeyEvents: true,
	    minChars: 2,
	    listeners: {
	        select: {
	            fn: function() {
	                vehId = Ext.getCmp('vehiclecomboId').getValue();
	                var id = regStore.findExact('vehicleNoName', vehId);
                    var record = regStore.getAt(id);
					summaryGrid.getSelectionModel().getSelected().set('vehiclegroup',record.data['groupName']);
					summaryGrid.getSelectionModel().getSelected().set('vehicleType',record.data['vehicleType']);
					summaryGrid.getSelectionModel().getSelected().set('createTripIndex','Create Trip');
	            }
	        }
	    }
	});

 function loadData(){
 custId = Ext.getCmp('custcomboId').getValue(); 
  
 globalHubId = Ext.getCmp('hubNameComboId').getValue();
 
 date= Ext.getCmp('dateId').getValue().format('Y-m-d');
 
 if((custId)&&(globalHubId)){
 regStore.load({
	params:{globalClientId : custId,
	       
	       globalHubId:globalHubId,
	       date:date
	       
	        }
	});
 
 }
	
	}
	//**************************** innerPanel ***********************************************		
	var innerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'innerPanelId',
        layout: 'table',
        frame: true,
        layoutConfig: {
            columns: 15
        },
        items: [{width:30},
        		{
                	xtype: 'label',
                 	text: 'Customer Name' + ' :',
                 	cls: 'labelstyle',
                 	id: 'customerlab'
               
            	},
            	{width:10},
            	custnamecombo,
     			{width:85},{
            	 	xtype: 'label',
            	 	text: 'Asset Node Name' + ' :',
            		cls: 'labelstyle',
            		id: 'assetLabelId'
        		},{width:10},
        		hubNameCombo,
			    {width:85},{
			    	xtype: 'label',
			    	text : 'Date' + ' :',
			    	cls: 'labelstyle',
			    	id: 'datelab',
			    	width:60
			    },{width:10},
			    {
  		            xtype: 'datefield',
  		            cls: 'selectstylePerfect',
  		            width: 185,
  		            format: getDateFormat(),
  		            emptyText: 'Select Date',
  		            allowBlank: false,
  		            blankText: 'Select Date',
  		            id: 'dateId',
  		            value: dtcur,
  		            vtype: 'daterange',
  		            maxValue: dtnxt,
  		            listeners: {
	        			select: {
	            			fn: function() {
	                			summaryGrid.store.clearData();
  		            			summaryGrid.view.refresh();
	            				}
	        				}
	    				}
  		            
  		            
  		        },{width:95},
			    { 
			    	xtype:'button',
			    	text:'View',
			    	id: 'addbuttonid',
			    	width:80,
			    	hidden:false,
			    	listeners: 
	       			{
		        		click:
		        		{
			       			fn:function()
			       			{
			       				if(Ext.getCmp('custcomboId').getValue() == "" )
							    {
						                 Ext.example.msg("<%=SelectCustomerName%>");
						                 Ext.getCmp('custcomboId').focus();
				                      	 return;
							    }
							    if(Ext.getCmp('hubNameComboId').getValue() == "" )
							    {
						                 Ext.example.msg("Select Asset Node Name");
						                 Ext.getCmp('hubNameComboId').focus();
				                      	 return;
							    }
							    if(Ext.getCmp('hubNameComboId').getValue()==0)
           						{          							
           							//document.getElementById("addButtonId").style.display='none'; 
           							summaryGrid.getBottomToolbar().get(2).disable();         
          						}
          						else
          						{
          						//document.getElementById("addButtonId").style.display='block';
          						summaryGrid.getBottomToolbar().get(2).enable();
          						}
							    if(Ext.getCmp('dateId').getValue() == "" )
							    {
						             Ext.example.msg("Select Date");
						             Ext.getCmp('dateId').focus();
				                     return;
							    }
							    
							   Store.load({
				                        params: {
				                        	jspName : jspName,
				                            CustId: Ext.getCmp('custcomboId').getValue(),
				                            CustName: Ext.getCmp('custcomboId').getRawValue(),
				                            hubId: Ext.getCmp('hubNameComboId').getValue(),
				                            hubName: Ext.getCmp('hubNameComboId').getRawValue(),
				                            dateId: Ext.getCmp('dateId').getValue().format('Y-m-d')
                       				}
				                });

			       			}
	       				}
       				}
			    }
        	]
   		 }); // End of innerPanel
   		 
 
	       			
//============================ Grid table creation ================================
		//********** reader *************
     	var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'VelicleReportingRoot',
        totalProperty: 'total',
        fields: [{
        	name: 'slnoIndex'
        },{
            name: 'hubnameIndex'
        },{ 
        	name: 'uniqueIdIndex'
        },{ 
        	name: 'idIndex'
        },{ 
        	name: 'vehicleTypeIndex'
        },{
            name: 'makeIndex'
        },{
            name: 'dedicatedAdhocIndex'
        }, {
            name: 'selectVehicleIndex'
        },{
            name: 'vehiclegroup'
        },{
            name: 'dateindex'
        },{
            name: 'currentdateindex'
        },{
            name: 'countIndex'
        },{
            name: 'actualReportingTimeIndex'
        },{
            name: 'actualReportingDateTimeIndex'
        },{
            name: 'insertedDateTimeIndex'
        },{
            name: 'vehicleIndentIdIndex'
        },{
            name: 'editRowIndex'
        },{
            name: 'createTripIndex'
        }]
    }); 
		//********** store *****************
		var Store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
           	url: '<%=request.getContextPath()%>/StoppageReportAction.do?param=getVehicleAllocations',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'darstore',
        reader: reader
    	});
    	
		//*********** filters **********
		var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        },{
            type: 'string',
            dataIndex: 'hubnameIndex'
        },{
            type: 'numeric',
            dataIndex: 'idIndex'
        },{
            type: 'string',
            dataIndex: 'vehicleTypeIndex'
        },{
            type: 'string',
            dataIndex: 'makeIndex'
        }, {
            type: 'string',
            dataIndex: 'dedicatedAdhocIndex'
        }, {
            type: 'string',
            dataIndex: 'selectVehicleIndex'
        }, {
            type: 'string',
            dataIndex: 'vehiclegroup'
        },{
            type: 'date',
            dataIndex: 'dateindex'
        }, {
            type: 'date',
            dataIndex: 'currentdateindex'
        }, {
            type: 'numeric',
            dataIndex: 'countindex'
        },{
            type: 'date',
            dataIndex: 'actualReportingTimeIndex'
        },{
            type: 'date',
            dataIndex: 'actualReportingDateTimeIndex'
        },{
            type: 'date',
            dataIndex: 'insertedDateTimeIndex'
        },{
            type: 'numeric',
            dataIndex: 'vehicleIndentIdIndex'
        },{
            type: 'boolean',
            dataIndex: 'editRowIndex'
        },{
            type: 'string',
            dataIndex: 'createTripIndex'
        }]
      });
		
		//************************************Column Model Config******************************************
    	var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                width: 50
            }),{
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;>Hub Name</span>",
                dataIndex: 'hubnameIndex',
                width: 100
            },{
                header: "<span style=font-weight:bold;>ID</span>",
                dataIndex: 'idIndex',
                hidden: true,
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;>Indent Vehicle Type</span>",
                dataIndex: 'vehicleTypeIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            }, {
        		header: "<span style=font-weight:bold;>Make</span>",
           	 	dataIndex: 'makeIndex',
            	//renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            	filter: {
            	type: 'string'
            	}
        	}, {
        		header: "<span style=font-weight:bold;>Dedicated/Ad-hoc</span>",
           	 	dataIndex: 'dedicatedAdhocIndex',
            	filter: {
            	type: 'string'
            	}
        	}, {
        		header: "<span style=font-weight:bold;>Select Vehicle</span>",
        		width: 100,
           	 	dataIndex: 'selectVehicleIndex',
           	 	editor: new Ext.grid.GridEditor(vehiclecombo),
            	filter: {
            	type: 'string'
            	}
        	},{
        		header: "<span style=font-weight:bold;>Vehicle-BA</span>",
        		width: 100,
           	 	dataIndex: 'vehiclegroup',
            	filter: {
            	type: 'string'
            	}
        	},{
                header: "<span style=font-weight:bold;>Current Reporting Time</span>",
                dataIndex: 'actualReportingTimeIndex'
            },{
                header: "<span style=font-weight:bold;>Actual Reporting Time</span>",
                dataIndex: 'actualReportingDateTimeIndex'
            },{
                header: "<span style=font-weight:bold;>Vehicle Allocated DateTime</span>",
                dataIndex: 'insertedDateTimeIndex'
            },{
                header: "<span style=font-weight:bold;>VEHICLE_INDENT_ID</span>",
                dataIndex: 'vehicleIndentIdIndex',
                hidden: true,
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;>Edit Row</span>",
                dataIndex: 'editRowIndex',
                hidden: true,
                width: 100
            },{
            	header: "<span style=font-weight:bold;>Create Trip</span>",
            	dataIndex: 'createTripIndex',
                width: 100
            }
        ];

        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };




	//***************** getGrid ****************************
 summaryGrid = getEditorGrid('', '<%=NoRecordsFound%>', Store, screen.width - 40, 450, 20, filters, '<%=ClearFilterData%>', false, '', 20, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, 'PDF', true, '<%=Save%>', false, '<%=Save%>', false, '<%=Delete%>');
 summaryGrid.on({
        beforeedit: function(e) {
            if (e.record.get('editRowIndex') == false && '<%=userAuthority%>' != 'Admin') {
                return false;
            }
          if (e.record.get('dateindex')>e.record.get('currentdateindex')) 
           {
             	Ext.getCmp('vehiclecomboId').getValue().disable();
             	Ext.getCmp('vehiclecomboId').getValue().enable();
           }
          if (e.record.get('countIndex')!==0 && '<%=userAuthority%>' == 'Admin') 
           {           		
             	Ext.getCmp('vehiclecomboId').getValue().disable();
             	Ext.getCmp('vehiclecomboId').getValue().enable();          		
           }
        }
    });

	function addRecord() {
	    var json = '';
    	for (var i = 0, len = summaryGrid.getStore().data.length; i < len; i++) {
        	var row = summaryGrid.getStore().getAt(i);
        	
            json += Ext.util.JSON.encode(row.data) + ',';
    	}

	    if (json != '') { 
	        json = json.substring(0, json.length - 1);
	    }
	    
	    Ext.MessageBox.confirm('Confirm', "Do you want to save?", function(btn) {

	    	if (btn == 'yes') {
	    	
	    	
	    	 Ext.MessageBox.show({
		        title: 'Please wait',
		        msg: 'Processing...',
		        progressText: 'Processing...',
		        width: 300,
		        progress: true,
		        closable: false,		        
		});
		
    	Ext.Ajax.request({
	        url: '<%=request.getContextPath()%>/StoppageReportAction.do?param=saveVehicleNumberAndTime',
	        method: 'POST',
	        params: {
	            json: json,
	            hubId : Ext.getCmp('hubNameComboId').getValue(),
	            dateId : Ext.getCmp('dateId').getValue(),
	            CustId : Ext.getCmp('custcomboId').getValue()

		    	        },
	        success: function(response, options) {
		        Ext.MessageBox.hide();
		        if(response.responseText == 'Success'){
		        	Ext.example.msg("Saved successfully");
		        	Store.reload();
		        	loadData();
		        }else if(response.responseText == 'Error'){
		        	Ext.example.msg("Something went wrong. Please check your connection or re-login.");	
		        	Store.reload();
		        }else{
		        	Ext.example.msg(response.responseText);
		        	//Store.reload();
		        }
	            json = "";
	        },
	        failure: function() {
	            store.reload();
	            json = "";
	        },
    	});
    	
    	}
    	});
	}
	function tripCreation(){
		var selected = summaryGrid.getSelectionModel().getSelected();
		var vehicleNo = selected.get('selectVehicleIndex');
		var hubId = Ext.getCmp('hubNameComboId').getValue();
		var pageId = "vehicleReport";
		var vehicleRepDate = Ext.getCmp('dateId').getValue();
		vehicleRepDate = vehicleRepDate.toLocaleDateString();
		window.location.href = "<%=request.getContextPath()%>/Jsps/GeneralVertical/CreateTrip.jsp?vehicleNo="+vehicleNo+"&hubId="+hubId+"&pageId="+pageId+"&vehicleRepDate="+vehicleRepDate+"";
	}
	//*********************main starts from here*************************
 	Ext.onReady(function(){
	ctsb=tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';			         	   			
 	outerPanel = new Ext.Panel({
			title:'Vehicle Placement',
			renderTo : 'content',
			standardSubmit: true,
			frame:true,
			cls:'outerpanel',
			border:false,
			items: [innerPanel,summaryGrid]  
			//bbar:ctsb			
			}); 
	});   
   
    </script>
  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->