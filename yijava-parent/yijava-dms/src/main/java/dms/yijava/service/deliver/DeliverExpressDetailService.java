package dms.yijava.service.deliver;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.deliver.DeliverExpressDetailDao;
import dms.yijava.entity.deliver.DeliverExpressDetail;

@Service
@Transactional
public class DeliverExpressDetailService {

	@Autowired
	private DeliverExpressDetailDao  deliverExpressDetailDao ;
	
	
	public JsonPage<DeliverExpressDetail> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return deliverExpressDetailDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}

	public DeliverExpressDetail selectSumById(String delivery_detail_id) {
		return deliverExpressDetailDao.getObject(".selectSumById", delivery_detail_id);
	}
	
	public DeliverExpressDetail selectSn(DeliverExpressDetail deliverExpressDetail) {
		return deliverExpressDetailDao.getObject(".selectSn", deliverExpressDetail);
	}
	
	
	public DeliverExpressDetail checkSn(String deliver_code) {
		return deliverExpressDetailDao.getObject(".checkSn", deliver_code);
	}
	
	public void saveEntity(DeliverExpressDetail entity) {
		deliverExpressDetailDao.insert(entity);
	}
	
	public void updateEntity(DeliverExpressDetail entity) {
		deliverExpressDetailDao.update(entity);
	}
	
	public void deleteEntity(String id) {
		deliverExpressDetailDao.removeById(id);
	}

		
}
