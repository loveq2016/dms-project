package dms.yijava.service.key;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.key.UKeyDao;
import dms.yijava.entity.flow.Flow;
import dms.yijava.entity.key.UKey;

@Service
@Transactional
public class UKeyService {

	@Autowired
	private UKeyDao uKeyDao;
	
	public JsonPage<UKey> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return uKeyDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}

	public UKey getEntity(String id) {
		return uKeyDao.get(id);
	}
	
	public void saveEntity(UKey entity) {
		uKeyDao.insert(entity);
	}
	
	public void updateEntity(UKey entity) {
		uKeyDao.update( entity);
	}
	
	public void removeEntityById(String key_id) {
		uKeyDao.removeById( key_id);
	}
}
