package dms.yijava.api.web.orderDeliver;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.Result;

import dms.yijava.entity.deliver.DeliverExpressDetail;
import dms.yijava.entity.deliver.DeliverExpressSn;
import dms.yijava.entity.orderDeliver.OrderDeliver;
import dms.yijava.service.deliver.DeliverExpressDetailService;
import dms.yijava.service.deliver.DeliverExpressSnService;
import dms.yijava.service.orderDeliver.OrderDeliverService;
import dms.yijava.service.storage.StorageDetailService;

@Controller
@RequestMapping("/api/orderDeliver")
public class OrderDeliverController {

	@Autowired
	private OrderDeliverService orderDeliverService;
	@Autowired
	private StorageDetailService storageDetailService;
	@Autowired
	private DeliverExpressDetailService deliverExpressDetailService;
	@Autowired
	private DeliverExpressSnService deliverExpressSnService;
	
	
	

	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<OrderDeliver> paging(PageRequest pageRequest,
			HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return orderDeliverService.paging(pageRequest, filters);
	}
	
	

	@ResponseBody
	@RequestMapping("consignee")
	public Result<String> consignee(
			@RequestParam(value = "deliver_code", required = true) String deliver_code,
			@RequestParam(value = "dealer_id", required = true) String dealer_id) {
		try {
			
			OrderDeliver orderDeliver = orderDeliverService.queryDeliverConsigneeStatus(deliver_code);
			if (orderDeliver != null) {
				List<DeliverExpressDetail> deliverExpressDetails =  deliverExpressDetailService.getList(deliver_code);
				List<DeliverExpressSn> deliverExpressSns = deliverExpressSnService.getList(deliver_code);
				if (deliverExpressDetails == null || deliverExpressSns == null)
					return new Result<String>(deliver_code, 0);
				boolean flag = storageDetailService.orderStorage(dealer_id,deliverExpressDetails,deliverExpressSns);
				if(flag){
					OrderDeliver entity = new OrderDeliver();
					entity.setDeliver_code(deliver_code);
					entity.setConsignee_user_id("1");
					orderDeliverService.submitConsignee(entity);
					return new Result<String>(deliver_code, 1);
				}
				return new Result<String>(deliver_code, 0);
			}
			return new Result<String>(deliver_code, 0);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(deliver_code, 0);
	}
	

}
