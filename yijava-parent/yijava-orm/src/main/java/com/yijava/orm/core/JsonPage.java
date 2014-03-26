package com.yijava.orm.core;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

public class JsonPage<T>  implements Serializable {

	protected List<T> rows = null;
	protected long total = -1;
	protected long notice = 0;
	protected List<Map<String,String>> footer = null;
	
	public JsonPage() {
		super();
	}
	
	
	public JsonPage(List<T> rows, long total) {
		super();
		this.rows = rows;
		this.total = total;
	}
	public List<T> getRows() {
		return rows;
	}
	public void setRows(List<T> rows) {
		this.rows = rows;
	}
	public long getTotal() {
		return total;
	}
	public void setTotal(long total) {
		this.total = total;
	}


	public long getNotice() {
		return notice;
	}


	public void setNotice(long notice) {
		this.notice = notice;
	}


	public List<Map<String, String>> getFooter() {
		return footer;
	}


	public void setFooter(List<Map<String, String>> footer) {
		this.footer = footer;
	}


	
	
	
	
}
