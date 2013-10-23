package dms.yijava.service.storage;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.storage.StorageDao;
import dms.yijava.entity.dealer.DealerStorage;
import dms.yijava.entity.hospital.Hospital;
import dms.yijava.entity.storage.Storage;
import dms.yijava.service.dealer.DealerStorageService;

@Service
@Transactional
public class StorageService {

	@Autowired
	private StorageDao  storageDao ;
	
	@Autowired
	private DealerStorageService dealerStorageService;
	
	public List<Storage> getList(String id){
		HashMap<String,String> parameters = new HashMap<String,String>();
		if(StringUtils.isNotEmpty(id))
			parameters.put("dealer_id", id);
		return storageDao.find(parameters);
	}
		
	public JsonPage<Storage> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return storageDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}

	public Storage getEntity(String id) {
		return storageDao.get(id);
	}
	
	public void saveEntity(Storage entity) {
		try {
			storageDao.insert(entity);
			DealerStorage entity2=new DealerStorage();
			entity2.setDealer_id(entity.getDealer_id());
			entity2.setStorage_id(entity.getId());
			dealerStorageService.saveEntity(entity2);//添加经销商关系
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void updateEntity(Storage entity) {
		try {
			storageDao.update(entity);
			DealerStorage entity2=new DealerStorage();
			entity2.setDealer_id(entity.getDealer_id());
			entity2.setStorage_id(entity.getId());
			dealerStorageService.updateEntity(entity2);//修改经销商关系
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public void deleteEntity(String id) {
		Storage s=storageDao.get(id);
		DealerStorage entity2=new DealerStorage();
		entity2.setDealer_id(s.getDealer_id());
		entity2.setStorage_id(s.getId());
		dealerStorageService.deleteEntity(entity2);//删除经销商关系
		storageDao.removeById(id);
	}
}
