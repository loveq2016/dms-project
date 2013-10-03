package dms.yijava.web.model;

import java.util.List;

public class UserToCheckJson {

	private String id;
	private String text;
	
	private List<UserToCheckJson> children;
	
	
	
	public UserToCheckJson() {
		super();
	}
	
	
	public UserToCheckJson(String id, String text) {
		super();
		this.id = id;
		this.text = text;
	}
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
	public List<UserToCheckJson> getChildren() {
		return children;
	}
	public void setChildren(List<UserToCheckJson> children) {
		this.children = children;
	}
	
	
	
}
