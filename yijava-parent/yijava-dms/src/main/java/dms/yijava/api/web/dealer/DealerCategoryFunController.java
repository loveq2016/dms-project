package dms.yijava.api.web.dealer;

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

import dms.yijava.entity.dealer.DealerCategoryFun;
import dms.yijava.service.dealer.DealerCategoryFunService;

@Controller
@RequestMapping("/api/dealerCategoryFun")
public class DealerCategoryFunController {
	

	@Autowired
	private DealerCategoryFunService dealerCategoryFunService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<DealerCategoryFun> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return dealerCategoryFunService.paging(pageRequest,filters);
	}
	
	
	@ResponseBody
	@RequestMapping("update")
	public Result<String> update(@ModelAttribute("entity") DealerCategoryFun entity) {
		dealerCategoryFunService.updateEntity(entity);
		return new Result<String>(entity.getDealer_id(), 1);
	}
	
	
	
	
}
