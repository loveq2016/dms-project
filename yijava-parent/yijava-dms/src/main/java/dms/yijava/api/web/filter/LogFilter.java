package dms.yijava.api.web.filter;

import ch.qos.logback.classic.filter.LevelFilter;
import ch.qos.logback.classic.spi.ILoggingEvent;
import ch.qos.logback.classic.spi.LoggingEvent;
import ch.qos.logback.core.spi.FilterReply;

public class LogFilter extends LevelFilter {
	@Override
	public FilterReply decide(ILoggingEvent event) {
	    LoggingEvent even2t = (LoggingEvent)event;  

		 if (String.valueOf(event.getLevel()).equalsIgnoreCase("INFO") && 
				 event.getLoggerName().contains("dms.yijava.api.web.")) {
		     return FilterReply.ACCEPT;
		 }else {
		     return FilterReply.DENY;
		 }
	}
}
