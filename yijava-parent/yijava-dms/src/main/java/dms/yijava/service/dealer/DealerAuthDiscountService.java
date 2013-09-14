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

import dms.yijava.dao.dealer.DealerAuthDiscountDao;
import dms.yijava.entity.dealer.DealerAuthDiscount;

@Service
@Transactional
public class DealerAuthDiscountService {

	@Autowired
	private DealerAuthDiscountDao  dealerAuthDiscountDao ;
	
	
	public JsonPage<DealerAuthDiscount> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return dealerAuthDiscountDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
	
	public DealerAuthDiscount getEntity(String id) {
		return dealerAuthDiscountDao.get(id);
	}
	
	public void saveEntity(DealerAuthDiscount entity) {
		dealerAuthDiscountDao.insert(entity);
	}
	
	public void updateEntity(DealerAuthDiscount entity) {
		dealerAuthDiscountDao.update( entity);
	}
	
	public void deleteEntity(String id) {
		dealerAuthDiscountDao.remove(id);
	}
	
	

	
	
	
	
	
	
		

	
	
}
