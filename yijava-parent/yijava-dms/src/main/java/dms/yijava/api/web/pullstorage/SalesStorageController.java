package dms.yijava.api.web.pullstorage;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.ErrorCode;
import com.yijava.web.vo.Result;

import dms.yijava.entity.pullstorage.PullStorage;
import dms.yijava.entity.pullstorage.PullStorageDetail;
import dms.yijava.entity.pullstorage.PullStorageProDetail;
import dms.yijava.entity.pullstorage.SalesStorage;
import dms.yijava.entity.storage.StorageDetail;
import dms.yijava.entity.storage.StorageProDetail;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.flow.FlowBussService;
import dms.yijava.service.pullstorage.PullStorageDetailService;
import dms.yijava.service.pullstorage.PullStorageProDetailService;
import dms.yijava.service.pullstorage.SalesStorageService;
import dms.yijava.service.storage.StorageDetailService;
import dms.yijava.service.storage.StorageDetailService.PullStorageOpt;
@Controller
@RequestMapping("/api/salesstorage")
public class SalesStorageController {
	private static final Logger logger = LoggerFactory.getLogger(SalesStorageController.class);
	@Value("#{properties['salesStorageflow_identifier_num']}")   	
	private String flowIdentifierNumber;
	@Autowired
	private SalesStorageService salesStorageService;
	@Autowired
	private PullStorageDetailService pullStorageDetailService;
	@Autowired
	private PullStorageProDetailService pullStorageProDetailService;
	@Autowired
	private StorageDetailService storageDetailService;
	@Autowired
	private FlowBussService flowBussService;
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<SalesStorage> paging(PageRequest pageRequest,HttpServletRequest request) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		String currentUserId=sysUser.getId();
		List<PropertyFilter> filters = PropertyFilters.build(request);
		if(null!=sysUser){
			//经销商
			if(!StringUtils.equals("0",sysUser.getFk_dealer_id())){
				filters.add(PropertyFilters.build("ANDS_fk_pull_storage_party_id",sysUser.getFk_dealer_id()));
			}else if(StringUtils.isNotEmpty(sysUser.getTeams())){
				filters.add(PropertyFilters.build("ANDS_fk_pull_storage_party_ids", this.listString(sysUser.getUserDealerList())));
				filters.add(PropertyFilters.build("ANDS_statuses","1,2,3,4,5,6"));
				filters.add(PropertyFilters.build("ANDS_check_id",currentUserId));
				filters.add(PropertyFilters.build("ANDS_flow_id",flowIdentifierNumber));
			}
			return salesStorageService.paging(pageRequest,filters);
		}
		return null;
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<Integer> save(@ModelAttribute("entity") SalesStorage entity,HttpServletRequest request) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		SimpleDateFormat formatter = new SimpleDateFormat("yyMMdd");
		//必须是经销商才可以添加销售单
		if(!StringUtils.equals("0",sysUser.getFk_dealer_id())){
			//销售出库
			entity.setFk_pull_storage_party_id(sysUser.getFk_dealer_id());
			SalesStorage pullObj=salesStorageService.getPullStorageCode(entity);
			//销售单
			entity.setPull_storage_code(sysUser.getDealer_code()+"SN"+formatter.format(new Date())+pullObj.getPull_storage_no());
			entity.setPull_storage_no(String.valueOf((Integer.parseInt(pullObj.getPull_storage_no()))));
			entity.setFk_pull_storage_party_id(sysUser.getFk_dealer_id());
			salesStorageService.saveEntity(entity);
			return new Result<Integer>(1, 1);
		}else{
			return new Result<Integer>(1, 0);
		}
	}
	
	
	/**
	 * 修改状态 提交审核
	 * @param trial_id
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping("updatetocheck")
	public Result<Integer> updatetocheck(PullStorage entity,HttpServletRequest request) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try {
			
			List<Object> list = salesStorageService.processSalesStorage(entity.getId());//获取SN
			PullStorageOpt pullStorageOpt = storageDetailService.updateStorageLockSn((List<StorageDetail>)list.get(0),(List<StorageProDetail>)list.get(1));//锁定库存
			if(pullStorageOpt!=null && "success".equals(pullStorageOpt.getStatus()) 
					&& pullStorageOpt.getList().size() > 0){
				//以下开始走流程处理
				SysUser sysUser = (SysUser) request.getSession().getAttribute("user");
				if(flowBussService.processFlow(Integer.parseInt(entity.getId()),sysUser,flowIdentifierNumber))
				{
					//更新状态
					salesStorageService.updateStatus(entity.getId(),"1");
					result.setData(1);
					result.setState(1);;
				}else
				{
					storageDetailService.rollBackStorageUnLockSn((List<StorageDetail>)list.get(0),(List<StorageProDetail>)list.get(1));//流程失败，回滚库存与sn
					result.setError(new ErrorCode("出现系统错误，处理流程节点"));
				}
			}else{
				result.setError(new ErrorCode("出现库存错误，库存不足!"));
			}
		} catch (Exception e) {
			logger.error("error" + e);
		}
		return result;
	}
	
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(HttpServletRequest request,@ModelAttribute("entity") PullStorage entity) {
		salesStorageService.removeByPullStorageCode(entity.getPull_storage_code());
		return new Result<Integer>(1, 1);
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
