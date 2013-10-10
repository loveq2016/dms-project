package dms.yijava.api.web.notice;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.Result;

import dms.yijava.entity.notice.NoticeDealer;
import dms.yijava.entity.system.SysUser;
import dms.yijava.service.notice.NoticeDealerService;

@Controller
@RequestMapping("/api/noticeDealer")
public class NoticeDealerController {
	
	@Autowired
	private NoticeDealerService noticeDealerService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<NoticeDealer> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return noticeDealerService.paging(pageRequest,filters);
	}
	
	
	@ResponseBody
	@RequestMapping("update")
	public Result<String> update(@RequestParam(value = "id", required = true) String id,HttpServletRequest request) {
		try {
				SysUser sysUser = (SysUser) request.getSession().getAttribute("user"); // 当前用户信息
				NoticeDealer entity = new NoticeDealer();
				entity.setDealer_id(sysUser.getFk_dealer_id());
				entity.setNotice_id(id);
				noticeDealerService.updateEntity(entity);
				return new Result<String>(id, 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(id, 0);
	}
	
}
