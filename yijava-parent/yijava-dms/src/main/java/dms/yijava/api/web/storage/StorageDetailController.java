package dms.yijava.api.web.storage;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;

import dms.yijava.entity.storage.StorageDetail;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.storage.StorageDetailService;
import dms.yijava.service.storage.StorageDetailService.PullStorageOpt;

@Controller
@RequestMapping("/api/storageDetail")
public class StorageDetailController {

	@Autowired
	private StorageDetailService storageDetailService;

	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<StorageDetail> paging(PageRequest pageRequest,
			HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return storageDetailService.paging(pageRequest, filters);
	}
	
	
	@ResponseBody
	@RequestMapping("api_paging")
	public JsonPage<StorageDetail> api_paging(PageRequest pageRequest,
			HttpServletRequest request) {
		SysUser sysUser = (SysUser) request.getSession().getAttribute("user");
		List<PropertyFilter> filters = PropertyFilters.build(request);
		boolean isDealerId=false;
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			if(propertyKey.equals("ANDS_dealer_id") || 
					propertyKey.equals("ANDS_dealer_ids")){
				isDealerId=true;
			}
		}
		if (null != sysUser && !isDealerId) {
			//经销商
			if (!StringUtils.equals("0", sysUser.getFk_dealer_id())) {
				filters.add(PropertyFilters.build("ANDS_dealer_id",sysUser.getFk_dealer_id()));
			}else if(StringUtils.isNotEmpty(sysUser.getTeams())){
				filters.add(PropertyFilters.build("ANDS_dealer_ids", this.listString(sysUser.getUserDealerList())));
			}
		}
		return storageDetailService.paging(pageRequest, filters);
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
	
	@ResponseBody
	@RequestMapping("test")
	public String test() {

		
		 	//出库 ： 更新库存、返回锁定SnList
			List<StorageDetail> StorageDetailList  = new ArrayList<StorageDetail>();
			StorageDetail sd1 = new StorageDetail();
			sd1.setFk_dealer_id("1");
			sd1.setFk_storage_id("1");
			sd1.setProduct_item_number("34");
			sd1.setBatch_no("AAA");
			sd1.setInventory_number("-1");
			StorageDetailList.add(sd1);
			//PullStorageOpt test = storageDetailService.updateStorageLockSn(StorageDetailList);
			
			
			
			//System.out.println(test);
	
		
		/**
		 * 出库 ： 库存回滚、取消锁定SnList,返回boolean
			List<StorageDetail> StorageDetailList  = new ArrayList<StorageDetail>();
			StorageDetail sd1 = new StorageDetail();
			sd1.setFk_dealer_id("3");
			sd1.setFk_storage_id("7");
			sd1.setProduct_item_number("34");
			sd1.setBatch_no("aaa");
			sd1.setInventory_number("3");
			StorageDetailList.add(sd1);
			
			List<StorageProDetail> StorageProDetailList = new ArrayList<StorageProDetail>(); 
			StorageProDetail spd1 = new StorageProDetail();
			spd1.setFk_dealer_id("3");
			spd1.setFk_storage_id("7");
			spd1.setBatch_no("aaa");
			spd1.setProduct_sn("sn001");
			StorageProDetailList.add(spd1);
			
			storageDetailService.rollBackStorageUnLockSn(StorageDetailList,StorageProDetailList);
		**/	
		
		/**
		 * 入库：确认收货、更新库存、更新Sn
			List<StorageDetail> StorageDetailList  = new ArrayList<StorageDetail>();
			StorageDetail sd1 = new StorageDetail();
			sd1.setFk_dealer_id("3");
			sd1.setFk_storage_id("7");
			sd1.setProduct_item_number("34");
			sd1.setBatch_no("aaa");
			sd1.setInventory_number("3");
			StorageDetailList.add(sd1);
			
			List<StorageProDetail> StorageProDetailList = new ArrayList<StorageProDetail>(); 
			StorageProDetail spd1 = new StorageProDetail();
			spd1.setFk_dealer_id("3");
			spd1.setFk_storage_id("7");
			spd1.setBatch_no("aaa");
			spd1.setProduct_sn("sn001");
			StorageProDetailList.add(spd1);
			
			storageDetailService.updateStorageAndSnSub(StorageDetailList,StorageProDetailList);
		**/	
		
		
		
		
		return "2";
	}
	
	
	

}
