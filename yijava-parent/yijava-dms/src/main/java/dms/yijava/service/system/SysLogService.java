package dms.yijava.service.system;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.system.SysLogDao;
@Service
@Transactional
public class SysLogService {
	@Autowired
	public SysLogDao sysLogDao;
}
