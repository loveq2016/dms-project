package dms.yijava.service.system;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.system.SysRoleFunctionDao;
import dms.yijava.entity.system.SysMenu;
import dms.yijava.entity.system.SysRoleFunction;
@Service
@Transactional
public class SysRoleFunctionService {
	@Autowired
	public SysRoleFunctionDao sysRoleFunctionDao;
	
	public List<SysRoleFunction> getList(String role_id){
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("fk_role_id", role_id);
		return sysRoleFunctionDao.find(parameters);
	}
}
