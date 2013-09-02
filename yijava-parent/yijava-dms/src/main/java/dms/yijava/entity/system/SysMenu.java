package dms.yijava.entity.system;

public class SysMenu {
	public String id;
	public String menu_name;
	public String url;
	public String isdeleted;
	public String fk_parent_id;
	public String remark;
	public String last_time;
	public String ext1;
	public String ext2;
	public String ext3;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getMenu_name() {
		return menu_name;
	}
	public void setMenu_name(String menu_name) {
		this.menu_name = menu_name;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getIsdeleted() {
		return isdeleted;
	}
	public void setIsdeleted(String isdeleted) {
		this.isdeleted = isdeleted;
	}
	public String getFk_parent_id() {
		return fk_parent_id;
	}
	public void setFk_parent_id(String fk_parent_id) {
		this.fk_parent_id = fk_parent_id;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getLast_time() {
		return last_time;
	}
	public void setLast_time(String last_time) {
		this.last_time = last_time;
	}
	public String getExt1() {
		return ext1;
	}
	public void setExt1(String ext1) {
		this.ext1 = ext1;
	}
	public String getExt2() {
		return ext2;
	}
	public void setExt2(String ext2) {
		this.ext2 = ext2;
	}
	public String getExt3() {
		return ext3;
	}
	public void setExt3(String ext3) {
		this.ext3 = ext3;
	}
}
