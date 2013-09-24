package dms.yijava.service.deliver;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.deliver.DeliverDetailDao;

@Service
@Transactional
public class DeliverDetailService {

	@Autowired
	private DeliverDetailDao  deliverDetailDao ;
	


		
}
