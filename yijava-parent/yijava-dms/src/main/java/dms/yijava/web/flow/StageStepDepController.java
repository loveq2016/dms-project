package dms.yijava.web.flow;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import dms.yijava.entity.flow.Step;
import dms.yijava.service.flow.StepService;

@Controller
@RequestMapping("/web/flow/step_dep")
public class StageStepDepController {

	@Autowired
	private StepService stepService;
	
	@RequestMapping("view")
	public String view(String step_id,HttpServletRequest request,HttpServletResponse response,
			Model model)
	{
		/*Flow folw=flowService.getEntity(fow_id);
		model.addAttribute("flow", folw);*/
		
		Step step=stepService.getEntity(step_id);
		model.addAttribute("step", step);
		return "flow/viewdetail_dep";
	}
}
