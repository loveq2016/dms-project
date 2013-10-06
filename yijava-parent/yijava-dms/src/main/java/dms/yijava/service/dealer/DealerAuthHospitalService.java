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

import dms.yijava.dao.dealer.DealerAuthHospitalDao;
import dms.yijava.entity.dealer.DealerAuthHospital;
import dms.yijava.entity.pullstorage.PullStorageDetail;

@Service
@Transactional
public class DealerAuthHospitalService {

	@Autowired
	private DealerAuthHospitalDao  dealerAuthHospitalDao ;
	
	
	public JsonPage<DealerAuthHospital> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return dealerAuthHospitalDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
	public List<DealerAuthHospital> getList(List<PropertyFilter> filters){
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return dealerAuthHospitalDao.find(parameters);
	}
	
	public DealerAuthHospital getEntity(String id) {
		return dealerAuthHospitalDao.get(id);
	}
	
	public void saveEntity(DealerAuthHospital entity) {
		dealerAuthHospitalDao.insert(entity);
	}
	
	public void updateEntity(DealerAuthHospital entity) {
		dealerAuthHospitalDao.update( entity);
	}
	
	public void deleteEntity(String id) {
		dealerAuthHospitalDao.remove(id);
	}
	
	
	public void deleteAllEntity(DealerAuthHospital entity) {
		dealerAuthHospitalDao.removeObject(".deleteAll", entity);
	}
	
	
}
