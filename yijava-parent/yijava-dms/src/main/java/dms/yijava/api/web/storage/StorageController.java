package dms.yijava.api.web.storage;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.Result;

import dms.yijava.entity.hospital.Hospital;
import dms.yijava.entity.storage.Storage;
import dms.yijava.service.hospital.HospitalService;
import dms.yijava.service.storage.StorageService;

@Controller
@RequestMapping("/api/storage")
public class StorageController {
	
	@Autowired
	private StorageService storageService;
	private HospitalService hospitalService;
	
	@ResponseBody
	@RequestMapping("list")
	public List<Storage> list(HttpServletRequest request,
			@RequestParam(value = "dealer_id", required = false) String id) {
		return storageService.getList(id);
	}
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<Storage> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return storageService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") Storage entity) {
		storageService.saveEntity(entity);
		return new Result<String>(entity.getId(), 1);
	}
	
	@ResponseBody
	@RequestMapping("update")
	public Result<String> update(@ModelAttribute("entity") Storage entity) {
		storageService.updateEntity(entity);
		return new Result<String>(entity.getId(), 1);
	}
	
	@ResponseBody
	@RequestMapping("delete")
	public Result<String> delete(@RequestParam(value = "id", required = true) String id) {
		storageService.deleteEntity(id);
		return new Result<String>(id, 1);
	}

}
