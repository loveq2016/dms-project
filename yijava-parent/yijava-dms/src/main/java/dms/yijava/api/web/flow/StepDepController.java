package dms.yijava.api.web.flow;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.web.vo.Result;

import dms.yijava.api.web.model.flow.StepModel;
import dms.yijava.entity.flow.StepDepartment;
import dms.yijava.service.flow.StepDepartmentService;

@Controller
@RequestMapping("/api/step_dep")
public class StepDepController {
	
	private static final Logger logger = LoggerFactory.getLogger(StepDepController.class);
	
	@Autowired
	private StepDepartmentService stepDepartmentService;
	
	
	@ResponseBody
	@RequestMapping("view")
	public List<StepDepartment> view(String step_id,HttpServletRequest request) {		
		return stepDepartmentService.getStepDepartmentByStep(step_id);
	} 
	
	@ResponseBody
	@RequestMapping("save")
	public Result<Integer> save(@ModelAttribute("entity") StepModel entity,HttpServletRequest request) {
		 Result<Integer> result=new  Result<Integer>(0,0);
		 
		 StepDepartment stepDepartment=new StepDepartment();
		 stepDepartment.setStep_id(entity.getStep_id());
		 stepDepartment.setAction_id(entity.getAction_id());
		 stepDepartment.setDepartment_id(entity.getDepartment_name());
		 stepDepartment.setFlow_id( entity.getFlow_id());
		 stepDepartment.setExt_logic(entity.getExt_logic());
		
		 stepDepartmentService.saveEntity(stepDepartment);
		 return result;
	}
	
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> delete(String entity_id,String step_id,HttpServletRequest request) {
		Result<Integer> result=new  Result<Integer>(0,0);
		try {
			StepDepartment stepDepartment=new StepDepartment();
			stepDepartment.setEntity_id(entity_id);
			stepDepartmentService.removeEntity(stepDepartment);
			result.setState(1);
			result.setData(1);
		} catch (Exception e) {
			logger.error("删除处理人异常");;
		}
		return result;
	}
	
	@ResponseBody
	@RequestMapping("update")
	public Result<Integer> update(@ModelAttribute("entity") StepModel entity,HttpServletRequest request) {
		Result<Integer> result=new  Result<Integer>(0,0);
		return result;
	}
}
