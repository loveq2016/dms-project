package dms.yijava.entity.product;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ProductCategory {

	private String id;
	private String text;
	private String parent_id;
	private String state;	// 分类下是否可以 open closed

}
