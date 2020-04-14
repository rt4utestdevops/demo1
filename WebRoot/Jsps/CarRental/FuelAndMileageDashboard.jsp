<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	
if(loginInfo != null){
			}
else 
 {
 	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
 	
 }
%>


<!doctype html>
<html>

<head>
    <title>Mileage and Refuel</title>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css">
    <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">

    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

    <style>
        #title {
            font-weight: 600;
            font-size: 30px;
        }
        
        #viewId {
            float: right;
            margin-top: -40px;
        }
    </style>
</head>

<body onload="loadPanenls()">
    <div class="container">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h2 id="title">Mileage and Fuel Summary Dashboard </h2>
                <button type="button" class="btn btn-danger" id="viewId" OnClick="changeView()">GRIDVIEW</button>
            </div>
            <!-- /.panel-heading -->
            <div class="panel-body">
                <div class="row" id="panelsId"> </div>
                <div class="col-lg-12 col-md-12 col-sm-12 " id="gridId" style="display:none">
                    <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th>SLNO</th>
                                <th>MODEL TYPE</th>
                                <th>MODEL NAME</th>
                                <th>CITYWISE MILEAGE(kmpl)</th>
                                <th>VEHICLE COUNT</th>
                                <th>CITY</th>
                                <th>VEHICLE LIST</th>
                            </tr>
                        </thead>

                    </table>
                </div>

            </div>
            <!-- /.panel-body -->
        </div>
        <!-- /.panel -->
        <div class="alert alert-info alert-dismissable" id="noteId" style="display:none;">
            <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a>
            <strong>Note: </strong> The Refuel and Mileage summary calculations are in  between date range <span id="sdate"></span> and <span id="edate"></span> .
        </div>
    </div>

<script>
var cityWiseMileage;
var startDate;
var endDate;

function loadPanenls() {
    $.ajax({
        url: '<%=request.getContextPath()%>/HBAnalysisGraphAction.do?param=getCityWiseAvgMileage',
        success: function(result) {
            cityWiseMileage = JSON.parse(result);
            for (var i = 0; i < cityWiseMileage["CityWiseAvgMileage"].length; i++) {
                var city = cityWiseMileage["CityWiseAvgMileage"][i].city;
                var mileage = cityWiseMileage["CityWiseAvgMileage"][i].mileage;
                var modelName = cityWiseMileage["CityWiseAvgMileage"][i].modelName;
                var modelType = cityWiseMileage["CityWiseAvgMileage"][i].modelType;
                var vehicleCount = cityWiseMileage["CityWiseAvgMileage"][i].vehicleCount;
                startDate = cityWiseMileage["CityWiseAvgMileage"][i].startDate;
                endDate = cityWiseMileage["CityWiseAvgMileage"][i].endDate;
                var obj = document.getElementById('panelsId');
                var div1 = document.createElement("div");
                div1.style.fontFamily = 'Helvetica Neue", Helvetica, Roboto, Arial, sans-serif';
                div1.innerHTML += '<div class="col-lg-4 col-md-6 col-sm-6 "> ' +
                    '<div class="panel panel-theme panel-danger"> ' +
                    '   <div class="panel-heading"><label>City: <span class="badge badge-default">' + city + '</span>  </div> ' +
                    '   <div class="panel-body"> ' +
                    '      <div class="col-lg-12 col-md-12 col-sm-12"> ' +
                    '         <div class="thumbnail"> ' +
                    '            <img src="../../Main/images/caricon.png">  ' +
                    '            <div class="caption"> ' +
                    '               <h4>Make: <span class="badge badge-default">' + modelType + '</span>  </h4> ' +
                    '               <h4>Model: <span class="badge badge-default">' + modelName + '</span></h4> ' +
                    '               <h4>CityWise Mileage(kmpl): <span class="badge">' + mileage + '</span></h4> ' +
                    '               <h4>Vehicle Count: <span class="badge">' + vehicleCount + '</span></h4> ' +
                    '            </div> ' +
                    '         </div> ' +
                    //'         <a href="CityAndModelWiseRefuelSummary.jsp?City='+city+'&ModelName='+modelName+'" class="btn btn-default btn-xs pull-right" role="button"><i class="glyphicon glyphicon-edit"></i></a> '+
                    '         <a href="CityAndModelWiseRefuelSummary.jsp?City=' + city + '&ModelName=' + modelName + '" class="btn btn-info btn-xs" role="button">Show Vehicles</a> ' +
                    '      </div> ' +
                    '   </div> ' +
                    '</div> ';

                obj.appendChild(div1);
            }
            if (typeof startDate === "undefined") {
			}else{
	            document.getElementById("noteId").style.display = "block";
	            document.getElementById("sdate").innerHTML = startDate;
	            document.getElementById("edate").innerHTML = endDate;
			}
            
        }
    });

}

function changeView() {
    var obj = document.getElementById("viewId");
    var val = obj.innerHTML;
    if (val == 'PANELVIEW') {
        document.getElementById("viewId").innerHTML = "GRIDVIEW"
        document.getElementById("panelsId").style.display = "block";
        document.getElementById("gridId").style.display = "none";

        jQuery('#panelsId div').html('');
        for (var i = 0; i < cityWiseMileage["CityWiseAvgMileage"].length; i++) {
            var city = cityWiseMileage["CityWiseAvgMileage"][i].city;
            var mileage = cityWiseMileage["CityWiseAvgMileage"][i].mileage;
            var modelName = cityWiseMileage["CityWiseAvgMileage"][i].modelName;
            var modelType = cityWiseMileage["CityWiseAvgMileage"][i].modelType;
            var vehicleCount = cityWiseMileage["CityWiseAvgMileage"][i].vehicleCount;
            var obj = document.getElementById('panelsId');
            var div1 = document.createElement("div");
            div1.style.fontFamily = 'Helvetica Neue", Helvetica, Roboto, Arial, sans-serif';
            div1.innerHTML += '<div class="col-lg-4 col-md-6 col-sm-6 "> ' +
                '<div class="panel panel-theme panel-danger"> ' +
                '   <div class="panel-heading"><label>City: <span class="badge badge-default">' + city + '</span>  </div> ' +
                '   <div class="panel-body"> ' +
                '      <div class="col-lg-12 col-md-12 col-sm-12"> ' +
                '         <div class="thumbnail"> ' +
                '            <img src="../../Main/images/caricon.png">  ' +
                '            <div class="caption"> ' +
                '               <h4>Make: <span class="badge badge-default">' + modelType + '</span>  </h4> ' +
                '               <h4>Model: <span class="badge badge-default">' + modelName + '</span></h4> ' +
                '               <h4>CityWise Mileage(kmpl): <span class="badge">' + mileage + '</span></h4> ' +
                '               <h4>Vehicle Count: <span class="badge">' + vehicleCount + '</span></h4> ' +
                '            </div> ' +
                '         </div> ' +
                //'         <a href="CityAndModelWiseRefuelSummary.jsp?City=' + city + '&ModelName=' + modelName + '" class="btn btn-default btn-xs pull-right" role="button"><i class="glyphicon glyphicon-edit"></i></a> ' +
                '         <a href="CityAndModelWiseRefuelSummary.jsp?City=' + city + '&ModelName=' + modelName + '" class="btn btn-info btn-xs" role="button">Show Vehicles</a> ' +
                '      </div> ' +
                '   </div> ' +
                '</div> ';

            obj.appendChild(div1);
        }
    } else {


        document.getElementById("viewId").innerHTML = "PANELVIEW"
        document.getElementById("panelsId").style.display = "none";
        document.getElementById("gridId").style.display = "block";

        if ($.fn.DataTable.isDataTable('#example')) {
            $('#example').DataTable().destroy();
        }

        var table = $('#example').DataTable({
            "ajax": {
                "url": "<%=request.getContextPath()%>/HBAnalysisGraphAction.do?param=getCityWiseAvgMileage",
                "dataSrc": "CityWiseAvgMileage"
            },
            "bLengthChange": false,
            "columns": [{
                "data": "slno"
            }, {
                "data": "modelType"
            }, {
                "data": "modelName"
            }, {
                "data": "mileage"
            }, {
                "data": "vehicleCount"
            }, {
                "data": "city"
            }, {
                "data": "details"
            }]
        });

    }



}
</script>
</body>
</html>


