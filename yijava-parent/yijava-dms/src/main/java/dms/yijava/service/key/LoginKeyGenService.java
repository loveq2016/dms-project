package dms.yijava.service.key;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.key.LoginKeyGenDao;
import dms.yijava.entity.key.LoginKeyGen;

@Service
@Transactional
public class LoginKeyGenService {

	@Autowired
	private LoginKeyGenDao loginKeyGenDao;
	
	

	public LoginKeyGen getEntity(String id) {
		return loginKeyGenDao.get(id);
	}
	
	public void saveEntity(LoginKeyGen entity) {
		loginKeyGenDao.insert(entity);
	}
	
	
	
	
	public List<LoginKeyGen>  getKeyGen(String keygen)
	{			
		return loginKeyGenDao.find(".selectByKeyGen", keygen);		
	}
	
	
	public void removeEntityById(String id) {
		loginKeyGenDao.removeById( id);
	}
}
