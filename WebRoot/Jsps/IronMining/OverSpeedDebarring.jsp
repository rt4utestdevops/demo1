<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
    <%@page import="com.itextpdf.text.log.SysoLogger"%>
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
	LoginInfoBean loginInfo1=new LoginInfoBean();
		loginInfo1=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		if(loginInfo1!=null)
		{
		int isLtsp=loginInfo1.getIsLtsp();
		loginInfo.setIsLtsp(isLtsp);
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
	int userid = loginInfo.getUserId();
	
	String userAuthority=cf.getUserAuthority(systemId,userid);
	if(customerId > 0 && loginInfo.getIsLtsp()== -1 && !(userAuthority.equalsIgnoreCase("Admin")))
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}	
	String activeButton="false";
	if(loginInfo.getIsLtsp()== 0)
	    {
	        activeButton="true";
	    }

int CustIdfrom=0;
if(request.getParameter("CustId")!=null){
	CustIdfrom=Integer.parseInt(request.getParameter("CustId").toString().trim());
}
int UserIdfrom=0;
if(request.getParameter("UserId")!=null){
	UserIdfrom=Integer.parseInt(request.getParameter("UserId").toString().trim());
}

ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Select_Customer");
tobeConverted.add("Customer_Name");
tobeConverted.add("No_Records_Found");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SelectCustomer=convertedWords.get(0); 
String CustomerName=convertedWords.get(1); 
String NoRecordsfound=convertedWords.get(2); 
String PleaseselectAtleastOneToMakeActive = "Please Select Atleast One Row To Make Active.";
String Save = "Save";
String Cancel = "Cancel";
String Title = "Over Speed Debarring";
String SLNO = "SLNO";
String vehicleNo = "Vehicle Number";
String alertCount = "Alert Count";
String noOfDaysInactive = "No Of Days Inactive";
String inactiveUpto = "Inactive Till Date";
String remarks = "Remarks";
String enterRemarks = "Enter Remarks";
String status = "Status";
String updatedTime = "Updated Time";
String updatedBy = "Updated By";
%>
<jsp:include page="../Common/header.jsp" />
     <title></title>

 <style>
     .x-panel-tl {
         border-bottom: 0px solid !important;
     }
 </style>


     <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
         <jsp:include page="../Common/ImportJSSandMining.jsp" />
         <%}else {%>
             <jsp:include page="../Common/ImportJS.jsp" />
             <%} %>
<jsp:include page="../Common/ExportJS.jsp" />
 <% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		<style>
			.ext-strict .x-form-text {
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
			.x-menu-list {
				height:auto !important;
			}
		</style>
	<%}%>
<script>
var selected;
var jspName = "OverSpeedDebarring";
var exportDataType = "int,string,string,int,int,string,string,string,string,string,int";
var gridData = "";
var json = "";
                                
var clientcombostore = new Ext.data.JsonStore({
	url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
	id: 'CustomerStoreId',
	root: 'CustomerRoot',
	autoLoad: true,
	remoteSort: true,
	fields: ['CustId', 'CustName'],
	listeners: {
    load: function(custstore, records, success, options) {
        if (<%= customerId %> > 0) {
        		Ext.getCmp('custcomboId').setValue('<%=customerId%>');
				custId = Ext.getCmp('custcomboId').getValue();								                    
                }
            }
        }
    });

var Client = new Ext.form.ComboBox({
    store: clientcombostore,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectCustomer%>',
    blankText: '<%=SelectCustomer%>',
    resizable: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'CustId',
    displayField: 'CustName',
    cls: 'selectstylePerfect',
    
});

var comboPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'traderMaster',
    layout: 'table',
    frame: false,
    width: screen.width - 12,
    height: 40,
    layoutConfig: {
        columns: 9
    },
    items: [{
            xtype: 'label',
            text: '<%=CustomerName%>' + ' :',
            cls: 'labelstyle'
        },
        Client,
        {   width: 30
        }, {
            xtype: 'label',
            cls: 'labelstyle',
            id: 'startdatelab',
            width: 200,
            text: 'Date' + ' :'
        }, {
            width: 10
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            width: 120,
            format: getDateFormat(),
            emptyText: 'Select Start Date',
            allowBlank: false,
            blankText: 'Select Start Date',
            id: 'startdate',
            value: currentDate
        }, {
            width: 70
        }, {
		   xtype: 'button',
		   text: 'View',
		   id: 'generateReport',
		   cls: 'buttonwastemanagement',
		   width: 60,
		   listeners: {
		       click: {
		           fn: function() {
		               if (Ext.getCmp('custcomboId').getValue() == "") {
		                   Ext.example.msg("<%=SelectCustomer%>");
		                   Ext.getCmp('custcomboId').focus();
		                   return;
		 				  }
<!--		 				if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {-->
<!--                            Ext.example.msg("End date must be greater than Start date");-->
<!--                            Ext.getCmp('enddate').focus();-->
<!--                            return;-->
<!--                        }-->
                        var Startdates = Ext.getCmp('startdate').getValue();
                        var Enddates = Ext.getCmp('startdate').getValue();
<!--                        var dateDifrnc = new Date(Enddates).add(Date.DAY, -31);-->
<!--                        if (Startdates < dateDifrnc) {-->
<!--                            Ext.example.msg("Difference between two dates should not be  greater than 31 days.");-->
<!--                            Ext.getCmp('startdate').focus();-->
<!--                            return;-->
<!--                        } -->
		                Store.load({
		                    params: {
		                        CustId: Ext.getCmp('custcomboId').getValue(),
		                        custName: Ext.getCmp('custcomboId').getRawValue(),
		                        endDate: Ext.getCmp('startdate').getValue(),
						        startDate: Ext.getCmp('startdate').getValue(),
		                        jspName: jspName
		                    }
		                });
		            }
		        }
		    }
		}
        ]
  });

//***************************************************************************FIRST GRID***********************************************************************************//
var sm = new Ext.grid.CheckboxSelectionModel({
    checkOnly: true,
    listeners: {
    beforerowselect : function (sm, rowIndex, keep, rec) {
      var row=rowIndex;
      var rec = Store.getAt(row);
      var remarks = rec.data['remarksInd'];
      var status = rec.data['statusInd'];
        if ((remarks==null||remarks=="") && status=="Inactive"){
          return true;
        }else{ return false; }
    }   
  }
});

var cols = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer({
        header: "<span style=font-weight:bold;><%=SLNO%></span>",
        width: 40
    }), {
        dataIndex: 'slnoIndex',
        hidden: true,
        width: 50,
        header: "<span style=font-weight:bold;><%=SLNO%></span>"
    }, sm, {
        header: '<b><%=vehicleNo%></b>',
        width: 195,
        sortable: true,
        dataIndex: 'vehicleNoInd'
    }, {
        header: '<b><%=alertCount%></b>',
        width: 195,
        sortable: true,
        dataIndex: 'alertCountInd'
    }, {
        header: '<b><%=noOfDaysInactive%></b>',
        width: 190,
        sortable: true,
        dataIndex: 'noOfDaysInactiveInd'
    }, {
        header: '<b><%=inactiveUpto%></b>',
        renderer: Ext.util.Format.dateRenderer(getDateFormat()),
        width: 190,
        sortable: true,
        dataIndex: 'inactiveUptoInd',
        filter: {type: 'date'}
    }, {
        header: '<b><%=remarks%></b>',
        width: 220,
        sortable: true,
        hidden: false,
        dataIndex: 'remarksInd'
    }, {
        header: '<b><%=status%></b>',
        width: 190,
        sortable: true,
        dataIndex: 'statusInd'
    }, {
        header: '<b><%=updatedTime%></b>',
        renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
        filter: {type: 'date'},
        width: 190,
        sortable: true,
        hidden:false,
        dataIndex: 'updatedTimeInd'
    }, {
        header: '<b><%=updatedBy%></b>',
        width: 190,
        sortable: true,
        hidden:false,
        dataIndex: 'updatedByInd'
    }, {
        header: '<b>uid</b>',
        width: 50,
        sortable: true,
        hidden:true,
        dataIndex: 'uidInd'
    }
]);

var reader = new Ext.data.JsonReader({
    root: 'getOverSpeedDebarringDetailsRoot',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'vehicleNoInd',
        type: 'string'
    }, {
        name: 'alertCountInd',
        type: 'string'
    }, {
        name: 'noOfDaysInactiveInd',
    }, {
        name: 'inactiveUptoInd',
        type: 'date',
        dateFormat: getDateFormat()
    }, {
        name: 'remarksInd',
        type: 'string'
    }, {
        name: 'statusInd',
        type: 'string'
    }, {
        name: 'updatedTimeInd',
        type: 'date',
        dateFormat: getDateTimeFormat()
    }, {
        name: 'updatedByInd',
        type: 'string'
    }, {
        name: 'uidInd',
    }, {
    	name: 'enrollIdInd'
    }]
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        dataIndex: 'vehicleNoInd',
        type: 'string'
    }, {
        dataIndex: 'alertCountInd',
        type: 'string'
    }, {
        dataIndex: 'noOfDaysInactiveInd',
        type: 'int'
    }, {
        dataIndex: 'inactiveUptoInd',
        type: 'date'
    }, {
        dataIndex: 'remarksInd',
        type: 'string'
    }, {
        dataIndex: 'statusInd',
        type: 'string'
    }, {
        dataIndex: 'updatedTimeInd',
        type: 'date'
    }, {
        dataIndex: 'updatedByInd',
        type: 'string'
    }, {
        dataIndex: 'uidInd',
        type: 'int'
    }]
});

var Store = new Ext.data.Store({
    url: '<%=request.getContextPath()%>/OverSpeedDebarringAction.do?param=getOverSpeedDebarringDetails',
    bufferSize: 367,
    reader: reader,
    autoLoad: false,
    remoteSort: false
});


var innerWinDeatailsPanel = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 150,
    width: 450,
    frame: false,
    id: 'innerWinDeatailsPanelId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title:'Over Speed Remarks',
        cls: 'my-fieldset',
        collapsible: false,
        colspan: 4,
        id: 'MineralInfoId',
        width: 445,
        height:120,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'remarksManId'
        },{
            xtype: 'label',
            text: '<%=remarks%>' + ' :',
            cls: 'labelstylenew',
            id: 'remarlsLabelId'
        }, {
           	xtype: 'textarea',
            //cls: 'selectstylePerfect',
            stripCharsRe: /[,]/,
            width: 250,
            height:60,
            id: 'remarksId',
            allowBlank: true,
            blankText: '<%=enterRemarks%>',
            labelSeparator: '',
            listeners: { change: function(f,n,o){ //restrict 50
		    if(f.getValue().length> 50){ Ext.example.msg("Field reached it's Maximum Size"); 
			  f.setValue(n.substr(0,50)); f.focus(); }
			} },
           	}]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 445,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
	                if(Ext.getCmp('remarksId').getValue()==""){
	                	Ext.example.msg("<%=enterRemarks%>");
	                	Ext.getCmp('remarksId').focus();
	                	return;
	                }
                	var selected = grid.getSelectionModel().getSelected();
				    outerPanel.getEl().mask();
				    Ext.Ajax.request({
				        url: '<%=request.getContextPath()%>/OverSpeedDebarringAction.do?param=activeSelectedVehicles',
				        method: 'POST',
				        params: {
				            CustID: Ext.getCmp('custcomboId').getValue(),
				            gridData: json,
				            remarks:Ext.getCmp('remarksId').getValue()
				        },
				        success: function(response, options) {
				            var message = response.responseText;
				            Ext.example.msg(message);
				            outerPanel.getEl().unmask();
				            myWin.hide();
				            Store.load({
				                params: {
				                    CustId: Ext.getCmp('custcomboId').getValue(),
				                    custName: Ext.getCmp('custcomboId').getRawValue(),
				                    endDate: Ext.getCmp('startdate').getValue(),
						            startDate: Ext.getCmp('startdate').getValue(),
				                    jspName: jspName
				                }
				            });
				        },
				        failure: function() {
				            Ext.example.msg("Error");
				            Store.reload();
				            outerPanel.getEl().unmask();
				        }
				    });
				}    
            }
        }
    }, {
        xtype: 'button',
        text: '<%=Cancel%>',
        id: 'canButtId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                	outerPanel.getEl().unmask();
                    myWin.hide();
                }
            }
        }
    }]
});

var innerWinPanel = new Ext.Panel({
    width: 460,
    height: 210,
    standardSubmit: true,
    frame: true,
    items: [innerWinDeatailsPanel, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: 'Remarks Window',
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 260,
    width: 475,
    id: 'myWin',
    items: [innerWinPanel]
});

function getSelectionModelGrid(gridtitle,emptytext,store,width,height,colmodel,gridnoofcols,filters,sm){
	var grid = new Ext.grid.GridPanel({
    	title:gridtitle,
        border: false,
        height: getGridHeight(),
        autoScroll:true,
        store: store,
        id:'selectionmodelgrid',
        colModel: colmodel,
        frame: true,
	    loadMask: true,
		sm: sm,
		view: new Ext.grid.GridView({
	           nearLimit: gridnoofcols
	    }),
	    plugins: [filters],
	    bbar: new Ext.Toolbar({})
    });
	if(width>0){
		grid.setSize(width,height);
	}
	return grid;
}
function customFunction(){
	if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomer%>");
        return;
    }
    Ext.getCmp('remarksId').reset();
    gridData = "";
    json = "";
    var records = grid.getSelectionModel().getSelections();
    if (records == null || records == "") {
      Ext.example.msg('<%=PleaseselectAtleastOneToMakeActive%>');
      return;
    }
    for (var i = 0; i < records.length; i++) {
        var record1 = records[i];
        var row = grid.store.findExact('slnoIndex', record1.get('slnoIndex'));
        var store = grid.store.getAt(row);
        json = json + Ext.util.JSON.encode(store.data) + ',';
    }
    outerPanel.getEl().mask();
    myWin.show();
    
}
var grid = getSelectionModelGrid('<%=Title%>', '<%=NoRecordsfound%>', Store, screen.width - 40, 420, cols, 6, filters, sm);
	grid.getBottomToolbar().add([
      '->',
      {   text: '',
          iconCls : 'clearfilterbutton',
          handler: function () { grid.filters.clearFilters(); } 
      }]);
  if(<%=activeButton%>){
	grid.getBottomToolbar().add([
        '-',
        {   text: 'Active',
            iconCls : '',
            handler: function () {
        	customFunction();
            } 
        }]);
   }
    grid.getBottomToolbar().add([
		'-',                             
		{
		    text:'',
		    iconCls : 'excelbutton',
		    handler : function(){
			getordreport('xls','All',jspName,grid,exportDataType);
		    }    
		}]);    
var gridPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'FirstGridForNonAssociationId',
    layout: 'table',
    frame: false,
    //width: 480,
    //height: 480,
    items: [grid]
});

Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    //Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 22,
        //height: 610,
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [comboPanel, gridPanel]
    });
    sb = Ext.getCmp('form-statusbar');
});
</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->