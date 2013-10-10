package dms.yijava.api.web.pullstorage;

import java.util.ArrayList;
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

import dms.yijava.entity.pullstorage.PullStorage;
import dms.yijava.entity.pullstorage.PullStorageDetail;
import dms.yijava.entity.pullstorage.PullStorageProDetail;
import dms.yijava.service.pullstorage.PullStorageDetailService;
import dms.yijava.service.pullstorage.PullStorageProDetailService;
import dms.yijava.service.pullstorage.PullStorageService;
import dms.yijava.service.storage.StorageDetailService;

@Controller
@RequestMapping("/api/pullstorageprodetail")
public class PullStorageProDetailController {
	@Autowired
	private PullStorageService pullStorageService;
	@Autowired
	private PullStorageDetailService pullStorageDetailService;
	@Autowired
	private PullStorageProDetailService pullStorageProDetailService;
	@Autowired
	private StorageDetailService storageDetailService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<PullStorageProDetail> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return pullStorageProDetailService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> savedetail(@ModelAttribute("entity") PullStorageProDetail entity) {
		//同一个单据，同一个仓库下的，同一个批次，同一个序号   不能重复添加
		PullStorageProDetail psd= pullStorageProDetailService.getPullStorageProDetail(entity);
		if(null==psd){
			List<PullStorageProDetail> list = new ArrayList<PullStorageProDetail>();
			list.add(entity);
			pullStorageProDetailService.saveEntity(list);//保存SN
			PullStorageDetail pullStorageDetail=pullStorageDetailService.getStorageProDetailSalesNumber(entity.getFk_pull_storage_detail_id());//查询SN总数
			pullStorageDetailService.updateEntity(pullStorageDetail);//修改产品数量
			PullStorage pullStorage = pullStorageService.getStorageDetailTotalNumber(entity.getPull_storage_code());//查询产品总数
			pullStorageService.updateEntity(pullStorage);//修改出库单据总数量
			return new Result<String>(entity.getId(), 1);
		}else{
			return new Result<String>(entity.getId(), 2);
		}
	}
	
	/**
	 * 删除SN
	 * id
	 * pull_storage_code
	 * batch_no
	 * fk_storage_id
	 * @param entity
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(@ModelAttribute("entity") PullStorageProDetail entity,HttpServletRequest request) {
		pullStorageProDetailService.removeByIdEntity(entity.getId());
		PullStorageDetail pullStorageDetail=pullStorageDetailService.getStorageProDetailSalesNumber(entity.getFk_pull_storage_detail_id());//查询SN总数
		if(null==pullStorageDetail){
			pullStorageDetail=new PullStorageDetail();
			pullStorageDetail.setId(entity.getFk_pull_storage_detail_id());
			pullStorageDetail.setSales_number("0");
		}
		pullStorageDetailService.updateEntity(pullStorageDetail);//修改产品数量
		//修改总数
		PullStorage pullStorage = pullStorageService.getStorageDetailTotalNumber(entity.getPull_storage_code());
		if(null==pullStorage){
			pullStorage=new PullStorage();
			pullStorage.setPull_storage_code(entity.getPull_storage_code());
			pullStorage.setTotal_number("0");
		}
		pullStorageService.updateEntity(pullStorage);//修改单据总数
		return new Result<Integer>(1, 1);
	}
}
