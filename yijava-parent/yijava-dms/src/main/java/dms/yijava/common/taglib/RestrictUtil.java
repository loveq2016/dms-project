package dms.yijava.common.taglib;

import java.util.List;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTagSupport;

import org.apache.commons.lang3.StringUtils;

import dms.yijava.entity.system.SysLogin;
import dms.yijava.entity.system.SysUser;

public class RestrictUtil extends BodyTagSupport {

	private static final long serialVersionUID = -197036399031741641L;

	private String funId;

	private String funMethod;
	
	private String type;

	@Override
	public int doEndTag() throws JspException {
		try {
			List<SysLogin> funList = (List<SysLogin>) this.pageContext.getSession().getAttribute("roleFunctionList");
			SysUser sysUser = (SysUser) this.pageContext.getSession().getAttribute("user");
			String buttString = this.getBodyContent().getString();
			if(null!=sysUser && null!=funList){
				for(Object obj:funList){
					SysLogin sysLogin=(SysLogin)obj;
					if(sysLogin.getFun_id().equals(this.getFunId())){
						this.pageContext.getOut().println(buttString);
						break;
					}
				}
			}else{
				this.pageContext.getOut().println("");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return EVAL_PAGE;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
	public String getFunId() {
		return funId;
	}

	public void setFunId(String funId) {
		this.funId = funId;
	}

	public String getFunMethod() {
		return funMethod;
	}

	public void setFunMethod(String funMethod) {
		this.funMethod = funMethod;
	}

	
}
