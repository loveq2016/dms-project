package dms.yijava.api.web.storage;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;

import dms.yijava.entity.storage.StorageProDetail;
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
	

}
