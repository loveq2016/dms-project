package dms.yijava.service.hospital;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.hospital.HospitalLevelDao;
import dms.yijava.entity.hospital.HospitalLevel;

@Service
@Transactional
public class HospitalLevelService {

	@Autowired
	private HospitalLevelDao  hospitalLevelDao ;
	
	
	public List<HospitalLevel> getList(){
		HashMap<String,String> parameters = new HashMap<String,String>();
		return hospitalLevelDao.find(parameters);
	}
		
}
