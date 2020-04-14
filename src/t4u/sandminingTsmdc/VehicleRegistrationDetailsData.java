package t4u.sandminingTsmdc;

public class VehicleRegistrationDetailsData {

	public String vehicleNumber;
	public String chassisNumber;
	public String ownerName;
	public String vehicleCapacity;
	public String status;
	public String remarks;
	
	public VehicleRegistrationDetailsData(String vehicleNumber, String chassisNumber,String ownerName, String vehicleCapacity, String status,String remarks) {
		this.vehicleNumber = vehicleNumber;
		this.chassisNumber = chassisNumber;
		this.ownerName = ownerName;
		this.vehicleCapacity = vehicleCapacity;
		this.status = status;
		this.remarks = remarks;
	}
	public VehicleRegistrationDetailsData(){
		
	}
	
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return this.vehicleNumber + " " + this.chassisNumber + " " + this.ownerName;
	}
	

}
