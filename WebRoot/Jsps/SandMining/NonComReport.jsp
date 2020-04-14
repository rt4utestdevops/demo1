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
	if(str.length>8){
	loginInfo.setCustomerName(str[8].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
//getting language
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
String systemID=Integer.toString(systemid);
//getting hashmap with language specific words
HashMap langConverted=ApplicationListener.langConverted;
LanguageWordsBean lwb=null;
int customeridlogged=loginInfo.getCustomerId();
//Getting words based on language 
String SelectCustomer;
lwb=(LanguageWordsBean)langConverted.get("Select_Customer");
if(language.equals("ar")){
	SelectCustomer=lwb.getArabicWord();
}else{
	SelectCustomer=lwb.getEnglishWord();
}
lwb=null;
String Non_Communication_Report;
lwb=(LanguageWordsBean)langConverted.get("Non_Communication_Report");
if(language.equals("ar")){
	Non_Communication_Report=lwb.getArabicWord();
}else{
	Non_Communication_Report=lwb.getEnglishWord();
}
lwb=null;
String NoRecordsFound;
lwb=(LanguageWordsBean)langConverted.get("No_Records_Found");
if(language.equals("ar")){
	NoRecordsFound=lwb.getArabicWord();
}else{
	NoRecordsFound=lwb.getEnglishWord();
}
lwb=null;
String CustomerName;
lwb=(LanguageWordsBean)langConverted.get("Customer_Name");
if(language.equals("ar")){
	CustomerName=lwb.getArabicWord();
}else{
	CustomerName=lwb.getEnglishWord();
}
lwb=null;
String SLNO;
lwb=(LanguageWordsBean)langConverted.get("SLNO");
if(language.equals("ar")){
	SLNO=lwb.getArabicWord();
}else{
	SLNO=lwb.getEnglishWord();
}
lwb=null;
String Non_Communicating_MoreThen24Hrs;
lwb=(LanguageWordsBean)langConverted.get("Non_Communicating_Greater_Than_24Hrs");
if(language.equals("ar")){
	Non_Communicating_MoreThen24Hrs=lwb.getArabicWord();
}else{
	Non_Communicating_MoreThen24Hrs=lwb.getEnglishWord();
}
lwb=null;
String Non_Comm_Assets;
lwb=(LanguageWordsBean)langConverted.get("Non_Communicating_Assets");
if(language.equals("ar")){
	Non_Comm_Assets=lwb.getArabicWord();
}else{
	Non_Comm_Assets=lwb.getEnglishWord();
}
lwb=null;
String Last_Location;
lwb=(LanguageWordsBean)langConverted.get("Last_Location");
if(language.equals("ar")){
	Last_Location=lwb.getArabicWord();
}else{
	Last_Location=lwb.getEnglishWord();
}
lwb=null;
String LastCommunicatingDate;
lwb=(LanguageWordsBean)langConverted.get("Last_Communicated_Date_Time");
if(language.equals("ar")){
	LastCommunicatingDate=lwb.getArabicWord();
}else{
	LastCommunicatingDate=lwb.getEnglishWord();
}
lwb=null;
String OwnerName;
lwb=(LanguageWordsBean)langConverted.get("Owner_Name");
if(language.equals("ar")){
	OwnerName=lwb.getArabicWord();
}else{
	OwnerName=lwb.getEnglishWord();
}
lwb=null;
String ContactNumber;
lwb=(LanguageWordsBean)langConverted.get("Contact_Number");
if(language.equals("ar")){
	ContactNumber=lwb.getArabicWord();
}else{
	ContactNumber=lwb.getEnglishWord();
}
lwb=null;
String Submit;
lwb=(LanguageWordsBean)langConverted.get("Submit");
if(language.equals("ar")){
	Submit=lwb.getArabicWord();
}else{
	Submit=lwb.getEnglishWord();
}
lwb=null;

String ClearFilterData;
lwb=(LanguageWordsBean)langConverted.get("Clear_Filter_Data");
if(language.equals("ar")){
	ClearFilterData=lwb.getArabicWord();
}else{
	ClearFilterData=lwb.getEnglishWord();
}
lwb=null;
String ReconfigureGrid;
lwb=(LanguageWordsBean)langConverted.get("Reconfigure_Grid");
if(language.equals("ar")){
	ReconfigureGrid=lwb.getArabicWord();
}else{
	ReconfigureGrid=lwb.getEnglishWord();
}
lwb=null;
String ClearGrouping;
lwb=(LanguageWordsBean)langConverted.get("Clear_Grouping");
if(language.equals("ar")){
	ClearGrouping=lwb.getArabicWord();
}else{
	ClearGrouping=lwb.getEnglishWord();
}
lwb=null;
String Excel=cf.getLabelFromDB("Excel",language);

%>

<jsp:include page="../Common/header.jsp" />
        <title>
            <%=Non_Communication_Report%>
        </title>
   
    
    <div height="100%"">
        <jsp:include page="../Common/ImportJSSandMining.jsp" />
         <!-- for exporting to excel***** -->
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
			.x-panel-body-noborder {
				height : 347px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}
			</style>
		<%}%>
		<style>
			.x-panel-body-noborder {
				height : 347px !important;
			}
		</style>
        <script>
    		var outerPanel;
            var totalcount=0;
            var noncommvehicles=0;
            var gpspercentage=0;
            var noncommhours=6;
            var jspName = "NonCommunicatingReport";
            var exportDataType = "int,string,string,string,string,string";
             //******************************Store for getting customer name************************
            var custmastcombostore = new Ext.data.JsonStore({
                url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
                id: 'CustomerStoreId',
                root: 'CustomerRoot',
                autoLoad: true,
                remoteSort: true,
                fields: ['CustId', 'CustName'],
                listeners: {
                    load: function (custstore, records, success, options) {
                        if ( <%= customeridlogged %> > 0) {
                            Ext.getCmp('custmastcomboId').setValue('<%=customeridlogged%>');
                            totalcount=0;
             				noncommvehicles=0;
             				gpspercentage=0;
             				noncommhours=6;
                            store.load({
                                params: {
                                    custID: Ext.getCmp('custmastcomboId').getValue(),
                                    jspName:jspName
                                		},callback:function(){
                                			userGrid.getSelectionModel().deselectRow(0); 
                                			var rec = store.getAt(0);
                                			if(store.getCount()>0)
                                			{
                                			totalcount=rec.data['totalvehicles'];
                                			noncommhours=rec.data['noncommhours']/60;
                                			noncommvehicles=store.getCount(); 
                                			gpspercentage=parseInt((noncommvehicles/totalcount)*100);
                                			}  
                                			document.getElementById('noncommcatingHeader').innerHTML='Total Non Communicating Assets >'+noncommhours+'Hrs:';  
                                			document.getElementById('noncommPercentageHeader').innerHTML='Non Communicating Percentage :';                         			
              		          				document.getElementById('toalnoncommvehicles').innerHTML=noncommvehicles;
              		          				document.getElementById('noncommPercentage').innerHTML=gpspercentage+'%';
                                			}
                            });
                            
                        }
                    }
                }
            });
            
             //**************************** Combo for Client Name***************************************************
            var clientnamecombo = new Ext.form.ComboBox({
                store: custmastcombostore,
                id: 'custmastcomboId',
                mode: 'local',
                hidden: false,
                resizable: true,
                forceSelection: true,
                emptyText: '<%=SelectCustomer%>',
                blankText: '<%=SelectCustomer%>',
                selectOnFocus: true,
                allowBlank: false,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                valueField: 'CustId',
                displayField: 'CustName',
                cls: 'selectstyle',
                listeners: {
                    select: {
                        fn: function () {
                        	totalcount=0;
             				noncommvehicles=0;
             				gpspercentage=0;
             				noncommhours=6;
                            store.load({
                                params: {
                                    custID: Ext.getCmp('custmastcomboId').getValue(),
                                    jspName:jspName
                                		  },callback:function(){
                                			userGrid.getSelectionModel().deselectRow(0); 
                                			var rec = store.getAt(0);
                                			if(store.getCount()>0)
                                			{
                                			totalcount=rec.data['totalvehicles'];
                                			noncommhours=rec.data['noncommhours']/60;
                                			noncommvehicles=store.getCount(); 
                                			gpspercentage=parseInt((noncommvehicles/totalcount)*100);
                                			}  
                                			document.getElementById('noncommcatingHeader').innerHTML='Total Non Communicating Assets >'+noncommhours+'Hrs:';  
                                			document.getElementById('noncommPercentageHeader').innerHTML='Non Communicating Percentage :';                         			
              		          				document.getElementById('toalnoncommvehicles').innerHTML=noncommvehicles;
              		          				document.getElementById('noncommPercentage').innerHTML=gpspercentage+'%';
                                			}
                            });
                        }
                    }
                }
            });
            
              //************************************* Inner panel start******************************************* 
            var innerPanel = new Ext.Panel({
                standardSubmit: true,
                collapsible: false,
                cls: 'innerpanelsmallestpercentage',
                id: 'custMaster',
                layout: 'table',
                layoutConfig: {
                    columns: 5
                },
                items: [{
                        xtype: 'label',
                        text: '<%=CustomerName%>' + '  :',
                        allowBlank: false,
                        hidden: false,
                        cls: 'labelstyle',
                        id: 'clientnamhidlab'
                    },
                    clientnamecombo
                ]
            }); // End of Panel	
            
             //********************************* Reader Config***********************************
            var reader = new Ext.data.JsonReader({
                idProperty: 'gridrootid',
                root: 'GridRoot',
                totalProperty: 'total',
                fields: [{
                        name: 'slnoIndex'
                    },{
                		name:'totalvehicles'
                	},
                	{
                	  name:'noncommhours'
                	},{
                        name: 'noncomid'
                    }, {
                        name: 'lastloc'
                    }, {
                        name: 'lastcondatetime'
                    }, {
                        name: 'ownername'
                    }, {
                        name: 'contactnumber'
                    }
                ]
            });
             //******************************** Grid Store*************************************** 
            var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/SandMiningAction.do?param=getGridNonCommunicatingData',
                    method: 'POST'
                }),
                remoteSort: false,
                storeId: 'gridStore',
                reader: reader
            });
            store.on('beforeload', function (store, operation, eOpts) {
                operation.params = {
                    custID: Ext.getCmp('custmastcomboId').getValue(),
                    jspName:jspName
                };
            }, this);

            var filters = new Ext.ux.grid.GridFilters({
                local: true,
                filters: [{
                        type: 'numeric',
                        dataIndex: 'slnoIndex'
                    },{
                        dataIndex: 'noncomid',
                        type: 'string'
                    }, {
                        type: 'string',
                        dataIndex: 'lastloc'
                    }, {
                        type: 'date',
                        dataIndex: 'lastcondatetime'
                    }, {
                        type: 'string',
                        dataIndex: 'ownername'
                    }, {
                        type: 'string',
                        dataIndex: 'contactnumber'
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
                    }, {
                        header: "<span style=font-weight:bold;><%=Non_Comm_Assets%></span>",
                        dataIndex: 'noncomid',
                        //width:40,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=Last_Location%></span>",
                        dataIndex: 'lastloc',
                        //width:70,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=LastCommunicatingDate%></span>",
                        dataIndex: 'lastcondatetime',
                        //width:40,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=OwnerName%></span>",
                        dataIndex: 'ownername',
                        //width:30,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=ContactNumber%></span>",
                        dataIndex: 'contactnumber',
                        //width:30,
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
            var userGrid = getGrid('', '<%=NoRecordsFound%>', store, screen.width-35, 405, 7, filters, '<%=ClearFilterData%>', true, '<%=ReconfigureGrid%>', 10, true, '<%=ClearGrouping%>', false, '', true, '<%=Excel%>', jspName, exportDataType, false, '');

            userGrid.on({
                cellclick: {
                    fn: function (userGrid, rowIndex, columnIndex, e) {
                        

                    }
                }
            });
            
            var InfoPanel = new Ext.Panel({
	    	id: 'headerPanelTripSearch',
    		standardSubmit: true,
    		frame: true,
            width: '100%',
            layout:'table', 
	  			defaults: {
        			bodyStyle:'padding:5px'
    			},
    			layoutConfig: {
       					columns: 2
    			},
    			items: [{
       				 			html: '<b></b> ',
       				 			id:'noncommcatingHeader',
       				 			cls: 'colCelllabel'
    					},{
       				 			html: '<div align=right><b></b></div>',
       				 			id:'toalnoncommvehicles',
       				 			cls: 'colCellcount' 
    					},{
       				 			html: '<b></b>',
       				 			id:'noncommPercentageHeader',
       				 			cls: 'colCelllabel' 

    					},{
        			  			html: '<div align=right><b> </b></div>',
        			  			id:'noncommPercentage',
        			  			cls: 'colCellcount' 
                		}]
    		});
              
          //***************************  Main starts from here **************************************************
            Ext.onReady(function () {
                Ext.QuickTips.init();
                Ext.form.Field.prototype.msgTarget = 'side';
                outerPanel = new Ext.Panel({
                    title: '<%=Non_Communication_Report%>',
                    renderTo: 'content',
                    standardSubmit: true,
                    autoHeight:true,
					frame: true,
                    cls: 'mainpanelpercentage',
                    items: [innerPanel,InfoPanel, userGrid]
                });
            });
    </script>
  </div>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
