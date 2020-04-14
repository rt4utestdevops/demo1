<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
String category = "VEHICLE";
int systemid=0;
int customerid=0;
int userid=0;
int CustIdPassed=0;
String list="";
String value="";
int ltsp=0;
LoginInfoBean loginInfo1=(LoginInfoBean)session.getAttribute("loginInfoDetails");
ltsp=loginInfo1.getIsLtsp();

String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if(request.getParameter("list")!=null){
	 list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	systemid=Integer.parseInt(str[0].trim());
	customerid=Integer.parseInt(str[1].trim());
	userid=Integer.parseInt(str[2].trim());
    if(request.getParameter("CustId")!=null){
	CustIdPassed=Integer.parseInt(request.getParameter("CustId").toString().trim());
    }
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
CommonFunctions cf=new CommonFunctions();
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}

else
{
session.setAttribute("loginInfoDetails",loginInfo);
    String language = loginInfo.getLanguage();
	ArrayList<String> tobeConverted = new ArrayList<String>();
 
  tobeConverted.add("SLNO");
  tobeConverted.add("Registration_No");
  tobeConverted.add("Asset_Model");
  tobeConverted.add("Asset_Type");
  tobeConverted.add("Select_Single_Row");
  tobeConverted.add("No_Rows_Selected");
  tobeConverted.add("Are_you_sure_you_want_to_delete");
  tobeConverted.add("No_Records_Found");
  tobeConverted.add("Select_Customer");
  tobeConverted.add("Asset_Document_Details");
  tobeConverted.add("Document_Upload");
  tobeConverted.add("Customer_Name");
  tobeConverted.add("View_Document");
  

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
 
String SLNO = convertedWords.get(0);
String vehicleNumber = convertedWords.get(1);
String AssetModel = convertedWords.get(2);
String AssetType = convertedWords.get(3);
String selectSingleRow = convertedWords.get(4);
String noRowsSelected = convertedWords.get(5);
String Areyousureyouwanttodelete = convertedWords.get(6);
String NoRecordsFound = convertedWords.get(7);
String selectCustomer=convertedWords.get(8);
String AssetDetails =convertedWords.get(9);
String DocumentUpload =convertedWords.get(10);
String CustomerName=convertedWords.get(11);
String documentView = convertedWords.get(12);
%>

<jsp:include page="../Common/header.jsp" />

		
		
    <base href="<%=basePath%>">

    <title>
        <%=AssetDetails%>
    </title>
    <style>
        .x-panel-tl {
            border-bottom: 0px solid !important;
        }
    </style>

    	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
		<jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" /><%} %>
		<style>
			label
			{	
				display : inline !important;
			}
			
			.x-window-tl *.x-window-header {
				height : 38px !important;
			}
			.selectstyle {
				height : 21px !important;
			}
			.x-layer ul {
				min-height:24px !important;
			}
		</style>
<script>

var globalCustomerID=parent.globalCustomerID;
 //************************************************Store for getting customer name**************************************************************
    var custmastcombostore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
        id: 'CustomerStoreId',
        root: 'CustomerRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['CustId', 'CustName','Status','ActivationStatus'],
        listeners: {
            load: function (custstore, records, success, options) {
                if ( <%= customerid %> > 0) {
                Ext.getCmp('custmastcomboId').setValue(<%=customerid%>);
                    store.load({
                        params: {
                            customerID:<%= customerid %>
                        }
                    });
                    
                }
                else if(<%= CustIdPassed %> > 0)
                {
                Ext.getCmp('custmastcomboId').setValue(<%=CustIdPassed%>);
                store.load({
                        params: {
                            customerID:<%= CustIdPassed %>
                        }
                    });
                    
                }
                else if(globalCustomerID!=0)
                {
                Ext.getCmp('custmastcomboId').setValue(globalCustomerID);
                store.load({
                        params: {
                            customerID:globalCustomerID
                        }
                    });
                    
                }
            }
        }
    });

//************************************************* Combo for Customer Name*****************************************************
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
                    parent.globalCustomerID=Ext.getCmp('custmastcomboId').getValue();
                    store.load({
                        params: {
                            customerID: Ext.getCmp('custmastcomboId').getValue()
                        }
                    });
                   
                }
            }
        }
    });


//***********************************************************Customer Panel Start************************************************************************ 
    var customerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        frame:false,
        cls: 'innerpanelsmallest',
        id: 'custMaster',
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [{
                xtype: 'label',
                text: '<%=CustomerName%>' + '  :',
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



/*******************resize window event function**********************/
Ext.EventManager.onWindowResize(function () {
    var width = '100%';
    var height = '100%';
    grid.setSize(width, height);
    outerPanel.setSize(width, height);
    outerPanel.doLayout();
});
var outerPanel;
var ctsb;
var jspName = "<%=AssetDetails%>";
var exportDataType = "string";
var selected;
var grid;
var buttonValue;
var dtprev = dateprev;
var dtcur = datecur;
var openfileuploadPage;
var viewuploadedimage;
var value;
var rgno;

function addRecord() {
     if (openfileuploadPage) {        
            openfileuploadPage.close();           
        }
          if(<%=ltsp%>!=0)
                {
                 ctsb.setStatus({
                            text: 'You are not authorised to do the following operation',
                            iconCls: '',
                            clear: true
                        });
                        return;
                }
        
       var selected = grid.getSelectionModel().getSelected();
        var value1=selected.get('assetNumber'); 
        openfileuploadPage = new Ext.Window({
            title: '<%=DocumentUpload%>',
            autoShow: false,
            constrain: false,
            constrainHeader: false,
            resizable: false,
            maximizable: false,
            buttonAlign: "center",
            width: 600,
            height: 250,
            plain: false,
            footer: true,
            closable: true,
            stateful: false,								
            html: "<iframe style='width:100%;height:100%' src='<%=request.getContextPath()%>/Jsps/DocumentManagement/DocumentUpload.jsp?category=<%=category%>&value="+value1+"&list=<%=list%>'></iframe>",
            scripts: true,
            shim: false
        });
        openfileuploadPage.show();

}

function modifyData() {
        if (viewuploadedimage) {        
            viewuploadedimage.close();           
        }
         var selected = grid.getSelectionModel().getSelected();
         var value1=selected.get('assetNumber'); 
        viewuploadedimage = new Ext.Window({
            title: '<%=documentView%>',
            autoShow: false,
            constrain: false,
            constrainHeader: false,
            resizable: false,
            maximizable: false,
            buttonAlign: "center",
            height:Ext.getBody().getViewSize().height-80,
    		width:Ext.getBody().getViewSize().width-100,
            plain: false,
            footer: true,
            closable: true,
            stateful: false,							      								  
            html: "<iframe style='width:100%;height:100%' src='<%=request.getContextPath()%>/Jsps/DocumentManagement/DocumentView.jsp?systemId=<%=systemid%>&custId="+Ext.getCmp('custmastcomboId').getValue()+"&category=<%=category%>&value="+value1+"&list=<%=list%>'></iframe>",
            scripts: true,
            shim: false	
        });
        viewuploadedimage.show();
        viewuploadedimage.setPosition(50, 50);
}

 var reader = new Ext.data.JsonReader({
        idProperty: 'assetgroupdetailid',
        root: 'AssetGroupRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'assetNumber'
        }, {
            name: 'assetModel'
        }, {
            name: 'assetType'
        }]
    });
//************************* store configs***************************//


 var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/AssetGroupAction.do?param=getAssetDocumentDetails',
            method: 'POST'
        }),
        remoteSort: false,
        sortInfo: {
            field: 'assetModel',
            direction: 'ASC'
        },
        storeId: 'assetgroupdetailid',
        reader: reader
        });
        store.on('beforeload', function (store, operation, eOpts) {
                operation.params = {
                    customerID: Ext.getCmp('custmastcomboId').getValue()
                };
            }, this);
            
 var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'string',
            dataIndex: 'assetNumber'
        }, {
            type: 'string',
            dataIndex: 'assetModel'
        }, {
            type: 'string',
            dataIndex: 'assetType'
        }]
    });


//****************column Model Config
var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 60
        }), {
            header: 'slnoIndex',
            hidden: true,
            hideable: false,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 20,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=vehicleNumber%></span>",
            hidden: false,
            //width: 100,
            //sortable: false,
            dataIndex: 'assetNumber',
            filter: {
                type: 'String'
            }
        }, {
            header: "<span style=font-weight:bold;><%=AssetModel%></span>",
            hidden: false,
            //width: 100,
           // sortable: true,
            dataIndex: 'assetModel',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=AssetType%></span>",
            hidden: false,
            width: 120,
            //sortable: true,
            dataIndex: 'assetType',
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

//********************************grid***************************//

grid = getGrid('', '<%=NoRecordsFound%>', store, screen.width - 60, 450, 20, filters,'', false, '', 20, false, '', false, '', false, '', jspName, exportDataType, false, '', true, '<%=DocumentUpload%>', true, '<%=documentView%>');

//*****main starts from here*************************************//
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.Ajax.timeout = 180000;
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=AssetDetails%>',
        renderTo: 'content',
        standardSubmit: true,
        autoScroll: false,
        frame: true,
        border: false,
        layout: 'table',
        cls: 'outerpanel',
        layoutConfig: {
            columns: 1
        },
        items: [customerPanel,grid],
        bbar: ctsb
    });
    store.load();
});
</script>
    
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>