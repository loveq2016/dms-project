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

import dms.yijava.entity.dealer.DealerAddress;
import dms.yijava.service.dealer.DealerAddressService;

@Controller
@RequestMapping("/api/dealerAddress")
public class DealerAddressController {
	

	@Autowired
	private DealerAddressService dealerAddressService;
	

	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<DealerAddress> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return dealerAddressService.paging(pageRequest,filters);
	}
	
	
	@ResponseBody
	@RequestMapping("list")
	public List<DealerAddress> getList(@RequestParam(value = "id", required = true) String id){
		return dealerAddressService.getList(id);
	}

	
	@ResponseBody
	@RequestMapping("entity")
	public DealerAddress entity(@RequestParam(value = "id", required = true) String id) {
		return dealerAddressService.getEntity(id);
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") DealerAddress entity) {
		try {
			dealerAddressService.saveEntity(entity);
			return new Result<String>(entity.getId(), 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getId(), 0);
	}
	
	
	@ResponseBody
	@RequestMapping("update")
	public Result<String> update(@ModelAttribute("entity") DealerAddress entity) {
		try {
			dealerAddressService.updateEntity(entity);
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
			dealerAddressService.deleteEntity(id);
			return new Result<String>(id, 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(id, 0);
	}
	
	
	
}
