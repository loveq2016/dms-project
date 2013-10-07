package dms.yijava.service.adjuststorage;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.adjuststorage.AdjustStorageProDetailDao;
import dms.yijava.entity.adjuststorage.AdjustStorageProDetail;
import dms.yijava.entity.pullstorage.PullStorageProDetail;
@Service
@Transactional
public class AdjustStorageProDetailService{
	@Autowired
	private AdjustStorageProDetailDao adjustStorageProDetailDao;
	
	public JsonPage<AdjustStorageProDetail> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return adjustStorageProDetailDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	public List<AdjustStorageProDetail> getList(List<PropertyFilter> filters){
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return adjustStorageProDetailDao.find(parameters);
	}
	public PullStorageProDetail getEntity(String id) {
		return adjustStorageProDetailDao.get(id);
	}
	public void saveEntity(List<AdjustStorageProDetail> list) {
		adjustStorageProDetailDao.insert(list);
	}
	public void removeByIdEntity(String id) {
		adjustStorageProDetailDao.removeById(id);
	}

	
}
