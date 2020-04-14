package t4u.sandmining;

import java.awt.Color;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import t4u.beans.EnglishNumberToWords;
import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.functions.SandMiningPermitFunctions;

import com.lowagie.text.Document;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;


public class Sand_Mining_ILMS_PDF_For_MDP extends HttpServlet{


    
    static BaseFont baseFont = null;
    SandMiningPermitFunctions smpf = new SandMiningPermitFunctions();
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{	try
	{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		SimpleDateFormat sdfFormatDatedd = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        
		int offset=330;
		HttpSession session = request.getSession();
		if (session.getAttribute("loginInfoDetails")!=null) {
			LoginInfoBean loginInfoBean = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			offset=loginInfoBean.getOffsetMinutes();
		}
		if(session.getAttribute("valid").toString() == "true")
		{
			String uids = request.getParameter("uids");
			String systemid = request.getParameter("systemId");
			String ts = request.getParameter("ts");
			String clientId = request.getParameter("clientId");
			uids=uids.substring(1);
			//System.out.println("#####################################"+systemid);
			ArrayList printList=smpf.getPrintListForMDP(uids,offset);
			//System.out.println("list=="+printList.toString());
	
			SimpleDateFormat simpleDateFormatddMMYY = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
			Calendar calendar = Calendar.getInstance();		
			Date TodayDate = calendar.getTime();
			String date=simpleDateFormatddMMYY.format(TodayDate);
			date= date.replaceAll("/", "");
			date=date.replaceAll(":", "");
			date=date.replaceAll(" ", "_");
	
			ServletOutputStream servletOutputStream = response.getOutputStream();
			Properties properties = ApplicationListener.prop;
			String billpath=  properties.getProperty("Builtypath");
			refreshdir(billpath);
			String formno="Trip_Sheet_Print_"+systemid+"_"+date;
			String fontPath = properties.getProperty("FontPathForMaplePDF");
			baseFont = BaseFont.createFont(fontPath, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
			String bill = billpath+ formno + ".pdf";
	
			generateBill(bill,systemid,request,printList, clientId);
			printBill(servletOutputStream,response,bill,formno);
		}
		//		}
	}
	catch (Exception e) 
	{
		System.out.println("Error generating sms bill : " + e);
		e.printStackTrace();
	}
	}



	private void generateBill(String bill,  String systemid, HttpServletRequest request, ArrayList printList, String clientId ) {		
		try
		{	
			
			FileOutputStream fileOut = new FileOutputStream(bill);
			Document document = new Document(PageSize.A4.rotate(), 40, 40, 30, 20);
			PdfWriter writer = PdfWriter.getInstance(document,fileOut);
			document.open();
			String currency=smpf.getCurrency(Integer.parseInt(systemid));
			//System.out.println("printList "+printList.toString());
			for (int i = 0; i < printList.size(); i++) {
				ArrayList list=(ArrayList) printList.get(i);
				String tSNO=list.get(0).toString();
				String dATE=list.get(1).toString();
				dATE=dATE.substring(0, 10);
				String pERMITNO=list.get(2).toString();
				String oWNERNAME=list.get(4).toString();
				String tYPE=list.get(5).toString();
				String mINERAL=list.get(6).toString();
				String sURVEYNO=list.get(7).toString();
				String vILLAGE=list.get(8).toString();
				String tALUK=list.get(9).toString();
				String qUANTITY=list.get(10).toString();
				String rOYALTY=currency+" "+list.get(11).toString();
				String vEHICLENO=list.get(14).toString();
				String fROMPLACE=list.get(16).toString();
				String tOPLACE=list.get(17).toString();
				String fromDate=list.get(15).toString();
				String toDate=list.get(18).toString();
				String miNo="";//list.get(3).toString();
				String pROCESSING=currency+" "+list.get(12).toString();
				String printed="";
				String totalFee=currency+" "+list.get(13).toString();
				String district=list.get(19).toString();
				String vehAddr=list.get(20).toString();
				String PortNO=list.get(21).toString();
				String validityPeriod=list.get(22).toString();
				String LoadingType=list.get(23).toString();
				String DDNo=list.get(24).toString();
				String DDDAte1=list.get(25).toString();
				String BankName=list.get(26).toString();
				String Index_No=list.get(27).toString();
				String Driver_Name=list.get(28).toString();
				String TS_ID=list.get(29).toString();
				String Via_Route=list.get(30).toString();
				String totalforwords=list.get(13).toString().replace(".000", "");
				String sandFromTime=list.get(31).toString();//"06:00:00 AM";
				String sandToTime=list.get(32).toString();//"06:00:00 PM";
				String customerName = list.get(33).toString();//Customer_Name
				String distance = list.get(34).toString();
				String DDDAte="";
				if (DDDAte1 != null && !DDDAte1.equals("") && !DDDAte1.contains("1900")) {
					DDDAte = DDDAte1;
				} else {
					DDDAte = "";
				}
				String contactNumber = list.get(35).toString();
				String ClientMobileNo = list.get(36).toString();
				String loadWeight =list.get(37).toString();
				String unloadWeight=list.get(38).toString();
				
				float netWeight=0;
				netWeight=Float.parseFloat(loadWeight) - Float.parseFloat(unloadWeight);
				if(netWeight <=0 ){
					netWeight = 0;
				}
// =======================================================================================================				
				ArrayList otherDetails=smpf.getotherDetails(vEHICLENO,systemid,TS_ID);
				String VehicleId=otherDetails.get(0).toString();
				if(otherDetails.size()>1)
				{String vehicleTSCount=otherDetails.get(1).toString();}
				// =======================================================================================================				

				String headingString1 = "GOVERNMENT OF KARNATAKA";
				String headingString2 = "T4U SERVICES";
				//String headingString3="Bangalore, Karnataka";
				headingString2 = "GPS Reference Copy";
				

				//headingString3 = "	"+smpf.getCity(systemid, clientId);

				//empty space
				PdfPTable headerTable45 =createBilldata24();
				document.add(headerTable45);
				
				//Top note
				PdfPTable headerTableTop = createBilldata();
				document.add(headerTableTop);

				// For heading
				//PdfPTable headerTable = createBillhead("",headingString1);
				//document.add(headerTable);
				PdfPTable headerTable1 = createBillhead1("",headingString2);
				document.add(headerTable1);
				//PdfPTable headerTable2 = createBillhead2("",headingString3);
				//document.add(headerTable2);

				//empty space
				document.add(headerTable45);

				//For date and TS No
				PdfPTable headerTable3 = newforMDP(tSNO,dATE);
				document.add(headerTable3);
				PdfPTable headerTable251 = createBillheader1();
				document.add(headerTable251);


				document.add(headerTable45);


				// VEHICLE no
				PdfPTable headerTable5 = createBilldata1(vEHICLENO);
				document.add(headerTable5);

				PdfPTable headerTable6 = createBillheader2();
				document.add(headerTable6);

				document.add(headerTable45);
				
				if(Float.parseFloat(loadWeight)!=0 || Float.parseFloat(unloadWeight)!=0)
				{
				//load & unload weight
				PdfPTable headerTable212 = LoadUnloadWeight(unloadWeight,loadWeight);
				document.add(headerTable212);

				PdfPTable headerTable222 = createBillheader1();
				document.add(headerTable222);
				
				document.add(headerTable45);
               
				PdfPTable headerTable242 = createBillheader3();
				
				//net weight
				PdfPTable headerTable8 = netWeight(netWeight);
				document.add(headerTable8);

				PdfPTable headerTable9 = createBillheader2();
				document.add(headerTable9);

				document.add(headerTable45);
				}
				//ILMS Trip Sheet No.
				PdfPTable headerTableVEHICLETYPE = createBilldataVEHICLETYPE(pERMITNO);
				document.add(headerTableVEHICLETYPE);

				PdfPTable headerTableVEHICLETYPE1 = createBillheader2();
				document.add(headerTableVEHICLETYPE1);

				document.add(headerTable45);
				
				//CONTACT No
				PdfPTable headerTableCONTACTNO = createContactNoBilldata(ClientMobileNo);
				document.add(headerTableCONTACTNO);
				
				PdfPTable headerTableCONTACTNO1 = createBillheader2();
				document.add(headerTableCONTACTNO1);
				
				document.add(headerTable45);
				
				//CUSTOMER NAME & ADDRESS
				PdfPTable headerTableCUSTOMERNAMEADDRESS = createCustomerNameAddressBilldata(customerName);
				document.add(headerTableCUSTOMERNAMEADDRESS);

				PdfPTable headerTableCUSTOMERNAMEADDRESS1 = createBillheader2();
				document.add(headerTableCUSTOMERNAMEADDRESS1);
				
				document.add(headerTable45);
				
				
				//From & to date
				/*PdfPTable headerTable25 = ValidFromTo(fromDate,toDate);
				document.add(headerTable25);

				document.add(headerTable251);*/
				
				
				PdfPTable headerTableFromDate = FromDate(fromDate);
				document.add(headerTableFromDate);
                PdfPTable headerTableFrom = createBillheader2();
				document.add(headerTableFrom);
				
				document.add(headerTable45);
				
				PdfPTable headerTableToDate = ToDate(toDate);
				document.add(headerTableToDate);
				PdfPTable headerTableTo = createBillheader2();
				document.add(headerTableTo);

				document.add(headerTable45);

				PdfPTable headerTable60 = createBilldata35(distance);
				document.add(headerTable60);

				PdfPTable headerTable70 = createBillheader2();
				document.add(headerTable70);


				document.add(headerTable45);


				//From & to
				PdfPTable headerTable211 = PlaceFromTo(fROMPLACE,tOPLACE);
				document.add(headerTable211);

				PdfPTable headerTable221 = createBillheader1();
				document.add(headerTable221);
				
				document.add(headerTable45);
                

				PdfPTable headerTable24 = createBillheader3();
				
				
				//INSPECTED BY:SIGN & SEAL
				PdfPTable headerTableINSPECTEDBY = createBilldataCOMMON("INSPECTED BY:SIGN & SEAL");
				document.add(headerTableINSPECTEDBY);

				document.add(headerTable24);
				document.add(headerTable45);
				document.add(headerTable45);
				
				PdfPTable headerTableNote = createBilldataNOTE();
				document.add(headerTableNote);
				//##############################################################################################CHALLAN############################################	



			}
			document.close();
		}
		catch (Exception e) 
		{
			System.out.println("Error generating report : " + e);
			e.printStackTrace();
		}
	}

	private PdfPTable createBilldataBANK(String bankName) {


		float[] widths = {20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(6);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("BANK NAME",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+bankName,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("BANK NAME",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+bankName,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	


	}



	

	private PdfPTable DDNumberAndDate(String vendorname,String s) {
		float[] widths = {40,30,05,15,25,15,40,30,05,15,25,15};
			PdfPTable t = new PdfPTable(12);
	       try
			{
				t.setWidthPercentage(100);
				t.setWidths(widths);

				Phrase myPhrase1=new Phrase("DD NO. ",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c3 = new PdfPCell(myPhrase1);
				c3.setBackgroundColor(Color.WHITE);
				c3.setBorder(Rectangle.NO_BORDER);
				t.addCell(c3);

				myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5 ,Font.BOLD));	
				PdfPCell c4 = new PdfPCell(myPhrase1);
				c4.setBackgroundColor(Color.WHITE);
				c4.setBorder(Rectangle.NO_BORDER);
				t.addCell(c4);
				
				myPhrase1=new Phrase(" ");
				PdfPCell c7 = new PdfPCell(myPhrase1);
				c7.setBorder(Rectangle.NO_BORDER);
				t.addCell(c7);
				
				myPhrase1=new Phrase("DD DATE",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c5 = new PdfPCell(myPhrase1);
				c5.setBackgroundColor(Color.WHITE);
				c5.setBorder(Rectangle.NO_BORDER);
				t.addCell(c5);

				myPhrase1=new Phrase(":  "+s,new Font(baseFont,(float) 7.5 ,Font.BOLD));	
				PdfPCell c6 = new PdfPCell(myPhrase1);
				c6.setBackgroundColor(Color.WHITE);
				c6.setBorder(Rectangle.NO_BORDER);
				t.addCell(c6);



				myPhrase1=new Phrase(" ");
				PdfPCell c8 = new PdfPCell(myPhrase1);
				c8.setBorder(Rectangle.NO_BORDER);
				t.addCell(c8);


				myPhrase1=new Phrase("DD NO. ",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c9 = new PdfPCell(myPhrase1);
				c9.setBackgroundColor(Color.WHITE);
				c9.setBorder(Rectangle.LEFT);
				t.addCell(c9);

				myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5,Font.BOLD));
				PdfPCell c10 = new PdfPCell(myPhrase1);
				c10.setBackgroundColor(Color.WHITE);
				c10.setBorder(Rectangle.NO_BORDER);
				t.addCell(c10);



				myPhrase1=new Phrase(" ");
				PdfPCell c11 = new PdfPCell(myPhrase1);
				c11.setBorder(Rectangle.NO_BORDER);
				t.addCell(c11);

				myPhrase1=new Phrase("DD DATE",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c12 = new PdfPCell(myPhrase1);
				c12.setBackgroundColor(Color.WHITE);
				c12.setBorder(Rectangle.NO_BORDER);
				t.addCell(c12);

				myPhrase1=new Phrase(":  "+s,new Font(baseFont,(float) 7.5 ,Font.BOLD));	
				PdfPCell c13 = new PdfPCell(myPhrase1);
				c13.setBackgroundColor(Color.WHITE);
				c13.setBorder(Rectangle.NO_BORDER);
				t.addCell(c13);



				myPhrase1=new Phrase(" ");
				PdfPCell c14 = new PdfPCell(myPhrase1);
				c14.setBorder(Rectangle.NO_BORDER);
				t.addCell(c14);

			}
			catch (Exception e) 
			{
				System.out.println("Error creating bill2 details for SMS Bills : " + e);
				e.printStackTrace();
			}
			return t;	

		}

	private PdfPTable LoadingTimeFromTo(String vendorname,String s) {
		float[] widths = {40,30,05,15,25,15,40,30,05,15,25,15};
			PdfPTable t = new PdfPTable(12);
	       try
			{
				t.setWidthPercentage(100);
				t.setWidths(widths);

				Phrase myPhrase1=new Phrase("LOADING TIME FROM",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c3 = new PdfPCell(myPhrase1);
				c3.setBackgroundColor(Color.WHITE);
				c3.setBorder(Rectangle.NO_BORDER);
				t.addCell(c3);

				myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5 ,Font.BOLD));	
				PdfPCell c4 = new PdfPCell(myPhrase1);
				c4.setBackgroundColor(Color.WHITE);
				c4.setBorder(Rectangle.NO_BORDER);
				t.addCell(c4);
				
				myPhrase1=new Phrase(" ");
				PdfPCell c7 = new PdfPCell(myPhrase1);
				c7.setBorder(Rectangle.NO_BORDER);
				t.addCell(c7);
				
				myPhrase1=new Phrase("TO",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c5 = new PdfPCell(myPhrase1);
				c5.setBackgroundColor(Color.WHITE);
				c5.setBorder(Rectangle.NO_BORDER);
				t.addCell(c5);

				myPhrase1=new Phrase(":  "+s,new Font(baseFont,(float) 7.5 ,Font.BOLD));	
				PdfPCell c6 = new PdfPCell(myPhrase1);
				c6.setBackgroundColor(Color.WHITE);
				c6.setBorder(Rectangle.NO_BORDER);
				t.addCell(c6);



				myPhrase1=new Phrase(" ");
				PdfPCell c8 = new PdfPCell(myPhrase1);
				c8.setBorder(Rectangle.NO_BORDER);
				t.addCell(c8);


				myPhrase1=new Phrase("LOADING TIME FROM",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c9 = new PdfPCell(myPhrase1);
				c9.setBackgroundColor(Color.WHITE);
				c9.setBorder(Rectangle.LEFT);
				t.addCell(c9);

				myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5,Font.BOLD));
				PdfPCell c10 = new PdfPCell(myPhrase1);
				c10.setBackgroundColor(Color.WHITE);
				c10.setBorder(Rectangle.NO_BORDER);
				t.addCell(c10);



				myPhrase1=new Phrase(" ");
				PdfPCell c11 = new PdfPCell(myPhrase1);
				c11.setBorder(Rectangle.NO_BORDER);
				t.addCell(c11);

				myPhrase1=new Phrase("TO",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c12 = new PdfPCell(myPhrase1);
				c12.setBackgroundColor(Color.WHITE);
				c12.setBorder(Rectangle.NO_BORDER);
				t.addCell(c12);

				myPhrase1=new Phrase(":  "+s,new Font(baseFont,(float) 7.5 ,Font.BOLD));	
				PdfPCell c13 = new PdfPCell(myPhrase1);
				c13.setBackgroundColor(Color.WHITE);
				c13.setBorder(Rectangle.NO_BORDER);
				t.addCell(c13);



				myPhrase1=new Phrase(" ");
				PdfPCell c14 = new PdfPCell(myPhrase1);
				c14.setBorder(Rectangle.NO_BORDER);
				t.addCell(c14);

			}
			catch (Exception e) 
			{
				System.out.println("Error creating bill2 details for SMS Bills : " + e);
				e.printStackTrace();
			}
			return t;	

		}
	
	private PdfPTable PlaceFromTo(String vendorname,String s) {
		   float[] widths ={40,30,05,15,30,10,40,30,05,15,30,10} ;
		    //{30,35,05,15,35,10,30,35,05,15,35,10};
			PdfPTable t = new PdfPTable(12);
	       try
			{
				t.setWidthPercentage(100);
				t.setWidths(widths);

				Phrase myPhrase1=new Phrase("FROM PLACE",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c3 = new PdfPCell(myPhrase1);
				c3.setBackgroundColor(Color.WHITE);
				c3.setBorder(Rectangle.NO_BORDER);
				t.addCell(c3);

				myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5 ,Font.BOLD));	
				PdfPCell c4 = new PdfPCell(myPhrase1);
				c4.setBackgroundColor(Color.WHITE);
				c4.setBorder(Rectangle.NO_BORDER);
				t.addCell(c4);
				
				myPhrase1=new Phrase(" ");
				PdfPCell c7 = new PdfPCell(myPhrase1);
				c7.setBorder(Rectangle.NO_BORDER);
				t.addCell(c7);
				
				myPhrase1=new Phrase("TO PLACE",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c5 = new PdfPCell(myPhrase1);
				c5.setBackgroundColor(Color.WHITE);
				c5.setBorder(Rectangle.NO_BORDER);
				t.addCell(c5);

				myPhrase1=new Phrase(":  "+s,new Font(baseFont,(float) 7.5 ,Font.BOLD));	
				PdfPCell c6 = new PdfPCell(myPhrase1);
				c6.setBackgroundColor(Color.WHITE);
				c6.setBorder(Rectangle.NO_BORDER);
				t.addCell(c6);



				myPhrase1=new Phrase(" ");
				PdfPCell c8 = new PdfPCell(myPhrase1);
				c8.setBorder(Rectangle.NO_BORDER);
				t.addCell(c8);


				myPhrase1=new Phrase("FROM PLACE",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c9 = new PdfPCell(myPhrase1);
				c9.setBackgroundColor(Color.WHITE);
				c9.setBorder(Rectangle.LEFT);
				t.addCell(c9);

				myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5,Font.BOLD));
				PdfPCell c10 = new PdfPCell(myPhrase1);
				c10.setBackgroundColor(Color.WHITE);
				c10.setBorder(Rectangle.NO_BORDER);
				t.addCell(c10);



				myPhrase1=new Phrase(" ");
				PdfPCell c11 = new PdfPCell(myPhrase1);
				c11.setBorder(Rectangle.NO_BORDER);
				t.addCell(c11);

				myPhrase1=new Phrase("TO PLACE",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c12 = new PdfPCell(myPhrase1);
				c12.setBackgroundColor(Color.WHITE);
				c12.setBorder(Rectangle.NO_BORDER);
				t.addCell(c12);

				myPhrase1=new Phrase(":  "+s,new Font(baseFont,(float) 7.5 ,Font.BOLD));	
				PdfPCell c13 = new PdfPCell(myPhrase1);
				c13.setBackgroundColor(Color.WHITE);
				c13.setBorder(Rectangle.NO_BORDER);
				t.addCell(c13);



				myPhrase1=new Phrase(" ");
				PdfPCell c14 = new PdfPCell(myPhrase1);
				c14.setBorder(Rectangle.NO_BORDER);
				t.addCell(c14);

			}
			catch (Exception e) 
			{
				System.out.println("Error creating bill2 details for SMS Bills : " + e);
				e.printStackTrace();
			}
			return t;	

		}
	
	private PdfPTable LoadUnloadWeight(String unloadWeight,String loadWeight) {
		   float[] widths ={40,30,05,15,30,10,40,30,05,15,30,10} ;
		    //{30,35,05,15,35,10,30,35,05,15,35,10};
			PdfPTable t = new PdfPTable(12);
	       try
			{
				t.setWidthPercentage(100);
				t.setWidths(widths);

				Phrase myPhrase1=new Phrase("UNLOAD WEIGHT",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c3 = new PdfPCell(myPhrase1);
				c3.setBackgroundColor(Color.WHITE);
				c3.setBorder(Rectangle.NO_BORDER);
				t.addCell(c3);

				myPhrase1=new Phrase(":  "+unloadWeight+" Kg",new Font(baseFont,(float) 7.5 ,Font.BOLD));	
				PdfPCell c4 = new PdfPCell(myPhrase1);
				c4.setBackgroundColor(Color.WHITE);
				c4.setBorder(Rectangle.NO_BORDER);
				t.addCell(c4);
				
				myPhrase1=new Phrase(" ");
				PdfPCell c7 = new PdfPCell(myPhrase1);
				c7.setBorder(Rectangle.NO_BORDER);
				t.addCell(c7);
				
				myPhrase1=new Phrase("LOAD WEIGHT",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c5 = new PdfPCell(myPhrase1);
				c5.setBackgroundColor(Color.WHITE);
				c5.setBorder(Rectangle.NO_BORDER);
				t.addCell(c5);

				myPhrase1=new Phrase(":  "+loadWeight+" Kg",new Font(baseFont,(float) 7.5 ,Font.BOLD));	
				PdfPCell c6 = new PdfPCell(myPhrase1);
				c6.setBackgroundColor(Color.WHITE);
				c6.setBorder(Rectangle.NO_BORDER);
				t.addCell(c6);



				myPhrase1=new Phrase(" ");
				PdfPCell c8 = new PdfPCell(myPhrase1);
				c8.setBorder(Rectangle.NO_BORDER);
				t.addCell(c8);


				myPhrase1=new Phrase("UNLOAD WEIGHT",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c9 = new PdfPCell(myPhrase1);
				c9.setBackgroundColor(Color.WHITE);
				c9.setBorder(Rectangle.LEFT);
				t.addCell(c9);

				myPhrase1=new Phrase(":  "+unloadWeight+" Kg",new Font(baseFont,(float) 7.5,Font.BOLD));
				PdfPCell c10 = new PdfPCell(myPhrase1);
				c10.setBackgroundColor(Color.WHITE);
				c10.setBorder(Rectangle.NO_BORDER);
				t.addCell(c10);



				myPhrase1=new Phrase(" ");
				PdfPCell c11 = new PdfPCell(myPhrase1);
				c11.setBorder(Rectangle.NO_BORDER);
				t.addCell(c11);

				myPhrase1=new Phrase("LOAD WEIGHT",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c12 = new PdfPCell(myPhrase1);
				c12.setBackgroundColor(Color.WHITE);
				c12.setBorder(Rectangle.NO_BORDER);
				t.addCell(c12);

				myPhrase1=new Phrase(":  "+loadWeight+" Kg",new Font(baseFont,(float) 7.5 ,Font.BOLD));	
				PdfPCell c13 = new PdfPCell(myPhrase1);
				c13.setBackgroundColor(Color.WHITE);
				c13.setBorder(Rectangle.NO_BORDER);
				t.addCell(c13);



				myPhrase1=new Phrase(" ");
				PdfPCell c14 = new PdfPCell(myPhrase1);
				c14.setBorder(Rectangle.NO_BORDER);
				t.addCell(c14);

			}
			catch (Exception e) 
			{
				System.out.println("Error creating bill2 details for SMS Bills : " + e);
				e.printStackTrace();
			}
			return t;	

		}
	
	private PdfPTable createBilldataLoadingType(String customerName) {
		float[] widths = {20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(6);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase  myPhrase1=new Phrase("CUSTOMER NAME",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+customerName,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("CUSTOMER NAME",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+customerName,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	


	}



	private PdfPTable createBilldataCOMMON(String name) {

		float[] widths = {20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(6);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase(name,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase(":",new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase(name,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	


	}
	private PdfPTable createBilldataNOTE() {

		float[] widths = {49,1,50};
		PdfPTable t = new PdfPTable(3);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("NOTE:1. This is not a Mineral Dispatch Permit, This is Gps Reference Copy, This reference copy does not guarantee the validity of Insurance , Registration of vehicle or any other statutory compliance related to vehicle. \n\n 2.Rane t4u does not take responsibility of accuracy of the weight data, as "+
            " it is fetched from the weighbridge provider " ,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);


			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("NOTE:1. This is not a Mineral Dispatch Permit, This is Gps Reference Copy, This reference copy does not guarantee the validity of Insurance , Registration of vehicle or any other statutory compliance related to vehicle. \n\n 2. Rane t4u does not take responsibility of accuracy of the weight data, as "+
		            " it is fetched from the weighbridge provider " ,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);



		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	


	}


	private PdfPTable createBillhead2(String string, String headingString) {
		float[] widths = {40,60,95,60,15};
		PdfPTable t = new PdfPTable(5);




		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			
			Phrase myPhrase=new Phrase(headingString,new Font(baseFont,(float) 8, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);

			myPhrase=new Phrase(headingString,new Font(baseFont,(float) 8, Font.BOLD));
			PdfPCell c5 = new PdfPCell(myPhrase);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c41 = new PdfPCell(myPhrase1);
			c41.setBackgroundColor(Color.WHITE);
			c41.setBorder(Rectangle.NO_BORDER);
			t.addCell(c41);




		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	
	}



	private PdfPTable createBilldatatot(String vendorname) {
		float[] widths = {20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(6);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("TOTAL AMOUNT",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("TOTAL AMOUNT",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);

		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

	}



	/** if directory not exixts then create it */
	private void refreshdir(String reportpath)
	{
		try
		{
			File f = new File(reportpath);
			if(!f.exists())
			{
				f.mkdirs();
			}
		}
		catch (Exception e) 
		{
			System.out.println("Error creating folder for Builty Report: " + e);
			e.printStackTrace();
		}
	}

	private PdfPTable createBilldata() {


		float[] widths = {60,70,120,70,40};
		PdfPTable t = new PdfPTable(5);
		
		String	Top2="OFFICE COPY";
		String	Top3="DRIVER COPY";


		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("                    ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			

			myPhrase1=new Phrase("  "+Top2+"  ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);

			myPhrase1=new Phrase("                ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase("                "+Top3+"  ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.NO_BORDER);
			t.addCell(c6);

			myPhrase1=new Phrase("                ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c31 = new PdfPCell(myPhrase1);
			c31.setBackgroundColor(Color.WHITE);
			c31.setBorder(Rectangle.NO_BORDER);
			t.addCell(c31);

		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

	}


	private PdfPTable createBillhead(String PDForm,String headingString)
	{
		float[] widths = {35,60,85,60,15};
		PdfPTable t = new PdfPTable(5);

		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			Phrase myPhrase=new Phrase(headingString,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase("                           ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);

			myPhrase=new Phrase(headingString,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c5 = new PdfPCell(myPhrase);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c41 = new PdfPCell(myPhrase1);
			c41.setBackgroundColor(Color.WHITE);
			c41.setBorder(Rectangle.NO_BORDER);
			t.addCell(c41);





		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	
	}	
	private PdfPTable createBillhead1(String PDForm,String headingString)
	{

		float[] widths = {38,60,80,60,10};
		PdfPTable t = new PdfPTable(5);




		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);


			myPhrase1=new Phrase(headingString,new Font(baseFont, 9, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);

			Phrase myPhrase=new Phrase(headingString,new Font(baseFont, 9, Font.BOLD));
			PdfPCell c5 = new PdfPCell(myPhrase);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c41 = new PdfPCell(myPhrase1);
			c41.setBackgroundColor(Color.WHITE);
			c41.setBorder(Rectangle.NO_BORDER);
			t.addCell(c41);
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

	}	

	

	private PdfPTable createBilldata1(String vendorname) {
	float[] widths = {20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(6);
       try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("VEHICLE NO. ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5 ,Font.BOLDITALIC));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("VEHICLE NO. ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5,Font.BOLDITALIC));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);



		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

	}

	private PdfPTable netWeight(float netWeight) {
		float[] widths = {20,35,10,20,35,10};
			PdfPTable t = new PdfPTable(6);
	       try
			{
				t.setWidthPercentage(100);
				t.setWidths(widths);

				Phrase myPhrase1=new Phrase("Net Weight ",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c3 = new PdfPCell(myPhrase1);
				c3.setBackgroundColor(Color.WHITE);
				c3.setBorder(Rectangle.NO_BORDER);
				t.addCell(c3);

				myPhrase1=new Phrase(":  "+netWeight+" Kg",new Font(baseFont,(float) 7.5 ,Font.BOLDITALIC));	
				PdfPCell c4 = new PdfPCell(myPhrase1);
				c4.setBackgroundColor(Color.WHITE);
				c4.setBorder(Rectangle.NO_BORDER);
				t.addCell(c4);

				myPhrase1=new Phrase(" ");
				PdfPCell c5 = new PdfPCell(myPhrase1);
				c5.setBorder(Rectangle.NO_BORDER);
				t.addCell(c5);


				myPhrase1=new Phrase("Net Weight ",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c6 = new PdfPCell(myPhrase1);
				c6.setBackgroundColor(Color.WHITE);
				c6.setBorder(Rectangle.LEFT);
				t.addCell(c6);

				myPhrase1=new Phrase(":  "+netWeight+" Kg",new Font(baseFont,(float) 7.5,Font.BOLDITALIC));
				PdfPCell c7 = new PdfPCell(myPhrase1);
				c7.setBackgroundColor(Color.WHITE);
				c7.setBorder(Rectangle.NO_BORDER);
				t.addCell(c7);

				myPhrase1=new Phrase(" ");
				PdfPCell c8 = new PdfPCell(myPhrase1);
				c8.setBorder(Rectangle.NO_BORDER);
				t.addCell(c8);

			}
			catch (Exception e) 
			{
				System.out.println("Error creating bill2 details for SMS Bills : " + e);
				e.printStackTrace();
			}
			return t;	

		}



	private PdfPTable newforMDP(String vendorname,String s) {
		float[] widths = {40,30,05,15,25,15,40,30,05,15,25,15};
			PdfPTable t = new PdfPTable(12);
	       try
			{
				t.setWidthPercentage(100);
				t.setWidths(widths);

				Phrase myPhrase1=new Phrase("MDP NO. ",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c3 = new PdfPCell(myPhrase1);
				c3.setBackgroundColor(Color.WHITE);
				c3.setBorder(Rectangle.NO_BORDER);
				t.addCell(c3);

				myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5 ,Font.BOLD));	
				PdfPCell c4 = new PdfPCell(myPhrase1);
				c4.setBackgroundColor(Color.WHITE);
				c4.setBorder(Rectangle.NO_BORDER);
				t.addCell(c4);
				
				myPhrase1=new Phrase(" ");
				PdfPCell c7 = new PdfPCell(myPhrase1);
				c7.setBorder(Rectangle.NO_BORDER);
				t.addCell(c7);
				
				myPhrase1=new Phrase("DATE",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c5 = new PdfPCell(myPhrase1);
				c5.setBackgroundColor(Color.WHITE);
				c5.setBorder(Rectangle.NO_BORDER);
				t.addCell(c5);

				myPhrase1=new Phrase(":  "+s,new Font(baseFont,(float) 7.5 ,Font.BOLD));	
				PdfPCell c6 = new PdfPCell(myPhrase1);
				c6.setBackgroundColor(Color.WHITE);
				c6.setBorder(Rectangle.NO_BORDER);
				t.addCell(c6);



				myPhrase1=new Phrase(" ");
				PdfPCell c8 = new PdfPCell(myPhrase1);
				c8.setBorder(Rectangle.NO_BORDER);
				t.addCell(c8);


				myPhrase1=new Phrase("MDP NO. ",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c9 = new PdfPCell(myPhrase1);
				c9.setBackgroundColor(Color.WHITE);
				c9.setBorder(Rectangle.LEFT);
				t.addCell(c9);

				myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5,Font.BOLD));
				PdfPCell c10 = new PdfPCell(myPhrase1);
				c10.setBackgroundColor(Color.WHITE);
				c10.setBorder(Rectangle.NO_BORDER);
				t.addCell(c10);



				myPhrase1=new Phrase(" ");
				PdfPCell c11 = new PdfPCell(myPhrase1);
				c11.setBorder(Rectangle.NO_BORDER);
				t.addCell(c11);

				myPhrase1=new Phrase("DATE",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c12 = new PdfPCell(myPhrase1);
				c12.setBackgroundColor(Color.WHITE);
				c12.setBorder(Rectangle.NO_BORDER);
				t.addCell(c12);

				myPhrase1=new Phrase(":  "+s,new Font(baseFont,(float) 7.5 ,Font.BOLD));	
				PdfPCell c13 = new PdfPCell(myPhrase1);
				c13.setBackgroundColor(Color.WHITE);
				c13.setBorder(Rectangle.NO_BORDER);
				t.addCell(c13);



				myPhrase1=new Phrase(" ");
				PdfPCell c14 = new PdfPCell(myPhrase1);
				c14.setBorder(Rectangle.NO_BORDER);
				t.addCell(c14);

			}
			catch (Exception e) 
			{
				System.out.println("Error creating bill2 details for SMS Bills : " + e);
				e.printStackTrace();
			}
			return t;	

		}


	private PdfPTable createBilldata(String vendorname) {
		float[] widths = {20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(6);

		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("AMOUNT/CUBIC METER",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("AMOUNT/CUBIC METER",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);

		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	


	}

	private PdfPTable createBilldataVEHICLETYPE(String pERMITNO) {
		String type="";
		
		type=pERMITNO;
		float[] widths = {20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(6);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("ILMS TRIP SHEET N0.",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+type,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("ILMS TRIP SHEET N0.",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+pERMITNO,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	


	}

	
	private PdfPTable createBilldata2(String vendorname,String LoadingType) {
		float[] widths = {40,20,05,25,25,15,40,20,05,25,25,15};
		PdfPTable t = new PdfPTable(12);
       try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("SAND PORT NO. ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5 ,Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);
			
			myPhrase1=new Phrase(" ");
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);
			
			myPhrase1=new Phrase("LOADING TYPE",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBackgroundColor(Color.WHITE);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);

			myPhrase1=new Phrase(":  "+LoadingType,new Font(baseFont,(float) 7.5 ,Font.BOLD));	
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.NO_BORDER);
			t.addCell(c6);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


			myPhrase1=new Phrase("SAND PORT NO. ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c9 = new PdfPCell(myPhrase1);
			c9.setBackgroundColor(Color.WHITE);
			c9.setBorder(Rectangle.LEFT);
			t.addCell(c9);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5,Font.BOLD));
			PdfPCell c10 = new PdfPCell(myPhrase1);
			c10.setBackgroundColor(Color.WHITE);
			c10.setBorder(Rectangle.NO_BORDER);
			t.addCell(c10);



			myPhrase1=new Phrase(" ");
			PdfPCell c11 = new PdfPCell(myPhrase1);
			c11.setBorder(Rectangle.NO_BORDER);
			t.addCell(c11);

			myPhrase1=new Phrase("LOADING TYPE",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c12 = new PdfPCell(myPhrase1);
			c12.setBackgroundColor(Color.WHITE);
			c12.setBorder(Rectangle.NO_BORDER);
			t.addCell(c12);

			myPhrase1=new Phrase(":  "+LoadingType,new Font(baseFont,(float) 7.5 ,Font.BOLD));	
			PdfPCell c13 = new PdfPCell(myPhrase1);
			c13.setBackgroundColor(Color.WHITE);
			c13.setBorder(Rectangle.NO_BORDER);
			t.addCell(c13);



			myPhrase1=new Phrase(" ");
			PdfPCell c14 = new PdfPCell(myPhrase1);
			c14.setBorder(Rectangle.NO_BORDER);
			t.addCell(c14);

		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	
	}


	private PdfPTable createBilldata44(String vendorname) {
		float[] widths = {20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(6);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			

			Phrase myPhrase1=new Phrase("SAND TYPE",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("SAND TYPE",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	


	}


	private PdfPTable createBilldata35(String distance) {
		float[] widths = {20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(6);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			
			Phrase myPhrase1=new Phrase("DISTANCE",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+distance,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("DISTANCE",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+distance,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	


	}


	private PdfPTable createBilldata5(String vendorname) {
		float[] widths = {20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(6);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("TALUK",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("TALUK",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	


	}
	
	private PdfPTable FromDate(String vendorname) {
		float[] widths = {20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(6);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("VALID FROM",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("VALID FROM",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	


	}
	
	private PdfPTable ToDate(String vendorname) {
		float[] widths = {20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(6);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("VALID TO",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("VALID TO",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
	}

	private PdfPTable createBilldata6(String vendorname) {
		float[] widths = {20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(6);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("QUANTITY",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("QUANTITY",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

	}

	private PdfPTable createBilldata7(String vendorname) {
		float[] widths = {20,35,10,20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(9);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase("				 						"+vendorname+"",new Font(baseFont,(float) 10, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);



			myPhrase1=new Phrase(" ");
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase("				 						"+vendorname+"",new Font(baseFont,(float) 10, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.NO_BORDER);
			t.addCell(c6);

			myPhrase1=new Phrase("				 						"+vendorname+"",new Font(baseFont,(float)10, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);

		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

	}

	//private PdfPTable createBilldata8(String vendorname) {
	//		float[] widths = {20,35,10,20,35,10,20,35,10,20,35,10};
	//		PdfPTable t = new PdfPTable(12);
	//		
	//	
	//
	//		try
	//		{
	//			t.setWidthPercentage(100);
	//			t.setWidths(widths);
	//			
	//			Phrase myPhrase1=new Phrase("VEHICLE NO",new Font(baseFont,(float) 7.5, Font.BOLD));
	//			PdfPCell c = new PdfPCell(myPhrase1);
	//			c.setBackgroundColor(Color.WHITE);
	//			c.setBorder(Rectangle.NO_BORDER);
	//			t.addCell(c);
	//		
	//			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));
	//			PdfPCell c1 = new PdfPCell(myPhrase1);
	//			c1.setBackgroundColor(Color.WHITE);
	//			c1.setBorder(Rectangle.NO_BORDER);
	//			t.addCell(c1);
	//			
	//			
	//			
	//			myPhrase1=new Phrase(" ");
	//			PdfPCell c2 = new PdfPCell(myPhrase1);
	//			c2.setBorder(Rectangle.NO_BORDER);
	//			t.addCell(c2);
	//			
	//			 myPhrase1=new Phrase("VEHICLE NO",new Font(baseFont,(float) 7.5, Font.BOLD));
	//			PdfPCell c3 = new PdfPCell(myPhrase1);
	//			c3.setBackgroundColor(Color.WHITE);
	//			c3.setBorder(Rectangle.NO_BORDER);
	//			t.addCell(c3);
	//		
	//			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));	
	//			PdfPCell c4 = new PdfPCell(myPhrase1);
	//			c4.setBackgroundColor(Color.WHITE);
	//			c4.setBorder(Rectangle.NO_BORDER);
	//			t.addCell(c4);
	//			
	//			
	//			
	//			myPhrase1=new Phrase(" ");
	//			PdfPCell c5 = new PdfPCell(myPhrase1);
	//			c5.setBorder(Rectangle.NO_BORDER);
	//			t.addCell(c5);
	//			
	//			
	//			 myPhrase1=new Phrase("VEHICLE NO",new Font(baseFont,(float) 7.5, Font.BOLD));
	//			PdfPCell c6 = new PdfPCell(myPhrase1);
	//			c6.setBackgroundColor(Color.WHITE);
	//			c6.setBorder(Rectangle.NO_BORDER);
	//			t.addCell(c6);
	//		
	//			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));
	//			PdfPCell c7 = new PdfPCell(myPhrase1);
	//			c7.setBackgroundColor(Color.WHITE);
	//			c7.setBorder(Rectangle.NO_BORDER);
	//			t.addCell(c7);
	//			
	//			
	//			
	//			myPhrase1=new Phrase(" ");
	//			PdfPCell c8 = new PdfPCell(myPhrase1);
	//			c8.setBorder(Rectangle.NO_BORDER);
	//			t.addCell(c8);
	//			
	//			 myPhrase1=new Phrase("VEHICLE NO",new Font(baseFont,(float) 7.5, Font.BOLD));
	//				PdfPCell c61 = new PdfPCell(myPhrase1);
	//				c61.setBackgroundColor(Color.WHITE);
	//				c61.setBorder(Rectangle.NO_BORDER);
	//				t.addCell(c61);
	//			
	//				myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));
	//				PdfPCell c71 = new PdfPCell(myPhrase1);
	//				c71.setBackgroundColor(Color.WHITE);
	//				c71.setBorder(Rectangle.NO_BORDER);
	//				t.addCell(c71);
	//				
	//				
	//				
	//				myPhrase1=new Phrase(" ");
	//				PdfPCell c81 = new PdfPCell(myPhrase1);
	//				c81.setBorder(Rectangle.NO_BORDER);
	//				t.addCell(c81);
	//		
	//			
	//		}
	//		catch (Exception e) 
	//		{
	//			System.out.println("Error creating bill2 details for SMS Bills : " + e);
	//			e.printStackTrace();
	//		}
	//		return t;	
	//		
	//	}

	//private PdfPTable createBilldataPRO(String vendorname) {
	//		float[] widths = {20,35,10,20,35,10,20,35,10};
	//		PdfPTable t = new PdfPTable(9);
	//		
	//	
	//
	//		try
	//		{
	//			t.setWidthPercentage(100);
	//			t.setWidths(widths);
	//			
	//			Phrase myPhrase1=new Phrase("PROCESSING FEE",new Font(baseFont,(float) 7.5, Font.BOLD));
	//			PdfPCell c = new PdfPCell(myPhrase1);
	//			c.setBackgroundColor(Color.WHITE);
	//			c.setBorder(Rectangle.NO_BORDER);
	//			t.addCell(c);
	//		
	//			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));
	//			PdfPCell c1 = new PdfPCell(myPhrase1);
	//			c1.setBackgroundColor(Color.WHITE);
	//			c1.setBorder(Rectangle.NO_BORDER);
	//			t.addCell(c1);
	//			
	//			
	//			
	//			myPhrase1=new Phrase(" ");
	//			PdfPCell c2 = new PdfPCell(myPhrase1);
	//			c2.setBorder(Rectangle.NO_BORDER);
	//			t.addCell(c2);
	//			
	//			 myPhrase1=new Phrase("PROCESSING FEE",new Font(baseFont,(float) 7.5, Font.BOLD));
	//			PdfPCell c3 = new PdfPCell(myPhrase1);
	//			c3.setBackgroundColor(Color.WHITE);
	//			c3.setBorder(Rectangle.NO_BORDER);
	//			t.addCell(c3);
	//		
	//			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));	
	//			PdfPCell c4 = new PdfPCell(myPhrase1);
	//			c4.setBackgroundColor(Color.WHITE);
	//			c4.setBorder(Rectangle.NO_BORDER);
	//			t.addCell(c4);
	//			
	//			
	//			
	//			myPhrase1=new Phrase(" ");
	//			PdfPCell c5 = new PdfPCell(myPhrase1);
	//			c5.setBorder(Rectangle.NO_BORDER);
	//			t.addCell(c5);
	//			
	//			
	//			 myPhrase1=new Phrase("PROCESSING FEE",new Font(baseFont,(float) 7.5, Font.BOLD));
	//			PdfPCell c6 = new PdfPCell(myPhrase1);
	//			c6.setBackgroundColor(Color.WHITE);
	//			c6.setBorder(Rectangle.NO_BORDER);
	//			t.addCell(c6);
	//		
	//			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));
	//			PdfPCell c7 = new PdfPCell(myPhrase1);
	//			c7.setBackgroundColor(Color.WHITE);
	//			c7.setBorder(Rectangle.NO_BORDER);
	//			t.addCell(c7);
	//			
	//			
	//			
	//			myPhrase1=new Phrase(" ");
	//			PdfPCell c8 = new PdfPCell(myPhrase1);
	//			c8.setBorder(Rectangle.NO_BORDER);
	//			t.addCell(c8);
	//			
	//			
	//			
	//		}
	//		catch (Exception e) 
	//		{
	//			System.out.println("Error creating bill2 details for SMS Bills : " + e);
	//			e.printStackTrace();
	//		}
	//		return t;	
	//		
	//	}

	private PdfPTable createBilldata9(String vendorname) {
		float[] widths = {20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(6);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("TRANSPORTER NAME",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("TRANSPORTER NAME",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

	}


	private PdfPTable createBilldata10() {
		float[] widths = {20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(6);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("PERMIT ISSUER'S SIGN & SEAL",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase(":",new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("PERMIT ISSUER'S SIGN & SEAL",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);

		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

	}

	//private PdfPTable createBilldata12(String systemid) {
	//	
	//	
	//	float[] widths = {200,200,200,200};
	//	PdfPTable t = new PdfPTable(4);
	//	
	//		String Bottom1="(To be retained by the Lessee or Court            Order Holder)";
	//		String Bottom2="(To be retained by the Driver & hand over            at Unloading point & be kept as a proof for           origin of mineral) ";
	//		String Bottom3="(To be retained over at the Check Post                  of the T4U)";
	//		String Bottom4="(To be retained by TELEMATICS)";
	//		
	//		
	//		if(Integer.parseInt(systemid)==8)
	//		{
	//			 Bottom3="(To be retained over at the Check Post                  of the DMG)";
	//			 Bottom4="(To be retained by DEPT. OF MINES                       & GEOLOGY)";
	//		}
	//		else if(Integer.parseInt(systemid)==131 )
	//			{
	//			 Bottom3="(To be retained over at the Check Post                  of the PWD)";
	//			 Bottom4="(To be retained by Public Works                       Department)";
	//			}
	//
	//
	//	try
	//	{t.setWidthPercentage(100);
	//	t.setWidths(widths);
	//	
	//
	//	Phrase myPhrase1=new Phrase(" "+Bottom1+"  ",new Font(baseFont,(float) 7.5, Font.BOLD));
	//	PdfPCell c1 = new PdfPCell(myPhrase1);
	//	c1.setBackgroundColor(Color.WHITE);
	//	c1.setBorder(Rectangle.NO_BORDER);
	//	t.addCell(c1);
	//
	//	myPhrase1=new Phrase(" "+Bottom2+"  ",new Font(baseFont,(float) 7.5, Font.BOLD));
	//	PdfPCell c4 = new PdfPCell(myPhrase1);
	//	c4.setBackgroundColor(Color.WHITE);
	//	c4.setBorder(Rectangle.NO_BORDER);
	//	t.addCell(c4);
	//
	//	
	//	myPhrase1=new Phrase(" "+Bottom3+"  ",new Font(baseFont,(float) 7.5, Font.BOLD));
	//	PdfPCell c6 = new PdfPCell(myPhrase1);
	//	c6.setBackgroundColor(Color.WHITE);
	//	c6.setBorder(Rectangle.NO_BORDER);
	//	t.addCell(c6);
	//	
	//	myPhrase1=new Phrase(" "+Bottom4+"  ",new Font(baseFont,(float) 7.5, Font.BOLD));
	//	PdfPCell c61 = new PdfPCell(myPhrase1);
	//	c61.setBackgroundColor(Color.WHITE);
	//	c61.setBorder(Rectangle.NO_BORDER);
	//	t.addCell(c61);
	//
	//	}
	//	catch (Exception e) 
	//	{
	//		System.out.println("Error creating bill2 details for SMS Bills : " + e);
	//		e.printStackTrace();
	//	}
	//	return t;	
	//	
	//}
	//
	//


	private PdfPTable createBilldata24() {

		float[] widths = {90,90};
		PdfPTable t = new PdfPTable(2);


		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("                                          ",new Font(baseFont, 10, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase("                                 ",new Font(baseFont,10, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			//c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);



			myPhrase1=new Phrase("                ");
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

	}
	private PdfPTable createBillheader2() {

		float[] widths = {20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(6);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
            
			Phrase myPhrase1=new Phrase(" ");
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setFixedHeight(1);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);

			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setFixedHeight(1);
			c5.setBackgroundColor(Color.BLACK);
			t.addCell(c5);



			myPhrase1=new Phrase(" ");
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setFixedHeight(1);
			c6.setBorder(Rectangle.NO_BORDER);
			t.addCell(c6);


			myPhrase1=new Phrase(" ");
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setFixedHeight(1);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);

			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setFixedHeight(1);
			c8.setBackgroundColor(Color.BLACK);
			t.addCell(c8);



			myPhrase1=new Phrase(" ");
			PdfPCell c9 = new PdfPCell(myPhrase1);
			c9.setFixedHeight(1);
			c9.setBorder(Rectangle.NO_BORDER);
			t.addCell(c9);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

	}

	private PdfPTable createBillheader3() {

		float[] widths = {20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(6);
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase(" ");
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setFixedHeight(1);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);

			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setFixedHeight(1);
			c5.setBackgroundColor(Color.BLACK);
			t.addCell(c5);



			myPhrase1=new Phrase(" ");
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setFixedHeight(1);
			c6.setBorder(Rectangle.NO_BORDER);
			t.addCell(c6);


			myPhrase1=new Phrase(" ");
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setFixedHeight(1);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);

			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setFixedHeight(1);
			c8.setBackgroundColor(Color.BLACK);
			t.addCell(c8);



			myPhrase1=new Phrase(" ");
			PdfPCell c9 = new PdfPCell(myPhrase1);
			c9.setFixedHeight(1);
			c9.setBorder(Rectangle.NO_BORDER);
			t.addCell(c9);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

	}


	private void printBill(ServletOutputStream servletOutputStream,HttpServletResponse response,String bill,String PDForm)
	{
		try
		{
			String formno=PDForm;
			response.setContentType("application/pdf");
			response.setHeader("Content-disposition","attachment;filename="+formno+".pdf");
			FileInputStream fis = new FileInputStream(bill);
			DataOutputStream outputStream = new	DataOutputStream(servletOutputStream);
			byte [] buffer = new byte [1024];
			int len = 0;
			while ((len = fis.read(buffer)) >= 0 ) 
			{
				outputStream.write(buffer, 0, len);
			}

			servletOutputStream.flush();
			servletOutputStream.close();
		}
		catch (Exception e) 
		{
			System.out.println("Error printing SMS Bills : " + e);
			e.printStackTrace();
		}
	}












	private PdfPTable ViaRoute(String vendorname) {
		float[] widths = {20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(6);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("VIA ROUTE",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("VIA ROUTE",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;
	}
	
	private PdfPTable createBillheader1() {

		float[] widths = {52,40,23,30,25,52,40,23,30,25};
		PdfPTable t = new PdfPTable(10);

		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase(" ");
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setFixedHeight(1);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			
			myPhrase1=new Phrase(" ");
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setFixedHeight(1);
			c7.setBackgroundColor(Color.BLACK);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setFixedHeight(1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);

			myPhrase1=new Phrase(" ");
			PdfPCell c9 = new PdfPCell(myPhrase1);
			c9.setFixedHeight(1);
			c9.setBackgroundColor(Color.BLACK);
			t.addCell(c9);

			myPhrase1=new Phrase(" ");
			PdfPCell c10 = new PdfPCell(myPhrase1);
			c10.setFixedHeight(1);
			c10.setBorder(Rectangle.NO_BORDER);
			t.addCell(c10);




			myPhrase1=new Phrase(" ");
			PdfPCell c11 = new PdfPCell(myPhrase1);
			c11.setFixedHeight(1);
			c11.setBorder(Rectangle.NO_BORDER);
			t.addCell(c11);

			myPhrase1=new Phrase(" ");
			PdfPCell c12 = new PdfPCell(myPhrase1);
			c12.setFixedHeight(1);
			c12.setBackgroundColor(Color.BLACK);
			t.addCell(c12);



			myPhrase1=new Phrase(" ");
			PdfPCell c13 = new PdfPCell(myPhrase1);
			c13.setFixedHeight(1);
			c13.setBorder(Rectangle.NO_BORDER);
			t.addCell(c13);

			myPhrase1=new Phrase(" ");
			PdfPCell c14 = new PdfPCell(myPhrase1);
			c14.setFixedHeight(1);
			c14.setBackgroundColor(Color.BLACK);
			t.addCell(c14);

			myPhrase1=new Phrase(" ");
			PdfPCell c15 = new PdfPCell(myPhrase1);
			c15.setFixedHeight(1);
			c15.setBorder(Rectangle.NO_BORDER);
			t.addCell(c15);





		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

	}

	
	

	private static PdfPTable createBilldataCHALLAN(String pDFBANK) {


		float[] widths = {100};
		PdfPTable t = new PdfPTable(1);
		float[] widths2COPY = {100,3,100};
		PdfPTable t2COPY = new PdfPTable(3);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			t.getRowHeight(10);



			Phrase myPhrase1 = new Phrase("KARNATAKA GOVERNMENT\n\n Deposited in "+pDFBANK,new Font(baseFont,(float) 10, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);


			t2COPY.setWidthPercentage(100);
			t2COPY.setWidths(widths2COPY);

			PdfPCell c1 = new PdfPCell(t);
			c1.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c3);

			PdfPCell c2 = new PdfPCell(t);
			c2.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c2);

		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t2COPY;	

	}


	private static PdfPTable createBilldata1() {


		float[] widths = {100,100,100,100};
		PdfPTable t = new PdfPTable(4);

		float[] widths2COPY = {100,3,100};
		PdfPTable t2COPY = new PdfPTable(3);


		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("TREASURY CODE",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);

			myPhrase1=new Phrase("DRAFT CODE",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);

			myPhrase1=new Phrase("PERMIT DATE",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);

			myPhrase1=new Phrase("CHALLAN NO.",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);



			t2COPY.setWidthPercentage(100);
			t2COPY.setWidths(widths2COPY);

			PdfPCell c1 = new PdfPCell(t);
			c1.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c3);

			PdfPCell c2 = new PdfPCell(t);
			c2.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c2);

		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t2COPY;	

	}

	private static PdfPTable createBilldata2dATE(String Date, String pDFTREASURYCODE) {	
		float[] widths = {50,50,50,50};
		PdfPTable t = new PdfPTable(4);

		float[] widths3 = {10,10,10,10};
		PdfPTable t1 = new PdfPTable(4);
		float[] widths4 = {10,10,10,10};
		PdfPTable t2 = new PdfPTable(4);

		float[] widths5 = {100};
		PdfPTable t3 = new PdfPTable(1);
		float[] widths6 = {100};
		PdfPTable t4 = new PdfPTable(1);
		String[] codes=pDFTREASURYCODE.split(",");
		//	System.out.println(codes[0]);
		//	System.out.println(codes[1]);
		//	System.out.println(codes[2]);
		//	System.out.println(codes[3]);

		float[] widths2COPY = {100,3,100};
		PdfPTable t2COPY = new PdfPTable(3);


		try
		{
			t1.setWidthPercentage(100);
			t1.setWidths(widths3);


			Phrase myPhrase1=new Phrase(codes[0],new Font(baseFont, 9, Font.BOLD,Color.black));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t1.addCell(c);

			myPhrase1=new Phrase(codes[1],new Font(baseFont, 9, Font.BOLD,Color.black));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.BOX);
			t1.addCell(c1);

			myPhrase1=new Phrase(codes[2],new Font(baseFont, 9, Font.BOLD,Color.black));
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBackgroundColor(Color.WHITE);
			c2.setBorder(Rectangle.BOX);
			t1.addCell(c2);


			myPhrase1=new Phrase(codes[3],new Font(baseFont, 9, Font.BOLD,Color.black));
			c2 = new PdfPCell(myPhrase1);
			c2.setBackgroundColor(Color.WHITE);
			c2.setBorder(Rectangle.BOX);
			t1.addCell(c2);


			t2.setWidthPercentage(100);
			t2.setWidths(widths4);

			ArrayList<String> codeList=new ArrayList<String>();
			if(codes.length-4>0)
			{codeList.add(codes[4]);
			codeList.add(codes[5]);
			codeList.add(codes[6]);
			codeList.add(codes[7]);}
			else
			{
				codeList.add("0");
				codeList.add("0");
				codeList.add("");
				codeList.add("");
			}
			Phrase myPhrase2=new Phrase(codeList.get(0),new Font(baseFont,(float) 9, Font.BOLD));	
			PdfPCell c3 = new PdfPCell(myPhrase2);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.BOX);
			t2.addCell(c3);

			myPhrase2=new Phrase(codeList.get(1),new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c4 = new PdfPCell(myPhrase2);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.BOX);
			t2.addCell(c4);

			myPhrase2=new Phrase(codeList.get(2),new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c5 = new PdfPCell(myPhrase2);
			c5.setBackgroundColor(Color.WHITE);
			c5.setBorder(Rectangle.BOX);
			t2.addCell(c5);

			myPhrase2=new Phrase(codeList.get(3),new Font(baseFont,(float) 9, Font.BOLD));
			c5 = new PdfPCell(myPhrase2);
			c5.setBackgroundColor(Color.WHITE);
			c5.setBorder(Rectangle.BOX);
			t2.addCell(c5);



			t3.setWidthPercentage(100);
			t3.setWidths(widths5);

			Phrase myPhrase3=new Phrase(Date);
			PdfPCell c8 = new PdfPCell(myPhrase3);
			c8.setBackgroundColor(Color.WHITE);
			c8.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c8.setBorder(Rectangle.BOX);
			t3.addCell(c8);


			t4.setWidthPercentage(100);
			t4.setWidths(widths6);


			Phrase myPhrase4=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));		
			PdfPCell c9 = new PdfPCell(myPhrase4);
			c9.setBackgroundColor(Color.WHITE);
			c9.setBorder(Rectangle.BOX);
			t4.addCell(c9);



			t.setWidthPercentage(100);
			t.setWidths(widths);

			PdfPCell c18 = new PdfPCell(t1);
			c18.setBorder(Rectangle.BOX);
			t.addCell(c18);


			PdfPCell c19 = new PdfPCell(t2);
			c19.setBorder(Rectangle.BOX);
			t.addCell(c19);

			PdfPCell c20 = new PdfPCell(t3);
			c20.setBorder(Rectangle.BOX);
			t.addCell(c20);


			PdfPCell c21 = new PdfPCell(t4);
			c21.setBorder(Rectangle.BOX);
			t.addCell(c21);



			t2COPY.setWidthPercentage(100);
			t2COPY.setWidths(widths2COPY);

			c1 = new PdfPCell(t);
			c1.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c3 = new PdfPCell(myPhrase1);
			c3.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c3);

			c2 = new PdfPCell(t);
			c2.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c2);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t2COPY;
	}

	private static PdfPTable createBilldata3() {


		float[] widths = {30,100};
		PdfPTable t = new PdfPTable(2);

		float[] widths2COPY = {100,3,100};
		PdfPTable t2COPY = new PdfPTable(3);

		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("DEPOSITER NAME:",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);

			myPhrase1=new Phrase("ASSISTANT EXECUTIVE ENGINEER",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);



			t2COPY.setWidthPercentage(100);
			t2COPY.setWidths(widths2COPY);

			PdfPCell c1 = new PdfPCell(t);
			c1.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c3);

			PdfPCell c2 = new PdfPCell(t);
			c2.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c2);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t2COPY;	

	}

	private static PdfPTable createBilldata4(String pDFADDRESS) {


		float[] widths = {30,100};
		PdfPTable t = new PdfPTable(2);

		float[] widths2COPY = {100,3,100};
		PdfPTable t2COPY = new PdfPTable(3);

		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("ADDRESS :",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);

			myPhrase1=new Phrase(pDFADDRESS,new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);



			t2COPY.setWidthPercentage(100);
			t2COPY.setWidths(widths2COPY);

			PdfPCell c1 = new PdfPCell(t);
			c1.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c3);

			PdfPCell c2 = new PdfPCell(t);
			c2.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c2);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t2COPY;	

	}

	private static PdfPTable createBilldata5() {


		float[] widths = {30,100};
		PdfPTable t = new PdfPTable(2);

		float[] widths2COPY = {100,3,100};
		PdfPTable t2COPY = new PdfPTable(3);

		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("REASON FOR DEPOSIT  :\n\n\t\t\tSAND MINING PERMIT AMOUNT",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			//c.setBorderColorBottom(Color.WHITE);
			t.addCell(c);

			myPhrase1=new Phrase("\n\nAMOUNT VERIFIED",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);



			t2COPY.setWidthPercentage(100);
			t2COPY.setWidths(widths2COPY);

			PdfPCell c1 = new PdfPCell(t);
			c1.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c3);

			PdfPCell c2 = new PdfPCell(t);
			c2.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c2);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t2COPY;	

	}

	private static PdfPTable createBilldata6PDF_ACCOUNT(String pDFACCOUNT) {


		float[] widths = {0,30,100};
		PdfPTable t = new PdfPTable(3);

		float[] widths2COPY = {100,3,100};
		PdfPTable t2COPY = new PdfPTable(3);
		String PDF_ACCOUNT = pDFACCOUNT.replaceAll(",", "");



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);


			Phrase myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.white);
			c.setBorder(Rectangle.BOX);

			t.addCell(c);
			myPhrase1=new Phrase("\n\nACCOUNT DETAILS:\n\n"+PDF_ACCOUNT+"\n\n\n\n\n\n",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.white);
			c.setBorder(Rectangle.BOX);

			t.addCell(c);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);


			t2COPY.setWidthPercentage(100);
			t2COPY.setWidths(widths2COPY);

			PdfPCell c1 = new PdfPCell(t);
			c1.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c3);

			PdfPCell c2 = new PdfPCell(t);
			c2.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c2);

		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t2COPY;	

	}

	private static PdfPTable createBilldata7() {


		float[] widths = {50,100,30};
		PdfPTable t = new PdfPTable(3);

		float[] widths2COPY = {100,3,100};
		PdfPTable t2COPY = new PdfPTable(3);


		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);


			Phrase myPhrase1=new Phrase("DEPOSIT DETAILS",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.white);
			c.setBorder(Rectangle.BOX);

			t.addCell(c);
			myPhrase1=new Phrase("ACCOUNT NUMBER",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.white);
			c.setBorder(Rectangle.BOX);

			t.addCell(c);

			myPhrase1=new Phrase("AMOUNT",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);



			t2COPY.setWidthPercentage(100);
			t2COPY.setWidths(widths2COPY);

			PdfPCell c1 = new PdfPCell(t);
			c1.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c3);

			PdfPCell c2 = new PdfPCell(t);
			c2.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c2);

		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t2COPY;	

	}

	private static PdfPTable createBilldata8DDNO(String DDNO, String totalforwords, String pDFACCOUNT) {

		String PDF_ACCOUNT[] = pDFACCOUNT.split(",");
		float[] widths = {50,100,30};
		PdfPTable t = new PdfPTable(3);

		float[] widths1 = {20,20,20,20,20,20,20,20,20,20,20,20,20};
		PdfPTable t1 = new PdfPTable(13);


		float[] widths2COPY = {100,3,100};
		PdfPTable t2COPY = new PdfPTable(3);

		try
		{
			t1.setWidthPercentage(100);
			t1.setWidths(widths1);

			Phrase myPhrase1=new Phrase(PDF_ACCOUNT[0],new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase(PDF_ACCOUNT[1],new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase(PDF_ACCOUNT[2],new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase(PDF_ACCOUNT[3],new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase(PDF_ACCOUNT[4],new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase(PDF_ACCOUNT[5],new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase(PDF_ACCOUNT[6],new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase(PDF_ACCOUNT[7],new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase(PDF_ACCOUNT[8],new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase(PDF_ACCOUNT[9],new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase(PDF_ACCOUNT[10],new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase(PDF_ACCOUNT[11],new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			if(PDF_ACCOUNT.length-12>0)
			{ myPhrase1=new Phrase(PDF_ACCOUNT[12],new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);}
			else
			{myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);}

			t.setWidthPercentage(100);
			t.setWidths(widths);


			myPhrase1=new Phrase("D.D No.:"+DDNO,new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.white);
			c.setBorder(Rectangle.BOX);

			t.addCell(c);

			t.addCell(t1);

			myPhrase1=new Phrase(totalforwords,new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);



			t2COPY.setWidthPercentage(100);
			t2COPY.setWidths(widths2COPY);

			PdfPCell c1 = new PdfPCell(t);
			c1.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c3);

			PdfPCell c2 = new PdfPCell(t);
			c2.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c2);

		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t2COPY;	

	}

	private static PdfPTable createBilldata9DDDAte(String DDDAte) {


		float[] widths = {0,50,100,30};
		PdfPTable t = new PdfPTable(4);

		float[] widths1 = {20,20,20,20,20,20,20,20,20,20,20,20,20};
		PdfPTable t1 = new PdfPTable(13);

		float[] widths2COPY = {100,3,100};
		PdfPTable t2COPY = new PdfPTable(3);


		try
		{
			t1.setWidthPercentage(100);
			t1.setWidths(widths1);

			Phrase myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);

			t.setWidthPercentage(100);
			t.setWidths(widths);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);

			myPhrase1=new Phrase("D.D Date:"+DDDAte,new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.white);
			c.setBorder(Rectangle.NO_BORDER);

			t.addCell(c);

			t.addCell(t1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);



			t2COPY.setWidthPercentage(100);
			t2COPY.setWidths(widths2COPY);

			PdfPCell c1 = new PdfPCell(t);
			c1.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c3);

			PdfPCell c2 = new PdfPCell(t);
			c2.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c2);

		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t2COPY;	

	}

	private static PdfPTable createBilldata10CHALLAN() {


		float[] widths = {0,50,100,30};
		PdfPTable t = new PdfPTable(4);

		float[] widths1 = {20,20,20,20,20,20,20,20,20,20,20,20,20};
		PdfPTable t1 = new PdfPTable(13);

		float[] widths2COPY = {100,3,100};
		PdfPTable t2COPY = new PdfPTable(3);


		try
		{
			t1.setWidthPercentage(100);
			t1.setWidths(widths1);

			Phrase myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);


			t.setWidthPercentage(100);
			t.setWidths(widths);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);

			myPhrase1=new Phrase("BANK NAME:",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.white);
			c.setBorder(Rectangle.NO_BORDER);

			t.addCell(c);

			t.addCell(t1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);



			t2COPY.setWidthPercentage(100);
			t2COPY.setWidths(widths2COPY);

			PdfPCell c1 = new PdfPCell(t);
			c1.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c3);

			PdfPCell c2 = new PdfPCell(t);
			c2.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c2);

		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t2COPY;	
	}

	private static PdfPTable createBilldata11(String BankName) {


		float[] widths = {0,50,100,30};
		PdfPTable t = new PdfPTable(4);

		float[] widths1 = {20,20,20,20,20,20,20,20,20,20,20,20,20};
		PdfPTable t1 = new PdfPTable(13);


		float[] widths2COPY = {100,3,100};
		PdfPTable t2COPY = new PdfPTable(3);

		try
		{
			t1.setWidthPercentage(100);
			t1.setWidths(widths1);

			Phrase myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);
			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			t1.addCell(c);


			t.setWidthPercentage(100);
			t.setWidths(widths);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);

			myPhrase1=new Phrase(BankName,new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.white);
			c.setBorder(Rectangle.NO_BORDER);

			t.addCell(c);

			t.addCell(t1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);



			t2COPY.setWidthPercentage(100);
			t2COPY.setWidths(widths2COPY);

			PdfPCell c1 = new PdfPCell(t);
			c1.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c3);

			PdfPCell c2 = new PdfPCell(t);
			c2.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c2);

		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t2COPY;	
	}


	private static PdfPTable createBilldata12totalFee(String totalforwords) {


		float[] widths = {0,50,100,30};
		PdfPTable t = new PdfPTable(4);


		float[] widths2COPY = {100,3,100};
		PdfPTable t2COPY = new PdfPTable(3);

		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase("TOTAL AMOUNT",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);

			myPhrase1=new Phrase(totalforwords,new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);



			t2COPY.setWidthPercentage(100);
			t2COPY.setWidths(widths2COPY);

			PdfPCell c1 = new PdfPCell(t);
			c1.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c3);

			PdfPCell c2 = new PdfPCell(t);
			c2.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c2);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t2COPY;	

	}

	private static PdfPTable createBilldata13totalFee(String totalforwords) {


		float[] widths = {100};
		PdfPTable t = new PdfPTable(1);


		float[] widths2COPY = {100,3,100};
		PdfPTable t2COPY = new PdfPTable(3);

		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			String s=intowords(totalforwords);
			Phrase myPhrase1=new Phrase("\nRUPEES IN WORDS : ("+s+" Only).\n\n",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOX);
			t.addCell(c);



			t2COPY.setWidthPercentage(100);
			t2COPY.setWidths(widths2COPY);

			PdfPCell c1 = new PdfPCell(t);
			c1.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c3);

			PdfPCell c2 = new PdfPCell(t);
			c2.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c2);

		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t2COPY;	

	}

	private static PdfPTable createBilldata14(String totalforwords) {


		float[] widths = {28,35,30,110,50};
		PdfPTable t = new PdfPTable(5);

		float[] widths2COPY = {100,3,100};
		PdfPTable t2COPY = new PdfPTable(3);


		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			String s=intowords(totalforwords);
			Phrase myPhrase1=new Phrase("RUPEES",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase(totalforwords,new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOTTOM);
			t.addCell(c);

			myPhrase1=new Phrase("IN WORDS",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase(""+s,new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.BOTTOM);
			t.addCell(c);

			myPhrase1=new Phrase("RECEIVED ONLY.",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);



			t2COPY.setWidthPercentage(100);
			t2COPY.setWidths(widths2COPY);

			PdfPCell c1 = new PdfPCell(t);
			c1.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c3);

			PdfPCell c2 = new PdfPCell(t);
			c2.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c2);

		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t2COPY;	

	}

	private static PdfPTable createBilldata14Under() {


		float[] widths = {28,20,30,100,50};
		PdfPTable t = new PdfPTable(5);

		float[] widths2COPY = {100,3,100};
		PdfPTable t2COPY = new PdfPTable(3);


		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			Phrase myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.TOP);
			t.addCell(c);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.TOP);
			t.addCell(c);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);



			t2COPY.setWidthPercentage(100);
			t2COPY.setWidths(widths2COPY);

			PdfPCell c1 = new PdfPCell(t);
			c1.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c3);

			PdfPCell c2 = new PdfPCell(t);
			c2.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c2);

		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t2COPY;	

	}

	//private static PdfPTable createBilldata15() {
	//	
	//	
	//	float[] widths1 = {100,50};
	//	PdfPTable t1 = new PdfPTable(2);
	//	
	//	
	//
	//	try
	//	{
	//		t1.setWidthPercentage(100);
	//		t1.setWidths(widths1);
	//		Phrase myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
	//		PdfPCell c = new PdfPCell(myPhrase1);
	//		c.setBackgroundColor(Color.white);
	//		c.setBorder(Rectangle.BOTTOM);
	//		t1.addCell(c);
	//		
	//		 myPhrase1=new Phrase(" RECEIVED ONLY.",new Font(baseFont,(float) 9, Font.BOLD));
	//		c = new PdfPCell(myPhrase1);
	//		c.setBackgroundColor(Color.WHITE);
	//		c.setBorder(Rectangle.NO_BORDER);
	//		t1.addCell(c);
	//		
	//		
	//	}
	//	catch (Exception e) 
	//	{
	//		System.out.println("Error creating bill2 details for SMS Bills : " + e);
	//		e.printStackTrace();
	//	}
	//	return t1;	
	//	
	//}

	private static PdfPTable createBilldata16() {


		float[] widths = {30,40,30,100};
		PdfPTable t = new PdfPTable(4);


		float[] widths2COPY = {100,3,100};
		PdfPTable t2COPY = new PdfPTable(3);

		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("\t\t\t\t\t\t\t\t\t\tCASHIER ",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			c = new PdfPCell(myPhrase1);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);



			t2COPY.setWidthPercentage(100);
			t2COPY.setWidths(widths2COPY);

			PdfPCell c1 = new PdfPCell(t);
			c1.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c3);

			PdfPCell c2 = new PdfPCell(t);
			c2.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c2);
		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t2COPY;	

	}

	private static PdfPTable createBilldataFULLEMPTY() {


		float[] widths = {100};
		PdfPTable t = new PdfPTable(1);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("\n\n",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);



		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

	}

	private static PdfPTable createBilldataLINE() {


		float[] widths = {100};
		PdfPTable t = new PdfPTable(1);


		float[] widths2COPY = {100,3,100};
		PdfPTable t2COPY = new PdfPTable(3);

		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.TOP);
			t.addCell(c);

			PdfPCell c1 = new PdfPCell(t);
			c1.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c3);

			PdfPCell c2 = new PdfPCell(t);
			c2.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c2);



		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t2COPY;	

	}

	private static PdfPTable createBilldataDASH() {


		float[] widths = {100};
		PdfPTable t = new PdfPTable(1);


		float[] widths2COPY = {100,3,100};
		PdfPTable t2COPY = new PdfPTable(3);

		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("------------------------------------------------x----------------------------------------",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);



			t2COPY.setWidthPercentage(100);
			t2COPY.setWidths(widths2COPY);

			PdfPCell c1 = new PdfPCell(t);
			c1.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 9, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c3);

			PdfPCell c2 = new PdfPCell(t);
			c2.setBorder(Rectangle.NO_BORDER);
			t2COPY.addCell(c2);

		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t2COPY;	

	}


	private static String intowords(String amount)
	{
		String inwords="";

		if(!(amount.equals("0.0")||amount.equals("0")))
		{
			if(amount.contains("."))
			{
				int len1 = amount.indexOf(".");
				if(len1 == (amount.length()-1))
				{
					amount = amount+"0";	
				}
				String data = amount;
				data = data.replace(".","/");
				String[] numbers = data.split("/");
				for(int i =0; i < numbers.length;i++)
				{

				}
				inwords = EnglishNumberToWords.convert(Long.parseLong(numbers[0]));
				if((!numbers[1].equals("")) && numbers[1].length() >=1 && Integer.parseInt(numbers[1])>0)
				{
					if(!numbers[1].equals(""))
					{
						inwords =inwords+" Rupees and "+EnglishNumberToWords.convert(Long.parseLong(numbers[1]))+" Paise";
					}
				}
				else
				{
					inwords =inwords+" rupees";
				}
			}
			else
			{
				inwords = EnglishNumberToWords.convert(Long.parseLong(amount))+" rupees";
			}

		}
		else
		{

			inwords = "Zero Rupees and Zero Paise";

		}

		return inwords;
	}




	
	private PdfPTable createContactNoBilldata(String contactNo) {
		float[] widths = {20,35,10,20,35,10};
			PdfPTable t = new PdfPTable(6);
	       try
			{
				t.setWidthPercentage(100);
				t.setWidths(widths);

				Phrase myPhrase1=new Phrase("CONTACT NO. ",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c3 = new PdfPCell(myPhrase1);
				c3.setBackgroundColor(Color.WHITE);
				c3.setBorder(Rectangle.NO_BORDER);
				t.addCell(c3);

				myPhrase1=new Phrase(":  "+contactNo,new Font(baseFont,(float) 7.5 ,Font.BOLD));	
				PdfPCell c4 = new PdfPCell(myPhrase1);
				c4.setBackgroundColor(Color.WHITE);
				c4.setBorder(Rectangle.NO_BORDER);
				t.addCell(c4);



				myPhrase1=new Phrase(" ");
				PdfPCell c5 = new PdfPCell(myPhrase1);
				c5.setBorder(Rectangle.NO_BORDER);
				t.addCell(c5);


				myPhrase1=new Phrase("CONTACT NO. ",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c6 = new PdfPCell(myPhrase1);
				c6.setBackgroundColor(Color.WHITE);
				c6.setBorder(Rectangle.LEFT);
				t.addCell(c6);

				myPhrase1=new Phrase(":  "+contactNo,new Font(baseFont,(float) 7.5,Font.BOLD));
				PdfPCell c7 = new PdfPCell(myPhrase1);
				c7.setBackgroundColor(Color.WHITE);
				c7.setBorder(Rectangle.NO_BORDER);
				t.addCell(c7);



				myPhrase1=new Phrase(" ");
				PdfPCell c8 = new PdfPCell(myPhrase1);
				c8.setBorder(Rectangle.NO_BORDER);
				t.addCell(c8);



			}
			catch (Exception e) 
			{
				System.out.println("Error creating contact number bill details for SMS Bills : " + e);
				e.printStackTrace();
			}
			return t;	

		}

	private PdfPTable createCustomerNameAddressBilldata(String customerName) {
		float[] widths = {20,35,10,20,35,10};
			PdfPTable t = new PdfPTable(6);
	       try
			{
				t.setWidthPercentage(100);
				t.setWidths(widths);

				Phrase myPhrase1=new Phrase("CUSTOMER NAME/ADDRESS  ",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c3 = new PdfPCell(myPhrase1);
				c3.setBackgroundColor(Color.WHITE);
				c3.setBorder(Rectangle.NO_BORDER);
				t.addCell(c3);

				myPhrase1=new Phrase(":  "+customerName,new Font(baseFont,(float) 7.5 ,Font.BOLD));	
				PdfPCell c4 = new PdfPCell(myPhrase1);
				c4.setBackgroundColor(Color.WHITE);
				c4.setBorder(Rectangle.NO_BORDER);
				t.addCell(c4);



				myPhrase1=new Phrase(" ");
				PdfPCell c5 = new PdfPCell(myPhrase1);
				c5.setBorder(Rectangle.NO_BORDER);
				t.addCell(c5);


				myPhrase1=new Phrase("CUSTOMER NAME/ADDRESS  ",new Font(baseFont,(float) 7.5, Font.BOLD));
				PdfPCell c6 = new PdfPCell(myPhrase1);
				c6.setBackgroundColor(Color.WHITE);
				c6.setBorder(Rectangle.LEFT);
				t.addCell(c6);

				myPhrase1=new Phrase(":  "+customerName,new Font(baseFont,(float) 7.5,Font.BOLD));
				PdfPCell c7 = new PdfPCell(myPhrase1);
				c7.setBackgroundColor(Color.WHITE);
				c7.setBorder(Rectangle.NO_BORDER);
				t.addCell(c7);



				myPhrase1=new Phrase(" ");
				PdfPCell c8 = new PdfPCell(myPhrase1);
				c8.setBorder(Rectangle.NO_BORDER);
				t.addCell(c8);



			}
			catch (Exception e) 
			{
				System.out.println("Error creating customer name and address bill details for SMS Bills : " + e);
				e.printStackTrace();
			}
			return t;	

		}

	
}
