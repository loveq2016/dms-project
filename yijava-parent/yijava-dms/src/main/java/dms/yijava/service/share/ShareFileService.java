package dms.yijava.service.share;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.share.ShareFileDao;
import dms.yijava.entity.key.UKey;
import dms.yijava.entity.share.ShareFile;

@Service
@Transactional
public class ShareFileService {

	@Autowired
	private ShareFileDao shareFileDao;
	
	public JsonPage<ShareFile> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return shareFileDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}

	public ShareFile getEntity(String id) {
		return shareFileDao.get(id);
	}
	
	public void saveEntity(ShareFile entity) {
		shareFileDao.insert(entity);
	}
	
	public void updateEntity(ShareFile entity) {
		shareFileDao.update( entity);
	}
	
	
	
	public void removeEntity(String key_id) {
		shareFileDao.remove( key_id);
	}
}
