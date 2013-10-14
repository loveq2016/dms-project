package dms.yijava.entity.orderDeliver;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class OrderDeliver {

	private String deliver_id;
	private String dealer_id;
	private String dealer_name;
	private String deliver_code;
	private String order_code;
	private String deliver_status;
	private String express_code;
	private String express_date;
	private String consignee_user_id;
	private String consignee_date;
	private String consignee_status;
	private String totalMoney;

}
