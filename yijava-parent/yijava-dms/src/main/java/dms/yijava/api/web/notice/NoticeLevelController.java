package dms.yijava.api.web.notice;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import dms.yijava.entity.notice.NoticeLevel;
import dms.yijava.service.notice.NoticeLevelService;

@Controller
@RequestMapping("/api/noticeLevel")
public class NoticeLevelController {

	@Autowired
	private NoticeLevelService noticeLevelService;

	@ResponseBody
	@RequestMapping("list")
	public List<NoticeLevel> list() {
		return noticeLevelService.getList();
	}

}
