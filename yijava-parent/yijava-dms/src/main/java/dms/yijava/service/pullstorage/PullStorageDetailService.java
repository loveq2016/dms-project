package dms.yijava.service.pullstorage;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.pullstorage.PullStorageDetailDao;
import dms.yijava.entity.order.OrderDetail;
import dms.yijava.entity.pullstorage.PullStorageDetail;
import dms.yijava.entity.pullstorage.PullStorageProDetail;
@Service
@Transactional
public class PullStorageDetailService{

	@Autowired
	private PullStorageDetailDao pullStorageDetailDao;
	
	public JsonPage<PullStorageDetail> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return pullStorageDetailDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	public List<PullStorageDetail> getList(List<PropertyFilter> filters){
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return pullStorageDetailDao.find(parameters);
	}
	public PullStorageDetail getEntity(String id) {
		return pullStorageDetailDao.get(id);
	}
	
	public void saveEntity(PullStorageDetail entity) {
		pullStorageDetailDao.insert(entity);
	}
	
	public void removeByIdEntity(String id) {
		pullStorageDetailDao.removeById(id);
	}
	public void removeByPullStorageCode(String pull_storage_code) {
		pullStorageDetailDao.removeObject(".deleteByPullStorageCode",pull_storage_code);
	}
	public void removeByStorageOrBatchNo(PullStorageProDetail entity) {
		pullStorageDetailDao.removeObject(".deleteByStorageOrBatchNo",entity);
	}
	public PullStorageDetail getPullStorageDetail(PullStorageDetail entity) {
		PullStorageDetail d=pullStorageDetailDao.getObject(".selectPullStorageDetail",entity);
		return d;
	}
}
