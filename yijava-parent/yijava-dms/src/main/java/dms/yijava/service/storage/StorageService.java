package dms.yijava.service.storage;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.storage.StorageDao;
import dms.yijava.entity.storage.Storage;

@Service
@Transactional
public class StorageService {

	@Autowired
	private StorageDao  storageDao ;
	
	
	public List<Storage> getList(){
		HashMap<String,String> parameters = new HashMap<String,String>();
		return storageDao.find(parameters);
	}
		
}
