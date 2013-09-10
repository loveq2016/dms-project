package dms.yijava.service.system;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.system.SysMenuDao;
import dms.yijava.entity.system.SysMenu;
import dms.yijava.entity.system.SysMenuFunction;
import dms.yijava.entity.system.SysRoleFunction;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.system.SysUserRole;
@Service
@Transactional
public class SysMenuService {
	@Autowired
	public SysMenuDao sysMenuDao;
	@Autowired
	public SysMenuFunctionService sysMenuFunctionService;
	
	@Autowired
	public SysRoleFunctionService sysRoleFunctionService;
	/**
	 * 返回菜单，以及菜单功能
	 * @param parent_id
	 * @return
	 */
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
	/**
	 * 返回菜单，以及绝对对应的功能。
	 * @param parent_id
	 * @param role_id
	 * @return
	 */
	public List<SysMenu> getAuthorizList(String parent_id,String role_id){
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("fk_parent_id", parent_id);
		List<SysMenu> sysMenuList=sysMenuDao.find(parameters); //菜单
		List<SysRoleFunction> sysRoleFunList=sysRoleFunctionService.getList(role_id); //角色对应的功能
		for (Object obj : sysMenuList) {
			SysMenu sysMenu=(SysMenu)obj;
			if(sysMenu.getState().equals("open")){
				List sysMenuFunctionList=sysMenuFunctionService.getList(sysMenu.getId()); //菜单对应的功能
				for (Object obj2 : sysMenuFunctionList){
					SysMenuFunction sysMenFunction=(SysMenuFunction)obj2;
					for (Object obj3 : sysRoleFunList) {
						SysRoleFunction sysroleFunction=(SysRoleFunction)obj3;
						if(sysMenFunction.getId().equals(sysroleFunction.getFk_fun_id())){
							sysMenFunction.setCheckbox(true);
						}
					}
				}
				sysMenu.setList(sysMenuFunctionList);
			}
		}
		return sysMenuList;
	}
	
	public void saveEntity(SysMenu entity) {
		sysMenuDao.insert(entity);
	}
	
	public void updateEntity(SysMenu entity) {
		sysMenuDao.update(entity);
	}
}
