package t4u.ironMining;


import java.awt.Color;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import t4u.common.ApplicationListener;
import t4u.common.DBConnection;

import com.lowagie.text.Document;
import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

@SuppressWarnings("serial")
public class PDFForMining extends HttpServlet {
	static BaseFont baseFont = null;
	static int font=9;
	
	public String GET_MINE_DETAILS= " select mfd.REGISTRATION_NO,tc.MINE_CODE,mfd.MINERAL_NAME,mfd.TYPE_OF_ORE,isNull(e.MINING_COMPANY,'') as NAME_OF_MINE,mfd.OTHER_MINERAL_NAME,tc.VILLAGE,tc.AREA, " +
									" tc.FAX_NO,tc.PHONE_NO,tc.EMAIL_ID,tc.PIN,s1.STATE_NAME,d1.DISTRICT_NAME,t1.TALUKA_NAME,mfd.RENT_PAID,mfd.ROYALTY_PAID," +
									" mfd.DEAD_RENT_PAID,mfd.INC_DEC_GRADE_REASON,mfd.INC_DEC_PROD_REASON,mfd.MINE_NON_WORK_DAYS,mfd.MINE_WORK_DAYS,mfd.REASON_FOR_NOT_WORK," +
									" mfd.TECHNICAL_STAFF,mfd.TOTAL_SALARIES,mfd.PLACE,mfd.ENTERED_DATE,mfd.ENTERED_BY,mfd.DESIGNATION,mfd.REGION,mfd.PIN_CODE," +
									" mfd.TC_NO,DATEPART(yyyy,mfd.DATE) as YEAR,DATENAME(month, mfd.DATE) as Month_Name,isnull(mfd.OTHER_REMARKS,'') as OTHER_REMARKS " +
									" from AMS.dbo.MONTHLY_FORM_DETAILS mfd " +
									" left outer join AMS.dbo.MINING_TC_MASTER tc on mfd.MINE_CODE=tc.ID " + 
									" left outer join ADMINISTRATOR.dbo.DISTRICT_DETAILS  d1 on tc.DISTRICT = d1.DISTRICT_CODE " + 
									" left outer join ADMINISTRATOR.dbo.TALUKA_DETAILS t1 on d1.DISTRICT_CODE=t1.DISTRICT_CODE and tc.TALUKA=t1.TALUKA_CODE " +
									" left outer join AMS.dbo.MINING_MINE_MASTER e on e.ID=tc.MINE_ID and e.SYSTEM_ID=tc.SYSTEM_ID and e.CUSTOMER_ID=tc.CUSTOMER_ID " +
									" left outer join ADMINISTRATOR.dbo.STATE_DETAILS s1 on tc.STATE=s1.STATE_CODE " +
									" where mfd.ID=? " ;
	
	public String GET_OWNER_DETAILS= " select om.VILLAGE,om.POST_OFFICE,isnull(om.LEASE_NAME,'') as CONTACT_PERSON,isnull(om.EMAIL_ID,'')as EMAIL_ID ,isnull(om.FAX_NO,'') as FAX_NO, " +
									 " om.PHONE_NO,om.PIN,s1.STATE_NAME,d1.DISTRICT_NAME,t1.TALUKA_NAME " +
									 " from dbo.MONTHLY_FORM_DETAILS mfd " +
									 " left outer join AMS.dbo.MINE_OWNER_MASTER om" +
									 " on mfd.MINE_OWNER_ID=om.ID " +
									 " left outer join ADMINISTRATOR.dbo.DISTRICT_DETAILS  d1 on om.DISTRICT = d1.DISTRICT_CODE " + 
									 " left outer join ADMINISTRATOR.dbo.TALUKA_DETAILS t1 on om.TALUKA=t1.TALUKA_CODE " + 
									 " left outer join ADMINISTRATOR.dbo.STATE_DETAILS s1 on om.STATE=s1.STATE_CODE " +
									 " where mfd.ID=?" ;
	
	public String GET_EMPLOYMENT_DETAILS =  " select WORK_PLACE,DIRECT_MALE,DIRECT_FEMALE, CONTRACT_MALE,CONTRACT_FEMALE,WAGES_DIRECT,WAGES_CONTRACT " +
											" from DAILY_EMPLOYEMENT_DETAILS where MONTHLY_ID=? and upper(WORK_PLACE)!='TOTAL' " +
											" union all " +
											" select 'TOTAL' as WORK_PLACE,sum(DIRECT_MALE),sum(DIRECT_FEMALE), sum(CONTRACT_MALE),sum(CONTRACT_FEMALE),sum(WAGES_DIRECT),sum(WAGES_CONTRACT) " +
											" from DAILY_EMPLOYEMENT_DETAILS where MONTHLY_ID=? and upper(WORK_PLACE)!='TOTAL' " ;
	
	public String GET_GRADEWISE_PRODUCTION_DETAILS =  " select MONTHLY_ID,GRADE,OPENING_STOCK,PRODUCTION,DESPATCHES,CLOSING_STOCK,EX_MINE_PRICE " +
                                                      " from GRADE_WISE_MINERAL_DEATILS where MONTHLY_ID=?  " ;
	
	public String GET_PRODUCTION_AND_STOCKS_DETAILS = " select CATEGORY,OPENING_STOCK,PRODUCTION,CLOSING_STOCK from PRODUCTION_AND_STOCK_DETAILS where MONTHLY_ID=? ";
	
	public String GET_DEDUCTION_DETAILS =   " select DEDUCTION_CLAIMED,UNIT_RS_PER_TONE,REMARKS from DEDUCTION_SALE_DETAILS where MONTHLY_ID=? and DEDUCTION_CLAIMED!='Total (a) to (g)' " +
											" union all " +
											" select 'Total (a) to (g)' as DEDUCTION_CLAIMED,sum(UNIT_RS_PER_TONE) as UNIT_RS_PER_TONE,'' as REMARKS from " +
											" DEDUCTION_SALE_DETAILS where MONTHLY_ID=? and DEDUCTION_CLAIMED!='Total (a) to (g)' " ;

	public String GET_SALES_FOR_DOMESTIC_CONSUMPTION = " select GRADE,DESPATCH_NAME,DOMESTIC_CONSIGNEE,DOMESTIC_QUANTITY,DOMESTICS_SALE_VALUE,EXPORT_COUNTRY,QUANTITY,EXPORT_FOB_VALUE " +
                                                       " from DOMESTIC_EXPORT_SALES_DEATILS where MONTHLY_ID=? ";
	
	public String GET_CHALLAN_DETAILS = " select MONTHLY_ID,CHALLAN_NO,GRADE,QUANTITY,TYPE,PROVISIONAL_ROYALITY_RATE,VALUE_PAID,CHALLAN_DATE from AMS.dbo.MONTHLY_CHALLAN_DETAILS where MONTHLY_ID=? ";
	
	public String GET_TOTAL = " select sum(QUANTITY) as QUANTITY ,sum(PROVISIONAL_ROYALITY_RATE) as AMOUNT,sum(VALUE_PAID) as VALUE_PAID from AMS.dbo.MONTHLY_CHALLAN_DETAILS where MONTHLY_ID=? " ;
	
	public String GET_ROM_PROCESSING_DETAILS= " select PLANT_LOCATION,ROM_OPENING_STOCK,ROM_RECEIPT,ROM_PROCESSED,ROM_CLOSING_STOCK from AMS.dbo.MRF_ROM_PROCESS_DETAILS where MONTHLY_ID=? ";
	
	public String GET_ORE_PROCESSED_DETAILS=    "select GRADE,FINES,LUMPS,OVERSIZE,WASTE_OR_TAILING from AMS.dbo.MRF_PROCESSED_ORE_DETAILS " + 
												" where MONTHLY_ID=? and GRADE!='Total' " +
												" union all " +
												" select 'Total' as GRADE,sum(FINES),sum(LUMPS),sum(OVERSIZE),sum(WASTE_OR_TAILING) from AMS.dbo.MRF_PROCESSED_ORE_DETAILS " + 
												" where MONTHLY_ID=? and GRADE!='Total'" ;
	
	public String GET_OVERSIZE_PROCESSING_DETAILS=   " select GRADE,FINES,LUMPS,WASTE_OR_TAILING from AMS.dbo.MRF_OVERSIZE_PROCESSING_DETAILS " +
													 " where MONTHLY_ID=? and GRADE!='Total' " +
													 " union all " +
													 " select 'Total' as GRADE,sum(FINES),sum(LUMPS),sum(WASTE_OR_TAILING) from AMS.dbo.MRF_OVERSIZE_PROCESSING_DETAILS " +
													 " where MONTHLY_ID=? and GRADE!='Total'" ;

	public String GET_PRODUCT_GENERATED_DETAILS= " select GRADE,OPENING_STOCK,PRODUCT,DESPATCH,CLOSING_STOCK from AMS.dbo.MRF_PRODUCT_BAL_DETAILS where MONTHLY_ID=? " +
												 " and GRADE not in ('Total','Total Waste & Tailing','Total Closing Stock Of Oversize','Reconciled') " +
												 " union all " +
												 " select 'Total' as GRADE,sum(OPENING_STOCK) as OPENING_STOCK,sum(PRODUCT) as PRODUCT,sum(DESPATCH) as DESPATCH,sum(CLOSING_STOCK) as CLOSING_STOCK from AMS.dbo.MRF_PRODUCT_BAL_DETAILS where MONTHLY_ID=? " +
												 " and GRADE not in ('Total','Total Waste & Tailing','Total Closing Stock Of Oversize','Reconciled') " +
												 " union all " +
												 " select GRADE,OPENING_STOCK,PRODUCT,DESPATCH,CLOSING_STOCK from AMS.dbo.MRF_PRODUCT_BAL_DETAILS where MONTHLY_ID=? " +
												 " and GRADE in ('Total Waste & Tailing','Total Closing Stock Of Oversize') " +
												 " union all " +
												 " select 'Reconciled' as GRADE,sum(OPENING_STOCK),sum(PRODUCT),sum(DESPATCH),sum(CLOSING_STOCK) from AMS.dbo.MRF_PRODUCT_BAL_DETAILS where MONTHLY_ID=? " +
												 " and GRADE not in ('Total','Reconciled') " ;
	
	public String GET_OVERSIZE_DETAILS= " select PLANT_LOCATION,OVERSIZE_OPENING_STOCK,OVERSIZE_GENERATION,OVERSIZE_PROCESSING,OVERSIZE_CLOSING_STOCK " +
	                                    " from AMS.dbo.MRF_OVERSIZE_CRUSHING_DETAILS where MONTHLY_ID=? ";
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {	
		try
		{
			ServletOutputStream servletOutputStream = response.getOutputStream();
			Properties properties = ApplicationListener.prop;
			String billpath=  properties.getProperty("Builtypath");
			refreshdir(billpath);
			String pdfFileName="AssetAcknowledgement";
			//String fontPath = "C:\\timesNew.ttf";
			String formno="MONTHLY RETURNS FORMS";
			baseFont = BaseFont.createFont(BaseFont.TIMES_ROMAN, BaseFont.CP1252, false);
			String bill = billpath+ pdfFileName + ".pdf";
			generateBill(bill,request);
			printBill(servletOutputStream,response,bill,formno);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error generating pdf form : " + e);
			e.printStackTrace();
		}
	}

	@SuppressWarnings("unchecked")
	private void generateBill(String bill,HttpServletRequest request) 
	{		
		try
		{			
			int autoGeneratedKeys = 0;
			if(request.getParameter("autoGeneratedKeys") != null && !request.getParameter("autoGeneratedKeys").equals("")){
			autoGeneratedKeys = Integer.parseInt(request.getParameter("autoGeneratedKeys"));
			}
			
			HashMap mineDetails = new HashMap();
			mineDetails=getDataForMineDetails(autoGeneratedKeys);
			
			HashMap ownerDetails=new HashMap();
			ownerDetails=getOwnerDetails(autoGeneratedKeys);
			
			HashMap employeeDetails=new HashMap();
			employeeDetails=getDailyEmploymentDetails(autoGeneratedKeys);
			
			HashMap gradeProductionDetails=new HashMap();
			gradeProductionDetails=getGradeWiseProductionDetails(autoGeneratedKeys);
			
			HashMap ProductionAndStocksDetails=new HashMap();
			ProductionAndStocksDetails=getProductionAndStocksDetails(autoGeneratedKeys);
			
			HashMap deductionDetails=new HashMap();
			deductionDetails=getDeductionDetails(autoGeneratedKeys);
			
			ArrayList<Object> domesticDetails = new ArrayList<Object>();
			domesticDetails=getSalesForDomestic(autoGeneratedKeys);
			
			ArrayList<Object> challanDetails = new ArrayList<Object>();
			challanDetails=getChallanDetails(autoGeneratedKeys);
			
			ArrayList<String> total = new ArrayList<String>();
			total=getTotalChallanDetails(autoGeneratedKeys);
			
			ArrayList<Object> romDetails = new ArrayList<Object>();
			romDetails=getRomProcessingDetails(autoGeneratedKeys);
			
			HashMap oreDetails=new HashMap();
			oreDetails=getOreProcessedDetails(autoGeneratedKeys);
			
			ArrayList<Object> oversizeDetails = new ArrayList<Object>();
			oversizeDetails=getOversizeDetails(autoGeneratedKeys);
			
			HashMap oversizeProcessingDetails=new HashMap();
			oversizeProcessingDetails=getOversizeProcessingDetails(autoGeneratedKeys);
			
			HashMap productGenerationDetails=new HashMap();
			productGenerationDetails=getProductGenerationReport(autoGeneratedKeys);
			
			String month=(String) mineDetails.get("month");
			String year=(String) mineDetails.get("year");
			
			String RegistrationNumber=(String) mineDetails.get("regNo");
			String MineCode=(String) mineDetails.get("mineCode");
			String NameOfMineral=(String) mineDetails.get("mineralName");
			String ironOreMineralName=(String) mineDetails.get("ironOreName");
			String nameOfMine=(String) mineDetails.get("mineName");
			String otherMineral=(String) mineDetails.get("otherMineral");
        
			String village=(String) mineDetails.get("village");
			String postOffice=(String) mineDetails.get("postOffice");
			String taluka=(String) mineDetails.get("tcTaluka");
			String district=(String) mineDetails.get("tcDistrict");
			String state=(String) mineDetails.get("tcState");
			String tcPin=(String) mineDetails.get("tcPin");
			String faxno=(String) mineDetails.get("faxNo");
			String phoneNo=(String) mineDetails.get("phoneNo");
			String email=(String) mineDetails.get("tcEmail");
			String rentPaid=(String) mineDetails.get("rentPaid");
			String royalty=(String) mineDetails.get("royalityPaid");
			String deadRent=(String) mineDetails.get("deadRent");
			String productionReason=(String) mineDetails.get("productionReason");
			String gradeReason=(String) mineDetails.get("gradeReason");
			String noOfWorkDays=(String) mineDetails.get("mineWorkDays");
			String noOfNonWorkDays=(String) mineDetails.get("mineNonWorkDays");
			String reasonForNotWork=(String) mineDetails.get("reasonForNotWork");
			String technicalStaff=(String) mineDetails.get("technicalStaff");
			String totalSalary=(String) mineDetails.get("totalSalary");
			String nameInFull=(String) mineDetails.get("nameinfull");
			String place=(String) mineDetails.get("place");
			String date=(String) mineDetails.get("date");
			String designation=(String) mineDetails.get("designation");
			String region=(String) mineDetails.get("region");
			String pinCode=(String) mineDetails.get("pinCode");
			String tcNo=(String) mineDetails.get("tcNo");
			String otherReason=(String) mineDetails.get("otherRemark");
			
		    String contactPerson=(String) ownerDetails.get("contactPerson");
			String ownerVillage=(String) ownerDetails.get("village");
			String ownerPost=(String) ownerDetails.get("postOffice");
			String ownerTaluka=(String) ownerDetails.get("ownerTaluk");
			String ownerDistrict=(String) ownerDetails.get("ownerDistrict");
			String ownerState=(String) ownerDetails.get("ownerState");
			String ownerPin=(String) ownerDetails.get("pin");
			String ownerPhoneNo=(String) ownerDetails.get("phoneNo");
			String ownerEmailId=(String) ownerDetails.get("emailId");
			String ownerFaxNo=(String) ownerDetails.get("faxNo");
			
			FileOutputStream fileOut = new FileOutputStream(bill);
			Document document = new Document(PageSize.A4, 40, 40, 30, 20);
			@SuppressWarnings("unused")
			PdfWriter writer = PdfWriter.getInstance(document,fileOut);
			document.open();
			
			PdfPTable formHeader=createHeader(month,year,region,pinCode,NameOfMineral);
			document.add(formHeader);
			
			PdfPTable FormData1 = createTableForMineDetails(RegistrationNumber,MineCode,NameOfMineral,nameOfMine,otherMineral,village,postOffice,taluka,district,state,faxno,phoneNo,email,tcPin,
					                                        contactPerson,ownerVillage,ownerPost,ownerTaluka,ownerDistrict,ownerState,ownerPin,ownerPhoneNo,tcNo,ownerEmailId,ownerFaxNo);
			document.add(FormData1);
			
			if(Integer.parseInt(noOfWorkDays)==0 && Integer.parseInt(noOfNonWorkDays)==0){
				noOfWorkDays=" ";
				noOfNonWorkDays=" ";
				}
			PdfPTable FormData12 = createTableForRentDetails(noOfWorkDays,rentPaid,royalty,deadRent);
			document.add(FormData12);
			
			PdfPTable FormData122 = createFormData122(noOfNonWorkDays,reasonForNotWork);
			document.add(FormData122);
			
			//document.newPage();
			
			PdfPTable heading4 = createHeading4();
			document.add(heading4);
			
			PdfPTable FormData2 = createFormData2();
			document.add(FormData2);	
			
			PdfPTable FormData21 = createTableForEmploymentDetails(employeeDetails);
			document.add(FormData21);	
			
			PdfPTable FormData3 = createFormData3(technicalStaff,totalSalary,NameOfMineral,ironOreMineralName);
			document.add(FormData3);
			
            PdfPTable FormData4=null;
			
			if(NameOfMineral.equals("Iron Ore")){
				FormData4 = createTableForProductionAndStocksDetailsFe(ProductionAndStocksDetails);
			}
			if(NameOfMineral.equals("Bauxite/Laterite")){
				FormData4 = createTableForProductionAndStocksDetailsBu(ProductionAndStocksDetails);
			}
			if(NameOfMineral.equals("Manganese")){
				FormData4 = createTableForProductionAndStocksDetailsMn(ProductionAndStocksDetails);
			}
			document.add(FormData4);
			
			PdfPTable heading1 = createHeading1(NameOfMineral);
			document.add(heading1);
			
			PdfPTable FormData5=null;
			
			if(NameOfMineral.equals("Iron Ore")){
				FormData5 = createTableForGradeWiseProductionIron(gradeProductionDetails);
			}
			if(NameOfMineral.equals("Bauxite/Laterite")){
				FormData5 = createTableForGradeWiseProductionBauxite(gradeProductionDetails);
			}
			if(NameOfMineral.equals("Manganese")){
				FormData5 = createTableForGradeWiseProductionManganese(gradeProductionDetails);
			}
			document.add(FormData5);
			
			PdfPTable heading2 = createHeading2(NameOfMineral);
			document.add(heading2);
			
			PdfPTable FormData6 = createTableForDeduction(deductionDetails,NameOfMineral);
			document.add(FormData6);
			
			document.newPage();
			
			PdfPTable heading3 = createHeading3(NameOfMineral);
			document.add(heading3);
			
			PdfPTable FormData10 = createTableForDomesticConsumption(domesticDetails);
			document.add(FormData10);
			
			PdfPTable FormData11=createFormData11();
			document.add(FormData11);
			
			PdfPTable FormData8 = createForReasons(gradeReason,productionReason,NameOfMineral);
			document.add(FormData8);
			
			PdfPTable FormData9 = createFormData9(nameInFull,place,date);
			document.add(FormData9);
			
			PdfPTable footer = createFooter(designation);
			document.add(footer);
			
			document.newPage();
			
			PdfPTable image = createImage();
			document.add(image);
			
			PdfPTable challanHeader = createChallanHeader();
			document.add(challanHeader);
			
			PdfPTable createdetails = createdetails(MineCode,tcNo,month,year);
			document.add(createdetails);
			
			PdfPTable challanData = createTableForChallanDetails(challanDetails,total);
			document.add(challanData);	
			
			PdfPTable footerdata = createFoooter(otherReason);
			document.add(footerdata);
			
			document.newPage();
			
			document.add(image);
			
			PdfPTable formHeaderLast = createFormHeader();
			document.add(formHeaderLast);
			
			PdfPTable FormDatah01 = createHeaderForROMProcessing();
			document.add(FormDatah01);
			
			PdfPTable FormData01 = createForROMProcessing(romDetails);
			document.add(FormData01);
			
			PdfPTable FormDatah02 = createHeaderForProcessedOre();
			document.add(FormDatah02);
			
			PdfPTable FormData02 = null;
			if(NameOfMineral.equals("Iron Ore")){
				FormData02 = createForDeatilsOfProcessedOreFe(oreDetails);
			}
			if(NameOfMineral.equals("Bauxite/Laterite")){
				FormData02 = createForDeatilsOfProcessedOreForAl(oreDetails);
			}
			if(NameOfMineral.equals("Manganese")){
				FormData02 = createForDeatilsOfProcessedOrefForMn(oreDetails);
			}
			document.add(FormData02);
			
			PdfPTable FormDatah03 = createHeaderForOversize();
			document.add(FormDatah03);
			
			PdfPTable FormData03 = createForOversize(oversizeDetails);
			document.add(FormData03);
			
			PdfPTable FormDatah04 = createHeaderForOversizeProcessing();
			document.add(FormDatah04);
			
			PdfPTable FormData04 = null;
			
			if(NameOfMineral.equals("Iron Ore")){
				FormData04 = createForDeatilsOfOversizeProcessingForFe(oversizeProcessingDetails);
			}
			if(NameOfMineral.equals("Bauxite/Laterite")){
				FormData04 = createForDeatilsOfOversizeProcessingForAl(oversizeProcessingDetails);
			}
			if(NameOfMineral.equals("Manganese")){
				FormData04 = createForDeatilsOfOversizeProcessingForMn(oversizeProcessingDetails);
			}
			
			document.add(FormData04);
			
			PdfPTable FormDatah05 = createHeaderForProductGenerated();
			document.add(FormDatah05);
			
			PdfPTable FormData05 = null;
			if(NameOfMineral.equals("Iron Ore")){
				FormData05 = createForProductGeneratedForFe(productGenerationDetails);
			}
			if(NameOfMineral.equals("Bauxite/Laterite")){
				FormData05 = createForProductGeneratedForAl(productGenerationDetails);
			}
			if(NameOfMineral.equals("Manganese")){
				FormData05 = createForProductGeneratedForMn(productGenerationDetails);
			}
			document.add(FormData05);
			
			
			document.close();
		}
		catch (Exception e) 
		{
			System.out.println("Error generating report : " + e);
			e.printStackTrace();
		}
	}
	/** if directory not exists then create it */
	private void refreshdir(String reportpath)
	{
		try
		{
			File f = new File(reportpath);
			if(!f.exists())
			{
				f.mkdir();
			}
		}
		catch (Exception e) 
		{
			System.out.println("Error creating PDF form for Mining :  " + e);
			e.printStackTrace();
		}
	}
	
	private PdfPTable createTableForMineDetails(String RegistrationNumber,String Minecode,String NameofMineral,String nameofmine,String othermineral,String village,String postoffice,String taluka,String district,String state,String faxno,String phoneno,String email,String pin,
			String contactPerson,String ownerVillage, String ownerPost,String ownerTaluka,String ownerDistrict,String ownerState,String ownerPin,String ownerPhoneNo,String tcNo,String ownerEmailId,String ownerFaxNo)
	{
		float[] widths = {50,30};
		PdfPTable t = new PdfPTable(2);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase1=new Phrase("  1. Details of the Mine :",new Font(baseFont,font, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			t.addCell(c);
			
			Phrase myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c1 = new PdfPCell(myPhrase);
			c.setBackgroundColor(Color.WHITE);
			t.addCell(c1);
			
			myPhrase1=new Phrase("    (a)Registration number alloted by Indian Bureau of Mines(to give registration number of the mine owner/agent/mining engineer/manager signing the return)",new Font(baseFont,font, Font.ITALIC));
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBackgroundColor(Color.WHITE);
			t.addCell(c2);
			
			myPhrase=new Phrase(RegistrationNumber,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c3 = new PdfPCell(myPhrase);
			c3.setBackgroundColor(Color.WHITE);
			t.addCell(c3);
			
			myPhrase1=new Phrase("    (b)Mine Code : ",new Font(baseFont,font, Font.BOLD));
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			t.addCell(c4);
			
			myPhrase=new Phrase(Minecode,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c5 = new PdfPCell(myPhrase);
			c5.setBackgroundColor(Color.WHITE);
			t.addCell(c5);
			
			myPhrase1=new Phrase("    (c)Name of The Mineral :",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			t.addCell(c6);
			
			myPhrase=new Phrase(NameofMineral,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c7 = new PdfPCell(myPhrase);
			c7.setBackgroundColor(Color.WHITE);
			t.addCell(c7);
			
			myPhrase1=new Phrase("       TC No:",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c006 = new PdfPCell(myPhrase1);
			c006.setBackgroundColor(Color.WHITE);
			t.addCell(c006);
			
			myPhrase=new Phrase(tcNo,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c007 = new PdfPCell(myPhrase);
			c007.setBackgroundColor(Color.WHITE);
			t.addCell(c007);
			
			myPhrase1=new Phrase("    (d)Name of Mine :",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c06 = new PdfPCell(myPhrase1);
			c06.setBackgroundColor(Color.WHITE);
			t.addCell(c06);
			
			myPhrase=new Phrase(nameofmine,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c07 = new PdfPCell(myPhrase);
			c07.setBackgroundColor(Color.WHITE);
			t.addCell(c07);
			
			myPhrase1=new Phrase("    (e)Name(s)of other mineral(s),if any, produced from the same mine",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBackgroundColor(Color.WHITE);
			t.addCell(c8);
			
			myPhrase=new Phrase(othermineral,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c9 = new PdfPCell(myPhrase);
			c9.setBackgroundColor(Color.WHITE);
			t.addCell(c9);
			
			myPhrase1=new Phrase("    (f)Location Of the Mine : ",new Font(baseFont,font, Font.BOLD));
			PdfPCell c10 = new PdfPCell(myPhrase1);
			c10.setBackgroundColor(Color.WHITE);
			t.addCell(c10);
			
			myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c11 = new PdfPCell(myPhrase);
			c11.setBackgroundColor(Color.WHITE);
			t.addCell(c11);
			
			myPhrase1=new Phrase("        Village",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c12 = new PdfPCell(myPhrase1);
			c12.setBackgroundColor(Color.WHITE);
			t.addCell(c12);
			
			myPhrase=new Phrase(village,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c13 = new PdfPCell(myPhrase);
			c13.setBackgroundColor(Color.WHITE);
			t.addCell(c13);
			
			myPhrase1=new Phrase("        Post Office",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c14 = new PdfPCell(myPhrase1);
			c14.setBackgroundColor(Color.WHITE);
			t.addCell(c14);
			
			myPhrase=new Phrase(postoffice,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c15 = new PdfPCell(myPhrase);
			c15.setBackgroundColor(Color.WHITE);
			t.addCell(c15);
			
			myPhrase1=new Phrase("        Taluk",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c16 = new PdfPCell(myPhrase1);
			c16.setBackgroundColor(Color.WHITE);
			t.addCell(c16);
			
			myPhrase=new Phrase(taluka,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c17 = new PdfPCell(myPhrase);
			c17.setBackgroundColor(Color.WHITE);
			t.addCell(c17);
			
			myPhrase1=new Phrase("        District",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c18 = new PdfPCell(myPhrase1);
			c18.setBackgroundColor(Color.WHITE);
			t.addCell(c18);
			
			myPhrase=new Phrase(district,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c19 = new PdfPCell(myPhrase);
			c19.setBackgroundColor(Color.WHITE);
			t.addCell(c19);
			
			myPhrase1=new Phrase("        State",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c20 = new PdfPCell(myPhrase1);
			c20.setBackgroundColor(Color.WHITE);
			t.addCell(c20);
			
			myPhrase=new Phrase(state,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c21 = new PdfPCell(myPhrase);
			c21.setBackgroundColor(Color.WHITE);
			t.addCell(c21);
			
			myPhrase1=new Phrase("        PIN Code",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c020 = new PdfPCell(myPhrase1);
			c020.setBackgroundColor(Color.WHITE);
			t.addCell(c020);
			
			myPhrase=new Phrase(pin,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c021 = new PdfPCell(myPhrase);
			c021.setBackgroundColor(Color.WHITE);
			t.addCell(c021);
			
			myPhrase1=new Phrase("        Fax no",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c23 = new PdfPCell(myPhrase1);
			c23.setBackgroundColor(Color.WHITE);
			t.addCell(c23);
			
			myPhrase=new Phrase(faxno,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c24 = new PdfPCell(myPhrase);
			c24.setBackgroundColor(Color.WHITE);
			t.addCell(c24);
			
			myPhrase1=new Phrase("        Phone No",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c25 = new PdfPCell(myPhrase1);
			c25.setBackgroundColor(Color.WHITE);
			t.addCell(c25);
			
			myPhrase=new Phrase(phoneno,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c26 = new PdfPCell(myPhrase);
			c26.setBackgroundColor(Color.WHITE);
			t.addCell(c26);
			
			myPhrase1=new Phrase("        E-mail",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c025 = new PdfPCell(myPhrase1);
			c025.setBackgroundColor(Color.WHITE);
			t.addCell(c025);
			
			myPhrase=new Phrase(email,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c026 = new PdfPCell(myPhrase);
			c026.setBackgroundColor(Color.WHITE);
			t.addCell(c026);
			
			myPhrase1=new Phrase("  2. Name and Address(s)of Lessee/Owner(along with fax no. and e-mail): ",new Font(baseFont,font, Font.BOLD));
			PdfPCell c27 = new PdfPCell(myPhrase1);
			c27.setBackgroundColor(Color.WHITE);
			t.addCell(c27);
			
			myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c28 = new PdfPCell(myPhrase);
			c28.setBackgroundColor(Color.WHITE);
			t.addCell(c28);
			
			myPhrase1=new Phrase("      Name of Person ",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c027 = new PdfPCell(myPhrase1);
			c027.setBackgroundColor(Color.WHITE);
			t.addCell(c027);
			
			myPhrase=new Phrase(contactPerson,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c028 = new PdfPCell(myPhrase);
			c028.setBackgroundColor(Color.WHITE);
			t.addCell(c028);
			
			myPhrase1=new Phrase("      Village",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c29 = new PdfPCell(myPhrase1);
			c29.setBackgroundColor(Color.WHITE);
			t.addCell(c29);
			
			myPhrase=new Phrase(ownerVillage,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c30 = new PdfPCell(myPhrase);
			c30.setBackgroundColor(Color.WHITE);
			t.addCell(c30);
			
			myPhrase1=new Phrase("      Post Office",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c31 = new PdfPCell(myPhrase1);
			c31.setBackgroundColor(Color.WHITE);
			t.addCell(c31);
			
			myPhrase=new Phrase(ownerPost,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c32 = new PdfPCell(myPhrase);
			c32.setBackgroundColor(Color.WHITE);
			t.addCell(c32);
			
			myPhrase1=new Phrase("      Taluk",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c33 = new PdfPCell(myPhrase1);
			c33.setBackgroundColor(Color.WHITE);
			t.addCell(c33);
			
			myPhrase=new Phrase(ownerTaluka,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c34 = new PdfPCell(myPhrase);
			c34.setBackgroundColor(Color.WHITE);
			t.addCell(c34);
			
			myPhrase1=new Phrase("      District",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c35 = new PdfPCell(myPhrase1);
			c35.setBackgroundColor(Color.WHITE);
			t.addCell(c35);
			
			myPhrase=new Phrase(ownerDistrict,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c36 = new PdfPCell(myPhrase);
			c36.setBackgroundColor(Color.WHITE);
			t.addCell(c36);
			
			myPhrase1=new Phrase("      State",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c37 = new PdfPCell(myPhrase1);
			c37.setBackgroundColor(Color.WHITE);
			t.addCell(c37);
			
			myPhrase=new Phrase(ownerState,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c38 = new PdfPCell(myPhrase);
			c38.setBackgroundColor(Color.WHITE);
			t.addCell(c38);
			
			myPhrase1=new Phrase("      PIN Code",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c037 = new PdfPCell(myPhrase1);
			c037.setBackgroundColor(Color.WHITE);
			t.addCell(c037);
			
			myPhrase=new Phrase(ownerPin,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c038 = new PdfPCell(myPhrase);
			c038.setBackgroundColor(Color.WHITE);
			t.addCell(c038);
			
			myPhrase1=new Phrase("      Fax no",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c39 = new PdfPCell(myPhrase1);
			c39.setBackgroundColor(Color.WHITE);
			t.addCell(c39);
			
			myPhrase=new Phrase(ownerFaxNo,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c40 = new PdfPCell(myPhrase);
			c40.setBackgroundColor(Color.WHITE);
			t.addCell(c40);
			
			myPhrase1=new Phrase("      Phone No",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c41 = new PdfPCell(myPhrase1);
			c41.setBackgroundColor(Color.WHITE);
			t.addCell(c41);
			
			myPhrase=new Phrase(ownerPhoneNo,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c42 = new PdfPCell(myPhrase);
			c42.setBackgroundColor(Color.WHITE);
			t.addCell(c42);
			
			myPhrase1=new Phrase("      E-mail",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c500 = new PdfPCell(myPhrase1);
			c500.setBackgroundColor(Color.WHITE);
			t.addCell(c500);
			
			myPhrase=new Phrase(ownerEmailId,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c501 = new PdfPCell(myPhrase);
			c501.setBackgroundColor(Color.WHITE);
			t.addCell(c501);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating PDF form for Mining :  " + e);
			e.printStackTrace();
		}
		return t;	
	}	

	private PdfPTable createTableForRentDetails(String noOfDays,String rentPaid,String royalty,String deadRent)
	{
		float[] widths = {50,30};
		PdfPTable t = new PdfPTable(2);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase=new Phrase("  3. Details of Rent/Royalty/Dead Rent paid in the month : ",new Font(baseFont,font, Font.BOLD));
			PdfPCell c43 = new PdfPCell(myPhrase);
			c43.setBackgroundColor(Color.WHITE);
			t.addCell(c43);
			
			myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c44 = new PdfPCell(myPhrase);
			c44.setBackgroundColor(Color.WHITE);
			t.addCell(c44);
			
			myPhrase=new Phrase("     (i)Rent paid for the period(Rs.)",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c45 = new PdfPCell(myPhrase);
			c45.setBackgroundColor(Color.WHITE);
			t.addCell(c45);
			
			myPhrase=new Phrase( rentPaid,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c46 = new PdfPCell(myPhrase);
			c46.setBackgroundColor(Color.WHITE);
			t.addCell(c46);
			
			myPhrase=new Phrase("     (ii)Royalty paid for the period(Rs.)",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c47 = new PdfPCell(myPhrase);
			c47.setBackgroundColor(Color.WHITE);
			t.addCell(c47);
			
			myPhrase=new Phrase(royalty,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c48 = new PdfPCell(myPhrase);
			c48.setBackgroundColor(Color.WHITE);
			t.addCell(c48);
			
			myPhrase=new Phrase("     (iii)Dead Rent paid for the period(in Rs.)",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c49 = new PdfPCell(myPhrase);
			c49.setBackgroundColor(Color.WHITE);
			t.addCell(c49);
			
			myPhrase=new Phrase(deadRent,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c50 = new PdfPCell(myPhrase);
			c50.setBackgroundColor(Color.WHITE);
			t.addCell(c50);
			
			myPhrase=new Phrase("  4. Details on working of mine:",new Font(baseFont,font, Font.BOLD));
			PdfPCell c51 = new PdfPCell(myPhrase);
			c51.setBackgroundColor(Color.WHITE);
			t.addCell(c51);
			
			myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c52 = new PdfPCell(myPhrase);
			c52.setBackgroundColor(Color.WHITE);
			t.addCell(c52);
			
			myPhrase=new Phrase("     (i)Number of days the mine worked:",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c53 = new PdfPCell(myPhrase);
			c53.setBackgroundColor(Color.WHITE);
			t.addCell(c53);
			
			myPhrase=new Phrase(noOfDays,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c54 = new PdfPCell(myPhrase);
			c54.setBackgroundColor(Color.WHITE);
			t.addCell(c54);
			
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating PDF form for Mining :  " + e);
			e.printStackTrace();
		}
		return t;	
	}	
	private PdfPTable createFormData122(String noOfNonWorkDays,String reasonForNotWork)
	{
		float[] widths = {100,30,30};
		PdfPTable t = new PdfPTable(3);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase=new Phrase("    (ii)Reasons for work stoppage in the mine",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c51 = new PdfPCell(myPhrase);
			c51.disableBorderSide(Rectangle.BOTTOM);
			c51.setBackgroundColor(Color.WHITE);
			t.addCell(c51);
			
			myPhrase=new Phrase("Reasons",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c52 = new PdfPCell(myPhrase);
			c52.setBackgroundColor(Color.WHITE);
			t.addCell(c52);
			
			myPhrase=new Phrase("No of Days",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c53 = new PdfPCell(myPhrase);
			c53.setBackgroundColor(Color.WHITE);
			t.addCell(c53);
			
			myPhrase=new Phrase("       during the month(due to strike,lockout,",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c55 = new PdfPCell(myPhrase);
			c55.disableBorderSide(Rectangle.BOTTOM);
		    c55.disableBorderSide(Rectangle.TOP);
			c55.setBackgroundColor(Color.WHITE);
			t.addCell(c55);
						
			myPhrase=new Phrase(reasonForNotWork,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c56 = new PdfPCell(myPhrase);
			c56.setBackgroundColor(Color.WHITE);
			t.addCell(c56);
			
			myPhrase=new Phrase(noOfNonWorkDays,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c57 = new PdfPCell(myPhrase);
			c57.setBackgroundColor(Color.WHITE);
			t.addCell(c57);
			
			myPhrase=new Phrase("       heavy rain ,non-availability of labour,",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c58 = new PdfPCell(myPhrase);
			c58.disableBorderSide(Rectangle.BOTTOM);
		    c58.disableBorderSide(Rectangle.TOP);
			c58.setBackgroundColor(Color.WHITE);
			t.addCell(c58);
			
			myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c59 = new PdfPCell(myPhrase);
			c59.setBackgroundColor(Color.WHITE);
			t.addCell(c59);
			
			myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c60= new PdfPCell(myPhrase);
			c60.setBackgroundColor(Color.WHITE);
			t.addCell(c60);
			
			
			myPhrase=new Phrase("       transport bottleneck,lack of demand,",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c61 = new PdfPCell(myPhrase);
			c61.disableBorderSide(Rectangle.BOTTOM);
		    c61.disableBorderSide(Rectangle.TOP);
			c61.setBackgroundColor(Color.WHITE);
			t.addCell(c61);
			
			myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c62 = new PdfPCell(myPhrase);
			c62.setBackgroundColor(Color.WHITE);
			t.addCell(c62);
			
			myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c63 = new PdfPCell(myPhrase);
			c63.setBackgroundColor(Color.WHITE);
			t.addCell(c63);
			
			myPhrase=new Phrase("       uneconomic operations etc.) and the number of days of work stoppage for",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c64 = new PdfPCell(myPhrase);
			c64.setBackgroundColor(Color.WHITE);
			c64.disableBorderSide(Rectangle.BOTTOM);
		    c64.disableBorderSide(Rectangle.TOP);
			t.addCell(c64);
			
			myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c65 = new PdfPCell(myPhrase);
			c65.setBackgroundColor(Color.WHITE);
			t.addCell(c65);
			
			myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c66 = new PdfPCell(myPhrase);
			c66.setBackgroundColor(Color.WHITE);
			t.addCell(c66);
			
			myPhrase=new Phrase("       each reason separately",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c67 = new PdfPCell(myPhrase);
			c67.setBackgroundColor(Color.WHITE);
		    c67.disableBorderSide(Rectangle.TOP);
			t.addCell(c67);
			
			myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c68 = new PdfPCell(myPhrase);
			c68.setBackgroundColor(Color.WHITE);
			t.addCell(c68);
			
			myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c69 = new PdfPCell(myPhrase);
			c69.setBackgroundColor(Color.WHITE);
			t.addCell(c69);
			
			myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c70 = new PdfPCell(myPhrase);
			c70.setBorder(Rectangle.NO_BORDER);
			c70.setBackgroundColor(Color.WHITE);
			t.addCell(c70);
			
			myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c71 = new PdfPCell(myPhrase);
			c71.setBorder(Rectangle.NO_BORDER);
			c71.setBackgroundColor(Color.WHITE);
			t.addCell(c71);
			
			myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c72 = new PdfPCell(myPhrase);
			c72.setBorder(Rectangle.NO_BORDER);
			c72.setBackgroundColor(Color.WHITE);
			t.addCell(c72);
			
			myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c73 = new PdfPCell(myPhrase);
			c73.setBorder(Rectangle.NO_BORDER);
			c73.setBackgroundColor(Color.WHITE);
			t.addCell(c73);
			
			myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c74 = new PdfPCell(myPhrase);
			c74.setBorder(Rectangle.NO_BORDER);
			c74.setBackgroundColor(Color.WHITE);
			t.addCell(c74);
			
			myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c75 = new PdfPCell(myPhrase);
			c75.setBorder(Rectangle.NO_BORDER);
			c75.setBackgroundColor(Color.WHITE);
			t.addCell(c75);
			
			myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c76 = new PdfPCell(myPhrase);
			c76.setBorder(Rectangle.NO_BORDER);
			c76.setBackgroundColor(Color.WHITE);
			t.addCell(c76);
			
			myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c77 = new PdfPCell(myPhrase);
			c77.setBorder(Rectangle.NO_BORDER);
			c77.setBackgroundColor(Color.WHITE);
			t.addCell(c77);
			
			myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c78 = new PdfPCell(myPhrase);
			c78.setBorder(Rectangle.NO_BORDER);
			c78.setBackgroundColor(Color.WHITE);
			t.addCell(c78);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating PDF form for Mining :  " + e);
			e.printStackTrace();
		}
		return t;	
	}	
	
	 private PdfPTable createHeading4 () {

			float[] width = {100};
			PdfPTable header = new PdfPTable(1);
			try {
				
				header.setWidthPercentage(100);
				header.setWidths(width);
			    
				Phrase myPhrase=new Phrase("  5. (i) Average Daily Employment and Wages paid :",new Font(baseFont,font, Font.BOLD));
			    PdfPCell c = new PdfPCell(myPhrase);
			    c.disableBorderSide(Rectangle.BOTTOM);
			    c.disableBorderSide(Rectangle.TOP);
			    c.disableBorderSide(Rectangle.LEFT);
			    c.disableBorderSide(Rectangle.RIGHT);
			    c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c.setBackgroundColor(Color.WHITE);
			    header.addCell(c);
			    
			} catch (Exception e) {
				e.printStackTrace();
			}
			return header;
		}
	private PdfPTable createFormData2()
	{
		float[] widths = {15,30,30,30};
		PdfPTable t = new PdfPTable(4);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			
			Phrase myPhrase=new Phrase("  Work Place ",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c4 = new PdfPCell(myPhrase);
			c4.disableBorderSide(Rectangle.BOTTOM);
			c4.setBackgroundColor(Color.WHITE);
			t.addCell(c4);
			
			myPhrase=new Phrase("Direct",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c5 = new PdfPCell(myPhrase);
			c5.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c5.setBackgroundColor(Color.WHITE);
			t.addCell(c5);
			
			myPhrase=new Phrase("Contract",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c6 = new PdfPCell(myPhrase);
			c6.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c6.setBackgroundColor(Color.WHITE);
			t.addCell(c6);
			
			myPhrase=new Phrase("Wages(Rs.) ",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c7 = new PdfPCell(myPhrase);
			c7.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c7.setBackgroundColor(Color.WHITE);
			t.addCell(c7);
			
			
		}
		catch (Exception e) 
		{
			System.out.println("Error creating PDF form for Mining :  " + e);
			e.printStackTrace();
		}
		return t;	
	}
	
	@SuppressWarnings("unchecked")
	private PdfPTable createTableForEmploymentDetails(Map employeeDetails)
	{
		float[] widths = {30,30,30,30,30,30,30};
		PdfPTable t = new PdfPTable(7);
		
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c = new PdfPCell(myPhrase);
			c.disableBorderSide(Rectangle.TOP);
			c.setBackgroundColor(Color.WHITE);
			t.addCell(c);
			
			myPhrase=new Phrase("Male",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c2 = new PdfPCell(myPhrase);
			c2.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c2.setBackgroundColor(Color.WHITE);
			t.addCell(c2);
			
			myPhrase=new Phrase("Female",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c3 = new PdfPCell(myPhrase);
			c3.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c3.setBackgroundColor(Color.WHITE);
			t.addCell(c3);
			
			myPhrase=new Phrase("Male",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c4 = new PdfPCell(myPhrase);
			c4.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c4.setBackgroundColor(Color.WHITE);
			t.addCell(c4);
			
			myPhrase=new Phrase("Female",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c5 = new PdfPCell(myPhrase);
			c5.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c5.setBackgroundColor(Color.WHITE);
			t.addCell(c5);
			
			myPhrase=new Phrase("Direct",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c6 = new PdfPCell(myPhrase);
			c6.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c6.setBackgroundColor(Color.WHITE);
			t.addCell(c6);
			
			myPhrase=new Phrase("Contract",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c7 = new PdfPCell(myPhrase);
			c7.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c7.setBackgroundColor(Color.WHITE);
			t.addCell(c7);
			
			myPhrase=new Phrase("  Below ground",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c8 = new PdfPCell(myPhrase);
			c8.setBackgroundColor(Color.WHITE);
			t.addCell(c8);
			
			ArrayList<String> workPlaceDetails =new ArrayList<String>();
			workPlaceDetails=getdetails("BelowGround", employeeDetails);
			for(int i=0;i<workPlaceDetails.size();i++){
				myPhrase=new Phrase(workPlaceDetails.get(i),new Font(baseFont,font, Font.NORMAL));
				PdfPCell c9 = new PdfPCell(myPhrase);
				c9.setBackgroundColor(Color.WHITE);
				t.addCell(c9);
			}
			
			myPhrase=new Phrase("  Opencast",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c10 = new PdfPCell(myPhrase);
			c10.setBackgroundColor(Color.WHITE);
			t.addCell(c10);
			
			workPlaceDetails=getdetails("Opencast", employeeDetails);
			for(int i=0;i<workPlaceDetails.size();i++){
				myPhrase=new Phrase(workPlaceDetails.get(i),new Font(baseFont,font, Font.NORMAL));
				PdfPCell c11 = new PdfPCell(myPhrase);
				c11.setBackgroundColor(Color.WHITE);
				t.addCell(c11);
			}
			
			myPhrase=new Phrase("  Above ground",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c12 = new PdfPCell(myPhrase);
			c12.setBackgroundColor(Color.WHITE);
			t.addCell(c12);
			
			workPlaceDetails=getdetails("AboveGround", employeeDetails);
			for(int i=0;i<workPlaceDetails.size();i++){
				myPhrase=new Phrase(workPlaceDetails.get(i),new Font(baseFont,font, Font.NORMAL));
				PdfPCell c13 = new PdfPCell(myPhrase);
				c13.setBackgroundColor(Color.WHITE);
				t.addCell(c13);
			}
			
			myPhrase=new Phrase("  TOTAL",new Font(baseFont,font, Font.NORMAL));
			PdfPCell c14 = new PdfPCell(myPhrase);
			c14.setBackgroundColor(Color.WHITE);
			t.addCell(c14);
			
			workPlaceDetails=getdetails("TOTAL", employeeDetails);
			for(int i=0;i<workPlaceDetails.size();i++){
				myPhrase=new Phrase(workPlaceDetails.get(i),new Font(baseFont,font, Font.NORMAL));
				PdfPCell c15 = new PdfPCell(myPhrase);
				c15.setBackgroundColor(Color.WHITE);
				t.addCell(c15);
			}
		}
		catch (Exception e) 
		{
			System.out.println("Error creating PDF form for Mining :  " + e);
			e.printStackTrace();
		}
		return t;	
	}
	
	
	 private PdfPTable createHeader (String month,String year,String region,String pin,String nameOfMineral) {

			float[] width = {100};
			PdfPTable maintable = new PdfPTable(1);
			String form="";
			if(nameOfMineral.equals("Iron Ore")){
				form ="FORM F-1";
			}
			if(nameOfMineral.equals("Bauxite/Laterite")){
				form="FORM F-3";
			}
			if(nameOfMineral.equals("Manganese")){
				form="FORM F-2";
			}
			try {
				
				maintable.setWidthPercentage(100);
				maintable.setWidths(width);
				
				Phrase myPhrase=new Phrase(form,new Font(baseFont,13, Font.BOLD));
			    PdfPCell c = new PdfPCell(myPhrase);
			    c.setBorder(Rectangle.NO_BORDER);
			    c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c);
			    
			    myPhrase=new Phrase("For the month of "+month+" "+year,new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c1 = new PdfPCell(myPhrase);
			    c1.setBorder(Rectangle.NO_BORDER);
			    c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c1.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c1);
			    
			    myPhrase=new Phrase("",new Font(baseFont,10, Font.NORMAL));
			    PdfPCell c21 = new PdfPCell(myPhrase);
			    c21.setBorder(Rectangle.NO_BORDER);
			    c21.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c21.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c21);
			    
			    myPhrase=new Phrase("",new Font(baseFont,10, Font.NORMAL));
			    PdfPCell c2 = new PdfPCell(myPhrase);
			    c2.setBorder(Rectangle.NO_BORDER);
			    c2.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c2.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c2);
			    
			    myPhrase=new Phrase("MONTHLY RETURN",new Font(baseFont,11, Font.BOLD));
			    PdfPCell c3 = new PdfPCell(myPhrase);
			    c3.setBorder(Rectangle.NO_BORDER);
			    c3.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c3.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c3);
			    
			    myPhrase=new Phrase("[See rule 45(5)(a)(i)]",new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c4 = new PdfPCell(myPhrase);
			    c4.setBorder(Rectangle.NO_BORDER);
			    c4.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c4.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c4);
			    
			    myPhrase=new Phrase("",new Font(baseFont,10, Font.NORMAL));
			    PdfPCell c5 = new PdfPCell(myPhrase);
			    c5.setBorder(Rectangle.NO_BORDER);
			    c5.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c5.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c5);
			    
			    myPhrase=new Phrase("",new Font(baseFont,10, Font.NORMAL));
			    PdfPCell c6 = new PdfPCell(myPhrase);
			    c6.setBorder(Rectangle.NO_BORDER);
			    c6.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c6.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c6);
			    
			    myPhrase=new Phrase("(Read the instructions carefully before filling the particulars)",new Font(baseFont,font, Font.BOLD));
			    PdfPCell c7 = new PdfPCell(myPhrase);
			    c7.setBorder(Rectangle.NO_BORDER);
			    c7.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c7.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c7);
			    
			    myPhrase=new Phrase("To",new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c8 = new PdfPCell(myPhrase);
			    c8.setBorder(Rectangle.NO_BORDER);
			    c8.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c8.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c8);
			    
			    myPhrase=new Phrase("(i)    The Regional Controller Of Mines ",new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c9 = new PdfPCell(myPhrase);
			    c9.setBorder(Rectangle.NO_BORDER);
			    c9.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c9.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c9);
			    
			    myPhrase=new Phrase("        Indian Bureau of Mines ",new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c10 = new PdfPCell(myPhrase);
			    c10.setBorder(Rectangle.NO_BORDER);
			    c10.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c10.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c10);
			    
			    myPhrase=new Phrase( "        "+  region+"  Region, ",new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c11 = new PdfPCell(myPhrase);
			    c11.setBorder(Rectangle.NO_BORDER);
			    c11.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c11.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c11);
			    
			    myPhrase=new Phrase("        PIN : "+pin,new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c12 = new PdfPCell(myPhrase);
			    c12.setBorder(Rectangle.NO_BORDER);
			    c12.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c12.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c12);
			    
			    myPhrase=new Phrase("        (Please address to Regional Controller of mines in whose territorial jurisdiction the mines falls as notified from time to",new Font(baseFont,font, Font.ITALIC));
			    PdfPCell c13 = new PdfPCell(myPhrase);
			    c13.setBorder(Rectangle.NO_BORDER);
			    c13.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c13.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c13);
			    
			    myPhrase=new Phrase("        time by the Controller General,Indian Bureau of Mines under Rule 62 of the Mineral Conservation and",new Font(baseFont,font, Font.ITALIC));
			    PdfPCell c013 = new PdfPCell(myPhrase); 
			    c013.setBorder(Rectangle.NO_BORDER);
			    c013.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c013.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c013);
			    
			    myPhrase=new Phrase("        Development rules ,1988) ",new Font(baseFont,font, Font.ITALIC));
			    PdfPCell c0013 = new PdfPCell(myPhrase);
			    c0013.setBorder(Rectangle.NO_BORDER);
			    c0013.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c0013.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c0013);
			    
			    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c19 = new PdfPCell(myPhrase);
			    c19.setBorder(Rectangle.NO_BORDER);
			    c19.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c19.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c19);
			    
			    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c20 = new PdfPCell(myPhrase);
			    c20.setBorder(Rectangle.NO_BORDER);
			    c20.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c20.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c20);
			    
			    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c021 = new PdfPCell(myPhrase);
			    c021.setBorder(Rectangle.NO_BORDER);
			    c021.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c021.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c021); 
			    
			    myPhrase=new Phrase("(ii)    The State Government ",new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c14 = new PdfPCell(myPhrase);
			    c14.setBorder(Rectangle.NO_BORDER);
			    c14.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c14.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c14);
			    
			    myPhrase=new Phrase("PART-I",new Font(baseFont,font, Font.BOLD));
			    PdfPCell c15 = new PdfPCell(myPhrase);
			    c15.setBorder(Rectangle.NO_BORDER);
			    c15.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c15.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c15);
			    
			    myPhrase=new Phrase("(General and Labour) ",new Font(baseFont,font, Font.BOLD));
			    PdfPCell c16 = new PdfPCell(myPhrase);
			    c16.setBorder(Rectangle.NO_BORDER);
			    c16.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c16.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c16);
			    
			    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c17 = new PdfPCell(myPhrase);
			    c17.setBorder(Rectangle.NO_BORDER);
			    c17.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c17.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c17);
			    
			    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c18 = new PdfPCell(myPhrase);
			    c18.setBorder(Rectangle.NO_BORDER);
			    c18.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c18.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c18);
			    
			} catch (Exception e) {
				e.printStackTrace();
			}
			return maintable;
		}
	 
	 private PdfPTable createHeading1 (String nameOfMineral) {

			float[] width = {100};
			PdfPTable header = new PdfPTable(1);
			String headingf3="";
			if(nameOfMineral.equals("Iron Ore")){
				headingf3 ="3.Grade-wise Production,Despatches,Stocks and Ex-mine prices of Processed ore : ";
			}
			if(nameOfMineral.equals("Bauxite/Laterite") || nameOfMineral.equals("Manganese")){
				headingf3="2.Grade-wise Production,Despatches,Stocks and Ex-mine prices of Processed ore : ";
			}
			try {
				
				header.setWidthPercentage(100);
				header.setWidths(width);
			    
				Phrase myPhrase=new Phrase("",new Font(baseFont,font, Font.BOLD));
			    PdfPCell c0 = new PdfPCell(myPhrase);
			    c0.disableBorderSide(Rectangle.BOTTOM);
			    c0.disableBorderSide(Rectangle.LEFT);
			    c0.disableBorderSide(Rectangle.RIGHT);
			    c0.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c0.setBackgroundColor(Color.WHITE);
			    header.addCell(c0);

				myPhrase=new Phrase("",new Font(baseFont,font, Font.BOLD));
			    PdfPCell c01 = new PdfPCell(myPhrase);
			    c01.disableBorderSide(Rectangle.BOTTOM);
			    c01.disableBorderSide(Rectangle.LEFT);
			    c01.disableBorderSide(Rectangle.RIGHT);
			    c01.disableBorderSide(Rectangle.TOP);
			    c01.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c01.setBackgroundColor(Color.WHITE);
			    header.addCell(c01);

			    myPhrase=new Phrase("",new Font(baseFont,font, Font.BOLD));
			    PdfPCell c02 = new PdfPCell(myPhrase);
			    c02.disableBorderSide(Rectangle.BOTTOM);
			    c02.disableBorderSide(Rectangle.LEFT);
			    c02.disableBorderSide(Rectangle.RIGHT);
			    c02.disableBorderSide(Rectangle.TOP);
			    c02.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c02.setBackgroundColor(Color.WHITE);
			    header.addCell(c02);
			    
				myPhrase=new Phrase(headingf3,new Font(baseFont,font, Font.BOLD));
			    PdfPCell c = new PdfPCell(myPhrase);
			    c.disableBorderSide(Rectangle.BOTTOM);
			    c.disableBorderSide(Rectangle.LEFT);
			    c.disableBorderSide(Rectangle.RIGHT);
			    c.disableBorderSide(Rectangle.TOP);
			    c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c.setBackgroundColor(Color.WHITE);
			    header.addCell(c);
			    
			} catch (Exception e) {
				e.printStackTrace();
			}
			return header;
		}
	 
	 private PdfPTable createHeading2 (String nameOfMineral) {

			float[] width = {100};
			PdfPTable header = new PdfPTable(1);
			String headingf4="";
			if(nameOfMineral.equals("Iron Ore")){
				headingf4 ="4.Details of Deductions used for computation of Sale price(Ex-mine)(Rs/Tonne) : ";
			}
			if(nameOfMineral.equals("Bauxite/Laterite") || nameOfMineral.equals("Manganese")){
				headingf4="3.Details of Deductions used for computation of Sale price(Ex-mine)(Rs/Metric Tonne) : " ;
			}
			try {
				
				header.setWidthPercentage(100);
				header.setWidths(width);
			    
				Phrase myPhrase=new Phrase("",new Font(baseFont,font, Font.BOLD));
			    PdfPCell c01 = new PdfPCell(myPhrase);
			    c01.disableBorderSide(Rectangle.BOTTOM);
			    c01.disableBorderSide(Rectangle.LEFT);
			    c01.disableBorderSide(Rectangle.RIGHT);
			    c01.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c01.setBackgroundColor(Color.WHITE);
			    header.addCell(c01);
			    
			    myPhrase=new Phrase("",new Font(baseFont,font, Font.BOLD));
			    PdfPCell c02 = new PdfPCell(myPhrase);
			    c02.disableBorderSide(Rectangle.BOTTOM);
			    c02.disableBorderSide(Rectangle.LEFT);
			    c02.disableBorderSide(Rectangle.RIGHT);
			    c02.disableBorderSide(Rectangle.TOP);
			    c02.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c02.setBackgroundColor(Color.WHITE);
			    header.addCell(c02);
			    
				myPhrase=new Phrase("",new Font(baseFont,font, Font.BOLD));
			    PdfPCell c0 = new PdfPCell(myPhrase);
			    c0.disableBorderSide(Rectangle.BOTTOM);
			    c0.disableBorderSide(Rectangle.LEFT);
			    c0.disableBorderSide(Rectangle.RIGHT);
			    c0.disableBorderSide(Rectangle.TOP);
			    c0.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c0.setBackgroundColor(Color.WHITE);
			    header.addCell(c0);
				    
			    myPhrase=new Phrase(headingf4,new Font(baseFont,font, Font.BOLD));
			    PdfPCell c = new PdfPCell(myPhrase);
			    c.disableBorderSide(Rectangle.BOTTOM);
			    c.disableBorderSide(Rectangle.LEFT);
			    c.disableBorderSide(Rectangle.TOP);
			    c.disableBorderSide(Rectangle.RIGHT);
			    c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c.setBackgroundColor(Color.WHITE);
			    header.addCell(c);
			    
			} catch (Exception e) {
				e.printStackTrace();
			}
			return header;
		}
	 
	 @SuppressWarnings("unchecked")
	private PdfPTable createTableForGradeWiseProductionIron(Map productionDetails)
		{
			float[] widths = {40,30,30,30,30,30};
			PdfPTable t = new PdfPTable(6);
			
			try
			{
				t.setWidthPercentage(100);
				t.setWidths(widths);
				
				Phrase myPhrase=new Phrase("Grades(% of Fe content)",new Font(baseFont,font, Font.BOLD));
				PdfPCell c = new PdfPCell(myPhrase);
				c.setBackgroundColor(Color.WHITE);
				t.addCell(c);
				
				myPhrase=new Phrase("Opening stock at mine- head",new Font(baseFont,font, Font.BOLD));
				PdfPCell c2 = new PdfPCell(myPhrase);
				c2.setBackgroundColor(Color.WHITE);
				t.addCell(c2);
				
				myPhrase=new Phrase("Production",new Font(baseFont, font, Font.BOLD));
				PdfPCell c3 = new PdfPCell(myPhrase);
				c3.setBackgroundColor(Color.WHITE);
				t.addCell(c3);
				
				myPhrase=new Phrase("Despatches from mine head",new Font(baseFont,font, Font.BOLD));
				PdfPCell c4 = new PdfPCell(myPhrase);
				c4.setBackgroundColor(Color.WHITE);
				t.addCell(c4);
				
				myPhrase=new Phrase("Closing stock at mine -head",new Font(baseFont, font, Font.BOLD));
				PdfPCell c5 = new PdfPCell(myPhrase);
				c5.setBackgroundColor(Color.WHITE);
				t.addCell(c5);
				
				myPhrase=new Phrase("Ex-mine price(Rs./MT)",new Font(baseFont,font, Font.BOLD));
				PdfPCell c6 = new PdfPCell(myPhrase);
				c6.setBackgroundColor(Color.WHITE);
				t.addCell(c6);
				
				myPhrase=new Phrase("(i)Lumps:",new Font(baseFont, font, Font.BOLD));
				PdfPCell cl = new PdfPCell(myPhrase);
				cl.setBackgroundColor(Color.WHITE);
			    cl.disableBorderSide(Rectangle.LEFT);
			    cl.disableBorderSide(Rectangle.RIGHT);
				t.addCell(cl);
			
				myPhrase=new Phrase("",new Font(baseFont,(float)7.5, Font.NORMAL));
				PdfPCell cl1 = new PdfPCell(myPhrase);
			    cl1.disableBorderSide(Rectangle.LEFT);
			    cl1.disableBorderSide(Rectangle.RIGHT);
				cl1.setBackgroundColor(Color.WHITE);
				t.addCell(cl1);
				
				myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
				PdfPCell cl2 = new PdfPCell(myPhrase);
			    cl2.disableBorderSide(Rectangle.LEFT);
			    cl2.disableBorderSide(Rectangle.RIGHT);
				cl2.setBackgroundColor(Color.WHITE);
				t.addCell(cl2);
				
				myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				PdfPCell cl3 = new PdfPCell(myPhrase);
			    cl3.disableBorderSide(Rectangle.LEFT);
			    cl3.disableBorderSide(Rectangle.RIGHT);
				cl3.setBackgroundColor(Color.WHITE);
				t.addCell(cl3);
				
				myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
				PdfPCell cl4 = new PdfPCell(myPhrase);
			    cl4.disableBorderSide(Rectangle.LEFT);
			    cl4.disableBorderSide(Rectangle.RIGHT);
				cl4.setBackgroundColor(Color.WHITE);
				t.addCell(cl4);
				
				myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				PdfPCell cl5 = new PdfPCell(myPhrase);
			    cl5.disableBorderSide(Rectangle.LEFT);
			    cl5.disableBorderSide(Rectangle.RIGHT);
				cl5.setBackgroundColor(Color.WHITE);
				t.addCell(cl5);
		
				myPhrase=new Phrase("  (a)Below 55%",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c7 = new PdfPCell(myPhrase);
				c7.setBackgroundColor(Color.WHITE);
				t.addCell(c7);
				
				ArrayList<String> gradeDetails =new ArrayList<String>();
				gradeDetails=getGradeStructure("Fe:Lumps:Below55%", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c9 = new PdfPCell(myPhrase);
					c9.setBackgroundColor(Color.WHITE);
					t.addCell(c9);
				}
			
				myPhrase=new Phrase("  (b)55% to below 58%",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c13 = new PdfPCell(myPhrase);
				c13.setBackgroundColor(Color.WHITE);
				t.addCell(c13);
				
				gradeDetails=getGradeStructure("Fe:Lumps:55%toBelow58%", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c09 = new PdfPCell(myPhrase);
					c09.setBackgroundColor(Color.WHITE);
					t.addCell(c09);
				}
				myPhrase=new Phrase("  (c)58% to below 60%",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c19 = new PdfPCell(myPhrase);
				c19.setBackgroundColor(Color.WHITE);
				t.addCell(c19);
				
				gradeDetails=getGradeStructure("Fe:Lumps:58%toBelow60%", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}	
				myPhrase=new Phrase("  (d)60% to below 62%",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c26 = new PdfPCell(myPhrase);
				c26.setBackgroundColor(Color.WHITE);
				t.addCell(c26);
				
				gradeDetails=getGradeStructure("Fe:Lumps:60%toBelow62%", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}		
				myPhrase=new Phrase("  (e)62% to below 65%",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c32 = new PdfPCell(myPhrase);
				c32.setBackgroundColor(Color.WHITE);
				t.addCell(c32);
				gradeDetails=getGradeStructure("Fe:Lumps:62%toBelow65%", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}	
				myPhrase=new Phrase("  (f)65% and above",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c38 = new PdfPCell(myPhrase);
				c38.setBackgroundColor(Color.WHITE);
				t.addCell(c38);
				
				gradeDetails=getGradeStructure("Fe:Lumps:65%andabove", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}	
				myPhrase=new Phrase("(ii)Fines:",new Font(baseFont, font, Font.BOLD));
				PdfPCell cm = new PdfPCell(myPhrase);
				cm.setBackgroundColor(Color.WHITE);
			    cm.disableBorderSide(Rectangle.LEFT);
			    cm.disableBorderSide(Rectangle.RIGHT);
				t.addCell(cm);
				
				myPhrase=new Phrase("",new Font(baseFont,(float)7.5, Font.NORMAL));
				PdfPCell cm1 = new PdfPCell(myPhrase);
			    cm1.disableBorderSide(Rectangle.LEFT);
			    cm1.disableBorderSide(Rectangle.RIGHT);
				cm1.setBackgroundColor(Color.WHITE);
				t.addCell(cm1);
				
				myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
				PdfPCell cm2 = new PdfPCell(myPhrase);
			    cm2.disableBorderSide(Rectangle.LEFT);
			    cm2.disableBorderSide(Rectangle.RIGHT);
				cm2.setBackgroundColor(Color.WHITE);
				t.addCell(cm2);
				
				myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				PdfPCell cm3 = new PdfPCell(myPhrase);
			    cm3.disableBorderSide(Rectangle.LEFT);
			    cm3.disableBorderSide(Rectangle.RIGHT);
				cm3.setBackgroundColor(Color.WHITE);
				t.addCell(cm3);
				
				myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
				PdfPCell cm4 = new PdfPCell(myPhrase);
			    cm4.disableBorderSide(Rectangle.LEFT);
			    cm4.disableBorderSide(Rectangle.RIGHT);
				cm4.setBackgroundColor(Color.WHITE);
				t.addCell(cm4);
				
				myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				PdfPCell cm5 = new PdfPCell(myPhrase);
			    cm5.disableBorderSide(Rectangle.LEFT);
			    cm5.disableBorderSide(Rectangle.RIGHT);
				cm5.setBackgroundColor(Color.WHITE);
				t.addCell(cm5);
				
				myPhrase=new Phrase("  (a)Below 55%",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c44 = new PdfPCell(myPhrase);
				c44.setBackgroundColor(Color.WHITE);
				t.addCell(c44);
				
				gradeDetails=getGradeStructure("Fe:Fines:Below55%", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}	
				myPhrase=new Phrase("  (b)55% to below 58%",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c50 = new PdfPCell(myPhrase);
				c50.setBackgroundColor(Color.WHITE);
				t.addCell(c50);
				gradeDetails=getGradeStructure("Fe:Fines:55%toBelow58%", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}	
				myPhrase=new Phrase("  (c)58% to below 60%",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c56 = new PdfPCell(myPhrase);
				c56.setBackgroundColor(Color.WHITE);
				t.addCell(c56);
				gradeDetails=getGradeStructure("Fe:Fines:58%toBelow60%", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}	
				myPhrase=new Phrase("  (d)60% to below 62%",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c62 = new PdfPCell(myPhrase);
				c62.setBackgroundColor(Color.WHITE);
				t.addCell(c62);
				gradeDetails=getGradeStructure("Fe:Fines:60%toBelow62%", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}	
				myPhrase=new Phrase("  (e)62% to below 65%",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c68 = new PdfPCell(myPhrase);
				c68.setBackgroundColor(Color.WHITE);
				t.addCell(c68);
				gradeDetails=getGradeStructure("Fe:Fines:62%toBelow65%", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}			
				myPhrase=new Phrase("  (f)65% and above",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c74 = new PdfPCell(myPhrase);
				c74.setBackgroundColor(Color.WHITE);
				t.addCell(c74);
				gradeDetails=getGradeStructure("Fe:Fines:65%andabove", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}	
				myPhrase=new Phrase("",new Font(baseFont, font, Font.BOLD));
				PdfPCell cm0 = new PdfPCell(myPhrase);
				cm0.setBackgroundColor(Color.WHITE);
				cm0.disableBorderSide(Rectangle.LEFT);
				cm0.disableBorderSide(Rectangle.RIGHT);
				t.addCell(cm0);
				
				myPhrase=new Phrase("",new Font(baseFont,(float)7.5, Font.NORMAL));
				PdfPCell cm01 = new PdfPCell(myPhrase);
				cm01.disableBorderSide(Rectangle.LEFT);
				cm01.disableBorderSide(Rectangle.RIGHT);
				cm01.setBackgroundColor(Color.WHITE);
				t.addCell(cm01);
				
				myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
				PdfPCell cm02 = new PdfPCell(myPhrase);
				cm02.disableBorderSide(Rectangle.LEFT);
				cm02.disableBorderSide(Rectangle.RIGHT);
				cm02.setBackgroundColor(Color.WHITE);
				t.addCell(cm02);
				
				myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				PdfPCell cm03 = new PdfPCell(myPhrase);
				cm03.disableBorderSide(Rectangle.LEFT);
				cm03.disableBorderSide(Rectangle.RIGHT);
				cm03.setBackgroundColor(Color.WHITE);
				t.addCell(cm03);
				
				myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
				PdfPCell cm04 = new PdfPCell(myPhrase);
				cm04.disableBorderSide(Rectangle.LEFT);
				cm04.disableBorderSide(Rectangle.RIGHT);
				cm04.setBackgroundColor(Color.WHITE);
				t.addCell(cm04);
				
				myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				PdfPCell cm05 = new PdfPCell(myPhrase);
				cm05.disableBorderSide(Rectangle.LEFT);
				cm05.disableBorderSide(Rectangle.RIGHT);
				cm05.setBackgroundColor(Color.WHITE);
				t.addCell(cm05);

				
				myPhrase=new Phrase("(iii)Concentrates",new Font(baseFont, font, Font.BOLD));
				PdfPCell c80 = new PdfPCell(myPhrase);
				c80.setBackgroundColor(Color.WHITE);
				t.addCell(c80);
				
				gradeDetails=getGradeStructure("Fe:Fines:65%andabove", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}	

			}
			catch (Exception e) 
			{
				System.out.println("Error creating PDF form for Mining  : " + e);
				e.printStackTrace();
			}
			return t;	
		}
	 
	 @SuppressWarnings("unchecked")
	private PdfPTable createTableForGradeWiseProductionManganese(Map productionDetails)
		{
			float[] widths = {40,30,30,30,30,30};
			PdfPTable t = new PdfPTable(6);
			
			try
			{
				t.setWidthPercentage(100);
				t.setWidths(widths);
				
				Phrase myPhrase=new Phrase("Grades(% of Mn content)",new Font(baseFont,font, Font.BOLD));
				PdfPCell c = new PdfPCell(myPhrase);
				c.setBackgroundColor(Color.WHITE);
				t.addCell(c);
				
				myPhrase=new Phrase("Opening stock at mine- head",new Font(baseFont,font, Font.BOLD));
				PdfPCell c2 = new PdfPCell(myPhrase);
				c2.setBackgroundColor(Color.WHITE);
				t.addCell(c2);
				
				myPhrase=new Phrase("Production",new Font(baseFont, font, Font.BOLD));
				PdfPCell c3 = new PdfPCell(myPhrase);
				c3.setBackgroundColor(Color.WHITE);
				t.addCell(c3);
				
				myPhrase=new Phrase("Despatches from mine head",new Font(baseFont,font, Font.BOLD));
				PdfPCell c4 = new PdfPCell(myPhrase);
				c4.setBackgroundColor(Color.WHITE);
				t.addCell(c4);
				
				myPhrase=new Phrase("Closing stock at mine -head",new Font(baseFont, font, Font.BOLD));
				PdfPCell c5 = new PdfPCell(myPhrase);
				c5.setBackgroundColor(Color.WHITE);
				t.addCell(c5);
				
				myPhrase=new Phrase("Ex-mine price(Rs./MT)",new Font(baseFont,font, Font.BOLD));
				PdfPCell c6 = new PdfPCell(myPhrase);
				c6.setBackgroundColor(Color.WHITE);
				t.addCell(c6);
				
				myPhrase=new Phrase("  (a)Below 25%",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c7 = new PdfPCell(myPhrase);
				c7.setBackgroundColor(Color.WHITE);
				t.addCell(c7);
				
				ArrayList<String> gradeDetails =new ArrayList<String>();
				gradeDetails=getGradeStructure("Mn:Below25%", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c9 = new PdfPCell(myPhrase);
					c9.setBackgroundColor(Color.WHITE);
					t.addCell(c9);
				}
			
				myPhrase=new Phrase("  (b)25% to below 35%",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c13 = new PdfPCell(myPhrase);
				c13.setBackgroundColor(Color.WHITE);
				t.addCell(c13);
				
				gradeDetails=getGradeStructure("Mn:25%toBelow35%", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c09 = new PdfPCell(myPhrase);
					c09.setBackgroundColor(Color.WHITE);
					t.addCell(c09);
				}
				myPhrase=new Phrase("  (c)35% to below 46%",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c19 = new PdfPCell(myPhrase);
				c19.setBackgroundColor(Color.WHITE);
				t.addCell(c19);
				
				gradeDetails=getGradeStructure("Mn:35%toBelow46%", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}	
				myPhrase=new Phrase("  (d)46% and Above",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c26 = new PdfPCell(myPhrase);
				c26.setBackgroundColor(Color.WHITE);
				t.addCell(c26);
				
				gradeDetails=getGradeStructure("Mn:46%andabove", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}		
				myPhrase=new Phrase("  (e)Dioxide ore",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c32 = new PdfPCell(myPhrase);
				c32.setBackgroundColor(Color.WHITE);
				t.addCell(c32);
				gradeDetails=getGradeStructure("Mn:Dioxideore", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}	
				myPhrase=new Phrase("  (f)Concentrates",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c38 = new PdfPCell(myPhrase);
				c38.setBackgroundColor(Color.WHITE);
				t.addCell(c38);
				
				gradeDetails=getGradeStructure("Mn:Concentrates", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}	

			}
			catch (Exception e) 
			{
				System.out.println("Error creating PDF form for Mining  : " + e);
				e.printStackTrace();
			}
			return t;	
		}
	 @SuppressWarnings("unchecked")
	private PdfPTable createTableForGradeWiseProductionBauxite(Map productionDetails)
		{
			float[] widths = {40,38,30,30,30,30};
			PdfPTable t = new PdfPTable(6);
			
			try
			{
				t.setWidthPercentage(100);
				t.setWidths(widths);
				
				Phrase myPhrase=new Phrase("Grades(% of Aluminium oxide content)",new Font(baseFont,font, Font.BOLD));
				PdfPCell c = new PdfPCell(myPhrase);
				c.setBackgroundColor(Color.WHITE);
				t.addCell(c);
				
				myPhrase=new Phrase("Opening stock at mine- head",new Font(baseFont,font, Font.BOLD));
				PdfPCell c2 = new PdfPCell(myPhrase);
				c2.setBackgroundColor(Color.WHITE);
				t.addCell(c2);
				
				myPhrase=new Phrase("Production",new Font(baseFont, font, Font.BOLD));
				PdfPCell c3 = new PdfPCell(myPhrase);
				c3.setBackgroundColor(Color.WHITE);
				t.addCell(c3);
				
				myPhrase=new Phrase("Despatches from mine head",new Font(baseFont,font, Font.BOLD));
				PdfPCell c4 = new PdfPCell(myPhrase);
				c4.setBackgroundColor(Color.WHITE);
				t.addCell(c4);
				
				myPhrase=new Phrase("Closing stock at mine -head",new Font(baseFont, font, Font.BOLD));
				PdfPCell c5 = new PdfPCell(myPhrase);
				c5.setBackgroundColor(Color.WHITE);
				t.addCell(c5);
				
				myPhrase=new Phrase("Ex-mine price(Rs./MT)",new Font(baseFont,font, Font.BOLD));
				PdfPCell c6 = new PdfPCell(myPhrase);
				c6.setBackgroundColor(Color.WHITE);
				t.addCell(c6);
				
				myPhrase=new Phrase("(A)    For use in alumina       extraction :",new Font(baseFont, font, Font.BOLD));
				PdfPCell cl = new PdfPCell(myPhrase);
				cl.setBackgroundColor(Color.WHITE);
				cl.disableBorderSide(Rectangle.BOTTOM);
			    cl.disableBorderSide(Rectangle.LEFT);
			    cl.disableBorderSide(Rectangle.RIGHT);
				t.addCell(cl);
				
			
				myPhrase=new Phrase("and aluminium",new Font(baseFont,font, Font.BOLD));
				PdfPCell cl1 = new PdfPCell(myPhrase);
			    cl1.disableBorderSide(Rectangle.LEFT);
			    cl1.disableBorderSide(Rectangle.BOTTOM);
			    cl1.disableBorderSide(Rectangle.RIGHT);
				cl1.setBackgroundColor(Color.WHITE);
				t.addCell(cl1);
				
				myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
				PdfPCell cl2 = new PdfPCell(myPhrase);
				cl2.disableBorderSide(Rectangle.BOTTOM);
			    cl2.disableBorderSide(Rectangle.LEFT);
			    cl2.disableBorderSide(Rectangle.RIGHT);
				cl2.setBackgroundColor(Color.WHITE);
				t.addCell(cl2);
				
				myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				PdfPCell cl3 = new PdfPCell(myPhrase);
				cl3.disableBorderSide(Rectangle.BOTTOM);
			    cl3.disableBorderSide(Rectangle.LEFT);
			    cl3.disableBorderSide(Rectangle.RIGHT);
				cl3.setBackgroundColor(Color.WHITE);
				t.addCell(cl3);
				
				myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
				PdfPCell cl4 = new PdfPCell(myPhrase);
				cl4.disableBorderSide(Rectangle.BOTTOM);
			    cl4.disableBorderSide(Rectangle.LEFT);
			    cl4.disableBorderSide(Rectangle.RIGHT);
				cl4.setBackgroundColor(Color.WHITE);
				t.addCell(cl4);
				
				myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				PdfPCell cl5 = new PdfPCell(myPhrase);
				cl5.disableBorderSide(Rectangle.BOTTOM);
			    cl5.disableBorderSide(Rectangle.LEFT);
			    cl5.disableBorderSide(Rectangle.RIGHT);
				cl5.setBackgroundColor(Color.WHITE);
				t.addCell(cl5);
		
				myPhrase=new Phrase("(Please furnish averages",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c0l = new PdfPCell(myPhrase);
				c0l.disableBorderSide(Rectangle.TOP);
				c0l.setBackgroundColor(Color.WHITE);
			    c0l.disableBorderSide(Rectangle.LEFT);
			    c0l.disableBorderSide(Rectangle.RIGHT);
				t.addCell(c0l);
				
			
				myPhrase=new Phrase("of the following ranges",new Font(baseFont,font, Font.NORMAL));
				PdfPCell c0l1 = new PdfPCell(myPhrase);
				c0l1.disableBorderSide(Rectangle.TOP);
			    c0l1.disableBorderSide(Rectangle.LEFT);
			    c0l1.disableBorderSide(Rectangle.RIGHT);
				c0l1.setBackgroundColor(Color.WHITE);
				t.addCell(c0l1);
				
				myPhrase=new Phrase("of grades):",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c0l2 = new PdfPCell(myPhrase);
				c0l2.disableBorderSide(Rectangle.TOP);
			    c0l2.disableBorderSide(Rectangle.LEFT);
			    c0l2.disableBorderSide(Rectangle.RIGHT);
				c0l2.setBackgroundColor(Color.WHITE);
				t.addCell(c0l2);
				
				myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				PdfPCell c0l3 = new PdfPCell(myPhrase);
				c0l3.disableBorderSide(Rectangle.TOP);
			    c0l3.disableBorderSide(Rectangle.LEFT);
			    c0l3.disableBorderSide(Rectangle.RIGHT);
				c0l3.setBackgroundColor(Color.WHITE);
				t.addCell(c0l3);
				
				myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c0l4 = new PdfPCell(myPhrase);
				c0l4.disableBorderSide(Rectangle.TOP);
			    c0l4.disableBorderSide(Rectangle.LEFT);
			    c0l4.disableBorderSide(Rectangle.RIGHT);
				c0l4.setBackgroundColor(Color.WHITE);
				t.addCell(c0l4);
				
				myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				PdfPCell c0l5 = new PdfPCell(myPhrase);
				c0l5.disableBorderSide(Rectangle.TOP);
			    c0l5.disableBorderSide(Rectangle.LEFT);
			    c0l5.disableBorderSide(Rectangle.RIGHT);
				c0l5.setBackgroundColor(Color.WHITE);
				t.addCell(c0l5);
				
				myPhrase=new Phrase("  (a)Below 40%",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c7 = new PdfPCell(myPhrase);
				c7.setBackgroundColor(Color.WHITE);
				t.addCell(c7);
				
				ArrayList<String> gradeDetails =new ArrayList<String>();
				gradeDetails=getGradeStructure("Al:Below40%", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c9 = new PdfPCell(myPhrase);
					c9.setBackgroundColor(Color.WHITE);
					t.addCell(c9);
				}
			
				myPhrase=new Phrase("  (b)40% to below 45%",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c13 = new PdfPCell(myPhrase);
				c13.setBackgroundColor(Color.WHITE);
				t.addCell(c13);
				
				gradeDetails=getGradeStructure("Al:40%toBelow45%", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c09 = new PdfPCell(myPhrase);
					c09.setBackgroundColor(Color.WHITE);
					t.addCell(c09);
				}
				myPhrase=new Phrase("  (c)45% to below 50%",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c19 = new PdfPCell(myPhrase);
				c19.setBackgroundColor(Color.WHITE);
				t.addCell(c19);
				
				gradeDetails=getGradeStructure("Al:45%toBelow50%", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}	
				myPhrase=new Phrase("  (d)50% to below 55%",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c26 = new PdfPCell(myPhrase);
				c26.setBackgroundColor(Color.WHITE);
				t.addCell(c26);
				
				gradeDetails=getGradeStructure("Al:50%toBelow55%", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}		
				myPhrase=new Phrase("  (e)55% to below 60%",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c32 = new PdfPCell(myPhrase);
				c32.setBackgroundColor(Color.WHITE);
				t.addCell(c32);
				gradeDetails=getGradeStructure("Al:55%toBelow60%", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}	
				myPhrase=new Phrase("  (f)60% and above",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c38 = new PdfPCell(myPhrase);
				c38.setBackgroundColor(Color.WHITE);
				t.addCell(c38);
				
				gradeDetails=getGradeStructure("Al:60%andabove", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}	
				myPhrase=new Phrase("(B)  For use Other than",new Font(baseFont, font, Font.BOLD));
				PdfPCell cm = new PdfPCell(myPhrase);
				cm.setBackgroundColor(Color.WHITE);
			    cm.disableBorderSide(Rectangle.LEFT);
			    cm.disableBorderSide(Rectangle.RIGHT);
				t.addCell(cm);
				
				myPhrase=new Phrase("alumina and aluminium",new Font(baseFont,(float)7.5, Font.BOLD));
				PdfPCell cm1 = new PdfPCell(myPhrase);
			    cm1.disableBorderSide(Rectangle.LEFT);
			    cm1.disableBorderSide(Rectangle.RIGHT);
				cm1.setBackgroundColor(Color.WHITE);
				t.addCell(cm1);
				
				myPhrase=new Phrase("metal extraction :",new Font(baseFont, font, Font.BOLD));
				PdfPCell cm2 = new PdfPCell(myPhrase);
			    cm2.disableBorderSide(Rectangle.LEFT);
			    cm2.disableBorderSide(Rectangle.RIGHT);
				cm2.setBackgroundColor(Color.WHITE);
				t.addCell(cm2);
				
				myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				PdfPCell cm3 = new PdfPCell(myPhrase);
			    cm3.disableBorderSide(Rectangle.LEFT);
			    cm3.disableBorderSide(Rectangle.RIGHT);
				cm3.setBackgroundColor(Color.WHITE);
				t.addCell(cm3);
				
				myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
				PdfPCell cm4 = new PdfPCell(myPhrase);
			    cm4.disableBorderSide(Rectangle.LEFT);
			    cm4.disableBorderSide(Rectangle.RIGHT);
				cm4.setBackgroundColor(Color.WHITE);
				t.addCell(cm4);
				
				myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				PdfPCell cm5 = new PdfPCell(myPhrase);
			    cm5.disableBorderSide(Rectangle.LEFT);
			    cm5.disableBorderSide(Rectangle.RIGHT);
				cm5.setBackgroundColor(Color.WHITE);
				t.addCell(cm5);
				
				myPhrase=new Phrase("  (a)Cement",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c44 = new PdfPCell(myPhrase);
				c44.setBackgroundColor(Color.WHITE);
				t.addCell(c44);
				
				gradeDetails=getGradeStructure("OtherthanAl:Cement", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}	
				myPhrase=new Phrase("  (b)Abrasive",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c50 = new PdfPCell(myPhrase);
				c50.setBackgroundColor(Color.WHITE);
				t.addCell(c50);
				gradeDetails=getGradeStructure("OtherthanAl:Abrasive", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}	
				myPhrase=new Phrase("  (c)Refractory",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c56 = new PdfPCell(myPhrase);
				c56.setBackgroundColor(Color.WHITE);
				t.addCell(c56);
				gradeDetails=getGradeStructure("OtherthanAl:Refactory", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}	
				myPhrase=new Phrase("  (d)Chemical",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c62 = new PdfPCell(myPhrase);
				c62.setBackgroundColor(Color.WHITE);
				t.addCell(c62);
				gradeDetails=getGradeStructure("OtherthanAl:Chemical", productionDetails);
				for(int i=0;i<gradeDetails.size();i++){
					myPhrase=new Phrase(gradeDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c100 = new PdfPCell(myPhrase);
					c100.setBackgroundColor(Color.WHITE);
					t.addCell(c100);
				}	
			}
			catch (Exception e) 
			{
				System.out.println("Error creating PDF form for Mining  : " + e);
				e.printStackTrace();
			}
			return t;	
		}
	 private PdfPTable createHeading3 (String nameOfMineral) {

			float[] width = {100};
			PdfPTable header = new PdfPTable(1);
			String headingf5="";
			if(nameOfMineral.equals("Iron Ore")){
				headingf5 ="5.Sales/Despatches effected for Domestic Consumption and for Exports: " ;
			}
			if(nameOfMineral.equals("Bauxite/Laterite") || nameOfMineral.equals("Manganese")){
				headingf5="4.Sales/Despatches effected for Domestic Consumption and for Exports:" ;
			}
			try {
				
				header.setWidthPercentage(100);
				header.setWidths(width);
				
				Phrase myPhrase=new Phrase("",new Font(baseFont,font, Font.BOLD));
			    PdfPCell c0 = new PdfPCell(myPhrase);
			    c0.disableBorderSide(Rectangle.BOTTOM);
			    c0.disableBorderSide(Rectangle.LEFT);
			    c0.disableBorderSide(Rectangle.RIGHT);
			    c0.disableBorderSide(Rectangle.TOP);
			    c0.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c0.setBackgroundColor(Color.WHITE);
			    header.addCell(c0);
			    
				myPhrase=new Phrase(headingf5,new Font(baseFont,font, Font.BOLD));
			    PdfPCell c = new PdfPCell(myPhrase);
			    c.disableBorderSide(Rectangle.BOTTOM);
			    c.disableBorderSide(Rectangle.LEFT);
			    c.disableBorderSide(Rectangle.TOP);
			    c.disableBorderSide(Rectangle.RIGHT);
			    c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c.setBackgroundColor(Color.WHITE);
			    header.addCell(c);
			    
			} catch (Exception e) {
				e.printStackTrace();
			}
			return header;
		}
	
	 private PdfPTable createFormData3 (String NoOfEmployee,String salary,String NameOfMineral,String ironOreMineralName) {

			float[] width = {100};
			PdfPTable maintable = new PdfPTable(1);
			String heading2="";
			if(NameOfMineral.equals("Iron Ore")){
				heading2="2.Production and Stocks of ROM ore at Mine-head";
			}
			if(NameOfMineral.equals("Bauxite/Laterite") || NameOfMineral.equals("Manganese")){
				heading2="1.Production and Stocks of ROM ore at Mine-head";
			}
			try {
				
				maintable.setWidthPercentage(100);
				maintable.setWidths(width);
				
				Phrase myPhrase=new Phrase("",new Font(baseFont,font, Font.BOLD));
			    PdfPCell c = new PdfPCell(myPhrase);
			    c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c.disableBorderSide(Rectangle.LEFT);
			    c.disableBorderSide(Rectangle.RIGHT);
			    c.disableBorderSide(Rectangle.BOTTOM);
			    c.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c);
			    
			    myPhrase=new Phrase("",new Font(baseFont,font, Font.BOLD));
			    PdfPCell c0 = new PdfPCell(myPhrase);
			    c0.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c0.setBorder(Rectangle.NO_BORDER);
			    c0.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c0);
			    
				myPhrase=new Phrase("     5.(ii)Total number of technical and supervisory staff employed in the mine during the month :"+NoOfEmployee,new Font(baseFont,font, Font.BOLD));
			    PdfPCell c01 = new PdfPCell(myPhrase);
			    c01.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c01.setBorder(Rectangle.NO_BORDER);
			    c01.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c01);
			    
			    myPhrase=new Phrase("",new Font(baseFont,font, Font.BOLD));
			    PdfPCell c02 = new PdfPCell(myPhrase);
			    c02.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c02.setBorder(Rectangle.NO_BORDER);
			    c02.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c02);
			    
			    myPhrase=new Phrase("       (iii)Total salaries paid to technical and supervisory staff employed in the mining during the month in Rs." +salary,new Font(baseFont,font, Font.BOLD));
			    PdfPCell c1 = new PdfPCell(myPhrase);
			    c1.setBorder(Rectangle.NO_BORDER);
			    c1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c1.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c1);
			    
			    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c21 = new PdfPCell(myPhrase);
			    c21.setBorder(Rectangle.NO_BORDER);
			    c21.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c21.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c21);
			    
			    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c22 = new PdfPCell(myPhrase);
			    c22.setBorder(Rectangle.NO_BORDER);
			    c22.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c22.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c22);
			    
			    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c23 = new PdfPCell(myPhrase);
			    c23.setBorder(Rectangle.NO_BORDER);
			    c23.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c23.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c23);
			    
			    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c24 = new PdfPCell(myPhrase);
			    c24.setBorder(Rectangle.NO_BORDER);
			    c24.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c24.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c24);
			    
			    myPhrase=new Phrase("PART-II (PRODUCTION,DESPATCHES AND STOCKS)",new Font(baseFont,font, Font.BOLD));
			    PdfPCell c2 = new PdfPCell(myPhrase);
			    c2.setBorder(Rectangle.NO_BORDER);
			    c2.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c2.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c2);
			    
			    myPhrase=new Phrase("(Unit of Quantity in Tonnes)",new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c3 = new PdfPCell(myPhrase);
			    c3.setBorder(Rectangle.NO_BORDER);
			    c3.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c3.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c3);
			    
			    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c25 = new PdfPCell(myPhrase);
			    c25.setBorder(Rectangle.NO_BORDER);
			    c25.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c25.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c25);
			    
			    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c26 = new PdfPCell(myPhrase);
			    c26.setBorder(Rectangle.NO_BORDER);
			    c26.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c26.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c26);
			    
			    if (NameOfMineral.equalsIgnoreCase("Iron Ore")) {
			    	 myPhrase=new Phrase("1.Type of ore produced:",new Font(baseFont,font, Font.BOLD));
					    PdfPCell c4 = new PdfPCell(myPhrase);
					    c4.setBorder(Rectangle.NO_BORDER);
					    c4.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
					    c4.setBackgroundColor(Color.WHITE);
					    maintable.addCell(c4);
					    
					    myPhrase=new Phrase("(a)"+ironOreMineralName,new Font(baseFont,font, Font.NORMAL));
					    PdfPCell c6 = new PdfPCell(myPhrase);
					    c6.setBorder(Rectangle.NO_BORDER);
					    c6.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
					    c6.setBackgroundColor(Color.WHITE);
					    maintable.addCell(c6);
				}
			    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c8 = new PdfPCell(myPhrase);
			    c8.setBorder(Rectangle.NO_BORDER);
			    c8.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c8.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c8);
			    
			    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
			    PdfPCell c9 = new PdfPCell(myPhrase);
			    c9.setBorder(Rectangle.NO_BORDER);
			    c9.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c9.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c9);
			    
			    myPhrase=new Phrase(heading2,new Font(baseFont,font, Font.BOLD));
			    PdfPCell c10 = new PdfPCell(myPhrase);
			    c10.setBorder(Rectangle.NO_BORDER);
			    c10.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c10.setBackgroundColor(Color.WHITE);
			    maintable.addCell(c10);
			    
			} catch (Exception e) {
				e.printStackTrace();
			}
			return maintable;
		}
	 @SuppressWarnings("unchecked")
	private PdfPTable createTableForProductionAndStocksDetailsFe(Map productionAndStocksDetails)
		{
			float[] widths = {30,20,20,20};
			PdfPTable t = new PdfPTable(4);
			
			try
			{
				t.setWidthPercentage(100);
				t.setWidths(widths);
				
				Phrase myPhrase1=new Phrase("Category",new Font(baseFont,font, Font.BOLD));
				PdfPCell c = new PdfPCell(myPhrase1);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.setBackgroundColor(Color.WHITE);
				t.addCell(c);
				
				Phrase myPhrase=new Phrase("Opening Stock",new Font(baseFont,font, Font.BOLD));
				PdfPCell c1 = new PdfPCell(myPhrase);
				c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.setBackgroundColor(Color.WHITE);
				t.addCell(c1);
				
				myPhrase1=new Phrase("Production",new Font(baseFont,font, Font.BOLD));
				PdfPCell c2 = new PdfPCell(myPhrase1);
				c2.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c2.setBackgroundColor(Color.WHITE);
				t.addCell(c2);
				
				myPhrase=new Phrase("Closing Stock",new Font(baseFont, font, Font.BOLD));
				PdfPCell c3 = new PdfPCell(myPhrase);
				c3.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c3.setBackgroundColor(Color.WHITE);
				t.addCell(c3);
				
				myPhrase=new Phrase("  (a)Open Cast Workings",new Font(baseFont,font, Font.NORMAL));
				PdfPCell c4 = new PdfPCell(myPhrase);
				c4.setBackgroundColor(Color.WHITE);
				t.addCell(c4);
				
				ArrayList<String> stockDetails =new ArrayList<String>();
				stockDetails=getStockStructure("OpenCastWorkings", productionAndStocksDetails);
				for(int i=0;i<stockDetails.size();i++){
					myPhrase=new Phrase(stockDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c9 = new PdfPCell(myPhrase);
					c9.setBackgroundColor(Color.WHITE);
					t.addCell(c9);
				}
				
				myPhrase=new Phrase("  (b)Dump Workings",new Font(baseFont,font, Font.NORMAL));
				PdfPCell c8 = new PdfPCell(myPhrase);
				c8.setBackgroundColor(Color.WHITE);
				t.addCell(c8);
				
				stockDetails=getStockStructure("DumpWorkings", productionAndStocksDetails);
				for(int i=0;i<stockDetails.size();i++){
					myPhrase=new Phrase(stockDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c10 = new PdfPCell(myPhrase);
					c10.setBackgroundColor(Color.WHITE);
					t.addCell(c10);
				}
			}
			catch (Exception e) 
			{
				System.out.println("Error creating PDF form for Mining :  " + e);
				e.printStackTrace();
			}
			return t;	
		}
	 @SuppressWarnings("unchecked")
	private PdfPTable createTableForProductionAndStocksDetailsBu(Map productionAndStocksDetails)
		{
			float[] widths = {30,20,20,20};
			PdfPTable t = new PdfPTable(4);
			
			try
			{
				t.setWidthPercentage(100);
				t.setWidths(widths);
				
				Phrase myPhrase1=new Phrase("Category",new Font(baseFont,font, Font.BOLD));
				PdfPCell c = new PdfPCell(myPhrase1);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.setBackgroundColor(Color.WHITE);
				t.addCell(c);
				
				Phrase myPhrase=new Phrase("Opening Stock",new Font(baseFont,font, Font.BOLD));
				PdfPCell c1 = new PdfPCell(myPhrase);
				c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.setBackgroundColor(Color.WHITE);
				t.addCell(c1);
				
				myPhrase1=new Phrase("Production",new Font(baseFont,font, Font.BOLD));
				PdfPCell c2 = new PdfPCell(myPhrase1);
				c2.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c2.setBackgroundColor(Color.WHITE);
				t.addCell(c2);
				
				myPhrase=new Phrase("Closing Stock",new Font(baseFont, font, Font.BOLD));
				PdfPCell c3 = new PdfPCell(myPhrase);
				c3.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c3.setBackgroundColor(Color.WHITE);
				t.addCell(c3);
				
				myPhrase=new Phrase("  (a)Open Cast Workings",new Font(baseFont,font, Font.NORMAL));
				PdfPCell c4 = new PdfPCell(myPhrase);
				c4.setBackgroundColor(Color.WHITE);
				t.addCell(c4);
				
				ArrayList<String> stockDetails =new ArrayList<String>();
				stockDetails=getStockStructure("OpenCastWorkings", productionAndStocksDetails);
				for(int i=0;i<stockDetails.size();i++){
					myPhrase=new Phrase(stockDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c9 = new PdfPCell(myPhrase);
					c9.setBackgroundColor(Color.WHITE);
					t.addCell(c9);
				}
				
				myPhrase=new Phrase("  (b)From UnderGround Workings",new Font(baseFont,font, Font.NORMAL));
				PdfPCell c04 = new PdfPCell(myPhrase);
				c04.setBackgroundColor(Color.WHITE);
				t.addCell(c04);
				
				stockDetails=getStockStructure("FromUndergroundWorkings", productionAndStocksDetails);
				for(int i=0;i<stockDetails.size();i++){
					myPhrase=new Phrase(stockDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c09 = new PdfPCell(myPhrase);
					c09.setBackgroundColor(Color.WHITE);
					t.addCell(c09);
				}
				
				myPhrase=new Phrase("  (c)Dump Workings",new Font(baseFont,font, Font.NORMAL));
				PdfPCell c8 = new PdfPCell(myPhrase);
				c8.setBackgroundColor(Color.WHITE);
				t.addCell(c8);
				
				stockDetails=getStockStructure("DumpWorkings", productionAndStocksDetails);
				for(int i=0;i<stockDetails.size();i++){
					myPhrase=new Phrase(stockDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c10 = new PdfPCell(myPhrase);
					c10.setBackgroundColor(Color.WHITE);
					t.addCell(c10);
				}
			}
			catch (Exception e) 
			{
				System.out.println("Error creating PDF form for Mining :  " + e);
				e.printStackTrace();
			}
			return t;	
		}

	 @SuppressWarnings("unchecked")
	private PdfPTable createTableForProductionAndStocksDetailsMn(Map productionAndStocksDetails)
		{
			float[] widths = {30,20,20,20};
			PdfPTable t = new PdfPTable(4);
			
			try
			{
				t.setWidthPercentage(100);
				t.setWidths(widths);
				
				Phrase myPhrase1=new Phrase("Category",new Font(baseFont,font, Font.BOLD));
				PdfPCell c = new PdfPCell(myPhrase1);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.setBackgroundColor(Color.WHITE);
				t.addCell(c);
				
				Phrase myPhrase=new Phrase("Opening Stock",new Font(baseFont,font, Font.BOLD));
				PdfPCell c1 = new PdfPCell(myPhrase);
				c1.setBackgroundColor(Color.WHITE);
				c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c1);
				
				myPhrase1=new Phrase("Production",new Font(baseFont,font, Font.BOLD));
				PdfPCell c2 = new PdfPCell(myPhrase1);
				c2.setBackgroundColor(Color.WHITE);
				c2.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c2);
				
				myPhrase=new Phrase("Closing Stock",new Font(baseFont, font, Font.BOLD));
				PdfPCell c3 = new PdfPCell(myPhrase);
				c3.setBackgroundColor(Color.WHITE);
				c3.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c3);
				
				myPhrase=new Phrase("  (a)Open Cast Workings",new Font(baseFont,font, Font.NORMAL));
				PdfPCell c4 = new PdfPCell(myPhrase);
				c4.setBackgroundColor(Color.WHITE);
				t.addCell(c4);
				
				ArrayList<String> stockDetails =new ArrayList<String>();
				stockDetails=getStockStructure("OpenCastWorkings", productionAndStocksDetails);
				for(int i=0;i<stockDetails.size();i++){
					myPhrase=new Phrase(stockDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c9 = new PdfPCell(myPhrase);
					c9.setBackgroundColor(Color.WHITE);
					t.addCell(c9);
				}
				
				myPhrase=new Phrase("  (b)Under Ground Workings",new Font(baseFont,font, Font.NORMAL));
				PdfPCell c08 = new PdfPCell(myPhrase);
				c08.setBackgroundColor(Color.WHITE);
				t.addCell(c08);
				
				stockDetails=getStockStructure("UndergroundWorkings", productionAndStocksDetails);
				for(int i=0;i<stockDetails.size();i++){
					myPhrase=new Phrase(stockDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c10 = new PdfPCell(myPhrase);
					c10.setBackgroundColor(Color.WHITE);
					t.addCell(c10);
				}
				
				myPhrase=new Phrase("  (c)Dump Workings",new Font(baseFont,font, Font.NORMAL));
				PdfPCell c8 = new PdfPCell(myPhrase);
				c8.setBackgroundColor(Color.WHITE);
				t.addCell(c8);
				
				stockDetails=getStockStructure("DumpWorkings", productionAndStocksDetails);
				for(int i=0;i<stockDetails.size();i++){
					myPhrase=new Phrase(stockDetails.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c10 = new PdfPCell(myPhrase);
					c10.setBackgroundColor(Color.WHITE);
					t.addCell(c10);
				}
			}
			catch (Exception e) 
			{
				System.out.println("Error creating PDF form for Mining :  " + e);
				e.printStackTrace();
			}
			return t;	
		}

		@SuppressWarnings({ "unchecked" })
		private PdfPTable createTableForDeduction(Map deductionDetails,String mineralName)
		{
			float[] widths = {50,30,70};
			PdfPTable t = new PdfPTable(3);
			String unit=null;

			if(mineralName.equals("Iron Ore")){
			unit="Unit(in Rs/Tonne)";
	     }
			if(mineralName.equals("Bauxite/Laterite")){
			unit="Unit(in Rs/Metric Tonne)";
		}
			if(mineralName.equals("Manganese")){
			unit="Unit(in Rs/Metric Tonne)";
		}
			try
			{
				t.setWidthPercentage(100);
				t.setWidths(widths);
				
				Phrase myPhrase=new Phrase("  Deduction claimed",new Font(baseFont,font, Font.NORMAL));
				PdfPCell c = new PdfPCell(myPhrase);
				c.setBackgroundColor(Color.WHITE);
				t.addCell(c);
				
				myPhrase=new Phrase(unit,new Font(baseFont,font, Font.NORMAL));
				PdfPCell c2 = new PdfPCell(myPhrase);
				c2.setBackgroundColor(Color.WHITE);
				t.addCell(c2);
				
				myPhrase=new Phrase("Remarks",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c3 = new PdfPCell(myPhrase);
				c3.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c3.setBackgroundColor(Color.WHITE);
				t.addCell(c3);
				
				myPhrase=new Phrase("  (a)Cost of transportation (indicate Loading station and Distance from mine in remarks)",new Font(baseFont,font, Font.NORMAL));
				PdfPCell c4 = new PdfPCell(myPhrase);
				c4.setBackgroundColor(Color.WHITE);
				t.addCell(c4);
				
				ArrayList<String> deduction =new ArrayList<String>();
				deduction=getDeductionStructure("(a)CostofTransportation(indicateLoadingstationandDistancefromminesinremarks)", deductionDetails);
				for(int i=0;i<deduction.size();i++){
					myPhrase=new Phrase(deduction.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c9 = new PdfPCell(myPhrase);
					c9.setBackgroundColor(Color.WHITE);
					t.addCell(c9);
				}
				
				myPhrase=new Phrase("  (b)Loading and Unloading charges",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c7 = new PdfPCell(myPhrase);
				c7.setBackgroundColor(Color.WHITE);
				t.addCell(c7);
				
				deduction=getDeductionStructure("(b)LoadingandunloadingCharges", deductionDetails);
				for(int i=0;i<deduction.size();i++){
					myPhrase=new Phrase(deduction.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c9 = new PdfPCell(myPhrase);
					c9.setBackgroundColor(Color.WHITE);
					t.addCell(c9);
				}
				
				myPhrase=new Phrase("  (c)Railway freight,if applicable(indicate destination and distance)",new Font(baseFont,font, Font.NORMAL));
				PdfPCell c10 = new PdfPCell(myPhrase);
				c10.setBackgroundColor(Color.WHITE);
				t.addCell(c10);
				
				deduction=getDeductionStructure("(c)Railwayfreight,ifapplicable(indicatedestinationanddistance)", deductionDetails);
				for(int i=0;i<deduction.size();i++){
					myPhrase=new Phrase(deduction.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c9 = new PdfPCell(myPhrase);
					c9.setBackgroundColor(Color.WHITE);
					t.addCell(c9);
				}
				
				myPhrase=new Phrase("  (d)Port Handling charges/export duty(indicate name of port)",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c13 = new PdfPCell(myPhrase);
				c13.setBackgroundColor(Color.WHITE);
				t.addCell(c13);
				
				deduction=getDeductionStructure("(d)PortHandlingcharges/exportduty(idicatenameofport)", deductionDetails);
				for(int i=0;i<deduction.size();i++){
					myPhrase=new Phrase(deduction.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c9 = new PdfPCell(myPhrase);
					c9.setBackgroundColor(Color.WHITE);
					t.addCell(c9);
				}

				myPhrase=new Phrase("  (e)Charges for Sampling and Analysis",new Font(baseFont,font, Font.NORMAL));
				PdfPCell c16 = new PdfPCell(myPhrase);
				c16.setBackgroundColor(Color.WHITE);
				t.addCell(c16);
				
				deduction=getDeductionStructure("(e)ChargesforSamplingandAnalysis", deductionDetails);
				for(int i=0;i<deduction.size();i++){
					myPhrase=new Phrase(deduction.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c9 = new PdfPCell(myPhrase);
					c9.setBackgroundColor(Color.WHITE);
					t.addCell(c9);
				}
				
				myPhrase=new Phrase("  (f)Rent for the plot at Stocking yard",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c19 = new PdfPCell(myPhrase);
				c19.setBackgroundColor(Color.WHITE);
				t.addCell(c19);
				
				deduction=getDeductionStructure("(f)Rentfortheplotatstockingyard", deductionDetails);
				for(int i=0;i<deduction.size();i++){
					myPhrase=new Phrase(deduction.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c9 = new PdfPCell(myPhrase);
					c9.setBackgroundColor(Color.WHITE);
					t.addCell(c9);
				}
				
				myPhrase=new Phrase("  (g)Other charges(specify clearly)",new Font(baseFont,font, Font.NORMAL));
				PdfPCell c23 = new PdfPCell(myPhrase);
				c23.setBackgroundColor(Color.WHITE);
				t.addCell(c23);
				
				deduction=getDeductionStructure("(g)Othercharges(SpecifyClearly)", deductionDetails);
				for(int i=0;i<deduction.size();i++){
					myPhrase=new Phrase(deduction.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c9 = new PdfPCell(myPhrase);
					c9.setBackgroundColor(Color.WHITE);
					t.addCell(c9);
				}
				
				myPhrase=new Phrase("      Total (a)to (g)",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c26 = new PdfPCell(myPhrase);
				c26.setBackgroundColor(Color.WHITE);
				t.addCell(c26);

				deduction=getDeductionStructure("Total(a)to(g)", deductionDetails);
				for(int i=0;i<deduction.size();i++){
					myPhrase=new Phrase(deduction.get(i),new Font(baseFont,font, Font.NORMAL));
					PdfPCell c9 = new PdfPCell(myPhrase);
					c9.setBackgroundColor(Color.WHITE);
					t.addCell(c9);
				}

				
			}
			catch (Exception e) 
			{
				System.out.println("Error creating PDF form for Mining :  " + e);
				e.printStackTrace();
			}
			return t;	
		}

		 private PdfPTable createForReasons (String gradeReason,String productioReason,String nameOfMineral) {

				float[] width = {100};
				PdfPTable maintable = new PdfPTable(1);
				String no1="";
				String no="";
				if(nameOfMineral.equals("Iron Ore")){
					no ="6";
					no1="7";
				}
				if(nameOfMineral.equals("Bauxite/Laterite") || nameOfMineral.equals("Manganese")){
					no ="5";
					no1="6";
				}
				try {
					
					maintable.setWidthPercentage(100);
					maintable.setWidths(width);
					
				    Phrase myPhrase=new Phrase("      "+no+".Give reasons for increase/decrease in production/nil production(of primary or associate mineral), if any, during the month compared",new Font(baseFont,font, Font.BOLD));
				    PdfPCell c2 = new PdfPCell(myPhrase);
				    c2.setBorder(Rectangle.NO_BORDER);
				    c2.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c2.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c2);
				    
				    myPhrase=new Phrase("      to the previous month.",new Font(baseFont,font, Font.BOLD));
				    PdfPCell c31 = new PdfPCell(myPhrase);
				    c31.setBorder(Rectangle.NO_BORDER);
				    c31.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c31.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c31);
				    
				    myPhrase=new Phrase("     (a)"+ productioReason,new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c3 = new PdfPCell(myPhrase);
				    c3.setBorder(Rectangle.NO_BORDER);
				    c3.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c3.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c3);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.BOLD));
				    PdfPCell c07 = new PdfPCell(myPhrase);
				    c07.setBorder(Rectangle.NO_BORDER);
				    c07.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c07.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c07);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.BOLD));
				    PdfPCell c08 = new PdfPCell(myPhrase);
				    c08.setBorder(Rectangle.NO_BORDER);
				    c08.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c08.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c08);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.BOLD));
				    PdfPCell c09 = new PdfPCell(myPhrase);
				    c09.setBorder(Rectangle.NO_BORDER);
				    c09.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c09.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c09);
				    
				    myPhrase=new Phrase("      "+no1+".Give reasons for increase/decrease in grade wise ex-mine price (of primary or associate Mineral), if any, during the month compared",new Font(baseFont,font, Font.BOLD));
				    PdfPCell c7 = new PdfPCell(myPhrase);
				    c7.setBorder(Rectangle.NO_BORDER);
				    c7.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c7.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c7);
				    
				    myPhrase=new Phrase("      to the previous month.",new Font(baseFont,font, Font.BOLD));
				    PdfPCell c32 = new PdfPCell(myPhrase);
				    c32.setBorder(Rectangle.NO_BORDER);
				    c32.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c32.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c32);
				    
				    myPhrase=new Phrase("     (a)" + gradeReason,new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c8 = new PdfPCell(myPhrase);
				    c8.setBorder(Rectangle.NO_BORDER);
				    c8.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c8.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c8);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.BOLD));
				    PdfPCell c11 = new PdfPCell(myPhrase);
				    c11.setBorder(Rectangle.NO_BORDER);
				    c11.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c11.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c11);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.BOLD));
				    PdfPCell c12 = new PdfPCell(myPhrase);
				    c12.setBorder(Rectangle.NO_BORDER);
				    c12.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c12.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c12);
				    
				    
//				    myPhrase=new Phrase("",new Font(baseFont,font, Font.BOLD));
//				    PdfPCell c13 = new PdfPCell(myPhrase);
//				    c13.setBorder(Rectangle.NO_BORDER);
//				    c13.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
//				    c13.setBackgroundColor(Color.WHITE);
//				    maintable.addCell(c13);
//				    
//				    myPhrase=new Phrase("      "+no2+". Enter Remarks,If any",new Font(baseFont,font, Font.BOLD));
//				    PdfPCell c20 = new PdfPCell(myPhrase);
//				    c20.setBorder(Rectangle.NO_BORDER);
//				    c20.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
//				    c20.setBackgroundColor(Color.WHITE);
//				    maintable.addCell(c20);
//				    
//				    myPhrase=new Phrase("     (a)",new Font(baseFont,font, Font.NORMAL));
//				    PdfPCell c30 = new PdfPCell(myPhrase);
//				    c30.setBorder(Rectangle.NO_BORDER);
//				    c30.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
//				    c30.setBackgroundColor(Color.WHITE);
//				    maintable.addCell(c30);
//				    
//				    myPhrase=new Phrase("",new Font(baseFont,font, Font.BOLD));
//				    PdfPCell c070 = new PdfPCell(myPhrase);
//				    c070.setBorder(Rectangle.NO_BORDER);
//				    c070.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
//				    c070.setBackgroundColor(Color.WHITE);
//				    maintable.addCell(c070);
//				    
//				    myPhrase=new Phrase("",new Font(baseFont,font, Font.BOLD));
//				    PdfPCell c080 = new PdfPCell(myPhrase);
//				    c080.setBorder(Rectangle.NO_BORDER);
//				    c080.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
//				    c080.setBackgroundColor(Color.WHITE);
//				    maintable.addCell(c080);
//				    
//				    myPhrase=new Phrase("",new Font(baseFont,font, Font.BOLD));
//				    PdfPCell c090 = new PdfPCell(myPhrase);
//				    c090.setBorder(Rectangle.NO_BORDER);
//				    c090.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
//				    c090.setBackgroundColor(Color.WHITE);
//				    maintable.addCell(c090);

				    myPhrase=new Phrase("         I certify that the information furnished above is correct and complete in all respects.",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c14 = new PdfPCell(myPhrase);
				    c14.setBorder(Rectangle.NO_BORDER);
				    c14.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c14.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c14);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c221 = new PdfPCell(myPhrase);
				    c221.setBorder(Rectangle.NO_BORDER);
				    c221.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c221.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c221);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c222 = new PdfPCell(myPhrase);
				    c222.setBorder(Rectangle.NO_BORDER);
				    c222.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c222.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c222);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c223 = new PdfPCell(myPhrase);
				    c223.setBorder(Rectangle.NO_BORDER);
				    c223.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c223.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c223);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c224 = new PdfPCell(myPhrase);
				    c224.setBorder(Rectangle.NO_BORDER);
				    c224.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c224.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c224);
				    
				} catch (Exception e) {
					e.printStackTrace();
				}
				return maintable;
			}
		 private PdfPTable createFormData11 () {

				float[] width = {100};
				PdfPTable maintable = new PdfPTable(1);
				try {
					
					maintable.setWidthPercentage(100);
					maintable.setWidths(width);
					
					Phrase myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c0 = new PdfPCell(myPhrase);
				    c0.disableBorderSide(Rectangle.BOTTOM);
				    c0.disableBorderSide(Rectangle.LEFT);
				    c0.disableBorderSide(Rectangle.RIGHT);
				    c0.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c0.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c0);
					
					myPhrase=new Phrase("     ##Consignee name and Registration number as allotted by the Indian Bureau of Mines to the Buyer",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c = new PdfPCell(myPhrase);
				    c.disableBorderSide(Rectangle.BOTTOM);
				    c.disableBorderSide(Rectangle.LEFT);
				    c.disableBorderSide(Rectangle.RIGHT);
				    c.disableBorderSide(Rectangle.TOP);
				    c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c);
				    
				    myPhrase=new Phrase("     (to indicate separately if more than one buyer) for the top five despatches in terms of Quantity for the remaining consolidated figure shall",new Font(baseFont,font, Font.ITALIC));
				    PdfPCell c01= new PdfPCell(myPhrase);
				    c01.disableBorderSide(Rectangle.BOTTOM);
				    c01.disableBorderSide(Rectangle.LEFT);
				    c01.disableBorderSide(Rectangle.RIGHT);
				    c01.disableBorderSide(Rectangle.TOP);
				    c01.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c01.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c01);
				    
				    myPhrase=new Phrase("      be reported with details of despatches as annexure",new Font(baseFont,font, Font.ITALIC));
				    PdfPCell c011= new PdfPCell(myPhrase);
				    c011.disableBorderSide(Rectangle.BOTTOM);
				    c011.disableBorderSide(Rectangle.LEFT);
				    c011.disableBorderSide(Rectangle.RIGHT);
				    c011.disableBorderSide(Rectangle.TOP);
				    c011.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c011.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c011);
				    
				    myPhrase=new Phrase("     Note:-",new Font(baseFont,font, Font.BOLD));
				    PdfPCell c1 = new PdfPCell(myPhrase);
				    c1.setBorder(Rectangle.NO_BORDER);
				    c1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c1.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c1);
				    
				    myPhrase=new Phrase("     Mine owners are required to substantiate domestic sale value/FOB value for each grade of ore quoted above with copy of invoices.",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c001 = new PdfPCell(myPhrase);
				    c001.setBorder(Rectangle.NO_BORDER);
				    c001.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c001.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c001);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c21 = new PdfPCell(myPhrase);
				    c21.setBorder(Rectangle.NO_BORDER);
				    c21.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				    c21.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c21);
				    
				} catch (Exception e) {
					e.printStackTrace();
				}
				return maintable;
			} 
		 private PdfPTable createFormData9(String nameInFull,String place,String date)
			{
				float[] widths = {7,30,10,30};
				PdfPTable t = new PdfPTable(4);
				
				try
				{
					t.setWidthPercentage(100);
					t.setWidths(widths);
					
					Phrase myPhrase1=new Phrase("     Place :",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c = new PdfPCell(myPhrase1);
					c.setBorder(Rectangle.NO_BORDER);
					c.setBackgroundColor(Color.WHITE);
					t.addCell(c);
					
					Phrase myPhrase=new Phrase(place,new Font(baseFont,font, Font.NORMAL));
					PdfPCell c1 = new PdfPCell(myPhrase);
					c1.setBorder(Rectangle.NO_BORDER);
					c1.setBackgroundColor(Color.WHITE);
					t.addCell(c1);
					
					myPhrase1=new Phrase("Signature",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c2 = new PdfPCell(myPhrase1);
					c2.setBorder(Rectangle.NO_BORDER);
					c2.setBackgroundColor(Color.WHITE);
					t.addCell(c2);
					
					myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
					PdfPCell c3 = new PdfPCell(myPhrase);
					c3.setBorder(Rectangle.NO_BORDER);
					c3.setBackgroundColor(Color.WHITE);
					t.addCell(c3);
					
					myPhrase1=new Phrase("     Date  : ",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c4 = new PdfPCell(myPhrase1);
					c4.setBorder(Rectangle.NO_BORDER);
					c4.setBackgroundColor(Color.WHITE);
					t.addCell(c4);
					
					myPhrase=new Phrase(date,new Font(baseFont, font, Font.NORMAL));
					PdfPCell c5 = new PdfPCell(myPhrase);
					c5.setBorder(Rectangle.NO_BORDER);
					c5.setBackgroundColor(Color.WHITE);
					t.addCell(c5);
					
					myPhrase1=new Phrase("Full Name:",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c6 = new PdfPCell(myPhrase1);
					c6.setBorder(Rectangle.NO_BORDER);
					c6.setBackgroundColor(Color.WHITE);
					t.addCell(c6);
					
					myPhrase=new Phrase(nameInFull,new Font(baseFont, font, Font.NORMAL));
					PdfPCell c7 = new PdfPCell(myPhrase);
					c7.setBorder(Rectangle.NO_BORDER);
					c7.setBackgroundColor(Color.WHITE);
					t.addCell(c7);
					
				}
				catch (Exception e) 
				{
					System.out.println("Error creating PDF form for Mining :  " + e);
					e.printStackTrace();
				}
				return t;	
			}	
		 private PdfPTable createFooter (String designation) {

				float[] width = {100};
				PdfPTable maintable = new PdfPTable(1);
				try {
					
					maintable.setWidthPercentage(100);
					maintable.setWidths(width);
					
					Phrase myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c = new PdfPCell(myPhrase);
				    c.setBorder(Rectangle.NO_BORDER);
				    c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    c.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell cc = new PdfPCell(myPhrase);
				    cc.setBorder(Rectangle.NO_BORDER);
				    cc.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    cc.setBackgroundColor(Color.WHITE);
				    maintable.addCell(cc);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell cm = new PdfPCell(myPhrase);
				    cm.setBorder(Rectangle.NO_BORDER);
				    cm.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    cm.setBackgroundColor(Color.WHITE);
				    maintable.addCell(cm);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell ck = new PdfPCell(myPhrase);
				    ck.setBorder(Rectangle.NO_BORDER);
				    ck.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    ck.setBackgroundColor(Color.WHITE);
				    maintable.addCell(ck);
				    
					myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c0 = new PdfPCell(myPhrase);
				    c0.setBorder(Rectangle.NO_BORDER);
				    c0.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    c0.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c0);

					myPhrase=new Phrase("Designation :"+designation,new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c1= new PdfPCell(myPhrase);
				    c1.setBorder(Rectangle.NO_BORDER);
				    c1.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    c1.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c1);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c2= new PdfPCell(myPhrase);
				    c2.setBorder(Rectangle.NO_BORDER);
				    c2.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    c2.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c2);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c3= new PdfPCell(myPhrase);
				    c3.setBorder(Rectangle.NO_BORDER);
				    c3.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    c3.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c3);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c4= new PdfPCell(myPhrase);
				    c4.setBorder(Rectangle.NO_BORDER);
				    c4.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    c4.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c4);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c5= new PdfPCell(myPhrase);
				    c5.setBorder(Rectangle.NO_BORDER);
				    c5.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    c5.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c5);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c6= new PdfPCell(myPhrase);
				    c6.setBorder(Rectangle.NO_BORDER);
				    c6.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    c6.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c6);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c7= new PdfPCell(myPhrase);
				    c7.disableBorderSide(Rectangle.TOP);
				    c7.disableBorderSide(Rectangle.LEFT);
				    c7.disableBorderSide(Rectangle.RIGHT);
				    c7.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c7);
				    
				} catch (Exception e) {
					e.printStackTrace();
				}
				return maintable;
			}
		 
		 private PdfPTable createFoooter (String remark) {

				float[] width = {100};
				PdfPTable maintable = new PdfPTable(1);
				try {
					
					maintable.setWidthPercentage(100);
					maintable.setWidths(width);
					
					Phrase myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c = new PdfPCell(myPhrase);
				    c.disableBorderSide(Rectangle.BOTTOM);
				    c.disableBorderSide(Rectangle.LEFT);
				    c.disableBorderSide(Rectangle.RIGHT);
				    c.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell cc = new PdfPCell(myPhrase);
				    cc.setBorder(Rectangle.NO_BORDER);
				    cc.setBackgroundColor(Color.WHITE);
				    maintable.addCell(cc);
				    
				    myPhrase=new Phrase("Enter Remark,If any",new Font(baseFont,font, Font.BOLD));
				    PdfPCell cm = new PdfPCell(myPhrase);
				    cm.setBorder(Rectangle.NO_BORDER);
				    cm.setBackgroundColor(Color.WHITE);
				    maintable.addCell(cm);
				    
				    myPhrase=new Phrase("(a)"+remark,new Font(baseFont,font, Font.NORMAL));
				    PdfPCell ck = new PdfPCell(myPhrase);
				    ck.setBorder(Rectangle.NO_BORDER);
				    ck.setBackgroundColor(Color.WHITE);
				    maintable.addCell(ck);
				    
					
				} catch (Exception e) {
					e.printStackTrace();
				}
				return maintable;
			}
		 
		 private PdfPTable createTableForDomesticConsumption(ArrayList<Object> domesticData)
			{
				float[] widths = {22,23,30,30,30,30,30,30};
				PdfPTable t = new PdfPTable(8);
				
				try
				{
					t.setWidthPercentage(100);
					t.setWidths(widths);
					
					Phrase myPhrase=new Phrase("Grade",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c0 = new PdfPCell(myPhrase);
					c0.disableBorderSide(Rectangle.BOTTOM);
					c0.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c0.setBackgroundColor(Color.WHITE);
					t.addCell(c0);
					
					myPhrase=new Phrase("Nature of Despatch ",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c01 = new PdfPCell(myPhrase);
					 c01.disableBorderSide(Rectangle.BOTTOM);
					c01.setBackgroundColor(Color.WHITE);
					t.addCell(c01);
					
					myPhrase=new Phrase("For domestic",new Font(baseFont, font, Font.NORMAL));
					PdfPCell c02 = new PdfPCell(myPhrase);
					c02.setBackgroundColor(Color.WHITE);
					c02.disableBorderSide(Rectangle.RIGHT);
					c02.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
					t.addCell(c02);
					
					myPhrase=new Phrase("Consumption",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c03 = new PdfPCell(myPhrase);
					c03.setBackgroundColor(Color.WHITE);
					c03.disableBorderSide(Rectangle.LEFT);
					c03.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
					c03.disableBorderSide(Rectangle.RIGHT);
					t.addCell(c03);
					
					myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c04 = new PdfPCell(myPhrase);
					c04.setBackgroundColor(Color.WHITE);
					c04.disableBorderSide(Rectangle.LEFT);
					t.addCell(c04);
					
					myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c05 = new PdfPCell(myPhrase);
					c05.disableBorderSide(Rectangle.LEFT);
					c05.disableBorderSide(Rectangle.RIGHT);
					c05.setBackgroundColor(Color.WHITE);
					t.addCell(c05);
					
					myPhrase=new Phrase("For Export",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c06 = new PdfPCell(myPhrase);
					c06.disableBorderSide(Rectangle.LEFT);
					c06.disableBorderSide(Rectangle.RIGHT);
					c06.setBackgroundColor(Color.WHITE);
					t.addCell(c06);
					
					myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c07 = new PdfPCell(myPhrase);
					c07.disableBorderSide(Rectangle.LEFT);
					c07.setBackgroundColor(Color.WHITE);
					t.addCell(c07);
					
					myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c014 = new PdfPCell(myPhrase);
					c014.disableBorderSide(Rectangle.TOP);
					c014.setBackgroundColor(Color.WHITE);
					t.addCell(c014);
					
					myPhrase=new Phrase("(indicate wheather [sale] or captive consumption or Export)",new Font(baseFont,font, Font.ITALIC));
					PdfPCell c015 = new PdfPCell(myPhrase);
					c015.disableBorderSide(Rectangle.TOP);
					c015.setBackgroundColor(Color.WHITE);
					t.addCell(c015);
					
					myPhrase=new Phrase("Consignee name and Registration number as allotted by the Indian Bureau of Mines to the buyer##",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c08 = new PdfPCell(myPhrase);
					c08.setBackgroundColor(Color.WHITE);
					t.addCell(c08);
					
					myPhrase=new Phrase("Quantity",new Font(baseFont, font, Font.NORMAL));
					PdfPCell c09 = new PdfPCell(myPhrase);
					c09.setBackgroundColor(Color.WHITE);
					c09.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c09);
					
					myPhrase=new Phrase("Sale value",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c010 = new PdfPCell(myPhrase);
					c010.setBackgroundColor(Color.WHITE);
					c010.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c010);
					
					myPhrase=new Phrase("Country",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c011 = new PdfPCell(myPhrase);
					c011.setBackgroundColor(Color.WHITE);
					c011.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c011);
					
					myPhrase=new Phrase("Quantity",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c012 = new PdfPCell(myPhrase);
					c012.setBackgroundColor(Color.WHITE);
					c012.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c012);
					
					myPhrase=new Phrase("F.O.B Value(Rs.)",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c013 = new PdfPCell(myPhrase);
					c013.setBackgroundColor(Color.WHITE);
					c013.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c013);
					
					if(domesticData.size()>0){
						for(int i=0;i<domesticData.size();i++){
							myPhrase=new Phrase((String) domesticData.get(i),new Font(baseFont,font, Font.NORMAL));
							PdfPCell c9 = new PdfPCell(myPhrase);
							c9.setBackgroundColor(Color.WHITE);
							t.addCell(c9);
						}
					}else{
						for(int i=0;i<160;i++){
							myPhrase=new Phrase(" ",new Font(baseFont,font, Font.NORMAL));
							PdfPCell c9 = new PdfPCell(myPhrase);
							c9.setBackgroundColor(Color.WHITE);
							t.addCell(c9);
						}
					}
				}
				catch (Exception e) 
				{
					System.out.println("Error creating PDF form for Mining :  " + e);
					e.printStackTrace();
				}
				return t;	
			}	
		 private PdfPTable createHeaderForROMProcessing()
			{
				float[] widths = {100};
				PdfPTable t = new PdfPTable(1);
				
				try
				{
					t.setWidthPercentage(100);
					t.setWidths(widths);
					
					Phrase myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c01 = new PdfPCell(myPhrase);
					c01.setBackgroundColor(Color.WHITE);
					c01.setBorder(Rectangle.NO_BORDER);
					t.addCell(c01);
					
					myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c04 = new PdfPCell(myPhrase);
					c04.setBorder(Rectangle.NO_BORDER);
					c04.setBackgroundColor(Color.WHITE);
					t.addCell(c04);
					
					myPhrase=new Phrase("(a)ROM Processing",new Font(baseFont, font, Font.BOLD));
					PdfPCell c02 = new PdfPCell(myPhrase);
					c02.setBackgroundColor(Color.WHITE);
					c02.setBorder(Rectangle.NO_BORDER);
					t.addCell(c02);
				
				}
				catch (Exception e) 
				{
					System.out.println("Error creating PDF form for Mining :  " + e);
					e.printStackTrace();
				}
				return t;	
			}	

		 @SuppressWarnings("unchecked")
		private PdfPTable createForROMProcessing(ArrayList romData)
			{
				float[] widths = {30,30,30,30,30};
				PdfPTable t = new PdfPTable(5);
				
				try
				{
					t.setWidthPercentage(100);
					t.setWidths(widths);
					
					Phrase myPhrase=new Phrase("Location Of Plant",new Font(baseFont,font, Font.BOLD));
					PdfPCell c0 = new PdfPCell(myPhrase);
					c0.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c0.setBackgroundColor(Color.WHITE);
					t.addCell(c0);
					
					myPhrase=new Phrase("Opening stock of ROM",new Font(baseFont,font, Font.BOLD));
					PdfPCell c01 = new PdfPCell(myPhrase);
					c01.setBackgroundColor(Color.WHITE);
					t.addCell(c01);
					
					myPhrase=new Phrase("Receipt of ROM during the month",new Font(baseFont, font, Font.BOLD));
					PdfPCell c02 = new PdfPCell(myPhrase);
					c02.setBackgroundColor(Color.WHITE);
					c02.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c02);
					
					myPhrase=new Phrase("ROM Processed during the month",new Font(baseFont,font, Font.BOLD));
					PdfPCell c03 = new PdfPCell(myPhrase);
					c03.setBackgroundColor(Color.WHITE);
					c03.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c03);
					
					myPhrase=new Phrase("Closing Stock of ROM",new Font(baseFont,font, Font.BOLD));
					PdfPCell c04 = new PdfPCell(myPhrase);
					c04.setBackgroundColor(Color.WHITE);
					t.addCell(c04);
					
					if(romData.size()>0){
						for(int i=0;i<romData.size();i++){
							myPhrase=new Phrase((String) romData.get(i),new Font(baseFont,font, Font.NORMAL));
							PdfPCell c9 = new PdfPCell(myPhrase);
							c9.setBackgroundColor(Color.WHITE);
							t.addCell(c9);
						}
					}else{
						for(int i=0;i<25;i++){
							myPhrase=new Phrase(" ",new Font(baseFont,font, Font.NORMAL));
							PdfPCell c9 = new PdfPCell(myPhrase);
							c9.setBackgroundColor(Color.WHITE);
							t.addCell(c9);
						}
					}
				}
				catch (Exception e) 
				{
					System.out.println("Error creating PDF form for Mining :  " + e);
					e.printStackTrace();
				}
				return t;	
			}	

		 private PdfPTable createHeaderForProcessedOre()
			{
				float[] widths = {100};
				PdfPTable t = new PdfPTable(1);
				
				try
				{
					t.setWidthPercentage(100);
					t.setWidths(widths);
					
					Phrase myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c04 = new PdfPCell(myPhrase);
					c04.setBorder(Rectangle.NO_BORDER);
					c04.setBackgroundColor(Color.WHITE);
					t.addCell(c04);
					
					myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c05 = new PdfPCell(myPhrase);
					c05.setBackgroundColor(Color.WHITE);
					c05.setBorder(Rectangle.NO_BORDER);
					t.addCell(c05);
						
					myPhrase=new Phrase("(b)Details Of Processed ore",new Font(baseFont, font, Font.BOLD));
					PdfPCell c13 = new PdfPCell(myPhrase);
					c13.setBackgroundColor(Color.WHITE);
					c13.setBorder(Rectangle.NO_BORDER);
					t.addCell(c13);
				}
				catch (Exception e) 
				{
					System.out.println("Error creating PDF form for Mining :  " + e);
					e.printStackTrace();
				}
				return t;	
			}	

		 
		 @SuppressWarnings("unchecked")
		private PdfPTable createForDeatilsOfProcessedOreFe(Map oreProductionDetails)
			{
				float[] widths = {30,30,30,30,30};
				PdfPTable t = new PdfPTable(5);
				
				try
				{
					t.setWidthPercentage(100);
					t.setWidths(widths);
					
					Phrase myPhrase=new Phrase("Grade(%) of Fe content",new Font(baseFont,font, Font.BOLD));
					PdfPCell c0 = new PdfPCell(myPhrase);
					c0.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c0.setBackgroundColor(Color.WHITE);
					t.addCell(c0);
					
					myPhrase=new Phrase("Fines",new Font(baseFont,font, Font.BOLD));
					PdfPCell c01 = new PdfPCell(myPhrase);
					c01.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c01.setBackgroundColor(Color.WHITE);
					t.addCell(c01);
					
					myPhrase=new Phrase("Lumps",new Font(baseFont, font, Font.BOLD));
					PdfPCell c02 = new PdfPCell(myPhrase);
					c02.setBackgroundColor(Color.WHITE);
					c02.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c02);
					
					myPhrase=new Phrase("Oversize",new Font(baseFont,font, Font.BOLD));
					PdfPCell c03 = new PdfPCell(myPhrase);
					c03.setBackgroundColor(Color.WHITE);
					c03.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c03);
					
					myPhrase=new Phrase("Waste/Tailing",new Font(baseFont,font, Font.BOLD));
					PdfPCell c04 = new PdfPCell(myPhrase);
					c04.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c04.setBackgroundColor(Color.WHITE);
					t.addCell(c04);
					
					myPhrase=new Phrase("  (a)Below 55%",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c05 = new PdfPCell(myPhrase);
					c05.setBackgroundColor(Color.WHITE);
					t.addCell(c05);

					ArrayList<String> oreDetails =new ArrayList<String>();
					oreDetails=getOreStructure("Fe:Below55%", oreProductionDetails);
					for(int i=0;i<oreDetails.size();i++){
						myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
						PdfPCell c9 = new PdfPCell(myPhrase);
						c9.setBackgroundColor(Color.WHITE);
						t.addCell(c9);
					}

						myPhrase=new Phrase("  (b)55% to below 58%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c13 = new PdfPCell(myPhrase);
						c13.setBackgroundColor(Color.WHITE);
						t.addCell(c13);
						
						oreDetails=getOreStructure("Fe:55%toBelow58%", oreProductionDetails);
						for(int i=0;i<oreDetails.size();i++){
									myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c1 = new PdfPCell(myPhrase);
									c1.setBackgroundColor(Color.WHITE);
									t.addCell(c1);
								}
								
						myPhrase=new Phrase("  (c)58% to below 60%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c19 = new PdfPCell(myPhrase);
						c19.setBackgroundColor(Color.WHITE);
						t.addCell(c19);
						
						oreDetails=getOreStructure("Fe:58%toBelow60%", oreProductionDetails);
						for(int i=0;i<oreDetails.size();i++){
									myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c2= new PdfPCell(myPhrase);
									c2.setBackgroundColor(Color.WHITE);
									t.addCell(c2);
								}
								
						myPhrase=new Phrase("  (d)60% to below 62%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c26 = new PdfPCell(myPhrase);
						c26.setBackgroundColor(Color.WHITE);
						t.addCell(c26);
						
						oreDetails=getOreStructure("Fe:60%toBelow62%", oreProductionDetails);
						for(int i=0;i<oreDetails.size();i++){
									myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c3 = new PdfPCell(myPhrase);
									c3.setBackgroundColor(Color.WHITE);
									t.addCell(c3);
								}
								
						myPhrase=new Phrase("  (e)62% to below 65%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c32 = new PdfPCell(myPhrase);
						c32.setBackgroundColor(Color.WHITE);
						t.addCell(c32);
						
						oreDetails=getOreStructure("Fe:62%toBelow65%", oreProductionDetails);
						for(int i=0;i<oreDetails.size();i++){
									myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c4 = new PdfPCell(myPhrase);
									c4.setBackgroundColor(Color.WHITE);
									t.addCell(c4);
								}
								
						myPhrase=new Phrase("  (f)65% and above",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c38 = new PdfPCell(myPhrase);
						c38.setBackgroundColor(Color.WHITE);
						t.addCell(c38);
						
						oreDetails=getOreStructure("Fe:65%andabove", oreProductionDetails);
						for(int i=0;i<oreDetails.size();i++){
									myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c5 = new PdfPCell(myPhrase);
									c5.setBackgroundColor(Color.WHITE);
									t.addCell(c5);
								}
						
						myPhrase=new Phrase("  Total",new Font(baseFont, font, Font.BOLD));
						PdfPCell c308 = new PdfPCell(myPhrase);
						c308.setBackgroundColor(Color.WHITE);
						t.addCell(c308);
						
						oreDetails=getOreStructure("Total", oreProductionDetails);
						for(int i=0;i<oreDetails.size();i++){
									myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell cc5 = new PdfPCell(myPhrase);
									cc5.setBackgroundColor(Color.WHITE);
									t.addCell(cc5);
								}
						
				}
				catch (Exception e) 
				{
					System.out.println("Error creating PDF form for Mining :  " + e);
					e.printStackTrace();
				}
				return t;	
			}	

		 @SuppressWarnings("unchecked")
		private PdfPTable createForDeatilsOfProcessedOreForAl(Map oreProductionDetails)
			{
				float[] widths = {30,30,30,30,30};
				PdfPTable t = new PdfPTable(5);
				
				try
				{
					t.setWidthPercentage(100);
					t.setWidths(widths);
					
					Phrase myPhrase=new Phrase("Grade(%) of Al content",new Font(baseFont,font, Font.BOLD));
					PdfPCell c0 = new PdfPCell(myPhrase);
					c0.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c0.setBackgroundColor(Color.WHITE);
					t.addCell(c0);
					
					myPhrase=new Phrase("Fines",new Font(baseFont,font, Font.BOLD));
					PdfPCell c01 = new PdfPCell(myPhrase);
					c01.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c01.setBackgroundColor(Color.WHITE);
					t.addCell(c01);
					
					myPhrase=new Phrase("Lumps",new Font(baseFont, font, Font.BOLD));
					PdfPCell c02 = new PdfPCell(myPhrase);
					c02.setBackgroundColor(Color.WHITE);
					c02.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c02);
					
					myPhrase=new Phrase("Oversize",new Font(baseFont,font, Font.BOLD));
					PdfPCell c03 = new PdfPCell(myPhrase);
					c03.setBackgroundColor(Color.WHITE);
					c03.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c03);
					
					myPhrase=new Phrase("Waste/Tailing",new Font(baseFont,font, Font.BOLD));
					PdfPCell c04 = new PdfPCell(myPhrase);
					c04.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c04.setBackgroundColor(Color.WHITE);
					t.addCell(c04);
					
					myPhrase=new Phrase("  (a)Below 40%",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c05 = new PdfPCell(myPhrase);
					c05.setBackgroundColor(Color.WHITE);
					t.addCell(c05);
					
					ArrayList<String> oreDetails =new ArrayList<String>();
					oreDetails=getOreStructure("Al:Below40%", oreProductionDetails);
					for(int i=0;i<oreDetails.size();i++){
						myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
						PdfPCell c9 = new PdfPCell(myPhrase);
						c9.setBackgroundColor(Color.WHITE);
						t.addCell(c9);
					}
					
					myPhrase=new Phrase("  (b)40% to Below 45%",new Font(baseFont, font, Font.NORMAL));
					PdfPCell c13 = new PdfPCell(myPhrase);
					c13.setBackgroundColor(Color.WHITE);
					t.addCell(c13);
					
					oreDetails=getOreStructure("Al:40%toBelow45%", oreProductionDetails);
					for(int i=0;i<oreDetails.size();i++){
						myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
							PdfPCell c9 = new PdfPCell(myPhrase);
							c9.setBackgroundColor(Color.WHITE);
							t.addCell(c9);
						}
						
						myPhrase=new Phrase("  (c)45% to Below 50%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c19 = new PdfPCell(myPhrase);
						c19.setBackgroundColor(Color.WHITE);
						t.addCell(c19);
						
						oreDetails=getOreStructure("Al:45%toBelow50%", oreProductionDetails);
						for(int i=0;i<oreDetails.size();i++){
							myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c1 = new PdfPCell(myPhrase);
									c1.setBackgroundColor(Color.WHITE);
									t.addCell(c1);
								}
								
						myPhrase=new Phrase("  (d)50% to Below 55%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c26 = new PdfPCell(myPhrase);
						c26.setBackgroundColor(Color.WHITE);
						t.addCell(c26);
						
						oreDetails=getOreStructure("Al:50%toBelow55%", oreProductionDetails);
						for(int i=0;i<oreDetails.size();i++){
							myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c2= new PdfPCell(myPhrase);
									c2.setBackgroundColor(Color.WHITE);
									t.addCell(c2);
								}
								
						myPhrase=new Phrase("  (e)55% to Below 60%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c32 = new PdfPCell(myPhrase);
						c32.setBackgroundColor(Color.WHITE);
						t.addCell(c32);
						
						oreDetails=getOreStructure("Al:55%toBelow60%", oreProductionDetails);
						for(int i=0;i<oreDetails.size();i++){
							myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c3 = new PdfPCell(myPhrase);
									c3.setBackgroundColor(Color.WHITE);
									t.addCell(c3);
								}
								
						myPhrase=new Phrase("  (f)60% and above",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c38 = new PdfPCell(myPhrase);
						c38.setBackgroundColor(Color.WHITE);
						t.addCell(c38);
						
						oreDetails=getOreStructure("Al:60%andabove", oreProductionDetails);
						for(int i=0;i<oreDetails.size();i++){
							myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c4 = new PdfPCell(myPhrase);
									c4.setBackgroundColor(Color.WHITE);
									t.addCell(c4);
								}
								
						myPhrase=new Phrase("  (g)Cement",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c380 = new PdfPCell(myPhrase);
						c380.setBackgroundColor(Color.WHITE);
						t.addCell(c380);
						
						oreDetails=getOreStructure("OtherthanAl:Cement", oreProductionDetails);
						for(int i=0;i<oreDetails.size();i++){
							myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c5 = new PdfPCell(myPhrase);
									c5.setBackgroundColor(Color.WHITE);
									t.addCell(c5);
								}
						
						myPhrase=new Phrase("  (h)Abrasive",new Font(baseFont, font, Font.NORMAL));
						PdfPCell cc38 = new PdfPCell(myPhrase);
						cc38.setBackgroundColor(Color.WHITE);
						t.addCell(cc38);
						
						oreDetails=getOreStructure("OtherthanAl:Abrasive", oreProductionDetails);
						for(int i=0;i<oreDetails.size();i++){
							myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
							PdfPCell cf1 = new PdfPCell(myPhrase);
							cf1.setBackgroundColor(Color.WHITE);
							t.addCell(cf1);
						}
						myPhrase=new Phrase("  (i)Refactory",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c3c8 = new PdfPCell(myPhrase);
						c3c8.setBackgroundColor(Color.WHITE);
						t.addCell(c3c8);
						
						oreDetails=getOreStructure("OtherthanAl:Refactory", oreProductionDetails);
						for(int i=0;i<oreDetails.size();i++){
							myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
							PdfPCell cf3 = new PdfPCell(myPhrase);
							cf3.setBackgroundColor(Color.WHITE);
							t.addCell(cf3);
						}
						
						myPhrase=new Phrase("  (j)Chemical",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c338 = new PdfPCell(myPhrase);
						c338.setBackgroundColor(Color.WHITE);
						t.addCell(c338);
						
						oreDetails=getOreStructure("OtherthanAl:Chemical", oreProductionDetails);
						for(int i=0;i<oreDetails.size();i++){
							myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell cf5 = new PdfPCell(myPhrase);
									cf5.setBackgroundColor(Color.WHITE);
									t.addCell(cf5);
								}
						
						myPhrase=new Phrase("  Total",new Font(baseFont, font, Font.BOLD));
						PdfPCell c308 = new PdfPCell(myPhrase);
						c308.setBackgroundColor(Color.WHITE);
						t.addCell(c308);
						
						oreDetails=getOreStructure("Total", oreProductionDetails);
						for(int i=0;i<oreDetails.size();i++){
							myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell cc5 = new PdfPCell(myPhrase);
									cc5.setBackgroundColor(Color.WHITE);
									t.addCell(cc5);
								}
						
				}
				catch (Exception e) 
				{
					System.out.println("Error creating PDF form for Mining :  " + e);
					e.printStackTrace();
				}
				return t;	
			}	

		 @SuppressWarnings("unchecked")
		private PdfPTable createForDeatilsOfProcessedOrefForMn(Map oreProductionDetails)
			{
				float[] widths = {30,30,30,30,30};
				PdfPTable t = new PdfPTable(5);
				
				try
				{
					t.setWidthPercentage(100);
					t.setWidths(widths);
					
					Phrase myPhrase=new Phrase("Grade(%) of Mn content",new Font(baseFont,font, Font.BOLD));
					PdfPCell c0 = new PdfPCell(myPhrase);
					c0.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c0.setBackgroundColor(Color.WHITE);
					t.addCell(c0);
					
					myPhrase=new Phrase("Fines",new Font(baseFont,font, Font.BOLD));
					PdfPCell c01 = new PdfPCell(myPhrase);
					c01.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c01.setBackgroundColor(Color.WHITE);
					t.addCell(c01);
					
					myPhrase=new Phrase("Lumps",new Font(baseFont, font, Font.BOLD));
					PdfPCell c02 = new PdfPCell(myPhrase);
					c02.setBackgroundColor(Color.WHITE);
					c02.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c02);
					
					myPhrase=new Phrase("Oversize",new Font(baseFont,font, Font.BOLD));
					PdfPCell c03 = new PdfPCell(myPhrase);
					c03.setBackgroundColor(Color.WHITE);
					c03.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c03);
					
					myPhrase=new Phrase("Waste/Tailing",new Font(baseFont,font, Font.BOLD));
					PdfPCell c04 = new PdfPCell(myPhrase);
					c04.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c04.setBackgroundColor(Color.WHITE);
					t.addCell(c04);
					
					myPhrase=new Phrase("  (a)Below 25%",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c05 = new PdfPCell(myPhrase);
					c05.setBackgroundColor(Color.WHITE);
					t.addCell(c05);
					
					ArrayList<String> oreDetails =new ArrayList<String>();
					oreDetails=getOreStructure("Mn:Below25%", oreProductionDetails);
					for(int i=0;i<oreDetails.size();i++){
						myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
						PdfPCell c9 = new PdfPCell(myPhrase);
						c9.setBackgroundColor(Color.WHITE);
						t.addCell(c9);
					}
					
					myPhrase=new Phrase("  (b)25% to Below 35%",new Font(baseFont, font, Font.NORMAL));
					PdfPCell c13 = new PdfPCell(myPhrase);
					c13.setBackgroundColor(Color.WHITE);
					t.addCell(c13);
					
					oreDetails=getOreStructure("Mn:25%toBelow35%", oreProductionDetails);
					for(int i=0;i<oreDetails.size();i++){
						myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
							PdfPCell c9 = new PdfPCell(myPhrase);
							c9.setBackgroundColor(Color.WHITE);
							t.addCell(c9);
						}
						
						myPhrase=new Phrase("  (c)35% to Below 46%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c19 = new PdfPCell(myPhrase);
						c19.setBackgroundColor(Color.WHITE);
						t.addCell(c19);
						
						oreDetails=getOreStructure("Mn:35%toBelow46%", oreProductionDetails);
						for(int i=0;i<oreDetails.size();i++){
							myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c1 = new PdfPCell(myPhrase);
									c1.setBackgroundColor(Color.WHITE);
									t.addCell(c1);
								}
								
						myPhrase=new Phrase("  (d)46% and above",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c26 = new PdfPCell(myPhrase);
						c26.setBackgroundColor(Color.WHITE);
						t.addCell(c26);
						
						oreDetails=getOreStructure("Mn:46%andabove", oreProductionDetails);
						for(int i=0;i<oreDetails.size();i++){
							myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c2= new PdfPCell(myPhrase);
									c2.setBackgroundColor(Color.WHITE);
									t.addCell(c2);
								}
								
						myPhrase=new Phrase("  (e)Dioxide ore",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c32 = new PdfPCell(myPhrase);
						c32.setBackgroundColor(Color.WHITE);
						t.addCell(c32);
						
						oreDetails=getOreStructure("Mn:Dioxideore", oreProductionDetails);
						for(int i=0;i<oreDetails.size();i++){
							myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c3 = new PdfPCell(myPhrase);
									c3.setBackgroundColor(Color.WHITE);
									t.addCell(c3);
								}
								
						myPhrase=new Phrase("  (f)Concentrates",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c38 = new PdfPCell(myPhrase);
						c38.setBackgroundColor(Color.WHITE);
						t.addCell(c38);
						
						oreDetails=getOreStructure("Mn:Concentrates", oreProductionDetails);
						for(int i=0;i<oreDetails.size();i++){
							myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c4 = new PdfPCell(myPhrase);
									c4.setBackgroundColor(Color.WHITE);
									t.addCell(c4);
								}
						
						myPhrase=new Phrase("  Total",new Font(baseFont, font, Font.BOLD));
						PdfPCell c308 = new PdfPCell(myPhrase);
						c308.setBackgroundColor(Color.WHITE);
						t.addCell(c308);
						
						oreDetails=getOreStructure("Total", oreProductionDetails);
						for(int i=0;i<oreDetails.size();i++){
							myPhrase=new Phrase(oreDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell cc5 = new PdfPCell(myPhrase);
									cc5.setBackgroundColor(Color.WHITE);
									t.addCell(cc5);
								}
						
				}
				catch (Exception e) 
				{
					System.out.println("Error creating PDF form for Mining :  " + e);
					e.printStackTrace();
				}
				return t;	
			}	

		 private PdfPTable createHeaderForOversize()
			{
				float[] widths = {100};
				PdfPTable t = new PdfPTable(1);
				
				try
				{
					t.setWidthPercentage(100);
					t.setWidths(widths);
					
					
					Phrase myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c04 = new PdfPCell(myPhrase);
					c04.disableBorderSide(Rectangle.RIGHT);
					c04.disableBorderSide(Rectangle.LEFT);
					c04.disableBorderSide(Rectangle.BOTTOM);
					c04.setBackgroundColor(Color.WHITE);
					t.addCell(c04);
					
					myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c05 = new PdfPCell(myPhrase);
					c05.setBackgroundColor(Color.WHITE);
					c05.setBorder(Rectangle.NO_BORDER);
					t.addCell(c05);
						
					myPhrase=new Phrase("(c)Oversize Crushing/Procesing",new Font(baseFont, font, Font.BOLD));
					PdfPCell c19 = new PdfPCell(myPhrase);
					c19.setBorder(Rectangle.NO_BORDER);
					c19.setBackgroundColor(Color.WHITE);
					t.addCell(c19);
				}
				catch (Exception e) 
				{
					System.out.println("Error creating PDF form for Mining :  " + e);
					e.printStackTrace();
				}
				return t;	
			}	

		 
		 @SuppressWarnings("unchecked")
		private PdfPTable createForOversize(ArrayList oversizeData)
			{
				float[] widths = {30,30,30,30,30};
				PdfPTable t = new PdfPTable(5);
				
				try
				{
					t.setWidthPercentage(100);
					t.setWidths(widths);
					
					Phrase myPhrase=new Phrase("Location Of Plant",new Font(baseFont,font, Font.BOLD));
					PdfPCell c0 = new PdfPCell(myPhrase);
					c0.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c0.setBackgroundColor(Color.WHITE);
					t.addCell(c0);
					
					myPhrase=new Phrase("Opening stock of Oversize",new Font(baseFont,font, Font.BOLD));
					PdfPCell c01 = new PdfPCell(myPhrase);
					c01.setBackgroundColor(Color.WHITE);
					t.addCell(c01);
					
					myPhrase=new Phrase("Generation of Oversize during the month",new Font(baseFont, font, Font.BOLD));
					PdfPCell c02 = new PdfPCell(myPhrase);
					c02.setBackgroundColor(Color.WHITE);
					c02.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c02);
					
					myPhrase=new Phrase("Processing of Oversize during the month",new Font(baseFont,font, Font.BOLD));
					PdfPCell c03 = new PdfPCell(myPhrase);
					c03.setBackgroundColor(Color.WHITE);
					c03.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c03);
					
					myPhrase=new Phrase("Closing Stock of Oversize",new Font(baseFont,font, Font.BOLD));
					PdfPCell c04 = new PdfPCell(myPhrase);
					c04.setBackgroundColor(Color.WHITE);
					t.addCell(c04);
					
					if(oversizeData.size()>0){
						for(int i=0;i<oversizeData.size();i++){
							myPhrase=new Phrase((String) oversizeData.get(i),new Font(baseFont,font, Font.NORMAL));
							PdfPCell c9 = new PdfPCell(myPhrase);
							c9.setBackgroundColor(Color.WHITE);
							t.addCell(c9);
						}
					}else{
						for(int i=0;i<25;i++){
							myPhrase=new Phrase(" ",new Font(baseFont,font, Font.NORMAL));
							PdfPCell c9 = new PdfPCell(myPhrase);
							c9.setBackgroundColor(Color.WHITE);
							t.addCell(c9);
						}
					}
				}
				catch (Exception e) 
				{
					System.out.println("Error creating PDF form for Mining :  " + e);
					e.printStackTrace();
				}
				return t;	
			}
		 
		 
		 private PdfPTable createHeaderForOversizeProcessing()
			{
				float[] widths = {100};
				PdfPTable t = new PdfPTable(1);
				
				try
				{
					t.setWidthPercentage(100);
					t.setWidths(widths);
					
					Phrase myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c05 = new PdfPCell(myPhrase);
					c05.disableBorderSide(Rectangle.RIGHT);
					c05.disableBorderSide(Rectangle.LEFT);
					c05.disableBorderSide(Rectangle.BOTTOM);
					c05.setBackgroundColor(Color.WHITE);
					t.addCell(c05);
						
					myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c04 = new PdfPCell(myPhrase);
					c04.setBorder(Rectangle.NO_BORDER);
					c04.setBackgroundColor(Color.WHITE);
					t.addCell(c04);
					
					myPhrase=new Phrase("(d)Details of Oversize Processing",new Font(baseFont, font, Font.BOLD));
					PdfPCell c26 = new PdfPCell(myPhrase);
					c26.setBorder(Rectangle.NO_BORDER);
					c26.setBackgroundColor(Color.WHITE);
					t.addCell(c26);
				}
				catch (Exception e) 
				{
					System.out.println("Error creating PDF form for Mining :  " + e);
					e.printStackTrace();
				}
				return t;	
			}	

		 @SuppressWarnings("unchecked")
		private PdfPTable createForDeatilsOfOversizeProcessingForFe(Map oversizeProcessingDetails)
			{
				float[] widths = {30,30,30,30};
				PdfPTable t = new PdfPTable(4);
				
				try
				{
					t.setWidthPercentage(100);
					t.setWidths(widths);
					
					Phrase myPhrase=new Phrase("Grade(%) of Fe content",new Font(baseFont,font, Font.BOLD));
					PdfPCell c0 = new PdfPCell(myPhrase);
					c0.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c0.setBackgroundColor(Color.WHITE);
					t.addCell(c0);
					
					myPhrase=new Phrase("Fines",new Font(baseFont,font, Font.BOLD));
					PdfPCell c01 = new PdfPCell(myPhrase);
					c01.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c01.setBackgroundColor(Color.WHITE);
					t.addCell(c01);
					
					myPhrase=new Phrase("Lumps",new Font(baseFont, font, Font.BOLD));
					PdfPCell c02 = new PdfPCell(myPhrase);
					c02.setBackgroundColor(Color.WHITE);
					c02.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c02);
					
					myPhrase=new Phrase("Waste/Tailing",new Font(baseFont,font, Font.BOLD));
					PdfPCell c04 = new PdfPCell(myPhrase);
					c04.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c04.setBackgroundColor(Color.WHITE);
					t.addCell(c04);
					
					myPhrase=new Phrase("  (a)Below 55%",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c05 = new PdfPCell(myPhrase);
					c05.setBackgroundColor(Color.WHITE);
					t.addCell(c05);
					
					ArrayList<String> oversizeProcess =new ArrayList<String>();
					oversizeProcess=getStockStructure("Fe:Below55%", oversizeProcessingDetails);
					for(int i=0;i<oversizeProcess.size();i++){
						myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
							PdfPCell c9 = new PdfPCell(myPhrase);
							c9.setBackgroundColor(Color.WHITE);
							t.addCell(c9);
						}
						
						myPhrase=new Phrase("  (b)55% to below 58%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c13 = new PdfPCell(myPhrase);
						c13.setBackgroundColor(Color.WHITE);
						t.addCell(c13);
						
						oversizeProcess=getStockStructure("Fe:55%toBelow58%", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c1 = new PdfPCell(myPhrase);
									c1.setBackgroundColor(Color.WHITE);
									t.addCell(c1);
								}
								
						myPhrase=new Phrase("  (c)58% to below 60%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c19 = new PdfPCell(myPhrase);
						c19.setBackgroundColor(Color.WHITE);
						t.addCell(c19);
						
						oversizeProcess=getStockStructure("Fe:58%toBelow60%", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c2= new PdfPCell(myPhrase);
									c2.setBackgroundColor(Color.WHITE);
									t.addCell(c2);
								}
								
						myPhrase=new Phrase("  (d)60% to below 62%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c26 = new PdfPCell(myPhrase);
						c26.setBackgroundColor(Color.WHITE);
						t.addCell(c26);
						
						oversizeProcess=getStockStructure("Fe:60%toBelow62%", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c3 = new PdfPCell(myPhrase);
									c3.setBackgroundColor(Color.WHITE);
									t.addCell(c3);
								}
								
						myPhrase=new Phrase("  (e)62% to below 65%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c32 = new PdfPCell(myPhrase);
						c32.setBackgroundColor(Color.WHITE);
						t.addCell(c32);
						
						oversizeProcess=getStockStructure("Fe:62%toBelow65%", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c4 = new PdfPCell(myPhrase);
									c4.setBackgroundColor(Color.WHITE);
									t.addCell(c4);
								}
								
						myPhrase=new Phrase("  (f)65% and above",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c38 = new PdfPCell(myPhrase);
						c38.setBackgroundColor(Color.WHITE);
						t.addCell(c38);
						
						oversizeProcess=getStockStructure("Fe:65%andabove", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c5 = new PdfPCell(myPhrase);
									c5.setBackgroundColor(Color.WHITE);
									t.addCell(c5);
								}
						
						myPhrase=new Phrase("  Total",new Font(baseFont, font, Font.BOLD));
						PdfPCell c308 = new PdfPCell(myPhrase);
						c308.setBackgroundColor(Color.WHITE);
						t.addCell(c308);
						
						oversizeProcess=getStockStructure("Total", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell cc5 = new PdfPCell(myPhrase);
									cc5.setBackgroundColor(Color.WHITE);
									t.addCell(cc5);
								}
						
				}
				catch (Exception e) 
				{
					System.out.println("Error creating PDF form for Mining :  " + e);
					e.printStackTrace();
				}
				return t;	
			}	

		 @SuppressWarnings("unchecked")
		private PdfPTable createForDeatilsOfOversizeProcessingForMn(Map oversizeProcessingDetails)
			{
				float[] widths = {30,30,30,30};
				PdfPTable t = new PdfPTable(4);
				
				try
				{
					t.setWidthPercentage(100);
					t.setWidths(widths);
					
					Phrase myPhrase=new Phrase("Grade(%) of Mn content",new Font(baseFont,font, Font.BOLD));
					PdfPCell c0 = new PdfPCell(myPhrase);
					c0.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c0.setBackgroundColor(Color.WHITE);
					t.addCell(c0);
					
					myPhrase=new Phrase("Fines",new Font(baseFont,font, Font.BOLD));
					PdfPCell c01 = new PdfPCell(myPhrase);
					c01.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c01.setBackgroundColor(Color.WHITE);
					t.addCell(c01);
					
					myPhrase=new Phrase("Lumps",new Font(baseFont, font, Font.BOLD));
					PdfPCell c02 = new PdfPCell(myPhrase);
					c02.setBackgroundColor(Color.WHITE);
					c02.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c02);
					
					myPhrase=new Phrase("Waste/Tailing",new Font(baseFont,font, Font.BOLD));
					PdfPCell c04 = new PdfPCell(myPhrase);
					c04.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c04.setBackgroundColor(Color.WHITE);
					t.addCell(c04);
					
					myPhrase=new Phrase("  (a)Below 25%",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c05 = new PdfPCell(myPhrase);
					c05.setBackgroundColor(Color.WHITE);
					t.addCell(c05);
					
					ArrayList<String> oversizeProcess =new ArrayList<String>();
					oversizeProcess=getStockStructure("Mn:Below25%", oversizeProcessingDetails);
					for(int i=0;i<oversizeProcess.size();i++){
						myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
							PdfPCell c9 = new PdfPCell(myPhrase);
							c9.setBackgroundColor(Color.WHITE);
							t.addCell(c9);
						}
						
						myPhrase=new Phrase("  (b)25% to Below 35%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c13 = new PdfPCell(myPhrase);
						c13.setBackgroundColor(Color.WHITE);
						t.addCell(c13);
						
						oversizeProcess=getStockStructure("Mn:25%toBelow35%", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c1 = new PdfPCell(myPhrase);
									c1.setBackgroundColor(Color.WHITE);
									t.addCell(c1);
								}
								
						myPhrase=new Phrase("  (c)35% to Below 46%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c19 = new PdfPCell(myPhrase);
						c19.setBackgroundColor(Color.WHITE);
						t.addCell(c19);
						
						oversizeProcess=getStockStructure("Mn:35%toBelow46%", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c2= new PdfPCell(myPhrase);
									c2.setBackgroundColor(Color.WHITE);
									t.addCell(c2);
								}
								
						myPhrase=new Phrase("  (d)46% and above",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c26 = new PdfPCell(myPhrase);
						c26.setBackgroundColor(Color.WHITE);
						t.addCell(c26);
						
						oversizeProcess=getStockStructure("Mn:46%andabove", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c3 = new PdfPCell(myPhrase);
									c3.setBackgroundColor(Color.WHITE);
									t.addCell(c3);
								}
								
						myPhrase=new Phrase("  (e)Dioxide ore",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c32 = new PdfPCell(myPhrase);
						c32.setBackgroundColor(Color.WHITE);
						t.addCell(c32);
						
						oversizeProcess=getStockStructure("Mn:Dioxideore", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c4 = new PdfPCell(myPhrase);
									c4.setBackgroundColor(Color.WHITE);
									t.addCell(c4);
								}
								
						myPhrase=new Phrase("  (f)Concentrates",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c38 = new PdfPCell(myPhrase);
						c38.setBackgroundColor(Color.WHITE);
						t.addCell(c38);
						
						oversizeProcess=getStockStructure("Mn:Concentrates", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c5 = new PdfPCell(myPhrase);
									c5.setBackgroundColor(Color.WHITE);
									t.addCell(c5);
								}
						
						myPhrase=new Phrase("  Total",new Font(baseFont, font, Font.BOLD));
						PdfPCell c308 = new PdfPCell(myPhrase);
						c308.setBackgroundColor(Color.WHITE);
						t.addCell(c308);
						
						oversizeProcess=getStockStructure("Total", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell cc5 = new PdfPCell(myPhrase);
									cc5.setBackgroundColor(Color.WHITE);
									t.addCell(cc5);
								}
						
				}
				catch (Exception e) 
				{
					System.out.println("Error creating PDF form for Mining :  " + e);
					e.printStackTrace();
				}
				return t;	
			}	

		 @SuppressWarnings("unchecked")
		private PdfPTable createForDeatilsOfOversizeProcessingForAl(Map oversizeProcessingDetails)
			{
				float[] widths = {30,30,30,30};
				PdfPTable t = new PdfPTable(4);
				
				try
				{
					t.setWidthPercentage(100);
					t.setWidths(widths);
					
					Phrase myPhrase=new Phrase("Grade(%) of Al content",new Font(baseFont,font, Font.BOLD));
					PdfPCell c0 = new PdfPCell(myPhrase);
					c0.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c0.setBackgroundColor(Color.WHITE);
					t.addCell(c0);
					
					myPhrase=new Phrase("Fines",new Font(baseFont,font, Font.BOLD));
					PdfPCell c01 = new PdfPCell(myPhrase);
					c01.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c01.setBackgroundColor(Color.WHITE);
					t.addCell(c01);
					
					myPhrase=new Phrase("Lumps",new Font(baseFont, font, Font.BOLD));
					PdfPCell c02 = new PdfPCell(myPhrase);
					c02.setBackgroundColor(Color.WHITE);
					c02.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c02);
					
					myPhrase=new Phrase("Waste/Tailing",new Font(baseFont,font, Font.BOLD));
					PdfPCell c04 = new PdfPCell(myPhrase);
					c04.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c04.setBackgroundColor(Color.WHITE);
					t.addCell(c04);
					
					myPhrase=new Phrase("  (a)Below 40%",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c05 = new PdfPCell(myPhrase);
					c05.setBackgroundColor(Color.WHITE);
					t.addCell(c05);
					
					ArrayList<String> oversizeProcess =new ArrayList<String>();
					oversizeProcess=getStockStructure("Al:Below40%", oversizeProcessingDetails);
					for(int i=0;i<oversizeProcess.size();i++){
						myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
							PdfPCell c9 = new PdfPCell(myPhrase);
							c9.setBackgroundColor(Color.WHITE);
							t.addCell(c9);
						}
						
						myPhrase=new Phrase("  (b)40% to Below 45%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c13 = new PdfPCell(myPhrase);
						c13.setBackgroundColor(Color.WHITE);
						t.addCell(c13);
						
						oversizeProcess=getStockStructure("Al:40%toBelow45%", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c1 = new PdfPCell(myPhrase);
									c1.setBackgroundColor(Color.WHITE);
									t.addCell(c1);
								}
								
						myPhrase=new Phrase("  (c)45% to Below 50%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c19 = new PdfPCell(myPhrase);
						c19.setBackgroundColor(Color.WHITE);
						t.addCell(c19);
						
						oversizeProcess=getStockStructure("Al:45%toBelow50%", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c2= new PdfPCell(myPhrase);
									c2.setBackgroundColor(Color.WHITE);
									t.addCell(c2);
								}
								
						myPhrase=new Phrase("  (d)50% to Below 55%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c26 = new PdfPCell(myPhrase);
						c26.setBackgroundColor(Color.WHITE);
						t.addCell(c26);
						
						oversizeProcess=getStockStructure("Al:50%toBelow55%", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c3 = new PdfPCell(myPhrase);
									c3.setBackgroundColor(Color.WHITE);
									t.addCell(c3);
								}
								
						myPhrase=new Phrase("  (e)55% to Below 60%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c32 = new PdfPCell(myPhrase);
						c32.setBackgroundColor(Color.WHITE);
						t.addCell(c32);
						
						oversizeProcess=getStockStructure("Al:55%toBelow60%", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c4 = new PdfPCell(myPhrase);
									c4.setBackgroundColor(Color.WHITE);
									t.addCell(c4);
								}
								
						myPhrase=new Phrase("  (f)60% and above",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c38 = new PdfPCell(myPhrase);
						c38.setBackgroundColor(Color.WHITE);
						t.addCell(c38);
						
						oversizeProcess=getStockStructure("Al:60%andabove", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c5 = new PdfPCell(myPhrase);
									c5.setBackgroundColor(Color.WHITE);
									t.addCell(c5);
								}
						
						
						myPhrase=new Phrase("  (g)Cement",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c380 = new PdfPCell(myPhrase);
						c380.setBackgroundColor(Color.WHITE);
						t.addCell(c380);
						
						oversizeProcess=getStockStructure("OtherthanAl:Cement", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c50 = new PdfPCell(myPhrase);
									c50.setBackgroundColor(Color.WHITE);
									t.addCell(c50);
								}
						
						
						myPhrase=new Phrase("  (h)Abrasive",new Font(baseFont, font, Font.NORMAL));
						PdfPCell cc38 = new PdfPCell(myPhrase);
						cc38.setBackgroundColor(Color.WHITE);
						t.addCell(cc38);
						
						oversizeProcess=getStockStructure("OtherthanAl:Abrasive", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
							PdfPCell cc5 = new PdfPCell(myPhrase);
									cc5.setBackgroundColor(Color.WHITE);
									t.addCell(cc5);
								}
						
						
						myPhrase=new Phrase("  (i)Refactory",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c3c8 = new PdfPCell(myPhrase);
						c3c8.setBackgroundColor(Color.WHITE);
						t.addCell(c3c8);
						
						oversizeProcess=getStockStructure("OtherthanAl:Refactory", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c52 = new PdfPCell(myPhrase);
									c52.setBackgroundColor(Color.WHITE);
									t.addCell(c52);
								}
						

						myPhrase=new Phrase("  (j)Chemical",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c338 = new PdfPCell(myPhrase);
						c338.setBackgroundColor(Color.WHITE);
						t.addCell(c338);
						
						oversizeProcess=getStockStructure("OtherthanAl:Chemical", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell fc5 = new PdfPCell(myPhrase);
									fc5.setBackgroundColor(Color.WHITE);
									t.addCell(fc5);
								}
						
						myPhrase=new Phrase("  Total",new Font(baseFont, font, Font.BOLD));
						PdfPCell c308 = new PdfPCell(myPhrase);
						c308.setBackgroundColor(Color.WHITE);
						t.addCell(c308);
						
						oversizeProcess=getStockStructure("Total", oversizeProcessingDetails);
						for(int i=0;i<oversizeProcess.size();i++){
							myPhrase=new Phrase(oversizeProcess.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell cc5 = new PdfPCell(myPhrase);
									cc5.setBackgroundColor(Color.WHITE);
									t.addCell(cc5);
								}
						
				}
				catch (Exception e) 
				{
					System.out.println("Error creating PDF form for Mining :  " + e);
					e.printStackTrace();
				}
				return t;	
			}	

		 private PdfPTable createHeaderForProductGenerated()
			{
				float[] widths = {100};
				PdfPTable t = new PdfPTable(1);
				
				try
				{
					t.setWidthPercentage(100);
					t.setWidths(widths);
					
					Phrase myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c01 = new PdfPCell(myPhrase);
					c01.disableBorderSide(Rectangle.RIGHT);
					c01.disableBorderSide(Rectangle.LEFT);
					c01.disableBorderSide(Rectangle.BOTTOM);
					c01.setBackgroundColor(Color.WHITE);
					t.addCell(c01);
							
					myPhrase=new Phrase(" ",new Font(baseFont, font, Font.NORMAL));
					PdfPCell c38 = new PdfPCell(myPhrase);
					c38.setBorder(Rectangle.NO_BORDER);
					c38.setBackgroundColor(Color.WHITE);
					t.addCell(c38);
					
					myPhrase=new Phrase("(e)Product Genereated(b & d) and Closing balance after Sale/Export",new Font(baseFont, font, Font.BOLD));
					PdfPCell c26 = new PdfPCell(myPhrase);
					c26.setBackgroundColor(Color.WHITE);
					c26.setBorder(Rectangle.NO_BORDER);
					t.addCell(c26);
					
				}
				catch (Exception e) 
				{
					System.out.println("Error creating PDF form for Mining :  " + e);
					e.printStackTrace();
				}
				return t;	
			}	


		 @SuppressWarnings("unchecked")
		private PdfPTable createForProductGeneratedForFe(Map productGenerationDetails)
			{
				float[] widths = {30,30,30,30,30};
				PdfPTable t = new PdfPTable(5);
				
				try
				{
					t.setWidthPercentage(100);
					t.setWidths(widths);
					
					Phrase myPhrase=new Phrase("Grade(%) of Fe content",new Font(baseFont,font, Font.BOLD));
					PdfPCell c0 = new PdfPCell(myPhrase);
					c0.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c0.setBackgroundColor(Color.WHITE);
					t.addCell(c0);
					
					myPhrase=new Phrase("Opening Stock",new Font(baseFont,font, Font.BOLD));
					PdfPCell c01 = new PdfPCell(myPhrase);
					c01.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c01.setBackgroundColor(Color.WHITE);
					t.addCell(c01);
					
					myPhrase=new Phrase("Product from (b) and (d)",new Font(baseFont, font, Font.BOLD));
					PdfPCell c02 = new PdfPCell(myPhrase);
					c02.setBackgroundColor(Color.WHITE);
					c02.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c02);
					
					myPhrase=new Phrase("Despatch",new Font(baseFont,font, Font.BOLD));
					PdfPCell c04 = new PdfPCell(myPhrase);
					c04.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c04.setBackgroundColor(Color.WHITE);
					t.addCell(c04);
					
					myPhrase=new Phrase("Closing Stock",new Font(baseFont,font, Font.BOLD));
					PdfPCell c004 = new PdfPCell(myPhrase);
					c004.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c004.setBackgroundColor(Color.WHITE);
					t.addCell(c004);
					
					myPhrase=new Phrase("(i)Lumps",new Font(baseFont,font, Font.BOLD));
					PdfPCell c40 = new PdfPCell(myPhrase);
					c40.setBackgroundColor(Color.WHITE);
					t.addCell(c40);
					
					for(int i=0;i<4;i++){
						myPhrase=new Phrase(" ",new Font(baseFont,font, Font.NORMAL));
						PdfPCell c9 = new PdfPCell(myPhrase);
						c9.setBackgroundColor(Color.WHITE);
						t.addCell(c9);
					}
					
					myPhrase=new Phrase("  (a)Below 55%",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c05 = new PdfPCell(myPhrase);
					c05.setBackgroundColor(Color.WHITE);
					t.addCell(c05);
					
					ArrayList<String> productDetails =new ArrayList<String>();
					productDetails=getOreStructure("Fe:Lumps:Below55%", productGenerationDetails);
					for(int i=0;i<productDetails.size();i++){
						myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
							PdfPCell c9 = new PdfPCell(myPhrase);
							c9.setBackgroundColor(Color.WHITE);
							t.addCell(c9);
						}
						
						myPhrase=new Phrase("  (b)55% to below 58%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c13 = new PdfPCell(myPhrase);
						c13.setBackgroundColor(Color.WHITE);
						t.addCell(c13);
						
						productDetails=getOreStructure("Fe:Lumps:55%toBelow58%", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c1 = new PdfPCell(myPhrase);
									c1.setBackgroundColor(Color.WHITE);
									t.addCell(c1);
								}
								
						myPhrase=new Phrase("  (c)58% to below 60%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c19 = new PdfPCell(myPhrase);
						c19.setBackgroundColor(Color.WHITE);
						t.addCell(c19);
						
						productDetails=getOreStructure("Fe:Lumps:58%toBelow60%", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c2= new PdfPCell(myPhrase);
									c2.setBackgroundColor(Color.WHITE);
									t.addCell(c2);
								}
								
						myPhrase=new Phrase("  (d)60% to below 62%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c26 = new PdfPCell(myPhrase);
						c26.setBackgroundColor(Color.WHITE);
						t.addCell(c26);
						
						productDetails=getOreStructure("Fe:Lumps:60%toBelow62%", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c3 = new PdfPCell(myPhrase);
									c3.setBackgroundColor(Color.WHITE);
									t.addCell(c3);
								}
								
						myPhrase=new Phrase("  (e)62% to below 65%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c32 = new PdfPCell(myPhrase);
						c32.setBackgroundColor(Color.WHITE);
						t.addCell(c32);
						
						productDetails=getOreStructure("Fe:Lumps:62%toBelow65%", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c4 = new PdfPCell(myPhrase);
									c4.setBackgroundColor(Color.WHITE);
									t.addCell(c4);
								}
								
						myPhrase=new Phrase("  (f)65% and above",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c38 = new PdfPCell(myPhrase);
						c38.setBackgroundColor(Color.WHITE);
						t.addCell(c38);
						
						productDetails=getOreStructure("Fe:Lumps:65%andabove", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c5 = new PdfPCell(myPhrase);
									c5.setBackgroundColor(Color.WHITE);
									t.addCell(c5);
								}
						
						myPhrase=new Phrase("(i)Fines",new Font(baseFont,font, Font.BOLD));
						PdfPCell cf = new PdfPCell(myPhrase);
						cf.setBackgroundColor(Color.WHITE);
						t.addCell(cf);
						
						for(int i=0;i<4;i++){
							myPhrase=new Phrase(" ",new Font(baseFont,font, Font.NORMAL));
							PdfPCell ccc9 = new PdfPCell(myPhrase);
							ccc9.setBackgroundColor(Color.WHITE);
							t.addCell(ccc9);
						}
						
						myPhrase=new Phrase("  (a)Below 55%",new Font(baseFont,font, Font.NORMAL));
						PdfPCell cf2 = new PdfPCell(myPhrase);
						cf2.setBackgroundColor(Color.WHITE);
						t.addCell(cf2);
						
						productDetails=getOreStructure("Fe:Fines:Below55%", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
							PdfPCell cf3 = new PdfPCell(myPhrase);
							cf3.setBackgroundColor(Color.WHITE);
							t.addCell(cf3);
						}
						
						myPhrase=new Phrase("  (b)55% to below 58%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell cf4 = new PdfPCell(myPhrase);
						cf4.setBackgroundColor(Color.WHITE);
						t.addCell(cf4);
						
						productDetails=getOreStructure("Fe:Fines:55%toBelow58%", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell cf5 = new PdfPCell(myPhrase);
									cf5.setBackgroundColor(Color.WHITE);
									t.addCell(cf5);
								}
								
						myPhrase=new Phrase("  (c)58% to below 60%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell cf6 = new PdfPCell(myPhrase);
						cf6.setBackgroundColor(Color.WHITE);
						t.addCell(cf6);
						
						productDetails=getOreStructure("Fe:Fines:58%toBelow60%", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell cf7= new PdfPCell(myPhrase);
									cf7.setBackgroundColor(Color.WHITE);
									t.addCell(cf7);
								}
								
						myPhrase=new Phrase("  (d)60% to below 62%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell cf8 = new PdfPCell(myPhrase);
						cf8.setBackgroundColor(Color.WHITE);
						t.addCell(cf8);
						
						productDetails=getOreStructure("Fe:Fines:60%toBelow62%", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell cf9 = new PdfPCell(myPhrase);
									cf9.setBackgroundColor(Color.WHITE);
									t.addCell(cf9);
								}
								
						myPhrase=new Phrase("  (e)62% to below 65%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell cf10 = new PdfPCell(myPhrase);
						cf10.setBackgroundColor(Color.WHITE);
						t.addCell(cf10);
						
						productDetails=getOreStructure("Fe:Fines:62%toBelow65%", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell cf11 = new PdfPCell(myPhrase);
									cf11.setBackgroundColor(Color.WHITE);
									t.addCell(cf11);
								}
								
						myPhrase=new Phrase("  (f)65% and above",new Font(baseFont, font, Font.NORMAL));
						PdfPCell cf12 = new PdfPCell(myPhrase);
						cf12.setBackgroundColor(Color.WHITE);
						t.addCell(cf12);
						
						productDetails=getOreStructure("Fe:Fines:65%andabove", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell cf13 = new PdfPCell(myPhrase);
									cf13.setBackgroundColor(Color.WHITE);
									t.addCell(cf13);
								}
						
						myPhrase=new Phrase("  Total",new Font(baseFont, font, Font.BOLD));
						PdfPCell ct = new PdfPCell(myPhrase);
						ct.setBackgroundColor(Color.WHITE);
						t.addCell(ct);
						
						productDetails=getOreStructure("Total", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell ct1 = new PdfPCell(myPhrase);
									ct1.setBackgroundColor(Color.WHITE);
									t.addCell(ct1);
								}
						
						myPhrase=new Phrase("  Total Waste and Tailing",new Font(baseFont, font, Font.NORMAL));
						PdfPCell ct2 = new PdfPCell(myPhrase);
						ct2.setBackgroundColor(Color.WHITE);
						t.addCell(ct2);
						
						productDetails=getOreStructure("TotalWaste&Tailing", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell ct3 = new PdfPCell(myPhrase);
									ct3.setBackgroundColor(Color.WHITE);
									t.addCell(ct3);
								}
						
						myPhrase=new Phrase("  Total Closing stock of oversize",new Font(baseFont, font, Font.NORMAL));
						PdfPCell ct4 = new PdfPCell(myPhrase);
						ct4.setBackgroundColor(Color.WHITE);
						t.addCell(ct4);
						
						productDetails=getOreStructure("TotalClosingStockOfOversize", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell ct5 = new PdfPCell(myPhrase);
									ct5.setBackgroundColor(Color.WHITE);
									t.addCell(ct5);
								}
						
						myPhrase=new Phrase("  Reconciled",new Font(baseFont, font, Font.NORMAL));
						PdfPCell ct6 = new PdfPCell(myPhrase);
						ct6.setBackgroundColor(Color.WHITE);
						t.addCell(ct6);
						
						productDetails=getOreStructure("Reconciled", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell ct7 = new PdfPCell(myPhrase);
									ct7.setBackgroundColor(Color.WHITE);
									t.addCell(ct7);
								}

				}
				catch (Exception e) 
				{
					System.out.println("Error creating PDF form for Mining :  " + e);
					e.printStackTrace();
				}
				return t;	
			}	

		 @SuppressWarnings("unchecked")
		private PdfPTable createForProductGeneratedForAl(Map productGenerationDetails)
			{
				float[] widths = {30,30,30,30,30};
				PdfPTable t = new PdfPTable(5);
				
				try
				{
					t.setWidthPercentage(100);
					t.setWidths(widths);
					
					Phrase myPhrase=new Phrase("Grade(%) of Al content",new Font(baseFont,font, Font.BOLD));
					PdfPCell c0 = new PdfPCell(myPhrase);
					c0.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c0.setBackgroundColor(Color.WHITE);
					t.addCell(c0);
					
					myPhrase=new Phrase("Opening Stock",new Font(baseFont,font, Font.BOLD));
					PdfPCell c01 = new PdfPCell(myPhrase);
					c01.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c01.setBackgroundColor(Color.WHITE);
					t.addCell(c01);
					
					myPhrase=new Phrase("Product from (b) and (d)",new Font(baseFont, font, Font.BOLD));
					PdfPCell c02 = new PdfPCell(myPhrase);
					c02.setBackgroundColor(Color.WHITE);
					c02.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c02);
					
					myPhrase=new Phrase("Despatch",new Font(baseFont,font, Font.BOLD));
					PdfPCell c04 = new PdfPCell(myPhrase);
					c04.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c04.setBackgroundColor(Color.WHITE);
					t.addCell(c04);
					
					myPhrase=new Phrase("Closing Stock",new Font(baseFont,font, Font.BOLD));
					PdfPCell c004 = new PdfPCell(myPhrase);
					c004.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c004.setBackgroundColor(Color.WHITE);
					t.addCell(c004);
					
					myPhrase=new Phrase("  (a)Below 40%",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c05 = new PdfPCell(myPhrase);
					c05.setBackgroundColor(Color.WHITE);
					t.addCell(c05);
					
					ArrayList<String> productDetails =new ArrayList<String>();
					productDetails=getOreStructure("Al:Below40%", productGenerationDetails);
					for(int i=0;i<productDetails.size();i++){
						myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
						PdfPCell c9 = new PdfPCell(myPhrase);
						c9.setBackgroundColor(Color.WHITE);
						t.addCell(c9);
					}
					
					myPhrase=new Phrase("  (b)40% to Below 45%",new Font(baseFont, font, Font.NORMAL));
					PdfPCell c13 = new PdfPCell(myPhrase);
					c13.setBackgroundColor(Color.WHITE);
					t.addCell(c13);
					

					productDetails=getOreStructure("Al:40%toBelow45%", productGenerationDetails);
					for(int i=0;i<productDetails.size();i++){
						myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
							PdfPCell c9 = new PdfPCell(myPhrase);
							c9.setBackgroundColor(Color.WHITE);
							t.addCell(c9);
						}
						
						myPhrase=new Phrase("  (c)45% to Below 50%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c19 = new PdfPCell(myPhrase);
						c19.setBackgroundColor(Color.WHITE);
						t.addCell(c19);
						
						productDetails=getOreStructure("Al:45%toBelow50%", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c1 = new PdfPCell(myPhrase);
									c1.setBackgroundColor(Color.WHITE);
									t.addCell(c1);
								}
								
						myPhrase=new Phrase("  (d)50% to Below 55%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c26 = new PdfPCell(myPhrase);
						c26.setBackgroundColor(Color.WHITE);
						t.addCell(c26);
						
						productDetails=getOreStructure("Al:50%toBelow55%", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c2= new PdfPCell(myPhrase);
									c2.setBackgroundColor(Color.WHITE);
									t.addCell(c2);
								}
								
						myPhrase=new Phrase("  (e)55% to Below 60%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c32 = new PdfPCell(myPhrase);
						c32.setBackgroundColor(Color.WHITE);
						t.addCell(c32);
						
						productDetails=getOreStructure("Al:55%toBelow60%", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c3 = new PdfPCell(myPhrase);
									c3.setBackgroundColor(Color.WHITE);
									t.addCell(c3);
								}
								
						myPhrase=new Phrase("  (f)60% and above",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c38 = new PdfPCell(myPhrase);
						c38.setBackgroundColor(Color.WHITE);
						t.addCell(c38);
						
						productDetails=getOreStructure("Al:60%andabove", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c4 = new PdfPCell(myPhrase);
									c4.setBackgroundColor(Color.WHITE);
									t.addCell(c4);
								}
								
						myPhrase=new Phrase("  (g)Cement",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c380 = new PdfPCell(myPhrase);
						c380.setBackgroundColor(Color.WHITE);
						t.addCell(c380);
						
						productDetails=getOreStructure("OtherthanAl:Cement", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c5 = new PdfPCell(myPhrase);
									c5.setBackgroundColor(Color.WHITE);
									t.addCell(c5);
								}
						
						myPhrase=new Phrase("  (h)Abrasive",new Font(baseFont, font, Font.NORMAL));
						PdfPCell cc38 = new PdfPCell(myPhrase);
						cc38.setBackgroundColor(Color.WHITE);
						t.addCell(cc38);
						
						productDetails=getOreStructure("OtherthanAl:Abrasive", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
							PdfPCell cf1 = new PdfPCell(myPhrase);
							cf1.setBackgroundColor(Color.WHITE);
							t.addCell(cf1);
						}
						myPhrase=new Phrase("  (i)Refactory",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c3c8 = new PdfPCell(myPhrase);
						c3c8.setBackgroundColor(Color.WHITE);
						t.addCell(c3c8);
						
						productDetails=getOreStructure("OtherthanAl:Refactory", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
							PdfPCell cf3 = new PdfPCell(myPhrase);
							cf3.setBackgroundColor(Color.WHITE);
							t.addCell(cf3);
						}
						
						myPhrase=new Phrase("  (j)Chemical",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c338 = new PdfPCell(myPhrase);
						c338.setBackgroundColor(Color.WHITE);
						t.addCell(c338);
						
						productDetails=getOreStructure("OtherthanAl:Chemical", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell cf5 = new PdfPCell(myPhrase);
									cf5.setBackgroundColor(Color.WHITE);
									t.addCell(cf5);
								}
						
						myPhrase=new Phrase("  Total",new Font(baseFont, font, Font.BOLD));
						PdfPCell ct = new PdfPCell(myPhrase);
						ct.setBackgroundColor(Color.WHITE);
						t.addCell(ct);
						
						productDetails=getOreStructure("Total", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell ct1 = new PdfPCell(myPhrase);
									ct1.setBackgroundColor(Color.WHITE);
									t.addCell(ct1);
								}
						
						myPhrase=new Phrase("  Total Waste and Tailing",new Font(baseFont, font, Font.NORMAL));
						PdfPCell ct2 = new PdfPCell(myPhrase);
						ct2.setBackgroundColor(Color.WHITE);
						t.addCell(ct2);
						
						productDetails=getOreStructure("TotalWaste&Tailing", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell ct3 = new PdfPCell(myPhrase);
									ct3.setBackgroundColor(Color.WHITE);
									t.addCell(ct3);
								}
						
						myPhrase=new Phrase("  Total Closing stock of oversize",new Font(baseFont, font, Font.NORMAL));
						PdfPCell ct4 = new PdfPCell(myPhrase);
						ct4.setBackgroundColor(Color.WHITE);
						t.addCell(ct4);
						
						productDetails=getOreStructure("TotalClosingStockOfOversize", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell ct5 = new PdfPCell(myPhrase);
									ct5.setBackgroundColor(Color.WHITE);
									t.addCell(ct5);
								}
						
						myPhrase=new Phrase("  Reconciled",new Font(baseFont, font, Font.NORMAL));
						PdfPCell ct6 = new PdfPCell(myPhrase);
						ct6.setBackgroundColor(Color.WHITE);
						t.addCell(ct6);
						
						productDetails=getOreStructure("Reconciled", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell ct7 = new PdfPCell(myPhrase);
									ct7.setBackgroundColor(Color.WHITE);
									t.addCell(ct7);
								}

				}
				catch (Exception e) 
				{
					System.out.println("Error creating PDF form for Mining :  " + e);
					e.printStackTrace();
				}
				return t;	
			}	

		 @SuppressWarnings("unchecked")
		private PdfPTable createForProductGeneratedForMn(Map productGenerationDetails)
			{
				float[] widths = {30,30,30,30,30};
				PdfPTable t = new PdfPTable(5);
				
				try
				{
					t.setWidthPercentage(100);
					t.setWidths(widths);
					
					Phrase myPhrase=new Phrase("Grade(%) of Mn content",new Font(baseFont,font, Font.BOLD));
					PdfPCell c0 = new PdfPCell(myPhrase);
					c0.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c0.setBackgroundColor(Color.WHITE);
					t.addCell(c0);
					
					myPhrase=new Phrase("Opening Stock",new Font(baseFont,font, Font.BOLD));
					PdfPCell c01 = new PdfPCell(myPhrase);
					c01.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c01.setBackgroundColor(Color.WHITE);
					t.addCell(c01);
					
					myPhrase=new Phrase("Product from (b) and (d)",new Font(baseFont, font, Font.BOLD));
					PdfPCell c02 = new PdfPCell(myPhrase);
					c02.setBackgroundColor(Color.WHITE);
					c02.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c02);
					
					myPhrase=new Phrase("Despatch",new Font(baseFont,font, Font.BOLD));
					PdfPCell c04 = new PdfPCell(myPhrase);
					c04.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c04.setBackgroundColor(Color.WHITE);
					t.addCell(c04);
					
					myPhrase=new Phrase("Closing Stock",new Font(baseFont,font, Font.BOLD));
					PdfPCell c004 = new PdfPCell(myPhrase);
					c004.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c004.setBackgroundColor(Color.WHITE);
					t.addCell(c004);
					
					myPhrase=new Phrase("  (a)Below 25%",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c05 = new PdfPCell(myPhrase);
					c05.setBackgroundColor(Color.WHITE);
					t.addCell(c05);
					
					ArrayList<String> productDetails =new ArrayList<String>();
					productDetails=getOreStructure("Mn:Below25%", productGenerationDetails);
					for(int i=0;i<productDetails.size();i++){
						myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
						PdfPCell c9 = new PdfPCell(myPhrase);
						c9.setBackgroundColor(Color.WHITE);
						t.addCell(c9);
					}
					
					myPhrase=new Phrase("  (b)25% to Below 35%",new Font(baseFont, font, Font.NORMAL));
					PdfPCell c13 = new PdfPCell(myPhrase);
					c13.setBackgroundColor(Color.WHITE);
					t.addCell(c13);
					
					productDetails=getOreStructure("Mn:25%toBelow35%", productGenerationDetails);
					for(int i=0;i<productDetails.size();i++){
						myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
							PdfPCell c9 = new PdfPCell(myPhrase);
							c9.setBackgroundColor(Color.WHITE);
							t.addCell(c9);
						}
						
						myPhrase=new Phrase("  (c)35% to Below 46%",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c19 = new PdfPCell(myPhrase);
						c19.setBackgroundColor(Color.WHITE);
						t.addCell(c19);
						
						productDetails=getOreStructure("Mn:35%toBelow46%", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c1 = new PdfPCell(myPhrase);
									c1.setBackgroundColor(Color.WHITE);
									t.addCell(c1);
								}
								
						myPhrase=new Phrase("  (d)46% and above",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c26 = new PdfPCell(myPhrase);
						c26.setBackgroundColor(Color.WHITE);
						t.addCell(c26);
						
						productDetails=getOreStructure("Mn:46%andabove", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c2= new PdfPCell(myPhrase);
									c2.setBackgroundColor(Color.WHITE);
									t.addCell(c2);
								}
								
						myPhrase=new Phrase("  (e)Dioxide ore",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c32 = new PdfPCell(myPhrase);
						c32.setBackgroundColor(Color.WHITE);
						t.addCell(c32);
						
						productDetails=getOreStructure("Mn:Dioxideore", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c3 = new PdfPCell(myPhrase);
									c3.setBackgroundColor(Color.WHITE);
									t.addCell(c3);
								}
								
						myPhrase=new Phrase("  (f)Concentrates",new Font(baseFont, font, Font.NORMAL));
						PdfPCell c38 = new PdfPCell(myPhrase);
						c38.setBackgroundColor(Color.WHITE);
						t.addCell(c38);
						
						productDetails=getOreStructure("Mn:Concentrates", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell c4 = new PdfPCell(myPhrase);
									c4.setBackgroundColor(Color.WHITE);
									t.addCell(c4);
								}
								
     					myPhrase=new Phrase("  Total",new Font(baseFont, font, Font.BOLD));
						PdfPCell ct = new PdfPCell(myPhrase);
						ct.setBackgroundColor(Color.WHITE);
						t.addCell(ct);
						
						productDetails=getOreStructure("Total", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell ct1 = new PdfPCell(myPhrase);
									ct1.setBackgroundColor(Color.WHITE);
									t.addCell(ct1);
								}
						
						myPhrase=new Phrase("  Total Waste and Tailing",new Font(baseFont, font, Font.NORMAL));
						PdfPCell ct2 = new PdfPCell(myPhrase);
						ct2.setBackgroundColor(Color.WHITE);
						t.addCell(ct2);
						
						productDetails=getOreStructure("TotalWasteTailing", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell ct3 = new PdfPCell(myPhrase);
									ct3.setBackgroundColor(Color.WHITE);
									t.addCell(ct3);
								}
						
						myPhrase=new Phrase("  Total Closing stock of oversize",new Font(baseFont, font, Font.NORMAL));
						PdfPCell ct4 = new PdfPCell(myPhrase);
						ct4.setBackgroundColor(Color.WHITE);
						t.addCell(ct4);
						
						productDetails=getOreStructure("TotalClosingStockOfOversize", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell ct5 = new PdfPCell(myPhrase);
									ct5.setBackgroundColor(Color.WHITE);
									t.addCell(ct5);
								}
						
						myPhrase=new Phrase("  Reconciled",new Font(baseFont, font, Font.NORMAL));
						PdfPCell ct6 = new PdfPCell(myPhrase);
						ct6.setBackgroundColor(Color.WHITE);
						t.addCell(ct6);
						
						productDetails=getOreStructure("Reconciled", productGenerationDetails);
						for(int i=0;i<productDetails.size();i++){
							myPhrase=new Phrase(productDetails.get(i),new Font(baseFont,font, Font.NORMAL));
									PdfPCell ct7 = new PdfPCell(myPhrase);
									ct7.setBackgroundColor(Color.WHITE);
									t.addCell(ct7);
								}

				}
				catch (Exception e) 
				{
					System.out.println("Error creating PDF form for Mining :  " + e);
					e.printStackTrace();
				}
				return t;	
			}	

		 
		 private PdfPTable createImage () {

				float[] width = {20};
				PdfPTable maintable = new PdfPTable(1);
				
				try {
					
					String path = getServletContext().getRealPath("/")+"Main/modules/ironMining/images/dmgLogo.png";
					Image img2 = Image.getInstance(path);
					
					maintable.setWidthPercentage(20);
					maintable.setWidths(width);
				   
					Phrase myPhrase=new Phrase("",new Font(baseFont, 1, Font.NORMAL));
					PdfPCell ci0 = new PdfPCell(myPhrase);
					ci0.setBackgroundColor(Color.WHITE);
					ci0.setBorder(Rectangle.NO_BORDER);
					maintable.addCell(ci0);
					
					myPhrase=new Phrase("",new Font(baseFont, 1, Font.NORMAL));
					PdfPCell ci1 = new PdfPCell(myPhrase);
					ci1.setBackgroundColor(Color.WHITE);
					ci1.setBorder(Rectangle.NO_BORDER);
					maintable.addCell(ci1);
					
					myPhrase=new Phrase("",new Font(baseFont, 1, Font.NORMAL));
					PdfPCell ci12 = new PdfPCell(myPhrase);
					ci12.setBackgroundColor(Color.WHITE);
					ci12.setBorder(Rectangle.NO_BORDER);
					maintable.addCell(ci12);
					
					myPhrase=new Phrase("",new Font(baseFont, 1, Font.NORMAL));
					PdfPCell ci11 = new PdfPCell(myPhrase);
					ci11.setBackgroundColor(Color.WHITE);
					ci11.setBorder(Rectangle.NO_BORDER);
					maintable.addCell(ci11);
					
					myPhrase=new Phrase("",new Font(baseFont, 1, Font.NORMAL));
					PdfPCell ci10 = new PdfPCell(myPhrase);
					ci10.setBackgroundColor(Color.WHITE);
					ci10.setBorder(Rectangle.NO_BORDER);
					maintable.addCell(ci10);
					
					myPhrase=new Phrase("",new Font(baseFont, 1, Font.NORMAL));
					PdfPCell ci2 = new PdfPCell(myPhrase);
					ci2.setBackgroundColor(Color.WHITE);
					ci2.setBorder(Rectangle.NO_BORDER);
					maintable.addCell(ci2);
					
					myPhrase=new Phrase("",new Font(baseFont, 1, Font.NORMAL));
					PdfPCell ci = new PdfPCell(myPhrase);
					ci.setBackgroundColor(Color.WHITE);
					ci.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					ci.addElement(img2);
					ci.setBorder(Rectangle.NO_BORDER);
					ci.disableBorderSide(Rectangle.TOP);
					maintable.addCell(ci);
				    
				} catch (Exception e) {
					e.printStackTrace();
				}
				return maintable;
			}
		 private PdfPTable createChallanHeader () {

				float[] width = {100};
				PdfPTable maintable = new PdfPTable(1);
				
				try {
					
					maintable.setWidthPercentage(100);
					maintable.setWidths(width);
					
					Phrase myPhrase=new Phrase("Government of Goa",new Font(baseFont,11, Font.NORMAL));
				    PdfPCell c = new PdfPCell(myPhrase);
				    c.setBorder(Rectangle.NO_BORDER);
				    c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				    c.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c);
				    
				    myPhrase=new Phrase("Directorate of Mines & Geology",new Font(baseFont,13, Font.NORMAL));
				    PdfPCell cc = new PdfPCell(myPhrase);
				    cc.setBorder(Rectangle.NO_BORDER);
				    cc.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				    cc.setBackgroundColor(Color.WHITE);
				    maintable.addCell(cc);
				    
				    myPhrase=new Phrase("Ground Floor, Institute of Menezes Braganza, Panaji, Goa",new Font(baseFont,11, Font.NORMAL));
				    PdfPCell cm = new PdfPCell(myPhrase);
				    cm.setBorder(Rectangle.NO_BORDER);
				    cm.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				    cm.setBackgroundColor(Color.WHITE);
				    maintable.addCell(cm);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c0 = new PdfPCell(myPhrase);
				    c0.setBorder(Rectangle.NO_BORDER);
				    c0.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    c0.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c0);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c2= new PdfPCell(myPhrase);
				    c2.setBorder(Rectangle.NO_BORDER);
				    c2.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    c2.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c2);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c3= new PdfPCell(myPhrase);
				    c3.setBorder(Rectangle.NO_BORDER);
				    c3.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    c3.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c3);
				    
				    myPhrase=new Phrase("Royalty Paid Challan Details ",new Font(baseFont,15, Font.UNDERLINE));
				    PdfPCell ck = new PdfPCell(myPhrase);
				    ck.setBorder(Rectangle.NO_BORDER);
				    ck.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				    ck.setBackgroundColor(Color.WHITE);
				    maintable.addCell(ck);
				    
					myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c1= new PdfPCell(myPhrase);
				    c1.setBorder(Rectangle.NO_BORDER);
				    c1.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    c1.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c1);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c4= new PdfPCell(myPhrase);
				    c4.setBorder(Rectangle.NO_BORDER);
				    c4.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    c4.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c4);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c5= new PdfPCell(myPhrase);
				    c5.setBorder(Rectangle.NO_BORDER);
				    c5.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    c5.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c5);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c6= new PdfPCell(myPhrase);
				    c6.setBorder(Rectangle.NO_BORDER);
				    c6.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    c6.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c6);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c7= new PdfPCell(myPhrase);
				    c7.setBorder(Rectangle.NO_BORDER);
				    c7.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c7);
				    
				} catch (Exception e) {
					e.printStackTrace();
				}
				return maintable;
			}
		 
		 private PdfPTable createFormHeader() {

				float[] width = {100};
				PdfPTable maintable = new PdfPTable(1);
				
				try {
					
					maintable.setWidthPercentage(100);
					maintable.setWidths(width);
					
				    
				    Phrase myPhrase=new Phrase("Processing Outside The Mining Lease",new Font(baseFont,15, Font.UNDERLINE));
				    PdfPCell ck = new PdfPCell(myPhrase);
				    ck.setBorder(Rectangle.NO_BORDER);
				    ck.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				    ck.setBackgroundColor(Color.WHITE);
				    maintable.addCell(ck);
				    
					myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c1= new PdfPCell(myPhrase);
				    c1.setBorder(Rectangle.NO_BORDER);
				    c1.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    c1.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c1);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c4= new PdfPCell(myPhrase);
				    c4.setBorder(Rectangle.NO_BORDER);
				    c4.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    c4.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c4);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c5= new PdfPCell(myPhrase);
				    c5.setBorder(Rectangle.NO_BORDER);
				    c5.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    c5.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c5);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c6= new PdfPCell(myPhrase);
				    c6.setBorder(Rectangle.NO_BORDER);
				    c6.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				    c6.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c6);
				    
				    myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				    PdfPCell c7= new PdfPCell(myPhrase);
				    c7.setBorder(Rectangle.NO_BORDER);
				    c7.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c7);
				    
				} catch (Exception e) {
					e.printStackTrace();
				}
				return maintable;
			}

		 
		 private PdfPTable createdetails (String MineCode,String tcNo,String month,String year) {

				float[] width = {50,70,50,50};
				PdfPTable maintable = new PdfPTable(4);
				try {
					
					maintable.setWidthPercentage(100);
					maintable.setWidths(width);
					
					Phrase myPhrase=new Phrase("Mine Code:",new Font(baseFont,11, Font.NORMAL));
				    PdfPCell c = new PdfPCell(myPhrase);
				    c.setBorder(Rectangle.NO_BORDER);
				    c.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c);
				    
				    myPhrase=new Phrase(MineCode,new Font(baseFont,11, Font.NORMAL));
				    PdfPCell cc = new PdfPCell(myPhrase);
				    cc.setBorder(Rectangle.NO_BORDER);
				    cc.setBackgroundColor(Color.WHITE);
				    maintable.addCell(cc);
				    
				    myPhrase=new Phrase("Month and Year:",new Font(baseFont,11, Font.NORMAL));
				    PdfPCell cm = new PdfPCell(myPhrase);
				    cm.setBorder(Rectangle.NO_BORDER);
				    cm.setBackgroundColor(Color.WHITE);
				    maintable.addCell(cm);
				    
				    myPhrase=new Phrase(month+" "+year,new Font(baseFont,11, Font.NORMAL));
				    PdfPCell c0 = new PdfPCell(myPhrase);
				    c0.setBorder(Rectangle.NO_BORDER);
				    c0.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c0);
				    
					myPhrase=new Phrase("",new Font(baseFont,11, Font.NORMAL));
				    PdfPCell cc11 = new PdfPCell(myPhrase);
				    cc11.setBorder(Rectangle.NO_BORDER);
				    cc11.setBackgroundColor(Color.WHITE);
				    maintable.addCell(cc11);
				    
				    myPhrase=new Phrase("",new Font(baseFont,11, Font.NORMAL));
				    PdfPCell cc1 = new PdfPCell(myPhrase);
				    cc1.setBorder(Rectangle.NO_BORDER);
				    cc1.setBackgroundColor(Color.WHITE);
				    maintable.addCell(cc1);
				    
				    myPhrase=new Phrase("",new Font(baseFont,11, Font.NORMAL));
				    PdfPCell cm2 = new PdfPCell(myPhrase);
				    cm2.setBorder(Rectangle.NO_BORDER);
				    cm2.setBackgroundColor(Color.WHITE);
				    maintable.addCell(cm2);
				    
				    myPhrase=new Phrase("",new Font(baseFont,11, Font.NORMAL));
				    PdfPCell c03 = new PdfPCell(myPhrase);
				    c03.setBorder(Rectangle.NO_BORDER);
				    c03.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c03);
				    
				    myPhrase=new Phrase("TC Number:",new Font(baseFont,11, Font.NORMAL));
				    PdfPCell c2= new PdfPCell(myPhrase);
				    c2.setBorder(Rectangle.NO_BORDER);
				    c2.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c2);
				    
				    myPhrase=new Phrase(tcNo,new Font(baseFont,11, Font.NORMAL));
				    PdfPCell c3= new PdfPCell(myPhrase);
				    c3.setBorder(Rectangle.NO_BORDER);
				    c3.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c3);
				    
				    myPhrase=new Phrase("",new Font(baseFont,11, Font.NORMAL));
				    PdfPCell ck = new PdfPCell(myPhrase);
				    ck.setBorder(Rectangle.NO_BORDER);
				    ck.setBackgroundColor(Color.WHITE);
				    maintable.addCell(ck);
				    
					myPhrase=new Phrase("",new Font(baseFont,11, Font.NORMAL));
				    PdfPCell c1= new PdfPCell(myPhrase);
				    c1.setBorder(Rectangle.NO_BORDER);
				    c1.setBackgroundColor(Color.WHITE);
				    maintable.addCell(c1);
				    
				} catch (Exception e) {
					e.printStackTrace();
				}
				return maintable;
			}
		 private PdfPTable createTableForChallanDetails(ArrayList<Object> challanDetails,ArrayList<String> total)
			{
				float[] widths = {30,30,30,30,30,30,30};
				PdfPTable t = new PdfPTable(7);
				
				try
				{
					t.setWidthPercentage(100);
					t.setWidths(widths);
					
					String totalQuantity=total.get(0);
					String royality=total.get(1);
					String valuePaid=total.get(2);
					
					Phrase myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
					PdfPCell cc = new PdfPCell(myPhrase);
					cc.setBorder(Rectangle.NO_BORDER);
					cc.setBackgroundColor(Color.WHITE);
					t.addCell(cc);
					
					myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c2c = new PdfPCell(myPhrase);
					c2c.setBorder(Rectangle.NO_BORDER);
					c2c.setBackgroundColor(Color.WHITE);
					t.addCell(c2c);
					
					myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
					PdfPCell c3c = new PdfPCell(myPhrase);
					c3c.setBorder(Rectangle.NO_BORDER);
					c3c.setBackgroundColor(Color.WHITE);
					t.addCell(c3c);
					
					myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c4c = new PdfPCell(myPhrase);
					c4c.setBorder(Rectangle.NO_BORDER);
					c4c.setBackgroundColor(Color.WHITE);
					t.addCell(c4c);
					
					myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
					PdfPCell cc0 = new PdfPCell(myPhrase);
					cc0.setBorder(Rectangle.NO_BORDER);
					cc0.setBackgroundColor(Color.WHITE);
					t.addCell(cc0);
					
					myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
					PdfPCell c2c0 = new PdfPCell(myPhrase);
					c2c0.setBorder(Rectangle.NO_BORDER);
					c2c0.setBackgroundColor(Color.WHITE);
					t.addCell(c2c0);
					
					myPhrase=new Phrase("",new Font(baseFont, font, Font.NORMAL));
					PdfPCell c3c1 = new PdfPCell(myPhrase);
					c3c1.setBorder(Rectangle.NO_BORDER);
					c3c1.setBackgroundColor(Color.WHITE);
					t.addCell(c3c1);
					
					myPhrase=new Phrase("Challan Number",new Font(baseFont,11, Font.NORMAL));
					PdfPCell c2 = new PdfPCell(myPhrase);
					c2.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c2.setBackgroundColor(Color.WHITE);
					t.addCell(c2);
					
					myPhrase=new Phrase("Challan Date",new Font(baseFont,11, Font.NORMAL));
					PdfPCell c0002 = new PdfPCell(myPhrase);
					c0002.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c0002.setBackgroundColor(Color.WHITE);
					t.addCell(c0002);
					
					myPhrase=new Phrase("Quantity",new Font(baseFont, 11, Font.NORMAL));
					PdfPCell d3 = new PdfPCell(myPhrase);
					d3.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					d3.setBackgroundColor(Color.WHITE);
					t.addCell(d3);
					
					myPhrase=new Phrase("Grade",new Font(baseFont,11, Font.NORMAL));
					PdfPCell d4 = new PdfPCell(myPhrase);
					d4.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					d4.setBackgroundColor(Color.WHITE);
					t.addCell(d4);
					
					myPhrase=new Phrase("Type",new Font(baseFont,11, Font.NORMAL));
					PdfPCell d1 = new PdfPCell(myPhrase);
					d1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					d1.setBackgroundColor(Color.WHITE);
					t.addCell(d1);
					
					myPhrase=new Phrase("Provisional Royalty Rate",new Font(baseFont,11, Font.NORMAL));
					PdfPCell d0 = new PdfPCell(myPhrase);
					d0.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					d0.setBackgroundColor(Color.WHITE);
					t.addCell(d0);
					
					myPhrase=new Phrase("Value Paid",new Font(baseFont,11, Font.NORMAL));
					PdfPCell d004 = new PdfPCell(myPhrase);
					d004.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					d004.setBackgroundColor(Color.WHITE);
					t.addCell(d004);
					
					if(challanDetails.size()>0){
						for(int i=0;i<challanDetails.size();i++){
							myPhrase=new Phrase((String) challanDetails.get(i),new Font(baseFont,11, Font.NORMAL));
							PdfPCell c9 = new PdfPCell(myPhrase);
							c9.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
							c9.setBackgroundColor(Color.WHITE);
							t.addCell(c9);
						}
					}
					myPhrase=new Phrase("Total",new Font(baseFont,11, Font.NORMAL));
					PdfPCell c01 = new PdfPCell(myPhrase);
					c01.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c01.setBackgroundColor(Color.WHITE);
					t.addCell(c01);
					
					myPhrase=new Phrase("",new Font(baseFont,11, Font.NORMAL));
					PdfPCell c200 = new PdfPCell(myPhrase);
					c200.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c200.setBackgroundColor(Color.WHITE);
					t.addCell(c200);
					
					
					myPhrase=new Phrase(totalQuantity,new Font(baseFont, 11, Font.NORMAL));
					PdfPCell c30 = new PdfPCell(myPhrase);
					c30.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c30.setBackgroundColor(Color.WHITE);
					t.addCell(c30);
					
					myPhrase=new Phrase("",new Font(baseFont,11, Font.NORMAL));
					PdfPCell c40 = new PdfPCell(myPhrase);
					c40.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c40.setBackgroundColor(Color.WHITE);
					t.addCell(c40);
					
					myPhrase=new Phrase("",new Font(baseFont,11, Font.NORMAL));
					PdfPCell c230 = new PdfPCell(myPhrase);
					c230.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c230.setBackgroundColor(Color.WHITE);
					t.addCell(c230);
					
					myPhrase=new Phrase(royality,new Font(baseFont, 11, Font.NORMAL));
					PdfPCell c330 = new PdfPCell(myPhrase);
					c330.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c330.setBackgroundColor(Color.WHITE);
					t.addCell(c330);
					
					myPhrase=new Phrase(valuePaid,new Font(baseFont,11, Font.NORMAL));
					PdfPCell c430 = new PdfPCell(myPhrase);
					c430.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c430.setBackgroundColor(Color.WHITE);
					t.addCell(c430);
				}
				catch (Exception e) 
				{
					System.out.println("Error creating PDF form for Mining :  " + e);
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
			System.out.println("Error printing pdf form : " + e);
			e.printStackTrace();
		}
	}

	//------------------------------------- Mine Details --------------------------------------//
	@SuppressWarnings("unchecked")
	public HashMap getDataForMineDetails( int  id) {
		 
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		HashMap dataMap = new HashMap();
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
		SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_MINE_DETAILS);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				dataMap.put("regNo", rs.getString("REGISTRATION_NO"));
				dataMap.put("mineCode", rs.getString("MINE_CODE"));
				dataMap.put("mineralName", rs.getString("MINERAL_NAME"));
				dataMap.put("ironOreName", rs.getString("TYPE_OF_ORE"));
				dataMap.put("mineName", rs.getString("NAME_OF_MINE"));
				dataMap.put("otherMineral",rs.getString("OTHER_MINERAL_NAME"));
				dataMap.put("village", rs.getString("VILLAGE"));
				dataMap.put("postOffice", rs.getString("AREA"));
				dataMap.put("faxNo", rs.getString("FAX_NO"));
				dataMap.put("phoneNo", rs.getString("PHONE_NO"));
				dataMap.put("tcEmail", rs.getString("EMAIL_ID"));
				dataMap.put("tcPin", rs.getString("PIN"));
				dataMap.put("tcState", rs.getString("STATE_NAME"));
				dataMap.put("tcDistrict", rs.getString("DISTRICT_NAME"));
				dataMap.put("tcTaluka", rs.getString("TALUKA_NAME"));
				dataMap.put("rentPaid", rs.getString("RENT_PAID"));
				dataMap.put("royalityPaid", rs.getString("ROYALTY_PAID"));
				dataMap.put("deadRent", rs.getString("DEAD_RENT_PAID"));
				dataMap.put("productionReason", rs.getString("INC_DEC_PROD_REASON"));
				dataMap.put("gradeReason", rs.getString("INC_DEC_GRADE_REASON"));
				dataMap.put("mineWorkDays", rs.getString("MINE_WORK_DAYS"));
				dataMap.put("mineNonWorkDays", rs.getString("MINE_NON_WORK_DAYS"));
				dataMap.put("reasonForNotWork", rs.getString("REASON_FOR_NOT_WORK"));
				dataMap.put("technicalStaff", rs.getString("TECHNICAL_STAFF"));
				dataMap.put("totalSalary", rs.getString("TOTAL_SALARIES"));
				dataMap.put("place", rs.getString("PLACE"));
				dataMap.put("date", ddmmyyyy.format(yyyymmdd.parse(rs.getString("ENTERED_DATE"))));
				dataMap.put("nameinfull", rs.getString("ENTERED_BY"));
				dataMap.put("designation", rs.getString("DESIGNATION"));
				dataMap.put("region", rs.getString("REGION"));
				dataMap.put("pinCode", rs.getString("PIN_CODE"));
				dataMap.put("tcNo", rs.getString("TC_NO"));
				dataMap.put("month", rs.getString("Month_Name"));
				dataMap.put("year", rs.getString("YEAR"));
				dataMap.put("otherRemark", rs.getString("OTHER_REMARKS"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return dataMap;
	}
	
	//------------------------------------- Owner Details --------------------------------------//
	@SuppressWarnings("unchecked")
	public HashMap getOwnerDetails(int id) {
		 
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		HashMap dataMap = new HashMap();
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_OWNER_DETAILS);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				dataMap.put("contactPerson", rs.getString("CONTACT_PERSON"));
				dataMap.put("village", rs.getString("VILLAGE"));
				dataMap.put("postOffice", rs.getString("POST_OFFICE"));
				dataMap.put("emailId", rs.getString("EMAIL_ID"));
				dataMap.put("faxNo", rs.getString("FAX_NO"));
				dataMap.put("phoneNo", rs.getString("PHONE_NO"));
				dataMap.put("pin", rs.getString("PIN"));
				dataMap.put("ownerState", rs.getString("STATE_NAME"));
				dataMap.put("ownerDistrict", rs.getString("DISTRICT_NAME"));
				dataMap.put("ownerTaluk", rs.getString("TALUKA_NAME"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return dataMap;
	}
	
	//------------------------------------- Daily Employment Details --------------------------------------//
	@SuppressWarnings("unchecked")
	public HashMap getDailyEmploymentDetails( int  id) {
		 
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		HashMap dataMap = new HashMap();
		ArrayList<Object> informationList = new ArrayList<Object>();
		ArrayList<Object> finalList = new ArrayList<Object>();
		try {
			int count=0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_EMPLOYMENT_DETAILS);
			pstmt.setInt(1, id);
			pstmt.setInt(2, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				informationList = new ArrayList<Object>();
				informationList.add( rs.getString("DIRECT_MALE"));
				informationList.add( rs.getString("DIRECT_FEMALE"));
				informationList.add( rs.getString("CONTRACT_MALE"));
				informationList.add( rs.getString("CONTRACT_FEMALE"));
				informationList.add( rs.getString("WAGES_DIRECT"));
				informationList.add( rs.getString("WAGES_CONTRACT"));
				dataMap.put(rs.getString("WORK_PLACE").replaceAll("\\s",""), informationList);
			}
			finalList.add(informationList);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return dataMap;
	}

	//------------------------------------- Grade wise Production Details --------------------------------------//
	@SuppressWarnings("unchecked")
	public HashMap getGradeWiseProductionDetails( int  id) {
		 
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		HashMap dataMap = new HashMap();
		ArrayList<Object> informationList = new ArrayList<Object>();
		try {
			int count=0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_GRADEWISE_PRODUCTION_DETAILS);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				informationList = new ArrayList<Object>();
				informationList.add( rs.getString("OPENING_STOCK"));
				informationList.add( rs.getString("PRODUCTION"));
				informationList.add( rs.getString("DESPATCHES"));
				informationList.add( rs.getString("CLOSING_STOCK"));
				informationList.add( rs.getString("EX_MINE_PRICE"));
				dataMap.put(rs.getString("GRADE").replaceAll("\\s",""), informationList);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return dataMap;
	}
	
	//------------------------------------- Production and Stocks Details --------------------------------------//
	@SuppressWarnings("unchecked")
	public HashMap getProductionAndStocksDetails( int  id) {
		 
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		HashMap dataMap = new HashMap();
		ArrayList<Object> informationList = new ArrayList<Object>();
		try {
			int count=0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_PRODUCTION_AND_STOCKS_DETAILS);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				informationList = new ArrayList<Object>();
				informationList.add( rs.getString("OPENING_STOCK"));
				informationList.add( rs.getString("PRODUCTION"));
				informationList.add( rs.getString("CLOSING_STOCK"));
				dataMap.put(rs.getString("CATEGORY").replaceAll("\\s",""), informationList);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return dataMap;
	}
	
	//------------------------------------- Deduction Details --------------------------------------//
	@SuppressWarnings("unchecked")
	public HashMap getDeductionDetails( int  id) {
		 
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		HashMap dataMap = new HashMap();
		ArrayList<Object> informationList = new ArrayList<Object>();
		try {
			int count=0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_DEDUCTION_DETAILS);
			pstmt.setInt(1, id);
			pstmt.setInt(2, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				informationList = new ArrayList<Object>();
				informationList.add( rs.getString("UNIT_RS_PER_TONE"));
				informationList.add( rs.getString("REMARKS"));
				dataMap.put(rs.getString("DEDUCTION_CLAIMED").replaceAll("\\s",""), informationList);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return dataMap;
	}
	
	//------------------------------------- Sales for Domestic Consumption Details --------------------------------------//
	public ArrayList<Object> getSalesForDomestic(int  id) {
		 
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> informationList = new ArrayList<Object>();
		try {
			int count=0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_SALES_FOR_DOMESTIC_CONSUMPTION);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				informationList.add( rs.getString("GRADE"));
				informationList.add( rs.getString("DESPATCH_NAME"));
				informationList.add( rs.getString("DOMESTIC_CONSIGNEE"));
				informationList.add( rs.getString("DOMESTIC_QUANTITY"));
				informationList.add( rs.getString("DOMESTICS_SALE_VALUE"));
				informationList.add( rs.getString("EXPORT_COUNTRY"));
				informationList.add( rs.getString("QUANTITY"));
				informationList.add( rs.getString("EXPORT_FOB_VALUE"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return informationList;
	}
	
	
	@SuppressWarnings("unchecked")
	public ArrayList<String> getdetails (String keyValue,Map employeeDetails){
		ArrayList<String> workPlaceDetails = new ArrayList<String>();
		if (employeeDetails.containsKey(keyValue)) {
			workPlaceDetails=(ArrayList<String>) employeeDetails.get(keyValue);
		}else {
			ArrayList<String> emptyCell = new ArrayList<String>();
			emptyCell.add("");
			emptyCell.add("");
			emptyCell.add("");
			emptyCell.add("");
			emptyCell.add("");
			emptyCell.add("");
			workPlaceDetails=(ArrayList<String>) emptyCell;
		}
		return workPlaceDetails;
	}
	
	@SuppressWarnings("unchecked")
	public ArrayList<String> getGradeStructure (String keyValue,Map gradeDetails){
		ArrayList<String> grade = new ArrayList<String>();
		if (gradeDetails.containsKey(keyValue)) {
			grade=(ArrayList<String>) gradeDetails.get(keyValue);
		}else {
			ArrayList<String> emptyCell = new ArrayList<String>();
			emptyCell.add("");
			emptyCell.add("");
			emptyCell.add("");
			emptyCell.add("");
			emptyCell.add("");
			grade=(ArrayList<String>) emptyCell;
		}
		return grade;
	}

	@SuppressWarnings("unchecked")
	public ArrayList<String> getStockStructure (String keyValue,Map stockDetails){
		ArrayList<String> stock = new ArrayList<String>();
		if (stockDetails.containsKey(keyValue)) {
			stock=(ArrayList<String>) stockDetails.get(keyValue);
		}else {
			ArrayList<String> emptyCell = new ArrayList<String>();
			emptyCell.add("");
			emptyCell.add("");
			emptyCell.add("");
			stock=(ArrayList<String>) emptyCell;
		}
		return stock;
	}

	@SuppressWarnings("unchecked")
	public ArrayList<String> getDeductionStructure (String keyValue,Map deductionDetails){
		ArrayList<String> deduction = new ArrayList<String>();
		if (deductionDetails.containsKey(keyValue)) {
			deduction=(ArrayList<String>) deductionDetails.get(keyValue);
		}else {
			ArrayList<String> emptyCell = new ArrayList<String>();
			emptyCell.add("");
			emptyCell.add("");
			deduction=(ArrayList<String>) emptyCell;
		}
		return deduction;
	}
	@SuppressWarnings("unchecked")
	public ArrayList<String> getOreStructure (String keyValue,Map oreDetails){
		ArrayList<String> ore = new ArrayList<String>();
		if (oreDetails.containsKey(keyValue)) {
			ore=(ArrayList<String>) oreDetails.get(keyValue);
		}else {
			ArrayList<String> emptyCell = new ArrayList<String>();
			emptyCell.add("");
			emptyCell.add("");
			emptyCell.add("");
			emptyCell.add("");
			ore=(ArrayList<String>) emptyCell;
		}
		return ore;
	}
	//------------------------------------- Challan Details --------------------------------------//
	public ArrayList<Object> getChallanDetails(int  id) {
		 
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> informationList = new ArrayList<Object>();
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
		SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			int count=0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_CHALLAN_DETAILS);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				informationList.add( rs.getString("CHALLAN_NO"));
				if(rs.getString("CHALLAN_DATE")==""|| rs.getString("CHALLAN_DATE").contains("1900"))
				{
				informationList.add("");
				}
				else
				{	
					informationList.add(ddmmyyyy.format(yyyymmdd.parse(rs.getString("CHALLAN_DATE"))));
				}
				informationList.add( rs.getString("QUANTITY"));
				informationList.add( rs.getString("GRADE"));
				informationList.add( rs.getString("TYPE"));
				informationList.add( rs.getString("PROVISIONAL_ROYALITY_RATE"));
				informationList.add( rs.getString("VALUE_PAID"));
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return informationList;
	}
	
	//------------------------------------- total challan Details --------------------------------------//
	public ArrayList<String> getTotalChallanDetails(int  id) {
		 
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> informationList = new ArrayList<String>();
		try {
			int count=0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_TOTAL);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				informationList.add( rs.getString("QUANTITY"));
				informationList.add( rs.getString("AMOUNT"));
				informationList.add( rs.getString("VALUE_PAID"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return informationList;
	}
	//------------------------------------- Rom Processing Details --------------------------------------//
	public ArrayList<Object> getRomProcessingDetails(int  id) {
		 
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> informationList = new ArrayList<Object>();
		try {
			int count=0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_ROM_PROCESSING_DETAILS);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				informationList.add( rs.getString("PLANT_LOCATION"));
				informationList.add( rs.getString("ROM_OPENING_STOCK"));
				informationList.add( rs.getString("ROM_RECEIPT"));
				informationList.add( rs.getString("ROM_PROCESSED"));
				informationList.add( rs.getString("ROM_CLOSING_STOCK"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return informationList;
	}
	//------------------------------------- Rom Processing Details --------------------------------------//
	public ArrayList<Object> getOversizeDetails(int  id) {
		 
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> informationList = new ArrayList<Object>();
		try {
			int count=0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_OVERSIZE_DETAILS);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				informationList.add( rs.getString("PLANT_LOCATION"));
				informationList.add( rs.getString("OVERSIZE_OPENING_STOCK"));
				informationList.add( rs.getString("OVERSIZE_GENERATION"));
				informationList.add( rs.getString("OVERSIZE_PROCESSING"));
				informationList.add( rs.getString("OVERSIZE_CLOSING_STOCK"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return informationList;
	}

	//------------------------------------- Deduction Details --------------------------------------//
	@SuppressWarnings("unchecked")
	public HashMap getOreProcessedDetails( int  id) {
		 
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		HashMap dataMap = new HashMap();
		ArrayList<Object> informationList = new ArrayList<Object>();
		try {
			int count=0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_ORE_PROCESSED_DETAILS);
			pstmt.setInt(1, id);
			pstmt.setInt(2, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				informationList = new ArrayList<Object>();
				informationList.add( rs.getString("FINES"));
				informationList.add( rs.getString("LUMPS"));
				informationList.add( rs.getString("OVERSIZE"));
				informationList.add( rs.getString("WASTE_OR_TAILING"));
				dataMap.put(rs.getString("GRADE").replaceAll("\\s",""), informationList);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return dataMap;
	}

	//------------------------------------- OversizeProcessing Details --------------------------------------//
	@SuppressWarnings("unchecked")
	public HashMap getOversizeProcessingDetails( int  id) {
		 
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		HashMap dataMap = new HashMap();
		ArrayList<Object> informationList = new ArrayList<Object>();
		try {
			int count=0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_OVERSIZE_PROCESSING_DETAILS);
			pstmt.setInt(1, id);
			pstmt.setInt(2, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				informationList = new ArrayList<Object>();
				informationList.add( rs.getString("FINES"));
				informationList.add( rs.getString("LUMPS"));
				informationList.add( rs.getString("WASTE_OR_TAILING"));
				dataMap.put(rs.getString("GRADE").replaceAll("\\s",""), informationList);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return dataMap;
	}
	//------------------------------------- ProductGeneration Details --------------------------------------//
	@SuppressWarnings("unchecked")
	public HashMap getProductGenerationReport( int  id) {
		 
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		HashMap dataMap = new HashMap();
		ArrayList<Object> informationList = new ArrayList<Object>();
		try {
			int count=0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_PRODUCT_GENERATED_DETAILS);
			pstmt.setInt(1, id);
			pstmt.setInt(2, id);
			pstmt.setInt(3, id);
			pstmt.setInt(4, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				informationList = new ArrayList<Object>();
				informationList.add( rs.getString("OPENING_STOCK"));
				informationList.add( rs.getString("PRODUCT"));
				informationList.add( rs.getString("DESPATCH"));
				informationList.add( rs.getString("CLOSING_STOCK"));
				dataMap.put(rs.getString("GRADE").replaceAll("\\s",""), informationList);
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return dataMap;
	}

}
