package dms.yijava.service.hospital;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.hospital.HospitalDao;
import dms.yijava.entity.hospital.Hospital;


@Service
@Transactional
public class HospitalService {

	@Autowired
	private HospitalDao  hospitalDao ;
	
	
	public List<Hospital> getList(){
		HashMap<String,String> parameters = new HashMap<String,String>();
		return hospitalDao.find(parameters);
	}
	
	
	public JsonPage<Hospital> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return hospitalDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}

	public Hospital getEntity(String id) {
		return hospitalDao.get(id);
	}
	
	public Hospital getEntityByName(String name) {
		return hospitalDao.getObject(".selectByName", name);
	}
	
	public void saveEntity(Hospital entity) {
		try {
			hospitalDao.insert(entity);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	public void updateEntity(Hospital entity) {
		try {
			hospitalDao.update( entity);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	public void deleteEntity(String id) {
		hospitalDao.remove(id);
	}
	
	public List<String> findAllProvincd()
	{
		return hospitalDao.findNoParamer(".selectAllProvince");
	}
		
}
