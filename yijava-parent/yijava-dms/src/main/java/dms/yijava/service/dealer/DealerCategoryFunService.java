package dms.yijava.service.dealer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.dealer.DealerCategoryFunDao;
import dms.yijava.entity.dealer.DealerCategoryFun;

@Service
@Transactional
public class DealerCategoryFunService {

	@Autowired
	private DealerCategoryFunDao  dealerCategoryFunDao ;
	
	
	public DealerCategoryFun getEntity(String id) {
		return dealerCategoryFunDao.get(id);
	}
	
	public void saveEntity(DealerCategoryFun entity) {
		dealerCategoryFunDao.insert(entity);
	}
	
	public void updateEntity(DealerCategoryFun entity) {
		dealerCategoryFunDao.update( entity);
	}
	

		

	
	
}
