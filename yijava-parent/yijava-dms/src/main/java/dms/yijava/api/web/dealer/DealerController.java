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

import dms.yijava.entity.dealer.Dealer;
import dms.yijava.service.dealer.DealerService;

@Controller
@RequestMapping("/api/dealer")
public class DealerController {
	

	@Autowired
	private DealerService dealerService;
	

	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<Dealer> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return dealerService.paging(pageRequest,filters);
	}
	
	
	@ResponseBody
	@RequestMapping("list")
	public List<Dealer> list() {
		return dealerService.getList();
	}
	
	
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") Dealer entity) {
		int c = 0;
		Dealer checkDealer = dealerService.checkEntity(entity.getDealer_code());
		if(null ==checkDealer){
			dealerService.saveEntity(entity);
			c = 1;
		}else{
			c = 2;
		}
		return new Result<String>(entity.getDealer_id(), c);
	}
	
	
	@ResponseBody
	@RequestMapping("update")
	public Result<String> update(@ModelAttribute("entity") Dealer entity) {
		int c = 0;
		Dealer checkDealer = dealerService.checkEntity(entity.getDealer_code());
		if(null !=checkDealer){
			if(entity.getDealer_id().equals(checkDealer.getDealer_id())){
				dealerService.updateEntity(entity);
				c = 1;
			}else{
				c = 2;
			}
		}else{
			dealerService.updateEntity(entity);
			c = 1;
		}
		return new Result<String>(entity.getDealer_id(), c);
	}
	
	
	@ResponseBody
	@RequestMapping("delete")
	public Result<String> delete(@RequestParam(value = "id", required = true) String id) {
		try {
			dealerService.deleteEntity(id);
			return new Result<String>(id, 1);
		} catch (Exception e) {
			// TODO: handle exception
		}
		return new Result<String>(id, 0);
	}
	
	
	
}
