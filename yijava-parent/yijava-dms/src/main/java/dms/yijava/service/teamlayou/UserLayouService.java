package dms.yijava.service.teamlayou;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.teamlayou.UserLayouDao;
import dms.yijava.entity.teamlayou.UserLayou;

@Service
@Transactional
public class UserLayouService {

	@Autowired
	private UserLayouDao  userLayouDao ;
	
	public List<UserLayou> getList(){
		HashMap<String,String> parameters = new HashMap<String,String>();
		return userLayouDao.find(parameters);
	}
	public UserLayou getEntity(String id) {
		return userLayouDao.get(id);
	}
	public void saveEntity(UserLayou entity) {
		userLayouDao.insert(entity);
	}	
	public void updateEntity(UserLayou entity) {
		userLayouDao.update(entity);
	}
	public void deleteEntity(String id) {
		userLayouDao.removeById(id);
	}
	public void deleteByTeamId(String id) {
		userLayouDao.removeObject(".deleteByTeamId",id);
	}
}
