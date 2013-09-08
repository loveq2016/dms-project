package dms.yijava.api.web.dealer;

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

import dms.yijava.entity.dealer.DealerPlan;
import dms.yijava.service.dealer.DealerPlanService;

@Controller
@RequestMapping("/api/dealerPlan")
public class DealerPlanController {
	

	@Autowired
	private DealerPlanService dealerPlanService;
	

	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<DealerPlan> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return dealerPlanService.paging(pageRequest,filters);
	}
	
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") DealerPlan entity) {
		
		int c = 0;
		DealerPlan checkDealerYear = dealerPlanService.checkEntity(entity);
		if (null == checkDealerYear) {
			dealerPlanService.saveEntity(entity);
			c = 1;
		}else{
			c = 2;
		}
		return new Result<String>(entity.getDealer_id(), c);
	}
	
	
	@ResponseBody
	@RequestMapping("update")
	public Result<String> update(@ModelAttribute("entity") DealerPlan entity) {
		dealerPlanService.updateEntity(entity);
		return new Result<String>(entity.getDealer_id(), 1);
	}
	
	
	@ResponseBody
	@RequestMapping("delete")
	public Result<String> delete(@RequestParam(value = "id", required = true) String id) {
		dealerPlanService.deleteEntity(id);
		return new Result<String>(id, 1);
	}
	
	
	
}
