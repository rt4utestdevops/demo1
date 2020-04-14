package t4u.admin;


public class SimDetailsData {
	public String mobileNumber;
	public String serviceProvider;
	public String simNumber;
	public String validityStartDate;
	public String validityEndDate;
	public String status;
	public String remarks;
	
	
	public SimDetailsData(String mobileNumber, String serviceProvider,String simNumber, String validityStartDate, String validityEndDate,String status,String remarks) {
		this.mobileNumber = mobileNumber;
		this.serviceProvider = serviceProvider;
		this.simNumber = simNumber;
		this.validityStartDate = validityStartDate;
		this.validityEndDate = validityEndDate;
		this.status = status;
		this.remarks = remarks;
	}

	public SimDetailsData(){
		
	}
	
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return this. mobileNumber+ " " + this.serviceProvider;
	}
	
}
