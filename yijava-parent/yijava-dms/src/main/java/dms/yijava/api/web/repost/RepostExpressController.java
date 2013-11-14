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
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;

import dms.yijava.service.repost.RepostService;

@Controller
@RequestMapping("/api/repostExpress")
public class RepostExpressController {
	
	@Autowired
	private RepostService repostService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<Map<String,Object>> paging(PageRequest pageRequest,HttpServletRequest request,Model model) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		try {
			filters.add(PropertyFilters.build("ANDS_check_status", "3"));
			return repostService.expressPaging(pageRequest,filters);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
	@RequestMapping("down")
	public void down(PageRequest pageRequest, HttpServletRequest request,
			final HttpServletResponse response) throws IOException {
		   pageRequest.setOrderBy("deliver_code");
		   pageRequest.setOrderDir("asc");
		   pageRequest.setPageSize(1000000);
		   List<PropertyFilter> filters = PropertyFilters.build(request);
		   filters.add(PropertyFilters.build("ANDS_check_status", "3"));
		   List<Map<String,Object>> list = repostService.expressPaging(pageRequest,filters).getRows();
		   String classPath = new File(getClass().getResource("/excel").getFile()).getCanonicalPath(); 
		   String excelPath = classPath + File.separator + "ExpressReport.xls";
		   excel(excelPath, list, response);
	}
	
	
	
	private void excel(String excelPath,List<Map<String,Object>> list,HttpServletResponse response){
		try {
			
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(excelPath));  //--->创建了一个excel文件
			HSSFSheet sheet = wb.getSheetAt(0);
			//HSSFSheet sheet = wb.createSheet("repostHospital");   //--->创建了一个工作簿  
	        // sheet.setColumnWidth((short)0, 256);    //---》设置单元格宽度，因为一个单元格宽度定了那么下面多有的单元格高度都确定了所以这个方法是sheet的  
	        // sheet.setColumnWidth((short)4, 20* 256);    //--->第一个参数是指哪个单元格，第二个参数是单元格的宽度  
	        // sheet.setDefaultRowHeight((short)1900);    // ---->有得时候你想设置统一单元格的高度，就用这个方法  
	        // sheet.setDefaultColumnWidth((short)300);
			// sheet.setDefaultColumnWidth(30);
			// sheet.setColumnWidth((short)0, 20 * 256); 
		/*	
	        //设置标题字体格式  
	        Font fontTitle = wb.createFont();     
	        fontTitle.setFontHeightInPoints((short)9);   //--->设置字体大小  
	        fontTitle.setFontName("Tahoma");   //---》设置字体，是什么类型例如：宋体  
	        fontTitle.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);     //--->设置是否是加粗  
	        fontTitle.setColor(HSSFColor.WHITE.index);
	        
	        //样式Tile 
	        HSSFCellStyle styleTitle = wb.createCellStyle(); // 样式对象  
	        styleTitle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 垂直  
	        styleTitle.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 水平  
	        styleTitle.setFont(fontTitle);     //--->将字体格式加入到style1中     
	        styleTitle.setFillForegroundColor(HSSFColor.LIGHT_BLUE.index);
	        styleTitle.setFillPattern(CellStyle.SOLID_FOREGROUND);
	        styleTitle.setWrapText(false);   //设置是否能够换行，能够换行为true  
	   */     
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
	        
	     /*
	        //表格第一行  
	        HSSFRow row1 = sheet.createRow(0);   //--->创建一行  
	        // 四个参数分别是：起始行，起始列，结束行，结束列  
	        //sheet.addMergedRegion(new Region(0,  0, 0, 1));  
	        //row1.setHeightInPoints(15);  
	     
	        HSSFCell cell=null;
	        for (int i = 0; i < title.length; i++) {
		        cell = row1.createCell((short)i);   //--->创建一个单元格  
		        cell.setCellStyle(styleTitle);  
		        cell.setCellValue(title[i]);  
			}
	       */

	        int row = 1 ;
	        for (Map<String,Object> map : list) {
	        	HSSFRow rowN = sheet.createRow(row);
				for (int j = 0; j <= 10; j++) {
					HSSFCell cellN = rowN.createCell((short)j);  
                    cellN.setCellStyle(styleContent);  
                    switch (j) {
                    	case 0:cellN.setCellValue(valueOf( map.get("type")));break;
						case 1:cellN.setCellValue(valueOf( map.get("express_date")));break;
						case 2:cellN.setCellValue(valueOf( map.get("deliver_code")));break;
						case 3:cellN.setCellValue(valueOf( map.get("deliver_remark")));break;
						case 4:cellN.setCellValue(valueOf( map.get("dealer_name")));break;
						case 5:cellN.setCellValue(valueOf( map.get("dealer_code")));break;
						case 6:cellN.setCellValue(valueOf( map.get("attribute")));break;
						case 7:cellN.setCellValue(valueOf( map.get("models")));break;
						case 8:cellN.setCellValue(valueOf( map.get("express_sn")));break;
						case 9:cellN.setCellValue(valueOf( map.get("validity_date")));break;
						case 10:cellN.setCellValue(valueOf( map.get("product_sn")));break;
						default:break;
					}
				}
				row++;
			}
	        
			 ByteArrayOutputStream os = new ByteArrayOutputStream();
			 //fileOut = new FileOutputStream("E:\\workbook.xls");  
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
