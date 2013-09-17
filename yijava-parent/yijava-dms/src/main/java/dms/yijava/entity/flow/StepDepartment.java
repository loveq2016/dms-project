package dms.yijava.entity.flow;

import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;
import dms.yijava.entity.system.SysUser;


public class StepDepartment {

	public String entity_id;;
	public String flow_id;
	public String step_id;
	public String action_id;
	public String department_id;//节点处理部门id
	public String department_name;//部门名称
	public List<SysUser> users;
	public String next_department_id;//下一节点处理部门id
	public List<SysUser> next_users;
	public String back_department_id;//上一节点处理部门id
	public List<SysUser> back_users;
	public String ext_logic;//是否有额外处理逻辑
	public String getEntity_id() {
		return entity_id;
	}
	public void setEntity_id(String entity_id) {
		this.entity_id = entity_id;
	}
	public String getFlow_id() {
		return flow_id;
	}
	public void setFlow_id(String flow_id) {
		this.flow_id = flow_id;
	}
	public String getStep_id() {
		return step_id;
	}
	public void setStep_id(String step_id) {
		this.step_id = step_id;
	}
	public String getAction_id() {
		return action_id;
	}
	public void setAction_id(String action_id) {
		this.action_id = action_id;
	}
	public String getDepartment_id() {
		return department_id;
	}
	public void setDepartment_id(String department_id) {
		this.department_id = department_id;
	}
	public String getDepartment_name() {
		return department_name;
	}
	public void setDepartment_name(String department_name) {
		this.department_name = department_name;
	}
	public List<SysUser> getUsers() {
		return users;
	}
	public void setUsers(List<SysUser> users) {
		this.users = users;
	}
	public String getNext_department_id() {
		return next_department_id;
	}
	public void setNext_department_id(String next_department_id) {
		this.next_department_id = next_department_id;
	}
	public List<SysUser> getNext_users() {
		return next_users;
	}
	public void setNext_users(List<SysUser> next_users) {
		this.next_users = next_users;
	}
	public String getBack_department_id() {
		return back_department_id;
	}
	public void setBack_department_id(String back_department_id) {
		this.back_department_id = back_department_id;
	}
	public List<SysUser> getBack_users() {
		return back_users;
	}
	public void setBack_users(List<SysUser> back_users) {
		this.back_users = back_users;
	}
	public String getExt_logic() {
		return ext_logic;
	}
	public void setExt_logic(String ext_logic) {
		this.ext_logic = ext_logic;
	}
	

	
}
