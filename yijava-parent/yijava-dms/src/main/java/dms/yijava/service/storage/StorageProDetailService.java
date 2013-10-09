package dms.yijava.service.storage;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.storage.StorageProDetailDao;
import dms.yijava.entity.storage.StorageProDetail;

@Service
@Transactional
public class StorageProDetailService {

	@Autowired
	private StorageProDetailDao  storageProDetailDao ;

	
	public JsonPage<StorageProDetail> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return storageProDetailDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
	public List<StorageProDetail> getList(List<PropertyFilter> filters) {
		//HashMap<String, String> parameters = new HashMap<String, String>();
		return storageProDetailDao.find(".selectStorageProDetail", filters);
	}
	

	

	
}
