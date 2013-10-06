package dms.yijava.service.teamlayou;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.teamlayou.TeamLayouDao;
import dms.yijava.entity.teamlayou.TeamLayou;

@Service
@Transactional
public class TeamLayouService {

	@Autowired
	private TeamLayouDao  teamLayouDao ;
	@Autowired
	private UserLayouService  userLayouService ;
	
	public List<TeamLayou> getList(String id){
		HashMap<String, String> parameters = new HashMap<String, String>();
		parameters.put("parent_id", id);
		return teamLayouDao.find(parameters);
	}
	public TeamLayou getEntity(String id) {
		return teamLayouDao.get(id);
	}
	public void saveEntity(TeamLayou entity) {
		teamLayouDao.insert(entity);
	}	
	public void updateEntity(TeamLayou entity) {
		teamLayouDao.update( entity);
	}
	public void deleteEntity(String id) {
		teamLayouDao.removeById(id);
		userLayouService.deleteByTeamId(id);
	}
}
