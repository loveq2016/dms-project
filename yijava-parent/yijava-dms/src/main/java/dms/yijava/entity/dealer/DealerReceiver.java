package dms.yijava.entity.dealer;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class DealerReceiver {

	private String id;
	private String dealer_id;
	private String address;
	private String postcode;
	private String linkman;
	private String linkphone;

}
