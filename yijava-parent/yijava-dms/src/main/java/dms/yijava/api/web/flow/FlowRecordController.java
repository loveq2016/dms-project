package dms.yijava.api.web.flow;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.common.utils.DateUtils;
import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.Result;

import dms.yijava.entity.flow.Flow;
import dms.yijava.entity.flow.FlowRecord;
import dms.yijava.entity.system.SysRole;
import dms.yijava.service.flow.FlowRecordService;

@Controller
@RequestMapping("/api/flowrecord")
public class FlowRecordController {

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
		flowRecordService.saveEntity(entity);
		return new Result<Integer>(1, 1);
	}
	
	@ResponseBody
	@RequestMapping("update")
	public Result<Integer> update(@ModelAttribute("entity") FlowRecord entity) {
		flowRecordService.updateEntity(entity);
		return new Result<Integer>(1, 1);
	}
	
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(@ModelAttribute("entity") FlowRecord entity) {
		flowRecordService.removeEntity(entity);
		return new Result<Integer>(1, 1);
	}
}
