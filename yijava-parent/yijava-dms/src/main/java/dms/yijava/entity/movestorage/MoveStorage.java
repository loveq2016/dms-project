package dms.yijava.entity.movestorage;

import lombok.Data;
import lombok.NoArgsConstructor;
import dms.yijava.entity.product.Product;

@Data
@NoArgsConstructor
public class MoveStorage {
	public String id;
	public String move_storage_code;
	public String move_storage_no;
	public String move_storage_date;
	public String fk_move_storage_party_id;
	public String move_storage_party_name;
	public String type;
	public String total_number;
	public String total_money;
	public String status;
	public String create_date;
	public String last_time;
}
