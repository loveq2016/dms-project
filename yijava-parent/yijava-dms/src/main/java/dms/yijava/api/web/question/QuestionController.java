package dms.yijava.api.web.question;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.Result;

import dms.yijava.entity.question.Question;
import dms.yijava.entity.system.SysUser;
import dms.yijava.service.question.QuestionService;

@Controller
@RequestMapping("/api/question")
public class QuestionController {
	
	@Autowired
	private QuestionService questionService;

	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<Question> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		//filters.add(PropertyFilters.build("ANDS_dealer_id", "1"));
		return questionService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") Question entity,HttpServletRequest request) {
		try {
			SysUser sysUser=(SysUser)request.getSession().getAttribute("user"); //当前用户信息
			entity.setDealer_id(sysUser.getId());
			questionService.saveEntity(entity);
			return new Result<String>(entity.getId(), 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getId(), 0);
	}
	
	
	@ResponseBody
	@RequestMapping("update")
	public Result<String> update(@ModelAttribute("entity") Question entity,HttpServletRequest request) {
		try {
			SysUser sysUser=(SysUser)request.getSession().getAttribute("user"); //当前用户信息
			entity.setDealer_id(sysUser.getId());
			questionService.updateEntity(entity);
			return new Result<String>(entity.getId(), 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getId(), 0);
	}
	
	@ResponseBody
	@RequestMapping("updateQuestion")
	public Result<String> updateQuestion(@ModelAttribute("entity") Question entity,HttpServletRequest request) {
		try {
			SysUser sysUser=(SysUser)request.getSession().getAttribute("user"); //当前用户信息
			entity.setUser_id(sysUser.getId());
			questionService.updateQuestionEntity(entity);
			return new Result<String>(entity.getId(), 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getId(), 0);
	}
	
	

}
