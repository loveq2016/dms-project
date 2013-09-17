package dms.yijava.entity.flow;

import java.util.List;

public class Step {

	
	private Integer step_id;
	private Integer flow_id;
	private Integer action_id;
	
	private Integer step_repeat_no;
	private Integer step_order_no;
	private Integer step_type;
	
	private Integer is_multi;

	private String action_name;
	private String action_desc;
	
	private List<StepDepartment> stepDepartments;
	
	//private Action action;
	
	
	public Step() {
		super();
	}

	public Integer getStep_id() {
		return step_id;
	}

	public void setStep_id(Integer step_id) {
		this.step_id = step_id;
	}

	public Integer getFlow_id() {
		return flow_id;
	}

	public void setFlow_id(Integer flow_id) {
		this.flow_id = flow_id;
	}

	public Integer getAction_id() {
		return action_id;
	}

	public void setAction_id(Integer action_id) {
		this.action_id = action_id;
	}

	public Integer getStep_repeat_no() {
		return step_repeat_no;
	}

	public void setStep_repeat_no(Integer step_repeat_no) {
		this.step_repeat_no = step_repeat_no;
	}

	public Integer getStep_order_no() {
		return step_order_no;
	}

	public void setStep_order_no(Integer step_order_no) {
		this.step_order_no = step_order_no;
	}

	public Integer getStep_type() {
		return step_type;
	}

	public void setStep_type(Integer step_type) {
		this.step_type = step_type;
	}

	public Integer getIs_multi() {
		return is_multi;
	}

	public void setIs_multi(Integer is_multi) {
		this.is_multi = is_multi;
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

	public List<StepDepartment> getStepDepartments() {
		return stepDepartments;
	}

	public void setStepDepartments(List<StepDepartment> stepDepartments) {
		this.stepDepartments = stepDepartments;
	}

	/*public Action getAction() {
		return action;
	}

	public void setAction(Action action) {
		this.action = action;
	}*/
	
	
	
	
	
}
