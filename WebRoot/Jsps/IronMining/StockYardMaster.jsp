
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
			 
			 tobeConverted.add("StockYard_Master");
			 tobeConverted.add("Organization_Code");
			 tobeConverted.add("Total_Fines");
			 tobeConverted.add("Total_Lumps");
			 tobeConverted.add("Total_Rejects");
			 tobeConverted.add("Total_Tailings");
			 tobeConverted.add("Total_UFO");
			 tobeConverted.add("Mineral_Name");
			 tobeConverted.add("Total_Quantity");
			 
ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

		    String SLNO = convertedWords.get(0);
		    String SelectCustomer = convertedWords.get(1);
		    String CustomerName = convertedWords.get(2);
		    String view=convertedWords.get(3);
			String NoRecordsfound= convertedWords.get(4);
			String ClearFilterData = convertedWords.get(5);
		    String Excel=convertedWords.get(6);
		    
		    String StockYardMaster=convertedWords.get(7);
		    String organizationCode=convertedWords.get(8);
		    String totalFines=convertedWords.get(9)+"(MT)";
		    String totalLumps=convertedWords.get(10)+"(MT)";
		    String totalRejects=convertedWords.get(11)+"(MT)";
		    String totalTailings=convertedWords.get(12)+"(MT)";
		    String totalUFO=convertedWords.get(13);
		    String MineralName=convertedWords.get(14);
		    String totalQty=convertedWords.get(15);
		    String jetty="Location Name";
		    String type="Type";
		    String totalConcentrates = "Total Concentrates (MT)";
		    int userId=loginInfo.getUserId(); 
		    String userAuthority=cf.getUserAuthority(systemId,userId);	
		    int isLtsp=loginInfo.getIsLtsp();
		    boolean auth=false;
		    if(isLtsp==0 && userAuthority.equalsIgnoreCase("Admin")){
				auth=true;
			}
   if(false)
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
	else{
		
%>

<jsp:include page="../Common/header.jsp" />
    <base href="<%=basePath%>">
    <title><%=StockYardMaster%></title>

  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
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
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
				height : 38px !important;
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
    //-------------------------------------------------------------------------------//
    var outerPanel;
    var jspName = "StockYard Master";
    var stockYardMasterGrid;
	var exportDataType = "int,int,string,string,string,string,string,number,number,number,number,number,number,number,number";
	var buttonValue;
	var dtcur = datecur;
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
                        //store.load();
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
      if (stockYardMasterGrid.getSelectionModel().getSelected() == null) {
          Ext.example.msg('No Records found');
          return;
      }
      if(stockYardMasterGrid.getSelectionModel().getCount()>1){
        Ext.example.msg("Select Single Row");
        return;
      }
      var selected=stockYardMasterGrid.getSelectionModel().getSelected();
      var orgId=selected.get('orgIdIndex');
      var hubId=selected.get('hubIdIndex');
      var mineralType=selected.get('MineralTypeIndex').replace(/\s/g, '');
      openPopWin("<%=basePath%>Jsps/IronMining/StockReconciliation.jsp?orgId="+orgId+"&hubId="+hubId+"&mineralType="+mineralType,'Stock Reconciliation Details',screen.width*0.98,screen.height*0.60);
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
        idProperty: 'StoctYartMasterRootId',
        root: 'StoctYartMasterRoot',
        totalProperty: 'total',
        fields: [ {
            name: 'slnoIndex'
        },{
            name: 'idIndex'
        },{
            name: 'JettyIndex'
        },{
            name: 'TypeIndex'
        }, {
            name: 'OrganizationCodeIndex'
        },{
            name: 'OrganizationNameIndex'
        },{
            name: 'MineralTypeIndex'
        }, {
            name: 'TotalFinesIndex'
        }, {
            name: 'TotalLumpsIndex'
        }, {
            name: 'TotalRejectsIndex'
        }, {
            name: 'TotalTailingsIndex'
        }, {
            name: 'TotalUFOIndex'
        }, {
        	name: 'TotalConcentratesIndex'
        }, {
            name: 'TotalQtyIndex'
        }, {
            name: 'romQtyIndex'
        }, {
            name: 'hubIdIndex'
        }, {
            name: 'orgIdIndex'
        }]
    });
    //-----------------------------------------------store---------------------------------------------------//
    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/StockYardMasterAction.do?param=getStockYardMasterDetails',
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
            dataIndex: 'idIndex',
            type: 'int'
        }, {
            dataIndex: 'JettyIndex',
            type: 'string'
        }, {
            dataIndex: 'TypeIndex',
            type: 'string'
        }, {
            dataIndex: 'OrganizationCodeIndex',
            type: 'string'
        }, {
            dataIndex: 'OrganizationNameIndex',
            type: 'string'
        }, {
            dataIndex: 'MineralTypeIndex',
            type: 'string'
        }, {
            dataIndex: 'TotalFinesIndex',
            type: 'numeric'
        }, {
            dataIndex: 'TotalLumpsIndex',
            type: 'numeric'
        }, {
            dataIndex: 'TotalRejectsIndex',
            type: 'numeric'
        }, {
            dataIndex: 'TotalTailingsIndex',
            type: 'numeric'
        }, {
            dataIndex: 'TotalUFOIndex',
            type: 'numeric'
        }, {
            dataIndex: 'TotalConcentratesIndex',
            type: 'numeric'
        }, {
            dataIndex: 'TotalQtyIndex',
            type: 'numeric'
        },{
            dataIndex: 'romQtyIndex',
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
                width: 50,
                hidden: true,
                header: "<span style=font-weight:bold;>SlNo</span>"
            }, {
                header: '<b>ID</b>',
                width: 50,
                dataIndex: 'idIndex',
                hidden:true
            }, {
                header: '<b><%=jetty%></b>',
                width: 150,
                dataIndex: 'JettyIndex'
            }, {
                header: '<b><%=type%></b>',
                width: 80,
                dataIndex: 'TypeIndex'
            }, {
                header: '<b><%=organizationCode%></b>',
                width: 100,
                dataIndex: 'OrganizationCodeIndex'
            },{
                header: '<b>Organization Name</b>',
                width: 100,
                dataIndex: 'OrganizationNameIndex'
            },{
                header: '<b><%=MineralName%></b>',
                width: 100,
                dataIndex: 'MineralTypeIndex'
            }, {
                header: '<b><%=totalFines%></b>',
                width: 80,
                align: 'right',
                dataIndex: 'TotalFinesIndex'
            }, {
                header: '<b><%=totalLumps%></b>',
                width: 80,
                align: 'right',
                dataIndex: 'TotalLumpsIndex'
            }, {
                header: '<b><%=totalRejects%></b>',
                width: 80,
                align: 'right',
                dataIndex: 'TotalRejectsIndex'
            }, {
                header: '<b><%=totalTailings%></b>',
                width: 80,
                align: 'right',
                dataIndex: 'TotalTailingsIndex'
            }, {
                header: '<b><%=totalUFO%></b>',
                width: 80,
                align: 'right',
                dataIndex: 'TotalUFOIndex'
            }, {
                header: '<b><%=totalConcentrates%></b>',
                width: 100,
                align: 'right',
                dataIndex: 'TotalConcentratesIndex'
            }, {
                header: '<b><%=totalQty%></b>',
                width: 80,
                align: 'right',
                dataIndex: 'TotalQtyIndex'
            },{
                header: '<b>ROM Qty</b>',
                width: 80,
                align: 'right',
                dataIndex: 'romQtyIndex'
            }        ];
        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };
    //---------------------------------------------------------grid-------------------------------------------//

	stockYardMasterGrid = getGrid('<%=StockYardMaster%>', '<%=NoRecordsfound%>', store, screen.width - 38, 400, 20, filters, '<%=ClearFilterData%>', false, '', 12, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, 'PDF',false,'Add','<%=auth%>','View Details',false,'',false,'',false,'Generate PDF');

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
        items: [stockYardMasterGrid]
       
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
        var cm =stockYardMasterGrid.getColumnModel();  
	    for (var j = 1; j < cm.getColumnCount(); j++) {
	    	if(j==2){
	    		cm.setColumnWidth(j,150);
	    	}else{
		         cm.setColumnWidth(j,130);
		    }
	    }
    });
    
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>
<%} %>
