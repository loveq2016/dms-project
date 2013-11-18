package dms.yijava.api.web.deliver;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.util.Region;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.common.utils.DateUtils;
import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.ErrorCode;
import com.yijava.web.vo.Result;

import dms.yijava.entity.deliver.Deliver;
import dms.yijava.entity.deliver.DeliverExpressDetail;
import dms.yijava.entity.flow.FlowRecord;
import dms.yijava.entity.order.Order;
import dms.yijava.entity.system.SysUser;
import dms.yijava.service.deliver.DeliverExpressDetailService;
import dms.yijava.service.deliver.DeliverService;
import dms.yijava.service.flow.FlowRecordService;
import dms.yijava.service.order.OrderService;
import dms.yijava.service.system.SysUserService;

@Controller
@RequestMapping("/api/deliverExpress")
public class DeliverExpressController {
	@Autowired
	private DeliverService deliverService;
	@Autowired
	private OrderService orderService;
	@Autowired
	private DeliverExpressDetailService deliverExpressDetailService;
	@Autowired
	private FlowRecordService flowRecordService;
	@Autowired
	private SysUserService sysUserService;
	//发货提醒
	@Value("#{properties['sendproduct_identifier_num']}")   	
	private String sendproduct_identifier_num;
	//收货提醒
	@Value("#{properties['reciveproduct_identifier_num']}")   	
	private String reciveproduct_identifier_num;
	
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<DeliverExpressDetail> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return deliverExpressDetailService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") DeliverExpressDetail entity) {
		entity.setUser_id("13");
		try {
			DeliverExpressDetail tempDeliverExpressDetail =  deliverExpressDetailService.selectSumById(entity.getDelivery_detail_id());
			if(tempDeliverExpressDetail ==null){//产品空
				if(Integer.parseInt(entity.getExpress_num()) <=  Integer.parseInt(entity.getDeliver_number_sum())){
					deliverExpressDetailService.saveEntity(entity);
					return new Result<String>(entity.getId(), 1);
				}else{
					return new Result<String>(entity.getId(), 2);
				}
			}else{
				int count = Integer.parseInt(tempDeliverExpressDetail.getExpress_num()) + Integer.parseInt(entity.getExpress_num());
				if(count <=  Integer.parseInt(entity.getDeliver_number_sum())){
					DeliverExpressDetail existsDeliverExpressDetail = deliverExpressDetailService.selectSn(entity);
					if (existsDeliverExpressDetail == null) {
						deliverExpressDetailService.saveEntity(entity);
					}else{
						entity.setId(existsDeliverExpressDetail.getId());
						deliverExpressDetailService.updateEntity(entity);
					}
					return new Result<String>(entity.getId(), 1);
				}else{
					return new Result<String>(entity.getId(), 2);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getId(),0);
	}

	
	@ResponseBody
	@RequestMapping("delete")
	public Result<String> delete(@RequestParam(value = "id", required = true) String id) {
		try {
			deliverExpressDetailService.deleteEntity(id);
			return new Result<String>(id, 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(id, 0);
	}
	
	
	@ResponseBody
	@RequestMapping("submitExpress")
	public Result<String> submitExpress(@ModelAttribute("entity") DeliverExpressDetail entity) {
		
		try {
			DeliverExpressDetail checkDeliverExpressDetail =  deliverExpressDetailService.checkSn(entity.getDeliver_code());
			if (checkDeliverExpressDetail == null) {
				return new Result<String>("1", 2);
			}
			if(checkDeliverExpressDetail.getExprees_total().equals(checkDeliverExpressDetail.getSn_total())){
				Deliver deliver =   deliverService.getEntity(Integer.parseInt(entity.getDeliver_id()));
				Deliver deliverEntity = new Deliver();
				deliverEntity.setDeliver_code(entity.getDeliver_code());
				deliverEntity.setExpress_code(entity.getExpress_code());
				deliverEntity.setExpress_date(entity.getExpress_date());
				deliverService.submitExpress(deliverEntity);
				Order orderEntity = new Order();
				orderEntity.setOrder_code(entity.getOrder_code());
				orderEntity.setOrder_status(entity.getDeliver_status());
				orderEntity.setExpress_code(entity.getExpress_code());
				orderService.submitExpress(orderEntity);
				
				try {
					if (deliver.getConsignee_status() == null) {
						List<SysUser> users = sysUserService.getListByDepartmentId("86");
						//关闭发货提醒
						flowRecordService.updateFlowByFlowUB(sendproduct_identifier_num, users.get(0).getId(), entity.getDeliver_id(), "", "1");
						//开始收货提醒
						 if(users!=null && users.size()>0)
						 {
							SysUser sysUser =  sysUserService.getEntityByDealer(deliver.getDealer_id());
							FlowRecord flowRecord = new FlowRecord();
							flowRecord.setFlow_id(reciveproduct_identifier_num);
							flowRecord.setBussiness_id(entity.getDeliver_id());		
							flowRecord.setTitle("待收货");
							flowRecord.setSend_id("0000000000");//只做提醒，所以此处设置了全0
							//flowRecord.setCheck_id(sysUser.getFk_dealer_id());//经销商id 取登录人的id 有问题。。
							flowRecord.setCheck_id(sysUser.getId());//经销商id 取登录人的id 有问题。。
							flowRecord.setSend_time(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
							flowRecord.setCreate_time(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));			
							flowRecord.setStatus("0");
							flowRecordService.saveEntity(flowRecord);
						 }
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				return new Result<String>("1", 1);
			}else{
				return new Result<String>("1", 2);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return new Result<String>("1", 0);
	}
	
	
	@ResponseBody
	@RequestMapping("viewdocument")
	public Result<String> viewdocument (Integer deliver_id,HttpServletRequest request,HttpServletResponse response) {
		Result<String> result=new Result<String>("0", 0);
		
		Deliver entity =  deliverService.getEntity(deliver_id);
		
		if (entity.getConsignee_status() == null) {
			result.setError(new ErrorCode("单据不正确，无法生成文档"));
			return result;
		}
		try {
			DateFormat format2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String generatePath = request.getSession().getServletContext().getRealPath("generate");
			String fileName="express/express-"+deliver_id+".xls";
			File outFile = new File(generatePath + File.separator + fileName);		
			
			
			 List<Map<String,Object>> list = deliverService.viewdocument(entity.getDeliver_id());
			
			 String classPath = new File(getClass().getResource("/excel").getFile()).getCanonicalPath(); 
			 String excelPath = classPath + File.separator + "DeliverExpress.xls";
			 excel(excelPath, list, outFile);
			   
			 result.setData(fileName);
			 result.setState(1);
			/*
			 * 
			Map<String, Object> dataMap = new HashMap<String, Object>();
			TheFreemarker freemarker = new TheFreemarker();
			List<Map<String,Object>> listftl = new ArrayList<Map<String,Object>>();
			for (Map<String, Object> map : list) {
				Map<String,Object> dd = new HashMap<String, Object>();
				dd.put("cname", map.get("cname"));
				dd.put("models", map.get("models"));
				dd.put("product_sn", map.get("product_sn"));
				dd.put("express_sn", map.get("express_sn"));
				dd.put("validity_date", map.get("validity_date"));
				dd.put("deliver_remark", map.get("deliver_remark"));
				listftl.add(dd);
			}
			dataMap.put("table", listftl);
			freemarker.createExpressXls(new FileOutputStream(outFile),dataMap);	
			*/

		} catch (Exception e) {
			e.printStackTrace();
			result.setError(new ErrorCode(e.toString()));
		}  
	    
		return result;
	}
	
	
	
	private void excel(String excelPath,List<Map<String,Object>> list,File outFile){
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

	        //设置标题字体格式  
	        Font fontTitle = wb.createFont();     
	        fontTitle.setFontHeightInPoints((short)12);   //--->设置字体大小  
	        fontTitle.setFontName("宋体");   //---》设置字体，是什么类型例如：宋体  
	        fontTitle.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);     //--->设置是否是加粗  
	        fontTitle.setColor(HSSFColor.BLACK.index);
	        
	        //样式Tile 
	        HSSFCellStyle styleTitle = wb.createCellStyle(); // 样式对象  
	        styleTitle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 垂直  
	        styleTitle.setAlignment(HSSFCellStyle.ALIGN_LEFT);// 水平  
	        styleTitle.setFont(fontTitle);     //--->将字体格式加入到style1中     
	        styleTitle.setBorderBottom((short)1);   //设置下划线，参数是黑线的宽度  
	        styleTitle.setBorderLeft((short)1);   //设置左边框  
	        styleTitle.setBorderRight((short)1);   //设置有边框  
	        styleTitle.setBorderTop((short)1);   //设置下边框  
	        styleTitle.setWrapText(true);   //设置是否能够换行，能够换行为true  
     
	        //设置正文字体格式  
	        Font fontContent = wb.createFont();     
	        fontContent.setFontHeightInPoints((short)12);   //--->设置字体大小  
	        fontContent.setFontName("宋体");   //---》设置字体，是什么类型例如：宋体  
	        fontContent.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);     //--->设置是否是加粗  
	        fontContent.setColor(HSSFColor.BLACK.index);
	        
	        //样式Tile 
	        HSSFCellStyle styleContent = wb.createCellStyle(); // 样式对象  
	        styleContent.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 垂直  
	        styleContent.setAlignment(HSSFCellStyle.ALIGN_LEFT);// 水平  
	        styleContent.setFont(fontContent);     //--->将字体格式加入到style1中     
	        styleContent.setWrapText(false);   //设置是否能够换行，能够换行为true  
	        styleContent.setBorderBottom((short)1);   //设置下划线，参数是黑线的宽度  
	        styleContent.setBorderLeft((short)1);   //设置左边框  
	        styleContent.setBorderRight((short)1);   //设置有边框  
	        styleContent.setBorderTop((short)1);   //设置下边框  
	        
	  
	       // HSSFCell cell = null;
			HSSFCell cellN = null;
	        //表格第一行  
	        HSSFRow row5 = sheet.createRow(5);   //--->创建一行  
	        // 四个参数分别是：起始行，起始列，结束行，结束列  
	        sheet.addMergedRegion(new Region(5,  (short)1,5, (short) 4));  
	        sheet.addMergedRegion(new Region(5,  (short)5,5, (short) 7));  
	        for (int j = 0; j <= 7; j++) {
		        cellN = row5.createCell((short)j);  
		        cellN.setCellStyle(styleTitle);  
	        	 switch (j) {
             		case 0:cellN.setCellValue(valueOf("收货单位："));break;
					case 1:cellN.setCellValue(valueOf(list.get(0).get("dealer_name")));break;
					case 5:cellN.setCellValue(valueOf("单号："+list.get(0).get("deliver_code")));break;
	        	 }
	        }
	        
	        int row = 7 ;
	        for (Map<String,Object> map : list) {
	        	HSSFRow rowN = sheet.createRow(row);
	        	sheet.addMergedRegion(new Region(row,  (short)3,row, (short) 4));    // 四个参数分别是：起始行，起始列，结束行，结束列
				for (int j = 0; j <= 7; j++) {
					cellN = rowN.createCell((short)j);  
                    cellN.setCellStyle(styleContent);  
                    switch (j) {
                    	case 0:cellN.setCellValue(valueOf( map.get("cname")));break;
						case 1:cellN.setCellValue(valueOf( map.get("models")));break;
						case 2:cellN.setCellValue(valueOf( "1"));break;
						case 3:cellN.setCellValue(valueOf( map.get("product_sn")));break;
						case 5:cellN.setCellValue(valueOf( map.get("express_sn")));break;
						case 6:cellN.setCellValue(valueOf( map.get("validity_date")));break;
						case 7:cellN.setCellValue(valueOf( map.get("deliver_remark")));break;
						default:break;
					}
				}
				row++;
			}
	        //空行
	        sheet.addMergedRegion(new Region(row,  (short)0,row, (short) 7));  
	        HSSFRow rowN = sheet.createRow(row);
			for (int j = 0; j <= 7; j++) {
				cellN = rowN.createCell((short)j);  
                cellN.setCellStyle(styleContent);  
			}
			
			//发货
			int title1 = row + 1;
	        sheet.setDefaultColumnWidth((short)300);
	        HSSFRow row1 = sheet.createRow(title1);   //--->创建一行  
	        // 四个参数分别是：起始行，起始列，结束行，结束列  
	        sheet.addMergedRegion(new Region(title1,  (short)0,title1, (short) 3));  
	        sheet.addMergedRegion(new Region(title1,  (short)4,title1, (short) 7));  
	        row1.setHeightInPoints((float) 30);
	        for (int j = 0; j <= 7; j++) {
		        cellN = row1.createCell((short)j);  
		        cellN.setCellStyle(styleContent);  
	        	 switch (j) {
             		case 0:cellN.setCellValue(valueOf("发货方：深圳市金瑞凯利生物科技有限公司"));break;
					case 4:cellN.setCellValue(valueOf("收货方：" + list.get(0).get("dealer_name")));break;
	        	 }
	        }
	        
	        //收货人
			int title2 = row + 2;
	        sheet.setDefaultColumnWidth((short)300);
	        HSSFRow row2 = sheet.createRow(title2);   //--->创建一行  
	        // 四个参数分别是：起始行，起始列，结束行，结束列  
	        sheet.addMergedRegion(new Region(title2,  (short)0,title2, (short) 3));  
	        sheet.addMergedRegion(new Region(title2,  (short)4,title2, (short) 7));  
	        row2.setHeightInPoints((float) 30);
	        for (int j = 0; j <= 7; j++) {
		        cellN = row2.createCell((short)j);  
		        cellN.setCellStyle(styleContent);  
	        	 switch (j) {
             		case 0:cellN.setCellValue(valueOf("经办人："));break;
					case 4:cellN.setCellValue(valueOf("收货人："));break;
	        	 }
	        }
	        
	        //日期
			int title3 = row + 3;
	        sheet.setDefaultColumnWidth((short)300);
	        HSSFRow row3 = sheet.createRow(title3);   //--->创建一行  
	        // 四个参数分别是：起始行，起始列，结束行，结束列  
	        sheet.addMergedRegion(new Region(title3,  (short)0,title3, (short) 3));  
	        sheet.addMergedRegion(new Region(title3,  (short)4,title3, (short) 7));  
	        row3.setHeightInPoints((float) 30);
	        for (int j = 0; j <= 7; j++) {
		        cellN = row3.createCell((short)j);  
		        cellN.setCellStyle(styleContent);  
	        	 switch (j) {
          			case 0:cellN.setCellValue(valueOf("发货日期：")+ list.get(0).get("express_date"));break;//express_date
					case 4:cellN.setCellValue(valueOf("收货日期：")+ list.get(0).get("consignee_date"));break;//consignee_date
	        	 }
	        }
	        
	        
	        //备注
			int title4 = row + 4;
	        sheet.setDefaultColumnWidth((short)600);
	        HSSFRow row4 = sheet.createRow(title4);   //--->创建一行  
	        // 四个参数分别是：起始行，起始列，结束行，结束列  
			row4.setHeightInPoints((float) 50);
	        sheet.addMergedRegion(new Region(title4,  (short)0,title4, (short) 7));  
	        for (int j = 0; j <= 7; j++) {
		        cellN = row4.createCell((short)j);  
		        cellN.setCellStyle(styleTitle);  
	        	 switch (j) {
          			case 0:cellN.setCellValue(valueOf("请收到货后核对收货数量，并于三日内确认回传，否则后果自负。\n电话：0755-83283095   传真：0755-83197052"));break;//express_date
	        	 }
	        }
	        
	        
	        
	        FileOutputStream fileOut = new FileOutputStream(outFile);
	        wb.write(fileOut);  
	        fileOut.close();
	        
			 //ByteArrayOutputStream os = new ByteArrayOutputStream();
			 //fileOut = new FileOutputStream("E:\\workbook.xls");  
//	         wb.write(os);  
//	         
//	         byte[] content = os.toByteArray();
//	         InputStream is = new ByteArrayInputStream(content);
	         
	         // 设置response参数，可以打开下载页面
//	         String fileName = String.valueOf(System.currentTimeMillis())+".xls";
//	         response.reset();
//	         response.setContentType("application/vnd.ms-excel;charset=utf-8");
//	         response.setHeader("Content-Disposition", "attachment;filename=" +fileName);  
//	         ServletOutputStream out = response.getOutputStream();
//	         BufferedInputStream bis = null;
//	         BufferedOutputStream bos = null;
//	         try {
//	             bis = new BufferedInputStream(is);
//	             bos = new BufferedOutputStream(out);
//	             byte[] buff = new byte[2048];
//	             int bytesRead;
//	             while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
//	                 bos.write(buff, 0, bytesRead);
//	             }
//	         } catch (Exception e) {
//	             throw e;
//	         } finally {
//	             if (bis != null)
//	                 bis.close();
//	             if (bos != null)
//	                 bos.close();
//	         }
		} catch (Exception e) {
			e.printStackTrace();
		}  
		
	}
	
	
	public static String valueOf(Object obj) {  
	    return (obj == null) ? "" : obj.toString();  
	} 
	
	
	
	
	
}
