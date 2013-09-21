package dms.yijava.entity.trial;

import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Trial {

	private Integer trial_id;
	private Integer dealer_user_id;
	private Integer region_user_id;
	private Integer company_user_id;
	private Integer hospital_id;
	private String reason;
	private Integer trial_num_sum;
	private String create_time;
	
	private String q_start_time;//查询使用
	private String q_end_time;//查询使用
	
	private Integer status;
	private Integer last_update;	
	private List<TrialDetail> trialDetails;
}
