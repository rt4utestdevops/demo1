

var app = angular.module('myApp', []);
app.controller('myCtrl', function($scope, $http) {
	
	 $scope.filters = { };
	 $scope.alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	 $scope.contextPath = path;
	 $scope.loading = true;
     $http.get(path+'/StoppageReportAction.do?param=distributionLogisticsDashboardNewElementsCount')
     .then(function(response) {
      //$scope.loading = false;
      $scope.result = response.data;
     
	  $scope.onTimeId = $scope.result.dashboardElementsCountRoot[0].count.onTime;
	  $scope.delayedId = $scope.result.dashboardElementsCountRoot[0].count.delayed;
	  $scope.delayedAddressId = $scope.result.dashboardElementsCountRoot[0].count.delayedAddress;
	  $scope.beforeTimeId = $scope.result.dashboardElementsCountRoot[0].count.beforeTime;
	  $scope.overSpeedId = $scope.result.dashboardElementsCountRoot[0].count.overSpeed;
	  $scope.vehicleStoppageId = $scope.result.dashboardElementsCountRoot[0].count.vehicleStoppage;
	  
     });
	  $http.get(path+'/StoppageReportAction.do?param=distributionLogisticsDashboardNewElements')
	     .then(function(response) {
	      $scope.result = response.data;
	  
	  $scope.dashboardDetails = $scope.result.dashboardElementsRoot[0].grid;
	  $scope.touchPointsArray = $scope.result.dashboardElementsRoot[0].grid[0].touchPoints;
	  $scope.clientName = $scope.result.dashboardElementsRoot[0].grid[0].clientName;
	  
	  $scope.loading = false;
  });
  
});


$(document).ready(function(){
/*	$.noConflict();
	  $('body').popover({
	        selector: '[data-toggle=popover]',
	        trigger: "click"
	    }).on("show.bs.popover", function(e) {
	        alert(" hide all other popovers");
	        $("[data-toggle=popover]").not(e.target).popover("destroy");
	        $(".popover").remove();
	    });*/
	
	

	   /* $('body').on('click', function(e) {
	        alert("did not click a popover toggle or popover");
	        if ($(e.target).data('toggle') !== 'popover' &&
	            $(e.target).parents('.popover.in').length === 0) {
	        	alert("in");
	            $('[data-toggle="popover"]').popover('hide');
	        }
	    });*/
});


