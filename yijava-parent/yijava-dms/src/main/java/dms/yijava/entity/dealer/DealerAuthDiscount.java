package dms.yijava.entity.dealer;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class DealerAuthDiscount {

	private String id;
	private String dealer_id;// 经销商id
	private String item_number;
	private String cname;
	private String models;
	private String discount;

}
