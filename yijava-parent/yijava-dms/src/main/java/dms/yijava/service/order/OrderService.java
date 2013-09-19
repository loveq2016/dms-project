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

import dms.yijava.dao.order.OrderDao;
import dms.yijava.entity.flow.FlowRecord;
import dms.yijava.entity.order.Order;
import dms.yijava.entity.system.SysUser;


@Service
@Transactional
public class OrderService {

	@Autowired
	private OrderDao orderDao;
	
	public JsonPage<Order> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return orderDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
	public List<Order> getList(){
		HashMap<String,String> parameters = new HashMap<String,String>();
		return orderDao.find(parameters);
	}

	public Order getEntity(String id) {
		return orderDao.get(id);
	}
	
	public void saveEntity(Order entity) {
		orderDao.insert(entity);
	}
	public void updateAddress(Order entity) {
		orderDao.updateObject(".updateAddress",entity);
	}
	public void updateStatus(Order entity) {
		orderDao.updateObject(".updateStatus",entity);
	}
	public void updateMoneyNum(Order entity) {
		orderDao.updateObject(".updateMoneyNum",entity);
	}
	public void removeEntity(Order entity) {
		orderDao.remove( entity);
	}
	public Order getOrderNum() {
		return orderDao.getObject(".selectOrderNum",null);
	}
}
