package dms.yijava.entity.teamlayou;

import lombok.Data;
import lombok.NoArgsConstructor;
import dms.yijava.entity.storage.Storage;

@Data
@NoArgsConstructor
public class TeamLayou {
	public String id;;
	public String team_name;
	public String fk_parent_id;
	public String remark;
	public String ext1;
	public String ext2;
	public String ext3;
	
	public String fk_team_id;
	public String fk_team_name;
	public String fk_user_id;
	public String fk_user_name;
	public String fk_role_id;
}
