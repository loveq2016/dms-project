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

import dms.yijava.dao.dealer.DealerCategoryDao;
import dms.yijava.entity.dealer.DealerCategory;

@Service
@Transactional
public class DealerCategoryService {

	@Autowired
	private DealerCategoryDao  dealerCategoryDao ;
	
	
	public List<DealerCategory> getList(){
		HashMap<String,String> parameters = new HashMap<String,String>();
		return dealerCategoryDao.find(parameters);
	}
		
	
	public JsonPage<DealerCategory> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return dealerCategoryDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
	
}
