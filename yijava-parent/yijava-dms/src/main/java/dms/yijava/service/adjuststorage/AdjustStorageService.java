package dms.yijava.service.adjuststorage;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.adjuststorage.AdjustStorageDao;
import dms.yijava.dao.adjuststorage.AdjustStorageDetailDao;
import dms.yijava.entity.adjuststorage.AdjustStorage;
@Service
@Transactional
public class AdjustStorageService{
	@Autowired
	private AdjustStorageDao adjustStorageDao;
	@Autowired
	private AdjustStorageDetailDao adjustStorageDetailDao;
	
	
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
	
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void removeEntity(String id,String adjust_storage_code) {
		adjustStorageDao.removeById(id);
		adjustStorageDetailDao.removeObject(".deleteByAdjustStorageCode", adjust_storage_code);
	}

	public AdjustStorage getAdjustStorageCode(String dealer_id) {
		AdjustStorage adjustStorage= adjustStorageDao.getObject(".selectAdjustStorageCode",dealer_id);
		if(null==adjustStorage || StringUtils.isEmpty(adjustStorage.getAdjust_storage_no())){
			adjustStorage = new AdjustStorage();
			adjustStorage.setAdjust_storage_no("001");
		}
		return adjustStorage;
	}
	

	
	
}
