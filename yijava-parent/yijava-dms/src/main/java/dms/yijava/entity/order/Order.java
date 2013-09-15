package dms.yijava.entity.order;

import lombok.Data;
import lombok.NoArgsConstructor;
import dms.yijava.entity.flow.FlowRecord;

@Data  
@NoArgsConstructor
public class Order {
	public String id;
	public String dealer_id;
	public String order_code;
	public String order_number_sum;
	public String order_money_sum;
	public String order_date;
	public String order_status;
	public String dealer_address_id;
	public String last_time;
	public String start_date;
	public String end_date;
}
