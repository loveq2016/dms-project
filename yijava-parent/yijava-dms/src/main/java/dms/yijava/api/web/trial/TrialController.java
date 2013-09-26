package dms.yijava.api.web.trial;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import dms.yijava.entity.flow.StepDepartment;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.trial.Trial;
import dms.yijava.service.flow.FlowBussService;
import dms.yijava.service.trial.TrialService;

@Controller
@RequestMapping("/api/protrial")
public class TrialController {

	private static final Logger logger = LoggerFactory
			.getLogger(TrialController.class);
	
	
	@Value("#{properties['trialflow_identifier_num']}")   	
	private String flowIdentifierNumber;
	
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
	public Result<Integer> save(@ModelAttribute("entity") Trial entity,HttpServletRequest request) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try {
			if(entity.getStatus()==null)
				entity.setStatus(0);
			trialService.saveEntity(entity);
			
			
			
			result.setData(1);
			result.setState(1);;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			logger.error("error" + e);
			//result.setError(error);
		}

		return result;
	}
	
	
	
	/**
	 * 开始流程
	 * @param trial_id
	 * @param currentUserId
	 */
	public void processFlow(Integer trial_id,String currentUserId)
	{
		Step step=flowBussService.getFirstStep(flowIdentifierNumber);
		StepDepartment stepDepartment=step.getStepDepartments().get(0);
		stepDepartment.getUsers().get(0).getId();
		
		

		
		flowBussService.insertStep(flowIdentifierNumber, currentUserId,  
				"提交给区域经理审核", trial_id.toString(), stepDepartment.getUsers().get(0).getId(), "提交给区域经理审核");
	}
	
	
	/**
	 * 修改试用申请
	 * @param entity
	 * @return
	 */
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
	
	/**
	 * 修改状态
	 * @param trial_id
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping("updatetocheck")
	public Result<Integer> updatetocheck(Integer trial_id,HttpServletRequest request) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try {
			
			
			
			trialService.updateEntityStatus(trial_id,1);
			
			
			///以下开始走流程处理
			SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
			processFlow(trial_id,sysUser.getId());	
			
			result.setData(1);
			result.setState(1);;
		} catch (Exception e) {
			logger.error("error" + e);
		}
		return result;
	}
	
	/**
	 * 删除
	 * @param trial_id
	 * @return
	 */
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(Integer trial_id) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try {
			trialService.removeEntity(trial_id);
			result.setData(1);
			result.setState(1);;
		} catch (Exception e) {
			logger.error("error" + e);
		}
		return result;
	}
}
