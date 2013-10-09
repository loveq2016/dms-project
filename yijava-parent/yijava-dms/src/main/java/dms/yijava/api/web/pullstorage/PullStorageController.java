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

import dms.yijava.api.web.order.OrderController;
import dms.yijava.entity.pullstorage.PullStorage;
import dms.yijava.entity.pullstorage.PullStorageDetail;
import dms.yijava.entity.pullstorage.PullStorageProDetail;
import dms.yijava.entity.storage.StorageDetail;
import dms.yijava.entity.storage.StorageProDetail;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.flow.FlowBussService;
import dms.yijava.service.pullstorage.PullStorageDetailService;
import dms.yijava.service.pullstorage.PullStorageProDetailService;
import dms.yijava.service.pullstorage.PullStorageService;
import dms.yijava.service.storage.StorageDetailService;
import dms.yijava.service.storage.StorageDetailService.PullStorageOpt;
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
				filters.add(PropertyFilters.build("ANDS_check_id",currentUserId));
				filters.add(PropertyFilters.build("ANDS_flow_id",flowIdentifierNumber));
			}
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
			///以下开始走流程处理
			SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
			if(flowBussService.processFlow(Integer.parseInt(entity.getId()),sysUser,flowIdentifierNumber))
			{
				//更新库存
				/**
				 * 
				 * 
				 * 方法实现
				 * 
				 * 
				 */
				//更新状态
				pullStorageService.updateStatus(entity.getId(),"1");
				result.setData(1);
				result.setState(1);;
			}else
			{
				result.setError(new ErrorCode("出现系统错误，处理流程节点"));
			}
		} catch (Exception e) {
			logger.error("error" + e);
		}
		return result;
	}
		
	public Result<Integer> submitPullStorage(@ModelAttribute("entity") PullStorage entity,HttpServletRequest request) {
		/**
		 * 添加产品SN明细
		 */
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		List<PropertyFilter> filters = PropertyFilters.build(request);
		List<PullStorageDetail> listPullStorageDetail = pullStorageDetailService.getList(filters);
		if(null!=listPullStorageDetail){
			List<StorageDetail> storageDetailList  = new ArrayList<StorageDetail>();
			for(int i=0;i<listPullStorageDetail.size();i++){
				PullStorageDetail psd=listPullStorageDetail.get(i);
				StorageDetail sd = new StorageDetail();
				sd.setFk_dealer_id(sysUser.getFk_dealer_id());
				sd.setFk_storage_id(psd.getFk_storage_id());
				sd.setProduct_item_number(psd.getProduct_item_number());
				sd.setBatch_no(psd.getBatch_no());
				sd.setInventory_number("-"+psd.getSales_number());
				storageDetailList.add(sd);
			}
			PullStorageOpt pullStorageOpt=storageDetailService.updateStorageLockSn(storageDetailList); //获取sn（根据 批次，仓库，数量），更新仓库
			List<PullStorageProDetail> listPullStorageProDetail=new ArrayList<PullStorageProDetail>();
			if(pullStorageOpt.getStatus().equals("success")){
				for(int i=0;i<pullStorageOpt.getList().size();i++){
					PullStorageProDetail pspd=new PullStorageProDetail();
					StorageProDetail spd=pullStorageOpt.getList().get(i);
					pspd.setBatch_no(spd.getBatch_no());
					pspd.setFk_storage_id(spd.getFk_storage_id());
					pspd.setProduct_sn(spd.getProduct_sn());
					pspd.setPull_storage_code(entity.getPull_storage_code());
					pspd.setPut_storage_code(entity.getPut_storage_code());
					listPullStorageProDetail.add(pspd);
				}
				//同一个仓库下的，同一个批次，同一个序号   不能重复添加
				pullStorageProDetailService.saveEntity(listPullStorageProDetail);
				
				/**
				 * 处理订单状态
				 */
				SimpleDateFormat time=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
				entity.setStatus("1");//在途中
				entity.setPull_storage_date(time.format(new Date()));
				pullStorageService.updateEntity(entity);
			}
		}
		return new Result<Integer>(1, 1);
	}
	
	/**
	 * 需要的参数，如果需要改为方法，封装下面2个参数
	 * pull_storage_code:pull_storage_code,
	 * filter_ANDS_pull_storage_code:pull_storage_code
	 * @param request
	 * @param entity
	 * @return
	 */
	@ResponseBody
	@RequestMapping("storageRollBack")
	public Result<Integer> storageRollBack(HttpServletRequest request,@ModelAttribute("entity") PullStorage entity) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		/**
		 * 出库明细
		 */
		List<PropertyFilter> filters = PropertyFilters.build(request);
		List<PullStorageDetail> listPullStorageDetail = pullStorageDetailService.getList(filters);
		List<StorageDetail> storageDetailList  = new ArrayList<StorageDetail>();
		for(int i=0;i<listPullStorageDetail.size();i++){
			PullStorageDetail psd=listPullStorageDetail.get(i);
			StorageDetail sd = new StorageDetail();
			sd.setFk_dealer_id(sysUser.getFk_dealer_id());
			sd.setFk_storage_id(psd.getFk_storage_id());
			sd.setProduct_item_number(psd.getProduct_item_number());
			sd.setBatch_no(psd.getBatch_no());
			sd.setInventory_number(psd.getSales_number());
			storageDetailList.add(sd);
		}
		/**
		 * 出库产品SN明细
		 */
		List<PropertyFilter> filters2 = PropertyFilters.build(request);
		List<PullStorageProDetail>  listPullStorageProDetail = pullStorageProDetailService.getList(filters2); //sn list 需要回滚库存
		List<StorageProDetail> storageProDetailList = new ArrayList<StorageProDetail>(); 
		if(null!=listPullStorageProDetail){
			for(int i=0;i<listPullStorageProDetail.size();i++){
				PullStorageProDetail pspd=(PullStorageProDetail)listPullStorageProDetail.get(i);
				StorageProDetail spd = new StorageProDetail();
				spd.setFk_dealer_id(sysUser.getFk_dealer_id());
				spd.setFk_storage_id(pspd.getFk_storage_id());
				spd.setBatch_no(pspd.getBatch_no());
				spd.setProduct_sn(pspd.getProduct_sn());
				storageProDetailList.add(spd);
			}
		}
		boolean s=storageDetailService.rollBackStorageUnLockSn(storageDetailList,storageProDetailList);
		//回滚成功
		if(s){
			PullStorage pullStorage=new PullStorage();
			pullStorage.setStatus("3");//取消状态
			pullStorage.setPull_storage_code(entity.getPull_storage_code());
			pullStorageService.updateEntity(pullStorage);
			return new Result<Integer>(1, 1);
		}else{
			return new Result<Integer>(1, 2);
		}
	}
	
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(HttpServletRequest request,@ModelAttribute("entity") PullStorage entity) {
		pullStorageDetailService.removeByPullStorageCode(entity.getPull_storage_code());
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
