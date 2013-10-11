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

import dms.yijava.dao.movestorage.MoveStorageDetailDao;
import dms.yijava.entity.movestorage.MoveStorageDetail;
import dms.yijava.entity.pullstorage.PullStorageDetail;
@Service
@Transactional
public class MoveStorageDetailService{

	@Autowired
	private MoveStorageDetailDao moveStorageDetailDao;
	@Autowired
	private MoveStorageDetailService moveStorageDetailService;
	@Autowired
	private MoveStorageProDetailService moveStorageProDetailService;
	
	public JsonPage<MoveStorageDetail> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return moveStorageDetailDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	public List<MoveStorageDetail> getList(List<PropertyFilter> filters){
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return moveStorageDetailDao.find(parameters);
	}
	public MoveStorageDetail getEntity(String id) {
		return moveStorageDetailDao.get(id);
	}
	public void saveEntity(MoveStorageDetail entity) {
		moveStorageDetailDao.insert(entity);
	}
	public void updateEntity(MoveStorageDetail entity) {
		moveStorageDetailDao.update(entity);
	}
	public void removeByIdEntity(String id) {
		moveStorageProDetailService.removeByMoveStorageDetailId(id);
		moveStorageDetailDao.removeById(id);
	}
	public void removeByMoveStorageCode(String move_storage_code) {
		moveStorageProDetailService.removeByMoveStorageCode(move_storage_code);
		moveStorageDetailDao.removeObject(".deleteByMoveStorageCode",move_storage_code);
	}
	
	/**
	 * move_storage_code
	 * batch_no
	 * fk_move_storage_id
	 * fk_move_to_storage_id
	 * @param entity
	 * @return
	 */
	public MoveStorageDetail getMoveStorageDetail(MoveStorageDetail entity) {
		MoveStorageDetail d=moveStorageDetailDao.getObject(".selectMoveStorageDetail",entity);
		return d;
	}
	public MoveStorageDetail getStorageProDetailMoveNumber(String id) {
		MoveStorageDetail d=moveStorageDetailDao.getObject(".selectStorageProDetailMoveNumber",id);
		return d;
	}
}
