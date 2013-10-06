package dms.yijava.entity.movestorage;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class MoveStorageProDetail {
	public String id;
	public String fk_move_storage_id;
	public String fk_move_to_storage_id;
	public String move_storage_code;
	public String product_sn;
	public String batch_no;
	public String last_time;
}
