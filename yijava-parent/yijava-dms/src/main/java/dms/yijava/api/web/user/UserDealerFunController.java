package dms.yijava.api.web.user;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.Result;

import dms.yijava.entity.dealer.Dealer;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.user.UserDealerFunService;

@Controller
@RequestMapping("/api/userDealerFun")
public class UserDealerFunController {

	@Autowired
	private UserDealerFunService userDealerFunService;

	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<UserDealer> paging(PageRequest pageRequest,
			HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return userDealerFunService.paging(pageRequest, filters);
	}

	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") UserDealer entity) {
		int c = 0;
		UserDealer checkDealer = userDealerFunService.checkEntity(entity);
		if (null == checkDealer) {
			userDealerFunService.saveEntity(entity);
			c = 1;
		} else {
			c = 2;
		}
		return new Result<String>(entity.getId(), c);
	}

	@ResponseBody
	@RequestMapping("list")
	public List<UserDealer> list(
			@RequestParam(value = "d_id", required = true) String d_id,
			@RequestParam(value = "u_id", required = true) String u_id) {
		return userDealerFunService.getUserDealerList(d_id,u_id);
	}

	@ResponseBody
	@RequestMapping("delete")
	public Result<String> delete(
			@RequestParam(value = "id", required = true) String id) {
		userDealerFunService.deleteEntity(id);
		return new Result<String>(id, 1);
	}

}
