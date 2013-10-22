package dms.yijava.api.web.system;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.text.ParseException;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateUtils;
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

import dms.yijava.common.SysConstant;
import dms.yijava.entity.key.LoginKeyGen;
import dms.yijava.entity.key.UKey;
import dms.yijava.entity.system.SysLogin;
import dms.yijava.entity.system.SysMenuFunction;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.teamlayou.UserLayou;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.key.LoginKeyGenService;
import dms.yijava.service.key.UKeyService;
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
	
	@Autowired
	private LoginKeyGenService loginKeyGenService;
	
	@Autowired
	private UKeyService uKeyService;
	
	
	@ResponseBody
	@RequestMapping(value = "/login")
	public Result<Integer> index(HttpServletRequest request,HttpServletResponse response,ModelMap map) {
		Result<Integer> result=new Result<Integer>(0, 0);
		String account = request.getParameter("account");
		String password = request.getParameter("password");
		String randcode = request.getParameter("captcha");
		
		if(account==null || account.equals("")|| password==null || password.equals(""))
		{
			result.setError(new ErrorCode("账户名和密码不可为空"));
			return result;
		}
		
		String sessionCode=(String)request.getSession().getAttribute(SysConstant.DEFAULT_CAPTCHA_PARAM);
		if(!StringUtils.equalsIgnoreCase(randcode, sessionCode))
		
		{
			result.setError(new ErrorCode("验证码错误！"));
			return result;
		}
		
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
				doLogin(request,sysUser);
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
	public void doLogin(HttpServletRequest request,SysUser sysUser)
	{
		List<SysLogin> sysLoginList= sysLoginService.getRoleMenuFunList(sysUser.getFk_role_id());
		try{
			String teams="";
			//经销商账号
			if(!sysUser.getFk_dealer_id().equals("0")){
				//获取销售ID
				UserDealer u=(UserDealer)userDealerFunService.getUserByDealer(sysUser.getFk_dealer_id());
				teams=userLayouService.getTeamIdsByUserId(u.getUser_id()).getFk_team_id();//用户节点
			}else{
				teams=userLayouService.getTeamIdsByUserId(sysUser.getId()).getFk_team_id();//用户节点
			}
			/**根据用户的所有节点找到所有的上级用户 */
			String parentIds="";
			for(String team:teams.split(","))
			{
				List<UserLayou> userLayouts=userLayouService.getParentByUserId(team);
				for(UserLayou userLayou:userLayouts)
				{
					parentIds+=userLayou.getFk_user_id()+",";
				}
			}
			sysUser.setParentIds(parentIds);
			/**/
			List<UserDealer> userDealerList=userDealerFunService.getUserDealerList(sysUser.getId(),teams.split(","));//节点用户
			List<String> list=userLayouService.getUserListById(sysUser.getId(),teams.split(","));
			if(list!=null)
			{
				 int size=list.size();  
				 String[] array = (String[])list.toArray(new String[size]);  
			       /* for(int i=0;i<array.length;i++){  
			            System.out.println(array[i]);  
			        }*/  
				sysUser.setChildIds(array);
			}
			 
			sysUser.setUserDealerList(userDealerList);
			sysUser.setTeams(teams);
		}catch(Exception e){
			e.printStackTrace();
		}
		List<SysMenuFunction> sysMenuFunctionList=sysMenuFunctionService.getAllList();
		request.getSession().setAttribute("roleFunctionList", sysLoginList);
		request.getSession().setAttribute("allFunctionList", sysMenuFunctionList);
		request.getSession().setAttribute("user", sysUser);
	}
	
	/**
	 * u盾自动登录
	 * @param request
	 * @param response
	 * @param map
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/autologin")
	public Result<Integer> autologin(HttpServletRequest request,HttpServletResponse response,ModelMap map) {
		Result<Integer> result=new Result<Integer>(0, 0);
		String code = request.getParameter("code");
		String faccode = request.getParameter("faccode");
		String keygen = request.getParameter("keygen");
		//判断keygen是否失效
		
		List<LoginKeyGen> keygens=loginKeyGenService.getKeyGen(keygen);
		if(null!=keygens && keygens.size()>0)
		{
			LoginKeyGen dbkeygen=keygens.get(0);
			try {
				String dateStr=dbkeygen.getCreate_date();
				dateStr=dateStr.substring(0,dateStr.indexOf("."));
				Date createDate=DateUtils.parseDate(dateStr,"yyyy-MM-dd HH:mm:ss");
				long sq=new Date().getTime()-createDate.getTime();
				if(sq<30*1000)
				{
					//开始登录
					//检查faccode是不是我们登记过的
					
					List<UKey> ukeys=uKeyService.getKeyByCode(faccode);
					if(null!=ukeys && ukeys.size()>0)
					{
						//找到里边的用户account进行登录
						
						SysUser sysUser = sysUserService.getEntity(code);
						doLogin(request,sysUser);
						result.setState(1);
						result.setData(1);
						logger.info("登录用户");
						return result;
					}else
					{
						result.setError(new ErrorCode("用户授权编码不正确,请联系管理员"));
					}
					
				}else
				{
					result.setError(new ErrorCode("用户授权失效,请联系管理员"));
				}
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}else
		{
			result.setError(new ErrorCode("用户授权不存在,请联系管理员"));
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