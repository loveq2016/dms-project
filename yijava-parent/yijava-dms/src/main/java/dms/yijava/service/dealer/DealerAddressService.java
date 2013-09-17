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

import dms.yijava.dao.dealer.DealerAddressDao;
import dms.yijava.entity.dealer.DealerAddress;
import dms.yijava.entity.order.Order;

@Service
@Transactional
public class DealerAddressService {

	@Autowired
	private DealerAddressDao  dealerAddressDao ;
	
	
	public JsonPage<DealerAddress> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return dealerAddressDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}

	public List<DealerAddress> getList(String dealer_id){
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("dealer_id", dealer_id);
		return dealerAddressDao.find(parameters);
	}
	
	public DealerAddress getEntity(String id) {
		return dealerAddressDao.get(id);
	}
	
	public void saveEntity(DealerAddress entity) {
		dealerAddressDao.insert(entity);
	}
	
	public void updateEntity(DealerAddress entity) {
		dealerAddressDao.update( entity);
	}
	
	public void deleteEntity(String id) {
		dealerAddressDao.remove(id);
	}
		

	
	
}
