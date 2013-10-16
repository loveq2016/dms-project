package dms.yijava.api.web.order;

import java.text.DecimalFormat;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.Result;

import dms.yijava.entity.order.Order;
import dms.yijava.entity.order.OrderDetail;
import dms.yijava.service.order.OrderDetailService;
import dms.yijava.service.order.OrderService;

@Controller
@RequestMapping("/api/orderdetail")
public class OrderDetailController {

	@Autowired
	private OrderDetailService orderDetailService;
	
	@Autowired
	private OrderService orderService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<OrderDetail> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return orderDetailService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("list")
	public List<OrderDetail> getList(HttpServletRequest request){
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return orderDetailService.getList(filters);
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<Integer> save(@ModelAttribute("entity") OrderDetail entity) {
        DecimalFormat df = new DecimalFormat("#.00");
		if(StringUtils.isEmpty(entity.getDiscount()))
			entity.setDiscount(entity.getOrder_price());
		double discount=(double) (Double.parseDouble(entity.getDiscount()));
		double m=Integer.parseInt(entity.getOrder_number_sum())*discount;
		entity.setOrder_money_sum(df.format(m));
		//OrderDetail d=orderDetailService.getOrderDetail(entity);
		//if(d==null){
			orderDetailService.saveEntity(entity);
			//修改订单总数，共计
			Order moneyAndNumberObj=orderService.getOrderDetailMoneyAndNumber(entity.getOrder_code());
			orderService.updateMoneyNum(moneyAndNumberObj);
			return new Result<Integer>(1, 1);
		//}else{
			//return new Result<Integer>(1, 2);
		//}
	}
	
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(@RequestParam(value = "oc", required = false) String oc,
			@RequestParam(value = "id", required = false) String id) {
		orderDetailService.removeEntity(id);
		//修改订单总数，共计等
		Order moneyAndNumberObj=orderService.getOrderDetailMoneyAndNumber(oc);
		if(null==moneyAndNumberObj){
			moneyAndNumberObj=new Order();
			moneyAndNumberObj.setOrder_code(oc);
			moneyAndNumberObj.setOrder_money_sum("0");
			moneyAndNumberObj.setOrder_number_sum("0");
		}
		orderService.updateMoneyNum(moneyAndNumberObj);
		return new Result<Integer>(1, 1);
	}
}
