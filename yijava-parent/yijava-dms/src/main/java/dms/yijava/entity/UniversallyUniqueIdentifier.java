package dms.yijava.entity;

import java.io.Serializable;

import org.apache.commons.lang3.StringUtils;

public class UniversallyUniqueIdentifier  implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -406763307231690222L;
	
	
	protected String id;

	/**
	 * 获取主键ID
	 * 
	 * @return String
	 */
	
	public String getId() {
		if (StringUtils.isEmpty(id)) {
			return null;
		}
		return this.id;
	}

	/**
	 * 设置主键ID，
	 * 
	 * @param id
	 */
	public void setId(String id) {
		if (StringUtils.isEmpty(id)) {
			this.id = null;
		} else {
			this.id = id;
		}

	}
}
