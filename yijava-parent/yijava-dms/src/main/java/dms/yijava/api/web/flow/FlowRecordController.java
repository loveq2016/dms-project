package dms.yijava.api.web.flow;

import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.eventbus.EventBus;
import com.yijava.common.utils.DateUtils;
import com.yijava.web.vo.ErrorCode;
import com.yijava.web.vo.Result;

import dms.yijava.api.web.model.flow.ProcFlowModel;
import dms.yijava.entity.flow.FlowLog;
import dms.yijava.entity.flow.FlowRecord;
import dms.yijava.entity.flow.Step;
import dms.yijava.entity.flow.StepDepartment;
import dms.yijava.entity.system.SysUser;
import dms.yijava.event.UserBackFlowEvent;
import dms.yijava.event.UserCheckFlowEvent;
import dms.yijava.service.flow.FlowBussService;
import dms.yijava.service.flow.FlowLogService;
import dms.yijava.service.flow.FlowRecordService;
import dms.yijava.web.model.UserToCheck;
import dms.yijava.web.model.UserToCheckJson;

@Controller
@RequestMapping("/api/flowrecord")
public class FlowRecordController {

	private static final Logger logger = LoggerFactory
			.getLogger(FlowRecordController.class);

	@Autowired
	private FlowRecordService flowRecordService;

	@Autowired
	private FlowBussService flowBussService;
	
	@Autowired
	private FlowLogService flowLogService;
	
	
	private EventBus eventBus;

	@Autowired(required = false)
    public void setEventBus(EventBus eventBus) {
        this.eventBus = eventBus;
    }
	private String flow_id;
	@Value("#{properties['trialflow_identifier_num']}")   	
	private String trialflow_identifier_num;
	
	@Value("#{properties['orderflow_identifier_num']}")   	
	private String orderflow_identifier_num;
	
	@Value("#{properties['pullStorageflow_identifier_num']}")   	
	private String pullStorageflow_identifier_num;
	
	@Value("#{properties['salesStorageflow_identifier_num']}")   	
	private String salesStorageflow_identifier_num;
	
	@Value("#{properties['deliverflow_identifier_num']}")   	
	private String deliverflow_identifier_num;
	
	@Value("#{properties['adjustStorageflow_identifier_num']}")   	
	private String adjustStorageflow_identifier_num;
	
	@Value("#{properties['exchangedflow_identifier_num']}")   	
	private String exchangedflow_identifier_num;
	
	//发货提醒
	@Value("#{properties['sendproduct_identifier_num']}")   	
	private String sendproduct_identifier_num;
	
	//收货提醒
	@Value("#{properties['reciveproduct_identifier_num']}")   	
	private String reciveproduct_identifier_num;
	
	//借贷提醒
	@Value("#{properties['loansproduct_identifier_num']}")   	
	private String loansproduct_identifier_num;
	
	//分销提醒
	@Value("#{properties['salesproduct_identifier_num']}")   	
	private String salesproduct_identifier_num;
	
	/**
	 * 查询流程处理记录
	 * @param bussiness_id
	 * @param flow_id
	 * @param check_id
	 * @param status
	 * @return
	 */
	@ResponseBody
	@RequestMapping("list")
	public List<FlowRecord> getList(
			@RequestParam(value = "bussiness_id", required = false) String bussiness_id,
			@RequestParam(value = "flow_id", required = false) String flow_id,
			@RequestParam(value = "check_id", required = false) String check_id,
			@RequestParam(value = "status", required = false) String status) {
		
		//status="0";	
		return flowRecordService.getRequetCheck(bussiness_id,flow_id,check_id,status);
	}

	/**
	 * 根据用户指定用户触发审批流程
	 * @param entity
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping("do_allocate_flow")
	public Result<Integer> doAllocateFlow(@ModelAttribute("entity") ProcFlowModel entity,HttpServletRequest request){
		Result<Integer> result=new Result<Integer>(0, 0);
		if ((entity!=null && entity.getBase_check_id()!=null && !"".equals(entity.getBase_check_id())) || entity.getStatus().equals("3")|| entity.getStatus().equals("2"))
		{
			flow_id=entity.getFlow_id();
			SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
			String currentUserId=sysUser.getId();
			//先查找待审核记录
			List<FlowRecord> flowRecords=flowRecordService.getRequetCheck(entity.getBussiness_id(), entity.getFlow_id(),currentUserId, "0");
			FlowRecord flowRecord=null;
			if(flowRecords!=null && flowRecords.size()>0)
			{
				flowRecord=flowRecords.get(0);			
				if(flowRecord!=null)
				{
					if(entity.getStatus().equals("1"))//同意
					{	
						//先更新本条记录的状态
						try {
							entity.setUser_id(currentUserId);
							entity.setStatus("1");
							flowRecordService.updateFlowByFlowUB(entity);
							//写入处理日志
							FlowLog flowLog=new FlowLog();
							flowLog.setFlow_id(flow_id);
							flowLog.setUser_id(currentUserId);
							flowLog.setUser_name(sysUser.getRealname());
							flowLog.setBussiness_id(entity.getBussiness_id());
							flowLog.setCreate_date(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
							flowLog.setAction_name("进行审核;提交给 "+entity.getCheck_name() + " 审核");
							flowLog.setCheck_reason(entity.getCheck_reason());
							flowLog.setSign(sysUser.getSign_img());
							flowLogService.saveEntity(flowLog);
							//写入待处理事项
							
							int step_order_no = Integer.parseInt(flowRecord.getStep_order_no());
							step_order_no++;
							flowBussService.insertStep(flow_id, currentUserId,  
									"提交审核", entity.getBussiness_id(), entity.getBase_check_id(), "提交审核","0",Integer.toString(step_order_no));
						} catch (Exception e) {
							result.setError(new ErrorCode(e.toString()));
							return result;
						}
						result.setData(1);
						result.setState(1);						
						return result;
					} else if (entity.getStatus().equals("2")){//驳回
						//处理驳回流程
						try {
							backAllocateFlow(flowRecord,entity,sysUser);
						} catch (Exception e) {
							result.setError(new ErrorCode(e.toString()));
							return result;
						}
						result.setData(1);
						result.setState(1);						
						return result;
					}else if (entity.getStatus().equals("3")){//结束
						//处理结束
						try {
							entity.setStatus("1");
							FlowLog flowLog=new FlowLog();
							flowLog.setFlow_id(flow_id);
							flowLog.setUser_id(currentUserId);
							flowLog.setUser_name(sysUser.getRealname());
							flowLog.setBussiness_id(entity.getBussiness_id());
							flowLog.setCreate_date(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
							flowLog.setAction_name("进行审核;流程结束");
							flowLog.setCheck_reason(entity.getCheck_reason());
							flowLog.setSign(sysUser.getSign_img());
							flowLogService.saveEntity(flowLog);
							
							entity.setUser_id(currentUserId);
							flowRecordService.updateFlowByFlowUB(entity);
							
							eventBus.post(new UserCheckFlowEvent(sysUser.getId(),sysUser.getRealname(),flow_id,entity.getBussiness_id(),
									entity.getCheck_reason(),entity.getStatus()));
						} catch (Exception e) {
							result.setError(new ErrorCode(e.toString()));
							return result;
						}
						result.setData(1);
						result.setState(1);						
						return result;
					}
				}
			}else
			{
				result.setError(new ErrorCode("您已经审核过该单据，或没有为您找到待审核的记录"));
				return result;
			}
		}else
		{
			//数据错误
			result.setError(new ErrorCode("数据错误，请选择提交人员"));					
			return result;
		}
		result.setError(new ErrorCode("数据错误"));	
		return result;
				
	}
	
	
	public boolean backAllocateFlow(FlowRecord flowRecord,ProcFlowModel entity,SysUser sysUser) throws Exception
	{
		
		
		
		try {
			int currentStepNo = Integer.parseInt(flowRecord.getStep_order_no());
			/*if(currentStepNo>1)
			{
				//删除本次的待处理事项
				flowRecordService.removeEntity(new Integer(flowRecord.getRecord_id()));
				//找到上一步骤，变更状态
				List<FlowRecord> flowRecordsBack=flowRecordService.getRequetCheck(entity.getBussiness_id(), 
						entity.getFlow_id(), flowRecord.getSend_id(), "1");
				FlowRecord flowRecordBack=flowRecordsBack.get(0);			
				flowRecordBack.setStatus("0");
				flowRecordService.updateEntity(flowRecordBack);
				//记录驳回日志
				FlowLog flowLog=new FlowLog();
				flowLog.setFlow_id(flow_id);
				flowLog.setUser_id(sysUser.getId());
				flowLog.setUser_name(sysUser.getRealname());
				flowLog.setBussiness_id(entity.getBussiness_id());
				flowLog.setCreate_date(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
				flowLog.setAction_name("进行审核;" + "驳回");
				flowLog.setCheck_reason(entity.getCheck_reason());
				flowLog.setSign(sysUser.getSign_img());
				flowLogService.saveEntity(flowLog);
			}else{
				//删除本次的待处理事项
				flowRecordService.removeEntity(new Integer(flowRecord.getRecord_id()));
				//记录驳回日志
				FlowLog flowLog=new FlowLog();
				flowLog.setFlow_id(flow_id);
				flowLog.setUser_id(sysUser.getId());
				flowLog.setUser_name(sysUser.getRealname());
				flowLog.setBussiness_id(entity.getBussiness_id());
				flowLog.setCreate_date(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
				flowLog.setAction_name("进行审核;" + "驳回");
				flowLog.setCheck_reason(entity.getCheck_reason());
				flowLog.setSign(sysUser.getSign_img());
				flowLogService.saveEntity(flowLog);
				eventBus.post(new UserBackFlowEvent(sysUser.getId(),sysUser.getRealname(),flow_id,entity.getBussiness_id(),
						entity.getCheck_reason(),entity.getStatus()));
			}*/
			
			//删除本次的待处理事项
			
			FlowRecord removeEntity=new FlowRecord();
			removeEntity.setBussiness_id(entity.getBussiness_id());
			removeEntity.setFlow_id(entity.getFlow_id());
			flowRecordService.removeByFlowAndBid(removeEntity);
			//flowRecordService.removeEntity(new Integer(flowRecord.getRecord_id()));
			//记录驳回日志
			FlowLog flowLog=new FlowLog();
			flowLog.setFlow_id(flow_id);
			flowLog.setUser_id(sysUser.getId());
			flowLog.setUser_name(sysUser.getRealname());
			flowLog.setBussiness_id(entity.getBussiness_id());
			flowLog.setCreate_date(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			flowLog.setAction_name("进行审核;" + "驳回");
			flowLog.setCheck_reason(entity.getCheck_reason());
			flowLog.setSign(sysUser.getSign_img());
			flowLogService.saveEntity(flowLog);
			eventBus.post(new UserBackFlowEvent(sysUser.getId(),sysUser.getRealname(),flow_id,entity.getBussiness_id(),
					entity.getCheck_reason(),entity.getStatus()));
			
		} catch (Exception e) {
			throw e;
		}	
		return true;
	}
	/**
	 * 同意流程节点
	 * @return
	 */
	@ResponseBody
	@RequestMapping("do_flow")
	public Result<Integer> doFlow(@ModelAttribute("entity") ProcFlowModel entity,HttpServletRequest request){
		Result<Integer> result=new Result<Integer>(0, 0);
		
		if (entity!=null)
		{
			flow_id=entity.getFlow_id();
			SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
			String currentUserId=sysUser.getId();
			if(entity.getStatus().equals("2"))
			{
				
				backFlow(entity,sysUser);
				
				//驳回
				//记录日志
				/*FlowLog flowLog=new FlowLog();
				flowLog.setFlow_id(flow_id);
				flowLog.setUser_id(currentUserId);
				flowLog.setUser_name(sysUser.getRealname());
				flowLog.setBussiness_id(entity.getBussiness_id());
				flowLog.setCreate_date(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
				flowLog.setAction_name(step.getAction_name());
				flowLog.setSign("1");
				flowLogService.saveEntity(flowLog);*/
				//更新状态
				result.setData(1);
				result.setState(1);
				return result;
			}
			
			//先找到待处理的步骤
			List<FlowRecord> flowRecords=flowRecordService.getRequetCheck(entity.getBussiness_id(), entity.getFlow_id(),currentUserId, "0");
			FlowRecord flowRecord=null;
			if(flowRecords!=null && flowRecords.size()>0)
			{
				flowRecord=flowRecords.get(0);			
				if(flowRecord!=null)
				{
					//先检查当前用户是否有权限审核，如无，直接 返回error
					
					if(!flowRecord.getCheck_id().equals(currentUserId))
					{
						result.setError(new ErrorCode("您无权审核该单据！"));
						return result;
					}
					//查找该业务的流程配置步骤
					
					
					Step step=null;
					int currentStepNo= Integer.parseInt(flowRecord.getStep_order_no());
					
					Step curentStep = flowBussService.getStep(new Integer(flow_id),currentStepNo);
					
					
					try {											
						step = flowBussService.getNextStep(new Integer(flow_id),currentStepNo);
					} catch (Exception e) {
						logger.error("getNextStep error: "+e);
						return result;
					}
					
					
					
					if(step==null)
					{
						//没有步骤 //流程结束
						FlowLog flowLog=new FlowLog();
						flowLog.setFlow_id(flow_id);
						flowLog.setUser_id(currentUserId);
						flowLog.setUser_name(sysUser.getRealname());
						flowLog.setBussiness_id(entity.getBussiness_id());
						flowLog.setCreate_date(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
						flowLog.setAction_name(curentStep.getAction_name());
						flowLog.setCheck_reason(entity.getCheck_reason());
						flowLog.setSign(sysUser.getSign_img());
						flowLogService.saveEntity(flowLog);
						
						entity.setUser_id(currentUserId);
						flowRecordService.updateFlowByFlowUB(entity);
						
						eventBus.post(new UserCheckFlowEvent(sysUser.getId(),sysUser.getRealname(),flow_id,entity.getBussiness_id(),
								entity.getCheck_reason(),entity.getStatus()));
						
					}else
					{
						//继续走步骤
						//记录本次操作
						
						
						FlowLog flowLog=new FlowLog();
						flowLog.setFlow_id(flow_id);
						flowLog.setUser_id(currentUserId);
						flowLog.setUser_name(sysUser.getRealname());
						flowLog.setBussiness_id(entity.getBussiness_id());
						flowLog.setCreate_date(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
						flowLog.setAction_name(curentStep.getAction_name());
						flowLog.setCheck_reason(entity.getCheck_reason());
						flowLog.setSign(sysUser.getSign_img());
						flowLogService.saveEntity(flowLog);
						//先更新本条记录的状态
						entity.setUser_id(currentUserId);
						entity.setStatus("1");
						flowRecordService.updateFlowByFlowUB(entity);
						
						//需要根据当前用户从部门里找到待处理人
						//插入下一个待处理事项
						//currentStepNo++;
						
						//step = flowBussService.getNextStep(new Integer(flow_id),currentStepNo);
						String check_id =null;
						StepDepartment stepDepartment=step.getStepDepartments().get(0);	
						//找到这个部门下的所有人，但还得确定谁是他们具体的上级
						//stepDepartment.getUsers();
						//这里找到了这个部门下的几个用户，应该查找哪个是他的上级
						List<SysUser> sysUsers= stepDepartment.getUsers();
						for(SysUser tmpsysUser: sysUsers)
						{
							if(sysUser.getParentIds()!=null && !sysUser.getParentIds().equals(""))
							{
								if(sysUser.getParentIds().indexOf(tmpsysUser.getId())>-1)
								{
									check_id=tmpsysUser.getId();
									break;
								}
							}
							
						}
						
						if(check_id==null)
						{
							return result;
						}
						//check_id=stepDepartment.getUsers().get(0).getId();
						
						flowBussService.insertStep(flow_id, currentUserId,  
								step.getAction_name(), entity.getBussiness_id(), check_id, step.getAction_name(),"0",step.getStep_order_no().toString());
						
					}
				}
			}else
			{
				result.setError(new ErrorCode("您已经审核过该单据，或没有为您找到待审核的记录"));
				return result;
			}
		}
		
		result.setData(1);
		result.setState(1);
		
		return result;
	}
	
	
	/**
	 * 驳回流程
	 * @param entity
	 * @return
	 */
	public boolean backFlow(ProcFlowModel entity,SysUser sysUser)
	{
		List<FlowRecord> flowRecords=flowRecordService.getRequetCheck(entity.getBussiness_id(), entity.getFlow_id(), sysUser.getId(), "0");
		FlowRecord flowRecord=null;
		if(flowRecords!=null && flowRecords.size()>0)
		{
			flowRecord=flowRecords.get(0);			
			if(flowRecord!=null)
			{
				//20140217zhjt修改,直接驳回到未提交状态开始
				int currentStepNo= Integer.parseInt(flowRecord.getStep_order_no());
				Step curentStep = flowBussService.getStep(new Integer(flow_id),currentStepNo);
				String currentUserId=sysUser.getId();
				FlowRecord removeEntity=new FlowRecord();
				removeEntity.setBussiness_id(entity.getBussiness_id());
				removeEntity.setFlow_id(entity.getFlow_id());
				flowRecordService.removeByFlowAndBid(removeEntity);
				//记录驳回日志
				FlowLog flowLog=new FlowLog();
				flowLog.setFlow_id(flow_id);
				flowLog.setUser_id(currentUserId);
				flowLog.setUser_name(sysUser.getRealname());
				flowLog.setBussiness_id(entity.getBussiness_id());
				flowLog.setCreate_date(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
				flowLog.setAction_name(curentStep.getAction_name() + "驳回");
				flowLog.setCheck_reason(entity.getCheck_reason());
				flowLog.setSign(sysUser.getSign_img());
				flowLogService.saveEntity(flowLog);
				eventBus.post(new UserBackFlowEvent(sysUser.getId(),sysUser.getRealname(),flow_id,entity.getBussiness_id(),
						entity.getCheck_reason(),entity.getStatus()));
				
				//20140217zhjt修改,直接驳回到未提交状态结束
				
				/*int currentStepNo= Integer.parseInt(flowRecord.getStep_order_no());
				//得到步骤名称，记录日志
				Step curentStep = flowBussService.getStep(new Integer(flow_id),currentStepNo);
				String currentUserId=sysUser.getId();
				if(currentStepNo>1)
				{
					//删除本次的待处理事项
					flowRecordService.removeEntity(new Integer(flowRecord.getRecord_id()));
					//找到上一步骤，变更状态
					List<FlowRecord> flowRecordsBack=flowRecordService.getRequetCheck(entity.getBussiness_id(), 
							entity.getFlow_id(), flowRecord.getSend_id(), "1");
					FlowRecord flowRecordBack=flowRecordsBack.get(0);			
					flowRecordBack.setStatus("0");
					flowRecordService.updateEntity(flowRecordBack);
					//记录驳回日志
					FlowLog flowLog=new FlowLog();
					flowLog.setFlow_id(flow_id);
					flowLog.setUser_id(currentUserId);
					flowLog.setUser_name(sysUser.getRealname());
					flowLog.setBussiness_id(entity.getBussiness_id());
					flowLog.setCreate_date(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
					flowLog.setAction_name(curentStep.getAction_name() + "驳回");
					flowLog.setCheck_reason(entity.getCheck_reason());
					flowLog.setSign(sysUser.getSign_img());
					flowLogService.saveEntity(flowLog);
				}else{
					//删除本次的待处理事项
					flowRecordService.removeEntity(new Integer(flowRecord.getRecord_id()));
					//记录驳回日志
					FlowLog flowLog=new FlowLog();
					flowLog.setFlow_id(flow_id);
					flowLog.setUser_id(currentUserId);
					flowLog.setUser_name(sysUser.getRealname());
					flowLog.setBussiness_id(entity.getBussiness_id());
					flowLog.setCreate_date(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
					flowLog.setAction_name(curentStep.getAction_name() + "驳回");
					flowLog.setCheck_reason(entity.getCheck_reason());
					flowLog.setSign(sysUser.getSign_img());
					flowLogService.saveEntity(flowLog);
					eventBus.post(new UserBackFlowEvent(sysUser.getId(),sysUser.getRealname(),flow_id,entity.getBussiness_id(),
							entity.getCheck_reason(),entity.getStatus()));
				}	*/			
			}
		}
		return true;
	}
	
	
	/**
	 * 同意流程节点
	 * @return
	 */
	@ResponseBody
	@RequestMapping("do_flow_agree")
	public Result<Integer> doFlowAgree(@ModelAttribute("entity") ProcFlowModel entity){
		Result<Integer> result=new Result<Integer>(0, 0);
		//先更新本条记录的状态
		flowRecordService.updateFlowByFlowUB(entity);
		//查找下一个节点，如没有节点，更行流程处理完成 
		
		//如果有节点，插入流程处理数据 
		
		return result;
	}
	/**
	 * 驳回流程节点
	 * @return
	 */
	@ResponseBody
	@RequestMapping("do_flow_reject")
	public Result<Integer> doFlowReject(){
		Result<Integer> result=new Result<Integer>(0, 0);
		return result;
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<Integer> save(@ModelAttribute("entity") FlowRecord entity) {
		try {
			flowRecordService.saveEntity(entity);
		} catch (Exception e) {
			logger.error("error" + e);
		}
		return new Result<Integer>(1, 1);
	}

	@ResponseBody
	@RequestMapping("savetest")
	public Result<Integer> saveByFlow(
			@RequestParam(value = "flow_id", required = false) String flow_id) {
		try {
			flowRecordService.saveFlowByFlowAndStep(flow_id, "0");
		} catch (Exception e) {
			logger.error("error" + e);
		}
		return new Result<Integer>(1, 1);
	}

	@ResponseBody
	@RequestMapping("updatetest")
	public Result<Integer> updateByFlow(
			@RequestParam(value = "record_id", required = false) String record_id,
			@RequestParam(value = "bussiness_id", required = false) String bussiness_id) {
		try {
			flowRecordService.updateFlowByFlowAndStep(record_id, bussiness_id);
		} catch (Exception e) {
			logger.error("error" + e);
		}
		return new Result<Integer>(1, 1);
	}

	@ResponseBody
	@RequestMapping("update")
	public Result<Integer> update(@ModelAttribute("entity") FlowRecord entity) {
		try {
			flowRecordService.updateEntity(entity);
		} catch (Exception e) {
			logger.error("error" + e);
		}
		return new Result<Integer>(1, 1);
	}

	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(@ModelAttribute("entity") FlowRecord entity) {
		try {
			flowRecordService.removeEntity(entity);
		} catch (Exception e) {
			logger.error("error" + e);
		}
		return new Result<Integer>(1, 1);
	}
	
	
	/*<!--以下开始处理待处理事项-->*/
	/**
	 * 直接返回jsontree
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping("tocheck")
	public List<UserToCheckJson> getToCheckList(HttpServletRequest request) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		List<UserToCheck> userToChecks=null;
		try {
			String currentUserId=sysUser.getId();
			userToChecks = flowRecordService.getRequetCheckSum(currentUserId);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		List<UserToCheckJson> jsons= new ArrayList<UserToCheckJson>(); 
		
		UserToCheckJson jsonTreeStr= new UserToCheckJson();
		jsonTreeStr.setId("1");
		jsonTreeStr.setText("待处理任务");
		
		List<UserToCheckJson> children=new ArrayList<UserToCheckJson>();
		String flow_id,item_number,desc;
		UserToCheckJson childrenJson;
		for(UserToCheck userToCheck:userToChecks)
		{
			flow_id=userToCheck.getFlow_id();
			item_number=userToCheck.getItem_number();
			desc=getFlowDesc(flow_id,item_number);
			childrenJson=new UserToCheckJson(flow_id,desc);
			children.add(childrenJson);
			jsonTreeStr.setChildren(children);
		}		
		jsons.add(jsonTreeStr);
		//
		return jsons;
	}
	
	private String getFlowDesc(String flow_id,String item_number)
	{
		String flowDescibe="";
		if(flow_id.equals(trialflow_identifier_num))
		{
			flowDescibe="试用审核"+"(<font color='red'>"+item_number+"</font>)";
		}else if(flow_id.equals(orderflow_identifier_num))
		{
			flowDescibe="订单审核"+"(<font color='red'>"+item_number+"</font>)";
		}else if(flow_id.equals(pullStorageflow_identifier_num))
		{
			flowDescibe="借贷出库审核"+"(<font color='red'>"+item_number+"</font>)";
		}else if(flow_id.equals(salesStorageflow_identifier_num))
		{
			flowDescibe="销售出库审核"+"(<font color='red'>"+item_number+"</font>)";
		}else if(flow_id.equals(deliverflow_identifier_num))
		{
			flowDescibe="发货审核"+"(<font color='red'>"+item_number+"</font>)";
		}else if(flow_id.equals(adjustStorageflow_identifier_num))
		{
			flowDescibe="调整审核"+"(<font color='red'>"+item_number+"</font>)";
		}else if(flow_id.equals(exchangedflow_identifier_num))
		{
			flowDescibe="退换审核"+"(<font color='red'>"+item_number+"</font>)";
		}else if(flow_id.equals(sendproduct_identifier_num))
		{
			flowDescibe="待发货"+"(<font color='red'>"+item_number+"</font>)";
		}else if(flow_id.equals(reciveproduct_identifier_num))
		{
			flowDescibe="采购待入库"+"(<font color='red'>"+item_number+"</font>)";
		}else if(flow_id.equals(loansproduct_identifier_num))
		{
			flowDescibe="借贷待入库"+"(<font color='red'>"+item_number+"</font>)";
		}else if(flow_id.equals(salesproduct_identifier_num))
		{
			flowDescibe="分销待入库"+"(<font color='red'>"+item_number+"</font>)";
		}
		return flowDescibe;
	}
	
}
