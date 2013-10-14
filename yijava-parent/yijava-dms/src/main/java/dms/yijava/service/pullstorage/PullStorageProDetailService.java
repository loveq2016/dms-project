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

import dms.yijava.dao.pullstorage.PullStorageProDetailDao;
import dms.yijava.entity.pullstorage.PullStorageDetail;
import dms.yijava.entity.pullstorage.PullStorageProDetail;
import dms.yijava.entity.system.SysRoleFunction;
@Service
@Transactional
public class PullStorageProDetailService{
	@Autowired
	private PullStorageProDetailDao pullStorageProDetailDao;
	
	public JsonPage<PullStorageProDetail> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return pullStorageProDetailDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	public List<PullStorageProDetail> getList(List<PropertyFilter> filters){
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return pullStorageProDetailDao.find(parameters);
	}
	public PullStorageProDetail getEntity(String id) {
		return pullStorageProDetailDao.get(id);
	}
	public void saveEntity(List<PullStorageProDetail> list) {
		pullStorageProDetailDao.insert(list);
	}
	public void removeByIdEntity(String id) {
		pullStorageProDetailDao.removeById(id);
	}
	public void removeByPullStorageCode(String pull_storage_code) {
		pullStorageProDetailDao.removeObject(".deleteByPullStorageCode",pull_storage_code);
	}
	public void removeByFullStorageDetailId(String fk_pull_storage_detail_id) {
		pullStorageProDetailDao.removeObject(".deleteByFullStorageDetailId",fk_pull_storage_detail_id);
	}
	/**
	 * pull_storage_code
	 * batch_no
	 * fk_storage_id
	 * @param entity
	 * @return
	 */
	public List<PullStorageProDetail> getPullStorageProDetail(PullStorageProDetail entity) {
		entity.setBatch_nos(entity.getBatch_nos()[0].split(","));
		entity.setProduct_sns(entity.getProduct_sns()[0].split(","));
		List<PullStorageProDetail> d=pullStorageProDetailDao.getObject(".selectPullStorageProDetail",entity);
		return d;
	}
}
