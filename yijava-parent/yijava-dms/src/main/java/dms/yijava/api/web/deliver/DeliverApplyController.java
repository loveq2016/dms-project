package dms.yijava.api.web.deliver;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import sun.misc.BASE64Encoder;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.ErrorCode;
import com.yijava.web.vo.Result;

import dms.yijava.api.web.word.util.TheFreemarker;
import dms.yijava.entity.dealer.DealerAddress;
import dms.yijava.entity.deliver.Deliver;
import dms.yijava.entity.deliver.DeliverDetail;
import dms.yijava.entity.flow.FlowLog;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.dealer.DealerAddressService;
import dms.yijava.service.deliver.DeliverDetailService;
import dms.yijava.service.deliver.DeliverService;
import dms.yijava.service.flow.FlowBussService;
import dms.yijava.service.flow.FlowLogService;

@Controller
@RequestMapping("/api/deliverApply")
public class DeliverApplyController {
	
	@Autowired
	private DeliverService deliverService;
	@Autowired
	private DeliverDetailService deliverDetailService;
	@Autowired
	private FlowBussService flowBussService;
	@Value("#{properties['deliverflow_identifier_num']}")   	
	private String flowIdentifierNumber;
	@Value("#{properties['document_filepath']}")   	
	private String document_filepath;
	@Autowired
	private DealerAddressService dealerAddressService;
	@Autowired
	private FlowLogService flowLogService;
	
	

	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<Deliver> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		SysUser sysUser = (SysUser) request.getSession().getAttribute("user");
		String currentUserId = sysUser.getId();
		if (null != sysUser && "84".equals(sysUser.getFk_department_id())){
			filters.add(PropertyFilters.build("ANDS_statuses", "0,1,2,3,4,5,6"));
		}else if (null != sysUser && StringUtils.isNotEmpty(sysUser.getTeams())) {
			filters.add(PropertyFilters.build("ANDS_statuses", "1,2,3,4,5,6"));
		}
		filters.add(PropertyFilters.build("ANDS_check_id", currentUserId));
		filters.add(PropertyFilters.build("ANDS_flow_id",flowIdentifierNumber));
		filters.add(PropertyFilters.build("ANDS_dealer_ids", this.listString(sysUser.getUserDealerList())));
		return deliverService.paging(pageRequest,filters);
	}
	
	
	@ResponseBody
	@RequestMapping("pagingtodelver")
	public JsonPage<Deliver> pagingtodelver(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
//		SysUser sysUser = (SysUser) request.getSession().getAttribute("user");
//		String currentUserId = sysUser.getId();
//		if (null != sysUser && "84".equals(sysUser.getFk_department_id())){
//			filters.add(PropertyFilters.build("ANDS_statuses", "0,1,2,3,4,5,6"));
//		}else if (null != sysUser && StringUtils.isNotEmpty(sysUser.getTeams())) {
//			filters.add(PropertyFilters.build("ANDS_statuses", "1,2,3,4,5,6"));
//			filters.add(PropertyFilters.build("ANDS_check_id", currentUserId));
//			filters.add(PropertyFilters.build("ANDS_flow_id",flowIdentifierNumber));
//		}
//		filters.add(PropertyFilters.build("ANDS_dealer_ids", this.listString(sysUser.getUserDealerList())));
		return deliverService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("detailList")
	public List<DeliverDetail> getList(HttpServletRequest request){
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return deliverDetailService.getList(filters);
	}
	
	
	@ResponseBody
	@RequestMapping("detailPaging")
	public JsonPage<DeliverDetail> detailPaging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return deliverDetailService.paging(pageRequest,filters);
	}
	
	
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") Deliver entity,
			@ModelAttribute("deliverDetail") DeliverDetail deliverDetail,
			HttpServletRequest request) {
		try {
			SysUser sysUser = (SysUser) request.getSession().getAttribute("user"); // 当前用户信息
			entity.setUser_id(sysUser.getId());
			deliverService.saveEntity(entity,deliverDetail);
			return new Result<String>(entity.getDeliver_id(), 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getDeliver_id(),0);
	}
	
	
	@ResponseBody
	@RequestMapping("update")
	public Result<String> update(@ModelAttribute("entity") Deliver entity,
			@ModelAttribute("deliverDetail") DeliverDetail deliverDetail,
			HttpServletRequest request) {
		try {
			SysUser sysUser = (SysUser) request.getSession().getAttribute("user"); // 当前用户信息
			entity.setUser_id(sysUser.getId());
			deliverService.updateEntity(entity, deliverDetail);
			return new Result<String>(entity.getDeliver_id(), 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getDeliver_id(), 0);
	}
	
	
	@ResponseBody
	@RequestMapping("delete")
	public Result<String> delete(@RequestParam(value = "id", required = true) String id) {
		try {
			deliverService.deleteEntity(id);
			return new Result<String>(id, 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(id, 0);
	}
	

	@ResponseBody
	@RequestMapping("submit")
	public Result<String> submit(
			@RequestParam(value = "deliver_code", required = true) String deliver_code,
			HttpServletRequest request) {
		try {
			deliverService.submitDeliver(deliver_code);
			return new Result<String>(deliver_code, 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(deliver_code, 0);
	}
	
	
	@ResponseBody
	@RequestMapping("updatetocheck")
	public Result<Integer> updatetocheck(Integer deliver_id,HttpServletRequest request) {
		Result<Integer> result = new Result<Integer>(0, 0);
		try {				
				SysUser sysUser = (SysUser) request.getSession().getAttribute("user");
				if(flowBussService.processFlowWithSign(deliver_id,sysUser,flowIdentifierNumber)){//提交流程
					//更新状态
					deliverService.updateDeliverStatus(String.valueOf(deliver_id),"1");
					//adjustStorageService.updateAdjustStorageStatus(String.valueOf(adjust_id), "1");//流程成功、更新业务的状态为提交审核
					result.setData(1);
					result.setState(1);;
				}else{
						result.setError(new ErrorCode("出现系统错误，处理流程节点"));
				}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	@ResponseBody
	@RequestMapping("viewdocument")
	public Result<String> viewdocument (Integer deliver_id,HttpServletRequest request,HttpServletResponse response) {
		Result<String> result=new Result<String>("0", 0);
		
		Deliver entity =  deliverService.getEntity(deliver_id);
		if(Integer.parseInt(entity.getCheck_status())<3){
			result.setError(new ErrorCode("单据不正确，无法生成文档"));
			return result;
		}
		try {
			DateFormat format2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String generatePath = request.getSession().getServletContext().getRealPath("generate");
			//String filePath= tomcatPath ;//document_filepath;			
			//String filePath = document_filepath;
			String fileName="deliver/deliver-"+deliver_id+".doc";
			File outFile = new File(generatePath + File.separator + fileName);		
			TheFreemarker freemarker = new TheFreemarker();
			Map<String, Object> dataMap = new HashMap<String, Object>();
			
			DealerAddress dealerAddress =  dealerAddressService.getEntity(entity.getDealer_address_id());
			//查找明细
			List<PropertyFilter> filters = PropertyFilters.build(request);
			filters.add(PropertyFilters.build("ANDS_deliver_code",entity.getDeliver_code()));
			List<DeliverDetail> deliverDetail = deliverDetailService.getList(filters);
			

			List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
			int id = 0 ;
			for (DeliverDetail deliverDetail2 : deliverDetail) {
				Map<String,Object> dd = new HashMap<String, Object>();
				dd.put("id", ++id);
				dd.put("models", deliverDetail2.getModels());
				dd.put("sum", deliverDetail2.getDeliver_number_sum());
				dd.put("dealer_code", entity.getDealer_code());
				dd.put("arrival_date", deliverDetail2.getArrival_date());
				dd.put("deliver_remark", deliverDetail2.getDeliver_remark());
				list.add(dd);
			}
			dataMap.put("address", dealerAddress.getAddress());
			dataMap.put("man",dealerAddress.getLinkman());
			dataMap.put("phone", dealerAddress.getLinkphone());
			dataMap.put("postcode", dealerAddress.getPostcode());
			
			dataMap.put("create_date",format2.format(format2.parse(entity.getCreate_date())));
			dataMap.put("remark", entity.getRemark());
			
			
			//查找该流程的处理记录,找到签名文件
			List<FlowLog> flowlogs= flowLogService.getLogByFlowAndBusIdSq(flowIdentifierNumber, deliver_id.toString());
			String regionsign = null, principalsign = null;
			String sign_Path = request.getSession().getServletContext().getRealPath("resource");
			sign_Path+=File.separator+ "signimg";
			for (FlowLog flowLog : flowlogs) {
				
				if (flowLog.getSign() != null && !"".equals(flowLog.getSign())) {
					if(flowLog.action_name.indexOf("提交-财务审核")>-1)
					{
						regionsign= sign_Path+File.separator+flowLog.getSign();
					}
					if (flowLog.action_name.indexOf("财务审核") > -1) {
						principalsign= sign_Path+File.separator+flowLog.getSign();
					}
					
				}
			}
			dataMap.put("account", getImageStr(regionsign));
			dataMap.put("caiwu", getImageStr(principalsign));
			//dataMap.put("image2", getImageStr(principalsign));
			dataMap.put("table", list);
			freemarker.createDeliverWord(new FileOutputStream(outFile),dataMap);	
			result.setData(fileName);
			result.setState(1);
		} catch (Exception e) {
			e.printStackTrace();
			result.setError(new ErrorCode(e.toString()));
		}  
	    
		return result;
	}

	
	
	private String getImageStr(String imagename) {
		if(StringUtils.isEmpty(imagename))
			return "";
        String imgFile = imagename;//"d:/10049_qz.jpg";
        InputStream in = null;
        byte[] data = null;
        try {
            in = new FileInputStream(imgFile);
            data = new byte[in.available()];
            in.read(data);
            in.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        BASE64Encoder encoder = new BASE64Encoder();
        return encoder.encode(data);
    }
	
	
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
