package t4u.util;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import t4u.common.ApplicationListener;

import com.mongodb.BasicDBList;
import com.mongodb.BasicDBObject;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.MongoClient;

public class TemperatureConfiguration {

	public static List<TemperatureConfigurationBean> getTemperatureConfigurationDetails(int systemId, int customerId, String registrationNo) {
		MongoClient mongo = null;
		List<TemperatureConfigurationBean> tempConfigDetails = null;
		try {
			mongo = getMongoConnection();
			DBCollection collection = mongo.getDB("temperature_module").getCollection( "configuration_details");
			tempConfigDetails = selectAllRecordByInput(collection, systemId, customerId, registrationNo);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			mongo.close();
		}
		return tempConfigDetails;
	}

	public static MongoClient getMongoConnection() throws FileNotFoundException, IOException {
		Properties properties = ApplicationListener.prop;
		String url = properties.getProperty("mongoconnectionurl");
		final MongoClient mongo = new MongoClient(url, 27017);
		return mongo;

	}

	private static List<TemperatureConfigurationBean> selectAllRecordByInput(DBCollection collection, int systemId, int customerId, String registrationNo) {
		BasicDBObject andQuery = new BasicDBObject();
		List<TemperatureConfigurationBean> tempConfigDetails = new ArrayList<TemperatureConfigurationBean>();
		List<BasicDBObject> obj = new ArrayList<BasicDBObject>();
		obj.add(new BasicDBObject("systemId", systemId));
		obj.add(new BasicDBObject("customerId", customerId));
		obj.add(new BasicDBObject("registrationNo", registrationNo));
		andQuery.put("$and", obj);

		DBCursor cursor = collection.find(andQuery);
		if (cursor.hasNext()) {
			DBObject theObj = cursor.next();
			BasicDBList tempList = (BasicDBList) theObj.get("temperatureConfiguration");
			if(tempList!=null){
				for (int i = 0; i < tempList.size(); i++) {
					BasicDBObject tempObj = (BasicDBObject) tempList.get(i);
					tempConfigDetails.add(new TemperatureConfigurationBean(tempObj .getString("registrationNo"), systemId, customerId,
							tempObj.getString("minPositiveTemp"), tempObj .getString("minNegativeTemp"), tempObj .getString("maxPositiveTemp"), tempObj .getString("maxNegativeTemp"), tempObj
									.getString("sensorName"), tempObj .getString("name")));
				}
			}else{
				tempConfigDetails=new ArrayList<TemperatureConfigurationBean>();
			}
		}
		return tempConfigDetails;
	}

}
