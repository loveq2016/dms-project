package dms.yijava.entity.hospital;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Hospital {


	private String id;
	private String hospital_name;
	private String hostpital_category;
	private String level_id;
	private String level_name;
	private String provinces;
	private String area;
	private String city;
	private String address;
	private String postcode;
	private String phone;
	private Integer beds = 0;
	private String create_date; //创建时间 
	private String last_update;//最后修改时间
	
	
}
