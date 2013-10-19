package dms.yijava.api.web.exchanged;

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

import dms.yijava.entity.exchanged.ExchangedProDetail;
import dms.yijava.service.exchanged.ExchangedProDetailService;



@Controller
@RequestMapping("/api/exchangeddetailpro")
public class ExchangedDetailProController {
	
	@Autowired
	private ExchangedProDetailService exchangedProDetailService;
	
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<ExchangedProDetail> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return exchangedProDetailService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") ExchangedProDetail entity) {
		try {
			exchangedProDetailService.saveEntity(entity);
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
	@RequestMapping("delete")
	public Result<String> delete(
			@RequestParam(value = "id", required = true) String id,
			@RequestParam(value = "exchanged_detail_id", required = true) String exchanged_detail_id,
			@RequestParam(value = "exchanged_code", required = true) String exchanged_code) {
		try {
			exchangedProDetailService.removeByIdEntity(id,exchanged_detail_id,exchanged_code);
			return new Result<String>(id, 1);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(id, 0);
	}
	
	
	@ResponseBody
	@RequestMapping("setModelsBySn")
	public Result<String> setModelsBySn(
			@RequestParam(value = "id", required = true) String id,
			@RequestParam(value = "models", required = true) String models) {
		try {
			
			ExchangedProDetail exchangedProDetail = new ExchangedProDetail();
			exchangedProDetail.setId(id);
			exchangedProDetail.setNewModels(models);
			exchangedProDetailService.setModelsBySn(exchangedProDetail);
			return new Result<String>(id, 1);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(id, 0);
	}
	
}
