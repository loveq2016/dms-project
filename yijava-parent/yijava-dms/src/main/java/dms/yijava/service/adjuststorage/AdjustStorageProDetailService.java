package dms.yijava.service.adjuststorage;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.adjuststorage.AdjustStorageDao;
import dms.yijava.dao.adjuststorage.AdjustStorageDetailDao;
import dms.yijava.dao.adjuststorage.AdjustStorageProDetailDao;
import dms.yijava.entity.adjuststorage.AdjustStorage;
import dms.yijava.entity.adjuststorage.AdjustStorageDetail;
import dms.yijava.entity.adjuststorage.AdjustStorageProDetail;
import dms.yijava.entity.pullstorage.PullStorageProDetail;
@Service
@Transactional
public class AdjustStorageProDetailService{
	@Autowired
	private AdjustStorageDao adjustStorageDao;
	@Autowired
	private AdjustStorageProDetailDao adjustStorageProDetailDao;
	@Autowired
	private AdjustStorageDetailDao adjustStorageDetailDao;
	
	public JsonPage<AdjustStorageProDetail> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return adjustStorageProDetailDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	public List<AdjustStorageProDetail> getList(List<PropertyFilter> filters){
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return adjustStorageProDetailDao.find(parameters);
	}
	public PullStorageProDetail getEntity(String id) {
		return adjustStorageProDetailDao.get(id);
	}

	public void saveEntity(AdjustStorageProDetail entity) {
		adjustStorageProDetailDao.insert(entity);
		AdjustStorageDetail adjustStorageDetail = adjustStorageDetailDao.getObject(".selectAdjustStorageProDetailTotalNumber",entity.getAdjust_storage_detail_id());
		if (null != adjustStorageDetail) {
			adjustStorageDetailDao.updateObject(".updateTotalNumber", adjustStorageDetail);
		}
		AdjustStorage adjustStorage = adjustStorageDao.getObject(".selectAdjustStorageDetailTotalNumber",entity.getAdjust_storage_code());
		if (null != adjustStorage) {
			adjustStorageDao.updateObject(".updateTotalNumber", adjustStorage);
		}
	}
	
	public void removeByIdEntity(String id,String adjust_storage_detail_id,String adjust_storage_code) {
		adjustStorageProDetailDao.removeById(id);
		AdjustStorageDetail adjustStorageDetail = adjustStorageDetailDao.getObject(".selectAdjustStorageProDetailTotalNumber",adjust_storage_detail_id);
		if (null != adjustStorageDetail) {
			adjustStorageDetail.setId(adjust_storage_detail_id);
			adjustStorageDetailDao.updateObject(".updateTotalNumber", adjustStorageDetail);
		}else{
			adjustStorageDetail = new AdjustStorageDetail();
			adjustStorageDetail.setId(adjust_storage_detail_id);
			adjustStorageDetail.setAdjust_number("0");
			adjustStorageDao.updateObject(".updateTotalNumber", adjustStorageDetail);
		}
		AdjustStorage adjustStorage = adjustStorageDao.getObject(".selectAdjustStorageDetailTotalNumber",adjust_storage_code);
		if (null != adjustStorage) {
			adjustStorageDao.updateObject(".updateTotalNumber", adjustStorage);
		}else{
			adjustStorage = new AdjustStorage();
			adjustStorage.setAdjust_storage_code(adjust_storage_code);
			adjustStorage.setTotal_number("0");
			adjustStorageDao.updateObject(".updateTotalNumber", adjustStorage);
		}
	}

	
}
