package dms.yijava.service.system;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.system.SysLoginDao;
import dms.yijava.entity.system.SysLogin;
@Service
@Transactional
public class SysLoginService {
	@Autowired
	public SysLoginDao sysLoginDao;
		
	public List<SysLogin> getRoleMenuFunList(String role_id){
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("fk_role_id", role_id);
		return sysLoginDao.find(parameters);
	}
}
