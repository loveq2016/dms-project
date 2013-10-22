package dms.yijava.service.system;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.system.SysUserDao;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.system.SysUserRole;

@Service
@Transactional
public class SysUserService {
	@Autowired
	public SysUserDao sysUserDao;
	@Autowired
	public SysUserRoleService sysUserRoleService;
	/**
	 * 查询用户分页
	 * @param pageRequest
	 * @param filters
	 * @return
	 */
	public JsonPage<SysUser> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return sysUserDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	/**
	 * 查询用户
	 * @param id
	 * @return
	 */
	public SysUser getEntity(String id) {
		return sysUserDao.get(id);
	}
	
	public SysUser getEntityByAccount(SysUser entity) {
		return sysUserDao.getObject(".selectByAccount",entity);
	}
	
	/**
	 * 保存用户
	 * @param entity
	 */
	public void saveEntity(SysUser entity) {
		sysUserDao.insert(entity);
		SysUserRole sysUserRole=new SysUserRole();
		sysUserRole.setFk_role_id(entity.getFk_role_id());
		sysUserRole.setFk_user_id(entity.getId());
		sysUserRoleService.saveEntity(sysUserRole);
	}
	/**
	 * 修改用户
	 * @param entity
	 */
	public void updateEntity(SysUser entity) {
		sysUserDao.update(entity);
		SysUserRole sysUserRole=new SysUserRole();
		sysUserRole.setFk_role_id(entity.getFk_role_id());
		sysUserRole.setFk_user_id(entity.getId());
		sysUserRoleService.delEntity(entity.getId());
		sysUserRoleService.saveEntity(sysUserRole);
	}
	/**
	 * 删除用户
	 * @param id
	 */
	public void deleteEntity(String id) {
		sysUserRoleService.delEntity(id);
		sysUserDao.removeById(id);
	}
	
	/**
	 * 查询用户信息根据部门ID
	 * @return
	 */
	public List<SysUser> getListByDepartmentId(String id){
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("fk_department_id", id);
		return sysUserDao.find(parameters);
	}
	/**
	 * 查询所有用户
	 * @return
	 */
	public List<SysUser> getUserList(){
		return sysUserDao.find(".selectUserList",null);
	}
	
	/**
	 * 修改密码
	 */
	public void updateUserPassword(SysUser entity)
	{
		sysUserDao.update(entity);
	}
	
	public void updateUserInfo(SysUser entity)
	{
		sysUserDao.update(entity);
	}
}
