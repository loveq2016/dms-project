package dms.yijava.api.web.pullstorage;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

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
import dms.yijava.service.pullstorage.PullStorageDetailService;
import dms.yijava.service.pullstorage.PullStorageProDetailService;
import dms.yijava.service.pullstorage.PullStorageService;
import dms.yijava.service.storage.StorageDetailService;

@Controller
@RequestMapping("/api/pullstoragedetail")
public class PullStorageDetailController {
	@Autowired
	private PullStorageService pullStorageService;
	@Autowired
	private PullStorageDetailService pullStorageDetailService;
	@Autowired
	private PullStorageProDetailService pullStorageProDetailService;
	@Autowired
	private StorageDetailService storageDetailService;
	
	@ResponseBody
	@RequestMapping("detailpaging")
	public JsonPage<PullStorageDetail> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return pullStorageDetailService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("savedetail")
	public Result<String> savedetail(@ModelAttribute("entity") PullStorageDetail entity) {
		//同一个仓库下的，同一个批次 不能重复添加
		PullStorageDetail psd= pullStorageDetailService.getPullStorageDetail(entity);
		if(null==psd){
			pullStorageDetailService.saveEntity(entity);//保存产品
			PullStorage pullStorage = pullStorageService.getStorageDetailTotalNumber(entity.getPull_storage_code());
			pullStorageService.updateEntity(pullStorage);//修改出库单据总数量
			return new Result<String>(entity.getId(), 1);
		}else{
			return new Result<String>(entity.getId(), 2);
		}
	}
	
//	/**
//	 * 出货经销code,仓库ID,批次，产品SN，product_item_number
//	 * @param entity
//	 * @param request
//	 * @return
//	 */
//	@ResponseBody
//	@RequestMapping("remove")
//	public Result<Integer> remove(@ModelAttribute("entity") PullStorageDetail entity,HttpServletRequest request) {
//		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
//		
//		/**
//		 * 出库明细
//		 */
//		List<StorageDetail> storageDetailList  = new ArrayList<StorageDetail>();
//		StorageDetail sd = new StorageDetail();
//		sd.setFk_dealer_id(sysUser.getFk_dealer_id());
//		sd.setFk_storage_id(entity.getFk_storage_id());
//		sd.setProduct_item_number(entity.getProduct_item_number());
//		sd.setBatch_no(entity.getBatch_no());
//		sd.setInventory_number(entity.getSales_number());
//		/**
//		 * 出库产品SN明细
//		 */
//		List<PropertyFilter> filters = PropertyFilters.build(request);
//		List<PullStorageProDetail>  listPullStorageProDetail = pullStorageProDetailService.getList(filters); //sn list 需要回滚库存
//		List<StorageProDetail> storageProDetailList = new ArrayList<StorageProDetail>(); 
//		if(null!=listPullStorageProDetail){
//			for(int i=0;i<listPullStorageProDetail.size();i++){
//				PullStorageProDetail pspd=(PullStorageProDetail)listPullStorageProDetail.get(i);
//				StorageProDetail spd = new StorageProDetail();
//				spd.setFk_dealer_id(sysUser.getFk_dealer_id());
//				spd.setFk_storage_id(pspd.getFk_storage_id());
//				spd.setBatch_no(pspd.getBatch_no());
//				spd.setProduct_sn(pspd.getProduct_sn());
//				storageProDetailList.add(spd);
//			}
//		}
//		boolean s=storageDetailService.rollBackStorageUnLockSn(storageDetailList,storageProDetailList);
//		//回滚成功
//		if(s){
//			pullStorageDetailService.removeByStorageOrBatchNo(entity);
//			PullStorageProDetail pullStorageProDetail=new PullStorageProDetail();
//			pullStorageProDetail.setBatch_no(entity.getBatch_no());
//			pullStorageProDetail.setFk_storage_id(entity.getFk_storage_id());
//			pullStorageProDetail.setPull_storage_code(entity.getPull_storage_code());
//			pullStorageProDetailService.removeByStorageOrBatchNo(pullStorageProDetail);
//			//修改总数
//			PullStorage pullStorage = pullStorageService.getStorageDetailTotalNumber(entity.getPull_storage_code());
//			if(null==pullStorage){
//				pullStorage=new PullStorage();
//				pullStorage.setPull_storage_code(entity.getPull_storage_code());
//				pullStorage.setTotal_number("0");
//			}
//			pullStorageService.updateEntity(pullStorage);//修改单据总数
//			return new Result<Integer>(1, 1);
//		}else{
//			return new Result<Integer>(1, 2);
//		}
//	}
	
	/**
	 * 出货经销code,仓库ID,批次
	 * @param entity
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(@ModelAttribute("entity") PullStorageDetail entity,HttpServletRequest request) {
		pullStorageDetailService.removeByStorageOrBatchNo(entity);
		//修改总数
		PullStorage pullStorage = pullStorageService.getStorageDetailTotalNumber(entity.getPull_storage_code());
		if(null==pullStorage){
			pullStorage=new PullStorage();
			pullStorage.setPull_storage_code(entity.getPull_storage_code());
			pullStorage.setTotal_number("0");
		}
		pullStorageService.updateEntity(pullStorage);//修改单据总数
		return new Result<Integer>(1, 1);
	}
}
