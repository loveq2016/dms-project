package dms.yijava.api.web.user;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

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
		
		for (PropertyFilter propertyFilter : filters) {
			//if(propertyFilter.get)
		}
		//filters.add(PropertyFilters.build("ANDS_user_id", "11"));
		
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
	public List<UserDealer> list(@RequestParam(value = "u_id", required = true) String u_id,
			@RequestParam(value = "t_id", required = true) String t_id) {
		List<UserDealer> list=userDealerFunService.getUserDealerList(u_id,t_id.split(","));
		removeDuplicate(list);
		return list;
	}

	@ResponseBody
	@RequestMapping("delete")
	public Result<String> delete(
			@RequestParam(value = "id", required = true) String id) {
		userDealerFunService.deleteEntity(id);
		return new Result<String>(id, 1);
	}
	
	public static void removeDuplicate(List list) {
		   for ( int i = 0 ; i < list.size() - 1 ; i ++ ) {
		     for ( int j = list.size() - 1 ; j > i; j -- ) {
		    	 UserDealer u=(UserDealer)list.get(i);
		    	 UserDealer u2=(UserDealer)list.get(j);
		       if (u.getDealer_id().equals(u2.getDealer_id())) {
		         list.remove(j);
		       }
		      }
		    }
		}

}
