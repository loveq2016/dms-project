package dms.yijava.service.order;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.order.OrderDetailDao;
import dms.yijava.entity.flow.FlowRecord;
import dms.yijava.entity.order.Order;
import dms.yijava.entity.order.OrderDetail;


@Service
@Transactional
public class OrderDetailService {

	@Autowired
	private OrderDetailDao orderDetailDao;
	
	public JsonPage<OrderDetail> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return orderDetailDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
	public List<OrderDetail> getList(List<PropertyFilter> filters){
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return orderDetailDao.find(parameters);
	}
	
	public OrderDetail getEntity(String id) {
		return orderDetailDao.get(id);
	}
	
	public void saveEntity(OrderDetail entity) {
		orderDetailDao.insert(entity);
	}
	
	public void removeEntity(String id) {
		orderDetailDao.removeById(id);
	}
	public void removeByOrderCodeEntity(String id) {
		orderDetailDao.removeObject(".deleteByOrderCode",id);
	}
	public OrderDetail getOrderDetail(OrderDetail entity) {
		OrderDetail order=orderDetailDao.getObject(".selectOrderDetail",entity);
		return order;
	}
}
