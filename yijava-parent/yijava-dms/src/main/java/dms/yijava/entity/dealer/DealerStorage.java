package dms.yijava.entity.dealer;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class DealerStorage {

	
	private String id;
	
	private String dealer_id;//经销商id
	private String dealer_name;
	private String dealer_code;
	
	private String storage_id;
	private String storage_name;
	private String province;
	private String city;
	private String area;
	private String address;
	private String postcode;
	private String phone;
	private String tex;
	
	
	private String category_id;
	private String category_name;
	
	
	
	
	
}
