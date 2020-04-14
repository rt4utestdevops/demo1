<%@ page language="java" pageEncoding="utf-8" %>

    <%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
        <%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
            <%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
                    <%@ taglib uri="http://packtag.sf.net" prefix="pack" %>

                        <jsp:include page="../Common/header.jsp" />                        

                                              
                            <html:base />

                            <title>SeatSelection.jsp</title>

                            <meta http-equiv="pragma" content="no-cache">
                            <meta http-equiv="cache-control" content="no-cache">
                            <meta http-equiv="expires" content="0">
                            <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
                            <meta http-equiv="description" content="This is my page">
                            <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

                            <!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
                            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
                            <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
                            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
                            <link rel="stylesheet" type="text/css" href="../../Main/modules/PassengerBusTransportation/css/component.css" />
                            <pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
                            <pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
                            <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
                            <script src="../../Main/Js/jquery.js"></script>
                            <script src="../../Main/Js/jquery-ui.js"></script>
                            <pack:script src="../../Main/resources/ux/gridfilters/menu/RangeMenu.js"></pack:script>
                            <pack:script src="../../Main/resources/ux/gridfilters/menu/ListMenu.js"></pack:script>
                            <pack:script src="../../Main/resources/ux/gridfilters/GridFilters.js"></pack:script>
                            <pack:script src="../../Main/resources/ux/gridfilters/filter/Filter.js"></pack:script>
                            <pack:script src="../../Main/resources/ux/gridfilters/filter/StringFilter.js"></pack:script>
                            <pack:script src="../../Main/resources/ux/gridfilters/filter/DateFilter.js"></pack:script>
                            <pack:script src="../../Main/resources/ux/gridfilters/filter/ListFilter.js"></pack:script>
                            <pack:script src="../../Main/resources/ux/gridfilters/filter/NumericFilter.js"></pack:script>
                            <pack:script src="../../Main/resources/ux/gridfilters/filter/BooleanFilter.js"></pack:script>
                            <pack:style src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
                            <pack:style src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
                            <pack:style src="../../Main/resources/css/ext-all.css" />
                            <pack:style src="../../Main/resources/css/chooser.css" />
                            <pack:script src="../../Main/Js/dropDown.js"></pack:script>
                            <pack:style src="../../Main/resources/css/examples1.css" />
                            <link rel="stylesheet" type="text/css" href="../../Main/modules/LTSP/theme/css/EXTJSExtn.css" />

                            <style type="text/css">
                                #container {
                                    background-color: #FFFFFF;
                                    width: 98% !Important;
                                    height: 95% !Important;
                                    -webkit-box-shadow: 1px 1px 3px #cac4ab;
                                    box-shadow: 1px 1px 3px #cac4ab;
                                    margin: 1%;
                                }
                                .ui-datepicker {
                                    width: 16em;
                                    padding: .2em .2em 0;
                                }
                                .ui-widget {
                                    font-family: 'Open Sas', sans-serif !important;
                                }
                                .ui-widget-header {
                                    border: 1px solid #aaaaaa;
                                    background: #6495ED;
                                    color: #FFFFFF;
                                    font-weight: bold;
                                }
                                #seatLayoutMain {
                                    margin: 2px 0 0px;
                                    background-color: #eee;
                                    width: 100%;
                                    height: 47%;
                                    display: none;
                                    box-shadow: 0 0 0 1px #6495ED !Important;
                                }
                                .validation {
                                    background-color: #eee;
                                    width: 280px;
                                    min-height: 30px;
                                    padding: 10px;
                                    color: black;
                                    position: absolute;
                                    text-align: center;
                                    vertical-align: middle;
                                    display: table-cell;
                                    border-radius: 2px;
                                }
                                .divBackgroundColor {
                                    font-family: 'Open Sas', sans-serif !important;
                                    font-size: 12px;
                                    padding-top: 8px;
                                    padding-bottom: 5px;
                                }
                                .ui-state-default {
                                    border: 1px solid #d3d3d3 !Important;
                                    font-weight: normal !Important;
                                    color: #555555 !Important;
                                    background: #ffffff !Important;
                                }
                                .ui-state-hover {
                                    background-color: #e24648 !Important;
                                    color: #fff !Important;
                                }
                                .header-heading {
                                    background-color: #e24648 !Important;
                                    color: #fff !Important;
                                }
                                .x-grid3-hd-row td {
                                    font-weight: normal;
                                    font-size: 12px !important;
                                    line-height: 1.36em;
                                    font-family: 'Open Sans', sans-serif !important;
                                    color: #FFFFFF;
                                    background-color: #6495ED;
                                    height: 35px !important;
                                    text-indent: 10px !important;
                                }
                                .ui-state-focus {
                                    border: 1px solid #999999;
                                    background: #e24648 !Important;
                                    font-weight: normal;
                                    color: #FFFFFF !Important;
                                }
								button.search {
									height : 62% !important;
								}
                                button:hover {
                                    background-color: #d0100c !Important;
                                    color: #fff !Important;
                                }
								.margin-image {
									margin-left: 0%;
								}
								#image {
									margin: 21px 6px 0 !important;
								}
                            </style>
                            <!--[if lt IE 9]>
      					<style>
      					#container
						{
    					display:table;
    					width: 100%;
						}
						.row
						{
    					height: 100%;
    					display: table-row;
						}
						.col-sm-4
						{
    					display: table-cell;
						}
      					</style>
    				<![endif]-->
                       
                            <div id="container">
                                <div id="accordion">
                                    <h3 class="header-heading">Search</h3>
                                    <div id="accordion-id">
                                        <div class="row">
                                            <div class="col-md-2 divBackgroundColor">
                                                <label for="usr">Origin</label>
                                                <input type="text" class="form-control input-id" placeholder="Origin" id="from-id">
                                            </div>
                                            <div class="col-md-1 divBackgroundColor margin-image">
                                                <span id="image"></span>
                                            </div>
                                            <div class="col-md-2 divBackgroundColor margin-input">
                                                <label for="usr">Destination</label>
                                                <input type="text" class="form-control input-id" placeholder="Destination" id="to-id">
                                            </div>
                                            <div class="col-md-2 divBackgroundColor">
                                                <label for="usr">Terminal&nbsp;&nbsp;(Onward)</label>
                                                <input type="text" class="form-control input-id" placeholder="Select Terminal" id="terminal-id">
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-2 divBackgroundColor">
                                                <label for="usr">Date Of Journey</label>
                                                <input type="text" class="form-control calendar" placeholder="Start Date" id="start-date">
                                            </div>
                                            <div class="col-md-1 divBackgroundColor margin-image">
                                            </div>
                                            <div class="col-md-2 divBackgroundColor margin-input">
                                                <label for="usr">Date of Return&nbsp;&nbsp;(Optional)</label>
                                                <input type="text" class="form-control calendar" placeholder="End Date" id="end-date">
                                            </div>
                                            <div class="col-md-2 divBackgroundColor margin-terminal">
                                                <label for="usr">Terminal&nbsp;&nbsp;(Return)</label>
                                                <input type="text" class="form-control  input-id" placeholder="Round Trip Terminal" id="round-terminal-id">
                                            </div>
                                            <div class="col-md-2 divBackgroundColor">
                                                <label for="usr"></label>
                                                <button class="search" onclick="dialog()">search</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>


                                <div id="myDialog">
                                    <div id="myDialogText"></div>
                                </div>
                                <div id="panelId"></div>
                                <div id="default"></div>
                                <div id="seatLayoutMain">
                                    <div id="seatLayoutBox">
                                        <div id="seat-container" class="seatlayoutContainer">
                                            <span class="tip">Tip:  Click on an available seat to select it. Click again to de-select it.</span>
                                            <div class="clearfix">
                                                <div class="rightContent">
                                                    <div class="legend">
                                                        <label><span class="avaliableSeat available"></span>Avaliable<span class="legend-type">&nbsp;Seat</span>
                                                        </label>
                                                        <label><span class="selectedSeat available"></span>Selected<span class="legend-type">&nbsp;Seat</span>
                                                        </label>
                                                        <label><span class="bookedSeat available"></span>Reserved<span class="legend-type">&nbsp;Seat</span>
                                                        </label>
                                                    </div>
                                                    <div class="fare">
                                                        <div class="seatsSelected">
                                                            <label>Seat(S)&nbsp;</label><span id="selected-seats"></span>
                                                        </div>
                                                        <div class="amount">
                                                            <label>Total&nbsp;&nbsp;Fare&nbsp;</label><span id="total-amount" class="fareval"></span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="leftContent" id="left-content-id">
                                                    <div class="seatLayoutHolder">
                                                        <div class="lowerDeck">
                                                            <ul class="deck" id="seatDeck"></ul>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="BPSelector">
                                                <div class="clearfix">
                                                    <button class="view" onclick="bookSeats()">Continue</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div id="default"></div>
                            </div>

                            <script type="text/javascript">
                                (function(i, s, o, g, r, a, m) {
                                    i['GoogleAnalyticsObject'] = r;
                                    i[r] = i[r] || function() {
                                        (i[r].q = i[r].q || []).push(arguments)
                                    }, i[r].l = 1 * new Date();
                                    a = s.createElement(o),
                                        m = s.getElementsByTagName(o)[0];
                                    a.async = 1;
                                    a.src = g;
                                    m.parentNode.insertBefore(a, m)
                                })(window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga');

                                ga('create', 'UA-42892514-4', 'telematics4u.in');
                                ga('send', 'pageview');
                                var pageFirstLoad = 1;
                                var terminalName;
                                var sourceName;
                                var selectedSource;
                                var destinationName;
                                var selectedDestination;
                                var startJourneyDate;
                                var endJourneyDate;
                                var returnTerminal = "";
                                var message = "Message!!!";
                                var priceValue;
                                var firstLoadDetails;
                                var reservedSeat;
                                var settings = {
                                    seatWidth: 35,
                                    seatHeight: 25,
                                    seatCss: 'seating',
                                    blank: 'blank',
                                    selectedSeatCss: 'bookedSeat',
                                    selectingSeatCss: 'selectedSeat'
                                };

                                var selectedSeatArray = [];
                                var roundTrip;
                                var flag;
                                var selectedSeatCount;
                                var selectedRoundSeatCount;
                                var selectedSeatNumbers;
                                var selectedRoundTripSeatNumbers;
                                var serviceID;
                                var terminalID;
                                var rateID;
                                var serviceID1;
                                var terminalID1;
                                var rateID1;
                                var date;
                                $(document).ready(function() {
                                    if (pageFirstLoad == 1) {

                                        $('#terminal-id').val('');
                                        $('#from-id').val('');
                                        $('#to-id').val('');
                                        $('#start-date').val('');
                                        $('#end-date').val('');
                                        $("#round-terminal-id").val('');
                                        pageFirstLoad = 0;
                                    }
                                    $("#accordion").accordion({
                                        collapsible: true,
                                        heightStyle: "content"
                                    });

                                    $("#end-date").datepicker({
                                        minDate: 0,
                                        maxDate: "9D",
                                        dateFormat: 'dd-mm-yy',
                                        onSelect: function(date) {
                                            $.ajax({
                                                url: "<%=request.getContextPath()%>/SeatSelectionAction.do?param=getTerminalNames",
                                                type: 'POST',
                                                timeout: 360000,
                                                data: {
                                                    destination: selectedSource,
                                                    source: selectedDestination
                                                },
                                                success: function(response, data) {
                                                    var listReturnTerminal = response.split("$");
                                                    $("#round-terminal-id").autocomplete({
                                                        source: listReturnTerminal,
                                                        select: function(event, ui) {
                                                            returnTerminal = ui.item.value;
                                                        }
                                                    });
                                                }
                                            });
                                        }
                                    });
                                    $("#start-date").datepicker({
                                        minDate: 0,
                                        maxDate: "9D",
                                        dateFormat: 'dd-mm-yy'
                                    });

                                    var sourceValue;
                                    $.ajax({
                                        url: "<%=request.getContextPath()%>/SeatSelectionAction.do?param=getOrigin",
                                        type: 'POST',
                                        timeout: 360000,
                                        success: function(response, data) {
                                            var sourceList = response;
                                            var source = sourceList.split("@");
                                            $("#from-id").autocomplete({
                                                source: source,
                                                autoFocus: true,
                                                select: function(event, ui) {
                                                    sourceValue = ui.item.value;
                                                    selectedSource = ui.item.value;
                                                    $.ajax({
                                                        url: "<%=request.getContextPath()%>/SeatSelectionAction.do?param=getDestination",
                                                        type: 'POST',
                                                        timeout: 360000,
                                                        data: {
                                                            source: ui.item.value
                                                        },
                                                        success: function(response, data) {
                                                            var destinationList = response.split("@");
                                                            $("#to-id").autocomplete({
                                                                source: destinationList,
                                                                autoFocus: true,
                                                                select: function(event, ui) {
                                                                    selectedDestination = ui.item.value;
                                                                    $.ajax({
                                                                        url: "<%=request.getContextPath()%>/SeatSelectionAction.do?param=getTerminalNames",
                                                                        type: 'POST',
                                                                        timeout: 360000,
                                                                        data: {
                                                                            destination: ui.item.value,
                                                                            source: sourceValue
                                                                        },
                                                                        success: function(response, data) {
                                                                            var text = response;
                                                                            var list = text.split("$");
                                                                            $("#terminal-id").autocomplete({
                                                                                source: list
                                                                            });
                                                                        }
                                                                    });
                                                                }

                                                            });

                                                        }
                                                    });
                                                }
                                            });
                                        }
                                    });


                                    $("body").on('click', '.seating', function() {
                                        if ($(this).hasClass(settings.selectedSeatCss)) {
                                            Ext.example.msg("Sorry!!! Seat Already Reserved");
                                            return;
                                        } else {
                                            if ($(this).hasClass(settings.selectingSeatCss)) {
                                                var deSelectedSeatNo = $(this).attr("id");
                                                var displaySeatNo = "";
                                                selectedSeatArray = $.grep(selectedSeatArray, function(value) {
                                                    return value != deSelectedSeatNo;
                                                });

                                                for (var k = 0; k < selectedSeatArray.length; k++) {
                                                    if (k == 0) {
                                                        displaySeatNo = parseInt(selectedSeatArray[k]);
                                                    } else {
                                                        displaySeatNo = displaySeatNo + ',' + parseInt(selectedSeatArray[k]);
                                                    }

                                                }
                                                $('#selected-seats').text(displaySeatNo);
                                                if (selectedSeatArray.length > 0) {
                                                    var price = parseInt(selectedSeatArray.length) * priceValue;
                                                    $('#total-amount').text('NGN :' + price.toFixed(2));
                                                } else {
                                                    $('#total-amount').text('');
                                                }
                                            } else {
                                                var selectedSeatNo = $(this).attr("id");
                                                var displaySeat = "";
                                                selectedSeatArray.push(parseInt(selectedSeatNo));
                                                for (var k = 0; k < selectedSeatArray.length; k++) {
                                                    if (k == 0) {
                                                        displaySeat = parseInt(selectedSeatArray[k]);
                                                    } else {
                                                        displaySeat = displaySeat + ',' + parseInt(selectedSeatArray[k]);
                                                    }

                                                }
                                                $('#selected-seats').text(displaySeat);
                                                if (selectedSeatArray.length > 0) {
                                                    var price = parseInt(selectedSeatArray.length) * priceValue;
                                                    $('#total-amount').text('NGN :' + price.toFixed(2));
                                                } else {
                                                    $('#total-amount').text('');
                                                }

                                            }
                                            $(this).toggleClass(settings.selectingSeatCss);
                                        }
                                    });

                                });

                                function dialog() {
                                    firstLoadDetails = 0;
                                    slider();
                                    terminalName = $('#terminal-id').val();
                                    sourceName = $('#from-id').val();
                                    destinationName = $('#to-id').val();
                                    startJourneyDate = $('#start-date').val();
                                    endJourneyDate = $('#end-date').val();

                                    if (sourceName.trim() == null || sourceName.trim() == "" || sourceName.trim() == 'undifined') {
                                        Ext.example.msg("Please Select Origin  ");
                                        return;
                                    }

                                    if (destinationName.trim() == null || destinationName.trim() == "" || destinationName.trim() == 'undifined') {
                                        Ext.example.msg("Please Select Destination ");
                                        return;
                                    }

                                    if (terminalName.trim() == null || terminalName.trim() == "" || terminalName.trim() == 'undifined') {
                                        Ext.example.msg("Please Select Terminal ");
                                        return;
                                    }

                                    if (startJourneyDate.trim() == null || startJourneyDate.trim() == "" || startJourneyDate.trim() == 'undifined') {
                                        Ext.example.msg("Please Select Date of Journey ");
                                        return;
                                    }
                                    date = startJourneyDate;
                                    if (startJourneyDate && endJourneyDate) {
                                        if (returnTerminal.trim() == null || returnTerminal.trim() == "" || returnTerminal.trim() == 'undifined') {
                                            Ext.example.msg("Please Select Return Terminal ");
                                            return;
                                        }else{                                                                         
                                        var startDate=startJourneyDate.split("-");
                                        var endDate=endJourneyDate.split("-");                                      
                                        var date1=new Date(startDate[2]+"-"+startDate[1]+"-"+startDate[0]);
                                        var date2=new Date(endDate[2]+"-"+endDate[1]+"-"+endDate[0]);                                      
                                         if(date2<date1){                                        
                                          Ext.example.msg("Date Of Return Cannot Be Less Then Date Of Journey ");
                                            return;
                                         }                                        
                                        }                                        
                                        roundTrip = 1;
                                        flag = 0;
                                    } else {
                                        roundTrip = 0;
                                        flag = 0;
                                    }
                                    store.load({
                                        params: {
                                            terminalName: terminalName,
                                            source: sourceName,
                                            destination: destinationName,
                                            startJourney: startJourneyDate,
                                            endJourney: endJourneyDate
                                        },
                                        callback: function() {
                                         if (store.getCount()== 0) {
                                          $("#myDialogText").text("Sorry!! No Service Available From " + sourceName + " To " + destinationName);
                                                    $("#myDialog").dialog({
                                                        title: message,
                                                        resizable: false,
                                                        modal: true,
                                                        height: "auto",
                                                        draggable: false,
                                                        show: {
                                                            effect: "fade",
                                                            duration: 800
                                                        },
                                                        open: function(event, ui) {
                                                            $(".ui-dialog-titlebar-close").hide();
                                                        },
                                                        buttons: {
                                                            Ok: function() {
                                                                $(this).dialog("close");
                                                            }
                                                        }
                                                    });
                                         
                                         }
                                         
                                        }
                                    });
                                }

                                function bookSeats() {

                                    if (roundTrip == 1 && flag == 0) {
                                        serviceID1 = serviceID;
                                        terminalID1 = terminalID;
                                        rateID1 = rateID;
                                        selectedSeatCount = selectedSeatArray.length;
                                        selectedSeatNumbers = returnSeats(selectedSeatArray);
                                        selectedSeatArray.length = 0;
                                        firstLoadDetails = 0;
                                        slider();
                                        store.load({
                                            params: {
                                                terminalName: returnTerminal,
                                                source: destinationName,
                                                destination: sourceName,
                                                startJourney: endJourneyDate,
                                            },
                                            callback: function() {
                                                if (store.getCount() > 0) {
                                                    $("#myDialogText").text("Please Select Seat From " + destinationName + " To " + sourceName + " For Return Journey");
                                                    $("#myDialog").dialog({
                                                        title: message,
                                                        resizable: false,
                                                        modal: true,
                                                        height: "auto",
                                                        draggable: false,
                                                        open: function(event, ui) {
                                                            $(".ui-dialog-titlebar-close").hide();
                                                        },
                                                        show: {
                                                            effect: "fade",
                                                            duration: 800
                                                        },
                                                        buttons: {
                                                            Ok: function() {
                                                                $(this).dialog("close");
                                                            }
                                                        }
                                                    });
                                                    flag = 1;
                                                    date = endJourneyDate;
                                                } else {
                                                    $("#myDialogText").text("Sorry!! No Service Available From " + destinationName + " To " + sourceName + " For Return Journey");
                                                    $("#myDialog").dialog({
                                                        title: message,
                                                        resizable: false,
                                                        modal: true,
                                                        height: "auto",
                                                        draggable: false,
                                                        show: {
                                                            effect: "fade",
                                                            duration: 800
                                                        },
                                                        open: function(event, ui) {
                                                            $(".ui-dialog-titlebar-close").hide();
                                                        },
                                                        buttons: {
                                                            Ok: function() {
                                                                $(this).dialog("close");
                                                            }
                                                        }
                                                    });

                                                }

                                            }
                                        });
                                    } else if (roundTrip == 0 && flag == 0) {
                                        selectedSeatCount = selectedSeatArray.length;
                                        if (selectedSeatCount == 0) {
                                            Ext.example.msg("Please Select Seats");
                                            return;
                                        } else {
                                            selectedSeatNumbers = returnSeats(selectedSeatArray);

                                            $.ajax({
                                                url: "<%=request.getContextPath()%>/SeatSelectionAction.do?param=saveBookedSeats",
                                                type: 'POST',
                                                timeout: 360000,
                                                data: {
                                                    journeyDate: startJourneyDate,
                                                    serviceID: serviceID,
                                                    terminalID: terminalID,
                                                    rateID: rateID,
                                                    noOfSeats: selectedSeatCount,
                                                    trip: 'single',
                                                    seatNumbers: selectedSeatNumbers
                                                },
                                                success: function(response, data) {
                                                    var returnTempID = response;
                                                    window.location = "<%=request.getContextPath()%>/Jsps/PassengerBusTransportation/PassengerPaymentDetails.jsp?TripType=0&TempId1=" + returnTempID + "&TempId2=0";
                                                }
                                            });
                                        }
                                    } else if (roundTrip == 1 && flag == 1) {
                                        selectedRoundSeatCount = selectedSeatArray.length;
                                        if (selectedRoundSeatCount < selectedSeatCount || selectedRoundSeatCount > selectedSeatCount) {
                                            Ext.example.msg("Please Select " + selectedSeatCount + " Seats");
                                            return;
                                        } else {
                                            selectedRoundTripSeatNumbers = returnSeats(selectedSeatArray);
                                            $.ajax({
                                                url: "<%=request.getContextPath()%>/SeatSelectionAction.do?param=saveBookedSeats",
                                                type: 'POST',
                                                timeout: 360000,
                                                data: {
                                                    journeyDate: startJourneyDate,
                                                    serviceID: serviceID1,
                                                    terminalID: terminalID1,
                                                    rateID: rateID1,
                                                    noOfSeats: selectedSeatCount,
                                                    seatNumbers: selectedSeatNumbers,
                                                    returnDate: endJourneyDate,
                                                    returnServiceID: serviceID,
                                                    returnRateID: rateID,
                                                    returnTerminalID: terminalID,
                                                    trip: 'round',
                                                    returnSeatNumbers: selectedRoundTripSeatNumbers
                                                },
                                                success: function(response, data) {
                                                    var details = response;
                                                    var text = details.split(",");
                                                    window.location = "<%=request.getContextPath()%>/Jsps/PassengerBusTransportation/PassengerPaymentDetails.jsp?TripType=1&TempId1=" + text[0] + "&TempId2=" + text[1];

                                                }
                                            });
                                        }
                                    }
                                }

                                function returnSeats(seatArray) {
                                    var seats = "";
                                    for (var k = 0; k < seatArray.length; k++) {
                                        if (k == 0) {
                                            seats = parseInt(seatArray[k]);
                                        } else {
                                            seats = seats + ',' + parseInt(seatArray[k]);
                                        }

                                    }
                                    return seats;
                                }




                                function display() {
                                    var effect = 'slide';
                                    var options = {
                                        direction: 'up'
                                    };
                                    var duration = 400;
                                    if ($('#seatLayoutMain').is(":visible")) {

                                        $('#seatLayoutMain').css('display', 'none');
                                    }
                                    if (firstLoadDetails == 1) {
                                        $('#seatLayoutMain').css('display', 'block');
                                    }


                                }

                                function slider() {
                                    var effect = 'slide';
                                    var options = {
                                        direction: 'up'
                                    };
                                    var duration = 200;
                                    if ($('#seatLayoutMain').is(":visible")) {
                                        $('#seatLayoutMain').toggle(effect, options, duration);
                                    }
                                    if (firstLoadDetails == 1) {
                                        $('#seatLayoutMain').toggle(effect, options, duration);
                                    }


                                }



                                function seatingStructure(structureDesign, reserved) {
                                    $('#total-amount').text('');
                                    $('#selected-seats').text('');

                                    reservedSeat = JSON.parse("[" + reserved + "]");

                                    $('#seatDeck').html(structureDesign);
                                    if ($("#seatDeck li").length == 75) {
                                        var lastRow = $("#seatDeck li").length / 6 - 1;
                                        $("#left-content-id").width(settings.seatWidth * Math.round(lastRow)).height(Math.round(lastRow) * settings.seatHeight - 165);
                                    } else if ($("#seatDeck li").length > 22) {
                                        var lastRow = $("#seatDeck li").length / 4 - 1;
                                        $("#left-content-id").width(settings.seatWidth * Math.round(lastRow) - 60).height(Math.round(lastRow) * settings.seatHeight - 70);
                                    } else {
                                        var lastRow = $("#seatDeck li").length / 3 - 1;
                                        $("#left-content-id").width(settings.seatWidth * Math.round(lastRow)).height(Math.round(lastRow) * settings.seatHeight);
                                    }

                                    for (var i = 0; i < reservedSeat.length; i++) {
                                        var id = "#" + reservedSeat[i];
                                        $(id).removeClass(settings.seatCss);
                                        $(id).addClass(settings.selectedSeatCss);
                                    }

                                    firstLoadDetails = 1;
                                    display();

                                }

                                var reader = new Ext.data.JsonReader({
                                    idProperty: 'darreaderid',
                                    root: 'servicenameroot',
                                    totalProperty: 'total',
                                    fields: [{
                                        type: 'string',
                                        name: 'servicenameindex'
                                    }, {
                                        type: 'string',
                                        name: 'vehiclemodelindex'
                                    }, {
                                        type: 'string',
                                        name: 'departureindex'
                                    }, {
                                        type: 'string',
                                        name: 'arivalindex'
                                    }, {
                                        type: 'string',
                                        name: 'durationindex'

                                    }, {

                                        type: 'numeric',
                                        name: 'avaliableindex'

                                    }, {

                                        type: 'numeric',
                                        name: 'priceindex'

                                    }, {

                                        type: 'string',
                                        name: 'structurenameindex'

                                    }, {

                                        type: 'numeric',
                                        name: 'serviceidindex'

                                    }, {

                                        type: 'string',
                                        name: 'terminalnameindex'

                                    }, {

                                        type: 'numeric',
                                        name: 'terminalidindex'

                                    }, {

                                        type: 'numeric',
                                        name: 'rateidindex'

                                    }, {

                                        type: 'string',
                                        name: 'routenameindex'

                                    }]
                                });


                                var filters = new Ext.ux.grid.GridFilters({
                                    local: true,
                                    filters: [{
                                        dataIndex: 'servicenameindex',
                                        type: 'string'
                                    }, {
                                        dataIndex: 'vehiclemodelindex',
                                        type: 'string',
                                    }, {
                                        dataIndex: 'departureindex',
                                        type: 'string',
                                    }, {
                                        dataIndex: 'arivalindex',
                                        type: 'string',
                                    }, {
                                        dataIndex: 'durationindex',
                                        type: 'string',
                                    }, {
                                        dataIndex: 'avaliableindex',
                                        type: 'numeric',
                                    }, {
                                        dataIndex: 'priceindex',
                                        type: 'numeric',
                                    }, {
                                        dataIndex: 'structurenameindex',
                                        type: 'string',
                                    }, {
                                        dataIndex: 'serviceidindex',
                                        type: 'numeric',
                                    }, {
                                        dataIndex: 'terminalnameindex',
                                        type: 'string',
                                    }, {
                                        dataIndex: 'terminalidindex',
                                        type: 'numeric',
                                    }, {
                                        dataIndex: 'rateidindex',
                                        type: 'numeric',
                                    }, {
                                        dataIndex: 'routenameindex',
                                        type: 'string',
                                    }]
                                });


                                var store = new Ext.data.GroupingStore({
                                    autoLoad: false,
                                    proxy: new Ext.data.HttpProxy({
                                        url: '<%=request.getContextPath()%>/SeatSelectionAction.do?param=getServiceNames',
                                        method: 'POST'
                                    }),
                                    baseParams: {
                                        terminalName: terminalName,
                                        source: sourceName,
                                        destination: destinationName,
                                        startJourney: startJourneyDate,
                                        endJourney: endJourneyDate
                                    },
                                    remoteSort: false,
                                    sortInfo: {
                                        field: 'servicenameindex',
                                        direction: 'ASC'
                                    },
                                    reader: reader
                                });

                                //************************************Column Model Config******************************************
                                var colModel = new Ext.grid.ColumnModel({
                                    defaults: {
                                        sortable: true,
                                        menuDisabled: true
                                    },
                                    columns: [{
                                            header: 'Service Name',
                                            sortable: true,
                                            dataIndex: 'servicenameindex',
                                            width: 80,
                                            draggable: false
                                        }, {
                                            header: 'Vehicle Model',
                                            sortable: true,
                                            dataIndex: 'vehiclemodelindex',
                                            width: 80
                                        }, {
                                            header: 'Departure',
                                            sortable: true,
                                            dataIndex: 'departureindex',
                                            width: 80
                                        }, {
                                            header: 'Arrival',
                                            sortable: true,
                                            dataIndex: 'arivalindex',
                                            width: 80
                                        }, {
                                            header: 'Duration (HH:MM)',
                                            sortable: true,
                                            dataIndex: 'durationindex',
                                            width: 80
                                        }, {
                                            header: 'Available Seats',
                                            sortable: true,
                                            dataIndex: 'avaliableindex',
                                            width: 80
                                        }, {
                                            header: 'Price',
                                            sortable: true,
                                            dataIndex: 'priceindex',
                                            width: 80
                                        }, {
                                            header: 'Structure Name',
                                            sortable: true,
                                            hidden: true,
                                            dataIndex: 'structurenameindex',
                                            width: 80
                                        }, {
                                            header: 'Service ID',
                                            sortable: true,
                                            hidden: true,
                                            dataIndex: 'serviceidindex',
                                            width: 80
                                        }, {
                                            header: 'Terminal Name',
                                            sortable: true,
                                            hidden: true,
                                            dataIndex: 'terminalnameindex',
                                            width: 80
                                        }, {
                                            header: 'Termianl ID',
                                            sortable: true,
                                            hidden: true,
                                            dataIndex: 'terminalidindex',
                                            width: 80
                                        }, {
                                            header: 'Rate ID',
                                            sortable: true,
                                            hidden: true,
                                            dataIndex: 'rateidindex',
                                            width: 80
                                        }, {
                                            header: 'Route Name',
                                            sortable: true,
                                            hidden: true,
                                            dataIndex: 'routenameindex',
                                            width: 80
                                        }, {
                                            header: 'View',
                                            xtype: 'actioncolumn',
                                            width: 50,
                                            items: [{
                                                icon: '/ApplicationImages/ApplicationButtonIcons/view_button_red.jpg',
                                                tooltip: 'View',
                                                handler: function(grid, rowIndex, colIndex) {
                                                    $("#accordion").accordion({
                                                        active: false,

                                                    });
                                                    var record = grid.getStore().getAt(rowIndex); // Get the Record	
                                                    serviceID = record.get('serviceidindex');
                                                    terminalID = record.get('terminalidindex');
                                                    rateID = record.get('rateidindex');
                                                    $.ajax({
                                                        url: "<%=request.getContextPath()%>/SeatSelectionAction.do?param=getBookedSeats",
                                                        type: 'POST',
                                                        data: {
                                                            serviceName: record.get('servicenameindex'),
                                                            routeName: record.get('routenameindex'),
                                                            terminalName: record.get('terminalnameindex'),
                                                            journeyDate: date,
                                                            serviceID: record.get('serviceidindex'),
                                                            terminalID: record.get('terminalidindex'),
                                                            rateID: record.get('rateidindex')

                                                        },
                                                        success: function(response, data) {
                                                            selectedSeatArray.length = 0;
                                                            var text = response;
                                                            var reserved = text.split(",");
                                                            priceValue = parseFloat(record.get('priceindex'));
                                                            $.ajax({
                                                                url: "<%=request.getContextPath()%>/SeatSelectionAction.do?param=getSeatingStructureDesign",
                                                                type: 'POST',
                                                                timeout: 360000,
                                                                data: {
                                                                    structureName: record.get('structurenameindex')
                                                                },
                                                                success: function(response, data) {
                                                                    seatingStructure(response, reserved);
                                                                }
                                                            });
                                                        }
                                                    });

                                                }
                                            }]
                                        }

                                    ]
                                });

                                var selModel = new Ext.grid.RowSelectionModel({
                                    singleSelect: true
                                });

                                var grid = new Ext.grid.EditorGridPanel({
                                    height: 300,
                                    disableSelection: true,
                                    layout: 'fit',
                                    viewConfig: {
                                        forceFit: true,
                                    },
                                    store: store,
                                    colModel: colModel,
                                    loadMask: true,
                                    border: false,
                                    sm: selModel,
                                    enableColumnMove: false,
                                    plugins: [filters]
                                });

                                setTimeout(function() {
                                    grid.render('panelId');
                                    grid.getSelectionModel().lock();
                                }, 500);

                                //**************************** Below overidden functions will eliminates grid alignment issues(Note:Use these functions only if required)******************	
                                if (!Ext.isDefined(Ext.webKitVersion)) {
                                    Ext.webKitVersion = Ext.isWebKit ? parseFloat(/AppleWebKit\/([\d.]+)/.exec(navigator.userAgent)[1], 10) : NaN;
                                }
                                /*
                                 * Box-sizing was changed beginning with Chrome v19.  For background information, see:
                                 * http://code.google.com/p/chromium/issues/detail?id=124816
                                 * https://bugs.webkit.org/show_bug.cgi?id=78412
                                 * https://bugs.webkit.org/show_bug.cgi?id=87536
                                 * http://www.sencha.com/forum/showthread.php?198124-Grids-are-rendered-differently-in-upcoming-versions-of-Google-Chrome&p=824367
                                 *
                                 * */
                                if (Ext.isWebKit && Ext.webKitVersion >= 535.2) { // probably not the exact version, but the issues started appearing in chromium 19
                                    Ext.override(Ext.grid.ColumnModel, {
                                        getTotalWidth: function(includeHidden) {
                                            if (!this.totalWidth) {
                                                var boxsizeadj = 2;
                                                this.totalWidth = 0;
                                                for (var i = 0, len = this.config.length; i < len; i++) {
                                                    if (includeHidden || !this.isHidden(i)) {
                                                        this.totalWidth += (this.getColumnWidth(i) + boxsizeadj);
                                                    }
                                                }
                                            }
                                            return this.totalWidth;
                                        }
                                    });

                                    Ext.onReady(function() {
                                        Ext.get(document.body).addClass('ext-chrome-fixes');
                                        Ext.util.CSS.createStyleSheet('@media screen and (-webkit-min-device-pixel-ratio:0) {.x-grid3-cell{box-sizing: border-box !important;}}', 'chrome-fixes-box-sizing');
                                    });
                                }
                            </script>
                        <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->