package dms.yijava.api.web.trial;

import java.util.Date;
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

import com.yijava.common.utils.DateUtils;
import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.ErrorCode;
import com.yijava.web.vo.Result;

import dms.yijava.entity.department.Department;
import dms.yijava.entity.flow.FlowLog;
import dms.yijava.entity.flow.Step;
import dms.yijava.entity.flow.StepDepartment;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.trial.Trial;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.department.DepartmentService;
import dms.yijava.service.flow.FlowBussService;
import dms.yijava.service.flow.FlowLogService;
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
	
	@Autowired
	private FlowLogService flowLogService;
	
	@Autowired
	private DepartmentService departmentService;
	

	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<Trial> paging(PageRequest pageRequest,
			HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		//找到当前登录用户所拥有的所有销售
		//如果是销售，只查询自己的试用
		//如果是其他用户，根据关系找到所有的销售
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		String currentUserId=sysUser.getId();
		List<Department> deparments=departmentService.getChildDeparmentById(sysUser.getFk_department_id());
		if(deparments==null || deparments.size()<=0)
		{
			//是销售
			filters.add(PropertyFilters.build("ANDS_sales_user_ids", currentUserId));
		}else
		{
			//不是销售，需要找到他对应的所有销售
			filters.add(PropertyFilters.build("ANDS_sales_user_ids", this.listString(sysUser.getUserDealerList())));
			
			filters.add(PropertyFilters.build("ANDS_statuses","1,2,3,4"));
			filters.add(PropertyFilters.build("ANDS_check_id",currentUserId));
			
		}
		
		
		
		return trialService.paging(pageRequest, filters);
	}

	@ResponseBody
	@RequestMapping("save")
	public Result<Integer> save(@ModelAttribute("entity") Trial entity,HttpServletRequest request) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try {
			SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
			String currentUserId=sysUser.getId();
			entity.setSales_user_id(currentUserId);
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

	/*!---------------------以下的方法，提供流程处理第一步骤-----------------------*/
	/**
	 * 修改状态 提交审核
	 * @param trial_id
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping("updatetocheck")
	public Result<Integer> updatetocheck(Integer trial_id,HttpServletRequest request) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try {			
						
			///以下开始走流程处理
			SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
			
			if(processFlow(trial_id,sysUser))
			{
				
				//更新状态
				trialService.updateEntityStatus(trial_id,1);
				result.setData(1);
				result.setState(1);;
			}else
			{
				result.setError(new ErrorCode("出现系统错误，处理流程节点"));
			}
			
		
			
			
			
		} catch (Exception e) {
			logger.error("error" + e);
		}
		return result;
	}
	
	/**
	 * 开始流程
	 * @param trial_id
	 * @param currentUserId
	 */
	public boolean processFlow(Integer trial_id,SysUser currentUser)
	{
		Step step=flowBussService.getFirstStep(flowIdentifierNumber);
		//此处需要根据当前用户从所属的部门里找到用户id
		String check_id =null;
		
		StepDepartment stepDepartment=step.getStepDepartments().get(0);
		//这里找到了这个部门下的几个用户，应该查找哪个是他的上级
		List<SysUser> sysUsers= stepDepartment.getUsers();
		for(SysUser sysUser: sysUsers)
		{
			if(currentUser.getParentIds()!=null && !currentUser.getParentIds().equals(""))
			{
				if(currentUser.getParentIds().indexOf(sysUser.getId())>-1)
				{
					check_id=sysUser.getId();
				}
			}
			
		}
		
		if(check_id==null)
		{
			return false;
		}
		
		//check_id=stepDepartment.getUsers().get(0).getId();
		
		//先记录处理日志
		//写处理日志
		FlowLog flowLog=new FlowLog();
		flowLog.setFlow_id(flowIdentifierNumber);
		flowLog.setUser_id(currentUser.getId());
		flowLog.setUser_name(currentUser.getRealname());
		flowLog.setBussiness_id(trial_id.toString());
		flowLog.setCreate_date(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		flowLog.setAction_name("提交"+"-"+step.getAction_name());
		//flowLog.setSign("0");
		flowLogService.saveEntity(flowLog);
		
		//记录流程
		flowBussService.insertStep(flowIdentifierNumber, currentUser.getId(),  
				"提交", trial_id.toString(), check_id, "提交"+"-"+step.getAction_name(),"0","1");
		return true;
	}
	
	public String listString(List<UserDealer> list) {
		String listString = "";
		for (int i = 0; i < list.size(); i++) {
			try {
				if (i == list.size() - 1) {
					UserDealer ud=list.get(i);
					listString += ud.getUser_id();
				} else {
					UserDealer ud=list.get(i);
					listString += ud.getUser_id() + ",";
				}
			} catch (Exception e) {
			}
		}
		return listString;
	}
	
}
