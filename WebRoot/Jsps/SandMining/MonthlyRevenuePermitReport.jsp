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

String CustomerName;
lwb=(LanguageWordsBean)langConverted.get("Customer_Name");
if(language.equals("ar")){
	CustomerName=lwb.getArabicWord();
}else{
	CustomerName=lwb.getEnglishWord();
}
System.out.println(CustomerName);
lwb=null;

String selectstartdate;
lwb=(LanguageWordsBean)langConverted.get("Start_Date");
if(language.equals("ar")){
	selectstartdate=lwb.getArabicWord();
}else{
	selectstartdate=lwb.getEnglishWord();
}
lwb=null;

String selectenddate;
lwb=(LanguageWordsBean)langConverted.get("End_Date");
if(language.equals("ar")){
	selectenddate=lwb.getArabicWord();
}else{
	selectenddate=lwb.getEnglishWord();
}
lwb=null;

String SelectCustomer;
lwb=(LanguageWordsBean)langConverted.get("Select_Customer");
if(language.equals("ar")){
	SelectCustomer=lwb.getArabicWord();
}else{
	SelectCustomer=lwb.getEnglishWord();
}
lwb=null;



String Pleaseselectcustomer;
lwb=(LanguageWordsBean)langConverted.get("Select_Customer");
if(language.equals("ar")){
	Pleaseselectcustomer=lwb.getArabicWord();
}else{
	Pleaseselectcustomer=lwb.getEnglishWord();
}
lwb=null;


String Pleaseselectstartdate;
lwb=(LanguageWordsBean)langConverted.get("Select_Start_Date");
if(language.equals("ar")){
	Pleaseselectstartdate=lwb.getArabicWord();
}else{
	Pleaseselectstartdate=lwb.getEnglishWord();
}
lwb=null;


String MonthlyRevenueGenerationReport="Monthly Revenue & Permit Report";

String Pleaseselectenddate;
lwb=(LanguageWordsBean)langConverted.get("Select_End_Date");
if(language.equals("ar")){
	Pleaseselectenddate=lwb.getArabicWord();
}else{
	Pleaseselectenddate=lwb.getEnglishWord();
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

String SLNO;
lwb=(LanguageWordsBean)langConverted.get("SLNO");
if(language.equals("ar")){
	SLNO=lwb.getArabicWord();
}else{
	SLNO=lwb.getEnglishWord();
}
lwb=null;

String AssetNO;
lwb=(LanguageWordsBean)langConverted.get("Asset_No");
if(language.equals("ar")){
	AssetNO=lwb.getArabicWord();
}else{
	AssetNO=lwb.getEnglishWord();
}
lwb=null;

String SandBlockName;
lwb=(LanguageWordsBean)langConverted.get("Sand_Block_Name");
if(language.equals("ar")){
	SandBlockName=lwb.getArabicWord();
}else{
	SandBlockName=lwb.getEnglishWord();
}
lwb=null;


String ArrivingDateTime;
lwb=(LanguageWordsBean)langConverted.get("Arriving_Date_Time");
if(language.equals("ar")){
	ArrivingDateTime=lwb.getArabicWord();
}else{
	ArrivingDateTime=lwb.getEnglishWord();
}
lwb=null;




String Excel=cf.getLabelFromDB("Excel",language);
//String monthValidation=cf.getLabelFromDB("Month_Validation",language);
langConverted=null;
%>




<jsp:include page="../Common/header.jsp" />
<style>
.mystyle1{
margin-left:10px;
}
</style>


        <title><%=MonthlyRevenueGenerationReport%></title>

    
    <div height="100%" background-color: "#ffffff">
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
					height : 38px !important;
				}
				.x-layer ul {
					min-height: 27px !important;
				}					
				.x-menu-list {
					height: auto !important;
				}
				
			</style>
		<%}%>
        
    <script type="text/javascript" src="../../Main/Js/jsapi.js"></script>
   	<script>
    google.load("visualization", "1", {packages:["corechart"]});
        var outerPanel;
        var jspName = "MonthlyRevenuePermitReport";
        var exportDataType = "int,string,string,string,string";
        var dtcur = datecur;
        var dtprev = dateprev;
		var startdatepassed=new Date();
		var enddatepassed=new Date();
        var customercombostore = new Ext.data.JsonStore({
            url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
            id: 'CustomerStoreId',
            root: 'CustomerRoot',
            autoLoad: true,
            remoteSort: true,
            fields: ['CustId', 'CustName'],
            listeners: {
                load: function (custstore, records, success, options) {
                    if ( <%= customeridlogged %> > 0) {
                        Ext.getCmp('CustomerNameId').setValue('<%=customeridlogged%>');
                        groupcombostore.load({params:{CustId:Ext.getCmp('CustomerNameId').getValue()}});
                    }
                }
            }
        });
         //**************************** Combo for Customer Name***************************************************
        var CustomerName = new Ext.form.ComboBox({
            store: customercombostore,
            id: 'CustomerNameId',
            mode: 'local',
            hidden: false,
            resizable: true,
            forceSelection: true,
            emptyText: '',
            blankText: '',
            width:'100%',
            selectOnFocus: true,
            allowBlank: false,
            typeAhead: true,
            triggerAction: 'all',
            lazyRender: true,
            valueField: 'CustId',
            displayField: 'CustName',
            cls: 'sandselectstyle',
            listeners: {
                select: {
                    fn: function () {
						groupcombostore.load({params:{CustId:Ext.getCmp('CustomerNameId').getValue()}});
                    }
                }
            }
        });
        
         var groupcombostore = new Ext.data.JsonStore({
            url: '<%=request.getContextPath()%>/CommonAction.do?param=getGroupIncludingAllOption',
            id: 'GroupStoreId',
            root: 'GroupRoot',
            autoLoad: true,
            remoteSort: true,
            fields: ['GroupId', 'GroupName'],
            listeners: {
            }
        });
        
        //**************************** Combo for Customer Name***************************************************
        var SubDivision = new Ext.form.ComboBox({
            store: groupcombostore,
            id: 'subDivisionId',
            mode: 'local',
            hidden: false,
            resizable: true,
            forceSelection: true,
            width:'100%',
            selectOnFocus: true,
            allowBlank: false,
            typeAhead: true,
            triggerAction: 'all',
            lazyRender: true,
            valueField: 'GroupId',
            displayField: 'GroupName',
            cls: 'sandselectstyle',
            listeners: {
                select: {
                    fn: function () {

                    }
                }
            }
        });
        
        //***************************************************** Months Store***********************************************************
        var monthliststore =new Ext.data.SimpleStore({
        id:'monthlistId',
        autoLoad:true,
        fields:['MonthId','MonthName'],
        data:[
        		['1','Januvary'],
        		['2','Februvary'],
        		['3','March'],
        		['4','April'],
        		['5','May'],
        		['6','June'],
        		['7','July'],
        		['8','August'],
        		['9','September'],
        		['10','October'],
        		['11','November'],
        		['12','December']
        ]
        });

		//********************************************Combo for Months**************************************************************
		var monthListCombo = new Ext.form.ComboBox({
            store: monthliststore,
            id: 'monthlistId',
            mode: 'local',
            hidden: false,
            resizable: true,
            forceSelection: true,
            selectOnFocus: true,
            allowBlank: false,
            disabled:true,
            typeAhead: true,
            triggerAction: 'all',
            lazyRender: true,
            valueField: 'MonthId',
            value:getcurrentMonth(),
            displayField: 'MonthName',
            cls: 'sandselectstyle',
            listeners: {
                select: {
                    fn: function () {
					startdatepassed=getStartDate(Ext.getCmp('monthlistId').getValue(),Ext.getCmp('yearlistId').getValue());
					enddatepassed=getEndDate(Ext.getCmp('monthlistId').getValue(),Ext.getCmp('yearlistId').getValue());
                    }
                }
            }
        });
        
        //*******************************************************Year Store**********************************************************
        var yearliststore =new Ext.data.SimpleStore({
        id:'yearlistId',
        autoLoad:true,
        fields:['yearId','yearName'],
        data:[
        		['2010','2010'],
        		['2011','2011'],
        		['2012','2012'],
        		['2013','2013'],
        		['2014','2014'],
        		['2015','2015'],
        		['2016','2016'],
        		['2017','2017'],
        		['2018','2018']
        ]
        });
        
        //********************************************Combo for Year**************************************************************
		var yearListCombo = new Ext.form.ComboBox({
            store: yearliststore,
            id: 'yearlistId',
            mode: 'local',
            hidden: false,
            resizable: true,
            disabled:true,
            forceSelection: true,
            selectOnFocus: true,
            allowBlank: false,
            typeAhead: true,
            triggerAction: 'all',
            lazyRender: true,
            value:getcurrentYear(),
            valueField: 'yearId',
            displayField: 'yearName',
            cls: 'sandselectstyle',
            listeners: {
                select: {
                    fn: function () {
					startdatepassed=getStartDate(Ext.getCmp('monthlistId').getValue(),Ext.getCmp('yearlistId').getValue());
					enddatepassed=getEndDate(Ext.getCmp('monthlistId').getValue(),Ext.getCmp('yearlistId').getValue());
                    }
                }
            }
        });
        
       //******************************** Chart Type*********************************************************
      var charttypestore =new Ext.data.SimpleStore({
        id:'charttypeId',
        autoLoad:true,
        fields:['charttype'],
        data:[
        		['Pie Chart'],
        		['Bar Chart']
        ]
        });

	var chartCombo = new Ext.form.ComboBox({
            store: charttypestore,
            id: 'charttypeId',
            mode: 'local',
            hidden: false,
            resizable: true,
            forceSelection: true,
            value: 'Pie Chart',
            selectOnFocus: true,
            allowBlank: false,
            typeAhead: true,
            triggerAction: 'all',
            lazyRender: true,
            valueField: 'charttype',
            displayField: 'charttype',
            cls: 'sandselectstyle',
            listeners: {
                select: {
                    fn: function () {
                    if(this.getValue()=='Bar Chart')
                    {
						Ext.getCmp('revenuechartid').update('<table width="100%"><tr><tr> <td> <div id="revenuechartdiv" align="left"> </div></td></tr></table>');
                    	Ext.getCmp('permitchartid').update('<table width="100%"><tr><tr> <td> <div id="permitchartdiv" align="left"> </div></td></tr></table>');
                    barChart();
                    }
                     if(this.getValue()=='Pie Chart')
                    {
						Ext.getCmp('revenuechartid').update('<table width="100%"><tr><tr> <td> <div id="revenuechartdiv" align="left"> </div></td></tr></table>');
                    	Ext.getCmp('permitchartid').update('<table width="100%"><tr><tr> <td> <div id="permitchartdiv" align="left"> </div></td></tr></table>');
                    pieChart();
                    }
                    }
                }
            }
        });

        var reader = new Ext.data.JsonReader({
            idProperty: 'darreaderid',
            root: 'MonthlyRevenueReport',
            totalProperty: 'total',
            fields: [{
                name: 'slnoIndex'
            }, {
                name: 'subdivisionIndex'
            }, {
                name: 'sandblockIndex'
            }, {
                name: 'revenueIndex'
            }, {
                name: 'permitIndex'
            }]
        });

         //***************************************Store Config*****************************************
        var store = new Ext.data.GroupingStore({
            autoLoad: false,
            proxy: new Ext.data.HttpProxy({
                url: '<%=request.getContextPath()%>/SandMiningAction.do?param=getMonthlyRevenuePermitReport',
                method: 'POST'
            }),

            storeId: 'MonthlyRevenueReportId',
            reader: reader
        });

         //**********************Filter Config****************************************************
        var filters = new Ext.ux.grid.GridFilters({
            local: true,
            filters: [{
                type: 'numeric',
                dataIndex: 'slnoIndex'
            }, {
                type: 'string',
                dataIndex: 'subdivisionIndex'
            }, {
                type: 'string',
                dataIndex: 'sandblockIndex'
            }, {
                type: 'float',
                dataIndex: 'revenueIndex'
            } , {
                type: 'int',
                dataIndex: 'permitIndex'
            }]
        });

         //************************************Column Model Config******************************************
        var createColModel = function (finish, start) {

            var columns = [
                new Ext.grid.RowNumberer({
                    header: "<span style=font-weight:bold;><%=SLNO%></span>",
                    width:50,
                }), {
                    dataIndex: 'slnoIndex',
                    hidden: true,
                    header: "<span style=font-weight:bold;><%=SLNO%></span>",
                    width:100,
                    filter: {
                        type: 'numeric'
                    }
                }, {
                    dataIndex: 'subdivisionIndex',
                    header: "<span style=font-weight:bold;>Sub Division</span>",
                    width:100,
                    filter: {
                        type: 'string'
                    }
                }, {
                    dataIndex: 'sandblockIndex',
                    header: "<span style=font-weight:bold;>Sand Block Name</span>",
                    width:100,
                    filter: {
                        type: 'string'
                    }
                }, {
                    dataIndex: 'revenueIndex',
                    renderer: Ext.util.Format.numberRenderer('0.00'),
                    header: "<span style=font-weight:bold;>Revenue</span>",
                    width:100,
                    filter: {
                        type: 'float'
                    }
                }, {
                    dataIndex: 'permitIndex',
                    header: "<span style=font-weight:bold;>Permit</span>",
                    width:100,
                    filter: {
                        type: 'int'
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

         //*******************************************Grid Panel Config***************************************

        var grid = getGrid('', '<%=NoRecordsFound%>', store, screen.width-35,360, 6, filters, '<%=ClearFilterData%>', true, '<%=ReconfigureGrid%>', 10, true, '<%=ClearGrouping%>', false, '', true, '<%=Excel%>', jspName, exportDataType, false, '');


		function getStartDate(month,year)
		{
			var startdate = new Date();
			startdate.setDate(01);
			startdate.setMonth(month-1);
			startdate.setYear(year);
			startdate.setHours(0,0,0,0);
			
			return startdate;
		}
		
		function getEndDate(month,year)
		{
			if(month==12)
			{
			year=parseInt(year)+1;
			}
			var enddate = new Date();
			enddate.setDate(01);
			enddate.setMonth(month);
			enddate.setYear(year);
			enddate.setHours(0,0,0,0);
			
			return enddate;
		}


		function getcurrentMonth()
		{
			var currentdate=new Date();
			return parseInt(currentdate.getMonth())+1;
		}
		
		function getcurrentYear()
		{
			var currentdate=new Date();
			return currentdate.getFullYear();
		}
		
		
		function getWeek(date)
		{
		var first = date.getDate() - date.getDay(); // First day is the day of the month - the day of the week
		var last = first + 7; // last day is the first day + 6

		var firstday = new Date(date.setDate(first));
		var lastday = new Date(date.setDate(last));
		startdatepassed=firstday;
		enddatepassed=lastday;
		//var weeknumber=22;
		//Ext.getCmp('weekdate').setValue(weeknumber);
		}
		function pieChart() {        	
  									var data = new google.visualization.DataTable();
  									var subdivision='';
  									var prevsubdivision=false;
  									var amount=0;
									data.addColumn('string', 'Sub Division');
									data.addColumn('number', 'Revenue'); 
									data.addRows(store.getCount());
									for  (var i = 0; i < store.getCount(); i++){
									var rec = store.getAt(i);
									subdivision=rec.data['subdivisionIndex'];
									if(store.getCount()!=1 && i!=store.getCount()-1 && subdivision==store.getAt(i+1).data['subdivisionIndex'])
									{
									amount=parseFloat(amount)+parseFloat(rec.data['revenueIndex']);
									continue;
									}
									else if(store.getCount()!=1 && i==store.getCount()-1 && subdivision==store.getAt(i-1).data['subdivisionIndex'])
									{
									amount=parseFloat(amount)+parseFloat(rec.data['revenueIndex']);
									}
									else
									{
									prevsubdivision=rec.data['subdivisionIndex'];
									amount=parseFloat(amount)+parseFloat(rec.data['revenueIndex']);
									}
									prevsubdivision=false;								
  									data.setCell(i,0,subdivision);
  									data.setCell(i,1,Math.round(amount)*1);
  									amount=0;
									}
  									var revenuegraph=new google.visualization.PieChart(document.getElementById('revenuechartdiv'));
  									var options = {
  									title:'Revenue Chart',
  									titleTextStyle:{color:'#686262',fontSize:13,align:'center'},
          							pieSliceText: "value",
          							forceIFrame: true,
          							width:400,
          							backgroundColor: '#E4E4E4',         							
          							height:350,
          							legend:{position: 'bottom'},
          							//colors:['#61D961','#5757FE','#BDBDBD'],
        							};
      								revenuegraph.draw(data,options);
      							 //google.visualization.events.addListener(vehiclestatusgraph, 'select', selectHandler);
                   				
                   				
                   					var permitdata = new google.visualization.DataTable();
  									var permitsubdivision='';
  									var permit=0;
									permitdata.addColumn('string', 'Sub Division');
									permitdata.addColumn('number', 'Revenue'); 
									permitdata.addRows(store.getCount());
									for  (var i = 0; i < store.getCount(); i++){
									var rec = store.getAt(i);
									permitsubdivision=rec.data['subdivisionIndex'];
									if(store.getCount()!=1 && i!=store.getCount()-1 && permitsubdivision==store.getAt(i+1).data['subdivisionIndex'])
									{
									permit=parseInt(permit)+parseInt(rec.data['permitIndex']);
									continue;
									}
									else if(store.getCount()!=1 && i==store.getCount()-1 && permitsubdivision==store.getAt(i-1).data['subdivisionIndex'])
									{
									permit=parseInt(permit)+parseInt(rec.data['permitIndex']);
									}
									else
									{
									permit=parseInt(permit)+parseInt(rec.data['permitIndex']);
									}
									prevsubdivision=false;									
  									permitdata.setCell(i,0,permitsubdivision);
  									permitdata.setCell(i,1,Math.round(permit)*1);
  									permit=0;
									}
  									var permitgraph=new google.visualization.PieChart(document.getElementById('permitchartdiv'));
  									var permitoptions = {
  									title:'Permit Chart',
  									titleTextStyle:{color:'#686262',fontSize:13,align:'center'},
          							pieSliceText: "value",
          							forceIFrame: true,
          							width:400,
          							height:350,
          							backgroundColor: '#E4E4E4',         							
          							legend:{position: 'bottom'},
          							//colors:['#61D961','#5757FE','#BDBDBD'],
        							};
      								permitgraph.draw(permitdata,permitoptions);
}


function barChart() {
			var barchartrevenuegraph = new google.visualization.ColumnChart(document.getElementById('revenuechartdiv'));
            var barchartrevenuedata = new google.visualization.DataTable();
            barchartrevenuedata.addColumn('string', 'Count');
            barchartrevenuedata.addColumn('number', 'Revenue(Rs)');
            var rowdata = new Array();
            var revenuesubdivision='';
            var count=0;
  			var revenue=0;
			for  (var i = 0; i < store.getCount(); i++){
				var rec = store.getAt(i);
				revenuesubdivision=rec.data['subdivisionIndex'];
					if(store.getCount()!=1 && i!=store.getCount()-1 && revenuesubdivision==store.getAt(i+1).data['subdivisionIndex'])
						{
							revenue=parseFloat(revenue)+parseFloat(rec.data['revenueIndex']);
							continue;
						}
					else if(store.getCount()!=1 && i==store.getCount()-1 && revenuesubdivision==store.getAt(i-1).data['subdivisionIndex'])
						{
							revenue=parseFloat(revenue)+parseFloat(rec.data['revenueIndex']);
						}
					else
						{
							revenue=parseFloat(revenue)+parseFloat(rec.data['revenueIndex']);
						}
				rowdata.push(revenuesubdivision);
                rowdata.push(Math.round(revenue)*1);
                revenue=0;
                count++;
                }   
            barchartrevenuedata.addRows(count + 1);  
            var k = 0;
            var m=0;
            var n=0;
            for (i = 0; i < count; i++) {
                for (j = 0; j <= 1; j++) {
                rowdata[k];
                	var rec = store.getAt(i);
                    barchartrevenuedata.setCell(i, j, rowdata[k]);
                    k++;
                }
            }
            count=0;
			var options = {
                title: 'Revenue Chart',
                titleTextStyle: {
                    color: '#686262',
                    fontSize: 13
                },
                pieSliceText: "value",
                legend: {
                    position: 'bottom'
                },
                sliceVisibilityThreshold: 0,
                width:400,
                height: 350,
                backgroundColor: '#E4E4E4',                
                isStacked: true,
                hAxis:{title:'Sub Division',textStyle:{fontSize: 10},titleTextStyle: { italic: false}},
                vAxis:{title:'Revenue(Rs)',titleTextStyle: { italic: false} }
            };             
            barchartrevenuegraph.draw(barchartrevenuedata, options);  
            var barchartpermitgraph = new google.visualization.ColumnChart(document.getElementById('permitchartdiv'));
            var barchartpermitdata = new google.visualization.DataTable();
            barchartpermitdata.addColumn('string', 'Count');
            barchartpermitdata.addColumn('number', 'Permit');           
            var rowdata = new Array();
            var permitsubdivision='';
  			var permit=0;
			for  (var i = 0; i < store.getCount(); i++){
				var rec = store.getAt(i);
				permitsubdivision=rec.data['subdivisionIndex'];
					if(store.getCount()!=1 && i!=store.getCount()-1 && permitsubdivision==store.getAt(i+1).data['subdivisionIndex'])
						{
							permit=parseInt(permit)+parseInt(rec.data['permitIndex']);
							continue;
						}
					else if(store.getCount()!=1 && i==store.getCount()-1 && permitsubdivision==store.getAt(i-1).data['subdivisionIndex'])
						{
							permit=parseInt(permit)+parseInt(rec.data['permitIndex']);
						}
					else
						{
							permit=parseInt(permit)+parseInt(rec.data['permitIndex']);
						}	
				rowdata.push(permitsubdivision);
                rowdata.push(Math.round(permit)*1);
                permit=0;
                count++;
                }
                barchartpermitdata.addRows(count + 1);
            var k = 0;
            var m=0;
            var n=0;
            for (i = 0; i <=count; i++) {
                for (j = 0; j <= 1; j++) {
                rowdata[k];
                	var rec = store.getAt(i);
                    barchartpermitdata.setCell(i, j, rowdata[k]);
                    k++;
                }
            }
			var options = {
                title: 'Permit Chart',
                titleTextStyle: {
                    color: '#686262',
                    fontSize: 13
                },
                pieSliceText: "value",
                legend: {
                    position: 'bottom'
                },
                //colors: ['#4572A7', '#93A9CF'],
                sliceVisibilityThreshold: 0,
                width:400,
                height: 350,
                backgroundColor: '#E4E4E4',                
                isStacked: true,
                hAxis:{title:'Sub Division',textStyle:{fontSize: 10},titleTextStyle: { italic: false}},
                vAxis:{title:'Permit Count',titleTextStyle: { italic: false} }
            };
            barchartpermitgraph.draw(barchartpermitdata, options);
}


		
			 var gridPannel = new Ext.Panel({
                id:'gridpannelid',
                height: 370,
                frame: true,
                cls: 'gridpanelpercentage',
                layout: 'column',
            	layoutConfig: {
                columns: 2
            	},
                items:[
                		{
                		 xtype:'label',
                		 text:'',
	     				 id:'charttypetxtid',
	     				 cls: 'sandlblstyle',
	     				 border:false
       					},chartCombo,
                		{
                		 xtype:'panel',
	     				 id:'revenuechartid',
	     				 border:false,
	     				 height: 500,
       	 				 html : '<table width="100%"><tr><tr> <td> <div id="revenuechartdiv" align="left"> </div></td></tr></table>'
       					},
       					{
                		 xtype:'panel',
	     				 id:'permitchartid',
	     				 border:false,
	     				 height: 500,
       	 				 html : '<table width="100%"><tr><tr> <td> <div id="permitchartdiv" align="left"> </div></td></tr></table>'
       					}
                ]
            });	
		var monthlyRevenueTabs = new Ext.TabPanel({
	    resizeTabs: false, // turn off tab resizing
	    enableTabScroll: true,
	    activeTab: 'revenueGridTab',
	    id: 'mainTabPanelId',
	    height: 400,
	    width: screen.width-40,
	    listeners: {
	    	'tabchange': function(tabPanel, tab){
            	if(tab.id == 'graphTab'){
            	pieChart();
                }
             }
        }
	});

	addTab();

	function addTab() {
	   monthlyRevenueTabs.add({
	        title: 'Details',
	        iconCls: 'admintab',
	        id: 'revenueGridTab',
	        //width:'100%',
	        items: [grid]
	    }).show();

	   monthlyRevenueTabs.add({
	        title: 'Graph',
	        iconCls: 'admintab',
	        autoScroll: true,
	        id: 'graphTab',
	        items:[gridPannel]
	    }).show();
	    
	    
	}

            
        var submitButton = new Ext.Button({
            text: 'Submit',
            cls: 'sandreportbutton',
            handler: function ()
            {
            if(Ext.getCmp('CustomerNameId').getValue()=='')
            {
            setMsgBoxStatus('Select Division');
            return;
            }
            if(Ext.getCmp('subDivisionId').getValue()=='')
            {
            setMsgBoxStatus('Select Sub Division');
            return;
            }
            
            if(Ext.getCmp('weeklyid').getValue()==false && Ext.getCmp('monthlyid').getValue()==false && Ext.getCmp('customid').getValue()==false)
            {
            setMsgBoxStatus('Select Date');
            return;
            }
				store.load({
						   params:{
						   CustID:Ext.getCmp('CustomerNameId').getValue(),
						   GroupId:Ext.getCmp('subDivisionId').getValue(),
						   jspName:jspName,
						   startdate:startdatepassed,
						   enddate:enddatepassed
						   },
						   callback:function()
						   {
						   Ext.getCmp('mainTabPanelId').setActiveTab('revenueGridTab');}
            });
            }
        });
        
        var resetButton = new Ext.Button({
            text: 'Reset',
            cls: 'sandreportbutton',
            handler: function ()
            {
            }
        });
        
        var buttonPanel = new Ext.Panel({
            frame: false,
            layout: 'column',
            layoutConfig: {
                columns: 1
            },
            items: [ submitButton]
        });

		var division = new Ext.Panel({
            frame: false,
            //width:'100%',
            height:25,
            layout: 'table',
            layoutConfig: {
                columns: 2
            },
            items: [ {
                    xtype: 'label',
                    text: 'Divison:',
                    cls: 'sandlblstyle',
                	},
                	CustomerName
                	
            ]
        });
        
        var subdivisionPanel = new Ext.Panel({
            frame: false,
            //width:'100%',
            height:25,
            layout: 'column',
            layoutConfig: {
                columns: 3
            },
            items: [ {
                    xtype: 'label',
                    text: 'Sub Divison:',
                    cls: 'sandlblstyle'
                	},
                	SubDivision
                	
            ]
        });
		
		var maindivisionPanel = new Ext.Panel({
            frame: false,
            //height:40,
            layout: 'table',
    		layoutConfig: {
        	tableAttrs: { style: { width: '100%' } }, 
        	columns: 3
    		},
            items: [division,subdivisionPanel,{width:'50%',height: 3}]
        });
        
        
        
        var weeklyPanel = new Ext.Panel({
            frame: false,
            height:30,
            width:185,
            layout: 'column',
            layoutConfig: {
                columns:3
            },
            items: [{
                    xtype: 'radio',
                    x: 350,
                    y: 70,
                    boxLabel: 'Week',
                    id: 'weeklyid',
                    listeners:{
		        	check:{fn:function(){
		        	getWeek(Ext.getCmp('weekdate').getValue());
		        	Ext.getCmp('customid').setValue(false);
		        	Ext.getCmp('monthlyid').setValue(false);
		        	Ext.getCmp('monthlistId').disable();
					Ext.getCmp('yearlistId').disable();
					Ext.getCmp('weekdate').enable();
					Ext.getCmp('startdate').disable();
					Ext.getCmp('enddate').disable();
					}
                    }
                    }
                    },
                	{
                        xtype: 'datefield',
                        cls: 'selectstyle',
                        format: getDateFormat(),
                        width:250,
                        emptyText: 'Select Date',
                        enableKeyEvents: true,
                        allowBlank: false,
                        disabled:true,
                        value: dtcur,
                        maxValue: dtcur,
                        blankText: 'Select Date',
                        id: 'weekdate',
                        vtype: 'daterange',
                        startDateField: 'startdate',
                        listeners: {
              			select: function(  ){
                    		getWeek(Ext.getCmp('weekdate').getValue())
                		}
            			}
                    	}
            ]
        });
        
        var monthlyPanel = new Ext.Panel({
            frame: false,
            height:30,
            layout: 'table',
            layoutConfig: {
                columns:4
            },
            items: [{
                    xtype: 'radio',
                    x: 350,
                    y: 90,
                    boxLabel: 'Month',
                    id: 'monthlyid',
                    listeners:{
		        	check:{fn:function(){
		        	startdatepassed=getStartDate(Ext.getCmp('monthlistId').getValue(),Ext.getCmp('yearlistId').getValue());
					enddatepassed=getEndDate(Ext.getCmp('monthlistId').getValue(),Ext.getCmp('yearlistId').getValue());
		        	Ext.getCmp('customid').setValue(false);
		        	Ext.getCmp('weeklyid').setValue(false);
		        	Ext.getCmp('monthlistId').enable();
					Ext.getCmp('yearlistId').enable();
					Ext.getCmp('weekdate').disable();
					Ext.getCmp('startdate').disable();
					Ext.getCmp('enddate').disable();
					}
                    }
                    }
                    },monthListCombo,{width:'2%',height:10},yearListCombo
            ]
        });
        
        var customDatePanel = new Ext.Panel({
            frame: false,
            height:40,
            layout: 'table',
            layoutConfig: {
                columns:3
            },
            items: [{
                    xtype: 'radio',
                    boxLabel: 'Custom',
                    id: 'customid',
                    listeners:{
		        	check:{fn:function(){
		        	startdatepassed=Ext.getCmp('startdate').getValue();
		        	enddatepassed=Ext.getCmp('enddate').getValue();
		        	Ext.getCmp('weeklyid').setValue(false);
		        	Ext.getCmp('monthlyid').setValue(false);
		        	Ext.getCmp('monthlistId').disable();
					Ext.getCmp('yearlistId').disable();
					Ext.getCmp('weekdate').disable();
					Ext.getCmp('startdate').enable();
					Ext.getCmp('enddate').enable();
					}
                    }
                    }
                    },
                	{
                        xtype: 'datefield',
                        cls: 'selectstyle',
                        format: getDateFormat(),
                        id:'startdate',
                        disabled:true,
                        emptyText: 'Select Date',
                        value: dtprev,
                        maxValue: dtprev,
                        vtype: 'daterange',
                        endDateField: 'enddate',
                        listeners: {
              			select: function(  ){
                    		startdatepassed=Ext.getCmp('startdate').getValue()
                		}
            			}
                        
                    },
                    {
                        xtype: 'datefield',
                        cls: 'selectstyle',
                        format: getDateFormat(),
                        emptyText: 'Select Date',
                        disabled:true,
                        id: 'enddate',
                        value: dtcur,
                        maxValue: dtcur,
                        vtype: 'daterange',
                        startDateField: 'startdate',
                        listeners: {
              			select: function(  ){
                    		enddatepassed=Ext.getCmp('enddate').getValue()
                		}
            			}
                    }
            ]
        });

		var durartionPanel = new Ext.Panel({
            frame: false,
            height:40,
            layout: 'column',
    		layoutConfig: {
        			tableAttrs: { style: { width: '100%'  } }, 
        			columns: 8
    		},
            items: [{width:'12%',height: 5},{width:'12%',height: 5},{width:'12%',height: 5},{width:'12%',height: 5},{width:'12%',height: 5},{width:'12%',height: 5},{width:'12%',height: 5},{width:'12%',height: 5},
            weeklyPanel,{width:'1%',height: 10},monthlyPanel,{width:'1%',height: 10},customDatePanel,{width:'1%',height: 10},buttonPanel]
        });

        var mainPanel = new Ext.Panel({
            frame: false,
            items: [maindivisionPanel,durartionPanel]
        });
		
		
        Ext.onReady(function () {
            Ext.QuickTips.init();
            Ext.form.Field.prototype.msgTarget = 'side';
            outerPanel = new Ext.Panel({
                title: '<%=MonthlyRevenueGenerationReport%>',
                renderTo: 'content',
                standardSubmit: true,
                width:screen.width-24,
                height: 545,
                frame: true,
                cls: 'mainpanelpercentage',
                items: [{
                        height: 10,
                    },
                    mainPanel, {
                        height: 10,
                    },
                    monthlyRevenueTabs
                ]
            });
        }); // END OF ONREADY

</script>
</div>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
