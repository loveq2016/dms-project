package dms.yijava.entity.dealer;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class DealerPlan {

	private String id;
	private String year;
	private String january;
	private String february;
	private String march;
	private String april;
	private String may;
	private String june;
	private String july;
	private String august;
	private String september;
	private String october;
	private String november;
	private String december;
	
	private String dealer_id;//经销商id
	private String dealer_name;
	private String dealer_code;

}
