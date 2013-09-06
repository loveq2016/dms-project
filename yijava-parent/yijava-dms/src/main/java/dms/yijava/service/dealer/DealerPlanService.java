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

import dms.yijava.dao.dealer.DealerPlanDao;
import dms.yijava.entity.dealer.DealerAddress;
import dms.yijava.entity.dealer.DealerPlan;

@Service
@Transactional
public class DealerPlanService {

	@Autowired
	private DealerPlanDao  dealerPlanDaoDao ;
	
	
	public JsonPage<DealerPlan> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return dealerPlanDaoDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}

	public DealerAddress getEntity(String id) {
		return dealerPlanDaoDao.get(id);
	}
	
	public void saveEntity(DealerPlan entity) {
		dealerPlanDaoDao.insert(entity);
	}
	
	public void updateEntity(DealerPlan entity) {
		dealerPlanDaoDao.update( entity);
	}
	
	public void deleteEntity(String id) {
		dealerPlanDaoDao.remove(id);
	}
		

	
	
}
