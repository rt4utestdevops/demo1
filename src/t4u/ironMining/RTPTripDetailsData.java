package t4u.ironMining;

public class RTPTripDetailsData {

	public String validstatus;
	public String remarks;
	public String tcNo;
	public String orgName;
	public String permitNo;
	public String quantity;
	public String vehicleNo;
	public int orgId;
	public int permitId;
	public String plantName;
	public int plantId;
	
	
	public RTPTripDetailsData(String validstatus,String remarks,String orgName,String permitNo,
			String quantity,String vehicleNo,int tcId,int orgId,int permitId,String plantName,int plantId) {
		this.validstatus = validstatus;
		this.remarks = remarks;
		this.tcNo = tcNo;
		this.permitNo = permitNo;
		this.orgName = orgName;
		this.permitNo = permitNo;
		this.quantity = quantity;
		this.vehicleNo = vehicleNo;
		this.orgId = orgId;
		this.permitId = permitId;
		this.plantName = plantName;
		this.plantId = plantId;
	}

	public RTPTripDetailsData(){
		
	}
	
//	@Override
//	public String toString() {
//		// TODO Auto-generated method stub
//		return this. mobileNumber+ " " + this.serviceProvider;
//	}

}
