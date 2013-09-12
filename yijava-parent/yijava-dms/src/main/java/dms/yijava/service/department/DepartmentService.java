package dms.yijava.service.department;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.department.DepartmentDao;
import dms.yijava.entity.department.Department;

@Service
@Transactional
public class DepartmentService {

	@Autowired
	private DepartmentDao  departmentDao ;
	
	public List<Department> getList(){
		HashMap<String,String> parameters = new HashMap<String,String>();
		return departmentDao.find(parameters);
	}
	public List<Department> getList(String id){
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("fk_parent_id", id);
		return departmentDao.find(parameters);
	}
	public Department getEntity(String id) {
		return departmentDao.get(id);
	}
	public void saveEntity(Department entity) {
		departmentDao.insert(entity);
	}	
	public void updateEntity(Department entity) {
		departmentDao.update( entity);
	}
	public void deleteEntity(String id) {
		departmentDao.removeById(id);
	}
}
