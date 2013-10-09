package dms.yijava.api.web.user;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;

import dms.yijava.entity.user.UserHospital;
import dms.yijava.service.user.UserHospitalFunService;

@Controller
@RequestMapping("/api/userHospitalFun")
public class UserHospitalFunController {

	@Autowired
	private UserHospitalFunService userHospitalFunService;
	

	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<UserHospital> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return userHospitalFunService.paging(pageRequest,filters);
	}
	
	
	
	
//	@ResponseBody
//	@RequestMapping("save")
//	public Result<String> save(@ModelAttribute("entity") UserDealer entity) {
//		
//		int c = 0;
//		UserDealer checkDealer = userHospitalFunService.checkEntity(entity);
//		if (null == checkDealer) {
//			userHospitalFunService.saveEntity(entity);
//			c = 1;
//		}else{
//			c = 2;
//		}
//		return new Result<String>(entity.getId(), c);
//	}
//	
//
//	
//	@ResponseBody
//	@RequestMapping("delete")
//	public Result<String> delete(@RequestParam(value = "id", required = true) String id) {
//		userHospitalFunService.deleteEntity(id);
//		return new Result<String>(id, 1);
//	}
	
	
	
	
	
}
