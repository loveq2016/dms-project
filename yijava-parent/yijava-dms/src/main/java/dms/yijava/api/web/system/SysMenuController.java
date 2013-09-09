package dms.yijava.api.web.system;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.web.vo.Result;

import dms.yijava.entity.system.SysMenu;
import dms.yijava.entity.system.SysRoleFunction;
import dms.yijava.service.system.SysMenuService;
import dms.yijava.service.system.SysRoleFunctionService;

@Controller
@RequestMapping("/api/sysmenu")
public class SysMenuController {
	private static final Logger logger = LoggerFactory.getLogger(SysMenuController.class);
	@Autowired
	public SysMenuService sysMenuService;
	@Autowired
	public SysRoleFunctionService sysRoleFunctionService;
	@ResponseBody
	@RequestMapping("list")
	public List<SysMenu> list(@RequestParam(value = "id", required = false) String id) {
		id = StringUtils.isBlank(id) == true ? "-1" : id;
		logger.info("查询菜单信息");
		return sysMenuService.getList(id);
	}
	
	@ResponseBody
	@RequestMapping("authorzelist")
	public List<SysMenu> authorizList(@RequestParam(value = "id", required = false) String id,
			@RequestParam(value = "roleid", required = false) String roleid) {
		id = StringUtils.isBlank(id) == true ? "-1" : id;
		return sysMenuService.getAuthorizList(id,roleid);
	}

	@RequestMapping(value = "/goauthorze")
	public String index(HttpServletRequest request,HttpServletResponse response,ModelMap map) {
		map.put("roleid", request.getParameter("roleid"));
		logger.info("查询角色授权信息");
		return "forward:/system/role/viewdauthorize.jsp";
	}
	@ResponseBody
	@RequestMapping("/saveauthorze")
	public Result<String> saveauthorze(HttpServletRequest request,HttpServletResponse response,ModelMap map) {
		String checkBox[] = request.getParameterValues("function");
		String roleid=request.getParameter("roleid");
		logger.info("添加角色授权信息");
		sysRoleFunctionService.insert(roleid,checkBox);
		return new Result<String>("1", 1);
	}
}
