package dms.yijava.api.web.deliver;

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

import dms.yijava.entity.deliver.DeliverExpressSn;
import dms.yijava.service.deliver.DeliverExpressSnService;

@Controller
@RequestMapping("/api/deliverExpressSn")
public class DeliverExpressSnController {
	
	@Autowired
	private DeliverExpressSnService deliverExpressSnService;
	
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<DeliverExpressSn> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return deliverExpressSnService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") DeliverExpressSn entity) {
		try {
			deliverExpressSnService.saveEntity(entity);
			return new Result<String>(entity.getId(), 1);
		} catch (org.springframework.dao.DuplicateKeyException e) {
			e.printStackTrace();
			return new Result<String>(entity.getId(), 2);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getId(),0);
	}
	
	
	@ResponseBody
	@RequestMapping("update")
	public Result<String> update(@ModelAttribute("entity") DeliverExpressSn entity) {
		try {
			deliverExpressSnService.updateEntity(entity);
			return new Result<String>(entity.getId(), 1);
		}  catch (org.springframework.dao.DuplicateKeyException e) {
			e.printStackTrace();
			return new Result<String>(entity.getId(), 2);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getId(),0);
	}
	
	
	@ResponseBody
	@RequestMapping("delete")
	public Result<String> delete(@RequestParam(value = "id", required = true) String id) {
		try {
			deliverExpressSnService.deleteEntity(id);
			return new Result<String>(id, 1);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(id, 0);
	}
	
}
