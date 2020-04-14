package t4u.functions;
import java.io.File;
import java.io.IOException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class ExtractKML {

	public static JSONArray globalJsonArray=null;
    
	/*
	 * This class will extract Coordinates from the KML file
	 */
	public static void extractKML(String path)throws IOException,SAXException,ParserConfigurationException,JSONException
	{
		DocumentBuilderFactory dbFactory=DocumentBuilderFactory.newInstance();
		DocumentBuilder dBuilder=dbFactory.newDocumentBuilder();
		Document doc=dBuilder.parse(new File(path));
		
		NodeList placeMark=doc.getElementsByTagName("Polygon");
		NodeList linear=null;
		String data=null;
		
	    linear=((Element)placeMark.item(0)).getElementsByTagName("coordinates");
		Node node=linear.item(0);
		data=node.getTextContent().trim();
		
		
		/*System.out.println(data.matches(".*,.*$"));
		data=data.replace(".*,.*$","jh");*/
		//System.out.println(data);
		String[] finalArray=data.split(",");
		
		for(int i=0;i<finalArray.length-1;i++)
		{
			if(i%2==0)
			{
				if(finalArray[i].contains(" "))
					if(finalArray[i].matches(".*\\n.*"))
						finalArray[i]=finalArray[i].split("\\n")[1].trim();
					else
						finalArray[i]=finalArray[i].split("\\s")[1];
			}
		}
		
		File f=new File(path);
		f.delete();
		
		globalJsonArray=new JSONArray();
		int i=0;
		while(i<finalArray.length-1)
		{
			JSONObject temp=new JSONObject();
			temp.put("Latitude",finalArray[i+1]);
			temp.put("Longitude",finalArray[i]);
			globalJsonArray.put(temp);
			i=i+2;
		}
	}
}
