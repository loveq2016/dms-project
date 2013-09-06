package dms.yijava.entity.dealer;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class DealerAddress {

	private String id;
	private String dealer_id;
	private String address;
	private String postcode;
	private String linkman;
	private String linkphone;
	private String column1;
	private String column2;
	private String column3;

}
