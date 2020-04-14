package t4u.statements;

public class FuelMileageStatements {
	
	public final String GET_FUEL_MILEAGE_DETAILS = "select  a.VehicleNo,isNull(c.ModelName,'') as VehicleModel,isNull(a.Driver,'') as DriverName,isNull(dateadd(mi,?,a.DateTime),'') as Date,isNull(a.Odometer,0) as Odometer,isNull(a.Disel,0) as Fuel,isNull(a.Amount,0) as Amount,isNull(a.SlipNo,'') as SlipNo,isNull(a.VendorBunk,'') as FuelStationName,isNull(a.Mileage,0) as Mileage,isNull(a.ApproximateMileage,0) as ApproximateMileage,isNull(a.Deviation,0) as Deviation,isNull(PetroCardNumber,'') as PetroCardNumber,isNull(b.Approx_Mileage_With_Load,'') as Approx_Mileage_With_Load,isnull(b.FuelUsed,'') as Fuel_Type " +
	"from FMS.dbo.MileagueMaster a " +
	"left outer join tblVehicleMaster b on a.VehicleNo = b.VehicleNo collate SQL_Latin1_General_CP1_CI_AS " +
	"left outer join FMS.dbo.Vehicle_Model c on a.SystemId = c.SystemId and a.ClientId = c.ClientId and b.Model = c.ModelTypeId " +
	"where  a.ClientId = ? and a.SystemId = ? and DateTime between dateAdd(mi,-?,?) and dateAdd(mi,-?,?)  ";

	public final String GET_FUEL_MILEAGE_SUMMARY_DETAILS = "select  a.VehicleNo,isNull(c.ModelName,'') as VehicleModel,count(*) as Count,sum(isNull(a.Mileage,0)) as TotalMileage,sum(isNull(a.Disel,0)) as TotalRefuel,sum(isNull(a.Amount,0)) as TotalAmount from FMS.dbo.MileagueMaster a " +
			"left outer join tblVehicleMaster b on a.VehicleNo = b.VehicleNo collate SQL_Latin1_General_CP1_CI_AS " +
			"left outer join FMS.dbo.Vehicle_Model c on a.SystemId = c.SystemId and a.ClientId = c.ClientId and b.Model = c.ModelTypeId " +
			"where  a.ClientId = ? and a.SystemId = ? and DateTime between dateAdd(mi,-?,?) and dateAdd(mi,-?,?) ";
	
	public final String GET_GROUP_ID_BASED_ON_ASSET_NUMBER = "select GROUP_ID from dbo.VEHICLE_CLIENT where REGISTRATION_NUMBER= ? and CLIENT_ID=? and SYSTEM_ID=?";

	public final String GET_PETRO_CARD_NUMBER = "select isNull(petrolCard, '') as PetrolCardNumber from tblVehicleMaster where VehicleNo=? and System_id=? ";

	public final String GET_TOP_ODOMETER = "select top 1 Odometer,Disel from FMS.dbo.MileagueMaster where  VehicleNo=? and ClientId = ? and SystemId=? order by DateTime desc";

	public final String GET_TOP_ODOMETER_WHILE_DELETE = "select top 1 Odometer,Disel,isNull(dateadd(mi,?,DateTime),'') as DateTime from FMS.dbo.MileagueMaster where  VehicleNo=? and ClientId = ? and SystemId=? order by DateTime desc";
	
	public final String INSERT_FUEL_DETAILS = "INSERT INTO [FMS].[dbo].[MileagueMaster]([VehicleNo],[Driver],[Odometer],[Mileage],[Disel],[Amount],[SlipNo],[DateTime],[VendorBunk],[ClientId],[SystemId],[ApproximateMileage],[Deviation],[PetroCardNumber],[GroupId],[CreatedBy]) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	
	public final String INSERT_FUEL_MILEAGUE_HISTORY_DETAIL = "insert into FMS.dbo.MileagueHistory (MileagueId,VehicleNo,Driver,Odometer,Disel,Mileage,Amount,SlipNo,DateTime,VendorBunk,ClientId,SystemId,ApproximateMileage,Deviation,PetroCardNumber,GroupId,CreatedDateTime,CreatedBy) " +
			"select top 1 * from FMS.dbo.MileagueMaster where VehicleNo=? and ClientId = ? and SystemId=? order by Odometer desc ";
	
	public final String GET_MILEAGUE_HISTORY_ID = "select max(MileagueHistoryId) as MileagueHistoryId from FMS.dbo.MileagueHistory";
			
	public final String UPDATE_MILEAGUE_HISTORY = "update FMS.dbo.MileagueHistory set DeletedBy = ?  where MileagueHistoryId = ?";
	
	public final String DELETE_MILEAGUE_MASTER_DETAILS = "delete from FMS.dbo.MileagueMaster where VehicleNo = ? and Odometer = ? and ClientId = ? and SystemId = ? ";
}
