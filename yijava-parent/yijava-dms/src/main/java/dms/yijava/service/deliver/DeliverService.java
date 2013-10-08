package dms.yijava.service.deliver;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.deliver.DeliverDao;
import dms.yijava.dao.deliver.DeliverDetailDao;
import dms.yijava.dao.order.OrderDetailDao;
import dms.yijava.entity.deliver.Deliver;
import dms.yijava.entity.deliver.DeliverDetail;
import dms.yijava.entity.order.OrderDetail;

@Service
@Transactional
public class DeliverService {

	@Autowired
	private DeliverDao  deliverDao ;
	@Autowired
	private DeliverDetailDao  deliverDetailDao ;
	@Autowired
	private OrderDetailDao  orderDetailDao ;
	
	
	public JsonPage<Deliver> paging(PageRequest pageRequest,
			List<PropertyFilter> filters) {
		Map<String, String> parameters = new HashMap<String, String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return deliverDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
	
	public Deliver queryDeliverNo(){
		return deliverDao.getObject(".queryDeliverNo", null);
	}
	
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void saveEntity(Deliver entity,DeliverDetail deliverDetail) {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
		Deliver deliverNo = deliverDao.getObject(".queryDeliverNo", null);
		if(null== deliverNo || StringUtils.isBlank(deliverNo.getDeliver_no())){
			deliverNo = new Deliver();
			deliverNo.setDeliver_no("001");
		}
		if(StringUtils.isNotBlank(deliverNo.getDeliver_no())){
			entity.setDeliver_no(deliverNo.getDeliver_no());
			entity.setDeliver_code("TEST-"+formatter.format(new Date())+"-"+entity.getDeliver_no());
			deliverDao.insert(entity);
		}
		if(StringUtils.isNotBlank(entity.getDeliver_id())){
			Map<String,String> parameters = new HashMap<String,String>();
			parameters.put("order_code", entity.getOrder_code());
			List<OrderDetail> orderDetails = orderDetailDao.find(parameters);
			DeliverDetail tempDeliverDetail = null;
			String[] ids = deliverDetail.getIds().split(",");
			String[] deliver_number_sums = deliverDetail.getDeliver_number_sums().split(",");
			String[] deliver_dates = deliverDetail.getDeliver_dates().split(",");
			String[] arrival_dates = deliverDetail.getArrival_dates().split(",");
			String[] deliver_remarks = StringUtils.splitPreserveAllTokens(deliverDetail.getDeliver_remarks(), ",");
			if (deliver_remarks == null || deliver_remarks.length == 0)
				deliver_remarks = new String[ids.length];
			int i =0;
			for (String id : ids) {
				tempDeliverDetail = new DeliverDetail();
				for (OrderDetail orderDetail : orderDetails) {
					if(id.equals(orderDetail.getId())){
						tempDeliverDetail.setProduct_item_number(orderDetail.getProduct_item_number());
						tempDeliverDetail.setProduct_name(orderDetail.getProduct_name());
						tempDeliverDetail.setOrder_price(orderDetail.getOrder_price());
						tempDeliverDetail.setDiscount(orderDetail.getDiscount());
						tempDeliverDetail.setModels(orderDetail.getModels());
						tempDeliverDetail.setOrder_number_sum(orderDetail.getOrder_number_sum());
						break;
					}
				}
				tempDeliverDetail.setDeliver_id(entity.getDeliver_id());
				tempDeliverDetail.setDeliver_code(entity.getDeliver_code());
				tempDeliverDetail.setOrder_code(entity.getOrder_code());
				tempDeliverDetail.setOrder_detail_id(id);
				tempDeliverDetail.setDeliver_number_sum(deliver_number_sums[i]);
				tempDeliverDetail.setDeliver_date(deliver_dates[i]);
				tempDeliverDetail.setArrival_date(arrival_dates[i]);
				tempDeliverDetail.setDeliver_remark(deliver_remarks[i]);
				i++;
				deliverDetailDao.insert(tempDeliverDetail);
			}
		}
	}
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void updateEntity(Deliver entity,DeliverDetail deliverDetail) {
		if(StringUtils.isNotBlank(entity.getDeliver_id())){
			deliverDao.update(entity);
		}
		
		DeliverDetail tempDeliverDetail = null;
		String[] ids = deliverDetail.getIds().split(",");
		String[] deliver_number_sums = deliverDetail.getDeliver_number_sums().split(",");
		String[] deliver_dates = deliverDetail.getDeliver_dates().split(",");
		String[] arrival_dates = deliverDetail.getArrival_dates().split(",");
		String[] deliver_remarks = StringUtils.splitPreserveAllTokens(deliverDetail.getDeliver_remarks(), ",");
		if (deliver_remarks == null || deliver_remarks.length == 0)
			deliver_remarks = new String[ids.length];
		if (ids.length > 0) {
			int i =0;
			for (String id : ids) {
				if(StringUtils.isNotBlank(id)){
					tempDeliverDetail = new DeliverDetail();
					tempDeliverDetail.setDelivery_detail_id(id);
					tempDeliverDetail.setDeliver_number_sum(deliver_number_sums[i]);
					tempDeliverDetail.setDeliver_date(deliver_dates[i]);
					tempDeliverDetail.setArrival_date(arrival_dates[i]);
					tempDeliverDetail.setDeliver_remark(deliver_remarks[i]);
					deliverDetailDao.update(tempDeliverDetail);
					i++;
				}
			}
		}

		
		
		
	}
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void deleteEntity(String deliver_id) {
		deliverDao.removeById(deliver_id);
		deliverDetailDao.removeById(deliver_id);
	}
	
	
	public void submitExpress(Deliver entity){
		deliverDao.updateObject(".submitExpress", entity);
	}
	
	public void submitDeliver(String deliver_code){
		deliverDao.updateObject(".submitDeliver", deliver_code);
	}
	
		
}
