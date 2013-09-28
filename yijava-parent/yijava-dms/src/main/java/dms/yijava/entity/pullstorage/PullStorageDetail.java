package dms.yijava.entity.pullstorage;

import lombok.Data;
import lombok.NoArgsConstructor;
import dms.yijava.entity.product.Product;


@Data
@NoArgsConstructor
public class PullStorageDetail {
	public String id;
	public String fk_storage_id;
	public String storage_name;
	public String pull_storage_code;
	public String put_storage_code;
	public String product_item_number;
	public String money;
	public String models;
	public String batch_no;
	public String inventory_number;
	public String sales_number;
	public String valid_date;
}
