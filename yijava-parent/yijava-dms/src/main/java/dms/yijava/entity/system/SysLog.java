package dms.yijava.entity.system;

public class SysLog {
	public String event_id;
	public String timestmp;
	public String formatted_message;
	public String logger_name;
	public String level_string;
	public String thread_name;
	public String reference_flag;
	public String arg0;
	public String arg1;
	public String arg2;
	public String arg3;
	public String caller_filename;
	public String caller_class;
	public String caller_method;
	public String caller_line;
	public String hostname;
	public String operatorip;
	public String account;
	
	public String getHostname() {
		return hostname;
	}
	public void setHostname(String hostname) {
		this.hostname = hostname;
	}
	public String getOperatorip() {
		return operatorip;
	}
	public void setOperatorip(String operatorip) {
		this.operatorip = operatorip;
	}
	public String getAccount() {
		return account;
	}
	public void setAccount(String account) {
		this.account = account;
	}
	public String getEvent_id() {
		return event_id;
	}
	public void setEvent_id(String event_id) {
		this.event_id = event_id;
	}
	public String getTimestmp() {
		return timestmp;
	}
	public void setTimestmp(String timestmp) {
		this.timestmp = timestmp;
	}
	public String getFormatted_message() {
		return formatted_message;
	}
	public void setFormatted_message(String formatted_message) {
		this.formatted_message = formatted_message;
	}
	public String getLogger_name() {
		return logger_name;
	}
	public void setLogger_name(String logger_name) {
		this.logger_name = logger_name;
	}
	public String getLevel_string() {
		return level_string;
	}
	public void setLevel_string(String level_string) {
		this.level_string = level_string;
	}
	public String getThread_name() {
		return thread_name;
	}
	public void setThread_name(String thread_name) {
		this.thread_name = thread_name;
	}
	public String getReference_flag() {
		return reference_flag;
	}
	public void setReference_flag(String reference_flag) {
		this.reference_flag = reference_flag;
	}
	public String getArg0() {
		return arg0;
	}
	public void setArg0(String arg0) {
		this.arg0 = arg0;
	}
	public String getArg1() {
		return arg1;
	}
	public void setArg1(String arg1) {
		this.arg1 = arg1;
	}
	public String getArg2() {
		return arg2;
	}
	public void setArg2(String arg2) {
		this.arg2 = arg2;
	}
	public String getArg3() {
		return arg3;
	}
	public void setArg3(String arg3) {
		this.arg3 = arg3;
	}
	public String getCaller_filename() {
		return caller_filename;
	}
	public void setCaller_filename(String caller_filename) {
		this.caller_filename = caller_filename;
	}
	public String getCaller_class() {
		return caller_class;
	}
	public void setCaller_class(String caller_class) {
		this.caller_class = caller_class;
	}
	public String getCaller_method() {
		return caller_method;
	}
	public void setCaller_method(String caller_method) {
		this.caller_method = caller_method;
	}
	public String getCaller_line() {
		return caller_line;
	}
	public void setCaller_line(String caller_line) {
		this.caller_line = caller_line;
	}
}
