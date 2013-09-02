package dms.yijava.api.web.system;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import dms.yijava.service.system.SysMenuService;

@Controller
@RequestMapping("/sys/sysmenu")
public class SysMenuController {
	@Autowired
	public SysMenuService sysMenuService;
}
