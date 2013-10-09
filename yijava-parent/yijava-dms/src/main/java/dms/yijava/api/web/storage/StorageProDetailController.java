package dms.yijava.api.web.storage;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;

import dms.yijava.entity.storage.StorageProDetail;
import dms.yijava.entity.system.SysUser;
import dms.yijava.service.storage.StorageProDetailService;

@Controller
@RequestMapping("/api/storageProDetail")
public class StorageProDetailController {

	@Autowired
	private StorageProDetailService storageProDetailService;

	public List<StorageProDetail> getList(HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		//HashMap<String,String> parameters = new HashMap<String,String>();
		return storageProDetailService.getList(filters);
	}
	
	
	
	@ResponseBody
	@RequestMapping("api_paging")
	public JsonPage<StorageProDetail> api_paging(PageRequest pageRequest,
			HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		SysUser sysUser = (SysUser) request.getSession().getAttribute("user");
		if(!StringUtils.equals("0",sysUser.getFk_dealer_id())){
			filters.add(PropertyFilters.build("ANDS_fk_dealer_id",sysUser.getFk_dealer_id()));
		}
		return storageProDetailService.paging(pageRequest, filters);
	}
	
	
	

}
