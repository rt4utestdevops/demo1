<%@ page language="java" import="java.util.*,t4u.beans.*,t4u.functions.CommonFunctions,t4u.functions.AdminFunctions,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	if(!list.isEmpty()){
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
	if(str.length>11){
	loginInfo.setStyleSheetOverride(str[11].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
	}
}
CommonFunctions cf=new CommonFunctions();
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
	session.setAttribute("loginInfoDetails",loginInfo);
	ArrayList<String> tobeConverted=new ArrayList<String>();
	tobeConverted.add("Filter");
	tobeConverted.add("Delete_Asset_Details");
  	tobeConverted.add("Are_you_sure_you_want_to_delete");
	
	ArrayList<String> convertedWords=new ArrayList<String>();
	String language=loginInfo.getLanguage();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
	String filter = convertedWords.get(0);
	String DeleteAssetDetails = convertedWords.get(1);
	String Areyousureyouwanttodelete = convertedWords.get(2);
	
	String SysId = request.getParameter("systemId");
	String ClientId = request.getParameter("custId");
	String category = request.getParameter("category");
	String value = request.getParameter("value");
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>Document View</title>

	<script type="text/javascript">var _gaq = _gaq || []; _gaq.push(['_setAccount', 'UA-1396058-8']); _gaq.push(['_trackPageview']); (function() { var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true; ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js'; var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s); })();</script>
	<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
	<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
	<pack:script src="../../Main/Js/T4UStatusBar.js"></pack:script>
	<pack:script src="../../Main/Js/Common.js"></pack:script>
	<pack:script src="../../Main/Js/cancelbackspace.js"></pack:script>
	<pack:script src="../../Main/resources/ux/statusbar/StatusBar.js"></pack:script>
	<pack:script src="../../Main/resources/ux/statusbar/ValidationStatus.js"></pack:script>
	<pack:script src="../../Main/resources/ux/fileuploadfield/FileUploadField.js"></pack:script>
	<pack:style src="../../Main/resources/css/ext-all.css" />
	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
	<pack:style src="../../Main/resources/css/chooser.css" />
	<pack:style src="../../Main/resources/css/xtheme-blue.css" />
	<pack:style src="../../Main/resources/css/common.css" />
	<pack:style src="../../Main/resources/css/commonnew.css" />
	<pack:style src="../../Main/iconCls/icons.css" />
	<pack:style src="../../Main/resources/ux/statusbar/css/statusbar.css" />

	<script type="text/javascript" >

var ImageChooser = function(config){
	this.config = config;
}

ImageChooser.prototype = {
    // cache data by image name for easy lookup
    lookup : {},

	show : function(callback){
		if(!this.win){
			this.initTemplates();

			this.store = new Ext.data.JsonStore({
			    url: this.config.url,
			    root: 'images',
			    fields: [
			        'id','name', 'url',
			        {name:'size', type: 'float'},
			        {name:'lastmod', type:'date', dateFormat:'timestamp'}
			    ],
			    listeners: {
			    	'load': {fn:function(){ this.view.select(0); }, scope:this, single:true}
			    }
			});
			this.store.load();
		    
			var formatSize = function(data){
		        if(data.size < 1024) {
		            return data.size + " bytes";
		        } else {
		            return (Math.round(((data.size*10) / 1024))/10) + " KB";
		        }
		    };

			var formatData = function(data){
		    	data.shortName = data.name.ellipse(15);
		    	data.sizeString = formatSize(data);
		    	data.dateString = new Date(data.lastmod).format("m/d/Y g:i a");
		    	this.lookup[data.name] = data;
		    	return data;
		    };

		    this.view = new Ext.DataView({
				tpl: this.thumbTemplate,
				singleSelect: true,
				overClass:'x-view-over',
				itemSelector: 'div.thumb-wrap',
				loadingText: 'Loading Images please Wait.....',
				emptyText : '<div style="padding:10px;">No images match the specified filter</div>',
				store: this.store,
				listeners: {
					'selectionchange': {fn:this.showDetails, scope:this, buffer:100},
					//'removed'       : {fn:this.doCallback, scope:this},
					//'removed'       : {fn:this.onRemoved, scope:this},
					'loadexception'  : {fn:this.onLoadException, scope:this},
					'beforeselect'   : {fn:function(view){
				        return view.store.getRange().length > 0;
				    }}
				},
				prepareData: formatData.createDelegate(this)
			});

			var cfg = {
		    	//title: 'Document Chooser',
		    	id: 'img-chooser-dlg',
		    	layout: 'border',
				minWidth: 1000,
				minHeight: 300,
				modal: true,
				region: 'left',
				closable: false,
				resizable: false,
				border: false,
				draggable : false,
				items:[{
					id: 'img-chooser-view',
					region: 'center',
					autoScroll: true,
					items: this.view,
                    tbar:[{
                    	text: '<%=filter%>:'
                    },{
                    	xtype: 'textfield',
                    	id: 'filter',
                    	selectOnFocus: true,
                    	width: 100,
                    	listeners: {
                    		'render': {fn:function(){
						    	Ext.getCmp('filter').getEl().on('keyup', function(){
						    		this.filter();
						    	}, this, {buffer:500});
                    		}, scope:this}
                    	}
                    },'-',{
                    	
							id: 'delete-btn',
							text: 'Delete',
							iconCls : 'deletebutton',
							handler: this.doCallback,
							scope: this
						}
				]
				},{
					id: 'img-detail-panel',
					region: 'east',
					split: true,
					autoScroll: true,
					width: 700,
					minWidth: 150,
					maxWidth: 1150
				}]
			};
			Ext.apply(cfg, this.config);
		    this.win = new Ext.Window(cfg);
		}

		this.reset();
	    this.win.show();
		this.callback = callback;
		
	},

	initTemplates : function(){
		this.thumbTemplate = new Ext.XTemplate(
			'<tpl for=".">',
				'<div class="thumb-wrap" id="{name}">',
				'<div class="thumb"><img src="{url}" title="{name}"></div>',
				'<span>{shortName}</span></div>',
			'</tpl>'
		);
		this.thumbTemplate.compile();
		

		this.detailsTemplate = new Ext.XTemplate(
			'<div class="details">',
				'<tpl for=".">',
					'<a href="{url}" download="{name}"><img src="{url}" title="Click here to download"></a><div class="details-info">',
					'<b>Document Name:</b>',
					'<span>{name}</span>',
				'</tpl>',
			'</div>'
		);
		this.detailsTemplate.compile();
	},

	showDetails : function(){
	    var selNode = this.view.getSelectedNodes();
	    var detailEl = Ext.getCmp('img-detail-panel').body;
		if(selNode && selNode.length > 0){
			selNode = selNode[0];
			//Ext.getCmp('delete-btn').enable();
		    var data = this.lookup[selNode.id];
            detailEl.hide();
            this.detailsTemplate.overwrite(detailEl, data);
            detailEl.slideIn('l', {stopFx:true,duration:.2});
		}else{
		    //Ext.getCmp('delete-btn').disable();
		    detailEl.update('');
		}
	},

	filter : function(){
		var filter = Ext.getCmp('filter');
		this.view.store.filter('name', filter.getValue());
		this.view.select(0);
	},

	sortImages : function(){
		var v = Ext.getCmp('sortSelect').getValue();
    	this.view.store.sort(v, v == 'name' ? 'asc' : 'desc');
    	this.view.select(0);
    },

	reset : function(){
		if(this.win.rendered){
			Ext.getCmp('filter').reset();
			this.view.getEl().dom.scrollTop = 0;
		}
	    this.view.store.clearFilter();
		this.view.select(0);
	},

	doCallback : function(){
        var selNode = this.view.getSelectedNodes()[0];
		var callback = this.callback;
		var lookup = this.lookup;
		if(this.view.getSelectedNodes().length > 0){
			this.win.hide(this.animateTarget, function(){
            	if(selNode && callback){
					var data = lookup[selNode.id];
					//callback(data);
					Ext.Msg.show({
				        title: '<%=DeleteAssetDetails%>',
				        msg: '<%=Areyousureyouwanttodelete%>',
				        progressText: 'Deleting  ...',
				        buttons: {
				            yes: true,
				            no: true
				        },
				        fn: function (btn) {
				            switch (btn) {
				            case 'yes':
				            
								Ext.Ajax.request({
									url: '<%=request.getContextPath()%>/AssetGroupAction.do?param=deleteAssetDocument&SystemId=<%=SysId%>&ClientId=<%=ClientId%>&category=<%=category%>&value=<%=value%>',
									params : { delImgFile : data.name, delImageId: data.id }, 
									method: 'POST',
									success:function(response, options)//start of success
									{
										Ext.Msg.alert('Status', response.responseText, function(btn){
									      window.location.reload(); 
									    });
									}, // END OF  SUCCESS
									failure: function()//start of failure 
									{
										window.location.reload();
									} // END OF FAILURE 
								});//end of ajax
								
								break;
				            case 'no':
				                window.location.reload();
				                break;
				                
							}
						}
					});
			}});//end of win.hide
		} else {
			Ext.Msg.alert('Status', 'No records found to delete');
		}
    },
 	
	onLoadException : function(v,o){
	    this.view.getEl().update('<div style="padding:10px;">Error loading images.</div>');
	}
};

String.prototype.ellipse = function(maxLength){
    if(this.length > maxLength){
        return this.substr(0, maxLength-3) + '...';
    }
    return this;
};
</script>
	<script type="text/javascript">
	Ext.onReady(function(){
    var chooser;

    function insertImage(data){
    	Ext.DomHelper.append('images', {
    		tag: 'img', 
    		src: data.url, 
    		style:'margin:10px;visibility:hidden;'
    	}, true).show(true).frame();
    	btn.focus();
    };

  
    	
    		chooser = new ImageChooser({
    			url:'<%=request.getContextPath()%>/DocumentManagement.do?param=getDocuments&SystemId=<%=SysId%>&ClientId=<%=ClientId%>&category=<%=category%>&value=<%=value%>' ,
    			height:Ext.getBody().getViewSize().height-100,
    			width:Ext.getBody().getViewSize().width-10
    		}).show(insertImage);
    

   
});

function loadData(){

	if ( <%= loginInfo.getCustomerId() %>  != 0){
		Ext.getCmp('delete-btn').hide();
	} else {
		Ext.getCmp('delete-btn').show();
	}
}
</script>

</head>
<body onload="loadData()">
	
		
	<div id="buttons" ></div>
	<div id="images" ></div>
</body>
</html>
<%}%>