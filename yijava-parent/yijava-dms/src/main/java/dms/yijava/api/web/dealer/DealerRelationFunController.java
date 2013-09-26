package dms.yijava.api.web.dealer;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
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

import dms.yijava.entity.dealer.DealerRelationFun;
import dms.yijava.service.dealer.DealerRelationFunService;

@Controller
@RequestMapping("/api/dealerRelationFun")
public class DealerRelationFunController {
	

	@Autowired
	private DealerRelationFunService dealerRelationFunService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<DealerRelationFun> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return dealerRelationFunService.paging(pageRequest,filters);
	}
	
	
	@ResponseBody
	@RequestMapping("list")
	public List<DealerRelationFun> list() {
		return dealerRelationFunService.getList();
	}
	
	

	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") DealerRelationFun entity) {
		
		try {
			if(StringUtils.isNotBlank(entity.getId())){
				dealerRelationFunService.updateEntity(entity);
			}else{
				dealerRelationFunService.saveEntity(entity);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new Result<String>(entity.getId(), 0);
		}
		return new Result<String>(entity.getId(), 1);
	}
	
	
	
	
	
	
	
	
}
