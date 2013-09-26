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

import dms.yijava.dao.dealer.DealerRelationFunDao;
import dms.yijava.entity.dealer.DealerRelationFun;

@Service
@Transactional
public class DealerRelationFunService {

	@Autowired
	private DealerRelationFunDao  dealerRelationFunDao ;
	
	
	public JsonPage<DealerRelationFun> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return dealerRelationFunDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
	public List<DealerRelationFun> getList(){
		HashMap<String,String> parameters = new HashMap<String,String>();
		return dealerRelationFunDao.find(parameters);
	}

	public void saveEntity(DealerRelationFun entity) {
		dealerRelationFunDao.insert(entity);
	}
	
	public void updateEntity(DealerRelationFun entity) {
		dealerRelationFunDao.update(entity);
	}

	

		

	
	
}
