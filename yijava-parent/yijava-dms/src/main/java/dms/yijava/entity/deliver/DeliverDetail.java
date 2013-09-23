package dms.yijava.entity.deliver;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class DeliverDetail {

	private String delivery_detail_id;
	private String deliver_id;
	private String deliver_code;
	private String order_code;
	private String order_detail_id;
	private String product_item_number;
	private String product_name;
	private String models;
	private String order_number_sum;
	private String deliver_number_sum;
	private String deliver_date;
	private String arrival_date;
	private String deliver_remark;
	
	
	private String ids;
	private String deliver_number_sums;
	private String deliver_dates;
	private String arrival_dates;
	private String deliver_remarks;
	
	
	

}
