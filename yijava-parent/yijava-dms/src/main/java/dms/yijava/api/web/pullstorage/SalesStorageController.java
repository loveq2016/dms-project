package dms.yijava.api.web.pullstorage;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.Result;

import dms.yijava.entity.pullstorage.PullStorage;
import dms.yijava.entity.pullstorage.PullStorageDetail;
import dms.yijava.entity.pullstorage.PullStorageProDetail;
import dms.yijava.entity.pullstorage.SalesStorage;
import dms.yijava.entity.storage.StorageDetail;
import dms.yijava.entity.storage.StorageProDetail;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.pullstorage.PullStorageDetailService;
import dms.yijava.service.pullstorage.PullStorageProDetailService;
import dms.yijava.service.pullstorage.SalesStorageService;
import dms.yijava.service.storage.StorageDetailService;
import dms.yijava.service.storage.StorageDetailService.PullStorageOpt;
@Controller
@RequestMapping("/api/salesstorage")
public class SalesStorageController {

	@Autowired
	private SalesStorageService salesStorageService;
	@Autowired
	private PullStorageDetailService pullStorageDetailService;
	@Autowired
	private PullStorageProDetailService pullStorageProDetailService;
	@Autowired
	private StorageDetailService storageDetailService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<SalesStorage> paging(PageRequest pageRequest,HttpServletRequest request) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		List<PropertyFilter> filters = PropertyFilters.build(request);
		if(null!=sysUser){
			//经销商
			if(!StringUtils.equals("0",sysUser.getFk_dealer_id())){
				filters.add(PropertyFilters.build("ANDS_fk_pull_storage_party_id",sysUser.getFk_dealer_id()));
			}else if(!StringUtils.equals("0",sysUser.getFk_department_id())){
				filters.add(PropertyFilters.build("ANDS_fk_pull_storage_party_ids", this.listString(sysUser.getUserDealerList())));
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
		//必须是经销商才可以添加出货单
		if(StringUtils.isNotEmpty(sysUser.getFk_dealer_id())){
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
	
	@ResponseBody
	@RequestMapping("submit")
	public Result<Integer> submitPullStorage(@ModelAttribute("entity") SalesStorage entity,HttpServletRequest request) {
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
				salesStorageService.updateEntity(entity);
			}
		}
		return new Result<Integer>(1, 1);
	}
	
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(HttpServletRequest request,@ModelAttribute("entity") PullStorage entity) {
		pullStorageDetailService.removeByPullStorageCode(entity.getPull_storage_code());
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