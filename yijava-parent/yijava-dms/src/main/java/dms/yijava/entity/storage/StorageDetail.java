package dms.yijava.entity.storage;

import java.io.Serializable;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class StorageDetail implements Serializable {

	private String id;
	private String fk_storage_id;
	private String fk_dealer_id;
	private String product_item_number;
	private String batch_no;
	private String inventory_number;
	private String valid_date;
	private String models;
	private String storage_name;
	private String dealer_name;
	private String product_cname;

}
