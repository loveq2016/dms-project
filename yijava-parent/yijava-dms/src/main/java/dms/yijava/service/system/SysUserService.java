package dms.yijava.service.system;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.system.SysUserDao;

@Service
@Transactional
public class SysUserService {
	@Autowired
	public SysUserDao sysUserDao;
	
}
