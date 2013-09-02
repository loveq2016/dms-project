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
import dms.yijava.entity.product.Product;
import dms.yijava.entity.product.ProductCategory;
import dms.yijava.entity.system.SysUser;

@Service
@Transactional
public class SysUserService {
	@Autowired
	public SysUserDao sysUserDao;
	
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
	public SysUser getEntity(String id) {
		return sysUserDao.get(id);
	}
	
	public void saveEntity(SysUser entity) {
		sysUserDao.insert(entity);
	}
	
	public void updateEntity(SysUser entity) {
		sysUserDao.update(entity);
	}
	public void deleteEntity(String id) {
		sysUserDao.removeById(id);
	}
}
