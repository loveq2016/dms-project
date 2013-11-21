package dms.yijava.service.teamlayou;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.teamlayou.UserLayouDao;
import dms.yijava.entity.teamlayou.UserLayou;
import dms.yijava.entity.user.UserDealer;

@Service
@Transactional
public class UserLayouService {

	@Autowired
	private UserLayouDao  userLayouDao ;
	
	public List<UserLayou> getList(){
		HashMap<String,String> parameters = new HashMap<String,String>();
		return userLayouDao.find(parameters);
	}
	public List<String> getUserListById(String user_id,String [] sourceIds){
		HashMap<String,Object> parameters = new HashMap<String,Object>();
		parameters.put("user_id", user_id);
		parameters.put("sourceIds", sourceIds);
		return userLayouDao.find(".selectUserListById",parameters);
	}
	public UserLayou getTeamIdsByUserId(String user_id){
		UserLayou userLayou = userLayouDao.getObject(".selectTeamIdsByUserId", user_id);
		return userLayou;
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
	
	public void deleteByUserId(String id) {
		userLayouDao.removeObject(".deleteByUserId",id);
	}
	
	/**
	 * 根据用户所在的节点，找到用户的所有上级用户id
	 * 
	 * @param team
	 * @return
	 */
	public List<UserLayou> getParentByUserId(String team)
	{
		return userLayouDao.find(".selectParentIdsByUserId", team);
	}
}
