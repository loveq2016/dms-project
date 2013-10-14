package dms.yijava.entity.exchanged;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ExchangedProDetail {
	private String id;
	private String exchanged_detail_id;
	private String fk_storage_id;
	private String exchanged_code;
	private String batch_no;
	private String product_sn;

}
