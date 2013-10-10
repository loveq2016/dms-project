package dms.yijava.entity.trial;

import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Trial {

	private Integer trial_id;
	public String trial_code;
	public String trial_no;
	
	private String dealer_user_id;
	private String dealer_name;
	private String sales_user_id;//销售id
	private Integer region_user_id;//区域负责人
	private Integer company_user_id;//公司负责人
	private String addhospital_id;
	private String hospital_id;
	private String hospital_name;//仅查询使用
	private String reason;
	private Integer trial_num_sum;
	private String create_time;
	
	private String q_start_time;//查询使用
	private String q_end_time;//查询使用
	
	private Integer status;
	private Integer last_update;	
	private List<TrialDetail> trialDetails;
}
