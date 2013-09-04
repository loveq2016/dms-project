package dms.yijava.api.web.system;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import dms.yijava.entity.system.SysMenu;
import dms.yijava.service.system.SysMenuService;

@Controller
@RequestMapping("/api/sysmenu")
public class SysMenuController {
	@Autowired
	public SysMenuService sysMenuService;
	@ResponseBody
	@RequestMapping("list")
	public List<SysMenu> list(@RequestParam(value = "id", required = false) String id) {
		id = StringUtils.isBlank(id) == true ? "-1" : id;
		return sysMenuService.getList(id);
	}
}
