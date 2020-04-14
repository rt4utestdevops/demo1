package t4u.beans;

public class RakeShiftDetails {

	public String containerNo;
	public String ContainerSize;
	public String loadType;
	public String location;
	public String shipperName;
	public String billingCustomer;
	public String weight;
	public String sb_blNo;
	public String remarks;
	public String status1;
	public String remarks1;
	public RakeShiftDetails(String containerNo, String containerSize,
			String loadType, String location, String shipperName,
			String billingCustomer, String weight, String sbBlNo,
			 String remarks,String status1,String remarks1) {
		super();
		this.containerNo = containerNo;
		this.ContainerSize = containerSize;
		this.loadType = loadType;
		this.location = location;
		this.shipperName = shipperName;
		this.billingCustomer = billingCustomer;
		this.weight = weight;
		this.sb_blNo = sbBlNo;
		this.remarks = remarks;
		this.status1 = status1;
		this.remarks1 = remarks1;
	}
	
}
