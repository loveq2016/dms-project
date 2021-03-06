package dms.yijava.entity.pullstorage;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class PullStorageProDetail {
	public String id;
	public String fk_pull_storage_detail_id;
	public String fk_storage_id;
	public String pull_storage_code;
	public String put_storage_code;
	public String product_sn;
	public String batch_no;

	public String[] product_sns;
	public String[] batch_nos;
	public String last_time;
}
