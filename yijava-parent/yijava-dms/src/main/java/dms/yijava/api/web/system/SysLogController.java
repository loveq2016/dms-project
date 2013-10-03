package dms.yijava.api.web.system;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;

import dms.yijava.entity.system.SysLog;
import dms.yijava.service.system.SysLogService;

@Controller
@RequestMapping("/api/syslog")
public class SysLogController {
	private static final Logger logger = LoggerFactory.getLogger(SysLogController.class);
	@Autowired
	public SysLogService sysLogService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<SysLog> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return sysLogService.paging(pageRequest,filters);
	}
}
