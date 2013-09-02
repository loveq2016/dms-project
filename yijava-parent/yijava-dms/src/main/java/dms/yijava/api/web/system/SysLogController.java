package dms.yijava.api.web.system;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import dms.yijava.service.system.SysLogService;

@Controller
@RequestMapping("/sys/log")
public class SysLogController {
	@Autowired
	public SysLogService sysLogService;
	
}
