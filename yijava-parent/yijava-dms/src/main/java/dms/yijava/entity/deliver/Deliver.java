package dms.yijava.entity.deliver;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Deliver {

	private String deliver_id;
	private String deliver_code;
	private String deliver_no;
	private String order_id;
	private String order_code;
	private String order_date;
	private String order_type;
	private String create_date;
	private String remark;
	private String deliver_status;
	private String check_status;
	private String express_code;
	private String express_date;
	private String user_id;
	private String dealer_id;
	private String dealer_code;
	private String dealer_name;
	private String dealer_address_id;

	private String record_id;
	private String record_status;
	private String check_id;
}
