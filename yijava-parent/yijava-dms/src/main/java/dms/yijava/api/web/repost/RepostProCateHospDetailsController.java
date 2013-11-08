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

import dms.yijava.entity.hospital.Hospital;
import dms.yijava.service.repost.RepostService;

@Controller
@RequestMapping("/api/procatehospdetails")
public class RepostProCateHospDetailsController {
	
	@Autowired
	private RepostService repostService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<Map<String,Object>> paging(PageRequest pageRequest,HttpServletRequest request,Model model) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		try {
			return repostService.proCateHospDetailsPaging(pageRequest,filters);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	@RequestMapping("down")
	public void down(PageRequest pageRequest, HttpServletRequest request,
			final HttpServletResponse response) throws IOException {
		   pageRequest.setOrderBy("id");
		   pageRequest.setOrderDir("desc");
		   pageRequest.setPageSize(1000000);
		   List<PropertyFilter> filters = PropertyFilters.build(request);
		   List<Map<String,Object>> list = repostService.proCateHospDetailsPaging(pageRequest,filters).getRows();
		   String classPath = new File(getClass().getResource("/excel").getFile()).getCanonicalPath(); 
		   String excelPath = classPath + File.separator + "ProCateHospDetails.xls";
		   excel(excelPath, list, response);
	}
	private void excel(String excelPath,List<Map<String,Object>> list,HttpServletResponse response){
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
	        for (Map<String,Object> map : list) {
	        	HSSFRow rowN = sheet.createRow(row);
				for (int j = 0; j < 18; j++) {
					HSSFCell cellN = rowN.createCell((short)j);  
                    cellN.setCellStyle(styleContent);  
                    switch (j) {
						case 0:cellN.setCellValue((String)map.get("product_remark"));break;
						case 1:cellN.setCellValue((String)map.get("hospital_name"));break;
						case 2:cellN.setCellValue((String)map.get("realname"));break;
						case 3:cellN.setCellValue((String)map.get("dealer_name"));break;
						case 4:cellN.setCellValue((String)map.get(""));break;
						case 5:cellN.setCellValue((String)map.get(""));break;
						case 6:cellN.setCellValue((String)map.get(""));break;
						case 7:cellN.setCellValue((String)map.get(""));break;
						case 8:cellN.setCellValue((String)map.get(""));break;
						case 9:cellN.setCellValue((String)map.get("level_name"));break;
						case 10:cellN.setCellValue((String)map.get("provinces_name"));break;
						case 11:cellN.setCellValue((String)map.get("area_name"));break;
						case 12:cellN.setCellValue((String)map.get("city_name"));break;
						case 13:cellN.setCellValue((String)map.get("postcode"));break;
						case 14:cellN.setCellValue((String)map.get("address"));break;
						case 15:cellN.setCellValue((String)map.get("phone"));break;
						case 16:cellN.setCellValue((String)map.get("beds"));break;
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
}
