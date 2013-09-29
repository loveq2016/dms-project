package dms.yijava.api.web.flow;

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
import com.yijava.web.vo.Result;

import dms.yijava.api.web.model.flow.ProcFlowModel;
import dms.yijava.entity.flow.FlowRecord;
import dms.yijava.entity.system.SysUser;
import dms.yijava.event.UserCheckFlowEvent;
import dms.yijava.service.flow.FlowRecordService;

@Controller
@RequestMapping("/api/flowrecord")
public class FlowRecordController {

	private static final Logger logger = LoggerFactory
			.getLogger(FlowRecordController.class);

	@Autowired
	private FlowRecordService flowRecordService;

	private EventBus eventBus;

	@Autowired(required = false)
    public void setEventBus(EventBus eventBus) {
        this.eventBus = eventBus;
    }
	
	@Value("#{properties['trialflow_identifier_num']}")   	
	private String flowIdentifierNumber;
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
	 * 同意流程节点
	 * @return
	 */
	@ResponseBody
	@RequestMapping("do_flow")
	public Result<Integer> doFlow(@ModelAttribute("entity") ProcFlowModel entity,HttpServletRequest request){
		
		//eventBus.post(new UserCheckFlowEvent("300000"));
		
		Result<Integer> result=new Result<Integer>(0, 0);
		//entity.setFlow_id("300000");
		///以下开始走流程处理
		//先找到待处理的步骤
		List<FlowRecord> flowRecords=flowRecordService.getRequetCheck(entity.getBussiness_id(), entity.getFlow_id(), entity.getUser_id(), "0");
		FlowRecord flowRecord=null;
		if(flowRecords!=null && flowRecords.size()>0)
		{
			flowRecord=flowRecords.get(0);
			
		}
		
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		String currentUserId=sysUser.getId();
		//先更新本条记录的状态
		entity.setUser_id(currentUserId);
		if(entity.getStatus().equals("1"))
		{
			//同意
			entity.setStatus("1");
			flowRecordService.updateFlowByFlowUB(entity);
		}else
		{
			//驳回
		}
		
		//查找下一个节点，如没有节点，更行流程处理完成 
		
		//如果有节点，插入流程处理数据 
		
		return result;
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
}
