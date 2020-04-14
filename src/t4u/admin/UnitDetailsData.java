package t4u.admin;


public class UnitDetailsData {
	public String unitNumber;
	public String manufacturer;
	public String unitType;
	public String unitReferenceId;
	public String status;
	public String remarks;
	
	public UnitDetailsData(String unitNumber, String manufacturer,String unitType, String unitReferenceId, String status,String remarks) {
		this.unitNumber = unitNumber;
		this.manufacturer = manufacturer;
		this.unitType = unitType;
		this.unitReferenceId = unitReferenceId;
		this.status = status;
		this.remarks = remarks;
	}
	public UnitDetailsData(){
		
	}
	
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return this.unitNumber + " " + this.manufacturer + " " + this.unitType;
	}
	
}
