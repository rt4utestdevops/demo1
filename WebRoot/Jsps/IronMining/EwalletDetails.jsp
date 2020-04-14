
<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="UTF-8"%>
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
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
			response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		     
		ArrayList<String> tobeConverted = new ArrayList<String>();
		tobeConverted.add("SLNO");
		tobeConverted.add("Select_Customer");
		tobeConverted.add("Customer_Name");
		tobeConverted.add("View");
		tobeConverted.add("No_Records_Found");
		tobeConverted.add("Clear_Filter_Data");
		tobeConverted.add("Excel");
		 
		ArrayList<String> convertedWords = new ArrayList<String>();
		convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
	
	    String SLNO = convertedWords.get(0);
	    String SelectCustomer = convertedWords.get(1);
	    String CustomerName = convertedWords.get(2);
	    String view=convertedWords.get(3);
		String NoRecordsfound= convertedWords.get(4);
		String ClearFilterData = convertedWords.get(5);
	    String Excel=convertedWords.get(6);
		    
		    int userId=loginInfo.getUserId(); 
		    String userAuthority=cf.getUserAuthority(systemId,userId);	
   if(customerId > 0 && loginInfo.getIsLtsp()== -1 && !(userAuthority.equalsIgnoreCase("Admin") || userAuthority.equalsIgnoreCase("Supervisor")))
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}else{
		
%>

<jsp:include page="../Common/header.jsp" />
    <base href="<%=basePath%>">
    <title>E-Wallet Details</title>
 
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
				min-height: 27px !important;
			}			
		</style>
 <script>
    //-------------------------------------------------------------------------------//
    var outerPanel;
    var jspName = "Ewallet Details";
    var ewalletDetailsGrid;
	var exportDataType = "int,string,string,string,string,number,number";
	var buttonValue;
    //----------------------------------customer store---------------------------// 
    var customercombostore = new Ext.data.JsonStore({
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
                    custId = Ext.getCmp('custcomboId').getValue();
                    custName = Ext.getCmp('custcomboId').getRawValue();
                }
            }
        }
    });
    //******************************************************************customer Combo******************************************//
    var custnamecombo = new Ext.form.ComboBox({
        store: customercombostore,
        id: 'custcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectCustomer%>',
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
        listeners: {
            select: {
                fn: function() {
                    custId = Ext.getCmp('custcomboId').getValue();
                    custName = Ext.getCmp('custcomboId').getRawValue();
                    }
                }
            }
    });

    //-------------------------------------------------------------------------------------------------------//
    var clientPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: '',
        layout: 'table',
        frame: true,
        width: screen.width - 20,
        height: 75,
        layoutConfig: {
            columns: 5
        },
        items: [{
                xtype: 'label',
                text: '<%=CustomerName%>' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
            },{
                width: 30
            },custnamecombo,
             {
                width: 50
            },{
                xtype: 'button',
                text: '<%=view%>',
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
                           var custName=Ext.getCmp('custcomboId').getRawValue();
                            store.load({
		                        params: {
		                            CustId: custId,
		                            custName: custName,
		                            jspName:jspName
		                        }
		                    });
                        }
                    }
                }
            }
        ]
    });
    function modifyData(){
      if (ewalletDetailsGrid.getSelectionModel().getSelected() == null) {
          Ext.example.msg('No Records found');
          return;
      }
      if(ewalletDetailsGrid.getSelectionModel().getCount()>1){
        Ext.example.msg("Select Single Row");
        return;
      }
      var selected=ewalletDetailsGrid.getSelectionModel().getSelected();
      var orgId=selected.get('orgIdIndex');
      var orgName=selected.get('orgNameIndex');
      openPopWin("<%=basePath%>Jsps/IronMining/WalletReconciliationDetails.jsp?orgId="+orgId+"&orgName="+orgName,'Reconciliation Details',screen.width*0.98,screen.height*0.60);
    }
    
    function openPopWin(url,title,width,height)
	{
		popWin = new Ext.Window({
		title: title,
		autoShow : false,
		constrain : false,
		constrainHeader : false,
		resizable : false,
		maximizable : true,
		minimizable : false,
		width:width,
	    height:height,
		closable : true,
		stateful : false,
		html : "<iframe style='width:100%;height:100%' src="+url+"></iframe>",
		scripts:true,
		shim : false
		});
		popWin.setPosition(10, 50);
		popWin.show();
	}
    //---------------------------------------------------Reader-------------------------------------------------------//
    var reader = new Ext.data.JsonReader({
        idProperty: 'ewalletDetailsId',
        root: 'ewalletDetailsRoot',
        totalProperty: 'total',
        fields: [ {
            name: 'slnoIndex'
        },{
            name: 'orgNameIndex'
        },{
            name: 'orgCodeIndex'
        },{
            name: 'orgIdIndex'
        },{
            name: 'TypeIndex'
        },{
            name: 'eWalletIndex'
        },{
            name: 'mWalletIndex'
        }]
    });
    //-----------------------------------------------store---------------------------------------------------//
    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/MiningReportsAction.do?param=getEwalletDetails',
            method: 'POST'
        }),
        remoteSort: false,
        sortInfo: {
            field: 'slnoIndex',
            direction: 'ASC'
        },
        bufferSize: 700,
        reader: reader
    });
    //------------------------------------------Filters--------------------------------------------------------//
    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [  {
            dataIndex: 'slnoIndex',
            type: 'numeric'
        }, {
            dataIndex: 'orgNameIndex',
            type: 'string'
        }, {
            dataIndex: 'orgCodeIndex',
            type: 'string'
        }, {
            dataIndex: 'orgIdIndex',
            type: 'int'
        }, {
            dataIndex: 'TypeIndex',
            type: 'string'
        }, {
            dataIndex: 'eWalletIndex',
            type: 'numeric'
        }, {
            dataIndex: 'mWalletIndex',
            type: 'numeric'
        }]
    });
    //--------------------------------------------------column Model---------------------------------------//
    var createColModel = function(finish, start) {
        var columns = [
             new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                width: 50
            }), {
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;>SlNo</span>"
            }, {
                header: '<b>Organization Name</b>',
                dataIndex: 'orgNameIndex'
            }, {
                header: '<b>Organization Code</b>',
                dataIndex: 'orgCodeIndex'
            }, {
                header: '<b>ID</b>',
                dataIndex: 'orgIdIndex',
                hidden:true
            },{
                header: '<b>Type</b>',
                dataIndex: 'TypeIndex'
            }, {
                header: '<b>E-Wallet Balance</b>',
                align: 'right',
                dataIndex: 'eWalletIndex'
            }, {
                header: '<b>M-Wallet Balance</b>',
                align: 'right',
                dataIndex: 'mWalletIndex'
            }];
        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };
    //---------------------------------------------------------grid-------------------------------------------//

	ewalletDetailsGrid = getGrid('E-Wallet Details', '<%=NoRecordsfound%>', store, screen.width - 40, 400, 12, filters, '<%=ClearFilterData%>', false, '', 12, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, 'PDF',false,'Add',true,'View Details',false,'',false,'',false,'Generate PDF');

    //--------------------------------------------------------------------------------------------------------//

    var mainPanel = new Ext.Panel({
        standardSubmit: true,
        frame: true,
        width: screen.width - 30,
        height: 420,
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [ewalletDetailsGrid]
       
    });

    Ext.onReady(function() {
        outerPanel = new Ext.Panel({
            renderTo: 'content',
            standardSubmit: true,
            autoScroll: false,
            frame: true,
            border: false,
            id: 'outer',
            layout: 'table',
            width: screen.width-22,
            height: screen.height-220,
            cls: 'outerpanel',
            layoutConfig: {
                columns: 1
            },
            items: [clientPanel, mainPanel]
        });
         var cm =ewalletDetailsGrid.getColumnModel();  
	    for (var j = 1; j < cm.getColumnCount(); j++) {
	       cm.setColumnWidth(j,249);
	    }
    });
    
</script>
  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>
<%} %>
