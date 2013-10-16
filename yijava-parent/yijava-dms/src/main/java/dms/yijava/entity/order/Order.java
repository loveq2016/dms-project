package dms.yijava.entity.order;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data  
@NoArgsConstructor
public class Order {
	public String id;
	public String dealer_id;
	public String order_code;
	public String order_no;
	public String order_number_sum;
	public String order_money_sum;
	public String order_date;
	public String order_status;
	public String type;
	public String dealer_address_id;
	public String express_code;
	public String last_time;
	public String start_date;
	public String end_date;
	
	public String dealer_name;
	public String business_contacts;
	public String business_phone;
	public String addess;
	public String receive_linkman;
	public String receive_linkphone;
	public String receive_postcode;
	public String receive_addess;
	
	
	
}
