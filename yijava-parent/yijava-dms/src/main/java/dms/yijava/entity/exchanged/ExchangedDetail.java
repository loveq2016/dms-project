package dms.yijava.entity.exchanged;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ExchangedDetail {
	private String id;
	private String fk_storage_id;
	private String storage_name;
	private String exchanged_code;
	private String product_item_number;
	private String models;
	private String batch_no;
	private String exchanged_number;
	private String valid_date;
	private String inventory_number;
	
	
	private String order_code;
	private String cname;
	private String newModels="";
	
	

}
