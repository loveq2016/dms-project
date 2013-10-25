package dms.yijava.api.web.model.flow;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data  
@NoArgsConstructor
public class ProcFlowModel {

	private String flow_id;
	private String user_id;
	private String bussiness_id;	
	private String check_reason;
	
	//处理状态 
	private String status;
	
	
	//************以下增加字段为，指定人的处理流程
	private String check_name;
	private String base_check_id;
	
	
	
}
