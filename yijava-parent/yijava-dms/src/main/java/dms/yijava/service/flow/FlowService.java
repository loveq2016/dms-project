package dms.yijava.service.flow;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.flow.FlowDao;
import dms.yijava.entity.flow.Flow;


@Service
@Transactional
public class FlowService {

	@Autowired
	private FlowDao flowDao;
	
	
	public JsonPage<Flow> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return flowDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}

	public Flow getEntity(String id) {
		return flowDao.get(id);
	}
	
	public void saveEntity(Flow entity) {
		flowDao.insert(entity);
	}
	
	public void updateEntity(Flow entity) {
		flowDao.update( entity);
	}
	
	public void removeEntity(Flow entity) {
		flowDao.remove( entity);
	}
}
