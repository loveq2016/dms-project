package dms.yijava.entity.flow;

public class Flow {

	private Integer flow_id;
	private String flow_name;
	private String flow_desc;
	private Integer is_system; //是否是系统流程不可删除
	private Integer del_sign;
	private Integer add_emp_id;
	private String add_date;
	private Integer mody_emp_id;
	private String mody_date;
	private Integer del_emp_id;
	private String del_date;	
	private Integer order_no;
	
	
	public Flow() {
		super();
	}


	public Integer getFlow_id() {
		return flow_id;
	}


	public void setFlow_id(Integer flow_id) {
		this.flow_id = flow_id;
	}


	public String getFlow_name() {
		return flow_name;
	}


	public void setFlow_name(String flow_name) {
		this.flow_name = flow_name;
	}


	public String getFlow_desc() {
		return flow_desc;
	}


	public void setFlow_desc(String flow_desc) {
		this.flow_desc = flow_desc;
	}


	public Integer getIs_system() {
		return is_system;
	}


	public void setIs_system(Integer is_system) {
		this.is_system = is_system;
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
