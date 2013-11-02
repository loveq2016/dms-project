package dms.yijava.service.storage;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import lombok.Data;
import lombok.NoArgsConstructor;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.storage.StorageDetailDao;
import dms.yijava.dao.storage.StorageProDetailDao;
import dms.yijava.entity.dealer.DealerStorage;
import dms.yijava.entity.deliver.DeliverExpressDetail;
import dms.yijava.entity.deliver.DeliverExpressSn;
import dms.yijava.entity.storage.StorageDetail;
import dms.yijava.entity.storage.StorageProDetail;
import dms.yijava.service.dealer.DealerStorageService;

@Service
@Transactional
public class StorageDetailService {

	@Autowired
	private StorageDetailDao  storageDetailDao ;
	@Autowired
	private StorageProDetailDao  storageProDetailDao ;
	@Autowired
	private DealerStorageService  dealerStorageService ;

	
	public JsonPage<StorageDetail> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return storageDetailDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
	
	/**
	 * 销售入库
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public synchronized String orderStorage(String dealer_id,String storage_id,String order_code,
			List<DeliverExpressDetail> deliverExpressDetails,
			List<DeliverExpressSn> deliverExpressSns) {
		//经销商id
		if(StringUtils.isBlank(dealer_id) || StringUtils.isBlank(storage_id)){
			return "storageError";
		}
	/*
		//查询默认仓库
		DealerStorage dealerStorage = dealerStorageService.getDefaultStorage(dealer_id);
		if (dealerStorage == null) {
			return "storageError";
		}
	*/
		//更新库存
		for (DeliverExpressDetail deliverExpressDetail : deliverExpressDetails) {
			StorageDetail storageDetail = new StorageDetail();
			//storageDetail.setFk_dealer_id(dealerStorage.getDealer_id());
			//storageDetail.setFk_storage_id(dealerStorage.getStorage_id());
			storageDetail.setFk_dealer_id(dealer_id);
			storageDetail.setFk_storage_id(storage_id);
			storageDetail.setProduct_item_number(deliverExpressDetail.getProduct_item_number());
			storageDetail.setInventory_number(deliverExpressDetail.getExpress_num());
			storageDetail.setBatch_no(deliverExpressDetail.getExpress_sn());
			storageDetail.setModels(deliverExpressDetail.getModels());
			storageDetail.setValid_date(deliverExpressDetail.getValidity_date());
			StorageDetail  tempStorageDetail = storageDetailDao.getObject(".queryStorageDetail",storageDetail);
			if (tempStorageDetail == null) {
				storageDetailDao.insertObject(".saveStorageDetail",storageDetail);
			}else{
				storageDetailDao.updateObject(".updateStorageDetail", storageDetail);
			}
			for (DeliverExpressSn deliverExpressSn : deliverExpressSns) {
				if(deliverExpressDetail.getId().equals(deliverExpressSn.getDeliver_express_detail_id())){
					StorageProDetail storageProDetail = new StorageProDetail();
//					storageProDetail.setFk_dealer_id(dealerStorage.getDealer_id());
//					storageProDetail.setFk_storage_id(dealerStorage.getStorage_id());
					storageProDetail.setFk_dealer_id(dealer_id);
					storageProDetail.setFk_storage_id(storage_id);
					storageProDetail.setFk_order_code(order_code);
					storageProDetail.setBatch_no(deliverExpressDetail.getExpress_sn());
					storageProDetail.setProduct_sn(deliverExpressSn.getProduct_sn());
					storageProDetail.setProduct_item_number(deliverExpressDetail.getProduct_item_number());
					storageProDetailDao.insertObject(".saveSnSub", storageProDetail);
				}
			}
		}
		return "success" ; 
	}
	
	
	/**
	 * 更新库存、锁定Sn记录
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public synchronized PullStorageOpt updateStorageLockSn(
			List<StorageDetail> StorageDetailList,
			List<StorageProDetail> StorageProDetailList) {
		List<StorageProDetail> lockSnList = new ArrayList<StorageProDetail>();
		PullStorageOpt opt = new PullStorageOpt();
		boolean isError = false ; 
		//减少库存
		for (StorageDetail storageDetail : StorageDetailList) {
			//查询库存
			StorageDetail  tempStorageDetail = storageDetailDao.getObject(".queryStorageDetail",storageDetail);
			if(tempStorageDetail ==null || 
					 (Math.abs(Integer.parseInt(storageDetail.getInventory_number())) > Integer.parseInt(tempStorageDetail.getInventory_number()))){
				//库存量不够修改的
				isError = true ;
				throw new RuntimeException("更新库存错误！库存量不足");
			}else{
				storageDetail.setInventory_number("-"+storageDetail.getInventory_number());
				int upIdex = storageDetailDao.updateObject(".updateStorageDetail", storageDetail);
			}
		}
		//锁定Sn记录
		for (StorageProDetail storageProDetail : StorageProDetailList) {
			StorageProDetail  tempStorageProDetail = storageProDetailDao.getObject(".selectStorageProDetailBySn",storageProDetail);
			if(tempStorageProDetail ==null ){
				isError = true;
				throw new RuntimeException("更新库存错误！库存量Sn记录已经被锁定");
			}else{
				int lockIdex = storageProDetailDao.updateObject(".lockSn", tempStorageProDetail);
				//返回锁定Sn记录List
				lockSnList.add(storageProDetail);
			}
		}
		
		if (isError) {
			opt.setStatus("faild");
			lockSnList = null;
		}else{
			opt.setStatus("success");
		}
		opt.setList(lockSnList);
		return opt;
		/*
		//查询sn List
		Map<String,Object> parameters = new HashMap<String, Object>();
		parameters.put("fk_storage_id", storageDetail.getFk_storage_id());
		parameters.put("fk_dealer_id", storageDetail.getFk_dealer_id());
		parameters.put("batch_no", storageDetail.getBatch_no());
		parameters.put("status", "1");
		parameters.put("size", Math.abs(Integer.parseInt(storageDetail.getInventory_number())));
		List<StorageProDetail> StorageProDetailList=   storageProDetailDao.findObject(".selectStorageProDetailBySn",parameters);
		if(StorageProDetailList.size()!= Math.abs(Integer.parseInt(storageDetail.getInventory_number()))){
			//获取sn数量 与 更新不一致
			try {
				isError = true ;
				throw new Exception("更新库存错误！Sn库存量不足");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else{
			
			for (StorageProDetail storageProDetail : StorageProDetailList) {
				//锁定Sn记录
				int lockIdex = storageProDetailDao.updateObject(".lockSn", storageProDetail);
				//System.out.println(lockIdex);
				//返回锁定Sn记录List
				lockSnList.add(storageProDetail);
			}	
			//System.out.println(upIdex);
		}
		*/

	}
	
	
	
	
	/**
	 * 库存回滚、取消锁定Sn记录
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public synchronized boolean rollBackStorageUnLockSn(List<StorageDetail> StorageDetailList,List<StorageProDetail> StorageProDetailList) {
		//库存回滚
		for (StorageDetail storageDetail : StorageDetailList) {
			int upIdex = storageDetailDao.updateObject(".updateStorageDetail", storageDetail);
			//System.out.println(upIdex);
		}
		for (StorageProDetail storageProDetail : StorageProDetailList) {
			//取消锁定Sn记录
			int lockIdex = storageProDetailDao.updateObject(".unlockSn", storageProDetail);
			//System.out.println(lockIdex);
		}	
		return true;
	}
	
	
	/**
	 * 入库：更新库存、更新Sn记录
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public synchronized boolean updateStorageAndSnSub(String dealer_id,
			List<StorageDetail> StorageDetailList,
			List<StorageProDetail> StorageProDetailList) {
		DealerStorage dealerStorage = null ; 
		if (dealer_id != null) {
			//查询默认仓库
			dealerStorage = dealerStorageService.getDefaultStorage(dealer_id);
			if (dealerStorage == null) {
				return false;
			}
		}

		for (StorageDetail storageDetail : StorageDetailList) {
			if(dealerStorage!=null)storageDetail.setFk_storage_id(dealerStorage.getStorage_id());
			StorageDetail  tempStorageDetail = storageDetailDao.getObject(".queryStorageDetail",storageDetail);
			if (tempStorageDetail == null) {
				storageDetailDao.insertObject(".saveStorageDetail",storageDetail);
			}else{
				storageDetailDao.updateObject(".updateStorageDetail", storageDetail);
			}
		}
		for (StorageProDetail storageProDetail : StorageProDetailList) {
			if(dealerStorage!=null)storageProDetail.setFk_storage_id(dealerStorage.getStorage_id());
			//更新Sn记录
			int lockIdex = storageProDetailDao.updateObject(".updateSnSub", storageProDetail);
			//System.out.println(lockIdex);
		}	
		return true;
	}
	
	
	@Data
	@NoArgsConstructor
	public class PullStorageOpt {
		private String status;
		private List<StorageProDetail> list;
	}
	

	
}
