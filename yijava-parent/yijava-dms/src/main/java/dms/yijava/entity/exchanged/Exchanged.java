package dms.yijava.entity.exchanged;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Exchanged {
	private String id;
	private String exchanged_code;
	private String exchanged_no;
	private String exchanged_date;
	private String dealer_id;
	private String dealer_name;
	private String type;
	private String total_number;
	private String status;
	private String remark;
}
