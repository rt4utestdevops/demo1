package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.StringTokenizer;

import t4u.statements.DemoCarStatements;
import t4u.statements.DriverMatrixSQLStatements;



public class ScoreSettings {
	HashMap<String,Double> distanceDrivedMap = new HashMap<String,Double>();
	HashMap<String,Double> drivedHrsMap = new HashMap<String,Double>();
	HashMap<String,Double> overspeedMap = new HashMap<String,Double>();
	HashMap<String,Double> idleTimeMap = new HashMap<String,Double>();
	HashMap<String,Double> acclCountMap = new HashMap<String,Double>();
	HashMap<String,Double> declCountMap = new HashMap<String,Double>();
	HashMap<String,Double> seatBeltMap = new HashMap<String,Double>();

	HashMap<Integer,Double> weightPara = new HashMap<Integer,Double>();
	HashMap<String,Double> HarshdrivecountMap = new HashMap<String,Double>();

	int systemId; 
	int settingId;
	Connection con;
	int clientId;
	public ScoreSettings(int systemId,int settingId,Connection con){
		this.systemId = systemId;
		this.settingId = settingId;
		this.con = con;
		setScoreParameters();
		setWeightParameters();
	}
	public ScoreSettings(int systemId,int settingId,Connection con,int clientId){
		this.systemId = systemId;
		this.settingId = settingId;
		this.con = con;
		this.clientId = clientId;
		setScoreParameters1();
		setWeightParameters1();
	}
	/*..............processing....................*/
	public void setScoreParameters(){
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			pstmt = con.prepareStatement(DriverMatrixSQLStatements.SELECT_LTSP_DRIVER_SETTINGS_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, settingId);
			rs = pstmt.executeQuery();			
			while(rs.next()){
				int paraId = rs.getInt("setting_param_id");
				String scoreRange = rs.getString("score_range");
				double score = rs.getDouble("score");
				/**settingsparam = 1:Distance Driven,2:Driving Hours,3:Overspeed,4:Idle Time,5:Over Accleration,6:Harsh Breaking*/
				if(paraId == 1){
					distanceDrivedMap.put(scoreRange, score);
				}else if(paraId == 2){
					drivedHrsMap.put(scoreRange, score);
				}else if(paraId == 3){
					overspeedMap.put(scoreRange, score);
				}else if(paraId == 4){
					idleTimeMap.put(scoreRange, score);
				}else if(paraId == 5){
					acclCountMap.put(scoreRange, score);
				}else if(paraId == 6){
					declCountMap.put(scoreRange, score);
				}else if(paraId == 7){
					seatBeltMap.put(scoreRange, score);
				}else if(paraId == 8){
					HarshdrivecountMap.put(scoreRange, score);
				}
				//System.out.println("setScoreParameters() scoreRange : " + scoreRange + " score : " + score);
			}
		}catch(Exception e){

		}finally{

		}
	}
	/* set weight parameters */
	public void setWeightParameters(){
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			pstmt = con.prepareStatement(DriverMatrixSQLStatements.GET_WEIGHT_PARAREMTERS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, settingId);
			rs = pstmt.executeQuery();			
			while(rs.next()){
				weightPara.put(rs.getInt("setting_param_id"), rs.getDouble("weight")/100);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	/* get the score by passing the score parameter id and the value of that parameter */
	public double getScore(int paraId,double value,double distanceDrived){


		double score = 0;
		HashMap scoreMap = new HashMap();

		//		if(value == 0.0){
		//			return score;commented as per discussion on 09/02/2013
		//		}

		///***** below condition will check wheather driver distance travelled or not if yes it will give score otherwise it will return zero*****///

		if(paraId != 1 && paraId != 2  && distanceDrived==0){

			return score;
		}
		else if(paraId == 1){
			scoreMap = distanceDrivedMap;
		}else if(paraId == 2){
			scoreMap = drivedHrsMap;
		}else if(paraId == 3){
			scoreMap = overspeedMap;
		}else if(paraId == 4){
			scoreMap = idleTimeMap;
		}else if(paraId == 5){
			scoreMap = acclCountMap;
		}else if(paraId == 6){
			scoreMap = declCountMap;
		}else if(paraId == 7){
			scoreMap = seatBeltMap;
		}else if(paraId == 8){
			scoreMap = HarshdrivecountMap;
		}
		Set set = scoreMap.entrySet();
		Iterator it = set.iterator();
		while(it.hasNext()){
			Map.Entry me = (Map.Entry)it.next();
			String scoreRange = (String)me.getKey();
			boolean inRange = isValueInScoreRange(scoreRange,value);
			if(inRange == true){
				score = Double.parseDouble(me.getValue().toString());
				double weight = weightPara.get(paraId);


				if(weight > 1){
					score = score * weight;
				}
				break;
			}
		}
		return score;
	}

	public boolean isValueInScoreRange(String scoreRange,double value){
		boolean inRange = false;
		if(scoreRange.contains("-")){
			StringTokenizer st = new StringTokenizer(scoreRange,"-");
			double range[] = new double[2];
			int k = 0;
			while(st.hasMoreElements()){
				range[k++] = Double.parseDouble(st.nextElement().toString());
			}
			if(value >= range[0] && value <= range[1]){
				inRange = true;
			}
		}else if(scoreRange.contains("<")){ //x<20
			double range = Double.parseDouble(scoreRange.replace("<",""));
			if(value < range){
				inRange = true;
			}
		}else if(scoreRange.contains(">")){//x>10
			double range = Double.parseDouble(scoreRange.replace(">",""));
			if(value > range){
				inRange = true;
			}
		}
		return inRange;
	}

public void setScoreParameters1(){
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	try{
		pstmt = con.prepareStatement(DemoCarStatements.SELECT_LTSP_DRIVER_SETTINGS_DETAILS);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, settingId);
		rs = pstmt.executeQuery();			
		while(rs.next()){
			int paraId = rs.getInt("setting_param_id");
			String scoreRange = rs.getString("score_range");
			double score = rs.getDouble("score");
			/**settingsparam = 1:Distance Driven,2:Driving Hours,3:Overspeed,4:Idle Time,5:Over Accleration,6:Harsh Breaking*/
			if(paraId == 1){
				distanceDrivedMap.put(scoreRange, score);
			}else if(paraId == 2){
				drivedHrsMap.put(scoreRange, score);
			}else if(paraId == 3){
				overspeedMap.put(scoreRange, score);
			}else if(paraId == 4){
				idleTimeMap.put(scoreRange, score);
			}else if(paraId == 5){
				acclCountMap.put(scoreRange, score);
			}else if(paraId == 6){
				declCountMap.put(scoreRange, score);
			}else if(paraId == 7){
				seatBeltMap.put(scoreRange, score);
			}else if(paraId == 8){
				HarshdrivecountMap.put(scoreRange, score);
			}
			//System.out.println("setScoreParameters() scoreRange : " + scoreRange + " score : " + score);
		}
	}catch(Exception e){

	}finally{

	}
}
/* set weight parameters */
public void setWeightParameters1(){
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	try{
		pstmt = con.prepareStatement(DemoCarStatements.GET_WEIGHT_PARAREMTERS);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, settingId);
		rs = pstmt.executeQuery();			
		while(rs.next()){
			weightPara.put(rs.getInt("setting_param_id"), rs.getDouble("weight")/100);
		}
	}catch(Exception e){
		e.printStackTrace();
	}
}
/* get the score by passing the score parameter id and the value of that parameter */
public double getScore1(int paraId,double value,double distanceDrived){


	double score = 0;
	HashMap scoreMap = new HashMap();

	//		if(value == 0.0){
	//			return score;commented as per discussion on 09/02/2013
	//		}

	///***** below condition will check wheather driver distance travelled or not if yes it will give score otherwise it will return zero*****///

	if(paraId != 1 && paraId != 2  && distanceDrived==0){

		return score;
	}
	else if(paraId == 1){
		scoreMap = distanceDrivedMap;
	}else if(paraId == 2){
		scoreMap = drivedHrsMap;
	}else if(paraId == 3){
		scoreMap = overspeedMap;
	}else if(paraId == 4){
		scoreMap = idleTimeMap;
	}else if(paraId == 5){
		scoreMap = acclCountMap;
	}else if(paraId == 6){
		scoreMap = declCountMap;
	}else if(paraId == 7){
		scoreMap = seatBeltMap;
	}else if(paraId == 8){
		scoreMap = HarshdrivecountMap;
	}
	Set set = scoreMap.entrySet();
	Iterator it = set.iterator();
	while(it.hasNext()){
		Map.Entry me = (Map.Entry)it.next();
		String scoreRange = (String)me.getKey();
		boolean inRange = isValueInScoreRange1(scoreRange,value);
		if(inRange == true){
			score = Double.parseDouble(me.getValue().toString());
			double weight = weightPara.get(paraId);


			if(weight > 1){
				score = score * weight;
			}
			break;
		}
	}
	return score;
}

public boolean isValueInScoreRange1(String scoreRange,double value){
	boolean inRange = false;
	if(scoreRange.contains("-")){
		StringTokenizer st = new StringTokenizer(scoreRange,"-");
		double range[] = new double[2];
		int k = 0;
		while(st.hasMoreElements()){
			range[k++] = Double.parseDouble(st.nextElement().toString());
		}
		if(value >= range[0] && value <= range[1]){
			inRange = true;
		}
	}else if(scoreRange.contains("<")){ //x<20
		double range = Double.parseDouble(scoreRange.replace("<",""));
		if(value < range){
			inRange = true;
		}
	}else if(scoreRange.contains(">")){//x>10
		double range = Double.parseDouble(scoreRange.replace(">",""));
		if(value > range){
			inRange = true;
		}
	}
	return inRange;
}
}
