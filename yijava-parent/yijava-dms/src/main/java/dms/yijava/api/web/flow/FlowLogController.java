package dms.yijava.api.web.flow;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import dms.yijava.entity.flow.FlowLog;
import dms.yijava.service.flow.FlowLogService;

@Controller
@RequestMapping("/api/flowlog")
public class FlowLogController {

	private static final Logger logger = LoggerFactory
			.getLogger(FlowLogController.class);

	@Autowired
	private FlowLogService flowLogService;

	@ResponseBody
	@RequestMapping("list")
	public List<FlowLog> getList(
			@RequestParam(value = "bussiness_id", required = false) String bussiness_id,
			@RequestParam(value = "flow_id", required = false) String flow_id) {

		return flowLogService.getLogByFlowAndBusId(flow_id,bussiness_id);
	}
}
