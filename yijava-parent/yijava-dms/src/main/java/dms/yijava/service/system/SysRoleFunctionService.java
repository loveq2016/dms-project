package dms.yijava.service.system;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.system.SysRoleFunctionDao;
import dms.yijava.entity.system.SysRoleFunction;
@Service
@Transactional
public class SysRoleFunctionService {
	@Autowired
	public SysRoleFunctionDao sysRoleFunctionDao;
	/**
	 * 查询角色权限
	 * @param role_id
	 * @return
	 */
	public List<SysRoleFunction> getList(String role_id){
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("fk_role_id", role_id);
		return sysRoleFunctionDao.find(parameters);
	}
	/**
	 * 删除角色权限
	 * @param role_id
	 */
	public void deleteFunByRoleid(String role_id){
			sysRoleFunctionDao.removeById(role_id);
	}
	/**
	 * 添加角色权限
	 * @param roleid
	 * @param checkBox
	 */
	public void insert(String roleid, String[] checkBox) {
		deleteFunByRoleid(roleid); //删除角色对应权限
		List<SysRoleFunction> list=new ArrayList<SysRoleFunction>();
		for(int i=0;i<checkBox.length;i++){
			SysRoleFunction sysRF=new SysRoleFunction();
			sysRF.setFk_fun_id(checkBox[i]);
			sysRF.setFk_role_id(roleid);
			list.add(sysRF);
		}
		sysRoleFunctionDao.insert(list); //添加角色权限
	}
}
