package dms.yijava.api.web.flow;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.common.utils.DateUtils;
import com.yijava.web.vo.ErrorCode;
import com.yijava.web.vo.Result;

import dms.yijava.api.web.model.flow.StepModel;
import dms.yijava.entity.flow.Action;
import dms.yijava.entity.flow.Step;
import dms.yijava.service.flow.ActionService;
import dms.yijava.service.flow.StepService;

@Controller
@RequestMapping("/api/step")
public class StepController {

	private static final Logger logger = LoggerFactory.getLogger(StepController.class);
	@Autowired
	private StepService stepService;
	
	@Autowired
	private ActionService actionService;
	
	
	@ResponseBody
	@RequestMapping("view")
	public List<Step> view(String flow_id,HttpServletRequest request) {
		
		return stepService.getStepByFlow(flow_id);
	} 
	
	@ResponseBody
	@RequestMapping("save")
	public Result<Integer> save(@ModelAttribute("entity") StepModel entity,HttpServletRequest request) {
		
		 Result<Integer> result=new  Result<Integer>(0,0);
		 
		try {
			Action action=new Action();
			action.setAction_name(entity.getAction_name());
			action.setAction_desc(entity.getAction_desc());
			action.setAdd_date(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			actionService.saveEntity(action);
			
			Step step=new Step();
			step.setAction_id(action.getAction_id());
			step.setStep_order_no(new Integer(entity.getStep_order_no()));
			step.setFlow_id(new Integer(entity.getFlow_id()));
			step.setStep_type(new Integer(entity.getStep_type()));
			
			stepService.saveEntity(step);
			
			result.setData(1);
			result.setState(1);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			result.setError(new ErrorCode(e.toString()));
			logger.error("error"+e.toString());
		}
		//return stepService.getStepByFlow(flow_id);
		return result;
	} 
	
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> delete(String action_id,String step_id,HttpServletRequest request) {
		Result<Integer> result=new  Result<Integer>(0,0);
		try {
			
			Action entity=new Action();
			entity.setAction_id(new Integer(action_id));
			actionService.removeEntity(entity);		
			
			Step step=new Step();	
			step.setStep_id(new Integer(step_id) );
			
			stepService.removeEntity(step);
			result.setData(1);
			result.setState(1);
		}catch (Exception e) {
			// TODO Auto-generated catch block
			result.setError(new ErrorCode(e.toString()));
			logger.error("error"+e.toString());
		}
		return result;		
	}
	
	@ResponseBody
	@RequestMapping("update")
	public Result<Integer> update(@ModelAttribute("entity") StepModel entity,HttpServletRequest request) {
		Result<Integer> result=new  Result<Integer>(0,0);
		 
		try {
			Action action=new Action();
			action.setAction_id(new Integer(entity.getAction_id()));
			action.setAction_name(entity.getAction_name());
			action.setAction_desc(entity.getAction_desc());
			action.setMody_date(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			actionService.updateEntity(action);
			
			//Step step=new Step();
			//step.setAction_id(action.getAction_id());
			//step.setStep_order_no(new Integer(entity.getStep_order_no()));
			//step.setFlow_id(new Integer(entity.getFlow_id()));
			//step.setStep_type(new Integer(entity.getStep_type()));
			
			//stepService.saveEntity(step);
			
			result.setData(1);
			result.setState(1);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			result.setError(new ErrorCode(e.toString()));
			logger.error("error"+e.toString());
		}
		
		return result;
	}
}
