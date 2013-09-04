package dms.yijava.service.system;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.system.SysMenuDao;
import dms.yijava.dao.system.SysMenuFunctionDao;
import dms.yijava.entity.system.SysMenu;
@Service
@Transactional
public class SysMenuService {
	@Autowired
	public SysMenuDao sysMenuDao;
	@Autowired
	public SysMenuFunctionService sysMenuFunctionService;
	
	public List<SysMenu> getList(String parent_id){
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("fk_parent_id", parent_id);
		List sysMenuList=sysMenuDao.find(parameters);
		for (Object object : sysMenuList) {
			SysMenu sysMenu=(SysMenu)object;
			if(sysMenu.getState().equals("open")){
				sysMenu.setList(sysMenuFunctionService.getList(sysMenu.getId()));
			}
		}
		return sysMenuList;
	}
}
