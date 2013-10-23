package dms.yijava.task;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import dms.yijava.service.key.LoginKeyGenService;

@Component
public class SystemTasker {

	private static final Logger logger = LoggerFactory
			.getLogger(SystemTasker.class);
	
	@Autowired
	private LoginKeyGenService loginKeyGenService;
	
	public void clearTasks()
	{
		logger.debug("clearTasks run start ...");
		loginKeyGenService.clearKeyGen();
		logger.debug("clearTasks run end ...");
	}
}
