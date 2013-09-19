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

	private static final Logger logger = LoggerFactory.getLogger(FlowRecordController.class);
	
	
	@Autowired
	private FlowRecordService flowRecordService;
	
	
	@ResponseBody
	@RequestMapping("list")
	public List<FlowRecord> getList(@RequestParam(value = "id", required = false) String id){
		return flowRecordService.getList(id);
	}
	
	
	@ResponseBody
	@RequestMapping("save")
	public Result<Integer> save(@ModelAttribute("entity") FlowRecord entity) {
		try {
			flowRecordService.saveEntity(entity);
		} catch (Exception e) {
			logger.error("error"+e);
		}
		return new Result<Integer>(1, 1);
	}
	
	@ResponseBody
	@RequestMapping("update")
	public Result<Integer> update(@ModelAttribute("entity") FlowRecord entity) {
		try {
			flowRecordService.updateEntity(entity);
		} catch (Exception e) {
			logger.error("error"+e);
		}
		return new Result<Integer>(1, 1);
	}
	
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(@ModelAttribute("entity") FlowRecord entity) {
		try {
			flowRecordService.removeEntity(entity);
		} catch (Exception e) {
			logger.error("error"+e);
		}
		return new Result<Integer>(1, 1);
	}
}
