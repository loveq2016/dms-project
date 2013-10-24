package dms.yijava.api.web.pullstorage;

import java.text.SimpleDateFormat;
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

import com.yijava.common.utils.DateUtils;
import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.ErrorCode;
import com.yijava.web.vo.Result;

import dms.yijava.entity.flow.FlowRecord;
import dms.yijava.entity.pullstorage.PullStorage;
import dms.yijava.entity.storage.StorageDetail;
import dms.yijava.entity.storage.StorageProDetail;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.flow.FlowBussService;
import dms.yijava.service.flow.FlowRecordService;
import dms.yijava.service.pullstorage.PullStorageDetailService;
import dms.yijava.service.pullstorage.PullStorageProDetailService;
import dms.yijava.service.pullstorage.PullStorageService;
import dms.yijava.service.storage.StorageDetailService;
import dms.yijava.service.storage.StorageDetailService.PullStorageOpt;
import dms.yijava.service.system.SysUserService;
@Controller
@RequestMapping("/api/pullstorage")
public class PullStorageController {
	private static final Logger logger = LoggerFactory.getLogger(PullStorageController.class);
	@Value("#{properties['pullStorageflow_identifier_num']}")   	
	private String flowIdentifierNumber;
	@Autowired
	private PullStorageService pullStorageService;
	@Autowired
	private PullStorageDetailService pullStorageDetailService;
	@Autowired
	private PullStorageProDetailService pullStorageProDetailService;
	@Autowired
	private StorageDetailService storageDetailService;
	@Autowired
	private FlowBussService flowBussService;
	@Autowired
	private FlowRecordService flowRecordService;
	@Autowired
	private SysUserService sysUserService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<PullStorage> paging(PageRequest pageRequest,HttpServletRequest request) {
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
			}
			filters.add(PropertyFilters.build("ANDS_check_id",currentUserId));
			filters.add(PropertyFilters.build("ANDS_flow_id",flowIdentifierNumber));
			return pullStorageService.paging(pageRequest,filters);
		}
		return null;
	}
	
	@ResponseBody
	@RequestMapping("list")
	public List<PullStorage> getList(HttpServletRequest request){
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return pullStorageService.getList(filters);
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<Integer> save(@ModelAttribute("entity") PullStorage entity,HttpServletRequest request) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		SimpleDateFormat formatter = new SimpleDateFormat("yyMMdd");
		//必须是经销商才可以添加出货单
		if(!StringUtils.equals("0",sysUser.getFk_dealer_id())){
			if(!sysUser.getFk_dealer_id().equals(entity.getFk_put_storage_party_id())){
				PullStorage pullObj=pullStorageService.getPullStorageCode(sysUser.getFk_dealer_id());
				PullStorage putObj=pullStorageService.getPutStorageCode(entity.getFk_put_storage_party_id());
				//出货单
				entity.setPull_storage_code(sysUser.getDealer_code()+"RN"+formatter.format(new Date())+pullObj.getPull_storage_no());
				entity.setPull_storage_no(String.valueOf((Integer.parseInt(pullObj.getPull_storage_no()))));
				entity.setFk_pull_storage_party_id(sysUser.getFk_dealer_id());
				//收货单
				entity.setPut_storage_code(entity.getPut_storage_code()+"PR"+formatter.format(new Date())+putObj.getPut_storage_no());
				entity.setPut_storage_no(String.valueOf((Integer.parseInt(putObj.getPut_storage_no()))));
				pullStorageService.saveEntity(entity);
				return new Result<Integer>(1, 1);
			}else{
				return new Result<Integer>(1, 2);
			}
		}else{
			return new Result<Integer>(1, 0);
		}
	}
	@ResponseBody
	@RequestMapping("updateEntity")
	public Result<Integer> updateStatus(@ModelAttribute("entity") PullStorage entity) {
		pullStorageService.updateEntity(entity);
		return new Result<Integer>(1, 1);
	}
	
	/**
	 * 提交审核 修改状态 (处理流程)
	 * @param trial_id
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping("updatetocheck")
	public Result<Integer> updatetocheck(PullStorage entity,HttpServletRequest request) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try {
			//出库
			List<Object> list = pullStorageService.processPullStorage(entity.getId());//获取产品明细，SN明显
			if(((List<StorageDetail>)list.get(0)).size()>0 &&
					((List<StorageProDetail>)list.get(1)).size()>0){
				PullStorageOpt pullStorageOpt = storageDetailService.updateStorageLockSn((List<StorageDetail>)list.get(0),(List<StorageProDetail>)list.get(1));//锁定库存
				if(pullStorageOpt!=null && "success".equals(pullStorageOpt.getStatus()) 
						&& pullStorageOpt.getList().size() > 0){
					//以下开始走流程处理
					SysUser sysUser = (SysUser) request.getSession().getAttribute("user");
					if(flowBussService.processFlow(Integer.parseInt(entity.getId()),sysUser,flowIdentifierNumber))
					{
						//更新状态
						pullStorageService.updateStatus(entity.getId(),"1");
						SimpleDateFormat time=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
						entity.setStatus("1");
						entity.setPull_storage_date(time.format(new Date()));
						pullStorageService.updateEntity(entity);//修改发货时间
						result.setData(1);
						result.setState(1);;
					}else
					{
						storageDetailService.rollBackStorageUnLockSn((List<StorageDetail>)list.get(0),(List<StorageProDetail>)list.get(1));//流程失败，回滚库存与sn
						result.setError(new ErrorCode("出现系统错误，处理流程节点"));
					}
				}else{
					result.setState(4);
					result.setError(new ErrorCode("出现库存错误，库存不足!"));
				}
			}else{
				if(((List<StorageProDetail>)list.get(1)).size()<=0){
					result.setState(2);
				}
				if(((List<StorageDetail>)list.get(0)).size()<=0){
					result.setState(3);
				}
			}
		} catch (Exception e) {
			logger.error("error" + e);
		}
		return result;
	}
	
	/**
	 * 提交单据，处理库存，(无流程)
	 * @param entity
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping("submitPullStorage")
	public Result<Integer> submitPullStorage(@ModelAttribute("entity") PullStorage entity,HttpServletRequest request) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try{
			//出库
			List<Object> list = pullStorageService.processPullStorage(entity.getId());//获取产品明细，SN明显
			if(((List<StorageDetail>)list.get(0)).size()>0 &&
					((List<StorageProDetail>)list.get(1)).size()>0){
				PullStorageOpt pullStorageOpt = storageDetailService.updateStorageLockSn((List<StorageDetail>)list.get(0),(List<StorageProDetail>)list.get(1));//锁定库存
				if(pullStorageOpt!=null && "success".equals(pullStorageOpt.getStatus()) 
						&& pullStorageOpt.getList().size() > 0){
						/**
						 * 处理订单状态
						 */
						SimpleDateFormat time=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
						entity.setStatus("3");//在途中
						entity.setPull_storage_date(time.format(new Date()));
						pullStorageService.updateSalesStatus(entity);
						result.setData(1);
						result.setState(1);
				}else{
					result.setState(4);
					result.setError(new ErrorCode("出现库存错误，库存不足!"));
				}
			}else{
				if(((List<StorageProDetail>)list.get(1)).size()<=0){
					result.setState(2);
				}
				if(((List<StorageDetail>)list.get(0)).size()<=0){
					result.setState(3);
				}
			}
		}catch (Exception e) {
			logger.error("error" + e);
		}
		return result;
	}
	
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(HttpServletRequest request,@ModelAttribute("entity") PullStorage entity) {
		pullStorageService.removeByPullStorageCode(entity.getPull_storage_code());
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
