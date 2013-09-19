package dms.yijava.api.web.dealer;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;

import dms.yijava.entity.dealer.DealerCategory;
import dms.yijava.service.dealer.DealerCategoryService;

@Controller
@RequestMapping("/api/dealerCategory")
public class DealerCategoryController {
	

	@Autowired
	private DealerCategoryService dealerCategoryService;
	
	@ResponseBody
	@RequestMapping("list")
	public List<DealerCategory> list() {
		return dealerCategoryService.getList();
	}
	
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<DealerCategory> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return dealerCategoryService.paging(pageRequest,filters);
	}
	
}
