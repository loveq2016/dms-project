package dms.yijava.entity.adjuststorage;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class AdjustStorageProDetail {
	public String id;
	public String fk_storage_id;
	public String adjust_storage_code;
	public String batch_no;
	public String product_sn;
}
