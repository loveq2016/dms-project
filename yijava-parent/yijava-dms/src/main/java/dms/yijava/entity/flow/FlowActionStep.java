package dms.yijava.entity.flow;

public class FlowActionStep {

	
	private Integer step_id;
	private Integer flow_id;
	private Integer action_id;
	
	private Integer step_repeat_no;
	private Integer step_order_no;
	private Integer step_type;
	
	private Integer is_multi;

	
	
	public FlowActionStep() {
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
	
	
	
	
	
}
