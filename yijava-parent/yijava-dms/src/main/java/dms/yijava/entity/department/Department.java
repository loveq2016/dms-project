package dms.yijava.entity.department;

import lombok.Data;
import lombok.NoArgsConstructor;
import dms.yijava.entity.dealer.Dealer;

@Data  
@NoArgsConstructor
public class Department {
	
	public String id;
	public String text;
	public String department_name;
	public String chkerid;
	public String fk_parent_id;
	public String isdelete;
	public String remark;
	public String ext1;
	public String ext2;
	public String ext3;
	public String state;
}
