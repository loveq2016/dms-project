package dms.yijava.service.user;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.user.UserOrganizationDao;
import dms.yijava.entity.user.UserOrganization;

@Service
@Transactional
public class UserOrganizationService {

	@Autowired
	private UserOrganizationDao userOrganizationDao;

	public List<UserOrganization> getList(String parent_id) {
		HashMap<String, String> parameters = new HashMap<String, String>();
		parameters.put("parent_id", parent_id);
		return userOrganizationDao.find(parameters);
	}

}
