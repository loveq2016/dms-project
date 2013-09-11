package dms.yijava.service.storage;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.storage.StorageCategoryDao;
import dms.yijava.entity.storage.StorageCategory;

@Service
@Transactional
public class StorageCategoryService {

	@Autowired
	private StorageCategoryDao  storageCategoryDao ;
	
	public List<StorageCategory> getList(){
		HashMap<String,String> parameters = new HashMap<String,String>();
		return storageCategoryDao.find(parameters);
	}
}
