package dms.yijava.service.dealer;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.dealer.DealerCategoryDao;
import dms.yijava.entity.dealer.DealerCategory;

@Service
@Transactional
public class DealerCategoryService {

	@Autowired
	private DealerCategoryDao  dealerCategoryDao ;
	
	
	public List<DealerCategory> getList(){
		HashMap<String,String> parameters = new HashMap<String,String>();
		return dealerCategoryDao.find(parameters);
	}
		
}
