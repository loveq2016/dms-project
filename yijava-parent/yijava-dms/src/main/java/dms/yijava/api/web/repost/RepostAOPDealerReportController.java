package dms.yijava.api.web.repost;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Font;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;

import dms.yijava.entity.dealer.DealerPlan;
import dms.yijava.service.dealer.DealerPlanService;
import dms.yijava.service.repost.RepostService;

@Controller
@RequestMapping("/api/aopdealerreport")
public class RepostAOPDealerReportController {
	
	@Autowired
	private RepostService repostService;
	@Autowired
	private DealerPlanService dealerPlanService;
	
	@RequestMapping("down")
	public void down(PageRequest pageRequest, HttpServletRequest request,
			final HttpServletResponse response) throws IOException {
		   pageRequest.setOrderBy("dealer_id");
		   pageRequest.setOrderDir("desc");
		   pageRequest.setPageSize(1000000);
		   List<PropertyFilter> filters = PropertyFilters.build(request);
		   List<DealerPlan> list = dealerPlanService.paging(pageRequest,filters).getRows();
		   String classPath = new File(getClass().getResource("/excel").getFile()).getCanonicalPath(); 
		   String excelPath = classPath + File.separator + "AOPDealerReport.xls";
		   excel(excelPath, list, response);
	}
	private void excel(String excelPath,List<DealerPlan> list,HttpServletResponse response){
		try {
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(excelPath));  //--->创建了一个excel文件
			HSSFSheet sheet = wb.getSheetAt(0);
			
	        //设置正文字体格式  
	        Font fontContent = wb.createFont();     
	        fontContent.setFontHeightInPoints((short)9);   //--->设置字体大小  
	        fontContent.setFontName("Tahoma");   //---》设置字体，是什么类型例如：宋体  
	        fontContent.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);     //--->设置是否是加粗  
	        fontContent.setColor(HSSFColor.BLACK.index);
	        
	        //样式Tile 
	        HSSFCellStyle styleContent = wb.createCellStyle(); // 样式对象  
	        styleContent.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 垂直  
	        styleContent.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 水平  
	        styleContent.setFont(fontContent);     //--->将字体格式加入到style1中     
	        styleContent.setWrapText(false);   //设置是否能够换行，能够换行为true  
	        styleContent.setBorderBottom((short)1);   //设置下划线，参数是黑线的宽度  
	        styleContent.setBorderLeft((short)1);   //设置左边框  
	        styleContent.setBorderRight((short)1);   //设置有边框  
	        styleContent.setBorderTop((short)1);   //设置下边框  
	        
	        int row = 1 ;
	        for (DealerPlan dealerPlan : list) {
	        	HSSFRow rowN = sheet.createRow(row);
				for (int j = 0; j < 15; j++) {
					HSSFCell cellN = rowN.createCell((short)j);  
                    cellN.setCellStyle(styleContent);  
                    switch (j) {
						case 0:cellN.setCellValue(dealerPlan.getDealer_name());break;
						case 1:cellN.setCellValue(dealerPlan.getDealer_code());break;
						case 2:cellN.setCellValue(dealerPlan.getYear());break;
						case 3:cellN.setCellValue(dealerPlan.getJanuary());break;
						case 4:cellN.setCellValue(dealerPlan.getFebruary());break;
						case 5:cellN.setCellValue(dealerPlan.getMarch());break;
						case 6:cellN.setCellValue(dealerPlan.getApril());break;
						case 7:cellN.setCellValue(dealerPlan.getMay());break;
						case 8:cellN.setCellValue(dealerPlan.getJune());break;
						case 9:cellN.setCellValue(dealerPlan.getJuly());break;
						case 10:cellN.setCellValue(dealerPlan.getAugust());break;
						case 11:cellN.setCellValue(dealerPlan.getSeptember());break;
						case 12:cellN.setCellValue(dealerPlan.getOctober());break;
						case 13:cellN.setCellValue(dealerPlan.getNovember());break;
						case 14:cellN.setCellValue(dealerPlan.getDecember());break;
						default:break;
					}
				}
				row++;
			}
			ByteArrayOutputStream os = new ByteArrayOutputStream();
	        wb.write(os);  
	         
	        byte[] content = os.toByteArray();
	        InputStream is = new ByteArrayInputStream(content);
	         
	        // 设置response参数，可以打开下载页面
	        String fileName = String.valueOf(System.currentTimeMillis())+".xls";
	        response.reset();
	        response.setContentType("application/vnd.ms-excel;charset=utf-8");
	        response.setHeader("Content-Disposition", "attachment;filename=" +fileName);  
	        ServletOutputStream out = response.getOutputStream();
	        BufferedInputStream bis = null;
	        BufferedOutputStream bos = null;
	        try {
	            bis = new BufferedInputStream(is);
	            bos = new BufferedOutputStream(out);
	            byte[] buff = new byte[2048];
	            int bytesRead;
	            while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
	               bos.write(buff, 0, bytesRead);
	            }
	        } catch (Exception e) {
	            throw e;
	        } finally {
	            if (bis != null)
	                bis.close();
	            if (bos != null)
	                bos.close();
	        }
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static String valueOf(Object obj) {  
	    return (obj == null) ? "" : obj.toString();  
	}  
}

