package dms.yijava.service.notice;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.notice.NoticeStatusDao;
import dms.yijava.entity.notice.NoticeStatus;

@Service
@Transactional
public class NoticeStatusService {

	@Autowired
	private NoticeStatusDao noticeStatusDao;

	public List<NoticeStatus> getList(){
		HashMap<String,String> parameters = new HashMap<String,String>();
		return noticeStatusDao.find(parameters);
	}

}
