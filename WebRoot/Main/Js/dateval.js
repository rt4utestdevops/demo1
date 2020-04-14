
	
	
	 function isValid(parm,val) 
		 {
		 for (i=0; i<parm.length; i++)
		 {
		 	if (val.indexOf(parm.charAt(i),0) == -1) return false;
		 }
      	 return true;
		 }
		 	 function isSpecial(parm) 
		 {
		 var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";

  for (var i = 0; i < parm.length; i++) {
  	if (iChars.indexOf(parm.charAt(i)) != -1)  return false;
  	
  	}
  	return true;
  }
  
  
    function DateCompare1 (startDate, endDate)
     {
		   var startddindex = startDate.indexOf('/');
		   var startdd = startDate.substring(0,startddindex);
		   var startmmindex = startDate.lastIndexOf('/');
		   var startmm = startDate.substring(startddindex+1,startmmindex);
		   var startyear = startDate.substring(startmmindex+1,startDate.length);
		   var endddindex = endDate.indexOf('/');
		   var enddd = endDate.substring(0,endddindex);
		   var endmmindex = endDate.lastIndexOf('/');
		   var endmm = endDate.substring(endddindex+1,endmmindex);
		   var endyear = endDate.substring(endmmindex+1,endDate.length);
		   var date1=new Date(startmm+"/"+startdd+"/"+startyear);
		   var date2=new Date(endmm+"/"+enddd+"/"+endyear);
		if (date1 <= date2)
		{
   			return true;
		}
		else 
		{
   			return false;
		}

}

function DateCompare2 (startDate, endDate)
   {
		
		   
		   
		   var startddindex = startDate.indexOf('/');
		   var startdd = startDate.substring(0,startddindex);
		   
		   var startmmindex = startDate.lastIndexOf('/');
		   var startmm = startDate.substring(startddindex+1,startmmindex);
		   var startyear = startDate.substring(startmmindex+1,startDate.length);
		   
		   var endddindex = endDate.indexOf('/');
		   var enddd = endDate.substring(0,endddindex);
		   
		   var endmmindex = endDate.lastIndexOf('/');
		  
		   var endmm = endDate.substring(endddindex+1,endmmindex);
		   var endyear = endDate.substring(endmmindex+1,endDate.length);
		   var date1=new Date(startmm+"/"+startdd+"/"+startyear);
		   var date2=new Date(endmm+"/"+enddd+"/"+endyear);
		  
		  
		
		if (date1 < date2)
		{
   			return true;
		}
		else 
		{
   			return false;
		}
		
}




var dtCh= "/";
var minYear=1900;
var maxYear=2100;

function isInteger(s){
	var i;
    for (i = 0; i < s.length; i++){
        // Check that current character is number.
        var c = s.charAt(i);
        if (((c < "0") || (c > "9"))) return false;
    }
    // All characters are numbers.
    return true;
}

function stripCharsInBag(s, bag){
	var i;
    var returnString = "";
    // Search through string's characters one by one.
    // If character is not in bag, append to returnString.
    for (i = 0; i < s.length; i++){
        var c = s.charAt(i);
        if (bag.indexOf(c) == -1) returnString += c;
    }
    return returnString;
}

function daysInFebruary (year){
	// February has 29 days in any year evenly divisible by four,
    // EXCEPT for centurial years which are not also divisible by 400.
    return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
}
function DaysArray(n) {
	for (var i = 1; i <= n; i++) {
		this[i] = 31
		if (i==4 || i==6 || i==9 || i==11) {this[i] = 30}
		if (i==2) {this[i] = 29}
   }
   return this
}

function isDateValid(dtStr){
    //alert("inside isdate");
	var daysInMonth = DaysArray(12)
	var pos1=dtStr.indexOf(dtCh)
	var pos2=dtStr.indexOf(dtCh,pos1+1)
	var strDay=dtStr.substring(0,pos1)
	var strMonth=dtStr.substring(pos1+1,pos2)
	var strYear=dtStr.substring(pos2+1)
	strYr=strYear
	if (strDay.charAt(0)=="0" && strDay.length>1) strDay=strDay.substring(1)
	if (strMonth.charAt(0)=="0" && strMonth.length>1) strMonth=strMonth.substring(1)
	for (var i = 1; i <= 3; i++) {
		if (strYr.charAt(0)=="0" && strYr.length>1) strYr=strYr.substring(1)
	}
	month=parseInt(strMonth)
	day=parseInt(strDay)
	year=parseInt(strYr)
	
	if (dtStr.indexOf(dtCh,pos2+1)!=-1 || isInteger(stripCharsInBag(dtStr, dtCh))==false){
		
		return false
	}
	if (pos1==-1 || pos2==-1){
		//alert("The date format should be : dd/mm/yyyy")
		//return false
	}
	if (strDay.length<1 || day<1 || day>31 || (month==2 && day>daysInFebruary(year)) || day > daysInMonth[month]){
		
		return false
	}
	if (strMonth.length<1 || month<1 || month>12){
		
		return false
	}
	
	if (strYear.length != 4 || year==0 || year<minYear || year>maxYear){
		//alert("Please enter a valid 4 digit year between "+minYear+" and "+maxYear)
		return false
	}
return true
}


/**function noRightClick() { 
if (event.button==2) {
alert('Right click is disabled!') 
} 
} 

document.onmousedown=noRightClick 
**/ 
//for only client.jsp page used to compare date1 >=date2
function DateCompare3 (startDate, endDate)
   {
		
		   
		   
		   var startddindex = startDate.indexOf('/');
		   var startdd = startDate.substring(0,startddindex);
		   
		   var startmmindex = startDate.lastIndexOf('/');
		   var startmm = startDate.substring(startddindex+1,startmmindex);
		   var startyear = startDate.substring(startmmindex+1,startDate.length);
		   
		   var endddindex = endDate.indexOf('/');
		   var enddd = endDate.substring(0,endddindex);
		   
		   var endmmindex = endDate.lastIndexOf('/');
		  
		   var endmm = endDate.substring(endddindex+1,endmmindex);
		   var endyear = endDate.substring(endmmindex+1,endDate.length);
		   var date1=new Date(startmm+"/"+startdd+"/"+startyear);
		   var date2=new Date(endmm+"/"+enddd+"/"+endyear);
		  
		  //date1.setFullYear(startyear,startmm-1,startdd);
		  //date2.setFullYear(endyear,endmm-1,enddd);
		//var date1  = new Date(date1Str);
		//var date2  = new Date(date2Str);
		//
		
		if (date1 <=date2)
		{
   			return true;
		}
		else 
		{
   			return false;
		}
		
}


/*function DateCompare2 (date1Str, date2Str)
   {
		var date1  = new Date(date1Str);
		var date2  = new Date(date2Str);
		//
		if (date1 < date2)
		{
   			return true;
		}
		else 
		{
   			return false;
		}
  }
*/

var dtCh= "/";
var minYear=1900;
var maxYear=2100;

function isInteger(s){
	var i;
    for (i = 0; i < s.length; i++){
        // Check that current character is number.
        var c = s.charAt(i);
        if (((c < "0") || (c > "9"))) return false;
    }
    // All characters are numbers.
    return true;
}

function stripCharsInBag(s, bag){
	var i;
    var returnString = "";
    // Search through string's characters one by one.
    // If character is not in bag, append to returnString.
    for (i = 0; i < s.length; i++){
        var c = s.charAt(i);
        if (bag.indexOf(c) == -1) returnString += c;
    }
    return returnString;
}

function daysInFebruary (year){
	// February has 29 days in any year evenly divisible by four,
    // EXCEPT for centurial years which are not also divisible by 400.
    return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
}
function DaysArray(n) {
	for (var i = 1; i <= n; i++) {
		this[i] = 31
		if (i==4 || i==6 || i==9 || i==11) {this[i] = 30}
		if (i==2) {this[i] = 29}
   }
   return this
}
var minYear=1900;
var maxYear=2070;
function isDate(dtStr){
    //alert("inside isdate");
	var daysInMonth = DaysArray(12)
	var pos1=dtStr.indexOf(dtCh)
	var pos2=dtStr.indexOf(dtCh,pos1+1)
	var strDay=dtStr.substring(0,pos1)
	var strMonth=dtStr.substring(pos1+1,pos2)
	var strYear=dtStr.substring(pos2+1)
	strYr=strYear
	if (strDay.charAt(0)=="0" && strDay.length>1) strDay=strDay.substring(1)
	if (strMonth.charAt(0)=="0" && strMonth.length>1) strMonth=strMonth.substring(1)
	for (var i = 1; i <= 3; i++) {
		if (strYr.charAt(0)=="0" && strYr.length>1) strYr=strYr.substring(1)
	}
	month=parseInt(strMonth)
	day=parseInt(strDay)
	year=parseInt(strYr)
	
	if (dtStr.indexOf(dtCh,pos2+1)!=-1 || isInteger(stripCharsInBag(dtStr, dtCh))==false){
		
		return false
	}
	if (pos1==-1 || pos2==-1){
		//alert("The date format should be : dd/mm/yyyy")
		//return false
	}
	if (strDay.length<1 || day<1 || day>31 || (month==2 && day>daysInFebruary(year)) || day > daysInMonth[month]){
		
		return false
	}
	if (strMonth.length<1 || month<1 || month>12){
		
		return false
	}
	
	if (strYear.length != 4 || year==0 || year<minYear || year>maxYear){
		
		return false
	}
return true
}


/**function noRightClick() { 
if (event.button==2) {
alert('Right click is disabled!') 
} 
} 

document.onmousedown=noRightClick 
**/  
function timecompare(starthr,startmin,endhr,endmin)
{
alert("timecompare");
  if(starthr<endhr)
    {
    return true;
    }
  if (startmin<endmin)
    {
    return true;
    }
return false;
}

/* Start calender Functions Added by Mahesh 25-06-08 */
 var calendar = null;
  function closeHandler(cal) {
  cal.hide();                        // hide the calendar

  // don't check mousedown on document anymore (used to be able to hide the
  // calendar when someone clicks outside it, see the showCalendar function).
  Calendar.removeEvent(document, "mousedown", checkCalendar);
   }
   
  function selected(cal, date) {
  cal.sel.value = date; // just update the date in the input field.
  if (cal.sel.id == "sel1" || cal.sel.id == "sel2" || cal.sel.id == "sel3" || cal.sel.id == "sel4")
    // if we add this call we close the calendar on single-click.
    // just to exemplify both cases, we are using this only for the 1st
    // and the 3rd field, while 2nd and 4th will still require double-click.
    cal.callCloseHandler();
}
  

function showCalendar(date) {
  //alert("inside show calender 1");
  //var el = document.getElementById(id);
  var format='dd/mm/y';
  //var el= document.clientForm.txtRegisteredDate;
  var el= date;
  //alert("inside show calender 2" +el);
  if (calendar != null) {
    // we already have some calendar created
    // alert("inside show calender 3");
    calendar.hide();                 // so we hide it first.
  } else {
    // first-time call, create the calendar.
    var cal = new Calendar(true, null, selected, closeHandler);
    calendar = cal;                  // remember it in the global var
    cal.setRange(1900, 2070);        // min/max year allowed.
    cal.create();
     //alert("inside show calender  else 4");
  }
  calendar.setDateFormat(format); 
  //alert("inside show calender  else 5");   // set the specified date format
   calendar.parseDate(el.value);      // try to parse the text in field
    //calendar.parseDate('22/03/1980');
 //alert("inside show calender  else 6");
  calendar.sel = el;                 // inform it what input field we use
 //alert("inside show calender  else 7"); 
  calendar.showAtElement(el);        // show the calendar below it
// alert("inside show calender  else 8");
  // catch "mousedown" on document
  Calendar.addEvent(document, "mousedown", checkCalendar);
  //alert("end show calender");
  return false;
}

// This gets called when the user presses a mouse button anywhere in the
// document, if the calendar is shown.  If the click was outside the open
// calendar this function closes it.
function checkCalendar(ev) {
  var el = Calendar.is_ie ? Calendar.getElement(ev) : Calendar.getTargetElement(ev);
  for (; el != null; el = el.parentNode)
    // FIXME: allow end-user to click some link without closing the
    // calendar.  Good to see real-time stylesheet change :)
    if (el == calendar.element || el.tagName == "A") break;
  if (el == null) {
    // calls closeHandler which should hide the calendar.
    calendar.callCloseHandler();
    Calendar.stopEvent(ev);
  }
}


function reportLessthanfifteendays(startDate,endDate)
{
           var startddindex = startDate.indexOf('/');
		   var startdd = startDate.substring(0,startddindex);
		   
		   var startmmindex = startDate.lastIndexOf('/');
		   var startmm = startDate.substring(startddindex+1,startmmindex);
		   var startyear = startDate.substring(startmmindex+1,startDate.length);
		   
		   var endddindex = endDate.indexOf('/');
		   var enddd = endDate.substring(0,endddindex);
		   
		   var endmmindex = endDate.lastIndexOf('/');
		   var endmm = endDate.substring(endddindex+1,endmmindex);
		   var endyear = endDate.substring(endmmindex+1,endDate.length);
		  
		  
		   var date1=new Date(startmm+"/"+startdd+"/"+startyear);
		   var date2=new Date(endmm+"/"+enddd+"/"+endyear);
		  
		   if(parseInt(date2-date1)/(1000*60*60*24)>15)
		    {
		     alert("Report can be generated only when the difference between Start Date and End Date is 15 days");
		     return false;
		   }  
}
/* End of  calender Functions Added by Mahesh 25-06-08 */

function TimeCompare(startDate,endDate,starthr,endhr,startmin,endmin)
{
  if(startDate == endDate)
  {
    if(parseInt(starthr) == parseInt(endhr))
    {
      if(parseInt(startmin) < parseInt(endmin))
      {
      return true;
      }
      else
      {
      return false;
      }
    }
    else if(parseInt(starthr) < parseInt(endhr))
    {
      return true;
    }
    else
    {
      return false;
    }
  }
  else
  {
    return true;
  }
}

function currency(s)
{
   var i;
   var j;
   var dot=0;
   var chars="0123456789.";
   for (i=0;i<s.length;i++)
   {
     for(j=0;j<chars.length;j++)
     {
       if(s.charAt(i)==chars.charAt(j))
       {
         if(s.charAt(i)=='.')
         {
           dot++;
         }
         if(dot>1)
         {
           return false;
         }
         break;
       }
     }
     if(j==chars.length)
     {
       return false;
     }
   }
   return true;
}
function isEmpty(val)
{
if (val.match(/^s+$/) || val == "")
{
return true;
}
else
{
return false;
} 
}

//function to not to take blank spaces as input

         function chkspaces(textfield)
                {
                //alert("inside common js");
                var len=textfield.value.length;
                //alert("len :"+len);
                //alert("value :" +document.getElementById('txtLoginName').value);
                var str=new Array(len);
                var str =textfield.value;// document.getElementById('txtLoginName').value;//substring(0,len);
               // alert("str:");
                var flag=0;
                for (var i=0;i<len;i++)
                {
               // alert("value :"+str[i]);
                var asciicode = str.charCodeAt(0);
                  //alert("asciicode :"+asciicode);
                 if(asciicode==32)
                    {
                  flag=1;
                     }
                  
                  }
                  if(flag==1)
                    {
                 // alert("Please enter Chkspace Loginname");
                  textfield.value="";
 	              textfield.focus();
 	              return 1;
 	             
                    }
                 
                 }
                 
function islatlng(s)
{
  var val=parseFloat(s);
  if(s >= -90 && s <= 90)
  {
    return true;
  }
  return false;
}

function isValidName(Data)
{
  varChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  var isChar = true;
  var index = 0;
  if(varChars.indexOf(Data.charAt(index)) != -1)
  {
    return true;
  }
  return false; 
}
		 