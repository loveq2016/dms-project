package dms.yijava.entity.trial;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class TrialDetail {

	private Integer trial_detail_id;
	private Integer trial_id;
	private Integer product_id;
	private String prouct_name;
	private Integer trial_num;
	private String remark;
}
