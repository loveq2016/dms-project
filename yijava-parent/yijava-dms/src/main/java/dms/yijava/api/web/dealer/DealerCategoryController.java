package dms.yijava.api.web.dealer;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

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
	
	

	
	
	
	
}
