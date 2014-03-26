package dms.yijava.service.deliver;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.deliver.DeliverDetailDao;
import dms.yijava.entity.deliver.DeliverDetail;

@Service
@Transactional
public class DeliverDetailService {

	@Autowired
	private DeliverDetailDao  deliverDetailDao ;
	
	
	public JsonPage<DeliverDetail> paging(PageRequest pageRequest,
			List<PropertyFilter> filters) {
		Map<String, String> parameters = new HashMap<String, String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		
		JsonPage<DeliverDetail> detail = deliverDetailDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
		
		/*以下开始计算合计数量 **/
		int orderNumber=0,delverNumber=0;
		List <DeliverDetail> details = detail.getRows();
		
		
		
		for(DeliverDetail det : details){
			orderNumber+=Integer.parseInt(det.getOrder_number_sum());
			delverNumber+=Integer.parseInt(det.getDeliver_number_sum());
		}
		
		List<Map<String,String>> footer=new ArrayList<Map<String,String>>();
		Map<String,String> footMap = new HashMap<String,String>();
		footMap.put("product_name", "合计");
		footMap.put("order_number_sum", Integer.toString(orderNumber));
		footMap.put("deliver_number_sum", Integer.toString(delverNumber));
		footer.add(footMap);
		detail.setFooter(footer);
		return detail;
	}

	public List<DeliverDetail> getList(List<PropertyFilter> filters){
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return deliverDetailDao.find(parameters);
	}

		
}
