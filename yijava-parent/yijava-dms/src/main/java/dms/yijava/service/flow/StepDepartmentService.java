package dms.yijava.service.flow;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.flow.StepDepartmentDao;
import dms.yijava.entity.flow.StepDepartment;

@Service
@Transactional
public class StepDepartmentService {

	@Autowired
	private StepDepartmentDao stepDepartmentDao;
	
	
	/**
	 * 根据步骤id得到步骤的处理部门
	 * @param flow_id
	 * @return
	 */
	public List<StepDepartment>  getStepDepartmentByStep(String step_id)
	{
		Map<String ,String > map=new HashMap<String,String>();
		map.put("step_id", step_id);
		return stepDepartmentDao.find(map);
	}
	
	//得到部门处理人
	public StepDepartment getEntity(String id) {
		return stepDepartmentDao.get(id);
	}

	//保存节点处理部门
	public void saveEntity(StepDepartment entity) {
		stepDepartmentDao.insert(entity);
	}
	//修改节点处理部门
	public void updateEntity(StepDepartment entity) {
		stepDepartmentDao.update(entity);
	}
	//删除节点处理部门
	public void removeEntity(StepDepartment entity) {
		stepDepartmentDao.remove(entity);
	}
	
	 
}
