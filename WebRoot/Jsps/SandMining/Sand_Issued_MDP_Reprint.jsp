<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	Properties properties = ApplicationListener.prop;
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
	session.setAttribute("loginInfoDetails",loginInfo);
	
}
	CommonFunctions cf = new CommonFunctions();
	Date date=new Date();
	SimpleDateFormat simpleDateFormatddMMYY1 = new SimpleDateFormat("dd/MM/yyyy");
	String validF=simpleDateFormatddMMYY1.format(date);
	validF=validF+"08:00:00";
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
	
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("SLNO");
tobeConverted.add("UniqueId_No");
tobeConverted.add("Consumer_Application_No");
tobeConverted.add("MDP_No");
tobeConverted.add("Vehicle_No");
tobeConverted.add("Validity_Period");
tobeConverted.add("Transporter_Name");
tobeConverted.add("Customer_Name");
tobeConverted.add("Driver_Name");
tobeConverted.add("Transporter");
tobeConverted.add("ML_No");
tobeConverted.add("Customer_Address");
tobeConverted.add("District");
tobeConverted.add("Quantity");
tobeConverted.add("Via_Route");
tobeConverted.add("To_Place");
tobeConverted.add("Sand_Port_No");
tobeConverted.add("Sand_Port_Unique_No");
tobeConverted.add("Valid_From");
tobeConverted.add("Valid_To");
tobeConverted.add("Mineral_Type");
tobeConverted.add("Loading_Type");
tobeConverted.add("Survey_No");
tobeConverted.add("Village");
tobeConverted.add("Taluka");
tobeConverted.add("Amount_CubicMeter");
tobeConverted.add("Processing_Fees");
tobeConverted.add("Total_Fee");
tobeConverted.add("Printed");
tobeConverted.add("MDP_Date");
tobeConverted.add("DD_No");
tobeConverted.add("Bank_Name");
tobeConverted.add("DD_Date");
tobeConverted.add("Group_Id");
tobeConverted.add("Group_Name");
tobeConverted.add("Index_No");
tobeConverted.add("Sand_Loading_From_Time");
tobeConverted.add("Sand_Loading_To_Time");
tobeConverted.add("Select_Consumer_Application_No");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Add");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Cancel");
tobeConverted.add("Save");
tobeConverted.add("select_vehicle_No");
tobeConverted.add("Select_Sand_Port");
tobeConverted.add("Select_To_Place");
tobeConverted.add("Select_Loading_Type");
tobeConverted.add("Modify");
tobeConverted.add("PDF");
tobeConverted.add("Excel");
tobeConverted.add("Consumer_MDP_Generator");
tobeConverted.add("From_Sand_Port");
tobeConverted.add("Contact_No");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SLNO=convertedWords.get(0);
String UniqueId_No=convertedWords.get(1);
String Consumer_Application_No=convertedWords.get(2);
String MDP_No=convertedWords.get(3);
String Vehicle_No=convertedWords.get(4);
String Validity_Period=convertedWords.get(5);
String Transporter_Name=convertedWords.get(6);
String Customer_Name=convertedWords.get(7);
String Driver_Name=convertedWords.get(8);
String Transporter=convertedWords.get(9);
String ML_No=convertedWords.get(10);
String Customer_Address=convertedWords.get(11);
String District=convertedWords.get(12);
String Quantity=convertedWords.get(13);
String Via_Route=convertedWords.get(14);
String To_Place=convertedWords.get(15);
String Sand_Port_No=convertedWords.get(16);
String Sand_Port_Unique_No=convertedWords.get(17);
String Valid_From=convertedWords.get(18);
String Valid_To=convertedWords.get(19);
String Mineral_Type=convertedWords.get(20);
String Loading_Type=convertedWords.get(21);
String Survey_No=convertedWords.get(22);
String Village=convertedWords.get(23);
String Taluka=convertedWords.get(24);
String Amount_CubicMeter=convertedWords.get(25);
String Processing_Fees=convertedWords.get(26);
String Total_Fee=convertedWords.get(27);
String Printed=convertedWords.get(28);
String MDP_Date=convertedWords.get(29);
String DD_No=convertedWords.get(30);
String Bank_Name=convertedWords.get(31);
String DD_Date=convertedWords.get(32);
String Group_Id=convertedWords.get(33);
String Group_Name=convertedWords.get(34);
String Index_No=convertedWords.get(35);
String Sand_Loading_From_Time=convertedWords.get(36);
String Sand_Loading_To_Time=convertedWords.get(37);
String Select_Consumer_Application_No=convertedWords.get(38);
String No_Records_Found=convertedWords.get(39);
String Clear_Filter_Data=convertedWords.get(40);
String Add=convertedWords.get(41);
String No_Rows_Selected=convertedWords.get(42);
String Select_Single_Row=convertedWords.get(43);
String Cancel=convertedWords.get(44);
String Save=convertedWords.get(45);
String select_vehicle_No=convertedWords.get(46);
String Select_Sand_Port=convertedWords.get(47);
String Select_To_Place=convertedWords.get(48);
String Select_Loading_Type=convertedWords.get(49);
String Modify=convertedWords.get(50);
String PDF=convertedWords.get(51);
String Excel=convertedWords.get(52);
String Consumer_MDP_Generator=convertedWords.get(53);
String From_Sand_Port=convertedWords.get(54);
String Distance="Distance";
String Contact_No = convertedWords.get(55);


%>

<jsp:include page="../Common/header.jsp" />
 		<title>Issued MDP Reprint</title>	
   
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>

    <%if(loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
	<%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
		<style>	
				.x-panel-header
				{
					height: 7% !important;
				}
				.x-grid3-cell-inner,.ext-strict .x-grid3-hd-inner {
					height: 26px !important;
					padding-top: 8px;
				}				
				.ext-strict .x-form-text {
					height: 21px !important;
				}
				.x-layer ul {
					min-height: 27px !important;
				}
				label {
					display : inline !important;
				}
		  </style>  
         
	
  <script>
   
   var setLocation="false";
var outerPanel;
var ctsb;
var jspname = "Issued_MDP_Reprint";
var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var dtcur = datecur;
var dtnext=datenext;
var custname="";
var mdpNoModify 
var permitNoModify;
var transporterModify;
var loadingTypeModify; 
var surveyNoModify;
var villageModify; 
var talukModify; 
var districtModify;
var quantityModify; 
var amountModify; 
var totalFeeModify; 
var fromPlaceModify; 
var toPlaceModify;
var sandPortNoModify; 
var sandPortUniqueIdModify; 
var validFromModify;
var validToModify; 
var customerNameModify ;
var driverNameModify ;
var viaRouteModify ;
var mineralTypeModify;
var vehicleNoModify;
var SandLoadingFromTimeModify;
var SandLoadingToTimeModify;
var applicationNoModify;
var transporter ;
var vehicleNo;
var customerAddress;
var todaysDate = new Date();
var uniqueIdModify;
var validityPeriodModify;
var MlNoModify;
var processingFeeModify;
var vehicleAddrModify;
var printedModify;
var TSDateModify;
var DDNoModify;
var bankNameModify;
var DDDateModify;
var groupIdModify ;
var groupNameModify;
var indexNoModify;
var mineralTypeModify;
var DD_NoNew;
var DD_Date;
var Bank_Name;
var DD_Date;
var groupId;
var groupName;
var ValidFromNew;
var DailyOff1;
var ValidToNew;
var DailyOff2;
var TSFormatNew;
var LoadCapacityNew;
var LoadTypeNew;
var SelfAmountNew;
var MachineAmountNew;
var DefaultLoadType;
var TripSheetFormat;
var SandLoadingFromTime;
var SandLoadingToTime;
var messageQuant="";  
var startdate = "";    
var ts="";  
var uniqueID="";
//var availableSand=0;
var assessedquantity="";
var rate="";
var sandportUniqueidModify="";
var extractionTypeModify="";
var stockyardUID="";
var fromPlaceAdd="";
var distance;
var stockyardlat;
var stockyardlong;
var lat;
var longi;
var longitude;
var latitude;      
var destlatlong;
var myDate = new Date();
myDate.setHours(myDate.getHours() + 24);
var nxtdate=nextDate;
nxtdate.setHours(23);
nxtdate.setMinutes(59);
nxtdate.setSeconds(59);
var previousDate = new Date().add(Date.DAY, -1);
previousDate.setHours(23);
previousDate.setMinutes(59);
previousDate.setSeconds(59);

var curdate=datecur;

var clientcombostore = new Ext.data.JsonStore({
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
                custname= Ext.getCmp('custcomboId').getRawValue();
                //store.load({
                //params:{ClientId: custId,
                //        jspname:jspname,
                //        custname:custname}
                //});
		        //PermitStoreNew.load({params:{clientId:custId}});
		        //FromSandPortStore.load({params:{clientId:custId}});
		       // ToPlaceStore.load({params:{clientId:custId}});
               // ApplicationNoStore.load({params:{clientId:custId}});
               // fromStockyardStore.load({params:{clientId:custId}});
               TPOwnerStoreNew.load({params:{clientId:custId}});
            }
        }
    }
});

  var startdate = new Ext.form.DateField({
            fieldLabel: '',
            cls: 'selectstyle',
            format: getDateFormat(),
            emptyText: '',
            allowBlank: false,
            blankText: '',
            submitFormat: getDateFormat(),
            labelSeparator: '',
            allowBlank: false,
            id: 'startdate',
            value: curdate
          //  maxValue: dtprev,
            //vtype: 'daterange',
          //  endDateField: 'enddate'

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
                custname= Ext.getCmp('custcomboId').getRawValue();
				//store.load({params:{ClientId: custId,
				//        jspname:jspname,
                //        custname:custname}});
		        //PermitStoreNew.load({params:{clientId:custId}});
		        //FromSandPortStore.load({params:{clientId:custId}});
		       // ToPlaceStore.load({params:{clientId:custId}});
		      //vehicleNoStore.load({params:{clientId: custId}});
		      //ApplicationNoStore.load({params:{clientId:custId}});
		      //	fromStockyardStore.load({params:{clientId:custId}});
		      TPOwnerStoreNew.load({params:{clientId:custId}});
            }
        }
    }
});


var TPOwnerStoreNew= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/Issue_MDP_ReprintAction.do?param=getIssueReprintNewGRID',
				   id:'TPOwnerStoreNewId',
			       root: 'TPOwnerstoreNewList',
			       autoLoad: true,
			       remoteSort:true,
				   fields: ['IssueTPIDNoNew','TemporaryPermitNoNew']
			     });
	
var TPOwnerComboNew=new Ext.form.ComboBox({
				  frame:true,
				  store: TPOwnerStoreNew,
				  id:'TPOwnerComboNewId',
				  width: 175,
				  forceSelection:true,
				  
				  emptyText:'Select TP Owner Name',
				  anyMatch:true,
	              onTypeAhead:true,
				  enableKeyEvents:true,
				  mode: 'local',
				  triggerAction: 'all',
				  displayField: 'TemporaryPermitNoNew',
				  valueField: 'TemporaryPermitNoNew',
				  cls: 'selectstylePerfect',
				  listeners: {
		                select: {
		                 	 fn:function(){ 
		                 		
							 
		                 	
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
            id:'clientlabelid'
        },
        Client,{width:20},        
        	{
                  xtype: 'label',
                  text: 'Tp Owner name' + ' :',
                  cls: 'labelstyle',
                  id: 'tpOwnerNameId'
              },TPOwnerComboNew,
		{width:40},
		{ xtype: 'label',
            text: 'Date' + ' :',
            cls: 'labelstyle'},startdate,{width:25},
		{xtype:'button',
						text: 'View',
						width:70,
						listeners: {
						click: {fn:function(){
						
						if(Ext.getCmp('custcomboId').getValue()=="")
                       {
                             Ext.example.msg("Select Customer");
                             return;
                       }
						 if(Ext.getCmp('TPOwnerComboNewId').getValue()=="")
                       {
                             Ext.example.msg("Select TP Owner Name");
                             return;
                       }
                        if(Ext.getCmp('startdate').getValue()=="")
                       {
                             Ext.example.msg("Select Date");
                             return;
                       }                      
						
                       store.load({
                            params:{ClientId: custId,
				        	jspname:jspname,
				        	tpOwner:Ext.getCmp('TPOwnerComboNewId').getValue(),
				        	startDate:Ext.getCmp('startdate').getValue(),
                        	custname:custname}
                        });
                        
                        
           	}
						}}}                 
    ]
});





var reader = new Ext.data.JsonReader({
	idProperty: 'mdpGeneratorid',
    root: 'viewRoot',
    totalProperty: 'total',
    fields: [
    		{name:'slnoId'},
    		{name:'vehicleNumber'},
    		{name:'tempPermitNumber'},
			{name:'IOdistrict'},
			{name:'leaseNumber'},
			{name:'leaseName'},
			{name:'permitNumber'},
			{name:'tripSheetCodeNumber'},
			{name:'barCodeNumber'},
			{name:'typeOfLand'},
    		{name:'validFrom'},
    		{name:'validTo'},
			{name:'buyer'},
			{name:'talukDistrict'},
			{name:'quantity'},
			{name:'royalty'},
			{name:'processingFees'},
			{name:'sourcePlace'},
			{name:'destinationPlace'},			
			{name:'distanceindex'},
			{name:'route'}

	        ] // END OF Fields
}); // End of Reader

 var store  = new Ext.data.GroupingStore({
     url:'<%=request.getContextPath()%>/Issue_MDP_ReprintAction.do?param=getViewDetailsGRID',
     bufferSize: 367,
     reader: reader,
     autoLoad: false,
     remoteSort:true
   });


var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters:[
        {dataIndex:'slnoId', type:'numeric'},
        {dataIndex:'vehicleNumber', type:'string'},
        {dataIndex:'tempPermitNumber', type:'string'},
		{dataIndex:'IOdistrict', type:'string'},
		{dataIndex:'leaseNumber', type:'numeric'},
		{dataIndex:'leaseName', type:'string'},
		{dataIndex:'permitNumber', type:'string'},
		{dataIndex:'tripSheetCodeNumber', type:'numeric'},
		{dataIndex:'barCodeNumber', type:'numeric'},
		{dataIndex:'typeOfLand', type:'string'},
		{dataIndex:'validFrom', type:'date'},
		{dataIndex:'validTo', type:'date'},
		{dataIndex:'buyer', type:'string'},
		{dataIndex:'talukDistrict', type:'string'},
		{dataIndex:'quantity', type:'string'},
		{dataIndex:'royalty', type:'string'},
		{dataIndex:'processingFees', type:'string'},
		{dataIndex:'sourcePlace', type:'string'},
		{dataIndex:'destinationPlace', type:'string'},
		{dataIndex:'distanceindex', type:'string'},
		{dataIndex:'route', type:'string'}

		]
});

var createColModel =function(finish, start) {
    var columns = 
     [new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            dataIndex: 'slnoId',
            hidden:true,
        	sortable: true,
        	//hideable: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            filter: {
                type: 'numeric'
            }
        },{
            dataIndex: 'vehicleNumber',
            hidden:false,
            width: 150,
            header: "<span style=font-weight:bold;>Vehicle Number</span>",
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Temporary Permit Number</span>",
            dataIndex: 'tempPermitNumber',
            hidden: false,
            width: 150,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>District(Inside/Outside)</span>",
            dataIndex: 'IOdistrict',
            hidden: false,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Lease Number</span>",
            dataIndex: 'leaseNumber',
            hidden: false,
            width: 150,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Lease Name</span>",
            dataIndex: 'leaseName',
            hidden: false,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>MDP Number</span>",
            dataIndex: 'permitNumber',
            hidden: false,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Tripsheet Code Number</span>",
            sortable : true,
            dataIndex: 'tripSheetCodeNumber',
            hidden: false,
            width: 150,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Barcode Number</span>",
            dataIndex: 'barCodeNumber',
            hidden: false,
            width: 150,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>River Name</span>",
            dataIndex: 'typeOfLand',
            hidden: false,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Valid From</span>",
            dataIndex: 'validFrom',
           	hidden: false,
            width: 150,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;>Valid To</span>",
            dataIndex: 'validTo',
           	hidden: false,
            width: 150,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;>Buyer</span>",
            dataIndex: 'buyer',
           	hidden: false,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Taluk</span>",
            dataIndex: 'talukDistrict',
           	hidden: false,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Quantity(Tons)</span>",
            dataIndex: 'quantity',
           	hidden: false,
        	sortable: true,
        	//hideable: true,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Royalty</span>",
            dataIndex: 'royalty',
           	hidden: false,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Processing Fees</span>",
            dataIndex: 'processingFees',
           	hidden: false,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Loading Place</span>",
            dataIndex: 'sourcePlace',
           	hidden: false,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Destination Place</span>",
            dataIndex: 'destinationPlace',
           	hidden: false,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Distance(Kms)</span>",
            dataIndex: 'distanceindex',
           	hidden: false,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Route</span>",
            dataIndex: 'route',
           	hidden: false,
            width: 150,
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

function PrintPDF()
{      
         var globalClientId = Ext.getCmp('custcomboId').getValue();
         var selection= grid.getSelectionModel();
         if(selection.getCount()>1)
         {
         	Ext.example.msg("Select Single Row");
			return;
         }
         			    if (grid.getSelectionModel().getCount() == 1)
            {
            var selected = grid.getSelectionModel().getSelected();
            var row = grid.store.findExact('slnoId', selected.get('slnoId'));
            var store = grid.store.getAt(row);
            var json = Ext.util.JSON.encode(store.data);
										
			window.open("<%=request.getContextPath()%>/Sand_Mining_MDP_Reprint_PDF?systemId=" + <%= systemId %> +"&clientId=" + globalClientId +  "&Json=" + json);			
<!--		Ext.Ajax.request({-->
<!--         url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getPDFFileType',-->
<!--             method: 'POST',-->
<!--              params: {-->
<!--                       systemId:<%=systemId%>-->
<!--                     },-->
<!--                	success:function(response, options)-->
<!--                   {-->
<!--                   	if(response.responseText=="D")  // It refers to Type="D"-->
<!--             		{-->
<!--             		    window.open("<%=request.getContextPath()%>/Sand_Mining_MDP_Reprint_PDF?systemId=" + <%= systemId %> +"&clientId=" + globalClientId +  "&Json=" + json);-->
<!--             		}-->
<!--             	   }, // end of success-->
<!--            		failure: function(response, options)-->
<!--                    {-->
<!--                      Ext.example.msg("ERROR WHILE PROCESSING")-->
<!--                    }// end of failure-->
<!--                   -->
<!--                  }); -->
 				}
  
}

//*****************************************************************Grid *******************************************************************************
grid = getSandPermitGrid('Issue MDP Reprint', '<%=No_Records_Found%>', store, screen.width - 32, 420, 45, filters, '<%=Clear_Filter_Data%>', false, '',20, false, '', false, '', false, '<%=Excel%>', jspname, exportDataType, false, '<%=PDF%>', false, '<%=Add%>', false, '<%=Modify%>', true, 'Print MDP');
//******************************************************************************************************************************************************

Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'Issued MDP Reprint',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 22,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerComboPanel,grid]
    });
    sb = Ext.getCmp('form-statusbar');
    if(<%=customerId%> > 0)
    {
    //Ext.getCmp('clientlabelid').hide();
    //Ext.getCmp('custcomboId').hide();
    //Ext.getCmp('setLocationId').disable();
    }
    var cm = grid.getColumnModel();  
    for (var j = 1; j < cm.getColumnCount(); j++) {
       cm.setColumnWidth(j,150);
    }
});
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
   