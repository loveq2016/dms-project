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

import dms.yijava.entity.dealer.DealerAuthHospital;
import dms.yijava.entity.system.SysUser;
import dms.yijava.service.dealer.DealerAuthHospitalService;

@Controller
@RequestMapping("/api/dealerAuthHospital")
public class DealerAuthHospitalController {
	

	@Autowired
	private DealerAuthHospitalService dealerAuthHospitalService;
	

	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<DealerAuthHospital> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return dealerAuthHospitalService.paging(pageRequest,filters);
	}
	
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") DealerAuthHospital entity) {
		try {
			dealerAuthHospitalService.saveEntity(entity);
			return new Result<String>(entity.getDealer_id(), 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getDealer_id(), 0);
	}
	
	
	@ResponseBody
	@RequestMapping("update")
	public Result<String> update(@ModelAttribute("entity") DealerAuthHospital entity) {
		try {
			dealerAuthHospitalService.updateEntity(entity);
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
			dealerAuthHospitalService.deleteEntity(id);
			return new Result<String>(id, 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(id, 0);
	}
	
	@ResponseBody
	@RequestMapping("deleteAll")
	public Result<String> deleteAll(@ModelAttribute("entity") DealerAuthHospital entity) {
		try {
			dealerAuthHospitalService.deleteAllEntity(entity);
			return new Result<String>("1", 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>("1", 0);
	}
	@ResponseBody
	@RequestMapping("list")
	public List<DealerAuthHospital> getList(HttpServletRequest request){
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		List<PropertyFilter> filters = PropertyFilters.build(request);
		filters.add(PropertyFilters.build("ANDS_dealer_id",sysUser.getFk_dealer_id()));
		return dealerAuthHospitalService.getList(filters);
	}
}
