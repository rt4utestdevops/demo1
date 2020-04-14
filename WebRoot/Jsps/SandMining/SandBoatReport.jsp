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
	if(str.length>11){
	loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
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
	int customerId = loginInfo.getCustomerId();
	
	String SLNO="SLNO";
	String ID="ID";
	String SandBoatRegNo="Sand BoatNo";
	String AlertDateTime="Alert DateTime";
	String AssociatedTPOwner="Associated TPOwner";
	String AssociatedParkingHub="Associated ParkingHub";
	String AssociatedLoadingHub="Associated LoadingHub";
	String DistanceFromParkingHub="Distance From ParkingHub";
	String DistanceFromloadingHub="Distance From LoadingHub";
	String StoppageDuration="Stoppage Duration";
	String MapView="MapView";
	String NoRecordsFound="No Records Found";
	String ClearFilterData="Clear Filter Data";
	String SandBoatReport="Sand Boat Report";
			
%>

<jsp:include page="../Common/header.jsp" />
        <title>
            <%=SandBoatReport%>
        </title>

    
    
    <div height="100%">
       <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
		<jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else{%>
		<jsp:include page="../Common/ImportJS.jsp" /><%}%>
         <!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
		<% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		<style>			
			label {
				display : inline !important;
			}			
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}						
			.x-menu-list {
				height:auto !important;
			}				
			.x-window-tl *.x-window-header {			
				padding-top : 6px !important;
				height : 38px !important;
			}			
			.x-panel-body-noborder  {
				height : 366px !important;
			}
		</style>
	 <%}%>
	 
	 <style>
		.x-panel-body-noborder  {
				height : 366px !important;
			}
	 </style>
        <script>
            var jspName = 'SandBoatReport';
            var dtcur = datecur;
       		var dtprev = dateprev;
       		var datenxt=datenext;
       		var startdatepassed;
       		var custId;
       		var enddatepassed;
            Ext.Ajax.timeout = 300000;
            var exportDataType = "int,string,string,string,string,string,number,number,string,string";
       
//-----------------*********client Store**********--------------------------------
    var clientcombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
    id: 'CustomerStoreId',
    root: 'CustomerRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['CustId', 'CustName'],
    listeners: {
        load: function(custstore, records, success, options) {
            if ( <%= customerId %> > 0) {
                Ext.getCmp('custcomboId').setValue('<%=customerId%>');
            }
        }
    }
});

var Client = new Ext.form.ComboBox({
    store: clientcombostore,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select Division',
    blankText: 'Select Division',
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
                custId = Ext.getCmp('custcomboId').getValue();
                custName=Ext.getCmp('custcomboId').getRawValue();
               
            }
        }
    }
});

          var customDatePanel = new Ext.Panel({
            frame: false,
            height:40,
            layout: 'table',
            layoutConfig: {
                columns:10
            },
           items: [{
	        			xtype: 'label',
						text: 'Client :',
						width : 90,
						cls: 'labelstyle'
				     },Client,{width:10},{width:10},{
	        			xtype: 'label',
						text: 'Start Date :',
						width : 90,
						cls: 'labelstyle'
				     },{
                        xtype: 'datefield',
                        cls: 'selectstylePerfect',
                        format: getDateFormat(),
                        id:'startdate',
                    //  disabled:true,
                        emptyText: 'Select Date',
                        value: dtprev,
                        maxValue: dtcur,
                        vtype: 'daterange',
                        endDateField: 'enddate',
                        listeners: {
              			select: function(  ){
                    		startdatepassed=Ext.getCmp('startdate').getValue()
                		}
            			}
                        
                    },{width:20},{
	        			xtype: 'label',
						text: 'End Date :',
						width : 90,
						cls: 'labelstyle'
				     },
                    {
                        xtype: 'datefield',
                        cls: 'selectstylePerfect',
                        format: getDateFormat(),
                        emptyText: 'Select Date',
                    //  disabled:true,
                        id: 'enddate',
                        value: dtcur,
                        maxValue: datenxt,
                        vtype: 'daterange',
                        startDateField: 'startdate',
                        listeners: {
              			select: function(  ){
                    		enddatepassed=Ext.getCmp('enddate').getValue()
                		}
            			}
                    },{width:25}
            ]
        });
        
            var submitButton = new Ext.Button({
            text: 'View',
            cls: 'sandreportbutton',
            handler: function ()
            {
                   startdatepassed=Ext.getCmp('startdate').getValue();
                   enddatepassed=Ext.getCmp('enddate').getValue();
                   custId = Ext.getCmp('custcomboId').getValue();
                   
                    if (Ext.getCmp('custcomboId').getValue() == "") {
                        Ext.example.msg("Select Division");
                        return;
                    }
                    if (Ext.getCmp('startdate').getValue() == "") {
                        Ext.example.msg("Select Start date");
                        return;
                    }
                    if (Ext.getCmp('enddate').getValue() == "") {
                        Ext.example.msg("Select end date");
                        return;
                    }
                   
					store.load({
							   params:{
							   jspName:jspName,
							   startdate:startdatepassed,
							   enddate:enddatepassed,
							   custId:custId
							   }
	            });
	           
            }
        });
        
            var buttonPanel = new Ext.Panel({
            frame: false,
            layout: 'column',
            layoutConfig: {
                columns: 2
            },
            items: [{width:100},submitButton]
        });
        
        
        var durartionPanel = new Ext.Panel({
            frame: false,
            height:40,
            layout: 'column',
    		layoutConfig: {
        				columns: 2
    		},
            items: [customDatePanel,buttonPanel]
        });

        var mainPanel = new Ext.Panel({
          title:'<%=SandBoatReport%>',
            frame: true,
            items: [durartionPanel]
        });
		

        //********************************* Reader Config***********************************
            var reader = new Ext.data.JsonReader({
                idProperty: 'gridrootid',
                root: 'SandBoatGridRoot',
                totalProperty: 'total',
                fields: [{
                        name: 'slnoIndex'
                    },{
                        name: 'IdDataIndex'
                    },{
                	    name: 'BoatNoDataIndex'
                	},{
                		name: 'AlertDateDataIndex',
                		type: 'date'
                	},{
                	    name: 'TpOwnerDataIndex'
                	},{
                        name: 'ParkinghubDataIndex'
                    },{
                        name: 'LoadinghubDataIndex'
                    },{
                        name: 'DistanceFromParkingDataIndex'
                    },{
                        name: 'DistanceFromLoadingDataIndex'
                    },{
                       name: 'StoppageDataIndex'
                    },{
                       name: 'MapDataIndex' 
                    }
                ]
            });
             //******************************** Grid Store*************************************** 
            var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getSandBoatReport',
                    method: 'POST'
                }),
                remoteSort: false,
                storeId: 'gridStore',
                reader: reader
            });
        
            var filters = new Ext.ux.grid.GridFilters({
                local: true,
                filters: [{
                        type: 'numeric',
                        dataIndex: 'slnoIndex'
                    },{
                        type: 'numeric',
                        dataIndex: 'IdDataIndex'
                    },{
                        type: 'string',
                        dataIndex: 'BoatNoDataIndex'
                    },{
                    	type: 'date',
                        dataIndex: 'AlertDateDataIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'TpOwnerDataIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'ParkinghubDataIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'LoadinghubDataIndex'
                    }, {
                        type: 'numeric',
                        dataIndex: 'DistanceFromParkingDataIndex'
                    }, {
                        type: 'numeric',
                        dataIndex: 'DistanceFromLoadingDataIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'StoppageDataIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'MapDataIndex' 
                    }
                    
                ]
            });
            
             //**************************** Grid Pannel Config ******************************************

            var createColModel = function (finish, start) {
                var columns = [
                    new Ext.grid.RowNumberer({
                        header: "<span style=font-weight:bold;><%=SLNO%></span>",
                        width: 40
                    }),{
                        dataIndex: 'slnoIndex',
                        hidden: true,
                        header: "<span style=font-weight:bold;><%=SLNO%></span>",
                        filter: {
                            type: 'numeric'
                        }
                    },{
                        dataIndex: 'IdDataIndex',
                        hidden: true,
                        header: "<span style=font-weight:bold;><%=ID%></span>",
                        filter: {
                            type: 'numeric'
                        }
                    },{
                        header: "<span style=font-weight:bold;><%=SandBoatRegNo%></span>",
                        dataIndex: 'BoatNoDataIndex',
                        //width:30,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=AlertDateTime%></span>",
                        dataIndex: 'AlertDateDataIndex',
                       renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                        filter: {
                            type: 'date'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=AssociatedTPOwner%></span>",
                        dataIndex: 'TpOwnerDataIndex',
                        //width:30,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=AssociatedParkingHub%></span>",
                        dataIndex: 'ParkinghubDataIndex',
                        //width:30,
                        filter: {
                            type: 'string'
                            }
                    }, {
                        header: "<span style=font-weight:bold;><%=AssociatedLoadingHub%></span>",
                        dataIndex: 'LoadinghubDataIndex',
                        //width:70,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=DistanceFromParkingHub%></span>",
                        dataIndex: 'DistanceFromParkingDataIndex',
                        //width:40,
                        filter: {
                            type: 'numeric'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=DistanceFromloadingHub%></span>",
                        dataIndex: 'DistanceFromLoadingDataIndex',
                         //width:40,
                       filter: {
                           type: 'numeric'
                       }
                    },{
                       header: "<span style=font-weight:bold;><%=StoppageDuration%></span>",
                       dataIndex: 'StoppageDataIndex',
                       //width:40,
                       filter: {
                           type: 'string'
                       }
                    },{
                       header: "<span style=font-weight:bold;><%=MapView%></span>",
                       dataIndex: 'MapDataIndex',
                       //width:40,
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
                        
             //**************************** Grid Panel Config ends here**********************************
            var userGrid = getGrid('<%=SandBoatReport%>', '<%=NoRecordsFound%>', store, screen.width - 25, 450, 20, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF');
            userGrid.on({
                cellclick: {
                    fn: function (userGrid, rowIndex, columnIndex, e) {
                    }
                }
            });
            function displayMap(boatno,id) 
           {
           var parameterStr="ID=" + id + "&SandBoatRegNo=" + boatno;
           window.open("<%=request.getContextPath()%>/Jsps/SandMining/BoatAlertMap.jsp?"+parameterStr, '_blank');
           } 
          //***************************  Main starts from here **************************************************
            Ext.onReady(function () {
                Ext.QuickTips.init();
                Ext.form.Field.prototype.msgTarget = 'side';
                outerPanel = new Ext.Panel({
                    renderTo: 'content',
                    standardSubmit: true,
		  			frame:false,
		  			border:true,
                    width : screen.width-22,
	        		height : 550,
					cls: 'mainpanelpercentage',
                    items: [ mainPanel,userGrid ]
                });
            });
    </script>
  </div>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->

