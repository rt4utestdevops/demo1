var pageModifyPanel;
//Common components used in pages
var datedayafternext = new Date().add(Date.DAY, 2);   //next to next day date
var datenext = new Date().add(Date.DAY, 1);   //next day date
var dateprev = new Date().add(Date.DAY, -1); // prev day date
var twoDaysPrev = new Date().add(Date.DAY, -2);
var datecur = new Date();   //todays date
var nextMonth = new Date().add(Date.MONTH,1);
//the below code is used for getting the current date & time with standard format like 02-01-2015 00:00:00
var currentDate = new Date();
currentDate.setHours(0);
currentDate.setMinutes(0);
currentDate.setSeconds(0);
//the below code is used for getting the Previous date & time with standard format like 01-01-2015 00:00:00
var previousDate = new Date().add(Date.DAY, -1);
previousDate.setHours(0);
previousDate.setMinutes(0);
previousDate.setSeconds(0);

var nextDate = new Date().add(Date.DAY, 1);
nextDate.setHours(0);
nextDate.setMinutes(0);
nextDate.setSeconds(0);
 
//Add the additional 'advanced' VTypes to restrict date selection
Ext.apply(Ext.form.VTypes, {
    daterange : function(val, field) {
        var date = field.parseDate(val);
        if(!date){
            return false;
        }
        if (field.startDateField) {
            var start = Ext.getCmp(field.startDateField);
            start.setMaxValue(date);
        }
        else if (field.endDateField) {
            var end = Ext.getCmp(field.endDateField);
            if (!end.minValue || (date.getTime() != end.minValue.getTime())) {
                end.setMinValue(date);
            }
        }
        /*
         * Always return true since we're only using this vtype to set the
         * min/max allowed values (these are tested for after the vtype test)
         */
        return true;
    }
});

//Add the contains filter in combox 
/**
 * it will filter any matching word from string in combobox list
 */
Ext.override(Ext.form.ComboBox, {
	 doQuery: function(q, forceAll){
	if(q === undefined || q === null){
		q = '';
	}
	var qe = {
		query: q,
		forceAll: forceAll,
		combo: this,
		cancel:false
	};
	if(this.fireEvent('beforequery', qe)===false || qe.cancel){
		return false;
	}
	q = qe.query;
	forceAll = qe.forceAll;
	if(forceAll === true || (q.length >= this.minChars)){
		if(this.lastQuery !== q){
			this.lastQuery = q;
			if(this.mode == 'local'){
				this.selectedIndex = -1;
				if(forceAll){
					this.store.clearFilter();
				}else{
					this.store.filter(this.displayField, q, this.anyMatch, this.caseSensitive);
				}
				this.onLoad();
			}else{
				this.store.baseParams[this.queryParam] = q;
				this.store.load({
					params: this.getParams(q)
				});
				this.expand();
			}
		}else{
			this.selectedIndex = -1;
			this.onLoad();
		}
	}
}

});

Ext.onReady(function(){
	pageModifyPanel= new Ext.Panel({
		standardSubmit: true,
		id: 'toolbar2',
		height:40,
		padding:'5px 5px 5px 5px',
		layout:'table',
		layoutConfig: {
			columns:5
		},
		items: [
		    {
		    xtype: 'button',
			id:'pagemodiadd',
			iconCls: 'add24',
			tooltip:new Ext.ToolTip({
		        title: 'ADD'

			})
		    }, 
		    {
		    xtype:'tbspacer', width:'10px'
		    },
		    {
		    xtype: 'button',
			id:'pagemodimodify',
			iconCls: 'update24',
			tooltip:new Ext.ToolTip({
		        title: 'MODIFY'

			})
			}, {
			xtype:'tbspacer', width:'10px'},{xtype: 'button',
			id:'pagemodidelete',
			iconCls: 'delete24',
			tooltip:new Ext.ToolTip({
		        title: 'DELETE'

			})
			}
				]
		});
});
/**
 * Grid Definition-For Vertical wise Platform.For add,modify and delete write the function definition in your jsp page
 * @param gridtitle
 * @param emptytext
 * @param store
 * @param width
 * @param height
 * @param gridnoofcols
 * @param filters
 * @param filterstr
 * @param reconfigure
 * @param reconfigurestr
 * @param reconfigurenoofcols
 * @param group
 * @param groupstr
 * @param chart
 * @param chartstr
 * @param excel
 * @param excelstr
 * @param jspName
 * @param exportDataType
 * @param pdf
 * @param pdfstr
 * @param add
 * @param addstr
 * @param modify
 * @param modifystr
 * @param del
 * @param delstr
 * @return
 */

function getVerticalPlatFormGrid(gridtitle,emptytext,store,width,height,gridnoofcols,filters,clearfilter,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr,closetrip,closestr,verify,verifystr,approve, approvestr,copy, copystr){
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid',
	        colModel: createColModel(gridnoofcols),
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        listeners: {
                render : function(grid){
                  grid.store.on('load', function(store, records, options){
                    grid.getSelectionModel().selectFirstRow();       
                  });                      
                }
               },
	        plugins: [filters],	       
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
	if(clearfilter)
	{
	 grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            iconCls : 'clearfilterbuttonNew',
	            handler: function () {
	        	grid.filters.clearFilters();
	            } 
	        }]);
	}		
	if(reconfigure){
		grid.getBottomToolbar().add([
		 '-',                            
			{
            text: reconfigurestr,
            iconCls : 'reconfigurebuttonNew',
            handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
            } 
        }]);
	}
	if(group){
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:groupstr,
			    iconCls : 'cleargroupbuttonNew',
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
	}
		if(add)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:addstr,
			    iconCls : 'addbuttonNew',
			    handler : function(){
			    addRecord();

			    }    
			  }]);
		}	
		if(modify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:modifystr,
			    iconCls : 'editbuttonNew',
			    id: 'modifyId',
			    handler : function(){
			    modifyData();

			    }    
			  }]);
		}	
		if(del)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:delstr,
			    iconCls : 'deletebuttonNew',
			    id: 'gridDeleteId',
			    handler : function(){
			    deleteData();

			    }    
			  }]);
		}
		if(copy)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:copystr,
			    iconCls : 'copybuttonNew',
			    id: 'gridCopyId',
			    handler : function(){
			    copyData();
			   }    
			  }]);
		}	
		if(chart)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:chartstr,
			    handler : function(){
				columnchart();
			    }    
			  }]);
		}
		if(excel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:excelstr,
			    iconCls : 'excelbuttonNew',
			    handler : function(){
				getordreport('xls','All',jspName,grid,exportDataType);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:pdfstr,
			    iconCls : 'pdfbuttonNew',
			    handler : function(){
			    getordreport('pdf','All',jspName,grid,exportDataType);

			    }    
			  }]);
		}
		if(closetrip)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:closestr,
			    iconCls:'closeTripbuttonS',
			    id: 'gridCloseTripId',
			    handler : function(){
				closetripsummary();
			    }    
			  }]);
		}
		if(verify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:verifystr,
			    iconCls:'',
			    id: 'gridVerifyId',
			    handler : function(){
					verifyFunction();
			    }    
			  }]);
		}
		if(approve)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:approvestr,
			    iconCls:'',
			    id: 'gridApproveId',
			    handler : function(){
					approveFunction();
			    }    
			  }]);
		}
	return grid;
}
/**
 * Grid Definition.For add,modify and delete write the function definition in your jsp page
 * @param gridtitle
 * @param emptytext
 * @param store
 * @param width
 * @param height
 * @param gridnoofcols
 * @param filters
 * @param filterstr
 * @param reconfigure
 * @param reconfigurestr
 * @param reconfigurenoofcols
 * @param group
 * @param groupstr
 * @param chart
 * @param chartstr
 * @param excel
 * @param excelstr
 * @param jspName
 * @param exportDataType
 * @param pdf
 * @param pdfstr
 * @param add
 * @param addstr
 * @param modify
 * @param modifystr
 * @param del
 * @param delstr
 * @return
 */

function getGrid(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr,closetrip,closestr,verify,verifystr,approve, approvestr,copy, copystr,postpone,postponestr,importExcel,importStr,save,saveStr,clearData,clearStr,close,closeStr){
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid',
	        colModel: createColModel(gridnoofcols),
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        listeners: {
                render : function(grid){
                  grid.store.on('load', function(store, records, options){
                    grid.getSelectionModel().selectFirstRow();       
                  });                      
                }
               },
	        plugins: [filters],	       
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
	 grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            iconCls : 'clearfilterbutton',
	            handler: function () {
	        	grid.filters.clearFilters();
	            } 
	        }]);
	if(reconfigure){
		grid.getBottomToolbar().add([
		 '-',                            
			{
            text: reconfigurestr,
            handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
            } 
        }]);
		}
		if(group){
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:groupstr,
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
		}
		if(add)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:addstr,
			    iconCls : 'addbutton',
			    handler : function(){
			    addRecord();

			    }    
			  }]);
		}	
		if(modify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:modifystr,
			    iconCls : 'editbutton',
			    id: 'modifyId',
			    handler : function(){
			    modifyData();

			    }    
			  }]);
		}	
		if(del)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:delstr,
			    iconCls : 'deletebutton',
			    id: 'gridDeleteId',
			    handler : function(){
			    deleteData();

			    }    
			  }]);
		}
		if(copy)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:copystr,
			    iconCls : 'copybutton',
			    id: 'gridCopyId',
			    handler : function(){
			    copyData();
			   }    
			  }]);
		}	
		if(chart)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:chartstr,
			    id: 'chartId',
			    handler : function(){
				columnchart();
			    }    
			  }]);
		}
		if(excel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'excelbutton',
			    handler : function(){
				getordreport('xls','All',jspName,grid,exportDataType);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'pdfbutton',
			    handler : function(){
			    getordreport('pdf','All',jspName,grid,exportDataType);

			    }    
			  }]);
		}
		if(closetrip)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:closestr,
			    iconCls:'closeTripbuttonS',
			    id: 'gridCloseTripId',
			    handler : function(){
				closetripsummary();
			    }    
			  }]);
		}
		if(verify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:verifystr,
			    iconCls:'',
			    id: 'gridVerifyId',
			    handler : function(){
					verifyFunction();
			    }    
			  }]);
		}
		if(approve)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:approvestr,
			    iconCls:'',
			    id: 'gridApproveId',
			    handler : function(){
					approveFunction();
			    }    
			  }]);
		}
		if(postpone)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:postponestr,
			    iconCls:'postponebutton',
			    id: 'gridPostponeId',
			    handler : function(){
					postponeFunction();
			    }    
			  }]);
		}
		if(importExcel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:importStr,
			    iconCls : 'excelbutton',
			    handler : function(){
			    importExcelData();

			    }    
			  }]);
		}
		if(save)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:saveStr,
			    iconCls : 'savebutton',
			    handler : function(){
			    saveDate();

			    }    
			  }]);
		}
		if(clearData)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:clearStr,
			    iconCls : 'clearbutton',
			    handler : function(){
			    clearInputData();

			    }    
			  }]);
		}
		if(close)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:closeStr,
			    iconCls : 'closebutton',
			    handler : function(){
			    closeImportWin();

			    }    
			  }]);
		}

	return grid;
}


function getGrid1(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr,closetrip,closestr,verify,verifystr,approve, approvestr,copy, copystr,postpone,postponestr,importExcel,importStr,save,saveStr,clearData,clearStr,close,closeStr){
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid1',
	        colModel: createColModel(gridnoofcols),
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        listeners: {
               render : function(grid){
                 grid.store.on('load', function(store, records, options){
                   grid.getSelectionModel().selectFirstRow();       
                 });                      
               }
              },
	        plugins: [filters],	       
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
	 grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            iconCls : 'clearfilterbutton',
	            handler: function () {
	        	grid.filters.clearFilters();
	            } 
	        }]);
	if(reconfigure){
		grid.getBottomToolbar().add([
		 '-',                            
			{
           text: reconfigurestr,
           handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
           } 
       }]);
		}
		if(group){
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:groupstr,
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
		}
		if(add)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:addstr,
			    iconCls : 'addbutton',
			    handler : function(){
			    addRecord();

			    }    
			  }]);
		}	
		if(modify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:modifystr,
			    iconCls : 'editbutton',
			    id: 'modifyId',
			    handler : function(){
			    modifyData();

			    }    
			  }]);
		}	
//		if(del)
//		{
//			grid.getBottomToolbar().add([
//			'-',                             
//			{
//			    text:cashBackStr,
//			    //iconCls : 'editbutton',
//			    id: 'cashBackId',
//			    handler : function(){
//			    cashBackData();
//
//			    }    
//			  }]);
//		}	
		if(del)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:delstr,
			    iconCls : 'cashBackbutton',
			    id: 'gridDeleteId',
			    handler : function(){
				cashBackData();

			    }    
			  }]);
		}
		if(copy)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:copystr,
			    iconCls : 'copybutton',
			    id: 'gridCopyId',
			    handler : function(){
			    copyData();
			   }    
			  }]);
		}	
		if(chart)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:chartstr,
			    handler : function(){
				columnchart();
			    }    
			  }]);
		}
		if(excel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'excelbutton',
			    handler : function(){
				getordreport('xls','All',jspName,grid,exportDataType);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'pdfbutton',
			    handler : function(){
			    getordreport('pdf','All',jspName,grid,exportDataType);

			    }    
			  }]);
		}
		if(closetrip)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:closestr,
			    iconCls:'closeTripbuttonS',
			    id: 'gridCloseTripId',
			    handler : function(){
				closetripsummary();
			    }    
			  }]);
		}
		if(verify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:verifystr,
			    iconCls:'',
			    id: 'gridVerifyId',
			    handler : function(){
					verifyFunction();
			    }    
			  }]);
		}
		if(approve)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:approvestr,
			    iconCls:'',
			    id: 'gridApproveId',
			    handler : function(){
					approveFunction();
			    }    
			  }]);
		}
		if(postpone)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:postponestr,
			    iconCls:'postponebutton',
			    id: 'gridPostponeId',
			    handler : function(){
					postponeFunction();
			    }    
			  }]);
		}
		if(importExcel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:importStr,
			    iconCls : 'excelbutton',
			    handler : function(){
			    importExcelData();

			    }    
			  }]);
		}
		if(save)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:saveStr,
			    iconCls : 'savebutton',
			    handler : function(){
			    saveDate();

			    }    
			  }]);
		}
		if(clearData)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:clearStr,
			    iconCls : 'clearbutton',
			    handler : function(){
			    clearInputData();

			    }    
			  }]);
		}
		if(close)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:closeStr,
			    iconCls : 'closebutton',
			    handler : function(){
			    closeImportWin();

			    }    
			  }]);
		}

	return grid;
}


function getGridVehicle(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,veh,vehstr,closetrip,closestr,verify,verifystr,approve, approvestr,copy, copystr,postpone,postponestr,importExcel,importStr,save,saveStr,clearData,clearStr,close,closeStr){
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid',
	        colModel: createColModel(gridnoofcols),
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        listeners: {
               render : function(grid){
                 grid.store.on('load', function(store, records, options){
                   grid.getSelectionModel().selectFirstRow();       
                 });                      
               }
              },
	        plugins: [filters],	       
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
	 grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            iconCls : 'clearfilterbutton',
	            handler: function () {
	        	grid.filters.clearFilters();
	            } 
	        }]);
	if(reconfigure){
		grid.getBottomToolbar().add([
		 '-',                            
			{
           text: reconfigurestr,
           handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
           } 
       }]);
		}
		if(group){
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:groupstr,
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
		}
		if(add)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:addstr,
			    iconCls : 'addbutton',
			    handler : function(){
			    addRecord();

			    }    
			  }]);
		}	
		if(modify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:modifystr,
			    iconCls : 'editbutton',
			    id: 'modifyId',
			    handler : function(){
			    modifyData();

			    }    
			  }]);
		}	
		if(veh)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:vehstr,
			   // iconCls : 'deletebutton',
			    id: 'gridDeleteId',
			    handler : function(){
			    addVehicleData();

			    }    
			  }]);
		}
		if(copy)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:copystr,
			    iconCls : 'copybutton',
			    id: 'gridCopyId',
			    handler : function(){
			    copyData();
			   }    
			  }]);
		}	
		if(chart)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:chartstr,
			    handler : function(){
				columnchart();
			    }    
			  }]);
		}
		if(excel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'excelbutton',
			    handler : function(){
				getordreport('xls','All',jspName,grid,exportDataType);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'pdfbutton',
			    handler : function(){
			    getordreport('pdf','All',jspName,grid,exportDataType);

			    }    
			  }]);
		}
		if(closetrip)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:closestr,
			    iconCls:'closeTripbuttonS',
			    id: 'gridCloseTripId',
			    handler : function(){
				closetripsummary();
			    }    
			  }]);
		}
		if(verify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:verifystr,
			    iconCls:'',
			    id: 'gridVerifyId',
			    handler : function(){
					verifyFunction();
			    }    
			  }]);
		}
		if(approve)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:approvestr,
			    iconCls:'',
			    id: 'gridApproveId',
			    handler : function(){
					approveFunction();
			    }    
			  }]);
		}
		if(postpone)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:postponestr,
			    iconCls:'postponebutton',
			    id: 'gridPostponeId',
			    handler : function(){
					postponeFunction();
			    }    
			  }]);
		}
		if(importExcel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:importStr,
			    iconCls : 'excelbutton',
			    handler : function(){
			    importExcelData();

			    }    
			  }]);
		}
		if(save)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:saveStr,
			    iconCls : 'savebutton',
			    handler : function(){
			    saveDate();

			    }    
			  }]);
		}
		if(clearData)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:clearStr,
			    iconCls : 'clearbutton',
			    handler : function(){
			    clearInputData();

			    }    
			  }]);
		}
		if(close)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:closeStr,
			    iconCls : 'closebutton',
			    handler : function(){
			    closeImportWin();

			    }    
			  }]);
		}

	return grid;
}



//if multiple tabs for grid to enable it will not return multiple column models so, below function is created. 
function getMultipleGrid(gridtitle,emptytext,store,width,height,gridColumnModel,filters,filterNeed,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr,importExcel,importStr,clearData,clearStr){
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid',
	        colModel: gridColumnModel,
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        listeners: {
               render : function(grid){
                 grid.store.on('load', function(store, records, options){
                   grid.getSelectionModel().selectFirstRow();       
                 });                      
               }
              },
	        plugins: [filters],	       
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
		
		if(filterNeed){
			grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            iconCls : 'clearfilterbutton',
	            handler: function () {
	        	grid.filters.clearFilters();
	            } 
	        }]);
		} else {
			grid.getBottomToolbar().add(['->']);
		}

		if(group){
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:groupstr,
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
		}
		if(add)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:addstr,
			    iconCls : 'addbutton',
			    handler : function(){
			    addRecord();

			    }    
			  }]);
		}	
		if(modify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:modifystr,
			    iconCls : 'validatebutton',
			    handler : function(){
			    modifyData();

			    }    
			  }]);
		}	
		if(del)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:delstr,
			    iconCls : 'savebutton',
			    handler : function(){
			    deleteData();

			    }    
			  }]);
		}
		if(importExcel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:importStr,
			    iconCls : 'excelbutton',
			    handler : function(){
			    importData();

			    }    
			  }]);
		}
		if(clearData)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:clearStr,
			    iconCls : 'clearbutton',
			    handler : function(){
			    clearInputData();

			    }    
			  }]);
		}
		if(chart)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:chartstr,
			    handler : function(){
				columnchart();
			    }    
			  }]);
		}
		if(excel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'excelbutton',
			    handler : function(){
				var subtotal=setReports('xls','All');
				getordreports('xls','All',jspName,grid,exportDataType,subtotal);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'pdfbutton',
			    handler : function(){
				var subtotal=setReports('xls','All');
			    getordreports('pdf','All',jspName,grid,exportDataType,subtotal);
			    }    
			  }]);
		}

	return grid;
}

/**
 * Grid Definition.For selection model grid definition in your jsp page
 * @param gridtitle
 * @param emptytext
 * @param store
 * @param width
 * @param height
 * @param colmodel
 * @param gridnoofcols
 * @param filters
 * @param sm
 * @return
 */
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
	    plugins: [filters]
    });
	if(width>0){
		grid.setSize(width,height);
	}
	return grid;
}

/**
 * Grid Definition.For add,modify and delete write the function definition in your jsp page
 * @param gridtitle
 * @param emptytext
 * @param store
 * @param width
 * @param height
 * @param gridnoofcols
 * @param filters
 * @param filterstr
 * @param reconfigure
 * @param reconfigurestr
 * @param reconfigurenoofcols
 * @param group
 * @param groupstr
 * @param chart
 * @param chartstr
 * @param excel
 * @param excelstr
 * @param jspName
 * @param exportDataType
 * @param pdf
 * @param pdfstr
 * @param add
 * @param addstr
 * @param modify
 * @param modifystr
 * @param del
 * @param delstr
 * @return
 */

function getEditorGrid(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr){
	 var grid = new Ext.grid.EditorGridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid',
	        colModel: createColModel(gridnoofcols),
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        sm		: new Ext.grid.RowSelectionModel({ singleSelect:true}),
	        plugins: [filters],
	        clicksToEdit: 1,
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);

	}
	 grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            iconCls : 'clearfilterbutton',
	            handler: function () {
	        	grid.filters.clearFilters();
	            } 
	        }]);
	if(reconfigure){
		grid.getBottomToolbar().add([
			{
            text: reconfigurestr,
            handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
            } 
        }]);
		}
		if(group){
			grid.getBottomToolbar().add([
			{
			    text:groupstr,
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
		}
		if(add)
		{
			grid.getBottomToolbar().add([
			{
			    text:addstr,
			    id: 'addButtonId',
			    handler : function(){
			    addRecord();

			    }    
			  }]);
		}	
		if(modify)
		{
			grid.getBottomToolbar().add([
			{
			    text:modifystr,
			    id: 'modifyButtonId',
			    handler : function(){
			    modifyData();

			    }    
			  }]);
		}	
		if(del)
		{
			grid.getBottomToolbar().add([
			{
			    text:delstr,
			    handler : function(){
			    deleteData();

			    }    
			  }]);
		}	
		if(chart)
		{
			grid.getBottomToolbar().add([
			{
			    text:chartstr,
			    handler : function(){
				columnchart();
			    }    
			  }]);
		}
		if(excel)
		{
			grid.getBottomToolbar().add([
			{
			    text:'',
			    iconCls : 'excelbutton',
			    handler : function(){
				getordreport('xls','All',jspName,grid,exportDataType);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			{
			    text:pdfstr,
			    handler : function(){
			    getordreport('pdf','All',jspName,grid,exportDataType);

			    }    
			  }]);
		}	
	return grid;
}
function getDateFormats(){
	return 'd/m/Y';
}
function checkDays(startDate,endDate){
	var startDate = startDate.split("/");
	var from_Date = new Date(startDate[1]+"/"+startDate[0]+"/"+startDate[2]); //mm/dd/yyyy
	var endDate = endDate.split("/");
	var to_Date = new Date(endDate[1]+"/"+endDate[0]+"/"+endDate[2]); //mm/dd/yyyy
	var one_day=1000*60*60*24;
	var days=parseInt((to_Date.getTime() - from_Date.getTime()) / one_day);
	return days;
}
//Common date formats used in pages 
function getDateFormat(){
	return 'd-m-Y';
}
function getDateTimeFormat(){
	return 'd-m-Y H:i:s';
}
function getDateTimeFormatWithoutSeconds(){
	return 'd-m-Y H:i';
}
//Common height defined in pages for grid
function getGridHeight(){
	return 450;
}
//Common width defined in pages for tool tip
function getToolTipWidth(){
	return 300;
}
//Common config used in pages
function getGroupConfig(){
	return '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})';
}
//common height for treepanel

function getTreePanelHeight(){
	return 300;
}

//common width for treepanel
function getTreePanelWidth(){
	return 875;
}

//Checks Date diff is greater than one week
function checkWeekValidation(startdate,enddate)
{ 
	var Startdatenew = new Date(enddate).add(Date.DAY, -6);
		if(startdate < Startdatenew )
		{
			return true;
		}
		else
		{
			return false;
		}	
}

//Checks Date diff is greater than one month
function checkMonthValidation(startdate,enddate)
{ 
	var Startdatenew = new Date(enddate).add(Date.MONTH, -1);
		if(startdate < Startdatenew )
		{
			return true;
		}
		else
		{
			return false;
		}	
}

//CHECKS DATE DIFF IS GREATER THAN ONE YEAR
function checkYearValidation(startdate,enddate)
{ 
	var Startdatenew = new Date(enddate).add(Date.YEAR, -1);
		if(startdate < Startdatenew )
		{
			return true;
		}
		else
		{
			return false;
		}	
}

//Checking date difference
function dateCompare(fromDate, toDate) {
	
	if(fromDate < toDate) {
		return 1;
	} else if(toDate <= fromDate) {
		return -1;
	}
	return 0;
}

function DateCompare3 (startDate, endDate)
{
		   var startddindex = startDate.indexOf('-');
		   var startdd = startDate.substring(0,startddindex);
		   
		   var startmmindex = startDate.lastIndexOf('-');
		   var startmm = startDate.substring(startddindex+1,startmmindex);
		   var startyear = startDate.substring(startmmindex+1,startDate.length);
		   
		   var endddindex = endDate.indexOf('-');
		   var enddd = endDate.substring(0,endddindex);
		   
		   var endmmindex = endDate.lastIndexOf('-');
		  
		   var endmm = endDate.substring(endddindex+1,endmmindex);
		   var endyear = endDate.substring(endmmindex+1,endDate.length);
		   var date1=new Date(startmm+"-"+startdd+"-"+startyear);
		   var date2=new Date(endmm+"-"+enddd+"-"+endyear);
		
		if (date1 <=date2)
		{
			return true;
		}
		else 
		{
			return false;
		}
		
};
function DateCompare4 (startDate, endDate)
{
			
		   var startddindex = startDate.indexOf('-');
		   var startdd = startDate.substring(0,startddindex);
		   
		   var startmmindex = startDate.lastIndexOf('-');
		   var startmm = startDate.substring(startddindex+1,startmmindex);
		   var startyear = startDate.substring(startmmindex+1,startDate.length);
		   var yearS=startyear.indexOf(' ');
		   var yearFF=startyear.substring(0,yearS);
		   var endddindex = endDate.indexOf('-');
		   var enddd = endDate.substring(0,endddindex);
		   
		   var endmmindex = endDate.lastIndexOf('-');
		  
		   var endmm = endDate.substring(endddindex+1,endmmindex);
		   var endyear = endDate.substring(endmmindex+1,endDate.length);
		   var year=endyear.indexOf(' ');
		   var yearF=endyear.substring(0,year);
		   var date1=new Date(startmm+"-"+startdd+"-"+yearFF);
		   var date2=new Date(endmm+"-"+enddd+"-"+yearF);
		if (date1 < date2)
		{
			return true;
		}
		else 
		{
			return false;
		}
		
};

function validate(settingname){
	if(settingname=='name'){
	return	/^\s*[a-zA-Z_,\s]+\s*$/;
	}else if(settingname=='email'){
	return /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
	}else if(settingname=='phone'){
	return /^((((\(\d{3}\))|(\d{3}-))\d{3}-\d{4})|(\+?\d{2}((-| )\d{1,8}){1,5}))(( x| ext)\d{1,5}){0,1}$/;
	}else if(settingname=='groupname'){
	return /^\s*[a-zA-Z0-9_,\s]+\s*$/;
	}else if(settingname=='username'){
	return /^([a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?)?$/;
	}else if(settingname=='password'){
	return /((?=.*\d)(?=.*[A-Z])(?=.*[a-z])(?=\S+$)(?=.*\W).{8,30})/;
	}else if(settingname=='city'){
	return	/^\s*[a-zA-Z_,\s]+\s*$/;
	}
	else if(settingname=='mobile'){
		return	/^\d+$/;
	}else if(settingname=='alphanumericname'){
		return /^\s*[a-zA-Z0-9\s]+\s*$/;
	}else if(settingname=='locationname'){
		return /^[a-zA-Z0-9_\-\.\,\/\s]+$/;
	}
	}

/**
 * Checks whether entered time s within the range of 5 mins and 1440 mins
 * @param time
 * @return
 */
function validateEnteredTime(time){
	var mins=parseInt(time);
	if(mins!=0 && (mins<5 || mins>1440)){
		return false;
	}else{
		return true;
	}
}


function validateStoppageLimitEnteredTime(time){
	var mins=parseInt(time);
	if(mins!=0 && (mins<5 || mins>7200)){
		return false;
	}else{
		return true;
	}
}

function getHubOpearationGrid(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr,details,detailstr){
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid',
	        colModel: createColModel(gridnoofcols),
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        listeners: {
               render : function(grid){
                 grid.store.on('load', function(store, records, options){
                   grid.getSelectionModel().selectFirstRow();       
                 });                      
               }
              },
	        plugins: [filters],	       
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
	 grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            iconCls : 'clearfilterbutton',
	            handler: function () {
	        	grid.filters.clearFilters();
	            } 
	        }]);
	if(reconfigure){
		grid.getBottomToolbar().add([
		 '-',                            
			{
           text: reconfigurestr,
           handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
           } 
       }]);
		}
		if(group){
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:groupstr,
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
		}
		if(add)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:addstr,
			    iconCls : 'addbutton',
			    handler : function(){
			    addRecord();

			    }    
			  }]);
		}	
		if(modify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:modifystr,
			    iconCls : 'editbutton',
			    id: 'modifyId',
			    handler : function(){
			    modifyData();

			    }    
			  }]);
		}	
		if(del)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:delstr,
			    iconCls : 'deletebutton',
			    id: 'gridDeleteId',
			    handler : function(){
			    deleteData();

			    }    
			  }]);
		}
			
		if(chart)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:chartstr,
			    handler : function(){
				columnchart();
			    }    
			  }]);
		}
		if(excel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:excelstr,
			    iconCls : 'excelbutton',
			    handler : function(){
				getordreport('xls','All',jspName,grid,exportDataType);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:pdfstr,
			    iconCls : 'pdfbutton',
			    handler : function(){
			    getordreport('pdf','All',jspName,grid,exportDataType);

			    }    
			  }]);
		}
		
		if(details)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:detailstr,
			    iconCls : 'closeTripbuttonS',
			    id: 'detailId',
			    handler : function(){
			    getDetails();

			    }    
			  }]);
		}
	return grid;
}

function getCashVanGrid(gridtitle,emptytext,store,width,height,gridnoofcols,refresh,refreshstr,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,add,addstr,modify,modifystr,del,delstr,closetrip,closestr,verify,verifystr,approve, approvestr,copy, copystr,postpone,postponestr,viewRevision,viewRevisionStr,viewAttachment,viewAttachmentStr,excel,excelstr,jspName,exportDataType,pdf,pdfstr){
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid',
	        colModel: createColModel(gridnoofcols),
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        listeners: {
               render : function(grid){
                 grid.store.on('load', function(store, records, options){
                   grid.getSelectionModel().selectFirstRow();       
                 });                      
               },
               cellclick:{fn:viewFuelPercentage}
              },
	        plugins: [filters],	       
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
	 grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            iconCls : 'clearfilterbutton',
	            handler: function () {
	        	grid.filters.clearFilters();
	            } 
	        }]);
	if(reconfigure){
		grid.getBottomToolbar().add([
		 '-',                            
			{
           text: reconfigurestr,
           handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
           } 
       }]);
		}
		if(group){
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:groupstr,
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
		}
		if(refresh)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:refreshstr,
			    iconCls : 'refreshbutton',
			    handler : function(){
			    refreshRecord();

			    }    
			  }]);
		}
		if(add)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:addstr,
			    iconCls : 'addbutton',
			    handler : function(){
			    addRecord();

			    }    
			  }]);
		}	
		if(modify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:modifystr,
			    iconCls : 'editbutton',
			    id: 'modifyId',
			    handler : function(){
			    modifyData();

			    }    
			  }]);
		}	
		if(del)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:delstr,
			    iconCls : 'deletebutton',
			    id: 'gridDeleteId',
			    handler : function(){
			    deleteData();

			    }    
			  }]);
		}
		if(copy)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:copystr,
			    iconCls : 'copybutton',
			    id: 'gridCopyId',
			    handler : function(){
			    copyData();
			   }    
			  }]);
		}	
		if(chart)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:chartstr,
			    handler : function(){
				columnchart();
			    }    
			  }]);
		}

		if(closetrip)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:closestr,
			    iconCls:'closeTripbuttonS',
			    id: 'gridCloseTripId',
			    handler : function(){
				closetripsummary();
			    }    
			  }]);
		}
		if(verify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:verifystr,
			    iconCls:'',
			    id: 'gridVerifyId',
			    handler : function(){
					verifyFunction();
			    }    
			  }]);
		}
		if(approve)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:approvestr,
			    iconCls:'',
			    id: 'gridApproveId',
			    handler : function(){
					approveFunction();
			    }    
			  }]);
		}
		if(postpone)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:postponestr,
			    iconCls:'postponebutton',
			    id: 'gridPostponeId',
			    handler : function(){
					postponeFunction();
			    }    
			  }]);
		}
		if(viewRevision)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:viewRevisionStr,
			    iconCls:'',
			    id: 'gridViewId',
			    handler : function(){
					viewRevisionFunction();
			    }    
			  }]);
		}
		if(viewAttachment)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:viewAttachmentStr,
			    iconCls:'',
			    id: 'attachmentViewId',
			    handler : function(){
				viewAttachmentFunction();
			    }    
			  }]);
		}
		if(excel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'excelbutton',
			    handler : function(){
				getordreport('xls','All',jspName,grid,exportDataType);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'pdfbutton',
			    handler : function(){
			    getordreport('pdf','All',jspName,grid,exportDataType);

			    }    
			  }]);
		}
		
	return grid;
}
//For right allignment icons grid
function getGridforRightIcons(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr,closetrip,closestr,verify,verifystr,approve, approvestr,copy, copystr,postpone,postponestr){
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid',
	        colModel: createColModel(gridnoofcols),
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        listeners: {
               render : function(grid){
                 grid.store.on('load', function(store, records, options){
                   grid.getSelectionModel().selectFirstRow();       
                 });                      
               }
              },
	        plugins: [filters],	       
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
	 grid.getBottomToolbar().add([
	        '-',
	        {
	            text: filterstr,
	            iconCls : 'clearfilterbutton',
	            handler: function () {
	        	grid.filters.clearFilters();
	            } 
	        }]);
	if(reconfigure){
		grid.getBottomToolbar().add([
		 '-',                            
			{
           text: reconfigurestr,
           handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
           } 
       }]);
		}
		if(group){
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:groupstr,
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
		}
		if(add)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:addstr,
			    iconCls : 'addbutton',
			    handler : function(){
			    addRecord();

			    }    
			  }]);
		}	
		if(modify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:modifystr,
			    iconCls : 'editbutton',
			    id: 'modifyId',
			    handler : function(){
			    modifyData();

			    }    
			  }]);
		}	
		if(del)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:delstr,
			    iconCls : 'deletebutton',
			    id: 'gridDeleteId',
			    handler : function(){
			    deleteData();

			    }    
			  }]);
		}
		if(copy)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:copystr,
			    iconCls : 'copybutton',
			    id: 'gridCopyId',
			    handler : function(){
			    copyData();
			   }    
			  }]);
		}	
		if(chart)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:chartstr,
			    handler : function(){
				columnchart();
			    }    
			  }]);
		}
		if(excel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'excelbutton',
			    handler : function(){
				getordreport('xls','All',jspName,grid,exportDataType);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'pdfbutton',
			    handler : function(){
			    getordreport('pdf','All',jspName,grid,exportDataType);

			    }    
			  }]);
		}
		if(closetrip)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:closestr,
			    iconCls:'closeTripbuttonS',
			    id: 'gridCloseTripId',
			    handler : function(){
				closetripsummary();
			    }    
			  }]);
		}
		if(verify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:verifystr,
			    iconCls:'',
			    id: 'gridVerifyId',
			    handler : function(){
					verifyFunction();
			    }    
			  }]);
		}
		if(approve)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:approvestr,
			    iconCls:'',
			    id: 'gridApproveId',
			    handler : function(){
					approveFunction();
			    }    
			  }]);
		}
		if(postpone)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:postponestr,
			    iconCls:'postponebutton',
			    id: 'gridPostponeId',
			    handler : function(){
					postponeFunction();
			    }    
			  }]);
		}
	return grid;
}

function getGridForConsumer(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr,closetrip,closestr,verify,verifystr,approve, approvestr,copy, copystr,postpone,postponestr,importExcel,importStr,save,saveStr,clearData,clearStr,close,closeStr){
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid',
	        colModel: createColModel(gridnoofcols),
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        listeners: {
               render : function(grid){
                 grid.store.on('load', function(store, records, options){
                   grid.getSelectionModel().selectFirstRow();       
                 });                      
               }
              },
	        plugins: [filters],	       
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
	 grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            iconCls : 'clearfilterbutton',
	            handler: function () {
	        	grid.filters.clearFilters();
	            } 
	        }]);
	if(reconfigure){
		grid.getBottomToolbar().add([
		 '-',                            
			{
           text: reconfigurestr,
           handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
           } 
       }]);
		}
		if(group){
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:groupstr,
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
		}
		if(add)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:addstr,
			    iconCls : 'addbutton',
			    handler : function(){
			    addRecord();

			    }    
			  }]);
		}	
		if(modify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:modifystr,
			    iconCls : 'editbutton',
			    id: 'modifyId',
			    handler : function(){
			    modifyData();

			    }    
			  }]);
		}	
		if(del)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:delstr,
			    iconCls : 'deletebutton',
			    id: 'gridDeleteId',
			    handler : function(){
			    deleteData();

			    }    
			  }]);
		}
		if(copy)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:copystr,
			    iconCls : 'copybutton',
			    id: 'gridCopyId',
			    handler : function(){
			    copyData();
			   }    
			  }]);
		}	
		if(chart)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:chartstr,
			    handler : function(){
				columnchart();
			    }    
			  }]);
		}
		if(excel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'excelbutton',
			    handler : function(){
				getordreport('xls','All',jspName,grid,exportDataType);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'pdfbutton',
			    handler : function(){
			    getordreport('pdf','All',jspName,grid,exportDataType);

			    }    
			  }]);
		}
		if(closetrip)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:closestr,
			    iconCls:'closeTripbuttonS',
			    id: 'gridCloseTripId',
			    handler : function(){
				closetripsummary();
			    }    
			  }]);
		}
		if(verify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:verifystr,
			    iconCls:'',
			    id: 'gridVerifyId',
			    handler : function(){
					verifyFunction();
			    }    
			  }]);
		}
		if(approve)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:approvestr,
			    iconCls:'',
			    id: 'gridApproveId',
			    handler : function(){
					approveFunction();
			    }    
			  }]);
		}
		if(postpone)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:postponestr,
			    iconCls:'postponebutton',
			    id: 'gridPostponeId',
			    handler : function(){
					postponeFunction();
			    }    
			  }]);
		}
		if(importExcel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:importStr,
			    iconCls : 'excelbutton',
			    handler : function(){
			    importExcelData();

			    }    
			  }]);
		}
		if(save)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:saveStr,
			    iconCls : 'savebutton',
			    handler : function(){
			    saveDate();

			    }    
			  }]);
		}
		if(clearData)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:clearStr,
			    iconCls : 'clearbutton',
			    handler : function(){
			    clearInputData();

			    }    
			  }]);
		}
		if(close)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:closeStr,
			    iconCls : 'closebutton',
			    handler : function(){
			    closeImportWin();

			    }    
			  }]);
		}

	return grid;
}

function getSandPermitGrid(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr){
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid',
	        //sm:sm1,
	        colModel: createColModel(gridnoofcols),
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        listeners: {
              render : function(grid){
                grid.store.on('load', function(store, records, options){
                  grid.getSelectionModel().selectFirstRow();       
                });                      
              }
             },
	        plugins: [filters],	       
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
	 grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            iconCls : 'clearfilterbutton',
	            handler: function () {
	        	grid.filters.clearFilters();
	            } 
	        }]);
	if(reconfigure){
		grid.getBottomToolbar().add([
		 '-',                            
			{
          text: reconfigurestr,
          handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
          } 
      }]);
		}
		if(group){
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:groupstr,
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
		}
		if(add)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:addstr,
			    iconCls : 'addbutton',
			    handler : function(){
			    addRecord();

			    }    
			  }]);
		}	
		if(modify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:modifystr,
			    iconCls : 'editbutton',
			    id: 'modifyId',
			    handler : function(){
			    modifyData();

			    }    
			  }]);
		}	
		if(del)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:delstr,
			    iconCls : 'printbutton',
			    id: 'gridDeleteId',
			    handler : function(){
				PrintPDF();

			    }    
			  }]);
		}
		
		if(chart)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:chartstr,
			    handler : function(){
				columnchart();
			    }    
			  }]);
		}
		if(excel)
		{ 
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'excelbutton',
			    handler : function(){
				getordreport('xls','All',jspName,grid,exportDataType);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'pdfbutton',
			    handler : function(){
			    getordreport('pdf','All',jspName,grid,exportDataType);

			    }    
			  }]);
		}
		

	return grid;
}

//This grid is used for subtotal value passed for Export.
function getGridforSubtotal(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,subtotal,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr,closetrip,closestr,verify,verifystr,approve, approvestr,copy, copystr,postpone,postponestr,importExcel,importStr,save,saveStr,clearData,clearStr,close,closeStr){
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid',
	        colModel: createColModel(gridnoofcols),
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        listeners: {
               render : function(grid){
                 grid.store.on('load', function(store, records, options){
                   grid.getSelectionModel().selectFirstRow();       
                 });                      
               }
              },
	        plugins: [filters],	       
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
	 grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            iconCls : 'clearfilterbutton',
	            handler: function () {
	        	grid.filters.clearFilters();
	            } 
	        }]);
	if(reconfigure){
		grid.getBottomToolbar().add([
		 '-',                            
			{
           text: reconfigurestr,
           handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
           } 
       }]);
		}
		if(group){
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:groupstr,
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
		}
		if(add)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:addstr,
			    iconCls : 'addbutton',
			    handler : function(){
			    addRecord();

			    }    
			  }]);
		}	
		if(modify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:modifystr,
			    iconCls : 'editbutton',
			    id: 'modifyId',
			    handler : function(){
			    modifyData();

			    }    
			  }]);
		}	
		if(del)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:delstr,
			    iconCls : 'deletebutton',
			    id: 'gridDeleteId',
			    handler : function(){
			    deleteData();

			    }    
			  }]);
		}
		if(copy)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:copystr,
			    iconCls : 'copybutton',
			    id: 'gridCopyId',
			    handler : function(){
			    copyData();
			   }    
			  }]);
		}	
		if(chart)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:chartstr,
			    handler : function(){
				columnchart();
			    }    
			  }]);
		}
		if(excel)
		{   
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'excelbutton',
			    handler : function(){
				var subtotal=setReports('xls','All');
				getordreports('xls','All',jspName,grid,exportDataType,subtotal);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'pdfbutton',
			    handler : function(){
				var subtotal=setReports('xls','All');
				getordreports('pdf','All',jspName,grid,exportDataType,subtotal);
			    }    
			  }]);
		}
		if(closetrip)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:closestr,
			    iconCls:'closeTripbuttonS',
			    id: 'gridCloseTripId',
			    handler : function(){
				closetripsummary();
			    }    
			  }]);
		}
		if(verify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:verifystr,
			    iconCls:'',
			    id: 'gridVerifyId',
			    handler : function(){
					verifyFunction();
			    }    
			  }]);
		}
		if(approve)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:approvestr,
			    iconCls:'',
			    id: 'gridApproveId',
			    handler : function(){
					approveFunction();
			    }    
			  }]);
		}
		if(postpone)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:postponestr,
			    iconCls:'postponebutton',
			    id: 'gridPostponeId',
			    handler : function(){
					postponeFunction();
			    }    
			  }]);
		}
		if(importExcel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:importStr,
			    iconCls : 'excelbutton',
			    handler : function(){
			    importExcelData();

			    }    
			  }]);
		}
		if(save)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:saveStr,
			    iconCls : 'savebutton',
			    handler : function(){
			    saveDate();

			    }    
			  }]);
		}
		if(clearData)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:clearStr,
			    iconCls : 'clearbutton',
			    handler : function(){
			    clearInputData();

			    }    
			  }]);
		}
		if(close)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:closeStr,
			    iconCls : 'closebutton',
			    handler : function(){
			    closeImportWin();

			    }    
			  }]);
		}

	return grid;
}
/*****************Plotting ruler marker************************/
var poly;	
var rulerMarkers = [];
var latlongClicked = [];
var rulerlistener;
var path;	
var rulerContent;
var rulerInfowindow;
var rulerInfowindowArray=[];
var firstLoad=1;
var distance=0;
var totalDistance=[];
var previousMarker=0;
var map;
var distUnits;
var distFactor=0.62137;
// Function to start ruler
function plotRulerMarkerNew(map,startRulerId,removeRulerId,units){
	map=map;	
	distUnits = units;
	if(startRulerId){
		$(startRulerId).attr('onclick',"startRuler()");
	}
	if(removeRulerId){
		$(removeRulerId).attr('onclick',"removeRuler()");
	}
}
function plotRulerMarker(map,startRulerId,removeRulerId){
	distUnits="";
	map=map;	
	if(startRulerId){
		$(startRulerId).attr('onclick',"startRuler()");
	}
	if(removeRulerId){
		$(removeRulerId).attr('onclick',"removeRuler()");
	}
}
function startRuler(){
		if(rulerlistener!=null){
		removeRuler();
		}
			
	var lineSymbol = {
		 path: 'M 0,-1 0,1',
		 strokeOpacity: 1,
		 scale: 3
	 };
	 
	var polyOptions = {
		strokeColor: '#5eb9f9',
		strokeOpacity: 1.0,
		strokeWeight: 3
	};
	poly = new google.maps.Polyline({   
		strokeOpacity: 0,
		strokeColor: '#0026b3',
		icons: [{
 	 	icon: lineSymbol,      	
     	repeat: '15px'
   		}],
  		map: map
		 });
	rulerlistener= google.maps.event.addListener(map, 'click', addLatLng);	
}
//Function to remove ruler
function removeRuler(){

	if(poly!=null){
		poly.setMap(null);
	}

	for (var i = 0; i < rulerMarkers.length; i++) {
		rulerMarkers[i].setMap(null);
		}
	google.maps.event.removeListener(rulerlistener);
	rulerMarkers.length=0;
	latlongClicked.length=0;
	totalDistance.length=0;
}

function addLatLng(event) {
		path = poly.getPath();  
		path.push(event.latLng);
		latlongClicked[path.getLength()]=event.latLng;
		
// Add a new marker at the new plotted point on the polyline.
		var	rulerMarker = new google.maps.Marker({
			position: event.latLng,
			id: path.getLength(),
			map: map
		});
rulerMarkers.push(rulerMarker);

 google.maps.event.addListener(rulerMarker, 'click', function() {
 		if(rulerMarker.id>1){
			rulerInfowindow=rulerInfowindowArray[rulerMarker.id]
			rulerInfowindow.open(map,rulerMarker);  
 		}
	});	
if(path.getLength()>1){		 	
		var firstLatLong=latlongClicked[path.getLength()-1];
	var secondLatLong=latlongClicked[path.getLength()];
		if(path.getLength()>2){		
			distance=parseFloat(totalDistance[path.getLength()-1])+calcDistance(firstLatLong, secondLatLong);		
			}else{	
			distance=calcDistance(firstLatLong, secondLatLong);
			}
	if(distUnits.includes("miles")){
		distance=parseFloat(distance) * parseFloat(distFactor);
		}
	totalDistance[path.getLength()]=parseFloat(distance.toFixed(2)); 
	contentString = '<div id="content" seamless="seamless" scrolling="no" style="overflow:hidden; width:100%; height: 100%; float: left; color: #000; background:#ffffff; line-height:100%; font-size:100%; font-family: sans-serif;">'+
    '<b id="firstHeading" class="firstHeading">'+distance.toFixed(2)+'&nbsp;'+distUnits+'</b>'+
    '</div>';
		rulerInfowindow = new google.maps.InfoWindow({
    	content: contentString
		});
 		rulerInfowindow.open(map,rulerMarker);
 		rulerInfowindowArray[path.getLength()]=rulerInfowindow;
} 

if(firstLoad==1){
	animateCircle();
 }
firstLoad=0;
}	

function calcDistance(p1, p2){
	 return parseFloat((google.maps.geometry.spherical.computeDistanceBetween(p1, p2) / 1000).toFixed(2));
	}
	
	function animateCircle() {
		 var count = 0;
		 window.setInterval(function () {
		    count = (count + 1) % 200;		
		    var icons = poly.get('icons');
		    icons[0].offset = (count / 2) + '%';
		    poly.set('icons', icons);
		 }, 100);
}
/********************* search Box **********************/
function searchBox(map,searchId){
	var markers1=[];
	var place;
	var input = (document.getElementById(searchId));
	map.controls[google.maps.ControlPosition.TOP_RIGHT].push(input);
	var searchBox = new google.maps.places.SearchBox(input);
// [START region_getplaces]
// Listen for the event fired when the user selects an item from the
// pick list. Retrieve the matching places for that item.
	
google.maps.event.addListener(searchBox, 'places_changed', function() {
	var places = searchBox.getPlaces();
	if (places.length == 0) {
		return;
	}

	 for (var i = 0; i < markers1.length; i++) {
		  markers1[i].setMap(null);
	  }
	   
 // For each place, get the icon, place name, and location.
 var bounds = new google.maps.LatLngBounds();

 for ( var i = 0, place; place = places[i]; i++) {
   var image = {
	     url: place.icon,
	     size: new google.maps.Size(71, 71),
	     origin: new google.maps.Point(0, 0),
	     anchor: new google.maps.Point(17, 34),
	     scaledSize: new google.maps.Size(25, 25)
   };
 

   // Create a marker for each place.
  var  marker1 = new google.maps.Marker({
	   map: map,
	   icon: image,
	   title: place.name,
	   position: place.geometry.location     
   });
   markers1.push(marker1);
   bounds.extend(place.geometry.location);
 }

 map.fitBounds(bounds);
 if (map.getZoom() > 16) map.setZoom(15);
 
});

// [END region_getplaces]
// Bias the SearchBox results towards places that are within the bounds of the
// current map's viewport.

google.maps.event.addListener(map, 'bounds_changed', function() {
	 var bounds = map.getBounds();
	 searchBox.setBounds(bounds);
});
}

/*********** Common pop-up window function   *******/
function openLocationWindow(locationPage,windowTitle)
{
createMapWindow(locationPage,windowTitle);
}
function createMapWindow(locationPage,windowTitle){
var win = new Ext.Window({
       title:windowTitle,
       autoShow : false,
	   constrain : false,
	   constrainHeader : false,
	   resizable : false,
	   maximizable : true,   
   	   footer:true,
       width:840,
       height:400,
       shim:false,
       animCollapse:false,
       border:false,
       constrainHeader:true,
       layout: 'fit',
html : "<iframe style='width:100%;height:100%;background:#ffffff' src="+locationPage+"></iframe>",
listeners: {
maximize: function(){
},
minimize:function(){
},
resize:function(){
},
restore:function(){
}
}
   });
 
   win.show();
}

/**
 * Grid Definition.For add,modify and delete write the function definition in your jsp page
 * @param gridtitle
 * @param emptytext
 * @param store
 * @param width
 * @param height
 * @param gridnoofcols
 * @param filters
 * @param filterstr
 * @param reconfigure
 * @param reconfigurestr
 * @param reconfigurenoofcols
 * @param group
 * @param groupstr
 * @param chart
 * @param chartstr
 * @param excel
 * @param excelstr
 * @param jspName
 * @param exportDataType
 * @param pdf
 * @param pdfstr
 * @param add
 * @param addstr
 * @param modify
 * @param modifystr
 * @param del
 * @param delstr
 * @return
 */

function getSeatingStructureGrid(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr,closetrip,closestr,verify,verifystr,approve, approvestr,copy, copystr,postpone,postponestr,importExcel,importStr,save,saveStr,clearData,clearStr,close,closeStr){
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid',
	        colModel: createColModel(gridnoofcols),
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        listeners: {
                render : function(grid){
                  grid.store.on('load', function(store, records, options){
                         
                  });                      
                },
                cellclick:{fn:showSeatingStructure}
               },
	        plugins: [filters],	       
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
	 grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            iconCls : 'clearfilterbutton',
	            handler: function () {
	        	grid.filters.clearFilters();
	            } 
	        }]);
	if(reconfigure){
		grid.getBottomToolbar().add([
		 '-',                            
			{
            text: reconfigurestr,
            handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
            } 
        }]);
		}
		if(group){
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:groupstr,
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
		}
		if(add)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:addstr,
			    iconCls : 'addbutton',
			    handler : function(){
			    addRecord();

			    }    
			  }]);
		}	
		if(modify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:modifystr,
			    iconCls : 'editbutton',
			    id: 'modifyId',
			    handler : function(){
			    modifyData();

			    }    
			  }]);
		}	
		if(del)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:delstr,
			    iconCls : 'deletebutton',
			    id: 'gridDeleteId',
			    handler : function(){
			    deleteData();

			    }    
			  }]);
		}
		if(copy)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:copystr,
			    iconCls : 'copybutton',
			    id: 'gridCopyId',
			    handler : function(){
			    copyData();
			   }    
			  }]);
		}	
		if(chart)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:chartstr,
			    handler : function(){
				columnchart();
			    }    
			  }]);
		}
		if(excel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'excelbutton',
			    handler : function(){
				getordreport('xls','All',jspName,grid,exportDataType);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'pdfbutton',
			    handler : function(){
			    getordreport('pdf','All',jspName,grid,exportDataType);

			    }    
			  }]);
		}
		if(closetrip)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:closestr,
			    iconCls:'closeTripbuttonS',
			    id: 'gridCloseTripId',
			    handler : function(){
				closetripsummary();
			    }    
			  }]);
		}
		if(verify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:verifystr,
			    iconCls:'',
			    id: 'gridVerifyId',
			    handler : function(){
					verifyFunction();
			    }    
			  }]);
		}
		if(approve)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:approvestr,
			    iconCls:'',
			    id: 'gridApproveId',
			    handler : function(){
					approveFunction();
			    }    
			  }]);
		}
		if(postpone)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:postponestr,
			    iconCls:'postponebutton',
			    id: 'gridPostponeId',
			    handler : function(){
					postponeFunction();
			    }    
			  }]);
		}
		if(importExcel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:importStr,
			    iconCls : 'excelbutton',
			    handler : function(){
			    importExcelData();

			    }    
			  }]);
		}
		if(save)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:saveStr,
			    iconCls : 'savebutton',
			    handler : function(){
			    saveDate();

			    }    
			  }]);
		}
		if(clearData)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:clearStr,
			    iconCls : 'clearbutton',
			    handler : function(){
			    clearInputData();

			    }    
			  }]);
		}
		if(close)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:closeStr,
			    iconCls : 'closebutton',
			    handler : function(){
			    closeImportWin();

			    }    
			  }]);
		}

	return grid;
}

/**
 * This common function for live vision
 * 
 */

function getLiveVisionGrid(gridtitle,emptytext,selmodel,store,width,height,gridnoofcols,refresh,refreshstr,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,
		groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,userSetting,userSettingStr){
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid',
	        bodyCssClass:'liveVisionGridStyle',
	        colModel: createColModel(gridnoofcols),
	        selModel: selmodel,
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        listeners: {
              render : function(grid){
                grid.store.on('load', function(store, records, options){
                      
                });                      
              },
              cellclick:{fn:viewFuelPercentage}
             },
	        plugins: [filters],	       
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
	 grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            iconCls : 'clearfilterbutton',
	            handler: function () {
	        	grid.filters.clearFilters();
	            } 
	        }]);
	if(reconfigure){
		grid.getBottomToolbar().add([
		 '-',                            
			{
          text: reconfigurestr,
          handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
          } 
      }]);
		}
		if(group){
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:groupstr,
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
		}
		if(refresh)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:refreshstr,
			    iconCls : 'refreshbutton',
			    handler : function(){
			    refreshRecord();

			    }    
			  }]);
		}
		if(add)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:addstr,
			    iconCls : 'addbutton',
			    handler : function(){
			    addRecord();

			    }    
			  }]);
		}	
		if(modify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:modifystr,
			    iconCls : 'editbutton',
			    id: 'modifyId',
			    handler : function(){
			    modifyData();

			    }    
			  }]);
		}		
		if(excel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'excelbutton',
			    handler : function(){
				getLiveVisionReport('xls','All',jspName,grid,exportDataType);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'pdfbutton',
			    handler : function(){
				getLiveVisionReport('pdf','All',jspName,grid,exportDataType);

			    }    
			  }]);
		}
		if(userSetting)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:userSettingStr,
			    iconCls : '',
			    handler : function(){
				readFilterSelectionDetails();

			    }    
			  }]);
		}
	return grid;
}
function getSelectionModelEditorGridCashVan(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr,sm){
	 var grid = new Ext.grid.EditorGridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid',
	        colModel: createColModel(gridnoofcols),
	        loadMask: true,
	        sm: sm,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        plugins: [filters],
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);

	}
	 grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            handler: function () {
	        	grid.filters.clearFilters();
	            } 
	        }]);
	if(reconfigure){
		grid.getBottomToolbar().add([
			{
           text: reconfigurestr,
           handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
           } 
       }]);
		}
		if(group){
			grid.getBottomToolbar().add([
			{
			    text:groupstr,
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
		}
		if(del)
		{
			grid.getBottomToolbar().add([
			{
			    text:delstr,
			    handler : function(){
			    deleteData();
			    }    
			  }]);
		}	
		if(add)
		{
			grid.getBottomToolbar().add([
			{
			    text:addstr,
			    handler : function(){
			    addRecord();

			    }    
			  }]);
		}	
		if(modify)
		{
			grid.getBottomToolbar().add([
			{
			    text:modifystr,
			    handler : function(){
			    modifyData();

			    }    
			  }]);
		}	
		if(chart)
		{
			grid.getBottomToolbar().add([
			{
			    text:chartstr,
			    handler : function(){
				columnchart();
			    }    
			  }]);
		}
		if(excel)
		{
			grid.getBottomToolbar().add([
			{
			    text:excelstr,
			    handler : function(){
				getordreport('xls','All',jspName,grid,exportDataType);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			{
			    text:pdfstr,
			    handler : function(){
			    getordreport('pdf','All',jspName,grid,exportDataType);

			    }    
			  }]);
		}	
	return grid;
}
						
function getGridManager(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr,closetrip,closestr,verify,verifystr,approve, approvestr,copy, copystr,postpone,postponestr,importExcel,importStr,save,saveStr,clearData,clearStr,close,closeStr){
	 
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid',
	        colModel: createColModel(gridnoofcols),
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        listeners: {
               render : function(grid){
                 grid.store.on('load', function(store, records, options){
                   grid.getSelectionModel().selectFirstRow();       
                 });                      
               }
              },
	        plugins: [filters],	       
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
	 grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            iconCls : 'clearfilterbutton',
	            handler: function () {
	        		grid.filters.clearFilters();
	            } 
	        }]);
		if(reconfigure){
			grid.getBottomToolbar().add([
			 '-',                            
				{
	           text: reconfigurestr,
	           handler: function () {
			   grid.reconfigure(store, createColModel(reconfigurenoofcols));
	           } 
	       }]);
		}
		
		if(group)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:groupstr,
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
		}
		if(add)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:addstr,
			    iconCls : 'addbutton',
			    handler : function(){
			    addRecord();
			    }    
			}]);
		}
		else
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
				id: 'gridAddId',
			    text:addstr,
			    iconCls : 'addbuttonDisable',
			    disabled: true,
			    tooltip: 'Supervisor/User Cannot Do This Operation',
			    handler : function(){
			   		 addRecord();
			    }    
			}]);
		}
			
		if(modify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:modifystr,
			    iconCls : 'editbutton',
			    id: 'modifyId',
			    handler : function(){
			    modifyData();
			    }    
			 }]);
		}
		else 
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			text:modifystr,
			iconCls : 'editbuttondisabled',
			id: 'modifyId',
			disabled: true,
			tooltip: 'Supervisor/User Cannot Do This Operation',
			handler : function(){
				modifyData();
			}    
			}]);
		}
		if(del)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:delstr,
			    iconCls : 'deletebutton',
			    id: 'gridDeleteId',
			    handler : function(){
			    deleteData();
			    }    
			 }]);
		}
		else
		{
			grid.getBottomToolbar().add([
 			'-',                             
 			{
 			    text:delstr,
 			    iconCls : 'deletebuttondisabled',
 			    id: 'gridDeleteId',
 			    disabled: true,
 				tooltip: 'Supervisor/User Cannot Do This Operation',
 			    handler : function(){
 			    deleteData();
 			    }    
 			 }]);
		}
		if(copy)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:copystr,
			    iconCls : 'copybutton',
			    id: 'gridCopyId',
			    handler : function(){
			    copyData();
			   }    
			  }]);
		}
		else
		{
			/*grid.getBottomToolbar().add([
 			'-',                             
 			{
 			    text:copystr,
 			    iconCls : 'copybutton',
 			    id: 'gridCopyId',
 			    disabled: true,
				tooltip: 'Supervisor/User cannot Do this Operation',
 			    handler : function(){
 			    copyData();
 			   }    
 			  }]);*/
		}
			
		if(chart)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:chartstr,
			    id: 'chartId',
			    handler : function(){
				columnchart();
			    }    
			  }]);
		}
		else
		{
			/*grid.getBottomToolbar().add([
 			'-',                             
 			{
 			    text:chartstr,
 			    id: 'chartId',
 			    disabled: true,
				tooltip: 'Supervisor/User cannot Do this Operation',
 			    handler : function(){
 				columnchart();
 			    }    
 			  }]);*/	
		}
		if(excel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'excelbutton',
			    handler : function(){
				getordreport('xls','All',jspName,grid,exportDataType);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'pdfbutton',
			    handler : function(){
			    getordreport('pdf','All',jspName,grid,exportDataType);

			    }    
			  }]);
		}
		if(closetrip)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:closestr,
			    iconCls:'closeTripbuttonS',
			    id: 'gridCloseTripId',
			    handler : function(){
				closetripsummary();
			    }    
			  }]);
		}
		else
		{
			/*grid.getBottomToolbar().add([
			'-',                             
			{
			    text:closestr,
			    iconCls:'closeTripbuttonS',
			    disabled: true,
				tooltip: 'Supervisor/User cannot Do this Operation',
			    handler : function(){
				closetripsummary();
			    }    
			 }]);*/
		}
		if(verify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:verifystr,
			    iconCls:'',
			    id: 'gridVerifyId',
			    handler : function(){
					verifyFunction();
			    }    
			  }]);
		}
		else 
		{
			/*grid.getBottomToolbar().add([
 			'-',                             
 			{
 			    text:verifystr,
 			    iconCls:'',
 			    id: 'gridVerifyId',
 			    disabled: true,
				tooltip: 'Supervisor/User cannot Do this Operation',
 			    handler : function(){
 					verifyFunction();
 			    }    
 			}]);*/
		}
		if(approve)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:approvestr,
			    iconCls:'',
			    id: 'gridApproveId',
			    handler : function(){
					approveFunction();
			    }    
			}]);
		}
		else
		{
			/*grid.getBottomToolbar().add([
 			'-',                             
 			{
 			    text:approvestr,
 			    iconCls:'',
 			    id: 'gridApproveId',
 			    disabled: true,
				tooltip: 'Supervisor/User cannot Do this Operation',
 			    handler : function(){
 					approveFunction();
 			    }    
 			}]);*/
		}
		if(postpone)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:postponestr,
			    iconCls:'postponebutton',
			    id: 'gridPostponeId',
			    handler : function(){
					postponeFunction();
			    }    
			  }]);
		}
		else
		{
			/*grid.getBottomToolbar().add([
			'-',                             
			{
			    text:postponestr,
			    iconCls:'postponebutton',
			    id: 'gridPostponeId',
			    disabled: true,
			    tooltip: 'Supervisor/User cannot Do this Operation',
			    handler : function(){
					postponeFunction();
			    }    
			 }]);*/
		}	
		if(importExcel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:importStr,
			    iconCls : 'excelbutton',
			    handler : function(){
			    importExcelData();
			}    
			}]);
		}
		else
		{
			grid.getBottomToolbar().add([
 			'-',                             
 			{
 			    text:importStr,
 			    iconCls : 'excelbuttondisabled',
 			    disabled: true,
			    tooltip: 'Supervisor/User cannot Do this Operation',
 			    handler : function(){
 			    importExcelData();

 			    }    
 			 }]);
		}
		if(save)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:saveStr,
			    iconCls : 'savebutton',
			    handler : function(){
			    saveDate();

			    }    
			  }]);
		}
		else
		{
			/*grid.getBottomToolbar().add([
			'-',                            
			{
			    text:saveStr,
			    iconCls : 'savebutton',
			    disabled: true,
			    tooltip: 'Supervisor/User cannot Do this Operation',
			    handler : function(){
			    saveDate();
	
			    }    
			 }]);*/
		}
		if(clearData)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:clearStr,
			    iconCls : 'clearbutton',
			    handler : function(){
			    clearInputData();

			    }    
			  }]);
		}
		else
		{
			/*grid.getBottomToolbar().add([
 			'-',                            
 			{
 			    text:clearStr,
 			    iconCls : 'clearbutton',
 			    disabled: true,
			    tooltip: 'Supervisor/User cannot Do this Operation',
 			    handler : function(){
 			    clearInputData();

 			    }    
 			 }]);*/
		}
		if(close)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:closeStr,
			    iconCls : 'closebutton',
			    handler : function(){
			    closeImportWin();

			    }    
			  }]);
		}
		/*else
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:closeStr,
			    disabled: true,
			    tooltip: 'Supervisor/User cannot Do this Operation',
			    handler : function(){
			    closeImportWin();
	
			    }    
			  }]);
		}*/
		
	return grid;
}


function getGridManagerNew(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr,closetrip,closestr,verify,verifystr,approve, approvestr,copy, copystr,postpone,postponestr,importExcel,importStr,save,saveStr,clearData,clearStr,close,closeStr){
	 
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid',
	        colModel: createColModel(gridnoofcols),
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        listeners: {
              render : function(grid){
                grid.store.on('load', function(store, records, options){
                  grid.getSelectionModel().selectFirstRow();       
                });                      
              }
             },
	        plugins: [filters],	       
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
	
	grid.getBottomToolbar().add([
	                             '->',
	                 	        {}]);
	if(filterstr){
	 grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            iconCls : 'clearfilterbutton',
	            handler: function () {
	        		grid.filters.clearFilters();
	            } 
	        }]);
	}
		if(reconfigure){
			grid.getBottomToolbar().add([
			 '-',                            
				{
	           text: reconfigurestr,
	           handler: function () {
			   grid.reconfigure(store, createColModel(reconfigurenoofcols));
	           } 
	       }]);
		}
		
		
		if(add)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:addstr,
			    iconCls : 'addbutton',
			    handler : function(){
			    addRecord();
			    }    
			}]);
		}
		else
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
				id: 'gridAddId',
			    text:addstr,
			    iconCls : 'addbuttonDisable',
			    disabled: true,
			    tooltip: 'Supervisor/User Cannot Do This Operation',
			    handler : function(){
			   		 addRecord();
			    }    
			}]);
		}
			
		if(modify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:modifystr,
			    iconCls : 'editbutton',
			    id: 'modifyId',
			    handler : function(){
			    modifyData();
			    }    
			 }]);
		}
		else 
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			text:modifystr,
			iconCls : 'editbuttondisabled',
			id: 'modifyId',
			disabled: true,
			tooltip: 'Supervisor/User Cannot Do This Operation',
			handler : function(){
				modifyData();
			}    
			}]);
		}
		if(del)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:delstr,
			    iconCls : 'deletebutton',
			    id: 'gridDeleteId',
			    handler : function(){
			    deleteData();
			    }    
			 }]);
		}
		else
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:delstr,
			    iconCls : 'deletebuttondisabled',
			    id: 'gridDeleteId',
			    disabled: true,
				tooltip: 'Supervisor/User Cannot Do This Operation',
			    handler : function(){
			    deleteData();
			    }    
			 }]);
		}
		if(copy)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:copystr,
			    iconCls : 'copybutton',
			    id: 'gridCopyId',
			    handler : function(){
			    copyData();
			   }    
			  }]);
		}
		else
		{
			/*grid.getBottomToolbar().add([
			'-',                             
			{
			    text:copystr,
			    iconCls : 'copybutton',
			    id: 'gridCopyId',
			    disabled: true,
				tooltip: 'Supervisor/User cannot Do this Operation',
			    handler : function(){
			    copyData();
			   }    
			  }]);*/
		}
			
		if(chart)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:chartstr,
			    id: 'chartId',
			    handler : function(){
				columnchart();
			    }    
			  }]);
		}
		else
		{
			/*grid.getBottomToolbar().add([
			'-',                             
			{
			    text:chartstr,
			    id: 'chartId',
			    disabled: true,
				tooltip: 'Supervisor/User cannot Do this Operation',
			    handler : function(){
				columnchart();
			    }    
			  }]);*/	
		}
		if(excel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'excelbutton',
			    handler : function(){
				getordreport('xls','All',jspName,grid,exportDataType);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'pdfbutton',
			    handler : function(){
			    getordreport('pdf','All',jspName,grid,exportDataType);

			    }    
			  }]);
		}
		if(closetrip)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:closestr,
			    iconCls:'closeTripbuttonS',
			    id: 'gridCloseTripId',
			    handler : function(){
				closetripsummary();
			    }    
			  }]);
		}
		else
		{
			/*grid.getBottomToolbar().add([
			'-',                             
			{
			    text:closestr,
			    iconCls:'closeTripbuttonS',
			    disabled: true,
				tooltip: 'Supervisor/User cannot Do this Operation',
			    handler : function(){
				closetripsummary();
			    }    
			 }]);*/
		}
		if(verify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:verifystr,
			    iconCls:'',
			    id: 'gridVerifyId',
			    handler : function(){
					verifyFunction();
			    }    
			  }]);
		}
		else 
		{
			/*grid.getBottomToolbar().add([
			'-',                             
			{
			    text:verifystr,
			    iconCls:'',
			    id: 'gridVerifyId',
			    disabled: true,
				tooltip: 'Supervisor/User cannot Do this Operation',
			    handler : function(){
					verifyFunction();
			    }    
			}]);*/
		}
		if(approve)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:approvestr,
			    iconCls:'',
			    id: 'gridApproveId',
			    handler : function(){
					approveFunction();
			    }    
			}]);
		}
		else
		{
			/*grid.getBottomToolbar().add([
			'-',                             
			{
			    text:approvestr,
			    iconCls:'',
			    id: 'gridApproveId',
			    disabled: true,
				tooltip: 'Supervisor/User cannot Do this Operation',
			    handler : function(){
					approveFunction();
			    }    
			}]);*/
		}
		if(postpone)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:postponestr,
			    iconCls:'postponebutton',
			    id: 'gridPostponeId',
			    handler : function(){
					postponeFunction();
			    }    
			  }]);
		}
		else
		{
			/*grid.getBottomToolbar().add([
			'-',                             
			{
			    text:postponestr,
			    iconCls:'postponebutton',
			    id: 'gridPostponeId',
			    disabled: true,
			    tooltip: 'Supervisor/User cannot Do this Operation',
			    handler : function(){
					postponeFunction();
			    }    
			 }]);*/
		}	
		if(importExcel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:importStr,
			    iconCls : 'excelbutton',
			    handler : function(){
			    importExcelData();
			}    
			}]);
		}
		else
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:importStr,
			    iconCls : 'excelbuttondisabled',
			    disabled: true,
			    tooltip: 'Supervisor/User cannot Do this Operation',
			    handler : function(){
			    importExcelData();

			    }    
			 }]);
		}
		if(save)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:saveStr,
			    iconCls : 'savebutton',
			    handler : function(){
			    saveDate();

			    }    
			  }]);
		}
		else
		{
			/*grid.getBottomToolbar().add([
			'-',                            
			{
			    text:saveStr,
			    iconCls : 'savebutton',
			    disabled: true,
			    tooltip: 'Supervisor/User cannot Do this Operation',
			    handler : function(){
			    saveDate();
	
			    }    
			 }]);*/
		}
		if(clearData)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:clearStr,
			    iconCls : 'clearbutton',
			    handler : function(){
			    clearInputData();

			    }    
			  }]);
		}
		else
		{
			/*grid.getBottomToolbar().add([
			'-',                            
			{
			    text:clearStr,
			    iconCls : 'clearbutton',
			    disabled: true,
			    tooltip: 'Supervisor/User cannot Do this Operation',
			    handler : function(){
			    clearInputData();

			    }    
			 }]);*/
		}
		if(close)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:closeStr,
			    iconCls : 'closebutton',
			    handler : function(){
			    closeImportWin();

			    }    
			  }]);
		}
		/*else
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:closeStr,
			    disabled: true,
			    tooltip: 'Supervisor/User cannot Do this Operation',
			    handler : function(){
			    closeImportWin();
	
			    }    
			  }]);
		}*/
		
	return grid;
}


window.oncontextmenu = function () {return false;}
document.onkeydown = function(e) {
    if (event.keyCode == 123) {
        return false;
    }
    if (e.ctrlKey && e.shiftKey && e.keyCode == 'I'.charCodeAt(0)) {
        return false;
    }
    if (e.ctrlKey && e.shiftKey && e.keyCode == 'J'.charCodeAt(0)) {
        return false;
    }
    if (e.ctrlKey && e.keyCode == 'U'.charCodeAt(0)) {
        return false;
    }
};
function convertMinutesToHHMM(minutes){
	  var hour = Math.floor(minutes / 60);
	  var min = minutes % 60;
	  hour = hour < 10 ? '0' + hour : hour;
	  min = min < 10 ? '0' + min : min;
	  return hour + ':' + min;
}
function convertMinutesToDDHHMM(fromDateMillisec){
    var d = fromDateMillisec;

    var dSeconds = d / 1000;
    var dM = d / (60 * 1000);
    var dH = d / (60 * 60 * 1000);
    var dD = d / (24 * 60 * 60 * 1000);
    var hours = (d % (24 * 60 * 60 * 1000)) / (60 * 60 * 1000);
    var minutes = ((d % (24 * 60 * 60 * 1000)) % (60 * 60 * 1000)) / (60 * 1000);
    dD  = Math.floor(dD);
    minutes = Math.floor(minutes);
    hours   = Math.floor(hours);
    dD = dD < 10 ? '0' + dD : dD;
    hours = hours < 10 ? '0' + hours : hours;
    minutes = minutes < 10 ? '0' + minutes : minutes;
    formateddaysHoursMinutes = dD + ":" + hours + ":" + minutes;    
    
    return formateddaysHoursMinutes;
 }

function convertDDHHMMToMinutes(dayhourminutes) {

	if(dayhourminutes == ''){
		return 0;
	}
	var duration=0;
	var arr = dayhourminutes.split(":");
	var day=arr[0];
	var hours=arr[1];
	var minutes=arr[2];
	var hoursdouble = 0;
	var daysdouble = 0;
	if (hours != '') {
		hoursdouble=parseInt(hours)*60;
	}
	if (day != '') {
		daysdouble=parseInt(day)*1440;
	}
	duration = parseInt(daysdouble)+parseInt(hoursdouble)+parseInt(minutes);
	return duration;
}

/**
 * Google Analytics code 
 * telematics4u.in
 * */
 
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-91363675-1', 'auto');
  ga('send', 'pageview');
  