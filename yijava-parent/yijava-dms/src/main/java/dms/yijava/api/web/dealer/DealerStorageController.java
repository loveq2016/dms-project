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

import dms.yijava.entity.dealer.DealerStorage;
import dms.yijava.service.dealer.DealerStorageService;

@Controller
@RequestMapping("/api/dealerStorage")
public class DealerStorageController {
	

	@Autowired
	private DealerStorageService dealerStorageService;
	

	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<DealerStorage> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return dealerStorageService.paging(pageRequest,filters);
	}
	
	
	@ResponseBody
	@RequestMapping("list")
	public List<DealerStorage> list(@RequestParam(value = "dealer_id", required = false) String dealer_id) {
		return dealerStorageService.getList(dealer_id);
	}
	
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") DealerStorage entity) {
		dealerStorageService.saveEntity(entity);
		return new Result<String>(entity.getDealer_id(), 1);
	}
	
	
	@ResponseBody
	@RequestMapping("update")
	public Result<String> update(@ModelAttribute("entity") DealerStorage entity) {
		dealerStorageService.updateEntity(entity);
		return new Result<String>(entity.getDealer_id(), 1);
	}
	
	
	@ResponseBody
	@RequestMapping("delete")
	public Result<String> delete(@RequestParam(value = "id", required = true) String id) {
		dealerStorageService.deleteEntity(id);
		return new Result<String>(id, 1);
	}
	
	
	
}
