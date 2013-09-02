package dms.yijava.service.system;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.system.SysFunctionDao;
@Service
@Transactional
public class SysFunctionService {
	@Autowired
	public SysFunctionDao sysFunctionDao;
}
