package dms.yijava.entity.teamlayou;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserLayou {
	public String id;
	public String fk_team_id;
	public String fk_team_name;
	public String fk_user_id;
	public String fk_user_name;
	public String fk_role_id;
	public String remark;
	public String ext1;
	public String ext2;
	public String ext3;
}
