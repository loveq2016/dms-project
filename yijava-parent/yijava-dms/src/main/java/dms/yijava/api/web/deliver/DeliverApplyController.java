package dms.yijava.api.web.deliver;

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

import dms.yijava.entity.deliver.Deliver;
import dms.yijava.entity.deliver.DeliverDetail;
import dms.yijava.service.deliver.DeliverDetailService;
import dms.yijava.service.deliver.DeliverService;

@Controller
@RequestMapping("/api/deliverApply")
public class DeliverApplyController {
	
	@Autowired
	private DeliverService deliverService;
	@Autowired
	private DeliverDetailService deliverDetailService;


	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<Deliver> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return deliverService.paging(pageRequest,filters);
	}
	
	
	@ResponseBody
	@RequestMapping("detailList")
	public List<DeliverDetail> getList(HttpServletRequest request){
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return deliverDetailService.getList(filters);
	}
	
	
	@ResponseBody
	@RequestMapping("detailPaging")
	public JsonPage<DeliverDetail> detailPaging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return deliverDetailService.paging(pageRequest,filters);
	}
	
	
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") Deliver entity,@ModelAttribute("deliverDetail") DeliverDetail deliverDetail) {
		entity.setUser_id("13");
		try {
			deliverService.saveEntity(entity,deliverDetail);
			return new Result<String>(entity.getDeliver_id(), 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getDeliver_id(),0);
	}
	
	
	@ResponseBody
	@RequestMapping("update")
	public Result<String> update(@ModelAttribute("entity") Deliver entity,@ModelAttribute("deliverDetail") DeliverDetail deliverDetail) {
		entity.setUser_id("13");
		try {
			deliverService.updateEntity(entity,deliverDetail);
			return new Result<String>(entity.getDeliver_id(), 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getDeliver_id(),0);
	}
	
	
	@ResponseBody
	@RequestMapping("delete")
	public Result<String> delete(@RequestParam(value = "id", required = true) String id) {
		try {
			deliverService.deleteEntity(id);
			return new Result<String>(id, 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(id, 0);
	}
	
	
	@ResponseBody
	@RequestMapping("submit")
	public Result<String> submit(@RequestParam(value = "deliver_code", required = true) String deliver_code) {
		try {
			//deliverService.deleteEntity(id);
			deliverService.submitDeliver(deliver_code);
			return new Result<String>(deliver_code, 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(deliver_code, 0);
	}
	

	
}
