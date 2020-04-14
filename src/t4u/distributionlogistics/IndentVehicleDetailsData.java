package t4u.distributionlogistics;

import java.util.ArrayList;
import java.util.List;


public class IndentVehicleDetailsData {
	private int indentId;
	private String node;
	private String vehicleType;
	private String make;
	private String dedicatedOrAdhoc;//TODO make Enum
	private String noOfVehicles;
	private String placementTime;
	private boolean valid;
	private List<String> errors = new ArrayList<String>();

	public IndentVehicleDetailsData(){
		
	}

	
	public String getNode() {
		return node;
	}

	public void setNode(String node) {
		this.node = node;
	}

	public String getVehicleType() {
		return vehicleType;
	}

	public void setVehicleType(String vehicleType) {
		this.vehicleType = vehicleType;
	}

	public String getMake() {
		return make;
	}

	public void setMake(String make) {
		this.make = make;
	}

	public String getDedicatedOrAdhoc() {
		return dedicatedOrAdhoc;
	}

	public void setDedicatedOrAdhoc(String dedicatedOrAdhoc) {
		this.dedicatedOrAdhoc = dedicatedOrAdhoc;
	}


	public int getIndentId() {
		return indentId;
	}


	public void setIndentId(int indentId) {
		this.indentId = indentId;
	}




	public String getNoOfVehicles() {
		return noOfVehicles;
	}


	public void setNoOfVehicles(String noOfVehicles) {
		this.noOfVehicles = noOfVehicles;
	}


	public String getPlacementTime() {
		return placementTime;
	}


	public void setPlacementTime(String placementTime) {
		this.placementTime = placementTime;
	}


	public boolean isValid() {
		return valid;
	}

	public void setValid(boolean valid) {
		this.valid = valid;
	}

	public List<String> getErrors() {
		return errors;
	}

	public void setErrors(List<String> errors) {
		this.errors = errors;
	}

	
}
