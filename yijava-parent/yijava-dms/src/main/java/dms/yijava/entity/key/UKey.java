package dms.yijava.entity.key;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UKey {

	private Integer key_id;
	private String factory_code;
	private String version;
	private String exversion;
	private String create_date;
	private String last_date;
	
	private Integer userId;
	private String realname;
	private String account;
	
}
