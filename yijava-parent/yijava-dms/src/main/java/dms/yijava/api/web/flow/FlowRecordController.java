package dms.yijava.api.web.flow;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.web.vo.Result;

import dms.yijava.entity.flow.FlowRecord;
import dms.yijava.service.flow.FlowRecordService;

@Controller
@RequestMapping("/api/flowrecord")
public class FlowRecordController {

	private static final Logger logger = LoggerFactory
			.getLogger(FlowRecordController.class);

	@Autowired
	private FlowRecordService flowRecordService;

	@ResponseBody
	@RequestMapping("list")
	public List<FlowRecord> getList(
			@RequestParam(value = "bussiness_id", required = false) String bussiness_id,
			@RequestParam(value = "flow_id", required = false) String flow_id,
			@RequestParam(value = "check_id", required = false) String check_id,
			@RequestParam(value = "status", required = false) String status) {
		
		status="0";	
		return flowRecordService.getRequetCheck(bussiness_id,flow_id,check_id,status);
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
