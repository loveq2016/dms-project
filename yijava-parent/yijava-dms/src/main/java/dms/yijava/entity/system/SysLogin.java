package dms.yijava.entity.system;

import java.io.Serializable;

public class SysLogin implements Serializable{
	private static final long serialVersionUID = -3790776302766012681L;
	public String user_id;
	public String user_name;
	public String role_id;
	public String fun_id;
	public String fun_name;
	public String fun_url;
	public String fun_method;
	public String menu_id;
	public String menu_name;
	public String menu_url;
	public String menu_parent_id;
	public String menu_parent_name;
	
	public String getFun_url() {
		return fun_url;
	}
	public void setFun_url(String fun_url) {
		this.fun_url = fun_url;
	}
	public String getFun_method() {
		return fun_method;
	}
	public void setFun_method(String fun_method) {
		this.fun_method = fun_method;
	}
	public String getMenu_url() {
		return menu_url;
	}
	public void setMenu_url(String menu_url) {
		this.menu_url = menu_url;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public String getRole_id() {
		return role_id;
	}
	public void setRole_id(String role_id) {
		this.role_id = role_id;
	}
	public String getFun_id() {
		return fun_id;
	}
	public void setFun_id(String fun_id) {
		this.fun_id = fun_id;
	}
	public String getFun_name() {
		return fun_name;
	}
	public void setFun_name(String fun_name) {
		this.fun_name = fun_name;
	}
	public String getMenu_id() {
		return menu_id;
	}
	public void setMenu_id(String menu_id) {
		this.menu_id = menu_id;
	}
	public String getMenu_name() {
		return menu_name;
	}
	public void setMenu_name(String menu_name) {
		this.menu_name = menu_name;
	}
	public String getMenu_parent_id() {
		return menu_parent_id;
	}
	public void setMenu_parent_id(String menu_parent_id) {
		this.menu_parent_id = menu_parent_id;
	}
	public String getMenu_parent_name() {
		return menu_parent_name;
	}
	public void setMenu_parent_name(String menu_parent_name) {
		this.menu_parent_name = menu_parent_name;
	}
	
}
