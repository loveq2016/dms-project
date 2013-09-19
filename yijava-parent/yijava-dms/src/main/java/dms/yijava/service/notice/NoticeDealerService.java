package dms.yijava.service.notice;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.notice.NoticeDealerDao;
import dms.yijava.entity.notice.NoticeDealer;

@Service
@Transactional
public class NoticeDealerService {

	@Autowired
	private NoticeDealerDao noticeDealerDao;

	public JsonPage<NoticeDealer> paging(PageRequest pageRequest,
			List<PropertyFilter> filters) {
		Map<String, String> parameters = new HashMap<String, String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return noticeDealerDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
	
	public void updateEntity(NoticeDealer entity) {
		noticeDealerDao.update(entity);
	}


}
