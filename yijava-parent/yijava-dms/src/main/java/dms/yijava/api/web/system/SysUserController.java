package dms.yijava.api.web.system;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.helpers.MessageFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.Result;

import dms.yijava.entity.system.SysUser;
import dms.yijava.service.system.SysUserService;

@Controller
@RequestMapping("/api/sysuser")
public class SysUserController {
	private static final Logger logger = LoggerFactory.getLogger(SysUserController.class);
	@Autowired
	public SysUserService sysUserService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<SysUser> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		logger.info("查询用户信息");
		return sysUserService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("read")
	public SysUser read(@RequestParam(value = "id", required = false) String id) {
		SysUser sysUser=sysUserService.getEntity(id);
		return sysUser;
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") SysUser entity) {
		sysUserService.saveEntity(entity);
		logger.info("保存用户信息");
		return new Result<String>(entity.getId(), 1);
	}
	
	@ResponseBody
	@RequestMapping("update")
	public Result<String> update(@ModelAttribute("entity") SysUser entity) {
		sysUserService.updateEntity(entity);
		logger.info("修改用户信息");
		return new Result<String>(entity.getId(), 1);
	}
	
	@ResponseBody
	@RequestMapping("remove")
	public Result<String> remove(@RequestParam(value = "id", required = false) String id) {
		sysUserService.deleteEntity(id);
		logger.info("删除用户信息");
		return new Result<String>(id, 1);
	}
}
