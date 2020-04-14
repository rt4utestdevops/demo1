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
<jsp:include page="../Common/header.jsp" />
<script>$(document).prop('title', 'Executive Static View');</script>
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<!--      <link rel="stylesheet" href="css/mutiselectDropdown.css">-->
			<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css">
			 <link rel="stylesheet" href="../../Main/sweetAlert/sweetalert.css">
			<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/css/select2.min.css" rel="stylesheet" />


      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/js/select2.min.js"></script>
         <script src="https://cdnjs.cloudflare.com/ajax/libs/multiple-select/1.2.0/multiple-select.js"></script>
        <script src="../../Main/sweetAlert/sweetalert.min.js"></script>
<!--      <script src="js/mutiselectDropdown.js"></script>-->
      <style>
         .custom{
         padding-left: 15px;
         padding-right: 15px;
         margin-left: auto;
         margin-right: auto;
         padding-top: 3px;
         }
         .align{
         text-align:center
         }
         .panel {
         margin-bottom: 17px;
         background-color: #fff;
         border: 1px solid #333 !important;
         border-radius: 4px;
         -webkit-box-shadow: 0 1px 1px rgba(0,0,0,.05);
         box-shadow: 0 1px 1px rgba(0,0,0,.05);
         }
         .percentageWell {
         float: right;
         background-color: #337ab7;
         color: #fff;
         padding: 9px;
         border-radius: 4px;
         /* border: 1px solid #333; */
         border-bottom: 1px solid #333;
         border-left: 1px solid #333;
         text-align: center;
         }
		 #description{
		   padding-right:13%;
		 }
		 #panelBox{
		    height:100px;
		 }
		 #routeList{
			 width:196.22px;
			 height: 34px;
		 }
		 #customerList{
			 width:196.22px;
			 height: 34px;
		 }
		 #add{
		 margin-top: 140px;
		 }
		 #add2{
		 margin-top: 140px;
		 }
		 #add3{
		 margin-top: 140px;
		 }
		 #add4{
		 margin-top: 140px;
		 }
		 .form-control{
		 	 width: 196.22px;
			 height: 34px;
		 }
		 .open>.dropdown-menu {
		     display: block;
		     height: 120px !important;
		     overflow-x: auto !important;
		     overflow-y: visible !important;
		   		 }
		 .multiselect dropdown-toggle btn btn-default{
			 width:196.22px;
			 height: 34px;
		 }

		 .btn-group.open .dropdown-toggle {
		 	 width:196.22px;
			 height: 34px;
		 }
		 .multiselect-selected-text{
		 	 width:196.22px;
			 height: 34px;
		 }
		 .btn-group>.btn:first-child {
		    width: 196.22px;
		}
		.modal-title{
		text-align: center;
		}

		#page-loader{
		 position:fixed;
		 left: 20%;
		 top: 35%;
		 z-index: 1000;
		 width:100%;
		 height:100%;
		 background-position:center;
		 z-index:10000000;
		 opacity: 0.7;
		 filter: alpha(opacity=40);
		 }
		 .btn .caret {
    display: none;
}
.multiselect-container {
    overflow-y: auto;
    height: 211px !important;
	
	
}
      </style>

      <div class="custom">

         <div class="col-md-12">
            <div class="panel panel-primary">
               <div class="panel-heading">
                  <h3 class="panel-title" >
                     <!-- <span class="glyphicon glyphicon-bookmark" > -->
<!--                     </span > -->
                     EXECUTIVE STATIC VIEW
                  </h3>
               </div>

               <div class="panel-body">

               <div class="panel row" style="padding:1% ;margin: 0%;">
			   <div class="col-md-12" >
			   <div class="col-md-2 " style="margin-right:3%">
			   <p>Select Customer: </p>
			   
			     <select class="form-control" multiple="multiple" id="customerList"  onchange="getRouteList()"  >
				<!--	 <option value="0" disabled >Select Customer</option> -->
				<!--  <option value="0">Select Customer</option> -->
				<!--  <option>TEST</option>-->
				</select>
               </div>
			       
			   <div class=" col-md-2 " style="margin-right:4%">
			   <p>Select Route: </p> 
			     <select class="form-control"  multiple="multiple" id="routeList"  >
				<!-- <option value="0"  disabled >Select Route</option> -->
					<!-- 	<option value="0">Select Route</option>  -->
				<!--    <option>T4U-SHADASHIV NAGAR</option>-->
				</select>
               </div>
			   <div class=" col-md-2 " style="margin-right:6%">
			   <p> <br > </p>
			     <select class="form-control"  id="rangeList" onchange="getComparison()" >
					<option value="0" >Select Analysis</option>
					<option id="1" value="1">Week-To-Date (WTD)</option>
					<option id="2" value="2">Month-To-Date (MTD)</option>
					<option id="3" value="3">Quarter-To-Date (QTD)</option>
					<option id="4" value="4">Year-To-Date (YTD)</option>
				</select>
               </div>
			   <div class=" col-md-2 " style="margin-right:3%">
			   <p> <br > </p>
			     <select class="form-control" id="comparisonList"  >
					<option value="0" >Select Comparison</option>
					<option id="option1Id"  value="1">To Previous</option>
					<option id="option2Id"  value="2" disabled> To Previous Year's Same (M/Q)</option>
				</select>
               </div>

			  
			    <div class="col-md-2">
				<p> <br > </p>
				<button type="button" id="submitbutton" class="btn btn-success" onclick="getDetails()">Submit</button>
			    </div>

<!--				<div class="col-md-3">-->
<!--				<button type="button"  style="margin-left: 1050px;margin-top:-56px;" class="btn btn-success" name="hidePDF" id="hidePDF" onclick="ExeStaticPdfButton()"> PDF </button>-->
<!--			    </div>-->
				 </div>
			    </div>


			   <br>
			    <div id="page-loader" style="margin-left:500px;margin-top:10px;display:none;">
				<img src="../../Main/images/loading.gif" alt="loader" />
				</div>

                  <div class="row">
                       <div class="col-xs-12 col-md-4 ">
                        <div id="panelBox" class="panel">
                           <span id="relativeTimeColorId" class="col-md-2 percentageWell"> <span id="relativeTimeId">0</span>%</span>
                           <div class="panel-body"  onclick="ontimedetails()">
                             <a href="#" >
                              <h2  class="align" > <span  id="ontimeId">0</span>% </h2>
                              </a>
                              <h5 id="description" class="align"><Span> ON-TIME PERFORMANCE </span></h5>
                           </div>
                        </div>
                     </div>
                     <div class="col-xs-12 col-md-4">
                        <div id="panelBox" class="panel">
                           <span id="delayPercentageColor" class="col-md-2 percentageWell"> <span id="relativedelayPercentage">0</span>%</span>
                           <div class="panel-body" onclick="Delaydetails()">
                            <a href="#" >
                              <h2 class="align"><span  id="delayPercentage">0</span>%  </h2>
                              </a>
                              <h5 id="description" class="align">DELAYED TRIPS</h5>
                           </div>
                        </div>
                     </div>
                     <div class="col-xs-12 col-md-4">
                        <div id="panelBox" class="panel">
                           <span id="backHaulPercentageColor" class="col-md-2 percentageWell"> <span id="relativebackHaulPercentage">0</span>%</span>
                           <div class="panel-body">
                              <h2 class="align"> <span  id="backHaulPercentage">0</span>%</h2>
                              <h5 id="description" class="align">TRUCK UTILIZATION</h5>
                           </div>
                        </div>
                     </div>

                  </div>

				  <div class="row">

                     <div class="col-xs-12 col-md-4">
                        <div id="panelBox" class="panel">
                           <span id="smartTruckColor" class="col-md-2 percentageWell"> <span id="relativesmartTruck">0</span>  </span>
                           <div class="panel-body" onclick="SmartTruckKM()">
                            <a href="#" >
                              <h2 class="align"> <span id="smartTruck">0</span> </h2>
                             </a>
                              <h5 id="description" class="align">SMART TRUCK (KM)</h5>
                           </div>
                        </div>
                     </div>

                     <div class="col-xs-12 col-md-4">
                        <div  id="panelBox" class="panel">
                           <span id="smartTrckerPerTruckColor" class="col-md-2 percentageWell"> <span id="relativesmartTrckerPerTruck">0</span> </span>
                           <div class="panel-body">
                              <h2 class="align"> <span id="smartTrckerPerTruck">0</span> </h2>
                              <h5 id="description" class="align">SMART TRUCKER PER TRUCK</h5>
                           </div>
                        </div>
                     </div>

					  <div class="col-xs-12 col-md-4">
                       <div id="panelBox" class="panel">
                        <span id="smartTruckTopColor" class="col-md-2 percentageWell"> <span id="realativesmartTruckTop" >0</span>%</span>
                        <div class="panel-body">
                           <h2 class="align"> <span id="smartTruckTop" >0</span>% </h2>
                           <h5 id="boxdescription"  data-toggle="tooltip" data-placement="bottom" title="score 8 and above is considered as target score!" class="align">SMART TRUCKER - TOP PERFORMANCE</h5>
                        </div>
                     </div>
                     </div>


                  </div>



                 <div class="row">
<!--						<div class=" panel col-md-11 col-sm-11" style=" margin-left:3%; padding:10px" >-->
							<!-- <div class=" panel col-md-9 col-sm-12"  > -->
								  <div class="col-md-4 col-sm-6">
									 <div id="panelBox" class="panel">
										<span id="22feetColor" class="col-md-2 percentageWell"> <span id="relative22feet">0</span></span>
										<div class="panel-body" onclick="Milage22ft()">
                                			 <a href="#" >
										   <h2 class="align"> <span id="22feet" >0</span></h2>
										   </a>
										   <h5 id="description" class="align"> 22 FEET</h5>
										</div>
									 </div>
								  </div>
									  <div class="col-md-4 col-sm-6">
									 <div id="panelBox" class="panel">
										<span id="24feetColor" class="col-md-2 percentageWell"> <span id="relative24feet">0</span></span>
										<div class="panel-body" onclick="Milage24ft()">
										 <a href="#" >
										   <h2 class="align"> <span id="24feet" >0</span></h2>
										   </a>
										   <h5 id="description" class="align"> 24 FEET</h5>
										</div>
									 </div>
								     </div>
									  <div class="col-md-4 col-sm-6">
									 <div  id="panelBox" class="panel">
										<span id="32feetColor" class="col-md-2 percentageWell"> <span id="relative32feet">0</span></span>
										<div class="panel-body" onclick="Milage32ft()">
										 <a href="#" >
										   <h2 class="align"> <span id="32feet" >0</span></h2>
										   </a>
										   <h5 id="description" class="align"> 32 FEET</h5>
										</div>
									 </div>
								  </div>
								  <div class=" col-md-12 col-sm-12" style="margin-top: -15px;" >
									 <div   class="panel">
										<!-- <div class="panel-body"> -->
										<h5  class="align">MILEAGE(KMPL)</h5>
										<!-- </div> -->
									 </div>
								  </div>
						<!-- </div> -->


<!--            </div>-->
			 </div>


               </div>
            </div>
         </div>

          <div id="add" class="modal fade">
         <div class="modal-content">
            <div class="modal-header" >
							<div class="secondLine" style="display:flex;width:100%; justify-content:space-between; align-items:baseline;">
								 <h4 id="OnTimeTitle" class="modal-title" style="text-align:left; margin-left:10px;"></h4>
							</div>
               <div>
                  <button type="button" class="close" style="align:right;" data-dismiss="modal">&times;</button>
               </div>

            </div>
            <div class="modal-body" style="height: 100%;">
               <div class="row">
                  <div class="col-xs-12">
                     <div class="col-xs-12 col-md-3 style=" >
                           <div id="panelBox" class="panel"  >
                            <div class="panel-body">

                              <h2  class="align"> <span  id="PlacedPercentage">0</span>%</h2>
                              <h5 id="description" class="align"><Span> Placed on Time </span></h5>
                           </div>
                           </div>
                        </div>

                     <div class="col-xs-12 col-md-3">
                        <div id="panelBox" class="panel">

                           <div class="panel-body">
                              <h2 class="align"> <span  id="DepartedPercentage">0</span>%</h2>
                              <h5 id="description" class="align">Departed on Time</h5>
                           </div>
                        </div>
                     </div>

                     <div class="col-xs-12 col-md-3">
                        <div id="panelBox" class="panel">

                           <div class="panel-body">
                              <h2 class="align"><span  id="LoadedPercentage">0</span>%</h2>
                              <h5 id="description" class="align">Loaded on Time</h5>
                           </div>
                        </div>
                     </div>

                     <div class="col-xs-12 col-md-3">
                        <div id="panelBox" class="panel">

                           <div class="panel-body">
                              <h2 class="align"> <span  id="UnloadedPercentage">0</span>%</h2>
                              <h5 id="description" class="align">Unloaded on Time</h5>
                           </div>
                        </div>
                     </div>
                  </div>

                  </div>
                  <div class="modal-footer"  style="text-align: right; height:52px;" >
             		  <button type="reset" class="btn btn-warning" data-dismiss="modal" style="margin-top: 10px;  background-color: red !important;">Close</button>
           			  </div>
           			   </div>
               </div>
            </div>
            <!-- delay 2nd -->
               <div id="add2" class="modal fade">
       <div class="modal-content">
            <div class="modal-header" >
							<div class="secondLine" style="display:flex;width:100%; justify-content:space-between; align-items:baseline;">
								 <h4 id="DelayTripTitle" class="modal-title" style="text-align:left; margin-left:10px;"></h4>
							</div>
               <div>
                  <button type="button" class="close" style="align:right;" data-dismiss="modal">&times;</button>
               </div>

            </div>
            <div class="modal-body" style="height: 100%;">
               <div class="row">
                  <div class="col-xs-12">
                     <div class="col-xs-12 col-md-3 style=" >
                           <div id="panelBox" class="panel"  >
                            <div class="panel-body">

                              <h2  class="align"> <span  id="Delay1hrPercentage">0</span>%</h2>
                              <h5 id="description" class="align"><Span> %delayed by 1 hour </span></h5>
                           </div>
                           </div>
                        </div>

                     <div class="col-xs-12 col-md-3">
                        <div id="panelBox" class="panel">

                           <div class="panel-body">
                              <h2 class="align"> <span  id="Delay3hrPercentage">0</span>%</h2>
                              <h5 id="description" class="align">%delayed by 1-3 hours</h5>
                           </div>
                        </div>
                     </div>

                     <div class="col-xs-12 col-md-3">
                        <div id="panelBox" class="panel">

                           <div class="panel-body">
                              <h2 class="align"><span  id="Delay5hrPercentage">0</span>%</h2>
                              <h5 id="description" class="align">%delayed by 3-5 hours</h5>
                           </div>
                        </div>
                     </div>

                     <div class="col-xs-12 col-md-3">
                        <div id="panelBox" class="panel">

                           <div class="panel-body">
                              <h2 class="align"> <span  id="Delaygreater5hrPercentage">0</span>%</h2>
                              <h5 id="description" class="align">%delayed by >5 hours </h5>
                           </div>
                        </div>
                     </div>
                    </div>
                    </div>
                      <div class="modal-footer"  style="text-align: right; height:52px;" >
             		  <button type="reset" class="btn btn-warning" data-dismiss="modal" style="margin-top: 10px; background-color: red !important;">Close</button>
           			  </div>

               </div>
            </div>
            </div>

 	 	<div id="add3" class="modal fade">
         <div class="modal-content">
            <div class="modal-header" >
							<div class="secondLine" style="display:flex; width:100%; justify-content:space-between; align-items:baseline;">
								 <h4 id="SmartTruckKMTitle" class="modal-title" style="text-align:left; margin-left:10px;"></h4>
							</div>
               <div>
                  <button type="button" class="close" style="align:right;" data-dismiss="modal">&times;</button>
               </div>

            </div>
            <div class="modal-body" style="height: 100%;">
               <div class="row">
                  <div class="col-xs-12">
                     <div class="col-xs-12 col-md-4 style=" >
                           <div id="panelBox" class="panel"  >
                            <div class="panel-body">
                              <h2  class="align"> <span  id=coveringabove15k>0</span>%</h2>
                              <h5 id="description" class="align"><Span> % of trucks covering above 15000km per month</span></h5>
                           </div>
                           </div>
                        </div>

                     <div class="col-xs-12 col-md-4">
                        <div id="panelBox" class="panel">

                           <div class="panel-body">
                              <h2 class="align"> <span  id="covering12kto15k">0</span>%</h2>
                              <h5 id="description" class="align">% of trucks between 12000k to 15000km per month</h5>
                           </div>
                        </div>
                     </div>

                     <div class="col-xs-12 col-md-4">
                        <div id="panelBox" class="panel">

                           <div class="panel-body">
                              <h2 class="align"><span  id="coveringbelow13k">0</span>%</h2>
                              <h5 id="description" class="align">% of trucks covering less than 12000km per month</h5>
                           </div>
                        </div>
                     </div>
                      </div>
                     </div>
                  <div class="modal-footer"  style="text-align: right; height:52px;" >
             		  <button type="reset" class="btn btn-warning" data-dismiss="modal" style="margin-top: 10px; background-color: red !important;">Close</button>
           			  </div>
               </div>
            </div>
            </div>

          <div id="add4" class="modal fade">
         <div class="modal-content">
            <div class="modal-header" >
							<div class="secondLine" style="display:flex; width:100%; justify-content:space-between; align-items:baseline;">
								 <h4 id="Mileage22Title" class="modal-title" style="text-align:left; margin-left:10px;"></h4>
							</div>
               <div>
                  <button type="button" class="close" style="align:right;" data-dismiss="modal">&times;</button>
               </div>

            </div>
            <div class="modal-body" style="height: 100%;">
               <div class="row">
                  <div class="col-xs-12">
                     <div class="col-xs-12 col-md-4 style=" >
                           <div id="panelBox" class="panel"  >
                            <div class="panel-body">
                              <h2  class="align"> <span  id=TweTwofeetBenz>0</span>%</h2>
                              <h5 id="description" class="align"><Span> BENZ 22 feet Vehicle Average Mileage </span></h5>
                           </div>
                           </div>
                        </div>

                     <div class="col-xs-12 col-md-4">
                        <div id="panelBox" class="panel">

                           <div class="panel-body">
                              <h2 class="align"> <span  id="TweTwofeetTata">0</span>%</h2>
                              <h5 id="description" class="align"> TATA 22 feet Vehicle Average Mileage</h5>
                           </div>
                        </div>
                     </div>

                     <div class="col-xs-12 col-md-4">
                        <div id="panelBox" class="panel">

                           <div class="panel-body">
                              <h2 class="align"><span  id="TweTwofeetOth">0</span>%</h2>
                              <h5 id="description" class="align">Others 22 feet Vehicle Average Mileage</h5>
                           </div>
                        </div>
                     </div>
                      </div>
                     </div>
                  <div class="modal-footer"  style="text-align: right; height:52px;" >
             		  <button type="reset" class="btn btn-warning" data-dismiss="modal" style="margin-top: 10px; background-color: red !important;">Close</button>
           			  </div>
               </div>
            </div>
            </div>

             <div id="add5" class="modal fade">
         <div class="modal-content">
            <div class="modal-header" >
							<div class="secondLine" style="display:flex; width:100%; justify-content:space-between; align-items:baseline;">
								 <h4 id="Mileage24Title" class="modal-title" style="text-align:left; margin-left:10px;"></h4>
							</div>
               <div>
                  <button type="button" class="close" style="align:right;" data-dismiss="modal">&times;</button>
               </div>

            </div>
            <div class="modal-body" style="height: 100%;">
               <div class="row">
                  <div class="col-xs-12">
                     <div class="col-xs-12 col-md-4 style=" >
                           <div id="panelBox" class="panel"  >
                            <div class="panel-body">
                              <h2  class="align"> <span  id=TweFourfeetBenz>0</span>%</h2>
                              <h5 id="description" class="align"><Span> BENZ 22 feet Vehicle Average Mileage </span></h5>
                           </div>
                           </div>
                        </div>

                     <div class="col-xs-12 col-md-4">
                        <div id="panelBox" class="panel">

                           <div class="panel-body">
                              <h2 class="align"> <span  id="TweFourofeetTata">0</span>%</h2>
                              <h5 id="description" class="align"> TATA 22 feet Vehicle Average Mileage</h5>
                           </div>
                        </div>
                     </div>

                     <div class="col-xs-12 col-md-4">
                        <div id="panelBox" class="panel">

                           <div class="panel-body">
                              <h2 class="align"><span  id="TweFourfeetOth">0</span>%</h2>
                              <h5 id="description" class="align">Others 24 feet Vehicle Average Mileage</h5>
                           </div>
                        </div>
                     </div>
                      </div>
                     </div>
                  <div class="modal-footer"  style="text-align: right; height:52px;" >
             		  <button type="reset" class="btn btn-warning" data-dismiss="modal" style="margin-top: 10px; background-color: red !important;">Close</button>
           			  </div>
               </div>
            </div>
            </div>

             <div id="add6" class="modal fade">
         <div class="modal-content">
            <div class="modal-header" >
							<div class="secondLine" style="display:flex; width:100%; justify-content:space-between; align-items:baseline;">
								 <h4 id="Mileage32Title" class="modal-title" style="text-align:left; margin-left:10px;"></h4>
							</div>
               <div>
                  <button type="button" class="close" style="align:right;" data-dismiss="modal">&times;</button>
               </div>

            </div>
            <div class="modal-body" style="height: 100%;">
               <div class="row">
                  <div class="col-xs-12">
                     <div class="col-xs-12 col-md-4 style=" >
                           <div id="panelBox" class="panel"  >
                            <div class="panel-body">
                              <h2  class="align"> <span  id=ThiTwofeetBenz>0</span>%</h2>
                              <h5 id="description" class="align"><Span> BENZ 32 feet Vehicle Average Mileage </span></h5>
                           </div>
                           </div>
                        </div>

                     <div class="col-xs-12 col-md-4">
                        <div id="panelBox" class="panel">

                           <div class="panel-body">
                              <h2 class="align"> <span  id="ThiTwofeetTata">0</span>%</h2>
                              <h5 id="description" class="align"> TATA 32 feet Vehicle Average Mileage</h5>
                           </div>
                        </div>
                     </div>

                     <div class="col-xs-12 col-md-4">
                        <div id="panelBox" class="panel">

                           <div class="panel-body">
                              <h2 class="align"><span  id="ThiTwofeetOth">0</span>%</h2>
                              <h5 id="description" class="align">Others 32 feet Vehicle Average Mileage</h5>
                           </div>
                        </div>
                     </div>
                      </div>
                     </div>
                  <div class="modal-footer"  style="text-align: right; height:52px;" >
             		  <button type="reset" class="btn btn-warning" data-dismiss="modal" style="margin-top: 10px; background-color: red !important;">Close</button>
           			  </div>
               </div>
            </div>
            </div>

<!--            <div class="modal-footer"  style="text-align: right; height:52px;" >-->
<!--               <button type="reset" class="btn btn-warning" data-dismiss="modal" style="margin-top: 10px;">Close</button> -->
<!--            </div>-->
	<div id="adds" class="modal fade" style="width: 70%;margin-left: 185px;margin-top: 60px;">
         <div class="modal-content">
         <div class="modal-header" style="border-bottom:none;">
               <div>
                  <button type="button" class="close" style="align:right;"data-dismiss="modal">&times;</button>
                   <h4 id="mileageTitle" class="modal-title">22 Feet Mileage Information</h4>
               </div>
            </div>
            <div class="modal-body" style="height: 100%;">
               <div class="row">
                  <div class="col-lg-12" style=" margin-top: -30px;">
                     <div id="chart_div"></div>
                  </div>
               </div>

            <div class="modal-footer"  style="text-align: right; height:52px;" >
             		  <button type="reset" class="btn btn-warning" data-dismiss="modal" style="margin-top: 10px; background-color: red !important;">Close</button>
           			  </div>
           			  </div>
         </div>
      </div>

	  <div id="adds1" class="modal fade" style="width: 70%;margin-left: 185px;margin-top: 60px;">
         <div class="modal-content">
         <div class="modal-header" style="border-bottom:none;">
               <div>
                  <button type="button" class="close" style="align:right;"data-dismiss="modal">&times;</button>
                   <h4 id="mileageTitle24" class="modal-title">24 Feet Mileage Information</h4>
               </div>
            </div>
            <div class="modal-body" style="height: 100%;">
               <div class="row">
                  <div class="col-lg-12" style=" margin-top: -30px;">
                     <div id="chart1_div"></div>
                  </div>
               </div>

            <div class="modal-footer"  style="text-align: right; height:52px;" >
             		  <button type="reset" class="btn btn-warning" data-dismiss="modal" style="margin-top: 10px; background-color: red !important;">Close</button>
           			  </div>
           			  </div>
         </div>
      </div>

	  <div id="adds2" class="modal fade" style="width: 70%;margin-left: 185px;margin-top: 60px;">
         <div class="modal-content">
         <div class="modal-header" style="border-bottom:none;">
               <div>
                  <button type="button" class="close" style="align:right;"data-dismiss="modal">&times;</button>
                   <h4 id="mileageTitle32" class="modal-title">32 FEET Mileage Information</h4>
               </div>
            </div>
            <div class="modal-body" style="height: 100%;">
               <div class="row">
                  <div class="col-lg-12" style=" margin-top: -30px;">
                     <div id="chart2_div"></div>
                  </div>
               </div>

            <div class="modal-footer"  style="text-align: right; height:52px;" >
             		  <button type="reset" class="btn btn-warning" data-dismiss="modal" style="margin-top: 10px; background-color: red !important;">Close</button>
           			  </div>
           			  </div>
         </div>
      </div>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
     <script type="text/javascript">
     //history.pushState({ foo: 'fake' }, 'Fake Url', 'ExecutiveViewStatic#');
getCustomerList();

<!--  var selectedCustomer = [];-->
<!--  var selectedRoute = [];-->
<!--  -->
<!-- $('#customerList').multiselect({-->
<!--nonSelectedText :'Select Customer',-->
<!--includeSelectAllOption: true,-->
<!-- //selectAllValue: 'multiselect-all',-->
<!--onChange: function(element, checked) {-->
<!--        var brands = $('#customerList option:selected');-->
<!--           selectedCustomer = [];-->
<!--        $(brands).each(function(index, brand){-->
<!--            selectedCustomer.push([$(this).val()]);-->
<!--        });-->
<!---->
<!--    //   sweetAlert(selectedCustomer.length);-->
<!--    }-->
<!--});	 -->
<!--$('#routeList').multiselect({-->
<!--nonSelectedText :'Select Route',-->
<!--includeSelectAllOption: true,-->
<!--onChange: function(element, checked) {-->
<!--        var brands = $('#routeList option:selected');-->
<!--           selectedRoute = [];-->
<!--        $(brands).each(function(index, brand){-->
<!--            selectedRoute.push([$(this).val()]);-->
<!--        });-->
<!---->
<!--    //   sweetAlert(selectedRoute.length);-->
<!--    }-->
<!--});	 -->
<!-- $('#rangeList').multiselect({ -->
<!-- nonSelectedText :'Select W/M/Q/Y-D', -->
<!-- includeSelectAllOption: true -->
<!-- });	 -->
<!-- $('#comparisonList').multiselect({ -->
<!-- nonSelectedText :'Select Comparison', -->
<!-- includeSelectAllOption: true -->
<!-- }); -->


function getCustomerList(){

//$('#customerList').multiselect({ nonSelectedText:'Select Customer'});
//$('#routeList').multiselect({ nonSelectedText:'Select Route'});
//document.getElementById("hidePDF").style.visibility = "hidden";

 $('[data-toggle="tooltip"]').tooltip();

var CustomerList;
var Customerarray = [];
		$.ajax({

	        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getCustNamesForSLA',
	        success: function(response) {
	            custList = JSON.parse(response);
	            var $custName = $('#customerList');
	            var output = '';
	            for (var i = 0; i < custList["customerRoot"].length; i++) {
	                $('#customerList').append($("<option></option>").attr("value", custList["customerRoot"][i].CustId).text(custList["customerRoot"][i].CustName));
	            }
	            $('#customerList').multiselect({
	                nonSelectedText: 'ALL',
	                includeSelectAllOption: true,
	                enableFiltering: true,
	                enableCaseInsensitiveFiltering: true,
	                numberDisplayed: 1,
	                allSelectedText: 'ALL',
	                buttonWidth: 160,
	                maxHeight: 200,
	                includeSelectAllOption: true,
	                selectAllText: 'ALL',
	                selectAllValue: 'ALL',
	            });
	            $("#customerList").multiselect('selectAll', false)
	            $("#customerList").multiselect('updateButtonText');
				getRouteListFirstTime();
				//getProductLine();
	        }
			
			 });
			 //document.getElementById("customerList").options.length = 0;
			 //$("#customerList")[0].selectedIndex = 0;
			 
			 // $(function () {
        // //$("#customerList").bind("click", function () {
            
        // //});
    // });

 }

 function getRouteListFirstTime(){
		//	 $('#routeList').nonSelectedText('Select Route');
		
  $('#rangeList').val(0);
  $('#comparisonList').val(0);
		var routeList;
		var routerarray = [];
		var custcombo = "";
        var custselected = $("#customerList option:selected");
        custselected.each(function () {
            custcombo += $(this).val() + ",";
        });
         
		var customerName=custcombo;//document.getElementById("customerList").value;
	
		for (var i = document.getElementById("routeList").length - 1; i >= 1; i--) {
			        document.getElementById("routeList").remove(i);
			    }
		 var param = {
		customerList:customerName

		        };
				$.ajax({
	        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getRouteNames',
	        success: function(response) {
	            routeName = JSON.parse(response);
	            var $routeList = $('#routeList');
	            var output = '';
	            $.each(routeName, function() {
	                $('<option value=' + this.routeId + '>' + this.routeName + '</option>').appendTo($routeList);
	            });
	            $('#routeList').multiselect({
	                nonSelectedText: 'ALL',
	                includeSelectAllOption: true,
	                enableFiltering: true,
	                enableCaseInsensitiveFiltering: true,
	                numberDisplayed: 1,
	                allSelectedText: 'ALL',
	                buttonWidth: 160,
	                maxHeight: 200,
	                selectAllText: 'ALL',
	                selectAllValue: 'ALL'
	            });
	            $("#routeList").multiselect('selectAll', false)
	            $("#routeList").multiselect('updateButtonText');
					}
					 });
 }


 function getRouteList(){
		//	 $('#routeList').nonSelectedText('Select Route');
		//$("#routeList").multiselect("clearSelection");
		//$('#routeList').multiselect('destroy');
		 $("#routeList option:selected").each(function () {
    		$(this).remove(); //or whatever else
		});
		var routeList = "";
		
  $('#rangeList').val(0);
  $('#comparisonList').val(0);

		var routeList;
		var routerarray = [];
		var custcombo = "";
        var custselected = $("#customerList option:selected");
        
        custselected.each(function () {
            custcombo += $(this).val() + ",";
        });
		var customerName=custcombo;//document.getElementById("customerList").value;
		
		// if (customerName.length <= 0){
		// sweetAlert("Select customer");
		// return;
		// }

		for (var i = document.getElementById("routeList").length - 1; i >= 1; i--) {
			        document.getElementById("routeList").remove(i);
			    }
		 var param = {
		customerList:customerName

		        };
				$.ajax({
	        url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getRouteNames',
	        success: function(response) {
	            routeName = JSON.parse(response);
	            var $routeList = $('#routeList');
	            var output = '';
	            $.each(routeName, function() {
	                $('<option value=' + this.routeId + '>' + this.routeName + '</option>').appendTo($routeList);
	            });
	            $('#routeList').multiselect({
	                nonSelectedText: 'ALL',
	                includeSelectAllOption: true,
	                enableFiltering: true,
	                enableCaseInsensitiveFiltering: true,
	                numberDisplayed: 1,
	                allSelectedText: 'ALL',
	                buttonWidth: 160,
	                maxHeight: 200,
	                selectAllText: 'ALL',
	                selectAllValue: 'ALL'
	            });
	            $("#routeList").multiselect('selectAll', false)
	            $("#routeList").multiselect('updateButtonText');

					}
					 });
 }

<!-- $("#rangeList").change(function() {-->
<!--  var value = $(this).children(":selected").attr("id");-->
<!--  sweetAlert(value);-->
<!--    switch(parseInt(value)){-->
<!--	case 1: -->
<!--	alert(value);-->
<!--	$("#option2Id").prop( "disabled", true );-->
<!--	break;-->
<!--	case 2: -->
<!--	$("#option2Id").prop( "disabled", false );-->
<!--	break;-->
<!--	case 3: -->
<!--	$("#option2Id").prop( "disabled", false );-->
<!--	break;-->
<!--	case 4: -->
<!--	$("#option2Id").prop( "disabled", true );-->
<!--	break;-->
<!--	-->
<!--	default:-->
<!--      break;-->
<!--	-->
<!--	}-->
<!--});-->

function getComparison(){
var value=document.getElementById("rangeList").value;
 // alert(value);
    switch(parseInt(value)){
	case 1:
	$("#option2Id").attr("disabled", true);
	break;
	case 2:
	$("#option2Id").removeAttr("disabled");
	break;
	case 3:
	$("#option2Id").removeAttr("disabled");
	break;
	case 4:
	$("#option2Id").attr("disabled", true);
	break;

	default:
      break;

	}

}

function ontimedetails() {
  		var custcombo = "";
        var routcombo = "";
        var custselected = $("#customerList option:selected");
        custselected.each(function () {
            custcombo += $(this).val() + ",";
        });

        var selected = $("#routeList option:selected");
        selected.each(function () {
            routcombo += $(this).val() + ",";
        });

    var combo1= custcombo;// document.getElementById("customerList").value;
	var combo2= routcombo;//document.getElementById("routeList").value;
	var combo3= document.getElementById("rangeList").value;
	var combo4= document.getElementById("comparisonList").value;
	var ontimevalue = document.getElementById("ontimeId").innerHTML;

	 if(combo1==0){
	   sweetAlert("Select customer");
	 }else if(combo2=='0,'||combo2==0||combo2==''){
		 sweetAlert("Select Route");
	 }
	 else if(combo3==0){
	    sweetAlert("Select Analysis");
	 }
	 else if(combo4==0){
	    sweetAlert("Select comaparsion");
	 }
	 else if(ontimevalue == 0){
	 // alert(ontimevalue);
	  sweetAlert("No data available");
	 }else{

	 var param = {

            customerList: combo1,
            selectedRoute:combo2,
            range:combo3,
            comaparsion:combo4

        };
         document.getElementById("page-loader").style.display="block";
   	$.ajax({
   		  type:'POST',
     	  url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getDetailstoOnTimePanel',
          data: param,
          success: function(result) {
           document.getElementById("page-loader").style.display="none";
               var   dataList= JSON.parse(result);
         			  for (var i = 0; i < dataList["OnTimedashboardRoot"].length; i++) {
						var ontimePlacedperformance=dataList["OnTimedashboardRoot"][i].ontimePlacedPercentage;
						var ontimeDepartPercentage=dataList["OnTimedashboardRoot"][i].ontimeDepart;
						var ontimeLoadPercentage=dataList["OnTimedashboardRoot"][i].ontimeLoad;
						var ontimeUnloadPercentage=dataList["OnTimedashboardRoot"][i].ontimeUnload;

						document.getElementById("PlacedPercentage").innerHTML = ontimePlacedperformance;
						document.getElementById("DepartedPercentage").innerHTML = ontimeDepartPercentage;
						document.getElementById("LoadedPercentage").innerHTML= ontimeLoadPercentage ;
						document.getElementById("UnloadedPercentage").innerHTML = ontimeUnloadPercentage;

						}
					}
			 });

	        $(".modal-header #OnTimeTitle").text("ON-TIME PERFORMANCE DETAILS");
	        $('#add').modal('show');
	        }

	    }
 function Delaydetails() {
  		var custcombo = "";
        var routcombo = "";
        var custselected = $("#customerList option:selected");
        custselected.each(function () {
            custcombo += $(this).val() + ",";
        });

        var selected = $("#routeList option:selected");
        selected.each(function () {
            routcombo += $(this).val() + ",";
        });

    var combo1= custcombo;// document.getElementById("customerList").value;
	var combo2= routcombo;//document.getElementById("routeList").value;
	var combo3= document.getElementById("rangeList").value;
	var combo4= document.getElementById("comparisonList").value;
	var delayvalue = document.getElementById("delayPercentage").innerHTML;


	 if(combo1==0){
	   sweetAlert("Select customer");
	 }else if(combo2=='0,'||combo2==0||combo2==''){
	 sweetAlert("Select Route");
	 }
	 else if(combo3==0){
	    sweetAlert("Select Analysis");
	 }
	 else if(combo4==0){
	    sweetAlert("Select comaparsion");
	 }
	 else if(delayvalue == 0){
	 // alert(ontimevalue);
	  sweetAlert("No data available");
	 }else{

	 var param = {

            customerList: combo1,
            selectedRoute:combo2,
            range:combo3,
            comaparsion:combo4

        };
         document.getElementById("page-loader").style.display="block";
   	$.ajax({
   	  type:'POST',
      url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getDetailstoDelayPanel',
          data: param,
          success: function(result) {
           document.getElementById("page-loader").style.display="none";
               var   dataList= JSON.parse(result);
         			  for (var i = 0; i < dataList["DelaydashboardRoot"].length; i++) {
						var oneHrDelayPercentage=dataList["DelaydashboardRoot"][i].onehrDelay;
						var threeHrDelayPercentage=dataList["DelaydashboardRoot"][i].threehrDelay;
						var fiveHrDelayPercentage=dataList["DelaydashboardRoot"][i].fivehrDelay;
						var greaterthanfiveHrDelayPercentage=dataList["DelaydashboardRoot"][i].abovefivehrDelay;

						document.getElementById("Delay1hrPercentage").innerHTML = oneHrDelayPercentage;
						document.getElementById("Delay3hrPercentage").innerHTML = threeHrDelayPercentage;
						document.getElementById("Delay5hrPercentage").innerHTML=  fiveHrDelayPercentage ;
						document.getElementById("Delaygreater5hrPercentage").innerHTML = greaterthanfiveHrDelayPercentage;

						}
					}
			 });

	        $(".modal-header #DelayTripTitle").text("DELAYED TRIPS DETAILS");
	        $('#add2').modal('show');
	        }

	    }

	    function SmartTruckKM() {
  		var custcombo = "";
        var routcombo = "";
        var custselected = $("#customerList option:selected");
        custselected.each(function () {
            custcombo += $(this).val() + ",";
        });

        var selected = $("#routeList option:selected");
        selected.each(function () {
            routcombo += $(this).val() + ",";
        });

    var combo1= custcombo;// document.getElementById("customerList").value;
	var combo2= routcombo;//document.getElementById("routeList").value;
	var combo3= document.getElementById("rangeList").value;
	var combo4= document.getElementById("comparisonList").value;
	var smartvalue = document.getElementById("smartTruck").innerHTML;
	 if(combo1==0){
	   sweetAlert("Select customer");
	 }else if(combo2=='0,'||combo2==0||combo2==''){
	 sweetAlert("Select Route");
	 }
	 else if(combo3==0){
	    sweetAlert("Select Analysis");
	 }
	 else if(combo4==0){
	    sweetAlert("Select comaparsion");
	 }
	 else if(smartvalue == 0){
	 // alert(ontimevalue);
	  sweetAlert("No data available");
	 }else{

	 var param = {

            customerList: combo1,
            selectedRoute:combo2,
            range:combo3,
            comaparsion:combo4

        };
         document.getElementById("page-loader").style.display="block";
   	$.ajax({
   	 type:'POST',
      url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getDetailstoSmarttruckPanel',
          data: param,
          success: function(result) {
           document.getElementById("page-loader").style.display="none";
               var   dataList= JSON.parse(result);
         			  for (var i = 0; i < dataList["SmartTruckdashboardRoot"].length; i++) {
						var TrucksCoveringabove15k=dataList["SmartTruckdashboardRoot"][i].greater15kTruck;
						var TrucksCovering12kto15k=dataList["SmartTruckdashboardRoot"][i].between15kTruck;
						var TrucksCoveringbelow13k=dataList["SmartTruckdashboardRoot"][i].lesser12kTruck;

						document.getElementById("coveringabove15k").innerHTML = TrucksCoveringabove15k;
						document.getElementById("covering12kto15k").innerHTML = TrucksCovering12kto15k;
						document.getElementById("coveringbelow13k").innerHTML= TrucksCoveringbelow13k ;

						}
					}
			 });

	        $(".modal-header #SmartTruckKMTitle").text("SMART TRUCK (km) DETAILS");
	        $('#add3').modal('show');
	        }

	        }


	function Milage22ft() {
  		var custcombo = "";
        var routcombo = "";
        var custselected = $("#customerList option:selected");
        custselected.each(function () {
            custcombo += $(this).val() + ",";
        });

        var selected = $("#routeList option:selected");
        selected.each(function () {
            routcombo += $(this).val() + ",";
        });

    var combo1= custcombo;// document.getElementById("customerList").value;
	var combo2= routcombo;//document.getElementById("routeList").value;
	var combo3= document.getElementById("rangeList").value;
	var combo4= document.getElementById("comparisonList").value;
	var twentytwovalue = document.getElementById("22feet").innerHTML;
	 if(combo1==0){
	   sweetAlert("Select customer");
	 }else if(combo2=='0,'||combo2==0||combo2==''){
	 sweetAlert("Select Route");
	 }
	 else if(combo3==0){
	    sweetAlert("Select Analysis");
	 }
	 else if(combo4==0){
	    sweetAlert("Select comaparsion");
	 }
	 else if(twentytwovalue == 0){
	  //alert(ontimevalue);
	  sweetAlert("No data available");
	 }
	 else{

	 var param = {

            customerList: combo1,
            selectedRoute:combo2,
            range:combo3,
            comaparsion:combo4

        };

        document.getElementById("page-loader").style.display="block";
       $('#adds').modal('show');
			var HbJsonList;
    		google.charts.load('current', {'packages': ['bar']});
          	google.charts.setOnLoadCallback(drawChart);

        function drawChart() {
        $.ajax({
        		type:'POST',
                url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getDetailstoTwentyTwoPanel',
                data: param,
                success: function(response) {
                 document.getElementById("page-loader").style.display="none";
                HbJsonList = JSON.parse(response);
	            var data = new google.visualization.DataTable();
	            var options = {
	               title: 'Analysis',
	                            height: 420,
	                            width: 860,
	                            hAxis: {
									direction: 1,
								    slantedText: true,
								    slantedTextAngle: 315, // here you can even use 180
								},
								vAxis: {
		                        	title: 'Average Mileage',
		                            format: 'decimal'
		                        }
	                };

	                  data.addColumn('string','Model');
					  data.addColumn('number','Mileage');

	                 	var  jsonData = HbJsonList["twentytwodashboardRoot"];
	                 	   array = [];
	                        if(HbJsonList["twentytwodashboardRoot"].length > 0){
	                        records = 'notempty';

		                   			for (var j = 0; j < HbJsonList["twentytwodashboardRoot"].length; j++) {
		                       			array.push([HbJsonList["twentytwodashboardRoot"][j].Model,Number(HbJsonList["twentytwodashboardRoot"][j].Mileage)]);
		                   			}
		                   			data.addRows(array);
		                   			  var chart = new google.charts.Bar(document.getElementById('chart_div'));
	            					chart.draw(data, options);
	                        }
               		 	}
           		 	});
        		}
	    	}
	    }

	    	function Milage24ft() {

  		var custcombo = "";
        var routcombo = "";
        var custselected = $("#customerList option:selected");
        custselected.each(function () {
            custcombo += $(this).val() + ",";
        });

        var selected = $("#routeList option:selected");
        selected.each(function () {
            routcombo += $(this).val() + ",";
        });

    var combo1= custcombo;// document.getElementById("customerList").value;
	var combo2= routcombo;//document.getElementById("routeList").value;
	var combo3= document.getElementById("rangeList").value;
	var combo4= document.getElementById("comparisonList").value;
	var twentytwovalue = document.getElementById("24feet").innerHTML;
	 if(combo1==0){
	   sweetAlert("Select customer");
	 }else if(combo2=='0,'||combo2==0||combo2==''){
	 sweetAlert("Select Route");
	 }
	 else if(combo3==0){
	    sweetAlert("Select Analysis");
	 }
	 else if(combo4==0){
	    sweetAlert("Select comaparsion");
	 }
	 else if(twentytwovalue == 0){
	  //alert(ontimevalue);
	  sweetAlert("No data available");
	 }
	 else{

	 var param = {

            customerList: combo1,
            selectedRoute:combo2,
            range:combo3,
            comaparsion:combo4

        };

        document.getElementById("page-loader").style.display="block";
       $('#adds1').modal('show');
			var HbJsonList;
    		google.charts.load('current', {'packages': ['bar']});
          	google.charts.setOnLoadCallback(drawChart);

        function drawChart() {
        $.ajax({
        type:'POST',
                url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getDetailstoTwentyFourPanel',
                data: param,
                success: function(response) {
                 document.getElementById("page-loader").style.display="none";
                HbJsonList = JSON.parse(response);
	            var data = new google.visualization.DataTable();
	            var options = {
	               title: 'Analysis',
	                            height: 420,
	                            width: 860,
	                            hAxis: {
									direction: 1,
								    slantedText: true,
								    slantedTextAngle: 315, // here you can even use 180
								},
								vAxis: {
		                        	title: 'Average Mileage',
		                            format: 'decimal'
		                        }
	                };

	                  data.addColumn('string','Model');
					  data.addColumn('number','Mileage');

	                 	var  jsonData = HbJsonList["twentyFourdashboardRoot"];

	                        if(HbJsonList["twentyFourdashboardRoot"].length > 0){
	                        records = 'notempty';
	                 		    array = [];
		                   			for (var j = 0; j < HbJsonList["twentyFourdashboardRoot"].length; j++) {
		                       			array.push([HbJsonList["twentyFourdashboardRoot"][j].Model,Number(HbJsonList["twentyFourdashboardRoot"][j].Mileage)]);
		                   			}
		                   			data.addRows(array);
		                   			  var chart = new google.charts.Bar(document.getElementById('chart1_div'));
	            					chart.draw(data, options);
	                        } else {
	                        }
               		 	}
           		 	});
        		}
	    	}

	    }

	    	function Milage32ft() {

  		var custcombo = "";
        var routcombo = "";
        var custselected = $("#customerList option:selected");
        custselected.each(function () {
            custcombo += $(this).val() + ",";
        });

        var selected = $("#routeList option:selected");
        selected.each(function () {
            routcombo += $(this).val() + ",";
        });

    var combo1= custcombo;// document.getElementById("customerList").value;
	var combo2= routcombo;//document.getElementById("routeList").value;
	var combo3= document.getElementById("rangeList").value;
	var combo4= document.getElementById("comparisonList").value;
	var twentytwovalue = document.getElementById("32feet").innerHTML;
	 if(combo1==0){
	   sweetAlert("Select customer");
	 }else if(combo2=='0,'||combo2==0||combo2==''){
	 sweetAlert("Select Route");
	 }
	 else if(combo3==0){
	    sweetAlert("Select Analysis");
	 }
	 else if(combo4==0){
	    sweetAlert("Select comaparsion");
	 }
	 else if(twentytwovalue == 0){
	  //alert(ontimevalue);
	  sweetAlert("No data available");
	 }
	 else{

	 var param = {

            customerList: combo1,
            selectedRoute:combo2,
            range:combo3,
            comaparsion:combo4

        };

        document.getElementById("page-loader").style.display="block";
       $('#adds2').modal('show');
			var HbJsonList;
    		google.charts.load('current', {'packages': ['bar']});
          	google.charts.setOnLoadCallback(drawChart);

        function drawChart() {
        $.ajax({
        		type:'POST',
                url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getDetailstoThirtyTwoPanel',
                data: param,
                success: function(response) {
                 document.getElementById("page-loader").style.display="none";
                HbJsonList = JSON.parse(response);
	            var data = new google.visualization.DataTable();
	            var options = {
	               title: 'Analysis',
	                            height: 420,
	                            width: 860,
	                            hAxis: {
									direction: 1,
								    slantedText: true,
								    slantedTextAngle: 315, // here you can even use 180
								},
								vAxis: {
		                        	title: 'Average Mileage',
		                            format: 'decimal'
		                        }
	                };

	                  data.addColumn('string','Model');
					  data.addColumn('number','Mileage');

	                 	var  jsonData = HbJsonList["thirtytwodashboardRoot"];

	                        if(HbJsonList["thirtytwodashboardRoot"].length > 0){
	                        records = 'notempty';
	                   		  array = [];
		                   			for (var j = 0; j < HbJsonList["thirtytwodashboardRoot"].length; j++) {
		                       			array.push([HbJsonList["thirtytwodashboardRoot"][j].Model,Number(HbJsonList["thirtytwodashboardRoot"][j].Mileage)]);
		                   			}
		                   			data.addRows(array);
		                   			  var chart = new google.charts.Bar(document.getElementById('chart2_div'));
	            					chart.draw(data, options);
	                        }
               		 	}
           		 	});
        		}
	    	}

	    }
function ExeStaticPdfButton(){
	    var customer = document.getElementById("customerList").value;
		var route= document.getElementById("routeList").value;
		var range= document.getElementById("rangeList").value;
		var comparison= document.getElementById("comparisonList").value;

		var Namecustomer = "";  //$("#customerList option:selected").text();
		var custselected = $("#customerList option:selected");
        custselected.each(function () {
         	Namecustomer += $(this).text() + ",";
        });

		var Nameroute= "";  // $("#routeList option:selected").text();
		 var selected = $("#routeList option:selected");
        selected.each(function () {
             Nameroute += $(this).text() + ",";
        });
		var Namerange=  $("#rangeList option:selected").text();
		var Namecomparison= $("#comparisonList option:selected").text();
		window.open("<%=request.getContextPath()%>/ExecutiveStaticPDF?customer="+customer+"&route="+route+"&range="+range+"&comparison="+comparison+"&Namecustomer="+Namecustomer+"&Nameroute="+Nameroute+"&Namerange="+Namerange+"&Namecomparison="+Namecomparison);
			}



 function getDetails(){
  		var custcombo = "";
        var routcombo = "";
        var custselected = $("#customerList option:selected");
        custselected.each(function () {
            custcombo += $(this).val() + ",";
        });

        var selected = $("#routeList option:selected");
        selected.each(function () {
            routcombo += $(this).val() + ",";
        });

    var combo1= custcombo;// document.getElementById("customerList").value;
	var combo2= routcombo;//document.getElementById("routeList").value;
	var combo3= document.getElementById("rangeList").value;
	var combo4= document.getElementById("comparisonList").value;

	//alert(combo1+"---- "+combo2);

<!-- if(selectedCustomer.length==0){-->
<!--   alert("Select customer");-->
<!-- }else if(selectedRoute.length==0){-->
<!--	 alert("Select Route");-->
<!-- }-->
 if(combo1==0){
   sweetAlert("Select customer");
 }else if(combo2=='0,'||combo2==0||combo2==''){
	 sweetAlert("Select Route");
 }
 else if(combo3==0){
    sweetAlert("Select Analysis");
 }
 else if(combo4==0){
    sweetAlert("Select comaparsion");
 }
 else{
 //  var customerJson = JSON.stringify(selectedCustomer); //JSON.stringify(selectedCustomer);
 //  var routeJson = JSON.stringify(selectedRoute);

<!--    var executive = new Object();-->
<!--    executive.range =combo3;-->
<!--    executive.comaparsion = combo4;-->
<!--    executive.selectedCustomer = selectedCustomer;-->
<!--    executive.selectedRoute = selectedRoute;-->
<!--    var jsonArray = JSON.parse(JSON.stringify(executive));-->

//document.getElementById("hidePDF").style.visibility = "hidden";
  var param = {

            customerList: combo1,
            selectedRoute:combo2,
            range:combo3,
            comaparsion:combo4

        };
         document.getElementById("page-loader").style.display="block";
   	$.ajax({
   	type:'POST',
      url: '<%=request.getContextPath()%>/tripDashBoardAction.do?param=getDetailstoPanel',
          data: param,
          success: function(result) {
           document.getElementById("page-loader").style.display="none";
               var   dataList= JSON.parse(result);
           for (var i = 0; i < dataList["dashboardRoot"].length; i++) {
		var ontimeperformance=dataList["dashboardRoot"][i].ontimePercentage;
		var relativePercentage=dataList["dashboardRoot"][i].relativePercentage;
		var relativePercentageColor=dataList["dashboardRoot"][i].relativePercentageColor;

		var delayPercentage=dataList["dashboardRoot"][i].delayPercentage;
		var relativedelayPercentage=dataList["dashboardRoot"][i].relativedelayPercentage;
		var delayPercentageColor=dataList["dashboardRoot"][i].delayPercentageColor;

		var backHaulPercentage=dataList["dashboardRoot"][i].backHaulPercentage;
		var relativebackHaulPercentage=dataList["dashboardRoot"][i].relativebackHaulPercentage;
		var backHaulPercentageColor=dataList["dashboardRoot"][i].backHaulPercentageColor;

		var smartTruck=dataList["dashboardRoot"][i].smartTruck;
		var relativesmartTruck=dataList["dashboardRoot"][i].relativesmartTruck;
		var smartTruckColor=dataList["dashboardRoot"][i].smartTruckColor;

		var mileage22ft=dataList["dashboardRoot"][i].mileage22ft;
		var realtivemileage22ft=dataList["dashboardRoot"][i].realtivemileage22ft;
		var color22feet=dataList["dashboardRoot"][i].color22feet;

		var mileage24ft=dataList["dashboardRoot"][i].mileage24ft;
		var realtivemileage24ft=dataList["dashboardRoot"][i].realtivemileage24ft;
		var color24feet=dataList["dashboardRoot"][i].color24feet;

		var mileage32ft=dataList["dashboardRoot"][i].mileage32ft;
		var realtivemileage32ft=dataList["dashboardRoot"][i].realtivemileage32ft;
		var color32feet=dataList["dashboardRoot"][i].color32feet;

		var smartTrckerPerTruck=dataList["dashboardRoot"][i].smartTrckerPerTruck;
		var relativesmartTrckerPerTruck=dataList["dashboardRoot"][i].relativesmartTrckerPerTruck;
		var smartTrckerPerTruckColor=dataList["dashboardRoot"][i].smartTrckerPerTruckColor;

		var smartTruckTop=dataList["dashboardRoot"][i].smartTruckTop;
		var realativesmartTruckTop=dataList["dashboardRoot"][i].realativesmartTruckTop;
		var smartTruckTopColor=dataList["dashboardRoot"][i].smartTruckTopColor;

		document.getElementById("relativeTimeColorId").style.backgroundColor = relativePercentageColor;
		document.getElementById("relativeTimeId").innerHTML = relativePercentage;
		document.getElementById("ontimeId").innerHTML= ontimeperformance ;

		document.getElementById("delayPercentageColor").style.backgroundColor = delayPercentageColor;
		document.getElementById("relativedelayPercentage").innerHTML = relativedelayPercentage;
		document.getElementById("delayPercentage").innerHTML=  delayPercentage;

		document.getElementById("backHaulPercentageColor").style.backgroundColor = backHaulPercentageColor;
		document.getElementById("relativebackHaulPercentage").innerHTML = relativebackHaulPercentage;
		document.getElementById("backHaulPercentage").innerHTML= backHaulPercentage ;

		document.getElementById("smartTruckColor").style.backgroundColor = smartTruckColor;
		document.getElementById("relativesmartTruck").innerHTML = relativesmartTruck;
		document.getElementById("smartTruck").innerHTML= smartTruck ;

		 document.getElementById("smartTrckerPerTruckColor").style.backgroundColor = smartTrckerPerTruckColor ;
		 document.getElementById("relativesmartTrckerPerTruck").innerHTML = relativesmartTrckerPerTruck ;
		 document.getElementById("smartTrckerPerTruck").innerHTML = smartTrckerPerTruck ;

		 document.getElementById("smartTruckTopColor").style.backgroundColor = smartTruckTopColor ;
		 document.getElementById("realativesmartTruckTop").innerHTML = realativesmartTruckTop ;
		 document.getElementById("smartTruckTop").innerHTML = smartTruckTop ;


		 document.getElementById("22feetColor").style.backgroundColor = color22feet ;
		 document.getElementById("relative22feet").innerHTML = realtivemileage22ft ;
		 document.getElementById("22feet").innerHTML = mileage22ft ;

		 document.getElementById("24feetColor").style.backgroundColor = color24feet ;
		 document.getElementById("relative24feet").innerHTML =realtivemileage24ft;
		 document.getElementById("24feet").innerHTML = mileage24ft ;

		 document.getElementById("32feetColor").style.backgroundColor = color32feet ;
		 document.getElementById("relative32feet").innerHTML = realtivemileage32ft ;
		 document.getElementById("32feet").innerHTML =mileage32ft;


		//document.getElementById("relativeTimeColorId").style.backgroundColor = dataList["dashboardRoot"][i].relativePercentageColor;
		//document.getElementById("relativeTimeId").innerHTML = dataList["dashboardRoot"][i].relativePercentage;
		//document.getElementById("ontimeId").innerHTML= dataList["dashboardRoot"][i].ontimePercentage;

		}
			}
			 });

 }

 }
</script>
  <jsp:include page="../Common/footer.jsp" />
