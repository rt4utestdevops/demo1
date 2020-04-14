  var modfiedHubIdToCircle = {};
  var modfiedHubIdToPolygon = {};
  function plotBuffersForSmartHub(){
      modfiedHubIdToCircle = {};
	    for(var i=0;i<bufferStoreSmartHub.getCount();i++){
	    var rec=bufferStoreSmartHub.getAt(i);
	    var urlForZero='/ApplicationImages/VehicleImages/red.png';
	    var convertRadiusToMeters = rec.data['radius'] * 1000;
	    var myLatLng = new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);       	
	        createCircle = {
	            strokeColor: '#A7A005',
    			    strokeOpacity: 0.8,
    			    strokeWeight: 3,
	                fillOpacity: 0.55,
                    fillColor: '#ECF086',
	                map: mapView,
	                center: myLatLng,
              draggable: true,
              editable: true,
              id :rec.data['hubId'], 
	            radius: convertRadiusToMeters //In meters
	        };
          	  bufferimage = {
	        	url: urlForZero, // This marker is 20 pixels wide by 32 pixels tall.
	        	scaledSize: new google.maps.Size(19, 35), // The origin for this image is 0,0.
	        	origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
	        	anchor: new google.maps.Point(0, 32)
	    	};      

	  buffermarker = new google.maps.Marker({
            	position: myLatLng,
            	id:rec.data['hubId'],
            	map: mapView,
            	icon:bufferimage

        	});
       buffercontent=rec.data['buffername']; 	
		   bufferinfowindow = new google.maps.InfoWindow({
      		content:buffercontent,
      		id:rec.data['hubId'],
      		marker:buffermarker
  		});	
  		//add event listner on drag event of marker
    
  		google.maps.event.addListener(buffermarker,'click', (function(buffermarker,buffercontent,bufferinfowindow){ 
    			return function() {
        			bufferinfowindow.setContent(buffercontent);
        			bufferinfowindow.open(mapView,buffermarker);
    			};
			})(buffermarker,buffercontent,bufferinfowindow)); 
			buffermarker.setAnimation(google.maps.Animation.DROP); 
    	buffermarkersmart[i]=buffermarker;
			circlessmart[i] = new google.maps.Circle(createCircle);
      buffermarkersmart[i].bindTo("position", circlessmart[i], "center");
       google.maps.event.addListener(circlessmart[i], 'radius_changed', function(event) {
                    this.getCenter().lng().toString().replace(/(\.\d{1,5})\d*$/, "$1")
                    this.getCenter().lat().toString().replace(/(\.\d{1,5})\d*$/, "$1")
                     modfiedHubIdToCircle[this.id] = this;
  	            });

        google.maps.event.addListener(circlessmart[i], 'center_changed', function(event) {

                        this.getCenter().lng().toString().replace(/(\.\d{1,5})\d*$/, "$1")
                        this.getCenter().lat().toString().replace(/(\.\d{1,5})\d*$/, "$1")
                        modfiedHubIdToCircle[this.id] = this;
        });
	    }
    }
function plotPolygonSmartHub(){
    var hubid=0;
    var polygonCoords=[];
    modfiedHubIdToPolygon = {};
    for(var i=0;i<polygonStoreSmartHub.getCount();i++)
    {
    	  var rec=polygonStoreSmartHub.getAt(i);
      	if(i!=polygonStoreSmartHub.getCount()-1 && rec.data['hubid']==polygonStoreSmartHub.getAt(i+1).data['hubid'])
      	{
          	var latLong=new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);
          	polygonCoords.push(latLong);
          	continue;
    		}
    		else
    		{
      		  var latLong=new google.maps.LatLng(rec.data['latitude'],rec.data['longitude']);
          	polygonCoords.push(latLong);
    		}
	  	polygon = new google.maps.Polygon({
    			paths: polygonCoords,
    			strokeColor: '#A7A005',
    			strokeOpacity: 0.8,
    			strokeWeight: 3,
          draggable: true,
          editable: true,
    			fillColor: '#ECF086',
          fillOpacity: 0.55,
          id :rec.data['hubid']
			});

                                	
		polygonimage = {
        	url: '/ApplicationImages/VehicleImages/red.png', // This marker is 20 pixels wide by 32 pixels tall.
        	size: new google.maps.Size(48, 48), // The origin for this image is 0,0.
        	origin: new google.maps.Point(0, 0), // The anchor for this image is the base of the flagpole at 0,32.
        	anchor: new google.maps.Point(0, 32)
    	}; 	
			
		  polygonmarker = new google.maps.Marker({
        	position:latLong,
        	map: mapView,
        	icon:polygonimage
    	});
    	var polygoncontent=rec.data['polygonname'];
		  polygoninfowindow = new google.maps.InfoWindow({
  		  	content:polygoncontent,
  			  marker:polygonmarker
	    });	
	
 	google.maps.event.addListener(polygonmarker,'click', (function(polygonmarker,polygoncontent,polygoninfowindow){ 
    			return function() {
        			polygoninfowindow.setContent(polygoncontent);
        			polygoninfowindow.open(map,polygonmarker);
    			};
    		})(polygonmarker,polygoncontent,polygoninfowindow)); 
    		polygonmarker.setAnimation(google.maps.Animation.DROP); 
    		polygon.setMap(mapView);
    		polygonsmart[hubid]=polygon;
    		polygonmarkersmart[hubid]=polygonmarker;
        //polygonsmart[hubid].bindTo("position", polygonmarkersmart[hubid], "center");
         google.maps.event.addListener(polygonsmart[hubid], 'editable_changed', function(event) {
    	  		//alert("editable_changed");
            modfiedHubIdToPolygon[this.id] = this;
   	                            
        });

        google.maps.event.addListener(polygonsmart[hubid], 'draggable_changed', function(event) {
           	//alert("draggable_changed");	        
                modfiedHubIdToPolygon[this.id] = this;                     
        });
    		hubid++;
    		polygonCoords=[];
        
   
        }
    }
	 
 

