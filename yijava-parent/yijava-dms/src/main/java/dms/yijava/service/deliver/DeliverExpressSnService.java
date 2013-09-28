package dms.yijava.service.deliver;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.deliver.DeliverExpressSnDao;
import dms.yijava.entity.deliver.DeliverExpressSn;

@Service
@Transactional
public class DeliverExpressSnService {

	@Autowired
	private DeliverExpressSnDao  deliverExpressSnDao ;
	
	
	public JsonPage<DeliverExpressSn> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return deliverExpressSnDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}


	public void saveEntity(DeliverExpressSn entity) {
		deliverExpressSnDao.insert(entity);
	}
	
	public void updateEntity(DeliverExpressSn entity) {
		deliverExpressSnDao.update(entity);
	}
	
	public void deleteEntity(String id) {
		deliverExpressSnDao.removeById(id);
	}

		
}
