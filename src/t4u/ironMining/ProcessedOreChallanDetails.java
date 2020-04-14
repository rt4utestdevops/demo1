package t4u.ironMining;

public class ProcessedOreChallanDetails {

	public String validstatus;
	public String remarks;
	public String orgName;
	public String challanNo;
	public String quantity;
	public String vehicleNo;
	public int orgId;
	public int challanId;
	public String plantName;
	public int plantId;
	
	
	public ProcessedOreChallanDetails(String validstatus,String remarks,String orgName,String challanNo,
			String quantity,String vehicleNo,int orgId,int challanId,String plantName,int plantId) {
		this.validstatus = validstatus;
		this.remarks = remarks;
		this.orgName = orgName;
		this.challanNo = challanNo;
		this.quantity = quantity;
		this.vehicleNo = vehicleNo;
		this.orgId = orgId;
		this.challanId = challanId;
		this.plantName = plantName;
		this.plantId = plantId;
	}

	public ProcessedOreChallanDetails(){
		
	}
	
//	@Override
//	public String toString() {
//		// TODO Auto-generated method stub
//		return this. mobileNumber+ " " + this.serviceProvider;
//	}

}
