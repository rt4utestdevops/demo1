<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>

<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
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
	
CommonFunctions cf=new CommonFunctions();
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
if(loginInfo!=null){
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
int customeridlogged=loginInfo.getCustomerId();
String seatingStructureId=cf.getLabelFromDB("Seating_Structure_Id",language);
String seatingStructure=cf.getLabelFromDB("Seating_Structure",language);
String structureName=cf.getLabelFromDB("Structure_Name",language); 
String noOfRows=cf.getLabelFromDB("No_Of_Rows",language);  
String leftWingSeats=cf.getLabelFromDB("Left_Wing_Seats",language); 
String rightWingSeats=cf.getLabelFromDB("Right_Wing_Seats",language); 
String lastRowSeats=cf.getLabelFromDB("Last_Row_Seats",language);  
String status=cf.getLabelFromDB("Status",language);
String selectCustomer=cf.getLabelFromDB("Select_Customer",language);
String customerName=cf.getLabelFromDB("Customer_Name",language);
String save=cf.getLabelFromDB("Save",language);
String cancel=cf.getLabelFromDB("Cancel",language);
String error=cf.getLabelFromDB("Error",language);
String noRowSelected=cf.getLabelFromDB("No_Rows_Selected",language);
String selectSingleRow=cf.getLabelFromDB("Select_Single_Row",language);
String slNo=cf.getLabelFromDB("SLNO",language);
String modify=cf.getLabelFromDB("Modify",language);
String modifySeatingStructure=cf.getLabelFromDB("Modify_Seating_Structure",language); 
String selectStatus=cf.getLabelFromDB("Select_Status",language);  
String structureInformtion=cf.getLabelFromDB("Structure_Information",language);  
 %>

<jsp:include page="../Common/header.jsp" />   
    
    <title>AssetSeatingStructure.jsp</title>

	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<link rel="stylesheet" type="text/css" href="../../Main/modules/PassengerBusTransportation/css/component.css" />
	<style type="text/css">
	
	.lowerDeck, .upperDeck {
  border: 1px solid #ccc;
  float: left;
  clear: both;
  margin: 10px 0;
  border-radius: 5px;
  background-color: #fff;
  width: 95%;
  height: 100%;
  margin-left: 333px;
}
.rotate {
-webkit-transform: rotate(-90deg) !Important;
 -moz-transform: rotate(-90deg) !Important;
-ms-transform: rotate(-90deg) !Important;
 -o-transform: rotate(-90deg) !Important;
 filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=3) !Important;
}
a {
    color: #337ab7;
    text-decoration: none;
}
input#custmastcomboId {
	height : 21px !important;
	width: 134px !important;
}
label
		{
			display : inline !important;
		}
	</style>
 
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
   <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                              
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" />
   <%} %> 
   <jsp:include page="../Common/ExportJS.jsp"/>
   <script src="../../Main/Js/jquery.min.js"></script> 
  <script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.5.1.min.js" type="text/javascript"></script>
   <script type="text/javascript">   
  var outerPanel;
    var ctsb;
    var jspName = "Seating Structure";
    var exportDataType = "numeric,numeric,string,numeric,numeric,numeric,numeric,string";
    var selected;
    var grid;
    var buttonValue;
    var assetgroupstate;
    var titel;
    var myWin;
   var structureID;
   var customerID;
var settings = {              
               seatWidth: 35,
               seatHeight: 25,
               seatCss: 'seating',
               blank:'blank',
               selectedSeatCss: 'bookedSeat',
               selectingSeatCss: 'selectedSeat'
           };
           
function CheckSession() {				
  						Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/SeatingStructureAction.do?param=checkSession',
                        method: 'POST',
                        success: function (response, options)
                        {
                        if(response.responseText=='InvalidSession')
                        {
                        window.location.href = "<%=request.getContextPath()%>/Jsps/Common/SessionDestroy.html";
                        }
                        },
                        failure: function ()
                        {
                        } 
                    });
            }
          
  var selectedSeatArray=[];
     Ext.override(Ext.grid.GridView, {
        afterRender: function () {
            this.mainBody.dom.innerHTML = this.renderRows();
            this.processRows(0, true);
            if (this.deferEmptyText !== true) {
                this.applyEmptyText();
            }
            this.fireEvent("viewready", this); //new event
        }
    }); 
   
   
    var statuscombostore= new Ext.data.SimpleStore({
	  id:'statuscombostoreId',
	  autoLoad: true,
	  fields: ['Name','Value'],
	  data: [['Active', 'Active'], ['Inactive', 'Inactive']]
	 });
   
   
   var statuscombo = new Ext.form.ComboBox({
        store: statuscombostore,
        id:'statuscomboId',
        mode: 'local',
        forceSelection: true,
        emptyText:'<%=selectStatus%>',
        blankText:'<%=selectStatus%>',
        selectOnFocus:true,
        allowBlank: false,
        anyMatch:true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
    	valueField: 'Value',
    	value:'Active',
    	displayField: 'Name',
    	cls:'selectstyle'   
    });
   
     var custmastcombostore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
        id: 'CustomerStoreId',
        root: 'CustomerRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['CustId', 'CustName'],
        listeners: {
            load: function (custstore, records, success, options) {
            CheckSession();
                if ( <%= customeridlogged %> > 0) {
                Ext.getCmp('custmastcomboId').setValue(<%=customeridlogged%>);
                customerID='<%=customeridlogged%>';
                    store.load({
                        params: {
                            customerID:<%= customeridlogged %>
                        }
                    });                   
                   
                }     
                    
            }
        }
    });
    
    var custnamecombo = new Ext.form.ComboBox({
        store: custmastcombostore,
        id: 'custmastcomboId',
        mode: 'local',
        hidden: false,
        resizable: false,
        forceSelection: true,
        emptyText: '<%=selectCustomer%>',
        blankText: '<%=selectCustomer%>',
        selectOnFocus: true,
        allowBlank: false,
        typeAhead: true,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'CustId',
        displayField: 'CustName',
        listWidth : 200,
        cls: 'selectstyle',
        listeners: {
            select: {
                fn: function () {
                	CheckSession();
                		customerID=Ext.getCmp('custmastcomboId').getValue();                    
                    store.load({
                        params: {
                            customerID: Ext.getCmp('custmastcomboId').getValue()
                        }
                    });                
                   
                }
            }
        }
    });  
      
      
       var innerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: false,
        height: 130,
        width: '100%',
        frame: true,
        id: 'custMaster',
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [
        		 {
		        xtype:'fieldset', 
				title:'<%=structureInformtion%>',
				cls:'fieldsetpanel',
				collapsible: false,
				colspan:1,
				id:'userpanelid',
				layout:'table',
				layoutConfig: {
					columns:3
				},
				items: [            
            {
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatorystructurenameid'
            }, 
			{
                xtype: 'label',
                text: '<%=structureName%>'+' :',
                cls: 'labelstyle',
                id: 'srtucturenametxt'
            }, {
                xtype: 'textfield',
                cls: 'textrnumberstyle',
                emptyText:'<%=structureName%>',               
                id: 'structurenameid',                 
		 		
            }, {
                xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'statusid'
            },{
                xtype: 'label',
                text: '<%=status%>'+' :',
                cls: 'labelstyle',
                id: 'statusnametxt'
            },statuscombo 
            
            ]}
        ]
    });
    
     var winButtonPanel = new Ext.Panel({
        id: 'winbuttonid',
        standardSubmit: true,
        collapsible: false,
        autoHeight: true,
        cls:'windowbuttonpanel',
        height: 50,
        width: '100%',
        frame: true,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        buttons:[{
            xtype: 'button',
            text: '<%=save%>',
            id: 'addButtId',
            iconCls:'savebutton',
            cls: 'buttonstyle',
            width: 70,
            listeners: {
                click: {
                    fn: function () {	
       					if (Ext.getCmp('statuscomboId').getValue() == "") {
       					    Ext.example.msg("<%=selectStatus%>");
           					Ext.getCmp('statuscomboId').focus();
           					return;
       						}     			
       						
			           //Ajax request starts here
			            outerPanelWindow.getEl().mask();			            
			            
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/SeatingStructureAction.do?param=saveormodifySeatingStructure',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,                                
                                status:Ext.getCmp('statuscomboId').getValue(),  
                                structureId:structureID,
                                customerID: customerID                              
                            },
                            success: function (response, options) {                               
								var message = response.responseText;								
                                 Ext.example.msg(message);                               
                                outerPanelWindow.getEl().unmask();  
                                myWin.hide();
								store.reload();
								$('#seatLayoutMain').css('display', 'none'); 
                            },
                            failure: function () {

                                Ext.example.msg("<%=error%>");                                
                                outerPanelWindow.getEl().unmask();  
                                myWin.hide();
                                store.reload();
								$('#seatLayoutMain').css('display', 'none'); 
                            }
                        });

                    }
                }
            }
        }, {
            xtype: 'button',
            text: '<%=cancel%>',
            id: 'canButtId',
            iconCls:'cancelbutton',
            cls: 'buttonstyle',
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
    
      var outerPanelWindow = new Ext.Panel({
        width: '100%',
        height:200,
        standardSubmit: true,
        frame: false,
        cls:'outerpanelwindow',
        items: [innerPanel, winButtonPanel]
    });
    
     myWin = new Ext.Window({
        title: titel,
        closable: false,
        resizable:false,
        modal: true,
        autoScroll: false,
        height: 250,
        width: '40%',
        id: 'myWin',
        items: [outerPanelWindow]
    });
    
     function modifyData() {
    if (Ext.getCmp('custmastcomboId').getValue() == "") {
                            Ext.example.msg("<%=selectCustomer%>");
           					Ext.getCmp('custmastcomboId').focus();
           					return;
       						}  
    if(grid.getSelectionModel().getCount()>1){
                            Ext.example.msg("<%=selectSingleRow%>");
           					return;
       						}    
    if (grid.getSelectionModel().getSelected() == null) {
                            Ext.example.msg("<%=noRowSelected%>");
           					Ext.getCmp('custmastcomboId').focus();
           					return;
       						}
       						
        buttonValue = "modify";     
          
        titel = '<%=modifySeatingStructure%>';
        myWin.setTitle(titel);     
         Ext.getCmp('statuscomboId').reset();
        var selected = grid.getSelectionModel().getSelected();
        myWin.show();
        Ext.getCmp('structurenameid').setValue(selected.get('structurenameIndex'));     
        Ext.getCmp('structurenameid').disable();
        Ext.getCmp('statuscomboId').setValue(selected.get('status'));   
        structureID=selected.get('structureidIndex');
       }
    
     var reader = new Ext.data.JsonReader({
        idProperty: 'structurestoreid',
        root: 'structureDetailsRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'structureidIndex'
        },{
            name: 'structurenameIndex'
        }, {
        	name:'status'
        }]
    });
    
      var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/SeatingStructureAction.do?param=getSeatingStructureDetails',
            method: 'POST'
        }),
        baseParams: {       
        customerID: customerID,
        jspName:jspName
    	},
        remoteSort: false,
        sortInfo: {
            field: 'structurenameIndex',
            direction: 'ASC'
        },
        storeId: 'structurestoreid',
        reader: reader
        });
    
     var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'string',
            dataIndex: 'slnoIndex'
        }, {
            type: 'string',
            dataIndex: 'structureidIndex'
        }, {
            type: 'string',
            dataIndex: 'structurenameIndex'
        }, {
            type: 'string',
            dataIndex: 'status'
        }]
    });
     
     var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=slNo%></span>",
                width: 50
            }), {
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;><%=slNo%></span>",
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=seatingStructureId%></span>",
                hidden: true,
                dataIndex: 'structureidIndex',               
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=structureName%></span>",
                dataIndex: 'structurenameIndex',               
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=status%></span>",
                dataIndex: 'status',
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
   
   
   grid = getSeatingStructureGrid('<%=seatingStructure%>', 'NoRecordsFound', store,screen.width-50,300, 17, filters, 'Clear Filter Data', false, '', 14, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'Pdf', false, 'Add', true, 'Modify', false, '');
   
    var customerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        frame:false,
        height:40,
        width:screen.width-50,        
        id: 'custMaster',
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [{
                xtype: 'label',
                text: '<%=customerName%>' + '  :',
                allowBlank: false,
                hidden: false,
                cls: 'labellargestyle',
                id: 'custnamhidlab'
            },
            custnamecombo, {
                cls: 'labellargestyle'
            }
        ]
    });
    
    
    
    function showSeatingStructure(grid1,rowIndex,columnIndex,e)
 	{ 	
 	CheckSession();
	var record = grid1.getStore().getAt(rowIndex);  // Get the Record	
	selectedSeatArray.length=0;
										$.ajax({
                                               url: "<%=request.getContextPath()%>/SeatingStructureAction.do?param=getSeatingStructure",
                                               type: 'POST',
                                               timeout: 360000,
                                               data: {
                                                  		customerID: customerID,
                                                        structureName: record.get('structurenameIndex')
                                                      },
                                               success: function(response, data) {  
                                                        seatingStructure(response);
                                               }
                               			});
	
	}
    
    function seatingStructure(seatingStructureDesign ){    			
   				 $('#seatLayoutMain').css('display', 'block'); 
    			$('#seatDeck').html(seatingStructureDesign);
    			if($("#seatDeck li").length==75){
    			var lastRow=$("#seatDeck li").length/6-1;    			
    			$("#left-content-id").width(settings.seatWidth*Math.round(lastRow)).height(Math.round(lastRow)*settings.seatHeight-165);
    			}else if($("#seatDeck li").length>22){    			
    			var lastRow=$("#seatDeck li").length/4-1;
    			$("#left-content-id").width(settings.seatWidth*Math.round(lastRow)-60).height(Math.round(lastRow)*settings.seatHeight-70);  
    			}else{
    			var lastRow=$("#seatDeck li").length/3-1;
    			$("#left-content-id").width(settings.seatWidth*Math.round(lastRow)).height(Math.round(lastRow)*settings.seatHeight);
    			}  
    }
    
   $(document).ready(function () {
      $('#tableID' ).remove();  
   });
   
   Ext.namespace('Ext.ux');
    Ext.onReady(function () {    	
        ctsb = tsb;
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            title: '',           
            width:screen.width-38,
            renderTo: 'panelId',
            standardSubmit: true,
            frame: false,
            border:false,                     
            items: [customerPanel, grid]
            //bbar: ctsb  
        });	        
			
    });
   </script>
   <div id="container">
   			<div id ="panelId"></div>
   			<div id="seatLayoutMain">
   				<div id="seatLayoutBox">
   					<div id="seat-container" class="seatlayoutContainer">   
   						<div class="clearfix">   
   							<div class="leftContent" id="left-content-id">
  								 <div class="seatLayoutHolder">
   									<div class="lowerDeck">   										
  										 <ul class="deck" id="seatDeck"></ul>
   									</div>
   								</div>
   							</div>
   						</div>
   					</div>
   				</div>
   			</div>
   </div>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>