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

import dms.yijava.dao.dealer.DealerAuthProductDao;
import dms.yijava.entity.dealer.DealerAuthProduct;

@Service
@Transactional
public class DealerAuthProductService {

	@Autowired
	private DealerAuthProductDao  dealerAuthProductDao ;
	
	
	public JsonPage<DealerAuthProduct> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return dealerAuthProductDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
	
	public List<DealerAuthProduct> getList(String dealer_id){
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("dealer_id", dealer_id);
		return dealerAuthProductDao.find(parameters);
	}
	
	
	public DealerAuthProduct getEntity(String id) {
		return dealerAuthProductDao.get(id);
	}
	
	public void saveEntity(DealerAuthProduct entity) {
		dealerAuthProductDao.insert(entity);
	}
	
	public void updateEntity(DealerAuthProduct entity) {
		dealerAuthProductDao.update( entity);
	}
	
	public void deleteEntity(String id) {
		dealerAuthProductDao.remove(id);
	}
		

	
	
}
