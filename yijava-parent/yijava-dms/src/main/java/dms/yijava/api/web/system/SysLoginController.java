package dms.yijava.api.web.system;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.web.vo.Result;

import dms.yijava.entity.system.SysLogin;
import dms.yijava.entity.system.SysMenuFunction;
import dms.yijava.entity.system.SysRole;
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
		if(StringUtils.isNotEmpty(account) && 
				StringUtils.isNotEmpty(password)){
			SysUser sysUser=new SysUser();
			sysUser.setAccount(account);
			sysUser = sysUserService.getEntityByAccount(sysUser);
			if(isExsitUser(sysUser,password)){
				request.getSession().setAttribute("user", sysUser);
				List<SysLogin> list= sysLoginService.getRoleMenuFunList(sysUser.getFk_role_id());
				List<SysMenuFunction> list2=sysMenuFunctionService.getAllList();
				request.getSession().setAttribute("roleFunctionList", list);
				request.getSession().setAttribute("allFunctionList", list2);
				return new Result<String>("succeess", 1);
			}
		}
			return new Result<String>("failed", 1);
	}
	
	private boolean isExsitUser(SysUser user,String password) {
		if (user != null && !"".equals(user)) {
			if (user.getPassword().equals(password)) {
				return true;
			} else {
				return false;
			}
		}
		return false;
	}
}