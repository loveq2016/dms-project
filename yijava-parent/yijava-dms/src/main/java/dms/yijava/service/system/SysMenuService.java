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

import dms.yijava.dao.system.SysMenuDao;
import dms.yijava.entity.product.ProductCategory;
import dms.yijava.entity.system.SysMenu;
@Service
@Transactional
public class SysMenuService {
	@Autowired
	public SysMenuDao sysMenuDao;
	
	public List<SysMenu> getList(String parent_id){
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("fk_parent_id", parent_id);
		return sysMenuDao.find(parameters);
	}
}
