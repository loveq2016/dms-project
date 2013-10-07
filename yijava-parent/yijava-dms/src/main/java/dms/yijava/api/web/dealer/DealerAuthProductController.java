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

import dms.yijava.entity.dealer.DealerAuthProduct;
import dms.yijava.service.dealer.DealerAuthProductService;

@Controller
@RequestMapping("/api/dealerAuthProduct")
public class DealerAuthProductController {
	

	@Autowired
	private DealerAuthProductService dealerAuthProductService;
	

	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<DealerAuthProduct> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return dealerAuthProductService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("list")
	public List<DealerAuthProduct> list(
			@RequestParam(value = "dealer_id", required = false) String dealer_id) {
		return dealerAuthProductService.getList(dealer_id);
	}
	
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") DealerAuthProduct entity) {
		try {
			dealerAuthProductService.saveEntity(entity);
			return new Result<String>(entity.getDealer_id(), 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getDealer_id(), 0);
	}
	
	
	@ResponseBody
	@RequestMapping("update")
	public Result<String> update(@ModelAttribute("entity") DealerAuthProduct entity) {
		try {
			dealerAuthProductService.updateEntity(entity);
			return new Result<String>(entity.getDealer_id(), 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getDealer_id(), 0);
		
	}
	
	
	@ResponseBody
	@RequestMapping("delete")
	public Result<String> delete(@RequestParam(value = "id", required = true) String id) {
		try {
			dealerAuthProductService.deleteEntity(id);
			return new Result<String>(id, 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(id, 0);
	}
	
	
	
}
