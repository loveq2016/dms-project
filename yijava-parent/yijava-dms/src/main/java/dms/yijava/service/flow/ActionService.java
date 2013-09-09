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

import dms.yijava.dao.flow.ActionDao;
import dms.yijava.entity.flow.Action;

@Service
@Transactional
public class ActionService {

	@Autowired
	private ActionDao actionDao;

	public JsonPage<Action> paging(PageRequest pageRequest,
			List<PropertyFilter> filters) {
		Map<String, String> parameters = new HashMap<String, String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return actionDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}

	public Action getEntity(String id) {
		return actionDao.get(id);
	}

	public int saveEntity(Action entity) {
		return actionDao.insert(entity);
	}

	public void updateEntity(Action entity) {
		actionDao.update(entity);
	}

	public void removeEntity(Action entity) {
		actionDao.remove(entity);
	}
}
