package dms.yijava.service.system;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.system.SysLoginDao;
@Service
@Transactional
public class SysLoginService {
	@Autowired
	public SysLoginDao sysLoginDao;
	
	/*SELECT tmrf.fk_role_id as role_id,tmmf.id as fun_id,tmmf.fun_name,tmmf.fk_menu_id as menu_id,tmm.menu_name,tmm.fk_parent_id as menu_parent_id,tmms.menu_name as menu_parent_name FROM dms.tb_manager_role_fun tmrf 
		LEFT JOIN dms.tb_manager_menu_fun tmmf ON tmrf.fk_fun_id=tmmf.id  
		LEFT JOIN dms.tb_manager_menu tmm ON tmmf.fk_menu_id=tmm.id
		LEFT JOIN dms.tb_manager_menu tmms ON tmms.id=tmm.fk_parent_id
		WHERE fk_role_id ='9' ORDER BY tmm.fk_parent_id ASC*/
	
	public List<Map> getRoleMenuFunList(String role_id){
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("fk_role_id", role_id);
		return sysLoginDao.find(parameters);
	}
}
