package dms.yijava.api.web.pullstorage;

import java.util.ArrayList;
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

import dms.yijava.entity.pullstorage.PullStorage;
import dms.yijava.entity.pullstorage.PullStorageDetail;
import dms.yijava.entity.pullstorage.PullStorageProDetail;
import dms.yijava.entity.system.SysRoleFunction;
import dms.yijava.service.pullstorage.PullStorageDetailService;
import dms.yijava.service.pullstorage.PullStorageProDetailService;
import dms.yijava.service.pullstorage.PullStorageService;

@Controller
@RequestMapping("/api/pullstoragedetail")
public class PullStorageDetailController {
	@Autowired
	private PullStorageService pullStorageService;
	@Autowired
	private PullStorageDetailService pullStorageDetailService;
	@Autowired
	private PullStorageProDetailService pullStorageProDetailService;
	
	@ResponseBody
	@RequestMapping("detailpaging")
	public JsonPage<PullStorageDetail> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return pullStorageDetailService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("savedetail")
	public Result<String> savedetail(@ModelAttribute("entity") PullStorageDetail entity) {
		//同一个仓库下的，同一个批次 不能重复添加
		PullStorageDetail psd= pullStorageDetailService.getPullStorageDetail(entity);
		if(null!=psd){
			pullStorageDetailService.saveEntity(entity);//保存产品
			PullStorage pullStorage = pullStorageService.getStorageDetailTotalNumber(entity.getPull_storage_code());
			pullStorageService.updateEntity(pullStorage);//修改出库单据总数量
			return new Result<String>(entity.getId(), 1);
		}else{
			return new Result<String>(entity.getId(), 2);
		}
	}
	
	@ResponseBody
	@RequestMapping("saveprodetail")
	public Result<String> saveprodetail(@ModelAttribute("entity") PullStorageProDetail entity) {
		//同一个仓库下的，同一个批次，同一个序号   不能重复添加
		PullStorageProDetail pspd= pullStorageProDetailService.getPullStorageProDetail(entity);
		if(null!=pspd){
			String[] prosns=null;//获取sn（根据 批次，仓库，数量），更新仓库
			//if 如果返回null 为库存不够 提醒用户
			List<PullStorageProDetail> list=new ArrayList<PullStorageProDetail>();
			if(null!=list){
				for(int i=0;i<prosns.length;i++){
					PullStorageProDetail pspds=new PullStorageProDetail();
					//pspd.setBatch_no(batch_no);
					//pspd.setFk_storage_id(fk_storage_id);
					//pspd.setProduct_sn(product_sn);
					//pspd.setPull_storage_code(pull_storage_code);
					//pspd.setPut_storage_code(put_storage_code);
					list.add(pspds);
				}
				pullStorageProDetailService.saveEntity(list);
			}
			return new Result<String>(entity.getId(), 1);
		}else{
			return new Result<String>(entity.getId(), 2);
		}
	}
	
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(HttpServletRequest request,
			@RequestParam(value = "id", required = false) String pull_storage_code) {
		//根据出货经销ID
		//批次
		//sn 
		
		
		
		//List list =pullStorageProDetailService.getList(filters); //sn list 需要回滚库存
		//获取SN 回滚SN库存
		
		
		//修改总数
		PullStorage pullStorage = pullStorageService.getStorageDetailTotalNumber(pull_storage_code);
		if(null==pullStorage){
			pullStorage=new PullStorage();
			pullStorage.setPull_storage_code(pull_storage_code);
			pullStorage.setTotal_number("0");
		}
		pullStorageService.updateEntity(pullStorage);//修改单据总数
		return new Result<Integer>(1, 1);
	}
}
