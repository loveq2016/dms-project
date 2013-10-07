package dms.yijava.entity.adjuststorage;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class AdjustStorage {
	private String id;
	private String adjust_storage_code;
	private String adjust_storage_no;
	private String adjust_storage_date;
	private String dealer_id;
	private String dealer_name;
	private String type;
	private String total_number;
	private String status;
	private String remark;

}
