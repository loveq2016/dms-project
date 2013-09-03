package dms.yijava.entity.flow;

public class Action {

	private Integer action_id;
	private String action_name;
	private String action_desc;
	
	
	private Integer del_sign;
	private Integer add_emp_id;
	private String add_date;
	private Integer mody_emp_id;
	private String mody_date;
	private Integer del_emp_id;
	private String del_date;	
	private Integer order_no;
	public Action() {
		super();
	}
	public Integer getAction_id() {
		return action_id;
	}
	public void setAction_id(Integer action_id) {
		this.action_id = action_id;
	}
	public String getAction_name() {
		return action_name;
	}
	public void setAction_name(String action_name) {
		this.action_name = action_name;
	}
	public String getAction_desc() {
		return action_desc;
	}
	public void setAction_desc(String action_desc) {
		this.action_desc = action_desc;
	}
	public Integer getDel_sign() {
		return del_sign;
	}
	public void setDel_sign(Integer del_sign) {
		this.del_sign = del_sign;
	}
	public Integer getAdd_emp_id() {
		return add_emp_id;
	}
	public void setAdd_emp_id(Integer add_emp_id) {
		this.add_emp_id = add_emp_id;
	}
	public String getAdd_date() {
		return add_date;
	}
	public void setAdd_date(String add_date) {
		this.add_date = add_date;
	}
	public Integer getMody_emp_id() {
		return mody_emp_id;
	}
	public void setMody_emp_id(Integer mody_emp_id) {
		this.mody_emp_id = mody_emp_id;
	}
	public String getMody_date() {
		return mody_date;
	}
	public void setMody_date(String mody_date) {
		this.mody_date = mody_date;
	}
	public Integer getDel_emp_id() {
		return del_emp_id;
	}
	public void setDel_emp_id(Integer del_emp_id) {
		this.del_emp_id = del_emp_id;
	}
	public String getDel_date() {
		return del_date;
	}
	public void setDel_date(String del_date) {
		this.del_date = del_date;
	}
	public Integer getOrder_no() {
		return order_no;
	}
	public void setOrder_no(Integer order_no) {
		this.order_no = order_no;
	}
	
	
}
