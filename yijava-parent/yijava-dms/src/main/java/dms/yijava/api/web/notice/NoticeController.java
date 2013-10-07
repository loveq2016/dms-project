package dms.yijava.api.web.notice;

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

import dms.yijava.entity.notice.Notice;
import dms.yijava.entity.system.SysUser;
import dms.yijava.service.notice.NoticeService;

@Controller
@RequestMapping("/api/notice")
public class NoticeController {
	
	@Autowired
	private NoticeService noticeService;
	
	@ResponseBody
	@RequestMapping("categoryList")
	public List<Notice> list(@RequestParam(value = "id", required = true) String id) {
		return noticeService.getList(id);
	}
	

	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<Notice> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
//		filters.add(PropertyFilters.build("ANDS_dealer_id", "3"));
		return noticeService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") Notice entity,HttpServletRequest request) {
		try {
			SysUser sysUser = (SysUser) request.getSession().getAttribute("user"); // 当前用户信息
			entity.setUser_id(sysUser.getId());
			noticeService.saveEntity(entity);
			return new Result<String>(entity.getNotice_id(), 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getNotice_id(), 0);
	}
	
	@ResponseBody
	@RequestMapping("update")
	public Result<String> update(@ModelAttribute("entity") Notice entity,HttpServletRequest request) {
		try {
			SysUser sysUser = (SysUser) request.getSession().getAttribute("user"); // 当前用户信息
			entity.setUser_id(sysUser.getId());
			noticeService.updateEntity(entity);
			return new Result<String>(entity.getNotice_id(), 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getNotice_id(), 0);
	}
	
}
