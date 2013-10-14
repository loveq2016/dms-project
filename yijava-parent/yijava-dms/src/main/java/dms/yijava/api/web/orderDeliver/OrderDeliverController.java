package dms.yijava.api.web.orderDeliver;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
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
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.deliver.DeliverExpressDetailService;
import dms.yijava.service.deliver.DeliverExpressSnService;
import dms.yijava.service.order.OrderService;
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
	@Autowired
	private OrderService orderService;
	
	

	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<OrderDeliver> paging(PageRequest pageRequest,
			HttpServletRequest request) {
		
		//zhjt2013年1013日修改
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		String currentUserId=sysUser.getId();
		List<PropertyFilter> filters = PropertyFilters.build(request);
		if(null!=sysUser){
			//经销商
			if(!StringUtils.equals("0",sysUser.getFk_dealer_id())){
				filters.add(PropertyFilters.build("ANDS_dealer_id",sysUser.getFk_dealer_id()));
			}else if(StringUtils.isNotEmpty(sysUser.getTeams())){
				filters.add(PropertyFilters.build("ANDS_dealer_ids", this.listString(sysUser.getUserDealerList())));
				filters.add(PropertyFilters.build("ANDS_statuses","0,1"));				
			}
			
		}
		return orderDeliverService.paging(pageRequest, filters);
	}
	
	/**
	 * 把一个list转换为String返回过去
	 */
	public String listString(List<UserDealer> list) {
		String listString = "";
		for (int i = 0; i < list.size(); i++) {
			try {
				if (i == list.size() - 1) {
					UserDealer ud=list.get(i);
					listString += ud.getDealer_id();
				} else {
					UserDealer ud=list.get(i);
					listString += ud.getDealer_id() + ",";
				}
			} catch (Exception e) {
			}
		}
		return listString;
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
					if ("4".equals(orderDeliver.getDeliver_status())) {//全部发货
						orderService.updateStatusByOrderCode(orderDeliver.getOrder_code(), "6");
					}
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
