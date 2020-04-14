<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%> 
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
	session.setAttribute("loginInfoDetails",loginInfo);
}
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
int customeridlogged=loginInfo.getCustomerId();

ArrayList<String> tobeConverted=new ArrayList<String>();
tobeConverted.add("Fuel_Reports");
tobeConverted.add("Select_Customer");
tobeConverted.add("Customer_Name");
tobeConverted.add("Start_Date");
tobeConverted.add("Select_Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("Select_End_Date");
tobeConverted.add("Submit");
tobeConverted.add("SLNO");
tobeConverted.add("Registration_No");
tobeConverted.add("Group_Name");
tobeConverted.add("Select_Group_Name");
tobeConverted.add("Vehicle_Model");
tobeConverted.add("Tank_Capacity");
tobeConverted.add("Refuel_Date_Time");
tobeConverted.add("Refuel_L");
tobeConverted.add("Location");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Reconfigure_Grid");
tobeConverted.add("Clear_Grouping");
tobeConverted.add("Distance_Travelled_BW_Two_Refuels");
tobeConverted.add("Fuel_Consumed_BW_Two_Refuels");
tobeConverted.add("Mileage_BW_Two_Refuels");
tobeConverted.add("Excel");
ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
String fuelConsRep=convertedWords.get(0);
String SelectCustomer = convertedWords.get(1);
String CustomerName = convertedWords.get(2);
String StartDate = convertedWords.get(3);
String SelectStartDate = convertedWords.get(4);
String EndDate = convertedWords.get(5);
String SelectEndDate = convertedWords.get(6);
String Submit = convertedWords.get(7);
String SLNO = convertedWords.get(8);
String VehicleNo = convertedWords.get(9);
String grpName = convertedWords.get(10);
String selectGrp = convertedWords.get(11);
String VehicleModel = convertedWords.get(12);
String TankCapacity = convertedWords.get(13);
String RefuelDateTime = convertedWords.get(14);
String RefuelLiters = convertedWords.get(15);
String Location = convertedWords.get(16);
String NoRecordsFound = convertedWords.get(17);
String ClearFilterData = convertedWords.get(18);
String ReconfigureGrid = convertedWords.get(19);
String ClearGrouping = convertedWords.get(20);
String DistanceTravelledBWTowRefuels = convertedWords.get(21);
String FuelConsumed = convertedWords.get(22);
String Mileage = convertedWords.get(23);
String Excel = convertedWords.get(24);
%>

<jsp:include page="../Common/header.jsp" />
    <meta http-equiv="X-UA-Compatible" content="IE=11,IE=10,IE=9,IE=8" />
  <!-- </head> -->
   <!-- <body onload="refresh();">   -->           
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
   <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                              
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" />
   
  <%} %> 
  <jsp:include page="../Common/ExportJS.jsp" />    
<style>
	.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		label {
			display : inline !important;
		}
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		.x-layer ul {
		 	min-height:26px !important;
		}
		.selectstyle {
			width: 115px !important;
		}
		.x-menu-list {
			height:auto !important;
		}
</style>  
   <script>
    window.onload = function () { 
		refresh();
	}
 var outerPanel;
 var ctsb;
 var dtnext = datenext;   
 var dtcur = datecur;
 //for exporting to excel***** 
 var jspName="FDAR";
 var exportDataType="int,string,string,number,datetime,number,string,number,number,number";
 Ext.EventManager.onWindowResize(function () {
var width = '100%';
var height = '100%';
grid.setSize(width, height);
outerPanel.setSize(width, height);
outerPanel.doLayout();
});
  //In chrome activate was slow so refreshing the page
 function refresh()
                 {
                 isChrome = window.chrome;
					if(isChrome && parent.flagFdas<2) {
					// is chrome
						              setTimeout(function(){
						              parent.Ext.getCmp('FDARTab').enable();
									  parent.Ext.getCmp('FDARTab').show();
						              parent.Ext.getCmp('FDARTab').update("<iframe style='width:100%;height:200px;border:0;'src='<%=path%>/Jsps/FCIS/FuelConsolidatedReport.jsp?feature=1'></iframe>");
						              },0);
						              parent.fdasTab.doLayout();
						              parent.flagFdas= parent.flagFdas+1;
					} 
                 }

 //****store for getting customer name
  var customercombostore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
				   id:'CustomerStoreId',
			       root: 'CustomerRoot',
			       autoLoad: true,
			       remoteSort: true,
				   fields: ['CustId','CustName'],
				   listeners: {
    				load: function(store, records, success, options) {
        				 if(<%=customeridlogged%>>0){
				 			Ext.getCmp('custcomboId').setValue('<%=customeridlogged%>');
				 			 groupstore.load({
                                params: {
                                    CustId: Ext.getCmp('custcomboId').getValue()
                             
                                }
                            });
				 		  }
    				}
    				}
	});
//***** combo for customername
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
	    	cls:'selectstyle',
	    	listeners: {
		                   select: {
		                 	   fn:function(){
		                 	   var CustId=Ext.getCmp('custcomboId').getValue();
		                 	    groupstore.load({
                                params: {
                                    CustId: CustId 
                             
                                }
                            });
 								}
 								}
 								}
 								});
 								
	
	 //***************************************Group store*************************************
     		var groupstore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/UtilizationReportsAction.do?param=getAssetGroupExceptAll',
			id:'GroupNameStoreId',
			root: 'assetGroupRoot',
			autoLoad: false,
			remoteSort: true,
			fields: ['groupId', 'groupName']
	});
  //****************************************Combo for Vehicle******************************************	
            var groupcombo = new Ext.form.ComboBox({
                store: groupstore,
                id: 'groupcomboid',
                mode: 'local',
                forceSelection: true,
                emptyText: '<%=selectGrp%>',
                selectOnFocus: true,
                allowBlank: false,
                anyMatch: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                valueField: 'groupId',
                displayField: 'groupName',
                cls: 'selectstyle',
                listeners: {
                    select: {
                        fn: function () {}
                    }
                }
            });

 
 								
	//******************grid config starts********************************************************
		// **********************reader configs
	var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'fuelconsrepdata',
        totalProperty: 'total',
        fields: [
        {name: 'slnoIndex'},
         {
            name: 'VehicleNo'
        }, {
            name: 'VehicleModel'
        },{
            name: 'TankCapacity'
        }, {
            name: 'RefuelDateTime'
        }, 
        {
            name: 'RefuelLiters'
        }, {
            name: 'Location'
        }, {
            name: 'DistanceTravelled'
        }, {
            name: 'FuelConsumed'
        }, {
            name: 'Mileage'
        }
        ]
	});
	
	       //************************* store configs
var store =  new Ext.data.GroupingStore({
        autoLoad:false,
        proxy: new Ext.data.HttpProxy({
        url:'<%=request.getContextPath()%>/FuelConsolidatedReportAction.do?param=getFuelConsolidatedReportDetails',
        method: 'POST'
		}),
        remoteSort: false,
        sortInfo: {
            field: 'RefuelDateTime',
            direction: 'ASC'
        },
       // groupField:'VehicleNo',
       ftype:'multigrouping',
        groupers: ['VehicleNo', 'VehicleModel', 'TankCapacity'],
        storeId: 'darStore',
        reader:reader
    });
    store.on('beforeload',function(store, operation,eOpts){
        operation.params={
       	custId: Ext.getCmp('custcomboId').getValue(),
       	custName:Ext.getCmp('custcomboId').getRawValue(),
       	groupId:Ext.getCmp('groupcomboid').getValue(),
       	gname:Ext.getCmp('groupcomboid').getRawValue(),
        startDate: Ext.getCmp('startdate').getValue(),
        endDate:Ext.getCmp('enddate').getValue(),
        jspName:jspName
           };
	},this);
//**********************filter config
    var filters = new Ext.ux.grid.GridFilters({
    local:true,
        filters: [
        {type: 'numeric',dataIndex: 'slnoIndex'}, 
         {
        	type: 'string',
            dataIndex: 'VehicleNo'
        }, {
            type: 'string',
            dataIndex: 'VehicleModel'
        },{
            type: 'numeric',
            dataIndex: 'TankCapacity'
        }, {
            type: 'date',
            dataIndex: 'RefuelDateTime'
        }, 
        {
            type: 'numeric',
            dataIndex: 'RefuelLiters'
        }, {
            type: 'string',
            dataIndex: 'Location'
        }, {
        	type: 'numeric',
            dataIndex: 'DistanceTravelled'
        }, {
        	type: 'numeric',
            dataIndex: 'FuelConsumed'
        }, {
        	type: 'numeric',
            dataIndex: 'Mileage'
        }
        ]
    });    
    
    //**************column model config
    var createColModel = function (finish, start) {

        var columns = [
        new Ext.grid.RowNumberer({header: "<span style=font-weight:bold;><%=SLNO%></span>",width:50}),
        {
            dataIndex: 'slnoIndex',
            hidden:true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            filter:
            {
            	type: 'numeric'
			}
        },
         {
        	header: "<span style=font-weight:bold;><%=VehicleNo%></span>",
            dataIndex: 'VehicleNo',
            filter: {
            type: 'string'
            },
            width:40
        }, {
            header: "<span style=font-weight:bold;><%=VehicleModel%></span>",
            dataIndex: 'VehicleModel',
            filter: {
            type: 'string'
            },
            width:50
        },{
            header: "<span style=font-weight:bold;><%=TankCapacity%></span>",
            dataIndex: 'TankCapacity',
            filter: {
            type: 'numeric'
            },
             width:20
        }, {
            header: "<span style=font-weight:bold;><%=RefuelDateTime%></span>",
            dataIndex: 'RefuelDateTime',
            renderer: Ext.util.Format.dateRenderer('d/m/Y H:i:s'),
            filter: {
            type: 'date'
            },
            width:45
        }, 
        {
            header: "<span style=font-weight:bold;><%=RefuelLiters%></span>",
            dataIndex: 'RefuelLiters',
            filter: {
            type: 'numeric'
            },
            width:20
        },{
            header: "<span style=font-weight:bold;><%=Location%></span>",
            dataIndex: 'Location',
            filter: {
            type: 'string'
            },
            width:150
        },{
            header: "<span style=font-weight:bold;><%=DistanceTravelledBWTowRefuels%></span>",
            dataIndex: 'DistanceTravelled',
            filter: {
            type: 'numeric'
            },
            width:30
        },{
            header: "<span style=font-weight:bold;><%=FuelConsumed%></span>",
            dataIndex: 'FuelConsumed',
            filter: {
            type: 'numeric'
            },
            width:20
        },{
            header: "<span style=font-weight:bold;><%=Mileage%></span>",
            dataIndex: 'Mileage',
            filter: {
            type: 'numeric'
            },
            width:20
        }
        ];

        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };
    //gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr
    
    //**********************grid panel config
    var grid=getGrid('<%=fuelConsRep%>','<%=NoRecordsFound%>',store,screen.width-35,418,11,filters,'<%=ClearFilterData%>',true,'<%=ReconfigureGrid%>',11,true,'<%=ClearGrouping%>',false,'',true,'<%=Excel%>',jspName,exportDataType,false,'');

//******************grid config ends*******************

  //**********************inner panel start******************************************* 
  var innerPanel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		cls:'innerpanelsmaller',
		id:'FuelConsolodatedReport',
		layout:'table',
		layoutConfig: {
			columns:7
		},
		items: [{
				height:4
				},
				{width:20,height:4},{width:20,height:4},
				{
				height:4
				},
				{width:20,height:4},{width:20,height:4},{width:20,height:4},{
				xtype: 'label',
				text: '<%=CustomerName%>'+' :',
				cls:'labelstyle',
				id:'custnamelab'
				},
				custnamecombo,{width:20,height:4},
				{
				xtype: 'label',
				text: '<%=grpName%>'+':',
				cls:'labelstyle',
				id:'vehiclegrouplabid'
				},
				groupcombo,{width:20,height:4},{width:20,height:4},
				{
				xtype: 'label',
				cls:'labelstyle',
				id:'startdatelab',
				text: '<%=StartDate%>'+' :'
				},
				{
				xtype:'datefield',
	    		cls:'selectstyle',
	    		format:getDateFormat(),
	    		emptyText:'<%=SelectStartDate%>',
	    		allowBlank: false,
	    		blankText :'<%=SelectStartDate%>',
	    		id:'startdate',
	    		value:dtcur,
	    		maxValue:dtcur,
				vtype: 'daterange',
        		endDateField:'enddate'
	    		}
	    		,{width:20,height:4},
				{
				xtype: 'label',
				cls:'labelstyle',
				id:'enddatelab',
				text: '<%=EndDate%>'+' :'
				},
				{
				xtype:'datefield',
	    		cls:'selectstyle',
	    		format:getDateFormat(),
	    		emptyText:'<%=SelectEndDate%>',
	    		allowBlank: false,
	    		blankText :'<%=SelectEndDate%>',
	    		id:'enddate',
	    		value:dtnext,
	    		maxValue:dtnext,
				vtype: 'daterange',
        		startDateField:'startdate'
	    		},{width:20,height:4},
	    		{
       			xtype:'button',
      			text:'<%=Submit%>',
        		id:'addbuttonid',
        		cls:' ',
        		width:80,
       			listeners: {
        		click:{
       			 fn:function(){
       			 //Action for Button
   			 	if(Ext.getCmp('custcomboId').getValue() == "" )
			    {
		             Ext.example.msg("<%=SelectCustomer%>");
		             Ext.getCmp('custcomboId').focus();
                     return;
			    }
			    if(Ext.getCmp('groupcomboid').getValue() == "" )
			    {
		             Ext.example.msg("<%=selectGrp%>");
		             Ext.getCmp('groupcomboid').focus();
                     return;
			    }
			    if(Ext.getCmp('startdate').getValue() == "" )
			    {
		             Ext.example.msg("<%=SelectStartDate%>");
		             Ext.getCmp('startdate').focus();
                     return;
			    }
			    if(Ext.getCmp('enddate').getValue() == "" )
			    {
		             Ext.example.msg("<%=SelectEndDate%>");
		             Ext.getCmp('enddate').focus();
                     return;
			    }
       			store.load({
                        params: {
                            custId: Ext.getCmp('custcomboId').getValue(),
                            groupId:Ext.getCmp('groupcomboid').getValue(),
                            custName:Ext.getCmp('custcomboId').getRawValue(),
       						gname:Ext.getCmp('groupcomboid').getRawValue(),
                            startDate: Ext.getCmp('startdate').getValue(),
                            endDate:Ext.getCmp('enddate').getValue(),
                            jspName:jspName
                        }
                    });
       			}
       			}
       			}
       			}
       					]
		}); // End of Panel	
	  
//*****main starts from here*************************
 Ext.onReady(function(){
	ctsb=tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';		         	   			
 	outerPanel = new Ext.Panel({
			title:'<%=fuelConsRep%>',
			renderTo : 'content',
			standardSubmit: true,
			autoScroll:false,
			frame:true,
			layout:'fit',
			cls:'outerpanel',
			items: [innerPanel,grid]
			//bbar:ctsb			
			}); 
     	});		
	
  </script>
  <jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->
 
