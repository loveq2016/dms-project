package dms.yijava.api.web.system;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import dms.yijava.entity.system.SysUser;
import dms.yijava.service.system.SysMenuFunctionService;
@Controller
@RequestMapping("/api/fun")
public class SysFunctionController {
	@Autowired
	public SysMenuFunctionService sysMenuFunctionService;
	
}
