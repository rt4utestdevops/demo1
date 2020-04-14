package t4u.admin;

public class AssetDetailsData {
	public String oldAssetNo;
	public String newAssetNo;
	public String status;
	public String remarks;
	
	public AssetDetailsData(String oldAssetNo,String newAssetNo,String status,String remarks){
		this.oldAssetNo=oldAssetNo;
		this.newAssetNo=newAssetNo;
		this.status = status;
		this.remarks = remarks;
	}
	
	@Override
	public String toString() {		
		return this.oldAssetNo + " " + this.newAssetNo ;
	}
}
