package dms.yijava.service.storage;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.storage.StorageDetailDao;
import dms.yijava.dao.storage.StorageProDetailDao;
import dms.yijava.entity.storage.StorageDetail;
import dms.yijava.entity.storage.StorageProDetail;

@Service
@Transactional
public class StorageDetailService {

	@Autowired
	private StorageDetailDao  storageDetailDao ;
	@Autowired
	private StorageProDetailDao  storageProDetailDao ;
	
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
	
	
	// 销售入库
	public void orderStorage() {
		
	}
	
	
	/**
	 * 更新库存、锁定Sn记录
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public List<StorageProDetail> updateStorageLockSn(List<StorageDetail> StorageDetailList) {
		List<StorageProDetail> lockSnList = new ArrayList<StorageProDetail>();
		try {
			//减少库存
			for (StorageDetail storageDetail : StorageDetailList) {
				int upIdex = storageDetailDao.updateObject(".updateStorageDetail", storageDetail);
				//System.out.println(upIdex);
				Map<String,Object> parameters = new HashMap<String, Object>();
				parameters.put("fk_storage_id", storageDetail.getFk_storage_id());
				parameters.put("fk_dealer_id", storageDetail.getFk_dealer_id());
				parameters.put("batch_no", storageDetail.getBatch_no());
				parameters.put("status", "1");
				parameters.put("size", Math.abs(Integer.parseInt(storageDetail.getInventory_number())));
				List<StorageProDetail> StorageProDetailList=   storageProDetailDao.findObject(".selectStorageProDetailByStatus",parameters);
				for (StorageProDetail storageProDetail : StorageProDetailList) {
					//锁定Sn记录
					int lockIdex = storageProDetailDao.updateObject(".lockSn", storageProDetail);
					//System.out.println(lockIdex);
					//返回锁定Sn记录List
					lockSnList.add(storageProDetail);
				}		
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return lockSnList;
	}
	
	
	/**
	 * 库存回滚、取消锁定Sn记录
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public boolean rollBackStorageUnLockSn(List<StorageDetail> StorageDetailList,List<StorageProDetail> StorageProDetailList) {
		try {
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
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	
	/**
	 * 入库：更新库存、更新Sn记录
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public boolean updateStorageAndSnSub(List<StorageDetail> StorageDetailList,List<StorageProDetail> StorageProDetailList){
		try {
			for (StorageDetail storageDetail : StorageDetailList) {
				StorageDetail  tempStorageDetail = storageDetailDao.getObject(".queryStorageDetail",storageDetail);
				if (tempStorageDetail == null) {
					storageDetailDao.insertObject(".saveStorageDetail",storageDetail);
				}else{
					storageDetailDao.updateObject(".updateStorageDetail", storageDetail);
				}
			}
			for (StorageProDetail storageProDetail : StorageProDetailList) {
				//更新Sn记录
				int lockIdex = storageProDetailDao.updateObject(".updateSnSub", storageProDetail);
				//System.out.println(lockIdex);
			}	
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	
	
	
	

	
}
