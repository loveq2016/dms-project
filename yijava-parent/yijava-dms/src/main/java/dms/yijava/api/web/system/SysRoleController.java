package dms.yijava.api.web.system;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

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

import dms.yijava.entity.system.SysRole;
import dms.yijava.service.system.SysRoleService;
@Controller
@RequestMapping("/api/sysrole")
public class SysRoleController {
	@Autowired
	public SysRoleService sysRoleService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<SysRole> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return sysRoleService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("read")
	public SysRole read(@RequestParam(value = "id", required = false) String id) {
		SysRole sysRole=sysRoleService.getEntity(id);
		return sysRole;
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") SysRole entity) {
		sysRoleService.saveEntity(entity);
		return new Result<String>(entity.getId(), 1);
	}
	
	@ResponseBody
	@RequestMapping("update")
	public Result<String> update(@ModelAttribute("entity") SysRole entity) {
		sysRoleService.updateEntity(entity);
		return new Result<String>(entity.getId(), 1);
	}
	
	@ResponseBody
	@RequestMapping("remove")
	public Result<String> remove(@RequestParam(value = "id", required = false) String id) {
		sysRoleService.deleteEntity(id);
		return new Result<String>(id, 1);
	}
}
