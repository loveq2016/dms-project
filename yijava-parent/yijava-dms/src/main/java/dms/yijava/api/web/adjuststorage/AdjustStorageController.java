package dms.yijava.api.web.adjuststorage;

import java.text.SimpleDateFormat;
import java.util.Date;
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
import dms.yijava.entity.storage.StorageDetail;
import dms.yijava.entity.storage.StorageProDetail;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.adjuststorage.AdjustStorageDetailService;
import dms.yijava.service.adjuststorage.AdjustStorageProDetailService;
import dms.yijava.service.adjuststorage.AdjustStorageService;
import dms.yijava.service.flow.FlowBussService;
import dms.yijava.service.storage.StorageDetailService;
import dms.yijava.service.storage.StorageDetailService.PullStorageOpt;
@Controller
@RequestMapping("/api/adjuststorage")
public class AdjustStorageController {

	@Autowired
	private AdjustStorageService adjustStorageService;
	@Autowired
	private AdjustStorageDetailService adjustStorageDetailService;
	@Autowired
	private AdjustStorageProDetailService adjustStorageProDetailService;
	@Autowired
	private StorageDetailService storageDetailService;
	@Autowired
	private FlowBussService flowBussService;
	@Value("#{properties['adjustStorageflow_identifier_num']}")   	
	private String flowIdentifierNumber;
	@Value("#{properties['document_filepath']}")   	
	private String document_filepath;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<AdjustStorage> paging(PageRequest pageRequest,HttpServletRequest request) {
		SysUser sysUser = (SysUser) request.getSession().getAttribute("user");
		String currentUserId = sysUser.getId();
		List<PropertyFilter> filters = PropertyFilters.build(request);
		if (null != sysUser) {
			//经销商
			if (!StringUtils.equals("0", sysUser.getFk_dealer_id())) {
				filters.add(PropertyFilters.build("ANDS_dealer_id",sysUser.getFk_dealer_id()));
			}else if(StringUtils.isNotEmpty(sysUser.getTeams())){
				filters.add(PropertyFilters.build("ANDS_statuses","1,2,3,4"));
				filters.add(PropertyFilters.build("ANDS_check_id",currentUserId));
				filters.add(PropertyFilters.build("ANDS_dealer_ids", this.listString(sysUser.getUserDealerList())));
				filters.add(PropertyFilters.build("ANDS_flow_id",flowIdentifierNumber));
			}
			return adjustStorageService.paging(pageRequest,filters);
		}
		return null;
	}
	
	
	@ResponseBody
	@RequestMapping("save")
	public  Result<String> save(@ModelAttribute("entity") AdjustStorage entity, HttpServletRequest request) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		SimpleDateFormat formatter = new SimpleDateFormat("yyMMdd");
		SimpleDateFormat formatter2 = new SimpleDateFormat("yyyy-MM-dd");
		//必须是经销商才可以添加出货单
		if(StringUtils.isNotEmpty(sysUser.getFk_dealer_id()) && !"0".equals(sysUser.getFk_dealer_id())){
			try {
				
				AdjustStorage adjustStorage =  adjustStorageService.getAdjustStorageCode(sysUser.getFk_dealer_id());
				adjustStorage.setAdjust_storage_code(sysUser.getDealer_code()+"AJ"+formatter.format(new Date())+adjustStorage.getAdjust_storage_no());
				adjustStorage.setDealer_id(sysUser.getFk_dealer_id());
				adjustStorage.setType(entity.getType());
				adjustStorage.setAdjust_storage_date(formatter2.format(new Date()));
				adjustStorageService.saveEntity(adjustStorage);
				return new Result<String>(adjustStorage.getId(), 1);
			} catch (Exception e) {
				e.printStackTrace();
				return new Result<String>("0", 0);
			}
		}else{
			return new Result<String>("2", 2);
		}
	}
	

	@ResponseBody
	@RequestMapping("delete")
	public Result<String> delete(@RequestParam(value = "id", required = true) String id,
			@RequestParam(value = "adjust_storage_code", required = true) String adjust_storage_code) {
		try {
			adjustStorageService.removeEntity(id,adjust_storage_code);
			return new Result<String>(id, 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(id, 0);
	}
	
	
	
	@ResponseBody
	@RequestMapping("submit")
	public Result<String> submitAdjustStorage(@ModelAttribute("entity") AdjustStorage entity,HttpServletRequest request) {
		try {
			adjustStorageService.submitAdjustStorage(entity);
			return new Result<String>("1", 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>("0", 0);
	}
	
	
	@ResponseBody
	@RequestMapping("updatetocheck")
	public Result<Integer> updatetocheck(Integer adjust_id,HttpServletRequest request) {
		Result<Integer> result = new Result<Integer>(0, 0);
		try {				
				List<Object> list = adjustStorageService.processAdjustStorage(String.valueOf(adjust_id));
				PullStorageOpt pullStorageOpt = storageDetailService.updateStorageLockSn((List<StorageDetail>)list.get(0),(List<StorageProDetail>)list.get(1));
				if(pullStorageOpt!=null && "success".equals(pullStorageOpt.getStatus()) 
						&& pullStorageOpt.getList().size() > 0){//库存减少、锁定sn 返回状态
					//以下开始走流程处理
					SysUser sysUser = (SysUser) request.getSession().getAttribute("user");
					if(flowBussService.processFlow(adjust_id,sysUser,flowIdentifierNumber)){//提交流程
					//更新状态
						adjustStorageService.updateAdjustStorageStatus(String.valueOf(adjust_id), "1");//流程成功、更新业务的状态为提交审核
						result.setData(1);
						result.setState(1);;
					}else{
						storageDetailService.rollBackStorageUnLockSn((List<StorageDetail>)list.get(0),(List<StorageProDetail>)list.get(1));//流程失败，回滚库存与sn
						result.setError(new ErrorCode("出现系统错误，处理流程节点"));
					}
				}else{
					result.setError(new ErrorCode("出现系统错误，处理流程节点"));
				}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	

	/**
	 * 把一个list转换为String返回过去
	 */
	public String listString(List<UserDealer> list) {
		String listString = "";
		for (int i = 0; i < list.size(); i++) {
			try {
				if (i == list.size() - 1) {
					UserDealer ud = list.get(i);
					listString += ud.getDealer_id();
				} else {
					UserDealer ud = list.get(i);
					listString += ud.getDealer_id() + ",";
				}
			} catch (Exception e) {
			}
		}
		return listString;
	}
}
