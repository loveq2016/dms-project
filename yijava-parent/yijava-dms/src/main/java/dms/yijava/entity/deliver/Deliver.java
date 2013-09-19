package dms.yijava.entity.deliver;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Deliver {

	private String deliver_id;
	private String order_entity_id;
	private String order_id;
	private String remark;
	private String deliver_status;

}
