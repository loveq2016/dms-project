package dms.yijava.api.web.teamlayou;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.web.vo.Result;

import dms.yijava.entity.teamlayou.TeamLayou;
import dms.yijava.entity.teamlayou.UserLayou;
import dms.yijava.service.teamlayou.TeamLayouService;
import dms.yijava.service.teamlayou.UserLayouService;

@Controller
@RequestMapping("/api/teamlayou")
public class TeamLayouController {
	
	@Autowired
	private TeamLayouService teamLayouService;
	@Autowired
	private UserLayouService userLayouService;
	
	@ResponseBody
	@RequestMapping("listByParentId")
	public List<TeamLayou> listByparentId(@RequestParam(value = "id", required = false) String id) {
		id = StringUtils.isBlank(id) == true ? "-1" : id;
		return teamLayouService.getList(id);
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") TeamLayou entity) {
		teamLayouService.saveEntity(entity);
		return new Result<String>(entity.getId(), 1);
	}
	
	@ResponseBody
	@RequestMapping("saveuser")
	public Result<String> saveuser(@ModelAttribute("entity") UserLayou entity) {
		userLayouService.saveEntity(entity);
		return new Result<String>(entity.getId(), 1);
	}
	
	@ResponseBody
	@RequestMapping("update")
	public Result<String> update(@ModelAttribute("entity") TeamLayou entity) {
		teamLayouService.updateEntity(entity);
		return new Result<String>(entity.getId(), 1);
	}
	
	@ResponseBody
	@RequestMapping("delete")
	public Result<String> delete(@RequestParam(value = "id", required = true) String id) {
		teamLayouService.deleteEntity(id);
		return new Result<String>(id, 1);
	}
	
	@ResponseBody
	@RequestMapping("deluser")
	public Result<String> deleteuser(@RequestParam(value = "id", required = true) String id) {
		id=id.split("\\|")[1];
		userLayouService.deleteEntity(id);
		return new Result<String>(id,1);
	}
}
