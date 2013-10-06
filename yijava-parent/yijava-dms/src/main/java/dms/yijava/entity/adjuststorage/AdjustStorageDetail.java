package dms.yijava.entity.adjuststorage;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class AdjustStorageDetail {
	private String id;
	private String fk_storage_id;
	private String storage_name;
	private String adjust_storage_code;
	private String product_item_number;
	private String batch_no;
	private String adjust_number;
	private String valid_date;
	private String inventory_number;

}
