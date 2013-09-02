package dms.yijava.entity.product;

public class ProductCategory {
	
	//分类id
	private String id;
	//分类名称
	private String text;
	//分类的父ID
	private String parent_id;
	//分类下是否可以 open closed
	private String state;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public String getParent_id() {
		return parent_id;
	}

	public void setParent_id(String parent_id) {
		this.parent_id = parent_id;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

}
