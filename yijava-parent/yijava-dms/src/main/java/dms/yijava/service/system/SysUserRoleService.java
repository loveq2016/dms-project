package dms.yijava.service.system;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.system.SysUserRoleDao;
import dms.yijava.entity.system.SysUserRole;

@Service
@Transactional
public class SysUserRoleService {
	@Autowired
	public SysUserRoleDao sysUserRoleDao;
	/**
	 * 保存用户角色关系
	 * @param entity
	 */
	public void saveEntity(SysUserRole entity) {
		sysUserRoleDao.insert(entity);
	}
	public void delEntity(String id) {
		sysUserRoleDao.removeById(id);
	}
}
