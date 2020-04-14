package t4u.distributionlogistics;

import java.util.ArrayList;
import java.util.List;


public class IndentMasterData {
	private String node;
	private int nodeId;
	private String region;
	private String dedicated;
	private String adhoc;
	private String supervisorName;
	private String supervisorContact;
	private boolean valid;
	private List<String> errors = new ArrayList<String>();

	public IndentMasterData(){
		
	}

	public int getNodeId() {
		return nodeId;
	}


	public void setNodeId(int nodeId) {
		this.nodeId = nodeId;
	}


	public String getNode() {
		return node;
	}

	public void setNode(String node) {
		this.node = node;
	}

	public String getRegion() {
		return region;
	}

	public void setRegion(String region) {
		this.region = region;
	}

	public String getDedicated() {
		return dedicated;
	}

	public void setDedicated(String dedicated) {
		this.dedicated = dedicated;
	}



	public String getAdhoc() {
		return adhoc;
	}



	public void setAdhoc(String adhoc) {
		this.adhoc = adhoc;
	}



	public String getSupervisorName() {
		return supervisorName;
	}



	public void setSupervisorName(String supervisorName) {
		this.supervisorName = supervisorName;
	}



	public String getSupervisorContact() {
		return supervisorContact;
	}



	public void setSupervisorContact(String supervisorContact) {
		this.supervisorContact = supervisorContact;
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
