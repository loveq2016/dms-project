package dms.yijava.api.web.storage;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;

import dms.yijava.entity.storage.StorageDetail;
import dms.yijava.service.storage.StorageDetailService;

@Controller
@RequestMapping("/api/storageDetail")
public class StorageDetailController {

	@Autowired
	private StorageDetailService storageDetailService;

	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<StorageDetail> paging(PageRequest pageRequest,
			HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return storageDetailService.paging(pageRequest, filters);
	}
	
	
	
	
	

}
