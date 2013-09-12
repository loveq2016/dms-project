package dms.yijava.service.user;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.user.UserHospitalFunDao;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.entity.user.UserHospital;

@Service
@Transactional
public class UserHospitalFunService {

	@Autowired
	private UserHospitalFunDao userHospitalFunDao;

	public JsonPage<UserHospital> paging(PageRequest pageRequest,
			List<PropertyFilter> filters) {
		Map<String, String> parameters = new HashMap<String, String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		String parent_id = parameters.get("parent_id");
		Set<String> userSet = new HashSet<String>();
		userSet.add(parameters.get("user_id"));
		userSet = getUserIds(userSet, parent_id);
		String uid = "";
		for (String userKey : userSet) {
			uid += userKey + ",";
		}
		uid = uid.substring(0, uid.length() - 1);
		parameters.put("user_ids", uid);
		return userHospitalFunDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
	
	private Set<String> getUserIds(Set<String> userSet,String parent_id){
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("parent_id", parent_id);
		List<UserHospital> temList = userHospitalFunDao.find(parameters);
		for (UserHospital userDealer : temList) {
			userSet.add(userDealer.getUser_id());
			getUserIds(userSet,userDealer.getDepartment_id());
		}
		return userSet;
	}
	


	
	
}
