package dms.yijava.event.handler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;

import com.google.common.eventbus.Subscribe;

import dms.yijava.event.EventDriven;
import dms.yijava.event.UserBackFlowEvent;
import dms.yijava.service.trial.TrialService;

@EventDriven
public class UserBackFlowEventHandler {

	private static final Logger logger = LoggerFactory
			.getLogger(UserBackFlowEventHandler.class);

	@Autowired
	private TrialService trialService;
	
	@Value("#{properties['trialflow_identifier_num']}")   	
	private String flowIdentifierNumber;
	@Value("#{properties['cancelflow_identifier_num']}")   	
	private String cancelflow_identifier_num;
	
	@Subscribe
	public void onUserBackFlow(UserBackFlowEvent flow_check) {
		logger.debug("get user back flow"+flow_check.toString());
		if(flow_check.getFlow_id().equals(flowIdentifierNumber))
		{
			//试用
			//试用
			logger.debug("试用流程审核完毕,更新状态,业务号:"+flow_check.getBussiness_id());
			trialService.updateEntityStatus(new Integer(flow_check.getBussiness_id()), 3);//驳回状态
		}else if(flow_check.getFlow_id().equals(cancelflow_identifier_num))
		{
			//退换货
		}
		
	}
}
