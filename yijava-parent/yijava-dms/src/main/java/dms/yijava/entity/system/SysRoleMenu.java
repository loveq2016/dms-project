package dms.yijava.entity.system;

public class SysRoleMenu {
	public String id;
	public String fk_system_id;
	public String fk_role_id;
	public String httplink;
	public String last_time;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getFk_system_id() {
		return fk_system_id;
	}
	public void setFk_system_id(String fk_system_id) {
		this.fk_system_id = fk_system_id;
	}
	public String getFk_role_id() {
		return fk_role_id;
	}
	public void setFk_role_id(String fk_role_id) {
		this.fk_role_id = fk_role_id;
	}
	public String getHttplink() {
		return httplink;
	}
	public void setHttplink(String httplink) {
		this.httplink = httplink;
	}
	public String getLast_time() {
		return last_time;
	}
	public void setLast_time(String last_time) {
		this.last_time = last_time;
	}
}
