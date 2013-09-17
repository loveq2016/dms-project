package dms.yijava.entity.flow;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data  
@NoArgsConstructor
public class StepDepartment {

	public String entity_id;;
	public String flow_id;
	public String step_id;
	public String action_id;
	public String department_id;//节点处理部门id
	public String department_name;//部门名称
	public String next_department_id;//下一节点处理部门id
	public String back_department_id;//上一节点处理部门id
	
	public String ext_logic;//是否有额外处理逻辑
	

	
}
