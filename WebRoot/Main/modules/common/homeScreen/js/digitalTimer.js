function getDigitalTimer(servertime) {
	
	/* Create two variable with the names of the months and days in an array */
	var monthNames = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]; 
	var dayNames= ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
	               
	 var newDate = new Date();
	
	/* Extract the current date from Date object */
	newDate.setDate(newDate.getDate());
	
	var copyrightYear = document.getElementById("copyrightYear");
	copyrightYear.innerHTML = "&#169 " + newDate.getFullYear() + " telematics4u";
	
	var d = new Date(servertime);
	var hh = d.getHours();
	var mm=d.getMinutes();
	var mms=d.getSeconds();
	var nd1 = new Date();
	
	nd1.setHours(parseInt(hh),parseInt(mm),parseInt(mms));	
	
	var GMTday=nd1.getUTCDay();
	var GMTdate=nd1.getUTCDate();
	var GMTmonth=nd1.getUTCMonth();
	var GMTyear=nd1.getUTCFullYear();	
	var GMTdayName=dayNames[parseInt(GMTday)];
	var GMTmonthName=monthNames[parseInt(GMTmonth)];
	
	var GMTtoday=GMTdayName + " " +GMTdate+ " " + GMTmonthName + " " + GMTyear;
	
	$('#Date').html(""+GMTtoday);
	
	setInterval(function showTime()
	{		
		mms=parseInt(mms);
		mm=parseInt(mm);
		hh=parseInt(hh);
		
		mms=mms+1;
		if(mms==60){
			mm=mm+1;
			mms=0;
		}
		if(mm==60){
			hh=hh+1;
			mm=0;
			mms=0;
		}
		if(hh==24){
			hh=1;
			mm=0;
			mms=0;
		}
		if (hh <= 9) hh = "0" + hh;
		if (mm <= 9) mm = "0" + mm;
		if (mms <= 9) mms = "0" + mms;
		
		$('#hours').html(" "+hh);
		$('#min').html(""+mm);
		$('#sec').html(""+mms);
		
	},1000);

	
}

function openNormalWindow(id,title,url,width,height)
{
	window.open(url, "jspPageId");
}
