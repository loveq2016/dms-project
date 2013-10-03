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

import dms.yijava.entity.teamlayou.TeamLayou;
import dms.yijava.service.teamlayou.TeamLayouService;

@Controller
@RequestMapping("/api/userOrganization")
public class UserOrganizationController {

	//@Autowired
	//private UserOrganizationService userOrganizationService;
	@Autowired
	private TeamLayouService teamLayouService;

	@ResponseBody
	@RequestMapping("list")
	public List<TeamLayou> list(@RequestParam(value = "id", required = false) String id) {
		id = StringUtils.isBlank(id) == true ? "-1" : id;
		List<TeamLayou> list = teamLayouService.getList(id);
		for (TeamLayou teamLayou : list) {
			Map<String,String> attributes = new HashMap<String,String>();
			attributes.put("parent_id", teamLayou.getParent_id());
			attributes.put("user_id", teamLayou.getFk_user_id());
			teamLayou.setAttributes(attributes);
		}
		return list;
	}
	
	
	
}
