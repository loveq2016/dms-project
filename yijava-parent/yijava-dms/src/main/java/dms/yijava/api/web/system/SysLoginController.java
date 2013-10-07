package dms.yijava.api.web.system;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.common.utils.EncodeUtils;
import com.yijava.web.vo.ErrorCode;
import com.yijava.web.vo.Result;

import dms.yijava.entity.system.SysLogin;
import dms.yijava.entity.system.SysMenuFunction;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.teamlayou.UserLayou;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.system.SysLoginService;
import dms.yijava.service.system.SysMenuFunctionService;
import dms.yijava.service.system.SysMenuService;
import dms.yijava.service.system.SysRoleFunctionService;
import dms.yijava.service.system.SysRoleService;
import dms.yijava.service.system.SysUserService;
import dms.yijava.service.teamlayou.UserLayouService;
import dms.yijava.service.user.UserDealerFunService;

@Controller
@RequestMapping("/api/sys")
public class SysLoginController {
	private static final Logger logger = LoggerFactory.getLogger(SysLoginController.class);
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
	@Autowired
	private UserDealerFunService userDealerFunService;
	@Autowired
	private  UserLayouService userLayouService;
	
	@ResponseBody
	@RequestMapping(value = "/login")
	public Result<Integer> index(HttpServletRequest request,HttpServletResponse response,ModelMap map) {
		Result<Integer> result=new Result<Integer>(0, 0);
		String account = request.getParameter("account");
		String password = request.getParameter("password");
		if(StringUtils.isNotEmpty(account) && 
				StringUtils.isNotEmpty(password)){
			SysUser sysUser=new SysUser();
			sysUser.setAccount(account);
			sysUser = sysUserService.getEntityByAccount(sysUser);
			try {
				password=EncodeUtils.encoderByMd5(password);
			} catch (NoSuchAlgorithmException e1) {
				result.setError(new ErrorCode(e1.toString()));
				return result;
			} catch (UnsupportedEncodingException e1) {
				result.setError(new ErrorCode(e1.toString()));
				return result;
			}
			if(isExsitUser(sysUser,password)){
				List<SysLogin> sysLoginList= sysLoginService.getRoleMenuFunList(sysUser.getFk_role_id());
				try{
					String[] teams=userLayouService.getTeamIdsByUserId(sysUser.getId()).getFk_team_id().split(",");//用户节点
					
					/**根据用户的所有节点找到所有的上级用户 */
					String parentIds="";
					for(String team:teams)
					{
						List<UserLayou> userLayouts=userLayouService.getParentByUserId(team);
						for(UserLayou userLayou:userLayouts)
						{
							parentIds+=userLayou.getFk_user_id()+",";
						}
					}
					sysUser.setParentIds(parentIds);
					/**/
					List<UserDealer> userDealerList=userDealerFunService.getUserDealerList(sysUser.getId(),teams);//节点用户
					sysUser.setUserDealerList(userDealerList);
					sysUser.setTeams(teams);
				}catch(Exception e){}
				List<SysMenuFunction> sysMenuFunctionList=sysMenuFunctionService.getAllList();
				request.getSession().setAttribute("roleFunctionList", sysLoginList);
				request.getSession().setAttribute("allFunctionList", sysMenuFunctionList);
				request.getSession().setAttribute("user", sysUser);
				result.setState(1);
				result.setData(1);
				logger.info("登录用户");
				return result;
			}else
			{
				result.setError(new ErrorCode("用户名或密码错误"));
			}
		}else
		{
			result.setError(new ErrorCode("用户名或密码错误"));
		}
		
		return result;
	}
	
	@RequestMapping(value = "/logout")
	public String logout(HttpServletRequest request,HttpServletResponse response,ModelMap map) {
		logger.info("退出用户");
		HttpSession session = request.getSession();
		session.invalidate();
		return "redirect:/login.jsp";  //重定向
	}
	
	@RequestMapping(value = "/tologin")
	public String tologin(HttpServletRequest request,HttpServletResponse response,ModelMap map) {		
		return "redirect:/login.jsp";  //重定向
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