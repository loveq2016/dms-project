package dms.yijava.service.movestorage;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.movestorage.MoveStorageProDetailDao;
import dms.yijava.entity.movestorage.MoveStorageProDetail;
@Service
@Transactional
public class MoveStorageProDetailService{
	@Autowired
	private MoveStorageProDetailDao moveStorageProDetailDao;
	
	public JsonPage<MoveStorageProDetail> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return moveStorageProDetailDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	public List<MoveStorageProDetail> getList(List<PropertyFilter> filters){
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return moveStorageProDetailDao.find(parameters);
	}
	public MoveStorageProDetail getEntity(String id) {
		return moveStorageProDetailDao.get(id);
	}
	public void saveEntity(List<MoveStorageProDetail> list) {
		moveStorageProDetailDao.insert(list);
	}
	public void removeByIdEntity(String id) {
		moveStorageProDetailDao.removeById(id);
	}
	public void removeByMoveStorageCode(String move_storage_code) {
		moveStorageProDetailDao.removeObject(".deleteByMoveStorageCode",move_storage_code);
	}
	public void removeByMoveStorageDetailId(String fk_move_storage_detail_id) {
		moveStorageProDetailDao.removeObject(".deleteByFullStorageDetailId",fk_move_storage_detail_id);
	}
	/**
	 * move_storage_code
	 * batch_no
	 * fk_move_storage_id
	 * fk_move_to_storage_id
	 * pr sn
	 * @param entity
	 * @return
	 */
	public MoveStorageProDetail getMoveStorageProDetail(MoveStorageProDetail entity) {
		MoveStorageProDetail d=moveStorageProDetailDao.getObject(".selectMoveStorageProDetail",entity);
		return d;
	}
}
