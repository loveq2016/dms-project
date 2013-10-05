package dms.yijava.web.system;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import dms.yijava.entity.system.SysUser;

@Controller
@RequestMapping("/web/user")
public class UserSettingControllser {

	
	@RequestMapping(value = "/setting")
	public String setting(HttpServletRequest request,HttpServletResponse response,Model model) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		model.addAttribute("sysUser", sysUser);
		return "system/user/setting";
	}
	
}
