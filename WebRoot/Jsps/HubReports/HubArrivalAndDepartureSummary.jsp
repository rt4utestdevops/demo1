<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
		loginInfo.setStyleSheetOverride("N");
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
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
			loginInfo.setStyleSheetOverride("N");
		}
		session.setAttribute("loginInfoDetails", loginInfo);
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
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
ArrayList<String> tobeConverted=new ArrayList<String>();


ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);


	     String ByHubs="By Hub";
	    String ByRegs="By Registration";
	    String VehNo= " Vehicle Number";
		String Groupname= "Group Name";
		String VehId= "Vehicle Id";
		String Nooftimesentered = "No of times entered in Hub "; 
		String NooftimeExited = "No of times Exited from Hub."; 
		String averagedetentiontime = "Average Detention Time ";
		String selectHub="Select Hub";
		String selectRegistration ="Select Registration";
		String startDates ="Start Date";
		String endDates ="end Date";
		String SLNOs="SL No";
		String VehType="Vehicle Type";	
		String Durationentered="Time Duration spent inside the Hub ( HH:MM:SS )";	
		String DurationExited="Time Duration spent Outside the Hub ( HH:MM:SS )";
		 

%>

<jsp:include page="../Common/header.jsp" />
	
		<title>Hub Summary Report</title>
	<style type="text/css">
	.x-table-layout td {
    vertical-align: inherit !important;
    }
    .x-btn-text addbutton{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;}
	.x-btn-text editbutton{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;}
	.x-btn-text excelbutton{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;}
	.x-btn-text pdfbutton{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;}
	.x-btn-text{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;}
	.x-btn-text clearfilterbutton{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;
	}


.customerPannelcssnew{
height:50px;
padding-top:10px;
padding-bottom:10px;
}

</style>
	
	
		<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/ImportJSSandMining.jsp" />                                                    
        <%}else {%>  
        <jsp:include page="../Common/ImportJS.jsp" /><%}%>
        <jsp:include page="../Common/ExportJS.jsp" />      

        <pack:style src="../../Main/resources/css/LovCombo/Ext.ux.form.LovCombo.css"></pack:style>
	  	<pack:style src="../../Main/resources/css/LovCombo/empty.css"></pack:style>
	  	<pack:style src="../../Main/resources/css/LovCombo/lovcombo.css"></pack:style>
	  	<pack:script src="../../Main/Js/LovCombo/Ext.ux.form.LovCombo.js"></pack:script>
	  	<pack:script src="../../Main/Js/LovCombo/Ext.ux.ThemeCombo.js"></pack:script>
		
		<style>
			.x-panel-header
		{
				height: 7% !important;
		}
		.x-form-radio {
			margin-bottom: 1px !important;
		}
		.x-form-label-left label {
			text-align: left;
			margin-top: 4px !important;
		}
		.x-grid3-cell-inner,.ext-strict .x-grid3-hd-inner {
			height: 26px !important;
			padding-top: 8px;
		}
		.x-form-text {
			height: 21px !important;
		}
		label {
			display : inline !important;
		}
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		.x-layer ul {
			min-height: 27px !important;	
		}
		</style>
	  	
        <script>
        
        var jspName='HubArrivalandDepReport';
        var exportDataType = "int,string,string,string,string,string,string,string,string,string,string";
    	var currentTime = new Date();
    	  var sdDate = new Date().add(Date.DAY, -2);
	   // var minDate = dateprev.add(Date.Month, -30);
	   var dtprev=dateprev; 
	   var nwdate=sdDate;
	   var prevselect = false;
	 //********************************************Grid config starts***********************************
  
  
    // **********************************************Reader configs Starts******************************
    
     var reader = new Ext.data.JsonReader({
        idProperty: 'HubArrivalDepartureId',
    	root: 'HubArrivalDepRoot',
    	totalProperty: 'total',
    	fields: [{
        name: 'slnoIndex'
    	},{
        name: 'VehNoId'
    	},{
    	name: 'GroupnameId'
    	},{
    	name: 'VehId'
    	},{
    	name: 'VehTypeId'
    	},{
        name: 'NooftimesenteredId'
    	}, {
    	name: 'NooftimeExitedId'
    	},{
    	name: 'DurationenteredId'
    	},{
    	name: 'DurationExitedId'
    	},{
        name: 'averagedetentiontimeId'
    	},{
        name: 'averagedetentionouttimeId'
    	}]
    });
    
    // **********************************************Reader configs Ends******************************

    //********************************************Store Configs For Grid*************************

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/HubSummaryReportAction.do?param=getHubSummaryDetails',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'tripDetailsStore',
        reader: reader
        });
        
   //********************************************Store Configs For Grid Ends*************************
       
	Ext.override(Ext.ux.form.LovCombo, {
		beforeBlur: Ext.emptyFn
	});
	
	var Hubcombostore = new Ext.data.JsonStore({                
    url: '<%=request.getContextPath()%>/HubSummaryReportAction.do?param=getAllHubs',
    id: 'HubStoreId',
    root: 'AllHubRoot',
    autoLoad: true,
    fields: ['HubName','HubID']
	});
	
		var Hubnamecombo = new Ext.ux.form.LovCombo({
		id:'HubcomboId',	
		store: Hubcombostore,
		mode: 'local',
        cls: 'selectstylePerfect',
	    forceSelection: true,
	     resizable: true,
	    emptyText: 'select Hub',
	    //blankText: '',
	    lazyRender: true,
	    selectOnFocus: true,
	    allowBlank: false,
	    autoload: true,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    valueField: 'HubID',
	    displayField: 'HubName',
	    multiSelect:true,
		beforeBlur: Ext.emptyFn,
   		listeners: {
          select:function(record, index) {     
              
             if(Ext.getCmp('HubcomboId').getRawValue() == 'ALL'){
	             prevselect = true;
				this.selectAll();
			}else if(Ext.getCmp('HubcomboId').getRawValue()!='ALL' && prevselect == true){
				this.deselectAll(); 
				prevselect = false;				
			} else{
				var newHub=[];
				newHub =Ext.getCmp('HubcomboId').getRawValue().split(',');
				if(newHub[0]=='ALL'){ 
				prevselect = true;
				this.selectAll(); 
				}
				}
	        }
	     }
	});
	Ext.override(Ext.ux.form.LovCombo, {
		beforeBlur: Ext.emptyFn
	});
	
	var groupcombostore = new Ext.data.JsonStore({                
    url: '<%=request.getContextPath()%>/HubSummaryReportAction.do?param=getAllGroupName',
    id: 'GroupStoreId',
    root: 'GroupRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['groupID', 'groupName']
});
	
    var Groupcombo = new Ext.form.ComboBox({
    store: groupcombostore,
    id: 'GrpcomboId',
    mode: 'local',
    hidden: true,
    forceSelection: true,
    emptyText: 'select group',
    blankText: '',
    lazyRender: true,
    selectOnFocus: true,
    allowBlank: true,
    autoload: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'groupID',
    displayField: 'groupName',
     cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function () {
         	  Ext.getCmp('RegcomboId').reset()
             var globalgroup = Ext.getCmp('GrpcomboId').getValue();                            
					Regnocombostore.load({
                                params: {
                                    group: globalgroup
                                }
                         });
                        }
        }
    }
	});
		var Regnocombostore = new Ext.data.JsonStore({                
    url: '<%=request.getContextPath()%>/HubSummaryReportAction.do?param=getAllRegistrationNo',
    id: 'RegnoStoreId',
    root: 'RegistrationRoot',
    autoLoad: false,
    fields: ['vehicleNo']
	});
	
    var Regnonamecombo = new Ext.ux.form.LovCombo({
    	id:'RegcomboId',	
		store: Regnocombostore,
		mode: 'local',
	    hidden: true,
       cls: 'selectstylePerfect',
	    forceSelection: true,
	    emptyText: 'Select Registration No',
	    blankText: '',
	    lazyRender: true,
	    selectOnFocus: true,
	    allowBlank: true,
	    autoload: true,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    valueField: 'vehicleNo',
	    displayField: 'vehicleNo',
	    multiSelect:true,
		beforeBlur: Ext.emptyFn,
   		listeners: {
        select:function(record, index) {
			 if(Ext.getCmp('RegcomboId').getValue()=='ALL'){
				 this.selectAll();
			      prevselect = true;
				this.selectAll();
			}else if(Ext.getCmp('RegcomboId').getValue()!='ALL' && prevselect == true){
				this.deselectAll(); 
				prevselect = false;				
			} else{
				var newHub=[];
				newReg =Ext.getCmp('RegcomboId').getValue().split(',');
				if(newReg[0]=='ALL'){ 
				prevselect = true;
				this.selectAll(); 
				}
				}
	     }
	     }
		});
	
	
   
     
    //********************************************************************Filter Config***************
       
    	var filters = new Ext.ux.grid.GridFilters({
        local: true,
    	filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    	}, {
        type: 'string',
        dataIndex: 'VehNoId'
    	},{
        type: 'string',
        dataIndex: 'GroupnameId'
    	}, {
    	type: 'string',
        dataIndex: 'VehTypeId'
    	}, {
    	type: 'string',
        dataIndex: 'VehId'
    	}, {
        type: 'string',
        dataIndex: 'NooftimesenteredId'
    	}, {
        type: 'string',
        dataIndex: 'NooftimeExitedId'
    	}, {
    	type: 'string',
        dataIndex: 'DurationenteredId'
    	}, {
    	type: 'string',
        dataIndex: 'DurationExitedId'
    	}, {
        type: 'string',
        dataIndex: 'averagedetentiontimeId'
    	}, {
        type: 'string',
        dataIndex: 'averagedetentionouttimeId'
    	}]
    	});
    	
    	
    	//***************************************************Filter Config Ends ***********************

    //*********************************************Column model config**********************************
    
    var createColModel = function (finish, start) {
        var columns = [
            new Ext.grid.RowNumberer({
        	header: "<span style=font-weight:bold;>SLNO</span>",
        	width: 50
    		}), {
        	dataIndex: 'slnoIndex',
        	hidden: true,
        	header: "<span style=font-weight:bold;><%=SLNOs%></span>",
        	filter: {
            type: 'numeric'
        	}
    		}, {
        	dataIndex: 'VehNoId',
        	header: "<span style=font-weight:bold;><%=VehNo%></span>",
        	// renderer: Ext.util.Format.dateRenderer('d-m-Y'),
        	width: 100,        	
        	filter: {
            type: 'String'
        	}
    		},{
    		header: "<span style=font-weight:bold;><%=Groupname%></span>",
    		dataIndex: 'GroupnameId',
    		width: 100,    
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},{
        	dataIndex: 'VehTypeId',
        	header: "<span style=font-weight:bold;><%=VehType%></span>",
        	// renderer: Ext.util.Format.dateRenderer('d-m-Y'),
        	width: 100,        	
        	filter: {
            type: 'String'
        	}
    		},{
    		header: "<span style=font-weight:bold;><%=VehId%></span>",
    		dataIndex: 'VehId',
    		width: 100,    		
    		filter: {
    		type: 'string'
    		}
    		},{
        	header: "<span style=font-weight:bold;><%=Nooftimesentered%></span>",
        	dataIndex: 'NooftimesenteredId',
        	width: 110,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=NooftimeExited%></span>",
        	dataIndex: 'NooftimeExitedId',
        	width: 110,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=Durationentered%></span>",
        	dataIndex: 'DurationenteredId',
        	width: 110,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=DurationExited%></span>",
        	dataIndex: 'DurationExitedId',
        	width: 110,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=averagedetentiontime%></span>",
        	dataIndex: 'averagedetentiontimeId',
        	width: 110,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=averagedetentiontime%></span>",
        	dataIndex: 'averagedetentionouttimeId',
        	width: 110,
        	hidden:true,
        	hideable:false,
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
    
    
     //*********************************************Column model config Ends***************************
   
    //******************************************Creating Grid By Passing Parameter***********************
   
    grid = getGrid('Hub Report', 'No Records Found', store, screen.width - 45, 385, 16, filters, 'Clear Filter Data', false, '', 14, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF');	
   	
		
	//**********************************End Of Creating Grid By Passing Parameter*************************	
        // ***********************   Pannel For Customer For Adding Trip Inforamtion**************************		
 
   			var customerPanel = new Ext.Panel({
   			 standardSubmit: true,
             collapsible: false,
             border: false,
             frame: false,
             width: '100%',
             cls: 'customerPannelcssnew',
             id: 'custMaster',
             layout: 'table',                 
    			layoutConfig: {
        		columns: 23
    			},
    			items: [ {
                xtype: 'radio',
                id: 'radioHubs',
                checked: true, 
                name: 'radioHub',
                listeners: {
                    check: function () {
                        if (this.checked) {                       
                        if(radioReg.checked){                                         
                         Ext.getCmp('radioReg').setValue(false);
                            }                     
                            prevselect = false;       
                        Ext.getCmp('Hublab').show();
						Ext.getCmp('HubcomboId').show();
						Ext.getCmp('Registrationlab').hide();
						Ext.getCmp('RegcomboId').hide();  						  
						Ext.getCmp('Grouplab').hide();
						Ext.getCmp('GrpcomboId').hide(); 
						Ext.getCmp('RegcomboId').reset();
						Ext.getCmp('GrpcomboId').reset();
						Ext.getCmp('HubcomboId').reset();
                        }
                    }
                }
            }, {
                xtype: 'label',
                text: '<%=ByHubs%>',
                cls: 'labelstyle',
                id : 'hubradiolabelid'
            },{width:10},{
                xtype: 'radio',
                id: 'radioReg',
                checked: false,
                name: 'radioReg',
                listeners: {
                    check: function () {
                        if (this.checked) {  
                        groupcombostore.load();                        
                            if(radioHubs.checked){
                              Ext.getCmp('radioHubs').setValue(false);
                            }
                            prevselect = false;
                        Ext.getCmp('Hublab').hide();
						Ext.getCmp('HubcomboId').hide();
						Ext.getCmp('Registrationlab').show();
						Ext.getCmp('RegcomboId').show();    
						Ext.getCmp('Grouplab').show();
						Ext.getCmp('GrpcomboId').show(); 
						Ext.getCmp('RegcomboId').reset();
						Ext.getCmp('GrpcomboId').reset();
						Ext.getCmp('HubcomboId').reset();
                        }
                    }
                }
            }, {
                xtype: 'label',
                text: '<%=ByRegs%>',
                cls: 'labelstyle',
                id:'beyregsradiolabelId'
            },{width: 10},{
            		xtype: 'label',
           		    text: '<%=selectHub%>' +' :',
            		cls: 'labelstyle',
            		hidden: false,
            		id: 'Hublab'
        			},
        			Hubnamecombo, {
                    width: 10
                },{
            		xtype: 'label',
           		    text: 'select Group' + ' :',
            		cls: 'labelstyle',
            		hidden: true,
            		id: 'Grouplab' 
        			},
        			Groupcombo, {
                    width: 10
                },{
            		xtype: 'label',
           		    text: '<%=selectRegistration%>' + ' :',
            		cls: 'labelstyle',
            		hidden: true,
            		id: 'Registrationlab' 
        			},
        			Regnonamecombo, {
                    width: 10
                } ,{
                    xtype: 'label',
                    text: '<%=startDates%>'+ ' :',
                    cls: 'labelstyle',
                    id:'startdatelabelId'
                },{
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               width: 175,
               format: getDateFormat(),
               allowBlank: false,
               id: 'startdate',
               value: nwdate,
                maxValue: dtprev,
               endDateField: 'enddate'
            },{width: 10},{
                    xtype: 'label',
                    text: '<%=endDates%> ' +' :',
                    cls: 'labelstyle',
                    id:'enddatelabelid'
                },{
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               width: 175,
               format: getDateFormat(),
               emptyText: '',
               allowBlank: false,
               blankText: '',
               id: 'enddate',
               value: dtprev,
               maxValue: dtprev,
               startDateField: 'startdate'
           },{width: 10}, {
		        xtype: 'button',
		        text: 'View',		        
		        cls: 'buttonstyle',	
		        id:'buttonId',	
		        listeners: {
		            click: {
		                fn: function() {
		                  if( Ext.getCmp('radioHubs').getValue()==true){
            	 HubsName = Ext.getCmp('HubcomboId').getValue();
            	 RegNo = "";
               
                }else if(  Ext.getCmp('radioReg').getValue()==true){
                 RegNo = Ext.getCmp('RegcomboId').getValue();
                 HubsName = "";
                }
                var startdate = Ext.getCmp('startdate').getValue();
                var enddate = Ext.getCmp('enddate').getValue();
  
                if (Ext.getCmp('RegcomboId').getValue() == "" && Ext.getCmp('HubcomboId').getValue() == "") {
                	Ext.example.msg('Select the value Hub/Registration no');                   
                    return;
                }

                if (Ext.getCmp('startdate').getValue() == "") {
                	Ext.example.msg('select Start Date');
                    Ext.getCmp('startdate').focus();
                    return;
                }
                if (Ext.getCmp('enddate').getValue() == "") {
                	Ext.example.msg('select end Date');
					Ext.getCmp('enddate').focus();
                    return;
                }
                 
                  if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                  		Ext.example.msg('EndDate Must Be Greater than StartDate');
                        Ext.getCmp('enddate').focus();
                           return;
                       }
                       
                       if(checkMonthValidation(Ext.getCmp('startdate').getValue(),Ext.getCmp('enddate').getValue()))
            		 	{
            		 		Ext.example.msg('Difference between two dates should not be greater than 30 days');
            		 		Ext.getCmp('enddate').focus(); 
               		    	return;
            		 	} 
            		 	 var dateDifrnc = new Date(Ext.getCmp('enddate').getValue()).add(Date.DAY, -30);
            		 	  if (Ext.getCmp('startdate').getValue() < dateDifrnc) {
                                                Ext.example.msg("Difference between two dates should not be greater than 30 days.");
                                                Ext.getCmp('startdate').focus();
                                                return;
                                            }

                store.load({
                    params: {
                        HubId: Ext.getCmp('HubcomboId').getValue(),
                        startdate: Ext.getCmp('startdate').getValue(),
                        enddate: Ext.getCmp('enddate').getValue(),
                        RegNo : Ext.getCmp('RegcomboId').getValue(), 
                        RegRad : Ext.getCmp('radioReg').getValue(),
                        HubRad : Ext.getCmp('radioHubs').getValue(),                        
                        jspName: jspName
                  }

               });

            }
		                }
		            }
		        }   				]
				});
           // ***********************    Main Starts From Here *********************************//		
   	
   	Ext.onReady(function () {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';

    outerPanel = new Ext.Panel({
        title: 'Hub Summary Report',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        cls: 'outerpanel',
        height:500,
        width:screen.width-20,
        items: [customerPanel,grid]
    });
 
     
});

	// ***********************    Main Ends Here *********************************//	
   		</script>
	<jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
	<!-- </html> -->
<%}%>