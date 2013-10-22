package dms.yijava.web.system;

import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import dms.yijava.entity.key.LoginKeyGen;
import dms.yijava.entity.system.SysUser;
import dms.yijava.service.key.LoginKeyGenService;

@Controller
@RequestMapping("/web/keyop")
public class KeyLoginController {

	@Autowired
	private LoginKeyGenService loginKeyGenService;
	
	
	
	@RequestMapping(value = "/reqlogin")
	//@ResponseBody
	public String reqlogin(HttpServletRequest request,HttpServletResponse response,Model model) {
		LoginKeyGen entity=new LoginKeyGen();
		
		  UUID uuid = UUID.randomUUID();  
	        String str = uuid.toString();  
	        // 去掉"-"符号  
	        String temp = str.substring(0, 8) + str.substring(9, 13) + str.substring(14, 18) + str.substring(19, 23) + str.substring(24);  
	        
		entity.setKeygen(temp);
		loginKeyGenService.saveEntity(entity);
		return "autologin";
	}
	
	
	@RequestMapping(value = "/login")
	public String login(HttpServletRequest request,HttpServletResponse response,Model model) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		model.addAttribute("sysUser", sysUser);
		return "system/user/setting";
	}
}
