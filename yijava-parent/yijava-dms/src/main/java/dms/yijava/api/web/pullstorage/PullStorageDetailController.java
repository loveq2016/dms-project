package dms.yijava.api.web.pullstorage;

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

import dms.yijava.entity.pullstorage.PullStorageDetail;
import dms.yijava.entity.question.Question;
import dms.yijava.entity.system.SysUser;
import dms.yijava.service.pullstorage.PullStorageDetailService;
import dms.yijava.service.pullstorage.PullStorageProDetailService;

@Controller
@RequestMapping("/api/pullstoragedetail")
public class PullStorageDetailController {
	//同一个仓库下的，同一个批次 不能重复添加
	
	@Autowired
	private PullStorageDetailService pullStorageDetailService;
	@Autowired
	private PullStorageProDetailService pullStorageProDetailService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<PullStorageDetail> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return pullStorageDetailService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") PullStorageDetail entity) {
		PullStorageDetail psd= pullStorageDetailService.getPullStorageDetail(entity);
		if(null!=psd){
			pullStorageDetailService.saveEntity(entity);
			
			return new Result<String>(entity.getId(), 1);
		}else{
			return new Result<String>(entity.getId(), 2);
		}
	}
}
