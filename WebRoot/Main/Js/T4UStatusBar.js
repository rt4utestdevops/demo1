var tsb;

Ext.onReady(function(){
	tsb= new Ext.ux.StatusBar({
		id: 'form-statusbar',
		defaultText: 'Ready',
		cls:'statusbarfontstyle',
		hasfocus:true
		});
});

function getMessageForStatus(statusfor){
	
	if(statusfor=="save"){
		return "Saved Successfully";
	}
	else if(statusfor=="error"){
		return "Error in Saving";
	}else{
		return statusfor;
	}
}