// demo = {
//   initDocumentationCharts: function() {
//     if ($('#dailySalesChart').length != 0 && $('#websiteViewsChart').length != 0) {
//       /* ----------==========     Daily Sales Chart initialization For Documentation    ==========---------- */
//
//       dataDailySalesChart = {
//         labels: ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
//         series: [
//           [12, 17, 7, 17, 23, 18, 38]
//         ]
//       };
//
//       optionsDailySalesChart = {
//         lineSmooth: Chartist.Interpolation.cardinal({
//           tension: 0
//         }),
//         low: 0,
//         high: 50, // creative tim: we recommend you to set the high sa the biggest value + something for a better look
//         chartPadding: {
//           top: 0,
//           right: 0,
//           bottom: 0,
//           left: 0
//         },
//       }
//
//       var dailySalesChart = new Chartist.Line('#dailySalesChart', dataDailySalesChart, optionsDailySalesChart);
//
//       var animationHeaderChart = new Chartist.Line('#websiteViewsChart', dataDailySalesChart, optionsDailySalesChart);
//     }
//   },
//
//   initDashboardPageCharts: function() {
//
//     if ($('#dailySalesChart').length != 0 || $('#completedTasksChart').length != 0 || $('#websiteViewsChart').length != 0) {
//       /* ----------==========     Daily Sales Chart initialization    ==========---------- */
//
//       dataDailySalesChart = {
//         labels: ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
//         series: [
//           [12, 17, 7, 17, 23, 18, 38]
//         ]
//       };
//
//       optionsDailySalesChart = {
//         lineSmooth: Chartist.Interpolation.cardinal({
//           tension: 0
//         }),
//         low: 0,
//         high: 50, // creative tim: we recommend you to set the high sa the biggest value + something for a better look
//         chartPadding: {
//           top: 0,
//           right: 0,
//           bottom: 0,
//           left: 0
//         },
//       }
//
//       var dailySalesChart = new Chartist.Line('#dailySalesChart', dataDailySalesChart, optionsDailySalesChart);
//
//       md.startAnimationForLineChart(dailySalesChart);
//
//
//
//       /* ----------==========     Completed Tasks Chart initialization    ==========---------- */
//
//       dataCompletedTasksChart = {
//         labels: ['12p', '3p', '6p', '9p', '12p', '3a', '6a', '9a'],
//         series: [
//           [230, 750, 450, 300, 280, 240, 200, 190]
//         ]
//       };
//
//       optionsCompletedTasksChart = {
//         lineSmooth: Chartist.Interpolation.cardinal({
//           tension: 0
//         }),
//         low: 0,
//         high: 1000, // creative tim: we recommend you to set the high sa the biggest value + something for a better look
//         chartPadding: {
//           top: 0,
//           right: 0,
//           bottom: 0,
//           left: 0
//         }
//       }
//
//       var completedTasksChart = new Chartist.Line('#completedTasksChart', dataCompletedTasksChart, optionsCompletedTasksChart);
//
//       // start animation for the Completed Tasks Chart - Line Chart
//       md.startAnimationForLineChart(completedTasksChart);
//
//
//       /* ----------==========     Emails Subscription Chart initialization    ==========---------- */
//
//       var dataWebsiteViewsChart = {
//         labels: ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'],
//         series: [
//           [542, 443, 320, 780, 553, 453, 326, 434, 568, 610, 756, 895]
//
//         ]
//       };
//       var optionsWebsiteViewsChart = {
//         axisX: {
//           showGrid: false
//         },
//         low: 0,
//         high: 1000,
//         chartPadding: {
//           top: 0,
//           right: 5,
//           bottom: 0,
//           left: 0
//         }
//       };
//       var responsiveOptions = [
//         ['screen and (max-width: 640px)', {
//           seriesBarDistance: 5,
//           axisX: {
//             labelInterpolationFnc: function(value) {
//               return value[0];
//             }
//           }
//         }]
//       ];
//       var websiteViewsChart = Chartist.Bar('#websiteViewsChart', dataWebsiteViewsChart, optionsWebsiteViewsChart, responsiveOptions);
//
//       //start animation for the Emails Subscription Chart
//       md.startAnimationForBarChart(websiteViewsChart);
//     }
//   },
//
//   initGoogleMaps: function(type) {
//     var myLatlng = new google.maps.LatLng(21.146633, 79.088860);
//     var mapOptions = {
//       zoom: 4.8,
//       center: myLatlng,
//       scrollwheel: false, //we disable de scroll over the map, it is a really annoing when you scroll through page
//       styles: [
//                   {
//                       "featureType": "all",
//                       "elementType": "labels.text.fill",
//                       "stylers": [
//                           {
//                               "color": "#7c93a3"
//                           },
//                           {
//                               "lightness": "-10"
//                           }
//                       ]
//                   },
//                   {
//                       "featureType": "water",
//                       "elementType": "geometry.fill",
//                       "stylers": [
//                           {
//                               "color": "#7CC7DF"
//                           }
//                       ]
//                   }
//               ]
//
//     };
//     map = new google.maps.Map(document.getElementById("map"), mapOptions);
//     map1 = new google.maps.Map(document.getElementById("map1"), mapOptions);
//
//     if(type == "red" || type == "all"){
//         icon = {
//               path: "M20 8h-3V4H3c-1.1 0-2 .9-2 2v11h2c0 1.66 1.34 3 3 3s3-1.34 3-3h6c0 1.66 1.34 3 3 3s3-1.34 3-3h2v-5l-3-4zM6 18.5c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zm13.5-9l1.96 2.5H17V9.5h2.5zm-1.5 9c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5z",
//               fillColor: '#FF0000',
//               fillOpacity: .8,
//               anchor: new google.maps.Point(0,0),
//               strokeWeight: 0,
//               scale: 1
//           }
//
//         markerRed = new google.maps.Marker({
//           position: myLatlng,
//           title: "Nagpur",
//           icon: icon
//         });
//
//         // To add the marker to the map, call setMap();
//
//         markerRed.setMap(map);
//         markerRed.addListener('click', function(event, i) {
//           $("#vehicleDetails").show();
//         });
//    }
//
//    if(type == "redSmall"){
//        iconRed = {
//              path: "M20 8h-3V4H3c-1.1 0-2 .9-2 2v11h2c0 1.66 1.34 3 3 3s3-1.34 3-3h6c0 1.66 1.34 3 3 3s3-1.34 3-3h2v-5l-3-4zM6 18.5c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zm13.5-9l1.96 2.5H17V9.5h2.5zm-1.5 9c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5z",
//              fillColor: '#FF0000',
//              fillOpacity: .8,
//              anchor: new google.maps.Point(0,0),
//              strokeWeight: 0,
//              scale: 1
//          }
//
//       var markerRedSmall = new google.maps.Marker({
//          position: myLatlng,
//          title: "Nagpur",
//          icon: icon
//        });
//
//        // To add the marker to the map, call setMap();
//
//        markerRedSmall.setMap(map1);
//
//   }
//
//    if(type == "green" || type == "all"){
//      iconGreen = {
//             path: "M20 8h-3V4H3c-1.1 0-2 .9-2 2v11h2c0 1.66 1.34 3 3 3s3-1.34 3-3h6c0 1.66 1.34 3 3 3s3-1.34 3-3h2v-5l-3-4zM6 18.5c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zm13.5-9l1.96 2.5H17V9.5h2.5zm-1.5 9c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5z",
//             fillColor: '#228B22',
//             fillOpacity: .8,
//             anchor: new google.maps.Point(0,0),
//             strokeWeight: 0,
//             scale: 1
//         }
//
//       markerGreen = new google.maps.Marker({
//         position: new google.maps.LatLng(12.971599,77.594566),
//         title: "Bangalore",
//         icon: iconGreen
//       });
//
//       // To add the marker to the map, call setMap();
//       markerGreen.setMap(map);
//       markerGreen.addListener('click', function(event, i) {
//         $("#vehicleDetails").show();
//       });
//     }
//
//     if(type == "orange" || type == "all"){
//       iconOrange = {
//             path: "M20 8h-3V4H3c-1.1 0-2 .9-2 2v11h2c0 1.66 1.34 3 3 3s3-1.34 3-3h6c0 1.66 1.34 3 3 3s3-1.34 3-3h2v-5l-3-4zM6 18.5c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zm13.5-9l1.96 2.5H17V9.5h2.5zm-1.5 9c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5z",
//             fillColor: "#FF8C00",
//             fillOpacity: .8,
//             anchor: new google.maps.Point(0,0),
//             strokeWeight: 0,
//             scale: 1
//         }
//
//
//       markerOrange = new google.maps.Marker({
//         position: new google.maps.LatLng(28.644800,77.216721),
//         title: "Delhi",
//         icon: iconOrange
//       });
//
//       // To add the marker to the map, call setMap();
//       markerOrange.setMap(map);
//       markerOrange.addListener('click', function(event, i) {
//         $("#vehicleDetails").show();
//       });
//     }
//
//   },
//
//   showNotification: function(from, align) {
//     type = ['', 'info', 'danger', 'success', 'warning', 'rose', 'primary'];
//
//     color = Math.floor((Math.random() * 6) + 1);
//
//     $.notify({
//       icon: "add_alert",
//       message: "Welcome to <b>Material Dashboard</b> - a beautiful freebie for every web developer."
//
//     }, {
//       type: type[color],
//       timer: 3000,
//       placement: {
//         from: from,
//         align: align
//       }
//     });
//   },
//   initGoogleMaps2: function (element) {
//     var myLatlng = new google.maps.LatLng(21.146633, 79.088860);
//     var mapOptions = {
//       zoom: 4.8,
//       center: myLatlng,
//       scrollwheel: false, //we disable de scroll over the map, it is a really annoing when you scroll through page
//       styles: [{
//         "featureType": "water",
//         "stylers": [{
//           "saturation": 43
//         }, {
//           "lightness": -11
//         }, {
//           "hue": "#0088ff"
//         }]
//       }, {
//         "featureType": "road",
//         "elementType": "geometry.fill",
//         "stylers": [{
//           "hue": "#ff0000"
//         }, {
//           "saturation": -100
//         }, {
//           "lightness": 99
//         }]
//       }, {
//         "featureType": "road",
//         "elementType": "geometry.stroke",
//         "stylers": [{
//           "color": "#808080"
//         }, {
//           "lightness": 54
//         }]
//       }, {
//         "featureType": "landscape.man_made",
//         "elementType": "geometry.fill",
//         "stylers": [{
//           "color": "#ece2d9"
//         }]
//       }, {
//         "featureType": "poi.park",
//         "elementType": "geometry.fill",
//         "stylers": [{
//           "color": "#ccdca1"
//         }]
//       }, {
//         "featureType": "road",
//         "elementType": "labels.text.fill",
//         "stylers": [{
//           "color": "#767676"
//         }]
//       }, {
//         "featureType": "road",
//         "elementType": "labels.text.stroke",
//         "stylers": [{
//           "color": "#ffffff"
//         }]
//       }, {
//         "featureType": "poi",
//         "stylers": [{
//           "visibility": "off"
//         }]
//       }, {
//         "featureType": "landscape.natural",
//         "elementType": "geometry.fill",
//         "stylers": [{
//           "visibility": "on"
//         }, {
//           "color": "#b8cb93"
//         }]
//       }, {
//         "featureType": "poi.park",
//         "stylers": [{
//           "visibility": "on"
//         }]
//       }, {
//         "featureType": "poi.sports_complex",
//         "stylers": [{
//           "visibility": "on"
//         }]
//       }, {
//         "featureType": "poi.medical",
//         "stylers": [{
//           "visibility": "on"
//         }]
//       }, {
//         "featureType": "poi.business",
//         "stylers": [{
//           "visibility": "simplified"
//         }]
//       }]
//
//     };
//     var map = new google.maps.Map(element, mapOptions);
//     var icon = {
//           path: "M20 8h-3V4H3c-1.1 0-2 .9-2 2v11h2c0 1.66 1.34 3 3 3s3-1.34 3-3h6c0 1.66 1.34 3 3 3s3-1.34 3-3h2v-5l-3-4zM6 18.5c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zm13.5-9l1.96 2.5H17V9.5h2.5zm-1.5 9c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5z",
//           fillColor: '#FF0000',
//           fillOpacity: .8,
//           anchor: new google.maps.Point(0,0),
//           strokeWeight: 0,
//           scale: 1
//       }
//
//     var marker = new google.maps.Marker({
//       position: myLatlng,
//       title: "Nagpur",
//       icon: icon
//     });
//
//     // To add the marker to the map, call setMap();
//     marker.setMap(map);
//
//     var iconGreen = {
//           path: "M20 8h-3V4H3c-1.1 0-2 .9-2 2v11h2c0 1.66 1.34 3 3 3s3-1.34 3-3h6c0 1.66 1.34 3 3 3s3-1.34 3-3h2v-5l-3-4zM6 18.5c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zm13.5-9l1.96 2.5H17V9.5h2.5zm-1.5 9c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5z",
//           fillColor: '#228B22',
//           fillOpacity: .8,
//           anchor: new google.maps.Point(0,0),
//           strokeWeight: 0,
//           scale: 1
//       }
//
//     marker = new google.maps.Marker({
//       position: new google.maps.LatLng(12.971599,77.594566),
//       title: "Bangalore",
//       icon: iconGreen
//     });
//
//     // To add the marker to the map, call setMap();
//     marker.setMap(map);
//   }
// }
