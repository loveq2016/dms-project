package dms.yijava.web.model;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data  
@NoArgsConstructor
public class UserToCheck {

	private String user_id;//用户id
	private String flow_id;//业务类型
	private String item_number;//待处理事项条目数
}
