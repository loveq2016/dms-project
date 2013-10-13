package dms.yijava.service.adjuststorage;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.common.spring.SpringContextHolder;
import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.adjuststorage.AdjustStorageDao;
import dms.yijava.dao.adjuststorage.AdjustStorageDetailDao;
import dms.yijava.dao.adjuststorage.AdjustStorageProDetailDao;
import dms.yijava.entity.adjuststorage.AdjustStorage;
import dms.yijava.entity.adjuststorage.AdjustStorageDetail;
import dms.yijava.entity.adjuststorage.AdjustStorageProDetail;
import dms.yijava.entity.storage.StorageDetail;
import dms.yijava.entity.storage.StorageProDetail;
import dms.yijava.service.storage.StorageDetailService;
@Service
@Transactional
public class AdjustStorageService{
	@Autowired
	private AdjustStorageDao adjustStorageDao;
	@Autowired
	private AdjustStorageDetailDao adjustStorageDetailDao;
	@Autowired
	private AdjustStorageProDetailDao adjustStorageProDetailDao;
	

	
	
	public JsonPage<AdjustStorage> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		//DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			String propertyValue = propertyFilter.getMatchValue();
			parameters.put(propertyKey, propertyValue);
		}
		return adjustStorageDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}


	public void saveEntity(AdjustStorage entity) {
		adjustStorageDao.insert(entity);
	}
	public void updateEntity(AdjustStorage entity) {
		adjustStorageDao.update(entity);
	}
	
	
	public void submitAdjustStorage(AdjustStorage entity) {
		adjustStorageDao.updateObject(".submitAdjustStorage",entity);
	}
	
	
	public void updateAdjustStorageStatus(String id,String status){
		AdjustStorage entity = new AdjustStorage();
		entity.setId(id);
		entity.setStatus(status);
		adjustStorageDao.updateObject(".updateAdjustStorageStatus", entity);
	}
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void removeEntity(String id,String adjust_storage_code) {
		adjustStorageDao.removeById(id);
		adjustStorageDetailDao.removeObject(".deleteByAdjustStorageCode", adjust_storage_code);
		adjustStorageProDetailDao.removeObject(".deleteByAdjustStorageCode", adjust_storage_code);
	}

	public synchronized AdjustStorage getAdjustStorageCode(String dealer_id) {
		AdjustStorage adjustStorage= adjustStorageDao.getObject(".selectAdjustStorageCode",dealer_id);
		if(null==adjustStorage || StringUtils.isEmpty(adjustStorage.getAdjust_storage_no())){
			adjustStorage = new AdjustStorage();
			adjustStorage.setAdjust_storage_no("001");
		}
		return adjustStorage;
	}
	
	
	public AdjustStorage getEntity(String id) {
		return adjustStorageDao.get(id);
	}

	
	//驳回
	public void backFlow(String bussiness_id){
		this.updateAdjustStorageStatus(bussiness_id,"2");
		List<Object> list = this.processAdjustStorage(bussiness_id);
		SpringContextHolder.getApplicationContext().getBean(StorageDetailService.class).rollBackStorageUnLockSn(
				(List<StorageDetail>)list.get(0),(List<StorageProDetail>)list.get(1));//流程失败，回滚库存与sn
	}
	

	public List<Object> processAdjustStorage(String adjust_id){

		List<Object> returnList = new ArrayList<Object>();
		//库存减少。。锁定Sn
		AdjustStorage entity = SpringContextHolder.getApplicationContext().getBean(AdjustStorageService.class).getEntity(adjust_id);
		//库存表
		List<StorageDetail> storageDetailList = new ArrayList<StorageDetail>();
		//sn表
		List<StorageProDetail> StorageProDetailList =  new ArrayList<StorageProDetail>();
		if (entity != null) {
			List<AdjustStorageDetail>  adjustStorageDetails =  SpringContextHolder.getApplicationContext().getBean(AdjustStorageDetailService.class).getAdjustStorageDetailList(entity.getAdjust_storage_code());
			List<AdjustStorageProDetail>  adjustStorageProDetails =  SpringContextHolder.getApplicationContext().getBean(AdjustStorageProDetailService.class).getAdjustStorageProDetailList(entity.getAdjust_storage_code());
			for (AdjustStorageDetail adjustStorageDetail : adjustStorageDetails) {
				StorageDetail sd = new StorageDetail();
				sd.setFk_dealer_id(entity.getDealer_id());
				sd.setFk_storage_id(adjustStorageDetail.getFk_storage_id());
				sd.setProduct_item_number(adjustStorageDetail.getProduct_item_number());
				sd.setBatch_no(adjustStorageDetail.getBatch_no());
				sd.setInventory_number(adjustStorageDetail.getAdjust_number());
				storageDetailList.add(sd);
			}
			for (AdjustStorageProDetail adjustStorageProDetail : adjustStorageProDetails) {
				StorageProDetail spd1 = new StorageProDetail();
				spd1.setFk_dealer_id(entity.getDealer_id());
				spd1.setFk_storage_id(adjustStorageProDetail.getFk_storage_id());
				spd1.setBatch_no(adjustStorageProDetail.getBatch_no());
				spd1.setProduct_sn(adjustStorageProDetail.getProduct_sn());
				StorageProDetailList.add(spd1);
			}
		}
		returnList.add(storageDetailList);
		returnList.add(StorageProDetailList);
		return returnList;
	}
	
	
}
