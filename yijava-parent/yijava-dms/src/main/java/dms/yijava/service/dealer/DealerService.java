package dms.yijava.service.dealer;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.common.utils.DateUtils;
import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.dealer.DealerDao;
import dms.yijava.entity.dealer.Dealer;
import dms.yijava.entity.dealer.DealerCategory;

@Service
@Transactional
public class DealerService {

	@Autowired
	private DealerDao dealerDao;
	
	
	public JsonPage<Dealer> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return dealerDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}

	
	public List<Dealer> getList(){
		HashMap<String,String> parameters = new HashMap<String,String>();
		return dealerDao.find(parameters);
	}
	
	
	public Dealer getEntity(String id) {
			return dealerDao.get(id);
	}
	
	
	public Dealer checkEntity(String id) {
		return dealerDao.getObject(".checkdealer_code", id);
	}
	
	
	
	public void saveEntity(Dealer entity) {
		if (StringUtils.isBlank(entity.getSettlement_time())) {
			entity.setSettlement_time(DateUtils.format(new Date(),"yyyy-MM-dd"));
		}
		if (StringUtils.isBlank(entity.getFound_time())) {
			entity.setFound_time(DateUtils.format(new Date(),"yyyy-MM-dd"));
		}
		dealerDao.insert(entity);
	}
	
	public void updateEntity(Dealer entity) {
		if (StringUtils.isBlank(entity.getSettlement_time())) {
			entity.setSettlement_time(DateUtils.format(new Date(),"yyyy-MM-dd"));
		}
		if (StringUtils.isBlank(entity.getFound_time())) {
			entity.setFound_time(DateUtils.format(new Date(),"yyyy-MM-dd"));
		}
		try{
			dealerDao.update( entity);
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}
	
	public void deleteEntity(String id) {
		dealerDao.remove(id);
	}
		

	
	
}
