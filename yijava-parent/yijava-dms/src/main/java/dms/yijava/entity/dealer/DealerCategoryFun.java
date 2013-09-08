package dms.yijava.entity.dealer;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class DealerCategoryFun {

	private String dealer_id;//经销商id
	private String dealer_name;
	private String dealer_code;
	private String category_id;//经销商分类
	private String category_name;
	
}
