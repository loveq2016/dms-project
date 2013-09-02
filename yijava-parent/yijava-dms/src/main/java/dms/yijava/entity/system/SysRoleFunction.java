package dms.yijava.entity.system;

public class SysRoleFunction {
	public String id;
	public String fk_fun_id;
	public String fk_role_id;
	public String last_time;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getFk_fun_id() {
		return fk_fun_id;
	}
	public void setFk_fun_id(String fk_fun_id) {
		this.fk_fun_id = fk_fun_id;
	}
	public String getFk_role_id() {
		return fk_role_id;
	}
	public void setFk_role_id(String fk_role_id) {
		this.fk_role_id = fk_role_id;
	}
	public String getLast_time() {
		return last_time;
	}
	public void setLast_time(String last_time) {
		this.last_time = last_time;
	}
}
