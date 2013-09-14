package dms.yijava.entity.flow;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;
import dms.yijava.entity.department.Department;
@Data  
@NoArgsConstructor
public class FlowRecord {
	public String record_id;;
	public String flow_id;
	public String bussiness_id;
	public String title;
	public String send_id;
	public String send_time;
	public String check_id;
	public String check_time;
	public String check_department_id;
	public String status;
	public String check_reason;
	public String is_delete;
	public String create_time;
	public String remark;
	public String ext1;
	public String ext2;
	public String ext3;

}
