package dms.yijava.api.web.word.util;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class OrderProdcut {

	private String productname;
	private String productmodel;
	private String sumnumber;
	private String price;//单价
	private String sumprice;//金额
	private String remark;
}
