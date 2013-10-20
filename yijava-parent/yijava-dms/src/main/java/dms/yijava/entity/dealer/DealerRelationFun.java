package dms.yijava.entity.dealer;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class DealerRelationFun {
	
	private String id;
	private String dealer_id;//经销商id
	private String dealer_name;
	private String parent_dealer_name;
	private String dealer_code;
	private String parent_dealer_code;
	private String category_name;
	
	private String parent_dealer_id;
	
	private String business_contacts;
	private String business_phone;

	
}
