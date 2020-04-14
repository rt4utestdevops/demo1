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
tobeConverted.add("SLNO");
tobeConverted.add("UniqueId_No");
tobeConverted.add("Consumer_Application_No");
tobeConverted.add("MDP_No");
tobeConverted.add("Vehicle_No");
tobeConverted.add("Transporter_Name");
tobeConverted.add("Customer_Name");
tobeConverted.add("Driver_Name");
tobeConverted.add("Transporter");
tobeConverted.add("District");
tobeConverted.add("Quantity");
tobeConverted.add("Via_Route");
tobeConverted.add("To_Place");
tobeConverted.add("Valid_From");
tobeConverted.add("Valid_To");
tobeConverted.add("Loading_Type");
tobeConverted.add("Printed");  
tobeConverted.add("MDP_Date");
tobeConverted.add("DD_No");
tobeConverted.add("Bank_Name");
tobeConverted.add("Group_Id");
tobeConverted.add("Group_Name");
tobeConverted.add("Select_Consumer_Application_No");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Add");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Cancel");
tobeConverted.add("Save");
tobeConverted.add("select_vehicle_No");
tobeConverted.add("Select_Loading_Type");
tobeConverted.add("Modify");
tobeConverted.add("PDF");
tobeConverted.add("Excel");
tobeConverted.add("MDP_Generator_New");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SLNO=convertedWords.get(0);
String UniqueId_No=convertedWords.get(1);
String Consumer_Application_No=convertedWords.get(2);
String MDP_No=convertedWords.get(3);
String Vehicle_No=convertedWords.get(4);
String Transporter_Name=convertedWords.get(5);
String Customer_Name=convertedWords.get(6);
String Driver_Name=convertedWords.get(7);
String Transporter=convertedWords.get(8);
String District=convertedWords.get(9);
String Quantity=convertedWords.get(10);
String Via_Route=convertedWords.get(11);
String To_Place=convertedWords.get(12);
String Valid_From=convertedWords.get(13);
String Valid_To=convertedWords.get(14);
String Loading_Type=convertedWords.get(15);
String Printed=convertedWords.get(16);
String MDP_Date=convertedWords.get(17);
String DD_No=convertedWords.get(18);
String Bank_Name=convertedWords.get(19);
String Group_Id=convertedWords.get(20);
String Group_Name=convertedWords.get(21);
String Select_Consumer_Application_No=convertedWords.get(22);
String No_Records_Found=convertedWords.get(23);
String Clear_Filter_Data=convertedWords.get(24);
String Add=convertedWords.get(25);
String No_Rows_Selected=convertedWords.get(26);
String Select_Single_Row=convertedWords.get(27);
String Cancel=convertedWords.get(28);
String Save=convertedWords.get(29);
String select_vehicle_No=convertedWords.get(30);
String Select_Loading_Type=convertedWords.get(31);
String Modify=convertedWords.get(32);
String PDF=convertedWords.get(33);
String Excel=convertedWords.get(34);
String MDP_Generator_New=convertedWords.get(35);
String Distance="Distance";
%>

        <jsp:include page="../Common/header.jsp" />
            <title><%=MDP_Generator_New%></title>
            <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places,geometry&key=AIzaSyBSHs2852hTpOnebBOn48LObrqlRdEkpBs&region=IN"></script>
        
        <style>
            .x-panel-tl {
                border-bottom: 0px solid !important;
            }
        </style>

      
            <%if(loginInfo.getStyleSheetOverride().equals("Y")){%>
                <jsp:include page="../Common/ImportJSSandMining.jsp" />
                <%}else{%>
                    <jsp:include page="../Common/ImportJS.jsp" />
                    <%}%>
                        <jsp:include page="../Common/ExportJS.jsp" />
						<style>
								label {
									display : inline !important;
								}
								.x-window-tl *.x-window-header {
									height : 38px !important;
								}
								.ext-strict .x-form-text {
									height: 21px !important;
								}
								.x-layer ul {
									min-height: 27px !important;
								}
						</style>

                        <script>
                            var outerPanel;
                            var ctsb;
                            var jspname = "MDPGeneratorNew";
                            var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string";
                            var selected;
                            var grid;
                            var buttonValue;
                            var titelForInnerPanel;
                            var myWin;
                            var dtcur = datecur;
                            var dtnext = datenext;
                            var custname = "";
                            var vehicleNo;
                            var customerAddress;
                            var todaysDate = new Date();
                            var groupId;
                            var groupName;
                            var VehicleType;
                            var SandLoadingFromTime;
                            var SandLoadingToTime;
                            var LoadCapacityNew;
                            var TripSheetFormat;
                            var messageQuant = "";
                            var startdate = "";
                            var ts = "";
                            var uniqueID = "";
                            var fromPlaceAdd = "";
                            var distance;
                            var lat;
                            var longi;
                            var longitude;
                            var latitude;
                            var destlatlong;
                            var tpno;
                            var tpId;
                            var river;
                            var port_no;
                            var barcode = 0;
                            var tripcode = 0;
                            var DD_No;
							var DD_Date;
							var Bank_Name;
							var Village;
							var Taluk;
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
                                            custname = Ext.getCmp('custcomboId').getRawValue();
                                            store.load({
                                                params: {
                                                    ClientId: custId,
                                                    jspname: jspname,
                                                    custname: custname
                                                }
                                            });
                                            PermitStoreNew.load({
                                                params: {
                                                    clientId: custId
                                                }
                                            });
                                            TpNoStore.load({
                                                params: {
                                                    clientId: custId
                                                }
                                            });
                                        }
                                    }
                                }
                            });

                            var Client = new Ext.form.ComboBox({
                                store: clientcombostore,
                                id: 'custcomboId',
                                mode: 'local',
                                forceSelection: true,
                                emptyText: 'Select Client',
                                blankText: 'Select Client',
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
                                            custname = Ext.getCmp('custcomboId').getRawValue();
                                            store.load({
                                                params: {
                                                    ClientId: custId,
                                                    jspname: jspname,
                                                    custname: custname
                                                }
                                            });
                                            PermitStoreNew.load({
                                                params: {
                                                    clientId: custId
                                                }
                                            });
                                            TpNoStore.load({
                                                params: {
                                                    clientId: custId
                                                }
                                            });
                                        }
                                    }
                                }
                            });
                            var tripSheetCodeStore = new Ext.data.JsonStore({
							    url: '<%=request.getContextPath()%>/MDPGeneratorNewAction.do?param=getTripSheetCode',
							    id: 'tripSheetCodeStoreId',
							    root: 'tripSheetCodeRoot',
							    autoLoad: false,
							    remoteSort: true,
							    fields: ['tripSheetCode']
							});
							
							
							var tripSheetCodeCombo = new Ext.form.ComboBox({
							    frame: true,
							    store: tripSheetCodeStore,
							    id: 'tripSheetCodeComboId',
							    width: 175,
							    forceSelection: true,
							    enableKeyEvents: true,
							    mode: 'local',
							    anyMatch: true,
							    onTypeAhead: true,
							    triggerAction: 'all',
							    displayField: 'tripSheetCode',
							    valueField: 'tripSheetCode',
							    emptyText: 'Select Trip Sheet Code',
							    cls: 'selectstylePerfect',
							    listeners: {
							        select: {
							            fn: function () {
							
							            }
							        }
							    }
							});
                            
							var barCodeStore = new Ext.data.JsonStore({
							    url: '<%=request.getContextPath()%>/MDPGeneratorNewAction.do?param=getBarCode',
							    id: 'barCodeStoreId',
							    root: 'barCodeRoot',
							    autoLoad: false,
							    remoteSort: true,
							    fields: ['barCode']
							});
							
							var barCodeCombo = new Ext.form.ComboBox({
							    frame: true,
							    store: barCodeStore,
							    id: 'barCodeComboId',
							    width: 175,
							    forceSelection: true,
							    enableKeyEvents: true,
							    mode: 'local',
							    anyMatch: true,
							    onTypeAhead: true,
							    triggerAction: 'all',
							    displayField: 'barCode',
							    valueField: 'barCode',
							    emptyText: 'Select Bar Code',
							    cls: 'selectstylePerfect',
							    listeners: {
							        select: {
							            fn: function () {
							            
							            }
							        }
							    }
							});
                            var PermitStoreNew = new Ext.data.JsonStore({
                                url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getPermitsNewGRID',
                                id: 'PermitStoreNewId',
                                root: 'PermitstoreNewList',
                                autoLoad: false,
                                remoteSort: true,
                                fields: ['PermitNoNew', 'OwnerNameNew', 'Owner_TypeNew', 'PortNew', 'LoadCapacityNew', 'Group_Name', 'Group_Id']
                            });

                            var PermitComboNew = new Ext.form.ComboBox({
                                frame: true,
                                store: PermitStoreNew,
                                id: 'PermitComboNewId',
                                width: 175,
                                forceSelection: true,
                                emptyText: '<%=select_vehicle_No%>',
                                anyMatch: true,
                                onTypeAhead: true,
                                enableKeyEvents: true,
                                mode: 'local',
                                triggerAction: 'all',
                                displayField: 'PermitNoNew',
                                valueField: 'PermitNoNew',
                                cls: 'selectstylePerfect',
                                listeners: {
                                    select: {
                                        fn: function() {
                                            permitNo = Ext.getCmp('PermitComboNewId').getValue();
                                            var row = PermitStoreNew.find('PermitNoNew', permitNo);
                                            var rec = PermitStoreNew.getAt(row);
                                            LoadCapacityNew = rec.data['LoadCapacityNew'];
                                            groupId = rec.data['Group_Id'];
                                            groupName = rec.data['Group_Name'];
                                            VehicleType=rec.data['PortNew'];
                                            messageQuant = "";

                                            Ext.getCmp('quantityId').setValue(LoadCapacityNew);
                                            var applicationNo = Ext.getCmp('ApplicationStoreId').getValue();
                                            Ext.Ajax.request({
                                                url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=updateQuantity',
                                                method: 'POST',
                                                params: {
                                                    permitNo: permitNo,
                                                    qty: Ext.getCmp('quantityId').getValue(),
                                                    clientId: custId,
                                                    applicationNo: applicationNo
                                                },
                                                success: function(response, options) {
                                                    messageQuant = response.responseText;
                                                    if (messageQuant == "ERROR") {
                                                        Ext.example.msg("Vehicle capacity should be less than or equal to Balance Quantity");
                                                        return;
                                                    } else if (messageQuant == "Sorry!! Vehicle is in Blocked state, You cannot perform Credit/MDP") {
                                                        Ext.example.msg("Sorry!! Vehicle is in Blocked state, You cannot perform Credit/MDP");
                                                        return;
                                                    }
                                                }, // end of success
                                                failure: function(response, options) {
                                                        messageQuant = "";
                                                    } //
                                            });
                                            var tidType = rec.data['Owner_TypeNew'];

                                            // end of Ajax	
                                            if (<%=systemId%> == 134 || <%=systemId%> == 133 || <%=systemId%> == 210) {
                                                //================================to check only one TS per Vehicle for a day for shimoga
                                                Ext.Ajax.request({
                                                    url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getVehicleTScount',
                                                    method: 'POST',
                                                    params: {
                                                        vehno: permitNo,
                                                        systemId: <%=systemId%>,
                                                        clientId: custId
                                                    },
                                                    success: function(response, options) {
                                                        if (response.responseText == "Error") {
                                                            grid.store.reload();
                                                            Ext.example.msg("Cannot generate 2 MDPs for this vehicle in the same day...!");
                                                            return;
                                                        }
                                                        if (response.responseText == "Error1") {
                                                            grid.store.reload();
                                                            Ext.example.msg("Cannot generate more then 3 MDPs for this vehicle in the same day...!");
                                                            return;
                                                        }
                                                    }, // end of success
                                                    failure: function(response, options) {
                                                            grid.store.reload();
                                                            Ext.example.msg("Error while Processing....!");
                                                            return;
                                                        } // end of failure
                                                }); // end of Ajax	                      
                                            }
                                            var oType = rec.data['Owner_TypeNew'];
                                            Ext.getCmp('transporterNameId').setValue(rec.data['OwnerNameNew']);
                                            transporter = rec.data['OwnerNameNew'];
                                            vehicleNo = permitNo;
                                            customerAddress = rec.data['PortNew'];

                                            if (oType == "LeaseOwner") {
                                                var type = oType;
                                            } else {
                                                var type = rec.data['OwnerNameNew'];
                                            }

                                        }
                                    }
                                }

                            });

                            var LoadingType = [
                                ['Machine'],
                                ['Self']
                            ];
                            var LoadingTypestore = new Ext.data.SimpleStore({
                                data: LoadingType,
                                fields: ['LoadingTypeid']
                            });

                            var LoadingTypeCombo = new Ext.form.ComboBox({
                                frame: true,
                                store: LoadingTypestore,
                                id: 'LoadingTypestoreId',
                                width: 175,
                                forceSelection: true,
                                enableKeyEvents: true,
                                mode: 'local',
                                hidden: false,
                                anyMatch: true,
                                onTypeAhead: true,
                                triggerAction: 'all',
                                displayField: 'LoadingTypeid',
                                valueField: 'LoadingTypeid',
                                emptyText: 'Select Loading Type',
                                cls: 'selectstylePerfect',
                                listeners: {
                                    select: {
                                        fn: function() {

                                        }

                                    }

                                }

                            });

                            var TpNoStore = new Ext.data.JsonStore({
                                url: '<%=request.getContextPath()%>/MDPGeneratorNewAction.do?param=getTpNo',
                                id: 'TpNoStoreId',
                                root: 'TpNoStoreList',
                                autoLoad: false,
                                remoteSort: true,
                                fields: ['TpNo', 'TpId','DD_No','DD_Date','Bank_Name','Village','Taluk','TripStartCode','TripEndCode','BarStartCode','BarEndCode']
                            })
                            var TpNoCombo = new Ext.form.ComboBox({
                                frame: true,
                                store: TpNoStore,
                                id: 'TpNoComboId',
                                width: 175,
                                forceSelection: true,
                                enableKeyEvents: true,
                                mode: 'local',
                                hidden: false,
                                anyMatch: true,
                                onTypeAhead: true,
                                triggerAction: 'all',
                                displayField: 'TpNo',
                                valueField: 'TpId',
                                emptyText: 'Select Tp No',
                                cls: 'selectstylePerfect',
                                listeners: {
                                    select: {
                                        fn: function() {
                                             tpno = Ext.getCmp('TpNoComboId').getRawValue();
                                             tpId = Ext.getCmp('TpNoComboId').getValue();
                                             var row = TpNoStore.find('TpId',tpId);
											 var rec = TpNoStore.getAt(row);
											 DD_No=rec.data['DD_No'];
											 DD_Date=rec.data['DD_Date'];
											 Bank_Name=rec.data['Bank_Name'];
											 Village=rec.data['Village'];
											 Taluk=rec.data['Taluk'];
                                             ApplicationNoStore.load({
                                                params: {
                                                    clientId: custId,
                                                    tpno: tpno
                                                }
                                            });
                                            FromLatLongStore.load({
                                            params: {
                                                    clientId: custId,
                                                    tpno: tpno
                                                }
                                            });
                                            tripSheetCodeStore.load({
						                        params: {
						                            storeTripStartCode: rec.data['TripStartCode'],
						                            storeTripEndCode: rec.data['TripEndCode'],
						                            globalClientId: custId
						                        }
						                    });
						
						                    barCodeStore.load({
						                        params: {
						                            storeBarStartCode: rec.data['BarStartCode'],
						                            storeBarEndCode: rec.data['BarEndCode'],
						                            globalClientId: custId
						                        }
						                    });
                                            Ext.getCmp('ApplicationStoreId').reset();
			                                Ext.getCmp('customerNameId').reset();
			                                Ext.getCmp('customerMobileId').reset();
			                                Ext.getCmp('mdpNoId').reset();
			                                Ext.getCmp('approvedId').reset();
			                                Ext.getCmp('balanceId').reset();
			                                Ext.getCmp('PermitComboNewId').reset();
			                                Ext.getCmp('transporterNameId').reset();
			                                Ext.getCmp('driverNameId').reset();
			                                Ext.getCmp('viaRouteId').reset();
			                                Ext.getCmp('quantityId').reset();
			                                Ext.getCmp('validToId').reset();
			                                Ext.getCmp('distanceHoursId').reset();
			                                Ext.getCmp('validfromId').reset();
			                                //Ext.getCmp('barCodeComboId').reset();
                               				//Ext.getCmp('tripSheetCodeComboId').reset();
                               				Ext.getCmp('barcodeeeId').reset();
                               				Ext.getCmp('tripcodeeeId').reset();
			                                Ext.getCmp('fromRiverId').reset();
                                			Ext.getCmp('ToPlaceId').reset();
                                        }
                                    }


                                }

                            });
                            var FromLatLongStore = new Ext.data.JsonStore({
                                url: '<%=request.getContextPath()%>/MDPGeneratorNewAction.do?param=getFromLocLatLong',
                                id: 'FromLatLongStoreId',
                                root: 'FromLatLongStoreList',
                                autoLoad: false,
                                remoteSort: true,
                                fields: ['FromLat', 'FromLong', 'TripSheetFormat', 'fromport', 'river','Port_No']
                            })
                            var ApplicationNoStore = new Ext.data.JsonStore({
                                url: '<%=request.getContextPath()%>/MDPGeneratorNewAction.do?param=getApplicationDetails',
                                id: 'ApplicationNoStoreId',
                                root: 'ApplicationNoStoreList',
                                autoLoad: false,
                                remoteSort: true,
                                fields: ['ApplicationNo', 'consumerName', 'workAddress', 'latitude', 'longitude', 'approvedqty', 'balanceqty', 'phone', 'checkpost'] //tolocation latlong
                            })


                            var ApplicationNoCombo = new Ext.form.ComboBox({
                                frame: true,
                                store: ApplicationNoStore,
                                id: 'ApplicationStoreId',
                                width: 175,
                                forceSelection: true,
                                enableKeyEvents: true,
                                mode: 'local',
                                hidden: false,
                                anyMatch: true,
                                onTypeAhead: true,
                                triggerAction: 'all',
                                displayField: 'ApplicationNo',
                                valueField: 'ApplicationNo',
                                emptyText: 'Select Application No',
                                cls: 'selectstylePerfect',
                                listeners: {
                                    select: {
                                        fn: function() {
                                            if (Ext.getCmp('ApplicationStoreId').getValue() != "") {
                                                var application = Ext.getCmp('ApplicationStoreId').getValue();
                                                var row1 = ApplicationNoStore.find('ApplicationNo', application);
                                                var rec1 = ApplicationNoStore.getAt(row1);
                                                Ext.getCmp('customerNameId').setValue(rec1.data['consumerName']);
                                                Ext.getCmp('ToPlaceId').setValue(rec1.data['workAddress']);
                                                Ext.getCmp('approvedId').setValue(rec1.data['approvedqty']);
                                                Ext.getCmp('balanceId').setValue(rec1.data['balanceqty']);
                                                Ext.getCmp('customerMobileId').setValue(rec1.data['phone']);
                                                Ext.getCmp('viaRouteId').setValue(rec1.data['checkpost']);
                                                latitude = rec1.data['latitude'];
                                                longitude = rec1.data['longitude'];
                                                destlatlong = rec1.data['latitude'] + ',' + rec1.data['longitude'];
                                                var rec2 = FromLatLongStore.getAt(0);
                                                var ts = rec2.data['TripSheetFormat'];
                                                fromPlaceAdd = rec2.data['fromport'];
                                                river = rec2.data['river'];
                                                port_no=rec2.data['Port_No'];
                                                Ext.getCmp('fromRiverId').setValue(river);
                                                sourcelatlong = rec2.data['FromLat'] + ',' + rec2.data['FromLong'];
                                                calculateDistance();
                                                Ext.Ajax.request({
                                                    url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=maxTSGRID',
                                                    method: 'POST',
                                                    params: {
                                                        ClientId: custId
                                                    },
                                                    success: function(response, options) {
                                                        var tsno = response.responseText;
                                                        ts = ts + "-" + tsno;
                                                        Ext.getCmp('mdpNoId').setValue(ts);
                                                    }, // end of success
                                                    failure: function(response, options) {
                                                            Ext.getCmp('mdpNoId').setValue(ts + "-");
                                                        } // end of failure
                                                }); // end of Ajax	
                                                Ext.getCmp('mdpNoId').setValue(ts + "-");
                                            }
                                        }
                                    }


                                }

                            });

                            var customerComboPanel = new Ext.Panel({
                                standardSubmit: true,
                                collapsible: false,
                                id: 'customerComboPanelId',
                                layout: 'table',
                                frame: false,
                                width: screen.width - 12,
                                height: 40,
                                layoutConfig: {
                                    columns: 13
                                },
                                items: [{
                                        xtype: 'label',
                                        text: 'Client Name' + ' :',
                                        cls: 'labelstyle',
                                        id: 'clientlabelid'
                                    },
                                    Client
                                ]
                            });

                            function calculateDistance() {
                                var service = new google.maps.DistanceMatrixService();
                                service.getDistanceMatrix({
                                    origins: [sourcelatlong],
                                    destinations: [destlatlong],
                                    travelMode: google.maps.TravelMode.DRIVING,
                                    unitSystem: google.maps.UnitSystem.METRIC
                                }, function callback(response, status) {
                                    if (status == google.maps.DistanceMatrixStatus.OK && response.rows[0].elements[0].status != "ZERO_RESULTS") {
                                        var distance = response.rows[0].elements[0].distance.text;
                                        var dis=distance.replace(",", ""); 
                                        var speed = 10;
                                        var speedperkm = parseFloat(dis) / speed;
                                        var validFromDate1 = new Date();
                                        var validToDate1 = new Date(new Date(validFromDate1).getTime() + 60 * 60 * speedperkm * 1000);
                                        Ext.getCmp('validfromId').setValue(validFromDate1);
                                        Ext.getCmp('validToId').setValue(validToDate1);
                                        Ext.getCmp('distanceHoursId').setValue(parseFloat(dis));
                                    } else {
                                        console.log("Unable to find the distance via road.");
                                        Ext.getCmp('distanceHoursId').reset();
                                        Ext.getCmp('validToId').reset();
                                    }
                                });

                            }

                            var innerPanelForMDPGenerator = new Ext.form.FormPanel({
                                standardSubmit: true,
                                collapsible: false,
                                autoScroll: true,
                                height: 290,
                                width: 450,
                                frame: true,
                                id: 'innerPanelForMDPGeneratorId',
                                layout: 'table',
                                layoutConfig: {
                                    columns: 4
                                },
                                items: [{
                                    xtype: 'fieldset',
                                    title: '',
                                    cls: 'fieldsetpanel',
                                    collapsible: false,
                                    colspan: 3,
                                    id: 'MDPGenerationDetailsId',
                                    width: 420,
                                    layout: 'table',
                                    layoutConfig: {
                                        columns: 4
                                    },
                                    items: [{
                                        xtype: 'label',
                                        text: '*',
                                        cls: 'mandatoryfield',
                                        id: 'tpNoid1'
                                    }, {
                                        xtype: 'label',
                                        text: 'TP Number' + ' :',
                                        cls: 'labelstyle',
                                        id: 'tpNoLabelId'
                                    }, TpNoCombo, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'tpNoid2'
                                    }, {
                                        xtype: 'label',
                                        text: '*',
                                        cls: 'mandatoryfield',
                                        id: 'applicationNoid1'
                                    }, {
                                        xtype: 'label',
                                        text: '<%=Consumer_Application_No%>' + ' :',
                                        cls: 'labelstyle',
                                        id: 'applicationNoLabelId'
                                    }, ApplicationNoCombo, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'applicationNoid2'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'customerNameid1'
                                    }, {
                                        xtype: 'label',
                                        text: 'Consumer Name' + ' :',
                                        cls: 'labelstyle',
                                        id: 'customerNameLabelId'
                                    }, {
                                        xtype: 'textfield',
                                        cls: 'selectstylePerfect',
                                        allowBlank: false,
                                        blankText: '',
                                        emptyText: '',
                                        labelSeparator: '',
                                        readOnly: true,
                                        id: 'customerNameId'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'customerNameid2'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'customerMobileid1'
                                    }, {
                                        xtype: 'label',
                                        text: 'Consumer PhoneNo' + ' :',
                                        cls: 'labelstyle',
                                        id: 'customerMobileLabelId'
                                    }, {
                                        xtype: 'textfield',
                                        cls: 'selectstylePerfect',
                                        allowBlank: false,
                                        blankText: '',
                                        emptyText: '',
                                        labelSeparator: '',
                                        readOnly: true,
                                        id: 'customerMobileId'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'customerMobileid2'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'mdpNoid1'
                                    }, {
                                        xtype: 'label',
                                        text: '<%=MDP_No%>' + ' :',
                                        cls: 'labelstyle',
                                        id: 'mdpNolabelid'
                                    }, {
                                        xtype: 'textfield',
                                        cls: 'selectstylePerfect',
                                        allowBlank: false,
                                        blankText: '',
                                        emptyText: '',
                                        labelSeparator: '',
                                        readOnly: true,
                                        id: 'mdpNoId'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'mdpNoid2'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'approvedId1'
                                    }, {
                                        xtype: 'label',
                                        text: 'Approved' + ' :',
                                        cls: 'labelstyle',
                                        id: 'approvedlabelid'
                                    }, {
                                        xtype: 'textfield',
                                        cls: 'selectstylePerfect',
                                        allowBlank: false,
                                        blankText: '',
                                        emptyText: '',
                                        labelSeparator: '',
                                        readOnly: true,
                                        id: 'approvedId'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'approvedid2'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'balenceId1'
                                    }, {
                                        xtype: 'label',
                                        text: 'Balance' + ' :',
                                        cls: 'labelstyle',
                                        id: 'balancelabelid'
                                    }, {
                                        xtype: 'textfield',
                                        cls: 'selectstylePerfect',
                                        allowBlank: false,
                                        blankText: '',
                                        emptyText: '',
                                        labelSeparator: '',
                                        readOnly: true,
                                        id: 'balanceId'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'balanceid2'
                                    }, {
                                        xtype: 'label',
                                        text: '*',
                                        cls: 'mandatoryfield',
                                        id: 'permitNoId1'
                                    }, {
                                        xtype: 'label',
                                        text: '<%=Vehicle_No%>' + ' :',
                                        cls: 'labelstyle',
                                        id: 'permitnoLabelId'
                                    }, PermitComboNew, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'permitNoId2'
                                    }, {
                                        xtype: 'label',
                                        text: '*',
                                        cls: 'mandatoryfield',
                                        id: 'transporterNameId1'
                                    }, {
                                        xtype: 'label',
                                        text: '<%=Transporter_Name%>' + ' :',
                                        cls: 'labelstyle',
                                        id: 'transporterNameLabelId'
                                    }, {
                                        xtype: 'textfield',
                                        cls: 'selectstylePerfect',
                                        allowBlank: false,
                                        blankText: '',
                                        emptyText: '',
                                        labelSeparator: '',
                                        readOnly: true,
                                        id: 'transporterNameId'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'transporterNameId2'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'driverNameid1'
                                    }, {
                                        xtype: 'label',
                                        text: '<%=Driver_Name%>' + ' :',
                                        cls: 'labelstyle',
                                        id: 'driverNameLabelId'
                                    }, {
                                        xtype: 'textfield',
                                        cls: 'selectstylePerfect',
                                        allowBlank: false,
                                        blankText: '',
                                        emptyText: '',
                                        labelSeparator: '',
                                        id: 'driverNameId'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'driverNameid2'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'quantityid1'
                                    }, {
                                        xtype: 'label',
                                        text: '<%=Quantity%>' + '(CBM) :',
                                        cls: 'labelstyle',
                                        id: 'quantityLabelId'
                                    }, {
                                        xtype: 'numberfield',
                                        cls: 'selectstylePerfect',
                                        allowBlank: false,
                                        size: "100",
                                        blankText: '',
                                        readOnly: true,
                                        emptyText: '',
                                        labelSeparator: '',
                                        id: 'quantityId',
                                        listeners: {
                                            'change': function() {

                                            }
                                        }
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'quantityid2'
                                    }, {
                                        xtype: 'label',
                                        text: '*',
                                        cls: 'mandatoryfield',
                                        id: 'toPlaceid1'
                                    }, {
                                        xtype: 'label',
                                        text: 'Destination' + ' :',
                                        cls: 'labelstyle',
                                        id: 'toPlacelabelid'
                                    }, {
                                        xtype: 'textfield',
                                        cls: 'selectstylePerfect',
                                        allowBlank: false,
                                        size: "100",
                                        blankText: '',
                                        emptyText: '',
                                        labelSeparator: '',
                                        readOnly: true,
                                        id: 'ToPlaceId'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'toPlaceid2'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'viaRouteid1'
                                    }, {
                                        xtype: 'label',
                                        text: '<%=Via_Route%>' + ' :',
                                        cls: 'labelstyle',
                                        id: 'viaRouteLabelId'
                                    }, {
                                        xtype: 'textfield',
                                        cls: 'selectstylePerfect',
                                        allowBlank: false,
                                        size: "100",
                                        blankText: '',
                                        emptyText: '',
                                        labelSeparator: '',
                                        readOnly: true,
                                        id: 'viaRouteId'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'viaRouteid2'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'fromriverid1'
                                    }, {
                                        xtype: 'label',
                                        text: 'From River' + ' :',
                                        cls: 'labelstyle',
                                        id: 'fromRiverId2'
                                    }, {
                                        xtype: 'textfield',
                                        cls: 'selectstylePerfect',
                                        allowBlank: false,
                                        blankText: '',
                                        emptyText: '',
                                        labelSeparator: '',
                                        readOnly: true,
                                        id: 'fromRiverId'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'fromRiverId3'
                                    }, {
                                        xtype: 'label',
                                        text: '*',
                                        cls: 'mandatoryfield',
                                        id: 'validFromid1'
                                    }, {
                                        xtype: 'label',
                                        text: '<%=Valid_From%>' + ' :',
                                        cls: 'labelstyle',
                                        id: 'validFromlabelid'
                                    }, {
                                        xtype: 'datefield',
                                        cls: 'selectstylePerfect',
                                        format: getDateTimeFormat(),
                                        allowBlank: false,
                                        readOnly: false,
                                        emptyText: '',
                                        // value:dtcur,
                                        id: 'validfromId',
                                        listeners: {
                                            select: function() {
                                                if (<%=systemId%> == 134) {
                                                    var fromDate = new Date();
                                                    var Today = new Date();
                                                    fromDate = new Date(fromDate);
                                                    if (Today > fromDate) {
                                                        Ext.example.msg("VALID FROM date Should be greater then the present time");
                                                        grid.store.reload();
                                                        return;
                                                    }
                                                }
                                            }
                                        }
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'validFromid2'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'distanceid1'
                                    }, {
                                        xtype: 'label',
                                        text: '<%=Distance%>' + ' :',
                                        cls: 'labelstyle',
                                        id: 'distancelableId'
                                    }, {
                                        xtype: 'numberfield',
                                        cls: 'selectstylePerfect',
                                        allowBlank: false,
                                        blankText: '',
                                        emptyText: '',
                                        labelSeparator: '',
                                        readOnly: true,
                                        id: 'distanceHoursId',
                                        listeners: {
                                            change: function() {}
                                        }
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'distanceid2'
                                    }, {
                                        xtype: 'label',
                                        text: '*',
                                        cls: 'mandatoryfield',
                                        id: 'validToid1'
                                    }, {
                                        xtype: 'label',
                                        text: '<%=Valid_To%>' + ' :',
                                        cls: 'labelstyle',
                                        id: 'validTolabelid'
                                    }, {
                                        xtype: 'datefield',
                                        cls: 'selectstylePerfect',
                                        format: getDateTimeFormat(),
                                        allowBlank: false,
                                        readOnly: false,
                                        emptyText: '',
                                        id: 'validToId'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'validToid2'
                                    }, {
                                        xtype: 'label',
                                        text: '*',
                                        cls: 'mandatoryfield',
                                        id: 'loadingTypeid1'
                                    }, {
                                        xtype: 'label',
                                        text: '<%=Loading_Type%>' + ' :',
                                        cls: 'labelstyle',
                                        id: 'loadingTypelabelid'
                                    }, LoadingTypeCombo, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'loadingTypeid2'
                                    }, {
                                        xtype: 'label',
                                        text: '*',
                                        cls: 'mandatoryfield',
                                        id: 'tripcodeid1'
                                    }, {
                                        xtype: 'label',
                                        text: 'Tripcode No' + ' :',
                                        cls: 'labelstyle',
                                        id: 'tripcodeLabelId'
                                    },  {
                                        xtype: 'numberfield',
                                        cls: 'selectstylePerfect',
                                        allowBlank: false,
                                        blankText: '',
                                        emptyText: '',
                                        labelSeparator: '',
                                        id: 'tripcodeeeId'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'tripcodeid2'
                                    }, {
                                        xtype: 'label',
                                        text: '*',
                                        cls: 'mandatoryfield',
                                        id: 'barcodeid1'
                                    }, {
                                        xtype: 'label',
                                        text: 'Barcode No' + ' :',
                                        cls: 'labelstyle',
                                        id: 'barcodeLabelId'
                                    },  {
                                        xtype: 'numberfield',
                                        cls: 'selectstylePerfect',
                                        allowBlank: false,
                                        blankText: '',
                                        emptyText: '',
                                        labelSeparator: '',
                                        id: 'barcodeeeId'
                                    }, {
                                        xtype: 'label',
                                        text: '',
                                        cls: 'mandatoryfield',
                                        id: 'barcodeid2'
                                    }]
                                }]
                            });

                            var innerWinButtonPanel = new Ext.Panel({
                                id: 'innerWinButtonPanelId',
                                standardSubmit: true,
                                collapsible: false,
                                autoHeight: true,
                                height: 100,
                                width: 450,
                                frame: true,
                                layout: 'table',
                                layoutConfig: {
                                    columns: 4
                                },
                                buttons: [{
                                    xtype: 'button',
                                    text: '<%=Save%>',
                                    iconCls: 'savebutton',
                                    id: 'saveButtonId',
                                    cls: 'buttonstyle',
                                    width: 70,
                                    listeners: {
                                        click: {
                                            fn: function() {
                                                if (Ext.getCmp('custcomboId').getValue() == "") {
                                                    Ext.example.msg("Select Client Name");
                                                    return;
                                                }
                                                if (Ext.getCmp('ApplicationStoreId').getValue() == "") {
                                                    Ext.example.msg("<%=Select_Consumer_Application_No%>");
                                                    return;
                                                }

                                                if (dateCompare(Ext.getCmp('validfromId').getValue(), Ext.getCmp('validToId').getValue()) == -1) {
                                                    Ext.example.msg("Valid To Should Be Greater than Valid From Date");
                                                    Ext.getCmp('enddate').focus();
                                                    return;
                                                }
                                                if (Ext.getCmp('PermitComboNewId').getValue() == "") {
							                        Ext.example.msg("<%=select_vehicle_No%>");
							                        return;
							                    }
                                                if (Ext.getCmp('LoadingTypestoreId').getValue() == "") {
                                                    Ext.example.msg("<%=Select_Loading_Type%>");
                                                    return;
                                                }
                                                if (Ext.getCmp('tripcodeeeId').getValue() == "") {
                                                    Ext.example.msg("Enter Tripcode Number");
                                                    return;
                                                }
                                                if (Ext.getCmp('barcodeeeId').getValue() == "") {
                                                    Ext.example.msg("Enter Barcode Number");
                                                    return;
                                                }
                                                if (messageQuant == "ERROR") {
                                                    Ext.example.msg("Vehicle capacity should be less than or equal to Balance Quantity");
                                                    return;
                                                }
                                                if (messageQuant == "Sorry!! Vehicle is in Blocked state, You cannot perform Credit/MDP") {
                                                    Ext.example.msg("Sorry!! Vehicle is in Blocked state, You cannot perform Credit/MDP");
                                                    return;
                                                }

                                                if (buttonValue == "<%=Modify%>") {
                                                    var selected = grid.getSelectionModel().getSelected();

                                                }

                                                sandInwardPermitOuterPanelWindow.getEl().mask();
                                                Ext.Ajax.request({
                                                    url: '<%=request.getContextPath()%>/MDPGeneratorNewAction.do?param=saveGRIDDetails',
                                                    method: 'POST',
                                                    params: {
                                                        buttonValue: buttonValue,
                                                        custId: Ext.getCmp('custcomboId').getValue(),
                                                        mdpNoAdd: Ext.getCmp('mdpNoId').getValue(),
                                                        permitNoAdd: Ext.getCmp('TpNoComboId').getRawValue(),
                                                        transporterNameAdd: Ext.getCmp('transporterNameId').getValue(),
                                                        loadingTypeAdd: Ext.getCmp('LoadingTypestoreId').getValue(),
                                                        quantityAdd: Ext.getCmp('quantityId').getValue(),
                                                        validFromAdd: Ext.getCmp('validfromId').getValue(),
                                                        distanceAdd: Ext.getCmp('distanceHoursId').getValue(),
                                                        validToAdd: Ext.getCmp('validToId').getValue(),
                                                        customerNameAdd: Ext.getCmp('customerNameId').getValue(),
                                                        driverNameAdd: Ext.getCmp('driverNameId').getValue(),
                                                        viaRouteAdd: Ext.getCmp('viaRouteId').getValue(),
                                                        applicationNoAdd: Ext.getCmp('ApplicationStoreId').getValue(),
                                                        tripcode: Ext.getCmp('tripcodeeeId').getValue(),
                                                        barcode: Ext.getCmp('barcodeeeId').getValue(),
                                                        vehicleNoAdd: vehicleNo,
                                                        uniqueID: uniqueID,
                                                        latitude: latitude,
                                                        longitude: longitude,
                                                        fromPlaceAdd: fromPlaceAdd,
                                                        toPlaceAdd: Ext.getCmp('ToPlaceId').getValue(),
                                                        SandLoadingFromTime:'06:00',
														SandLoadingToTime:'18:00',
														Sand_type:'Ordinary Sand',
														port_no: port_no,
														DD_No: DD_No,
														DD_Date: DD_Date,
														Bank_Name: Bank_Name,
														Village: Village,
														Taluk: Taluk,
														VehicleType: VehicleType

                                                    },
                                                    success: function(response, options) {
                                                        var message = response.responseText;
                                                        Ext.example.msg(message);
                                                        myWin.hide();
                                                        sandInwardPermitOuterPanelWindow.getEl().unmask();
                                                        store.load({
                                                            params: {
                                                                ClientId: Ext.getCmp('custcomboId').getValue(),
                                                                jspname: jspname,
                                                                custname: custname
                                                            }
                                                        });


                                                    },
                                                    failure: function() {
                                                        Ext.example.msg("Error");
                                                        myWin.hide();
                                                    }
                                                });
                                                //  }
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
                                                myWin.hide();
                                             //   Ext.getCmp('barCodeComboId').reset();
                               				//Ext.getCmp('tripSheetCodeComboId').reset();
                               				Ext.getCmp('barcodeeeId').reset();
                               				Ext.getCmp('tripcodeeeId').reset();
                               				Ext.getCmp('ApplicationStoreId').reset();
                                            }
                                        }
                                    }
                                }]
                            });

                            var sandInwardPermitOuterPanelWindow = new Ext.Panel({
                                width: 460,
                                height: 340,
                                standardSubmit: true,
                                frame: false,
                                items: [innerPanelForMDPGenerator, innerWinButtonPanel]
                            });

                            myWin = new Ext.Window({
                                title: titelForInnerPanel,
                                closable: false,
                                resizable: false,
                                modal: true,
                                autoScroll: false,
                                height: 390,
                                width: 460,
                                id: 'myWin',
                                items: [sandInwardPermitOuterPanelWindow]
                            });

                            function addRecord() {
                                if (Ext.getCmp('custcomboId').getValue() == "") {
                                    Ext.example.msg("select Client Name");
                                    return;
                                }
                                titelForInnerPanel = 'Add Information';
                                myWin.setPosition(450, 80);
                                buttonValue = '<%=Add%>';
                                myWin.show();
                                myWin.setTitle(titelForInnerPanel);
                                Ext.getCmp('TpNoComboId').reset();
                                Ext.getCmp('ApplicationStoreId').reset();
                                Ext.getCmp('customerNameId').reset();
                                Ext.getCmp('customerMobileId').reset();
                                Ext.getCmp('mdpNoId').reset();
                                Ext.getCmp('approvedId').reset();
                                Ext.getCmp('balanceId').reset();
                                Ext.getCmp('PermitComboNewId').reset();
                                Ext.getCmp('transporterNameId').reset();
                                Ext.getCmp('driverNameId').reset();
                                Ext.getCmp('viaRouteId').reset();
                                Ext.getCmp('quantityId').reset();
                                Ext.getCmp('LoadingTypestoreId').reset();
                                Ext.getCmp('validToId').reset();
                                Ext.getCmp('distanceHoursId').reset();
                                Ext.getCmp('validfromId').reset();
                               // Ext.getCmp('barCodeComboId').reset();
                                //Ext.getCmp('tripSheetCodeComboId').reset();
                                Ext.getCmp('barcodeeeId').reset();
                               	Ext.getCmp('tripcodeeeId').reset();
                                Ext.getCmp('fromRiverId').reset();
                                Ext.getCmp('ToPlaceId').reset();

                            }

                            var reader = new Ext.data.JsonReader({
                                idProperty: 'mdpGeneratorid',
                                root: 'newGridRoot',
                                totalProperty: 'total',
                                fields: [{
                                        name: 'SLNODataIndex'
                                    }, {
                                        name: 'UniqueIdDataIndex'
                                    }, {
                                        name: 'tpNODataIndex'
                                    }, {
                                        name: 'applicationNODataIndex'
                                    }, {
                                        name: 'ConsumerNameDataIndex'
                                    }, {
                                        name: 'ConsumerPhoneDataIndex'
                                    }, {
                                        name: 'TripSheetNODataIndex'
                                    }, {
                                        name: 'approvedDataIndex'
                                    }, {
                                        name: 'balanceDataIndex'
                                    }, {
                                        name: 'PermitNoDataIndex'
                                    }, {
                                        name: 'PermitHolderDataIndex'
                                    }, {
                                        name: 'DriverIndex'
                                    }, {
                                        name: 'QuantityDataIndex'
                                    }, {
                                        name: 'ViaRouteDataIndex'
                                    }, {
                                        name: 'DateOfEntryDataIndex',
                                        type: 'date'
                                    }, {
                                        name: 'DateOfEntryDataIndex1',
                                        type: 'date'
                                    }, {
                                        name: 'distanceindex'
                                    }, {
                                        name: 'LoadingTypeDataIndex'
                                    }, {
                                        name: 'destinationDataIndex'
                                    }] // END OF Fields
                            }); // End of Reader

                            var store = new Ext.data.GroupingStore({
                                url: '<%=request.getContextPath()%>/MDPGeneratorNewAction.do?param=getGRIDDetails',
                                bufferSize: 367,
                                reader: reader,
                                autoLoad: false,
                                remoteSort: true
                            });

                            var filters = new Ext.ux.grid.GridFilters({
                                local: true,
                                filters: [{
                                    dataIndex: 'SLNODataIndex',
                                    type: 'numeric'
                                }, {
                                    dataIndex: 'UniqueIdDataIndex',
                                    type: 'numeric'
                                }, {
                                    dataIndex: 'applicationNODataIndex',
                                    type: 'string'
                                }, {
                                    dataIndex: 'tpNODataIndex',
                                    type: 'string'
                                }, {
                                    dataIndex: 'ConsumerNameDataIndex',
                                    type: 'string'
                                }, {
                                    dataIndex: 'ConsumerPhoneDataIndex',
                                    type: 'string'
                                }, {
                                    dataIndex: 'TripSheetNODataIndex',
                                    type: 'string'
                                }, {
                                    dataIndex: 'approvedDataIndex',
                                    type: 'string'
                                }, {
                                    dataIndex: 'balanceDataIndex',
                                    type: 'string'
                                }, {
                                    dataIndex: 'PermitNoDataIndex',
                                    type: 'string'
                                }, {
                                    dataIndex: 'PermitHolderDataIndex',
                                    type: 'string'
                                }, {
                                    dataIndex: 'DriverIndex',
                                    type: 'string'
                                }, {
                                    dataIndex: 'QuantityDataIndex',
                                    type: 'string'
                                }, {
                                    dataIndex: 'destinationDataIndex',
                                    type: 'string'
                                }, {
                                    dataIndex: 'ViaRouteDataIndex',
                                    type: 'string'
                                }, {
                                    dataIndex: 'DateOfEntryDataIndex',
                                    type: 'date'
                                }, {
                                    dataIndex: 'DateOfEntryDataIndex1',
                                    type: 'date'
                                }, {
                                    dataIndex: 'distanceindex',
                                    type: 'numeric'
                                }, {
                                    dataIndex: 'LoadingTypeDataIndex',
                                    type: 'string'
                                }]
                            });

                            var createColModel = function(finish, start) {
                                var columns = [new Ext.grid.RowNumberer({
                                    header: "<span style=font-weight:bold;><%=SLNO%></span>",
                                    width: 50
                                }), {
                                    header: "<span style=font-weight:bold;><%=SLNO%></span>",
                                    dataIndex: 'SLNODataIndex',
                                    hidden: true,
                                    sortable: true,
                                    hideable: true,
                                    filter: {
                                        type: 'numeric'
                                    }
                                }, {
                                    header: "<span style=font-weight:bold;><%=UniqueId_No%></span>",
                                    dataIndex: 'UniqueIdDataIndex',
                                    hidden: true,
                                    hideable: true,
                                    width: 150,
                                    filter: {
                                        type: 'numeric'
                                    }
                                }, {
                                    header: "<span style=font-weight:bold;>TP Number</span>",
                                    dataIndex: 'tpNODataIndex',
                                    hidden: false,
                                    sortable: true,
                                    hideable: true,
                                    width: 150,
                                    filter: {
                                        type: 'string'
                                    }
                                }, {
                                    header: "<span style=font-weight:bold;><%=Consumer_Application_No%></span>",
                                    dataIndex: 'applicationNODataIndex',
                                    hidden: false,
                                    sortable: true,
                                    hideable: true,
                                    width: 150,
                                    filter: {
                                        type: 'string'
                                    }
                                }, {
                                    header: "<span style=font-weight:bold;>Consumer Name</span>",
                                    dataIndex: 'ConsumerNameDataIndex',
                                    hidden: false,
                                    sortable: true,
                                    hideable: true,
                                    width: 150,
                                    filter: {
                                        type: 'string'
                                    }
                                }, {
                                    header: "<span style=font-weight:bold;>Consumer PhoneNo</span>",
                                    dataIndex: 'ConsumerPhoneDataIndex',
                                    hidden: false,
                                    sortable: true,
                                    hideable: true,
                                    width: 150,
                                    filter: {
                                        type: 'string'
                                    }
                                }, {
                                    header: "<span style=font-weight:bold;><%=MDP_No%></span>",
                                    dataIndex: 'TripSheetNODataIndex',
                                    hidden: false,
                                    sortable: true,
                                    hideable: true,
                                    width: 150,
                                    filter: {
                                        type: 'string'
                                    }
                                }, {
                                    header: "<span style=font-weight:bold;>Approved</span>",
                                    dataIndex: 'approvedDataIndex',
                                    hidden: false,
                                    sortable: true,
                                    hideable: true,
                                    width: 150,
                                    filter: {
                                        type: 'string'
                                    }
                                }, {
                                    header: "<span style=font-weight:bold;>Balance</span>",
                                    dataIndex: 'balanceDataIndex',
                                    hidden: false,
                                    sortable: true,
                                    hideable: true,
                                    width: 150,
                                    filter: {
                                        type: 'string'
                                    }
                                }, {
                                    header: "<span style=font-weight:bold;><%=Vehicle_No%></span>",
                                    dataIndex: 'PermitNoDataIndex',
                                    hidden: false,
                                    sortable: true,
                                    hideable: true,
                                    width: 150,
                                    filter: {
                                        type: 'string'
                                    }
                                }, {
                                    header: "<span style=font-weight:bold;><%=Transporter_Name%></span>",
                                    dataIndex: 'PermitHolderDataIndex',
                                    hidden: false,
                                    sortable: true,
                                    hideable: true,
                                    width: 150,
                                    filter: {
                                        type: 'string'
                                    }
                                }, {
                                    header: "<span style=font-weight:bold;><%=Driver_Name%></span>",
                                    dataIndex: 'DriverIndex',
                                    hidden: false,
                                    sortable: true,
                                    hideable: true,
                                    width: 150,
                                    filter: {
                                        type: 'string'
                                    }
                                }, {
                                    header: "<span style=font-weight:bold;><%=Quantity%>(CBM)</span>",
                                    dataIndex: 'QuantityDataIndex',
                                    width: 150,
                                    hidden: false,
                                    sortable: true,
                                    hideable: true,
                                    filter: {
                                        type: 'string'
                                    }
                                }, {
                                    header: "<span style=font-weight:bold;>Destination</span>",
                                    dataIndex: 'destinationDataIndex',
                                    width: 150,
                                    hidden: false,
                                    sortable: true,
                                    hideable: true,
                                    filter: {
                                        type: 'string'
                                    }
                                }, {
                                    header: "<span style=font-weight:bold;><%=Via_Route%></span>",
                                    dataIndex: 'ViaRouteDataIndex',
                                    width: 150,
                                    hidden: false,
                                    sortable: true,
                                    hideable: true,
                                    filter: {
                                        type: 'string'
                                    }
                                }, {
                                    header: "<span style=font-weight:bold;><%=Valid_From%></span>",
                                    dataIndex: 'DateOfEntryDataIndex',
                                    width: 150,
                                    renderer: Ext.util.Format.dateRenderer('d/m/Y H:i:s'),
                                    hidden: false,
                                    sortable: true,
                                    hideable: true,
                                    filter: {
                                        type: 'date'
                                    }
                                }, {
                                    header: "<span style=font-weight:bold;><%=Valid_To%></span>",
                                    dataIndex: 'DateOfEntryDataIndex1',
                                    width: 150,
                                    renderer: Ext.util.Format.dateRenderer('d/m/Y H:i:s'),
                                    hidden: false,
                                    sortable: true,
                                    hideable: true,
                                    filter: {
                                        type: 'date'
                                    }
                                }, {
                                    header: "<span style=font-weight:bold;>Distance</span>",
                                    dataIndex: 'distanceindex',
                                    width: 150,
                                    hidden: false,
                                    sortable: true,
                                    hideable: true,
                                    filter: {
                                        type: 'string'
                                    }
                                }, {
                                    header: "<span style=font-weight:bold;><%=Loading_Type%></span>",
                                    dataIndex: 'LoadingTypeDataIndex',
                                    width: 150,
                                    hidden: false,
                                    sortable: true,
                                    hideable: true,
                                    filter: {
                                        type: 'string'
                                    }
                                }];
                                return new Ext.grid.ColumnModel({
                                    columns: columns.slice(start || 0, finish),
                                    defaults: {
                                        sortable: true
                                    }
                                });
                            };


                            function PrintPDF() {

                                var selection = grid.getSelectionModel();
                                if (selection.getCount() > 1) {
                                    Ext.example.msg("Select Single Row");
                                    return;
                                }
                                var uids = "";
                                var ts = "";
                                var total = 0;
                                for (i = 0; i < grid.store.getCount(); i++) {

                                    if (selection.isSelected(i)) {
                                        var uid = grid.store.getAt(i).data.UniqueIdDataIndex;
                                        var ts1 = grid.store.getAt(i).data.PermitNoDataIndex;
                                        uids = uids + "," + uid;
                                        ts = ts + "," + ts1;
                                    }
                                }

                                if (uids == "") {
                                    Ext.example.msg("No records selected to print...");
                                    return;
                                }
                                Ext.Ajax.request({
                                    url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getPDFFileType',
                                    method: 'POST',
                                    params: {
                                        systemId: <%=systemId%>
                                    },
                                    success: function(response, options) {
                                        if (response.responseText == "D") // It refers to Type="D"
                                        {
                                            window.open("<%=request.getContextPath()%>/Sand_Mining_MDP?uids=" + uids + "&ts=" + ts + "&systemId=" + <%=systemId%> + "");
                                        }
                                    }, // end of success
                                    failure: function(response, options) {
                                            Ext.example.msg("ERROR WHILE PROCESSING")
                                        } // end of failure
                                });

                                loadGrid1();
                            }

                            function load() {

                                grid.store.load();
                            }

                            function loadGrid1() {

                                setTimeout('load()', 100);

                            }



                            //*****************************************************************Grid *******************************************************************************
                            grid = getSandPermitGrid('MDPGeneratorNew', '<%=No_Records_Found%>', store, screen.width - 32, 420, 45, filters, '<%=Clear_Filter_Data%>', false, '', 20, false, '', false, '', true, '<%=Excel%>', jspname, exportDataType, true, '<%=PDF%>', true, '<%=Add%>', false, '<%=Modify%>', true, 'Print MDP');
                            //******************************************************************************************************************************************************
                            Ext.onReady(function() {
                                ctsb = tsb;
                                Ext.QuickTips.init();
                                Ext.form.Field.prototype.msgTarget = 'side';
                                outerPanel = new Ext.Panel({
                                    title: '<%=MDP_Generator_New%>',
                                    renderTo: 'content',
                                    standardSubmit: true,
                                    frame: true,
                                    width: screen.width - 22,
                                    cls: 'outerpanel',
                                    layout: 'table',
                                    layoutConfig: {
                                        columns: 1
                                    },
                                    items: [customerComboPanel, grid]
                                });
                                sb = Ext.getCmp('form-statusbar');
                                if (<%=customerId%> > 0) {
                                    Ext.getCmp('clientlabelid').hide();
                                    Ext.getCmp('custcomboId').hide();
                                }
                                var cm = grid.getColumnModel();
                                for (var j = 1; j < cm.getColumnCount(); j++) {
                                    cm.setColumnWidth(j, 150);
                                }

                            });
        </script>
      <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
        <%}%>
