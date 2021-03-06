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
<%
String City="";
String ModelName="";
String PageName="";
City=request.getParameter("City");
ModelName=request.getParameter("ModelName");
PageName=request.getParameter("PageName");

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
    <script>
    (function($){

    $.session = {

        _id: null,

        _cookieCache: undefined,

        _init: function()
        {
            if (!window.name) {
                window.name = Math.random();
            }
            this._id = window.name;
            this._initCache();

            // See if we've changed protcols

            var matches = (new RegExp(this._generatePrefix() + "=([^;]+);")).exec(document.cookie);
            if (matches && document.location.protocol !== matches[1]) {
               this._clearSession();
               for (var key in this._cookieCache) {
                   try {
                   window.sessionStorage.setItem(key, this._cookieCache[key]);
                   } catch (e) {};
               }
            }

            document.cookie = this._generatePrefix() + "=" + document.location.protocol + ';path=/;expires=' + (new Date((new Date).getTime() + 120000)).toUTCString();

        },

        _generatePrefix: function()
        {
            return '__session:' + this._id + ':';
        },

        _initCache: function()
        {
            var cookies = document.cookie.split(';');
            this._cookieCache = {};
            for (var i in cookies) {
                var kv = cookies[i].split('=');
                if ((new RegExp(this._generatePrefix() + '.+')).test(kv[0]) && kv[1]) {
                    this._cookieCache[kv[0].split(':', 3)[2]] = kv[1];
                }
            }
        },

        _setFallback: function(key, value, onceOnly)
        {
            var cookie = this._generatePrefix() + key + "=" + value + "; path=/";
            if (onceOnly) {
                cookie += "; expires=" + (new Date(Date.now() + 120000)).toUTCString();
            }
            document.cookie = cookie;
            this._cookieCache[key] = value;
            return this;
        },

        _getFallback: function(key)
        {
            if (!this._cookieCache) {
                this._initCache();
            }
            return this._cookieCache[key];
        },

        _clearFallback: function()
        {
            for (var i in this._cookieCache) {
                document.cookie = this._generatePrefix() + i + '=; path=/; expires=Thu, 01 Jan 1970 00:00:01 GMT;';
            }
            this._cookieCache = {};
        },

        _deleteFallback: function(key)
        {
            document.cookie = this._generatePrefix() + key + '=; path=/; expires=Thu, 01 Jan 1970 00:00:01 GMT;';
            delete this._cookieCache[key];
        },

        get: function(key)
        {
            return window.sessionStorage.getItem(key) || this._getFallback(key);
        },

        set: function(key, value, onceOnly)
        {
            try {
                window.sessionStorage.setItem(key, value);
            } catch (e) {}
            this._setFallback(key, value, onceOnly || false);
            return this;
        },
        
        'delete': function(key){
            return this.remove(key);
        },

        remove: function(key)
        {
            try {
            window.sessionStorage.removeItem(key);
            } catch (e) {};
            this._deleteFallback(key);
            return this;
        },

        _clearSession: function()
        {
          try {
                window.sessionStorage.clear();
            } catch (e) {
                for (var i in window.sessionStorage) {
                    window.sessionStorage.removeItem(i);
                }
            }
        },

        clear: function()
        {
            this._clearSession();
            this._clearFallback();
            return this;
        }

    };

    $.session._init();

})(jQuery);
    </script>
    <style>
    #title
    {
    font-weight: 600;
    font-size: 25px;
    color: dodgerblue;
    }
    #example_filter{
   margin-top: -40px;
	}
   
    </style>
	
</head>

<body onload="LoadData()">
    <div class="col-lg-12">
        <div class="col-lg-8">
            <div class="panel panel-default">
                <div class="panel-heading" id="title">
                    VehicleWise Mileage Summary
                    <a href="FuelAndMileageDashboard.jsp" class="btn btn-info btn-md" style="float: right; border-radius: 10px;"> <span class="glyphicon glyphicon-circle-arrow-left"></span> Back</a>
                </div>
                <!-- /.panel-heading -->
                <div class="panel-body">
                    <p>
                        <label> City: <span class="badge badge-default" id="cityId"></span> </label>
                        <label> Model Name: <span class="badge badge-default" id="modelId"></span> </label>
                    </p>
                    <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th>SLNO</th>
                                <th>REGISTRATION_NO</th>
                                <th>MILEAGE(kmpl)</th>
                                <th>DETAILS</th>
                            </tr>
                        </thead>

                    </table>
                </div>
                <!-- /.panel-body -->
            </div>
            <!-- /.panel -->
        </div>

    </div>
  <script>
 var City = '<%=City%>'
 var ModelName = '<%=ModelName%>'
 var pageName = '<%=PageName%>'

 function LoadData() {
     if (pageName == "Back") {
         City = $.session.get('City');
         ModelName = $.session.get('ModelName');
     } else {
         $.session.clear();
         $.session.set('City', City);
         $.session.set('ModelName', ModelName);

     }
     document.getElementById("cityId").innerHTML = City;
     document.getElementById("modelId").innerHTML = ModelName;
     // getVechileFuelSummary("TS10XTR7437");
     var table = $('#example').DataTable({
         "processing": true,
         //  "serverSide": true,
         "ajax": {
             "url": "<%=request.getContextPath()%>/HBAnalysisGraphAction.do?param=getVechileWiseMileage",
             "data": {
                 City: City,
                 ModelName: ModelName
             },
             "dataSrc": "VechileWiseMileage"
         },
         "bLengthChange": false,
         "columns": [{
             "data": "slno"
         }, {
             "data": "vehicleNo"
         }, {
             "data": "mileage"
         }, {
             "data": "details"
         }]
     });

 }
  </script>
  
 </body>
</html>
