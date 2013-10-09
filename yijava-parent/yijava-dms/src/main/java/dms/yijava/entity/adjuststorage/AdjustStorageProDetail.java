package dms.yijava.entity.adjuststorage;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class AdjustStorageProDetail {
	private String id;
	private String adjust_storage_detail_id;
	private String fk_storage_id;
	private String adjust_storage_code;
	private String batch_no;
	private String product_sn;

}
