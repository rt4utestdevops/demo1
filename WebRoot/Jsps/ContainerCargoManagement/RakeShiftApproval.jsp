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
	loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
	session.setAttribute("loginInfoDetails",loginInfo);
	
}
	
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();

ArrayList<String> tobeConverted = new ArrayList<String>();

tobeConverted.add("Modified_Date_Time");
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("SLNO");
tobeConverted.add("Id");
tobeConverted.add("Delete");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("Excel");



ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String ModifiedDateTime=convertedWords.get(0);
String Add=convertedWords.get(1);
String Modify=convertedWords.get(2);
String NoRecordsFound=convertedWords.get(3);
String ClearFilterData=convertedWords.get(4);
String SLNO=convertedWords.get(5);
String ID=convertedWords.get(6);
String Delete=convertedWords.get(7);
String NoRowsSelected=convertedWords.get(8);
String SelectSingleRow=convertedWords.get(9);
String Save=convertedWords.get(10);
String Cancel=convertedWords.get(11);
String Excel=convertedWords.get(12);


int userId=loginInfo.getUserId(); 

%>
<jsp:include page="../Common/header.jsp" />
 		<title>Rake Approval </title>		
    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
 
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<jsp:include page="../IronMining/css.jsp" />
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
	<jsp:include page="../IronMining/css.jsp" />
	<%}%>
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
		</style>
	 <%}%>	
   <script>
   
var outerPanel;
var ctsb;
var jspName = "Rake Approval";
var exportDataType = "";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var editedRows = "";
var globalClientId = "";
var globalBranchId="";
var branchComboStore= new Ext.data.JsonStore({
       url:'<%=request.getContextPath()%>/RakeShiftBookingAction.do?param=getBranchList',
                   id:'BranchStoreId',
                   root: 'BranchRoot',
                   autoLoad: true,
                   fields: ['BranchID','BranchName']
    });
     var branchcombo = new Ext.form.ComboBox({
        store: branchComboStore,
        id: 'branchcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Branch',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
   		valueField: 'BranchID',
        width: 170,
        displayField: 'BranchName',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
               	globalBranchId = Ext.getCmp('branchcomboId').getValue();
  				loadData();
                    }
                }
            }
    });
     
  function loadData(){
		                            ApprovalStore.load({
                                params: {
                               		Branch: globalBranchId                                 
                               }
                          }); 
	}   


//for approving
function addRecord() {
	if (Grid.getSelectionModel().getCount() == 0) {
           Ext.example.msg("No row selected");
           return;
       }
     buttonValue = 'Approve';  
     var json = '';
     var record = Grid.getSelectionModel().getSelections();
    	for (var i = 0, len = record.length; i < len; i++) {
        var row = record[i];
    
        json += Ext.util.JSON.encode(row.data) + ',';
    }
    if (json != '') {
        json = json.substring(0, json.length - 1);
    }
    Ext.MessageBox.confirm('Confirm', "Please make sure that all the records which are marked will be approved. Continue...?", function(btn) {
    	if (btn == 'yes') {
    	outerPanel.getEl().mask();
    	Ext.Ajax.request({
	             url: '<%=request.getContextPath()%>/RakeShiftBookingAction.do?param=approveOrCancleDetails',
	             method: 'POST',
	             params: {
	                 jsonData: json,
	                 buttonValue:buttonValue
	             },
	             success: function(response, options){             
                     var message = response.responseText;
                     Ext.example.msg(message);
                     json = '';
                     ApprovalStore.reload();
                     outerPanel.getEl().unmask();
	              }, 
	              failure: function(){
	                     ApprovalStore.reload();
                         outerPanel.getEl().unmask();
                         json = '';
	                 } // END OF FAILURE 
	         });
     }
    });
}
//for cancelling 
function deleteData() {
	if (Grid.getSelectionModel().getCount() == 0) {
           Ext.example.msg("No row selected");
           return;
       }
     buttonValue = 'Cancle';  
     var json = '';
     var record = Grid.getSelectionModel().getSelections();
    	for (var i = 0, len = record.length; i < len; i++) {
        var row = record[i];
    
        json += Ext.util.JSON.encode(row.data) + ',';
    }
    if (json != '') {
        json = json.substring(0, json.length - 1);
    }
    Ext.MessageBox.confirm('Confirm', "Please make sure that all the records which are marked will be Cancelled. Continue...?", function(btn) {
    	if (btn == 'yes') {
    	outerPanel.getEl().mask();
    	Ext.Ajax.request({
	             url: '<%=request.getContextPath()%>/RakeShiftBookingAction.do?param=approveOrCancleDetails',
	             method: 'POST',
	             params: {
	                 jsonData: json,
	                 buttonValue:buttonValue
	             },
	             success: function(response, options){             
                     var message = response.responseText;
                     Ext.example.msg(message);
                     json = '';
                     ApprovalStore.reload();
                     outerPanel.getEl().unmask();
	              }, 
	              failure: function(){
	                     ApprovalStore.reload();
                         outerPanel.getEl().unmask();
                         json = '';
	                 } // END OF FAILURE 
	         });
     }
    });
}
		//============================ Grid table creation ================================
		//********** reader *************
     	var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'ApprovalRoot',
        totalProperty: 'total',
        fields: [{
        	name: 'slnoIndex'
        },{ 
        	name: 'uidIndex'
        },{ 
        	name: 'bookingNoIndex'
        },{
            name: 'bookingDateIndex',
            type: 'date',
  		    dateFormat: getDateTimeFormat()
        }, {
            name: 'containerNoIndex'
        }, {
            name: 'sizeIndex'
        }, {
            name: 'loadTypeIndex'
        }, {
            name: 'locationIndex'
        }, {
            name: 'shipperNameIndex'
        }, {
            name: 'billingCustomerIndex'
        }, {
            name: 'weightIndex'
        }, {
            name: 'sbblNoIndex'
        }]
    });
		//********** store *****************
		var ApprovalStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
           	url: '<%=request.getContextPath()%>/RakeShiftBookingAction.do?param=getApprovalData',
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
        }, {
            type: 'numeric',
            dataIndex: 'uidIndex'
        },{
            type: 'numeric',
            dataIndex: 'bookingNoIndex'
        },{
            type: 'date',
            dataIndex: 'bookingDateIndex'
        }, {
            type: 'string',
            dataIndex: 'containerNoIndex'
        }, {
            type: 'string',
            dataIndex: 'sizeIndex'
        }, {
            type: 'string',
            dataIndex: 'loadTypeIndex'
        }, {
            type: 'string',
            dataIndex: 'locationIndex'
        }, {
            type: 'string',
            dataIndex: 'shipperNameIndex'
        }, {
            type: 'string',
            dataIndex: 'billingCustomerIndex'
        }, {
            type: 'numeric',
            dataIndex: 'weightIndex'
        }, {
            type: 'string',
            dataIndex: 'sbblNoIndex'
        }]
      });
		
		//************************************Column Model Config******************************************
    	var sm = new Ext.grid.CheckboxSelectionModel();
    	var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                width: 50
            }),sm,{
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;>UID</span>",
                dataIndex: 'uidIndex',
                hidden: true,
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;>Booking No</span>",
                dataIndex: 'bookingNoIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            }, {
        		header: "<span style=font-weight:bold;>Booking Date</span>",
           	 	dataIndex: 'bookingDateIndex',
            	renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            	filter: {
            	type: 'date'
            	}
        	}, {
                header: "<span style=font-weight:bold;>Container No</span>",
                dataIndex: 'containerNoIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Size</span>",
                dataIndex: 'sizeIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Load Type</span>",
                dataIndex: 'loadTypeIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Location</span>",
                dataIndex: 'locationIndex',
                width: 100,
                filter: {
                    type: 'String'
                }
            }, {
                header: "<span style=font-weight:bold;>Shipper Name</span>",
                dataIndex: 'shipperNameIndex',
                filter: {
                    type: 'String'
                }
            }, {
                header: "<span style=font-weight:bold;>Billing Customer</span>",
                dataIndex: 'billingCustomerIndex',
                filter: {
                    type: 'String'
                }
            }, {
                header: "<span style=font-weight:bold;>Weight</span>",
                dataIndex: 'weightIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>SB / BL Number</span>",
                dataIndex: 'sbblNoIndex',
                width: 100,
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
	//***************** getGrid1 ****************************	
	Grid = getSelectionModelEditorGridCashVan('', '<%=NoRecordsFound%>', ApprovalStore, screen.width - 35, 450, 15, filters, '<%=ClearFilterData%>', false, '', 15, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', true, 'Approve', false, 'Modify', true, 'Cancle', sm);
 	
 	var clientPanel = new Ext.Panel({
            standardView: true,
            collapsible: false,
            id: 'clientPanelId',
            layout: 'table',
            frame: true,
            width: screen.width - 40,
            height: 40,
            layoutConfig: {
                columns: 5
            },
            items: [{
                xtype: 'label',
                cls: 'labelstyle',
                id: 'BranchID',
                text: 'Branch Name' + ' :',
                style: 'vertical-align: -webkit-baseline-middle'               
            },
            branchcombo
             
            ]
        });

Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'Rake Shift Approval',
        id:'outerPanelId',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 22,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [clientPanel,Grid]
    });
    ApprovalStore.load();
});

</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>