package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import t4u.common.DBConnection;


public class DriverEvaluation {
	HashMap<Integer,DriverEvaluationDTO> driverScore = new HashMap<Integer,DriverEvaluationDTO>();
	HashMap<Integer,String[]> monthlyDriverScore = new HashMap<Integer,String[]>();
	SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	int systemId;
	int clientId;
	String driverIdStr;
	int settingId;
	String startDate;
	String endDate;
	String groId;
	ArrayList<String> driverList;

	/** constructor for driver evaluation of selected date time */
	public DriverEvaluation(int systemId,int clientId,String driverIdStr,int settingId,String startDate,String endDate){
		this.systemId = systemId;
		this.clientId = clientId;
		this.driverIdStr = driverIdStr;
		this.settingId = settingId;
		this.startDate = startDate;
		this.endDate = endDate;
	}
	/** constructor for monthly driver evaluation */
	public DriverEvaluation(int systemId,int clientId,String driverIdStr,int settingId,int year,String startDate,String endDate){
		this.systemId = systemId;
		this.clientId = clientId;
		this.driverIdStr = driverIdStr;
		this.settingId = settingId;
		this.startDate = startDate;
		this.endDate = endDate;
	}
	/** gouse For PDO Report */	
	public DriverEvaluation(int systemId,int clientId,String driverIdStr,String groId,String startDate,String endDate, ArrayList<String> driverList){
		this.systemId = systemId;
		this.clientId = clientId;
		this.driverIdStr = driverIdStr;
		this.groId = groId;
		this.startDate = startDate;
		this.endDate = endDate;
		this.driverList = driverList;
	}
	/** get driver evaluation data of selected date time */
	public HashMap<Integer,DriverEvaluationDTO> getDriverScore(){
		calculateDriverScore();
		return driverScore;
	}

	public HashMap<Integer,DriverEvaluationDTO> getDriverScorePDO(){
		calculateDriverScorePDO();
		return driverScore;
	}
	/** get monthly driver evaluation data of selected date time */
	public HashMap<Integer,String[]> getMonthlyDriverScore(){
		calculateMonthlyDriverScore();
		return monthlyDriverScore;
	}

	/** calculate driver evaluation data of selected date time */
	public void calculateDriverScore(){
		//DriverMatrixSQLFunctions dms = new DriverMatrixSQLFunctions();
		DBConnection dms=new DBConnection();
		ScoreSettings ss= null;
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con=dms.getConnectionToDB("AMS");
			ss  = new ScoreSettings(systemId,settingId,con);

			String SELECT_DRIVER_EVALUATION_DATA = "select Driver_id,Fullname,sum(TotalDistance) as TotalDistance,"+
			"sum(DrivingHr) as DrivingHr,max(MaxSpeed) as MaxSpeed,sum(AcclCount) as AcclCount,"+
			"sum(TotalAccl) as TotalAccl,sum(DeclCount) as DeclCount,sum(TotalDecl) as TotalDecl,"+
			"sum(OverSpeedCount) as OverSpeedCount,sum(OverSpeedCountGraded) as OverSpeedCountGraded,sum(OverSpeedDistance) as OverSpeedDistance,"+
			"sum(StopTime) as StopTime,sum(IdleTime) as IdleTime,sum(SeatBeltCount) as SeatBeltCount,"+
			"sum(DistWithOutSeatBelt) as DistWithOutSeatBelt,sum(ACIdleCount) as ACIdleCount "+
			"from Driver_Master left outer join DriverEvaluation "+ 
			"on System_id = SystemId and Driver_id = DriverId "+
			"where Driver_id in"+driverIdStr+ " "+
			"and System_id=? and Client_id=? and "+
			"(EndDate between ? and ? or EndDate is null) "+
			"group by Driver_id,Fullname";

			//System.out.println("SELECT_DRIVER_EVALUATION_DATA : " + SELECT_DRIVER_EVALUATION_DATA);

			pstmt=con.prepareStatement(SELECT_DRIVER_EVALUATION_DATA);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, startDate);
			pstmt.setString(4, endDate);
			rs = pstmt.executeQuery();			
			while(rs.next()){
				int driverId = rs.getInt("Driver_id");
				String driverName = rs.getString("Fullname");
				double distanceDrived = rs.getDouble("TotalDistance");
				double drivingHr = rs.getDouble("DrivingHr");
				double acclCount = rs.getDouble("AcclCount");
				double declCount = rs.getDouble("DeclCount");
				double overspeedCount = rs.getDouble("OverSpeedCount");
				double overspeedCountgraded = rs.getDouble("OverSpeedCountGraded");
				double idleTime = rs.getDouble("IdleTime");
				double seatBelt = rs.getDouble("SeatBeltCount");
				double distWithOutSeatBelt = rs.getDouble("DistWithOutSeatBelt");
				double harshdrivecount =rs.getInt("AcclCount")+ rs.getInt("DeclCount");
				storeDriverEvaluationData(ss,driverId,driverName,distanceDrived,drivingHr,acclCount,declCount,overspeedCount,overspeedCountgraded,idleTime,seatBelt,distWithOutSeatBelt,harshdrivecount);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			dms.releaseConnectionToDB(con,pstmt,rs);
		}
	}

	/**	
	 *  Added By Gouse for DRIVERPDO
	 */
	public void calculateDriverScorePDO(){
		DBConnection dms = new DBConnection();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		ArrayList<String> inDriverList = new ArrayList<String>();

		double overspeedscorenew =0;
		double harshcountscore=0;
		double harshbrecountscore=0;
		int driverId = 0;
		String driverName = null;
		double distanceDriven = 0;
		double Overspeeddurationgraded = 0;
		double Overspeeddurationblacktop = 0;
		double totalosduration = 0;
		double overspeedscore = 0;
		double harshacccount = 0;
		double harshbrecount = 0;
		double totalscore = 0;
		double maxSpeed=0;

		try{
			con=dms.getConnectionToDB("AMS");
			String SELECT_DRIVER_EVALUATION_DATA_PDO = "select Driver_id,Fullname,sum(TotalDistance) as TotalDistance,"+
			"sum(AcclCount) as AcclCount,sum(TotalAccl) as TotalAccl,sum(DeclCount) as DeclCount,sum(TotalDecl) as TotalDecl,"+
			"sum(isnull(OverSpeedDurationBlackTopSecs,0)) as OverSpeedDurationBlackTop,sum(isnull(OverSpeedDurationGradedSecs,0)) as OverSpeedDurationGraded,max(isnull(MaxSpeed,0)) as MaxSpeed  "+
			"from Driver_Master inner join DriverEvaluation "+ 
			"on System_id = SystemId and Driver_id = DriverId "+
			"where Driver_id in"+driverIdStr+ " "+
			"and System_id=? and Client_id=? and "+
			"(StartDate >= ? and  EndDate <= ? or EndDate is null) "+
			"group by Driver_id,Fullname";

			pstmt=con.prepareStatement(SELECT_DRIVER_EVALUATION_DATA_PDO);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, startDate);
			pstmt.setString(4, endDate);
			rs = pstmt.executeQuery();
			while(rs.next()){


				driverId = rs.getInt("Driver_id");
				driverName = rs.getString("Fullname");
				distanceDriven = rs.getDouble("TotalDistance");
				Overspeeddurationgraded = rs.getDouble("OverSpeedDurationGraded");
				Overspeeddurationblacktop = rs.getDouble("OverSpeedDurationBlackTop");
				totalosduration = rs.getDouble("OverSpeedDurationGraded")+rs.getDouble("OverSpeedDurationBlackTop");
				inDriverList.add(String.valueOf(driverId));
				overspeedscore = totalosduration/10;
				if(distanceDriven!=0){
					overspeedscorenew  =((overspeedscore/distanceDriven)*100);
				}
				else{
					overspeedscorenew = 0;
				}

				harshacccount = rs.getDouble("AcclCount");
				if(distanceDriven!=0){
					harshcountscore  =((harshacccount/distanceDriven)*100);
				}
				else{
					harshcountscore = 0;
				}

				harshbrecount = rs.getDouble("DeclCount");
				if(distanceDriven!=0){
					harshbrecountscore  =((harshbrecount/distanceDriven)*100);
				}
				else{
					harshbrecountscore = 0;
				}
				maxSpeed=rs.getDouble("MaxSpeed");
				totalscore = (overspeedscorenew+harshcountscore+harshbrecountscore);
				//System.out.println("totalscore****"+totalscore);
				//System.out.println("totalosduration"+totalosduration);
				//System.out.println("overspeedscorenew"+overspeedscorenew);
				storeDriverEvaluationDataPDO(driverId,driverName,distanceDriven,Overspeeddurationgraded,Overspeeddurationblacktop,totalosduration,overspeedscorenew,harshacccount,harshcountscore,harshbrecount,harshbrecountscore,totalscore,maxSpeed);
			}

			for(int i=0;i<inDriverList.size();i++)
			{
				driverList.remove(inDriverList.get(i));
			}

			String tempDriverStr = "";

			for(int i=0;i<driverList.size();i++)
			{
				tempDriverStr = tempDriverStr+driverList.get(i)+",";
			}
			//			System.out.println("In driverIdStr:"+driverIdStr);
			//			System.out.println("Not In tempDriverStr:"+tempDriverStr);
			if(!tempDriverStr.equalsIgnoreCase(""))
			{
				tempDriverStr =tempDriverStr.substring(0,tempDriverStr.lastIndexOf(","));

				String query = "select Driver_id,Fullname from Driver_Master where Driver_id in " +
				"("+tempDriverStr+") and System_id=? and Client_id=?";
				pstmt=con.prepareStatement(query);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				rs = pstmt.executeQuery();
				while(rs.next())
				{
					driverId = rs.getInt("Driver_id");
					driverName = rs.getString("Fullname");
					storeDriverEvaluationDataPDO(driverId,driverName,0,0,0,0,0,0,0,0,0,0,0);
				}
			}

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			dms.releaseConnectionToDB(con,pstmt,rs);
		}
	}

	/** calculate monthly driver evaluation data */
	public void calculateMonthlyDriverScore(){
		DBConnection dms = new DBConnection();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con=dms.getConnectionToDB("AMS");

			ScoreSettings ss  = new ScoreSettings(systemId,settingId,con);

			String SELECT_DRIVER_EVALUATION_DATA = "select Driver_id,Fullname,sum(TotalDistance) as TotalDistance,"+
			"sum(DrivingHr) as DrivingHr,max(MaxSpeed) as MaxSpeed,sum(AcclCount) as AcclCount,"+
			"sum(TotalAccl) as TotalAccl,sum(DeclCount) as DeclCount,sum(TotalDecl) as TotalDecl,"+
			"sum(OverSpeedCount) as OverSpeedCount,sum(OverSpeedCountGraded) as OverSpeedCountGraded,sum(OverSpeedDistance) as OverSpeedDistance,"+
			"sum(StopTime) as StopTime,sum(IdleTime) as IdleTime,sum(SeatBeltCount) as SeatBeltCount,"+
			"sum(ACIdleCount) as ACIdleCount,substring(convert(varchar(10),EndDate,111),0,8) as EndYM, "+
			"sum(DistWithOutSeatBelt) as DistWithOutSeatBelt  from Driver_Master left outer join DriverEvaluation "+
			"on System_id = SystemId and Driver_id = DriverId "+
			"where Driver_id in "+driverIdStr+ " "+
			"and System_id=? and Client_id=? and "+
			"(EndDate between ? and ? or EndDate is null) "+
			"group by Driver_id,Fullname,substring(convert(varchar(10),EndDate,111),0,8)";

			//System.out.println("SELECT_DRIVER_EVALUATION_DATA : " + SELECT_DRIVER_EVALUATION_DATA);

			pstmt=con.prepareStatement(SELECT_DRIVER_EVALUATION_DATA);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, startDate);
			pstmt.setString(4, endDate);
			rs = pstmt.executeQuery();			
			while(rs.next()){
				int driverId = rs.getInt("Driver_id");
				String driverName = rs.getString("Fullname");
				double distanceDrived = rs.getDouble("TotalDistance");
				double drivingHr = rs.getDouble("DrivingHr");
				double acclCount = rs.getDouble("AcclCount");
				double declCount = rs.getDouble("DeclCount");
				double overspeedCount = rs.getDouble("OverSpeedCount");
				double overspeedCountgraded = rs.getDouble("OverSpeedCountGraded");
				double idleTime = rs.getDouble("IdleTime")*60;
				String endYearMonth = rs.getString("EndYM");
				double seatBelt = rs.getDouble("SeatBeltCount");
				double distWithOutSeatBelt = rs.getDouble("DistWithOutSeatBelt");
				double harshdrivecount =rs.getInt("AcclCount")+ rs.getInt("DeclCount");
				storeMonthlyDriverEvaluationData(ss,endYearMonth,driverId,driverName,distanceDrived,drivingHr,acclCount,declCount,overspeedCount,overspeedCountgraded,idleTime,seatBelt,distWithOutSeatBelt,harshdrivecount);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			dms.releaseConnectionToDB(con,pstmt,rs);
		}
	}




	public void storeDriverEvaluationData(ScoreSettings ss,int driverId,String driverName,double distanceDrived,double drivingHr,double acclCount,double declCount,double overspeedCount,double overspeedCountgraded,double idleTime,double seatBelt,
			double distWithOutSeatBelt,double harshdrivecount){
		DriverEvaluationDTO deDTO = null;
		/**settingsparam = 1:Distance Driven,2:Driving Hours,3:Overspeed,4:Idle Time,5:Over Accleration,6:Harsh Breaking*/

		try{

			deDTO = driverScore.get(driverId);
			if(deDTO == null){
				deDTO = new DriverEvaluationDTO();
				deDTO.setDriverName(driverName);
				deDTO.setDistanceDrived(distanceDrived);
				deDTO.setDistanceScore(ss.getScore(1, distanceDrived,distanceDrived));
				deDTO.setDrivingHr(drivingHr);
				deDTO.setDrivingHrScore(ss.getScore(2, drivingHr,distanceDrived));
				deDTO.setOverspeedCount(getPerHundradeKm(overspeedCount,distanceDrived));
				deDTO.setOverspeedCountScore(ss.getScore(3, getPerHundradeKm(overspeedCount,distanceDrived),distanceDrived));
				deDTO.setOverspeedCountGraded(getPerHundradeKm(overspeedCountgraded,distanceDrived));
				deDTO.setOverspeedCountGradedScore(ss.getScore(3, getPerHundradeKm(overspeedCountgraded,distanceDrived),distanceDrived));
				deDTO.setIdleTime(getPerHundradeKm(idleTime*60,distanceDrived));
				deDTO.setIdleTimeScore(ss.getScore(4, getPerHundradeKm(idleTime*60,distanceDrived),distanceDrived));
				deDTO.setAcclCount(getPerHundradeKm(acclCount,distanceDrived));
				deDTO.setAcclCountScore(ss.getScore(5, getPerHundradeKm(acclCount,distanceDrived),distanceDrived));	
				deDTO.setDeclCount(getPerHundradeKm(declCount,distanceDrived));
				deDTO.setDeclCountScore(ss.getScore(6, getPerHundradeKm(declCount,distanceDrived),distanceDrived));	
				deDTO.setSeatBelt(getPerHundradeKm(seatBelt,distanceDrived));
				deDTO.setSeatBeltScore(ss.getScore(7, getPerHundradeKm(seatBelt,distanceDrived),distanceDrived));
				deDTO.setDistWithOutSeatBelt(getPerHundradeKm(distWithOutSeatBelt,distanceDrived));
				deDTO.setDistWithOutSeatBeltScore(ss.getScore(7, getPerHundradeKm(distWithOutSeatBelt,distanceDrived),distanceDrived));

				//deDTO.setHarshdrivecount(getPerHundradeKm(harshdrivecount,distanceDrived));commented as per discussion on 09/02/2013
				//deDTO.setHarshdrivecountscore(ss.getScore(8, getPerHundradeKm(harshdrivecount,distanceDrived)));

				int div=9;
				if( deDTO.getDistanceScore()==0 ){
					div=div-1;
				}	if( deDTO.getDrivingHrScore()==0 ){
					div=div-1;
				}	if( deDTO.getOverspeedCountScore()==0 ){
					div=div-1;
				}	if( deDTO.getIdleTimeScore()==0 ){
					div=div-1;
				}	if( deDTO.getAcclCountScore()==0 ){
					div=div-1;
				}	if( deDTO.getDeclCountScore()==0){
					div=div-1;
				}	if( deDTO.getSeatBeltScore()==0 ){
					div=div-1;
				}
				if(deDTO.getOverspeedCountGradedScore()==0 ){
					div=div-1;
				}
				if(deDTO.getDistWithOutSeatBeltScore()==0  ){
					div=div-1;
				}
				//if( deDTO.getHarshdrivecountscore()==0){commented as per discussion on 09/02/2013
				//div=div-1;
				//}

				double totalScore = deDTO.getDistanceScore() + deDTO.getDrivingHrScore() + deDTO.getOverspeedCountScore()+deDTO.getOverspeedCountGradedScore()
				+ deDTO.getIdleTimeScore() + deDTO.getAcclCountScore() + deDTO.getDeclCountScore() + deDTO.getSeatBeltScore();//+ deDTO.getHarshdrivecountscore();commented as per discussion on 09/02/2013

				if(div!=0){
					deDTO.setTotalScore((totalScore/div));
				}else{
					deDTO.setTotalScore(totalScore);
				}
				driverScore.put(driverId, deDTO);
			}else{

				deDTO.setDistanceDrived(distanceDrived+deDTO.getDistanceDrived());
				deDTO.setDistanceScore(ss.getScore(1, distanceDrived,distanceDrived) + deDTO.getDistanceScore());
				deDTO.setDrivingHr(drivingHr + deDTO.getDrivingHr());
				deDTO.setDrivingHrScore(ss.getScore(2, drivingHr,distanceDrived) + deDTO.getDrivingHrScore());
				deDTO.setOverspeedCount(getPerHundradeKm(overspeedCount,distanceDrived) + deDTO.getOverspeedCount());
				deDTO.setOverspeedCountScore(ss.getScore(3, getPerHundradeKm(overspeedCount,distanceDrived),distanceDrived) + deDTO.getOverspeedCountScore());
				deDTO.setOverspeedCountGraded(getPerHundradeKm(overspeedCountgraded,distanceDrived) + deDTO.getOverspeedCountGraded());
				deDTO.setOverspeedCountGradedScore(ss.getScore(3, getPerHundradeKm(overspeedCountgraded,distanceDrived),distanceDrived) + deDTO.getOverspeedCountGradedScore());
				deDTO.setIdleTime(getPerHundradeKm(idleTime*60,distanceDrived) + deDTO.getIdleTime());
				deDTO.setIdleTimeScore(ss.getScore(4, getPerHundradeKm(idleTime*60,distanceDrived),distanceDrived) + deDTO.getIdleTimeScore());
				deDTO.setAcclCount(getPerHundradeKm(acclCount,distanceDrived) + deDTO.getAcclCount());
				deDTO.setAcclCountScore(ss.getScore(5, getPerHundradeKm(acclCount,distanceDrived),distanceDrived) + deDTO.getAcclCountScore());
				deDTO.setDeclCount(getPerHundradeKm(declCount,distanceDrived) + deDTO.getDeclCount());
				deDTO.setDeclCountScore(ss.getScore(6, getPerHundradeKm(declCount,distanceDrived),distanceDrived) + deDTO.getDeclCountScore());
				deDTO.setSeatBelt(getPerHundradeKm(seatBelt,distanceDrived)+deDTO.getSeatBelt());
				deDTO.setSeatBeltScore(ss.getScore(7, getPerHundradeKm(seatBelt,distanceDrived),distanceDrived)+deDTO.getSeatBeltScore());
				deDTO.setDistWithOutSeatBelt(getPerHundradeKm(distWithOutSeatBelt,distanceDrived)+deDTO.getDistWithOutSeatBelt());
				deDTO.setDistWithOutSeatBeltScore(ss.getScore(7, getPerHundradeKm(distWithOutSeatBelt,distanceDrived),distanceDrived)+deDTO.getDistWithOutSeatBeltScore());

				//deDTO.setHarshdrivecount(getPerHundradeKm(harshdrivecount,distanceDrived)+ deDTO.getHarshdrivecount());commented as per discussion on 09/02/2013
				//deDTO.setHarshdrivecountscore(ss.getScore(8, getPerHundradeKm(harshdrivecount,distanceDrived))+ deDTO.getHarshdrivecountscore());

				int div=9;
				if( deDTO.getDistanceScore()==0 ){
					div=div-1;
				}	if( deDTO.getDrivingHrScore()==0 ){
					div=div-1;
				}	if( deDTO.getOverspeedCountScore()==0  ){
					div=div-1;
				}	if( deDTO.getIdleTimeScore()==0 ){
					div=div-1;
				}	if( deDTO.getAcclCountScore()==0 ){
					div=div-1;
				}	if( deDTO.getDeclCountScore()==0 ){
					div=div-1;
				}	if( deDTO.getSeatBeltScore()==0 ){
					div=div-1;
				}
				if( deDTO.getOverspeedCountGradedScore()==0 ){
					div=div-1;
				}if(deDTO.getDistWithOutSeatBeltScore()==0){
					div=div-1;
				}
				//				if( deDTO.getHarshdrivecountscore()==0){commented as per discussion on 09/02/2013
				//					div=div-1;
				//				}
				double totalScore = deDTO.getDistanceScore() + deDTO.getDrivingHrScore() + deDTO.getOverspeedCountScore()+deDTO.getOverspeedCountGradedScore()
				+ deDTO.getIdleTimeScore() + deDTO.getAcclCountScore() + deDTO.getDeclCountScore() + deDTO.getSeatBeltScore();//+ deDTO.getHarshdrivecountscore();commented as per discussion on 09/02/2013
				if(div!=0){
					deDTO.setTotalScore(totalScore/div);
				}else{
					deDTO.setTotalScore(totalScore);
				}
				driverScore.put(driverId, deDTO);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	/**
	 * By Gouse For calculating overspeed duration on blacktop and graded roads PDO REPORT
	 * @param driverId
	 * @param driverName
	 * @param distanceDriven
	 * @param Overspeeddurationgraded
	 * @param Overspeeddurationblacktop
	 * @param totalosduration
	 * @param overspeedscore
	 * @param harshacccount
	 * @param harshcountscore
	 * @param harshbrecount
	 * @param harshbrecountscore
	 * @param totalscore
	 */
	public void storeDriverEvaluationDataPDO(int driverId,String driverName,double distanceDriven,double Overspeeddurationgraded,double Overspeeddurationblacktop,double totalosduration,double overspeedscorenew,double harshacccount,double harshcountscore,double harshbrecount,double harshbrecountscore,double totalscore,double maxSpeed){

		DriverEvaluationDTO deDTO = null;
		try{
			deDTO = driverScore.get(driverId);
			if(deDTO == null){
				deDTO = new DriverEvaluationDTO();

				deDTO.setDriverName(driverName);
				deDTO.setDistanceDrived(distanceDriven);
				deDTO.setOverspeeddurationgraded(Overspeeddurationgraded);
				deDTO.setOverspeeddurationblacktop(Overspeeddurationblacktop);
				deDTO.setOverspeedCount(totalosduration);
				deDTO.setOverspeedCountScore(overspeedscorenew);
				deDTO.setAcclCount(harshacccount);
				deDTO.setAcclCountScore(harshcountscore);
				deDTO.setDeclCount(harshbrecount);
				deDTO.setDeclCountScore(harshbrecountscore);
				deDTO.setTotalScore(totalscore);
				deDTO.setMaxSpeed(maxSpeed);
				driverScore.put(driverId, deDTO);
			}else{

				deDTO.setDistanceDrived(distanceDriven + deDTO.getDistanceDrived());
				deDTO.setOverspeeddurationgraded(Overspeeddurationgraded + deDTO.getOverspeeddurationgraded());
				deDTO.setOverspeeddurationblacktop(Overspeeddurationblacktop + deDTO.getOverspeeddurationblacktop());
				deDTO.setOverspeedCount(totalosduration + deDTO.getOverspeedCount());
				deDTO.setOverspeedCountScore(overspeedscorenew +deDTO.getOverspeedCountScore());
				deDTO.setAcclCount(harshacccount+deDTO.getAcclCount());
				deDTO.setAcclCountScore(harshcountscore+deDTO.getAcclCountScore());
				deDTO.setDeclCount(harshbrecount+deDTO.getDeclCount());
				deDTO.setDeclCountScore(harshbrecountscore+deDTO.getDeclCountScore());
				deDTO.setTotalScore(totalscore+deDTO.getTotalScore());
				deDTO.setMaxSpeed(maxSpeed+deDTO.getMaxSpeed());
				driverScore.put(driverId, deDTO);
			}
		}   catch(Exception e){
			e.printStackTrace();
		}
	}
	/**.................................................................*/
	public void storeMonthlyDriverEvaluationData(ScoreSettings ss,String endYearMonth,int driverId,String driverName,double distanceDrived,double drivingHr,double acclCount,double declCount,double overspeedCount,double overspeedCountgraded,double idleTime,double seatBelt,double distWithOutSeatBelt,double harshdrivecount){
		String driverScore[] = new String[14];
	
		/**settingsparam = 1:Distance Driven,2:Driving Hours,3:Overspeed,4:Idle Time,5:Over Accleration,6:Harsh Breaking*/
		try{
           
			int month = 0;
			if(endYearMonth != null){
				month = Integer.parseInt(endYearMonth.substring(endYearMonth.indexOf("/")+1,endYearMonth.length()));
			}
			//System.out.println("month : " + month);

			double existingTotalScore = 0.0;
			driverScore = monthlyDriverScore.get(driverId);
			if(driverScore == null){
				driverScore = new String[14];
				driverScore[0] = driverName;
			}else{
				existingTotalScore = Double.parseDouble(driverScore[13]);
			}
			int div=9;
			if(month != 0){
				
				if(ss.getScore(1, distanceDrived,distanceDrived)==0){
					div=div-1;
				}
				if(ss.getScore(2, drivingHr,distanceDrived)==0){
					div=div-1;
				}
				if(ss.getScore(3, getPerHundradeKm(overspeedCount,distanceDrived),distanceDrived)==0){
					div=div-1;
				}
				if(ss.getScore(4, getPerHundradeKm(idleTime,distanceDrived),distanceDrived)==0){
					div=div-1;
				}
				if(ss.getScore(5, getPerHundradeKm(acclCount,distanceDrived),distanceDrived)==0){
					div=div-1;
				}
				if(	ss.getScore(6, getPerHundradeKm(declCount,distanceDrived),distanceDrived)==0){
					div=div-1;
				}
				if(ss.getScore(7, getPerHundradeKm(seatBelt,distanceDrived),distanceDrived)==0){
					div=div-1;
				}
				if(ss.getScore(7, getPerHundradeKm(distWithOutSeatBelt,distanceDrived),distanceDrived)==0){
					div=div-1;
				}
				if(ss.getScore(3, getPerHundradeKm(overspeedCountgraded,distanceDrived),distanceDrived)==0){
					div=div-1;
				}
				//				if(ss.getScore(8, getPerHundradeKm(harshdrivecount,distanceDrived))==0){
				//					div=div-1;
				//				}commented as per discussion on 09/02/2013
				double score = ss.getScore(1, distanceDrived,distanceDrived) + 
				ss.getScore(2, drivingHr,distanceDrived) + 
				ss.getScore(3, getPerHundradeKm(overspeedCount,distanceDrived),distanceDrived) + ss.getScore(3, getPerHundradeKm(overspeedCountgraded,distanceDrived),distanceDrived)+
				ss.getScore(4, getPerHundradeKm(idleTime,distanceDrived),distanceDrived) +
				ss.getScore(5, getPerHundradeKm(acclCount,distanceDrived),distanceDrived) + 
				ss.getScore(6, getPerHundradeKm(declCount,distanceDrived),distanceDrived) + ss.getScore(7, getPerHundradeKm(seatBelt,distanceDrived),distanceDrived)+
				ss.getScore(7, getPerHundradeKm(distWithOutSeatBelt,distanceDrived),distanceDrived);//+
				//ss.getScore(8, getPerHundradeKm(harshdrivecount,distanceDrived));commented as per discussion on 09/02/2013

				/** score of this month */
				if(div!=0){
					driverScore[month] = String.valueOf(score/div); 
					driverScore[13] = String.valueOf(existingTotalScore + score/div);
				}else{
					driverScore[month]=String.valueOf(score); 
					driverScore[13] = String.valueOf(existingTotalScore + score);
				}

				/** total score */

			}

			monthlyDriverScore.put(driverId, driverScore);

		}catch(Exception e){
			e.printStackTrace();
		}
	}

	public double getPerHundradeKm(double count,double distanceDrived){
		if(distanceDrived > 0){
			return (count * 100) / distanceDrived;
		}else {
			return 0;
		}
	}
}


