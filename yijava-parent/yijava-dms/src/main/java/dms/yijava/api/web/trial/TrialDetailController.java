package dms.yijava.api.web.trial;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.web.vo.Result;

import dms.yijava.entity.trial.TrialDetail;
import dms.yijava.service.trial.TrialDetailService;

@Controller
@RequestMapping("/api/trialdetail")
public class TrialDetailController {

	private static final Logger logger = LoggerFactory
			.getLogger(TrialDetailController.class);

	@Autowired
	private TrialDetailService trialDetailService;

	@ResponseBody
	@RequestMapping("view")
	public List<TrialDetail> view(String trial_id, HttpServletRequest request) {
		List<TrialDetail> trialDetail = trialDetailService
				.getTrialDetailByTrialId(trial_id);
		return trialDetail;
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<Integer> save(@ModelAttribute("entity") TrialDetail entity) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try {
			trialDetailService.saveEntity(entity);
			result.setData(1);
			result.setState(1);;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			logger.error("error" + e);
			//result.setError(error);
		}

		return result;
	}

	@ResponseBody
	@RequestMapping("update")
	public Result<Integer> update(@ModelAttribute("entity") TrialDetail entity) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try {
			trialDetailService.updateEntity(entity);
			result.setData(1);
			result.setState(1);;
		} catch (Exception e) {
			logger.error("error" + e);
		}
		return result;
	}
	
	@ResponseBody
	@RequestMapping("delete")
	public Result<Integer> delete(@ModelAttribute("entity") TrialDetail entity) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try {
			trialDetailService.removeEntity(entity);
			result.setData(1);
			result.setState(1);;
		} catch (Exception e) {
			logger.error("error" + e);
		}
		return result;
	}
}
