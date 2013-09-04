package dms.yijava.service.system;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.system.SysMenuFunctionDao;
import dms.yijava.entity.system.SysMenu;
import dms.yijava.entity.system.SysMenuFunction;
@Service
@Transactional
public class SysMenuFunctionService {
	@Autowired
	public SysMenuFunctionDao sysMenuFunctionDao;
	
	public List<SysMenuFunction> getList(String menu_id){
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("fk_menu_id", menu_id);
		return sysMenuFunctionDao.find(parameters);
	}
}
