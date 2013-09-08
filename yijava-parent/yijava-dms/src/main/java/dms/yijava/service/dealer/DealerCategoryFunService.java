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

import dms.yijava.dao.dealer.DealerCategoryFunDao;
import dms.yijava.entity.dealer.DealerCategory;
import dms.yijava.entity.dealer.DealerCategoryFun;

@Service
@Transactional
public class DealerCategoryFunService {

	@Autowired
	private DealerCategoryFunDao  dealerCategoryFunDao ;
	
	
	public JsonPage<DealerCategoryFun> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return dealerCategoryFunDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
	
	public DealerCategoryFun getEntity(String id) {
		return dealerCategoryFunDao.get(id);
	}
	
	public void saveEntity(DealerCategoryFun entity) {
		dealerCategoryFunDao.insert(entity);
	}
	
	public void updateEntity(DealerCategoryFun entity) {
		dealerCategoryFunDao.update( entity);
	}
	

		

	
	
}
