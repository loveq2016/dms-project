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

import dms.yijava.dao.flow.FlowRecordDao;
import dms.yijava.entity.flow.Flow;
import dms.yijava.entity.flow.FlowRecord;
import dms.yijava.entity.system.SysRoleFunction;


@Service
@Transactional
public class FlowRecordService {

	@Autowired
	private FlowRecordDao flowRecordDao;
	
	public List<FlowRecord> getList(String bussiness_id){
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("bussiness_id", bussiness_id);
		return flowRecordDao.find(parameters);
	}

	public FlowRecord getEntity(String id) {
		return flowRecordDao.get(id);
	}
	
	public void saveEntity(FlowRecord entity) {
		flowRecordDao.insert(entity);
	}
	
	public void updateEntity(FlowRecord entity) {
		flowRecordDao.update(entity);
	}
	
	public void removeEntity(FlowRecord entity) {
		flowRecordDao.remove( entity);
	}
}
