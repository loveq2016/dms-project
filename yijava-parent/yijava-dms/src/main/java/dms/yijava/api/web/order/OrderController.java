package dms.yijava.api.web.order;

import java.text.SimpleDateFormat;
import java.util.Date;
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
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.order.OrderDetailService;
import dms.yijava.service.order.OrderService;
import dms.yijava.service.teamlayou.UserLayouService;
import dms.yijava.service.user.UserDealerFunService;

@Controller
@RequestMapping("/api/order")
public class OrderController {

	@Autowired
	private OrderService orderService;
	@Autowired
	private OrderDetailService orderDetailService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<Order> paging(PageRequest pageRequest,HttpServletRequest request) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		List<PropertyFilter> filters = PropertyFilters.build(request);
		if(null!=sysUser){
			//经销商
			if(!StringUtils.equals("0",sysUser.getFk_dealer_id())){
				filters.add(PropertyFilters.build("ANDS_dealer_id",sysUser.getFk_dealer_id()));
			}else if(!StringUtils.equals("0",sysUser.getFk_department_id())){
				
				filters.add(PropertyFilters.build("ANDS_dealer_ids", this.listString(sysUser.getUserDealerList())));
			}
			return orderService.paging(pageRequest,filters);
		}
		return null;
	}
	
	@ResponseBody
	@RequestMapping("list")
	public List<Order> getList(){
		return orderService.getList();
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<Integer> save(@ModelAttribute("entity") Order entity,HttpServletRequest request) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
		//必须是经销商才可以添加订单
		if(StringUtils.isNotEmpty(sysUser.getFk_dealer_id())){
			Order order=orderService.getOrderNum(sysUser.getFk_dealer_id());
			entity.setOrder_code("JRKL-"+formatter.format(new Date())+"-"+order.getOrder_no());
			entity.setOrder_no(String.valueOf((Integer.parseInt(order.getOrder_no()))));
			entity.setDealer_name(sysUser.getDealer_name());
			entity.setDealer_id(sysUser.getFk_dealer_id());
			orderService.saveEntity(entity);
			return new Result<Integer>(1, 1);
		}else{
			return new Result<Integer>(1, 0);
		}
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
	public Result<Integer> remove(@RequestParam(value = "id", required = false) String id) {
		orderService.removeEntity(id);
		orderDetailService.removeByOrderCodeEntity(id);
		return new Result<Integer>(1, 1);
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
}