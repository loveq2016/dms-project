package dms.yijava.entity.product;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Product {

	private String item_number;
	private String cname;
	private String ename;
	private String remark;
	private String price;
	private String order_company;
	private String is_order;
	private String column1;
	private String column2;
	private String column3;
	
	private String category_id;
	private String category_name;
	
	private String discount;
	

}
