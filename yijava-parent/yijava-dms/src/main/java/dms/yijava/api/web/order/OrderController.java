package dms.yijava.api.web.order;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

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

import dms.yijava.entity.flow.FlowRecord;
import dms.yijava.entity.order.Order;
import dms.yijava.entity.system.SysUser;
import dms.yijava.service.order.OrderService;

@Controller
@RequestMapping("/api/order")
public class OrderController {

	@Autowired
	private OrderService orderService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<Order> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		JsonPage<Order> dsss=orderService.paging(pageRequest,filters);
		return dsss;
	}
	
	@ResponseBody
	@RequestMapping("list")
	public List<Order> getList(){
		return orderService.getList();
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<Integer> save(@ModelAttribute("entity") Order entity) {
		orderService.saveEntity(entity);
		return new Result<Integer>(1, 1);
	}
	
	@ResponseBody
	@RequestMapping("updateAddress")
	public Result<Integer> updateAddress(@ModelAttribute("entity") Order entity) {
		orderService.updateAddress(entity);
		return new Result<Integer>(1, 1);
	}
	@ResponseBody
	@RequestMapping("updateStatus")
	public Result<Integer> updateStatus(@ModelAttribute("entity") Order entity) {
		orderService.updateStatus(entity);
		return new Result<Integer>(1, 1);
	}
	
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(@ModelAttribute("entity") Order entity) {
		orderService.removeEntity(entity);
		return new Result<Integer>(1, 1);
	}
}
