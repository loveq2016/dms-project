package dms.yijava.service.storage;

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

import dms.yijava.dao.storage.StorageDao;
import dms.yijava.entity.hospital.Hospital;
import dms.yijava.entity.storage.Storage;

@Service
@Transactional
public class StorageService {

	@Autowired
	private StorageDao  storageDao ;
	
	public List<Storage> getList(String id){
		HashMap<String,String> parameters = new HashMap<String,String>();
		if(StringUtils.isNotEmpty(id))
			parameters.put("dealer_id", id);
		return storageDao.find(parameters);
	}
		
	public JsonPage<Storage> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return storageDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}

	public Hospital getEntity(String id) {
		return storageDao.get(id);
	}
	
	public void saveEntity(Storage entity) {
		try {
			storageDao.insert(entity);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void updateEntity(Storage entity) {
		try {
			storageDao.update( entity);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void deleteEntity(String id) {
		storageDao.removeById(id);
	}
}
