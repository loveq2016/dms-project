package dms.yijava.service.movestorage;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.movestorage.MoveStorageDao;
import dms.yijava.entity.movestorage.MoveStorage;
import dms.yijava.entity.pullstorage.PullStorage;
@Service
@Transactional
public class MoveStorageService{
	@Autowired
	private MoveStorageDao moveStorageDao;
	@Autowired
	private MoveStorageDetailService moveStorageDetailService;
	public JsonPage<MoveStorage> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		try{
			for (PropertyFilter propertyFilter : filters) {
				String propertyKey = propertyFilter.getPropertyNames()[0];
				String propertyValue = propertyFilter.getMatchValue();
				String hhmmss="";
				if(propertyKey.equals("move_start_date") || propertyKey.equals("move_end_date")){
					if(propertyKey.equals("move_start_date")&&!"".equals(propertyValue))
						hhmmss=" 00:00:00";
					if(propertyKey.equals("move_end_date")&&!"".equals(propertyValue))
						hhmmss=" 23:59:59";
					propertyValue=propertyValue + hhmmss;
				}
				parameters.put(propertyKey, propertyValue);
			}
		}catch(Exception ex){}
		return moveStorageDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	public List<MoveStorage> getList(List<PropertyFilter> filters){
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return moveStorageDao.find(parameters);
	}
	public MoveStorage getEntity(String id) {
		return moveStorageDao.get(id);
	}
	public void saveEntity(MoveStorage entity) {
		moveStorageDao.insert(entity);
	}
	public void updateEntity(MoveStorage entity) {
		moveStorageDao.update(entity);
	}
	public void updateStatus(String id,String status){
		MoveStorage entity=new MoveStorage();
		entity.setId(id);
		entity.setStatus(status);
		moveStorageDao.updateObject(".updateStatus", entity);
	}
	public void removeByMoveStorageCode(String move_storage_code) {
		moveStorageDetailService.removeByMoveStorageCode(move_storage_code);
		moveStorageDao.removeObject(".deleteByMoveStorageCode",move_storage_code);
	}
	public MoveStorage getStorageDetailTotalNumber(String move_storage_code) {
		MoveStorage moveStorage=moveStorageDao.getObject(".selectStorageDetailTotalNumber",move_storage_code);
		return moveStorage;
	}
	public MoveStorage getMoveStorageCode(String move_storage_party_id) {
		MoveStorage moveStorage=moveStorageDao.getObject(".selectMoveStorageCode",move_storage_party_id);
		if(null==moveStorage || StringUtils.isEmpty(moveStorage.getMove_storage_no())){
			moveStorage=new MoveStorage();
			moveStorage.setMove_storage_no("001");
		}
		return moveStorage;
	}
}
