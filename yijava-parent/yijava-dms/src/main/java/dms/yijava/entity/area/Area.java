package dms.yijava.entity.area;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data  
@NoArgsConstructor
public class Area {

	private Integer areaid;
	private String name;
	private Integer parentid;
	private Integer vieworder;
	
}
