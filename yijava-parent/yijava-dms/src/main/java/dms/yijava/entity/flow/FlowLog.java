package dms.yijava.entity.flow;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data  
@NoArgsConstructor
public class FlowLog {

	public String id;
	public String flow_record_id;
	public String flow_id;
	public String user_id;	
	public String user_name;
	public String bussiness_id;
	public String action_name;
	public String check_user_id;
	public String check_user_name;
	public String check_reason;
	public String create_date;
	public String sign;
	
}
