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

import dms.yijava.dao.pullstorage.SalesStorageDao;
import dms.yijava.entity.pullstorage.PullStorage;
import dms.yijava.entity.pullstorage.SalesStorage;
@Service
@Transactional
public class SalesStorageService{
	@Autowired
	private SalesStorageDao salesStorageDao;
	
	public JsonPage<SalesStorage> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		try{
			for (PropertyFilter propertyFilter : filters) {
				String propertyKey = propertyFilter.getPropertyNames()[0];
				String propertyValue = propertyFilter.getMatchValue();
				String hhmmss="";
				if(propertyKey.equals("pull_start_date") || propertyKey.equals("pull_end_date")||
						propertyKey.equals("sales_start_date") || propertyKey.equals("sales_end_date")){
					if(propertyKey.equals("pull_start_date")&&!"".equals(propertyValue))
						hhmmss=" 00:00:00";
					if(propertyKey.equals("pull_end_date")&&!"".equals(propertyValue))
						hhmmss=" 23:59:59";
					if(propertyKey.equals("sales_start_date")&&!"".equals(propertyValue))
						hhmmss=" 00:00:00";
					if(propertyKey.equals("sales_end_date")&&!"".equals(propertyValue))
						hhmmss=" 23:59:59";
					propertyValue=propertyValue + hhmmss;
				}
				parameters.put(propertyKey, propertyValue);
			}
		}catch(Exception ex){}
		return salesStorageDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	public List<SalesStorage> getList(List<PropertyFilter> filters){
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return salesStorageDao.find(parameters);
	}
	public PullStorage getEntity(String id) {
		return salesStorageDao.get(id);
	}
	public void saveEntity(SalesStorage entity) {
		salesStorageDao.insert(entity);
	}
	public void updateEntity(SalesStorage entity) {
		salesStorageDao.update(entity);
	}
	public void removeEntity(String id) {
		salesStorageDao.removeById(id);
	}
	public void removeByPullStorageCode(String pull_storage_code) {
		salesStorageDao.removeObject(".deleteByPullStorageCode",pull_storage_code);
	}
	public SalesStorage getStorageDetailTotalNumber(String pull_storage_code) {
		SalesStorage pullStorage=salesStorageDao.getObject(".selectStorageDetailTotalNumber",pull_storage_code);
		return pullStorage;
	}
	public SalesStorage getPullStorageCode(SalesStorage entity) {
		SalesStorage pullStorage=salesStorageDao.getObject(".selectPullStorageCode",entity);
		if(null==pullStorage || StringUtils.isEmpty(pullStorage.getPull_storage_no())){
			pullStorage=new SalesStorage();
			pullStorage.setPull_storage_no("001");
		}
		return pullStorage;
	}
}
