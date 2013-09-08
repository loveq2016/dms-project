package dms.yijava.api.web.system;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.web.vo.Result;

import dms.yijava.entity.system.SysUser;
import dms.yijava.service.system.SysLoginService;
import dms.yijava.service.system.SysMenuFunctionService;
import dms.yijava.service.system.SysMenuService;
import dms.yijava.service.system.SysRoleFunctionService;
import dms.yijava.service.system.SysRoleService;
import dms.yijava.service.system.SysUserService;

@Controller
@RequestMapping("/api/sys")
public class SysLoginController {
	@Autowired
	public SysUserService sysUserService;
	@Autowired
	public SysRoleService sysRoleService;
	@Autowired
	public SysLoginService sysLoginService;
	@Autowired
	public SysMenuService sysMenuService;
	@Autowired
	public SysMenuFunctionService sysMenuFunctionService;
	@Autowired
	public SysRoleFunctionService sysRoleFunctionService;
	
	@ResponseBody
	@RequestMapping(value = "/login")
	public Result<String> index(HttpServletRequest request,HttpServletResponse response,ModelMap map) {
		String account = request.getParameter("account");
		String password = request.getParameter("password");
		if(null!=account && null!=password){
			SysUser sysUser=new SysUser();
			sysUser.setAccount(account);
			sysUser = sysUserService.getEntityByAccount(sysUser);
			if(sysUser.getPassword().equals(password))
				return new Result<String>("succeess", 1);
		}
			return new Result<String>("failed", 2);
	}
	
}