package dms.yijava.service.deliver;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.deliver.DeliverDao;

@Service
@Transactional
public class DeliverService {

	@Autowired
	private DeliverDao  deliverDao ;
	
	
	
		
}
