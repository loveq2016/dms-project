package dms.yijava.api.web.deliver;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.ErrorCode;
import com.yijava.web.vo.Result;

import dms.yijava.entity.adjuststorage.AdjustStorage;
import dms.yijava.entity.deliver.Deliver;
import dms.yijava.entity.deliver.DeliverDetail;
import dms.yijava.entity.storage.StorageDetail;
import dms.yijava.entity.storage.StorageProDetail;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.deliver.DeliverDetailService;
import dms.yijava.service.deliver.DeliverService;
import dms.yijava.service.flow.FlowBussService;
import dms.yijava.service.storage.StorageDetailService.PullStorageOpt;

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
			filters.add(PropertyFilters.build("ANDS_check_id", currentUserId));
			filters.add(PropertyFilters.build("ANDS_flow_id",flowIdentifierNumber));
		}
		filters.add(PropertyFilters.build("ANDS_dealer_ids", this.listString(sysUser.getUserDealerList())));
		
		return deliverService.paging(pageRequest,filters);
	}
	
	
	@ResponseBody
	@RequestMapping("pagingtodelver")
	public JsonPage<Deliver> pagingtodelver(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		/*SysUser sysUser = (SysUser) request.getSession().getAttribute("user");
		String currentUserId = sysUser.getId();
		if (null != sysUser && "84".equals(sysUser.getFk_department_id())){
			filters.add(PropertyFilters.build("ANDS_statuses", "0,1,2,3,4,5,6"));
		}else if (null != sysUser && StringUtils.isNotEmpty(sysUser.getTeams())) {
			filters.add(PropertyFilters.build("ANDS_statuses", "1,2,3,4,5,6"));
			filters.add(PropertyFilters.build("ANDS_check_id", currentUserId));
			filters.add(PropertyFilters.build("ANDS_flow_id",flowIdentifierNumber));
		}
		filters.add(PropertyFilters.build("ANDS_dealer_ids", this.listString(sysUser.getUserDealerList())));*/
		
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
				if(flowBussService.processFlow(deliver_id,sysUser,flowIdentifierNumber)){//提交流程
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
