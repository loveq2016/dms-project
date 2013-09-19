package dms.yijava.service.notice;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.notice.NoticeLevelDao;
import dms.yijava.entity.notice.NoticeLevel;

@Service
@Transactional
public class NoticeLevelService {

	@Autowired
	private NoticeLevelDao noticeLevelDao;

	public List<NoticeLevel> getList(){
		HashMap<String,String> parameters = new HashMap<String,String>();
		return noticeLevelDao.find(parameters);
	}

}
