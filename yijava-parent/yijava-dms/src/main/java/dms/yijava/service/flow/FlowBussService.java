package dms.yijava.service.flow;

import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.common.utils.DateUtils;

import dms.yijava.api.web.flow.FlowRecordController;
import dms.yijava.entity.flow.FlowRecord;
import dms.yijava.entity.flow.Step;
import dms.yijava.entity.flow.StepDepartment;
import dms.yijava.entity.system.SysUser;
import dms.yijava.service.system.SysUserService;

/**
 * 
 * @author zhjt
 * 流程业务封装类
 */
@Service
@Transactional
public class FlowBussService {

	private static final Logger logger = LoggerFactory
			.getLogger(FlowBussService.class);
	
	
	@Autowired
	private StepService stepService;
	
	@Autowired
	private StepDepartmentService stepDepartmentService;
	
	@Autowired
	private SysUserService sysUserService;
	
	@Autowired
	private FlowRecordService flowRecordService;
	
	/**
	 * 找到流程的第一步
	 * @param flow_id
	 * @return
	 */
	public Step getFirstStep(String flow_id) {
		//找到流程的第一步
		Step step=stepService.getFirstSetp(new Integer(flow_id));
		//找这一步的负责部门
	    List<StepDepartment> stepDepartments=stepDepartmentService.getStepDepartmentByStep(step.getStep_id().toString());
	    step.setStepDepartments(stepDepartments);
	    for(StepDepartment dep :stepDepartments)
	    {
	    	if (null!=dep.getDepartment_id())
	    	{
	    		List<SysUser> users=sysUserService.getListByDepartmentId(dep.getDepartment_id());
	    		if(users!=null)
	    		{
	    			dep.setUsers(users);
	    		}
	    	}
	    }
		return step;		
	}
	
	public Step getStep(Integer flow_id,Integer step_order_no) {
		//找到流程的第一步
		return stepService.getSetp(flow_id,step_order_no);
	}
	/**
	 * 根据流程及步骤序号找到下一步
	 * 
	 * @param flow_id
	 * @param step_order_no 当前步骤号，如果返回为空，表示到达流程结尾
	 * @return
	 */
	public Step getNextStep(Integer flow_id,Integer step_order_no) {		
		Step step=stepService.getNextSetp(flow_id,step_order_no+1);
		if(step!=null)
		{
			//找这一步的负责部门
		    List<StepDepartment> stepDepartments=stepDepartmentService.getStepDepartmentByStep(step.getStep_id().toString());
		    step.setStepDepartments(stepDepartments);
		    for(StepDepartment dep :stepDepartments)
		    {
		    	if (null!=dep.getDepartment_id())
		    	{
		    		List<SysUser> users=sysUserService.getListByDepartmentId(dep.getDepartment_id());
		    		if(users!=null)
		    		{
		    			dep.setUsers(users);
		    		}
		    	}
		    }
		}		
		return step;		
	}
	
	/**
	 * 流程记录第一步
	 * @param flow_id
	 * @param send_Userid
	 * @param descTitle
	 * @param bussiness_id
	 * @param remark
	 * @return
	 */
	public boolean insertStep(String flow_id,String send_Userid,String descTitle,String bussiness_id,String check_id,String remark,String status,String step_order_no)
	{
		boolean save_status=false;
		FlowRecord entity=new FlowRecord();
		entity.setFlow_id(flow_id);
		entity.setBussiness_id(bussiness_id);		
		entity.setTitle(descTitle);
		entity.setSend_id(send_Userid);
		entity.setCheck_id(check_id);
		entity.setSend_time(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		entity.setCreate_time(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		entity.setRemark(remark);
		entity.setStatus(status);
		entity.setStep_order_no(step_order_no);
		try {
			flowRecordService.saveEntity(entity);
		} catch (Exception e) {
			logger.error("bussiness error:"+e.toString());
			save_status=false;
		}
		return save_status;
	}
	
	/**
	 * 处理通过
	 * @param flow_id
	 * @param send_Userid
	 * @param descTitle
	 * @param bussiness_id
	 * @param remark
	 * @return
	 */
	public boolean agreeFlowStep(String flow_id,String send_Userid,String descTitle,String bussiness_id,String remark)
	{
		boolean save_status=false;
		//首先更新本步的状态，
		
		//插入下一步的申请
		
		return save_status;
	}
	
	/**
	 * 退回
	 * @return
	 */
	public boolean rejectFlowStep(String flow_id,String send_Userid,String check_userid,String descTitle,String bussiness_id,String remark)
	{
		boolean save_status=false;
		//首先查找步骤记录
		List<FlowRecord> flowRecord=flowRecordService.getRequetCheck(bussiness_id,flow_id,check_userid,"0");
		
		//更新本步骤的状态
		FlowRecord entity=new FlowRecord();
		entity.setRecord_id(flowRecord.get(0).getRecord_id());
		entity.setStatus("2");
		entity.setCheck_time(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		entity.setCheck_reason(remark);
		
		
		try {
			flowRecordService.updateEntity(entity);
		} catch (Exception e) {
			logger.error("bussiness error:"+e.toString());
			save_status=false;
		}
		return save_status;
	}
	/**
	 * 
	 * @param flow_id
	 * @param send_Userid
	 * @param descTitle
	 * @param bussiness_id
	 * @param remark
	 * @return
	 */
	public boolean insertNextStep(String flow_id,String send_Userid,String descTitle,String bussiness_id,String remark)
	{
		boolean save_status=false;
		FlowRecord entity=new FlowRecord();
		entity.setFlow_id(flow_id);
		entity.setBussiness_id(bussiness_id);		
		entity.setTitle(descTitle);
		entity.setSend_id(send_Userid);
		entity.setSend_time(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		entity.setCreate_time(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		entity.setRemark(remark);
	
		try {
			flowRecordService.saveEntity(entity);
		} catch (Exception e) {
			logger.error("bussiness error:"+e.toString());
			save_status=true;
		}
		return save_status;
	}
	
	/**
	 * 得到待处理事项，待审核
	 * 根据业务号，流程号，处理用户id，状态得到待处理事项
	 * status  步骤处理状态  0--不通过（默认），1--通过，2--退回，3--否决，4--撤回
	 * 此处之针对状态为0
	 * @param bussiness_id
	 * @param flow_id
	 * @param check_id
	 * @param status
	 * @return
	 */
	public List<FlowRecord>  getRequetForCheck(String bussiness_id,String flow_id,String check_id,String status)
	{
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("bussiness_id", bussiness_id);
		parameters.put("flow_id", flow_id);
		parameters.put("check_id", check_id);
		parameters.put("status", status);	
		return flowRecordService.getRequetCheck(parameters);
		//flowRecordDao.find(parameters)
	}
	
	/**
	 * 得到待处理事项，已经退回的
	 * 根据业务号，流程号，发送用户id，状态得到待处理事项
	 * status  步骤处理状态  0--不通过（默认），1--通过，2--退回，3--否决，4--撤回
	 * 此处之针对状态为2
	 * @param bussiness_id
	 * @param flow_id
	 * @param check_id
	 * @param status
	 * @return
	 */
	public List<FlowRecord>  getRequetForBack(String bussiness_id,String flow_id,String send_id,String status)
	{
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("bussiness_id", bussiness_id);
		parameters.put("flow_id", flow_id);
		parameters.put("send_id", send_id);
		parameters.put("status", status);	
		return flowRecordService.getRequetCheck(parameters);
		//flowRecordDao.find(parameters)
	}
	/**
	 * 得到待处理事项，已经退回的
	 * 根据业务号，流程号，发送用户id，状态得到待处理事项
	 * status  步骤处理状态  0--不通过（默认），1--通过，2--退回，3--否决，4--撤回
	 * 此处之针对状态为3
	 * @param bussiness_id
	 * @param flow_id
	 * @param check_id
	 * @param status
	 * @return
	 */
	public List<FlowRecord>  getRequetForReject(String bussiness_id,String flow_id,String send_id,String status)
	{
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("bussiness_id", bussiness_id);
		parameters.put("flow_id", flow_id);
		parameters.put("send_id", send_id);
		parameters.put("status", status);	
		return flowRecordService.getRequetCheck(parameters);
		//flowRecordDao.find(parameters)
	}
	
	public void deleteByRecordId(Integer record_id)
	{
		flowRecordService.removeEntity(record_id);
	}
	
}
