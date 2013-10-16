package dms.yijava.entity.order;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data  
@NoArgsConstructor
public class OrderDetail {
	public String id;
	public String order_code;
	public String product_item_number;
	public String product_name;
	public String models;
	public String order_number_sum;
	public String order_price;
	public String order_money_sum;
	public String remark;
	public String plan_send_date;
	public String last_time;
	public String discount;
	public String delivery_sum;
	public String type;
}
