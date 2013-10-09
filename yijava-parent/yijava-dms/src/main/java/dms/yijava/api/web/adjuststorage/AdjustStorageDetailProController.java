package dms.yijava.api.web.adjuststorage;

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

import dms.yijava.entity.adjuststorage.AdjustStorageProDetail;
import dms.yijava.service.adjuststorage.AdjustStorageProDetailService;

@Controller
@RequestMapping("/api/adjuststoragedetailpro")
public class AdjustStorageDetailProController {
	
	@Autowired
	private AdjustStorageProDetailService adjustStorageProDetailService;
	
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<AdjustStorageProDetail> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return adjustStorageProDetailService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") AdjustStorageProDetail entity) {
		try {
			adjustStorageProDetailService.saveEntity(entity);
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
			@RequestParam(value = "adjust_storage_detail_id", required = true) String adjust_storage_detail_id,
			@RequestParam(value = "adjust_storage_code", required = true) String adjust_storage_code) {
		try {
			adjustStorageProDetailService.removeByIdEntity(id,adjust_storage_detail_id,adjust_storage_code);
			return new Result<String>(id, 1);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(id, 0);
	}
	
}
