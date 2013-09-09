package dms.yijava.entity.dealer;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class DealerAuthProduct {

	
	
	
	private String dealer_id;//经销商id
	
	private String id;
	private String product_category_id;
	private String product_remark;
	private String area_remark;
	private String status;

	private String category_name;
	
	
	
}
