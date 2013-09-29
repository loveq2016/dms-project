package dms.yijava.event;

public class UserCheckFlowEvent {

	private String user_id;
	private String user_name;
	private String flow_id;
	private String bussiness_id;
	private String check_reason;
	private String status;
	
	
	
	public UserCheckFlowEvent(String user_id) {
		super();
		this.user_id = user_id;
	}


	public UserCheckFlowEvent(String user_id, String user_name, String flow_id,
			String bussiness_id, String check_reason, String status) {
		super();
		this.user_id = user_id;
		this.user_name = user_name;
		this.flow_id = flow_id;
		this.bussiness_id = bussiness_id;
		this.check_reason = check_reason;
		this.status = status;
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
	public String getFlow_id() {
		return flow_id;
	}
	public void setFlow_id(String flow_id) {
		this.flow_id = flow_id;
	}
	public String getBussiness_id() {
		return bussiness_id;
	}
	public void setBussiness_id(String bussiness_id) {
		this.bussiness_id = bussiness_id;
	}
	public String getCheck_reason() {
		return check_reason;
	}
	public void setCheck_reason(String check_reason) {
		this.check_reason = check_reason;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}


	@Override
	public String toString() {
		return "UserCheckFlowEvent [user_id=" + user_id + ", user_name="
				+ user_name + ", flow_id=" + flow_id + ", bussiness_id="
				+ bussiness_id + ", check_reason=" + check_reason + ", status="
				+ status + "]";
	}
	
	
	
	
}
