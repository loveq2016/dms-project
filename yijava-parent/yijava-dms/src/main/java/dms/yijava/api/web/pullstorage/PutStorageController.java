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
import dms.yijava.entity.storage.StorageDetail;
import dms.yijava.entity.storage.StorageProDetail;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.pullstorage.PullStorageDetailService;
import dms.yijava.service.pullstorage.PullStorageProDetailService;
import dms.yijava.service.pullstorage.PullStorageService;
import dms.yijava.service.storage.StorageDetailService;
import dms.yijava.service.storage.StorageDetailService.PullStorageOpt;
@Controller
@RequestMapping("/api/putstorage")
public class PutStorageController {

	@Autowired
	private PullStorageService pullStorageService;
	@Autowired
	private PullStorageDetailService pullStorageDetailService;
	@Autowired
	private PullStorageProDetailService pullStorageProDetailService;
	@Autowired
	private StorageDetailService storageDetailService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<PullStorage> paging(PageRequest pageRequest,HttpServletRequest request) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		List<PropertyFilter> filters = PropertyFilters.build(request);
		if(null!=sysUser){
			//经销商
			if(!StringUtils.equals("0",sysUser.getFk_dealer_id())){
				filters.add(PropertyFilters.build("ANDS_fk_put_storage_party_id",sysUser.getFk_dealer_id()));
			}else if(StringUtils.isNotEmpty(sysUser.getTeams())){
				filters.add(PropertyFilters.build("ANDS_fk_put_storage_party_ids", this.listString(sysUser.getUserDealerList())));
			}
			filters.add(PropertyFilters.build("ANDS_status","3,4"));
			return pullStorageService.paging(pageRequest,filters);
		}
		return null;
	}
		
	@ResponseBody
	@RequestMapping("submit")
	public Result<Integer> submitPutStorage(@ModelAttribute("entity") PullStorage entity,HttpServletRequest request) {
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
			sd.setProduct_item_number(psd.getProduct_item_number());
			sd.setBatch_no(psd.getBatch_no());
			sd.setInventory_number(psd.getSales_number());
			sd.setValid_date(psd.getValid_date());
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
				spd.setBatch_no(pspd.getBatch_no());
				spd.setProduct_sn(pspd.getProduct_sn());
				storageProDetailList.add(spd);
			}
		}
		boolean s =storageDetailService.updateStorageAndSnSub(sysUser.getFk_dealer_id(),storageDetailList,storageProDetailList);
		if(s){
			/**
			 * 处理订单状态
			 */
			SimpleDateFormat time=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
			entity.setStatus("4");//成功
			entity.setPut_storage_date(time.format(new Date()));
			pullStorageService.updateEntity(entity);
			return new Result<Integer>(1, 1);
		}
		return new Result<Integer>(1, 2);		
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
