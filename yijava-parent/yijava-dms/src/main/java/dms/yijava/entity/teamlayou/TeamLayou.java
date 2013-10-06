package dms.yijava.entity.teamlayou;

import java.util.HashMap;
import java.util.Map;

import lombok.Data;
import lombok.NoArgsConstructor;
import dms.yijava.entity.storage.Storage;

@Data
@NoArgsConstructor
public class TeamLayou {
	public String id;
	public String text;
	public String team_name;
	public String parent_id;
	public String remark;
	public String type;
	public String state;
	public String ext1;
	public String ext2;
	public String ext3;
	
	public String fk_team_id;
	public String fk_team_name;
	public String fk_user_id;
	public String fk_user_name;
	public String fk_role_id;
	
	private Map<String,String> attributes = new HashMap<String,String>();

}
