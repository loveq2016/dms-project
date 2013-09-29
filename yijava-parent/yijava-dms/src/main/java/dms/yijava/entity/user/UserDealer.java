package dms.yijava.entity.user;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserDealer {

	private String id;
	private String dealer_id;
	private String dealer_code;
	private String dealer_name;
	private String business_contacts;
	private String business_phone;
	
	private String user_id;
	private String department_id;
}
