package dms.yijava.service.storage;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.storage.StorageProDetailDao;
import dms.yijava.entity.storage.StorageProDetail;

@Service
@Transactional
public class StorageProDetailService {

	@Autowired
	private StorageProDetailDao  storageProDetailDao ;

	public List<StorageProDetail> getList(List<PropertyFilter> filters) {
		//HashMap<String, String> parameters = new HashMap<String, String>();
		return storageProDetailDao.find(".selectStorageProDetail", filters);
	}
	

	

	
}
