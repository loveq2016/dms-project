package dms.yijava.service.pullstorage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.pullstorage.PullStorageDetailDao;
@Service
@Transactional
public class PullStorageDetailService{

	@Autowired
	private PullStorageDetailDao pullStorageDetailDao;
}
