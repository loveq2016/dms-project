package dms.yijava.api.web.storage;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import dms.yijava.entity.storage.Storage;
import dms.yijava.service.storage.StorageService;

@Controller
@RequestMapping("/api/storage")
public class StorageController {
	

	@Autowired
	private StorageService storageService;
	
	@ResponseBody
	@RequestMapping("list")
	public List<Storage> list() {
		return storageService.getList();
	}
	
}
