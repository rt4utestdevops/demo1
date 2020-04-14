<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
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
		if(str.length>11){
		loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
		}
			session.setAttribute("loginInfoDetails", loginInfo);
		}
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		
int userId=loginInfo.getUserId(); 
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();

String userAuthority=cf.getUserAuthority(systemId,userId);	

if(customerId > 0 && loginInfo.getIsLtsp()== -1 && !userAuthority.equalsIgnoreCase("Admin"))
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
	else{

%>

<!DOCTYPE HTML>
<html>
	<head>
		<base href="<%=basePath%>">
		<title>Mining TripSheet Generation For Truck</title>
	</head>
	<body>
	 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
	   <jsp:include page="../IronMining/css.jsp" />
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<jsp:include page="../IronMining/css.jsp" />
		<%} %>
		 <jsp:include page="../Common/ExportJS.jsp" />
 <script>
  var outerPanel;
  var jspName = 'BargeTruckTripSheet';
  var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,number,number,number,number,string,string,string";
  var grid;
  var selected;
  //-------------------------------------------------- Truck Trip Sheet Configuration---------------------------------------//
         var reader = new Ext.data.JsonReader({
            idProperty: 'tripcreationId3',
            root: 'miningTripSheetDetailsRoot',
            totalProperty: 'total',
            fields: [{
                name: 'slnoIndex'
            }, {
                name: 'TypeIndex'
            }, {
                name: 'TripSheetNumberIndex'
            }, {
                name: 'assetNoIndex'
            }, {
                name: 'tcLeaseNoIndex'
            }, {
                name: 'validityDateDataIndex',
                type: 'date',
                dateFormat: getDateTimeFormat()
            }, {
                name: 'gradeAndMineralIndex'
            }, {
                name: 'RouteIndex'
            }, {
                name: 'uniqueIDIndex'
            }, {
                name: 'tcLeaseNoIndexId'
            }, {
                name: 'orgNameIndex'
            }, {
                name: 'gradeAndMineralIndexId'
            }, {
                name: 'RouteIndexId'
            }, {
                name: 'statusIndexId'
            }, {
                name: 'q1IndexId'
            }, {
                name: 'QuantityIndex'
            }, {
                name: 'netIndexId'
            }, {
                name: 'actualQtyIndexId'
            }, {
                name: 'permitIndexId'
            }, {
                name: 'issuedIndexId'
            },{
            	name: 'shipNameIndexId'
            },{
            	name: 'commStatusIndexId'
            }]
        });
        var store = new Ext.data.GroupingStore({
            autoLoad: false,
            proxy: new Ext.data.HttpProxy({
                url: '<%=request.getContextPath()%>/PermitWiseTripSheets.do?param=getTruckTripSheetDetails',
                method: 'POST'
            }),
            remoteSort: false,
            storeId: 'miningTripsheetDetailsStore3',
            reader: reader
        });
        var filters = new Ext.ux.grid.GridFilters({
            local: true,
            filters: [{
                type: 'numeric',
                dataIndex: 'slnoIndex'
            }, {
                type: 'string',
                dataIndex: 'TypeIndex'
            }, {
                type: 'string',
                dataIndex: 'TripSheetNumberIndex'
            }, {
                type: 'string',
                dataIndex: 'assetNoIndex'
            }, {
                type: 'string',
                dataIndex: 'tcLeaseNoIndex'
            }, {
                type: 'string',
                dataIndex: 'orgNameIndex'
            }, {
                type: 'date',
                dataIndex: 'validityDateDataIndex'
            }, {
                type: 'string',
                dataIndex: 'gradeAndMineralIndex'
            }, {
                type: 'string',
                dataIndex: 'RouteIndex'
            }, {
                type: 'string',
                dataIndex: 'statusIndexId'
            }, {
                type: 'int',
                dataIndex: 'q1IndexId'
            }, {
                type: 'int',
                dataIndex: 'QuantityIndex'
            }, {
                type: 'float',
                dataIndex: 'netIndexId'
            },  {
                type: 'float',
                dataIndex: 'actualQtyIndexId'
            }, {
                type: 'string',
                dataIndex: 'permitIndexId'
            }, {
                type: 'string',
                dataIndex: 'issuedIndexId'
            }, {
                type: 'string',
                dataIndex: 'shipNameIndexId'
            }, {
                type: 'string',
                dataIndex: 'commStatusIndexId'
            }]
        });
        var createColModel = function(finish, start) {
            var columns = [
                new Ext.grid.RowNumberer({
                    header: "<span style=font-weight:bold;>SLNO</span>",
                    width: 50
                }), {
                    dataIndex: 'slnoIndex',
                    hidden: true,
                    header: "<span style=font-weight:bold;>SLNO</span>",
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    header: "<span style=font-weight:bold;>Type</span>",
                    dataIndex: 'TypeIndex',
                    filter: {
                        type: 'string'
                    }
                }, {
                    header: "<span style=font-weight:bold;>TripSheet Number</span>",
                    dataIndex: 'TripSheetNumberIndex',
                    filter: {
                        type: 'string'
                    }
                }, {
                    header: "<span style=font-weight:bold;>AssetNumber</span>",
                    dataIndex: 'assetNoIndex',
                    filter: {
                        type: 'string'
                    }
                }, {
                    header: "<span style=font-weight:bold;>TCLeaseName</span>",
                    dataIndex: 'tcLeaseNoIndex',
                    filter: {
                        type: 'string'
                    }
                }, {
                    header: "<span style=font-weight:bold;>Organization Name</span>",
                    dataIndex: 'orgNameIndex',
                    filter: {
                        type: 'string'
                    }
                }, {
                    header: "<span style=font-weight:bold;>Issued Date</span>",
                    dataIndex: 'issuedIndexId',
                    filter: {
                        type: 'string'
                    }

                }, {
                    header: "<span style=font-weight:bold;>Validity Date Time</span>",
                    dataIndex: 'validityDateDataIndex',
                    renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                    filter: {
                        type: 'date'
                    }
                }, {
                    header: "<span style=font-weight:bold;>Grade And Mineral Information</span>",
                    dataIndex: 'gradeAndMineralIndex',
                    filter: {
                        type: 'string'
                    }
                }, {
                    header: "<span style=font-weight:bold;>Route</span>",
                    dataIndex: 'RouteIndex',
                    filter: {
                        type: 'string'
                    }
                }, {
                    header: "<span style=font-weight:bold;>Status</span>",
                    dataIndex: 'statusIndexId',
                    hidden: true,
                    filter: {
                        type: 'string'
                    }
                }, {
                    header: "<span style=font-weight:bold;>Tare Weight1</span>",
                    dataIndex: 'q1IndexId',
                    align: 'right',
                    sortable: true,
                    filter: {
                        type: 'int'
                    }
                }, {
                    header: "<span style=font-weight:bold;>Gross Weight1</span>",
                    dataIndex: 'QuantityIndex',
                    align: 'right',
                    sortable: true,
                    filter: {
                        type: 'int'
                    }
                }, {
                    header: "<span style=font-weight:bold;>Net Weight</span>",
                    dataIndex: 'netIndexId',
                    align: 'right',
                    sortable: true,
                    filter: {
                        type: 'float'
                    }
                },  {
                    header: "<span style=font-weight:bold;>Actual Quantity</span>",
                    dataIndex: 'actualQtyIndexId',
                    align: 'right',
                    hidden: true,
                    filter: {
                        type: 'float'
                    }
                }, {
                    header: "<span style=font-weight:bold;>Permit No</span>",
                    dataIndex: 'permitIndexId',
                    hidden: false,
                    filter: {
                        type: 'string'
                    }
                },{
                    header: "<span style=font-weight:bold;>Vessel Name</span>",
                    dataIndex: 'shipNameIndexId',
                    hidden: false,
                    filter: {
                        type: 'string'
                    }
                },{
                    header: "<span style=font-weight:bold;>Communicating Status</span>",
                    dataIndex: 'commStatusIndexId',
                    hidden: false,
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
      
  grid = getGrid('', 'No Records Found', store, screen.width - 65, 390, 20, filters, 'Clear Filter Data', false, '', 20, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', false, 'Add', false, 'Modify', false, 'Close', false, '', false, 'Destination Weight', false, 'Close Trip',false,'',false,'',false,'Import Excel');
 Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width-50,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [grid],
        
    });
    //sb = Ext.getCmp('form-statusbar');
    store.load({
         params: {
         	jspName: jspName,
             CustID: '<%=request.getParameter("custId")%>',
             bargeId: '<%=request.getParameter("bargeId")%>',
             permitId: '<%=request.getParameter("permitId")%>'
         }
     });
     var cm=grid.getColumnModel();
     for (var j = 1; j < cm.getColumnCount(); j++) {
      cm.setColumnWidth(j,150);
     }
});

  </script>
</body>
</html>
<%}%>
<%}%>
 
