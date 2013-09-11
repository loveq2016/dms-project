package dms.yijava.api.web.storage;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import dms.yijava.entity.storage.StorageCategory;
import dms.yijava.service.storage.StorageCategoryService;

@Controller
@RequestMapping("/api/storageCategory")
public class StorageCategoryController {
	

	@Autowired
	private StorageCategoryService storageCategoryService;
	
	@ResponseBody
	@RequestMapping("list")
	public List<StorageCategory> list() {
		return storageCategoryService.getList();
	}
	
}
