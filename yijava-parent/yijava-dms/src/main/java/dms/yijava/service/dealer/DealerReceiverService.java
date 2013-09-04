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

import dms.yijava.dao.dealer.DealerReceiverDao;
import dms.yijava.entity.dealer.Dealer;
import dms.yijava.entity.dealer.DealerReceiver;

@Service
@Transactional
public class DealerReceiverService {

	@Autowired
	private DealerReceiverDao  dealerReceiverDao ;
	
	
	public JsonPage<DealerReceiver> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return dealerReceiverDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}

	public DealerReceiver getEntity(String id) {
		return dealerReceiverDao.get(id);
	}
	
	public void saveEntity(DealerReceiver entity) {
		dealerReceiverDao.insert(entity);
	}
	
	public void updateEntity(DealerReceiver entity) {
		dealerReceiverDao.update( entity);
	}
	
	public void deleteEntity(String id) {
		dealerReceiverDao.remove(id);
	}
		

	
	
}
