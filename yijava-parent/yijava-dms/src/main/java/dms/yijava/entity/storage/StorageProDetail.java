package dms.yijava.entity.storage;

import java.io.Serializable;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class StorageProDetail  implements Serializable {

	private String id;
	private String fk_storage_id;
	private String fk_dealer_id;
	private String product_item_number;
	private String fk_order_code;
	//private String pull_storage_code;
	//private String type;
	private String status;
	private String batch_no;
	private String models;
	private String product_sn;
	private String valid_date;
	
	private String storage_name;
	


}
