package t4u.beans;

import java.io.Serializable;

public class MapAPIConfigBean implements Serializable {

	private Integer systemId;
	private String mapName;
	private String APIKey;
	private String AppCode;
	private String vehicleType;
	private String trafficType;
	private String status;
	private String routingType;
	private String graphHopperMapFile;
	private boolean walkingMode;
	private boolean liveTraffic;

	public MapAPIConfigBean() {

	}

	public Integer getSystemId() {
		return systemId;
	}

	public void setSystemId(Integer systemId) {
		this.systemId = systemId;
	}

	public String getMapName() {
		return mapName;
	}

	public void setMapName(String mapName) {
		this.mapName = mapName;
	}

	public String getAPIKey() {
		return APIKey;
	}

	public void setAPIKey(String aPIKey) {
		APIKey = aPIKey;
	}

	public String getAppCode() {
		return AppCode;
	}

	public void setAppCode(String appCode) {
		AppCode = appCode;
	}

	public String getVehicleType() {
		return vehicleType;
	}

	public void setVehicleType(String vehicleType) {
		this.vehicleType = vehicleType;
	}

	public String getTrafficType() {
		return trafficType;
	}

	public void setTrafficType(String trafficType) {
		this.trafficType = trafficType;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getRoutingType() {
		return routingType;
	}

	public void setRoutingType(String routingType) {
		this.routingType = routingType;
	}

	public String getGraphHopperMapFile() {
		return graphHopperMapFile;
	}

	public void setGraphHopperMapFile(String graphHopperMapFile) {
		this.graphHopperMapFile = graphHopperMapFile;
	}

	public boolean isWalkingMode() {
		return walkingMode;
	}

	public void setWalkingMode(boolean walkingMode) {
		this.walkingMode = walkingMode;
	}

	public boolean isLiveTraffic() {
		return liveTraffic;
	}

	public void setLiveTraffic(boolean liveTraffic) {
		this.liveTraffic = liveTraffic;
	}

}
