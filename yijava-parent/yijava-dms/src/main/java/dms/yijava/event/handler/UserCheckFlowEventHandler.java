package dms.yijava.event.handler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;

import com.google.common.eventbus.Subscribe;

import dms.yijava.event.EventDriven;
import dms.yijava.event.UserCheckFlowEvent;

@EventDriven
public class UserCheckFlowEventHandler {

	private static final Logger logger = LoggerFactory
			.getLogger(UserCheckFlowEventHandler.class);

	@Value("#{properties['trialflow_identifier_num']}")   	
	private String flowIdentifierNumber;
	@Value("#{properties['cancelflow_identifier_num']}")   	
	private String cancelflow_identifier_num;
	
	@Subscribe
	public void onUserRegistered(UserCheckFlowEvent flow_check) {
		logger.debug("get user check flow"+flow_check.toString());
		if(flow_check.getFlow_id().equals(flowIdentifierNumber))
		{
			//试用
		}else if(flow_check.getFlow_id().equals(cancelflow_identifier_num))
		{
			//退换货
		}
		
	}
}
