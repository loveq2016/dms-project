package dms.yijava.api.web.order;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.Result;

import dms.yijava.entity.order.Order;
import dms.yijava.entity.order.OrderDetail;
import dms.yijava.service.order.OrderDetailService;

@Controller
@RequestMapping("/api/orderdetail")
public class OrderDetailController {

	@Autowired
	private OrderDetailService orderDetailService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<OrderDetail> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return orderDetailService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("list")
	public List<OrderDetail> getList(){
		return orderDetailService.getList();
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<Integer> save(@ModelAttribute("entity") OrderDetail entity) {
		orderDetailService.saveEntity(entity);
		return new Result<Integer>(1, 1);
	}
	
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(@ModelAttribute("entity") OrderDetail entity) {
		orderDetailService.removeEntity(entity);
		return new Result<Integer>(1, 1);
	}
}
