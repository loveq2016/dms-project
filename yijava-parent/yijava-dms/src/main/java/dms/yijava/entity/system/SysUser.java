package dms.yijava.entity.system;

import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;
import dms.yijava.entity.user.UserDealer;

@Data
@NoArgsConstructor
public class SysUser {
	public String id;
	public String account;
	public String realname;
	public String password;
	public String email;
	public String type;
	public String birthday;
	public String sex;
	public String phone;
	public String province;
	public String address;
	public String postcode;
	public String fk_department_id;
	public String department_name;
	public String fk_dealer_id;
	public String dealer_name;
	public String deliver_code;
	public String fk_role_id;
	public String role_name;
	public String isdeleted;
	public String create_time;
	public String last_time;
	public String remark;
	public String customfield1;
	public String customfield2;
	public String customfield3;
	public String ext1;
	public String ext2;
	public String ext3;
	public String[] teams;
	public List<UserDealer> userDealerList;
}
