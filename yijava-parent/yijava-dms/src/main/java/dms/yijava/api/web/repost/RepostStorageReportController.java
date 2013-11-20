package dms.yijava.api.web.repost;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
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

import dms.yijava.entity.dealer.DealerPlan;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.dealer.DealerPlanService;
import dms.yijava.service.repost.RepostService;

@Controller
@RequestMapping("/api/storagereport")
public class RepostStorageReportController {
	
	@Autowired
	private RepostService repostService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<Map<String,Object>> paging(PageRequest pageRequest,HttpServletRequest request,Model model) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		try {
			SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
			if(null!=sysUser){
				//经销商
				if(!StringUtils.equals("0",sysUser.getFk_dealer_id())){
					filters.add(PropertyFilters.build("ANDS_dealer_id",sysUser.getFk_dealer_id()));
				}else if(StringUtils.isNotEmpty(sysUser.getTeams())){
					filters.add(PropertyFilters.build("ANDS_dealer_ids", this.listString(sysUser.getUserDealerList())));
				}
				return repostService.storageReportPaging(pageRequest,filters);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	@RequestMapping("down")
	public void down(PageRequest pageRequest, HttpServletRequest request,
			final HttpServletResponse response) throws IOException {
		   pageRequest.setOrderBy("fk_dealer_id");
		   pageRequest.setOrderDir("desc");
		   pageRequest.setPageSize(1000000);
		   List<PropertyFilter> filters = PropertyFilters.build(request);
		   List<Map<String,Object>> list =new ArrayList<Map<String,Object>>();
			try {
				SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
				if(null!=sysUser){
					//经销商
					if(!StringUtils.equals("0",sysUser.getFk_dealer_id())){
						filters.add(PropertyFilters.build("ANDS_dealer_id",sysUser.getFk_dealer_id()));
					}else if(StringUtils.isNotEmpty(sysUser.getTeams())){
						filters.add(PropertyFilters.build("ANDS_dealer_ids", this.listString(sysUser.getUserDealerList())));
					}
					list = repostService.storageReportPaging(pageRequest,filters).getRows();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		   String classPath = new File(getClass().getResource("/excel").getFile()).getCanonicalPath(); 
		   String excelPath = classPath + File.separator + "StorageReport.xls";
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
				for (int j = 0; j < 10; j++) {
					HSSFCell cellN = rowN.createCell((short)j);  
                    cellN.setCellStyle(styleContent);  
                    switch (j) {
                    	// 仓库名称  经销商  经销商代码	区域	入库日期  库存数量	产品编号	型号	批号	序列号	有效效期
						case 0:cellN.setCellValue(valueOf(map.get("storage_name")));break;
						case 1:cellN.setCellValue(valueOf(map.get("dealer_name")));break;
						case 2:cellN.setCellValue(valueOf(map.get("dealer_code")));break;
						case 3:cellN.setCellValue(valueOf(map.get("attribute")));break;
						case 4:cellN.setCellValue(valueOf(map.get("last_time")));break;
						case 5:cellN.setCellValue(valueOf(map.get("storage_sum")));break;
						case 6:cellN.setCellValue(valueOf(map.get("models")));break;
						case 7:cellN.setCellValue(valueOf(map.get("batch_no")));break;
						case 8:cellN.setCellValue(valueOf(map.get("product_sn")));break;
						case 9:cellN.setCellValue(valueOf(map.get("valid_date")));break;
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
	/**
	 * 把一个list转换为String返回过去
	 */
	public String listString(List<UserDealer> list) {
		String listString = "";
		for (int i = 0; i < list.size(); i++) {
			try {
				if (i == list.size() - 1) {
					UserDealer ud=list.get(i);
					listString += ud.getDealer_id();
				} else {
					UserDealer ud=list.get(i);
					listString += ud.getDealer_id() + ",";
				}
			} catch (Exception e) {
			}
		}
		return listString;
	}
}

