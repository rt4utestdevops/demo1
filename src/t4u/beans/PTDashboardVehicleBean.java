package t4u.beans;

public class PTDashboardVehicleBean {

	private String assetNo;
	private Double duration;
	
	public Double getDuration() {
		return duration;
	}
	public void setDuration(Double duration) {
		this.duration = duration;
	}
	public void setAssetNo(String assetNo) {
		this.assetNo = assetNo;
	}
	public String getAssetNo() {
		return assetNo;
	}
	@Override
	public String toString() {
		return "PTDashboardVehicleBean [assetNo=" + assetNo + ", duration="
				+ duration + "]";
	}

}
