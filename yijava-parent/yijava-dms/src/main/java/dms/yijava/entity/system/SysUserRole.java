package dms.yijava.entity.system;

public class SysUserRole {

	public String id;
	public String fk_user_id;
	public String 	fk_role_id;
	public String last_time;
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getFk_user_id() {
		return fk_user_id;
	}
	public void setFk_user_id(String fk_user_id) {
		this.fk_user_id = fk_user_id;
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
