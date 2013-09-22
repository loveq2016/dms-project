package dms.yijava.api.web.trial;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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

import dms.yijava.entity.flow.Step;
import dms.yijava.entity.trial.Trial;
import dms.yijava.service.flow.FlowBussService;
import dms.yijava.service.trial.TrialService;

@Controller
@RequestMapping("/api/trial")
public class TrialController {

	private static final Logger logger = LoggerFactory
			.getLogger(TrialController.class);
	
	
	@Autowired
	private TrialService trialService;

	@Autowired
	private FlowBussService flowBussService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<Trial> paging(PageRequest pageRequest,
			HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return trialService.paging(pageRequest, filters);
	}

	@ResponseBody
	@RequestMapping("save")
	public Result<Integer> save(@ModelAttribute("entity") Trial entity) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try {
			trialService.saveEntity(entity);
			
			///以下开始走流程处理
			processFlow();
			result.setData(1);
			result.setState(1);;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			logger.error("error" + e);
			//result.setError(error);
		}

		return result;
	}
	
	public void processFlow()
	{
		Step step=flowBussService.getFirstStep("3");
	}
	
	

	@ResponseBody
	@RequestMapping("update")
	public Result<Integer> update(@ModelAttribute("entity") Trial entity) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try {
			trialService.updateEntity(entity);
			result.setData(1);
			result.setState(1);;
		} catch (Exception e) {
			logger.error("error" + e);
		}
		return result;
	}
}
