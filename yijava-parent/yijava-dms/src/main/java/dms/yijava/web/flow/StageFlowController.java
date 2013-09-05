package dms.yijava.web.flow;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import dms.yijava.entity.flow.Flow;
import dms.yijava.service.flow.FlowService;

@Controller
@RequestMapping("/web/flow")
public class StageFlowController {

	@Autowired
	private FlowService flowService;
	
	@RequestMapping("view")
	public String view(String fow_id,HttpServletRequest request,HttpServletResponse response,
			Model model)
	{
		Flow folw=flowService.getEntity(fow_id);
		model.addAttribute("flow", folw);
		return "flow/viewdetail";
	}
}
