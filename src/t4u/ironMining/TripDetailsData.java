package t4u.ironMining;

public class TripDetailsData {
	public String type;
	public String vehicleNumber;
	public String validityDate;
	public String permitNo;
	public String grossWeight;
	public String status;
	public String remarks;
	public String grade;
	public float permitQty;
	public int orgCode;
	public int tc_id;
	public int srcHubId;
	public int deshubId;
	public String routeName;
	public int routeId;
	public float netWeight;
	public float permitId;
	public float tareWeight;
	public String transactionID;
	public String bargeID;
	public String commStatus;
	
	public TripDetailsData(String type, String vehiclenumber,String validityDate, String permitNo, String grossWeight,String status,String remarks,float permitQty,float tareWeight,float netWeight,String grade,int routeId,int orgCode,int tc_id,int permitId,String transactionID,String bargeID,String commStatus) {
		this.type = type;
		this.vehicleNumber = vehiclenumber;
		this.validityDate = validityDate;
		this.permitNo = permitNo;
		this.grossWeight = grossWeight;
		this.status = status;
		this.remarks = remarks;
		this.permitQty = permitQty;
		this.routeId = routeId;
		this.grade = grade;
		this.orgCode = orgCode;
		this.tc_id = tc_id;
		this.netWeight = netWeight;
		this.permitId = permitId;
		this.tareWeight = tareWeight;
		this.transactionID = transactionID;
		this.bargeID = bargeID;
		this.commStatus = commStatus;
		
	}

	public TripDetailsData(){
		
	}
	
//	@Override
//	public String toString() {
//		// TODO Auto-generated method stub
//		return this. mobileNumber+ " " + this.serviceProvider;
//	}
}
