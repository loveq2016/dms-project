package dms.yijava.entity.trial;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class TrialDetail {

	private Integer trial_detail_id;
	private Integer trial_id;
	private Integer product_id;
	private String product_name;
	private String models;
	private Integer trial_num;
	private String remark;
}
