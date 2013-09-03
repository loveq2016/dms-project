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

import dms.yijava.dao.system.SysRoleDao;
import dms.yijava.entity.system.SysRole;
import dms.yijava.entity.system.SysUser;
@Service
@Transactional
public class SysRoleService {
	@Autowired
	public SysRoleDao sysRoleDao;
	
	public JsonPage<SysRole> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return sysRoleDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	public SysRole getEntity(String id) {
		return sysRoleDao.get(id);
	}
	
	public void saveEntity(SysRole entity) {
		sysRoleDao.insert(entity);
	}
	
	public void updateEntity(SysRole entity) {
		sysRoleDao.update(entity);
	}
	public void deleteEntity(String id) {
		sysRoleDao.removeById(id);
	}
}
