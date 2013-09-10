package dms.yijava.api.web.interseptor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import dms.yijava.entity.system.SysLogin;
import dms.yijava.entity.system.SysMenuFunction;
import dms.yijava.entity.system.SysUser;

public class Interseptor extends HandlerInterceptorAdapter {

	static Logger logger = LoggerFactory.getLogger(Interseptor.class);
	
	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
       
		MDC.put("ACCOUNT", "gaoyong");
		MDC.put("OPERATORIP", getIpAddr(request));
		return true;
		
		
//		String url =  request.getRequestURI().toString();
//        if(url.indexOf("/api/sys/login")>-1 || url.indexOf("/api/sys/logout")>-1)
//        	return true;
//        try{
//        	
////        	  权限认证机制细节
////        	 1，需要认证的权限URL，必须和功能按钮的URL对应(sysmenufun表有记录)，否则权限无效。
////        	 2，未登录的用户无法访问action. 但可以放jsp
////        	 3，已登录用户访问的权限URL必须是经过授权的，否则跳转错误页面(防止已登录用户，记住连接地址)，jsp、非权限URL除外。
//        	 
//        	List<SysMenuFunction> allFunList=(List<SysMenuFunction>) request.getSession().getAttribute("allFunctionList"); //所有的权限
//			List<SysLogin> roleFunList = (List<SysLogin>) request.getSession().getAttribute("roleFunctionList");//角色拥有的权限
//        	SysUser sysUser=(SysUser)request.getSession().getAttribute("user"); //当前用户信息
//			if(null!=sysUser && null!=roleFunList && null!=allFunList){
//				for(Object obj1:allFunList){
//					SysMenuFunction sysMenuFun = (SysMenuFunction)obj1;
//					if(url.indexOf(sysMenuFun.getUrl())>-1 &&
//							!sysMenuFun.getUrl().equals("")){
//						for(Object obj2:roleFunList){
//							SysLogin sysLogin=(SysLogin)obj2;
//							if(url.indexOf(sysLogin.getFun_url())>-1 &&
//									!sysLogin.getFun_url().equals("")){
//								return true;
//							}
//						}
//						//是权限连接 但角色没有拥有该的权限(防止get请求，恶意注入等操作)
//				        response.sendRedirect(request.getContextPath()+"/error/500.jsp");
//						return false;
//					}
//				}
//				MDC.put("ACCOUNT", sysUser.getAccount());
//				MDC.put("OPERATORIP", getIpAddr(request));
//				//不属于权限连接放行
//				return true;
//			}else{
//				response.sendRedirect(request.getContextPath()+"/login.jsp");
//    			return false;
//			}
//        }catch(Exception e){}
//        response.sendRedirect(request.getContextPath()+"/error/500.jsp");
//    	return false;
	}
	
	public String getIpAddr(HttpServletRequest request) {  
	    String ip = request.getHeader("x-forwarded-for");  
	    if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
	        ip = request.getHeader("PRoxy-Client-IP");  
	    }  
	    if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
	        ip = request.getHeader("WL-Proxy-Client-IP");  
	    }  
	    if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
	        ip = request.getRemoteAddr();  
	    }  
	    return ip;  
	}  
	
}
