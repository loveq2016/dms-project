package dms.yijava.api.web.notice;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import dms.yijava.entity.notice.NoticeStatus;
import dms.yijava.service.notice.NoticeStatusService;

@Controller
@RequestMapping("/api/noticeStatus")
public class NoticeStatusController {

	@Autowired
	private NoticeStatusService noticeStatusService;

	@ResponseBody
	@RequestMapping("list")
	public List<NoticeStatus> list() {
		return noticeStatusService.getList();
	}

}
