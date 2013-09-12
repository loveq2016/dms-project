package dms.yijava.entity.user;

import java.util.HashMap;
import java.util.Map;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserOrganization {


	private String id;
	private String parent_id;
	private String text;
	private String state;

	private Map<String,String> attributes = new HashMap<String,String>();
	
}
