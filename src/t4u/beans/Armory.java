package t4u.beans;

import java.io.Serializable;
import java.util.Date;

public class Armory implements Serializable{

	/**
	 * used in Cash Van Management Armory Master
	 */
	private static final long serialVersionUID = 1L;
	
	private String armoryName; 
	private String type;
	private String qrCode;
	private String vendor;
	private String branch;
	private Date inwardDateTime;
	private Date outwardDateTime;
	private Long assetnumber;
	private String  status;
	
	
	public String getArmoryName() {
		return armoryName;
	}
	public void setArmoryName(String armoryName) {
		this.armoryName = armoryName;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getQrCode() {
		return qrCode;
	}
	public void setQrCode(String qrCode) {
		this.qrCode = qrCode;
	}
	public String getVendor() {
		return vendor;
	}
	public void setVendor(String vendor) {
		this.vendor = vendor;
	}
	public String getBranch() {
		return branch;
	}
	public void setBranch(String branch) {
		this.branch = branch;
	}
	public Date getInwardDateTime() {
		return inwardDateTime;
	}
	public void setInwardDateTime(Date inwardDateTime) {
		this.inwardDateTime = inwardDateTime;
	}
	public Date getOutwardDateTime() {
		return outwardDateTime;
	}
	public void setOutwardDateTime(Date outwardDateTime) {
		this.outwardDateTime = outwardDateTime;
	}
	public Long getAssetnumber() {
		return assetnumber;
	}
	public void setAssetnumber(Long assetnumber) {
		this.assetnumber = assetnumber;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	

}
