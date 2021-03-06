package dms.yijava.event.handler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;

import com.google.common.eventbus.Subscribe;

import dms.yijava.event.EventDriven;
import dms.yijava.event.UserBackFlowEvent;
import dms.yijava.service.adjuststorage.AdjustStorageService;
import dms.yijava.service.deliver.DeliverService;
import dms.yijava.service.exchanged.ExchangedService;
import dms.yijava.service.order.OrderService;
import dms.yijava.service.pullstorage.PullStorageService;
import dms.yijava.service.pullstorage.SalesStorageService;
import dms.yijava.service.trial.TrialService;

@EventDriven
public class UserBackFlowEventHandler {

	private static final Logger logger = LoggerFactory
			.getLogger(UserBackFlowEventHandler.class);

	@Autowired
	private TrialService trialService;
	@Autowired
	private OrderService orderService;
	@Autowired
	private DeliverService deliverService;
	@Autowired
	private PullStorageService pullStorageService;
	@Autowired
	private SalesStorageService salesStorageService;
	@Autowired
	private AdjustStorageService adjustStorageService;
	@Autowired
	private ExchangedService exchangedService;
	
	@Value("#{properties['trialflow_identifier_num']}")   	
	private String flowIdentifierNumber;
	@Value("#{properties['deliverflow_identifier_num']}")   	
	private String deliverflow_identifier_num;
	@Value("#{properties['orderflow_identifier_num']}")   	
	private String orderflow_identifier_num;
	@Value("#{properties['pullStorageflow_identifier_num']}")   	
	private String pullStorageflow_identifier_num;
	@Value("#{properties['salesStorageflow_identifier_num']}")   	
	private String salesStorageflow_identifier_num;
	@Value("#{properties['adjustStorageflow_identifier_num']}")   	
	private String adjustStorageflow_identifier_num;
	@Value("#{properties['exchangedflow_identifier_num']}")   	
	private String exchangedflow_identifier_num;
	
	@Subscribe
	public void onUserBackFlow(UserBackFlowEvent flow_check) {
		logger.debug("get user back flow"+flow_check.toString());
		if(flow_check.getFlow_id().equals(flowIdentifierNumber)){
			//试用
			logger.debug("试用流程审核完毕,更新状态,业务号:"+flow_check.getBussiness_id());
			trialService.updateEntityStatus(new Integer(flow_check.getBussiness_id()),2);//驳回状态
		}else if(flow_check.getFlow_id().equals(deliverflow_identifier_num)){
			//发货
			logger.debug("发货流程审核完毕,更新状态,业务号:"+flow_check.getBussiness_id());
			deliverService.updateDeliverStatus(flow_check.getBussiness_id(), "2");//驳回状态
		}else if(flow_check.getFlow_id().equals(orderflow_identifier_num)){
			//订单
			logger.debug("订单流程审核完毕,更新状态,业务号:"+flow_check.getBussiness_id());
			orderService.updateStatus(flow_check.getBussiness_id(),"2");//驳回
		}else if(flow_check.getFlow_id().equals(pullStorageflow_identifier_num)){
			//借贷出货
			logger.debug("借贷出库流程审核完毕,更新状态,业务号:"+flow_check.getBussiness_id());
			pullStorageService.backFlow(flow_check.getBussiness_id());//驳回
		}else if(flow_check.getFlow_id().equals(salesStorageflow_identifier_num)){
			//销售出货
			logger.debug("销售出库流程审核完毕,更新状态,业务号:"+flow_check.getBussiness_id());
			salesStorageService.backFlow(flow_check.getBussiness_id());//驳回
		}else if(flow_check.getFlow_id().equals(adjustStorageflow_identifier_num)){
			//库存调整
			logger.debug("库存调整流程审核完毕,更新状态,业务号:"+flow_check.getBussiness_id());
			adjustStorageService.backFlow(flow_check.getBussiness_id());//驳回
		}else if(flow_check.getFlow_id().equals(exchangedflow_identifier_num)){
			//退换货
			logger.debug("退换货流程审核完毕,更新状态,业务号:"+flow_check.getBussiness_id());
			exchangedService.backFlow(flow_check.getBussiness_id());//驳回
		}
		
	}
}
