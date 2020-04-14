<%@ page language="java"
	import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
  	
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String processId= request.getParameter("processId");
String systemid=request.getParameter("systemid");
String language=request.getParameter("language");
String checkFDAS=request.getParameter("checkFDAS");
//System.out.println("******pid:"+processId);
//System.out.println("******systemid:"+systemid);
//System.out.println("******language:"+language);
//System.out.println("******checkFDAS:"+checkFDAS);

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>Inward Stationary</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
 <style>
.x-panel-tl {
	border-bottom: 0px solid !important;
} 
</style>
	<body>

	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  	<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
  <script>
  $( function() {
    $( "#sortable" ).sortable();
    $( "#sortable" ).disableSelection();
  } );
  window.onload=function(){
           
             $.ajax({
		    	url: "<%=request.getContextPath()%>/MapView.do?param=addFilter", 
		    	data:{
		    		
		    		processId: <%=processId%>,
		    		language: '<%=language%>',
		    		systemid: <%=systemid%>,
		    		checkFDAS: <%=checkFDAS%>
		    	},
		    	"dataSrc": "columnDetailsRoot",
		    	success: function(result){
		    	var checkstatus="unchecked";
		    		results = JSON.parse(result);
		    		
		    			
		    		for (var i = 0; i < results['columnDetailsRoot'].length; i++){
		    		if(results['columnDetailsRoot'][i].visibilityIndex == 'true'){
		    	 
			    		checkstatus="checked";
			    		}else{
			    		checkstatus="unchecked";
			    		}
			    		
		    			if((results['columnDetailsRoot'][i].valueIndex == 'Vehicle_No')){
		    				$("#sortable").append(" <li  font-family: 'Open Sans', 'sans-serif' id='columnIndex"+i+" ' ><span class=' '><input name= 'tabledata' type='checkbox' checked disabled value='"+results['columnDetailsRoot'][i].valueIndex+"'/></span>"+results['columnDetailsRoot'][i].nameIndex+"</li>") ;
		    			}else{
							$("#sortable").append(" <li font-family: 'Open Sans', 'sans-serif' id='columnIndex"+i+" ' ><span class=' '><input name= 'tabledata' type='checkbox' "+checkstatus+" value='"+results['columnDetailsRoot'][i].valueIndex+"'/></span>"+results['columnDetailsRoot'][i].nameIndex+"</li>") ;
			    		}
		    		}
		    		
	        	}
	        });
        }    
//var idsInOrder = $("#sortable").sortable('toArray');
//alert()
var j=0;
 $(document).ready(function() {
        $("#savefilterId").click(function(){
            var order = [];
            $.each($("input[name='tabledata']"), function(){            
                order.push($(this).val(),j,this.checked);
                j++;
            });
            
            var order1=order.join(", ");
            $.ajax({
		    	url: "<%=request.getContextPath()%>/MapView.do?param=updateUserFilter", 
		    	data:{
		    		
		    		order: order1
		    		
		    	},
		    	success: function(result){
		    	//parent.myWin1.close();
		    	//document.getElementById('47').click();
		    	parent.window.location.reload(1);
		    	}
		    	});
        });
    });                             
$(document).ready(function() {
        $("#resetfilterId").click(function(){
            
            $.ajax({
		    	url: "<%=request.getContextPath()%>/MapView.do?param=resetUserFilter", 
		    	
		    	success: function(result){
		    	//parent.myWin1.close();
		    	//document.getElementById('47').click();
		    	window.location.reload(1);
		    	}
		    	});
        });
    });                             
                
                
  </script>
  <b>Check the items you want to display . You can rearrange the table by dragging the elements.</b><br/>
  <ul id="sortable" class="filtertable">
  
</ul>
<input type='button' value='SAVE' id='savefilterId'></input>
<input type='button' value='RESET' id='resetfilterId'></input>

	</body>
</html>
