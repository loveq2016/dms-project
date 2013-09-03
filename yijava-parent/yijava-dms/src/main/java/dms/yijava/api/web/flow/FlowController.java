package dms.yijava.api.web.flow;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.common.utils.DateUtils;
import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.Result;

import dms.yijava.entity.flow.Flow;
import dms.yijava.service.flow.FlowService;

@Controller
@RequestMapping("/api/flow")
public class FlowController {

	
	@Autowired
	private FlowService flowService;
	

	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<Flow> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return flowService.paging(pageRequest,filters);
	}
	
	
	@ResponseBody
	@RequestMapping("save")
	public Result<Integer> save(@ModelAttribute("entity") Flow entity) {
		if(StringUtils.isBlank(entity.getAdd_date()))
		{
			entity.setAdd_date(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		}
			
		flowService.saveEntity(entity);
		return new Result<Integer>(1, 1);
	}
	
	@ResponseBody
	@RequestMapping("update")
	public Result<Integer> update(@ModelAttribute("entity") Flow entity) {
		if(StringUtils.isBlank(entity.getMody_date()))
		{
			entity.setMody_date(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		}
		flowService.updateEntity(entity);
		return new Result<Integer>(1, 1);
	}
	
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(@ModelAttribute("entity") Flow entity) {
		if(StringUtils.isBlank(entity.getDel_date()))
		{
			entity.setDel_date(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		}
		//并不去真正删除，只是标志
		entity.setDel_sign(1);
		flowService.removeEntity(entity);
		return new Result<Integer>(1, 1);
	}
}
