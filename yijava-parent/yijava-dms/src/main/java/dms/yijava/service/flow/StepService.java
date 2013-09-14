package dms.yijava.service.flow;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.flow.StepDao;
import dms.yijava.entity.flow.Action;
import dms.yijava.entity.flow.Step;


@Service
@Transactional
public class StepService {

	@Autowired
	private StepDao stepDao;
	
	
	/**
	 * 根据流程id得到所有步骤
	 * @param flow_id
	 * @return
	 */
	public List<Step>  getStepByFlow(String flow_id)
	{
		Map<String ,String > map=new HashMap<String,String>();
		map.put("flow_id", flow_id);
		return stepDao.find(map);
	}
	
	public Step getEntity(String id) {
		return stepDao.get(id);
	}

	public void saveEntity(Step entity) {
		stepDao.insert(entity);
	}

	public void updateEntity(Step entity) {
		stepDao.update(entity);
	}

	public void removeEntity(Step entity) {
		stepDao.remove(entity);
	}
}
