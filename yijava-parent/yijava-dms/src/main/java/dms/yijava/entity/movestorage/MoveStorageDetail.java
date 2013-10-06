package dms.yijava.entity.movestorage;

import lombok.Data;
import lombok.NoArgsConstructor;
import dms.yijava.entity.product.Product;


@Data
@NoArgsConstructor
public class MoveStorageDetail {
	public String id;
	public String fk_move_storage_id;
	public String fk_move_to_storage_id;
	public String move_storage_code;
	public String product_item_number;
	public String money;
	public String models;
	public String batch_no;
	public String move_number;
	public String valid_date;
	
	public String move_storage_name;
	public String move_to_storage_name;
	public String inventory_number;

}
