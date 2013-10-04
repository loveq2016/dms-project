package dms.yijava.service.pullstorage;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.pullstorage.PullStorageDao;
import dms.yijava.entity.order.Order;
import dms.yijava.entity.pullstorage.PullStorage;
@Service
@Transactional
public class PullStorageService{
	@Autowired
	private PullStorageDao pullStorageDao;
	
	public JsonPage<PullStorage> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Map<String,String> parameters = new HashMap<String,String>();
		try{
			for (PropertyFilter propertyFilter : filters) {
				String propertyKey = propertyFilter.getPropertyNames()[0];
				String propertyValue = propertyFilter.getMatchValue();
				String hhmmss="";
				if(propertyKey.equals("pull_start_date") || propertyKey.equals("pull_end_date")||
						propertyKey.equals("put_start_date") || propertyKey.equals("put_end_date")){
					if(propertyKey.equals("pull_start_date")&&!"".equals(propertyValue))
						hhmmss=" 00:00:00";
					if(propertyKey.equals("pull_end_date")&&!"".equals(propertyValue))
						hhmmss=" 23:59:59";
					if(propertyKey.equals("put_start_date")&&!"".equals(propertyValue))
						hhmmss=" 00:00:00";
					if(propertyKey.equals("put_end_date")&&!"".equals(propertyValue))
						hhmmss=" 23:59:59";
					propertyValue=propertyValue + hhmmss;
				}
				parameters.put(propertyKey, propertyValue);
			}
		}catch(Exception ex){}
		return pullStorageDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	public List<PullStorage> getList(List<PropertyFilter> filters){
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return pullStorageDao.find(parameters);
	}
	public PullStorage getEntity(String id) {
		return pullStorageDao.get(id);
	}
	public void saveEntity(PullStorage entity) {
		pullStorageDao.insert(entity);
	}
	public void updateEntity(PullStorage entity) {
		pullStorageDao.update(entity);
	}
	public void removeEntity(String id) {
		pullStorageDao.removeById(id);
	}
	public void removeByPullStorageCode(String pull_storage_code) {
		pullStorageDao.removeObject(".deleteByPullStorageCode",pull_storage_code);
	}
	public PullStorage getStorageDetailTotalNumber(String pull_storage_code) {
		PullStorage pullStorage=pullStorageDao.getObject(".selectStorageDetailTotalNumber",pull_storage_code);
		return pullStorage;
	}
	/**
	 * 返回入库单据
	 * @param put_storage_party_id
	 * @return
	 */
	public PullStorage getPutStorageCode(String put_storage_party_id) {
		PullStorage pullStorage=pullStorageDao.getObject(".selectPutStorageCode",put_storage_party_id);
		if(null==pullStorage || StringUtils.isEmpty(pullStorage.getPut_storage_no())){
			pullStorage=new PullStorage();
			pullStorage.setPut_storage_no("001");
		}
		return pullStorage;
	}
	/**
	 * 返回出库单据
	 * @param pull_storage_party_id
	 * @return
	 */
	public PullStorage getPullStorageCode(String pull_storage_party_id) {
		PullStorage pullStorage=pullStorageDao.getObject(".selectPullStorageCode",pull_storage_party_id);
		if(null==pullStorage || StringUtils.isEmpty(pullStorage.getPull_storage_no())){
			pullStorage=new PullStorage();
			pullStorage.setPull_storage_no("001");
		}
		return pullStorage;
	}
}
