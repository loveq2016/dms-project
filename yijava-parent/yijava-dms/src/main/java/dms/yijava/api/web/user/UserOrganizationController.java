package dms.yijava.api.web.user;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import dms.yijava.entity.user.UserOrganization;
import dms.yijava.service.user.UserOrganizationService;

@Controller
@RequestMapping("/api/userOrganization")
public class UserOrganizationController {

	@Autowired
	private UserOrganizationService userOrganizationService;
	

	@ResponseBody
	@RequestMapping("list")
	public List<UserOrganization> list(@RequestParam(value = "id", required = false) String id) {
		id = StringUtils.isBlank(id) == true ? "-1" : id;
		List<UserOrganization> list = userOrganizationService.getList(id);
		for (UserOrganization userOrganization : list) {
			Map<String,String> attributes = new HashMap<String,String>();
			attributes.put("parent_id", userOrganization.getParent_id());
			userOrganization.setAttributes(attributes);
		}
		return list;
	}
	
	
	
}
