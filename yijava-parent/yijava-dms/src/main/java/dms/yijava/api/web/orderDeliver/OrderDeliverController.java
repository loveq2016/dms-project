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

import dms.yijava.entity.orderDeliver.OrderDeliver;
import dms.yijava.service.orderDeliver.OrderDeliverService;

@Controller
@RequestMapping("/api/orderDeliver")
public class OrderDeliverController {

	@Autowired
	private OrderDeliverService orderDeliverService;

	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<OrderDeliver> paging(PageRequest pageRequest,
			HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return orderDeliverService.paging(pageRequest, filters);
	}
	
	

	@ResponseBody
	@RequestMapping("consignee")
	public Result<String> consignee(@RequestParam(value = "deliver_code", required = true) String deliver_code) {
		try {
			System.out.println(deliver_code);
			
			OrderDeliver entity = new OrderDeliver();
			entity.setDeliver_code(deliver_code);
			entity.setConsignee_user_id("1");
			orderDeliverService.submitConsignee(entity);
			
			
			return new Result<String>(deliver_code, 1);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(deliver_code, 0);
	}
	

}
