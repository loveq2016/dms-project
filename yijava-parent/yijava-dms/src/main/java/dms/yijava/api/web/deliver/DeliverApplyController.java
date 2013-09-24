package dms.yijava.api.web.deliver;

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
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") Deliver entity,@ModelAttribute("deliverDetail") DeliverDetail deliverDetail) {
		entity.setUser_id("13");
		try {
			deliverService.saveEntity(entity,deliverDetail);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getDeliver_id(), 1);
	}
	

	
}
