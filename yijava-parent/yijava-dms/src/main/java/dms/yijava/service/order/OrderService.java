package dms.yijava.service.order;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
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
import dms.yijava.entity.order.Order;


@Service
@Transactional
public class OrderService {

	@Autowired
	private OrderDao orderDao;
	
	public JsonPage<Order> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Map<String,String> parameters = new HashMap<String,String>();
		try{
			for (PropertyFilter propertyFilter : filters) {
				String propertyKey = propertyFilter.getPropertyNames()[0];
				String propertyValue = propertyFilter.getMatchValue();
				String hhmmss="";
				if(propertyKey.equals("start_date") || propertyKey.equals("end_date")){
					if(propertyKey.equals("start_date")&&
							!"".equals(propertyValue))
						hhmmss=" 00:00:00";
					if(propertyKey.equals("end_date")&&
							!"".equals(propertyValue))
						hhmmss=" 23:59:59";
					propertyValue=propertyValue + hhmmss;
				}
				parameters.put(propertyKey, propertyValue);
			}
		}catch(Exception ex){}
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
	public void updateStatus(String order_id,String status) {
		Order entity =new Order();
		entity.setId(order_id);
		entity.setOrder_status(status);
		orderDao.updateObject(".updateStatus",entity);
	}
	public void updateMoneyNum(Order entity) {
		orderDao.updateObject(".updateMoneyNum",entity);
	}
	public void removeEntity(String id) {
		orderDao.removeById(id);
	}
	public Order getOrderNum(String dear_id) {
		Order order=orderDao.getObject(".selectOrderNum",dear_id);
		if(null==order || null==order.getOrder_no() || order.getOrder_no().equals("")){
			order=new Order();
			order.setOrder_no("001");
		}
		return order;
	}
	public Order getOrderDetailMoneyAndNumber(String o) {
		return orderDao.getObject(".selectMoneyAndNumber", o);
	}
	
	public void submitExpress(Order entity) {
		orderDao.updateObject(".submitExpress",entity);
	}
}
