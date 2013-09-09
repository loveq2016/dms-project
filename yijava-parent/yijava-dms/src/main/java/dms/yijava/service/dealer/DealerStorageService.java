package dms.yijava.service.dealer;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.dealer.DealerStorageDao;
import dms.yijava.entity.dealer.DealerStorage;

@Service
@Transactional
public class DealerStorageService {

	@Autowired
	private DealerStorageDao  dealerStorageDao ;
	
	
	public JsonPage<DealerStorage> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return dealerStorageDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
	
	public DealerStorage getEntity(String id) {
		return dealerStorageDao.get(id);
	}
	
	public void saveEntity(DealerStorage entity) {
		dealerStorageDao.insert(entity);
	}
	
	public void updateEntity(DealerStorage entity) {
		dealerStorageDao.update( entity);
	}
	
	public void deleteEntity(String id) {
		dealerStorageDao.remove(id);
	}
		

	
	
}
